# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: cdumais <cdumais@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/12/20 12:42:23 by cdumais           #+#    #+#              #
#    Updated: 2023/12/20 14:14:39 by cdumais          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#TODO: check to install GLFW in lib dir like we did with readline ?

# **************************************************************************** #
# --------------------------------- VARIABLES -------------------------------- #
# **************************************************************************** #
NAME		:= cub3D
ARGS		:= 

INC_DIR		:= inc
LIB_DIR		:= lib
OBJ_DIR		:= obj
SRC_DIR		:= src
TMP_DIR		:= tmp

COMPILE		:= gcc
C_FLAGS		:= -Wall -Wextra -Werror
C_FLAGS		:= $(CFLAGS) -Wunreachable-code -Ofast
L_FLAGS		:= 
HEADERS		:= -I$(INC_DIR)

REMOVE		:= rm -rf
NPD			:= --no-print-directory
VOID		:= /dev/null
OS			:= $(shell uname -s)
# **************************************************************************** #
# ---------------------------------- LIBFT ----------------------------------- #
# **************************************************************************** #
LIBFT_DIR	:= $(LIB_DIR)/libft
LIBFT_INC	:= $(LIBFT_DIR)/$(INC_DIR)
LIBFT		:= $(LIBFT_DIR)/libft.a
HEADERS		:= $(HEADERS) -I$(LIBFT_INC)
# **************************************************************************** #
# ----------------------------------- MLX ------------------------------------ #
# **************************************************************************** #
MLX_DIR		:= $(LIB_DIR)/MLX42
MLX_INC		:= $(MLX_DIR)/include/MLX42
MLX_BLD		:= $(MLX_DIR)/build

GLFW_PATH	= $(shell brew --prefix glfw)
GLFW_DIR	= $(GLFW_PATH)/lib

ifeq ($(shell uname),Linux)
	L_FLAGS	+= -lglfw -ldl -lm -pthread
else ifeq ($(shell uname),Darwin)
	L_FLAGS	+= -L$(GLFW_DIR) -lglfw \
	-framework Cocoa -framework OpenGL -framework IOKit
else
	$(error Unsupported operating system: $(shell uname))
endif

