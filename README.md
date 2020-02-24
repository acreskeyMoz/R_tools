## R plots from browsertime.json


Tool to import `browsertime.json` into R for the purpose of generating plots and summaries.
The data flow is:

```browsertime.json -> csv -> R data frame -> plot to .png```


### Setup

• Install R or RStudio

• Install jq so that it is available in your shell

• Clone this repo: ```git clone git@github.com:acreskeyMoz/R_tools.git```

• Customize the working directory in `plot_browsertime_visual_metrics.R` to match your local path:
https://github.com/acreskeyMoz/R_tools/blob/master/plot_browsertime_visual_metrics.R#L9

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

By default script will be looking for visual metrics (e.g. SpeedIndex, ContenfulSpeedIndex).
If those are not present, swap to this tranform script:

• OSX or Linux, WSL

• Run the R script (select all and then command-enter in RStudio for MacOS)

• The generated graph will be in `experiment/plots`
csv output for each run is also output.

•  A summary of the results is presented in the R log

Folder structure after completion
```
R_tools/
├── experiment
│   ├── data
│   │   └── browsertime-results
│   │       ├── booking.com
│   │       │   ├── chrome
│   │       │   │   ├── browsertime.json
│   │       │   │   └── out.csv
│   │       │   └── gve
│   │       │       ├── browsertime.json
│   │       │       └── out.csv
│   │       └── cnn.com
│   │           ├── chrome
│   │           │   ├── browsertime.json
│   │           │   └── out.csv
│   │           └── gve
│   │               ├── browsertime.json
│   │               └── out.csv
│   └── plots
│       └── output.png
├── plot_browsertime_visual_metrics.R
├── to_csv_no_visual_metrics.sh
└── to_csv_visual_metrics.sh
```

e.g.
![alt text](https://github.com/acreskeyMoz/R_tools/blob/master/output.png)
