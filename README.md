# terraform-jenkins-slaves

Code developed to provision jenkins slave instaces of the mock enterprise jenkins system

This repository stores terraform code which provisions the following resources:

- Autoscaling group and launch configuration
- Cloudwatch Metrics and Alarms
- Jenkins Slave Cluster Auto-Discovery script

## Prerequisites

- Jenkins master needs to be configured and running
- CSRF protection need to be disabled on the Jenkins master
- The ssh keypair used on the agents needs to be added to Jenkins' global credentials
