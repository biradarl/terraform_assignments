#creating VPC

resource "aws_vpc" "ec2_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      "Name" = "ec2_vpc"
    }
  
}


#Creating subnet
 resource "aws_subnet" "ec2_subnet" {
    vpc_id = aws_vpc.ec2_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    tags = {
      "Name" = "ec2_subnet"
    }
   
 }


 #Creating intergate gateway

 resource "aws_internet_gateway" "ec2_gw" {
    vpc_id = aws_vpc.ec2_vpc.id
    tags = {
      "Name" = "ec2_gw"
    }
   
 }

 #Creating route table

 resource "aws_route_table" "ec2_route_table" {
    vpc_id = aws_vpc.ec2_vpc.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.ec2_gw.id
    }

    tags = {
      "name" = "ec2_route_table"
    }
   
 }

 #creating route table association 

 resource "aws_route_table_association" "ec2_route_association" {
    subnet_id = aws_subnet.ec2_subnet.id
    route_table_id = aws_route_table.ec2_route_table.id
   
 }
 
#Creating IAM role 

resource "aws_iam_role" "ec2_iam_role" {
  name = "ec2_iam_role"

  assume_role_policy = "${file("ec2_assume_role_policy_file.json")}"
}

#Creating IAM policy and attaching it to the role 
  
resource "aws_iam_role_policy" "ec2_iam_policy" {
  name = "ec2_iam_policy"
  role = aws_iam_role.ec2_iam_role.id
  policy = "${file("ec2_iam_policy_file.json")}"
}

#attaching the role to instance profile

resource "aws_iam_instance_profile" "ec2_instance_profile" {

  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_iam_role.name
  
}


 
 #creating ec2 instance and attaching the profile
 resource "aws_instance" "ec2_instance" {
    
    ami = data.aws_ami.data_ami.id
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = "terraform_key"
    subnet_id = aws_subnet.ec2_subnet.id
    iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

    tags = {
      "Name" = "ec2_instance"
    }

}