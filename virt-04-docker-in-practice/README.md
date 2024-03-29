# Домашнее задание к занятию 5. «Практическое применение Docker»

---
## Примечание: Ознакомьтесь со схемой виртуального стенда [по ссылке](https://github.com/netology-code/shvirtd-example-python/blob/main/schema.pdf)

---

## Задача 1
1. Сделайте в своем github пространстве fork репозитория ```https://github.com/netology-code/shvirtd-example-python/blob/main/README.md```.   

https://github.com/LexionN/hvirtd-example-python/blob/main/README.md

2. Создайте файл с именем ```Dockerfile.python``` для сборки данного проекта. Используйте базовый образ ```python:3.9-slim```. Протестируйте корректность сборки. Не забудьте dockerignore.
```
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY main.py .
ENTRYPOINT ["python"]
CMD ["./main.py"]
```

3. (Необязательная часть, *) Изучите инструкцию в проекте и запустите web-приложение без использования docker в venv. (Mysql БД можно запустить в docker run).
4. (Необязательная часть, *) По образцу предоставленного python кода внесите в него исправление для управления названием используемой таблицы через ENV переменную.
---
### ВНИМАНИЕ!
!!! В процессе последующего выполнения ДЗ НЕ изменяйте содержимое файлов в fork-репозитории! Ваша задача ДОБАВИТЬ 4 файла: ```Dockerfile.python```, ```compose.yaml```, ```.gitignore```, ```bash-скрипт```. Если вам понадобилось внести иные изменения в проект - вы что-то делаете неверно!
---

## Задача 2 (*)
1. Создайте в yandex cloud container registry с именем "test" с помощью "yc tool" . [Инструкция](https://cloud.yandex.ru/ru/docs/container-registry/quickstart/?from=int-console-help)
![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/02fc6089-79dd-4225-98b0-f988e8e1a343)

2. Настройте аутентификацию вашего локального docker в yandex container registry.
3. Соберите и залейте в него образ с python приложением из задания №1.
![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/e0083253-21cc-4cc0-b585-5bc5991d794b)

4. Просканируйте образ на уязвимости.
5. В качестве ответа приложите отчет сканирования.
   ![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/80e0fb91-7f8d-4844-9743-0b0690ce135c)


## Задача 3
1. Изучите файл "proxy.yaml"
2. Создайте в репозитории с проектом файл ```compose.yaml```. С помощью директивы "include" подключите к нему файл "proxy.yaml".
3. Опишите в файле ```compose.yaml``` следующие сервисы: 

- ```web```. Образ приложения должен ИЛИ собираться при запуске compose из файла ```Dockerfile.python``` ИЛИ скачиваться из yandex cloud container registry(из задание №2 со *). Контейнер должен работать в bridge-сети с названием ```backend``` и иметь фиксированный ipv4-адрес ```172.20.0.5```. Сервис должен всегда перезапускаться в случае ошибок.
Передайте необходимые ENV-переменные для подключения к Mysql базе данных по сетевому имени сервиса ```web``` 

- ```db```. image=mysql:8. Контейнер должен работать в bridge-сети с названием ```backend``` и иметь фиксированный ipv4-адрес ```172.20.0.10```. Явно перезапуск сервиса в случае ошибок. Передайте необходимые ENV-переменные для создания: пароля root пользователя, создания базы данных, пользователя и пароля для web-приложения.Обязательно используйте уже существующий .env file для назначения секретных ENV-переменных!
```
version: '3.8'
services:

  web:
    build:
      context: .
      dockerfile: Dockerfile.python
    container_name: web_python
    restart: on-failure
    networks:
      backend:
        ipv4_address: 172.20.0.5
    environment:
      - DB_HOST=db
      - DB_USER=${MYSQL_USER}
      - DB_PASSWORD=${MYSQL_PASSWORD}
      - DB_NAME=${MYSQL_DATABASE}


    depends_on:
      - reverse-proxy
      - ingress-proxy
      - db
    env_file:
      - .env

  db:
    image: mysql:8
    container_name: db_mysql
    restart: on-failure
    networks:
      backend:
        ipv4_address: 172.20.0.10
    ports:
      - "3306:3306"

    depends_on:
      - reverse-proxy
      - ingress-proxy

    env_file:
      - .env


include:
  - path:
     - proxy.yaml
```
4. Запустите проект локально с помощью docker compose , добейтесь его стабильной работы: команда ```curl -L http://127.0.0.1:8090``` должна возвращать в качестве ответа время и локальный IP-адрес.
   ![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/808192a9-368d-497f-b8fe-75dc77968a14)

5. Подключитесь к БД mysql с помощью команды ```docker exec <имя_контейнера> mysql -uroot -p<пароль root-пользователя>``` . Введите последовательно команды (не забываем в конце символ ; ): ```show databases; use <имя вашей базы данных(по-умолчанию example)>; show tables; SELECT * from requests LIMIT 10;```.
6. Остановите проект. В качестве ответа приложите скриншот sql-запроса.
   ![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/a6bedbc7-dfbe-4e65-a642-eb12d831de38)


## Задача 4
1. Запустите в Yandex Cloud ВМ (вам хватит 2 Гб Ram).

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/37c36769-3f73-4883-a550-d1e4beb19437)


