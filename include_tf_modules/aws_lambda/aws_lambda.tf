/*
  AWS Lambda Module
*/

/*
  Calling example

  # Descriptions...

  module "example-lambda" {
    source                  = "./tf_modules/aws_lambda"
    lambda_function_name    = "example-lambda"
    lambda_role_name        = "example-lambda-role"
    lambda_source_dir_path  = "./lambdas/example-lambda"
    output_zip_path         = "./lambdas/example-lambda/lambda.zip"
    handler                 = "index.handler"
    runtime                 = "go1.x"
    lambda_description      = "example lambda"
    lambda_policies         = [
      {
        name      = "lambda-1"
        actions   = "apigateway:*"
        resources = "*"
      },
      {
        name      = "lambda-2"
        actions   = "s3:*,lambda:*"
        resources = "*"
      },
    ]
    lambda_policy_arns = ["arn:aws:iam::aws:policy/AWSLambdaFullAccess"]
  }
*/

variable "lambda_policies" {
  type    = "list"
  default = []
}

variable "lambda_role_name" {
  type = "string"
}

variable "lambda_source_dir_path" {
  type = "string"
}

variable "output_zip_path" {
  type = "string"
}

variable "handler" {
  type = "string"
}

variable "lambda_source_excludes_list" {
  type    = "list"
  default = []
}

variable "runtime" {
  type = "string"
}

variable "lambda_function_name" {
  type = "string"
}

variable "lambda_policy_arns" {
  type    = "list"
  default = []
}

variable "lambda_description" {
  type = "string"
}

variable "lambda_timeout" {
  type    = "string"
  default = 3
}

data aws_iam_policy_document "lambda_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      identifiers = [
        "lambda.amazonaws.com",
      ]

      type = "Service"
    }
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "${var.lambda_role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_role.json}"
}

data "aws_iam_policy_document" "aws_lambda_policy_document" {
  count = "${length(var.lambda_policies)}"

  statement {
    actions   = "${split(",", lookup(var.lambda_policies[count.index], "actions"))}"
    resources = "${split(",", lookup(var.lambda_policies[count.index], "resources"))}"
  }
}

resource "aws_iam_policy" "aws_lambda_policies" {
  count = "${length(var.lambda_policies)}"

  name   = "${lookup(var.lambda_policies[count.index], "name")}"
  path   = "/"
  policy = "${data.aws_iam_policy_document.aws_lambda_policy_document.*.json[count.index]}"
}

resource "aws_iam_role_policy_attachment" "lambda_policies_attachment" {
  count      = "${length(var.lambda_policies)}"
  role       = "${var.lambda_role_name}"
  policy_arn = "${aws_iam_policy.aws_lambda_policies.*.arn[count.index]}"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_arns_attachment" {
  count      = "${length(var.lambda_policy_arns)}"
  role       = "${var.lambda_role_name}"
  policy_arn = "${var.lambda_policy_arns[count.index]}"
}

data archive_file "lambda_archive" {
  type        = "zip"
  source_dir  = "${var.lambda_source_dir_path}"
  output_path = "${var.output_zip_path}"
  excludes    = "${var.lambda_source_excludes_list}"
}

resource "aws_lambda_function" "aws_lambda" {
  filename         = "${var.output_zip_path}"
  function_name    = "${var.lambda_function_name}"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "${var.handler}"
  source_code_hash = "${base64sha256(file(var.output_zip_path))}"
  runtime          = "${var.runtime}"
  description      = "${var.lambda_description}"
  timeout          = "${var.lambda_timeout}"
}
