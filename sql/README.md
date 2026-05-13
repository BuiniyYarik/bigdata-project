This file contains brief information about the SQL and HiveQL files used in the repository.

Stage 1:
- `create_tables.sql` creates two tables in the PostgreSQL database.
- `import_to_raw.sql` inserts raw data into the staging table.
- `process_from_raw.sql` processes raw records, applies type corrections, and inserts the cleaned data into the primary table.

Stage 2:
- `db.hql` creates a database in Hive.
- `create_table.hql` creates the primary table in Hive.
- `import_from_temp.hql` imports data from the temporary table into the primary Hive table with necessary type casting.
- `q1.hql` contains the first analytical query used for business insights.
- `q2.hql` contains the second analytical query used for business insights.
- `q3.hql` contains the third analytical query used for business insights.
- `q4.hql` contains the fourth analytical query used for business insights.
- `q5.hql` contains the fifth analytical query used for business insights.
- `q6.hql` contains the sixth analytical query used for business insights.

Stage 4:
- `st4_hyperparameters_create_table.hql` creates a table for storing model hyperparameters.
- `st4_optimization_results_create_table.hql` creates a table for storing optimization and evaluation results.
- `st4_prediction_samples_create_table.hql` creates a table for storing sample model predictions.
- `st4_rf_feature_importance_create_table.hql` creates a table for storing Random Forest feature importance values.
- `st4_fm_shap_importance_create_table.hql` creates a table for storing SHAP importance values for the Factorization Machine model.
- `st4_mlp_shap_importance_create_table.hql` creates a table for storing SHAP importance values for the MLP model.
- `st4_risk1_rf_summary_create_table.hql` creates a table for storing Random Forest prediction risk statistics, including mean and standard deviation of predicted probabilities for each class.
