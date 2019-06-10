library(dplyr) 
library(ggplot2) 
library(tidyr)

library("rjson")
library("rowr")
library("doBy")

setwd("/users/acreskey/tools/R/data/ssl_threads")

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
    # strip out 0 loadtime timeouts
    csv_as_df <- csv_as_df[csv_as_df$loadtime != 0,]
    df <- rbind(df, csv_as_df)
  }
}

pngPath <- paste("./plots/", "test", ".png", sep="")
png(file=pngPath, width = 12, height = 12, units = 'in', res = 300)

title <- "cold page loads, n=50, varying number of SSL threads (baseline=5)"
ggplot(df, aes(x=url, y=loadtime)) +labs(title=title, y = "loadtime ms") + geom_boxplot(aes(fill=mode)) + theme(axis.text.x=element_text(angle=-67.5, hjust=0, vjust=0)) + xlab('site')
#ggplot(df, aes(x=url, y=loadtime)) +labs(title=title, y = "loadtime ms") + geom_point(aes(color=mode)) + theme(axis.text.x=element_text(angle=90, hjust=1)) 

#ggplot(df, aes(x=url, y=loadtime)) +labs(title="", y = "loadtime ms") + geom_violin(aes(fill=mode)) + theme(axis.text.x=element_text(angle=90, hjust=1))
#ggplot(df, aes(x=url, y=loadtime)) +labs(title="", y = "loadtime ms") + geom_violin(aes(fill=mode)) + facet_wrap(vars(device), ncol=1, scales='fixed', labeller=labeller(.multi_line=FALSE)) + theme(axis.text.x=element_text(angle=-67.5, hjust=0, vjust=0)) + xlab('site')

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

# drop loadtime.s
x <- x[,c(1,2,3)]

# long to wide on mode*load
#e.g.
#                             url     1ssl    3ssl baseline
#1 https://www.washingtonpost.com 2547.469 2867.24  2819.08
y = spread(x, mode, loadtime.m, convert=TRUE)
y

#mutate(y, improvement_pct = -(y[[2]] - y[[3]]) /y[[2]] * 100)
