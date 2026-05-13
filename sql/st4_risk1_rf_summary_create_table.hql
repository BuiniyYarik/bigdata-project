USE team4_projectdb;

DROP TABLE IF EXISTS team4_projectdb.risk1_rf_summary;
CREATE EXTERNAL TABLE team4_projectdb.risk1_rf_summary(
class VARCHAR(150), 
mean_prob FLOAT, 
std_prob FLOAT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ';'
location '/user/team4/project/hive/warehouse/risk1_rf_summary'; 

-- to not display table names with column names
SET hive.resultset.use.unique.column.names = false;