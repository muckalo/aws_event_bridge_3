# CloudWatch Alarm for DLQ
resource "aws_cloudwatch_metric_alarm" "dlq_alarm" {
  alarm_name          = "agrcic-DLQMessagesAlarm-1-${var.part}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name        = "ApproximateNumberOfMessagesVisible"
  namespace          = "AWS/SQS"
  period             = "60"  # 1 minute
  statistic          = "Sum"
  threshold          = "0"  # Change this if you want to set a different threshold
  alarm_description  = "Alarm when messages are sent to DLQ"
  dimensions = {
    QueueName = var.dlq_name
  }

  # Action to send notification to SNS topic
  alarm_actions = [
    aws_sns_topic.dlq_notifications_1.arn
  ]
}

# Create SNS Topic
resource "aws_sns_topic" "dlq_notifications_1" {
  name = "agrcic-dlq-notifications-1-${var.part}"
}
# Subscribe Topic
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.dlq_notifications_1.arn
  protocol  = "email"
  endpoint  = var.email
}

# Attach Policy to allow SNS Topic to publish messages from CloudWatch Alarm
resource "aws_sns_topic_policy" "sns_policy" {
  arn = aws_sns_topic.dlq_notifications_1.arn
  policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action = "SNS:Publish"
        Resource = aws_sns_topic.dlq_notifications_1.arn
        Condition = {
          "ArnEquals" = {
            "AWS:SourceArn" = aws_cloudwatch_metric_alarm.dlq_alarm.arn
          }
        }
      }
    ]
  })
}
