terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
  provider "aws" {
    region = "${var.myregion}"
  }

resource "aws_vpc" "mynewmainvpc" {
  cidr_block       =  "${var.myvpc-cidr}"
  instance_tenancy = "${var.newtenancy}"

  tags = {
    Name = "MY ACCOUNT VPC INFO"
  }
}

resource "aws_subnet" "mynewmainsubnet" {
  count = "${length(data.aws_availability_zones.azs.names[3])}"
  vpc_id     = aws_vpc.mynewmainvpc.id
  availability_zone  = "${element(data.aws_availability_zones.azs.names,count.index)}"
  cidr_block = "${element(var.mysub-cidr,count.index)}"
  
  tags = {
    Name = "MY ACCOUNT-${count.index+1}"
  }
}

resource "aws_security_group" "mylatestcustomsg" {
  name        = "${var.myname}"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.mynewmainvpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.mynewmainvpc.cidr_block]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "MY NEW CUSTOM SG-2"
  }
}

resource "aws_s3_bucket" "ownbucketone" {
  bucket = "${var.myownbucket}"

  tags = {
    Name        = "My bucket Custom One"
    Environment = "New-Dev"
  }
}
