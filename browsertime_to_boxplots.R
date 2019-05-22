library("rjson")

setwd("/users/acreskey/tools/R/data/tsproxy/data")

system('bash ./to_csv.sh')

folders <- list.dirs(full.names=FALSE, recursive = FALSE)

for (folder in folders)
{
  thisPath <- paste("./", folder, sep="")
  my_files <- list.files(path=thisPath, pattern=".csv$", recursive=TRUE)
  
  df <- data.frame()
  
  for(i in seq_along(my_files))
  {
    print(my_files[i])
    thisFile = paste(thisPath, "/", my_files[i], sep="")
    file <- read.csv(thisFile, header=FALSE,sep=",")
    csv_as_df <- as.data.frame(file)
    name <-unlist(strsplit(my_files[i], "/"))
    colnames(csv_as_df) <- name[length(name)-1]
    if (nrow(df)==0)
    {
      df <- csv_as_df
    }
    else
    {
      df <- cbind(df, csv_as_df)
    }
  }
  
  #strip off https;//
  graphname <- substring(folder, 9)

  # plot to high resolution png
  pngPath <- paste("../plots/", graphname, ".png", sep="")
  png(file=pngPath, width=1200,height=1200)

  y_label <- paste("loadtime ", graphname, sep="" )
  boxplot(df, ylab=y_label)
  dev.off()
}
