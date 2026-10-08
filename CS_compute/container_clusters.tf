resource "aws_ecs_cluster" "cs_container_cluster"{
    name = "cs_container_cluster"
    tags = {
      container_cluster = true
    }
}

/*
resource "aws_ecs_service" "cs_container_service"{
    name = "cs_container_service"
    cluster = aws_ecs_cluster.cs_container_cluster.id
    task_arn = aws_ecs_task_definition.cs_ecs_task_def.arn
    desired_count = 2

    load_balancer {
       target_group_arn = aws_lb_target_group.target_containers.arn
    }
}

/**/

/*resource "aws_ecs_task_definition" "cs_ecs_task_def"{
    family = "whole_app"
    container_definitions = jsonencode([
        {
            name = "cs_image"
            image = "cs_docker_source"
            cpu = 800
            memory = 800
        }
    ])
}*/
