#!/usr/bin/env bash
docker run --name=prod.1.110  --rm -itd --network=prod1 --ip=172.31.1.110 alpine:latest /bin/sh
docker run --name=prod.2.110 --rm -itd --network=mvlanprod2 --ip=172.31.2.110 alpine:latest /bin/sh
docker run --name=dev.3.110 --rm -itd --network=mvlandev3 --ip=172.31.3.110 alpine:latest /bin/sh
