# vpc to launch our instance into 

resource "aws_vpc" "flask-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "flask-app-vpc"
  } 
}


# An internet gateway to give our subnet access to the outside world:

resource "aws_internet_gateway" "flask-gateway" {
  vpc_id = aws_vpc.flask-vpc.id
  
    tags = {
      Name = "flask-app-internet-gateway"
  }
}

# grant the vpc internet access on its main route table:

resource "aws_route_table" "flask-rt" {
    vpc_id = aws_vpc.flask-vpc.id
 
   route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.flask-gateway.id
   }
 }

resource "aws_main_route_table_association" "flask-route" {
    vpc_id         = aws_vpc.flask-vpc.id
    route_table_id = aws_route_table.flask-rt.id
 } 

resource "aws_subnet" "flask-main" {
  vpc_id                  = aws_vpc.flask-vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
 
  tags = {
   Name  = "flask_subnet"
  } 
}
