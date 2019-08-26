#!/usr/bin/env bash
for filename in $(find ./data -name *.json); do
  out_path=$(dirname $filename)/out.csv

  # get the directory name to be used as the "mode" header
  dir="$(dirname $filename)"   # Returns "/from/here/to"
  dir="$(basename $dir)"  # Returns just "to"
  echo $dir

  cat $filename | jq --arg mode $dir --raw-output '["mode", "url", "loadtime", "fcp"], (.[] | .info.url as $url | .browserScripts[] | .timings | .timeToContentfulPaint as $fcp | .pageTimings | [$mode, $url, .pageLoadTime, $fcp]) | @csv' > $out_path
done
