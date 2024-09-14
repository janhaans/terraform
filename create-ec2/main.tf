# Create an EC2 instance in region eu-west-1 with Amazon Linux 2 AMI on t2.micro instance type
resource "aws_instance" "example" {
  ami           = "ami-04936a5cb606eda31"
  instance_type = "t2.micro"
  user_data = file("${path.module}/app1-install.sh")
  vpc_security_group_ids = [aws_security_group.allow-inbound-http.id, aws_security_group.allow-outbound-https.id]
  tags = {
    "name" = "example"
  }
}

resource "aws_security_group" "allow-inbound-http" {
  name        = "allow-inbound-http"
  description = "Allow inbound HTTP traffic"
}

 resource "aws_vpc_security_group_ingress_rule" "http" {
   security_group_id = aws_security_group.allow-inbound-http.id
   from_port         = 80
   to_port           = 80
   ip_protocol       = "tcp"
   cidr_ipv4         = "0.0.0.0/0" 
} 

resource "aws_security_group" "allow-outbound-https" {
  name        = "allow-outbound-https"
  description = "Allow outbound HTTPS traffic"
}

resource "aws_vpc_security_group_egress_rule" "https" {
  security_group_id = aws_security_group.allow-outbound-https.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}