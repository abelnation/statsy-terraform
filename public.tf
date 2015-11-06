
resource "aws_security_group" "web" {
    depends_on = ["aws_vpc.default"]
    name = "statsy-web"
    description = "Allow incoming/outgoing http, incoming ssh/icmp"
    vpc_id = "${aws_vpc.default.id}"

    # SSH from anywhere
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Serve http traffic
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Don't listen for https traffic
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # statsd
    ingress {
        from_port = 8125
        to_port = 8126
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # graphite
    ingress {
        from_port = 2003
        to_port = 2004
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 8000
        to_port = 8999
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # supervisord http dashboard
    ingress {
        from_port = 9001
        to_port = 9001
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # ICMP e.g. for ping
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "statsy-server AWS security group"
    }
}

resource "aws_instance" "statsy_server" {
    depends_on = ["aws_security_group.web", "aws_subnet.public"]

    ami = "${lookup(var.aws_amis, var.aws_region)}"
    instance_type = "${var.aws_instance_type}"
    availability_zone = "${var.aws_availability_zone}"

    key_name = "${var.aws_key_name}"
    security_groups = [ "${aws_security_group.web.id}" ]
    subnet_id = "${aws_subnet.public.id}"

    connection {
        user = "ec2-user"
        key_file = "${var.aws_key_file_path}"
    }

    provisioner "file" {
        source = "./files/"
        destination = "/tmp/docker"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo yum update -y",
            "sudo yum install -y docker",
            "sudo service docker start",
            "sudo mv /tmp/docker /usr/local/src/",
            "sudo /usr/local/src/docker/build",
            "sudo /usr/local/src/docker/start"
        ]
    }

    tags {
        Name = "statsy-server"
    }
}