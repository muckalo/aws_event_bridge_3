terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
  required_version = ">= 1.5.7, < 1.10.0"
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.region
}


# Module SQS
module "sqs_stack" {
  source = "../nested/sqs"
  part = var.part
}

# Module EventBridge
module "event_bridge_stack" {
  source = "../nested/event_bridge"
  part = var.part
  region = var.region
  sqs_queue_1_arn = module.sqs_stack.sqs_queue_1_arn
  sqs_queue_1_id = module.sqs_stack.sqs_queue_1_id
}

# Module Lambda
module "lambda_stack" {
  source = "../nested/lambda"
  part = var.part
  sqs_access_policy_arn = module.sqs_stack.sqs_access_policy_arn
}

# Module StepFunction
module "step_function_stack" {
  source = "../nested/step_function"
  part = var.part
  agrcic_lambda_1_arn = module.lambda_stack.agrcic_lambda_1_arn
  agrcic_lambda_2_arn = module.lambda_stack.agrcic_lambda_2_arn
  agrcic_lambda_3_arn = module.lambda_stack.agrcic_lambda_3_arn
}

# Module Lambda-StepFunction
module "lambda_sf" {
  source = "../nested/lambda_sf"
  part = var.part
  lambda_role_1_arn = module.lambda_stack.lambda_role_1_arn
  lambda_role_1_id = module.lambda_stack.lambda_role_1_id
  dlq_id = module.sqs_stack.dlq_id
  sqs_queue_1_arn = module.sqs_stack.sqs_queue_1_arn
  agrcic_state_machine_1_arn = module.step_function_stack.agrcic_state_machine_1_arn
}

# Module SNS
module "sns_stack" {
  source = "../nested/sns"
  part = var.part
  dlq_name = module.sqs_stack.dlq_name
  email = var.email
}
