#!/usr/bin/env bash
for filename in $(find ./data -name *.json); do
  out_path=$(dirname $filename)/out.csv

  dir="$(dirname $filename)"   # Returns "/from/hear/to"
  dir="$(basename $dir)"  # Returns just "to"
  echo $dir

  # mode is passed into jq as an arg ($dir)
  #capture browserScripts as $metrics, and .visualMetrics as $visualMetrics
  # then we can interate over both arrays simultaneously with the same index
  cat $filename | jq --arg mode $dir --raw-output '["mode", "url", "loadtime", "firstVisualChange", "speedIndex", "contentfulSpeedIndex", "visualComplete85" ], (.[] | .info.url as $url | .visualMetrics as $visualMetrics | .browserScripts as $metrics | range(0; $visualMetrics | length) as $i | [$mode, $url, $metrics[$i].timings.pageTimings.pageLoadTime, $visualMetrics[$i].FirstVisualChange, $visualMetrics[$i].SpeedIndex, $visualMetrics[$i].ContentfulSpeedIndex, $visualMetrics[$i].VisualComplete85]) | @csv' > $out_path

done
