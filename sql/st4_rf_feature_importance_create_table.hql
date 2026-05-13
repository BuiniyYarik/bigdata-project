USE team4_projectdb;

DROP TABLE IF EXISTS team4_projectdb.rf_feature_importance_original;
CREATE EXTERNAL TABLE team4_projectdb.rf_feature_importance_original(
feature VARCHAR(150), 
importance FLOAT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ';'
location '/user/team4/project/hive/warehouse/rf_feature_importance_original'; 

-- to not display table names with column names
SET hive.resultset.use.unique.column.names = false;