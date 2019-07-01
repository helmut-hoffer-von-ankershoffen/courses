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


nginx-cert-renewal: ## Renew cert now via let's encrypt
	docker-compose -p courses exec nginx  /etc/cron.daily/cert-renewal.sh


all-teardown: ## DANGER: Tears down *everything*
	docker-compose -p courses kill
	docker-compose -p courses down --remove-orphans
	docker system prune -af
	docker system prune --volumes -af
	rm * || true
	rm -rf /mnt/gluster/courses/volumes/app/wp-content/*