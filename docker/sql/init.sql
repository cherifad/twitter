--
-- PostgreSQL database dump
--

-- Dumped from database version 12.14 (Debian 12.14-1.pgdg110+1)
-- Dumped by pg_dump version 15.0

-- Started on 2023-03-29 13:08:39

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
-- TOC entry 9 (class 2615 OID 16384)
-- Name: hdb_catalog; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA hdb_catalog;


ALTER SCHEMA hdb_catalog OWNER TO postgres;

--
-- TOC entry 7 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 2 (class 3079 OID 16385)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 3205 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 258 (class 1255 OID 16422)
-- Name: gen_hasura_uuid(); Type: FUNCTION; Schema: hdb_catalog; Owner: postgres
--

CREATE FUNCTION hdb_catalog.gen_hasura_uuid() RETURNS uuid
    LANGUAGE sql
    AS $$select gen_random_uuid()$$;


ALTER FUNCTION hdb_catalog.gen_hasura_uuid() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 206 (class 1259 OID 16446)
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
-- TOC entry 208 (class 1259 OID 16472)
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
-- TOC entry 207 (class 1259 OID 16457)
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
-- TOC entry 205 (class 1259 OID 16435)
-- Name: hdb_metadata; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_metadata (
    id integer NOT NULL,
    metadata json NOT NULL,
    resource_version integer DEFAULT 1 NOT NULL
);


ALTER TABLE hdb_catalog.hdb_metadata OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16502)
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
-- TOC entry 209 (class 1259 OID 16488)
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
-- TOC entry 211 (class 1259 OID 16517)
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
-- TOC entry 204 (class 1259 OID 16423)
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
-- TOC entry 220 (class 1259 OID 24868)
-- Name: conversation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conversation (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    user1_id uuid NOT NULL,
    user2_id uuid NOT NULL
);


ALTER TABLE public.conversation OWNER TO postgres;

--
-- TOC entry 3206 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE conversation; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.conversation IS 'Conversation table';


--
-- TOC entry 214 (class 1259 OID 16557)
-- Name: follower; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.follower (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    follower_id uuid NOT NULL
);


ALTER TABLE public.follower OWNER TO postgres;

--
-- TOC entry 3207 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE follower; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.follower IS 'Follower table';


--
-- TOC entry 217 (class 1259 OID 16608)
-- Name: hashtag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hashtag (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    text text NOT NULL
);


ALTER TABLE public.hashtag OWNER TO postgres;

--
-- TOC entry 3208 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE hashtag; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.hashtag IS 'Hashtag table';


--
-- TOC entry 215 (class 1259 OID 16573)
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
-- TOC entry 3209 (class 0 OID 0)
-- Dependencies: 215
-- Name: TABLE "like"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."like" IS 'Like table';


--
-- TOC entry 219 (class 1259 OID 16633)
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
-- TOC entry 3210 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE mention; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.mention IS 'Mention table';


