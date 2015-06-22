#!/usr/bin/env Rscript

suppressMessages(library(wakefield))
suppressMessages(library(magrittr))
suppressMessages(library(optparse))

option_list <- list(
	make_option(c("-n", "--number"), type = "integer", 
		    help = "Number of logs to generate"),
	make_option(c("-v", "--variation"), type = "integer", default = 0L,
		    help = "Random variance of n")
	)
arguments <- OptionParser(usage = "%prog [options] output",
			  option_list=option_list) %>%
	parse_args(positional_arguments = 1)
opts <- arguments$options
filename <- arguments$args

n <- 0
while(n <=0) {
  n <- rnorm(1, mean = opts$number, sd = opts$variation) %>% ceiling
}

s1 <- r_data_frame(n, race, age, military)
write.table(s1, file = "s1.txt", sep = " ", row.names = FALSE, quote = FALSE)

s2 <- r_data_frame(n, color, speed, car, month, state)
s2$Month %<>% as.character
s2$Month[sample(1:n, ceiling(n/2), replace = FALSE)] <- ""
write.table(s2, file = "s2.txt", sep = "$", row.names = FALSE, quote = FALSE)

system('sed -i "s/\\\\$\\\\$/\\\\$/g" s2.txt')
system('sed -i -e "s/^/\\"/g" -e "s/$/\\"/g" s2.txt')
system(sprintf('paste -d "" s1.txt s2.txt > %s.txt', filename))
system("rm s1.txt s2.txt")
system(sprintf('gzip -f %s.txt', filename))
