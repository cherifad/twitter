--
-- PostgreSQL database dump
--

-- Dumped from database version 12.14 (Debian 12.14-1.pgdg110+1)
-- Dumped by pg_dump version 15.0

-- Started on 2023-04-06 06:21:21

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
-- TOC entry 3293 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 264 (class 1255 OID 16422)
-- Name: gen_hasura_uuid(); Type: FUNCTION; Schema: hdb_catalog; Owner: postgres
--

CREATE FUNCTION hdb_catalog.gen_hasura_uuid() RETURNS uuid
    LANGUAGE sql
    AS $$select gen_random_uuid()$$;


ALTER FUNCTION hdb_catalog.gen_hasura_uuid() OWNER TO postgres;

--
-- TOC entry 278 (class 1255 OID 33210)
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
    trace_context json;
  BEGIN
    id := gen_random_uuid();
    server_version_num := current_setting('server_version_num');
    IF server_version_num >= 90600 THEN
      session_variables := current_setting('hasura.user', 't');
      trace_context := current_setting('hasura.tracecontext', 't');
    ELSE
      BEGIN
        session_variables := current_setting('hasura.user');
      EXCEPTION WHEN OTHERS THEN
                  session_variables := NULL;
      END;
      BEGIN
        trace_context := current_setting('hasura.tracecontext');
      EXCEPTION WHEN OTHERS THEN
        trace_context := NULL;
      END;
    END IF;
    payload := json_build_object(
      'op', op,
      'data', row_data,
      'session_variables', session_variables,
      'trace_context', trace_context
    );
    INSERT INTO hdb_catalog.event_log
                (id, schema_name, table_name, trigger_name, payload)
    VALUES
    (id, schema_name, table_name, trigger_name, payload);
    RETURN id;
  END;
$$;


ALTER FUNCTION hdb_catalog.insert_event_log(schema_name text, table_name text, trigger_name text, op text, row_data json) OWNER TO postgres;

--
-- TOC entry 279 (class 1255 OID 33229)
-- Name: notify_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    IF TG_TABLE_NAME = 'follower' THEN
      INSERT INTO notification (message, type, sender_id, receiver_id)
      VALUES ('A new follower has been added', 'Follower', NEW.follower_id, NEW.user_id);
    ELSIF TG_TABLE_NAME = 'mention' THEN
      INSERT INTO notification (message, type, sender_id, receiver_id)
      VALUES ('You have been mentioned in a post', 'Mention', NEW.tweet_id, NEW.user_id);
    ELSIF TG_TABLE_NAME = 'message' THEN
      INSERT INTO notification (message, type, sender_id, receiver_id)
      VALUES (new.content, 'Message', NEW.sender_id, NEW.recipient_id);
    END IF;
  END IF;
  RETURN NULL;
END;
$$;


ALTER FUNCTION public.notify_trigger() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

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
-- TOC entry 3294 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE hashtag; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.hashtag IS 'Hashtag table';


--
-- TOC entry 265 (class 1255 OID 24956)
-- Name: number_of_tweets(public.hashtag); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.number_of_tweets(hashtag_row public.hashtag) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN (SELECT COUNT(*) FROM tweet_hashtag WHERE hashtag_id = hashtag_row.id);
END;
$$;


ALTER FUNCTION public.number_of_tweets(hashtag_row public.hashtag) OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 33199)
-- Name: event_invocation_logs; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.event_invocation_logs (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    trigger_name text,
    event_id text,
    status integer,
    request json,
    response json,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE hdb_catalog.event_invocation_logs OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 33183)
-- Name: event_log; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.event_log (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    schema_name text NOT NULL,
    table_name text NOT NULL,
    trigger_name text NOT NULL,
    payload jsonb NOT NULL,
    delivered boolean DEFAULT false NOT NULL,
    error boolean DEFAULT false NOT NULL,
    tries integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    locked timestamp with time zone,
    next_retry_at timestamp without time zone,
    archived boolean DEFAULT false NOT NULL
);


ALTER TABLE hdb_catalog.event_log OWNER TO postgres;

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
-- TOC entry 227 (class 1259 OID 33211)
-- Name: hdb_event_log_cleanups; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_event_log_cleanups (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    trigger_name text NOT NULL,
    scheduled_at timestamp without time zone NOT NULL,
    deleted_event_logs integer,
    deleted_event_invocation_logs integer,
    status text NOT NULL,
    CONSTRAINT hdb_event_log_cleanups_status_check CHECK ((status = ANY (ARRAY['scheduled'::text, 'paused'::text, 'completed'::text, 'dead'::text])))
);


ALTER TABLE hdb_catalog.hdb_event_log_cleanups OWNER TO postgres;

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
-- TOC entry 224 (class 1259 OID 33176)
-- Name: hdb_source_catalog_version; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_source_catalog_version (
    version text NOT NULL,
    upgraded_on timestamp with time zone NOT NULL
);


ALTER TABLE hdb_catalog.hdb_source_catalog_version OWNER TO postgres;

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
    user2_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.conversation OWNER TO postgres;

--
-- TOC entry 3295 (class 0 OID 0)
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
    follower_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.follower OWNER TO postgres;

--
-- TOC entry 3296 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE follower; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.follower IS 'Follower table';


--
-- TOC entry 222 (class 1259 OID 24917)
-- Name: image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    tweet_id uuid NOT NULL,
    data bytea NOT NULL,
    description text,
    title text,
    user_id uuid
);


ALTER TABLE public.image OWNER TO postgres;

--
-- TOC entry 3297 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE image; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.image IS 'Image table';


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
-- TOC entry 3298 (class 0 OID 0)
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
-- TOC entry 3299 (class 0 OID 0)
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
    sender_id uuid NOT NULL,
    recipient_id uuid NOT NULL,
    content text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    conversation_id uuid
);


ALTER TABLE public.message OWNER TO postgres;

--
-- TOC entry 3300 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE message; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.message IS 'Message table';


--
-- TOC entry 223 (class 1259 OID 33156)
-- Name: notification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    message text NOT NULL,
    type text NOT NULL,
    sender_id uuid NOT NULL,
    receiver_id uuid NOT NULL,
    read boolean DEFAULT false
);


ALTER TABLE public.notification OWNER TO postgres;

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
-- TOC entry 3301 (class 0 OID 0)
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
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    image_url jsonb,
    parent_tweet_id uuid
);


ALTER TABLE public.tweet OWNER TO postgres;

--
-- TOC entry 3302 (class 0 OID 0)
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
-- TOC entry 3303 (class 0 OID 0)
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
    date_of_birth date NOT NULL,
    phone character varying
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- TOC entry 3304 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE "user"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."user" IS 'User table';


--
-- TOC entry 3285 (class 0 OID 33199)
-- Dependencies: 226
-- Data for Name: event_invocation_logs; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.event_invocation_logs (id, trigger_name, event_id, status, request, response, created_at) FROM stdin;
0ae52d1f-c3be-4e1b-a631-01ec1b85f4b4	follow_notification	afcd8c6c-d13d-4ca0-acab-8dd13260b6d5	\N	{"headers":[{"name":"Content-Type","value":"application/json"},{"name":"User-Agent","value":"hasura-graphql-engine/v2.21.0"}],"payload":{"created_at":"2023-04-05T12:26:57.393668Z","delivery_info":{"current_retry":0,"max_retries":0},"event":{"data":{"new":null,"old":{"created_at":"2023-04-03T19:25:14.988961+00:00","follower_id":"6b2f8c43-8d7f-4d05-878c-923f6d74cd67","id":"4451450b-aae4-4e7e-87d5-dfb96476ed44","user_id":"2a4d1591-32db-4e1b-bdda-e8703cebb0a8"}},"op":"DELETE","session_variables":{"x-hasura-role":"admin"},"trace_context":{"sampling_state":"1","span_id":"d609edaf610bade9","trace_id":"c74abd6e9ebbedf2ee5c232e79afdf73"}},"id":"afcd8c6c-d13d-4ca0-acab-8dd13260b6d5","table":{"name":"follower","schema":"public"},"trigger":{"name":"follow_notification"}},"version":"2"}	{"data":{"message":"{\\"message\\":\\"Connection failure\\",\\"request\\":{\\"host\\":\\"localhost\\",\\"method\\":\\"POST\\",\\"path\\":\\"/\\",\\"port\\":80,\\"queryString\\":\\"\\",\\"requestHeaders\\":{\\"Content-Type\\":\\"application/json\\",\\"User-Agent\\":\\"hasura-graphql-engine/v2.21.0\\",\\"X-B3-ParentSpanId\\":\\"4c07d89f8b120988\\",\\"X-B3-Sampled\\":\\"1\\",\\"X-B3-SpanId\\":\\"3441f9d10eb325ed\\",\\"X-B3-TraceId\\":\\"c74abd6e9ebbedf2ee5c232e79afdf73\\"},\\"responseTimeout\\":\\"ResponseTimeoutMicro 60000000\\",\\"secure\\":false},\\"type\\":\\"http_exception\\"}"},"type":"client_error","version":"2"}	2023-04-05 12:26:58.085195
\.


--
-- TOC entry 3284 (class 0 OID 33183)
-- Dependencies: 225
-- Data for Name: event_log; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.event_log (id, schema_name, table_name, trigger_name, payload, delivered, error, tries, created_at, locked, next_retry_at, archived) FROM stdin;
afcd8c6c-d13d-4ca0-acab-8dd13260b6d5	public	follower	follow_notification	{"op": "DELETE", "data": {"new": null, "old": {"id": "4451450b-aae4-4e7e-87d5-dfb96476ed44", "user_id": "2a4d1591-32db-4e1b-bdda-e8703cebb0a8", "created_at": "2023-04-03T19:25:14.988961+00:00", "follower_id": "6b2f8c43-8d7f-4d05-878c-923f6d74cd67"}}, "trace_context": {"span_id": "d609edaf610bade9", "trace_id": "c74abd6e9ebbedf2ee5c232e79afdf73", "sampling_state": "1"}, "session_variables": {"x-hasura-role": "admin"}}	f	t	1	2023-04-05 12:26:57.393668	\N	\N	t
\.


