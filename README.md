# TerraformLambdaModule

An importable module for defining lambdas in Terraform

Use this by importing it as a module in your TF main file, for example:

```terraform
module "first_lambda" {
  tags        = local.tags
  source      = "github.com/PGEDigitalCatalyst/TerraformLambdaModule"
  lambda_name = "First-Example"
  region      = "us-west-2"
  aws_account = var.aws_account
}
```

# List of Variables

```
region
tags
lambda_name
runtime (default: "nodejs10x")
handler (default: "src/index.handler")
layers (list of ARN strings; default, git layer)
envvars (map of key/value pairs; default, "DEFAULT_ENVARS" = "TRUE")
aws_account
filter_pattern (default: "")
timeout  (default: 60)
tracing_enabled (default: true)
memory (default: 1024)
archive_path (if empty: "${path.root}/../../${var.lambda_name}/" )
maximum_retry_attempts (default:2)
```

# Outputs

```
lambda_arn (aws_lambda_function.lambda_function.arn)
lambda_function_name (aws_lambda_function.lambda_function.function_name)
lambda_invoke_arn (aws_lambda_function.lambda_function.invoke_arn)
```
