SHELL := /bin/bash
MAKEFLAGS += --no-print-directory
.DEFAULT_GOAL := help

test:
	@./run.sh status
.PHONY: test

status:
	@./run.sh status
.PHONY: status 

deploy:
	@./run.sh deploy
.PHONY: deploy

clean:
	@./run.sh clean
.PHONY: clean

rebuild:
	@./run.sh rebuild
.PHONY: rebuild

down:
	@./run.sh teardown
.PHONY: down

help:
	@echo "Usage: make deploy | teardown | clean | rebuild | status | init | help"
	@echo
	@echo "deploy   | build images and start containers"
	@echo "down     | stop containers (shutdown containers)"
	@echo "rebuild  | rebuilds the lab from scratch (clean and deploy)"
	@echo "clean    | stop and delete containers and images"
	@echo "status   | check the status of the lab"
	@echo "help     | show this help message"
.PHONY: help
