#!/usr/bin/env bash
for filename in $(find ./data -name browsertime.json); do
  out_path=$(dirname $filename)/out.csv
  #echo $out_path

  dir="$(dirname $filename)"   # Returns "/from/hear/to"
  dir="$(basename $dir)"  # Returns just "to"
  echo $dir

  # Nick's directory structure
  #parentdir="$(dirname "$filename")"
  #parentdir="$(dirname "$parentdir")"
  #dir="$(basename $parentdir)"  # Returns just "to"
  #echo $dir

  #cat $filename | jq --raw-output '.[] | .browserScripts[] | .timings | .pageTimings | [.pageLoadTime] | @csv' > $out_path
  #cat $filename | jq --arg mode $basename  --raw-output '["mode", "url", "loadtime", "fcp"], (.[] | .info.url as $url | .browserScripts[] | .timings | .timeToContentfulPaint as $fcp | .pageTimings | [$mode, $url, .pageLoadTime, $fcp]) | @csv' > $out_path

  # mode is passed into jq as an arg ($dir)
  #capture browserScripts as $metrics, and .visualMetrics as $visualMetrics
  # then we can interate over both arrays simultaneously with the same index

  cat $filename | jq --arg mode $dir --raw-output '["mode", "url", "backendTime", "firstPaint", "DOMContentLoaded", "loadtime", "redirectionTime", "fetchStart", "domainLookupStart", "domainLookupEnd", "connectStart", "requestStart", "responseStart", "responseEnd", "domainLookupTime", "serverConnectionTime", "serverResponseTime", "frontEndTime", "decodedBodySize", "encodedBodySize" ], (.[] | .info.url as $url | .browserScripts as $metrics | range(0; $metrics | length) as $i | [$mode, $url, $metrics[$i].timings.pageTimings.backEndTime, $metrics[$i].timings.firstPaint, $metrics[$i].timings.pageTimings.domContentLoadedTime, $metrics[$i].timings.pageTimings.pageLoadTime, $metrics[$i].timings.pageTimings.redirectionTime, $metrics[$i].timings.navigationTiming.fetchStart, $metrics[$i].timings.navigationTiming.domainLookupStart, $metrics[$i].timings.navigationTiming.domainLookupEnd, $metrics[$i].timings.navigationTiming.connectStart, $metrics[$i].timings.navigationTiming.requestStart, $metrics[$i].timings.navigationTiming.responseStart, $metrics[$i].timings.navigationTiming.responseEnd, $metrics[$i].timings.pageTimings.domainLookupTime, $metrics[$i].timings.pageTimings.serverConnectionTime, $metrics[$i].timings.pageTimings.serverResponseTime, $metrics[$i].timings.pageTimings.frontEndTime, $metrics[$i].pageinfo.documentSize.decodedBodySize, $metrics[$i].pageinfo.documentSize.encodedBodySize ]) | @csv' > $out_path

done
