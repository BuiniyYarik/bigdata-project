USE team4_projectdb;

DROP TABLE IF EXISTS team4_projectdb.hyperparameters;
CREATE EXTERNAL TABLE team4_projectdb.hyperparameters(
Model VARCHAR(150), 
Parameter1 VARCHAR(20), 
Parameter2 VARCHAR(20), 
Parameter3 VARCHAR(20))
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ';'
location '/user/team4/project/hive/warehouse/hyperparameters'; 

-- to not display table names with column names
SET hive.resultset.use.unique.column.names = false;