CREATE SCHEMA IF NOT EXISTS _realtime;
ALTER SCHEMA _realtime OWNER TO postgres;
GRANT USAGE ON SCHEMA _realtime TO supabase_admin;
GRANT ALL ON ALL TABLES IN SCHEMA _realtime TO supabase_admin;
GRANT ALL ON ALL SEQUENCES IN SCHEMA _realtime TO supabase_admin;
