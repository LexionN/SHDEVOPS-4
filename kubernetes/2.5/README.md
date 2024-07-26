# Домашнее задание к занятию «Helm»

### Цель задания

В тестовой среде Kubernetes необходимо установить и обновить приложения с помощью Helm.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение, например, MicroK8S.
2. Установленный локальный kubectl.
3. Установленный локальный Helm.
4. Редактор YAML-файлов с подключенным репозиторием GitHub.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://helm.sh/docs/intro/install/) по установке Helm. [Helm completion](https://helm.sh/docs/helm/helm_completion/).

------

### Задание 1. Подготовить Helm-чарт для приложения

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения. 
2. Каждый компонент приложения деплоится отдельным deployment’ом или statefulset’ом.
3. В переменных чарта измените образ приложения для изменения версии.

### Ответ

1. Проверим версию и корректность установленного helm:

```
$helm version
version.BuildInfo{Version:"v3.15.3", GitCommit:"3bb50bbbdd9c946ba9989fbe4fb4104766302a64", GitTreeState:"clean", GoVersion:"go1.22.5"}
```

2. Создадим чарт:
```
$ helm create chart1
Creating chart1
```
3. Изменим в файле Chart.yaml версию приложения и версию чарта:

```
user@home-01:~/dev/SHDEVOPS-4/kubernetes/2.5/src$ cat chart1/Chart.yaml 
apiVersion: v2
name: chart1
description: A Helm chart for Kubernetes

# A chart can be either an 'application' or a 'library' chart.
#
# Application charts are a collection of templates that can be packaged into versioned archives
# to be deployed.
#
# Library charts provide useful utilities or functions for the chart developer. They're included as
# a dependency of application charts to inject those utilities and functions into the rendering
# pipeline. Library charts do not define any templates and therefore cannot be deployed.
type: application

# This is the chart version. This version number should be incremented each time you make changes
# to the chart and its templates, including the app version.
# Versions are expected to follow Semantic Versioning (https://semver.org/)
version: 1

# This is the version number of the application being deployed. This version number should be
# incremented each time you make changes to the application. Versions are not expected to
# follow Semantic Versioning. They should reflect the version the application is using.
# It is recommended to use it with quotes.
appVersion: "1.23.0"
```

4. Установим чарт:

```
user@home-01:~/dev/SHDEVOPS-4/kubernetes/2.5/src$ helm install chart chart1
NAME: chart
LAST DEPLOYED: Fri Jul 26 16:05:38 2024
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=chart1,app.kubernetes.io/instance=chart" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT
```

5. Убедимся что чарт установлен:

