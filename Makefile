CONTAINER_NAME=alpine-owncloud
IMAGE_NAME=bdereims/armhf-alpine-owncloud
VOLUME=/data/gv-01/docker-volunes/alpine-owncloud

build: Dockerfile
	docker build -t $(IMAGE_NAME) .

run:
	docker run -d \
	-p 443:443 \
	-v $(VOLUME):/var/www/owncloud/data \
	--name $(CONTAINER_NAME) $(IMAGE_NAME)

stop:
	docker stop $(CONTAINER_NAME) 
	docker rm $(CONTAINER_NAME) 

clean: 
	docker rmi $(IMAGE_NAME) 
	docker images

clean-volume:
	rm -fr $(VOLUME)/{*,.??*}

