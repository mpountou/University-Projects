SHELL := /bin/bash

# ==================================================
# COMMANDS

CC = gcc
RM = rm -f

# ==================================================
# TARGETS

all: episode_rename

# final link for executable
episode_rename: episode_rename.o utilities.o
	$(CC) $^ -o $@

# generate objects
%.o: %.c
	$(CC) -c $<

# clean temporary files
clean:
	$(RM) *.o *~

# remove executable
purge: clean
	$(RM) episode_rename
