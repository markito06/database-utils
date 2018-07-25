create or replace FUNCTION blob_to_xmltype (blob_in IN BLOB)
RETURN VARCHAR2
AS
v_xml XMLTYPE;
v_path VARCHAR2(300);
v_mesage_version VARCHAR2(10);
v_clob CLOB;
v_varchar VARCHAR2(32767);
v_start PLS_INTEGER := 1;
v_buffer PLS_INTEGER := 32767;
msg_invalid EXCEPTION;
BEGIN
v_path := '/*:Envelope/*:Body/*/*:cabecalho/*:Padrao/text()';

DBMS_LOB.CREATETEMPORARY(v_clob, TRUE);

FOR i IN 1..CEIL(DBMS_LOB.GETLENGTH(blob_in) / v_buffer)
LOOP
  v_varchar := UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(blob_in, v_buffer, v_start));
  DBMS_LOB.WRITEAPPEND(v_clob, LENGTH(v_varchar), v_varchar);
  v_start := v_start + v_buffer;
END LOOP;
  v_xml := XMLTYPE(v_clob);
  v_mesage_version := v_xml.EXTRACT(v_path).getStringVal();
  v_mesage_version := TRIM (' ' FROM v_mesage_version);
  IF REGEXP_LIKE(v_mesage_version, '[^0-9.]')
  THEN RETURN v_mesage_version;
  END IF;
RETURN 'INVALID';  
EXCEPTION  WHEN OTHERS THEN RETURN '';
END blob_to_xmltype;