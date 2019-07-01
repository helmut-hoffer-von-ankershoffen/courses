# courses

Wordpress site for courses using a modern Docker *and* Kubernetes stack + Ansible based approach including fully automatic bootstrap of the development and production environment and fully automatic deployment of updates.

Hints:
- Basic knowledge of `git` and `GitHub` is assumed - see https://product.hubspot.com/blog/git-and-github-tutorial-for-beginners and https://help.github.com/en/desktop/getting-started-with-github-desktop
- Basic knowledge of the terminal is assumed - see https://github.com/0nn0/terminal-mac-cheatsheet
- For development a Mac OS notebook, Mac Mini or iMac with macOS Mojave is assumed
- For production infrastructure previously provisioned using `github.com/helmuthva/ceil` is assumed


## Features

### Sprint 1 - Basics
- [x] workflow: install requirements using Ansible
- [x] basics: development stack using docker-compose
- [x] workflow: up/down development stack using docker-compose
- [x] basics: staging deployment using manifests and kustomize
- [x] workflow: build, push, deploy, watch, update to/on staging (K8S cluster "max") using skaffold + kustomize
- [x] basics: production stack on bare-metal using Ansible and docker-compose
- [ ] workflow: deploy to production

## Docker/K8S stack wiring

The Docker / k8s stack of this project consists of the following containers as defined in the `*.yaml` files.

-> `nginx`: SSL+HTTP/2 termination and mod_pagespeed for optimzing Google PageSpeed  
&nbsp;&nbsp;&nbsp;&nbsp;-> `memcached`: Key/value store used as backend cache for mod_pagesspeed  
&nbsp;&nbsp;&nbsp;&nbsp;-> `varnish`: Full page cache for acceleration  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-> `app`: Apache with PHP FPM and app installation  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-> `rabbitmq`: RabbitMQ message queue including management UI used by app for asynchronous operations  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-> `redis`: Redis key/value store used as backend cache and session storage for Wordpress  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-> `es`: ElasticSearch fulltext search engine for efficient search in wordpress  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-> `db`: MariaDB SQL database  
-> `phpmyadmin`: Web UI for administrative access to database  
&nbsp;&nbsp;&nbsp;&nbsp;-> `db`: MariaDB SQL database  
            
Hints:
- Arrows show dependencies
- There is multiple additional dependencies to various infrastructure services provided by `ceil` not shown here
- See the official Wordpress reference architecture for a diagram that matches our stack 1:1


## Workflow

### Bootstrap development environment

1) Clone this repository: open a terminal window and execute `git clone git@github.com:helmuthva/courses.git` - alternatively clone using [GitHub Desktop](https://help.github.com/en/desktop/getting-started-with-github-desktop/installing-github-desktop).
2) Bootstrap runtime and development environment: open a terminal, `cd` into the directory created in step 1), execute `make bootstrap-environment && source ~/.bash_profile` and follow the instructions.
3) Bootstrap Docker stack: open a terminal, `cd` into the directory created in step 1), execute `make bootstrap-stack` and follow the instructions.

Hints:
- Assumes the Apple `XCode command tools` are installed thus `git` and `make` being available *before* starting the bootstrap - open a terminal and enter `xcode-select --install` to make sure.
- Assumes you generated and uploaded a SSH key to Github as explained in this [Tutorial](https://help.github.com/en/articles/adding-a-new-ssh-key-to-your-github-account)
- If you want to copy an already generated SSH key from one machine to another zip, copy and unpack the directory  `~/.ssh` with `~/` referencing your Home directory on your Mac.
- Assumes the system preferences, section security are configured to allow installation of software from outside the Apple AppStore.
- The bootstrap is needed once per developer / workstation only.
- You will be prompted for your admin password multiple times during the bootstrap - if you are asked to enter "y" / "yes" or "n" / "no" please enter "y" or "yes" respectively.
- Will install some applications and packages required for running the stack and executing the workflow.  
- Will boot up Docker sync and the Docker stack. 
- Will setup uptimerobot.com monitors.
- Will the app frontend, app backend, phpMyAdmin and the RabbitMQ management UI in your browser.
- The whole process takes ca 60 min (depending on your cpu, disk and Internet connection speed).
- You can watch which containers are running using `ctop` and/or `make service-list`
- You can watch the progress of the app setup using `make service-logs app` and/or repeatedly reload the browser tabs that have been opened automatically - app is setup and running when you see a log message containing `apache2 -D FOREGROUND -D APACHE_LOCK_DIR`
- You can watch the logs messages of all containers at once by entering `make service-logs`
- The login/password for the app backend on development is `admin`, `secret123`.
- If something fails during steps 2 or 3 of the bootstrap first repeat those steps, after that call your supporter ,-)

