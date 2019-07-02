.DEFAULT_GOAL := help
SHELL := /bin/bash


help: ## This help dialog.
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##/:/'`); \
	printf "%-30s %s\n" "DevOps console for Project Courses" ; \
	printf "%-30s %s\n" "==================================" ; \
	printf "%-30s %s\n" "" ; \
	printf "%-30s %s\n" "Target" "Help" ; \
	printf "%-30s %s\n" "------" "----" ; \
	for help_line in $${help_lines[@]}; do \
        IFS=$$':' ; \
        help_split=($$help_line) ; \
        help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        printf '\033[36m'; \
        printf "%-30s %s" $$help_command ; \
        printf '\033[0m'; \
        printf "%s\n" $$help_info; \
    done

%:      # thanks to chakrit
	@:    # thanks to Wi.lliam Pursell


bootstrap-environment: requirements bootstrap-environment-message ## Bootstrap development environment!

requirements: requirements-bootstrap ## Install requirements on workstation

requirements-bootstrap: ## Prepare basic packages on workstation
	workflow/requirements/MacOSX/bootstrap
	source ~/.bash_profile && rbenv install --skip-existing 2.2.2
	source ~/.bash_profile && ansible-galaxy install -r workflow/requirements/macOS/ansible/requirements.yml
	ansible-playbook -i "localhost," workflow/requirements/generic/ansible/playbook.yml --tags "hosts" --ask-become-pass
	source ~/.bash_profile && ansible-playbook -i "localhost," workflow/requirements/macOS/ansible/playbook.yml --ask-become-pass
	source ~/.bash_profile && $(SHELL) -c 'cd workflow/requirements/macOS/docker; . ./daemon_check.sh'

requirements-docker: ## Prepare Docker on workstation
	source ~/.bash_profile && $(SHELL) -c 'cd workflow/requirements/macOS/docker; . ./daemon_check.sh'

requirements-hosts: ## Prepare /etc/hosts on workstation
	ansible-playbook -i "localhost," workflow/requirements/generic/ansible/playbook.yml --tags "hosts" --ask-become-pass

requirements-packages: ## Install packages workstation
	ansible-playbook -i "localhost," workflow/requirements/macOS/ansible/playbook.yml --ask-become-pass

requirements-ansible: ## Prepare ansible requirements on workstation
	ansible-galaxy install -r deploy/requirements.yml

bootstrap-environment-message: ## Echo a message that the app installation is happening now
	@echo ""
	@echo ""
	@echo "Welcome!"
	@echo ""
	@echo "1) Please follow the instructions to fully install and start Docker - Docker started up when its Icon ("the whale") is no longer moving."
	@echo ""
	@echo "2) Click on the Docker icon, goto Preferences / Advanced, set Memory to at least 4GiB and click Apply & Restart."
	@echo ""
	@echo "3) After Docker started up again execute 'make bootstrap-stack' to finish the bootstrap."
	@echo ""
	@echo ""


bootstrap-stack: all-restart stack-open bootstrap-stack-message ## Bootstrap stack!

bootstrap-stack-message: ## Echo a message that the app installation is happening now
	@echo ""
	@echo ""
	@echo "Welcome back!"
	@echo ""
	@echo "I am currently setting up your database and configuring your app in container 'app'."
	@echo ""
	@echo "You can follow the process using 'make service-logs app'."
	@echo ""
	@echo "When done please refresh the browser tabs I opened for you."
	@echo ""
	@echo ""

sync-reset: ## reset docker sync (to be used after changing sync-strategy in docker-sync.yml)
	kill `cat .docker-sync/daemon.pid` || true
	docker-sync clean || true
	docker volume prune || true
	rm -rf .docker-sync || true

sync-start: ## Start docker sync
	docker-sync start

sync-stop: ## Stop docker sync
	kill `cat .docker-sync/daemon.pid` || true

sync-restart: sync-reset sync-start ## Reset and restart docker-sync

sync-clean: ## Remove volumes managed by docker-sync
	docker-sync clean

sync-logs: ## Show last lines of docker-sync logs
	docker-sync logs

stack-up: ## Boot stack
	docker-compose -p courses run --rm app_infra_up
	docker-compose -p courses up -d --build --remove-orphans

stack-down: ## Teardown the stack
	docker-compose -p courses kill
	docker-compose -p courses down --remove-orphans

stack-restart: stack-down stack-up ## Restart stack

stack-volumes-remove: ## Remove rabbitmq, es and db volume thus resetting the database - the stack must be down for this
	docker volume rm courses_db-data courses_es-data courses_rabbitmq-data courses_automysqlbackup-backup

stack-pause: ## Pause all services in the stack
	docker-compose -p courses pause

