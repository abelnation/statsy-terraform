output "testserver_ip" {
    value = "${aws_instance.testserver.public_ip}"
}