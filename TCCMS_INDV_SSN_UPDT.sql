create or replace PROCEDURE "TCCMS_INDV_SSN_UPDT" 
is
   v_int1 number;
   v_int2 number;
   v_int varchar2(200);
   v_text varchar2(300);

 BEGIN
  SELECT MIN(ORG_KEY) INTO v_int1 FROM TCCMSMASK.TCCMS_MASK_DTL_TABLE 
  WHERE TABLE_NAME = 'TCCMS_INDV'  AND  TYPE='INDV_C_SSN' AND  SSN_SW='N';
 SELECT  MAX(ORG_KEY) INTO v_int2  FROM TCCMSMASK.TCCMS_MASK_DTL_TABLE 
  WHERE TABLE_NAME = 'TCCMS_INDV'  AND  TYPE='INDV_C_SSN' AND  SSN_SW='N';

       WHILE v_int1 <= v_int2
         LOOP    
BEGIN
    SELECT B.MASKED, A.INDV_C_SSN INTO v_text,v_int 
    FROM 
    TCCMSMASK.TCCMS_INDV A, 
    TCCMSMASK.TCCMS_MASK_DTL_TABLE B
    WHERE  B.ORIGINAL = A.INDV_C_SSN
    AND B.TABLE_NAME = 'TCCMS_INDV'  
    AND  B.TYPE='INDV_C_SSN'
    AND B.ORG_KEY=v_int1 AND  B.SSN_SW='N';
     exception 
       when no_data_found
       then DBMS_OUTPUT.put_line ('No data found');
       end;
 
 UPDATE TCCMSMASK.TCCMS_MASK_DTL_TABLE
 SET SSN_SW='Y' 
 WHERE ORG_KEY=v_int1;
 
 UPDATE TCCMSMASK.TCCMS_INDV A 
    SET A.INDV_C_SSN = v_text 
    WHERE A.INDV_C_SSN= v_int;
 
         commit;
         v_int1:=v_int1 + 1;
   END LOOP; 
END;