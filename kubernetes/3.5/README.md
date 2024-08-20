# Домашнее задание к занятию Troubleshooting

### Цель задания

Устранить неисправности при деплое приложения.

### Чеклист готовности к домашнему заданию

1. Кластер K8s.

### Задание. При деплое приложение web-consumer не может подключиться к auth-db. Необходимо это исправить

1. Установить приложение по команде:
```shell
kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
```
2. Выявить проблему и описать.
3. Исправить проблему, описать, что сделано.
4. Продемонстрировать, что проблема решена.

### Решение

Пробуем установить приложение:

![image](https://github.com/user-attachments/assets/29f8cd2c-931d-40de-b97d-f99ded2a2125)

Ошибка, отсутсвуют namespace web и data. Создадим их:

![image](https://github.com/user-attachments/assets/9a6624e5-3d75-4a50-b64f-36b67de4df88)


Пробуем еще раз установить приложение:

![image](https://github.com/user-attachments/assets/c172a4eb-7fc1-4b7e-804b-ac0fb6524404)

![image](https://github.com/user-attachments/assets/1e1eebab-a810-4bac-8f27-7ef4dbd88474)


На первый взгляд всё хорошо. Посмотрим "под капотом":

![image](https://github.com/user-attachments/assets/53b08e42-700a-4ced-912b-0e9646e94eef)


Видим что приложение auth-db недоступно из web-consumer

Попробуем подключиться к web-consumer и проверить доступность auth-db:

![image](https://github.com/user-attachments/assets/15581840-9ba2-4e2f-97eb-379732043f36)

Попробуем по полному имени:

![image](https://github.com/user-attachments/assets/8419ef0e-20f5-4310-b042-fb86a09483c9)

По полному имени auth-db резолвится. Неоходимо исправить deployment:

![image](https://github.com/user-attachments/assets/3661c5d1-9d3d-4da1-a675-d557a21ea579)

![image](https://github.com/user-attachments/assets/c726128b-eeef-42f8-a44f-f52077755398)

После исправления поды пересоздадутся:

![image](https://github.com/user-attachments/assets/2d4293b6-4525-4934-bd72-91c11a813c6f)

Проверим "под капотом" еще раз:

![image](https://github.com/user-attachments/assets/1b46c5de-3cfa-4f4e-b0cf-cfe5b7f32515)

Приложение работает.



### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