--
-- TOC entry 3265 (class 0 OID 16446)
-- Dependencies: 206
-- Data for Name: hdb_action_log; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_action_log (id, action_name, input_payload, request_headers, session_variables, response_payload, errors, created_at, response_received_at, status) FROM stdin;
\.


--
-- TOC entry 3267 (class 0 OID 16472)
-- Dependencies: 208
-- Data for Name: hdb_cron_event_invocation_logs; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_cron_event_invocation_logs (id, event_id, status, request, response, created_at) FROM stdin;
\.


--
-- TOC entry 3266 (class 0 OID 16457)
-- Dependencies: 207
-- Data for Name: hdb_cron_events; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_cron_events (id, trigger_name, scheduled_time, status, tries, created_at, next_retry_at) FROM stdin;
\.


--
-- TOC entry 3286 (class 0 OID 33211)
-- Dependencies: 227
-- Data for Name: hdb_event_log_cleanups; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_event_log_cleanups (id, trigger_name, scheduled_at, deleted_event_logs, deleted_event_invocation_logs, status) FROM stdin;
\.


--
-- TOC entry 3264 (class 0 OID 16435)
-- Dependencies: 205
-- Data for Name: hdb_metadata; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_metadata (id, metadata, resource_version) FROM stdin;
1	{"network":{"tls_allowlist":[{"host":"vuejs.com","permissions":["self-signed"],"suffix":"5136"}]},"sources":[{"configuration":{"connection_info":{"database_url":"postgres://postgres:postgrespassword@postgres:5432/postgres","isolation_level":"read-committed","use_prepared_statements":false}},"kind":"postgres","name":"main","tables":[{"array_relationships":[{"name":"conversation_messages","using":{"foreign_key_constraint_on":{"column":"conversation_id","table":{"name":"message","schema":"public"}}}}],"object_relationships":[{"name":"conversation_user","using":{"foreign_key_constraint_on":"user2_id"}},{"name":"conversation_user2","using":{"manual_configuration":{"column_mapping":{"user1_id":"id"},"insertion_order":null,"remote_table":{"name":"user","schema":"public"}}}}],"table":{"name":"conversation","schema":"public"}},{"object_relationships":[{"name":"user","using":{"foreign_key_constraint_on":"follower_id"}},{"name":"user2","using":{"manual_configuration":{"column_mapping":{"user_id":"id"},"insertion_order":null,"remote_table":{"name":"user","schema":"public"}}}},{"name":"userByUserId","using":{"foreign_key_constraint_on":"user_id"}}],"table":{"name":"follower","schema":"public"}},{"array_relationships":[{"name":"tweet_hashtags","using":{"foreign_key_constraint_on":{"column":"hashtag_id","table":{"name":"tweet_hashtag","schema":"public"}}}}],"computed_fields":[{"definition":{"function":{"name":"number_of_tweets","schema":"public"}},"name":"number_of_tweets"}],"table":{"name":"hashtag","schema":"public"}},{"object_relationships":[{"name":"image_tweet","using":{"foreign_key_constraint_on":"tweet_id"}}],"table":{"name":"image","schema":"public"}},{"object_relationships":[{"name":"tweet","using":{"foreign_key_constraint_on":"tweet_id"}},{"name":"user","using":{"foreign_key_constraint_on":"user_id"}}],"table":{"name":"like","schema":"public"}},{"object_relationships":[{"name":"tweet","using":{"foreign_key_constraint_on":"tweet_id"}},{"name":"user","using":{"foreign_key_constraint_on":"user_id"}}],"table":{"name":"mention","schema":"public"}},{"table":{"name":"message","schema":"public"}},{"object_relationships":[{"name":"notification_user","using":{"foreign_key_constraint_on":"receiver_id"}}],"table":{"name":"notification","schema":"public"}},{"object_relationships":[{"name":"tweet","using":{"foreign_key_constraint_on":"tweet_id"}},{"name":"user","using":{"foreign_key_constraint_on":"user_id"}}],"table":{"name":"retweet","schema":"public"}},{"array_relationships":[{"name":"tweet_images","using":{"foreign_key_constraint_on":{"column":"tweet_id","table":{"name":"image","schema":"public"}}}},{"name":"tweet_likes","using":{"foreign_key_constraint_on":{"column":"tweet_id","table":{"name":"like","schema":"public"}}}},{"name":"tweet_mentions","using":{"foreign_key_constraint_on":{"column":"tweet_id","table":{"name":"mention","schema":"public"}}}},{"name":"tweet_replies","using":{"manual_configuration":{"column_mapping":{"id":"parent_tweet_id"},"insertion_order":null,"remote_table":{"name":"tweet","schema":"public"}}}},{"name":"tweet_retweets","using":{"foreign_key_constraint_on":{"column":"tweet_id","table":{"name":"retweet","schema":"public"}}}},{"name":"tweet_tweet_hashtags","using":{"foreign_key_constraint_on":{"column":"tweet_id","table":{"name":"tweet_hashtag","schema":"public"}}}}],"object_relationships":[{"name":"tweet_user","using":{"foreign_key_constraint_on":"author_id"}}],"table":{"name":"tweet","schema":"public"}},{"object_relationships":[{"name":"hashtag","using":{"foreign_key_constraint_on":"hashtag_id"}},{"name":"tweet","using":{"foreign_key_constraint_on":"tweet_id"}}],"table":{"name":"tweet_hashtag","schema":"public"}},{"array_relationships":[{"name":"follower","using":{"foreign_key_constraint_on":{"column":"follower_id","table":{"name":"follower","schema":"public"}}}},{"name":"followers","using":{"manual_configuration":{"column_mapping":{"id":"follower_id"},"insertion_order":null,"remote_table":{"name":"follower","schema":"public"}}}},{"name":"followersByUserId","using":{"foreign_key_constraint_on":{"column":"user_id","table":{"name":"follower","schema":"public"}}}},{"name":"following","using":{"manual_configuration":{"column_mapping":{"id":"user_id"},"insertion_order":null,"remote_table":{"name":"follower","schema":"public"}}}},{"name":"likes","using":{"foreign_key_constraint_on":{"column":"user_id","table":{"name":"like","schema":"public"}}}},{"name":"mentions","using":{"foreign_key_constraint_on":{"column":"user_id","table":{"name":"mention","schema":"public"}}}},{"name":"retweets","using":{"foreign_key_constraint_on":{"column":"user_id","table":{"name":"retweet","schema":"public"}}}},{"name":"tweets","using":{"foreign_key_constraint_on":{"column":"author_id","table":{"name":"tweet","schema":"public"}}}},{"name":"user_conversations","using":{"foreign_key_constraint_on":{"column":"user1_id","table":{"name":"conversation","schema":"public"}}}},{"name":"user_conversations_2","using":{"foreign_key_constraint_on":{"column":"user2_id","table":{"name":"conversation","schema":"public"}}}}],"select_permissions":[{"permission":{"columns":["premium","bio","email","location","name","password","profile_picture_url","username","website","created_at","id"],"filter":{"id":{"_eq":"X-Hasura-User-Id"}}},"role":"user"}],"table":{"name":"user","schema":"public"},"update_permissions":[{"permission":{"check":null,"columns":["id","username","email","password","bio","profile_picture_url","website","location","created_at","name","premium"],"filter":{"id":{"_eq":"X-Hasura-User-Id"}}},"role":"user"}]}]}],"version":3}	104
\.


--
-- TOC entry 3269 (class 0 OID 16502)
-- Dependencies: 210
-- Data for Name: hdb_scheduled_event_invocation_logs; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_scheduled_event_invocation_logs (id, event_id, status, request, response, created_at) FROM stdin;
\.


--
-- TOC entry 3268 (class 0 OID 16488)
-- Dependencies: 209
-- Data for Name: hdb_scheduled_events; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_scheduled_events (id, webhook_conf, scheduled_time, retry_conf, payload, header_conf, status, tries, created_at, next_retry_at, comment) FROM stdin;
\.


--
-- TOC entry 3270 (class 0 OID 16517)
-- Dependencies: 211
-- Data for Name: hdb_schema_notifications; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_schema_notifications (id, notification, resource_version, instance_id, updated_at) FROM stdin;
1	{"metadata":false,"remote_schemas":[],"sources":["main"],"data_connectors":[]}	104	7207d1a6-7123-4b93-b40b-4e065ae6a8c0	2023-03-25 11:12:51.931196+00
\.


--
-- TOC entry 3283 (class 0 OID 33176)
-- Dependencies: 224
-- Data for Name: hdb_source_catalog_version; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_source_catalog_version (version, upgraded_on) FROM stdin;
3	2023-04-04 15:19:17.740915+00
\.


--
-- TOC entry 3263 (class 0 OID 16423)
-- Dependencies: 204
-- Data for Name: hdb_version; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_version (hasura_uuid, version, upgraded_on, cli_state, console_state) FROM stdin;
4eac0206-3a75-44d0-a80d-17db64dd9cc7	47	2023-03-25 10:51:57.485849+00	{}	{"console_notifications": {"admin": {"date": "2023-04-05T12:38:16.435Z", "read": "default", "showBadge": false}}, "telemetryNotificationShown": true}
\.


--
-- TOC entry 3279 (class 0 OID 24868)
-- Dependencies: 220
-- Data for Name: conversation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.conversation (id, user1_id, user2_id, created_at) FROM stdin;
a6ee364d-cacf-4679-93d9-0f4b611da7b7	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	6e621ebe-c0b1-4877-8244-5e581f25d878	2023-04-03 20:16:50.845231+00
e89a2ab0-d575-4773-887e-d87380d19dac	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	1ce2b46d-c92c-4fd4-a1e3-b4d4e2074815	2023-04-03 20:16:50.845231+00
405f8e61-6f7d-4964-9dd7-a73827478487	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	2023-04-03 20:16:50.845231+00
\.


