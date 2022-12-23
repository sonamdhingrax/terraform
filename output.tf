output "run_command" {
  value     = "aws ecs run-task --cluster ${aws_ecs_cluster.app_cluster.name} --task-definition ${aws_ecs_task_definition.app_task_definition.id}:${aws_ecs_task_definition.app_task_definition.revision} --network-configuration '{ \"awsvpcConfiguration\" : {\"subnets\":[\"${aws_subnet.subnets["sub-11"].id}\"],\"securityGroups\":[\"${aws_security_group.allow_http_https.id}\"], \"assignPublicIp\":\"ENABLED\"}}'"
  sensitive = true
}

output "instructions" {
  value = "terraform output -raw run_command"
}