--
-- TOC entry 221 (class 1259 OID 24884)
-- Name: message; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.message (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    conversation_id uuid NOT NULL,
    sender_id uuid NOT NULL,
    recipient_id uuid NOT NULL,
    content text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.message OWNER TO postgres;

--
-- TOC entry 3211 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE message; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.message IS 'Message table';


--
-- TOC entry 216 (class 1259 OID 16592)
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
-- TOC entry 3212 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE retweet; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.retweet IS 'Retweet table';


--
-- TOC entry 213 (class 1259 OID 16542)
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
-- TOC entry 3213 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE tweet; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.tweet IS 'Tweet table';


--
-- TOC entry 218 (class 1259 OID 16617)
-- Name: tweet_hashtag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tweet_hashtag (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    tweet_id uuid NOT NULL,
    hashtag_id uuid NOT NULL
);


ALTER TABLE public.tweet_hashtag OWNER TO postgres;

--
-- TOC entry 3214 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE tweet_hashtag; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.tweet_hashtag IS 'Tweet-Hashtag table';


--
-- TOC entry 212 (class 1259 OID 16528)
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
-- TOC entry 3215 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE "user"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."user" IS 'User table';


--
-- TOC entry 3183 (class 0 OID 16446)
-- Dependencies: 206
-- Data for Name: hdb_action_log; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_action_log (id, action_name, input_payload, request_headers, session_variables, response_payload, errors, created_at, response_received_at, status) FROM stdin;
\.


--
-- TOC entry 3185 (class 0 OID 16472)
-- Dependencies: 208
-- Data for Name: hdb_cron_event_invocation_logs; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_cron_event_invocation_logs (id, event_id, status, request, response, created_at) FROM stdin;
\.


--
-- TOC entry 3184 (class 0 OID 16457)
-- Dependencies: 207
-- Data for Name: hdb_cron_events; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_cron_events (id, trigger_name, scheduled_time, status, tries, created_at, next_retry_at) FROM stdin;
\.


--
-- TOC entry 3182 (class 0 OID 16435)
-- Dependencies: 205
-- Data for Name: hdb_metadata; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_metadata (id, metadata, resource_version) FROM stdin;
1	{"network":{"tls_allowlist":[{"host":"vuejs.com","permissions":["self-signed"],"suffix":"5136"}]},"sources":[{"configuration":{"connection_info":{"database_url":"postgres://postgres:postgrespassword@postgres:5432/postgres","isolation_level":"read-committed","use_prepared_statements":false}},"kind":"postgres","name":"main","tables":[{"table":{"name":"conversation","schema":"public"}},{"object_relationships":[{"name":"user","using":{"foreign_key_constraint_on":"follower_id"}},{"name":"userByUserId","using":{"foreign_key_constraint_on":"user_id"}}],"table":{"name":"follower","schema":"public"}},{"array_relationships":[{"name":"tweet_hashtags","using":{"foreign_key_constraint_on":{"column":"hashtag_id","table":{"name":"tweet_hashtag","schema":"public"}}}}],"table":{"name":"hashtag","schema":"public"}},{"object_relationships":[{"name":"tweet","using":{"foreign_key_constraint_on":"tweet_id"}},{"name":"user","using":{"foreign_key_constraint_on":"user_id"}}],"table":{"name":"like","schema":"public"}},{"object_relationships":[{"name":"tweet","using":{"foreign_key_constraint_on":"tweet_id"}},{"name":"user","using":{"foreign_key_constraint_on":"user_id"}}],"table":{"name":"mention","schema":"public"}},{"table":{"name":"message","schema":"public"}},{"object_relationships":[{"name":"tweet","using":{"foreign_key_constraint_on":"tweet_id"}},{"name":"user","using":{"foreign_key_constraint_on":"user_id"}}],"table":{"name":"retweet","schema":"public"}},{"array_relationships":[{"name":"tweet_likes","using":{"foreign_key_constraint_on":{"column":"tweet_id","table":{"name":"like","schema":"public"}}}},{"name":"tweet_mentions","using":{"foreign_key_constraint_on":{"column":"tweet_id","table":{"name":"mention","schema":"public"}}}},{"name":"tweet_retweets","using":{"foreign_key_constraint_on":{"column":"tweet_id","table":{"name":"retweet","schema":"public"}}}},{"name":"tweet_tweet_hashtags","using":{"foreign_key_constraint_on":{"column":"tweet_id","table":{"name":"tweet_hashtag","schema":"public"}}}}],"object_relationships":[{"name":"tweet_user","using":{"foreign_key_constraint_on":"author_id"}}],"table":{"name":"tweet","schema":"public"}},{"object_relationships":[{"name":"hashtag","using":{"foreign_key_constraint_on":"hashtag_id"}},{"name":"tweet","using":{"foreign_key_constraint_on":"tweet_id"}}],"table":{"name":"tweet_hashtag","schema":"public"}},{"array_relationships":[{"name":"followers","using":{"foreign_key_constraint_on":{"column":"follower_id","table":{"name":"follower","schema":"public"}}}},{"name":"followersByUserId","using":{"foreign_key_constraint_on":{"column":"user_id","table":{"name":"follower","schema":"public"}}}},{"name":"likes","using":{"foreign_key_constraint_on":{"column":"user_id","table":{"name":"like","schema":"public"}}}},{"name":"mentions","using":{"foreign_key_constraint_on":{"column":"user_id","table":{"name":"mention","schema":"public"}}}},{"name":"retweets","using":{"foreign_key_constraint_on":{"column":"user_id","table":{"name":"retweet","schema":"public"}}}},{"name":"tweets","using":{"foreign_key_constraint_on":{"column":"author_id","table":{"name":"tweet","schema":"public"}}}}],"select_permissions":[{"permission":{"columns":["premium","bio","email","location","name","password","profile_picture_url","username","website","created_at","id"],"filter":{"id":{"_eq":"X-Hasura-User-Id"}}},"role":"user"}],"table":{"name":"user","schema":"public"},"update_permissions":[{"permission":{"check":null,"columns":["id","username","email","password","bio","profile_picture_url","website","location","created_at","name","premium"],"filter":{"id":{"_eq":"X-Hasura-User-Id"}}},"role":"user"}]}]}],"version":3}	49
\.


--
-- TOC entry 3187 (class 0 OID 16502)
-- Dependencies: 210
-- Data for Name: hdb_scheduled_event_invocation_logs; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_scheduled_event_invocation_logs (id, event_id, status, request, response, created_at) FROM stdin;
\.


--
-- TOC entry 3186 (class 0 OID 16488)
-- Dependencies: 209
-- Data for Name: hdb_scheduled_events; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_scheduled_events (id, webhook_conf, scheduled_time, retry_conf, payload, header_conf, status, tries, created_at, next_retry_at, comment) FROM stdin;
\.


--
-- TOC entry 3188 (class 0 OID 16517)
-- Dependencies: 211
-- Data for Name: hdb_schema_notifications; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_schema_notifications (id, notification, resource_version, instance_id, updated_at) FROM stdin;
1	{"metadata":false,"remote_schemas":[],"sources":["main"],"data_connectors":[]}	49	3b55ba47-97f5-4132-a2d1-f60779572cca	2023-03-25 11:12:51.931196+00
\.


--
-- TOC entry 3181 (class 0 OID 16423)
-- Dependencies: 204
-- Data for Name: hdb_version; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_version (hasura_uuid, version, upgraded_on, cli_state, console_state) FROM stdin;
4eac0206-3a75-44d0-a80d-17db64dd9cc7	47	2023-03-25 10:51:57.485849+00	{}	{"console_notifications": {"admin": {"date": "2023-03-28T13:15:00.606Z", "read": "all", "showBadge": false}}, "telemetryNotificationShown": true}
\.


--
-- TOC entry 3197 (class 0 OID 24868)
-- Dependencies: 220
-- Data for Name: conversation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.conversation (id, user1_id, user2_id) FROM stdin;
\.


--
-- TOC entry 3191 (class 0 OID 16557)
-- Dependencies: 214
-- Data for Name: follower; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.follower (id, user_id, follower_id) FROM stdin;
\.


--
-- TOC entry 3194 (class 0 OID 16608)
-- Dependencies: 217
-- Data for Name: hashtag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hashtag (id, text) FROM stdin;
\.


--
-- TOC entry 3192 (class 0 OID 16573)
-- Dependencies: 215
-- Data for Name: like; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."like" (id, user_id, tweet_id, created_at) FROM stdin;
b0d4f4c9-9cb8-4b37-81d5-08b61a3201e7	2c13461f-7c04-4376-9f2e-15d2443a3a03	e05ec5dc-f8d4-4f0d-b05c-1a511a8e372a	2023-03-25 12:40:26.143407+00
3d3f06af-6a0c-4567-9069-9a43bb5ce108	48f7d933-aa75-422a-ae14-29eb8c880de1	e05ec5dc-f8d4-4f0d-b05c-1a511a8e372a	2023-03-25 12:40:26.143407+00
a8b41c0e-24c6-4b6c-8c4a-4c41e4e9d70f	2c13461f-7c04-4376-9f2e-15d2443a3a03	1d0342d9-b726-4c2a-9f69-c6c09b6f30c8	2023-03-25 12:40:26.143407+00
e28c0d98-9c1f-4ee4-91d7-883ccf8808b7	336bf68a-d72e-40ed-82ec-75a573e7ab78	e05ec5dc-f8d4-4f0d-b05c-1a511a8e372a	2023-03-25 12:40:26.143407+00
f628bb2d-d3a3-4a5e-b14f-52065c56ac75	2c13461f-7c04-4376-9f2e-15d2443a3a03	fe3610d5-5a5e-48e1-b59f-5a39c9b0f208	2023-03-25 12:40:26.143407+00
abb26249-6f96-463d-8ccf-4766b53f1443	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	cb614ba2-b1c2-44dc-a551-a8b3dd809379	2023-03-28 17:47:38.271065+00
881cff80-bc67-42fd-91ec-ab0bffd77e3c	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	c3a1adde-714d-49c4-ae93-401626cc1f19	2023-03-28 17:47:56.321308+00
76813cf1-e8d9-42bf-a1da-7ba9dbb91aa6	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	15cd1872-3f5e-4f4b-ae29-57d277cc3ae4	2023-03-28 17:48:00.629655+00
b55b40aa-8484-43e2-82dd-db23190facba	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	fe3610d5-5a5e-48e1-b59f-5a39c9b0f208	2023-03-28 18:16:47.139261+00
bb72bc24-238f-40c4-9b6e-a8ef7cc1876c	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	e1188ff9-a3b1-41eb-a9bb-9808463bac45	2023-03-28 19:17:03.205819+00
68b20039-a853-46fe-92b0-80aaf7765caf	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	d6a52a6f-9c9a-47b9-ae22-697d5a5a5dcf	2023-03-28 19:17:05.20424+00
\.


--
-- TOC entry 3196 (class 0 OID 16633)
-- Dependencies: 219
-- Data for Name: mention; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mention (id, user_id, tweet_id, created_at) FROM stdin;
\.


--
-- TOC entry 3198 (class 0 OID 24884)
-- Dependencies: 221
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.message (id, conversation_id, sender_id, recipient_id, content, created_at) FROM stdin;
\.


--
-- TOC entry 3193 (class 0 OID 16592)
-- Dependencies: 216
-- Data for Name: retweet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.retweet (user_id, tweet_id, created_at, id) FROM stdin;
\.


--
-- TOC entry 3190 (class 0 OID 16542)
-- Dependencies: 213
-- Data for Name: tweet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tweet (id, author_id, content, image_url, created_at) FROM stdin;
e05ec5dc-f8d4-4f0d-b05c-1a511a8e372a	1ce2b46d-c92c-4fd4-a1e3-b4d4e2074815	Hello world!	\N	2022-01-01 00:00:00+00
1d0342d9-b726-4c2a-9f69-c6c09b6f30c8	2c13461f-7c04-4376-9f2e-15d2443a3a03	I love Hasura!	\N	2022-01-02 00:00:00+00
d58e0e09-e8f3-4fb7-9cf4-c431df7b8d4e	1ce2b46d-c92c-4fd4-a1e3-b4d4e2074815	GraphQL is amazing!	\N	2022-01-03 00:00:00+00
fe3610d5-5a5e-48e1-b59f-5a39c9b0f208	336bf68a-d72e-40ed-82ec-75a573e7ab78	Just had a great meeting with the team	\N	2022-01-04 00:00:00+00
d6a52a6f-9c9a-47b9-ae22-697d5a5a5dcf	48f7d933-aa75-422a-ae14-29eb8c880de1	Excited to start my new job next week	\N	2022-01-05 00:00:00+00
e1188ff9-a3b1-41eb-a9bb-9808463bac45	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	Salut c'est un test de tweet	null	2023-03-28 15:15:40.703273+00
15cd1872-3f5e-4f4b-ae29-57d277cc3ae4	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	oui j'arrive	null	2023-03-28 15:19:24.587484+00
c3a1adde-714d-49c4-ae93-401626cc1f19	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	salut	null	2023-03-28 15:22:15.327641+00
cb614ba2-b1c2-44dc-a551-a8b3dd809379	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	comment ca va ?	null	2023-03-28 17:13:31.012208+00
\.


--
-- TOC entry 3195 (class 0 OID 16617)
-- Dependencies: 218
-- Data for Name: tweet_hashtag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tweet_hashtag (id, tweet_id, hashtag_id) FROM stdin;
\.


--
-- TOC entry 3189 (class 0 OID 16528)
-- Dependencies: 212
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, username, email, password, bio, profile_picture_url, website, location, created_at, name, premium, date_of_birth) FROM stdin;
1ce2b46d-c92c-4fd4-a1e3-b4d4e2074815	alice	alice@example.com	password1	'	\N	\N	\N	2023-03-25 12:33:35.914806+00	Alice	f	2001-02-01
48f7d933-aa75-422a-ae14-29eb8c880de1	david	david@example.com	password4	'	\N	\N	\N	2023-03-25 12:33:35.914806+00	David	f	2001-02-01
336bf68a-d72e-40ed-82ec-75a573e7ab78	charlie	charlie@example.com	password3	'	\N	\N	\N	2023-03-25 12:33:35.914806+00	Charlie	f	2001-02-01
2c13461f-7c04-4376-9f2e-15d2443a3a03	bob	bob@example.com	password2	'	\N	\N	\N	2023-03-25 12:33:35.914806+00	Bob	f	2001-02-01
6b2f8c43-8d7f-4d05-878c-923f6d74cd67	nelda	adlencherif29@gmail.com	$2a$10$MGql3FiTb539DPCWnjCdauBJqm3lvDiFrA67cUmYPyTzU9ZctTALq	'	\N	\N	\N	2023-03-28 10:54:55.805202+00	Adlen CHERIF	t	2002-07-29
\.


