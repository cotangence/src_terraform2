
resource "local_file" "hosts_for" {
  content =  <<-EOT
  %{if length(yandex_compute_instance.web) > 0}
  [webservers]
  %{endif}
  %{for i in yandex_compute_instance.web }
  ${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]} fqdn=${i["fqdn"]}
  %{endfor}
  %{if length(yandex_compute_instance.db) > 0}

  [databases]

  %{endif}
  %{for i in yandex_compute_instance.db }
  ${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]} fqdn=${i["fqdn"]}
  %{endfor}
  [storage]

  ${local.storage_name}   ansible_host=${local.storage_ip} fqdn=${local.storage_fqdn}
  EOT
  filename = "${abspath(path.module)}/host.cfg"

}
#как сделать автоматическое корректное определение по yandex_compute_instance.*  я не понял, если машины созданы через count или for то все работает , но если там одна машина  то возвращаются другие данные =\