# Домашнее задание к занятию «Хранение в K8s. Часть 2»

### Цель задания

В тестовой среде Kubernetes нужно создать PV и продемострировать запись и хранение файлов.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным GitHub-репозиторием.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке NFS в MicroK8S](https://microk8s.io/docs/nfs). 
2. [Описание Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/). 
3. [Описание динамического провижининга](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/). 
4. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1

**Что нужно сделать**

Создать Deployment приложения, использующего локальный PV, созданный вручную.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Создать PV и PVC для подключения папки на локальной ноде, которая будет использована в поде.
3. Продемонстрировать, что multitool может читать файл, в который busybox пишет каждые пять секунд в общей директории. 
4. Удалить Deployment и PVC. Продемонстрировать, что после этого произошло с PV. Пояснить, почему.
5. Продемонстрировать, что файл сохранился на локальном диске ноды. Удалить PV.  Продемонстрировать что произошло с файлом после удаления PV. Пояснить, почему.
5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

### Ответ

Объединил в один yaml создание PV, PVC и Deployment:

[deployment_1.yaml](https://github.com/LexionN/SHDEVOPS-4/blob/main/kubernetes/2.2/src/deployment_1.yaml)

![image](https://github.com/user-attachments/assets/baa2bf08-c8a0-4300-ad0b-02ecbb2af7b4)

![image](https://github.com/user-attachments/assets/020ca650-f4fd-4077-85b6-e5e33e1ce5e7)

![image](https://github.com/user-attachments/assets/8a02ce3a-0650-4fa4-852f-98d54a2b8ecc)

![image](https://github.com/user-attachments/assets/71716365-164f-406a-94eb-e83188ad96c1)

После удаления PVC и Deployment, PV остался т.к. PV выступает как интерфейс или плагин к типу хранения.

![image](https://github.com/user-attachments/assets/f5f07038-0dab-4b0d-b4db-1b121081804b)

Соответственно после удаления PV, хранилище на ноде не удаляется, т.к чтобы удалить файлы при удалении pv, нужно использовать persistentVolumeReclaimPolicy: Recycle

![image](https://github.com/user-attachments/assets/f4d581e7-1a16-415a-bf30-74bcca3bce6a)


------

### Задание 2

**Что нужно сделать**

Создать Deployment приложения, которое может хранить файлы на NFS с динамическим созданием PV.

1. Включить и настроить NFS-сервер на MicroK8S.
2. Создать Deployment приложения состоящего из multitool, и подключить к нему PV, созданный автоматически на сервере NFS.
3. Продемонстрировать возможность чтения и записи файла изнутри пода. 
4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.


### Ответ

Объединил создание PV, PVC и Deployment в одном yaml:

[deployment_2.yaml](https://github.com/LexionN/SHDEVOPS-4/blob/main/kubernetes/2.2/src/deployment_2.yaml)

![image](https://github.com/user-attachments/assets/3a0f0a37-4f44-48aa-88ae-9693bc3da667)

![image](https://github.com/user-attachments/assets/3762c7e7-d0c5-47ad-abcb-fa3a58c7b974)

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
