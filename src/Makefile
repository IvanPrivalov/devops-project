#!make
export USER_NAME=privalovip
export APP_CRAWLER_VERSION=latest
export APP_UI_VERSION=latest

all : docker-build-crawler-bot docker-push-crawler-bot docker-build-crawler-ui docker-push-crawler-ui

.PHONY : all

######################################
# CRAWLER
docker-build-crawler-bot:
	cd ./crawler && ./docker_build.sh

docker-push-crawler-bot:
	docker login && docker push $(USER_NAME)/crawler-bot:$(APP_CRAWLER_VERSION)

######################################
# SEARCH-UI
docker-build-crawler-ui:
	cd ./ui && ./docker_build.sh

docker-push-crawler-ui:
	docker login && docker push $(USER_NAME)/crawler-ui:$(APP_UI_VERSION)
