#!/usr/bin/make -f
.SECONDARY:

ROOT_DIR=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
CACHE_DIR=.
DOWNLOADS_DIR=$(CACHE_DIR)/downloads
LOGS_DIR=$(CACHE_DIR)/logs

SSH=$(ROOT_DIR)/ssh-config

$(DOWNLOADS_DIR)/%.foo.gz:
	@mkdir -p '$(@D)'
	scp -F $(SSH) '$*':data/serverlogs.foo.txt.gz '$@'

$(DOWNLOADS_DIR)/%.bar.gz:
	@mkdir -p '$(@D)'
	scp -F $(SSH) '$*':data/serverlogs.bar.txt.gz '$@'

$(LOGS_DIR)/%.txt: \
		$(DOWNLOADS_DIR)/%.foo.gz \
		$(DOWNLOADS_DIR)/%.bar.gz
	@mkdir -p '$(@D)'
	@rm -f '$@'
	zcat '$<' | head -1 >> '$@'
	for archive in $+; do \
		gunzip -c "$$archive" \
	        |tail -n +2 >> '$@'; \
	done