--
-- TOC entry 2994 (class 2606 OID 16456)
-- Name: hdb_action_log hdb_action_log_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_action_log
    ADD CONSTRAINT hdb_action_log_pkey PRIMARY KEY (id);


--
-- TOC entry 3001 (class 2606 OID 16481)
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 2997 (class 2606 OID 16469)
-- Name: hdb_cron_events hdb_cron_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_events
    ADD CONSTRAINT hdb_cron_events_pkey PRIMARY KEY (id);


--
-- TOC entry 2990 (class 2606 OID 16443)
-- Name: hdb_metadata hdb_metadata_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_pkey PRIMARY KEY (id);


--
-- TOC entry 2992 (class 2606 OID 16445)
-- Name: hdb_metadata hdb_metadata_resource_version_key; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_resource_version_key UNIQUE (resource_version);


--
-- TOC entry 3006 (class 2606 OID 16511)
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 3004 (class 2606 OID 16500)
-- Name: hdb_scheduled_events hdb_scheduled_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_events
    ADD CONSTRAINT hdb_scheduled_events_pkey PRIMARY KEY (id);


--
-- TOC entry 3008 (class 2606 OID 16527)
-- Name: hdb_schema_notifications hdb_schema_notifications_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_schema_notifications
    ADD CONSTRAINT hdb_schema_notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 2988 (class 2606 OID 16433)
