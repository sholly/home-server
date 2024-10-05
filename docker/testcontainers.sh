#!/usr/bin/env bash
docker run --name=prod.7.97  --rm -itd --network=prod1 --ip=172.31.7.97 alpine:latest /bin/sh
docker run --name=prod.22.3 --rm -itd --network=mvlanprod2 --ip=192.168.22.3 alpine:latest /bin/sh
docker run --name=dev.23.3 --rm -itd --network=mvlandev3 --ip=192.168.23.3 alpine:latest /bin/sh