--
-- TOC entry 3273 (class 0 OID 16557)
-- Dependencies: 214
-- Data for Name: follower; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.follower (id, user_id, follower_id, created_at) FROM stdin;
f0a35f90-27e1-4723-84a4-521f53b9036e	6e621ebe-c0b1-4877-8244-5e581f25d878	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	2023-04-01 22:26:11.968107+00
402dca02-122d-45fa-b755-e3ae91eef901	48f7d933-aa75-422a-ae14-29eb8c880de1	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	2023-04-02 08:41:11.900962+00
3b7bd969-4482-493e-911d-8225e33d42ee	1ce2b46d-c92c-4fd4-a1e3-b4d4e2074815	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	2023-04-02 08:44:35.207582+00
ff244b42-5dca-4982-b2dd-7a242cad1777	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	2023-04-03 19:31:41.25655+00
4e2f6321-96ed-4669-a9f4-51183ee452f6	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	2023-04-03 20:01:20.516485+00
0f5bf4f9-43b5-4297-be3a-38a0c1c064cd	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	6e621ebe-c0b1-4877-8244-5e581f25d878	2023-04-04 08:03:06.908719+00
2814c41d-7884-4fa1-8ac6-e067e1a57aef	336bf68a-d72e-40ed-82ec-75a573e7ab78	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	2023-04-05 12:39:56.871642+00
\.


--
-- TOC entry 3276 (class 0 OID 16608)
-- Dependencies: 217
-- Data for Name: hashtag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hashtag (id, text) FROM stdin;
16429971-a8ff-44d6-afc0-5b2095d6b245	#faute
dd40e0f4-b0c5-4cf2-adc9-b154154c7eab	#hastag
1a76d01f-e2a4-47fe-8e21-2ca769ee1438	#testdesvrai
39af38fc-45c3-4d3e-ae3b-5156cab0e87e	#testdesvrairt
9c5f1fec-ffca-4d62-b9b1-cc229905e23a	#test
3038e2f9-716c-43cf-9bd6-916f7c5521be	#rien
f1f75f28-6878-4978-aa8d-88aa3f4ddbb8	#salutca
842ec305-87ed-4028-8d25-8480704ee3e8	#c
3e0a62d4-6eb6-4e30-8909-1d9bd9e90d8b	#deprime
a32bd55b-d319-4222-96a2-b3493440f469	#jetweet
5d6c0f20-04ae-490e-882c-4f409e37b442	#FreeAbdeslam
4bb14102-8cd1-47bb-a46e-871b8023eabe	#39
cde4c72c-bd31-4bb1-92f0-12d287632eea	#salut
\.


--
-- TOC entry 3281 (class 0 OID 24917)
-- Dependencies: 222
-- Data for Name: image; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.image (id, tweet_id, data, description, title, user_id) FROM stdin;
\.


--
-- TOC entry 3274 (class 0 OID 16573)
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
bb72bc24-238f-40c4-9b6e-a8ef7cc1876c	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	e1188ff9-a3b1-41eb-a9bb-9808463bac45	2023-03-28 19:17:03.205819+00
68b20039-a853-46fe-92b0-80aaf7765caf	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	d6a52a6f-9c9a-47b9-ae22-697d5a5a5dcf	2023-03-28 19:17:05.20424+00
d18d4671-6edd-4c66-814e-b1a274a64937	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	68467af0-a65e-4443-a0c4-16acbd3eb77d	2023-03-31 18:49:16.612193+00
e03895c6-f2d2-4e38-8181-77e43091254d	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	eada2b15-0fe2-4249-9b0b-d134f97c3fcf	2023-04-01 15:32:22.844293+00
66062449-1db8-4976-b8e4-9fb28b4714b6	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	8146dec6-fae8-498e-8b10-c544483ea8ff	2023-04-01 15:34:32.349404+00
6f56520e-6d99-4d0e-9d0d-d8f986dfc7e9	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	6882f9fa-7a03-416a-a15c-01043084e698	2023-04-01 16:00:27.966108+00
3f2bd35b-7161-4f3f-bb48-c5a4dc3771bc	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	7549b8e6-1768-4845-ad2e-74316870193e	2023-04-01 16:00:29.4218+00
14c97afc-7972-4012-8417-20780fff9412	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	1d0342d9-b726-4c2a-9f69-c6c09b6f30c8	2023-04-01 16:00:43.470749+00
5ee0931f-99ec-4944-a3ed-00c6ffc4472f	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	39214c57-19d5-41cd-9f53-a03c52309d59	2023-04-01 16:01:42.487596+00
7e4d3ac8-9bd8-4c83-a53c-08df8620b919	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	9e4fcbf1-db7e-4ed4-bc3b-8f78fb53b6b7	2023-04-01 16:56:15.664507+00
7f0d855f-9074-4443-a95f-431d64726de1	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	15f8d2f0-db07-4c72-85e6-23507cb289da	2023-04-01 17:06:31.206355+00
917c83ff-6103-417e-a113-dd2427378199	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	e7061617-6e92-460e-a968-ea80c71dc886	2023-04-01 18:58:18.611136+00
2179fb44-aca4-4b8f-92ff-e0447cb4f7e0	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	172718dc-f927-4e5a-8eb1-065798283aa0	2023-04-01 18:58:21.44183+00
9acc6ddd-9094-477d-be27-f7d518d06467	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	64ad5ef5-5133-4e28-a68c-fdb6b4c46e1f	2023-04-02 13:59:33.971632+00
79c3b3c3-50ea-4fdd-8a2d-b025a818eb9f	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	3a96781f-6b5d-4b60-9b72-a151b9122edf	2023-04-02 14:00:52.148327+00
b4a57269-f392-4cbf-8898-61385aafcbc2	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	9cc97b3c-6453-4c12-b2f0-e3c2a902ff2c	2023-04-02 14:02:06.398955+00
1dcf346d-48da-4b42-80a6-d0940bd59efb	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	a23481d1-53b1-41cd-81b9-c7f4583862e6	2023-04-03 19:21:35.441008+00
360029ec-a102-4065-be19-5f595eb4a35a	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	b7f8e609-8ddf-4a22-9a35-701a4348f82e	2023-04-03 19:25:46.844414+00
021b0581-ed68-4b31-b510-88f6866e0ab7	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	b7f8e609-8ddf-4a22-9a35-701a4348f82e	2023-04-03 19:26:01.299565+00
3cbbc3be-7799-4e55-bf30-8830e2962e4f	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	146c8078-8f13-457e-b841-b25b088da11c	2023-04-03 19:26:43.091901+00
0ee92e0c-a48a-4b40-976a-0cc225d6be92	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	4a96d7c1-efdf-4b3d-8ef6-d24695ac7a96	2023-04-03 19:26:43.887727+00
6f500451-0efb-4946-9066-8820557de237	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	c6692b06-2e10-4b5d-ac0f-73da09e7489b	2023-04-03 19:30:51.509358+00
1dbf708e-d1c9-4190-8451-bad42082733c	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	e1022b7e-a872-47e9-9da1-2bc0d21debd0	2023-04-03 19:30:53.053218+00
11e6650d-61cd-48a0-8072-75cdef6ad696	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	146c8078-8f13-457e-b841-b25b088da11c	2023-04-03 19:30:54.04604+00
a07d9352-af05-44f2-adb5-16a0fe45e8b1	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	4a96d7c1-efdf-4b3d-8ef6-d24695ac7a96	2023-04-03 19:30:55.471048+00
cbbd0540-6a94-4fc7-a148-c4cbbeab1db5	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	c6692b06-2e10-4b5d-ac0f-73da09e7489b	2023-04-03 19:31:09.815717+00
aeb27807-2e4a-411f-978c-c3cf8672b9c3	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	e1022b7e-a872-47e9-9da1-2bc0d21debd0	2023-04-03 19:31:11.823356+00
4ceb01d7-c30e-4fa0-a415-af9dcc033af2	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	a77f97f0-7c4e-46ea-a4bb-cc1471fe5a03	2023-04-03 19:34:45.50429+00
cdd044cf-3e88-4d5f-803c-49c843815aa9	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	0a872b17-049e-48c9-906a-ce48fcee357a	2023-04-03 19:34:46.508084+00
595a8429-3fbf-40bc-b97a-f1dca3416cdc	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	ad442d54-b26f-4aee-b13e-17cd44ffc43a	2023-04-03 19:34:58.731285+00
3b561e6d-6b9e-4890-b563-b62a5ab9d2d0	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	98f8712c-b796-4a75-b2e1-9e2107820429	2023-04-03 19:35:01.597461+00
70aa4cae-c006-46ba-9152-108816ba1ebc	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	ca13ce3b-96ae-4094-aba7-582da95cdb1e	2023-04-03 19:48:29.187745+00
0d46fba6-3d86-45b4-8841-cb6057c67312	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	55b20b35-4fb5-44c7-a09e-5f29372dea54	2023-04-03 19:52:46.371976+00
a6b15ab7-937c-4e48-92e1-f35a7ace611b	6e621ebe-c0b1-4877-8244-5e581f25d878	ed930f48-7501-4a2b-9112-02987d26a688	2023-04-04 06:29:36.811517+00
b1d2c239-f2dd-49b5-91eb-238400dfc0c8	6e621ebe-c0b1-4877-8244-5e581f25d878	3e23cf2f-f52b-45a4-8af5-7be6caaf2ba5	2023-04-04 06:29:38.480497+00
7ea0020c-51ba-458f-9e66-57162645269e	6e621ebe-c0b1-4877-8244-5e581f25d878	ca13ce3b-96ae-4094-aba7-582da95cdb1e	2023-04-04 07:36:54.195168+00
f112f2e4-ee90-4842-a3dd-64b84e366104	6e621ebe-c0b1-4877-8244-5e581f25d878	55b20b35-4fb5-44c7-a09e-5f29372dea54	2023-04-04 07:36:56.321601+00
3ece2a10-54b5-4352-903b-d8b4c169bc1a	6e621ebe-c0b1-4877-8244-5e581f25d878	e1022b7e-a872-47e9-9da1-2bc0d21debd0	2023-04-04 08:00:49.671168+00
f323b262-ba52-4a4a-a58f-7754a585fe62	6e621ebe-c0b1-4877-8244-5e581f25d878	146c8078-8f13-457e-b841-b25b088da11c	2023-04-04 08:00:50.882194+00
4cfb192d-2efc-4e80-abff-cffa3762d884	6e621ebe-c0b1-4877-8244-5e581f25d878	4a96d7c1-efdf-4b3d-8ef6-d24695ac7a96	2023-04-04 08:00:51.9528+00
c0cdb8da-035d-41bf-86dc-bcc43a895aac	6e621ebe-c0b1-4877-8244-5e581f25d878	f0b791fc-789d-4d70-98d1-672876060a32	2023-04-04 08:00:52.690083+00
dfd0325c-7634-4404-a344-63d625bb01ed	6e621ebe-c0b1-4877-8244-5e581f25d878	b7f8e609-8ddf-4a22-9a35-701a4348f82e	2023-04-04 08:00:53.55671+00
41f19a58-e429-4711-b511-0eacd8ebe8bb	6e621ebe-c0b1-4877-8244-5e581f25d878	0c3e3ff8-862a-4b71-bc31-976dc146b4bc	2023-04-04 08:02:01.607164+00
61821ffc-7443-422e-9344-429e393164db	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	1d9b4478-a6ff-47ae-bcc5-9593659b4ee8	2023-04-04 15:05:39.127841+00
524f4eb2-67b1-4387-9ab8-8663d37b1fb0	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	28127c59-1c80-4fa6-ba04-eba9603a0255	2023-04-05 14:48:30.31891+00
\.


