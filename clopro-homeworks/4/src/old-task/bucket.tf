// Creating a service account
resource "yandex_iam_service_account" "sa" {
  name = "service-bucket"
}

// Assigning roles to the service account
resource "yandex_resourcemanager_folder_iam_member" "sa-admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Creating a static access key
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

// Creating a bucket using the key
resource "yandex_storage_bucket" "my_bucket" {
  access_key            = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket                = "aleksey20082024"
  max_size              = 1073741824
  default_storage_class = "standard"
  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }
  
}