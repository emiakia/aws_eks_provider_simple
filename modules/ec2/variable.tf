variable "ami" {}
variable "instance_type" {}
variable "security_groups" { type = list(string) }
variable "user_data" {
  type = string
}
variable "key_name" {}
variable "created_by" {}
variable "tags" { type = map(string) }
variable "machine_name" {}
variable "count_instance" {
  description = "Number of EC2 instances to create"
  type        = number
}
