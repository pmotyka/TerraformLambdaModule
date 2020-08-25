variable "region" {
  type        = string
  description = "The region for AWS assets"
}

variable "tags" {
  type        = map
  description = "The list of PG&E tags required for AWS assets"
}

variable "lambda_name" {
  type        = string
  description = "The name of the Lambda"
}

variable "runtime" {
  type        = string
  description = "The runtime the Lambda is executing in"
  default     = "nodejs12.x"
}

variable "handler" {
  type        = string
  description = "Where the handler function lives"
  default     = "src/index.handler"
}

variable "layers" {
  type        = list(string)
  description = "Layer that the lambda contains; default gives git"
  default     = []
}

variable "envvars" {
  type        = map
  description = "Environment variables, like github tokens"
  default     = { "DEFAULT_ENVARS" = "TRUE" }
}

variable "filter_pattern" {
  type        = string
  description = "The filter pattern for logging pattern matching"
  default     = ""
}

variable "timeout" {
  type        = number
  description = "Timeout for the Lambda Function"
  default     = 60
}

variable "memory" {
  type        = number
  description = "Memory for the Lambda Function"
  default     = 1024
}

variable "tracing_enabled" {
  type        = bool
  description = "Enable xray tracing"
  default     = true
}

variable "archive_path" {
  type        = string
  description = "The path to the Lambda for the archive provider"
  default     = ""
}

variable "maximum_retry_attempts" {
  type        = number
  description = "Maximum number of times to retry when the function returns an error. Valid values between 0 and 2. Defaults to 2."
  default     = 1
}
