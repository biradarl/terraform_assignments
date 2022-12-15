provider "aws" {
    region = "us-east-1"
    access_key = "YourAccessKey"
    secret_key = "YourSecretKey"
}

data "aws_ami" "data_ami" {
    most_recent = true
    owners=["099720109477"]

    filter {
        name="name"
        values=["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
    
}


resource "aws_instance" "server_instance" {
    
    ami = data.aws_ami.data_ami.id
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = "YourKeyPairName"

}

output "ami_name" {
    value = data.aws_ami.data_ami
  
}