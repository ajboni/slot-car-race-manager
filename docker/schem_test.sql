
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

