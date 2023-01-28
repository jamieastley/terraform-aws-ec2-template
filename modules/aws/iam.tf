resource "aws_iam_role" "ec2_role" {
  name = "${var.app_name}-ec2-role"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : "sts:AssumeRole",
        Principal : {
          Service : "ec2.amazonaws.com"
        },
        Effect : "Allow",
        Sid : ""
      }
    ]
  })
}

resource "aws_iam_instance_profile" "valheim" {
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_policy" "ec2_policy" {
  name = "${var.app_name}-ec2-policy"
  description = "Allows the EC2 instance to interact with various AWS services"
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "s3:Put*",
          "s3:Get*",
          "s3:List*"
        ],
        Resource : [
          "arn:aws:s3:::${data.aws_s3_bucket.bucket.id}",
          "arn:aws:s3:::${data.aws_s3_bucket.bucket.id}/"
        ]
      },
      {
        Effect : "Allow",
        Action : ["ec2:DescribeInstances"],
        Resource : ["*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "valheim" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}