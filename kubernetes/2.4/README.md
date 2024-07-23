# Домашнее задание к занятию «Управление доступом»

### Цель задания

В тестовой среде Kubernetes нужно предоставить ограниченный доступ пользователю.

------

### Чеклист готовности к домашнему заданию

1. Установлено k8s-решение, например MicroK8S.
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым github-репозиторием.

------

### Инструменты / дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) RBAC.
2. [Пользователи и авторизация RBAC в Kubernetes](https://habr.com/ru/company/flant/blog/470503/).
3. [RBAC with Kubernetes in Minikube](https://medium.com/@HoussemDellai/rbac-with-kubernetes-in-minikube-4deed658ea7b).

------

### Задание 1. Создайте конфигурацию для подключения пользователя

1. Создайте и подпишите SSL-сертификат для подключения к кластеру.
2. Настройте конфигурационный файл kubectl для подключения.
3. Создайте роли и все необходимые настройки для пользователя.
4. Предусмотрите права пользователя. Пользователь может просматривать логи подов и их конфигурацию (`kubectl logs pod <pod_id>`, `kubectl describe pod <pod_id>`).
5. Предоставьте манифесты и скриншоты и/или вывод необходимых команд.

------

### Ответ

Создаю закрытый ключ:

```openssl genrsa -out user.key 2048```

Создаю запрос на подпись сертификата:

```openssl req -new -key user.key -out user.csr -subj "/CN=user/O=group"```

Подписываю CSR в Kubernetes CA. Для этого использую сертификат CA и ключ, которые находятся в /var/snap/microk8s/6809/certs. Сертификат будет действителен в течение 365 дней:

```openssl x509 -req -in user.csr -CA /var/snap/microk8s/6809/certs/ca.crt -CAkey /var/snap/microk8s/6809/certs/ca.key -CAcreateserial -out user.crt -days 365```

Создаю пользователя внутри Kubernetes:

```kubectl config set-credentials user --client-certificate=/home/user/.certs/user.crt --client-key=/home/user/.certs/user.key```

Задаю контекст для пользователя:

```kubectl config set-context user-context --cluster=microk8s-cluster --user=user```

Просматриваю конфигурацию и убеждаюсь, что пользователь и контекст создан:

![image](https://github.com/user-attachments/assets/ccf18b49-1668-4b0e-84e7-cd68cf2fd519)

Создаю [Role и RoleBinding](https://github.com/LexionN/SHDEVOPS-4/blob/main/kubernetes/2.4/src/role-rolebinding.yaml)

Применяю:

![image](https://github.com/user-attachments/assets/a2f12262-36af-4d2a-adfa-547f6e158852)

Переключаюсь на контекст user:

![image](https://github.com/user-attachments/assets/f60d35c3-4b0e-4621-bc7a-c5a5d5007c99)

Проверяю чтение логов:

![image](https://github.com/user-attachments/assets/8487c8a0-242c-4d1b-b863-5fc3e2efca31)

Проверяем discribe:

```
$ kubectl describe pod nginx-multitool-58d986c6c7-c99jh
Name:             nginx-multitool-58d986c6c7-c99jh
Namespace:        default
Priority:         0
Service Account:  default
Node:             home-01/192.168.2.159
Start Time:       Tue, 23 Jul 2024 16:18:12 +0400
Labels:           app=nginx-multitool
                  pod-template-hash=58d986c6c7
Annotations:      cni.projectcalico.org/containerID: d5d581e7b869b5f8f4a79ebc65ded26afda4c29582ff07dfabc9a38e4bbd25f2
                  cni.projectcalico.org/podIP: 10.1.151.103/32
                  cni.projectcalico.org/podIPs: 10.1.151.103/32
Status:           Running
IP:               10.1.151.103
IPs:
  IP:           10.1.151.103
Controlled By:  ReplicaSet/nginx-multitool-58d986c6c7
Containers:
  nginx:
    Container ID:   containerd://3e75cb6e3511365ae094f5dbac085686aa2d441c820507b7ae9d105b189a71c9
    Image:          nginx:latest
    Image ID:       docker.io/library/nginx@sha256:67682bda769fae1ccf5183192b8daf37b64cae99c6c3302650f6f8bf5f0f95df
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Tue, 23 Jul 2024 16:18:13 +0400
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /usr/share/nginx/html/ from index-html (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-hk4fd (ro)
  multitool:
    Container ID:   containerd://468b4b64a474faee40c079961b60c4b2307ea1344404632b9308ed01cc6c41c1
    Image:          wbitt/network-multitool
    Image ID:       docker.io/wbitt/network-multitool@sha256:d1137e87af76ee15cd0b3d4c7e2fcd111ffbd510ccd0af076fc98dddfc50a735
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Tue, 23 Jul 2024 16:18:14 +0400
    Ready:          True
    Restart Count:  0
    Environment:
      HTTP_PORT:  <set to the key 'key1' of config map 'my-configmap'>  Optional: false
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-hk4fd (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  index-html:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      my-configmap
    Optional:  false
  kube-api-access-hk4fd:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  104s  default-scheduler  Successfully assigned default/nginx-multitool-58d986c6c7-c99jh to home-01
  Normal  Pulled     104s  kubelet            Container image "nginx:latest" already present on machine
  Normal  Created    104s  kubelet            Created container nginx
  Normal  Started    104s  kubelet            Started container nginx
  Normal  Pulling    104s  kubelet            Pulling image "wbitt/network-multitool"
  Normal  Pulled     103s  kubelet            Successfully pulled image "wbitt/network-multitool" in 1.23s (1.23s including waiting)
  Normal  Created    103s  kubelet            Created container multitool
  Normal  Started    103s  kubelet            Started container multitool

```



### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------

