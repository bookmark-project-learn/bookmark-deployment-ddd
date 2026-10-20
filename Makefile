.PHONY: up, down
up:
	docker-compose -f docker-compose.yaml up -d

down:
	docker-compose -f docker-compose.yaml down


.PHONY: generate-rsa-key, deploy, full-deploy

generate-rsa-key:
	openssl genpkey -algorithm RSA -out privatekey.pem -pkeyopt rsa_keygen_bits:2048
	openssl rsa -pubout -in privatekey.pem -out publickey.pem


deploy-bookmark-service:
	sudo docker ps -f "name=bookmark_service" --format '{{.Names}}' | grep -q bookmark_service && sudo docker rm -f bookmark_service
	sudo docker compose pull bookmark_service
	sudo docker compose up -d --remove-orphans bookmark_service

deploy-user-service:
	sudo docker ps -f "name=user_service" --format '{{.Names}}' | grep -q user_service && sudo docker rm -f user_service
	sudo docker compose pull user_service
	sudo docker compose up -d --remove-orphans user_service
clean-deploy-prune:
	sudo docker system prune -f