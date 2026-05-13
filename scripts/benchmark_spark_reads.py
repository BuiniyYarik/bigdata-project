"""Benchmark Spark read/query performance for imported storage formats."""

import csv
import time
from pathlib import Path
from typing import Any, Callable, Dict, List, Tuple

from py4j.protocol import Py4JJavaError
from pyspark.sql import DataFrame, SparkSession


BASE_PATH = Path.home() / "project" / "bigdata-project"
INPUT_CSV = BASE_PATH / "output" / "storage_import_benchmark.csv"
OUTPUT_CSV = BASE_PATH / "output" / "storage_read_benchmark.csv"


def measure(operation_name: str, operation: Callable[[], Any]) -> Tuple[str, Any, float]:
    """Measure execution time of a Spark action."""
    start_time = time.time()
    result = operation()
    end_time = time.time()

    return operation_name, result, round(end_time - start_time, 4)


def load_table(spark: SparkSession, file_format: str, table_path: str) -> DataFrame:
    """Load a table from HDFS according to its storage format."""
    if file_format == "avro":
        return spark.read.format("avro").load(table_path)

    if file_format == "parquet":
        return spark.read.parquet(table_path)

    raise ValueError(f"Unsupported format: {file_format}")


def count_rows(dataframe: DataFrame) -> int:
    """Count all rows in a dataframe."""
    return dataframe.count()


def benchmark_table(
    spark: SparkSession,
    file_format: str,
    compression: str,
    table_path: str,
) -> List[Dict[str, Any]]:
    """Run benchmark operations for one imported table."""
    dataframe = load_table(
        spark=spark,
        file_format=file_format,
        table_path=table_path,
    )

    columns = dataframe.columns
    first_column = columns[0]

    results = [
        measure("count_all", lambda: count_rows(dataframe)),
        measure(
            "distinct_first_column",
            lambda: dataframe.select(first_column).distinct().count(),
        ),
        measure(
            "sort_by_first_column",
            lambda: dataframe.orderBy(first_column).count(),
        ),
    ]

    if len(columns) >= 2:
        second_column = columns[1]
        results.append(
            measure(
                "group_by_second_column",
                lambda: dataframe.groupBy(second_column).count().count(),
            )
        )

    return [
        {
            "format": file_format,
            "compression": compression,
            "table_path": table_path,
            "operation": operation_name,
            "result_value": result_value,
            "runtime_sec": runtime_sec,
        }
        for operation_name, result_value, runtime_sec in results
    ]


def list_hdfs_subdirectories(spark: SparkSession, hdfs_path: str) -> List[str]:
    """List direct HDFS subdirectories using Hadoop FileSystem API."""
    hadoop_filesystem = spark._jvm.org.apache.hadoop.fs.FileSystem.get(
        spark._jsc.hadoopConfiguration()
    )
    hadoop_path = spark._jvm.org.apache.hadoop.fs.Path(hdfs_path)

    return [
        item.getPath().toString()
        for item in hadoop_filesystem.listStatus(hadoop_path)
        if item.isDirectory()
    ]


def read_import_benchmark_rows() -> List[Dict[str, str]]:
    """Read import benchmark rows from CSV."""
    with open(INPUT_CSV, newline="", encoding="utf-8") as csv_file:
        return list(csv.DictReader(csv_file))


def write_read_benchmark_rows(rows: List[Dict[str, Any]]) -> None:
    """Write Spark read benchmark results to CSV."""
    OUTPUT_CSV.parent.mkdir(parents=True, exist_ok=True)

    fieldnames = [
        "format",
        "compression",
        "table_path",
        "operation",
        "result_value",
        "runtime_sec",
    ]

    with open(OUTPUT_CSV, "w", newline="", encoding="utf-8") as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def make_error_row(
    file_format: str,
    compression: str,
    table_path: str,
    error: Exception,
) -> Dict[str, Any]:
    """Create a CSV row for a failed benchmark attempt."""
    return {
        "format": file_format,
        "compression": compression,
        "table_path": table_path,
        "operation": "error",
        "result_value": str(error).replace(",", ";").replace("\n", " "),
        "runtime_sec": -1,
    }


def main() -> None:
    """Run Spark read benchmarks for all successful imported benchmark datasets."""
    spark = SparkSession.builder.appName("Storage format read benchmark").getOrCreate()
    all_results = []  # type: List[Dict[str, Any]]

    for row in read_import_benchmark_rows():
        if row.get("status") != "SUCCESS":
            print(
                f"Skipping failed import: "
                f"{row['format']} + "
                f"{row['compression']} | "
                f"{row['hdfs_path']}"
            )
            continue

        file_format = row["format"]
        compression = row["compression"]
        hdfs_path = row["hdfs_path"]

        try:
            table_paths = list_hdfs_subdirectories(spark=spark, hdfs_path=hdfs_path)
        except Py4JJavaError as error:
            print(f"Skipping missing or invalid HDFS path: {hdfs_path}")
            all_results.append(
                make_error_row(
                    file_format=file_format,
                    compression=compression,
                    table_path=hdfs_path,
                    error=error,
                )
            )
            continue

        for table_path in table_paths:
            print(
                f"Benchmarking reads: "
                f"{file_format} + {compression} | {table_path}"
            )

            try:
                all_results.extend(
                    benchmark_table(
                        spark=spark,
                        file_format=file_format,
                        compression=compression,
                        table_path=table_path,
                    )
                )
            except (Py4JJavaError, ValueError) as error:
                all_results.append(
                    make_error_row(
                        file_format=file_format,
                        compression=compression,
                        table_path=table_path,
                        error=error,
                    )
                )

    write_read_benchmark_rows(all_results)
    spark.stop()

    print(f"Read benchmark completed. Results saved to: {OUTPUT_CSV}")


if __name__ == "__main__":
    main()
