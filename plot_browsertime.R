library(ggplot2)

# point to your clone of the repo:
setwd("/users/acreskey/dev/test/R_tools")

# Depending on whether or not the browsertime data includes visual metrics,
#  uncomment the appropriate script:
# 1. visual metrics
system('sh to_csv_visual_metrics.sh')
# 2. no visual metrics:
#system('sh to_csv_no_visual_metrics.sh')

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

df
summary(df)

dir.create("plots")
pngPath <- paste("./plots/", "output", ".png", sep="")
png(file=pngPath, width = 12, height = 12, units = 'in', res = 300)

# customize title:
title <- "Cold page loads"

#select the metric (y=....) and uncomment one of the graph types
ggplot(df, aes(x=url, y=speedIndex)) +labs(title=title) + geom_point(aes(color=mode), position = position_dodge(width=0.8)) + theme(axis.text.x=element_text(angle=-67.5, hjust=0, vjust=0))
#ggplot(df, aes(x=url, y=loadtime)) +labs(title=title) + geom_point(aes(color=mode), position = position_dodge(width=0.8)) + theme(axis.text.x=element_text(angle=-67.5, hjust=0, vjust=0))
#ggplot(df, aes(x=url, y=speedIndex)) +labs(title=title) + geom_violin(aes(fill=mode), position = position_dodge(width=0.8)) + theme(axis.text.x=element_text(angle=-67.5, hjust=0, vjust=0))
#ggplot(df, aes(x=url, y=speedIndex)) +labs(title=title) + geom_boxplot(aes(fill=mode)) + theme(axis.text.x=element_text(angle=-67.5, hjust=0, vjust=0))

dev.off()
