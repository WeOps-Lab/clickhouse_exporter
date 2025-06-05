#!/bin/bash
set -e

# 部署监控对象
object_versions=("23.8.16" "24.12.4" "25.5.2")
object=clickhouse

# 部署 v22 版本
version="22.8.21"
version_suffix="v22"
chart_dir="./v22/clickhouse"
helm install $object-$version_suffix --namespace $object -f ./values/values.yaml \
    --set image.tag=$version \
    --set podLabels.object_version=$version_suffix \
    $chart_dir

# 部署其他版本
for version in "${object_versions[@]}"; do
    version_suffix="v${version%%.*}"
    chart_dir="./new/clickhouse"
    helm install $object-$version_suffix --namespace $object -f ./values/values.yaml \
        --set image.tag=$version \
        --set podLabels.object_version=$version_suffix \
        $chart_dir
done

