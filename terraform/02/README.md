# Домашнее задание к занятию «Основы Terraform. Yandex Cloud»

### Цели задания

1. Создать свои ресурсы в облаке Yandex Cloud с помощью Terraform.
2. Освоить работу с переменными Terraform.


### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Исходный код для выполнения задания расположен в директории [**02/src**](https://github.com/netology-code/ter-homeworks/tree/main/02/src).


### Задание 0

1. Ознакомьтесь с [документацией к security-groups в Yandex Cloud](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav). 
Этот функционал понадобится к следующей лекции.

------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
------

### Задание 1
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git.  Убедитесь что ваша версия **Terraform** =1.5.Х (версия 1.6.Х может вызывать проблемы с Яндекс провайдером) 

1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
2. Создайте сервисный аккаунт и ключ. [service_account_key_file](https://terraform-provider.yandexcloud.net).
4. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную **vms_ssh_public_root_key**.
5. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.

**Ответ**
1. В проекте используется OAuth-token, необходимо раскомментировать #token = var.token и закомментировать строку  service_account_key_file = file("~/.authorized_key.json")
2. В файле main.tf допущены ошибки
   
   2.1. platform_id = "standart-v4" - нет такого id платформы.
   ![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/99b5ad3d-73a1-43be-a707-79660d3277b2)

    2.2.
```
   resources {
    cores         = 1  #Допускается только четное количество ядер
    memory        = 1
    core_fraction = 5  # В зависимости от выбранной платформы "standard-v3" (20, 50, 100), "standard-v2" (5, 20, 50, 100), "standard-v1" (5, 20, 100)
  }
```
[Исправленный код проекта](https://github.com/LexionN/SHDEVOPS-4/tree/main/terraform/02/src_task1)   
6. Подключитесь к консоли ВМ через ssh и выполните команду ``` curl ifconfig.me```.
Примечание: К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: ```"ssh ubuntu@vm_ip_address"```. Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: ```eval $(ssh-agent) && ssh-add``` Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей лекции.;
8. Ответьте, как в процессе обучения могут пригодиться параметры ```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ.

**Ответ**
Параметр ```preemptible = true``` означает создание прерываемой ВМ, ```core_fraction=5``` - доля vCPU равная 5%. Данные параметры помогут в экономии облачных ресурсов.

В качестве решения приложите:

- скриншот ЛК Yandex Cloud с созданной ВМ, где видно внешний ip-адрес;

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/40bd1574-055d-47d0-bb14-5f39479082cf)

- скриншот консоли, curl должен отобразить тот же внешний ip-адрес;

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/04fb2bf1-01e9-402c-a736-db35e37d78c2)

- ответы на вопросы.


### Задание 2

1. Замените все хардкод-**значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. 
3. Проверьте terraform plan. Изменений быть не должно. 

**Ответ**
[Измененный код проекта](https://github.com/LexionN/SHDEVOPS-4/tree/main/terraform/02/src_task2)  

### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: **"netology-develop-platform-db"** ,  ```cores  = 2, memory = 2, core_fraction = 20```. Объявите её переменные с префиксом **vm_db_** в том же файле ('vms_platform.tf').  ВМ должна работать в зоне "ru-central1-b"
3. Примените изменения.

**Ответ**

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/2140bed1-8fea-41e2-b2ef-039ccc215538)

[Измененный код проекта](https://github.com/LexionN/SHDEVOPS-4/tree/main/terraform/02/src_task3)

### Задание 4

1. Объявите в файле outputs.tf **один** output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ в удобном лично для вас формате.
2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/e346d87d-0084-455a-a0e9-8ac1bbdd7742)

[Измененный код проекта](https://github.com/LexionN/SHDEVOPS-4/tree/main/terraform/02/src_task4)


### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с НЕСКОЛЬКИМИ переменными по примеру из лекции.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/740130dc-a57e-41ba-8e30-714a2ea7ba55)

2. Замените переменные внутри ресурса ВМ на созданные вами local-переменные.
3. Примените изменения.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/96dab63a-167e-4acd-add9-e614470e5c98)

[Измененный код проекта](https://github.com/LexionN/SHDEVOPS-4/tree/main/terraform/02/src_task5)


### Задание 6

1. Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедините их в единую map-переменную **vms_resources** и  внутри неё конфиги обеих ВМ в виде вложенного map.  
   ```
   пример из terraform.tfvars:
   vms_resources = {
     web={
       cores=
       memory=
       core_fraction=
       ...
     },
     db= {
       cores=
       memory=
       core_fraction=
       ...
     }
   }
   ```

   **Ответ**

В файле vms_platform.tf добавил объявление для новой переменной

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/64551d19-c6e1-4679-89a6-88c7a15d14f7)

В файле terraform.tfvars описал характеристики ВМ

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/9e527817-6684-4d26-ae33-1171fe260bb7)

Изменил файл main.tf в соответствии с новыми переменными

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/21f8ec71-5e75-46c9-b883-e06e0ab2870b)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/deceefc0-79fa-467c-9c48-d71edd2668f9)

   
3. Создайте и используйте отдельную map переменную для блока metadata, она должна быть общая для всех ваших ВМ.
   ```
   пример из terraform.tfvars:
   metadata = {
     serial-port-enable = 1
     ssh-keys           = "ubuntu:ssh-ed25519 AAAAC..."
   }
   ```  
  
5. Найдите и закоментируйте все, более не используемые переменные проекта.

 Изменил variables.tf
```
....
###ssh vars

#variable "vms_ssh_root_key" {
#  type        = string
#  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3........."
#  description = "ssh-keygen -t ed25519"
#}


variable "metadata_vm" {
  type = map(object({
    serial-port-enable = number
    ssh-keys = string
  }))
 default = {
  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3........."

  }
 }

}
....

```
Изменил main.tf

```
...
  metadata = var.metadata_vm["metadata"]
...
```
[Измененный код проекта](https://github.com/LexionN/SHDEVOPS-4/tree/main/terraform/02/src_task6)

7. Проверьте terraform plan. Изменений быть не должно.

------

## Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.**   
Они помогут глубже разобраться в материале. Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 


------
### Задание 7*

Изучите содержимое файла console.tf. Откройте terraform console, выполните следующие задания: 

1. Напишите, какой командой можно отобразить **второй** элемент списка test_list.
```local.test_list[1]```
2. Найдите длину списка test_list с помощью функции length(<имя переменной>).
```length(local.test_list)``` результат ```3```
4. Напишите, какой командой можно отобразить значение ключа admin из map test_map.
```local.test_map.admin``` или ```local.test_map["admin"]```
5. Напишите interpolation-выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.

```
"${local.test_map["admin"]} is ${keys(local.test_map)[0]} for ${local.test_list[2]} server based on OS ${local.servers.production["image"]} with ${local.servers.production["cpu"]} vcpu ${local.servers.production["ram"]} ram ${length(local.servers.production["disks"])} virtual disks"
```

   ![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/a63dfc43-c2f8-4976-b85c-5372bd69ad37)



**Примечание**: если не догадаетесь как вычленить слово "admin", погуглите: "terraform get keys of map"

В качестве решения предоставьте необходимые команды и их вывод.

------

### Задание 8*
1. Напишите и проверьте переменную test и полное описание ее type в соответствии со значением из terraform.tfvars:
```
test = [
  {
    "dev1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117",
      "10.0.1.7",
    ]
  },
  {
    "dev2" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88",
      "10.0.2.29",
    ]
  },
  {
    "prod1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101",
      "10.0.1.30",
    ]
  },
]
```

**Ответ**

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/f77328b7-6313-4c19-97ab-407089a8c351)


2. Напишите выражение в terraform console, которое позволит вычленить строку "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117"

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/f3800725-84fc-4a73-bf63-770b63701c55)


------

------

### Задание 9*

Используя инструкцию https://cloud.yandex.ru/ru/docs/vpc/operations/create-nat-gateway#tf_1, настройте для ваших ВМ nat_gateway. Для проверки уберите внешний IP адрес (nat=false) у ваших ВМ и проверьте доступ в интернет с ВМ, подключившись к ней через serial console. Для подключения предварительно через ssh измените пароль пользователя: ```sudo passwd ubuntu```

### Правила приёма работыДля подключения предварительно через ssh измените пароль пользователя: sudo passwd ubuntu
В качестве результата прикрепите ссылку на MD файл с описанием выполненой работы в вашем репозитории. Так же в репозитории должен присутсвовать ваш финальный код проекта.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/4c416adf-b608-4ac1-8459-866d8736ceb6)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/a3c35c16-8809-44ff-bd06-e03fa64c7f21)

[Финальный код проекта](https://github.com/LexionN/SHDEVOPS-4/tree/main/terraform/02/src_task9)

**Важно. Удалите все созданные ресурсы**.


### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 

