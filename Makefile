AIOT_DEV_USR=ec2-user@54.65.95.105
AIOT_DEV_KEY=-i ~/.ssh/IoT_dev.pem


AIOT_PROD_USR=ec2-user@54.65.95.105
AIOT_PROD_KEY=-i ~/.ssh/IoT_dev.pem

start_docker:
	rm -rf ./build/*
	pnpm i && pnpm run build:local
	docker compose up -d


deploy_dev:
	rm -rf ./build/*
	bun i && bun run build
	sudo ssh $(AIOT_DEV_KEY) $(AIOT_DEV_USR) rm -rf /var/www/demo.bi.ai-ot.net/html/*
	sudo scp -r ${AIOT_DEV_KEY} ./dist/* ${AIOT_DEV_USR}:/var/www/demo.bi.ai-ot.net/html
	sudo ssh $(AIOT_DEV_KEY) $(AIOT_DEV_USR) sudo rm -rf /usr/share/nginx/demo.bi.ai-ot.net/html/*
	sudo ssh $(AIOT_DEV_KEY) $(AIOT_DEV_USR) sudo cp -r /var/www/demo.bi.ai-ot.net/html/* /usr/share/nginx/demo.bi.ai-ot.net/html
