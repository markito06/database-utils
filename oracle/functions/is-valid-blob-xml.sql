create or replace function is_valid_blob_xml(blob_param blob)

return int

as

  scratch xmltype;

begin

  select XMLType(blob_param,1) into scratch from dual;

  return 1;

exception

  when others then

    return 0;

end;