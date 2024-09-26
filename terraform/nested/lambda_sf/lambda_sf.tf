# Create Lambda Function to Start the Step Function
resource "aws_lambda_function" "start_step_function" {
  function_name = "agrcic-lambda-start-step-function-1-${var.part}"
  handler       = "lambda_start_step_function.lambda_handler" # Adjust based on your handler
  runtime       = "python3.9"
#   role          = aws_iam_role.lambda_role_1.arn
  role          = var.lambda_role_1_arn
  source_code_hash = filebase64sha256("../../lambda_functions.zip") # Adjust the path as necessary
  filename      = "../../lambda_functions.zip" # Adjust the path as necessary

  environment {
    variables = {
#       STEP_FUNCTION_ARN = aws_sfn_state_machine.agrcic_state_machine_1.arn
      STEP_FUNCTION_ARN = var.agrcic_state_machine_1_arn
#       DLQ_URL = aws_sqs_queue.dlq.id
      DLQ_URL = var.dlq_id
    }
  }
}
# Add permission for Lambda to read from SQS
resource "aws_iam_role_policy" "lambda_sqs_policy" {
  name   = "agrcic-lambda-sqs-policy-1-${var.part}"
#   role   = aws_iam_role.lambda_role_1.id
  role   = var.lambda_role_1_id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sqs:ReceiveMessage",
#         Resource = aws_sqs_queue.sqs-queue-1.arn
        Resource = var.sqs_queue_1_arn
      },
      {
        Effect = "Allow",
        Action = [
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ],
#         Resource = aws_sqs_queue.sqs-queue-1.arn
        Resource = var.sqs_queue_1_arn
      }
    ]
  })
}
# Add permission for Lambda to start execution of State Machine
resource "aws_iam_role_policy" "lambda_step_function_policy" {
  name   = "agrcic-lambda-step-function-policy-1-${var.part}"
#   role   = aws_iam_role.lambda_role_1.id
  role   = var.lambda_role_1_id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "states:StartExecution",
#         Resource = aws_sfn_state_machine.agrcic_state_machine_1.arn
        Resource = var.agrcic_state_machine_1_arn
      }
    ]
  })
}
# Event Source Mapping for SQS to Trigger Lambda
resource "aws_lambda_event_source_mapping" "sqs_to_lambda" {
#   event_source_arn = aws_sqs_queue.sqs-queue-1.arn
  event_source_arn = var.sqs_queue_1_arn
  function_name    = aws_lambda_function.start_step_function.arn
  enabled          = true
  batch_size       = 10
}