-- Name: hdb_version hdb_version_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_version
    ADD CONSTRAINT hdb_version_pkey PRIMARY KEY (hasura_uuid);


--
-- TOC entry 3034 (class 2606 OID 24873)
-- Name: conversation conversation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversation
    ADD CONSTRAINT conversation_pkey PRIMARY KEY (id);


--
-- TOC entry 3018 (class 2606 OID 16562)
-- Name: follower follower_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follower
    ADD CONSTRAINT follower_pkey PRIMARY KEY (id);


--
-- TOC entry 3028 (class 2606 OID 16616)
-- Name: hashtag hashtag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hashtag
    ADD CONSTRAINT hashtag_pkey PRIMARY KEY (id);


--
-- TOC entry 3020 (class 2606 OID 24910)
-- Name: like like_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."like"
    ADD CONSTRAINT like_pkey PRIMARY KEY (id, tweet_id, user_id);


--
-- TOC entry 3022 (class 2606 OID 24912)
-- Name: like like_user_id_tweet_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."like"
    ADD CONSTRAINT like_user_id_tweet_id_key UNIQUE (user_id, tweet_id);


--
-- TOC entry 3032 (class 2606 OID 16639)
-- Name: mention mention_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mention
    ADD CONSTRAINT mention_pkey PRIMARY KEY (id);


