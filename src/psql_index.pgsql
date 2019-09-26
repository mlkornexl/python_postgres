select
    t.relname as table_name,
    i.relnamespace as index_schema,
    i.relname as index_name,
    ix.indisunique as unique_ind,
    array_to_string(array_agg(a.attname), ', ') as column_names
from
    pg_class t,
    pg_class i,
    pg_index ix,
    pg_attribute a,
    pg_namespace ni,
    pg_namespace nt
where
    t.oid = ix.indrelid
    and i.oid = ix.indexrelid
    and a.attrelid = t.oid
    and a.attnum = ANY(ix.indkey)
    and t.relkind = 'r'
    and ni.oid = i.relnamespace
    and nt.oid = t.relnamespace
    and nt.nspname = 'test'
    --and t.relname like 'test%'
group by
    t.relname,
    i.relname,
    i.relnamespace,
    ix.indisunique
order by
    t.relname,
    i.relname;

select idx.relname as index_name, 
       insp.nspname as index_schema,
       tbl.relname as table_name,
       tnsp.nspname as table_schema,
       pgi.indisunique as unique_ind
from pg_index pgi
  join pg_class idx on idx.oid = pgi.indexrelid
  join pg_namespace insp on insp.oid = idx.relnamespace
  join pg_class tbl on tbl.oid = pgi.indrelid
  join pg_namespace tnsp on tnsp.oid = tbl.relnamespace
where tnsp.nspname = 'test'; --<< only for tables from the public schema