output "sensor_instance_id" {
  value = aws_instance.corelight_sensor.id
}

output "management_security_group_id" {
  value = aws_security_group.management_sg.id
}

output "monitoring_security_group_id" {
  value = aws_security_group.monitoring_sg.id
}
