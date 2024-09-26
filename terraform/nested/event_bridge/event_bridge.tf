# Create CloudWatch Log Group For EventBridge
resource "aws_cloudwatch_log_group" "eb-rule-log-group-1" {
  name = "/aws/events/agrcic-eb-rule-1-${var.part}"
}

# Create Role for EventBridge
resource "aws_iam_role" "eventbridge_role" {
  name = "agrcic-eventbridge-role-1-${var.part}"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "events.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

# Create Policy for EventBridge to send messages to SQS
resource "aws_iam_role_policy" "eventbridge_policy" {
  name   = "agrcic-eventbridge-policy-1-${var.part}"
  role   = aws_iam_role.eventbridge_role.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "sqs:SendMessage",
        "Resource": var.sqs_queue_1_arn
      }
    ]
  })
}

# Create Policy for EventBridge to send logs to CloudWatch
resource "aws_iam_role_policy" "eventbridge_policy_2" {
  name   = "agrcic-eventbridge-policy-2"
  role   = aws_iam_role.eventbridge_role.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:log-group:/aws/events/*"
      }
    ]
  })
}

# Create EventBridge Rule
resource "aws_cloudwatch_event_rule" "eb-rule-1" {
  name = "agrcic-eb-rule-1-${var.part}"
  event_pattern = jsonencode({
    source = ["demo.sqs"]
  })
}

# Create EventBridge Target for SQS
resource "aws_cloudwatch_event_target" "eb-target-1" {
  rule = aws_cloudwatch_event_rule.eb-rule-1.name
  target_id = "agrcic-target-1-${var.part}"
  arn  = var.sqs_queue_1_arn
  depends_on = [aws_cloudwatch_event_rule.eb-rule-1]
  input_transformer {
      input_paths = {
        choice = "$.detail.choice"  # Adjust this based on your event structure
      }
    input_template = <<-EOF
    {
      "choice": "<choice>"
    }
    EOF
    }
}

# Create EventBridge Target for CloudWatch
resource "aws_cloudwatch_event_target" "eb-target-cw-1" {
  rule      = aws_cloudwatch_event_rule.eb-rule-1.name
  target_id = "agrcic-target-cw-1-${var.part}"
  arn = aws_cloudwatch_log_group.eb-rule-log-group-1.arn
}

# Grant EventBridge Permissions to Send Messages to SQS
resource "aws_sqs_queue_policy" "event_queue_policy" {
#   queue_url = aws_sqs_queue.sqs-queue-1.id
  queue_url = var.sqs_queue_1_id
  depends_on = [aws_cloudwatch_event_target.eb-target-1]
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "agrcic-EventBridgeSendMessage-1-${var.part}",
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action = "SQS:SendMessage"
        Resource = var.sqs_queue_1_arn
        Condition = {
          "ArnEquals" = {
            "aws:SourceArn" = aws_cloudwatch_event_rule.eb-rule-1.arn
          }
        }
      }
    ]
  })
}

# Create Policy for Sending Events to EventBridge
resource "aws_iam_role_policy" "eventbridge_policy_3" {
  name   = "agrcic-eventbridge-policy-3"
  role   = aws_iam_role.eventbridge_role.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "events:PutEvents",
        "Resource": "arn:aws:events:${var.region}:${data.aws_caller_identity.current.account_id}:event-bus/default"
      }
    ]
  })
}
