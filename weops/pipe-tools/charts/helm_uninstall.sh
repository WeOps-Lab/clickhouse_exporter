#!/bin/bash

object=clickhouse

for RELEASE in $(helm list -n $object --short)
do
  echo "Uninstalling $RELEASE ..."
  helm uninstall -n $object "$RELEASE"
done
