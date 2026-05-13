#!/bin/bash

set -euo pipefail

conf_path="$HOME/.spark/conf/log4j.properties"

spark-submit \
  --master yarn \
  --deploy-mode cluster \
  --driver-memory 1g \
  --executor-memory 5g \
  --executor-cores 3 \
  --conf "spark.driver.extraJavaOptions=-Dlog4j.configuration=file:$conf_path" \
  --conf "spark.executor.extraJavaOptions=-Dlog4j.configuration=file:$conf_path" \
  ~/project/bigdata-project/scripts/build_model.py
