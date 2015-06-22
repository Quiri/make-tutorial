library(dplyr)
library(wakefield)
library(magrittr)

args <- commandArgs(TRUE)

n <- args[1] %>% as.numeric

s1 <- r_data_frame(n, race, age, military)
write.table(s1, file = "s1.txt", sep = " ", row.names = FALSE, quote = FALSE)

s2 <- r_data_frame(n, color, speed, car, month, state)
s2$Month %<>% as.character
s2$Month[sample(1:n, n/2, replace = FALSE)] <- ""
write.table(s2, file = "s2.txt", sep = "$", row.names = FALSE, quote = FALSE)

system('sed -i "s/\\\\$\\\\$/\\\\$/g" s2.txt')
system('sed -i -e "s/^/\\"/g" -e "s/$/\\"/g" s2.txt')
system(sprintf('paste -d "" s1.txt s2.txt > %s.txt', args[2]))
system("rm s1.txt s2.txt")
system(sprintf('gzip -f %s.txt', args[2]))
