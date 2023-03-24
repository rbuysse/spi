resource "aws_efs_file_system" "foo" {
  availability_zone_name = data.aws_availability_zones.available.names[0]

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "foo"
  }
}

resource "aws_efs_mount_target" "foo" {
  file_system_id  = aws_efs_file_system.foo.id
  subnet_id       = aws_subnet.subnet.id
  security_groups = [aws_security_group.efs.id]
}
