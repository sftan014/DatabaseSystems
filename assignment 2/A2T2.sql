-- @A2T2.sql

SPOOL A2T2.txt
SET ECHO ON
SET FEEDBACK ON
SET LINESIZE 100
SET PAGESIZE 200
SET SERVEROUTPUT ON

CREATE OR REPLACE function lowHighCost(pKey IN PARTSUPP.ps_partkey%type) return varchar2
IS
lowCost varchar2 (100);
highCost varchar2 (100);
outputting varchar2(2000) := '';

BEGIN 
	SELECT min(ps_supplycost) INTO lowCost FROM partsupp WHERE ps_partkey = pKey;
	
	FOR lcost IN (SELECT ps_suppkey, s_suppkey, s_name FROM partsupp JOIN supplier
					ON partsupp.ps_suppkey = supplier.s_suppkey 
					WHERE ps_supplycost = lowCost AND ps_partkey = pKey) loop
			
			outputting := outputting ||chr(10) 
						|| 'Supplier supplying part ' || pKey
						|| ' with cheapest cost is/are: '
						|| lcost.ps_suppkey || ', ' 
						|| lcost.s_name || ', ' 
						|| '$' || round(lowCost,2) || '.';

	END loop;
	
	
	SELECT max(ps_supplycost) INTO highCost FROM partsupp WHERE ps_partkey = pKey;
	
	FOR hcost IN (SELECT ps_suppkey, s_suppkey, s_name FROM partsupp JOIN supplier
					ON partsupp.ps_suppkey = supplier.s_suppkey 
					WHERE ps_supplycost = highCost AND ps_partkey = pKey) loop
			
			outputting := outputting || chr(10) 
						|| 'Supplier supplying part ' || pKey
						|| ' with highest cost is/are: '
						|| hcost.ps_suppkey || ', ' 
						|| hcost.s_name || ', ' 
						|| '$' || round(highCost,2) || '.';
	END loop;
--------------------------------------------------------------
	RETURN outputting;
END lowHighCost;
/
SHOW error

-- test codes here
SELECT lowHighCost('3753') from dual;
SELECT lowHighCost('43064') from dual;
SELECT lowHighCost('57574') from dual;
SELECT lowHighCost('60000') from dual;

SPOOL OFF