![image](https://github.com/user-attachments/assets/daa70a1a-afec-49ae-b59f-d1685932a088)

6. Для демонстрации новой версии приложения, скопируем chart1 в chart2 и изменим версию nginx и чарта в файле Chart.yaml

```
user@home-01:~/dev/SHDEVOPS-4/kubernetes/2.5/src$ cat chart2/Chart.yaml 
apiVersion: v2
name: chart1
description: A Helm chart for Kubernetes

# A chart can be either an 'application' or a 'library' chart.
#
# Application charts are a collection of templates that can be packaged into versioned archives
# to be deployed.
#
# Library charts provide useful utilities or functions for the chart developer. They're included as
# a dependency of application charts to inject those utilities and functions into the rendering
# pipeline. Library charts do not define any templates and therefore cannot be deployed.
type: application

# This is the chart version. This version number should be incremented each time you make changes
# to the chart and its templates, including the app version.
# Versions are expected to follow Semantic Versioning (https://semver.org/)
version: 2

# This is the version number of the application being deployed. This version number should be
# incremented each time you make changes to the application. Versions are not expected to
# follow Semantic Versioning. They should reflect the version the application is using.
# It is recommended to use it with quotes.
appVersion: "1.24.0"
```
7. Применим обновления к запущенному чарту:

```
user@home-01:~/dev/SHDEVOPS-4/kubernetes/2.5/src$ helm upgrade chart chart2
Release "chart" has been upgraded. Happy Helming!
NAME: chart
LAST DEPLOYED: Fri Jul 26 16:10:15 2024
NAMESPACE: default
STATUS: deployed
REVISION: 2
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=chart1,app.kubernetes.io/instance=chart" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT
```

8. Смотрим, что обновления применились:

![image](https://github.com/user-attachments/assets/b7d19206-edd0-4208-9c8d-f58b2844ab4c)


------
### Задание 2. Запустить две версии в разных неймспейсах

1. Подготовив чарт, необходимо его проверить. Запуститe несколько копий приложения.
2. Одну версию в namespace=app1, вторую версию в том же неймспейсе, третью версию в namespace=app2.
3. Продемонстрируйте результат.

### Ответ

1. Подготовим namespaces:

```
user@home-01:~/dev/SHDEVOPS-4/kubernetes/2.5/src$ kubectl create namespace app1
namespace/app1 created
user@home-01:~/dev/SHDEVOPS-4/kubernetes/2.5/src$ kubectl create namespace app2
namespace/app2 created
```

2. В продолжении работы скопируем chart1 в chart3 и изменим версию приложения и чарта

```
user@home-01:~/dev/SHDEVOPS-4/kubernetes/2.5/src$ cp -r chart1 chart3
user@home-01:~/dev/SHDEVOPS-4/kubernetes/2.5/src$ cat chart3/Chart.yaml 
apiVersion: v2
name: chart1
description: A Helm chart for Kubernetes

# A chart can be either an 'application' or a 'library' chart.
#
# Application charts are a collection of templates that can be packaged into versioned archives
# to be deployed.
#
# Library charts provide useful utilities or functions for the chart developer. They're included as
# a dependency of application charts to inject those utilities and functions into the rendering
# pipeline. Library charts do not define any templates and therefore cannot be deployed.
type: application

# This is the chart version. This version number should be incremented each time you make changes
# to the chart and its templates, including the app version.
# Versions are expected to follow Semantic Versioning (https://semver.org/)
version: 3

# This is the version number of the application being deployed. This version number should be
# incremented each time you make changes to the application. Versions are not expected to
# follow Semantic Versioning. They should reflect the version the application is using.
# It is recommended to use it with quotes.
appVersion: "1.25.0"
```

3. При проверке чартов возникла ошибка

```
user@home-01:~/dev/SHDEVOPS-4/kubernetes/2.5/src$ helm lint chart1
==> Linting chart1
[ERROR] Chart.yaml: version should be of type string but it's of type float64
[INFO] Chart.yaml: icon is recommended

Error: 1 chart(s) linted, 1 chart(s) failed
```

4. Изменим во всех чартах Chart.yaml заключив в кавычки в номер версии чарта. После этого проверки проходят успешно:

```
user@home-01:~/dev/SHDEVOPS-4/kubernetes/2.5/src$ helm lint chart1
==> Linting chart1
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, 0 chart(s) failed
user@home-01:~/dev/SHDEVOPS-4/kubernetes/2.5/src$ helm lint chart2
==> Linting chart2
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, 0 chart(s) failed
user@home-01:~/dev/SHDEVOPS-4/kubernetes/2.5/src$ helm lint chart3
==> Linting chart3
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, 0 chart(s) failed
```

5. Запустим одну версию в namespace=app1, вторую версию в том же неймспейсе, третью версию в namespace=app2

```
user@home-01:~/dev/SHDEVOPS-4/kubernetes/2.5/src$ helm install chartv1 chart1 -n app1
NAME: chartv1
LAST DEPLOYED: Fri Jul 26 16:26:23 2024
NAMESPACE: app1
STATUS: deployed
REVISION: 1
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace app1 -l "app.kubernetes.io/name=chart1,app.kubernetes.io/instance=chartv1" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace app1 $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace app1 port-forward $POD_NAME 8080:$CONTAINER_PORT
user@home-01:~/dev/SHDEVOPS-4/kubernetes/2.5/src$ helm install chartv2 chart2 -n app1
NAME: chartv2
LAST DEPLOYED: Fri Jul 26 16:26:30 2024
NAMESPACE: app1
STATUS: deployed
REVISION: 1
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace app1 -l "app.kubernetes.io/name=chart1,app.kubernetes.io/instance=chartv2" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace app1 $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace app1 port-forward $POD_NAME 8080:$CONTAINER_PORT
user@home-01:~/dev/SHDEVOPS-4/kubernetes/2.5/src$ helm install chartv3 chart3 -n app2
NAME: chartv3
LAST DEPLOYED: Fri Jul 26 16:26:37 2024
NAMESPACE: app2
STATUS: deployed
REVISION: 1
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace app2 -l "app.kubernetes.io/name=chart1,app.kubernetes.io/instance=chartv3" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace app2 $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace app2 port-forward $POD_NAME 8080:$CONTAINER_PORT
```

6. Проверим корректность размещения версий приложения в namespaces:

![image](https://github.com/user-attachments/assets/af070525-38b6-45da-ab7d-810bbb65b70f)


![image](https://github.com/user-attachments/assets/4cd12aca-8283-445a-bc72-8625da62e35c)


[chart1](https://github.com/LexionN/SHDEVOPS-4/tree/main/kubernetes/2.5/src/chart1)

[chart2](https://github.com/LexionN/SHDEVOPS-4/tree/main/kubernetes/2.5/src/chart2)

[chart3](https://github.com/LexionN/SHDEVOPS-4/tree/main/kubernetes/2.5/src/chart3)



### Правила приёма работы

1. Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, `helm`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
