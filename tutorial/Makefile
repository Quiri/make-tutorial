#!/usr/bin/make -f
.PHONY: clean build servers
.SECONDARY:

ALLSERVER=server1 server2 server3 server4
EXCLUDE=
SERVERS=$(filter-out $(EXCLUDE), $(ALLSERVER))
CHECKWORD=RUSERROCK
DBNAME=datakraken

ROOT_DIR=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
CACHE_DIR=.
DOWNLOADS_DIR=$(CACHE_DIR)/downloads
LOGS_DIR=$(CACHE_DIR)/logs
RESULTS_DIR=$(CACHE_DIR)/results

SSH=$(ROOT_DIR)/ssh-config

build: $(RESULTS_DIR)/agg.check

clean: 
	rm -rf $(DOWNLOADS_DIR)
	rm -rf $(LOGS_DIR)
	rm -rf $(RESULTS_DIR)

servers:
	@echo $(SERVERS)

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


%.log: 	%.txt
	@mkdir -p '$(@D)'
	cat '$+' \
	| grep -v "Toyota" \
	| sed 's/\"/\" \"/' \
	| awk '{$$3 = "\""$$3; print $$0}' \
	> '$@'

%.cut: 	%.log
	@mkdir -p '$(@D)'
	cut -d\" -f4 '$+' \
	| sed 's/\$$/;/g' \
	| awk 'BEGIN {FS = ";"; OFS = ";"}\
		     {a = NF; $$6 = $$(a); $$(a) = ""; print $$0}'\
	> '$@'

$(RESULTS_DIR)/%.raw.output: $(LOGS_DIR)/%.log $(LOGS_DIR)/%.cut
	@mkdir -p '$(@D)'
	Rscript $(ROOT_DIR)/process.R -d \
		--checkword=$(CHECKWORD) --dbname=$(DBNAME) $+ > '$@'

%.check: %.output
	grep '$(CHECKWORD)' '$+'


$(RESULTS_DIR)/agg.output : \
		$(SERVERS:%=$(RESULTS_DIR)/%.raw.check)
	psql $(DBNAME) -f $(ROOT_DIR)/agg.sql > '$@' \
	&& echo '$(CHECKWORD)' >> '$@'

