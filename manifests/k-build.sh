#!/bin/sh
cd ./overlays/production || exit
kustomize build .
cd ../staging || exit
kustomize build .
echo "staging and production kustomization files rebuilt"
