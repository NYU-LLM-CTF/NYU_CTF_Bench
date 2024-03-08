# Variables
variable "profile" {

}

variable "region" {
    default = "us-east-1"
}

variable "userIP" {
    
}

#Provider
provider "aws" {
    profile = var.profile
    region = "us-east-1"
}

#AWS Key-Pair
resource "aws_key_pair" "example" {
    key_name = "exkey"
    public_key = file("./terraform.pub")
}

#IAM Users
resource "aws_iam_user" "bourne" {
    name = "bourne"
}

resource "aws_iam_user" "nikolas" {
    name = "nikolas"
}

#IAM Users Access-Keys
resource "aws_iam_access_key" "bourne-keys" {
    user = aws_iam_user.bourne.name
}

resource "aws_iam_access_key" "nikolas-keys" {
    user = aws_iam_user.nikolas.name
}

#IAM Users' Policies
resource "aws_iam_user_policy" "bourne-policy" {
  name = "bourne-policy"
  user = aws_iam_user.bourne.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy" "nikolas-policy" {
  name = "nikolas-policy"
  user = aws_iam_user.nikolas.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "iam:ListUsers",
                "s3:ListAllMyBuckets",
                "dynamodb:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


#DynamoDB
resource "aws_dynamodb_table" "bourne-keys-dynamo" {
    name = "bourne-keys-dynamo"
    read_capacity = 5
    write_capacity = 5
    hash_key = "Username"
    attribute {
        name = "Username"
        type = "S"
    }
}

resource "aws_dynamodb_table_item" "bourne-access-keys" {
    table_name = aws_dynamodb_table.bourne-keys-dynamo.name
    hash_key = aws_dynamodb_table.bourne-keys-dynamo.hash_key
    item = <<EOF
    {
        "Username": {"S": "bourne"},
        "AccessKeyID": {"S": "${aws_iam_access_key.bourne-keys.id}"},
        "SecretKey": {"S": "${aws_iam_access_key.bourne-keys.secret}"}
    }
    EOF
}

#IAM Role
resource "aws_iam_role" "access-ddb" {
    name = "access-ddb"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow"
        }
    ]
}
EOF
}

#IAM Policy to access DynamoDB
resource "aws_iam_policy" "access-ddb-policy" {
    name = "access-ddb-policy"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": [
            "dynamodb:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
    }
    ]
}
EOF
}

#IAM Role Policy Attachement
resource "aws_iam_role_policy_attachment" "access-ddb-rp-attachment" {
    role = aws_iam_role.access-ddb.name
    policy_arn = aws_iam_policy.access-ddb-policy.arn
}

#IAM Instance Profile
resource "aws_iam_instance_profile" "access-ddb-instance-prof" {
    name = "access-ddb-instance-prof"
    role = aws_iam_role.access-ddb.name
}

#S3 Bucket
resource "aws_s3_bucket" "secret-bucket" {
    force_destroy = true
}

resource "aws_s3_bucket_acl" "secret-bucket-acl" {
    bucket = aws_s3_bucket.secret-bucket.id
    acl = "private"
}

resource "aws_s3_bucket_object" "top-secret-data" {
    bucket = aws_s3_bucket.secret-bucket.id
    key = "top-secret-data.txt"
    source = "../stuff/top-secret-data.txt"
}

#VPC
resource "aws_vpc" "vpc-server" {
  cidr_block = "10.10.0.0/16"
  enable_dns_hostnames = true
}

#Internet Gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = "${aws_vpc.vpc-server.id}"
}

#Subnet
resource "aws_subnet" "public-subnet" {
  availability_zone = "${var.region}a"
  cidr_block = "10.10.10.0/24"
  vpc_id = "${aws_vpc.vpc-server.id}"
}

#Subnet Routing Table
resource "aws_route_table" "subnet-route-table" {
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.internet-gateway.id}"
  }
  vpc_id = "${aws_vpc.vpc-server.id}"
}

#Route Association Table
resource "aws_route_table_association" "route-association" {
  subnet_id = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.subnet-route-table.id}"
}

#Security Group
resource "aws_security_group" "security-group" {
  name = "security-group"
  vpc_id = "${aws_vpc.vpc-server.id}"
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["${var.userIP}"]
  }
  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [
        "0.0.0.0/0"
      ]
  }
}

#EC2 Instance
resource "aws_instance" "openworld-server" {
    key_name = aws_key_pair.example.key_name
    ami = "ami-2757f631"
    availability_zone = "us-east-1a"
    instance_type = "t2.micro"
    iam_instance_profile = aws_iam_instance_profile.access-ddb-instance-prof.name
    associate_public_ip_address = true
    subnet_id = "${aws_subnet.public-subnet.id}"
    vpc_security_group_ids = ["${aws_security_group.security-group.id}"]
    user_data = <<-EOF
        #!/bin/bash
        apt-get update
        sudo adduser claymore
        echo "claymore:MyChemicalRomance" |sudo chpasswd
        sudo echo "claymore ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-cloud-init-users
        sudo sed -i '/PasswordAuthentication no/c\PasswordAuthentication yes' /etc/ssh/sshd_config
        sudo service sshd restart 

        sudo apt-get install -y apache2
        sudo chmod 777 /var/www/html/
        sudo rm /var/www/html/index.html
        sudo apt-get install -y php libapache2-mod-php php-mcrypt
        sudo echo "claymore:MyChemicalRomance" >> /var/www/html/credentials.txt
        sudo echo "The answer for exercise 1 is SGF6UHJvbmV7WTB1XzRyM19uMHRfNTBfYjRkfQ==" >> /home/secret_file.txt
        sudo echo ${base64encode(file("../webapp/index.php"))} | base64 --decode > /var/www/html/index.php
        sudo echo ${base64encode(file("../webapp/login.php"))} | base64 --decode > /var/www/html/login.php
        sudo echo ${base64encode(file("../webapp/welcome.php"))} | base64 --decode > /var/www/html/welcome.php
        sudo echo ${base64encode(file("../webapp/notwelcome.php"))} | base64 --decode > /var/www/html/notwelcome.php
        sudo systemctl restart apache2
        EOF

    root_block_device {
        delete_on_termination = true
    }

}

#Outputs
output "ip" {
    value = "${aws_instance.openworld-server.public_ip}/index.php"
}

output "nikola-access-key-id" {
    value = aws_iam_access_key.nikolas-keys.id
}

output "nikolas-secret-key" {
    value = nonsensitive(aws_iam_access_key.nikolas-keys.secret)
}
