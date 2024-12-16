resource "aws_vpc" "vpc-example" {
    cidr_block = "10.16.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
    assign_generated_ipv6_cidr_block = "true"

    tags = {
        Name = "main-vpc"
    }
}