stack-unpause: ## Resume all services in the stack
	docker-compose -p courses unpause

stack-open: app-open phpmyadmin-open rabbitmq-open ## Open services in your browser

all-restart: stack-down sync-restart stack-up ## Reinit and restart docker sync and the stack


service-list: ## Show containers
	docker-compose -p courses ps

service-logs: ## Show and follow logs of containers
	docker-compose -p courses logs --tail 100 -f $(filter-out $@,$(MAKECMDGOALS))

service-bash: ## Access container using bash
	docker-compose -p courses exec $(filter-out $@,$(MAKECMDGOALS)) bash -l

service-bash-root: ## Access container using bash as root
	docker-compose -p courses exec --user=root $(filter-out $@,$(MAKECMDGOALS)) bash -l

service-restart: ## Restart container
	docker-compose -p courses restart $(filter-out $@,$(MAKECMDGOALS))

service-update: ## Stop, (re)build and start service
	docker-compose -p courses up -d --build --no-deps --force-recreate $(filter-out $@,$(MAKECMDGOALS))

app-run-on-host: ## Run app on local host
	app/vendor/bin/wp server --port=9090

app-open: ## Open app frontend and backend in your browser
	python -mwebbrowser https://courses.localhost
	python -mwebbrowser https://courses.localhost/wp-admin

app-exec: ## Exec WP CLI
	@docker-compose -p courses exec app $(filter-out $@,$(MAKECMDGOALS))

app-wp-exec: ## Exec bin/magento - you can pass args
	@docker-compose -p courses exec app vendor/bin/wp $(filter-out $@,$(MAKECMDGOALS))

phpmyadmin-open: ## Open phpMyAdmin in your browser
	python -mwebbrowser http://courses.localhost:8080

rabbitmq-open: ## Open RabbitMQ management UI in your browser
	python -mwebbrowser http://courses.localhost:15672



backup-now: ## Backup database and media to external storage
	@echo "Backing up ..."
	@echo "Taking snapshot of database ..."
	@docker-compose -p courses exec automysqlbackup automysqlbackup
	@echo "Backing up database and media to external storage ..."
	@docker-compose -p courses exec borg borg-backup backup
	@echo "Backing up done."

backup-db-snapshot-local-list: ## List *local* db snapshots
	@docker-compose -p courses exec automysqlbackup find /backup -maxdepth 3 -ls

backup-db-snapshot-local-import-latest: ## Import latest *local* db snapshot
	@echo "Importing latest local database snapshot ..."
	@docker-compose -p courses exec automysqlbackup automysqlrestore
	@echo "Importing latest local database snapshot done."

backup-db-snapshot-local-import-specific: ## Import specific *local* db snapshot
	@echo "Importing local database snapshot $(filter-out $@,$(MAKECMDGOALS)) ..."
	@docker-compose -p courses exec automysqlbackup automysqlrestore $(filter-out $@,$(MAKECMDGOALS))
	@echo "Importing local database snapshot done."

backup-archive-list: ## List backup archives
	@docker-compose -p courses exec borg borg-backup list

backup-archive-extract-latest: ## Extract latest archive from external storage
	@echo "Extracting latest archive from external storage ..."
	@docker-compose -p courses exec borg borg-backup extract-files-latest var
	@echo "Extracting latest archive from external storage done."

backup-archive-extract-specific: ## Extract latest archive from external storage
	@echo "Extracting archive $(filter-out $@,$(MAKECMDGOALS)) from external storage ..."
	@docker-compose -p courses exec borg borg-backup extract-files-specific $(filter-out $@,$(MAKECMDGOALS)) var
	@echo "Extracting archive $(filter-out $@,$(MAKECMDGOALS)) from external storage done."

backup-restore-latest: backup-archive-extract-latest backup-db-snapshot-local-import-latest ## Extract latest archive from external storage and import latest database snapshot found in it


staging-max-one-ssh: ## SSH into max-one
	ssh courses@max-one.local

staging-build-and-deploy: ## Build for & deploy to staging (max K8S cluster)
	kubectl create namespace courses || true
	skaffold deploy

staging-dev: ## Build, push, deploy, watch, update
	kubectl create namespace courses || true
	skaffold dev --port-forward --cleanup=false --no-prune --no-prune-children --toot -p max

staging-undeploy: ## Delete deployment on staging
	skaffold delete
	kubectl delete namespace courses || true

staging-open: ## Open services on staging
	python -mwebbrowser http://courses.maxxx.pro

staging-proxy: ## Open K8S proxy to staging
	kubectl proxy

staging-dashboard-bearer-token-show: ## Show K8S dashboard bearer token for staging
	workflow/staging/scripts/dashboard-bearer-token-show

