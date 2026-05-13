USE team4_projectdb;

DROP TABLE IF EXISTS team4_projectdb.optimization;
CREATE EXTERNAL TABLE team4_projectdb.optimization(
Model VARCHAR(150), 
InitialAreaUnderROC FLOAT,
OptimizedAreaUnderROC FLOAT,
IncreaseAreaUnderPR FLOAT,
InitialAreaUnderPR FLOAT,
OptimizedAreaUnderPR FLOAT,
IncreaseAreaUnderROC FLOAT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ';'
location '/user/team4/project/hive/warehouse/optimization'; 

-- to not display table names with column names
SET hive.resultset.use.unique.column.names = false;