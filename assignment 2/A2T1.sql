-- @A2T1.sql

SPOOL A2T1.txt
SET ECHO ON
SET FEEDBACK ON
SET LINESIZE 100
SET PAGESIZE 200
SET SERVEROUTPUT ON

CREATE OR REPLACE procedure supplierAccBal(rName IN REGION.r_name%type, minNum number, maxNum number)
IS
avgNum varchar2(100);

BEGIN

	-- User specify Region
	FOR n IN (SELECT n_name FROM nation 
				JOIN region 
				ON nation.n_regionkey = region.r_regionkey
				WHERE rName = region.r_name
				ORDER BY n_name) loop

		dbms_output.put_line(chr(10)); -- New line
		dbms_output.put_line ('Nation Name: ' || n.n_name);
		dbms_output.put_line(chr(5)); -- New line
		dbms_output.put_line(chr(9) || rpad('Supplier Name', 20) 
											 || rpad('Supplier Phone', 20) 
											 || rpad('Account Balance',20) 
											 || chr(10)
											 || rpad('Comment',20)
											);

		-- User specify range
		FOR sn IN (SELECT s_name, s_phone, s_acctbal
						FROM supplier JOIN nation ON s_nationkey = n_nationkey
						WHERE n_name = n.n_name) loop
						
			IF sn.s_acctbal BETWEEN minNum AND maxNum THEN
		
				SELECT avg(s_acctbal) INTO avgNum FROM supplier 
				JOIN nation ON s_nationkey = n_nationkey WHERE n_name = n.n_name;
				
					IF sn.s_acctbal < avgNum THEN
						dbms_output.put_line(chr(9) || rpad(sn.s_name, 20)
												 || rpad(sn.s_phone, 20)
												 || '$' 
												 || rpad(sn.s_acctbal, 20)
												 || 'The account balance is BELOW the nation average of $'
												 || round(avgNum, 2));
						
					ELSE 
						dbms_output.put_line(chr(9) || rpad(sn.s_name, 20) 
												 || rpad(sn.s_phone, 20) 
												 || '$' 
												 || rpad(sn.s_acctbal, 20));
												 
						dbms_output.put_line('The account balance is ABOVE the nation average of $'
												 || round(avgNum, 2) );	
			 		END if;
				
			END if;
		END loop;
	END loop;

EXCEPTION 
		WHEN no_data_found THEN
			dbms_output.put_line('No data found!');
		WHEN others THEN
			dbms_output.put_line('Error!');

--------------------------------------------------------------

END supplierAccBal;
/
SHOW error

-- test codes here
EXECUTE supplierAccBal('ASIA', 4500, 5000);

SPOOL OFF
