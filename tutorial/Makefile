#!/usr/bin/make -f
.SECONDARY:

ROOT_DIR=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
CACHE_DIR=.
DOWNLOADS_DIR=$(CACHE_DIR)/downloads

SSH=$(ROOT_DIR)/ssh-config

$(DOWNLOADS_DIR)/%.foo.gz:
	@mkdir -p '$(@D)'
	scp -F $(SSH) '$*':data/serverlogs.foo.txt.gz '$@'

$(DOWNLOADS_DIR)/%.bar.gz:
	@mkdir -p '$(@D)'
	scp -F $(SSH) '$*':data/serverlogs.bar.txt.gz '$@'

