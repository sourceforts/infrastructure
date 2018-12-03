#!/bin/bash

set -e

# Send the log output from this script to user-data.log, syslog, and the console
# From: https://alestic.com/2010/12/ec2-user-data-output/
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# ECS config
${ecs_config}
{
  echo "ECS_CLUSTER=${cluster_name}"
  echo 'ECS_AVAILABLE_LOGGING_DRIVERS=${ecs_logging}'
} >> /etc/ecs/ecs.config

# Inject the CloudWatch Logs configuration file contents
cat > /etc/awslogs/awslogs.conf <<- EOF
[general]
state_file = /var/lib/awslogs/agent-state        
 
[/var/log/dmesg]
file = /var/log/dmesg
log_group_name = ${cloudwatch_prefix}/var/log/dmesg
log_stream_name = ${cluster_name}/{container_instance_id}
[/var/log/messages]
file = /var/log/messages
log_group_name = ${cloudwatch_prefix}/var/log/messages
log_stream_name = ${cluster_name}/{container_instance_id}
datetime_format = %b %d %H:%M:%S
[/var/log/docker]
file = /var/log/docker
log_group_name = ${cloudwatch_prefix}/var/log/docker
log_stream_name = ${cluster_name}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%S.%f
[/var/log/ecs/ecs-init.log]
file = /var/log/ecs/ecs-init.log.*
log_group_name = ${cloudwatch_prefix}/var/log/ecs/ecs-init.log
log_stream_name = ${cluster_name}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ
[/var/log/ecs/ecs-agent.log]
file = /var/log/ecs/ecs-agent.log.*
log_group_name = ${cloudwatch_prefix}/var/log/ecs/ecs-agent.log
log_stream_name = ${cluster_name}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ
[/var/log/ecs/audit.log]
file = /var/log/ecs/audit.log.*
log_group_name = ${cloudwatch_prefix}/var/log/ecs/audit.log
log_stream_name = ${cluster_name}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ
EOF

# Set the region to send CloudWatch Logs data to (the region where the container instance is located)
region=$(curl 169.254.169.254/latest/meta-data/placement/availability-zone | sed s'/.$//')
sed -i -e "s/region = us-east-1/region = $region/g" /etc/awslogs/awscli.conf

# Set the ip address of the node 
container_instance_id=$(curl 169.254.169.254/latest/meta-data/local-ipv4)
sed -i -e "s/{container_instance_id}/$container_instance_id/g" /etc/awslogs/awslogs.conf

cat > /etc/init/awslogjob.conf <<- EOF
#upstart-job
description "Configure and start CloudWatch Logs agent on Amazon ECS container instance"
author "Amazon Web Services"
start on started ecs
script
	exec 2>>/var/log/ecs/cloudwatch-logs-start.log
	set -x
	
	until curl -s http://localhost:51678/v1/metadata
	do
		sleep 1	
	done
	
	service awslogs start
	chkconfig awslogs on
end script
EOF

# Associate EIP with this instance
aws ec2 associate-address --region $region \
	--instance-id $(curl http://169.254.169.254/latest/meta-data/instance-id) \
	--allocation-id ${eip_allocation_id} \
	--allow-reassociation

start ecs

# Run the consul client
/opt/consul/bin/run-consul --client --cluster-tag-key "${consul_tag_key}" --cluster-tag-value "${consul_tag_value}"

# Custom userdata script code
${custom_user_data}

echo "Done"
