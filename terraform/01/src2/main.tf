terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
  required_version = ">=0.13" /*Многострочный комментарий.
 Требуемая версия terraform */
}

provider "docker" {
  host = "ssh://lexion@158.160.117.15:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

#однострочный комментарий
 
resource "random_password" "random_string_root" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "random_string_user" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "docker_image" "mysql"{
  name         = "mysql:8"
  keep_locally = false
  build {
    context        = "."
    remote_context = "https://github.com/mysql/mysql-docker.git"
  }
}

resource "docker_container" "mysql" {
  image = docker_image.mysql.image_id
  name  = "mysql-test"

  ports {
    internal = 3306
    external = 3306
  }
  env = [
       "MYSQL_ROOT_PASSWORD=${random_password.random_string_root.result}",
       "MYSQL_DATABASE=wordpress",
       "MYSQL_USER=wordpress",
       "MYSQL_PASSWORD=${random_password.random_string_user.result}",
       "MYSQL_ROOT_HOST=%"
  ]
  
}