staging-dashboard-open: ## Open Dashboard
	python -mwebbrowser http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/overview?namespace=default



production-build-and-push: production-nginx-build-and-push production-varnish-build-and-push production-app-build-and-push production-phpmyadmin-build-and-push production-automysqlbackup-build-and-push production-rabbitmq-build-and-push production-redis-build-and-push production-memcached-build-and-push production-es-build-and-push production-db-build-and-push production-borg-build-and-push ## Build all docker images and push to private registry

production-varnish-build-and-push: ## Build varnish docker image, tag and push to private registry
	docker build -t varnish stack/varnish
	docker tag varnish max-one.local:5001/courses/varnish:latest
	docker push max-one.local:5001/courses/varnish

production-nginx-build-and-push: ## Build nginx docker image, tag and push to private registry
	docker build -t nginx stack/nginx
	docker tag nginx max-one.local:5001/courses/nginx:latest
	docker push max-one.local:5001/courses/nginx

production-app-build-and-push: ## Build app docker image, tag and push to private registry
	docker build -t app app
	docker tag app max-one.local:5001/courses/app:latest
	docker push max-one.local:5001/courses/app

production-phpmyadmin-build-and-push: ## Build phpMyAdmin docker image, tag and push to private registry
	docker build -t phpmyadmin stack/phpmyadmin
	docker tag phpmyadmin max-one.local:5001/courses/phpmyadmin:latest
	docker push max-one.local:5001/courses/phpmyadmin

production-automysqlbackup-build-and-push: ## Build automysqlbackup docker image, tag and push to private registry
	docker build -t automysqlbackup stack/automysqlbackup
	docker tag automysqlbackup max-one.local:5001/courses/automysqlbackup:latest
	docker push max-one.local:5001/courses/automysqlbackup

production-rabbitmq-build-and-push: ## Build RabbitMQ docker image, tag and push to private registry
	docker build -t rabbitmq stack/rabbitmq
	docker tag rabbitmq max-one.local:5001/courses/rabbitmq:latest
	docker push max-one.local:5001/courses/rabbitmq

production-redis-build-and-push: ## Build Redis docker image, tag and push to private registry
	docker build -t redis stack/redis
	docker tag redis max-one.local:5001/courses/redis:latest
	docker push max-one.local:5001/courses/redis

production-memcached-build-and-push: ## Build Memcached docker image, tag and push to private registry
	docker build -t memcached stack/memcached
	docker tag memcached max-one.local:5001/courses/memcached:latest
	docker push max-one.local:5001/courses/memcached

production-es-build-and-push: ## Build Elasticsearch docker image, tag and push to private registry
	docker build -t es stack/es
	docker tag es max-one.local:5001/courses/es:latest
	docker push max-one.local:5001/courses/es

production-db-build-and-push: ## Build MariaDB docker image, tag and push to private registry
	docker build -t db stack/db
	docker tag db max-one.local:5001/courses/db:latest
	docker push max-one.local:5001/courses/db

production-borg-build-and-push: ## Build borg docker image, tag and push to private registry
	docker build -t borg stack/borg
	docker tag borg max-one.local:5001/courses/borg:latest
	docker push max-one.local:5001/courses/borg

production-build-and-deploy: build-and-push production-deploy ## Build all docker images and deploy to production

production-deploy: ## Deploy to production without building first
	cd workflow/production && ansible-playbook main.yml --tags "deploy"

production-max-one-ssh: ## SSH into max-one
	ssh courses@max-one.local

production-open: production-logging-open ## Open services on production in your browser
	python -mwebbrowser https://courses.20steps.de
	python -mwebbrowser https://courses.20steps.de/wp-admin
	python -mwebbrowser http://max-one.local:8081
	python -mwebbrowser http://max-one.local:15672
	python -mwebbrowser http://max-one.local:9000

production-nginx-cert-renewal: ## Renew certs of nginx on production
	cd workflow/production && ansible-playbook main.yml --tags "cert"

production-logging-open: ## Open logging dashboard (graylog)
	python -mwebbrowser http://max-one.local:9000

production-monitoring-open: ## Open monitoring dashboards (UptimeRobot.com, Sentry.io and Grafana)
	python -mwebbrowser https://stats.uptimerobot.com/OZAWPTWNA
	python -mwebbrowser https://sentry.io/organizations/courses/issues/?project=1484857
	python -mwebbrowser http://max-one.local:3000

production-user-setup: ## Setup users on production e.g. to add new or updated SSH keys
	cd workflow/production && ansible-playbook main.yml --tags "user"

production-uptimerobot-setup: ## Setup monitors in UptimeRobot.com
	cd workflow/production && ansible-playbook main.yml --tags "uptimerobot"

