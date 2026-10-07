#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

dnf update -y

echo "ECS_CLUSTER = cs_container_cluster" > /etc/ecs/ecs.config

dnf install -y amazon-ssm-agent
dnf install -y ecs-init
dnf install -y mariadb105
dnf amazon-linux-extra install docker -y

systemctl start amazon-ssm-agent
systemctl enable amazon-ssm-agent

systemctl start --now ecs
systemctl enable --now ecs

systemctl start mariadb105
systemctl enable mariadb105

systemctl start docker
systemctl enable docker