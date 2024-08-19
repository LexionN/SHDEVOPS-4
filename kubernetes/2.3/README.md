
# Домашнее задание к занятию «Конфигурация приложений»

### Цель задания

В тестовой среде Kubernetes необходимо создать конфигурацию и продемонстрировать работу приложения.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8s).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым GitHub-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/configuration/secret/) Secret.
2. [Описание](https://kubernetes.io/docs/concepts/configuration/configmap/) ConfigMap.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment приложения и решить возникшую проблему с помощью ConfigMap. Добавить веб-страницу

1. Создать Deployment приложения, состоящего из контейнеров nginx и multitool.
2. Решить возникшую проблему с помощью ConfigMap.
3. Продемонстрировать, что pod стартовал и оба конейнера работают.
4. Сделать простую веб-страницу и подключить её к Nginx с помощью ConfigMap. Подключить Service и показать вывод curl или в браузере.
5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.


### Ответ

Создал yaml содержащий ConfigMap, Service и Deployment из двух контейнеров nginx и multitool:

[deployment.yaml](https://github.com/LexionN/SHDEVOPS-4/blob/main/kubernetes/2.3/src/deployment.yaml)

![image](https://github.com/user-attachments/assets/439179bd-3f90-4966-85b8-9c304df58061)

Запустил Port-forward:

![image](https://github.com/user-attachments/assets/7c3b714b-2518-40ef-beb1-3b00a9d7cc4f)

Результат:

![image](https://github.com/user-attachments/assets/e5e7454e-0cae-478a-88c2-366037d1646c)

![image](https://github.com/user-attachments/assets/2b1ef0cb-ff78-4636-82b8-7bddf1f3c027)

------

### Задание 2. Создать приложение с вашей веб-страницей, доступной по HTTPS 

1. Создать Deployment приложения, состоящего из Nginx.
2. Создать собственную веб-страницу и подключить её как ConfigMap к приложению.
3. Выпустить самоподписной сертификат SSL. Создать Secret для использования сертификата.
4. Создать Ingress и необходимый Service, подключить к нему SSL в вид. Продемонстировать доступ к приложению по HTTPS. 
4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

### Ответ

Выпускаем сертификат и ключ к нему:

![image](https://github.com/user-attachments/assets/a793c058-6de4-4609-bd9e-2123bbc92106)

На основе изданного сертификата и ключа дополнил yaml необходимым Secret и Ingress:

[deployment-https.yaml](https://github.com/LexionN/SHDEVOPS-4/blob/main/kubernetes/2.3/src/deployment-https.yaml)

Применил yaml:

![image](https://github.com/user-attachments/assets/4f5cff7e-4f35-46fc-9945-8bd5d0c810d9)

Результат:

![image](https://github.com/user-attachments/assets/1716d072-4ced-4e97-b3fe-2856e166dff2)

![image](https://github.com/user-attachments/assets/a49a3682-a6c9-42e7-b1b8-aaaf46d24d8a)

------

### Правила приёма работы

1. Домашняя работа оформляется в своём GitHub-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------
