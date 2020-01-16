--task 14385
select * from (
select
  substr(envio.nm_arquivo_xml,22,32) as nomehash,
  count(*) as total
  from tiss_batch envio
  where envio.TIPO_TRANSACAO = 'ENVIO_LOTE_GUIAS' and envio.ID_TIPO_MENSAGEM in (530, 580)
  group by substr(envio.nm_arquivo_xml,22,32)
) tabela where total > 1;
