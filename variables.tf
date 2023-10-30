variable "benches_access" {
  type = map(string)
  default = {
    ingress_ip = "23.126.118.246/32"
    user       = "ec2-user"
    keypair    = "kp_benches"
    region     = "us-east-2"
    az         = "us-east-2c"
    vpc_block  = "172.30.30.0/27"
    net_block  = "172.30.30.0/28"
  }
}

variable "benches_plan" {
  type = list(object({
    name           = string
    desc           = string
    ami            = string
    instance_type  = string
    user           = string
    keypair        = string
    bench_script   = string
    ebs_volumes    = list(object(
      {
        name = string
        size = number
        type = string
      }
      ))
  }))
  default = [
    {
      name          = "basic_nvme"
      desc          = "Amazon Linux 2 Kernel 5.10 AMI 2.0.20230926.0 x86_64 HVM gp2 nvme"
      ami           = "ami-0aec300fa613b1c92"
      instance_type = "t3.micro"
      user          = "ec2-user"
      keypair       = "kp_benches"
      bench_script  = "basic_nvme_cfg.sh"
      ebs_volumes = [
        {
          name        = "/dev/sdb" # actually /dev/nvme1n1, see https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/device_naming.html
          size = 5
          type = "gp3"
        },
        {
          name        = "/dev/sdc" # /dev/nvme2n1
          size = 5
          type = "gp2"
        }
      ]
    },
    {
      name          = "basic_ssd"
      desc          = "Amazon Linux 2 Kernel 5.10 AMI 2.0.20230926.0 x86_64 HVM gp2 nvme"
      ami           = "ami-0aec300fa613b1c92"
      instance_type = "t2.micro"
      user          = "ec2-user"
      keypair       = "kp_benches"
      bench_script  = "basic_ssd_cfg.sh"
      ebs_volumes = [
        {
          name        = "/dev/xvdb"
          size = 1
          type = "gp2"
        },
        {
          name        = "/dev/xvdc"
          size = 1
          type = "gp2"
        }
      ]
    }
  ]
}
