# Домашнее задание к занятию «Обновление приложений»

### Цель задания

Выбрать и настроить стратегию обновления приложения.

### Чеклист готовности к домашнему заданию

1. Кластер K8s.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Updating a Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment).
2. [Статья про стратегии обновлений](https://habr.com/ru/companies/flant/articles/471620/).

-----

### Задание 1. Выбрать стратегию обновления приложения и описать ваш выбор

1. Имеется приложение, состоящее из нескольких реплик, которое требуется обновить.
2. Ресурсы, выделенные для приложения, ограничены, и нет возможности их увеличить.
3. Запас по ресурсам в менее загруженный момент времени составляет 20%.
4. Обновление мажорное, новые версии приложения не умеют работать со старыми.
5. Вам нужно объяснить свой выбор стратегии обновления приложения.

### Решение

Здесь подходит вариант обновления recreate из-за ограниченности ресурсов и невозможности их увеличения, а также из-за несовместимости версий приложения.


### Задание 2. Обновить приложение

1. Создать deployment приложения с контейнерами nginx и multitool. Версию nginx взять 1.19. Количество реплик — 5.
2. Обновить версию nginx в приложении до версии 1.20, сократив время обновления до минимума. Приложение должно быть доступно.
3. Попытаться обновить nginx до версии 1.28, приложение должно оставаться доступным.
4. Откатиться после неудачного обновления.


### Решение

Создал namespace:

```
apiVersion: v1
kind: Namespace
metadata:
  name: update-app
```

Создал deployment с версией nginx 1.19:

```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment
  namespace: update-app
  labels:
    app: nginx-multitool
  annotations:
    kubernetes.io/change-cause: "nginx 1.19"
spec:
  replicas: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 50%
      maxUnavailable: 50%
  selector:
    matchLabels:
      app: nginx-multitool
  template:
    metadata:
      labels:
        app: nginx-multitool
    spec:
      containers:
      - name: nginx
        image: nginx:1.19
        ports:
          - containerPort: 80
      - name: multitool
        image: wbitt/network-multitool
        ports:
          - containerPort: 8080
        env:
          - name: HTTP_PORT
            value: "8080"
```

Применяем deployment и проверяем доступность подов:

![image](https://github.com/user-attachments/assets/a533a19f-e6a2-45d0-9eac-5613f05bc4c5)

![image](https://github.com/user-attachments/assets/08b5d399-abcf-4d4a-8fc1-cd8dd1b7a671)


Создадим новый deployment с версий nginx 1.20:

```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment
  namespace: update-app
  labels:
    app: nginx-multitool
  annotations:
    kubernetes.io/change-cause: "nginx 1.20"
spec:
  replicas: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 50%
      maxUnavailable: 50%
  selector:
    matchLabels:
      app: nginx-multitool
  template:
    metadata:
      labels:
        app: nginx-multitool
    spec:
      containers:
      - name: nginx
        image: nginx:1.20
        ports:
          - containerPort: 80
      - name: multitool
        image: wbitt/network-multitool
        ports:
          - containerPort: 8080
        env:
          - name: HTTP_PORT
            value: "8080"
```

Применяем deployment и проверяем доступность подов:

![image](https://github.com/user-attachments/assets/f9a75cdf-e763-4b58-b720-f4d922e5143d)


Создадим новый deployment с версий nginx 1.28:

```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment
  namespace: update-app
  labels:
    app: nginx-multitool
  annotations:
    kubernetes.io/change-cause: "nginx 1.28"
spec:
  replicas: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 50%
      maxUnavailable: 50%
  selector:
    matchLabels:
      app: nginx-multitool
  template:
    metadata:
      labels:
        app: nginx-multitool
    spec:
      containers:
      - name: nginx
        image: nginx:1.28
        ports:
          - containerPort: 80
      - name: multitool
        image: wbitt/network-multitool
        ports:
          - containerPort: 8080
        env:
          - name: HTTP_PORT
            value: "8080"
```

Применяем deployment и проверяем доступность подов:

![image](https://github.com/user-attachments/assets/4ce6e1bb-b5b1-48d5-9cfd-af18eab4ddd5)

![image](https://github.com/user-attachments/assets/4df77b01-954e-4c59-8f56-14a039e06cb3)


Как видим обновление прошло не успешно. Проверим лог:

![image](https://github.com/user-attachments/assets/81801c02-c06e-44ea-8c31-d762b10c3639)

Недоступен image приложения nginx 1.28


Проверим историю обновлений:

![image](https://github.com/user-attachments/assets/c53de447-66a6-4215-89c4-ecae98df30e5)


Откатимся на предыдущую рабочую версию:

![image](https://github.com/user-attachments/assets/c8aa9284-747c-4872-b41c-6bf25e467b28)


Проверим доступность подов:

![image](https://github.com/user-attachments/assets/ce26bdc5-35e8-4dc9-8806-b71d50aedbf3)


Проверим историю обновлений еще раз:

![image](https://github.com/user-attachments/assets/5385d447-8cb6-4205-a280-6556a12b5939)



## Дополнительные задания — со звёздочкой*

Задания дополнительные, необязательные к выполнению, они не повлияют на получение зачёта по домашнему заданию. **Но мы настоятельно рекомендуем вам выполнять все задания со звёздочкой.** Это поможет лучше разобраться в материале.   

### Задание 3*. Создать Canary deployment

1. Создать два deployment'а приложения nginx.
2. При помощи разных ConfigMap сделать две версии приложения — веб-страницы.
3. С помощью ingress создать канареечный деплоймент, чтобы можно было часть трафика перебросить на разные версии приложения.

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
