data "aws_ami" "ubuntu" {
    most_recent = true 
    owners = ["099720109477"]

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    filter {
        name = "root-device-type"
        values = ["ebs"]
    }

}

/*

data "aws_availability_zones" "zones" {
    state = "available"

    filter {
      name = "opt-in-status"
      values = ["opt-in-not-required"]
    }
  
}



data "aws_ec2_instance_types" "ins_type" {
    filter {
        name = "processor-info.supported-architecture"
        values = ["x86_64"]

    }  
    filter {
        name = "vcpu-info.default-vcpus"
        values = ["2"]
    }

    filter {
        name = "memory-info.size-in-mib"
        values = ["4096"]
    }
    filter {
    name   = "instance-type"
    values = ["c7*"] 
  }
}
*/