FROM python:3.6-alpine

WORKDIR /app
ADD . /app

RUN pip install --no-cache-dir -r requirements.txt &&  pip install --no-cache-dir -r requirements-test.txt

ENV MONGO mongodb
ENV MONGO_PORT 27017
ENV RMQ_HOST rabbitmq
ENV RMQ_QUEUE rabbitmq
ENV RMQ_USERNAME rabbitmq
ENV RMQ_PASSWORD rabbitmq

ENV CHECK_INTERVAL 60
ENV EXCLUDE_URLS '.*github.com'

CMD python -u crawler/crawler.py https://vitkhab.github.io/search_engine_test_site/
