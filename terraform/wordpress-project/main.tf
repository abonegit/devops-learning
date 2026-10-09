data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_internet_gateway_attachment" "default" {
  vpc_id              = data.aws_vpc.default.id
  internet_gateway_id = "igw-0cf7c81573eeeeaf4"
}

resource "aws_security_group" "wordpress" {
  name        = "wordpress-security-group"
  description = "Security group for WordPress server"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wordpress-security-group"
  }
}

resource "aws_secretsmanager_secret" "wordpress_db" {
  name        = "wordpress-project-db-credentials"
  description = "Database credentials for the WordPress project"

  # Allows Terraform destroy to remove the secret immediately.
  recovery_window_in_days = 0
}

resource "aws_iam_role" "wordpress" {
  name = "wordpress-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "wordpress_secrets" {
  name = "wordpress-secrets-policy"
  role = aws_iam_role.wordpress.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "secretsmanager:PutSecretValue",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]

        Resource = aws_secretsmanager_secret.wordpress_db.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "wordpress_ssm" {
  role       = aws_iam_role.wordpress.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "wordpress" {
  name = "wordpress-ec2-profile"
  role = aws_iam_role.wordpress.name
}

resource "aws_instance" "wordpress" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.wordpress.id
  ]

  iam_instance_profile = aws_iam_instance_profile.wordpress.name

  user_data = templatefile("${path.module}/wordpress-user-data.sh", {
    aws_region    = var.aws_region
    db_secret_arn = aws_secretsmanager_secret.wordpress_db.arn
  })

  tags = {
    Name = var.instance_name
  }
}