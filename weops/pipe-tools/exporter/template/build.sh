#!/bin/bash

# 单点
for version in v22 v23 v24 v25; do
  output_file="${version}.yaml"
  sed "s/{{VERSION}}/${version}/g;" standalone.tpl > ../standalone/${output_file}
done

