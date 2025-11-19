#dev
include "root" {
  path = "../../../root.hcl"
}

terraform {
  source = "../../../modules/eks"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs = {
    vpc_id            = "mock-vpc-id"
    public_subnet_ids = ["mock-subnet-a", "mock-subnet-b"]
  }
}

inputs = {
  environment              = "dev"
  region                   = "us-east-1"
  eks_version              = "1.28"
  eks_node_sizes           = ["t3.medium"]
  vpc_id                   = dependency.vpc.outputs["vpc_id"]
  subnet_ids               = dependency.vpc.outputs["public_subnet_ids"]
  control_plane_subnet_ids = dependency.vpc.outputs["public_subnet_ids"]
}
