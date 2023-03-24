resource "aws_instance" "foo" {
  ami                         = data.aws_ami.amazon_linux.id
  associate_public_ip_address = "true"
  instance_type               = "t2.micro"
  iam_instance_profile        = aws_iam_instance_profile.profile.name
  key_name                    = "foo"
  subnet_id                   = aws_subnet.subnet.id
  vpc_security_group_ids      = [aws_security_group.ec2.id]

  user_data = <<EOF
#!/bin/bash
# user_data script is modified from AWS console auto-generated content.
yum update -y
yum -y install amazon-efs-utils nfs-common
pip3 install awscli botocore 
file_system_id_1=${aws_efs_file_system.foo.id}
efs_mount_point_1=/data/test
mkdir -p "$${efs_mount_point_1}"
test -f "/sbin/mount.efs" && printf "\n$${file_system_id_1}:/ $${efs_mount_point_1} efs tls,_netdev\n" >> /etc/fstab || printf "\n$${file_system_id_1}.efs.us-east-2.amazonaws.com:/ $${efs_mount_point_1} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0\n" >> /etc/fstab
test -f "/sbin/mount.efs" && grep -ozP 'client-info]\nsource' '/etc/amazon/efs/efs-utils.conf'; if [[ $? == 1 ]]; then printf "\n[client-info]\nsource=liw\n" >> /etc/amazon/efs/efs-utils.conf; fi;
retryCnt=15; waitTime=30; while true; do mount -a -t efs,nfs4 defaults; if [ $? = 0 ] || [ $retryCnt -lt 1 ]; then echo File system mounted successfully; break; fi; echo File system not available, retrying to mount.; ((retryCnt--)); sleep $waitTime; done;
chown root:ec2-user /data
chown root:ec2-user /data/test
chmod g+w /data
chmod g+w /data/test
EOF

  root_block_device {
    volume_size = "40"
    volume_type = "gp2"
  }

  tags = {
    Name = "foo"
  }
}

data "aws_eip" "foo" {
  tags = {
    Project = "NetSPI_EIP"
  }
}

resource "aws_eip_association" "foo" {
  instance_id   = aws_instance.foo.id
  allocation_id = data.aws_eip.foo.id
}
