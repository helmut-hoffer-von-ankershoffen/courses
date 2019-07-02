.DEFAULT_GOAL := help
SHELL := /bin/bash
.PHONY: help

help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-0-9]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)


service-list: ## Show containers
	docker-compose -p courses ps

service-bash: ## Access container using bash
	docker-compose -p courses exec $(filter-out $@,$(MAKECMDGOALS)) bash -l

service-bash-root: ## Access container using bash as root
	docker-compose -p courses exec --user=root $(filter-out $@,$(MAKECMDGOALS)) bash -l

service-restart: ## Restart container
	docker-compose -p courses restart $(filter-out $@,$(MAKECMDGOALS))

service-update: ## Stop, (re)build and start service
	docker-compose -p courses up -d --build --no-deps --force-recreate $(filter-out $@,$(MAKECMDGOALS))


stack-pull: ## Pull Docker images of stack to make stack-up faster
	docker-compose -p courses pull

stack-up: ## Boot stack
	docker-compose -p courses run --rm app_infra_up
	docker-compose -p courses up -d --build --remove-orphans

stack-down: ## Teardown the stack
	docker-compose -p courses kill
	docker-compose -p courses down --remove-orphans

stack-restart: stack-down stack-up ## Restart stack

stack-volumes-remove: ## Remove rabbitmq, es and db volume thus resetting the database - the stack must be down for this
	docker volume rm courses_db-data courses_es-data courses_rabbitmq-data


nginx-cert-renewal: ## Renew cert now via let's encrypt
	docker-compose -p courses exec nginx  /etc/cron.daily/cert-renewal.sh


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


all-teardown: ## DANGER: Tears down *everything*
	docker-compose -p courses kill
	docker-compose -p courses down --remove-orphans
	docker system prune -af
	docker system prune --volumes -af
	rm * || true
	rm -rf /mnt/gluster/courses/volumes/app/uploads/*