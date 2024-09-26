# Create Dead Letter Queue
resource "aws_sqs_queue" "dlq" {
  name = "agrcic-sqs-dlq-1-1-${var.part}"
  visibility_timeout_seconds = 30
  message_retention_seconds   = 86400  # Retain messages for 1 day (86400 seconds)
}

# Create SQS Queue
resource "aws_sqs_queue" "sqs-queue-1" {
  name = "agrcic-sqs-queue-1-${var.part}"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount = 1  # Number of times to try before sending to DLQ
  })
}

# Create IAM policy for SQS permissions
resource "aws_iam_policy" "sqs_access_policy" {
  name        = "agrcic-sqs-access-policy-1-${var.part}"
  description = "Policy for accessing SQS and DLQ"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ],
        Resource = [
          aws_sqs_queue.sqs-queue-1.arn,
          aws_sqs_queue.dlq.arn
        ]
      }
    ]
  })
}
