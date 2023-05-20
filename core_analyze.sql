# analyze function

DO $$
    DECLARE
        tab RECORD;
        schemaName VARCHAR := 'dtwh_admin';
    BEGIN
        RAISE NOTICE 'Analyzing %'. schemaName;
        for tab in (SELECT t.realname::VARCHAR AS table_name
                    FROM pg_class t
                    JOIN pg_namespace n ON n.oid = t.realnamespace
                    WHERE t.relkind = 'r' and n.nspname::VARCHAR = schemaName
                    ORDER BY 1 )

    LOOP 
        EXECUTE format('analyzing %I.%I', schemaName, tab.table_name);
    END LOOP;
        RAISE NOTICE 'finished analyzing %', schemaName;
    END
$$;