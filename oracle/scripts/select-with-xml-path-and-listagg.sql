select TO_CHAR(ts_transacao, 'YYYY' ),  LISTAGG(mensagem, ',' ) within group(order by mensagem)  as mensagem from
(SELECT  log_transacao_conteudo.ts_transacao , blob_to_xmltype(log_transacao_conteudo.DS_CONTEUDO).EXTRACT('/*:Envelope/*:Body/*/*:cabecalho/*:Padrao/text()').getStringVal() AS mensagem
FROM LOG_TRANSACAO log_transacao 
INNER JOIN LOG_TRANSACAO_CONTEUDO log_transacao_conteudo ON log_transacao.ID_LOG_TRANSACAO  = log_transacao_conteudo.ID_LOG_TRANSACAO
WHERE log_transacao_conteudo.COD_ETAPA = 1
--and log_transacao_conteudo.ts_transacao > to_date('01/01/2017', 'DD/MM/YYYY')
and log_transacao_conteudo.DS_CONTEUDO is not null
group by TO_CHAR(log_transacao_conteudo.ts_transacao, 'YYYY' )
) tabela group by ts_transacao;