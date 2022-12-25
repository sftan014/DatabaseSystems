-- @A2T3.sql

SPOOL A2T3.txt
SET ECHO ON
SET FEEDBACK ON
SET LINESIZE 100
SET PAGESIZE 200
SET SERVEROUTPUT ON

CREATE OR REPLACE TRIGGER displayTrigger
BEFORE INSERT OR UPDATE ON customer
FOR EACH ROW 
WHEN (new.c_comment IS null)
   
BEGIN 
   	:new.c_comment := 'New customer was created on: ' || SYSDATE || '.'; 
END; 
/ 
show error

INSERT INTO customer
(c_custkey, c_name, c_address, c_nationkey, c_phone, c_acctbal, c_mktsegment, c_comment)
VALUES (45123, 'namename', 'addadd', 8, 123456789, 123.45, 'furniture', NULL);

SELECT * FROM customer WHERE c_custkey = 45123;

DELETE FROM customer where c_custkey = 45123;
SPOOL OFF
