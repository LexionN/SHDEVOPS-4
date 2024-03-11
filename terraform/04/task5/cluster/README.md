<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | 0.111.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_mdb_mysql_cluster.cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_HA"></a> [HA](#input\_HA) | HA кластер? | `bool` | `true` | no |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Имя модуля | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | <окружение> | `string` | `"PRESTABLE"` | no |
| <a name="input_name"></a> [name](#input\_name) | <имя\_кластера> | `string` | n/a | yes |
| <a name="input_name_id"></a> [name\_id](#input\_name\_id) | <id hosts кластера> | `list(string)` | <pre>[<br>  "1",<br>  "2"<br>]</pre> | no |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | <идентификатор\_сети> | `string` | n/a | yes |
| <a name="input_resources"></a> [resources](#input\_resources) | n/a | <pre>map(object({<br>      resource_preset_id = string<br>      disk_type_id       = string<br>      disk_size          = number<br>    }))</pre> | <pre>{<br>  "res": {<br>    "disk_size": "10",<br>    "disk_type_id": "network-hdd",<br>    "resource_preset_id": "s2.micro"<br>  }<br>}</pre> | no |
| <a name="input_version_mysql"></a> [version\_mysql](#input\_version\_mysql) | <версия\_MySQL> | `string` | `"8.0"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->