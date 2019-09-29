module "consul_cluster" {
  source = "../../"

  enable_consul_cluster                       = "1"
  consul_cluster_name                         = "dnv-consul"
  consul_cluster_domain                       = "dinivas"
  consul_cluster_datacenter                   = "gra"
  consul_cluster_availability_zone            = "nova:node03"
  consul_cluster_network                      = "dnv-mgmt"
  consul_cluster_subnet                       = "dnv-mgmt-subnet"
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
  os_auth_domain_name = "default"
  os_auth_username    = "admin"
  os_auth_password    = "yfCOIh4DwkiHMeMGgdzraI0XYEqpVwNlmcS05gQt"
  os_auth_url         = "http://cloud.runadium.fr:5000/v3"
  os_project_id       = "c923a362940f49948d46b0073014705b"
}
