#!/bin/bash

# Pre-processing
echo "Running pre-processing..."
bash scripts/preprocess.sh

# Run the big data pipeline
echo "Running Stage 1 of the pipeline..."
bash scripts/stage1.sh

echo "Running Stage 2 of the pipeline..."
bash scripts/stage2.sh

echo "Running Stage 3 of the pipeline..."
bash scripts/stage3.sh

echo "Running Stage 4 of the pipeline..."
bash scripts/stage4.sh

# Post-processing 
echo "Running post-processing..."
bash scripts/postprocess.sh
