data "aws_caller_identity" "current" {}

/*
    --- Lambda Permissions ---
*/

data "aws_iam_policy_document" "lambda_policy_document" {
  // Events permissions
  statement {
    actions = [
      "events:*",
    ]

    resources = [
      "*",
    ]
  }

  // Logs permissions
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:DeleteLogGroup",
      "logs:DescribeLogGroups",
      "logs:ListTagsLogGroup",
      "logs:PutLogEvents",
      "logs:TagLogGroup",
      "logs:PutSubscriptionFilter",
      "logs:DescribeSubscriptionFilters",
      "logs:DeleteSubscriptionFilter"
    ]

    resources = [
      "*",
    ]
  }

  // ECS Permissions
  statement {
    actions = [
      "ecs:DeleteCluster",
      "ecs:DeleteService",
      "ecs:DeleteTaskSet",
      "ecs:Describe*",
      "ecs:UntagResource",
      "ecs:UpdateService",
      "ecs:DeregisterTaskDefinition",
    ]

    resources = [
      "*",
    ]
  }

  // ELB permissions
  statement {
    actions = [
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:Describe*"
    ]

    resources = [
      "*",
    ]
  }

  // ECR Permissions
  statement {
    actions = [
      "ecr:CreateRepository",
      "ecr:DescribeRepositories",
      "ecr:DeleteLifecyclePolicy",
      "ecr:GetLifecyclePolicy",
      "ecr:GetRepositoryPolicy",
      "ecr:ListTagsForResource",
      "ecr:DeleteRepository",
      "ecr:Describe*",
      "ecr:Get*",
      "ecr:List*",
      "ecr:Put*",
      "ecr:UntagResource"
    ]

    resources = [
      "*",
    ]
  }

  // IAM Permissions
  statement {
    actions = [
      "iam:*",
    ]

    resources = [
      "*",
    ]
  }

  // Lambda permissions
  statement {
    actions = [
      "lambda:*",
    ]

    resources = [
      "*",
    ]
  }

  // API Gateway Permissions
  statement {
    actions = [
      "apigateway:*"
    ]

    resources = [
      "*",
    ]
  }

  // DynamoDB Permissions
  statement {
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
    ]

    resources = [
      "*",
    ]
  }

  // SQS Permissions
  statement {
    actions = [
      "sqs:*",
    ]

    resources = [
      "*",
    ]
  }

  // SNS Permissions
  statement {
    actions = [
      "sns:Subscribe",
      "sns:Get*",
      "sns:List*",
      "sns:Unsubscribe"
    ]

    resources = [
      "*",
    ]
  }

  // CodeBuild/CodePipeline permissions
  statement {
    actions = [
      "codebuild:BatchGetProjects",
      "codebuild:CreateProject",
      "codebuild:CreateWebhook",
      "codebuild:DeleteProject",
      "codebuild:DeleteWebhook",
      "codepipeline:CreatePipeline",
      "codepipeline:DeletePipeline",
      "codepipeline:DeleteWebhook",
      "codepipeline:Get*",
      "codepipeline:ListTagsForResource",
      "codepipeline:ListWebhooks",
      "codepipeline:PutWebhook",
      "codepipeline:TagResource",
      "codepipeline:UpdatePipeline",
    ]
    resources = [
      "*",
    ]
  }

  // SSM permissions
  statement {
    actions = [
      "ssm:DeleteParameter",
      "ssm:Describe*",
      "ssm:Get*",
      "ssm:List*",
      "ssm:PutParameter",
    ]
    resources = [
      "*",
    ]
  }

  // s3 permissions
  statement {
    actions = [
      "s3:CreateBucket",
      "s3:Delete*",
      "s3:Get*",
      "s3:List*",
      "s3:Put*",
    ]

    resources = [
      "*",
    ]
  }

  // Secret permissions
  statement {
    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      "*",
    ]
  }

  // ACM permissions
  statement {
    actions = [
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "acm:GetCertificate",
      "acm:ListTagsForCertificate"
    ]

    resources = [
      "*",
    ]
  }


  // SQS permissions
  statement {
    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage",
    ]

    resources = [
      "*",
    ]
  }

  // EC2 Permissions
  statement {
    actions = [
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
      "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "ec2:DescribeTags",
      "ec2:Describe*",
    ]

    resources = [
      "*",
    ]
  }

  // Hodgepodge permissions for manual deployment
  statement {
    actions = [
      "ec2:AttachNetworkInterface",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "xray:PutTelemetryRecords",
      "xray:PutTraceSegments",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      "arn:aws:iam::686137062481:role/DCDNSCrossAccountRole",
    ]
  }
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

/*
    --- IAM Policies ---
*/

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.lambda_name}-Lambda-Policy-${terraform.workspace}"
  description = "A policy that allows a Lambda to execute via SQS"
  policy      = data.aws_iam_policy_document.lambda_policy_document.json
}

/*
    --- IAM Roles ---
*/

resource "aws_iam_role" "lambda_role" {
  name               = "${var.lambda_name}-Lambda-Role-${terraform.workspace}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
  tags               = merge(var.tags, map("Name", "${var.tags.ProjectName}-Lambda-Role-${terraform.workspace}", "Environment", "${terraform.workspace}", "Role", "IAM Role"))
}

/*
    --- Policy/Role Attachment ---
*/

resource "aws_iam_policy_attachment" "lambda_attach" {
  name       = "${var.lambda_name}-lambda-policy-attachment-${terraform.workspace}"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.lambda_policy.arn
}
