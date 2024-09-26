# Create Role for Lambda
resource "aws_iam_role" "lambda_role_1" {
  name = "agrcic-lambda-role-1-${var.part}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Create Permission for Lambda to be able to create Logs
resource "aws_iam_policy" "lambda_logging_policy" {
  name        = "agrcic-lambda-logging-policy1--${var.part}"
  description = "Policy for allowing Lambda to write logs to CloudWatch"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach policy
resource "aws_iam_role_policy_attachment" "lambda_logging_policy_policy_attachment" {
  role       = aws_iam_role.lambda_role_1.name
  policy_arn = aws_iam_policy.lambda_logging_policy.arn
}

# Attach the SQS access policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_sqs_access_policy_attachment" {
  role       = aws_iam_role.lambda_role_1.name
#   policy_arn = aws_iam_policy.sqs_access_policy.arn
  policy_arn = var.sqs_access_policy_arn
}


# # Create Lambda Function to Start the Step Function
# resource "aws_lambda_function" "start_step_function" {
#   function_name = "agrcic-lambda-start-step-function-1-${var.part}"
#   handler       = "lambda_start_step_function.lambda_handler" # Adjust based on your handler
#   runtime       = "python3.9"
#   role          = aws_iam_role.lambda_role_1.arn
#   source_code_hash = filebase64sha256("../lambda_functions.zip") # Adjust the path as necessary
#   filename      = "../lambda_functions.zip" # Adjust the path as necessary
#
#   environment {
#     variables = {
#       STEP_FUNCTION_ARN = aws_sfn_state_machine.agrcic_state_machine_1.arn
# #       DLQ_URL = aws_sqs_queue.dlq.id
#       DLQ_URL = var.dlq_id
#     }
#   }
# }
# # Add permission for Lambda to read from SQS
# resource "aws_iam_role_policy" "lambda_sqs_policy" {
#   name   = "agrcic-lambda-sqs-policy-1-${var.part}"
#   role   = aws_iam_role.lambda_role_1.id
#
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = "sqs:ReceiveMessage",
# #         Resource = aws_sqs_queue.sqs-queue-1.arn
#         Resource = var.sqs_queue_1_arn
#       },
#       {
#         Effect = "Allow",
#         Action = [
#           "sqs:DeleteMessage",
#           "sqs:GetQueueAttributes"
#         ],
# #         Resource = aws_sqs_queue.sqs-queue-1.arn
#         Resource = var.sqs_queue_1_arn
#       }
#     ]
#   })
# }
# # Add permission for Lambda to start execution of State Machine
# resource "aws_iam_role_policy" "lambda_step_function_policy" {
#   name   = "agrcic-lambda-step-function-policy-1-${var.part}"
#   role   = aws_iam_role.lambda_role_1.id
#
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = "states:StartExecution",
#         Resource = aws_sfn_state_machine.agrcic_state_machine_1.arn
#       }
#     ]
#   })
# }
# # Event Source Mapping for SQS to Trigger Lambda
# resource "aws_lambda_event_source_mapping" "sqs_to_lambda" {
# #   event_source_arn = aws_sqs_queue.sqs-queue-1.arn
#   event_source_arn = var.sqs_queue_1_arn
#   function_name    = aws_lambda_function.start_step_function.arn
#   enabled          = true
#   batch_size       = 10
# }


# Create Lambda Functions
resource "aws_lambda_function" "agrcic-lambda-1" {
  function_name = "agrcic-lambda-1-${var.part}"
  handler = "lambda_1.lambda_handler"
  runtime = "python3.9"
  role = aws_iam_role.lambda_role_1.arn
  source_code_hash = filebase64sha256("../lambda_functions.zip")
  filename = "../lambda_functions.zip"
}
resource "aws_lambda_function" "agrcic-lambda-2" {
  function_name = "agrcic-lambda-2-${var.part}"
  handler = "lambda_2.lambda_handler"
  runtime = "python3.9"
  role = aws_iam_role.lambda_role_1.arn
  source_code_hash = filebase64sha256("../lambda_functions.zip")
  filename = "../lambda_functions.zip"
}
resource "aws_lambda_function" "agrcic-lambda-3" {
  function_name = "agrcic-lambda-3-${var.part}"
  handler = "lambda_3.lambda_handler"
  runtime = "python3.9"
  role = aws_iam_role.lambda_role_1.arn
  source_code_hash = filebase64sha256("../lambda_functions.zip")
  filename = "../lambda_functions.zip"
}
