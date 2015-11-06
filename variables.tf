# ===========================================================================
# AWS Credentials
# 
# These values must be set either as env vars e.g.:
# 	`TF_VAR_aws_access_key`
# or set them when running terraform apply, e.g.:
# 	`terraform apply -var 'aws_access_key=foo'`
# or set them interactively when running terraform without vars.
# ===========================================================================

variable "aws_access_key" {}
variable "aws_secret_key" {}

# AWS .pem key name
variable "aws_key_name" {}

# AWS .pem key file abs path
variable "aws_key_file_path" {}

# ===========================================================================
# AWS Arch Config
# ===========================================================================

variable "aws_region" {
    default = "us-east-1"
}

variable "aws_instance_type" {
    default = "t2.micro"
}

variable "aws_availability_zone" {
    default = "us-east-1a"
}

variable "aws_amis" {
    default = {
        # Amazon Linux HVM (SSD) EBS-Backed 64-bit
        us-east-1 = "ami-e3106686"  # N. Virginia
        us-west-1 = "ami-cd3aff89"  # N. California
        us-west-2 = "ami-9ff7e8af"  # Oregon
    }
}

# ===========================================================================
# statsy config
# ===========================================================================

variable "statsy_docker_url" {
    default = "https://github.com/abelnation/statsy-docker.git"
}
