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
    region = "us-east-1"
  }

#Creating a Vpc

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "MYCUSTOMVPC"
  }
}

#Creating a subnet for above vpc

resource "aws_subnet" "main1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  
  tags = {
    Name = "My Custom subnet"
  }
}

#Creating a Securtiy Group

resource "aws_security_group" "mynewsg" {
  name        = "MYNEWSG"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    
  }
  
  ingress {
    description      = "ALLOWING WEBSERVER from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]

  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "MYNEWSG-1"
  }
}

#Creating a Internet Gateway

resource "aws_internet_gateway" "mynewigw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MYNEWCUSTOMIGW"
  }
}

#Creating a Route Table

resource "aws_route_table" "mycustomnewrt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mynewigw.id
  }

  tags = {
    Name = "example"
  }
}

#Creating a RouteTable Association

resource "aws_route_table_association" "mynewrt" {
  subnet_id      = aws_subnet.main1.id
  route_table_id = aws_route_table.mycustomnewrt.id
}

#Creating a Network Acl TO Traffic

resource "aws_network_acl" "mynetworkacl" {
  vpc_id = aws_vpc.main.id

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "MYNEWNETWORKACL"
  }
}

###########################################

resource "aws_subnet" "main2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "My Custom subnet1"
  }
}
#################################################
resource "aws_network_acl" "mynetworknewaccess" {
  vpc_id = aws_vpc.main.id

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "MYNEWNETWORKCUSTOMACL"
  }
}

#####################################





#Creating a New AMi

resource "aws_ami" "mynewcustomami" {
  name                = "MYCUSTOMAMI"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda"

  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id = "snap-0d10dd73e945b0d0d"
    volume_size = 8
  }
}

#Creating a AMi Copy

resource "aws_ami_copy" "mynewamicopy" {
  name              = "MYNEWSUTOMAMI"
  description       = "A NEW COPY OF A CUSTOM AMI"
  source_ami_id     = "ami-0464d49b8794eba32"
  source_ami_region = "us-east-1"

  tags = {
    Name = "MYCUSTOMAMICOPY"
    LOCATION = "KURNOOL"
  }
}

#Creating a KeyPAir

resource "aws_key_pair" "mynewcustomkey" {
  key_name   = "MYFirstNewTwo"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCg7g+pRjIWmjBUz5En1ry9GHwRHbpbDJr+mSqfqBixwSgDEkD7FwdovBp8jvZA9ePaKJadtgEAsGnGZm826E7OQkJ1iK2jSdaEYCDZeBSnC03HHSVpAsyTnN5o86SJhk9V54TOVDfUxFXUHQzSihok13cdmX/5nONGl8cWVhfDtMykaEIZyZJX+uZoWMNomHBLGF+y7Ye/t6C6F4JLjVQmEOkelpVzlag3Wfx8vix7woUCCv5qJ333ptgIhZVo+5WJyqiy4/Of6UjAb8vDMk5D9iZAa/aZw4E+hlrN7mrOaZFirLh9VpHztv7RY4HfmPBLdwv5zArWfW81Ggr7ATMD MYNEWONE"
}

#CHecking a SOurce availability of ZOnes

data "aws_availability_zones" "myzones" {
  state = "available"
}

#####################################


#############################

resource "aws_ebs_volume" "mynewcustomvolume" {
  availability_zone = "us-east-1a"
  size              = 8

  tags = {
    Name = "MYFIRSTVOLUME"
  }
}

##################################################



############################################


#################################################

resource "aws_ebs_snapshot" "mynewcustomsnapshot" {
  volume_id = aws_ebs_volume.mynewcustomvolume.id

  tags = {
    Name = "MYCUSTOM_SNAP"
  }
}

########################################################



########################################

resource "aws_ebs_snapshot_copy" "mycustomnewsnapcopy" {
  source_snapshot_id = aws_ebs_snapshot.mynewcustomsnapshot.id
  source_region      = "us-east-1"

  tags = {
    Name = "MYCUSTOM_Copy_Snap"
  }
}

###################################################

resource "aws_cloudtrail_event_data_store" "mycustomcloudtrail" {
  name = "mynew-customevent-data-store"
}

###################################################

resource "aws_iam_role" "mynewcustomrole" {
  name = "MYCUSTOMROLE1"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

############################################

resource "aws_iam_role_policy" "mynewrolepolicy" {
  name = "OWNCUSTOMPOLICY"
  role = aws_iam_role.mynewcustomrole.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

#Creating a bucket

resource "aws_s3_bucket" "mynewbucket" {
  bucket = "mynewcustombuck01"
   
    tags = {
    name = "MYNEWCUSTOMBUCKET"
 }
}

# Accessing a Bucket level acl

resource "aws_s3_bucket_acl" "mynewversionbuc" {
  bucket = aws_s3_bucket.mynewbucket.id
  acl    = "public-read"
   

}

##################################

resource "aws_flow_log" "mynewvpcflowlog" {
  log_destination      = aws_s3_bucket.mynewbucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main.id
}


############################
data "aws_subnet" "main1" {
  id = aws_subnet.main1.id
}

#Creating a ANother Bucket

resource "aws_s3_bucket" "mynewcustombucket" {
  bucket = "mynewsecondbucket"
}
 resource "aws_s3_bucket_policy" "allowing_access_to_account" {
  bucket = aws_s3_bucket.mynewcustombucket.id
  policy = data.aws_iam_policy_document.allowing_access_to_account.json
}

data "aws_iam_policy_document" "allowing_access_to_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["479348965617"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
  
   resources = [
      aws_s3_bucket.mynewcustombucket.arn,
      "${aws_s3_bucket.mynewcustombucket.arn}/*",
    ]
  }
}

