# Домашнее задание к занятию 5 «Тестирование roles»

## Подготовка к выполнению

1. Установите molecule и его драйвера: `pip3 install "molecule molecule_docker molecule_podman`.
2. Выполните `docker pull aragast/netology:latest` —  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

## Основная часть

Ваша цель — настроить тестирование ваших ролей. 

Задача — сделать сценарии тестирования для vector. 

Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s ubuntu_xenial` (или с любым другим сценарием, не имеет значения) внутри корневой директории clickhouse-role, посмотрите на вывод команды. Данная команда может отработать с ошибками или не отработать вовсе, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу И из чего может состоять сценарий тестирования.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/047e363a-7eb0-4d25-a888-2251881206da)

2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
3. Добавьте несколько разных дистрибутивов (oraclelinux:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
4. Добавьте несколько assert в verify.yml-файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.). 

`verify.yml`
```
- name: Verify
  hosts: all
  gather_facts: true
  tasks:
  - name: Include vars
    ansible.builtin.include_vars:
      dir: '{{ lookup("env", "MOLECULE_PROJECT_DIRECTORY") }}/vars/'
      extensions:
        - 'yml'
  - name: Config file exists
    stat:
      path: "{{ vector_config_dir }}/vector.yml"
    register: config_stat
  - name: Check if config exists
    assert:
      that:
        - config_stat.stat.exists == True
      success_msg: "Config file exists"
      fail_msg: "Config file doesn't exist"

  - name: Get version of Vector
    ansible.builtin.command:
      cmd: vector --version
    register: version_of_vector

  - name: Vector start and enable vector service
    assert:
      that:
        - "vector_version in version_of_vector.stdout"
      success_msg: "Vector version is True"
      fail_msg: "Vector version is False"

```

5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.

```
user@home-01:~/dev/SHDEVOPS-4/ansible-05-testing/playbook/roles/vector-role$ molecule test
WARNING  Driver docker does not provide a schema.
INFO     default scenario test matrix: dependency, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)
changed: [localhost] => (item=oraclelinux_8)
changed: [localhost] => (item=centos7)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=instance)
ok: [localhost] => (item=oraclelinux_8)
ok: [localhost] => (item=centos7)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /home/user/dev/SHDEVOPS-4/ansible-05-testing/playbook/roles/vector-role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/oraclelinux:8', 'name': 'oraclelinux_8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/centos:centos7', 'name': 'centos7', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True}) 
skipping: [localhost] => (item={'image': 'docker.io/oraclelinux:8', 'name': 'oraclelinux_8', 'pre_build_image': True}) 
skipping: [localhost] => (item={'image': 'docker.io/centos:centos7', 'name': 'centos7', 'pre_build_image': True}) 
skipping: [localhost]

TASK [Synchronization the context] *********************************************
skipping: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True}) 
skipping: [localhost] => (item={'image': 'docker.io/oraclelinux:8', 'name': 'oraclelinux_8', 'pre_build_image': True}) 
skipping: [localhost] => (item={'image': 'docker.io/centos:centos7', 'name': 'centos7', 'pre_build_image': True}) 
skipping: [localhost]

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'false_condition': 'not item.pre_build_image | default(false)', 'item': {'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'false_condition': 'not item.pre_build_image | default(false)', 'item': {'image': 'docker.io/oraclelinux:8', 'name': 'oraclelinux_8', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'false_condition': 'not item.pre_build_image | default(false)', 'item': {'image': 'docker.io/centos:centos7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 2, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/quay.io/centos/centos:stream8) 
skipping: [localhost] => (item=molecule_local/docker.io/oraclelinux:8) 
skipping: [localhost] => (item=molecule_local/docker.io/centos:centos7) 
skipping: [localhost]

TASK [Create docker network(s)] ************************************************
skipping: [localhost]

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/oraclelinux:8', 'name': 'oraclelinux_8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/centos:centos7', 'name': 'centos7', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)
changed: [localhost] => (item=oraclelinux_8)
changed: [localhost] => (item=centos7)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': 'j922925715016.618200', 'results_file': '/home/user/.ansible_async/j922925715016.618200', 'changed': True, 'item': {'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': 'j958436394536.618225', 'results_file': '/home/user/.ansible_async/j958436394536.618225', 'changed': True, 'item': {'image': 'docker.io/oraclelinux:8', 'name': 'oraclelinux_8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (299 retries left).
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (298 retries left).
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (297 retries left).
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (296 retries left).
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (295 retries left).
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (294 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': 'j288004664270.618250', 'results_file': '/home/user/.ansible_async/j288004664270.618250', 'changed': True, 'item': {'image': 'docker.io/centos:centos7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=2    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]
ok: [oraclelinux_8]
ok: [centos7]