### Develop and test locally

1) Start Docker sync and boot the development stack: `make sync-start` resp. `make stack-up` - if not already started / booted up as part of bootstrap (cp. above).
2) Open browser tabs pointing to app frontend, app backend, phpMyAdmin and the RabbitMQ management UI: `make stack-open`
3) Modify the source code, install extensions, do whatever a developer does: Source code of app resides in `app/` and  is automatically synched with the `app` container using Docker sync.
4) Test, test, test again
5) Commit and push your code including a nice and self explanatory commit message - cp. any git tutorial
6) Stop the stack and Docker sync to not consume resources and do other stuff: `make stack-down` and `make sync-stop`

Hints:
- You can watch which containers are running using `ctop` and/or `make service-list`
- You can watch the progress of the app container booting up using `make service-logs app`
- You can watch the logs messages of all containers at once by entering `make service-logs`
- To restart the stack execute `make stack-restart`
- To reinit and restart Docker sync *and* the stack execute `make all-restart`
- Always work on a branch when developing, merge to the master branch for deploying
- There is a lot of additional tools: `make help` shows them all
- Touch parts other than `app/` of this repository only if you definitely know what you are doing

### Build for & deploy to staging

1) Build, push, deploy, watch, update: `make staging-dev`, alternatively deploy: `make staging-build-and-deploy`
2) Open browser pointing to app frontend, app backend, phpMyAdmin and the RabbitMQ management UI on max: `make staging-open`

Hints:
- Automatically watches local changes to manifests or files in Docker contexts, rebuilds and redeploys what changed
- Automatically aggregates logs of all containers and taials
- Automatically opens port forwards
- Automatically syncs file updates directly into pods

### Build for & deploy to production

1) Build and deploy to production: `make production-build-and-deploy` - yes, that's it, wonderful not?
2) Open browser pointing to app frontend, app backend, phpMyAdmin and the RabbitMQ management UI on production: `make production-open`

Hints:
- Asssumes you have established a VPN connection as needed to access the private Docker registry, phpMyAdmin and the RabbitMQ management UI
- The bootstrap (initial deploy to production) and deployment of updates is fully automatic - the single command above is all that is needed
- The bootstrap takes ca. 30 minutes
- Let your fellow developer test your changes first *before* deploying to production
- The login/passsword for the app backend on production was shared with you
- You can ssh into production using `make max-one-ssh` - after that execute `make help` to show available commands on production
- You can use `make production-logging-open` to inspect logs - credentials for graylog is `admin`/`FVx3zCUMGNfWqSmd` - after login goto `Search`, type in your query and click the play button.
- You can use `make production-monitoring-open` to inspect monitoring (UptimeRobot and Grafana) - credentials for grafana is `admin`/`admin` or `wMctTeRPdKVYxB9t`, credentials for UptimeRobot cp. section `External Services` below


## Semi-manual steps

- Before your first commit set your email for git by executing `subl ~/.gitconfig`, setting your `email` and uncommenting the lines `name` and `email` - i.e. removing the `# ` - in case you are *not* using the GitHub Desktop tool.

- To allow access to the VPN open the tunnelblick application and click on the VPN credentials provided to you - the file is called `admin@vpn.courses.20steps.de.ovpn`, the password is `secret`.

- In case you want to access the database directly create database connections in `SequelPro`  - which was installed as part of bootstrap - as follows:
  - `courses/development`: color `green`, server `127.0.0.1`, login `root`, passsword `secret`
  - `courses/production`: color `red`, server `max-one.localhost`, login `root`, passsword `secret` - assumes VPN connection is established, firewalling is automatic

- In case your fellow developer did not already do this create free account at `https://uptimerobot.com` than
  - Manually create public status page
  - Automatically setup monitors using `make production-uptimerobot-setup`  after updating `uptimerobot_api_key` in  `deploy/group_vars/all.yml`

- In case your fellow developer did not already do this register free account at `https://sentry.io` than
  - Set secondary email to `hhva@20steps.de` 
  - Integration in app on production is automatic after updating `sentry/general/domain` in `app/container/opt/docker/provision/entrypoint.d/991-app.sh` and `stack/app.development/container/opt/docker/provision/entrypoint.d/991-app.sh`.

- In case you don't want to use the sublime editor install `PHPStorm EAP`, see https://www.jetbrains.com/phpstorm/eap/ or the JetBraians Toolbox - the latter was installed during bootstrap.


## External Services

- uptimerobot.com (uptime monitoring)
  - Credentials: `webmaster@20steps.de`, `TBD`
  - Status-Page: https://stats.uptimerobot.com/TBD, password `TBD`

- sentry.io (error monitoring, debugging) 
  - Credentials: `webmaster@20steps.de`, `TBD`
