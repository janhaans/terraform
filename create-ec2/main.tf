# Create an EC2 instance in region eu-west-1 with Amazon Linux 2 AMI on t2.micro instance type
resource "aws_instance" "example" {
  ami           = "ami-04936a5cb606eda31"
  instance_type = "t2.micro"
  user_data = file("${path.module}/app1-install.sh")
  vpc_security_group_ids = [aws_security_group.allow-http.id, aws_security_group.allow-ssh.id, aws_security_group.allow-https.id]
  tags = {
    "name" = "example"
  }
}

resource "aws_security_group" "allow-http" {
  name        = "allow-http"
  description = "Allow inbound HTTP traffic"
}

 resource "aws_vpc_security_group_ingress_rule" "http" {
   security_group_id = aws_security_group.allow-http.id
   from_port         = 80
   to_port           = 80
   ip_protocol       = "tcp"
   cidr_ipv4         = "0.0.0.0/0" 
} 

#Create security group to allow connection manager to connect to instance example
resource "aws_security_group" "allow-ssh" {
  name        = "allow-ssh"
  description = "Allow inbound SSH traffic"
}

#Create VPB security group ingress rule to allow connection manager to connect to instance example
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.allow-ssh.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Create security group to allow outbound HTTPS
resource "aws_security_group" "allow-https" {
  name        = "allow-https"
  description = "Allow outbound HTTPS traffic"
}

# Create VPC security group egress rule to allow outbound HTTPS
resource "aws_vpc_security_group_egress_rule" "https" {
  security_group_id = aws_security_group.allow-https.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4       = "0.0.0.0/0"
}

