variable "project_name" {}
variable "environment" {}
variable "vpc_id" {}
variable "public_subnet_id" {}
variable "security_group_id" {}
variable "instance_type" {}
variable "tags" {}

# Recurso Data para pegar a AMI Amazon Linux 2 mais recente
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Instância EC2 (Web Server)
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id

  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = true # IP Público

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install nginx1 -y
              systemctl start nginx
              systemctl enable nginx
              
              # Página WEB
              echo '<html>
                <head>
                  <title>QuickOrder - Light Version</title>
                  <style>
                    body { font-family: Arial, sans-serif; text-align: center; padding: 50px; background-color: #f0f2f5; }
                    .card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); display: inline-block; }
                    h1 { color: #1a73e8; }
                    p { color: #555; }
                  </style>
                </head>
                <body>
                  <div class="card">
                    <h1>🚀 QuickOrder (Light)</h1>
                    <p>Infraestrutura simplificada rodando em EC2.</p>
                    <p>Status: <strong>ONLINE</strong></p>
                  </div>
                </body>
              </html>' > /usr/share/nginx/html/index.html
              EOF

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-web-server"
    }
  )
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "instance_id" {
  value = aws_instance.web.id
}
