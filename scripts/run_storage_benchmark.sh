#!/bin/bash
base_path="$HOME/project/bigdata-project"

echo "Running Sqoop import/storage benchmark..."
bash "$base_path/scripts/benchmark_storage_formats.sh"

echo "Running Spark read benchmark..."
spark-submit \
    --packages org.apache.spark:spark-avro_2.12:3.2.4 \
    "$base_path/scripts/benchmark_spark_reads.py"

echo "Benchmark completed."
echo "Results:"
echo "$base_path/output/storage_import_benchmark.csv"
echo "$base_path/output/storage_read_benchmark.csv"