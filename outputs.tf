output "consul_server_instance_ids" {
  value = "${module.consul_server_instance.ids}"
}

output "consul_client_instance_ids" {
  value = "${module.consul_client_instance.ids}"
}


output "consul_server_network_fixed_ip_v4" {
  value = "${module.consul_server_instance.network_fixed_ip_v4}"
}

output "consul_client_network_fixed_ip_v4" {
  value = "${module.consul_client_instance.network_fixed_ip_v4}"
}

output "consul_cluster_floating_ip" {
  value       = "${openstack_networking_floatingip_v2.consul_cluster_floatingip.0.address}"
  description = "The floating ip bind to first Consul server"
}