MLX42		:= $(MLX_BLD)/libmlx42.a
L_FLAGS		:= $(L_FLAGS) -L$(MLX_BLD) -lmlx42
HEADERS		:= $(HEADERS) -I$(MLX_INC)
# **************************************************************************** #
# -------------------------------- SUBMODULES  ------------------------------- #
# **************************************************************************** #
INIT_CHECK	:= $(LIB_DIR)/.init_check
INIT		:= $(if $(wildcard $(INIT_CHECK)),,init_submodules)
# **************************************************************************** #
# --------------------------------- H FILES ---------------------------------- #
# **************************************************************************** #
# INC		:= 
# **************************************************************************** #
# --------------------------------- C FILES ---------------------------------- #
# **************************************************************************** #
# SRC		:=	$(END_SRC)
# **************************************************************************** #
# -------------------------------- ALL FILES --------------------------------- #
# **************************************************************************** #
# INCS		:=	$(addprefix $(INC_DIR)/, $(addsuffix .h, $(INC)))
# SRCS		:=	$(addprefix $(SRC_DIR)/, $(addsuffix .c, $(SRC)))
# OBJS		:=	$(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS))
# **************************************************************************** #
# -------------------------------- ALL * FILES ------------------------------- #
# **************************************************************************** #
INCS	:=	$(wildcard $(INC_DIR)/*.h)
SRCS	:=	$(wildcard $(SRC_DIR)/*.c)
OBJS	:=	$(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS))
# **************************************************************************** #
# ---------------------------------- RULES ----------------------------------- #
# **************************************************************************** #
all: $(INIT) $(NAME)

$(NAME): $(LIBFT) $(OBJS) $(INCS) $(MLX42)
	@$(COMPILE) $(C_FLAGS) $(HEADERS) $(OBJS) $(LIBFT) $(L_FLAGS) -o $@
	@echo "$(GREEN)$$TITLE$(RESET)"

$(LIBFT):
	@$(MAKE) -C $(LIBFT_DIR) $(NPD)

$(MLX42):
	@echo "Building MLX42..."
	@cmake -S lib/MLX42 -B lib/MLX42/build -Wno-dev
	@echo "Compiling MLX42..."
	@$(MAKE) -C lib/MLX42/build -j4 $(NPD)
	@echo "[$(BOLD)$(PURPLE)MLX42$(RESET)] \
	$(GREEN)\tbuilt successfully$(RESET)"

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(INCS) | $(OBJ_DIR)
	@echo "$(CYAN)Compiling...$(ORANGE)\t$(notdir $<)$(RESET)"
	@$(COMPILE) $(C_FLAGS) $(HEADERS) -c $< -o $@
	@printf "$(UP)$(ERASE_LINE)"

$(OBJ_DIR):
	@mkdir -p $(OBJ_DIR)

clean:
	@if [ -d "$(OBJ_DIR)" ]; then \
		$(REMOVE) $(OBJ_DIR); \
		echo "[$(BOLD)$(PURPLE)$(NAME)$(RESET)] \
		$(GREEN)Object files removed$(RESET)"; \
	else \
		echo "[$(BOLD)$(PURPLE)$(NAME)$(RESET)] \
		$(YELLOW)No object files to remove$(RESET)"; \
	fi
	@$(MAKE) clean -C $(LIBFT_DIR) $(NPD)

fclean: clean
	@if [ -n "$(wildcard $(NAME))" ]; then \
		$(REMOVE) $(NAME); \
		echo "[$(BOLD)$(PURPLE)$(NAME)$(RESET)] \
		$(GREEN)Executable removed$(RESET)"; \
	else \
		echo "[$(BOLD)$(PURPLE)$(NAME)$(RESET)] \
		$(YELLOW)No executable to remove$(RESET)"; \
	fi

re: fclean all

.PHONY: all clean fclean re
# **************************************************************************** #
# ----------------------------------- MLX ------------------------------------ #
# **************************************************************************** #
mlxclean:
	@if [ -f $(MLX42) ]; then \
		$(REMOVE) $(MLX_BLD); \
		echo "[$(BOLD)$(PURPLE)MLX42$(RESET)] \
		$(GREEN)Library removed$(RESET)"; \
	else \
		echo "[$(BOLD)$(PURPLE)MLX42$(RESET)] \
		$(YELLOW)No library to remove$(RESET)"; \
	fi

# mlxdebug: (will recompile the mlx42 to be able to check for leaks ?)

.PHONY: mlxclean
# **************************************************************************** #
# ----------------------------------- GIT ------------------------------------ #
# **************************************************************************** #
init_submodules: $(INIT_CHECK)

$(INIT_CHECK):
	@git submodule update --init --recursive
	@touch $@

update:
	@echo "Are you sure you want to update the repo and submodules? [y/N] " \
	&& read ANSWER; \
	if [ "$$ANSWER" = "y" ] || [ "$$ANSWER" = "Y" ]; then \
		git pull origin main; \
		$(MAKE) init_submodules; \
		echo "Repository and submodules updated."; \
	else \
		echo "canceling update..."; \
	fi

.PHONY: init_submodules update

# add choice with make git (enter commit message or ... to cancel)
# **************************************************************************** #
# ---------------------------------- NORME ----------------------------------- #
# **************************************************************************** #
norm:
	@if which norminette > $(VOID); then \
		echo "$(BOLD)$(YELLOW)Norminetting $(PURPLE)$(NAME)$(RESET)"; \
		norminette -o $(INCS); \
		norminette -o $(SRCS); \
		$(MAKE) norm -C $(LIBFT_DIR); \
	else \
		echo "$(BOLD)$(YELLOW)Norminette not installed$(RESET)"; \
	fi

nm: $(NAME)
	@echo "$(BOLD)$(YELLOW)Functions in $(PURPLE)$(UNDERLINE)$(NAME)$(RESET):"
	@nm $(NAME) | grep U | grep -v 'ft_' \
				| sed 's/U//g' | sed 's/__//g' | sed 's/ //g' \
				| sort | uniq
	@$(MAKE) nm -C $(LIBFT_DIR) $(NPD)

.PHONY: norm nm
# **************************************************************************** #
# ---------------------------------- PDF ------------------------------------- #
# **************************************************************************** #
PDF		:= cub3d_en.pdf
GIT_URL	:= https://github.com/SaydRomey/42_ressources
PDF_URL	= $(GIT_URL)/blob/main/pdf/$(PDF)?raw=true

pdf: | $(TMP_DIR)
	@curl -# -L $(PDF_URL) -o $(TMP_DIR)/$(PDF)
ifeq ($(OS),Darwin)
	@open $(TMP_DIR)/$(PDF)
else
	@xdg-open $(TMP_DIR)/$(PDF) || echo "Please install a compatible PDF viewer"
endif

.PHONY: pdf
# **************************************************************************** #
# -------------------------------- LEAKS ------------------------------------- #
# **************************************************************************** #
VAL_CHECK	:= $(shell which valgrind > $(VOID); echo $$?)

# valgrind options
ORIGIN		:= --track-origins=yes
LEAK_CHECK	:= --leak-check=full
LEAK_KIND	:= --show-leak-kinds=all

# valgrind additional options
CHILDREN	:= --trace-children=yes
FD_TRACK	:= --track-fds=yes
HELGRIND	:= --tool=helgrind
NO_REACH	:= --show-reachable=no
VERBOSE		:= --verbose
VAL_LOG		:= valgrind-out.txt
LOG_FILE	:= --log-file=$(VAL_LOG)

# suppression-related options
SUPP_FILE	:= suppression.supp
SUPP_GEN	:= --gen-suppressions=all
SUPPRESS	:= --suppressions=$(SUPP_FILE)

# default valgrind tool
BASE_TOOL	= valgrind $(ORIGIN) $(LEAK_CHECK) $(LEAK_KIND)
# **************************************************************************** #
# specific valgrind tool (add 'valgrind option' variables as needed)
BASE_TOOL	+= 
# **************************************************************************** #	TODO: check if we should put messages as an echo instead of a target
LEAK_TOOL	= $(BASE_TOOL) $(LOG_FILE)
SUPP_TOOL	= $(BASE_TOOL) $(SUPP_GEN) $(LOG_FILE)

# run valgrind
leaks_msg:
	@echo "[$(BOLD)$(PURPLE)valgrind$(RESET)] \
	$(ORANGE)\tRecompiling with debug flags$(RESET)"

leaks: leaks_msg debug
	@if [ $(VAL_CHECK) -eq 0 ]; then \
		echo "[$(BOLD)$(PURPLE)valgrind$(RESET)] \
		$(ORANGE)Launching valgrind\n$(RESET)#"; \
		$(LEAK_TOOL) ./$(NAME) $(ARGS); \
		echo "#\n[$(BOLD)$(PURPLE)valgrind$(RESET)] \
		$(ORANGE)info in: $(CYAN)$(VAL_LOG)$(RESET)"; \
	else \
		echo "Please install valgrind to use the 'leaks' feature"; \
	fi

# generate suppression file
supp_msg:
	@echo "generating suppression file"
supp: leaks_msg supp_msg debug
	$(SUPP_TOOL) ./$(NAME) $(ARGS) && \
	awk '/^{/,/^}/' valgrind-out.txt > suppression.supp

# use suppression file
suppleaks_msg:
	@echo "launching valgrind with suppression file"
suppleaks: debug
	$(LEAK_TOOL) $(SUPPRESS) ./$(NAME) $(ARGS)

# remove suppression and log files
vclean:
	@if [ -n "$(wildcard suppression.supp)" ]; then \
		$(REMOVE) $(SUPP_FILE); \
		echo "[$(BOLD)$(PURPLE)$(NAME)$(RESET)] \
		$(GREEN)suppression file removed$(RESET)"; \
	else \
		echo "[$(BOLD)$(PURPLE)$(NAME)$(RESET)] \
		$(YELLOW)no suppression file to remove$(RESET)"; \
	fi
	@if [ -n "$(wildcard valgrind-out.txt)" ]; then \
		$(REMOVE) valgrind-out.txt; \
		echo "[$(BOLD)$(PURPLE)$(NAME)$(RESET)] \
		$(GREEN)log file removed$(RESET)"; \
	else \
		echo "[$(BOLD)$(PURPLE)$(NAME)$(RESET)] \
		$(YELLOW)no log file to remove$(RESET)"; \
	fi

.PHONY: leaks_msg leaks supp_msg supp suppleaks_msg suppleaks vclean
# **************************************************************************** #
# ---------------------------------- UTILS ----------------------------------- #
# **************************************************************************** #
run: all
	./$(NAME) $(ARGS)

debug: C_FLAGS += -g
debug: re

$(TMP_DIR):
	@mkdir -p $(TMP_DIR)

ffclean: fclean vclean mlxclean
	@$(MAKE) fclean -C $(LIBFT_DIR) $(NPD)
	@$(REMOVE) $(TMP_DIR) $(INIT_CHECK) $(NAME).dSYM

.PHONY: run debug ffclean
# **************************************************************************** #
# ---------------------------------- BACKUP (zip) ---------------------------- #
# **************************************************************************** #
USER		:=$(shell whoami)
ROOT_DIR	:=$(notdir $(shell pwd))
TIMESTAMP	:=$(shell date "+%Y%m%d_%H%M%S")
BACKUP_NAME	:=$(ROOT_DIR)_$(USER)_$(TIMESTAMP).zip
MOVE_TO		:= ~/Desktop/$(BACKUP_NAME)

zip: ffclean
	@if which zip > $(VOID); then \
		zip -r --quiet $(BACKUP_NAME) ./*; \
		mv $(BACKUP_NAME) $(MOVE_TO); \
		echo "[$(BOLD)$(PURPLE)$(NAME)$(RESET)] \
		compressed as: $(CYAN)$(UNDERLINE)$(MOVE_TO)$(RESET)"; \
	else \
		echo "Please install zip to use the backup feature"; \
	fi

.PHONY: zip
# **************************************************************************** #
# ----------------------------------- DECO ----------------------------------- #
# **************************************************************************** #
define TITLE

$@ is ready

endef
export TITLE
# **************************************************************************** #
ESC			:= \033

RESET		:= $(ESC)[0m
BOLD		:= $(ESC)[1m
ITALIC		:= $(ESC)[3m
UNDERLINE	:= $(ESC)[4m

# Cursor movement
UP			:= $(ESC)[A
DOWN		:= $(ESC)[B
TOP_LEFT	:= $(ESC)[1;1H

# Erasing
ERASE_REST	:= $(ESC)[K
ERASE_LINE	:= $(ESC)[2K
ERASE_ALL	:= $(ESC)[2J
# **************************************************************************** #
# ---------------------------------- COLORS ---------------------------------- #
# **************************************************************************** #
# Text
BLACK		:= $(ESC)[30m
RED			:= $(ESC)[91m
GREEN		:= $(ESC)[32m
YELLOW		:= $(ESC)[93m
ORANGE		:= $(ESC)[38;5;208m
BLUE		:= $(ESC)[94m
PURPLE		:= $(ESC)[95m
CYAN		:= $(ESC)[96m
WHITE		:= $(ESC)[37m
GRAY		:= $(ESC)[90m

# **************************************************************************** #
# ---------------------------------- TESTS ----------------------------------- #
# **************************************************************************** #
# testing multiple option targets
# (add grademe ?)

choose_read:
	@echo "Are you sure you want to print \"testing\" [y/N] " && read ANSWER; \
	if [ "$$ANSWER" = "y" ] || [ "$$ANSWER" = "Y" ]; then \
		echo "testing"; \
	else \
		echo "canceling..."; \
	fi

choose_case:
	@echo "Select a project to clone:"
	@echo "1. Project A"
	@echo "2. Project B"
	@echo "3. Project C"
	@read choice; \
	case $$choice in \
		1) echo "Cloning Project A..."; \
			echo "AAAAA" ;; \
		2) echo "Cloning Project B..."; \
			echo "BBBBB" ;; \
		3) echo "Cloning Project C..."; \
			echo "CCCCC" ;; \
		*) echo "Invalid choice. Exiting." ;; \
	esac

.PHONY: choose_read choose_case

# choose:
# 	@echo "Select a project to clone:"
# 	@echo "1. libft"
# 	@echo "2. push_swap"
# 	@echo "3. FdF"
# 	@echo "4. pipex"
# 	@echo "5. Minishell"
# 	@echo "6. Cub3D"
# 	@echo "\n(tester projects)\n"
# 	@echo "7. Placeholder"
# 	@echo "8. minilibx_project"
# 	@echo "8. MLX_project"
# 	@read choice; \
# 	case $$choice in \
# 		1) echo "Cloning Project A..."; \
# 			git clone --recurse-submodules <project-A-repository-url> ;; \
# 		2) echo "Cloning Project B..."; \
# 			git clone --recurse-submodules <project-B-repository-url> ;; \
# 		3) echo "Cloning Project C..."; \
# 			git clone --recurse-submodules <project-C-repository-url> ;; \
# 		5) echo "Cloning Project C..."; \
# 		*) echo "Invalid choice. Exiting." ;; \
# 	esac

# .PHONY: choose

# **************************************************************************** #

# tests (a trier)

# ifeq ($(shell uname),Linux)
# 	GLFW_DIR := /usr/include/GLFW/
# 	GLFW_EXISTS := $(shell pkg-config --exists glfw3 && echo TRUE)
# 	ifeq ($(GLFW_EXISTS), TRUE)
# 		LIBRARIES += -lglfw -ldl -lm -pthread
# 	else
# 		$(error GLFW not found. Please run 'make dep' to install necessary packages.)
# 	endif
# else ifeq ($(shell uname),Darwin)
# 	BREW_EXISTS := $(shell brew --version && echo TRUE)
# 	ifeq ($(BREW_EXISTS), TRUE)
# 		GLFW_EXISTS := $(shell brew list --formula | grep glfw && echo TRUE)
# 		ifeq ($(GLFW_EXISTS), TRUE)
# 			LIBRARIES += -lglfw -framework Cocoa -framework OpenGL -framework IOKit
# 		else
# 			$(error GLFW not found. Please run 'make dep' to install necessary packages.)
# 		endif
# 	else
# 		$(error Homebrew not found. Please run 'make dep' to install necessary packages.)
# 	endif
# 	GLFW_DIR := $(shell brew --prefix glfw)$(LIB_DIR)
# else
# 	$(error Unsupported operating system: $(shell uname))
# endif

# # **************************************************************************** #

# # //
# VOID := /dev/null

# ifeq ($(shell uname),Linux)
# 	cmake_check := $(shell cmake --version > $(VOID))
# 	install_packages:
# 	@echo "Installing required packages..."
# 	@sudo apt update > $(VOID) 2>&1
# 	@sudo apt install -y build-essential libx11-dev libglfw3-dev libglfw3 xorg-dev > $(VOID)
# 	@if [ ! -z "$(cmake_check)" ]; then \
# 		echo "To compile MLX42, please run 'make cmake' to install CMake.";	\
# 	fi
# else ifeq ($(shell uname),Darwin)
# 	brew_check := $(shell brew --version > $(VOID))
# 	cmake_check := $(shell cmake --version > $(VOID))
# 	install_packages:
# 		@echo "Installing required packages..."
# 		@if [ ! -z "$(brew_check)" ]; then \
# 			brew install glfw; \
# 		elif [ ! -z "$(cmake_check)" ]; then \
# 			echo "To install GLFW, please run 'make brew' to install Homebrew."; \
# 		else \
# 			echo "To compile MLX42 and/or install CMake, please run 'make cmake' to install CMake."; \
# 		fi
# else
# 	$(error Unsupported operating system: $(shell uname))
# endif

# # 'dep' target to install dependencies
# dep: install_packages
# 	@echo "Dependencies installed."

# # 'brew' target to install Homebrew
# brew:
# 	@echo "Installing Homebrew..."
# 	@/bin/bash -c \
# 	"$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# # installing cmake with brew if on mac, or with apt if on linux
# cmake:
# ifeq ($(shell uname),Darwin)
# 	@echo "Installing CMake..."
# 	@brew install cmake
# else ifeq ($(shell uname),Linux)
# 	@echo "Installing CMake..."
# 	@sudo apt install -y cmake
# else
# 	$(error Unsupported operating system: $(shell uname)) //*to fix and test



# **************************************************************************** #
# info
# **************************************************************************** #

# OPENGL is a cross-platform API for rendering 2D and 3D graphics.

# GLFW is a library that provides a simple API for 
#	creating windows, contexts and surfaces, receiving input and events.

# explaining the LIBRARIESvariable:
# -L$(GLFW_DIR)		: tells the compiler where to find the GLFW library
# (the '-L' is a flag that tells the compiler to look in the directory that follows for the library)

# $(MLX42) $(LIBFT)	: tells the compiler to link the MLX42 and LIBFT libraries (the .a files)


# (the '-l' is a flag that tells the compiler to link the library that follows)
# -lglfw			: tells the compiler to link the GLFW library
# -ldl				: tells the compiler to link the dynamic loading library
# -pthread			: tells the compiler to link the pthread library
# -lm				: tells the compiler to link the math library

# (glfw : the name of the library, without the 'lib' prefix and the '.a' suffix,
# 	used for managing windows, contexts, surfaces, input and events)

# the (3) after -lglfw is a version specifier indicating 
# a specific version of the GLFW library to link against.
# On macOS (which uses the Mach-O binary format), 
# frameworks are used to link libraries. 
# The -lglfw(3) syntax is specific to macOS and 
# denotes linking against GLFW version 3.
# On Linux (which typically uses the ELF binary format), 
# libraries are linked using the -l option 
# followed by the library name without a version specifier.

# (dl : used for dynamic loading) (meaning that it loads libraries at runtime)

# (pthread : used for multithreading)
# (links the program with the POSIX threads library,
# enabling multithreading capabilities in the resulting executable,
# allowing for concurrent execution of tasks across multiple threads.)

# (m : used for math)
# (even if we include the math.h header file, we still need to link the math library,
# because the math.h header file only contains the declarations of the math functions,
# not the actual code that implements them)
# ///

# := (Simple Assignment):

# Variables assigned with := use immediate or simple assignment.
# The right-hand side of the assignment is expanded once at the time of assignment.
# The variable value will remain the same throughout the makefile, 
# even if the value of other variables changes later.
# This type of assignment is useful when you want to evaluate the value only once 
# and have a fixed value for the variable.

# = (Recursive Assignment):

# Variables assigned with = use recursive assignment.
# The right-hand side of the assignment is not expanded immediately; 
# instead, it is expanded whenever the variable is used.
# The variable value will be evaluated each time it is referenced, 
# allowing for dynamic or delayed evaluation.
# This type of assignment is useful when you want the variable to reflect changes in other variables 
# or when you want the value to be evaluated at the time of usage.




# ///
# (The -j4 flag enables parallel compilation by running up to four simultaneous jobs,
# improving build time by utilizing multiple cores or threads.
