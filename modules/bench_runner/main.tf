resource "aws_instance" "ec2_bench_box" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet
  security_groups             = var.sgs
  associate_public_ip_address = true
  key_name                    = var.keypair

  tags = {
    Name = var.name
    Description = var.desc
  }

  connection {
    type        = "ssh"
    user        = var.user
    private_key = var.privkey
    host        = aws_instance.ec2_bench_box.public_ip
  }

  provisioner "file" {
    source = "./bin/${var.bench_script}"
    destination = "/tmp/${var.bench_script}"
  }

  provisioner "remote-exec" {
    inline = [
       "chmod +x /tmp/${var.bench_script}",
       "sudo /tmp/${var.bench_script}"
    ]
  }

  dynamic ebs_block_device {
    for_each = var.ebs_volumes
    content {
      device_name = ebs_block_device.value.name
      volume_size = ebs_block_device.value.size
      volume_type = ebs_block_device.value.type
    }
  }

}

output "ssh_cmd" {
  value = "ssh ec2-user@${aws_instance.ec2_bench_box.public_ip}"
}