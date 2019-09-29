output "consul_server_instance_ids" {
  value = "${module.consul_cluster.consul_server_instance_ids}"
}

output "consul_client_instance_ids" {
  value = "${module.consul_cluster.consul_client_instance_ids}"
}

output "consul_server_instance_ip_v4" {
  value = "${module.consul_cluster.consul_server_network_fixed_ip_v4}"
}

output "consul_client_instance_ip_v4" {
  value = "${module.consul_cluster.consul_client_network_fixed_ip_v4}"
}

output "consul_cluster_floating_ip" {
  value = "${module.consul_cluster.consul_cluster_floating_ip}"
}
