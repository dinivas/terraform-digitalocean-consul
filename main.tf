data "http" "generic_user_data_template" {
  url = "${var.generic_user_data_file_url}"
}

# Consul servers definitions
data "template_file" "consul_server_user_data" {
  template = "${data.http.generic_user_data_template.body}"

  vars = {
    consul_agent_mode         = "server"
    consul_server_count       = "${var.consul_server_instance_count}"
    consul_cluster_domain     = "${var.consul_cluster_domain}"
    consul_cluster_datacenter = "${var.consul_cluster_datacenter}"
    consul_cluster_name       = "${var.consul_cluster_name}"
    os_auth_domain_name       = "${var.os_auth_domain_name}"
    os_auth_username          = "${var.os_auth_username}"
    os_auth_password          = "${var.os_auth_password}"
    os_auth_url               = "${var.os_auth_url}"
    os_project_id             = "${var.os_project_id}"

    pre_configure_script     = ""
    custom_write_files_block = "${data.template_file.consul_server_user_data_write_files.rendered}"
    post_configure_script    = ""
  }
}

data "template_file" "consul_server_user_data_write_files" {
  template = "${file("${path.module}/templates/consul-server-user-data.tpl")}"

  vars = {
    consul_cluster_name = "${var.consul_cluster_name}"
  }
}

module "consul_server_instance" {
  # source = "../terraform-openstack-instance"

  source = "github.com/dinivas/terraform-openstack-instance"

  instance_name                      = "${var.consul_cluster_name}-server"
  instance_count                     = "${var.consul_server_instance_count}"
  image_name                         = "${var.consul_server_image_name}"
  flavor_name                        = "${var.consul_server_flavor_name}"
  keypair                            = "${var.consul_server_keypair_name}"
  network_ids                        = ["${var.consul_cluster_network_id}"]
  subnet_ids                         = "${var.consul_cluster_subnet_id}"
  instance_security_group_name       = "${var.consul_cluster_name}-server-sg"
  instance_security_group_rules      = "${var.consul_cluster_security_group_rules}"
  security_groups_to_associate       = "${var.consul_cluster_security_groups_to_associate}"
  metadata                           = "${var.consul_cluster_metadata}"
  user_data                          = "${data.template_file.consul_server_user_data.rendered}"
  enabled                            = "${var.enable_consul_cluster}"
  availability_zone                  = "${var.consul_cluster_availability_zone}"
  execute_on_destroy_instance_script = "${var.execute_on_destroy_server_instance_script}"
  ssh_via_bastion_config             = "${var.ssh_via_bastion_config}"
}

// Conditional floating ip on the first Consul server
resource "openstack_networking_floatingip_v2" "consul_cluster_floatingip" {
  count = "${var.consul_cluster_floating_ip_pool != "" ? var.enable_consul_cluster * 1 : 0}"

  pool = "${var.consul_cluster_floating_ip_pool}"
}

resource "openstack_compute_floatingip_associate_v2" "consul_cluster_floatingip_associate" {
  count = "${var.consul_cluster_floating_ip_pool != "" ? var.enable_consul_cluster * 1 : 0}"

  floating_ip           = "${lookup(openstack_networking_floatingip_v2.consul_cluster_floatingip[count.index], "address")}"
  instance_id           = "${module.consul_server_instance.ids[count.index]}"
  fixed_ip              = "${module.consul_server_instance.network_fixed_ip_v4[count.index]}"
  wait_until_associated = true
}

# Consul client definitions

data "template_file" "consul_client_user_data" {
  template = "${data.http.generic_user_data_template.body}"

  vars = {
    consul_agent_mode         = "client"
    consul_cluster_domain     = "${var.consul_cluster_domain}"
    consul_cluster_datacenter = "${var.consul_cluster_datacenter}"
    consul_cluster_name       = "${var.consul_cluster_name}"
    os_auth_domain_name       = "${var.os_auth_domain_name}"
    os_auth_username          = "${var.os_auth_username}"
    os_auth_password          = "${var.os_auth_password}"
    os_auth_url               = "${var.os_auth_url}"
    os_project_id             = "${var.os_project_id}"

    pre_configure_script     = ""
    custom_write_files_block = ""
    post_configure_script    = ""
  }
}

module "consul_client_instance" {
  # source = "../terraform-openstack-instance"

  source = "github.com/dinivas/terraform-openstack-instance"

  instance_name                      = "${var.consul_cluster_name}-client"
  instance_count                     = "${var.consul_client_instance_count}"
  image_name                         = "${var.consul_client_image_name}"
  flavor_name                        = "${var.consul_client_flavor_name}"
  keypair                            = "${var.consul_client_keypair_name}"
  network_ids                        = ["${var.consul_cluster_network_id}"]
  subnet_ids                         = "${var.consul_cluster_subnet_id}"
  instance_security_group_name       = "${var.consul_cluster_name}-client-sg"
  instance_security_group_rules      = "${var.consul_cluster_security_group_rules}"
  security_groups_to_associate       = "${var.consul_cluster_security_groups_to_associate}"
  metadata                           = "${var.consul_cluster_metadata}"
  user_data                          = "${data.template_file.consul_client_user_data.rendered}"
  enabled                            = "${var.enable_consul_cluster}"
  availability_zone                  = "${var.consul_cluster_availability_zone}"
  execute_on_destroy_instance_script = "${var.execute_on_destroy_client_instance_script}"
  ssh_via_bastion_config             = "${var.ssh_via_bastion_config}"
}
