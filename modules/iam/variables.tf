variable "tags" {
  type        = map
  description = "The list of PG&E tags required for AWS assets"
}

variable "lambda_name" {
  type        = string
  description = "The name of the Lambda"
}