--
-- TOC entry 3036 (class 2606 OID 24893)
-- Name: message message_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_pkey PRIMARY KEY (id);


--
-- TOC entry 3024 (class 2606 OID 16654)
-- Name: retweet retweet_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retweet
    ADD CONSTRAINT retweet_id_key UNIQUE (id);


--
-- TOC entry 3026 (class 2606 OID 16660)
-- Name: retweet retweet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retweet
    ADD CONSTRAINT retweet_pkey PRIMARY KEY (id);


--
-- TOC entry 3030 (class 2606 OID 16622)
-- Name: tweet_hashtag tweet_hashtag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tweet_hashtag
    ADD CONSTRAINT tweet_hashtag_pkey PRIMARY KEY (id);


--
-- TOC entry 3016 (class 2606 OID 16551)
-- Name: tweet tweet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tweet
    ADD CONSTRAINT tweet_pkey PRIMARY KEY (id);


--
-- TOC entry 3010 (class 2606 OID 16541)
-- Name: user user_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- TOC entry 3012 (class 2606 OID 16537)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 3014 (class 2606 OID 16539)
-- Name: user user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- TOC entry 2999 (class 1259 OID 16487)
-- Name: hdb_cron_event_invocation_event_id; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX hdb_cron_event_invocation_event_id ON hdb_catalog.hdb_cron_event_invocation_logs USING btree (event_id);


