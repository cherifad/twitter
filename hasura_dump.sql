--
-- PostgreSQL database dump
--

-- Dumped from database version 12.14 (Debian 12.14-1.pgdg110+1)
-- Dumped by pg_dump version 12.14 (Debian 12.14-1.pgdg110+1)

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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: gen_hasura_uuid(); Type: FUNCTION; Schema: hdb_catalog; Owner: postgres
--

CREATE FUNCTION hdb_catalog.gen_hasura_uuid() RETURNS uuid
    LANGUAGE sql
    AS $$select gen_random_uuid()$$;


ALTER FUNCTION hdb_catalog.gen_hasura_uuid() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: hdb_action_log; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_action_log (
    id uuid DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    action_name text,
    input_payload jsonb NOT NULL,
    request_headers jsonb NOT NULL,
    session_variables jsonb NOT NULL,
    response_payload jsonb,
    errors jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    response_received_at timestamp with time zone,
    status text NOT NULL,
    CONSTRAINT hdb_action_log_status_check CHECK ((status = ANY (ARRAY['created'::text, 'processing'::text, 'completed'::text, 'error'::text])))
);


ALTER TABLE hdb_catalog.hdb_action_log OWNER TO postgres;

--
-- Name: hdb_cron_event_invocation_logs; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_cron_event_invocation_logs (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    event_id text,
    status integer,
    request json,
    response json,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE hdb_catalog.hdb_cron_event_invocation_logs OWNER TO postgres;

--
-- Name: hdb_cron_events; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_cron_events (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    trigger_name text NOT NULL,
    scheduled_time timestamp with time zone NOT NULL,
    status text DEFAULT 'scheduled'::text NOT NULL,
    tries integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    next_retry_at timestamp with time zone,
    CONSTRAINT valid_status CHECK ((status = ANY (ARRAY['scheduled'::text, 'locked'::text, 'delivered'::text, 'error'::text, 'dead'::text])))
);


ALTER TABLE hdb_catalog.hdb_cron_events OWNER TO postgres;

--
-- Name: hdb_metadata; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_metadata (
    id integer NOT NULL,
    metadata json NOT NULL,
    resource_version integer DEFAULT 1 NOT NULL
);


ALTER TABLE hdb_catalog.hdb_metadata OWNER TO postgres;

--
-- Name: hdb_scheduled_event_invocation_logs; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_scheduled_event_invocation_logs (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    event_id text,
    status integer,
    request json,
    response json,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE hdb_catalog.hdb_scheduled_event_invocation_logs OWNER TO postgres;

--
-- Name: hdb_scheduled_events; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_scheduled_events (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    webhook_conf json NOT NULL,
    scheduled_time timestamp with time zone NOT NULL,
    retry_conf json,
    payload json,
    header_conf json,
    status text DEFAULT 'scheduled'::text NOT NULL,
    tries integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    next_retry_at timestamp with time zone,
    comment text,
    CONSTRAINT valid_status CHECK ((status = ANY (ARRAY['scheduled'::text, 'locked'::text, 'delivered'::text, 'error'::text, 'dead'::text])))
);


ALTER TABLE hdb_catalog.hdb_scheduled_events OWNER TO postgres;

--
-- Name: hdb_schema_notifications; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_schema_notifications (
    id integer NOT NULL,
    notification json NOT NULL,
    resource_version integer DEFAULT 1 NOT NULL,
    instance_id uuid NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT hdb_schema_notifications_id_check CHECK ((id = 1))
);


ALTER TABLE hdb_catalog.hdb_schema_notifications OWNER TO postgres;

--
-- Name: hdb_version; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_version (
    hasura_uuid uuid DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    version text NOT NULL,
    upgraded_on timestamp with time zone NOT NULL,
    cli_state jsonb DEFAULT '{}'::jsonb NOT NULL,
    console_state jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE hdb_catalog.hdb_version OWNER TO postgres;

--
-- Name: follower; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.follower (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    follower_id uuid NOT NULL
);


ALTER TABLE public.follower OWNER TO postgres;

--
-- Name: TABLE follower; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.follower IS 'Follower table';


--
-- Name: hashtag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hashtag (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    text text NOT NULL
);


ALTER TABLE public.hashtag OWNER TO postgres;

--
-- Name: TABLE hashtag; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.hashtag IS 'Hashtag table';


--
-- Name: like; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."like" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    tweet_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."like" OWNER TO postgres;

--
-- Name: TABLE "like"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."like" IS 'Like table';


--
-- Name: mention; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mention (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    tweet_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.mention OWNER TO postgres;

--
-- Name: TABLE mention; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.mention IS 'Mention table';


--
-- Name: retweet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.retweet (
    user_id uuid NOT NULL,
    tweet_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT public.gen_random_uuid() NOT NULL
);


ALTER TABLE public.retweet OWNER TO postgres;

--
-- Name: TABLE retweet; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.retweet IS 'Retweet table';


--
-- Name: tweet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tweet (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    author_id uuid NOT NULL,
    content text NOT NULL,
    image_url text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.tweet OWNER TO postgres;

--
-- Name: TABLE tweet; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.tweet IS 'Tweet table';


--
-- Name: tweet_hashtag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tweet_hashtag (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    tweet_id uuid NOT NULL,
    hashtag_id uuid NOT NULL
);


ALTER TABLE public.tweet_hashtag OWNER TO postgres;

--
-- Name: TABLE tweet_hashtag; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.tweet_hashtag IS 'Tweet-Hashtag table';


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    username text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    bio text DEFAULT ''''::text NOT NULL,
    profile_picture_url text,
    website text,
    location text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    name text NOT NULL,
    premium boolean DEFAULT false,
    date_of_birth date NOT NULL
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: TABLE "user"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."user" IS 'User table';


--
-- Data for Name: hdb_action_log; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_action_log (id, action_name, input_payload, request_headers, session_variables, response_payload, errors, created_at, response_received_at, status) FROM stdin;
\.


--
-- Data for Name: hdb_cron_event_invocation_logs; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_cron_event_invocation_logs (id, event_id, status, request, response, created_at) FROM stdin;
\.


--
-- Data for Name: hdb_cron_events; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_cron_events (id, trigger_name, scheduled_time, status, tries, created_at, next_retry_at) FROM stdin;
\.


--
-- Data for Name: hdb_metadata; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_metadata (id, metadata, resource_version) FROM stdin;
1	{"sources":[{"configuration":{"connection_info":{"database_url":"postgres://postgres:postgrespassword@postgres:5432/postgres","isolation_level":"read-committed","use_prepared_statements":false}},"kind":"postgres","name":"main","tables":[{"object_relationships":[{"name":"user","using":{"foreign_key_constraint_on":"follower_id"}},{"name":"userByUserId","using":{"foreign_key_constraint_on":"user_id"}}],"table":{"name":"follower","schema":"public"}},{"array_relationships":[{"name":"tweet_hashtags","using":{"foreign_key_constraint_on":{"column":"hashtag_id","table":{"name":"tweet_hashtag","schema":"public"}}}}],"table":{"name":"hashtag","schema":"public"}},{"object_relationships":[{"name":"tweet","using":{"foreign_key_constraint_on":"tweet_id"}},{"name":"user","using":{"foreign_key_constraint_on":"user_id"}}],"table":{"name":"like","schema":"public"}},{"object_relationships":[{"name":"tweet","using":{"foreign_key_constraint_on":"tweet_id"}},{"name":"user","using":{"foreign_key_constraint_on":"user_id"}}],"table":{"name":"mention","schema":"public"}},{"object_relationships":[{"name":"tweet","using":{"foreign_key_constraint_on":"tweet_id"}},{"name":"user","using":{"foreign_key_constraint_on":"user_id"}}],"table":{"name":"retweet","schema":"public"}},{"array_relationships":[{"name":"tweet_likes","using":{"foreign_key_constraint_on":{"column":"tweet_id","table":{"name":"like","schema":"public"}}}},{"name":"tweet_mentions","using":{"foreign_key_constraint_on":{"column":"tweet_id","table":{"name":"mention","schema":"public"}}}},{"name":"tweet_retweets","using":{"foreign_key_constraint_on":{"column":"tweet_id","table":{"name":"retweet","schema":"public"}}}},{"name":"tweet_tweet_hashtags","using":{"foreign_key_constraint_on":{"column":"tweet_id","table":{"name":"tweet_hashtag","schema":"public"}}}}],"object_relationships":[{"name":"tweet_user","using":{"foreign_key_constraint_on":"author_id"}}],"table":{"name":"tweet","schema":"public"}},{"object_relationships":[{"name":"hashtag","using":{"foreign_key_constraint_on":"hashtag_id"}},{"name":"tweet","using":{"foreign_key_constraint_on":"tweet_id"}}],"table":{"name":"tweet_hashtag","schema":"public"}},{"array_relationships":[{"name":"followers","using":{"foreign_key_constraint_on":{"column":"follower_id","table":{"name":"follower","schema":"public"}}}},{"name":"followersByUserId","using":{"foreign_key_constraint_on":{"column":"user_id","table":{"name":"follower","schema":"public"}}}},{"name":"likes","using":{"foreign_key_constraint_on":{"column":"user_id","table":{"name":"like","schema":"public"}}}},{"name":"mentions","using":{"foreign_key_constraint_on":{"column":"user_id","table":{"name":"mention","schema":"public"}}}},{"name":"retweets","using":{"foreign_key_constraint_on":{"column":"user_id","table":{"name":"retweet","schema":"public"}}}},{"name":"tweets","using":{"foreign_key_constraint_on":{"column":"author_id","table":{"name":"tweet","schema":"public"}}}}],"select_permissions":[{"permission":{"columns":["premium","bio","email","location","name","password","profile_picture_url","username","website","created_at","id"],"filter":{"id":{"_eq":"X-Hasura-User-Id"}}},"role":"user"}],"table":{"name":"user","schema":"public"},"update_permissions":[{"permission":{"check":null,"columns":["id","username","email","password","bio","profile_picture_url","website","location","created_at","name","premium"],"filter":{"id":{"_eq":"X-Hasura-User-Id"}}},"role":"user"}]}]}],"version":3}	42
\.


--
-- Data for Name: hdb_scheduled_event_invocation_logs; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_scheduled_event_invocation_logs (id, event_id, status, request, response, created_at) FROM stdin;
\.


--
-- Data for Name: hdb_scheduled_events; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_scheduled_events (id, webhook_conf, scheduled_time, retry_conf, payload, header_conf, status, tries, created_at, next_retry_at, comment) FROM stdin;
\.


--
-- Data for Name: hdb_schema_notifications; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_schema_notifications (id, notification, resource_version, instance_id, updated_at) FROM stdin;
1	{"metadata":false,"remote_schemas":[],"sources":[],"data_connectors":[]}	42	4878ec12-10f9-4d30-93ff-28ce2d9bfc7e	2023-03-25 11:12:51.931196+00
\.


--
-- Data for Name: hdb_version; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_version (hasura_uuid, version, upgraded_on, cli_state, console_state) FROM stdin;
4eac0206-3a75-44d0-a80d-17db64dd9cc7	47	2023-03-25 10:51:57.485849+00	{}	{"console_notifications": {"admin": {"date": "2023-03-25T12:36:08.514Z", "read": [], "showBadge": true}}, "telemetryNotificationShown": true}
\.


--
-- Data for Name: follower; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.follower (id, user_id, follower_id) FROM stdin;
\.


--
-- Data for Name: hashtag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hashtag (id, text) FROM stdin;
\.


--
-- Data for Name: like; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."like" (id, user_id, tweet_id, created_at) FROM stdin;
b0d4f4c9-9cb8-4b37-81d5-08b61a3201e7	2c13461f-7c04-4376-9f2e-15d2443a3a03	e05ec5dc-f8d4-4f0d-b05c-1a511a8e372a	2023-03-25 12:40:26.143407+00
3d3f06af-6a0c-4567-9069-9a43bb5ce108	48f7d933-aa75-422a-ae14-29eb8c880de1	e05ec5dc-f8d4-4f0d-b05c-1a511a8e372a	2023-03-25 12:40:26.143407+00
a8b41c0e-24c6-4b6c-8c4a-4c41e4e9d70f	2c13461f-7c04-4376-9f2e-15d2443a3a03	1d0342d9-b726-4c2a-9f69-c6c09b6f30c8	2023-03-25 12:40:26.143407+00
e28c0d98-9c1f-4ee4-91d7-883ccf8808b7	336bf68a-d72e-40ed-82ec-75a573e7ab78	e05ec5dc-f8d4-4f0d-b05c-1a511a8e372a	2023-03-25 12:40:26.143407+00
f628bb2d-d3a3-4a5e-b14f-52065c56ac75	2c13461f-7c04-4376-9f2e-15d2443a3a03	fe3610d5-5a5e-48e1-b59f-5a39c9b0f208	2023-03-25 12:40:26.143407+00
\.


--
-- Data for Name: mention; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mention (id, user_id, tweet_id, created_at) FROM stdin;
\.


--
-- Data for Name: retweet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.retweet (user_id, tweet_id, created_at, id) FROM stdin;
\.


--
-- Data for Name: tweet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tweet (id, author_id, content, image_url, created_at) FROM stdin;
e05ec5dc-f8d4-4f0d-b05c-1a511a8e372a	1ce2b46d-c92c-4fd4-a1e3-b4d4e2074815	Hello world!	\N	2022-01-01 00:00:00+00
1d0342d9-b726-4c2a-9f69-c6c09b6f30c8	2c13461f-7c04-4376-9f2e-15d2443a3a03	I love Hasura!	\N	2022-01-02 00:00:00+00
d58e0e09-e8f3-4fb7-9cf4-c431df7b8d4e	1ce2b46d-c92c-4fd4-a1e3-b4d4e2074815	GraphQL is amazing!	\N	2022-01-03 00:00:00+00
fe3610d5-5a5e-48e1-b59f-5a39c9b0f208	336bf68a-d72e-40ed-82ec-75a573e7ab78	Just had a great meeting with the team	\N	2022-01-04 00:00:00+00
d6a52a6f-9c9a-47b9-ae22-697d5a5a5dcf	48f7d933-aa75-422a-ae14-29eb8c880de1	Excited to start my new job next week	\N	2022-01-05 00:00:00+00
\.


--
-- Data for Name: tweet_hashtag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tweet_hashtag (id, tweet_id, hashtag_id) FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, username, email, password, bio, profile_picture_url, website, location, created_at, name, premium, date_of_birth) FROM stdin;
1ce2b46d-c92c-4fd4-a1e3-b4d4e2074815	alice	alice@example.com	password1	'	\N	\N	\N	2023-03-25 12:33:35.914806+00	Alice	f	2001-02-01
48f7d933-aa75-422a-ae14-29eb8c880de1	david	david@example.com	password4	'	\N	\N	\N	2023-03-25 12:33:35.914806+00	David	f	2001-02-01
336bf68a-d72e-40ed-82ec-75a573e7ab78	charlie	charlie@example.com	password3	'	\N	\N	\N	2023-03-25 12:33:35.914806+00	Charlie	f	2001-02-01
2c13461f-7c04-4376-9f2e-15d2443a3a03	bob	bob@example.com	password2	'	\N	\N	\N	2023-03-25 12:33:35.914806+00	Bob	f	2001-02-01
\.


--
-- Name: hdb_action_log hdb_action_log_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_action_log
    ADD CONSTRAINT hdb_action_log_pkey PRIMARY KEY (id);


--
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_pkey PRIMARY KEY (id);


--
-- Name: hdb_cron_events hdb_cron_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_events
    ADD CONSTRAINT hdb_cron_events_pkey PRIMARY KEY (id);


--
-- Name: hdb_metadata hdb_metadata_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_pkey PRIMARY KEY (id);


--
-- Name: hdb_metadata hdb_metadata_resource_version_key; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_resource_version_key UNIQUE (resource_version);


--
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_pkey PRIMARY KEY (id);


--
-- Name: hdb_scheduled_events hdb_scheduled_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_events
    ADD CONSTRAINT hdb_scheduled_events_pkey PRIMARY KEY (id);


--
-- Name: hdb_schema_notifications hdb_schema_notifications_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_schema_notifications
    ADD CONSTRAINT hdb_schema_notifications_pkey PRIMARY KEY (id);


--
-- Name: hdb_version hdb_version_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_version
    ADD CONSTRAINT hdb_version_pkey PRIMARY KEY (hasura_uuid);


--
-- Name: follower follower_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follower
    ADD CONSTRAINT follower_pkey PRIMARY KEY (id);


--
-- Name: hashtag hashtag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hashtag
    ADD CONSTRAINT hashtag_pkey PRIMARY KEY (id);


--
-- Name: like like_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."like"
    ADD CONSTRAINT like_pkey PRIMARY KEY (id);


--
-- Name: mention mention_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mention
    ADD CONSTRAINT mention_pkey PRIMARY KEY (id);


--
-- Name: retweet retweet_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retweet
    ADD CONSTRAINT retweet_id_key UNIQUE (id);


--
-- Name: retweet retweet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retweet
    ADD CONSTRAINT retweet_pkey PRIMARY KEY (id);


--
-- Name: tweet_hashtag tweet_hashtag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tweet_hashtag
    ADD CONSTRAINT tweet_hashtag_pkey PRIMARY KEY (id);


--
-- Name: tweet tweet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tweet
    ADD CONSTRAINT tweet_pkey PRIMARY KEY (id);


--
-- Name: user user_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- Name: hdb_cron_event_invocation_event_id; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX hdb_cron_event_invocation_event_id ON hdb_catalog.hdb_cron_event_invocation_logs USING btree (event_id);


--
-- Name: hdb_cron_event_status; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX hdb_cron_event_status ON hdb_catalog.hdb_cron_events USING btree (status);


--
-- Name: hdb_cron_events_unique_scheduled; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE UNIQUE INDEX hdb_cron_events_unique_scheduled ON hdb_catalog.hdb_cron_events USING btree (trigger_name, scheduled_time) WHERE (status = 'scheduled'::text);


--
-- Name: hdb_scheduled_event_status; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX hdb_scheduled_event_status ON hdb_catalog.hdb_scheduled_events USING btree (status);


--
-- Name: hdb_version_one_row; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE UNIQUE INDEX hdb_version_one_row ON hdb_catalog.hdb_version USING btree (((version IS NOT NULL)));


--
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_cron_events(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_scheduled_events(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: follower follower_follower_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follower
    ADD CONSTRAINT follower_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: follower follower_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follower
    ADD CONSTRAINT follower_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: like like_tweet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."like"
    ADD CONSTRAINT like_tweet_id_fkey FOREIGN KEY (tweet_id) REFERENCES public.tweet(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: like like_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."like"
    ADD CONSTRAINT like_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: mention mention_tweet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mention
    ADD CONSTRAINT mention_tweet_id_fkey FOREIGN KEY (tweet_id) REFERENCES public.tweet(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: mention mention_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mention
    ADD CONSTRAINT mention_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: retweet retweet_tweet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retweet
    ADD CONSTRAINT retweet_tweet_id_fkey FOREIGN KEY (tweet_id) REFERENCES public.tweet(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: retweet retweet_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retweet
    ADD CONSTRAINT retweet_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tweet tweet_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tweet
    ADD CONSTRAINT tweet_author_id_fkey FOREIGN KEY (author_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tweet_hashtag tweet_hashtag_hashtag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tweet_hashtag
    ADD CONSTRAINT tweet_hashtag_hashtag_id_fkey FOREIGN KEY (hashtag_id) REFERENCES public.hashtag(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tweet_hashtag tweet_hashtag_tweet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tweet_hashtag
    ADD CONSTRAINT tweet_hashtag_tweet_id_fkey FOREIGN KEY (tweet_id) REFERENCES public.tweet(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

