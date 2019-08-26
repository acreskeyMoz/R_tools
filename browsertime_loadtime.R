library(dplyr) 
library(ggplot2) 
library(tidyr)

library("rjson")
library("rowr")
library("doBy")

setwd("/users/acreskey/tools/R/data/some_loadtime_experiment")

dir.create("plots")
system('bash ../to_csv_headers.sh')

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
    # strip out 0 loadtime timeouts
    csv_as_df <- csv_as_df[csv_as_df$loadtime != 0,]
    df <- rbind(df, csv_as_df)
  }
}

pngPath <- paste("./plots/", "output", ".png", sep="")
png(file=pngPath, width = 12, height = 12, units = 'in', res = 300)

title <- "Graph title"

#ggplot(df, aes(x=url, y=loadtime)) +labs(title=title, y = "loadtime ms") + geom_boxplot(aes(fill=mode)) + theme(axis.text.x=element_text(angle=-67.5, hjust=0, vjust=0))
ggplot(df, aes(x=url, y=loadtime)) +labs(title=title, y = "loadtime ms") + geom_point(aes(color=mode), position = position_dodge(width=0.6)) + theme(axis.text.x=element_text(angle=-67.5, hjust=0, vjust=0))
#ggplot(df, aes(x=url, y=loadtime)) +labs(title="", y = "loadtime ms") + geom_violin(aes(fill=mode)) + theme(axis.text.x=element_text(angle=-67.5, hjust=0, vjust=0))


dev.off()

# long to wide with all cases, loadtime
temp <- df[c("url", "mode", "loadtime")]
temp <- tibble::rowid_to_column(temp, var = "id")
wide = spread(temp, mode, loadtime, convert=TRUE)
summary(wide)

# collect cases into grouped summary
#e.g.
#                             url     mode loadtime.m loadtime.s
#1 https://www.washingtonpost.com     1ssl   2547.469   966.1234
#2 https://www.washingtonpost.com     3ssl   2867.240  1057.0106
#3 https://www.washingtonpost.com baseline   2819.080   944.1798

x <- summaryBy(loadtime ~ url+mode, data = df,
          FUN = function(x) { c(m = mean(x), s = sd(x)) } )
x
# make loadtime.m read mean (+/- loadtime.s)

# apply a function to a column, overwriting data
myRound <- function(x){
  round(x, digits=0)
}   
x[3:4] <- lapply(x[3:4], myRound)

#merge loadtime.m into a column with mean and std dev
x$loadtime.m <- paste(formatC(x$loadtime.m, width=6), " (+/-", formatC(x$loadtime.s, width=4), ")", sep="" )

# drop loadtime.s
x <- x[,c(1,2,3)]
x

# long to wide on mode*load
#e.g.
#                             url     1ssl    3ssl baseline
#1 https://www.washingtonpost.com 2547.469 2867.24  2819.08
y = spread(x, mode, loadtime.m, convert=TRUE)
y
