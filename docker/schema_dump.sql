SET xmloption = content;
CREATE TABLE public.lap (
    id integer NOT NULL,
    "time" timestamp without time zone NOT NULL,
    race_id integer NOT NULL,
    racer_id integer NOT NULL,
    index integer NOT NULL
);
CREATE SEQUENCE public.lap_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.lap_id_seq OWNED BY public.lap.id;
CREATE TABLE public.race (
    id integer NOT NULL,
    time_start timestamp with time zone DEFAULT now() NOT NULL,
    time_end timestamp with time zone NOT NULL,
    ruleset integer DEFAULT 1 NOT NULL
);
CREATE SEQUENCE public.race_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.race_id_seq OWNED BY public.race.id;
CREATE TABLE public.race_racer (
    id integer NOT NULL,
    race_id integer NOT NULL,
    racer_id integer NOT NULL
);
CREATE SEQUENCE public.race_racer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.race_racer_id_seq OWNED BY public.race_racer.id;
CREATE TABLE public.racer (
    id integer NOT NULL,
    name text NOT NULL
);
CREATE SEQUENCE public.racer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.racer_id_seq OWNED BY public.racer.id;
CREATE TABLE public.ruleset (
    id integer NOT NULL,
    total_laps integer DEFAULT 10 NOT NULL,
    total_racers integer DEFAULT 4 NOT NULL,
    name text
);
CREATE SEQUENCE public.ruleset_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.ruleset_id_seq OWNED BY public.ruleset.id;
ALTER TABLE ONLY public.lap ALTER COLUMN id SET DEFAULT nextval('public.lap_id_seq'::regclass);
ALTER TABLE ONLY public.race ALTER COLUMN id SET DEFAULT nextval('public.race_id_seq'::regclass);
ALTER TABLE ONLY public.race_racer ALTER COLUMN id SET DEFAULT nextval('public.race_racer_id_seq'::regclass);
ALTER TABLE ONLY public.racer ALTER COLUMN id SET DEFAULT nextval('public.racer_id_seq'::regclass);
ALTER TABLE ONLY public.ruleset ALTER COLUMN id SET DEFAULT nextval('public.ruleset_id_seq'::regclass);
ALTER TABLE ONLY public.lap
    ADD CONSTRAINT lap_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.race
    ADD CONSTRAINT race_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.race_racer
    ADD CONSTRAINT race_racer_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.racer
    ADD CONSTRAINT racer_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ruleset
    ADD CONSTRAINT ruleset_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.lap
    ADD CONSTRAINT lap_race_id_fkey FOREIGN KEY (race_id) REFERENCES public.race(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.lap
    ADD CONSTRAINT lap_racer_id_fkey FOREIGN KEY (racer_id) REFERENCES public.racer(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.race_racer
    ADD CONSTRAINT race_racer_race_id_fkey FOREIGN KEY (race_id) REFERENCES public.race(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.race_racer
    ADD CONSTRAINT race_racer_racer_id_fkey FOREIGN KEY (racer_id) REFERENCES public.racer(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
