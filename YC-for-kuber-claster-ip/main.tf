terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 1.8"
  backend "s3" {
    endpoints = {s3 = "https://storage.yandexcloud.net"}
    bucket = "shulgatyysv-tfstate"
    region = "ru-central1"
    key    = "terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
}
}

provider "yandex" {
  folder_id                = var.folder_id
  service_account_key_file = file("${var.service_account_key_file}")
  zone                     = var.default_zone
}

resource "yandex_vpc_network" "network" {
  name = var.network_name
}

resource "yandex_vpc_subnet" "subnet" {
  count =  length(var.subnets_data)
  v4_cidr_blocks = ["${var.subnets_data[count.index].cidr}"]
  zone           = "${var.subnets_data[count.index].zone}"
  network_id     = "${yandex_vpc_network.network.id}"
  name = "subnet-${var.network_name}-${count.index+1}"
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    username           = var.username
    ssh_public_key     = file(var.vms_ssh_root_key)
  }
}