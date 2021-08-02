data "digitalocean_vpc" "consul_cluster" {
  count = var.enable_consul_cluster

  name = var.consul_cluster_network_name
}

data "digitalocean_ssh_key" "consul_cluster" {
  count = var.enable_consul_cluster

  name = "${var.project_name}-project-keypair"
}
data "http" "generic_user_data_template" {
  url = var.generic_user_data_file_url
}

# Consul servers definitions
data "template_file" "consul_server_user_data" {
  template = data.http.generic_user_data_template.body

  vars = {
    cloud_provider            = "digitalocean"
    project_name              = var.project_name
    consul_agent_mode         = "server"
    consul_server_count       = "${var.consul_server_instance_count}"
    consul_cluster_domain     = "${var.consul_cluster_domain}"
    consul_cluster_datacenter = "${var.consul_cluster_datacenter}"
    consul_cluster_name       = "${var.consul_cluster_name}"
    do_region                 = var.project_availability_zone
    do_api_token              = var.do_api_token
    enable_logging_graylog    = 1

    pre_configure_script     = ""
    custom_write_files_block = "${data.template_file.consul_server_user_data_write_files.rendered}"
    post_configure_script    = ""
  }
}

data "template_file" "consul_server_user_data_write_files" {
  template = file("${path.module}/templates/consul-server-user-data.tpl")

  vars = {
    consul_cluster_name = "${var.consul_cluster_name}"
  }
}

resource "digitalocean_droplet" "consul_server" {
  count = var.consul_server_instance_count

  name               = format("%s-server-%s", var.consul_cluster_name, count.index)
  image              = var.consul_server_image_name
  size               = var.consul_server_flavor_name
  ssh_keys           = [data.digitalocean_ssh_key.consul_cluster.0.id]
  region             = var.consul_cluster_availability_zone
  vpc_uuid           = data.digitalocean_vpc.consul_cluster.0.id
  user_data          = data.template_file.consul_server_user_data.rendered
  tags               = concat([var.project_name], split(",", format("consul_cluster_name_%s-%s,project_%s", var.project_name, "consul", var.project_name)))
  private_networking = true
}

resource "null_resource" "consul_server_leave" {
  count = var.consul_server_instance_count * var.enable_consul_cluster

  triggers = {
    private_ip                                = digitalocean_droplet.consul_server[count.index].ipv4_address_private
    host_private_key                          = var.host_private_key
    bastion_host                              = lookup(var.ssh_via_bastion_config, "bastion_host")
    bastion_port                              = lookup(var.ssh_via_bastion_config, "bastion_port")
    bastion_ssh_user                          = lookup(var.ssh_via_bastion_config, "bastion_ssh_user")
    bastion_private_key                       = var.bastion_private_key
    execute_on_destroy_server_instance_script = join(",", var.execute_on_destroy_server_instance_script)
  }

  connection {
    type        = "ssh"
    user        = "root"
    port        = 22
    host        = self.triggers.private_ip
    private_key = self.triggers.host_private_key
    agent       = false

    bastion_host        = self.triggers.bastion_host
    bastion_port        = self.triggers.bastion_port
    bastion_user        = self.triggers.bastion_ssh_user
    bastion_private_key = self.triggers.bastion_private_key
  }

  provisioner "remote-exec" {
    when       = destroy
    inline     = split(",", self.triggers.execute_on_destroy_server_instance_script)
    on_failure = continue
  }

}


# Consul client definitions

data "template_file" "consul_client_user_data" {
  template = data.http.generic_user_data_template.body

  vars = {
    cloud_provider            = "digitalocean"
    project_name              = var.project_name
    consul_agent_mode         = "client"
    consul_cluster_domain     = "${var.consul_cluster_domain}"
    consul_cluster_datacenter = "${var.consul_cluster_datacenter}"
    consul_cluster_name       = "${var.consul_cluster_name}"
    do_region                 = var.project_availability_zone
    do_api_token              = var.do_api_token
    enable_logging_graylog    = 1

    pre_configure_script     = ""
    custom_write_files_block = ""
    post_configure_script    = ""
  }
}

resource "digitalocean_droplet" "consul_client" {
  count = var.consul_client_instance_count

  name               = format("%s-client-%s", var.consul_cluster_name, count.index)
  image              = var.consul_client_image_name
  size               = var.consul_client_flavor_name
  ssh_keys           = [data.digitalocean_ssh_key.consul_cluster.0.id]
  region             = var.consul_cluster_availability_zone
  vpc_uuid           = data.digitalocean_vpc.consul_cluster.0.id
  user_data          = data.template_file.consul_client_user_data.rendered
  tags               = concat([var.project_name], split(",", format("consul_cluster_name_%s-%s,project_%s", var.project_name, "consul", var.project_name)))
  private_networking = true
}

resource "null_resource" "consul_client_leave" {
  count = var.consul_client_instance_count * var.enable_consul_cluster

  triggers = {
    private_ip                                = digitalocean_droplet.consul_client[count.index].ipv4_address_private
    host_private_key                          = var.host_private_key
    bastion_host                              = lookup(var.ssh_via_bastion_config, "bastion_host")
    bastion_port                              = lookup(var.ssh_via_bastion_config, "bastion_port")
    bastion_ssh_user                          = lookup(var.ssh_via_bastion_config, "bastion_ssh_user")
    bastion_private_key                       = var.bastion_private_key
    execute_on_destroy_client_instance_script = join(",", var.execute_on_destroy_client_instance_script)
  }

  connection {
    type        = "ssh"
    user        = "root"
    port        = 22
    host        = self.triggers.private_ip
    private_key = self.triggers.host_private_key
    agent       = false

    bastion_host        = self.triggers.bastion_host
    bastion_port        = self.triggers.bastion_port
    bastion_user        = self.triggers.bastion_ssh_user
    bastion_private_key = self.triggers.bastion_private_key
  }

  provisioner "remote-exec" {
    when       = destroy
    inline     = split(",", self.triggers.execute_on_destroy_client_instance_script)
    on_failure = continue
  }

}
