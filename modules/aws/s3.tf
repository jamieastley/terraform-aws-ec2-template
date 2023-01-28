data "aws_s3_bucket" "bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_policy" "valheim" {
  bucket = data.aws_s3_bucket.bucket.id
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
        Resource : "arn:aws:s3:::${data.aws_s3_bucket.bucket.id}/*"
      }
    ]
  })
}
