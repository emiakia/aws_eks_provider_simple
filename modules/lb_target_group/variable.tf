variable "lbtg_name" {}
variable "lbtg_port" {}
variable "lbtg_protocol" {}
variable "lbtg_vpc_id" {}
variable "lbtg_tags" {}
#health_check
variable "lbtg_health_check_path" {}
variable "lbtg_health_check_protocol" {}
variable "lbtg_health_check_matcher" {}
variable "lbtg_health_check_interval" {}
variable "lbtg_health_check_timeout" {}
variable "lbtg_healthy_threshold" {}
variable "lbtg_unhealthy_threshold" {}