TASK [Include dir vector role] *************************************************

TASK [vector-role : Get vector distrib] ****************************************
changed: [instance]
changed: [oraclelinux_8]
changed: [centos7]

TASK [vector-role : Install vector] ********************************************
changed: [centos7]
changed: [instance]
changed: [oraclelinux_8]

TASK [vector-role : Configure Vector | ensure what directory exists] ***********
changed: [centos7]
changed: [instance]
changed: [oraclelinux_8]

TASK [vector-role : Configure Vector | Template config] ************************
changed: [centos7]
changed: [instance]
changed: [oraclelinux_8]

TASK [vector-role : Configure Service Vector| Template systemd unit] ***********
changed: [centos7]
changed: [oraclelinux_8]
changed: [instance]

RUNNING HANDLER [vector-role : Restart vector service] *************************
changed: [instance]
changed: [centos7]
changed: [oraclelinux_8]

PLAY RECAP *********************************************************************
centos7                    : ok=7    changed=6    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
instance                   : ok=7    changed=6    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
oraclelinux_8              : ok=7    changed=6    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running default > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]
ok: [oraclelinux_8]
ok: [centos7]

TASK [Include dir vector role] *************************************************

TASK [vector-role : Get vector distrib] ****************************************
ok: [instance]
ok: [centos7]
ok: [oraclelinux_8]

TASK [vector-role : Install vector] ********************************************
ok: [centos7]
ok: [instance]
ok: [oraclelinux_8]

TASK [vector-role : Configure Vector | ensure what directory exists] ***********
ok: [oraclelinux_8]
ok: [instance]
ok: [centos7]

TASK [vector-role : Configure Vector | Template config] ************************
ok: [centos7]
ok: [oraclelinux_8]
ok: [instance]

TASK [vector-role : Configure Service Vector| Template systemd unit] ***********
ok: [centos7]
ok: [oraclelinux_8]
ok: [instance]

PLAY RECAP *********************************************************************
centos7                    : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
instance                   : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
oraclelinux_8              : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running default > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]
ok: [oraclelinux_8]
ok: [centos7]

TASK [Include vars] ************************************************************
ok: [centos7]
ok: [instance]
ok: [oraclelinux_8]

TASK [Config file exists] ******************************************************
ok: [oraclelinux_8]
ok: [instance]
ok: [centos7]

TASK [Check if config exists] **************************************************
ok: [centos7] => {
    "changed": false,
    "msg": "Config file exists"
}
ok: [instance] => {
    "changed": false,
    "msg": "Config file exists"
}
ok: [oraclelinux_8] => {
    "changed": false,
    "msg": "Config file exists"
}

TASK [Get version of Vector] ***************************************************
changed: [centos7]
changed: [instance]
changed: [oraclelinux_8]

TASK [Vector start and enable vector service] **********************************
ok: [centos7] => {
    "changed": false,
    "msg": "Vector version is True"
}
ok: [instance] => {
    "changed": false,
    "msg": "Vector version is True"
}
ok: [oraclelinux_8] => {
    "changed": false,
    "msg": "Vector version is True"
}

PLAY RECAP *********************************************************************
centos7                    : ok=6    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
instance                   : ok=6    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
oraclelinux_8              : ok=6    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)
changed: [localhost] => (item=oraclelinux_8)
changed: [localhost] => (item=centos7)

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item=instance)
changed: [localhost] => (item=oraclelinux_8)
changed: [localhost] => (item=centos7)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```

6. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

[Vector-role v2.2.1](https://github.com/LexionN/vector-role/tree/v2.2.1)


### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example).
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.

`molecule.yml`
```
---
driver:
  name: podman
platforms:
  - name: instance
    image: quay.io/centos/centos:stream8
    pre_build_image: true
provisioner:
  name: ansible
scenario:
  test_sequence:
    - destroy
    - create
    - converge
    - destroy

```

6. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.

`tox.ini`
```
[tox]
minversion = 1.8
basepython = python3.6
envlist = py{37,39}-ansible{210,30}
skipsdist = true

[testenv]
passenv = *
deps =
    -r tox-requirements.txt
    ansible210: ansible<3.0
    ansible210: ansible-core<2.12
    ansible30: ansible<3.1
    ansible30: ansible-core<2.12
commands =
    {posargs:molecule test -s tox --destroy always}
```

8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/0ca8638d-8637-4b3a-b620-e0074a9a9c44)

9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

[Vector-role v2.2.1](https://github.com/LexionN/vector-role/tree/v2.2.1)

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на  ваш репозиторий и скриншоты этапов выполнения задания. 

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли LightHouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории.

В качестве решения пришлите ссылки и скриншоты этапов выполнения задания.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.
