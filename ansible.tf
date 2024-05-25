
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

  %{if length(yandex_compute_instance.storage) > 0}
  [storage]
  %{endif}
  %{for i in [yandex_compute_instance.storage] }
  ${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]} fqdn=${i["fqdn"]}
  %{endfor}
  EOT
  filename = "${abspath(path.module)}/host.cfg"

}
