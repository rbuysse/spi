resource "tls_private_key" "foo" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "foo" {
  key_name   = "foo"
  public_key = tls_private_key.foo.public_key_openssh
}

resource "local_sensitive_file" "pem_file" {
  filename             = pathexpand("./ssh/foo.pem")
  file_permission      = "600"
  directory_permission = "700"
  content              = tls_private_key.foo.private_key_pem
}
