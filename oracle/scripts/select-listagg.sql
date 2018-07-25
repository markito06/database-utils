select COD_UNIMED , LISTAGG (ID_TIPO_MENSAGEM, ',') WITHIN GROUP (order by ID_TIPO_MENSAGEM) as MENSAGEM from
(select usuario.COD_UNIMED, tipo.ID_TIPO_MENSAGEM
from DIRETORIO diretorio
inner join USUARIO_WSD_UNIMED unimed on unimed.ID_USUARIO_WSD = diretorio.ID_USUARIO_WSD
inner join USUARIO_WSD usuario on usuario.ID_USUARIO_WSD = unimed.ID_USUARIO_WSD
inner join TIPO_MENSAGEM tipo on tipo.ID_TIPO_MENSAGEM = diretorio.ID_TIPO_MENSAGEM
group by usuario.COD_UNIMED, tipo.ID_TIPO_MENSAGEM order by usuario.COD_UNIMED asc)
tebela group by COD_UNIMED;