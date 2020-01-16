/*
    Descrição lógica da consulta 
    
    SE   	Nenhum codigoProcedimento (XML) EXISTE gravado na base com 
        	dataExecucao (XML) IGUAL Data Execução (BASE) E
    (  ( 	horaInicial (XML) MAIOR OU IGUAL A horaInicial (BASE) E 
  				     MENOR OU IGUAL A horaFinal (BASE)) 
        OU	
        ( 	horaFinal (XML) MAIOR OU IGUAL A horaInicial (BASE) E 
  				   MENOR OU IGUAL A horaFinal (BASE))
    ) E
        	mesmo codigoPrestadorNaOperadora ou cpfContratado (BASE) E
	viaDeAcesso (XML) IGUAL A viaDeAcesso (BASE) QUANDO as duas forem 1 – Única
 */


--native query hibernate
select * from WSDV_PROCEDIMENTO_REALIZADO procedimento
inner join WSDV_PROFISSIONAL profissional on profissional.ID_PROCEDIMENTO = procedimento.ID_PROCEDIMENTO
where procedimento.CODIGO_PROCEDIMENTO is not null
--data do procedimento trafegando no xml
and procedimento.DATA_EXECUCAO = ? 
and procedimento.TIPO_VIA_ACESSO = 'UNICA'
--hora inicial trafegando no xml
and ((?
BETWEEN TO_DATE(procedimento.HORA_INICIAL_PROCEDIMENTO,'HH24:MI:SS') and TO_DATE(procedimento.HORA_FINAL_PROCEDIMENTO, 'HH24:MI:SS'))
--hora final trafegando no xml
or (?
BETWEEN TO_DATE(procedimento.HORA_INICIAL_PROCEDIMENTO,'HH24:MI:SS') and TO_DATE(procedimento.HORA_FINAL_PROCEDIMENTO, 'HH24:MI:SS')))
and profissional.CODIGO_PRESTADOR_OPERADORA = ? 
and profissional.CPF_CONTRATADO = ?;



--preenchido para consulta
select * from WSDV_PROCEDIMENTO_REALIZADO procedimento
inner join WSDV_PROFISSIONAL profissional on profissional.ID_PROCEDIMENTO = procedimento.ID_PROCEDIMENTO
where procedimento.DATA_EXECUCAO = TO_DATE('12/07/18', 'DD/MM/YY') 
and procedimento.CODIGO_PROCEDIMENTO is not null
and procedimento.TIPO_VIA_ACESSO = 'UNICA'
--hora inicial trafegando no xml
and ((TO_DATE('11:59:59', 'HH24:MI:SS') 
BETWEEN TO_DATE(procedimento.HORA_INICIAL_PROCEDIMENTO,'HH24:MI:SS') and TO_DATE(procedimento.HORA_FINAL_PROCEDIMENTO, 'HH24:MI:SS'))
--hora final trafegando no xml
or (TO_DATE('12:00:0', 'HH24:MI:SS') 
BETWEEN TO_DATE(procedimento.HORA_INICIAL_PROCEDIMENTO,'HH24:MI:SS') and TO_DATE(procedimento.HORA_FINAL_PROCEDIMENTO, 'HH24:MI:SS')))
and profissional.CODIGO_PRESTADOR_OPERADORA = '120681' 
and profissional.CPF_CONTRATADO is null;


--guarda o plano de execução
explain plan for

--preenchido para consulta
SELECT procedimento.ID_PROCEDIMENTO
FROM WSDV_PROCEDIMENTO_REALIZADO procedimento
INNER JOIN WSDV_PROFISSIONAL profissional ON profissional.ID_PROCEDIMENTO  =   procedimento.ID_PROCEDIMENTO
AND procedimento.DATA_EXECUCAO         = TO_DATE('17/08/2018','DD/MM/YYYY')
WHERE procedimento.CODIGO_PROCEDIMENTO = 31102360
AND procedimento.TIPO_VIA_ACESSO       = 'UNICA'
AND (TO_DATE('08:00:00', 'HH24:MI:SS') BETWEEN TO_DATE(procedimento.HORA_INICIAL_PROCEDIMENTO,'HH24:MI:SS') AND TO_DATE(procedimento.HORA_FINAL_PROCEDIMENTO, 'HH24:MI:SS')
OR TO_DATE('10:00:00', 'HH24:MI:SS') BETWEEN TO_DATE(procedimento.HORA_INICIAL_PROCEDIMENTO,'HH24:MI:SS') AND TO_DATE(procedimento.HORA_FINAL_PROCEDIMENTO, 'HH24:MI:SS'))
AND profissional.CODIGO_PRESTADOR_OPERADORA = '65770' and rownum <= 1 ;

--exibir o plano de execução
  select plan_table_output
     from table(dbms_xplan.display('plan_table',null,'basic +predicate +cost'));