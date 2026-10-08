#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

dnf update -y


dnf install docker -y
systemctl start docker
systemctl enable docker

sleep 60

mkdir -p /etc/ecs
echo "ECS_CLUSTER=cs_container_cluster" > /etc/ecs/ecs.config
dnf install -y ecs-init
systemctl enable ecs
systemctl start ecs

dnf install -y amazon-ssm-agent
systemctl start amazon-ssm-agent
systemctl enable amazon-ssm-agent

dnf install -y mariadb105
systemctl start mariadb105
systemctl enable mariadb105
