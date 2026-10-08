/*resource "aws_ecs_cluster" "cs_container_cluster"{
    name = "cs_container_cluster"
    tags = {
      container_cluster = true
    }
}

resource "aws_ecs_service" "cs_container_service"{
    name = "cs_container_service"
    cluster = aws_ecs_cluster.cs_container_cluster.id
    task_definition = aws_ecs_task_definition.cs_ecs_task_def.arn
    desired_count = 2
    launch_type = "EC2"

    load_balancer {
       target_group_arn = aws_lb_target_group.target_containers.arn
       container_name = "cloudsave_build"
       container_port = 4000
    }
}


resource "aws_ecs_task_definition" "cs_ecs_task_def"{
    family = "cloudsave_app"
    network_mode = "host"
    requires_compatibilities = ["EC2"]
    cpu = 512
    memory = 1024
    execution_role_arn = aws_iam_role.ecs_exec_role.arn
    
    container_definitions = jsonencode([
        {
            name = "cloudsave_build"
            image = "${aws_ecr_repository.cloudsaveRegistry.repository_url}:latest"
            portMappings=[{
                containerPort = 4000
                hostPort = 4000
                protocol = "tcp"
            }]
            essential = true
        }
    ])
    /*placement_constraints{
        type = "distinctInstance"
    }
}
*/