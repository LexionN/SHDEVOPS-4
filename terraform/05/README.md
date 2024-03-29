# Домашнее задание к занятию «Использование Terraform в команде»

### Цели задания

1. Научиться использовать remote state с блокировками.
2. Освоить приёмы командной работы.


### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Любые ВМ, использованные при выполнении задания, должны быть прерываемыми, для экономии средств.

------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
Убедитесь что ваша версия **Terraform** =1.5.5 (версия 1.6 может вызывать проблемы с Яндекс провайдером)
Пишем красивый код, хардкод значения не допустимы!

------
### Задание 0
1. Прочтите статью: https://neprivet.com/
2. Пожалуйста, распространите данную идею в своем коллективе.

------

### Задание 1

1. Возьмите код:
- из [ДЗ к лекции 4](https://github.com/netology-code/ter-homeworks/tree/main/04/src),
- из [демо к лекции 4](https://github.com/netology-code/ter-homeworks/tree/main/04/demonstration1).
2. Проверьте код с помощью tflint и checkov. Вам не нужно инициализировать этот проект.
3. Перечислите, какие **типы** ошибок обнаружены в проекте (без дублей).

**Ответ**

tflint выдал предупреждения:

Warning: Missing version constraint for provider (Предупреждение, не указана версия провайдера)

Warning: [Fixable] variable is declared but not used (Предупреждение, переменная объявлена, но не используется)

Warning: Module source uses a default branch as ref (main) (Предупреждение, используется ветка main, не указан конкретный хеш коммита ветки)


checkov выдал:

CKV_YC_11: "Ensure security group is assigned to network interface." (ВМ не назначена группа безопасности)

CKV_YC_2: "Ensure compute instance does not have public IP." (У ВМ есть публичный IP)

CKV_TF_1: "Ensure Terraform module sources use a commit hash" (Не указан хеш коммита)



------

### Задание 2

1. Возьмите ваш GitHub-репозиторий с **выполненным ДЗ 4** в ветке 'terraform-04' и сделайте из него ветку 'terraform-05'.
2. Повторите демонстрацию лекции: настройте YDB, S3 bucket, yandex service account, права доступа и мигрируйте state проекта в S3 с блокировками. Предоставьте скриншоты процесса в качестве ответа.


![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/e61a0a76-9dc5-4dfa-bb21-354b9f67c4d6)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/d824ac80-6382-4c88-928e-f34abe829358)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/19560389-648e-48bd-9972-8ea15a7499ba)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/4ce97880-96b9-4f1a-a9bd-feaadee10541)

3. Закоммитьте в ветку 'terraform-05' все изменения.
4. Откройте в проекте terraform console, а в другом окне из этой же директории попробуйте запустить terraform apply.
5. Пришлите ответ об ошибке доступа к state.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/e51e51cb-87bf-4d5c-8cd5-b67fdff69b2d)

6. Принудительно разблокируйте state. Пришлите команду и вывод.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/e7fa6c05-0078-4acb-9853-4b761d707d97)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/542bce2d-34fa-472c-a265-763858d84246)

------
### Задание 3  

1. Сделайте в GitHub из ветки 'terraform-05' новую ветку 'terraform-hotfix'.
2. Проверье код с помощью tflint и checkov, исправьте все предупреждения и ошибки в 'terraform-hotfix', сделайте коммит.
3. Откройте новый pull request 'terraform-hotfix' --> 'terraform-05'. 
4. Вставьте в комментарий PR результат анализа tflint и checkov, план изменений инфраструктуры из вывода команды terraform plan.
5. Пришлите ссылку на PR для ревью. Вливать код в 'terraform-05' не нужно.

**Ответ**

[Ссылка на PR для ревью](https://github.com/LexionN/SHDEVOPS-4/pull/2)

------
### Задание 4

1. Напишите переменные с валидацией и протестируйте их, заполнив default верными и неверными значениями. Предоставьте скриншоты проверок из terraform console. 

- type=string, description="ip-адрес" — проверка, что значение переменной содержит верный IP-адрес с помощью функций cidrhost() или regex(). Тесты:  "192.168.0.1" и "1920.1680.0.1";
- type=list(string), description="список ip-адресов" — проверка, что все адреса верны. Тесты:  ["192.168.0.1", "1.1.1.1", "127.0.0.1"] и ["192.168.0.1", "1.1.1.1", "1270.0.0.1"].

```
variable "ip_address" {
 type = string
 default = "192.168.0.1"
 description = "ip-адрес"
 validation {
   condition = can(cidrhost("${var.ip_address}/31", 1) == var.ip_address)
   error_message = "Invalid ip address."
}
}

variable "list_ip_address" {
 type = list(string)
 default = ["192.168.0.1", "1.1.1.1", "1270.0.0.1"]
 description = "ip-адрес"
 validation {
   condition = alltrue([
     for ip in var.list_ip_address : can(cidrhost("${ip}/31", 1))
   ])
   error_message = "Invalid ip address in list."
}
}
```

## Дополнительные задания (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.** Их выполнение поможет глубже разобраться в материале.   
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 
------
### Задание 5*
1. Напишите переменные с валидацией:
- type=string, description="любая строка" — проверка, что строка не содержит символов верхнего регистра;
- type=object — проверка, что одно из значений равно true, а второе false, т. е. не допускается false false и true true:
```
variable "in_the_end_there_can_be_only_one" {
    description="Who is better Connor or Duncan?"
    type = object({
        Dunkan = optional(bool)
        Connor = optional(bool)
    })

    default = {
        Dunkan = true
        Connor = false
    }

    validation {
        error_message = "There can be only one MacLeod"
        condition = <проверка>
    }
}
```


**Ответ**

```
variable "in_the_end_there_can_be_only_one" {
    description="Who is better Connor or Duncan?"
    type = object({
        Dunkan = optional(bool)
        Connor = optional(bool)
    })

    default = {
        Dunkan = true
        Connor = false
    }

    validation {
        error_message = "There can be only one MacLeod"
        condition = var.in_the_end_there_can_be_only_one.Dunkan != var.in_the_end_there_can_be_only_one.Connor
    }
}

variable "stroka" {
  type = string
  description = "любая строка"
  default = "dgfgffdgd"
  validation {
  condition = can(regex("[[:upper:]]", var.stroka)) != true
  error_message = "Обнаружены заглавные буквы"
  }
}
```


------
### Задание 6*

1. Настройте любую известную вам CI/CD-систему. Если вы ещё не знакомы с CI/CD-системами, настоятельно рекомендуем вернуться к этому заданию после изучения Jenkins/Teamcity/Gitlab.
2. Скачайте с её помощью ваш репозиторий с кодом и инициализируйте инфраструктуру.
3. Уничтожьте инфраструктуру тем же способом.


------
### Задание 7*
1. Настройте отдельный terraform root модуль, который будет создавать YDB, s3 bucket для tfstate и сервисный аккаунт с необходимыми правами. 

### Правила приёма работы

Ответы на задания и необходимые скриншоты оформите в md-файле в ветке terraform-05.

В качестве результата прикрепите ссылку на ветку terraform-05 в вашем репозитории.

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




