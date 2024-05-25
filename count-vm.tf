data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}
resource "yandex_compute_instance" "web" {
  count = 2

  name        = "netology-develop-platform-web-${count.index + 1}"
  platform_id = "standard-v1"

  resources {
    cores         = "${var.vms_resources_web["cores"]}"
    memory        = "${var.vms_resources_web["memory"]}"
    core_fraction = "${var.vms_resources_web["core_fraction"]}"
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = 5
    }
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = local.ssh
  }

  scheduling_policy {
    preemptible = true
}

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
  allow_stopping_for_update = true
  depends_on = [yandex_compute_instance.db]
}