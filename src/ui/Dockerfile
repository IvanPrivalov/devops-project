FROM python:3.6-alpine

WORKDIR /app
ADD . /app

RUN pip install --no-cache-dir -r requirements.txt &&  pip install --no-cache-dir -r requirements-test.txt

ENV MONGO mongo_db
ENV MONGO_PORT 27017

CMD cd ui && FLASK_APP=ui.py gunicorn ui:app -b 0.0.0.0