--
-- TOC entry 3278 (class 0 OID 16633)
-- Dependencies: 219
-- Data for Name: mention; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mention (id, user_id, tweet_id, created_at) FROM stdin;
92510387-d907-46a0-a190-68eecd5f9296	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	55b20b35-4fb5-44c7-a09e-5f29372dea54	2023-04-03 19:44:34.492724+00
bc774ee8-3352-4f96-a9e9-5d6002a1d32e	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	ca13ce3b-96ae-4094-aba7-582da95cdb1e	2023-04-03 19:48:11.794918+00
83d45f61-dae8-48a5-a96a-a3b71a6a3254	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	28127c59-1c80-4fa6-ba04-eba9603a0255	2023-04-05 13:54:38.35177+00
\.


--
-- TOC entry 3280 (class 0 OID 24884)
-- Dependencies: 221
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.message (id, sender_id, recipient_id, content, created_at, conversation_id) FROM stdin;
3d3b01ee-7c84-4d0b-b31b-c6fdd2d9cd6a	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	6e621ebe-c0b1-4877-8244-5e581f25d878	salut mon pote ca va ?	2023-04-01 21:51:55.261933+00	a6ee364d-cacf-4679-93d9-0f4b611da7b7
5f6bc0ff-6320-4afc-b5bb-61737e43570f	6e621ebe-c0b1-4877-8244-5e581f25d878	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	bien et toi ?	2023-04-01 21:52:23.69688+00	a6ee364d-cacf-4679-93d9-0f4b611da7b7
2e36bee1-b967-4258-9cb9-1032debe4bd4	6e621ebe-c0b1-4877-8244-5e581f25d878	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	trkl	2023-04-01 22:33:55.862543+00	a6ee364d-cacf-4679-93d9-0f4b611da7b7
6f7657e0-aaa5-4321-b56d-8d3e2c6f9d3b	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	6e621ebe-c0b1-4877-8244-5e581f25d878	fff	2023-04-01 22:37:54.132471+00	a6ee364d-cacf-4679-93d9-0f4b611da7b7
c86a787c-5099-411d-9964-bd32ae6ba705	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	6e621ebe-c0b1-4877-8244-5e581f25d878	test de 	2023-04-01 23:21:33.762789+00	a6ee364d-cacf-4679-93d9-0f4b611da7b7
a71b5d88-6df5-49ac-98c1-47f7befea28a	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	6e621ebe-c0b1-4877-8244-5e581f25d878	message de merde	2023-04-01 23:21:39.335194+00	a6ee364d-cacf-4679-93d9-0f4b611da7b7
77cfee87-d4c1-4702-a120-515acc94c88b	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	6e621ebe-c0b1-4877-8244-5e581f25d878	on test l'overflow	2023-04-01 23:21:46.925511+00	a6ee364d-cacf-4679-93d9-0f4b611da7b7
25968bf1-b990-402b-89b8-84eeb5dd57a1	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	6e621ebe-c0b1-4877-8244-5e581f25d878	fkfk	2023-04-01 23:21:49.932975+00	a6ee364d-cacf-4679-93d9-0f4b611da7b7
6112b071-e11b-44bf-bf6a-12f5b63b33c4	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	6e621ebe-c0b1-4877-8244-5e581f25d878	,,,	2023-04-01 23:22:20.402234+00	a6ee364d-cacf-4679-93d9-0f4b611da7b7
072232f8-6cc4-4e7e-8fea-4b5dbaeebb27	6e621ebe-c0b1-4877-8244-5e581f25d878	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	tjs rien	2023-04-01 23:25:42.895155+00	a6ee364d-cacf-4679-93d9-0f4b611da7b7
476cfaff-fb3a-4555-8b16-0bd5988d867c	6e621ebe-c0b1-4877-8244-5e581f25d878	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	rien  de rien	2023-04-01 23:28:55.974634+00	a6ee364d-cacf-4679-93d9-0f4b611da7b7
3c45b193-6f33-458b-8463-a785686c44d8	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	6e621ebe-c0b1-4877-8244-5e581f25d878	ha non	2023-04-01 23:29:05.819705+00	a6ee364d-cacf-4679-93d9-0f4b611da7b7
24f1aea6-ceb2-45b5-b682-37fda88d0891	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	1ce2b46d-c92c-4fd4-a1e3-b4d4e2074815	salut alice	2023-04-02 08:10:25.640562+00	e89a2ab0-d575-4773-887e-d87380d19dac
34da7826-48a5-4435-b521-f594918080c1	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	salut ca te dis on fais un attentat ?	2023-04-03 19:27:23.28984+00	405f8e61-6f7d-4964-9dd7-a73827478487
e3ae2377-cccb-40c1-85a2-5a279725f4e6	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	tageul mecu	2023-04-03 19:28:16.140734+00	405f8e61-6f7d-4964-9dd7-a73827478487
03dec9ee-3e8c-4e35-9348-8dc7c35a9c73	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	mec	2023-04-03 19:28:19.014792+00	405f8e61-6f7d-4964-9dd7-a73827478487
531b477d-b0e8-4418-92ff-022e587a8f5c	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	HFRTEWZSAyxpie<<eacsxomakncwegf87zaXKOKNDWEGFZ6T78SACNWBERJSOAxdbugifhsaXKO	2023-04-03 19:28:31.461682+00	405f8e61-6f7d-4964-9dd7-a73827478487
d8c01015-d9ec-43cf-8806-849a87618ee1	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	Prout	2023-04-03 19:28:55.795052+00	405f8e61-6f7d-4964-9dd7-a73827478487
fdd61441-95c7-4723-b363-d4d920668b43	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	74hzju*-5uj	2023-04-03 19:29:02.401925+00	405f8e61-6f7d-4964-9dd7-a73827478487
83fd9506-a9e7-4515-8f88-a3a7ee95de2c	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	0-4	2023-04-03 19:29:10.856913+00	405f8e61-6f7d-4964-9dd7-a73827478487
01d8d697-d236-4ebc-b91f-1b9af763cc5e	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	HFRTEWZSAyxpie<<eacsxomakncwegf87zaXKOKNDWEGFZ6T78SACNWBERJSOAxdbugifhsaXKO	2023-04-03 20:13:13.9675+00	405f8e61-6f7d-4964-9dd7-a73827478487
16c7da08-6a19-4d48-99f3-88e9539475e7	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	25	2023-04-03 20:13:55.636707+00	405f8e61-6f7d-4964-9dd7-a73827478487
5816aaa0-4d97-4fdf-8c22-3c17664f0426	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	1ce2b46d-c92c-4fd4-a1e3-b4d4e2074815	rien	2023-04-03 20:18:18.147274+00	e89a2ab0-d575-4773-887e-d87380d19dac
9229fab8-0739-439d-a1e4-e573c807de21	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	1ce2b46d-c92c-4fd4-a1e3-b4d4e2074815	haha	2023-04-03 20:18:27.824573+00	e89a2ab0-d575-4773-887e-d87380d19dac
99432256-9024-435a-ba21-8f82825255cd	6e621ebe-c0b1-4877-8244-5e581f25d878	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	nononon	2023-04-04 06:29:49.212272+00	a6ee364d-cacf-4679-93d9-0f4b611da7b7
b1394f9b-c419-4c95-962e-4e9edaf6e59d	6e621ebe-c0b1-4877-8244-5e581f25d878	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	232323232323232	2023-04-04 07:33:05.053707+00	a6ee364d-cacf-4679-93d9-0f4b611da7b7
b4402c03-3abe-4411-a279-1fb7179410b3	6e621ebe-c0b1-4877-8244-5e581f25d878	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	lololololo	2023-04-04 07:37:05.30001+00	a6ee364d-cacf-4679-93d9-0f4b611da7b7
0a3e52a0-2e37-4800-b1fb-70a8ef8f7db5	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	6e621ebe-c0b1-4877-8244-5e581f25d878	salut	2023-04-05 12:40:58.048644+00	a6ee364d-cacf-4679-93d9-0f4b611da7b7
d0fe4c30-2cbb-4d91-87c9-7cc50bb7737c	6e621ebe-c0b1-4877-8244-5e581f25d878	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	pmm	2023-04-05 14:08:48.52591+00	a6ee364d-cacf-4679-93d9-0f4b611da7b7
df32981a-00a2-4f53-8860-262b0fd15ca6	6e621ebe-c0b1-4877-8244-5e581f25d878	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	jiji	2023-04-05 14:32:00.488669+00	a6ee364d-cacf-4679-93d9-0f4b611da7b7
463b1b62-782a-4d59-8890-ee96afad0974	6e621ebe-c0b1-4877-8244-5e581f25d878	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	loloollo	2023-04-05 14:32:26.228768+00	a6ee364d-cacf-4679-93d9-0f4b611da7b7
802a32d4-d04b-4f26-9cec-f8e38ae5956f	6e621ebe-c0b1-4877-8244-5e581f25d878	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	lolol	2023-04-05 14:34:14.335279+00	a6ee364d-cacf-4679-93d9-0f4b611da7b7
4dba788b-a633-48f0-aac0-63ad6c0405e3	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	6e621ebe-c0b1-4877-8244-5e581f25d878	rien	2023-04-05 15:05:21.700594+00	a6ee364d-cacf-4679-93d9-0f4b611da7b7
\.


