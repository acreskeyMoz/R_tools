#!/usr/bin/env bash
for filename in $(find ./data -name browsertime.json); do
  out_path=$(dirname $filename)/out.csv
  #echo $out_path

  dir="$(dirname $filename)"   # Returns "/from/hear/to"
  dir="$(basename $dir)"  # Returns just "to"
  echo $dir

  #cat $filename | jq --raw-output '.[] | .browserScripts[] | .timings | .pageTimings | [.pageLoadTime] | @csv' > $out_path
  #cat $filename | jq --arg mode $basename  --raw-output '["mode", "url", "loadtime", "fcp"], (.[] | .info.url as $url | .browserScripts[] | .timings | .timeToContentfulPaint as $fcp | .pageTimings | [$mode, $url, .pageLoadTime, $fcp]) | @csv' > $out_path

  # mode is passed into jq as an arg ($dir)
  #capture browserScripts as $metrics, and .visualMetrics as $visualMetrics
  # then we can interate over both arrays simultaneously with the same index
  cat $filename | jq --arg mode $dir --raw-output '["mode", "url", "responseStart", "firstPaint", "firstVisualChange", "DOMContentLoaded", "loadtime", "visualComplete85", "speedIndex", "contentfulSpeedIndex", "perceptualSpeedIndex" ], (.[] | .info.url as $url | .visualMetrics as $visualMetrics | .browserScripts as $metrics | range(0; $visualMetrics | length) as $i | [$mode, $url, $metrics[$i].timings.pageTimings.backEndTime, $metrics[$i].timings.firstPaint, $visualMetrics[$i].FirstVisualChange, $metrics[$i].timings.pageTimings.domContentLoadedTime, $metrics[$i].timings.pageTimings.pageLoadTime, $visualMetrics[$i].VisualComplete85, $visualMetrics[$i].SpeedIndex, $visualMetrics[$i].ContentfulSpeedIndex, $visualMetrics[$i].PerceptualSpeedIndex]) | @csv' > $out_path

done
