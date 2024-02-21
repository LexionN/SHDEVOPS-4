# Домашнее задание к занятию 1 «Введение в Ansible»

## Основная часть

1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте значение, которое имеет факт `some_fact` для указанного хоста при выполнении playbook.
![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/9f427bc9-9d82-4a6a-8830-2a52414659d5)

2. Найдите файл с переменными (group_vars), в котором задаётся найденное в первом пункте значение, и поменяйте его на `all default fact`.
![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/7843280f-6ca1-44d6-a2dc-ac90d8017042)

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/7225d89d-bfbf-44fd-9a48-c548047246b0)

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/a495fc29-2303-4d5a-9452-a3b97339416c)

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились значения: для `deb` — `deb default fact`, для `el` — `el default fact`.
![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/14b7ae1d-32ec-4696-ad39-d2df52f98296)

6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/4f344c48-1b72-4980-8e05-7d8ea8caf768)

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/710c2b44-0c8f-4b53-a66e-7175aa12815a)

8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/b4c2f13c-3fc8-4a79-929f-a5b1b15b7ee0)

9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/0da6a705-0773-43df-9692-d32bfc705ba7)

11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь, что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/e2169819-645a-46af-bf4e-84ced7ec5cdf)

12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.
13. Предоставьте скриншоты результатов запуска команд.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/5374bc4a-3cb9-43e1-aeab-cae54aa86ae4)

2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/698d28df-aad2-4448-b27e-5d944787f3bb)
![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/ebdff230-84ea-4afc-a281-69748bac0e85)

4. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/67f0118d-fde0-44cd-8f7a-12faef41cd71)

5. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот вариант](https://hub.docker.com/r/pycontribs/fedora).
6. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
7. Все изменения должны быть зафиксированы и отправлены в ваш личный репозиторий.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
