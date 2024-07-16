# Домашнее задание к занятию «Хранение в K8s. Часть 1»

### Цель задания

В тестовой среде Kubernetes нужно обеспечить обмен файлами между контейнерам пода и доступ к логам ноды.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным GitHub-репозиторием.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке MicroK8S](https://microk8s.io/docs/getting-started).
2. [Описание Volumes](https://kubernetes.io/docs/concepts/storage/volumes/).
3. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1 

**Что нужно сделать**

Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.
3. Обеспечить возможность чтения файла контейнером multitool.
4. Продемонстрировать, что multitool может читать файл, который периодоически обновляется.
5. Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.


### Ответ

[deployment_1.yaml](https://github.com/LexionN/SHDEVOPS-4/blob/main/kubernetes/2.1/src/deployment_1.yaml)

![image](https://github.com/user-attachments/assets/dd630e19-cfb1-4b2c-adf8-31830746c7da)

![image](https://github.com/user-attachments/assets/0cecceda-e80b-4805-85fd-5a9f792e4b87)

![image](https://github.com/user-attachments/assets/36d7fed9-2281-4dde-bfb8-3131e456d206)

![image](https://github.com/user-attachments/assets/71ca4889-150a-49ba-8200-435be2a25570)



------

### Задание 2

**Что нужно сделать**

Создать DaemonSet приложения, которое может прочитать логи ноды.

1. Создать DaemonSet приложения, состоящего из multitool.
2. Обеспечить возможность чтения файла `/var/log/syslog` кластера MicroK8S.
3. Продемонстрировать возможность чтения файла изнутри пода.
4. Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.


### Ответ

[deployment_2.yaml](https://github.com/LexionN/SHDEVOPS-4/blob/main/kubernetes/2.1/src/deployment_2.yaml)

![image](https://github.com/user-attachments/assets/1b71adc9-1371-4f27-8854-6da8ab5a503c)

![image](https://github.com/user-attachments/assets/8ce4d9ff-c15e-487c-bb8c-3e544bbf55eb)




------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------
