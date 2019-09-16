SET xmloption = content;
COPY public.race (id, time_start, time_end, ruleset) FROM stdin;
\.
COPY public.racer (id, name) FROM stdin;
329	sasa
330	asdsaddsa
331	dsad
\.
COPY public.lap (id, "time", race_id, racer_id, index) FROM stdin;
\.
COPY public.race_racer (id, race_id, racer_id) FROM stdin;
\.
COPY public.ruleset (id, total_laps, total_racers, name) FROM stdin;
23	4	4	Partida rápida
24	10	2	Mano a Mano
\.
SELECT pg_catalog.setval('public.lap_id_seq', 1, false);
SELECT pg_catalog.setval('public.race_id_seq', 1, false);
SELECT pg_catalog.setval('public.race_racer_id_seq', 1, false);
SELECT pg_catalog.setval('public.racer_id_seq', 331, true);
SELECT pg_catalog.setval('public.ruleset_id_seq', 24, true);
