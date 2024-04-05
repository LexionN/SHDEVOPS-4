# Домашнее задание к занятию 3 «Использование Ansible»

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/aca2a149-0521-4e29-873b-dc99543f93ab)

2. Репозиторий LightHouse находится [по ссылке](https://github.com/VKCOM/lighthouse).

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.

```
...

- name: Get lighthouse
  hosts: lighthouse
  pre_tasks:
    - name: Install GIT
      become: true
      ansible.builtin.package:
        name: git
        state: present
  tasks:
    - name: Get lighthouse distrib
      ansible.builtin.git:
        repo: "{{ url_to_lighthouse }}"
        #version: "master"
        dest: "{{ site_path }}"
        accept_hostkey: true

- name: Prepare NGINX
  hosts: lighthouse
  handlers:
    - name: Start nginx
      become: true
      ansible.builtin.command: nginx
    - name: Restart nginx
      become: true
      ansible.builtin.command: nginx -s reload
  tasks:
    - name: Get NGINX version
      become: true
      ansible.builtin.command: nginx -v
      register: nginx_result
      ignore_errors: true
      changed_when: false
    - name: Get, unpack and configure nginx
      block:
        - name: Install the 'Development tools' package group
          become: true
          ansible.builtin.yum:
            name: "@Development tools"
            state: present
        - name: Get NGINX distrib
          ansible.builtin.get_url:
            url: "https://nginx.org/download/nginx-{{ nginx_version }}.tar.gz"
            dest: /tmp
            mode: "0644"
        - name: Unpack nginx distrib
          ansible.builtin.unarchive:
            src: /tmp/nginx-{{ nginx_version }}.tar.gz
            dest: /tmp
            remote_src: true
        - name: Configure NGINX
          ansible.builtin.command:
            cmd: ./configure --without-http_rewrite_module --without-http_gzip_module
            chdir: /tmp/nginx-{{ nginx_version }}
          register: my_output
          changed_when: my_output.rc != 0
        - name: Make NGINX
          ansible.builtin.command:
            cmd: make
            chdir: /tmp/nginx-{{ nginx_version }}
          register: my_output
          changed_when: my_output.rc != 0
        - name: Install NGINX
          become: true
          ansible.builtin.command:
            cmd: make install
            chdir: /tmp/nginx-{{ nginx_version }}
          register: my_output
          changed_when: my_output.rc != 0
        - name: Make NGINX callable
          become: true
          ansible.builtin.file:
            src: /usr/local/nginx/sbin/nginx
            dest: /usr/bin/nginx
            state: link
            mode: "0744"
          notify: Start nginx
      when:
        - nginx_result.failed
        - nginx_version not in nginx_result.stdout
    - name: Configure nginx config for site
      become: true
      ansible.builtin.template:
        src: nginx.cfg.j2
        dest: /usr/local/nginx/conf/nginx.conf
        mode: "0644"
      notify: Restart nginx
    - name: Assure that directory conf.d exist
      become: true
      ansible.builtin.file:
        path: /usr/local/nginx/conf/conf.d
        state: directory
        mode: "0644"
    - name: Make config for lighthouse
      become: true
      ansible.builtin.template:
        src: default.cfg.j2
        dest: /usr/local/nginx/conf/conf.d/default.conf
        mode: "0644"
      notify: Restart nginx

```

2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.
4. Подготовьте свой inventory-файл `prod.yml`.

```
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: 158.160.66.158
      ansible_user: user
vector:
  hosts:
    vector-01:
      ansible_host: 158.160.82.98
      ansible_user: user
lighthouse:
  hosts:
    lighthouse-01:
      ansible_host: 158.160.6.221
      ansible_user: user
```

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/6ec979b9-d78e-4b99-aa8a-845a2f8e25bd)

9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

**Playbook устанавливает и настраивает конфигурацию связки Clickhouse, Vector и Lighthouse на трёх хостах, в данном случае использовалось Яндекс Облако**


10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---




### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
