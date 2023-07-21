module "prod" {
  source = "../../tp-4"
  env = "prod"
  owner = "fsa-mod"
  instance_type = "t2.micro"
}