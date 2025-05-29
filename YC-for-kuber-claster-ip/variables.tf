variable "username" {
    type = string
    default = "ubuntu"
    description = "for ubuntu"
}

variable "vms_ssh_root_key" {
    type        = string
    default     = "~/.ssh/id_ed25519.pub"
    description = "ssh-keygen -t ed25519"
}

variable "service_account_key_file" {
  type        = string
  description = "file_key.json"
}

variable "folder_id" {
    type = string
}

variable "master_nodes_family_os" {
    type = string
    default = "ubuntu-2004-lts"
}

variable "worker_nodes_family_os" {
    type = string
    default = "ubuntu-2004-lts"
}

variable "master_core_fraction" {
  type = number
  default = 100
}

variable "worker_core_fraction" {
  type = number
  default = 50
}

variable "size_hdd" {
  type = number
  default = 10
}

variable "worker_nodes_count" {
    type = number
    default = 1
}

variable "master_cores" {
  type = number
  default = 2
}

variable "worker_cores" {
  type = number
  default = 2
}

variable "worker_RAM" {
  type = number
  default = 2
}

variable "master_RAM" {
  type = number
  default = 2
}

variable "platform" {
    type = string
    default = "standard-v2"
}

variable "network_name" {
    type = string
    default = "kubernetes"
}


variable  "subnets_data" {
  type = list(object({
    zone = string,
    cidr = string
    }
    )
  )
  default = [ 
    {zone = "ru-central1-a", cidr = "10.0.1.0/24"},
    {zone = "ru-central1-b", cidr = "10.0.2.0/24"},
    {zone = "ru-central1-d", cidr = "10.0.3.0/24"},
   ] 
}

variable "default_zone" {
  type = string
  default = "ru-central1-a" 
}

variable "master_nodes_count" {
  type = number
  default = 1
}

variable "admin_nodes_family_os" {
  type= string
  default = "ubuntu-2404-lts"
}

variable "bucket_name" {
  type = string
}