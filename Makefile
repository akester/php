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

only-8.5: compress
	packer build --only=docker.php8-5 .

only-8.5-ssh: compress
	packer build --only=docker.php8-5-ssh .

login:
	echo '${DOCKER_TOKEN}' | docker login --username akester --password-stdin

push-8.1: login
	docker push akester/php:8.1

push-8.1-ssh: login
	docker push akester/php:8.1-ssh

push-8.2: login
	docker push akester/php:8.2

push-8.2-ssh: login
	docker push akester/php:8.2-ssh

push-8.3: login
	docker push akester/php:8.3

push-8.3-ssh: login
	docker push akester/php:8.3-ssh

push-8.4: login
	docker push akester/php:8.4

push-8.4-ssh: login
	docker push akester/php:8.4-ssh

push-8.5: login
	docker push akester/php:8.5

push-8.5-ssh: login
	docker push akester/php:8.5-ssh