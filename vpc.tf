
resource "aws_vpc" "default" {
    cidr_block = "10.0.0.0/20"

    tags {
        Name = "statsy-vpc"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "statsy-gateway"
    }
}

resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "10.0.0.0/24"
    availability_zone = "${var.aws_availability_zone}"
    map_public_ip_on_launch = true
    tags {
        Name = "statsy-public-subnet"
    }
}

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.public.id}"
}