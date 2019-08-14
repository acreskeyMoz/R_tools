# R_tools: R plots from browsertime.json

The data flow is:
browsertime.json -> csv -> R data frame -> plot to .png

• Clone this repo

• Copy your root `browsertime-results` into `experiment/data`

• Open `plot_browsertime_visual_metrics.R` and modify this line

```setwd("/users/acreskey/tools/R_tools/experiment")``` to point to match your local configuration.

• Run the R script (select all and then command-enter in RStudio for MacOS)

• The generated graph will be in `experiment/data`

```
R_tools/
├── experiment
│   ├── data (copy your root browsertime-results folder here)
│   └── plots (generated .png will be here)
├── plot_browsertime_visual_metrics.R
├── to_csv_headers.sh
└── to_csv_visual_metrics.sh
```
