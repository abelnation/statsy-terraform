output "testserver_ip" {
    value = "${aws_instance.statsy_server.public_ip}"
}