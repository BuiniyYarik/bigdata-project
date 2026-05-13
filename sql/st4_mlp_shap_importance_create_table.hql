USE team4_projectdb;

DROP TABLE IF EXISTS team4_projectdb.mlp_shap_importance;
CREATE EXTERNAL TABLE team4_projectdb.mlp_shap_importance(
feature VARCHAR(150), 
mean_abs_shap FLOAT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ';'
location '/user/team4/project/hive/warehouse/mlp_shap_importance'; 

-- to not display table names with column names
SET hive.resultset.use.unique.column.names = false;