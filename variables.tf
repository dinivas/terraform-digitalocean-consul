variable "enable_consul_cluster" {
  type    = string
  default = "1"
}
variable "project_name" {
  type    = string
}

variable "consul_cluster_name" {
  description = "The Consul cluster name"
  type        = string
}

variable "consul_cluster_domain" {
  description = "The Consul cluster domain name"
  type        = string
}

variable "consul_cluster_datacenter" {
  description = "The Consul cluster domain name"
  type        = string
}

variable "consul_cluster_availability_zone" {
  description = "The availability zone"
  type        = string
  default     = "null"
}

variable "consul_cluster_network_name" {
  description = "The Network Name of the cluster"
  type        = string
}

variable "consul_cluster_security_group_rules" {
  type        = list(map(any))
  default     = []
  description = "The definition os security groups to associate to instance. Only one is allowed"
}

variable "consul_cluster_security_groups_to_associate" {
  type        = list(string)
  default     = []
  description = "List of existing security groups to associate to consul instances."
}

variable "consul_server_instance_count" {
  description = "Number of Consul server in the cluster"
  default     = 1
}

variable "consul_server_image_name" {
  description = "The image name of the consul server instance"
  type        = string
}

variable "consul_server_flavor_name" {
  description = "The flavor name of the consul server instance"
  type        = string
}

variable "consul_client_instance_count" {
  description = "Number of Consul client in the cluster"
  default     = 0
}

variable "consul_client_image_name" {
  description = "The image name of the consul client instance"
  type        = string
}

variable "consul_client_flavor_name" {
  description = "The flavor name of the consul client instance"
  type        = string
}

variable "generic_user_data_file_url" {
  type    = string
  default = "https://raw.githubusercontent.com/dinivas/terraform-shared/master/templates/generic-user-data.tpl"
}

variable "execute_on_destroy_server_instance_script" {
  type    = list(string)
  default = ["consul leave"]
}

variable "execute_on_destroy_client_instance_script" {
  type    = list(string)
  default = ["consul leave"]
}

variable "ssh_via_bastion_config" {
  description = "config map used to connect via bastion ssh"
  default     = {}
}

variable "host_private_key" {}
variable "bastion_private_key" {}

variable "do_api_token" {
  type = string
}