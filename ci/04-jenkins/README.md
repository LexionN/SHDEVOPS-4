# Домашнее задание к занятию 10 «Jenkins»

## Подготовка к выполнению

1. Создать два VM: для jenkins-master и jenkins-agent.
2. Установить Jenkins при помощи playbook.
<<<<<<< HEAD
3. Запустить и проверить работоспособность.
4. Сделать первоначальную настройку.

## Основная часть

1. Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
2. Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.
4. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.
5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline).
6. Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True). По умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.
7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`.
8. Отправить ссылку на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline.
=======

Создал VM с помощью [terraform](https://github.com/LexionN/SHDEVOPS-4/tree/main/ci/04-jenkins/terraform)

Он же запускает playbook для установки Jenkins

3. Запустить и проверить работоспособность.
4. Сделать первоначальную настройку.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/12f5367a-cd84-4c7c-bf96-6d270dcc255f)

## Основная часть

1. Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/77fb1f5c-bb7d-4996-894f-03396027ed73)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/e5c36f97-7180-4965-865c-fb6fe0ddb5b1)

2. Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/586dcca2-9e48-43b3-917d-90a7a8275407)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/0acdd91b-16f7-4122-8960-f91b0337cb68)

3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.

[Jenkinsfile](https://github.com/LexionN/SHDEVOPS-4/blob/main/ci/04-jenkins/Jenkinsfile)

4. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/a36bc296-f716-4458-9f51-500181d653da)

5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline).
6. Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True). По умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/30d84a43-3057-45ff-8b0b-7800981fbcff)


![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/5dbd731f-13b3-493b-8e82-89c7ea9aa437)

7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`.

[ScriptedJenkinsfile](https://github.com/LexionN/SHDEVOPS-4/blob/main/ci/04-jenkins/ScriptedJenkinsfile)

8. Отправить ссылку на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline.

[vector-role](https://github.com/LexionN/vector-role)

>>>>>>> refs/remotes/origin/main
9. Сопроводите процесс настройки скриншотами для каждого пункта задания!!

## Необязательная часть

1. Создать скрипт на groovy, который будет собирать все Job, завершившиеся хотя бы раз неуспешно. Добавить скрипт в репозиторий с решением и названием `AllJobFailure.groovy`.
2. Создать Scripted Pipeline так, чтобы он мог сначала запустить через Yandex Cloud CLI необходимое количество инстансов, прописать их в инвентори плейбука и после этого запускать плейбук. Мы должны при нажатии кнопки получить готовую к использованию систему.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
