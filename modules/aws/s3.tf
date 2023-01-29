resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = var.s3_bucket_id
  policy = jsonencode({
    Version : "2012-10-17",
    Id : "PolicyFor${var.app_name}Backups",
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          "AWS" : aws_iam_role.ec2_role.arn
        },
        Action : [
          "s3:Put*",
          "s3:Get*",
          "s3:List*"
        ],
        Resource : "arn:aws:s3:::${var.s3_bucket_id}/*"
      }
    ]
  })
}
