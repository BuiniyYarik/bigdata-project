**PATH TO ROOT DIRECTORY**: "~/project/bigdata-project/"

`main.sh` is the main script that will run all scripts of the pipeline stages which will execute the full pipeline.

This repository contains the following directories:

- `data/` contains the dataset file and output train/test data.
- `models/` contains the Spark ML models.
- `notebooks/` contains the Jupyter notebook for Stage 3.
- `output/` contains `csv` files, text files, images and other materials that returned as an ouput of the pipeline.
- `scripts/` contains all `.sh` and `.py` scripts of the pipeline (except `main.sh`).
- `sql/` contains all `.sql` and `.hql` files.

`requirements.txt` contains Python packages needed for running Python scripts in the pipeline.
