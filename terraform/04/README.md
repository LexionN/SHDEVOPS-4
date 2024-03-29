# Домашнее задание к занятию «Продвинутые методы работы с Terraform»

### Цели задания

1. Научиться использовать модули.
2. Отработать операции state.
3. Закрепить пройденный материал.


### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Исходный код для выполнения задания расположен в директории [**04/src**](https://github.com/netology-code/ter-homeworks/tree/main/04/src).
4. Любые ВМ, использованные при выполнении задания, должны быть прерываемыми, для экономии средств.

------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
Убедитесь что ваша версия **Terraform** =1.5.X (версия 1.6 может вызывать проблемы с Яндекс провайдером)
Пишем красивый код, хардкод значения не допустимы!
------

### Задание 1

1. Возьмите из [демонстрации к лекции готовый код](https://github.com/netology-code/ter-homeworks/tree/main/04/demonstration1) для создания с помощью двух вызовов remote-модуля -> двух ВМ, относящихся к разным проектам(marketing и analytics) используйте labels для обозначения принадлежности.  В файле cloud-init.yml необходимо использовать переменную для ssh-ключа вместо хардкода. Передайте ssh-ключ в функцию template_file в блоке vars ={} .
Воспользуйтесь [**примером**](https://grantorchard.com/dynamic-cloudinit-content-with-terraform-file-templates/). Обратите внимание, что ssh-authorized-keys принимает в себя список, а не строку.
3. Добавьте в файл cloud-init.yml установку nginx.
4. Предоставьте скриншот подключения к консоли и вывод команды ```sudo nginx -t```, скриншот консоли ВМ yandex cloud с их метками. Откройте terraform console и предоставьте скриншот содержимого модуля. Пример: > module.marketing_vm

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/66673683-7c9b-44e1-9b54-e0b92318bd35)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/01ba3679-66c0-4ab9-8112-a20bef9b36ae)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/8f7b7edc-af0a-46b9-8ec9-2c7720d31353)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/35351ca9-129f-46a5-9c96-fb8b4e5d8a21)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/caf8f920-bcc5-4b9a-94bc-04e6c7d02da6)


------

### Задание 2

1. Напишите локальный модуль vpc, который будет создавать 2 ресурса: **одну** сеть и **одну** подсеть в зоне, объявленной при вызове модуля, например: ```ru-central1-a```.
2. Вы должны передать в модуль переменные с названием сети, zone и v4_cidr_blocks.
3. Модуль должен возвращать в root module с помощью output информацию о yandex_vpc_subnet. Пришлите скриншот информации из terraform console о своем модуле. Пример: > module.vpc_dev  

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/67faded4-bcc9-4268-a380-22c48d3e5345)

4. Замените ресурсы yandex_vpc_network и yandex_vpc_subnet созданным модулем. Не забудьте передать необходимые параметры сети из модуля vpc в модуль с виртуальной машиной.
5. Сгенерируйте документацию к модулю с помощью terraform-docs.

[Описание модуля созданное с помощью terraform-docs](https://github.com/LexionN/SHDEVOPS-4/blob/main/terraform/04/src/vpc/README.md)
 
Пример вызова

```
module "vpc_dev" {
  source       = "./vpc"
  env_name     = "develop"
  zone = "ru-central1-a"
  cidr = "10.0.1.0/24"
}
```

### Задание 3
1. Выведите список ресурсов в стейте.
2. Полностью удалите из стейта модуль vpc.
3. Полностью удалите из стейта модуль vm.
4. Импортируйте всё обратно. Проверьте terraform plan. Значимых(!!) изменений быть не должно.
Приложите список выполненных команд и скриншоты процессы.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/28c7d4ca-04ba-4df4-bcee-b060461d3f65)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/c5ea352a-8c1e-45fd-ad08-3411a239a827)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/0e4d4b28-fc71-4925-8bd5-cf44c86348ef)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/124aa882-457b-459f-b296-cc9853d2954e)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/d87a7a43-ba7a-4bde-8c47-c941c119f78b)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/ff0d056c-ef9c-4ad8-8920-1608d8c065ff)


## Дополнительные задания (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.**   Они помогут глубже разобраться в материале.   
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 


### Задание 4*