--
-- TOC entry 3282 (class 0 OID 33156)
-- Dependencies: 223
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification (id, created_at, message, type, sender_id, receiver_id, read) FROM stdin;
f24d87ff-846d-4e8a-9ef9-9cd12fc4ca39	2023-04-05 12:39:56.871642+00	A new follower has been added	Follower	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	336bf68a-d72e-40ed-82ec-75a573e7ab78	f
a6de3a43-54bd-4c8e-a1a9-00fa5f7239f7	2023-04-05 12:40:58.048644+00	salut	Message	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	6e621ebe-c0b1-4877-8244-5e581f25d878	f
f9b56f32-d3a7-4494-b659-756bb15e3fc3	2023-04-05 13:54:38.35177+00	You have been mentioned in a post	Mention	28127c59-1c80-4fa6-ba04-eba9603a0255	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	f
44342a8f-e400-447b-9057-89c4e96490aa	2023-04-05 14:08:48.52591+00	pmm	Message	6e621ebe-c0b1-4877-8244-5e581f25d878	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	f
e1c379b1-1256-4c99-ad8b-7dc2a5815e83	2023-04-05 14:32:00.488669+00	jiji	Message	6e621ebe-c0b1-4877-8244-5e581f25d878	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	f
39779f88-133f-4302-9ec8-22da34253f11	2023-04-05 14:32:26.228768+00	loloollo	Message	6e621ebe-c0b1-4877-8244-5e581f25d878	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	f
e5068b3a-2af9-4df7-b062-ff33b4ab9d7c	2023-04-05 14:34:14.335279+00	lolol	Message	6e621ebe-c0b1-4877-8244-5e581f25d878	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	f
bb9bd337-a0eb-485f-827c-aa1409140f40	2023-04-05 15:05:21.700594+00	rien	Message	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	6e621ebe-c0b1-4877-8244-5e581f25d878	f
\.


--
-- TOC entry 3275 (class 0 OID 16592)
-- Dependencies: 216
-- Data for Name: retweet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.retweet (user_id, tweet_id, created_at, id) FROM stdin;
6b2f8c43-8d7f-4d05-878c-923f6d74cd67	82535ae5-d550-4021-9c41-0b4e00adf211	2023-04-01 17:06:25.117769+00	25a17366-ccae-4c2c-b6f4-2769df3a8dea
6b2f8c43-8d7f-4d05-878c-923f6d74cd67	e7061617-6e92-460e-a968-ea80c71dc886	2023-04-01 17:06:30.165123+00	c0f82a2c-ef3f-4713-8738-d6ce5441eb3b
6b2f8c43-8d7f-4d05-878c-923f6d74cd67	172718dc-f927-4e5a-8eb1-065798283aa0	2023-04-01 18:58:20.235661+00	6c0e6301-f818-4b49-bbba-9c87681c8b3f
6b2f8c43-8d7f-4d05-878c-923f6d74cd67	fe3610d5-5a5e-48e1-b59f-5a39c9b0f208	2023-04-02 08:20:18.870843+00	c57a62cc-f042-45c7-bf7a-f11d3e36a641
6b2f8c43-8d7f-4d05-878c-923f6d74cd67	64ad5ef5-5133-4e28-a68c-fdb6b4c46e1f	2023-04-02 14:01:32.384142+00	2349d8e6-0c60-44ab-ac8c-49b942da3e58
6b2f8c43-8d7f-4d05-878c-923f6d74cd67	9e4fcbf1-db7e-4ed4-bc3b-8f78fb53b6b7	2023-04-02 14:02:32.74303+00	02035a80-f4c1-41a7-bf6e-9a044d480daa
2a4d1591-32db-4e1b-bdda-e8703cebb0a8	b7f8e609-8ddf-4a22-9a35-701a4348f82e	2023-04-03 19:25:05.006798+00	0b8242ec-231f-4c32-bf32-8de06548bf5e
6b2f8c43-8d7f-4d05-878c-923f6d74cd67	b7f8e609-8ddf-4a22-9a35-701a4348f82e	2023-04-03 19:25:55.10352+00	06293ffa-1011-4f08-8298-15ef1c8051b0
2a4d1591-32db-4e1b-bdda-e8703cebb0a8	ca13ce3b-96ae-4094-aba7-582da95cdb1e	2023-04-03 19:48:30.644236+00	8c318967-f55c-4b5c-819e-04574d140b2f
6b2f8c43-8d7f-4d05-878c-923f6d74cd67	55b20b35-4fb5-44c7-a09e-5f29372dea54	2023-04-03 19:52:45.289989+00	ff2c0d07-2887-4e19-9b9d-e39a8bfc0e5c
6e621ebe-c0b1-4877-8244-5e581f25d878	ed930f48-7501-4a2b-9112-02987d26a688	2023-04-04 07:38:17.382351+00	4a634d88-34b3-46e0-afb1-c57f0adbf6a6
6e621ebe-c0b1-4877-8244-5e581f25d878	3e23cf2f-f52b-45a4-8af5-7be6caaf2ba5	2023-04-04 07:38:18.790677+00	90e9b78f-1660-45c8-990a-942931a74895
6e621ebe-c0b1-4877-8244-5e581f25d878	55b20b35-4fb5-44c7-a09e-5f29372dea54	2023-04-04 07:38:20.522259+00	fd34d48a-8a0e-47d9-b423-2e7fff49c272
6e621ebe-c0b1-4877-8244-5e581f25d878	0c3e3ff8-862a-4b71-bc31-976dc146b4bc	2023-04-04 08:02:23.917726+00	341d5491-fe88-4006-befb-ce5e9f5b35de
\.


