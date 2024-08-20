resource "yandex_storage_object" "cute-picture" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.my_bucket.id
  key        = "devops-image.jpg"
  source     = "./images/DevOps.jpg"
}
