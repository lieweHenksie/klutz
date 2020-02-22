# get project path
project_path := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))



# get path basename
project := $(shell basename $$PWD)

container_name=${project}-container
image_name=dev_${project}

build:
	cp ~/.Renviron ./
	docker build --tag ${image_name} -f ./Dockerfile . && \
	rm ./.Renviron

run:
	docker stop ${container_name}; \
	docker rm ${container_name}; \
	docker run \
		-ti \
		-d \
		-p 8888:8888 \
		-p 8787:8787 \
		-v ${project_path}:/home/rstudio/${project} \
		--name ${container_name} \
		${image_name}

shell:
	docker exec -ti ${container_name} bash

shell-rstudio:
	docker exec -ti --user rstudio ${container_name} bash

start:
	docker start ${container_name};

stop:
	docker stop ${container_name};

restart:
	docker restart ${container_name};

logs:
	docker logs -f ${container_name}

push:
	make test && \
	$$(aws ecr get-login --no-include-email --region ${AWS_DEFAULT_REGION} --profile=default) && \
	docker push ${image_name}:latest


all: build run
