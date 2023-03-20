data "aws_security_groups" "my_sec_group" {
  tags = {
    Name = "MySecurityGroup"
  }
}

data "aws_subnet" "CZ-Training_PrivateSubnet" {
  tags = {
    Name = "CZ-Training_PrivateSubnet"
  }
}
  
data "aws_ami" "my_ami" {
  most_recent = true
  owners      =["amazon"]
 
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
 
resource "aws_instance" "data_instance" {
  ami                    = data.aws_ami.my_ami.id
  instance_type          = "t2.micro"
  key_name               = "chenna-key"
  vpc_security_group_ids = data.aws_security_groups.my_sec_group.ids
  # specify the subnet_id here
  subnet_id              = data.aws_subnet.CZ-Training_PrivateSubnet.id

tags = {
Name = "newinstance"
}
}
