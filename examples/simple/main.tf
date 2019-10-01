data "openstack_networking_network_v2" "consul_cluster_network" {
  count = "${var.enable_consul_cluster}"

  name = "${var.consul_cluster_network}"

  depends_on = "${var.consul_depends_on}"
}

data "openstack_networking_subnet_v2" "consul_cluster_subnet" {
  count = "${var.enable_consul_cluster}"

  name = "${var.consul_cluster_subnet}"

  depends_on = "${var.consul_depends_on}"
}

module "consul_cluster" {
  source = "../../"

  enable_consul_cluster                       = "1"
  consul_cluster_name                         = "dnv-consul"
  consul_cluster_domain                       = "dinivas"
  consul_cluster_datacenter                   = "gra"
  consul_cluster_availability_zone            = "nova:node03"
  consul_cluster_network_id                   = "${data.openstack_networking_network_v2.consul_cluster_network.0.id}"
  consul_cluster_subnet_id                    = "${data.openstack_networking_subnet_v2.consul_cluster_subnet.0.id}"
  consul_cluster_floating_ip_pool             = "public"
  consul_server_instance_count                = 2
  consul_server_image_name                    = "Dinivas Base"
  consul_server_flavor_name                   = "dinivas.medium"
  consul_server_keypair_name                  = "dnv"
  consul_client_instance_count                = 1
  consul_client_image_name                    = "Dinivas Base"
  consul_client_flavor_name                   = "dinivas.medium"
  consul_client_keypair_name                  = "dnv"
  consul_cluster_security_groups_to_associate = ["dnv-common"]
  consul_cluster_metadata = {
    consul_cluster_name = "dnv-consul"
  }
}
