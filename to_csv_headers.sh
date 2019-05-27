#!/usr/bin/env bash
for filename in $(find ./data -name *.json); do
  out_path=$(dirname $filename)/out.csv
  #echo $out_path

  dir="$(dirname $filename)"   # Returns "/from/hear/to"
  dir="$(basename $dir)"  # Returns just "to"
  echo $dir

  #cat $filename | jq --raw-output '.[] | .browserScripts[] | .timings | .pageTimings | [.pageLoadTime] | @csv' > $out_path
  #cat $filename | jq --arg mode $basename  --raw-output '["mode", "url", "loadtime", "fcp"], (.[] | .info.url as $url | .browserScripts[] | .timings | .timeToContentfulPaint as $fcp | .pageTimings | [$mode, $url, .pageLoadTime, $fcp]) | @csv' > $out_path
  cat $filename | jq --arg mode $dir --raw-output '["mode", "url", "loadtime", "fcp"], (.[] | .info.url as $url | .browserScripts[] | .timings | .timeToContentfulPaint as $fcp | .pageTimings | [$mode, $url, .pageLoadTime, $fcp]) | @csv' > $out_path
done
