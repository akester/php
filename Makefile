build: compress
	packer build -parallel-builds=1 .

build-all: compress
	packer build .

compress: init
	rm -f puppet.tar.gz
	tar -czvf puppet.tar.gz *.pp modules .modules

init:
	packer init .
	bolt module install

only-8.1: compress
	packer build --only=docker.php8-1 .

only-8.1-ssh: compress
	packer build --only=docker.php8-1-ssh .

only-8.2: compress
	packer build --only=docker.php8-2 .

only-8.2-ssh: compress
	packer build --only=docker.php8-2-ssh .

only-8.3: compress
	packer build --only=docker.php8-3 .

only-8.3-ssh: compress
	packer build --only=docker.php8-3-ssh .

only-8.4: compress
	packer build --only=docker.php8-4 .

only-8.4-ssh: compress
	packer build --only=docker.php8-4-ssh .

login:
	echo '${DOCKER_TOKEN}' | docker login --username akester --password-stdin

push-remote: login
	docker push akester/php:8.1
	docker push akester/php:8.1-ssh
	docker push akester/php:8.2
	docker push akester/php:8.2-ssh
	docker push akester/php:8.3
	docker push akester/php:8.3-ssh
	docker push akester/php:8.4
	docker push akester/php:8.4-ssh
