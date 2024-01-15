#!/usr/bin/env bash

nodes=$(pvesh get /cluster/resources --type vm  --output-format json |jq -r '.[] | [.vmid, .name, .node] | @json')
printf  "processing data ... \n"
for i in $nodes; do
  #printf "\n i= $i"
  vmid=$(jq -r '.[0]' <<< $i);
  vmname=$(jq -r '.[1]' <<< $i);
  node=$(jq -r '.[2]' <<< $i);
  snapshots=$(pvesh get "/nodes/$node/qemu/$vmid/snapshot" --output-format=json)
  snapdates=""
  snapdates=$(echo $snapshots | jq -r '[.[] | select(.snaptime) | (.snaptime  | tonumber | todate[:10])] | @csv ');
  if [[ $snapdates ]]; then
    printf "\n $node \t $vmid \t $vmname \t SNAPDATES: $snapdates"
  fi
done;
printf "\n processing complete \n"
