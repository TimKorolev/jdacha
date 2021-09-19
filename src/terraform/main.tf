resource "aws_instance" "this" {
  ami = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [
    aws_security_group.youtrack_perf_security_group.id]
  key_name = aws_key_pair.key.key_name
  availability_zone = var.availability_zone

  root_block_device {
    volume_size = 8
  }

  provisioner "local-exec" {
    command = "chmod 400 ${var.os}_${var.os_type}_key.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt -y install openjdk-11-jre-headless"
    ]

    connection {
      type = "ssh"
      host = self.public_ip
      user = var.user
      private_key = tls_private_key.aws_key.private_key_pem
    }
  }

  provisioner "local-exec" {
    command = "scp -oStrictHostKeyChecking=no -i ${var.os}_${var.os_type}_key.pem dacha-all.jar ${var.user}@${aws_instance.this.public_dns}:/home/${var.user}/"
  }

  provisioner "remote-exec" {
    inline = [
      "java -jar dacha-all.jar &"
    ]

    connection {
      type = "ssh"
      host = self.public_ip
      user = var.user
      private_key = tls_private_key.aws_key.private_key_pem
    }
  }

  tags = {
    Name = "${var.os} ${var.os_type}"
    owner = var.owner
  }
}

resource "tls_private_key" "aws_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "key" {
  key_name = "${var.os}_${var.os_type}_key"
  public_key = tls_private_key.aws_key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.aws_key.private_key_pem}' >> ${var.os}_${var.os_type}_key.pem"
  }

}
