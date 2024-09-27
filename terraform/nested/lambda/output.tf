output "agrcic_lambda_choice_1_arn" {
  value = aws_lambda_function.agrcic-lambda-choice-1.arn
}

output "agrcic_lambda_choice_2_arn" {
  value = aws_lambda_function.agrcic-lambda-choice-2.arn
}

output "agrcic_lambda_default_choice_arn" {
  value = aws_lambda_function.agrcic-lambda-deafult-choice.arn
}

output "lambda_role_1_arn" {
  value = aws_iam_role.lambda_role_1.arn
}

output "lambda_role_1_id" {
  value = aws_iam_role.lambda_role_1.id
}
