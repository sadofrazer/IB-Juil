module "dev" {
  source = "../../tp-4"
  env = "dev"
  owner = "fsa-mod"
  instance_type = "t2.nano"
}


module "dev1" {
  source = "../../tp-4"
  env = "dev1"
  owner = "fsa-mod"
  instance_type = "t2.nano"
}


output "ip-ec2-dev" {
  value = module.dev.my-eip
}


output "ip-ec2-dev1" {
  value = module.dev1.my-eip
}