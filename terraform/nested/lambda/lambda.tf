# Create Role for Lambda
resource "aws_iam_role" "lambda_role_1" {
  name = "agrcic-lambda-role-1-v-${var.run_version}"
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
  name        = "agrcic-lambda-logging-policy-1-v-${var.run_version}"
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
  policy_arn = var.sqs_access_policy_arn
}

# Create CloudWatch Log group for Lambdas
resource "aws_cloudwatch_log_group" "lambda_log_group_1" {
  name = "/aws/lambda/agrcic-lambda-choice-1-v-${var.run_version}"
}
resource "aws_cloudwatch_log_group" "lambda_log_group_2" {
  name = "/aws/lambda/agrcic-lambda-choice-2-v-${var.run_version}"
}
resource "aws_cloudwatch_log_group" "lambda_log_group_3" {
  name = "/aws/lambda/agrcic-lambda-default-choice-v-${var.run_version}"
}

# Create Lambda Functions
resource "aws_lambda_function" "agrcic-lambda-choice-1" {
  function_name = "agrcic-lambda-choice-1-v-${var.run_version}"
  handler = "lambda_choice_1.lambda_handler"
  runtime = "python3.9"
  role = aws_iam_role.lambda_role_1.arn
  source_code_hash = filebase64sha256("../../lambda_functions.zip")
  filename = "../../lambda_functions.zip"
  depends_on = [aws_cloudwatch_log_group.lambda_log_group_1]
}
resource "aws_lambda_function" "agrcic-lambda-choice-2" {
  function_name = "agrcic-lambda-choice-2-v-${var.run_version}"
  handler = "lambda_choice_2.lambda_handler"
  runtime = "python3.9"
  role = aws_iam_role.lambda_role_1.arn
  source_code_hash = filebase64sha256("../../lambda_functions.zip")
  filename = "../../lambda_functions.zip"
  depends_on = [aws_cloudwatch_log_group.lambda_log_group_2]
}
resource "aws_lambda_function" "agrcic-lambda-deafult-choice" {
  function_name = "agrcic-lambda-default-choice-v-${var.run_version}"
  handler = "lambda_default_choice.lambda_handler"
  runtime = "python3.9"
  role = aws_iam_role.lambda_role_1.arn
  source_code_hash = filebase64sha256("../../lambda_functions.zip")
  filename = "../../lambda_functions.zip"
  depends_on = [aws_cloudwatch_log_group.lambda_log_group_3]
}
