#
# This is a TEST for the modules in terraform
# that will create 54 resources. (vpc, subnets, nat, in two regions and multiple azs)
#

variable "AWS_REGION" { default = "eu-west-1" }

# Lets create a VPC and IGW

module "vpc_me" {
  source     	= "github.com/cascompany/terraform-modules/vpc_me/"
  NAME		= "myVPC"
  VPC_CIDR	= "10.1.0.0/16"
  AWS_REGION	= "eu-west-1"
  TAGS { "Terraform" = "true" }
}

# Lets create all network and nat configs.

module "subnet_me" {
  source      = "github.com/cascompany/terraform-modules/subnet_me/"
  NAME        = "prod-public"
  CIDRS       = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  NAME_PRIV   = "prod-private"
  CIDRS_PRIV  = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]  
  AZS         = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  VPC_ID      = "${module.vpc_me.vpc_id}"
  IGW_ID      = "${module.vpc_me.vpc_igw}"
  TAGS { "Terraform" = "true"  }
}

# Now, Lets create a Another VPC and Networks in USA, using most defaults.

module "vpc_me_us" {
  source        = "github.com/cascompany/terraform-modules/vpc_me/"
  NAME          = "SecondVPC"
  AWS_REGION    = "us-west-1"
}
module "subnet_me_us" {
  source      = "github.com/cascompany/terraform-modules/subnet_me/"
  NAME        = "usa-public"
  NAME_PRIV   = "usa-private"
  AZS         = ["${data.aws_availability_zones.available.names}"]
}

