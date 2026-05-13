#!/bin/bash

base_path="$HOME/project/bigdata-project"

directory="$base_path/data"
file="Combined_Flights_2021.csv"
zip_file="Combined_Flights_2021.csv.zip"
dataset="robikscube/flight-delay-dataset-20182022"

mkdir -p "$directory"

# Check if file already exists
if [ -f "$directory/$file" ]; then
    echo "$file already exists, skipping download."
    exit 0
fi

echo "$file does not exist, downloading..."

# Activate virtual environment
source "$base_path/venv/bin/activate"

# Check that Kaggle CLI is available
if ! kaggle --version >/dev/null 2>&1; then
    echo "Kaggle CLI is not available in this Python environment."
    exit 1
fi

# Download dataset
kaggle datasets download "$dataset" \
    --file "$file" \
    --path "$directory"

# Check downloaded ZIP
if [ -f "$directory/$zip_file" ]; then
    echo "Unzipping $zip_file..."

    unzip -o "$directory/$zip_file" -d "$directory"

    rm -f "$directory/$zip_file"

    echo "File unzipped successfully."
else
    echo "Failed to download the ZIP file: $directory/$zip_file"
    exit 1
fi