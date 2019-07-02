--
-- PostgreSQL database dump
--

-- Dumped from database version 11.4 (Debian 11.4-1.pgdg90+1)
-- Dumped by pg_dump version 11.4 (Debian 11.4-1.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: hdb_catalog; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA hdb_catalog;


ALTER SCHEMA hdb_catalog OWNER TO postgres;

--
-- Name: hdb_views; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA hdb_views;


ALTER SCHEMA hdb_views OWNER TO postgres;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: hdb_schema_update_event_notifier(); Type: FUNCTION; Schema: hdb_catalog; Owner: postgres
--

CREATE FUNCTION hdb_catalog.hdb_schema_update_event_notifier() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
    instance_id uuid;
    occurred_at timestamptz;
    curr_rec record;
  BEGIN
    instance_id = NEW.instance_id;
    occurred_at = NEW.occurred_at;
    PERFORM pg_notify('hasura_schema_update', json_build_object(
      'instance_id', instance_id,
      'occurred_at', occurred_at
      )::text);
    RETURN curr_rec;
  END;
$$;


ALTER FUNCTION hdb_catalog.hdb_schema_update_event_notifier() OWNER TO postgres;

--
-- Name: hdb_table_oid_check(); Type: FUNCTION; Schema: hdb_catalog; Owner: postgres
--

CREATE FUNCTION hdb_catalog.hdb_table_oid_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF (EXISTS (SELECT 1 FROM information_schema.tables st WHERE st.table_schema = NEW.table_schema AND st.table_name = NEW.table_name)) THEN
      return NEW;
    ELSE
      RAISE foreign_key_violation using message = 'table_schema, table_name not in information_schema.tables';
      return NULL;
    END IF;
  END;
$$;


ALTER FUNCTION hdb_catalog.hdb_table_oid_check() OWNER TO postgres;

--
-- Name: inject_table_defaults(text, text, text, text); Type: FUNCTION; Schema: hdb_catalog; Owner: postgres
--

CREATE FUNCTION hdb_catalog.inject_table_defaults(view_schema text, view_name text, tab_schema text, tab_name text) RETURNS void
    LANGUAGE plpgsql
    AS $$
    DECLARE
        r RECORD;
    BEGIN
      FOR r IN SELECT column_name, column_default FROM information_schema.columns WHERE table_schema = tab_schema AND table_name = tab_name AND column_default IS NOT NULL LOOP
          EXECUTE format('ALTER VIEW %I.%I ALTER COLUMN %I SET DEFAULT %s;', view_schema, view_name, r.column_name, r.column_default);
      END LOOP;
    END;
$$;


ALTER FUNCTION hdb_catalog.inject_table_defaults(view_schema text, view_name text, tab_schema text, tab_name text) OWNER TO postgres;

--
-- Name: insert_event_log(text, text, text, text, json); Type: FUNCTION; Schema: hdb_catalog; Owner: postgres
--

CREATE FUNCTION hdb_catalog.insert_event_log(schema_name text, table_name text, trigger_name text, op text, row_data json) RETURNS text
    LANGUAGE plpgsql
    AS $$
  DECLARE
    id text;
    payload json;
    session_variables json;
    server_version_num int;
  BEGIN
    id := gen_random_uuid();
    server_version_num := current_setting('server_version_num');
    IF server_version_num >= 90600 THEN
      session_variables := current_setting('hasura.user', 't');
    ELSE
      BEGIN
        session_variables := current_setting('hasura.user');
      EXCEPTION WHEN OTHERS THEN
                  session_variables := NULL;
      END;
    END IF;
    payload := json_build_object(
      'op', op,
      'data', row_data,
      'session_variables', session_variables
    );
    INSERT INTO hdb_catalog.event_log
                (id, schema_name, table_name, trigger_name, payload)
    VALUES
    (id, schema_name, table_name, trigger_name, payload);
    RETURN id;
  END;
$$;


ALTER FUNCTION hdb_catalog.insert_event_log(schema_name text, table_name text, trigger_name text, op text, row_data json) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: event_invocation_logs; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.event_invocation_logs (
    id text DEFAULT public.gen_random_uuid() NOT NULL,
    event_id text,
    status integer,
    request json,
    response json,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE hdb_catalog.event_invocation_logs OWNER TO postgres;

--
-- Name: event_log; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.event_log (
    id text DEFAULT public.gen_random_uuid() NOT NULL,
    schema_name text NOT NULL,
    table_name text NOT NULL,
    trigger_name text NOT NULL,
    payload jsonb NOT NULL,
    delivered boolean DEFAULT false NOT NULL,
    error boolean DEFAULT false NOT NULL,
    tries integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    locked boolean DEFAULT false NOT NULL,
    next_retry_at timestamp without time zone
);


ALTER TABLE hdb_catalog.event_log OWNER TO postgres;

--
-- Name: event_triggers; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.event_triggers (
    name text NOT NULL,
    type text NOT NULL,
    schema_name text NOT NULL,
    table_name text NOT NULL,
    configuration json,
    comment text
);


ALTER TABLE hdb_catalog.event_triggers OWNER TO postgres;

--
-- Name: hdb_allowlist; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_allowlist (
    collection_name text
);


ALTER TABLE hdb_catalog.hdb_allowlist OWNER TO postgres;

--
-- Name: hdb_check_constraint; Type: VIEW; Schema: hdb_catalog; Owner: postgres
--

CREATE VIEW hdb_catalog.hdb_check_constraint AS
 SELECT (n.nspname)::text AS table_schema,
    (ct.relname)::text AS table_name,
    (r.conname)::text AS constraint_name,
    pg_get_constraintdef(r.oid, true) AS "check"
   FROM ((pg_constraint r
     JOIN pg_class ct ON ((r.conrelid = ct.oid)))
     JOIN pg_namespace n ON ((ct.relnamespace = n.oid)))
  WHERE (r.contype = 'c'::"char");


ALTER TABLE hdb_catalog.hdb_check_constraint OWNER TO postgres;

--
-- Name: hdb_foreign_key_constraint; Type: VIEW; Schema: hdb_catalog; Owner: postgres
--

CREATE VIEW hdb_catalog.hdb_foreign_key_constraint AS
 SELECT (q.table_schema)::text AS table_schema,
    (q.table_name)::text AS table_name,
    (q.constraint_name)::text AS constraint_name,
    (min(q.constraint_oid))::integer AS constraint_oid,
    min((q.ref_table_table_schema)::text) AS ref_table_table_schema,
    min((q.ref_table)::text) AS ref_table,
    json_object_agg(ac.attname, afc.attname) AS column_mapping,
    min((q.confupdtype)::text) AS on_update,
    min((q.confdeltype)::text) AS on_delete
   FROM ((( SELECT ctn.nspname AS table_schema,
            ct.relname AS table_name,
            r.conrelid AS table_id,
            r.conname AS constraint_name,
            r.oid AS constraint_oid,
            cftn.nspname AS ref_table_table_schema,
            cft.relname AS ref_table,
            r.confrelid AS ref_table_id,
            r.confupdtype,
            r.confdeltype,
            unnest(r.conkey) AS column_id,
            unnest(r.confkey) AS ref_column_id
           FROM ((((pg_constraint r
             JOIN pg_class ct ON ((r.conrelid = ct.oid)))
             JOIN pg_namespace ctn ON ((ct.relnamespace = ctn.oid)))
             JOIN pg_class cft ON ((r.confrelid = cft.oid)))
             JOIN pg_namespace cftn ON ((cft.relnamespace = cftn.oid)))
          WHERE (r.contype = 'f'::"char")) q
     JOIN pg_attribute ac ON (((q.column_id = ac.attnum) AND (q.table_id = ac.attrelid))))
     JOIN pg_attribute afc ON (((q.ref_column_id = afc.attnum) AND (q.ref_table_id = afc.attrelid))))
  GROUP BY q.table_schema, q.table_name, q.constraint_name;


ALTER TABLE hdb_catalog.hdb_foreign_key_constraint OWNER TO postgres;

--
-- Name: hdb_function; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_function (
    function_schema text NOT NULL,
    function_name text NOT NULL,
    is_system_defined boolean DEFAULT false
);


ALTER TABLE hdb_catalog.hdb_function OWNER TO postgres;

--
-- Name: hdb_function_agg; Type: VIEW; Schema: hdb_catalog; Owner: postgres
--

CREATE VIEW hdb_catalog.hdb_function_agg AS
 SELECT (p.proname)::text AS function_name,
    (pn.nspname)::text AS function_schema,
        CASE
            WHEN (p.provariadic = (0)::oid) THEN false
            ELSE true
        END AS has_variadic,
        CASE
            WHEN ((p.provolatile)::text = ('i'::character(1))::text) THEN 'IMMUTABLE'::text
            WHEN ((p.provolatile)::text = ('s'::character(1))::text) THEN 'STABLE'::text
            WHEN ((p.provolatile)::text = ('v'::character(1))::text) THEN 'VOLATILE'::text
            ELSE NULL::text
        END AS function_type,
    pg_get_functiondef(p.oid) AS function_definition,
    (rtn.nspname)::text AS return_type_schema,
    (rt.typname)::text AS return_type_name,
        CASE
            WHEN ((rt.typtype)::text = ('b'::character(1))::text) THEN 'BASE'::text
            WHEN ((rt.typtype)::text = ('c'::character(1))::text) THEN 'COMPOSITE'::text
            WHEN ((rt.typtype)::text = ('d'::character(1))::text) THEN 'DOMAIN'::text
            WHEN ((rt.typtype)::text = ('e'::character(1))::text) THEN 'ENUM'::text
            WHEN ((rt.typtype)::text = ('r'::character(1))::text) THEN 'RANGE'::text
            WHEN ((rt.typtype)::text = ('p'::character(1))::text) THEN 'PSUEDO'::text
            ELSE NULL::text
        END AS return_type_type,
    p.proretset AS returns_set,
    ( SELECT COALESCE(json_agg(q.type_name), '[]'::json) AS "coalesce"
           FROM ( SELECT pt.typname AS type_name,
                    pat.ordinality
                   FROM (unnest(COALESCE(p.proallargtypes, (p.proargtypes)::oid[])) WITH ORDINALITY pat(oid, ordinality)
                     LEFT JOIN pg_type pt ON ((pt.oid = pat.oid)))
                  ORDER BY pat.ordinality) q) AS input_arg_types,
    to_json(COALESCE(p.proargnames, ARRAY[]::text[])) AS input_arg_names
   FROM (((pg_proc p
     JOIN pg_namespace pn ON ((pn.oid = p.pronamespace)))
     JOIN pg_type rt ON ((rt.oid = p.prorettype)))
     JOIN pg_namespace rtn ON ((rtn.oid = rt.typnamespace)))
  WHERE (((pn.nspname)::text !~~ 'pg_%'::text) AND ((pn.nspname)::text <> ALL (ARRAY['information_schema'::text, 'hdb_catalog'::text, 'hdb_views'::text])) AND (NOT (EXISTS ( SELECT 1
           FROM pg_aggregate
          WHERE ((pg_aggregate.aggfnoid)::oid = p.oid)))));


ALTER TABLE hdb_catalog.hdb_function_agg OWNER TO postgres;

--
-- Name: hdb_function_info_agg; Type: VIEW; Schema: hdb_catalog; Owner: postgres
--

CREATE VIEW hdb_catalog.hdb_function_info_agg AS
 SELECT hdb_function_agg.function_name,
    hdb_function_agg.function_schema,
    row_to_json(( SELECT e.*::record AS e
           FROM ( SELECT hdb_function_agg.has_variadic,
                    hdb_function_agg.function_type,
                    hdb_function_agg.return_type_schema,
                    hdb_function_agg.return_type_name,
                    hdb_function_agg.return_type_type,
                    hdb_function_agg.returns_set,
                    hdb_function_agg.input_arg_types,
                    hdb_function_agg.input_arg_names,
                    (EXISTS ( SELECT 1
                           FROM information_schema.tables
                          WHERE (((tables.table_schema)::text = hdb_function_agg.return_type_schema) AND ((tables.table_name)::text = hdb_function_agg.return_type_name)))) AS returns_table) e)) AS function_info
   FROM hdb_catalog.hdb_function_agg;


ALTER TABLE hdb_catalog.hdb_function_info_agg OWNER TO postgres;

--
-- Name: hdb_permission; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_permission (
    table_schema text NOT NULL,
    table_name text NOT NULL,
    role_name text NOT NULL,
    perm_type text NOT NULL,
    perm_def jsonb NOT NULL,
    comment text,
    is_system_defined boolean DEFAULT false,
    CONSTRAINT hdb_permission_perm_type_check CHECK ((perm_type = ANY (ARRAY['insert'::text, 'select'::text, 'update'::text, 'delete'::text])))
);


ALTER TABLE hdb_catalog.hdb_permission OWNER TO postgres;

--
-- Name: hdb_permission_agg; Type: VIEW; Schema: hdb_catalog; Owner: postgres
--

CREATE VIEW hdb_catalog.hdb_permission_agg AS
 SELECT hdb_permission.table_schema,
    hdb_permission.table_name,
    hdb_permission.role_name,
    json_object_agg(hdb_permission.perm_type, hdb_permission.perm_def) AS permissions
   FROM hdb_catalog.hdb_permission
  GROUP BY hdb_permission.table_schema, hdb_permission.table_name, hdb_permission.role_name;


ALTER TABLE hdb_catalog.hdb_permission_agg OWNER TO postgres;

--
-- Name: hdb_primary_key; Type: VIEW; Schema: hdb_catalog; Owner: postgres
--

CREATE VIEW hdb_catalog.hdb_primary_key AS
 SELECT tc.table_schema,
    tc.table_name,
    tc.constraint_name,
    json_agg(constraint_column_usage.column_name) AS columns
   FROM (information_schema.table_constraints tc
     JOIN ( SELECT x.tblschema AS table_schema,
            x.tblname AS table_name,
            x.colname AS column_name,
            x.cstrname AS constraint_name
           FROM ( SELECT DISTINCT nr.nspname,
                    r.relname,
                    a.attname,
                    c.conname
                   FROM pg_namespace nr,
                    pg_class r,
                    pg_attribute a,
                    pg_depend d,
                    pg_namespace nc,
                    pg_constraint c
                  WHERE ((nr.oid = r.relnamespace) AND (r.oid = a.attrelid) AND (d.refclassid = ('pg_class'::regclass)::oid) AND (d.refobjid = r.oid) AND (d.refobjsubid = a.attnum) AND (d.classid = ('pg_constraint'::regclass)::oid) AND (d.objid = c.oid) AND (c.connamespace = nc.oid) AND (c.contype = 'c'::"char") AND (r.relkind = ANY (ARRAY['r'::"char", 'p'::"char"])) AND (NOT a.attisdropped))
                UNION ALL
                 SELECT nr.nspname,
                    r.relname,
                    a.attname,
                    c.conname
                   FROM pg_namespace nr,
                    pg_class r,
                    pg_attribute a,
                    pg_namespace nc,
                    pg_constraint c
                  WHERE ((nr.oid = r.relnamespace) AND (r.oid = a.attrelid) AND (nc.oid = c.connamespace) AND (r.oid =
                        CASE c.contype
                            WHEN 'f'::"char" THEN c.confrelid
                            ELSE c.conrelid
                        END) AND (a.attnum = ANY (
                        CASE c.contype
                            WHEN 'f'::"char" THEN c.confkey
                            ELSE c.conkey
                        END)) AND (NOT a.attisdropped) AND (c.contype = ANY (ARRAY['p'::"char", 'u'::"char", 'f'::"char"])) AND (r.relkind = ANY (ARRAY['r'::"char", 'p'::"char"])))) x(tblschema, tblname, colname, cstrname)) constraint_column_usage ON ((((tc.constraint_name)::text = (constraint_column_usage.constraint_name)::text) AND ((tc.table_schema)::text = (constraint_column_usage.table_schema)::text) AND ((tc.table_name)::text = (constraint_column_usage.table_name)::text))))
  WHERE ((tc.constraint_type)::text = 'PRIMARY KEY'::text)
  GROUP BY tc.table_schema, tc.table_name, tc.constraint_name;


ALTER TABLE hdb_catalog.hdb_primary_key OWNER TO postgres;

--
-- Name: hdb_query_collection; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_query_collection (
    collection_name text NOT NULL,
    collection_defn jsonb NOT NULL,
    comment text,
    is_system_defined boolean DEFAULT false
);


ALTER TABLE hdb_catalog.hdb_query_collection OWNER TO postgres;

--
-- Name: hdb_query_template; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_query_template (
    template_name text NOT NULL,
    template_defn jsonb NOT NULL,
    comment text,
    is_system_defined boolean DEFAULT false
);


ALTER TABLE hdb_catalog.hdb_query_template OWNER TO postgres;

--
-- Name: hdb_relationship; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_relationship (
    table_schema text NOT NULL,
    table_name text NOT NULL,
    rel_name text NOT NULL,
    rel_type text,
    rel_def jsonb NOT NULL,
    comment text,
    is_system_defined boolean DEFAULT false,
    CONSTRAINT hdb_relationship_rel_type_check CHECK ((rel_type = ANY (ARRAY['object'::text, 'array'::text])))
);


ALTER TABLE hdb_catalog.hdb_relationship OWNER TO postgres;

--
-- Name: hdb_schema_update_event; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_schema_update_event (
    id bigint NOT NULL,
    instance_id uuid NOT NULL,
    occurred_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE hdb_catalog.hdb_schema_update_event OWNER TO postgres;

--
-- Name: hdb_schema_update_event_id_seq; Type: SEQUENCE; Schema: hdb_catalog; Owner: postgres
--

CREATE SEQUENCE hdb_catalog.hdb_schema_update_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hdb_catalog.hdb_schema_update_event_id_seq OWNER TO postgres;

--
-- Name: hdb_schema_update_event_id_seq; Type: SEQUENCE OWNED BY; Schema: hdb_catalog; Owner: postgres
--

ALTER SEQUENCE hdb_catalog.hdb_schema_update_event_id_seq OWNED BY hdb_catalog.hdb_schema_update_event.id;


--
-- Name: hdb_table; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_table (
    table_schema text NOT NULL,
    table_name text NOT NULL,
    is_system_defined boolean DEFAULT false
);


ALTER TABLE hdb_catalog.hdb_table OWNER TO postgres;

--
-- Name: hdb_table_info_agg; Type: VIEW; Schema: hdb_catalog; Owner: postgres
--

CREATE VIEW hdb_catalog.hdb_table_info_agg AS
 SELECT tables.table_name,
    tables.table_schema,
    COALESCE(columns.columns, '[]'::json) AS columns,
    COALESCE(pk.columns, '[]'::json) AS primary_key_columns,
    COALESCE(constraints.constraints, '[]'::json) AS constraints,
    COALESCE(views.view_info, 'null'::json) AS view_info
   FROM ((((information_schema.tables tables
     LEFT JOIN ( SELECT c.table_name,
            c.table_schema,
            json_agg(json_build_object('name', c.column_name, 'type', c.udt_name, 'is_nullable', (c.is_nullable)::boolean)) AS columns
           FROM information_schema.columns c
          GROUP BY c.table_schema, c.table_name) columns ON ((((tables.table_schema)::text = (columns.table_schema)::text) AND ((tables.table_name)::text = (columns.table_name)::text))))
     LEFT JOIN ( SELECT hdb_primary_key.table_schema,
            hdb_primary_key.table_name,
            hdb_primary_key.constraint_name,
            hdb_primary_key.columns
           FROM hdb_catalog.hdb_primary_key) pk ON ((((tables.table_schema)::text = (pk.table_schema)::text) AND ((tables.table_name)::text = (pk.table_name)::text))))
     LEFT JOIN ( SELECT c.table_schema,
            c.table_name,
            json_agg(c.constraint_name) AS constraints
           FROM information_schema.table_constraints c
          WHERE (((c.constraint_type)::text = 'UNIQUE'::text) OR ((c.constraint_type)::text = 'PRIMARY KEY'::text))
          GROUP BY c.table_schema, c.table_name) constraints ON ((((tables.table_schema)::text = (constraints.table_schema)::text) AND ((tables.table_name)::text = (constraints.table_name)::text))))
     LEFT JOIN ( SELECT v.table_schema,
            v.table_name,
            json_build_object('is_updatable', ((v.is_updatable)::boolean OR (v.is_trigger_updatable)::boolean), 'is_deletable', ((v.is_updatable)::boolean OR (v.is_trigger_deletable)::boolean), 'is_insertable', ((v.is_insertable_into)::boolean OR (v.is_trigger_insertable_into)::boolean)) AS view_info
           FROM information_schema.views v) views ON ((((tables.table_schema)::text = (views.table_schema)::text) AND ((tables.table_name)::text = (views.table_name)::text))));


ALTER TABLE hdb_catalog.hdb_table_info_agg OWNER TO postgres;

--
-- Name: hdb_unique_constraint; Type: VIEW; Schema: hdb_catalog; Owner: postgres
--

CREATE VIEW hdb_catalog.hdb_unique_constraint AS
 SELECT tc.table_name,
    tc.constraint_schema AS table_schema,
    tc.constraint_name,
    json_agg(kcu.column_name) AS columns
   FROM (information_schema.table_constraints tc
     JOIN information_schema.key_column_usage kcu USING (constraint_schema, constraint_name))
  WHERE ((tc.constraint_type)::text = 'UNIQUE'::text)
  GROUP BY tc.table_name, tc.constraint_schema, tc.constraint_name;


ALTER TABLE hdb_catalog.hdb_unique_constraint OWNER TO postgres;

--
-- Name: hdb_version; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_version (
    hasura_uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    version text NOT NULL,
    upgraded_on timestamp with time zone NOT NULL,
    cli_state jsonb DEFAULT '{}'::jsonb NOT NULL,
    console_state jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE hdb_catalog.hdb_version OWNER TO postgres;

--
-- Name: remote_schemas; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.remote_schemas (
    id bigint NOT NULL,
    name text,
    definition json,
    comment text
);


ALTER TABLE hdb_catalog.remote_schemas OWNER TO postgres;

--
-- Name: remote_schemas_id_seq; Type: SEQUENCE; Schema: hdb_catalog; Owner: postgres
--

CREATE SEQUENCE hdb_catalog.remote_schemas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hdb_catalog.remote_schemas_id_seq OWNER TO postgres;

--
-- Name: remote_schemas_id_seq; Type: SEQUENCE OWNED BY; Schema: hdb_catalog; Owner: postgres
--

ALTER SEQUENCE hdb_catalog.remote_schemas_id_seq OWNED BY hdb_catalog.remote_schemas.id;


--
-- Name: lap; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lap (
    id integer NOT NULL,
    "time" time without time zone NOT NULL,
    race_id integer NOT NULL,
    racer_id integer NOT NULL,
    index integer NOT NULL
);


ALTER TABLE public.lap OWNER TO postgres;

--
-- Name: lap_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lap_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lap_id_seq OWNER TO postgres;

--
-- Name: lap_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lap_id_seq OWNED BY public.lap.id;


--
-- Name: race; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.race (
    id integer NOT NULL,
    time_start timestamp with time zone DEFAULT now() NOT NULL,
    time_finish timestamp with time zone,
    ruleset integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.race OWNER TO postgres;

--
-- Name: COLUMN race.ruleset; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.race.ruleset IS 'The ruleset for this race. Defaults to 1.';


--
-- Name: race_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.race_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.race_id_seq OWNER TO postgres;

--
-- Name: race_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.race_id_seq OWNED BY public.race.id;


--
-- Name: race_racer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.race_racer (
    id integer NOT NULL,
    race_id integer NOT NULL,
    racer_id integer NOT NULL
);


ALTER TABLE public.race_racer OWNER TO postgres;

--
-- Name: race_racer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.race_racer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.race_racer_id_seq OWNER TO postgres;

--
-- Name: race_racer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.race_racer_id_seq OWNED BY public.race_racer.id;


--
-- Name: ruleset; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ruleset (
    id integer NOT NULL,
    total_laps integer DEFAULT 10 NOT NULL,
    total_racers integer DEFAULT 4 NOT NULL
);


ALTER TABLE public.ruleset OWNER TO postgres;

--
-- Name: race_rule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.race_rule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.race_rule_id_seq OWNER TO postgres;

--
-- Name: race_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.race_rule_id_seq OWNED BY public.ruleset.id;


--
-- Name: race_ruleset_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.race_ruleset_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.race_ruleset_seq OWNER TO postgres;

--
-- Name: race_ruleset_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.race_ruleset_seq OWNED BY public.race.ruleset;


--
-- Name: racer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.racer (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.racer OWNER TO postgres;

--
-- Name: racer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.racer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.racer_id_seq OWNER TO postgres;

--
-- Name: racer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.racer_id_seq OWNED BY public.racer.id;


--
-- Name: hdb_schema_update_event id; Type: DEFAULT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_schema_update_event ALTER COLUMN id SET DEFAULT nextval('hdb_catalog.hdb_schema_update_event_id_seq'::regclass);


--
-- Name: remote_schemas id; Type: DEFAULT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.remote_schemas ALTER COLUMN id SET DEFAULT nextval('hdb_catalog.remote_schemas_id_seq'::regclass);


--
-- Name: lap id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lap ALTER COLUMN id SET DEFAULT nextval('public.lap_id_seq'::regclass);


--
-- Name: race id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.race ALTER COLUMN id SET DEFAULT nextval('public.race_id_seq'::regclass);


--
-- Name: race_racer id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.race_racer ALTER COLUMN id SET DEFAULT nextval('public.race_racer_id_seq'::regclass);


--
-- Name: racer id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.racer ALTER COLUMN id SET DEFAULT nextval('public.racer_id_seq'::regclass);


--
-- Name: ruleset id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ruleset ALTER COLUMN id SET DEFAULT nextval('public.race_rule_id_seq'::regclass);


--
-- Data for Name: event_invocation_logs; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.event_invocation_logs (id, event_id, status, request, response, created_at) FROM stdin;
\.


--
-- Data for Name: event_log; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.event_log (id, schema_name, table_name, trigger_name, payload, delivered, error, tries, created_at, locked, next_retry_at) FROM stdin;
\.


--
-- Data for Name: event_triggers; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.event_triggers (name, type, schema_name, table_name, configuration, comment) FROM stdin;
\.


--
-- Data for Name: hdb_allowlist; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_allowlist (collection_name) FROM stdin;
\.


--
-- Data for Name: hdb_function; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_function (function_schema, function_name, is_system_defined) FROM stdin;
\.


--
-- Data for Name: hdb_permission; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_permission (table_schema, table_name, role_name, perm_type, perm_def, comment, is_system_defined) FROM stdin;
\.


--
-- Data for Name: hdb_query_collection; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_query_collection (collection_name, collection_defn, comment, is_system_defined) FROM stdin;
\.


--
-- Data for Name: hdb_query_template; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_query_template (template_name, template_defn, comment, is_system_defined) FROM stdin;
\.


--
-- Data for Name: hdb_relationship; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_relationship (table_schema, table_name, rel_name, rel_type, rel_def, comment, is_system_defined) FROM stdin;
hdb_catalog	hdb_table	detail	object	{"manual_configuration": {"remote_table": {"name": "tables", "schema": "information_schema"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}	\N	t
hdb_catalog	hdb_table	primary_key	object	{"manual_configuration": {"remote_table": {"name": "hdb_primary_key", "schema": "hdb_catalog"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}	\N	t
hdb_catalog	hdb_table	columns	array	{"manual_configuration": {"remote_table": {"name": "columns", "schema": "information_schema"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}	\N	t
hdb_catalog	hdb_table	foreign_key_constraints	array	{"manual_configuration": {"remote_table": {"name": "hdb_foreign_key_constraint", "schema": "hdb_catalog"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}	\N	t
hdb_catalog	hdb_table	relationships	array	{"manual_configuration": {"remote_table": {"name": "hdb_relationship", "schema": "hdb_catalog"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}	\N	t
hdb_catalog	hdb_table	permissions	array	{"manual_configuration": {"remote_table": {"name": "hdb_permission_agg", "schema": "hdb_catalog"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}	\N	t
hdb_catalog	hdb_table	check_constraints	array	{"manual_configuration": {"remote_table": {"name": "hdb_check_constraint", "schema": "hdb_catalog"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}	\N	t
hdb_catalog	hdb_table	unique_constraints	array	{"manual_configuration": {"remote_table": {"name": "hdb_unique_constraint", "schema": "hdb_catalog"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}	\N	t
hdb_catalog	event_log	trigger	object	{"manual_configuration": {"remote_table": {"name": "event_triggers", "schema": "hdb_catalog"}, "column_mapping": {"trigger_name": "name"}}}	\N	t
hdb_catalog	event_triggers	events	array	{"manual_configuration": {"remote_table": {"name": "event_log", "schema": "hdb_catalog"}, "column_mapping": {"name": "trigger_name"}}}	\N	t
hdb_catalog	event_invocation_logs	event	object	{"foreign_key_constraint_on": "event_id"}	\N	t
hdb_catalog	event_log	logs	array	{"foreign_key_constraint_on": {"table": {"name": "event_invocation_logs", "schema": "hdb_catalog"}, "column": "event_id"}}	\N	t
hdb_catalog	hdb_function_agg	return_table_info	object	{"manual_configuration": {"remote_table": {"name": "hdb_table", "schema": "hdb_catalog"}, "column_mapping": {"return_type_name": "table_name", "return_type_schema": "table_schema"}}}	\N	t
public	race_racer	race	object	{"foreign_key_constraint_on": "race_id"}	\N	f
public	race	racers	array	{"foreign_key_constraint_on": {"table": "race_racer", "column": "race_id"}}	\N	f
public	lap	race	object	{"foreign_key_constraint_on": "race_id"}	\N	f
public	race	laps	array	{"foreign_key_constraint_on": {"table": "lap", "column": "race_id"}}	\N	f
public	lap	racer	object	{"foreign_key_constraint_on": "racer_id"}	\N	f
public	race_racer	racer	object	{"foreign_key_constraint_on": "racer_id"}	\N	f
public	racer	laps	array	{"foreign_key_constraint_on": {"table": "lap", "column": "racer_id"}}	\N	f
public	racer	races	array	{"foreign_key_constraint_on": {"table": "race_racer", "column": "racer_id"}}	\N	f
\.


--
-- Data for Name: hdb_schema_update_event; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_schema_update_event (id, instance_id, occurred_at) FROM stdin;
1	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:09:20.98678+00
2	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:09:21.00687+00
3	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:09:24.447942+00
4	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:09:25.546961+00
5	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:09:28.371405+00
6	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:10:17.217712+00
7	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:10:17.329428+00
8	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:10:17.454868+00
9	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:10:17.464437+00
10	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:10:17.485+00
11	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:10:19.706282+00
12	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:10:35.351222+00
13	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:10:35.475765+00
14	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:10:35.587403+00
15	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:10:35.602245+00
16	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:10:35.621153+00
17	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:10:36.79126+00
18	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:11:10.612554+00
19	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:11:10.785573+00
20	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:11:10.912334+00
21	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:11:10.924579+00
22	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:11:10.944571+00
23	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:11:11.655091+00
24	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:12:06.295789+00
25	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:12:06.415986+00
26	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:12:06.555752+00
27	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:12:06.569489+00
28	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:12:06.592994+00
29	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:12:12.34556+00
30	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:12:12.419247+00
31	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:12:14.037512+00
32	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:12:14.11738+00
33	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:12:16.776685+00
34	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:12:16.787614+00
35	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:12:16.810082+00
36	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:12:34.33841+00
37	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:12:34.402555+00
38	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:12:40.235917+00
39	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:12:40.318349+00
40	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:12:50.707639+00
41	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:12:50.7229+00
42	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:12:50.74454+00
43	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:13:08.212536+00
44	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:13:08.266125+00
45	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:13:12.930285+00
46	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:13:12.980519+00
47	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:13:37.600053+00
48	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:13:37.659279+00
49	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:15:23.629439+00
50	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:15:23.700251+00
51	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:15:54.600754+00
52	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:15:54.64835+00
53	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:16:29.083567+00
54	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:16:29.129703+00
55	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:16:39.226403+00
56	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:16:39.370339+00
57	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:16:41.404933+00
58	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:16:41.47509+00
59	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:16:52.251626+00
60	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:16:52.340975+00
61	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:17:01.913934+00
62	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:17:01.985522+00
63	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:17:36.239494+00
64	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:17:36.260996+00
65	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:18:07.26157+00
66	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:21:36.286221+00
67	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:21:36.309367+00
68	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:21:36.365649+00
69	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:21:40.836513+00
70	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:21:40.847235+00
71	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:21:40.874876+00
72	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:22:18.355806+00
73	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:22:18.406148+00
74	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:22:24.769639+00
75	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:22:24.825302+00
76	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:22:28.741305+00
77	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:22:28.787267+00
78	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:22:49.236461+00
79	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:22:49.299562+00
80	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:23:14.390115+00
81	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:23:14.402997+00
82	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:23:14.42632+00
83	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:23:21.937253+00
84	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:23:21.95137+00
85	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:23:21.974903+00
86	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:26:12.201007+00
87	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:26:12.216122+00
88	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:26:12.242224+00
89	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:26:15.826859+00
90	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:26:15.837689+00
91	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:26:15.860861+00
92	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:26:17.716735+00
93	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:26:17.724906+00
94	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:26:17.750174+00
95	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:26:42.114919+00
96	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:26:42.20239+00
97	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:26:50.575877+00
98	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:26:50.697813+00
99	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:26:52.529106+00
100	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:26:52.598738+00
101	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:26:55.588724+00
102	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:26:55.600444+00
103	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:26:55.625214+00
104	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:27:07.036419+00
105	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:27:07.047301+00
106	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:27:07.073196+00
107	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:27:25.570521+00
108	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:27:25.580379+00
109	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:27:25.604381+00
110	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:27:29.18929+00
111	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:27:29.200366+00
112	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:27:29.225563+00
113	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:27:33.969835+00
114	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:27:34.024808+00
115	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:27:37.104979+00
116	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:27:37.11587+00
117	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:27:37.136825+00
118	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:27:46.459024+00
119	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:27:46.470307+00
120	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:27:46.492515+00
121	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:27:59.035866+00
122	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:27:59.125268+00
123	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:28:02.10781+00
124	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:28:02.12538+00
125	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:28:02.153955+00
126	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:28:11.699023+00
127	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:28:11.714005+00
128	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:28:11.739872+00
129	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:28:28.771415+00
130	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:28:28.785824+00
131	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:28:28.811716+00
132	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:28:33.047737+00
133	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:28:33.131646+00
134	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:28:38.114465+00
135	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:28:38.13062+00
136	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:28:38.154861+00
137	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:28:39.923345+00
138	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:28:40.010527+00
139	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:28:40.07541+00
140	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:28:41.288067+00
141	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:28:43.134269+00
142	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:28:43.157638+00
143	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:28:43.246856+00
144	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:29:38.824542+00
145	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:29:38.984053+00
146	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:29:39.126055+00
147	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:29:39.13826+00
148	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:29:39.166418+00
149	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:29:42.387732+00
150	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:29:42.398622+00
151	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:29:42.423638+00
152	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:29:52.154032+00
153	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:29:52.204941+00
154	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:29:55.196263+00
155	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:29:55.206767+00
156	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:29:55.229386+00
157	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:30:02.590195+00
158	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:30:05.62417+00
159	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:30:17.514513+00
160	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:30:17.582152+00
161	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:30:21.323071+00
162	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:30:21.407871+00
163	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:30:31.836857+00
164	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:30:31.952561+00
165	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:30:36.560506+00
166	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:30:36.649412+00
167	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:30:44.891037+00
168	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:30:44.980496+00
169	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:32:54.659077+00
170	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:32:56.558503+00
171	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:35:06.624391+00
172	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:35:06.764863+00
173	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:35:06.902693+00
174	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:35:06.912052+00
175	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:35:06.937607+00
176	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:35:26.098701+00
177	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:35:26.109064+00
178	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:35:26.142239+00
179	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:35:32.449301+00
180	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:35:32.494344+00
181	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:35:40.990923+00
182	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:35:41.039314+00
183	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:36:05.272564+00
184	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:36:05.285787+00
185	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:36:05.314317+00
186	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:36:12.895666+00
187	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:36:12.950003+00
188	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:36:13.821972+00
189	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:36:13.846819+00
190	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:36:13.934105+00
191	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:36:13.947344+00
192	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:36:13.973342+00
193	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:37:01.313522+00
194	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:37:01.327509+00
195	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:37:01.349736+00
196	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:37:13.839946+00
197	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:37:13.883859+00
198	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:37:24.959874+00
199	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:37:25.00603+00
200	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:37:46.521335+00
201	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:37:46.569193+00
202	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:41:14.318467+00
203	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:41:14.363134+00
204	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:45:43.091387+00
205	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:45:43.140874+00
206	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:45:49.311079+00
207	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:45:49.355025+00
208	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:45:52.811676+00
209	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:45:52.824276+00
210	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:45:52.864573+00
211	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:46:10.545019+00
212	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:46:10.558453+00
213	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:46:10.589668+00
214	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:46:20.619654+00
215	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:46:20.633123+00
216	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:46:20.658857+00
217	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:46:38.223207+00
218	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:46:38.266758+00
219	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:51:12.72101+00
220	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 02:51:12.751814+00
221	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 03:14:48.498252+00
222	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 03:15:04.476862+00
223	1796b7d0-b804-4312-96db-fee624a1ca37	2019-06-28 03:18:46.387876+00
\.


--
-- Data for Name: hdb_table; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_table (table_schema, table_name, is_system_defined) FROM stdin;
hdb_catalog	hdb_table	t
information_schema	tables	t
information_schema	schemata	t
information_schema	views	t
hdb_catalog	hdb_primary_key	t
information_schema	columns	t
hdb_catalog	hdb_foreign_key_constraint	t
hdb_catalog	hdb_relationship	t
hdb_catalog	hdb_permission_agg	t
hdb_catalog	hdb_check_constraint	t
hdb_catalog	hdb_unique_constraint	t
hdb_catalog	hdb_query_template	t
hdb_catalog	event_triggers	t
hdb_catalog	event_log	t
hdb_catalog	event_invocation_logs	t
hdb_catalog	hdb_function_agg	t
hdb_catalog	hdb_function	t
hdb_catalog	remote_schemas	t
hdb_catalog	hdb_version	t
hdb_catalog	hdb_query_collection	t
hdb_catalog	hdb_allowlist	t
public	race	f
public	lap	f
public	race_racer	f
public	racer	f
public	ruleset	f
\.


--
-- Data for Name: hdb_version; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_version (hasura_uuid, version, upgraded_on, cli_state, console_state) FROM stdin;
f5135bed-9d5d-4ea3-9b83-3de6358cd88b	17	2019-06-28 02:09:18.099442+00	{}	{"telemetryNotificationShown": true}
\.


--
-- Data for Name: remote_schemas; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.remote_schemas (id, name, definition, comment) FROM stdin;
\.


--
-- Data for Name: lap; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lap (id, "time", race_id, racer_id, index) FROM stdin;
\.


--
-- Data for Name: race; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.race (id, time_start, time_finish, ruleset) FROM stdin;
5	2019-06-28 02:47:36.503199+00	\N	1
13	2019-06-28 02:52:50.503146+00	\N	1
\.


--
-- Data for Name: race_racer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.race_racer (id, race_id, racer_id) FROM stdin;
1	5	1
2	5	2
3	13	1
4	13	2
5	13	3
6	13	4
\.


--
-- Data for Name: racer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.racer (id, name) FROM stdin;
1	Juancho
2	Marimbo
3	Lucho
4	Miguelo
\.


--
-- Data for Name: ruleset; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ruleset (id, total_laps, total_racers) FROM stdin;
1	10	4
\.


--
-- Name: hdb_schema_update_event_id_seq; Type: SEQUENCE SET; Schema: hdb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('hdb_catalog.hdb_schema_update_event_id_seq', 223, true);


--
-- Name: remote_schemas_id_seq; Type: SEQUENCE SET; Schema: hdb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('hdb_catalog.remote_schemas_id_seq', 1, false);


--
-- Name: lap_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lap_id_seq', 1, false);


--
-- Name: race_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.race_id_seq', 13, true);


--
-- Name: race_racer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.race_racer_id_seq', 6, true);


--
-- Name: race_rule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.race_rule_id_seq', 1, true);


--
-- Name: race_ruleset_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.race_ruleset_seq', 1, false);


--
-- Name: racer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.racer_id_seq', 4, true);


--
-- Name: event_invocation_logs event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.event_invocation_logs
    ADD CONSTRAINT event_invocation_logs_pkey PRIMARY KEY (id);


--
-- Name: event_log event_log_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.event_log
    ADD CONSTRAINT event_log_pkey PRIMARY KEY (id);


--
-- Name: event_triggers event_triggers_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.event_triggers
    ADD CONSTRAINT event_triggers_pkey PRIMARY KEY (name);


--
-- Name: hdb_allowlist hdb_allowlist_collection_name_key; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_allowlist
    ADD CONSTRAINT hdb_allowlist_collection_name_key UNIQUE (collection_name);


--
-- Name: hdb_function hdb_function_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_function
    ADD CONSTRAINT hdb_function_pkey PRIMARY KEY (function_schema, function_name);


--
-- Name: hdb_permission hdb_permission_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_permission
    ADD CONSTRAINT hdb_permission_pkey PRIMARY KEY (table_schema, table_name, role_name, perm_type);


--
-- Name: hdb_query_collection hdb_query_collection_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_query_collection
    ADD CONSTRAINT hdb_query_collection_pkey PRIMARY KEY (collection_name);


--
-- Name: hdb_query_template hdb_query_template_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_query_template
    ADD CONSTRAINT hdb_query_template_pkey PRIMARY KEY (template_name);


--
-- Name: hdb_relationship hdb_relationship_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_relationship
    ADD CONSTRAINT hdb_relationship_pkey PRIMARY KEY (table_schema, table_name, rel_name);


--
-- Name: hdb_schema_update_event hdb_schema_update_event_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_schema_update_event
    ADD CONSTRAINT hdb_schema_update_event_pkey PRIMARY KEY (id);


--
-- Name: hdb_table hdb_table_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_table
    ADD CONSTRAINT hdb_table_pkey PRIMARY KEY (table_schema, table_name);


--
-- Name: hdb_version hdb_version_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_version
    ADD CONSTRAINT hdb_version_pkey PRIMARY KEY (hasura_uuid);


--
-- Name: remote_schemas remote_schemas_name_key; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.remote_schemas
    ADD CONSTRAINT remote_schemas_name_key UNIQUE (name);


--
-- Name: remote_schemas remote_schemas_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.remote_schemas
    ADD CONSTRAINT remote_schemas_pkey PRIMARY KEY (id);


--
-- Name: lap lap_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lap
    ADD CONSTRAINT lap_pkey PRIMARY KEY (id);


--
-- Name: race race_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.race
    ADD CONSTRAINT race_pkey PRIMARY KEY (id);


--
-- Name: race_racer race_racer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.race_racer
    ADD CONSTRAINT race_racer_pkey PRIMARY KEY (id);


--
-- Name: ruleset race_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ruleset
    ADD CONSTRAINT race_rule_pkey PRIMARY KEY (id);


--
-- Name: racer racer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.racer
    ADD CONSTRAINT racer_pkey PRIMARY KEY (id);


--
-- Name: event_invocation_logs_event_id_idx; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX event_invocation_logs_event_id_idx ON hdb_catalog.event_invocation_logs USING btree (event_id);


--
-- Name: event_log_trigger_name_idx; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX event_log_trigger_name_idx ON hdb_catalog.event_log USING btree (trigger_name);


--
-- Name: hdb_version_one_row; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE UNIQUE INDEX hdb_version_one_row ON hdb_catalog.hdb_version USING btree (((version IS NOT NULL)));


--
-- Name: hdb_schema_update_event hdb_schema_update_event_notifier; Type: TRIGGER; Schema: hdb_catalog; Owner: postgres
--

CREATE TRIGGER hdb_schema_update_event_notifier AFTER INSERT ON hdb_catalog.hdb_schema_update_event FOR EACH ROW EXECUTE PROCEDURE hdb_catalog.hdb_schema_update_event_notifier();


--
-- Name: hdb_table hdb_table_oid_check; Type: TRIGGER; Schema: hdb_catalog; Owner: postgres
--

CREATE TRIGGER hdb_table_oid_check BEFORE INSERT OR UPDATE ON hdb_catalog.hdb_table FOR EACH ROW EXECUTE PROCEDURE hdb_catalog.hdb_table_oid_check();


--
-- Name: event_invocation_logs event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.event_invocation_logs
    ADD CONSTRAINT event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.event_log(id);


--
-- Name: event_triggers event_triggers_schema_name_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.event_triggers
    ADD CONSTRAINT event_triggers_schema_name_fkey FOREIGN KEY (schema_name, table_name) REFERENCES hdb_catalog.hdb_table(table_schema, table_name) ON UPDATE CASCADE;


--
-- Name: hdb_allowlist hdb_allowlist_collection_name_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_allowlist
    ADD CONSTRAINT hdb_allowlist_collection_name_fkey FOREIGN KEY (collection_name) REFERENCES hdb_catalog.hdb_query_collection(collection_name);


--
-- Name: hdb_permission hdb_permission_table_schema_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_permission
    ADD CONSTRAINT hdb_permission_table_schema_fkey FOREIGN KEY (table_schema, table_name) REFERENCES hdb_catalog.hdb_table(table_schema, table_name) ON UPDATE CASCADE;


--
-- Name: hdb_relationship hdb_relationship_table_schema_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_relationship
    ADD CONSTRAINT hdb_relationship_table_schema_fkey FOREIGN KEY (table_schema, table_name) REFERENCES hdb_catalog.hdb_table(table_schema, table_name) ON UPDATE CASCADE;


--
-- Name: lap lap_race_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lap
    ADD CONSTRAINT lap_race_id_fkey FOREIGN KEY (race_id) REFERENCES public.race(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: lap lap_racer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lap
    ADD CONSTRAINT lap_racer_id_fkey FOREIGN KEY (racer_id) REFERENCES public.racer(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: race_racer race_racer_race_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.race_racer
    ADD CONSTRAINT race_racer_race_id_fkey FOREIGN KEY (race_id) REFERENCES public.race(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: race_racer race_racer_racer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.race_racer
    ADD CONSTRAINT race_racer_racer_id_fkey FOREIGN KEY (racer_id) REFERENCES public.racer(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: race race_ruleset_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.race
    ADD CONSTRAINT race_ruleset_fkey FOREIGN KEY (ruleset) REFERENCES public.ruleset(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

