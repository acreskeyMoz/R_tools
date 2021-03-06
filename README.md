## R plots from browsertime.json


Tooling to import `browsertime.json` into R for the purpose of generating plots and summaries.

The data flow is:
```browsertime.json -> csv -> R data frame -> plot to .png```

• Requires MacOS, Linux, or WSL



### Setup

• Install R or RStudio

• Install `jq` so that it is available in your shell

• Clone this repo: ```git clone git@github.com:acreskeyMoz/R_tools.git```

• Open `plot_browsertime.R` in R or RStudio and customize the working directory to match your local environment:
[plot_browsertime.R](https://github.com/acreskeyMoz/R_tools/blob/62132cc7440cd6008d97e5768ad9167ebc88baa9/plot_browsertime.R#L4)

• Copy your root `browsertime-results` into `R_tools/data/`
This script will read in the data from this folder
  
    The name of the folder in which the browsertime.json resides is used as the 'mode'.
    This is a test variation (e.g. a browser, preference change, etc). 
  ```
     ├── data
     │   │   └── browsertime-results
     │   │       ├── booking.com
     │   │       │   ├── chrome
     │   │       │   │   ├── browsertime.json
     │   │       │   │   
     │   │       │   └── gve
     │   │       │       ├── browsertime.json
```

• By default, the R script will transforms using visual metrics (e.g. SpeedIndex, ContenfulSpeedIndex).
If those are not present, swap to this tranform script:
[plot_browsertime.R#L6-L11](https://github.com/acreskeyMoz/R_tools/blob/62132cc7440cd6008d97e5768ad9167ebc88baa9/plot_browsertime.R#L6-L11)

• Uncomment the desired graph type and set the metric (y=...)
[plot_browsertime.R#L44-L48](https://github.com/acreskeyMoz/R_tools/blob/62132cc7440cd6008d97e5768ad9167ebc88baa9/plot_browsertime.R#L44-L48)

• Run the R script (select all and then command-enter in RStudio for MacOS)

• The generated graph will be in `/plots/output.png`

• `.csv` for each `.json` is also output in the `browsertime-results` folder.

•  A summary of the results is presented in the R log

e.g.
![alt text](https://github.com/acreskeyMoz/R_tools/blob/master/sample.png)
