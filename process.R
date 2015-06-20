#!/usr/bin/Rscript
suppressMessages(library(data.table))
suppressMessages(library(dplyr))
suppressMessages(library(magrittr))
suppressMessages(library(optparse))
suppressMessages(library(readr))
suppressMessages(library(bbbi))
suppressMessages(library(RPostgreSQL))


options(warn = 2)
Sys.setlocale("LC_TIME", "C") %>% invisible

## ---- Argument parsing
  options_list <- list(
    make_option( c("-d", "--db"), action = "store_true", default = FALSE, 
                 help = "Writes the results to a database"),
    make_option( c("--dbname"), type = "character", help = "Name of Database"),
    make_option( c("-s", "--save"), action = "store_true", default = FALSE, 
                 help = "Saves the results to an .Rdata file"),
    make_option( c("-f", "--save-to-folder"), type = "character", default = ".", 
                 metavar = "folder", dest = "savetofolder",
                 help = "The folder to save the results to (if -s flag is used) [dafault \"%default\"]"),
    make_option( c("--checkword"), type = "character", default = "", help = "Checkword for Makefile. 
                 Will insert this to stdout.")

    )
  
  arguments <- OptionParser(usage = "%prog [options] txtfile cutfile", option_list=options_list) %>%
    parse_args(positional_arguments = 2)
  
   
  opt <-  arguments$options
  args <- arguments$args

## ---- IMPORT

server <- gsub(".*/(.*)\\..*","\\1", args[1])


cat(server, ":", "imports data \n")
logs <- read_log(args[1], col_names = TRUE, col_types = "cicc") %>% 
  data.table  

cut <- read_csv2(args[2], col_names = TRUE, 
		col_types = paste(rep("c",6), collapse='')) %>% 
  data.table 
cut$'[EMPTY]' <- NULL

data <- cbind(logs, cut)
rm(logs, cut); garbcoll <- gc();

## ---- AGGREGATION
cat(server, ":", "aggregates \n")
raw <- data[, .N, .(Race, Military, Color, Month, State)
	    ][, server := server]

cat(server, ":", "inserts to DB \n")
conn <- dbConnect("PostgreSQL", db = opt$dbname)
inserted <- insertDB(raw, conn, "raw")

if( inserted )
  cat(server, ":", opt$checkword, "\n")
