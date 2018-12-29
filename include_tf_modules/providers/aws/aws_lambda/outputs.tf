output "lambda-arn" {
  value = "${aws_lambda_function.aws_lambda.arn}"
}

output "lambda-id" {
  value = "${aws_lambda_function.aws_lambda.id}"
}

output "lambda-function-name" {
  value = "${var.lambda_function_name}"
}
