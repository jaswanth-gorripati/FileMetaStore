#!/bin/bash

set -e

pushd ./hlf-network
./network.sh tx
popd