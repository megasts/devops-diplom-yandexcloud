data "yandex_compute_image" "worker-os-image" {
  #family = "container-optimized-image"
  #family = "ubuntu-2004-lts"
  family = var.worker_nodes_family_os
}

resource "yandex_compute_instance" "worker_nodes" {
  count       = var.worker_nodes_count
  name        = "worker-${count.index+1}"
  platform_id = var.platform
  zone = element(yandex_vpc_subnet.subnet[*].zone, count.index % length(yandex_vpc_subnet.subnet[*].id))
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
    # subnet_id = "${yandex_vpc_subnet.subnet[0].id}"
    subnet_id = element(yandex_vpc_subnet.subnet[*].id, count.index % length(yandex_vpc_subnet.subnet[*].id))
    # subnet_id = element(yandex_vpc_subnet.subnet.ids[*], count.index % length(yandex_vpc_subnet.subnet.ids[*]))
    nat       = true
  }

  metadata = {
    user-data = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

}