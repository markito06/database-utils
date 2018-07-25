create or replace PROCEDURE insertUUID
 
AS
  
  CURSOR c1
	IS 
		select * from LOG_TRANSACAO_TISS;
BEGIN
	FOR transacao IN c1
	LOOP
		BEGIN
			update LOG_TRANSACAO_TISS logTiss set logTiss.UUID = RandomUUID() where logTiss.ID = transacao.ID;
		END 
   
END;