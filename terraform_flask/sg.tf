resource "aws_security_group" "flask-sg" {
  name    =  "flask_security_group"
  description = "Flask Application security group"
  vpc_id       = aws_vpc.flask-vpc.id

# Allow outbound internet access.
  

egress {
  from_port    = 0
  to_port      = 0
  protocol     = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}


# Allow  inbound internet access
 
ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks =  ["0.0.0.0/0"]
}

ingress {
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks =  ["0.0.0.0/0"]
}

}

# create a key pair that will be assigned to our instance

resource "aws_key_pair" "flask" {
  key_name  = "flask-app"
  public_key = file(var.public_key_path)
}
 data "aws_ami" "app_ami" {
   most_recent = true
   owners      = ["amazon"]

   filter {
     name    = "name"
     values  = ["amzn2-ami-hvm*"]
}
}

resource "aws_instance" "flask-instance" {
  ami                              = data.aws_ami.app_ami.id
  instance_type                    = "t2.micro"
  key_name                         = "flask-app"
  subnet_id                        =  aws_subnet.flask-main.id
  associate_public_ip_address      =  true
  user_data                        = file("remote.sh")
  tags = {
    name = "flask-app-instance"
}

}

# Associate sg with the instance
 
resource "aws_network_interface_sg_attachment" "flask-sg_attachment" {
  security_group_id  = aws_security_group.flask-sg.id
  network_interface_id = aws_instance.flask-instance.primary_network_interface_id
}
