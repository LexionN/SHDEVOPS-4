# Домашнее задание к занятию 9 «Процессы CI/CD»

## Подготовка к выполнению

1. Создайте два VM в Yandex Cloud с параметрами: 2CPU 4RAM Centos7 (остальное по минимальным требованиям).

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/f2138677-2fec-4d3e-b881-9060559c50ab)

2. Пропишите в [inventory](./infrastructure/inventory/cicd/hosts.yml) [playbook](./infrastructure/site.yml) созданные хосты.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/defe6f48-2c26-46aa-9191-dd9274cf9013)

3. Добавьте в [files](./infrastructure/files/) файл со своим публичным ключом (id_rsa.pub). Если ключ называется иначе — найдите таску в плейбуке, которая использует id_rsa.pub имя, и исправьте на своё.
4. Запустите playbook, ожидайте успешного завершения.

Изменил версию Postgresql на 12, в playbook исправил жестко прописанные в некоторых местах версии postgresql на переменную `postgresql_version`

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/6506fe1e-e2bc-429e-b6e7-e2c6592a9bde)

5. Проверьте готовность SonarQube через [браузер](http://localhost:9000).

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/29a3def4-82df-405f-b432-a0371faccb3b)

6. Зайдите под admin\admin, поменяйте пароль на свой.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/40579b4f-4779-4872-bd81-c546226230c8)

7.  Проверьте готовность Nexus через [бразуер](http://localhost:8081).

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/a3f0c650-4d9c-4de3-b879-52ed4db09fa6)

8. Подключитесь под admin\admin123, поменяйте пароль, сохраните анонимный доступ.

## Знакомоство с SonarQube

### Основная часть

1. Создайте новый проект, название произвольное.
2. Скачайте пакет sonar-scanner, который вам предлагает скачать SonarQube.
3. Сделайте так, чтобы binary был доступен через вызов в shell (или поменяйте переменную PATH, или любой другой, удобный вам способ).
4. Проверьте `sonar-scanner --version`.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/e663b96f-3fa4-4a7e-b21f-c696fbaf6b36)

5. Запустите анализатор против кода из директории [example](./example) с дополнительным ключом `-Dsonar.coverage.exclusions=fail.py`.
6. Посмотрите результат в интерфейсе.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/3f3a64ca-5f9e-4750-90d0-e7003589b29d)

7. Исправьте ошибки, которые он выявил, включая warnings.
8. Запустите анализатор повторно — проверьте, что QG пройдены успешно.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/acd1721b-ae31-4aff-a14f-0a6c74fa666b)

9. Сделайте скриншот успешного прохождения анализа, приложите к решению ДЗ.

## Знакомство с Nexus

### Основная часть

1. В репозиторий `maven-public` загрузите артефакт с GAV-параметрами:

 *    groupId: netology;
 *    artifactId: java;
 *    version: 8_282;
 *    classifier: distrib;
 *    type: tar.gz.
   
2. В него же загрузите такой же артефакт, но с version: 8_102.
3. Проверьте, что все файлы загрузились успешно.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/ebc71776-8091-499e-b791-2a816c90914e)

4. В ответе пришлите файл `maven-metadata.xml` для этого артефекта.

[maven-metadata.xml](https://github.com/LexionN/SHDEVOPS-4/blob/main/ci/03-cicd/maven-metadata.xml)


### Знакомство с Maven

### Подготовка к выполнению

1. Скачайте дистрибутив с [maven](https://maven.apache.org/download.cgi).
2. Разархивируйте, сделайте так, чтобы binary был доступен через вызов в shell (или поменяйте переменную PATH, или любой другой, удобный вам способ).
3. Удалите из `apache-maven-<version>/conf/settings.xml` упоминание о правиле, отвергающем HTTP- соединение — раздел mirrors —> id: my-repository-http-unblocker.
4. Проверьте `mvn --version`.
5. Заберите директорию [mvn](./mvn) с pom.

### Основная часть

1. Поменяйте в `pom.xml` блок с зависимостями под ваш артефакт из первого пункта задания для Nexus (java с версией 8_282).
2. Запустите команду `mvn package` в директории с `pom.xml`, ожидайте успешного окончания.
3. Проверьте директорию `~/.m2/repository/`, найдите ваш артефакт.
4. В ответе пришлите исправленный файл `pom.xml`.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
