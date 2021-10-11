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

make all

```

![image 3](https://github.com/IvanPrivalov/devops-project/blob/main/Screens/Screen_3.png)
