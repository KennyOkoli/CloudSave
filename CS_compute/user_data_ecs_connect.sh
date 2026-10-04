#!/bin/bash

dnf update -y

echo "ECS_CLUSTER = cs_container_cluster" > /etc/ecs/ecs.config

dnf install -y amazon-ssm-agent
dnf install -y ecs-init

dnf systemctl start amazon-ssm-agent
dnf systemctl enable amazon-ssm-agent

dnf systemctl start --now ecs
dnf systemctl enable --now ecs