-- Drop database if it already exists
DROP DATABASE IF EXISTS team4_projectdb CASCADE;


-- Create database and access it
CREATE DATABASE team4_projectdb LOCATION '/user/team4/project/hive/warehouse';
USE team4_projectdb;


-- Create temporary table in database
CREATE EXTERNAL TABLE flights_temp STORED AS AVRO LOCATION '/user/team4/project/warehouse/flights'
TBLPROPERTIES ('avro.schema.url'='/user/team4/project/warehouse/avsc/flights.avsc');


-- Check the content of table
SELECT * FROM flights_temp LIMIT 10;

