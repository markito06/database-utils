(select id_tipo_mensagem, ds_tipo_mensagem,  LISTAGG(anos, ',' )   within group(order by anos) as ANOS from 
)(select 
tipo.ID_TIPO_MENSAGEM , 
tipo.DS_TIPO_MENSAGEM,
TO_CHAR(upload.DT_UPLOAD, 'YYYY') as ANOS from TISS_BATCH tissbatch
inner join TISS_BATCH_UPLOAD upload on upload.ID_TISS_BATCH_UPLOAD = tissbatch.ID_TISS_BATCH_UPLOAD
inner join TIPO_MENSAGEM tipo on tissbatch.ID_TIPO_MENSAGEM = tipo.ID_TIPO_MENSAGEM
GROUP by tipo.ID_TIPO_MENSAGEM, tipo.DS_TIPO_MENSAGEM, TO_CHAR(upload.DT_UPLOAD, 'YYYY')
) tabela group by id_tipo_mensagem, ds_tipo_mensagem;