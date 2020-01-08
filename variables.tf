variable "aws_region" {
  description = "The aws region resources are created"
  default = "ap-southeast-2"
}

variable "keypair_name" {
  description = "Name of aws keypair, to be used in naming and tagging"
}

variable "hosted_zone_id" {
  description = "Id of the AWS Public Hosted Zone"
}

variable "jenkins_slave_instance_config" {
  type = "map"
  description = "The configuration variables used in creating the jenkins slave instance"
}

variable "slave_max_size" {
  description = "The max number of jenkins slaves required"
}

variable "slave_min_size" {
  description = "The min number of jenkins slaves required"
}

variable "slave_desired_capacity" {
  description = "The desired number of jenkins slaves required"
}

variable "bastion_sg_id" {
  description = "Security Group id of Bastion instance"
}

variable "master_sg_id" {
  description = "Security Group id of Master Jenkins instance"
}

variable "slave_sg_id" {
  description = "Security Group id of Slave Jenkins instance"
}

variable "jenkins_username" {
  description = "Username of the Jenkins user, the slaves will use for connecting with the master"
}       
    
variable "jenkins_password" {
  description = "Password of the Jenkins user, the slaves will use for connecting with the master"
}

variable "jenkins_credentials_id" {
  description = "ID of the SSH key configured"
}