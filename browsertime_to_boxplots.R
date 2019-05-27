library(dplyr) 
library(ggplot2) 

library("rjson")
library("rowr")

setwd("/users/acreskey/tools/R/data/rcwn")

dir.create("plots")
system('bash ./to_csv_headers.sh')

folders <- list.dirs(path = "./data", full.names=FALSE, recursive = FALSE)

df <- data.frame()
for (folder in folders)
{
  thisPath <- paste("./data/", folder, sep="")
  my_files <- list.files(path=thisPath, pattern=".csv$", recursive=TRUE)
  
  for(i in seq_along(my_files))
  {
    thisFile = paste(thisPath, "/", my_files[i], sep="")
    print(thisFile)
    file <- read.csv(thisFile, header=TRUE,sep=",")
    csv_as_df <- as.data.frame(file)
    csv_as_df$url <- strtrim(csv_as_df$url, 40)
    df <- rbind(df, csv_as_df)
  }
}

ggplot(df, aes(x=url, y=loadtime)) +labs(title="baseline and rcwn off with 30Mbps 2ms rtt 'WIFI', Geckoview_example 05/24/2019, Moto G5", y = "loadtime, ms") + geom_boxplot(aes(fill=mode)) + theme(axis.text.x=element_text(angle=90, hjust=1))
#ggplot(df, aes(x=url, y=loadtime)) +labs(title="", y = "loadtime ms") + geom_point(aes(color=mode)) + theme(axis.text.x=element_text(angle=90, hjust=1))
#ggplot(df, aes(x=url, y=loadtime)) +labs(title="", y = "loadtime ms") + geom_violin(aes(fill=mode)) + theme(axis.text.x=element_text(angle=90, hjust=1))
