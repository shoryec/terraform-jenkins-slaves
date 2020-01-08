terragrunt = {
  remote_state {
    backend = "s3"
    config {
    bucket         = "test-jenkins-shorye"
    region         = "ap-southeast-2"
    key            = "jenkins-slave/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
    profile        = "personal"
    }
  }
}

aws_region = "ap-southeast-2"
keypair_name = "test-jenkins"
hosted_zone_id = "Z1G6V4NYWUKXJY"

jenkins_slave_instance_config = {
    ami                     = "ami-07cc15c3ba6f8e287"
    type                    = "t2.micro"
    root_volume_size        = "30"
    az                      = "ap-southeast-2a"
}
slave_min_size = 3
slave_max_size = 6
slave_desired_capacity = 3

bastion_sg_id = "sg-0bdaa1a16a5a3031a"
master_sg_id  = "sg-06643023230350b54"
slave_sg_id   = "sg-034caef77febff1fd"
jenkins_username = "admin"
jenkins_password = "password"
jenkins_credentials_id = "jenkins-slave"