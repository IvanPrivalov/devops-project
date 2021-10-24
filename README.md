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

### Ссылки на сервисы проекта:
____

| Сервис                                | Ссылка                           |
| ------------------------------------- | -------------------------------- |
| Приложение поиска (prod)              | http://crawler.3ddiamond.ru/     |
| Gitlab                                | http://gitlab.3ddiamond.ru       |
| Grafana                               |                                  |
| Prometheus                            |                                  |

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

В рамках проекта развернут GitLab на отдельном сервере.

Для установки GitLab в Yandex.Cloud используйте официальную инструкцию [https://cloud.yandex.ru/docs](https://cloud.yandex.ru/docs/solutions/infrastructure-management/gitlab-containers)

![image 4](https://github.com/IvanPrivalov/devops-project/blob/main/Screens/Screen_4.png)

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


