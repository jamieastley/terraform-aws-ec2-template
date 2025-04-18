output "policy_name" {
  value       = aws_iam_policy.tf_policy
  description = "The name of the IAM policy which was created"
}

output "policy_arn" {
  value       = aws_iam_policy.tf_policy.arn
  description = "The ARN of the IAM policy which was created"
}