--
-- TOC entry 2995 (class 1259 OID 16470)
-- Name: hdb_cron_event_status; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX hdb_cron_event_status ON hdb_catalog.hdb_cron_events USING btree (status);


--
-- TOC entry 2998 (class 1259 OID 16471)
-- Name: hdb_cron_events_unique_scheduled; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE UNIQUE INDEX hdb_cron_events_unique_scheduled ON hdb_catalog.hdb_cron_events USING btree (trigger_name, scheduled_time) WHERE (status = 'scheduled'::text);


--
-- TOC entry 3002 (class 1259 OID 16501)
-- Name: hdb_scheduled_event_status; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX hdb_scheduled_event_status ON hdb_catalog.hdb_scheduled_events USING btree (status);


--
-- TOC entry 2986 (class 1259 OID 16434)
-- Name: hdb_version_one_row; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE UNIQUE INDEX hdb_version_one_row ON hdb_catalog.hdb_version USING btree (((version IS NOT NULL)));


--
-- TOC entry 3037 (class 2606 OID 16482)
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_cron_events(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3038 (class 2606 OID 16512)
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_scheduled_events(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3050 (class 2606 OID 24874)
-- Name: conversation conversation_user1_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversation
    ADD CONSTRAINT conversation_user1_id_fkey FOREIGN KEY (user1_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3051 (class 2606 OID 24879)
-- Name: conversation conversation_user2_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversation
    ADD CONSTRAINT conversation_user2_id_fkey FOREIGN KEY (user2_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3040 (class 2606 OID 16568)
-- Name: follower follower_follower_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follower
    ADD CONSTRAINT follower_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3041 (class 2606 OID 16563)
-- Name: follower follower_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follower
    ADD CONSTRAINT follower_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3042 (class 2606 OID 16585)
-- Name: like like_tweet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."like"
    ADD CONSTRAINT like_tweet_id_fkey FOREIGN KEY (tweet_id) REFERENCES public.tweet(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3043 (class 2606 OID 16580)
-- Name: like like_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."like"
    ADD CONSTRAINT like_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3048 (class 2606 OID 16645)
-- Name: mention mention_tweet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mention
    ADD CONSTRAINT mention_tweet_id_fkey FOREIGN KEY (tweet_id) REFERENCES public.tweet(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3049 (class 2606 OID 16640)
-- Name: mention mention_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mention
    ADD CONSTRAINT mention_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3052 (class 2606 OID 24904)
-- Name: message message_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversation(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3053 (class 2606 OID 24899)
-- Name: message message_recipient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_recipient_id_fkey FOREIGN KEY (recipient_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3054 (class 2606 OID 24894)
-- Name: message message_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3044 (class 2606 OID 16598)
-- Name: retweet retweet_tweet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retweet
    ADD CONSTRAINT retweet_tweet_id_fkey FOREIGN KEY (tweet_id) REFERENCES public.tweet(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3045 (class 2606 OID 16603)
-- Name: retweet retweet_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retweet
    ADD CONSTRAINT retweet_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3039 (class 2606 OID 16552)
-- Name: tweet tweet_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tweet
    ADD CONSTRAINT tweet_author_id_fkey FOREIGN KEY (author_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3046 (class 2606 OID 16628)
-- Name: tweet_hashtag tweet_hashtag_hashtag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tweet_hashtag
    ADD CONSTRAINT tweet_hashtag_hashtag_id_fkey FOREIGN KEY (hashtag_id) REFERENCES public.hashtag(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3047 (class 2606 OID 16623)
-- Name: tweet_hashtag tweet_hashtag_tweet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tweet_hashtag
    ADD CONSTRAINT tweet_hashtag_tweet_id_fkey FOREIGN KEY (tweet_id) REFERENCES public.tweet(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3204 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2023-03-29 13:08:39

--
-- PostgreSQL database dump complete
--

