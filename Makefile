# Makefile per l'ambiente Docker di OpenCart ITALIA

SHELL := /bin/bash

# --- Colori ---
OC_COLOR := \033[38;5;45m
COLOR_RESET := \033[0m

# --- Docker Compose ---
COMPOSE := docker compose --env-file=./docker/.env.docker

# Utente corrente, passato alla build dell'immagine PHP
CURRENT_USER_NAME := $(shell id -un)
CURRENT_USER_ID   := $(shell id -u)

# Argomenti facoltativi
# Esempio: make down options="-v --remove-orphans"
options ?=
# Esempio: make up profiles="adminer redis"
profiles ?=
PROFILES_FLAGS := $(foreach p,$(profiles),--profile $(p))

define check_service_running
	@if ! $(COMPOSE) ps --services --filter "status=running" | grep -q "^$(1)$$"; then \
	@echo "Errore: il servizio '$(1)' non e' in esecuzione."; \
	@echo "Lancia prima 'make up' oppure controlla con 'make ps'."; \
	@exit 1; \
	fi
endef

KNOWN_TARGETS := help init build up down restart logs apache php mysql exec ps

.PHONY: $(KNOWN_TARGETS)

.DEFAULT_GOAL := help

help: ## Mostra questo messaggio
	@echo "OpenCart ITALIA - ambiente Docker"
	@echo "---------------------------------"
	@echo "Uso: make <comando> [options=\"...\"] [profiles=\"...\"]"
	@echo ""
	@echo "Comandi principali:"
	@echo -e "  $(OC_COLOR)make init$(COLOR_RESET)      - Prepara la configurazione (copia docker/.env.docker)"
	@echo -e "  $(OC_COLOR)make build$(COLOR_RESET)     - Costruisce le immagini"
	@echo -e "  $(OC_COLOR)make up$(COLOR_RESET)        - Avvia i servizi"
	@echo -e "  $(OC_COLOR)make down$(COLOR_RESET)      - Ferma e rimuove i contenitori"
	@echo -e "  $(OC_COLOR)make restart$(COLOR_RESET)   - Riavvia i servizi"
	@echo -e "  $(OC_COLOR)make ps$(COLOR_RESET)        - Stato dei servizi"
	@echo -e "  $(OC_COLOR)make logs$(COLOR_RESET)      - Log dei servizi"
	@echo ""
	@echo "Accesso ai contenitori:"
	@echo -e "  $(OC_COLOR)make php$(COLOR_RESET)       - Entra nel contenitore PHP"
	@echo -e "  $(OC_COLOR)make apache$(COLOR_RESET)    - Entra nel contenitore Apache"
	@echo -e "  $(OC_COLOR)make mysql$(COLOR_RESET)     - Entra nel contenitore MariaDB"
	@echo -e "  $(OC_COLOR)make exec$(COLOR_RESET)      - Esegue un comando in un servizio"
	@echo ""
	@echo "Esempi:"
	@echo "  make up profiles=\"adminer redis\""
	@echo "  make down options=\"-v\"          # elimina anche il database"
	@echo "  make build options=\"--no-cache\""
	@echo "  make logs options=\"php\""
	@echo "  make exec service=php command=\"php -v\""
	@echo ""
	@echo "Collegamenti:"
	@echo "  Sito:          https://www.opencartitalia.it"
	@echo "  Documentazione: https://www.opencartitalia.it/documentazione"
	@echo "  Assistenza:    https://www.opencartitalia.it/assistenza"
	@echo "  Repository:    https://github.com/tuxlbit/OpenCart-ITALIA"

init: ## Prepara docker/.env.docker
	@if [ ! -f ./docker/.env.docker ]; then \
	@echo "Copio docker/.env.docker.example in docker/.env.docker..."; \
	@cp docker/.env.docker.example docker/.env.docker; \
	else \
	@echo "docker/.env.docker esiste gia': non lo tocco."; \
	fi

build: ## Costruisce le immagini
	@echo "Costruzione immagini per l'utente $(CURRENT_USER_NAME) (ID $(CURRENT_USER_ID))"
	@$(COMPOSE) build \
	--build-arg PHP_UNAME="$(CURRENT_USER_NAME)" \
	--build-arg PHP_UID="$(CURRENT_USER_ID)" \
	$(options)

up: ## Avvia i servizi
	@echo "Avvio dei servizi..."
	@$(COMPOSE) $(PROFILES_FLAGS) up -d $(options)
	@echo ""
	@echo "Negozio:  http://localhost:8080/"
	@echo "Pannello: http://localhost:8080/admin/"

down: ## Ferma i contenitori
	@echo "Arresto dei servizi..."
	@$(COMPOSE) down $(options)

restart: ## Riavvia i servizi
	@$(MAKE) down options="$(options)"
	@$(MAKE) up profiles="$(profiles)" options="$(options)"

ps: ## Stato dei servizi
	@$(COMPOSE) ps

logs: ## Log dei servizi
	@if [ -n "$(options)" ] && ! echo "$(options)" | grep -q "^-"; then \
	@if ! $(COMPOSE) config --services | grep -q "^$(options)$$"; then \
		echo "Errore: servizio '$(options)' inesistente."; \
		echo "Servizi disponibili:"; \
		$(COMPOSE) config --services | sed 's/^/  - /'; \
		exit 1; \
	@fi; \
	fi
	@$(COMPOSE) logs -f $(options)

exec: ## Esegue un comando: make exec service=<nome> command="<comando>"
	@if [ -z "$(service)" ] || [ -z "$(command)" ]; then \
	@echo "Errore: servono le variabili 'service' e 'command'."; \
	@echo "Uso: make exec service=<nome> command=\"<comando>\""; \
	@exit 1; \
	fi
	@if ! $(COMPOSE) config --services | grep -q "^$(service)$$"; then \
	@echo "Errore: servizio '$(service)' inesistente."; \
	@echo "Servizi disponibili:"; \
	@$(COMPOSE) config --services | sed 's/^/  - /'; \
	@exit 1; \
	fi
	@$(call check_service_running,$(service))
	@$(COMPOSE) exec $(service) sh -c "$(command)"

apache: ## Entra nel contenitore Apache
	@$(call check_service_running,apache)
	@$(COMPOSE) exec apache sh

php: ## Entra nel contenitore PHP
	@$(call check_service_running,php)
	@$(COMPOSE) exec --user www-data --workdir /var/www php bash

mysql: ## Entra nel contenitore MariaDB
	@$(call check_service_running,mysql)
	@$(COMPOSE) exec mysql bash
