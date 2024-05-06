output "instances" {
  value = flatten([[
    for instance in yandex_compute_instance.web : [
      {
        name = instance.name
        id   = instance.id
        fqdn = instance.network_interface.0.ip_address
      }
    ]
    ],
  [for instance in yandex_compute_instance.db : [
      {
        name = instance.name
        id   = instance.id
        fqdn = instance.network_interface.0.ip_address
      }
    ]
]])
}
