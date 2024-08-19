# Домашнее задание к занятию 12 «GitLab»

## Подготовка к выполнению


1. Или подготовьте к работе Managed GitLab от yandex cloud [по инструкции](https://cloud.yandex.ru/docs/managed-gitlab/operations/instance/instance-create) .
Или создайте виртуальную машину из публичного образа [по инструкции](https://cloud.yandex.ru/marketplace/products/yc/gitlab ) .

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/bad59d11-51d7-4577-a91c-a2a7cbfebb06)

2. Создайте виртуальную машину и установите на нее gitlab runner, подключите к вашему серверу gitlab  [по инструкции](https://docs.gitlab.com/runner/install/linux-repository.html) .

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/92942a89-9085-46fb-9d65-d674964ac723)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/cbb2ae68-d2ce-4566-8522-416bc2f95378)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/8ed0e56e-b405-4791-8f25-ba9175d236a4)

3. (* Необязательное задание повышенной сложности. )  Если вы уже знакомы с k8s попробуйте выполнить задание, запустив gitlab server и gitlab runner в k8s  [по инструкции](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/gitlab-containers). 

4. Создайте свой новый проект.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/9e471cb0-6849-46f3-971e-021129f7d71f)

5. Создайте новый репозиторий в GitLab, наполните его [файлами](./repository).

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/6d216fec-50f1-42a3-997b-e08ef314d788)

6. Проект должен быть публичным, остальные настройки по желанию.

## Основная часть

### DevOps

В репозитории содержится код проекта на Python. Проект — RESTful API сервис. Ваша задача — автоматизировать сборку образа с выполнением python-скрипта:

1. Образ собирается на основе [centos:7](https://hub.docker.com/_/centos?tab=tags&page=1&ordering=last_updated).
2. Python версии не ниже 3.7.
3. Установлены зависимости: `flask` `flask-jsonpify` `flask-restful`.
4. Создана директория `/python_api`.
5. Скрипт из репозитория размещён в /python_api.
6. Точка вызова: запуск скрипта.
7. При комите в любую ветку должен собираться docker image с форматом имени hello:gitlab-$CI_COMMIT_SHORT_SHA . Образ должен быть выложен в Gitlab registry или yandex registry.   

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/fd58cb47-12b4-4bee-aad9-e00f97477eb6)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/5659052a-ca05-4739-afe0-529504352c37)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/35bf8022-a019-4c3b-8296-a0a89d1063cd)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/347402ea-7ff5-4e96-aa76-da96480b0e0a)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/3147ac1b-e5bf-4150-8f55-c6403d1ae1b1)


### Product Owner

Вашему проекту нужна бизнесовая доработка: нужно поменять JSON ответа на вызов метода GET `/rest/api/get_info`, необходимо создать Issue в котором указать:

1. Какой метод необходимо исправить.
2. Текст с `{ "message": "Already started" }` на `{ "message": "Running"}`.
3. Issue поставить label: feature.

### Developer

Пришёл новый Issue на доработку, вам нужно:

1. Создать отдельную ветку, связанную с этим Issue.
2. Внести изменения по тексту из задания.
3. Подготовить Merge Request, влить необходимые изменения в `master`, проверить, что сборка прошла успешно.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/98a2847e-fc81-499f-ba14-7390b09b6feb)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/09140251-f879-4abd-937c-0f63a8715958)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/8ac76a08-3977-49b0-898e-88df5b435efa)

### Tester

Разработчики выполнили новый Issue, необходимо проверить валидность изменений:

1. Поднять докер-контейнер с образом `python-api:latest` и проверить возврат метода на корректность.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/3fcc846a-964d-4b5f-9754-d567970ddd00)

2. Закрыть Issue с комментарием об успешности прохождения, указав желаемый результат и фактически достигнутый.

## Итог

В качестве ответа пришлите подробные скриншоты по каждому пункту задания:

- файл gitlab-ci.yml;
- Dockerfile; 
- лог успешного выполнения пайплайна;
- решённый Issue.

### Важно 
После выполнения задания выключите и удалите все задействованные ресурсы в Yandex Cloud.

