--
-- PostgreSQL database dump
--

-- Dumped from database version 12.14 (Debian 12.14-1.pgdg110+1)
-- Dumped by pg_dump version 15.0

-- Started on 2023-03-27 12:40:43

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
-- TOC entry 7 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3114 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

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
-- TOC entry 3116 (class 0 OID 0)
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
-- TOC entry 3117 (class 0 OID 0)
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
-- TOC entry 3118 (class 0 OID 0)
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
-- TOC entry 3119 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE mention; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.mention IS 'Mention table';


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
-- TOC entry 3120 (class 0 OID 0)
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
-- TOC entry 3121 (class 0 OID 0)
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
-- TOC entry 3122 (class 0 OID 0)
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
-- TOC entry 3123 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE "user"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."user" IS 'User table';


--
-- TOC entry 3103 (class 0 OID 16557)
-- Dependencies: 214
-- Data for Name: follower; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.follower (id, user_id, follower_id) FROM stdin;
\.


--
-- TOC entry 3106 (class 0 OID 16608)
-- Dependencies: 217
-- Data for Name: hashtag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hashtag (id, text) FROM stdin;
\.


--
-- TOC entry 3104 (class 0 OID 16573)
-- Dependencies: 215
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
-- TOC entry 3108 (class 0 OID 16633)
-- Dependencies: 219
-- Data for Name: mention; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mention (id, user_id, tweet_id, created_at) FROM stdin;
\.


--
-- TOC entry 3105 (class 0 OID 16592)
-- Dependencies: 216
-- Data for Name: retweet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.retweet (user_id, tweet_id, created_at, id) FROM stdin;
\.


--
-- TOC entry 3102 (class 0 OID 16542)
-- Dependencies: 213
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
-- TOC entry 3107 (class 0 OID 16617)
-- Dependencies: 218
-- Data for Name: tweet_hashtag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tweet_hashtag (id, tweet_id, hashtag_id) FROM stdin;
\.


--
-- TOC entry 3101 (class 0 OID 16528)
-- Dependencies: 212
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, username, email, password, bio, profile_picture_url, website, location, created_at, name, premium, date_of_birth) FROM stdin;
1ce2b46d-c92c-4fd4-a1e3-b4d4e2074815	alice	alice@example.com	password1	'	\N	\N	\N	2023-03-25 12:33:35.914806+00	Alice	f	2001-02-01
48f7d933-aa75-422a-ae14-29eb8c880de1	david	david@example.com	password4	'	\N	\N	\N	2023-03-25 12:33:35.914806+00	David	f	2001-02-01
336bf68a-d72e-40ed-82ec-75a573e7ab78	charlie	charlie@example.com	password3	'	\N	\N	\N	2023-03-25 12:33:35.914806+00	Charlie	f	2001-02-01
2c13461f-7c04-4376-9f2e-15d2443a3a03	bob	bob@example.com	password2	'	\N	\N	\N	2023-03-25 12:33:35.914806+00	Bob	f	2001-02-01
\.


--
-- TOC entry 2951 (class 2606 OID 16562)
-- Name: follower follower_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follower
    ADD CONSTRAINT follower_pkey PRIMARY KEY (id);


--
-- TOC entry 2959 (class 2606 OID 16616)
-- Name: hashtag hashtag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hashtag
    ADD CONSTRAINT hashtag_pkey PRIMARY KEY (id);


--
-- TOC entry 2953 (class 2606 OID 16579)
-- Name: like like_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."like"
    ADD CONSTRAINT like_pkey PRIMARY KEY (id);


--
-- TOC entry 2963 (class 2606 OID 16639)
-- Name: mention mention_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mention
    ADD CONSTRAINT mention_pkey PRIMARY KEY (id);


--
-- TOC entry 2955 (class 2606 OID 16654)
-- Name: retweet retweet_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retweet
    ADD CONSTRAINT retweet_id_key UNIQUE (id);


--
-- TOC entry 2957 (class 2606 OID 16660)
-- Name: retweet retweet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retweet
    ADD CONSTRAINT retweet_pkey PRIMARY KEY (id);


--
-- TOC entry 2961 (class 2606 OID 16622)
-- Name: tweet_hashtag tweet_hashtag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tweet_hashtag
    ADD CONSTRAINT tweet_hashtag_pkey PRIMARY KEY (id);


--
-- TOC entry 2949 (class 2606 OID 16551)
-- Name: tweet tweet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tweet
    ADD CONSTRAINT tweet_pkey PRIMARY KEY (id);


--
-- TOC entry 2943 (class 2606 OID 16541)
-- Name: user user_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- TOC entry 2945 (class 2606 OID 16537)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 2947 (class 2606 OID 16539)
-- Name: user user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- TOC entry 2965 (class 2606 OID 16568)
-- Name: follower follower_follower_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follower
    ADD CONSTRAINT follower_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2966 (class 2606 OID 16563)
-- Name: follower follower_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follower
    ADD CONSTRAINT follower_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2967 (class 2606 OID 16585)
-- Name: like like_tweet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."like"
    ADD CONSTRAINT like_tweet_id_fkey FOREIGN KEY (tweet_id) REFERENCES public.tweet(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2968 (class 2606 OID 16580)
-- Name: like like_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."like"
    ADD CONSTRAINT like_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2973 (class 2606 OID 16645)
-- Name: mention mention_tweet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mention
    ADD CONSTRAINT mention_tweet_id_fkey FOREIGN KEY (tweet_id) REFERENCES public.tweet(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2974 (class 2606 OID 16640)
-- Name: mention mention_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mention
    ADD CONSTRAINT mention_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2969 (class 2606 OID 16598)
-- Name: retweet retweet_tweet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retweet
    ADD CONSTRAINT retweet_tweet_id_fkey FOREIGN KEY (tweet_id) REFERENCES public.tweet(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2970 (class 2606 OID 16603)
-- Name: retweet retweet_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retweet
    ADD CONSTRAINT retweet_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2964 (class 2606 OID 16552)
-- Name: tweet tweet_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tweet
    ADD CONSTRAINT tweet_author_id_fkey FOREIGN KEY (author_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2971 (class 2606 OID 16628)
-- Name: tweet_hashtag tweet_hashtag_hashtag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tweet_hashtag
    ADD CONSTRAINT tweet_hashtag_hashtag_id_fkey FOREIGN KEY (hashtag_id) REFERENCES public.hashtag(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2972 (class 2606 OID 16623)
-- Name: tweet_hashtag tweet_hashtag_tweet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tweet_hashtag
    ADD CONSTRAINT tweet_hashtag_tweet_id_fkey FOREIGN KEY (tweet_id) REFERENCES public.tweet(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3115 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2023-03-27 12:40:43

--
-- PostgreSQL database dump complete
--

