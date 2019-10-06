variable "enable_consul_cluster" {
  type    = "string"
  default = "1"
}

variable "consul_cluster_name" {
  description = "The Consul cluster name"
  type        = "string"
}

variable "consul_cluster_domain" {
  description = "The Consul cluster domain name"
  type        = "string"
}

variable "consul_cluster_datacenter" {
  description = "The Consul cluster domain name"
  type        = "string"
}

variable "consul_cluster_availability_zone" {
  description = "The availability zone"
  type        = "string"
  default     = "null"
}

variable "consul_cluster_network_id" {
  description = "The Network Id of the cluster"
  type        = "string"
}

variable "consul_cluster_subnet_id" {
  description = "The Network subnet Id for the cluster"
  type        = "list"
  default     = []
}

variable "consul_cluster_security_group_rules" {
  type = list(map(any))
  default = []
  description = "The definition os security groups to associate to instance. Only one is allowed"
}

variable "consul_cluster_security_groups_to_associate" {
  type        = list(string)
  default     = []
  description = "List of existing security groups to associate to consul instances."
}

variable "consul_cluster_metadata" {
  default = {}
}

variable "consul_server_instance_count" {
  description = "Number of Consul server in the cluster"
  default     = 1
}

variable "consul_server_image_name" {
  description = "The image name of the consul server instance"
  type        = "string"
}

variable "consul_server_flavor_name" {
  description = "The flavor name of the consul server instance"
  type        = "string"
}

variable "consul_server_keypair_name" {
  description = "The Keypair name of the consul server instance"
  type        = "string"
}

variable "consul_cluster_floating_ip_pool" {
  description = "The floating Ip pool to use for the first consul server instance"
  type        = "string"
  default     = ""
}

variable "consul_client_instance_count" {
  description = "Number of Consul client in the cluster"
  default     = 0
}

variable "consul_client_image_name" {
  description = "The image name of the consul client instance"
  type        = "string"
}

variable "consul_client_flavor_name" {
  description = "The flavor name of the consul client instance"
  type        = "string"
}

variable "consul_client_keypair_name" {
  description = "The Keypair name of the consul client instance"
  type        = "string"
}

variable "os_auth_url" {
  type = "string"
}

variable "os_auth_domain_name" {
  type    = "string"
  default = "default"
}

variable "os_project_id" {
  type = "string"
}

variable "os_auth_username" {
  type = "string"
}

variable "os_auth_password" {
  type = "string"
}
