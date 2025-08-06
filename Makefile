build: compress
	packer build .

compress: init
	rm -f puppet.tar.gz
	tar -czvf puppet.tar.gz *.pp modules .modules

init:
	packer init .
	bolt module install

only-8.1: compress
	packer build --only=docker.php8-1 .

only-8.2: compress
	packer build --only=docker.php8-2 .

only-8.3: compress
	packer build --only=docker.php8-3 .

only-8.4: compress
	packer build --only=docker.php8-4 .

login:
	echo '${DOCKER_TOKEN}' | docker login --username akester --password-stdin

push-remote: login
	docker push akester/php:8.1
	docker push akester/php:8.2
	docker push akester/php:8.3
	docker push akester/php:8.4
