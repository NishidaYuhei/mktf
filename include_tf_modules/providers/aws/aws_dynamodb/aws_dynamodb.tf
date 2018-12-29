/*
  AWS DynamoDB Module
*/

/*
  Calling example
  # table_name: users
  # hash_key: user_id
  # range_key: user_name

  # Descriptions...

  module "users" {
    source         = "./tf_modules/aws_dynamodb"
    table_name     = "users"
    read_capacity  = "2"
    write_capacity = "2"
    hash_key       = "user_id"
    range_key      = "user_name"

    attributes = [
      {
        name = "user_id"
        type = "S"
      },
      {
        name = "user_name"
        type = "S"
      },
    ]
  }
*/

variable "table_name" {
  type = "string"
}

variable "read_capacity" {
  type = "string"
}

variable "write_capacity" {
  type = "string"
}

variable "hash_key" {
  type = "string"
}

variable "range_key" {
  type = "string"

  default = ""
}

variable "attributes" {
  type = "list"
}

variable "ttl_attr_name" {
  type = "string"

  default = ""
}

variable "ttl_enabled" {
  type = "string"

  default = "false"
}

variable "global_secondary_index_list" {
  type = "list"

  default = []
}

variable "billing_mode" {
  type = "string"

  default = "PROVISIONED"
}

locals {
  attributes = ["${var.attributes}"]
}

resource "aws_dynamodb_table" "default" {
  name           = "${var.table_name}"
  billing_mode   = "${var.billing_mode}"
  read_capacity  = "${var.read_capacity}"
  write_capacity = "${var.write_capacity}"
  hash_key       = "${var.hash_key}"
  range_key      = "${var.range_key}"
  attribute      = ["${var.attributes}"]

  ttl = {
    attribute_name = "${var.ttl_attr_name}"
    enabled        = "${var.ttl_enabled}"
  }

  global_secondary_index = ["${var.global_secondary_index_list}"]
}
