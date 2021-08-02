output "consul_server_ids" {
  value = digitalocean_droplet.consul_server.*.id
}
output "consul_server_names" {
  value = digitalocean_droplet.consul_server.*.name
}

output "consul_client_ids" {
  value = digitalocean_droplet.consul_client.*.id
}
output "consul_client_names" {
  value = digitalocean_droplet.consul_client.*.name
}
output "consul_server_private_fixed_ip_v4" {
  value = digitalocean_droplet.consul_server.*.ipv4_address_private
}
output "consul_client_private_fixed_ip_v4" {
  value = digitalocean_droplet.consul_client.*.ipv4_address_private
}
output "consul_server_public_fixed_ip_v4" {
  value = digitalocean_droplet.consul_server.*.ipv4_address
}
output "consul_client_public_fixed_ip_v4" {
  value = digitalocean_droplet.consul_client.*.ipv4_address
}
