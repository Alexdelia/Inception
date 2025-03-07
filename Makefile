# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: adelille <adelille@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/03/10 14:54:46 by adelille          #+#    #+#              #
#    Updated: 2022/03/27 22:12:09 by adelille         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = Inception

# **************************************************************************** #
#	MAKEFILE	#

#include	srcs/.env
#export	$(shell sed 's/=.*//' srcs/.env)

SHELL := bash

B =		$(shell tput bold)
RED =	$(shell tput setaf 1)
GRE =	$(shell tput setaf 2)
YEL =	$(shell tput setaf 3)
D =		$(shell tput sgr0)

define sudotest
	@if [[ $(shell id -u) != 0 ]]; then \
		printf "$(B)$(RED)you are not root$(D)\n"; \
		printf "$(B)please use: $(YEL)sudo make$(D)\n\n"; \
		exit 1; \
	fi
endef

CD =	cd srcs &&

# *************************************************************************** #
#	RULES	#

all:	launch $(NAME)

launch:
	$(call sudotest)

$(NAME):
	$(CD) docker-compose up --force-recreate --build

clean: launch
	$(CD) docker-compose down

fclean:	launch
	@$(CD) docker-compose down -v 2>/dev/null
	@docker rm -f $(shell docker ps -aq) 2>/dev/null || true
	@docker rmi -f $(shell docker images -q) 2>/dev/null || true
	@docker builder prune -f

re:		launch clean all

list:	launch
	@printf "\n\t$(B)$(GRE)container$(D)\n"
	docker ps -a
	@printf "\n\t$(B)$(GRE)images$(D)\n"
	docker images -a
	@printf "\n\t$(B)$(GRE)network$(D)\n"
	docker network ls
	@printf "\n\t$(B)$(GRE)volume$(D)\n"
	docker volume ls
	@echo ;

.PHONY: all clean fclean re launch list

# **************************************************************************** #