1. Измените модуль vpc так, чтобы он мог создать подсети во всех зонах доступности, переданных в переменной типа list(object) при вызове модуля.  
  
Пример вызова
```
module "vpc_prod" {
  source       = "./vpc"
  env_name     = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.2.0/24" },
    { zone = "ru-central1-c", cidr = "10.0.3.0/24" },
  ]
}

module "vpc_dev" {
  source       = "./vpc"
  env_name     = "develop"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
  ]
}
```

Предоставьте код, план выполнения, результат из консоли YC.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/c3e0f1ff-d2d2-4f92-a169-e11c4c1bdc16)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/1d12ce22-b163-4fe0-81e1-d0f0813efebc)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/af587fbe-e9e0-4524-bda6-cf54a68ee2d8)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/001b0eff-283f-4050-8d10-07b37c758654)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/a8c7dec0-e3dd-461e-94c5-a32b094039f1)


### Задание 5*

1. Напишите модуль для создания кластера managed БД Mysql в Yandex Cloud с одним или несколькими(2 по умолчанию) хостами в зависимости от переменной HA=true или HA=false. Используйте ресурс yandex_mdb_mysql_cluster: передайте имя кластера и id сети.
2. Напишите модуль для создания базы данных и пользователя в уже существующем кластере managed БД Mysql. Используйте ресурсы yandex_mdb_mysql_database и yandex_mdb_mysql_user: передайте имя базы данных, имя пользователя и id кластера при вызове модуля.
3. Используя оба модуля, создайте кластер example из одного хоста, а затем добавьте в него БД test и пользователя app. Затем измените переменную и превратите сингл хост в кластер из 2-х серверов.
4. Предоставьте план выполнения и по возможности результат. Сразу же удаляйте созданные ресурсы, так как кластер может стоить очень дорого. Используйте минимальную конфигурацию.

[Код модуля создания кластера](https://github.com/LexionN/SHDEVOPS-4/tree/main/terraform/04/task5/cluster)

Если HA=false

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/d982f64f-bad1-4e61-bc2c-f686da1ff886)


Если HA=true или не указан

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/ebe7a45e-fe2a-4170-a8db-0c591b5dac24)


Далее невозможно продолжить из-за ошибки создания кластера, нет прав для сервисного аккаунта, хотя права необходимые добавил.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/9a48ee0f-4982-4089-ae9a-01ab74b66d02)


### Задание 6*
1. Используя готовый yandex cloud terraform module и пример его вызова(examples/simple-bucket): https://github.com/terraform-yc-modules/terraform-yc-s3 .
Создайте и не удаляйте для себя s3 бакет размером 1 ГБ(это бесплатно), он пригодится вам в ДЗ к 5 лекции.

### Задание 7*

1. Разверните у себя локально vault, используя docker-compose.yml в проекте.
2. Для входа в web-интерфейс и авторизации terraform в vault используйте токен "education".
3. Создайте новый секрет по пути http://127.0.0.1:8200/ui/vault/secrets/secret/create
Path: example  
secret data key: test 
secret data value: congrats!  
4. Считайте этот секрет с помощью terraform и выведите его в output по примеру:
```
provider "vault" {
 address = "http://<IP_ADDRESS>:<PORT_NUMBER>"
 skip_tls_verify = true
 token = "education"
}
data "vault_generic_secret" "vault_example"{
 path = "secret/example"
}

output "vault_example" {
 value = "${nonsensitive(data.vault_generic_secret.vault_example.data)}"
} 

Можно обратиться не к словарю, а конкретному ключу:
terraform console: >nonsensitive(data.vault_generic_secret.vault_example.data.<имя ключа в секрете>)
```
5. Попробуйте самостоятельно разобраться в документации и записать новый секрет в vault с помощью terraform. 

### Задание 8*
Попробуйте самостоятельно разобраться в документаци и с помощью terraform remote state разделить root модуль на два отдельных root-модуля: создание VPC , создание ВМ . 

### Правила приёма работы

В своём git-репозитории создайте новую ветку terraform-04, закоммитьте в эту ветку свой финальный код проекта. Ответы на задания и необходимые скриншоты оформите в md-файле в ветке terraform-04.

В качестве результата прикрепите ссылку на ветку terraform-04 в вашем репозитории.

**Важно.** Удалите все созданные ресурсы.

### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 




