provider "aws" {
  region = "us-east-1"
}

# Public S3 Bucket (HIGH)
resource "aws_s3_bucket" "public_bucket" {
  bucket = "vulnerable-public-bucket"
  acl    = "public-read"
}

# Security Group Open to the World (CRITICAL)
resource "aws_security_group" "open_ssh" {
  name = "open-ssh-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Unencrypted RDS with Hardcoded Credentials (CRITICAL)
resource "aws_db_instance" "insecure_db" {
  allocated_storage   = 20
  engine              = "mysql"
  instance_class      = "db.t3.micro"
  username            = "admin"
  password            = "password123"
  skip_final_snapshot = true
  storage_encrypted   = false
}

# Unencrypted EBS Volume (MEDIUM)
resource "aws_ebs_volume" "unencrypted_volume" {
  availability_zone = "us-east-1a"
  size              = 10
  encrypted         = false
}

# IAM Policy with Full Admin Access (CRITICAL)
resource "aws_iam_policy" "admin_policy" {
  name = "admin-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "*"
      Resource = "*"
    }]
  })
}
