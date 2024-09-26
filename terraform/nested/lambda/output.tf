output "agrcic_lambda_1_arn" {
  value = aws_lambda_function.agrcic-lambda-1.arn
}

output "agrcic_lambda_2_arn" {
  value = aws_lambda_function.agrcic-lambda-2.arn
}

output "agrcic_lambda_3_arn" {
  value = aws_lambda_function.agrcic-lambda-3.arn
}

output "lambda_role_1_arn" {
  value = aws_iam_role.lambda_role_1.arn
}

output "lambda_role_1_id" {
  value = aws_iam_role.lambda_role_1.id
}
