data "aws_instance" "jenkins-master" {

  filter {
    name   = "tag:Name"
    values = ["jenkins_master"]
  }
}

data "template_file" "user_data_slave" {
  template = "${file("scripts/join-cluster.sh.tpl")}"

  vars {
    jenkins_url            = "http://${data.aws_instance.jenkins-master.private_ip}:8080"
    jenkins_username       = "${var.jenkins_username}"
    jenkins_password       = "${var.jenkins_password}"
    jenkins_credentials_id = "${var.jenkins_credentials_id}"
  }
}

// Jenkins slaves launch configuration
resource "aws_launch_configuration" "jenkins_slave_launch_conf" {
  name            = "jenkins_slaves_config"
  image_id        = "${var.jenkins_slave_instance_config["ami"]}"
  instance_type   = "${var.jenkins_slave_instance_config["type"]}"
  key_name        = "${var.keypair_name}"
  security_groups = ["${var.slave_sg_id}"]
  user_data       = "${data.template_file.user_data_slave.rendered}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "${var.jenkins_slave_instance_config["root_volume_size"]}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "jenkins_slaves" {
  name                 = "jenkins_slaves_asg"
  launch_configuration = "${aws_launch_configuration.jenkins_slave_launch_conf.name}"
  vpc_zone_identifier  = ["${data.aws_subnet_ids.test_jenkins_priv_subnets.ids}"]
  min_size             = "${var.slave_min_size}"
  max_size             = "${var.slave_max_size}"

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "jenkins_slave"
    propagate_at_launch = true
  }
}