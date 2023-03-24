resource "aws_iam_policy" "ec2_policy" {
  name        = "S3RW"
  path        = "/"
  description = "Grants Get/Put permissions to the netspi-screening-abc123 s3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
        ]
        Resource = "${aws_s3_bucket.foo.arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = "s3:ListBucket"
        Resource = "${aws_s3_bucket.foo.arn}"
      },
    ]
  })
}

resource "aws_iam_role" "role" {
  name = "ec2role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy_attachment" "attach" {
  name       = "ec2role-attach"
  roles      = ["${aws_iam_role.role.name}"]
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_instance_profile" "profile" {
  name = "ec2role"
  role = aws_iam_role.role.name
}
