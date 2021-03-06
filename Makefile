APPLICATIONS := activitystream characters core gallery usermgmt usermgmt
APPLICATIONS_COMMA := $(shell echo $(APPLICATIONS) | tr ' ' ',')

.PHONY: help
help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: run
run: ## Run the development environment from tox.
	tox -e devenv

.PHONY: migrate
migrate: makemigrations ## Run migrate on the DB, updating schema per migration files.
	venv/bin/python manage.py migrate

.PHONY: makemigrations
makemigrations: venv/bin/django-admin ## Generate migration files based on models.
	venv/bin/python manage.py makemigrations

.PHONY: fixtures
fixtures: venv/bin/django-admin ## Load data fixtures.
	# venv/bin/python manage.py loaddata core/fixtures/*

.PHONY: collectstatic
collectstatic: ## Collect static files into the STATIC_ROOT directory.
	venv/bin/python manage.py collectstatic

.PHONY: check-deploy
check-deploy: ## Run a check against the project for deployability.
	venv/bin/python manage.py check --deploy

.PHONY: reestdb
resetdb: ## Remove the development database and regenerate it, loading fixtures.
	- rm db.sqlite3
	$(MAKE) migrate fixtures

.PHONY: update-revno
update-revno: venv/bin/django-admin ## Update the git revno for non-DEBUG templates.
	venv/bin/python manage.py git_revno $(TAG)

.PHONY: test
test: testone ## Shortcut for testone.

.PHONY: testall
testall: ## Run tests in all available environments.
	tox

.PHONY: testone
testone: ## Run tests in py3.5 only.
	tox -e 3.5

.PHONY: test-travis
test-travis: ## Test target for travis-ci use.
	flake8
	coverage run \
		--source='$(APPLICATIONS_COMMA)' \
		--omit='*migrations*,*urls.py,*apps.py,*admin.py,*__init__.py,*test.py' \
		manage.py test --verbosity=2
	coverage report -m --skip-covered

.PHONY: clean
clean: ## Remove virtualenv and tox environments, along with compiled/optimized python files.
	rm -rf venv .tox
	find . -name *.py[co] -exec rm {} \;

.PHONY: deps
deps: check-sysdeps venv ## Install dependencies in the virtualenv.
	venv/bin/pip install -r requirements.txt

.PHONY: check-sysdeps
check-sysdeps: ## Check that system dependencies are met.
	@printf "\e[31mChecking for tox...\e[0m"
	@tox --version
	@printf "\e[32m- tox found\e[0m\n\n"
	@printf "\e[31mChecking for virtualenv...\e[0m"
	@virtualenv --version
	@printf "\e[32m- virtualenv found\e[0m\n\n"
	@printf "\e[32mSysdeps met\e[0m\n"

venv: ## Setup the virtualenv.
	virtualenv venv
