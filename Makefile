#!/usr/bin/make -f
.PHONY: clean build
.SECONDARY:

ALLSERVER=toolbox1 toolbox2 toolbox3 toolbox4
EXCLUDE=
SERVER=$(filter-out $(EXCLUDE), $(ALLSERVER))
CHECKWORD=RUSERROCK
DBNAME=toolkit

ROOT_DIR=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
CACHE_DIR=.
DOWNLOAD_DIR=$(CACHE_DIR)/downloads
LOG_DIR=$(CACHE_DIR)/logs
AGG_DIR=$(CACHE_DIR)/aggs

servers:
	@echo $(SERVER)

$(DOWNLOAD_DIR)/%.foo.gz:
	@mkdir -p '$(@D)'
	scp '$*':data/serverlog.foo.txt.gz '$@'

$(DOWNLOAD_DIR)/%.bar.gz:
	@mkdir -p '$(@D)'
	scp '$*':data/serverlog.bar.txt.gz '$@'

$(LOG_DIR)/%.txt: \
		$(DOWNLOAD_DIR)/%.foo.gz \
		$(DOWNLOAD_DIR)/%.bar.gz
	@mkdir -p '$(@D)'
	@rm -f '$@'
	zcat '$<' | head -1 >> '$@'
	for archive in $+; do \
		gunzip -c "$$archive" \
	        |tail -n +2 >> '$@'; \
	done


%.log: \
		%.txt
	@mkdir -p '$(@D)'
	cat '$+' \
	| grep -v "Toyota" \
	| sed 's/\"/\" \"/' \
	| awk '{$$3 = "\""$$3; print $$0}' \
	> '$@'

%.cut: \
		%.log
	@mkdir -p '$(@D)'
	cut -d\" -f4 '$+' \
	| sed 's/\$$/;/g' \
	| awk 'BEGIN {FS = ";"; OFS = ";"}\
		     {a = NF; $$6 = $$(a); $$(a) = ""; print $$0}'\
	> '$@'

$(AGG_DIR)/%.Rdata: $(LOG_DIR)/%.log $(LOG_DIR)/%.cut
	@mkdir -p '$(@D)'
	Rscript $(ROOT_DIR)/process.R -d \
		--checkword=$(CHECKWORD) --dbname=$(DBNAME) $+ 


