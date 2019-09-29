 #!/bin/sh

instance_ip4=$(ip addr show dev eth0 | grep inet | awk '{print $2}' | head -1 | cut -d/ -f1)
instance_hostname=$(hostname -s)

echo " ===> Configuring Consul"
cat << EOF > /etc/consul/config.json
{
    "addresses": {
        "dns": "0.0.0.0",
        "grpc": "0.0.0.0",
        "http": "0.0.0.0",
        "https": "0.0.0.0"
    },
    "advertise_addr": "$${instance_ip4}",
    "advertise_addr_wan": "$${instance_ip4}",
    "bind_addr": "0.0.0.0",
    "bootstrap": false,
    %{ if consul_agent_mode == "server" }
    "bootstrap_expect": ${consul_server_count},
    %{ endif }
    "client_addr": "0.0.0.0",
    "data_dir": "/var/consul",
    "datacenter": "${consul_cluster_datacenter}",
    "disable_update_check": false,
    "domain": "${consul_cluster_domain}",
    "enable_local_script_checks": false,
    "enable_script_checks": false,
    "log_file": "/var/log/consul/consul.log",
    "log_level": "INFO",
    "log_rotate_bytes": 0,
    "log_rotate_duration": "24h",
    "log_rotate_max_files": 0,
    "node_name": "$${instance_hostname}",
    "performance": {
        "leave_drain_time": "5s",
        "raft_multiplier": 1,
        "rpc_hold_timeout": "7s"
    },
    "ports": {
        "dns": 8600,
        "grpc": -1,
        "http": 8500,
        "https": -1,
        "serf_lan": 8301,
        "serf_wan": 8302,
        "server": 8300
    },
    "raft_protocol": 3,
    "retry_interval": "30s",
    "retry_interval_wan": "30s",
    "retry_join": ["provider=os tag_key=consul_cluster_name tag_value=${consul_cluster_name} username=${os_auth_username} password=${os_auth_password} auth_url=${os_auth_url} project_id=${os_project_id}"],
    "retry_max": 0,
    "retry_max_wan": 0,
    "server": %{ if consul_agent_mode == "server" }true%{ else }false%{ endif },
    "translate_wan_addrs": false,
    "ui": %{ if consul_agent_mode == "server" }true%{ else }false%{ endif }
}
EOF

chown consul:bin /etc/consul/config.json
chmod 644 /etc/consul/config.json

echo " ===> Restart Consul"

systemctl restart consul