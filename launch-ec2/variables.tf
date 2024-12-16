variable "region" {
  description = "The AWS region"
  type        = string
}

variable "profile" {
  description = "The AWS profile"
  type        = string
}

variable "ec2_ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}  

variable "ec2_instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string  
}

variable "disk-size" {
  description = "The size of the EBS volume in GB"
  type        = number
}

variable "ebs_volume_type" {
  description = "The type of the EBS volume"
  type        = string
}