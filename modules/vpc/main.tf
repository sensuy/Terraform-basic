resource "aws_vpc" "new-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "${var.prefix}-vpc"
    }
  
}


data "aws_availability_zones" "available" {
    state = "available"
}

# output "az" {
#     value = "${data.aws_availability_zones.available.names}"
# }


resource "aws_subnet" "subnets" {
    count = 2
    availability_zone = data.aws_availability_zones.available.names[count.index]
    vpc_id = aws_vpc.new-vpc.id
    cidr_block = "10.0.${count.index}.0/24"
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.prefix}-subnet-${count.index + 1}"
    }
  
}

resource "aws_internet_gateway" "new-igw" {
    vpc_id = aws_vpc.new-vpc.id
    tags = {
        Name = "${var.prefix}-igw"
    }
}

resource "aws_route_table" "new-route-table" {
    vpc_id = aws_vpc.new-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.new-igw.id
    }
    tags = {
        Name = "${var.prefix}-route-table"
    }
}

resource "aws_route_table_association" "new-route-table-association" {
    count = 2
    route_table_id = aws_route_table.new-route-table.id
    subnet_id = aws_subnet.subnets.*.id[count.index]
  
}

# resource "aws_subnet" "new-subnet-2" {
#     availability_zone = "us-east-2c"
#     vpc_id     = aws_vpc.new-vpc.id
#     cidr_block = "10.0.1.0/24"
#     tags = {
#         Name = "${var.prefix}-subnet-2"
#     }
  
# }