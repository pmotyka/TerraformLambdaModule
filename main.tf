
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.archive_path == "" ? "${path.root}/../../${var.lambda_name}/" : var.archive_path
  output_path = "${path.root}/../../${var.lambda_name}.zip"
}

/*
  --- IAM ---
*/

module "iam" {
  tags        = var.tags
  lambda_name = var.lambda_name
  source      = "./modules/iam"
}

/*
  --- Lambda Function(s) ---
*/

resource "aws_s3_bucket" "s3" {
  bucket = "${lower(var.lambda_name)}-${lower(terraform.workspace)}-source"
  tags   = var.tags
  acl    = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_access" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.s3.id
  key    = uuid()
  source = data.archive_file.lambda_zip.output_path
}

resource "aws_lambda_function" "lambda_function" {
  function_name    = "${var.lambda_name}-${terraform.workspace}"
  handler          = var.handler
  runtime          = var.runtime
  memory_size      = var.memory
  role             = module.iam.lambda_role_arn
  s3_bucket        = aws_s3_bucket.s3.id
  s3_key           = aws_s3_bucket_object.object.id
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = var.timeout
  environment { variables = var.envvars }
  publish = true

  layers = var.layers

  tracing_config {
    mode = var.tracing_enabled ? "Active" : "PassThrough"
  }

  tags = merge(var.tags, map("Name", "${var.tags.ProjectName}", "Environment", "${terraform.workspace}", "Role", "Lambda"))
}

// set the number of retries based ont the variable
resource "aws_lambda_function_event_invoke_config" "lambda_config" {
  function_name          = "${var.lambda_name}-${terraform.workspace}"
  maximum_retry_attempts = var.maximum_retry_attempts
  depends_on             = [aws_lambda_function.lambda_function]
}

/*
  --- Warming ---
*/

resource "aws_lambda_provisioned_concurrency_config" "warmer" {
  count                             = 1
  function_name                     = aws_lambda_function.lambda_function.function_name
  provisioned_concurrent_executions = 1
  qualifier                         = aws_lambda_function.lambda_function.version
  depends_on                        = [aws_lambda_function.lambda_function]
}
