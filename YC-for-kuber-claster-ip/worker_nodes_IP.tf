resource "yandex_compute_instance" "worker_nodes_ip" {
  count       = 1
  name        = "workerip-${count.index+1}"
  platform_id = var.platform
  zone = "ru-central1-d"
  allow_stopping_for_update = true

  resources {
    cores         = var.worker_cores
    memory        = var.worker_RAM
    core_fraction = var.worker_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.worker-os-image.image_id
      type     = "network-hdd"
      size     = var.size_hdd
    }
  }

  #прерываемая машина
  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet[2].id}"
    nat_ip_address = "158.160.182.231"
    # subnet_id = element(yandex_vpc_subnet.subnet.ids[*], count.index % length(yandex_vpc_subnet.subnet.ids[*]))
    nat       = true
  }

  metadata = {
    user-data = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

}