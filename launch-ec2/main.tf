resource "aws_instance" "ec2-example" {
    ami           = data.aws_ami.amazon_linux.id
    instance_type = var.ec2_instance_type
    key_name = aws_key_pair.deployer.key_name
    security_groups = [aws_security_group.allow_ssh.name]


    tags = {
        Name = "ec2-example"
    }
}

resource "aws_key_pair" "deployer" {
    key_name   = "deployer-key"
    public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_security_group" "allow_ssh" {
    name        = "allow_ssh"
    description = "Allow inbound SSH traffic"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_ebs_volume" "ebs-example" {
    availability_zone = aws_instance.ec2-example.availability_zone
    size              = var.disk-size
    type              = var.ebs_volume_type
    tags = {
        Name = "ebs-example"
    }
}

resource "aws_volume_attachment" "ec2-ebs-example" {
    device_name = "/dev/sdh"
    volume_id   = aws_ebs_volume.ebs-example.id
    instance_id = aws_instance.ec2-example.id
}

data "aws_ami" "amazon_linux" {
    most_recent = true

    filter {
        name   = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["amazon"]
}

output "amazon_linux_ami_id" {
    value = data.aws_ami.amazon_linux.id
}