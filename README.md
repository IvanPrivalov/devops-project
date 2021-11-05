## Проект DevOps
____

### Техническое задание.

Создание процесса непрерывной поставки для приложения с применением Практик CI/CD и быстрой обратной связью.

### Требования к проекту:

1) Автоматизированные процессы создания и управления платформой:
 - Инфраструктура для CI/CD
 - Инфраструктура для сбора обратной связи

2) Использование IaC (Infrastructure as Code) для управления конфигурацией и инфраструктурой.

3) Настроен процесс CI/CD.

4) Проект хранится в Git репозитории.

5) Настроен процесс сбора обратной связи:
 - Мониторинг (сбор метрик, алертинг, визуализация)
 - Логирование (опционально)
 - Трейсинг (опционально)
 - ChatOps (опционально)

6) Документация:
 - README по работе с репозиторием
 - Описание приложения и его архитектуры
 - How to start (по ходу README)
 - CHANGELOG с описанием выполненной работы

### Описание приложения.

Дано:

- Простое микросервисное приложение
- База данных
- Менеджер очередей сообщений

Пример сайта для парсинга:

[Crawler](https://github.com/express42/search_engine_crawler)

[UI](https://github.com/express42/search_engine_ui)

#### Архитектура приложения.

![image 14](https://github.com/IvanPrivalov/devops-project/blob/main/Screens/Screen_14.png)

![image 15](https://github.com/IvanPrivalov/devops-project/blob/main/Screens/Screen_15.png)

![image 16](https://github.com/IvanPrivalov/devops-project/blob/main/Screens/Screen_16.png)

### Ссылки на сервисы проекта:
____

| Сервис                                | Ссылка                           |
| ------------------------------------- | -------------------------------- |
| Приложение поиска (prod)              | http://crawler.3ddiamond.ru/     |
| Gitlab                                | http://gitlab.3ddiamond.ru/      |
| Grafana                               | http://grafana.3ddiamond.ru/     |

## Подготовка инфраструктуры с использованием trerraform
____

Инфраструктура разворачивается с помощью terraform в Yandex.Cloud, для этого подними k8s в Yandex.Cloud.

```sh
cd infra/k8s-terraform/
terraform init
terraform apply
```

Типы серверов реализованы модулями, и включают:

- ВМ для k8s master;
- ВМ для k8s node и LoadBalancer для k8s node;

![image 5](https://github.com/IvanPrivalov/devops-project/blob/main/Screens/Screen_5.png)

## Удаленное управление kubernetes

Для удаленного управления kubernetes понадобится kubectl и helm.

### kubectl

Установка kubectl:

```sh
cd /tmp
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.14.3/bin/linux/amd64/kubectl

chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
```

Создаем кластер и группу хостов. Подключаемся к кластеру::

```sh
yc managed-kubernetes cluster get-credentials k8s-cluster --external --force
```

Проверим подключение к нашему кластеру:

```sh
kubectl config current-context
```

Проверка:

```sh
kubectl get nodes
NAME                        STATUS   ROLES    AGE     VERSION
cl1aegvuf5dubg8rr3am-inel   Ready    <none>   6d11h   v1.19.15
cl1aegvuf5dubg8rr3am-ufer   Ready    <none>   6d11h   v1.19.15
```

### Helm

Установка helm:

```sh
sudo curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

Добавим репо:

```sh
helm repo add stable https://charts.helm.sh/stable && helm repo add incubator https://charts.helm.sh/incubator && helm repo add harbor https://helm.goharbor.io && helm repo update
```

Проверка:

```sh
helm version
version.BuildInfo{Version:"v3.7.0", GitCommit:"eeac83883cb4014fe60267ec6373570374ce770b", GitTreeState:"clean", GoVersion:"go1.16.8"}
```

## Развертывание GitLab

В рамках проекта развернут GitLab на отдельном сервере http://gitlab.3ddiamond.ru/

![image 4](https://github.com/IvanPrivalov/devops-project/blob/main/Screens/Screen_4.png)

Для установки GitLab в Yandex.Cloud используйте официальную инструкцию [https://cloud.yandex.ru/docs](https://cloud.yandex.ru/docs/solutions/infrastructure-management/gitlab-containers)

![image 8](https://github.com/IvanPrivalov/devops-project/blob/main/Screens/Screen_8.png)

## Развертывание Prometheus, Grafana, Alertmanager

За основу взят `kube-prometheus-stack` https://prometheus-community.github.io/helm-charts

Получаем kube-prometheus-stack на локальный диск

```sh
cd k8s/Helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm pull prometheus-community/kube-prometheus-stack --version 19.2.2 --untar
```

### Настройки Prometheus хранятся в `k8s/helm/kube-prometheus-stack/values.yaml`

Включены модули:

- alertmanager;
- kubeStateMetrics;
- nodeExporter;

Для prometheus сервера настроено:

- включены jobs
  - job_name: prometheus
  - job_name: 'kubernetes-apiservers'
  - job_name: 'kubernetes-nodes'
  - job_name: 'kubernetes-nodes-cadvisor'
  - job_name: 'kubernetes-service-endpoints'
  - job_name: 'prometheus-pushgateway'
  - job_name: 'kubernetes-services'
  - job_name: 'kubernetes-pods'

![image 9](https://github.com/IvanPrivalov/devops-project/blob/main/Screens/Screen_9.png)

![image 10](https://github.com/IvanPrivalov/devops-project/blob/main/Screens/Screen_10.png)

### Настройки Grafana хранятся в `k8s/helm/charts/grafana/values.yaml`

Настраиваем:

- ingress;
- datasource Prometheus по умолчанию;
- провайдера dashboards;
- базовые dashboards;

Импортирован dashboard [K8S Cluster Monitor](http://grafana.3ddiamond.ru/d/4b545447f/k8s-cluster-monitor?orgId=1&refresh=10s&from=1635213199398&to=1635223999398)

![image 11](https://github.com/IvanPrivalov/devops-project/blob/main/Screens/Screen_11.png)

### Настройки Alertmanager хранятся в `k8s/helm/kube-prometheus-stack/values.yaml`

Для alertmanager настроено:

- интеграция со slack каналом;

![image 12](https://github.com/IvanPrivalov/devops-project/blob/main/Screens/Screen_12.png)

![image 13](https://github.com/IvanPrivalov/devops-project/blob/main/Screens/Screen_13.png)

Устанавливаем kube-prometheus-stack:

```sh
helm upgrade --install kube-prometheus-stack kube-prometheus-stack/
```

Grafana доступен по ссылке http://grafana.3ddiamond.ru/

## Подготовка приложения
____

### Создание Docker образов

- Для сборки Docker образов приложений добавлены Dockerfile.

- Для локального запуска и тестирования добавлен Docker-compose file, котоый включает mongodb и rabbitmq

```shell

cd src

docker-compose up -d

```

- Для проверки работы веб-интефейса надо зайти по адресу http://HOST_IP:8000/, где HOST_IP - адрес хоста на котором запущен веб-интерфейс.

![image 1](https://github.com/IvanPrivalov/devops-project/blob/main/Screens/screen_1.png)

- Интерфейс для управления rabbitmq доступен на порту 15672.

- При первом запуске необходимо создать очередь, с которой будет работать crawler.

![image 2](https://github.com/IvanPrivalov/devops-project/blob/main/Screens/screen_2.png)

### Сборка docker образов

- Для сборки Dcoker образов и пуш в репозиторий, создан Makefile src/Makefile

```shell

cd src

# собрать и запушить все образы
make all

```

![image 3](https://github.com/IvanPrivalov/devops-project/blob/main/Screens/Screen_3.png)


### Создание Helm Charts

Созданы Helm Charts для каждого из компонентов приложения и главный Helm Chart приложения:

- компонент приложения mongodb
- компонент приложения nginx-ingress
- компонент приложения rabbitmq
- компонент приложения crawler-ui
- компонент приложения crawler-bot
- приложение crawler

```sh
cd k8s/Charts
```

#### Компонент приложения mongodb

За основу взят `mongo:3.2`

Настройки хранятся в `k8s/Charts/mongodb/values.yaml`

#### Компонент приложения nginx-ingress

За основу взят `stable/nginx-ingress` https://github.com/kubernetes/ingress-nginx

Настройки хранятся в `k8s/Charts/nginx-ingress/values.yaml`

#### Компонент приложения rabbitmq

За основу взят `rabbitmq:3-management`

Настройки хранятся в `k8s/Charts/rabbitmq/values.yaml`

#### Компонент приложения crawler-ui

Helm chart для компонента приложения crawler-ui создан в директории `k8s/Charts/crawler-ui`

#### Компонент приложения crawler-bot

Helm chart для компонента приложения crawler-bot создан в директории `k8s/Charts/crawler-bot`

#### Приложение crawler

Главный helm chart приложения, который включает все компоненты приложения со всеми зависимостями.

Загрузка зависимостей в helm chart приложения:

```sh
cd k8s/Charts/crawler
helm dep update
```

## Развертывание приложения в kubernetes

### Развертывание приложения crawler

Развернуть приложения в кластере kubernetes можно с использованием подготовленных helm charts:

- по отдельности каждый компонент.
- все приложение через главный helm chart приложения.

Пример развертывания отдельного компонента приложения:

```sh
cd k8s/Charts
helm upgrade --install --namespace=production mongodb mongodb/
helm upgrade --install --namespace=production nginx-ingress nginx-ingress/
helm upgrade --install --namespace=production rabbitmq rabbitmq/
helm upgrade --install --namespace=production crawler-ui crawler-ui/
helm upgrade --install --namespace=production crawler-bot crawler-bot/
```

Развертывание приложения со всеми зависимостями:

```sh
cd k8s/Charts/crawler

#обновляем изменения в зависимостях
helm dep update

#устанавливаем приложение
helm upgrade --install --namespace=production production crawler/
```

Проверка:

```sh
kubectl get pods -n production

NAME                                                        READY   STATUS    RESTARTS   AGE
mongodb-6f5db597c4-fm5fm                                    1/1     Running   0          5h42m
production-crawler-bot-5c89c744bc-bflq7                     1/1     Running   3          84m
production-crawler-ui-5cbc6566cd-9tmf2                      1/1     Running   0          84m
production-nginx-ingress-controller-8484b488d6-xzr2z        1/1     Running   0          5h42m
production-nginx-ingress-default-backend-76b66b5d45-gdl92   1/1     Running   0          5h42m
rabbitmq-6fd4f67648-fhcbz                                   1/1     Running   0          5h42m
```

```sh
helm list -A

NAME      	NAMESPACE          	REVISION	UPDATED                                	STATUS  	CHART               	APP VERSION
production	production         	7       	2021-10-24 16:44:00.444146869 +0000 UTC	deployed	crawler-1.0.1       	1          
runner    	gitlab-managed-apps	1       	2021-10-21 16:04:32.907283137 +0000 UTC	deployed	gitlab-runner-0.24.0	13.7.0
```

Приложение доступно по ссылке http://crawler.3ddiamond.ru/

![image 6](https://github.com/IvanPrivalov/devops-project/blob/main/Screens/Screen_6.png)

## GitLab CI/CD

### Настройка интеграции GitLab с Kubernetes

В Admin Area > Kubernetes добавляем существующий кластер.

В GitLab входит справка, по нажатию More information под полем, для получения нужной информации для интеграции. Выполнено в соответствии с руководством.

- Получаем API URL:

```sh
kubectl cluster-info | grep -E 'Kubernetes master|Kubernetes control plane' | awk '/http/ {print $NF}'
https://193.32.218.46
```

- Получаем CA certificate:

```sh
kubectl get secrets|grep -iE "name|default-token"
NAME                  TYPE                                  DATA   AGE
default-token-stkm6   kubernetes.io/service-account-token   3      3d5h

kubectl get secret default-token-stkm6 -o jsonpath="{['data']['ca\.crt']}" | base64 --decode

-----BEGIN CERTIFICATE-----
MIIC5zCCAc+gAwIBAgIBADANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDEwprdWJl
cm5ldGVzMB4XDTIxMTAxODA1MzYxMVoXDTMxMTAxNjA1MzYxMVowFTETMBEGA1UE
AxMKa3ViZXJuZXRlczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALVo
L0O9Sj5ixaEBSrG09NvcqW9sQbG9SOY4v8hq5BejlQiiNrkZCvg0jVAdn3x4oc0C
...
Lq2YiFQavwjjGdqaw7w/xuYBKL7V2NyRCR4FoQgCOvW925XCWM9EBVsg6Wc2jjrA
3HLVru/3XMFZ89dYKm98o9FzNIZ/K9ukTU08xdNpvbRDqJL1tMozV+HHMmyY7mUN
WmrPEU0oeQP638jTGl+51tXMYDU7Pjbqqco+/YNjD9UYR2gaOmYENUs/2OSEFRl6
OMMNCC+XN71WiNpL46VtWucGePgkplyXTDxc
-----END CERTIFICATE-----
```

- Получаем Service Token

```sh

# Применяем манифест с пользователем `gitlab`

cd k8s/GitLab
kubectl apply -f gitlab-admin-service-account.yaml

# Получаем token  пользователя `gitlab`

kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep gitlab | awk '{print $1}')

Name:         gitlab-token-vgfhr
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: gitlab
              kubernetes.io/service-account.uid: 22010e9a-1220-4dd9-80cf-49d79057a609

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1066 bytes
namespace:  11 bytes

```

- Указываем полученную информацию, завершаем интеграцию.

  > Снять галку с `GitLab-managed cluster`, иначе GitLab вместо использования учетной записи `gitlab` будет создавать дополнительные сервисные аккаунты и пытаться развернуть приложения с использованием этих сервисных аккаунтов.

![image 7](https://github.com/IvanPrivalov/devops-project/blob/main/Screens/Screen_7.png)

- В Application устанавливаем 

  - GitLab Runner

- Проверка:

```sh

kubectl get pods -n gitlab-managed-apps
NAME                                   READY   STATUS    RESTARTS   AGE
runner-gitlab-runner-dfcb8774b-68482   1/1     Running   0          3d12h

```

### CI/CD

В CI/CD реализованы следующие этапы (stages):

- build - сборка приложения;

- test - тестирование приложения (в данном этапе функционирует заглушка);

- review - обзор и проверка приложения;

- release - отправка образов на Docker Hub;

- cleanup - очистка окружения review, выполняется в ручную по кнопке в pipeline;

- production- развертывание приложения в окружении prod, приложение доступно по ссылке http://crawler.3ddiamond.ru/.

Общий принцип работы CI/CD:

- коммит в branch 

  - автоматически выполняются этапы build/test/review;
  - в ручную в pipeline выполняется cleanup (stop_review).

- коммит в master

  - автоматически выполняются этапы build/test/release/production;











