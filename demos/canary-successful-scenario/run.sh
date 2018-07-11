#!/bin/bash

DEMO_RUN_FAST=1
ROOT_DIR=$(dirname $0)/..
. $ROOT_DIR/util.sh

desc "Kubernetes cluster"
run "kubectl get nodes"

desc "Fission installed"
run "kubectl --namespace default get deployment"

clear

desc "NodeJS environment pods"
run "kubectl --namespace fission-function get pod -l environmentName=nodejs"

desc "Function version-1"
run "fission function get --name fn1-v4"

desc "Function version-2"
run "fission function get --name fn1-v5"

desc "Create a route \(HTTP trigger\) the version-1 of the function with weight 100% and version-2 with weight 0%"
run "fission route create --name route-hello --method GET --url /hello --function fn1-v5 --weight 0 --function fn1-v4 --weight 100"

desc "Create a canary config to gradually increment the weight of version-2 by a step of 20 every 1 minute"
run "fission canary-config create --name canary-1 --funcN fn1-v5 --funcN-1 fn1-v4 --trigger route-hello --increment-step 30 --increment-interval 1m --failure-threshold 10"

sleep 2

# TODO : Find a way to do the below in a for loop

desc "Fire requests to the route"
run "ab -n 35 -c 7 http://$FISSION_ROUTER/hello"

desc "Check the current weight distribution"
run "fission route get --name route-hello"

desc "Wait for a few seconds"
run "sleep 30"

desc "Fire more requests to the route"
run "ab -n 35 -c 7 http://$FISSION_ROUTER/hello"

desc "Check the current weight distribution"
run "fission route get --name route-hello"

desc "Wait for a few seconds"
run "sleep 30"

desc "Fire more requests to the route"
run "ab -n 35 -c 7 http://$FISSION_ROUTER/hello"

desc "Check the current weight distribution"
run "fission route get --name route-hello"

desc "Wait for a few seconds"
run "sleep 30"

desc "Check the current weight distribution"
run "fission route get --name route-hello"

desc "Fire more requests to the route"
run "ab -n 35 -c 7 http://$FISSION_ROUTER/hello"

desc "Check the current weight distribution"
run "fission route get --name route-hello"

desc "Wait for a few seconds"
run "sleep 30"

desc "Fire more requests to the route"
run "ab -n 35 -c 7 http://$FISSION_ROUTER/hello"

desc "Check the current weight distribution"
run "fission route get --name route-hello"

desc "Wait for a few seconds"
run "sleep 30"