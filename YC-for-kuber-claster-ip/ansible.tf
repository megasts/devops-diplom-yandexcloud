resource "local_file" "hosts_templatefile" {
  content = templatefile("${(path.module)}/hosts.tftpl",
    {
    masters = yandex_compute_instance.master_nodes[*],
    workers = yandex_compute_instance.worker_nodes[*],
    workersip = yandex_compute_instance.worker_nodes_ip[*]
    }
  )
  filename = "${abspath(path.module)}/hosts.ini"
}

#определяем, на скольких master нодах можно разместить etcd
locals {
  etcd_count = "${var.master_nodes_count % 2}" == 0 ? "${var.master_nodes_count - 1}" : "${var.master_nodes_count}" 
}

resource "local_file" "inventory_k8s_templatefile" {
  content = templatefile("${(path.module)}/inventory.tftpl",
    {
    masters = yandex_compute_instance.master_nodes[*],
    workers = yandex_compute_instance.worker_nodes[*]
    workersip = yandex_compute_instance.worker_nodes_ip[*]
    etcd_count = local.etcd_count
    }
  ) 
  filename = "${abspath(path.module)}/myinventory.ini"
}

resource "null_resource" "web_hosts_provision" {
  depends_on = [yandex_compute_instance.master_nodes]
  #ожидаем окончания загрузки нод
  provisioner "local-exec" {
     command = "sleep 90"
  }

  #Запуск ansible-playbook
  provisioner "local-exec" {
    command     = "ansible-playbook -i ${abspath(path.module)}/hosts.ini --extra-vars 'host_user_name=${var.username}' ${abspath(path.module)}/ansible.yml -v"
  }
}