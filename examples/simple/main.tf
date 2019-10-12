variable "os_auth_domain_name" {
  type    = "string"
  default = "default"
}

variable "os_auth_username" {}

variable "os_auth_password" {}

variable "os_auth_url" {}

variable "os_project_id" {}

module "mgmt_network" {
  #source              = "../terraform-os-network/"
  source              = "github.com/dinivas/terraform-openstack-network"
  network_name        = "test-mgmt"
  network_tags        = ["test", "management", "dinivas"]
  network_description = ""

  subnets = [
    {
      subnet_name       = "test-mgmt-subnet"
      subnet_cidr       = "10.10.18.1/24"
      subnet_ip_version = 4
      subnet_tags       = "test, management, dinivas"
      allocation_pool_start = "10.10.18.2"
      allocation_pool_end   = "10.10.18.20"
    }
  ]
}

module "consul_cluster" {
  source = "../../"

  enable_consul_cluster                       = "1"
  consul_cluster_name                         = "dnv-consul"
  consul_cluster_domain                       = "dinivas"
  consul_cluster_datacenter                   = "gra"
  consul_cluster_availability_zone            = "nova:node03"
  consul_cluster_network_id                   = "${module.mgmt_network.network_id}"
  consul_cluster_subnet_id                    = ["${module.mgmt_network.subnet_ids}"]
  consul_cluster_floating_ip_pool             = "public"
  consul_server_instance_count                = 1
  consul_server_image_name                    = "Dinivas Base"
  consul_server_flavor_name                   = "dinivas.medium"
  consul_server_keypair_name                  = "dnv-bastion-generated-keypair"
  consul_client_instance_count                = 1
  consul_client_image_name                    = "Dinivas Base"
  consul_client_flavor_name                   = "dinivas.medium"
  consul_client_keypair_name                  = "dnv-bastion-generated-keypair"
  consul_cluster_security_groups_to_associate = ["dnv-common", "dnv-bastion"]
  consul_cluster_metadata = {
    consul_cluster_name = "dnv-consul"
  }

  os_auth_domain_name = "${var.os_auth_domain_name}"
  os_auth_username    = "${var.os_auth_username}"
  os_auth_password    = "${var.os_auth_password}"
  os_auth_url         = "${var.os_auth_url}"
  os_project_id       = "${var.os_project_id}"
}
