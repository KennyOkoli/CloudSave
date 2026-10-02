/*resource "aws_ecs_cluster" "cs_container_cluster"{
    name = "cs_container_cluster"
    tags = {
      container_cluster = true
    }
}
# Orchestration | Compute 

# Things to code
# Name of the container

/*
resource "aws_ecs_service" "cs_comtainer_service"{
    name = "cs_container_service"
    cluster = aws_ecs_cluster.cs_container_cluster.id
    #task_arn
    desired_count = 2
    #load_balancer {}
}


# For scaling
# Things to compute
# container id
# task arn
# desired count
# load balancing
# placement_groups


resource "aws_ecs_task_definition" "cs_container_task_mng"{
    family = "whole_app"
    container_definitions = jsonencode([
        {
            name = "cs_image"
            image = "cs_docker_source"
            cpu = 800
            memory = 800
        }
    ])
}
*/