--
-- TOC entry 3272 (class 0 OID 16542)
-- Dependencies: 213
-- Data for Name: tweet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tweet (id, author_id, content, created_at, image_url, parent_tweet_id) FROM stdin;
1d0342d9-b726-4c2a-9f69-c6c09b6f30c8	2c13461f-7c04-4376-9f2e-15d2443a3a03	I love Hasura!	2022-01-02 00:00:00+00	\N	\N
d58e0e09-e8f3-4fb7-9cf4-c431df7b8d4e	1ce2b46d-c92c-4fd4-a1e3-b4d4e2074815	GraphQL is amazing!	2022-01-03 00:00:00+00	\N	\N
fe3610d5-5a5e-48e1-b59f-5a39c9b0f208	336bf68a-d72e-40ed-82ec-75a573e7ab78	Just had a great meeting with the team	2022-01-04 00:00:00+00	\N	\N
d6a52a6f-9c9a-47b9-ae22-697d5a5a5dcf	48f7d933-aa75-422a-ae14-29eb8c880de1	Excited to start my new job next week	2022-01-05 00:00:00+00	\N	\N
e1188ff9-a3b1-41eb-a9bb-9808463bac45	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	Salut c'est un test de tweet	2023-03-28 15:15:40.703273+00	\N	\N
15cd1872-3f5e-4f4b-ae29-57d277cc3ae4	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	oui j'arrive	2023-03-28 15:19:24.587484+00	\N	\N
c3a1adde-714d-49c4-ae93-401626cc1f19	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	salut	2023-03-28 15:22:15.327641+00	\N	\N
cb614ba2-b1c2-44dc-a551-a8b3dd809379	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	comment ca va ?	2023-03-28 17:13:31.012208+00	\N	\N
6882f9fa-7a03-416a-a15c-01043084e698	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	ca va et toi #fatigué, #rien	2023-03-29 17:18:55.888699+00	\N	\N
7549b8e6-1768-4845-ad2e-74316870193e	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	salut #test	2023-03-29 17:58:36.047198+00	\N	\N
45eb4e70-d2fa-4ca8-84ef-034e0b91e8e0	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	salut #test cava #faute	2023-03-29 18:00:21.279962+00	\N	\N
a0af770f-4de4-4b29-930c-31b6509121a1	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	Test #hastag	2023-03-29 18:36:20.885765+00	\N	\N
63888231-19dd-43ad-b632-43b9f7adf5bb	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	test des vrai_ #testdesvrai	2023-03-29 19:05:16.492529+00	\N	\N
39214c57-19d5-41cd-9f53-a03c52309d59	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	test des vrai_ #testdesvrairt	2023-03-29 19:07:22.765717+00	\N	\N
6bc94cd2-1c89-4669-ba4e-57345a270b35	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	test des vrai_ #testdesvrairt	2023-03-29 19:07:57.291211+00	\N	\N
1bf3de46-3282-49c7-8024-4c474590ffaa	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	#test	2023-03-29 19:11:10.239892+00	\N	\N
8c28cb8b-e454-4fea-ac0a-7b1783eeb964	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	#test	2023-03-29 19:15:37.216834+00	\N	\N
0606f502-5af2-417f-bdf0-edc70c152e1f	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	#test	2023-03-29 19:15:58.30673+00	\N	\N
77863df5-8023-4256-92ee-47d7b333e81d	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	#test	2023-03-29 19:17:06.045412+00	\N	\N
1091b696-1f34-4e99-8b82-756bb7ce5f1a	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	#test	2023-03-29 19:18:18.458183+00	\N	\N
15976796-505e-41cf-a346-ac9235c59821	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	#rien	2023-03-29 19:29:08.77773+00	\N	\N
895506cb-4093-4c8b-9831-bb264ae3d58d	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	#salutca va ?	2023-03-29 19:31:25.706548+00	\N	\N
172718dc-f927-4e5a-8eb1-065798283aa0	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	#salutca test2	2023-03-29 19:39:28.942101+00	\N	\N
68467af0-a65e-4443-a0c4-16acbd3eb77d	6e621ebe-c0b1-4877-8244-5e581f25d878	Nouveau su twitter #c&#39;estbien	2023-03-31 18:49:03.62858+00	\N	\N
e7061617-6e92-460e-a968-ea80c71dc886	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	test	2023-03-31 19:25:25.191537+00	\N	\N
15f8d2f0-db07-4c72-85e6-23507cb289da	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	rien de spécial	2023-03-31 19:27:58.811557+00	\N	\N
7f98107f-73e8-4c86-af84-28144ff61d74	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	test image	2023-03-31 19:29:44.931393+00	\N	\N
3a96781f-6b5d-4b60-9b72-a151b9122edf	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	star wars	2023-03-31 19:30:55.631829+00	\N	\N
8eaa756f-625a-4773-af90-2c8a72c35586	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	rin de special test n°2589 #deprime	2023-03-31 19:35:59.208257+00	\N	\N
8735b68d-0704-46ba-9982-845c8673d5dd	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	rin de special test n°2589 #deprime	2023-03-31 19:38:20.005217+00	\N	\N
82535ae5-d550-4021-9c41-0b4e00adf211	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	y	2023-03-31 19:39:26.625965+00	\N	\N
8146dec6-fae8-498e-8b10-c544483ea8ff	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	fff	2023-03-31 19:41:00.591665+00	\N	\N
9e4fcbf1-db7e-4ed4-bc3b-8f78fb53b6b7	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	xee	2023-03-31 19:44:00.686149+00	\N	\N
eada2b15-0fe2-4249-9b0b-d134f97c3fcf	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	fffrerqer	2023-03-31 19:44:46.079371+00	\N	\N
9cc97b3c-6453-4c12-b2f0-e3c2a902ff2c	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	ddd	2023-03-31 19:46:39.561589+00	\N	\N
ed930f48-7501-4a2b-9112-02987d26a688	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	rienWhat’s happening?	2023-04-03 20:00:56.38838+00	"null"	\N
e05ec5dc-f8d4-4f0d-b05c-1a511a8e372a	1ce2b46d-c92c-4fd4-a1e3-b4d4e2074815	Hello world!	2022-01-01 00:00:00+00	["/main/FpkMFTpX0AABs_O.jpg"]	\N
64ad5ef5-5133-4e28-a68c-fdb6b4c46e1f	6e621ebe-c0b1-4877-8244-5e581f25d878	#jetweet lol	2023-04-01 21:52:44.226216+00	"null"	\N
a23481d1-53b1-41cd-81b9-c7f4583862e6	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	ccc	2023-04-02 20:08:27.282359+00	"null"	\N
b7f8e609-8ddf-4a22-9a35-701a4348f82e	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	Bonjour #FreeAbdeslam	2023-04-03 19:24:51.598581+00	"null"	\N
f0b791fc-789d-4d70-98d1-672876060a32	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	salut #FreeAbdeslam	2023-04-03 19:26:21.692947+00	"null"	\N
4a96d7c1-efdf-4b3d-8ef6-d24695ac7a96	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	#FreeAbdeslam	2023-04-03 19:26:26.289519+00	"null"	\N
146c8078-8f13-457e-b841-b25b088da11c	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	#FreeAbdeslam	2023-04-03 19:26:39.50906+00	"null"	\N
e1022b7e-a872-47e9-9da1-2bc0d21debd0	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	#FreeAbdeslam	2023-04-03 19:26:44.411781+00	"null"	\N
c6692b06-2e10-4b5d-ac0f-73da09e7489b	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	et la certif abruti @nelda	2023-04-03 19:27:20.163217+00	"null"	\N
fddb7a4d-dceb-475a-8031-ef3467362bc8	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	Beaucoup de choses peuvent expliquer cette réaction sobre (vision froide de l&#39;entraîneur, peur du VAR, etc.) mais je pense qu&#39;il y aussi de l&#39;empathie envers Solbakken Le joueur veut jouer, il va devoir se rasseoir, c&#39;est jamais un moment cool. J&#39;aime bien cette réaction de José	2023-04-03 19:31:59.308537+00	"null"	\N
98f8712c-b796-4a75-b2e1-9e2107820429	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	Beaucoup de choses peuvent expliquer cette réaction sobre (vision froide de l&#39;entraîneur, peur du VAR, etc.) mais je pense qu&#39;il y aussi de l&#39;empathie envers Solbakken Le joueur veut jouer, il va devoir se rasseoir, c&#39;est jamais un moment cool. J&#39;aime bien cette réaction de José	2023-04-03 19:33:02.978016+00	"null"	\N
ad442d54-b26f-4aee-b13e-17cd44ffc43a	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	Beaucoup de choses peuvent expliquer cette réaction sobre (vision froide de l&#39;entraîneur, peur du VAR, etc.) mais je pense qu&#39;il y aussi de l&#39;empathie envers Solbakken Le joueur veut jouer, il va devoir se rasseoir, c&#39;est jamais un moment cool. J&#39;aime bien cette réaction de José	2023-04-03 19:33:25.840103+00	"null"	\N
0a872b17-049e-48c9-906a-ce48fcee357a	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	Beaucoup de choses peuvent expliquer cette réaction sobre (vision froide de l&#39;entraîneur, peur du VAR, etc.) mais je pense qu&#39;il y aussi de l&#39;empathie envers Solbakken Le joueur veut jouer, il va devoir se rasseoir, c&#39;est jamais un moment cool. J&#39;aime bien cette réaction de José	2023-04-03 19:33:40.536513+00	"null"	\N
a77f97f0-7c4e-46ea-a4bb-cc1471fe5a03	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	Beaucoup de choses peuvent expliquer cette réaction sobre (vision froide de l&#39;entraîneur, peur du VAR, etc.) mais je pense qu&#39;il y aussi de l&#39;empathie envers Solbakken Le joueur veut jouer, il va devoir se rasseoir, c&#39;est jamais un moment cool. J&#39;aime bien cette réaction de José	2023-04-03 19:34:39.190197+00	"null"	\N
55b20b35-4fb5-44c7-a09e-5f29372dea54	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	#salut @nelda	2023-04-03 19:44:34.30972+00	"null"	\N
ca13ce3b-96ae-4094-aba7-582da95cdb1e	2a4d1591-32db-4e1b-bdda-e8703cebb0a8	Et ce ratio, il te dit salut ? @nelda	2023-04-03 19:48:11.460744+00	"null"	\N
3e23cf2f-f52b-45a4-8af5-7be6caaf2ba5	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	salut @rien de rien	2023-04-03 19:53:27.326789+00	"null"	\N
0c3e3ff8-862a-4b71-bc31-976dc146b4bc	6e621ebe-c0b1-4877-8244-5e581f25d878	salut @Jean-mi	2023-04-04 07:53:13.049007+00	"null"	\N
62e4ff9f-a6ad-44e4-a331-e168d1cd1981	6e621ebe-c0b1-4877-8244-5e581f25d878	rtrt	2023-04-04 11:25:46.654571+00	\N	0c3e3ff8-862a-4b71-bc31-976dc146b4bc
f8ada09b-469d-4691-b540-0235ea95e950	6e621ebe-c0b1-4877-8244-5e581f25d878	réponse	2023-04-04 11:34:59.108361+00	\N	3e23cf2f-f52b-45a4-8af5-7be6caaf2ba5
689a5d26-d1cd-41d2-a0f9-2410ae072a49	6e621ebe-c0b1-4877-8244-5e581f25d878	deuxième réponse\n\n	2023-04-04 11:35:32.088551+00	\N	ed930f48-7501-4a2b-9112-02987d26a688
1d9b4478-a6ff-47ae-bcc5-9593659b4ee8	6b2f8c43-8d7f-4d05-878c-923f6d74cd67	kiikk	2023-04-04 15:03:19.663245+00	\N	ca13ce3b-96ae-4094-aba7-582da95cdb1e
28127c59-1c80-4fa6-ba04-eba9603a0255	6e621ebe-c0b1-4877-8244-5e581f25d878	@nelda	2023-04-05 13:54:38.321991+00	"null"	\N
\.


--
-- TOC entry 3277 (class 0 OID 16617)
-- Dependencies: 218
-- Data for Name: tweet_hashtag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tweet_hashtag (id, tweet_id, hashtag_id) FROM stdin;
84e382d2-ddff-4606-9555-28862558e0ce	15976796-505e-41cf-a346-ac9235c59821	3038e2f9-716c-43cf-9bd6-916f7c5521be
2d355c31-73fe-45c4-984d-63d49f79dc96	895506cb-4093-4c8b-9831-bb264ae3d58d	f1f75f28-6878-4978-aa8d-88aa3f4ddbb8
9c196932-614d-4072-b154-13e1f0299e76	172718dc-f927-4e5a-8eb1-065798283aa0	f1f75f28-6878-4978-aa8d-88aa3f4ddbb8
ac794654-df94-43d9-bdef-199f0fe9411d	68467af0-a65e-4443-a0c4-16acbd3eb77d	842ec305-87ed-4028-8d25-8480704ee3e8
f070e435-469f-4ea9-8421-3a8e857463ba	68467af0-a65e-4443-a0c4-16acbd3eb77d	4bb14102-8cd1-47bb-a46e-871b8023eabe
e6b31864-f681-4b03-ab68-83e8f9bf9396	8eaa756f-625a-4773-af90-2c8a72c35586	3e0a62d4-6eb6-4e30-8909-1d9bd9e90d8b
2f25bf75-5d97-496f-99b4-1752a3a53b77	8735b68d-0704-46ba-9982-845c8673d5dd	3e0a62d4-6eb6-4e30-8909-1d9bd9e90d8b
5295febf-d1e9-4e26-8f1a-9ec1b646a8d4	64ad5ef5-5133-4e28-a68c-fdb6b4c46e1f	a32bd55b-d319-4222-96a2-b3493440f469
ca1e90b6-b3df-421c-ac00-5a5df260df54	b7f8e609-8ddf-4a22-9a35-701a4348f82e	5d6c0f20-04ae-490e-882c-4f409e37b442
88ed184e-495a-48e2-aa75-31d61a9c79e9	f0b791fc-789d-4d70-98d1-672876060a32	5d6c0f20-04ae-490e-882c-4f409e37b442
aeda9e60-ae9c-4186-91ae-a506da54153c	4a96d7c1-efdf-4b3d-8ef6-d24695ac7a96	5d6c0f20-04ae-490e-882c-4f409e37b442
e04cb3c2-1a93-4535-ba4a-83ecded5c42e	146c8078-8f13-457e-b841-b25b088da11c	5d6c0f20-04ae-490e-882c-4f409e37b442
48d65779-c6d5-48b0-b8a3-8d69e4079205	e1022b7e-a872-47e9-9da1-2bc0d21debd0	5d6c0f20-04ae-490e-882c-4f409e37b442
ed4f1c9c-2a8f-4c5f-b1e4-de8012e4d50b	fddb7a4d-dceb-475a-8031-ef3467362bc8	4bb14102-8cd1-47bb-a46e-871b8023eabe
8921983e-1949-46fe-88a5-ec2fa919ff6e	fddb7a4d-dceb-475a-8031-ef3467362bc8	4bb14102-8cd1-47bb-a46e-871b8023eabe
d79010c4-e033-4c29-b4c1-4e950d2c360d	fddb7a4d-dceb-475a-8031-ef3467362bc8	4bb14102-8cd1-47bb-a46e-871b8023eabe
506a8542-6814-4882-9de2-eafe91d897d2	fddb7a4d-dceb-475a-8031-ef3467362bc8	4bb14102-8cd1-47bb-a46e-871b8023eabe
c622ae13-b836-4972-a4a4-7cf83fef8462	fddb7a4d-dceb-475a-8031-ef3467362bc8	4bb14102-8cd1-47bb-a46e-871b8023eabe
9d1d4cc7-1475-4400-8aec-98ded0f6ad47	98f8712c-b796-4a75-b2e1-9e2107820429	4bb14102-8cd1-47bb-a46e-871b8023eabe
8e41b873-8a92-4b91-a2e3-43ecc223ff93	98f8712c-b796-4a75-b2e1-9e2107820429	4bb14102-8cd1-47bb-a46e-871b8023eabe
b201d00c-2ec9-4738-aba8-44136759bf34	98f8712c-b796-4a75-b2e1-9e2107820429	4bb14102-8cd1-47bb-a46e-871b8023eabe
a951b07d-fbb5-4db8-acb7-dc507389849a	98f8712c-b796-4a75-b2e1-9e2107820429	4bb14102-8cd1-47bb-a46e-871b8023eabe
0647ee04-6562-4d0d-a68b-5973708cd377	98f8712c-b796-4a75-b2e1-9e2107820429	4bb14102-8cd1-47bb-a46e-871b8023eabe
0e2f7e9f-5990-4123-890d-74130b54d064	ad442d54-b26f-4aee-b13e-17cd44ffc43a	4bb14102-8cd1-47bb-a46e-871b8023eabe
1deb0149-4bf0-433a-a65e-18c3cf648c82	ad442d54-b26f-4aee-b13e-17cd44ffc43a	4bb14102-8cd1-47bb-a46e-871b8023eabe
e1192951-af7e-4d9f-8b2e-1d1afee3c348	ad442d54-b26f-4aee-b13e-17cd44ffc43a	4bb14102-8cd1-47bb-a46e-871b8023eabe
0c418208-0b57-445a-98c2-d3e9d707c67e	ad442d54-b26f-4aee-b13e-17cd44ffc43a	4bb14102-8cd1-47bb-a46e-871b8023eabe
421a2924-0706-4430-81d9-acd3356298a6	ad442d54-b26f-4aee-b13e-17cd44ffc43a	4bb14102-8cd1-47bb-a46e-871b8023eabe
de3e706b-7d85-4bcb-aa7e-bfccf8b4d82d	0a872b17-049e-48c9-906a-ce48fcee357a	4bb14102-8cd1-47bb-a46e-871b8023eabe
f81b1b8d-7edd-4b30-ad42-719278ecd6b4	0a872b17-049e-48c9-906a-ce48fcee357a	4bb14102-8cd1-47bb-a46e-871b8023eabe
88fb571f-cadb-45bd-ae27-7bd63eccd16f	0a872b17-049e-48c9-906a-ce48fcee357a	4bb14102-8cd1-47bb-a46e-871b8023eabe
1ae71a27-1737-4f85-9767-7b0f871e2568	0a872b17-049e-48c9-906a-ce48fcee357a	4bb14102-8cd1-47bb-a46e-871b8023eabe
b096c75c-6573-4da2-b983-8926fa27538a	0a872b17-049e-48c9-906a-ce48fcee357a	4bb14102-8cd1-47bb-a46e-871b8023eabe
9cc87ed1-7abe-4f9e-ad51-33b0a23d43b1	a77f97f0-7c4e-46ea-a4bb-cc1471fe5a03	4bb14102-8cd1-47bb-a46e-871b8023eabe
57d7344a-1684-44f1-8c7b-56262d68b96e	a77f97f0-7c4e-46ea-a4bb-cc1471fe5a03	4bb14102-8cd1-47bb-a46e-871b8023eabe
d9272431-1a72-41e9-a2ef-e6f8bd5c6fcd	a77f97f0-7c4e-46ea-a4bb-cc1471fe5a03	4bb14102-8cd1-47bb-a46e-871b8023eabe
e42bf5ef-2c26-410e-8185-aac016d99e51	a77f97f0-7c4e-46ea-a4bb-cc1471fe5a03	4bb14102-8cd1-47bb-a46e-871b8023eabe
e36fcbda-ec38-4062-861a-3381582783f6	a77f97f0-7c4e-46ea-a4bb-cc1471fe5a03	4bb14102-8cd1-47bb-a46e-871b8023eabe
53b3c8e7-bb6c-4df4-8406-ecb8acb76d12	55b20b35-4fb5-44c7-a09e-5f29372dea54	cde4c72c-bd31-4bb1-92f0-12d287632eea
\.


--
-- TOC entry 3271 (class 0 OID 16528)
-- Dependencies: 212
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, username, email, password, bio, profile_picture_url, website, location, created_at, name, premium, date_of_birth, phone) FROM stdin;
1ce2b46d-c92c-4fd4-a1e3-b4d4e2074815	alice	alice@example.com	password1	'	\N	\N	\N	2023-03-25 12:33:35.914806+00	Alice	f	2001-02-01	\N
48f7d933-aa75-422a-ae14-29eb8c880de1	david	david@example.com	password4	'	\N	\N	\N	2023-03-25 12:33:35.914806+00	David	f	2001-02-01	\N
336bf68a-d72e-40ed-82ec-75a573e7ab78	charlie	charlie@example.com	password3	'	\N	\N	\N	2023-03-25 12:33:35.914806+00	Charlie	f	2001-02-01	\N
2c13461f-7c04-4376-9f2e-15d2443a3a03	bob	bob@example.com	password2	'	\N	\N	\N	2023-03-25 12:33:35.914806+00	Bob	f	2001-02-01	\N
6e621ebe-c0b1-4877-8244-5e581f25d878	krateros	spelfard74@gmail.com	$2a$10$fRoFKWfHn2O4PWECO7OqPOSf4VC.XkH1hhZwyl8M6v2/A2Ar1cZGm	'	\N	\N	\N	2023-03-31 18:48:24.121525+00	Krateros Wallace	f	1992-03-12	\N
6b2f8c43-8d7f-4d05-878c-923f6d74cd67	nelda	adlencherif29@gmail.com	$2a$10$MGql3FiTb539DPCWnjCdauBJqm3lvDiFrA67cUmYPyTzU9ZctTALq	'	http://127.0.0.1:9000/main/FpkMFTpX0AABs_O.jpg	\N	\N	2023-03-28 10:54:55.805202+00	Adlen CHERIF	t	2002-07-29	\N
2a4d1591-32db-4e1b-bdda-e8703cebb0a8	Jean-mi	yahiv71671@marikuza.com	$2a$10$wfKjGUNj8LgDdkVjYr6Fze7m6cs2nAqIQjZpMBOUYyCivI4MUAvGu	'	\N	\N	\N	2023-04-03 19:22:57.95808+00	Abdelakh Khadirhov	f	1900-01-01	\N
\.


--
-- TOC entry 3107 (class 2606 OID 33208)
-- Name: event_invocation_logs event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.event_invocation_logs
    ADD CONSTRAINT event_invocation_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 3103 (class 2606 OID 33196)
-- Name: event_log event_log_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.event_log
    ADD CONSTRAINT event_log_pkey PRIMARY KEY (id);


--
-- TOC entry 3043 (class 2606 OID 16456)
-- Name: hdb_action_log hdb_action_log_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_action_log
    ADD CONSTRAINT hdb_action_log_pkey PRIMARY KEY (id);


--
-- TOC entry 3050 (class 2606 OID 16481)
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 3046 (class 2606 OID 16469)
-- Name: hdb_cron_events hdb_cron_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_events
    ADD CONSTRAINT hdb_cron_events_pkey PRIMARY KEY (id);


--
-- TOC entry 3109 (class 2606 OID 33220)
-- Name: hdb_event_log_cleanups hdb_event_log_cleanups_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_event_log_cleanups
    ADD CONSTRAINT hdb_event_log_cleanups_pkey PRIMARY KEY (id);


--
-- TOC entry 3111 (class 2606 OID 33222)
-- Name: hdb_event_log_cleanups hdb_event_log_cleanups_trigger_name_scheduled_at_key; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_event_log_cleanups
    ADD CONSTRAINT hdb_event_log_cleanups_trigger_name_scheduled_at_key UNIQUE (trigger_name, scheduled_at);


--
-- TOC entry 3039 (class 2606 OID 16443)
-- Name: hdb_metadata hdb_metadata_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_pkey PRIMARY KEY (id);


--
-- TOC entry 3041 (class 2606 OID 16445)
-- Name: hdb_metadata hdb_metadata_resource_version_key; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_resource_version_key UNIQUE (resource_version);


--
-- TOC entry 3055 (class 2606 OID 16511)
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 3053 (class 2606 OID 16500)
-- Name: hdb_scheduled_events hdb_scheduled_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_events
    ADD CONSTRAINT hdb_scheduled_events_pkey PRIMARY KEY (id);


--
-- TOC entry 3057 (class 2606 OID 16527)
-- Name: hdb_schema_notifications hdb_schema_notifications_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_schema_notifications
    ADD CONSTRAINT hdb_schema_notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 3037 (class 2606 OID 16433)
-- Name: hdb_version hdb_version_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_version
    ADD CONSTRAINT hdb_version_pkey PRIMARY KEY (hasura_uuid);


--
-- TOC entry 3091 (class 2606 OID 24947)
-- Name: conversation conversation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversation
    ADD CONSTRAINT conversation_pkey PRIMARY KEY (id);


--
-- TOC entry 3093 (class 2606 OID 24939)
-- Name: conversation conversation_user1_id_user2_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversation
    ADD CONSTRAINT conversation_user1_id_user2_id_key UNIQUE (user1_id, user2_id);


--
-- TOC entry 3067 (class 2606 OID 16562)
-- Name: follower follower_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follower
    ADD CONSTRAINT follower_pkey PRIMARY KEY (id);


--
-- TOC entry 3069 (class 2606 OID 24954)
-- Name: follower follower_user_id_follower_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follower
    ADD CONSTRAINT follower_user_id_follower_id_key UNIQUE (user_id, follower_id);


--
-- TOC entry 3081 (class 2606 OID 16616)
-- Name: hashtag hashtag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hashtag
    ADD CONSTRAINT hashtag_pkey PRIMARY KEY (id);


--
-- TOC entry 3083 (class 2606 OID 24916)
-- Name: hashtag hashtag_text_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hashtag
    ADD CONSTRAINT hashtag_text_key UNIQUE (text);


--
-- TOC entry 3097 (class 2606 OID 24925)
-- Name: image image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_pkey PRIMARY KEY (id);


--
-- TOC entry 3071 (class 2606 OID 24910)
-- Name: like like_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."like"
    ADD CONSTRAINT like_pkey PRIMARY KEY (id, tweet_id, user_id);


--
-- TOC entry 3073 (class 2606 OID 24912)
-- Name: like like_user_id_tweet_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."like"
    ADD CONSTRAINT like_user_id_tweet_id_key UNIQUE (user_id, tweet_id);


--
-- TOC entry 3087 (class 2606 OID 16639)
-- Name: mention mention_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mention
    ADD CONSTRAINT mention_pkey PRIMARY KEY (id);


--
-- TOC entry 3089 (class 2606 OID 33149)
-- Name: mention mention_user_id_tweet_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mention
    ADD CONSTRAINT mention_user_id_tweet_id_key UNIQUE (user_id, tweet_id);


--
-- TOC entry 3095 (class 2606 OID 24893)
-- Name: message message_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_pkey PRIMARY KEY (id);


--
-- TOC entry 3099 (class 2606 OID 33165)
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- TOC entry 3075 (class 2606 OID 16654)
-- Name: retweet retweet_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retweet
    ADD CONSTRAINT retweet_id_key UNIQUE (id);


--
-- TOC entry 3077 (class 2606 OID 16660)
-- Name: retweet retweet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retweet
    ADD CONSTRAINT retweet_pkey PRIMARY KEY (id);


--
-- TOC entry 3079 (class 2606 OID 24937)
-- Name: retweet retweet_user_id_tweet_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retweet
    ADD CONSTRAINT retweet_user_id_tweet_id_key UNIQUE (user_id, tweet_id);


--
-- TOC entry 3085 (class 2606 OID 16622)
-- Name: tweet_hashtag tweet_hashtag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tweet_hashtag
    ADD CONSTRAINT tweet_hashtag_pkey PRIMARY KEY (id);


--
-- TOC entry 3065 (class 2606 OID 16551)
-- Name: tweet tweet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tweet
    ADD CONSTRAINT tweet_pkey PRIMARY KEY (id);


--
-- TOC entry 3059 (class 2606 OID 16541)
-- Name: user user_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- TOC entry 3061 (class 2606 OID 16537)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 3063 (class 2606 OID 16539)
-- Name: user user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- TOC entry 3105 (class 1259 OID 33209)
-- Name: event_invocation_logs_event_id_idx; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX event_invocation_logs_event_id_idx ON hdb_catalog.event_invocation_logs USING btree (event_id);


--
-- TOC entry 3101 (class 1259 OID 33198)
-- Name: event_log_fetch_events; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX event_log_fetch_events ON hdb_catalog.event_log USING btree (locked NULLS FIRST, next_retry_at NULLS FIRST, created_at) WHERE ((delivered = false) AND (error = false) AND (archived = false));


--
-- TOC entry 3104 (class 1259 OID 33197)
-- Name: event_log_trigger_name_idx; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX event_log_trigger_name_idx ON hdb_catalog.event_log USING btree (trigger_name);


--
-- TOC entry 3048 (class 1259 OID 16487)
-- Name: hdb_cron_event_invocation_event_id; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX hdb_cron_event_invocation_event_id ON hdb_catalog.hdb_cron_event_invocation_logs USING btree (event_id);


--
-- TOC entry 3044 (class 1259 OID 16470)
-- Name: hdb_cron_event_status; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX hdb_cron_event_status ON hdb_catalog.hdb_cron_events USING btree (status);


--
-- TOC entry 3047 (class 1259 OID 16471)
-- Name: hdb_cron_events_unique_scheduled; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE UNIQUE INDEX hdb_cron_events_unique_scheduled ON hdb_catalog.hdb_cron_events USING btree (trigger_name, scheduled_time) WHERE (status = 'scheduled'::text);


--
-- TOC entry 3051 (class 1259 OID 16501)
-- Name: hdb_scheduled_event_status; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX hdb_scheduled_event_status ON hdb_catalog.hdb_scheduled_events USING btree (status);


--
-- TOC entry 3100 (class 1259 OID 33182)
-- Name: hdb_source_catalog_version_one_row; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE UNIQUE INDEX hdb_source_catalog_version_one_row ON hdb_catalog.hdb_source_catalog_version USING btree (((version IS NOT NULL)));


--
-- TOC entry 3035 (class 1259 OID 16434)
-- Name: hdb_version_one_row; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE UNIQUE INDEX hdb_version_one_row ON hdb_catalog.hdb_version USING btree (((version IS NOT NULL)));


--
-- TOC entry 3134 (class 2620 OID 33230)
-- Name: follower follower_notify_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER follower_notify_trigger AFTER INSERT OR UPDATE ON public.follower FOR EACH ROW EXECUTE FUNCTION public.notify_trigger();


--
-- TOC entry 3135 (class 2620 OID 33231)
-- Name: mention mention_notify_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER mention_notify_trigger AFTER INSERT OR UPDATE ON public.mention FOR EACH ROW EXECUTE FUNCTION public.notify_trigger();


--
-- TOC entry 3136 (class 2620 OID 33232)
-- Name: message message_notify_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER message_notify_trigger AFTER INSERT OR UPDATE ON public.message FOR EACH ROW EXECUTE FUNCTION public.notify_trigger();


--
-- TOC entry 3112 (class 2606 OID 16482)
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_cron_events(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3113 (class 2606 OID 16512)
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_scheduled_events(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3126 (class 2606 OID 24874)
-- Name: conversation conversation_user1_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversation
    ADD CONSTRAINT conversation_user1_id_fkey FOREIGN KEY (user1_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3127 (class 2606 OID 24879)
-- Name: conversation conversation_user2_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversation
    ADD CONSTRAINT conversation_user2_id_fkey FOREIGN KEY (user2_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3116 (class 2606 OID 16568)
-- Name: follower follower_follower_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follower
    ADD CONSTRAINT follower_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3117 (class 2606 OID 16563)
-- Name: follower follower_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follower
    ADD CONSTRAINT follower_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3131 (class 2606 OID 24926)
-- Name: image image_tweet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_tweet_id_fkey FOREIGN KEY (tweet_id) REFERENCES public.tweet(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3132 (class 2606 OID 24931)
-- Name: image image_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3118 (class 2606 OID 16585)
-- Name: like like_tweet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."like"
    ADD CONSTRAINT like_tweet_id_fkey FOREIGN KEY (tweet_id) REFERENCES public.tweet(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3119 (class 2606 OID 16580)
-- Name: like like_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."like"
    ADD CONSTRAINT like_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3124 (class 2606 OID 16645)
-- Name: mention mention_tweet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mention
    ADD CONSTRAINT mention_tweet_id_fkey FOREIGN KEY (tweet_id) REFERENCES public.tweet(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3125 (class 2606 OID 16640)
-- Name: mention mention_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mention
    ADD CONSTRAINT mention_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3128 (class 2606 OID 24948)
-- Name: message message_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversation(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3129 (class 2606 OID 24899)
-- Name: message message_recipient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_recipient_id_fkey FOREIGN KEY (recipient_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3130 (class 2606 OID 24894)
-- Name: message message_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3133 (class 2606 OID 33171)
-- Name: notification notification_receiver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3120 (class 2606 OID 16598)
-- Name: retweet retweet_tweet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retweet
    ADD CONSTRAINT retweet_tweet_id_fkey FOREIGN KEY (tweet_id) REFERENCES public.tweet(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3121 (class 2606 OID 16603)
-- Name: retweet retweet_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retweet
    ADD CONSTRAINT retweet_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3114 (class 2606 OID 16552)
-- Name: tweet tweet_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tweet
    ADD CONSTRAINT tweet_author_id_fkey FOREIGN KEY (author_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3122 (class 2606 OID 16628)
-- Name: tweet_hashtag tweet_hashtag_hashtag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tweet_hashtag
    ADD CONSTRAINT tweet_hashtag_hashtag_id_fkey FOREIGN KEY (hashtag_id) REFERENCES public.hashtag(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3123 (class 2606 OID 16623)
-- Name: tweet_hashtag tweet_hashtag_tweet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tweet_hashtag
    ADD CONSTRAINT tweet_hashtag_tweet_id_fkey FOREIGN KEY (tweet_id) REFERENCES public.tweet(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3115 (class 2606 OID 33150)
-- Name: tweet tweet_parent_tweet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tweet
    ADD CONSTRAINT tweet_parent_tweet_id_fkey FOREIGN KEY (parent_tweet_id) REFERENCES public.tweet(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3292 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2023-04-06 06:21:22

--
-- PostgreSQL database dump complete
--

