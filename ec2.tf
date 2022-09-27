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

variable "instance_names" {
  default = ["devsecops-prod", "devsecops-jenkins",
  "devsecops-vul_vault"]
}

variable "hostnames" {
  default = ["script_prod.sh", "script_jenkins.sh",
  "script_vm_valut.sh"]
}

data "template_file" "user-data" {
  count    = "${length(var.hostnames)}"
  template = "${file("${element(var.hostnames, count.index)}")}"
}


resource "aws_instance" "mytfinstance" {
  count = 3
  ami           = "ami-017fecd1353bcc96e" #ubuntu 22
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key121.key_name
  subnet_id = element(aws_subnet.prod-subnet-public-1.*.id, count.index)    
  vpc_security_group_ids = [aws_security_group.demo-devsecops.id]
  user_data    = "${element(data.template_file.user-data.*.rendered, count.index)}"

  

  tags = {
    Name = "${element(var.instance_names, count.index)}"
  }



  
}
