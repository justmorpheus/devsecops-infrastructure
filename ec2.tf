resource "tls_private_key" "oskey" {
  algorithm = "RSA"
}

resource "local_file" "myterrakey" {
  content  = tls_private_key.oskey.private_key_pem
  filename = "devsecops.pem"
}

resource "aws_key_pair" "key121" {
  key_name   = "devsecops"
  public_key = tls_private_key.oskey.public_key_openssh
}

resource "aws_instance" "mytfinstance" {
  ami           = "ami-017fecd1353bcc96e" #ubuntu 22
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key121.key_name
  subnet_id = element(aws_subnet.prod-subnet-public-1.*.id, count.index)    
  vpc_security_group_ids = [aws_security_group.demo-devsecops.id]
  
  count = 3

  tags = {
    Name = "devsecops-prod-${count.index}"
  }

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh"
    ]
  }

  connection {
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = tls_private_key.oskey.private_key_pem
    host        = aws_instance.mytfinstance[0].public_ip
  }
}
