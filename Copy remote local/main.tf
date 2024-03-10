resource "aws_instance" "ec2" {
  ami           = "ami-0287a05f0ef0e9d9a"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = ["sg-0b5c4ec4808949635"] 
  subnet_id              = "subnet-05feb5f6a1540579a"  
  key_name = "gowda"
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./gowda.pem")
    host        = self.public_ip
  }
  provisioner "file" {
    source = "./sample.txt"
    destination = "/home/ubuntu/"
  }
    provisioner "local-exec" {
    command = "echo ${self.private_ip} >> ./private_ips.txt"
  }
}


