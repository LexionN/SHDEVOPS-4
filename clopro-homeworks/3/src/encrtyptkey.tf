resource "yandex_kms_symmetric_key" "encryptkey" {
  name              = "encryptkey"
  default_algorithm = "AES_256_HSM"
  rotation_period   = "8760h" // 1 год
}

