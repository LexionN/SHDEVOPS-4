terraform {
 backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket = "tfstate-backet"
    region = "ru-central1"
    key = "terraform.tfstate"
    skip_region_validation = true
    skip_credentials_validation = true
    dynamodb_endpoint = "https://docapi.serverless.yandexcloud.net/ru-central1/b1g0bb283f7v06m9lpc2/etn85r2hvct5l0r7uj57"
    dynamodb_table = "tfstate-backet"
  }

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.5"
}

provider "yandex" {
  # token                    = "do not use!!!"
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = file("~/authorized_key.json")
  zone                     = "ru-central1-a" #(Optional) The default availability zone to operate under, if not specified by a given resource.
}
