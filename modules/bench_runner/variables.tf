variable "name" {
    type = string
    description = "Name"
}

variable "desc" {
    type = string
    description = "Description"
}

variable "subnet" {
    type = string
    description = "Subnet"
}

variable "sgs" {
    type = list(string)
    description = "Security Group(s)"
}

variable "user" {
    type = string
    description = "Default AMI user account"
}

variable "keypair" {
    type = string
    description = "KP for authorized_keys and provisioners"
}

variable "privkey" {
    type = string
    description = "Local path to private key for use by provisioners"
}

variable "ami" {
    type = string
    description = "AMI ID"
}

variable "instance_type" {
    type = string
    description = "Instance Type"
}

variable "bench_script" {
    type = string
    description = "Local path to script that handles mdraid and benchmarks"
}

variable "ebs_volumes" {
  description = "List of EBS volumes to attach to the EC2 instances"
  type        = list(object({
    name = string
    size = number
    type = string
  }))
}