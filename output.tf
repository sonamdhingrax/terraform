output "run_command" {
  value = "aws ecs run-task --cluster ${aws_ecs_cluster.openstor_cluster.name} --task-definition ${aws_ecs_task_definition.openstor_task_definition.id}:${aws_ecs_task_definition.openstor_task_definition.revision} --network-configuration '{ \"awsvpcConfiguration\" : {\"subnets\":[\"${aws_subnet.subnets["sub-11"].id}\"],\"securityGroups\":[\"${aws_security_group.allow_http_https.id}\"], \"assignPublicIp\":\"ENABLED\"}}'"
}
