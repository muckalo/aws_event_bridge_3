# Create Role for Step Function
resource "aws_iam_role" "step_function_role" {
  name = "agrcic-step-function-role-1-v-${var.run_version}"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "states.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}
# Attach policy to allow Step Function to invoke Lambda functions
resource "aws_iam_role_policy" "step_function_policy_1" {
  name = "agrcic-step-function-policy-1-v-${var.run_version}"
  role = aws_iam_role.step_function_role.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "lambda:InvokeFunction"
        ],
        "Resource": [
          var.agrcic_lambda_choice_1_arn,
          var.agrcic_lambda_choice_2_arn,
          var.agrcic_lambda_default_choice_arn
        ]
      }
    ]
  })
}

# Create Step Function State Machine
resource "aws_sfn_state_machine" "agrcic_state_machine_1" {
  name     = "agrcic-state-machine-1-v-${var.run_version}"
  role_arn = aws_iam_role.step_function_role.arn

  definition = jsonencode({
    "Comment": "A simple AWS Step Function example with choices",
    "StartAt": "ChoiceState",
    "States": {
      "ChoiceState": {
        "Type": "Choice",
        "Choices": [
          {
            "Variable": "$.choice",
            "StringEquals": "1",
            "Next": "InvokeLambda1"
          },
          {
            "Variable": "$.choice",
            "StringEquals": "2",
            "Next": "InvokeLambda2"
          }
        ],
        "Default": "InvokeLambda3"
      },
      "InvokeLambda1": {
        "Type": "Task",
        "Resource": var.agrcic_lambda_choice_1_arn,
        "End": true
      },
      "InvokeLambda2": {
        "Type": "Task",
        "Resource": var.agrcic_lambda_choice_2_arn,
        "End": true
      },
      "InvokeLambda3": {
        "Type": "Task",
        "Resource": var.agrcic_lambda_default_choice_arn,
        "End": true
      }
    }
  })
}