2. Подключитесь к Вм по ssh и установите docker.
3. Напишите bash-скрипт, который скачает ваш fork-репозиторий в каталог /opt и запустит проект целиком.
4. Зайдите на сайт проверки http подключений, например(или аналогичный): ```https://check-host.net/check-http``` и запустите проверку вашего сервиса ```http://<внешний_IP-адрес_вашей_ВМ>:8090```. Таким образом трафик будет направлен в ingress-proxy.
5. (Необязательная часть) Дополнительно настройте remote ssh context к вашему серверу. Отобразите список контекстов и результат удаленного выполнения ```docker ps -a```
![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/f8603322-b799-4420-ad0e-64691366370b)

6. В качестве ответа повторите  sql-запрос и приложите скриншот с данного сервера, bash-скрипт и ссылку на fork-репозиторий.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/84bb8868-195c-4e59-9b58-83b16780a7d2)

```
#!/bin/bash
if [ -d /opt/hvirt ]; then
    sudo rm -rf /opt/hvirt
fi
sudo git clone https://github.com/LexionN/hvirtd-example-python.git /opt/hvirt
cd /opt/hvirt
docker compose down -v && docker compose up -d
```
https://github.com/LexionN/hvirtd-example-python/blob/main/README.md


## Задача 5 (*)
1. Напишите и задеплойте на вашу облачную ВМ bash скрипт, который произведет резервное копирование БД mysql в директорию "/opt/backup" с помощью запуска в сети "backend" контейнера из образа ```schnitzler/mysqldump``` при помощи ```docker run ...``` команды. Подсказка: "документация образа."

```
#!/bin/sh

if [ ! -d /opt/backup ]; then
    sudo mkdir /opt/backup && sudo chown -R  $USER:$USER /opt/backup
fi
#uname=$(ls -l $1 | awk '{print $3}')
if [ -O /opt/backup ];
 then
   now=$(date +"%s_%Y-%m-%d")
    docker run -d --network='hvirt_backend' schnitzler/mysqldump \
      /usr/bin/mysqldump --opt -h ${MYSQL_HOST} \
      -u ${MYSQL_USER} -p${MYSQL_PASSWORD} \
      ${MYSQL_DATABASE} > "/opt/backup/${now}_${MYSQL_DATABASE}.sql"

 else 
   sudo chown -R  $USER:$USER /opt/backup
fi
```

2. Протестируйте ручной запуск
3. Настройте выполнение скрипта раз в 1 минуту через cron, crontab или systemctl timer. Придумайте способ не светить логин/пароль в git!!

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/1e1836f9-2c62-4987-9ef9-7a6f89574698)

4. Предоставьте скрипт, cron-task и скриншот с несколькими резервными копиями в "/opt/backup"

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/f5ec6518-cb70-4354-87a5-fdda842bf5fd)

   

## Задача 6
Скачайте docker образ ```hashicorp/terraform:latest``` и скопируйте бинарный файл ```/bin/terraform``` на свою локальную машину, используя dive и docker save.
Предоставьте скриншоты  действий .

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/45a89624-1de6-4b02-b1aa-0a2f234a0137)
![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/8fbb2834-ddeb-4625-9fac-c90bd49d4ffc)



## Задача 6.1
Добейтесь аналогичного результата, используя docker cp.  
Предоставьте скриншоты  действий .

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/9d3fd088-bc0e-48ac-b25a-261e03e14cdd)

## Задача 6.2 (**)
Предложите способ извлечь файл из контейнера, используя только команду docker build и любой Dockerfile.  
Предоставьте скриншоты  действий .

## Задача 7 (***)
Запустите ваше python-приложение с помощью runC, не используя docker или containerd.  
Предоставьте скриншоты  действий . 
