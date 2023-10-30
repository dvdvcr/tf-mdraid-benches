terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.21.0"
    }
  }

  required_version = ">= 1.4.0"
}

provider "aws" {
  region = "us-east-2"
}
 
# fix the ssh key
 
module "bench_runners" {
  source = "./modules/bench_runner"

  for_each = { for plan in var.benches_plan : plan.name => plan }

  name           = each.value.name
  desc           = each.value.desc
  subnet         = aws_subnet.subnet_benches.id
  sgs            = [aws_security_group.sg_benches.id]
  user           = each.value.user
  keypair        = each.value.keypair
  privkey        = each.value.privkey
  ami            = each.value.ami
  instance_type  = each.value.instance_type
  bench_script   = each.value.bench_script
  ebs_volumes    = [
    for blkdev in each.value.ebs_volumes: {
      name = blkdev.name
      size = blkdev.size
      type = blkdev.type
    }
  ]
}

output "ssh_cmds" {
  value = {
    for k, v in module.bench_runners :
    k => v.ssh_cmd
  }
}
