resource "aws_lb_target_group" "target_containers"{
    name = "target_containers"
    vpc_id = aws_vpc.CloudSave
    target_type = "ecs"
    port = 80
    protocol = "HTTP"

    health_check {
      port = 80
      protocol = "HTTP"
      interval = 30
      timeout = 5
      healthy_threshold = 3
      unhealthy_threshold = 2
    }
}