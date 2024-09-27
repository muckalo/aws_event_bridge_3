output "run_version" {
  value = var.run_version
}

output "sqs_queue_1_arn" {
  value = aws_sqs_queue.sqs-queue-1.arn
}

output "sqs_queue_1_id" {
  value = aws_sqs_queue.sqs-queue-1.id
}

output "sqs_access_policy_arn" {
  value = aws_iam_policy.sqs_access_policy.arn
}

output "dlq_id" {
  value = aws_sqs_queue.dlq.id
}

output "dlq_name" {
  value = aws_sqs_queue.dlq.name
}
