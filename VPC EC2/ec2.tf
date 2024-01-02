resource "aws_instance" "ec2-tf" {
  for_each = aws_subnet.subnet-tf

  ami                    = var.ami
  instance_type          = var.instance_type[0]
  associate_public_ip_address = true
  subnet_id              = each.value.id
  vpc_security_group_ids = ["${aws_security_group.sg-tf.id}"]
  key_name               = "gowda"
}
# resource "tls_private_key" "my_key" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }
# resource "aws_key_pair" "my_key_pair" {
#   key_name   = "my-key-pair"  # Specify a unique name for your key pair
#   public_key = tls_private_key.my_key.public_key_openssh
# }