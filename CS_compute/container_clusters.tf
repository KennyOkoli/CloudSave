/*resource "aws_ecs_cluster" "cs_container_cluster"{
    name = "cs_container_cluster"
    tags = {
      container_cluster = true
    }
}
# Orchestration | Compute 

# Things to code
# Name of the container


resource "aws_ecs_service" "cs_container_service"{
    name = "cs_container_service"
    cluster = aws_ecs_cluster.cs_container_cluster.id
    task_arn = aws_ecs_task_definition.cs_ecs_task_def.arn
    desired_count = 2
    #load_balancer {}
}


resource "aws_ecs_task_definition" "cs_ecs_task_def"{
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