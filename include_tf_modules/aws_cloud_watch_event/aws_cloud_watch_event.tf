/*
  AWS CloudWatch event Module
*/

variable "rule_name" {
  type = "string"
}

variable "rule_description" {
  type = "string"
}

variable "rule_enabled" {
  type    = "string"
  default = "true"
}

variable "rule_scheduled" {
  type = "string"
}

variable "target_lambda_id" {
  type = "string"
}

variable "target_lambda_arn" {
  type = "string"
}

variable "target_lambda_name" {
  type = "string"
}

resource "aws_cloudwatch_event_rule" "cloudwatch_event_rule_info" {
  name                = "${var.rule_name}"
  description         = "${var.rule_description}"
  is_enabled          = "${var.rule_enabled}"
  schedule_expression = "${var.rule_scheduled}"
}

resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = "${aws_cloudwatch_event_rule.cloudwatch_event_rule_info.name}"
  target_id = "${var.target_lambda_id}"
  arn       = "${var.target_lambda_arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${var.target_lambda_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.cloudwatch_event_rule_info.arn}"
}
