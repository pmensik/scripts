-- Gets 10 biggest tables by size 

SELECT table_name, (pg_relation_size(table_name) / (1024 * 1024)) || ' MB' AS size
FROM information_schema.tables
WHERE table_schema NOT IN ('information_schema', 'pg_catalog')
ORDER BY size DESC LIMIT 10;

--Lists all views

SELECT table_name FROM INFORMATION_SCHEMA.views WHERE table_schema = ANY (current_schemas(FALSE));

-- list all tables
SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_schema = ANY (current_schemas(FALSE)) AND table_name LIKE '%contact%';
-- Random shit

(random()*(2*10^9))::integer

(random()*(9*10^18))::bigint

repeat('1',(random()*40)::integer) -- random length string

substr('abcdefghijklmnopqrstuvwxyz',1, (random()*26)::integer) -- random substring

-- Passwords

--query weak password (not hashed)
select usename,passwd from pg_shadow where passwd not like 'md5%' or length(passwd) <> 35;

-- drop all views

SELECT 'DROP VIEW ' || t.oid::regclass || 'CASCADE;'
FROM   pg_class t
JOIN   pg_namespace n ON n.oid = t.relnamespace
WHERE  t.relkind = 'v'
AND    n.nspname = 'public';
-- delete data in all tables
do
$$
declare
  l_stmt text;
begin
  select 'truncate ' || string_agg(format('%I.%I', schemaname, tablename), ',')
    into l_stmt
  from pg_tables
  where schemaname in ('public') and tableowner = 'name';
  execute l_stmt;
end;
$$

-- drop all connections from current DB
SELECT pid, pg_terminate_backend(pid) 
FROM pg_stat_activity 
WHERE datname = current_database() AND pid <> pg_backend_pid();

-- list all connections for current DB
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = current_database();