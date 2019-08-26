## R plots from browsertime.json

Just copy your `browsertime-results` folder over and run an R script to generate pretty graphs.

The data flow is:

```browsertime.json -> csv -> R data frame -> plot to .png```

There are two R scripts that can be used:
One plots load time and the other plots visual metrics (SpeedIndex is the default but that can be changed)


### Setup
• Clone this repo

• Copy your root `browsertime-results` into `experiment/data`
  
    The name of the folder in which the browsertime.json resides is used as the 'mode'.
    This is a variation (e.g. a browser, preference change, etc). 
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

• If you want visual metrics, open `plot_browsertime_visual_metrics.R` and modify this line

```setwd("/users/acreskey/tools/R_tools/experiment")``` to match your local configuration.
This script will be looking for visual metrics (e.g. SpeedIndex, ContenfulSpeedIndex)

• If you want just loadtime, open `browsertime_loadtime.R` and modify this line

```setwd("/users/acreskey/tools/R_tools/experiment")``` to match your local configuration.


• Run the R script (select all and then command-enter in RStudio for MacOS)

• The generated graph will be in `experiment/plots`


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
├── to_csv_headers.sh
└── to_csv_visual_metrics.sh
```

e.g.
![alt text](https://github.com/acreskeyMoz/R_tools/blob/master/output.png)
