output "public_ip_masters" {
  value = [for k in yandex_compute_instance.master_nodes : "ssh -o 'StrictHostKeyChecking=no' ${var.username}@${k["network_interface"][0]["nat_ip_address"]}"]
}

output "ip_masters" {
  value = [for k in yandex_compute_instance.master_nodes : "${k["name"]} ${k["network_interface"][0]["ip_address"]}"]
}