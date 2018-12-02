output "lambda_arn" {
    value = "${aws_lambda_function.function.arn}"
}

output "lambda_role_name" {
    value = "${aws_iam_role.function_iam_role.name}"
}
