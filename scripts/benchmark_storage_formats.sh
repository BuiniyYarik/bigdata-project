#!/bin/bash

base_path="$HOME/project/bigdata-project"

db_name="team4_projectdb"
db_user="team4"
db_host="hadoop-04.uni.innopolis.ru"
hdfs_root="/user/team4/project/benchmark_storage"

password=$(head -n 1 "$base_path/secrets/.psql.pass")

mkdir -p "$base_path/output"

results_file="$base_path/output/storage_import_benchmark.csv"
echo "format,compression,hdfs_path,size_bytes,import_time_sec,status" > "$results_file"

run_sqoop_import() {
    local file_format="$1"
    local compression="$2"
    local hdfs_path="$hdfs_root/${file_format}_${compression}"
    local start_time
    local end_time
    local import_time
    local size_bytes
    local status
    local format_arg

    echo "Benchmarking import: $file_format + $compression"

    hdfs dfs -rm -r -f -skipTrash "$hdfs_path" > /dev/null 2>&1 || true

    if [ "$file_format" = "avro" ]; then
        format_arg="--as-avrodatafile"
    elif [ "$file_format" = "parquet" ]; then
        format_arg="--as-parquetfile"
    else
        echo "Unsupported format: $file_format"
        exit 1
    fi

    start_time=$(date +%s)

    if sqoop import-all-tables \
        --connect "jdbc:postgresql://${db_host}/${db_name}" \
        --username "$db_user" \
        --password "$password" \
        --compression-codec "$compression" \
        --compress \
        "$format_arg" \
        --warehouse-dir "$hdfs_path" \
        --m 1 > /dev/null 2>&1; then
        status="SUCCESS"
    else
        status="FAILED"
    fi

    end_time=$(date +%s)
    import_time=$((end_time - start_time))

    if hdfs dfs -test -d "$hdfs_path"; then
        size_bytes=$(hdfs dfs -du -s "$hdfs_path" | awk '{print $1}')
    else
        size_bytes=""
        status="FAILED"
    fi

    echo "$file_format,$compression,$hdfs_path,$size_bytes,$import_time,$status" >> "$results_file"
}

hdfs dfs -mkdir -p "$hdfs_root"

run_sqoop_import "avro" "snappy"
run_sqoop_import "avro" "gzip"
run_sqoop_import "avro" "bzip2"

run_sqoop_import "parquet" "snappy"
run_sqoop_import "parquet" "gzip"
run_sqoop_import "parquet" "bzip2"

echo "Import benchmark completed."
echo "Results saved to: $results_file"