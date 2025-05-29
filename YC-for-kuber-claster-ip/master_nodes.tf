data "yandex_compute_image" "master-os-image" {
  family = var.master_nodes_family_os
}

resource "yandex_compute_instance" "master_nodes" {
  depends_on = [yandex_vpc_subnet.subnet]
  count       = var.master_nodes_count
  name        = "master-${count.index+1}"
  platform_id = var.platform
  zone = element(yandex_vpc_subnet.subnet[*].zone, count.index % length(yandex_vpc_subnet.subnet[*].id))
  allow_stopping_for_update = true

  resources {
    cores         = var.master_cores
    memory        = var.master_RAM
    core_fraction = var.master_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.master-os-image.image_id
      type     = "network-hdd"
      size     = var.size_hdd
    }
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = element(yandex_vpc_subnet.subnet[*].id, count.index % length(yandex_vpc_subnet.subnet[*].id))
    nat       = true
  }

  metadata = {
    user-data = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }
}

