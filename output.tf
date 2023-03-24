output "s3_bucket_id" {
  value = aws_s3_bucket.foo.id
}

output "efs_volume_id" {
  value = aws_efs_file_system.foo.id
}

output "ec2_instance_id" {
  value = aws_instance.foo.id
}

output "ec2_sg_id" {
  value = aws_security_group.ec2.id
}

output "efs_sg_id" {
  value = aws_security_group.efs.id
}

output "subnet_id" {
  value = aws_subnet.subnet.id
}

output "elastic_ip" {
  value = data.aws_eip.foo.public_ip
}
