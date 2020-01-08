#!/bin/bash

echo "Install Java JDK 8"
sudo yum update -y 
sudo yum remove -y java
sudo yum install -y java-1.8.0-openjdk

echo "Install Docker engine"
sudo yum update -y
sudo yum install docker -y
sudo usermod -aG docker ec2-user
sudo service docker start

echo "Install git"
sudo yum install -y git

echo "Connecting to Master"
export JENKINS_URL="${jenkins_url}"
export JENKINS_USERNAME="${jenkins_username}"
export JENKINS_PASSWORD="${jenkins_password}"
export INSTANCE_NAME=$(curl -s 169.254.169.254/latest/meta-data/local-hostname)
export INSTANCE_IP=$(curl -s 169.254.169.254/latest/meta-data/local-ipv4)
export JENKINS_CREDENTIALS_ID="${jenkins_credentials_id}"

sleep 60

echo "Running curl command"
curl -v -u $JENKINS_USERNAME:$JENKINS_PASSWORD -d 'script=
import hudson.model.Node.Mode
import hudson.slaves.*
import jenkins.model.Jenkins
import hudson.plugins.sshslaves.SSHLauncher
DumbSlave dumb = new DumbSlave("'$INSTANCE_NAME'",
"'$INSTANCE_NAME'",
"/home/ec2-user",
"3",
Mode.NORMAL,
"slaves",
new SSHLauncher("'$INSTANCE_IP'", 22, "'$JENKINS_CREDENTIALS_ID'", "", null, null, "", null, 60, 3, null),
RetentionStrategy.INSTANCE)
Jenkins.instance.addNode(dumb)
' $JENKINS_URL/script