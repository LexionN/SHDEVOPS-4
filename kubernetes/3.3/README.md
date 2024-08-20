# Домашнее задание к занятию «Как работает сеть в K8s»

### Цель задания

Настроить сетевую политику доступа к подам.

### Чеклист готовности к домашнему заданию

1. Кластер K8s с установленным сетевым плагином Calico.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Calico](https://www.tigera.io/project-calico/).
2. [Network Policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/).
3. [About Network Policy](https://docs.projectcalico.org/about/about-network-policy).

-----

### Задание 1. Создать сетевую политику или несколько политик для обеспечения доступа

1. Создать deployment'ы приложений frontend, backend и cache и соответсвующие сервисы.
2. В качестве образа использовать network-multitool.
3. Разместить поды в namespace App.
4. Создать политики, чтобы обеспечить доступ frontend -> backend -> cache. Другие виды подключений должны быть запрещены.
5. Продемонстрировать, что трафик разрешён и запрещён.


### Решение

Создал namespace:

```
apiVersion: v1
kind: Namespace
metadata:
  name: netology-app
```

Создал deployment и service приложения frontend:

```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: deployment-frontend
  name: deployment-frontend
  namespace: netology-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
        - name: frontend-multitool
          image: wbitt/network-multitool

---
apiVersion: v1
kind: Service
metadata:
  name: service-frontend
  namespace: netology-app
spec:
  selector:
    app: frontend
  ports:
    - name: port-80
      port: 80
      targetPort: 80
```

Создал deployment и service приложения backend:

```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: deployment-backend
  name: deployment-backend
  namespace: netology-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
        - name: backend-multitool
          image: wbitt/network-multitool

---
apiVersion: v1
kind: Service
metadata:
  name: service-backend
  namespace: netology-app
spec:
  selector:
    app: backend
  ports:
    - name: port-80
      port: 80
      targetPort: 80
```

Создал deployment и service приложения cache:

```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: deployment-cache
  name: deployment-cache
  namespace: netology-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cache
  template:
    metadata:
      labels:
        app: cache
    spec:
      containers:
        - name: cache-multitool
          image: wbitt/network-multitool

---
apiVersion: v1
kind: Service
metadata:
  name: service-cache
  namespace: netology-app
spec:
  selector:
    app: cache
  ports:
    - name: port-80
      port: 80
      targetPort: 80
```

Применяем созданные namespace, deployments, service и проверяем работу подов:

![image](https://github.com/user-attachments/assets/c3261c01-5582-4fa2-9411-458b14c9c7ed)

Проверим работу сети до применения политики доступа:

![image](https://github.com/user-attachments/assets/951734e5-aee5-4460-a347-5e8f98429a4e)

Как видим доступы есть.

Создадим политику доступа:

```
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: netology-app
spec:
  podSelector: {}
  policyTypes:
    - Ingress

---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: frontend-to-backend-policy
  namespace: netology-app
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
    - Ingress
  ingress:
    - from:
      - podSelector:
          matchLabels:
            app: frontend
      ports:
        - protocol: TCP
          port: 80

---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-to-cache-policy
  namespace: netology-app
spec:
  podSelector:
    matchLabels:
      app: cache
  policyTypes:
    - Ingress
  ingress:
    - from:
      - podSelector:
          matchLabels:
            app: backend
      ports:
        - protocol: TCP
          port: 80
```

Применим её:

![image](https://github.com/user-attachments/assets/8cb87528-7ed5-4d46-a3b5-0e761785518b)

![image](https://github.com/user-attachments/assets/669e64da-12dc-4573-af67-dd7b42df86b7)

Проверим доступность подов:

![image](https://github.com/user-attachments/assets/865d4970-a3bc-4ea7-af64-365e5e50be99)

Политика доступа работает frontend->backend->cache и никак иначе.



### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
