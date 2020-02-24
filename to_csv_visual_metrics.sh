#!/usr/bin/env bash
for filename in $(find ./data -name browsertime.json); do
  out_path=$(dirname $filename)/out.csv
 
  dir="$(dirname $filename)"   # Returns "/from/hear/to"
  dir="$(basename $dir)"  # Returns just "to"
  echo $dir

  # mode is passed into jq as an arg ($dir)
  #capture browserScripts as $metrics, and .visualMetrics as $visualMetrics
  # then we can interate over both arrays simultaneously with the same index

  # FIXME: this ordering is correct but is brittle. Need to generically transform the json fields to csv  
  cat $filename | jq --arg mode $dir --raw-output '["mode", "url", "backendTime", "firstPaint", "firstVisualChange", "DOMContentLoaded", "loadtime", "visualComplete85", "speedIndex", "contentfulSpeedIndex", "perceptualSpeedIndex", "rumSpeedIndex", "redirectionTime", "fetchStart", "domainLookupStart", "domainLookupEnd", "connectStart", "requestStart", "responseStart", "responseEnd", "domainLookupTime", "serverConnectionTime", "serverResponseTime", "frontEndTime", "decodedBodySize", "encodedBodySize", "domInteractive", "resourceCount", "resourceDuration" ], (.[] | .info.url as $url | .visualMetrics as $visualMetrics | .browserScripts as $metrics | range(0; $visualMetrics | length) as $i | [$mode, $url, $metrics[$i].timings.pageTimings.backEndTime, $metrics[$i].timings.firstPaint, $visualMetrics[$i].FirstVisualChange, $metrics[$i].timings.pageTimings.domContentLoadedTime, $metrics[$i].timings.pageTimings.pageLoadTime, $visualMetrics[$i].VisualComplete85, $visualMetrics[$i].SpeedIndex, $visualMetrics[$i].ContentfulSpeedIndex, $visualMetrics[$i].PerceptualSpeedIndex, $metrics[$i].timings.rumSpeedIndex, $metrics[$i].timings.pageTimings.redirectionTime, $metrics[$i].timings.navigationTiming.fetchStart, $metrics[$i].timings.navigationTiming.domainLookupStart, $metrics[$i].timings.navigationTiming.domainLookupEnd, $metrics[$i].timings.navigationTiming.connectStart, $metrics[$i].timings.navigationTiming.requestStart, $metrics[$i].timings.navigationTiming.responseStart, $metrics[$i].timings.navigationTiming.responseEnd, $metrics[$i].timings.pageTimings.domainLookupTime, $metrics[$i].timings.pageTimings.serverConnectionTime, $metrics[$i].timings.pageTimings.serverResponseTime, $metrics[$i].timings.pageTimings.frontEndTime, $metrics[$i].pageinfo.documentSize.decodedBodySize, $metrics[$i].pageinfo.documentSize.encodedBodySize, $metrics[$i].timings.navigationTiming.domInteractive, $metrics[$i].timings.pageTimings.resourceCount, $metrics[$i].timings.pageTimings.resourceDuration ]) | @csv' > $out_path

done
