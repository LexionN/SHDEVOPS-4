output "picture_url" {
  value = "https://${yandex_storage_bucket.my_bucket.bucket_domain_name}/${yandex_storage_object.cute-picture.key}"
}

