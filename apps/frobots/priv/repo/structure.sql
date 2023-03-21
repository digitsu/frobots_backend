--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2
-- Dumped by pg_dump version 14.4

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: battlelogs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.battlelogs (
    id bigint NOT NULL,
    winners integer[],
    qudos_pool integer,
    payouts integer[],
    odds double precision[],
    commission_paid integer,
    match_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: battlelogs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.battlelogs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: battlelogs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.battlelogs_id_seq OWNED BY public.battlelogs.id;


--
-- Name: frobots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.frobots (
    id bigint NOT NULL,
    name character varying(255),
    brain_code text,
    xp integer,
    class character varying(255),
    user_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: frobots_battlelogs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.frobots_battlelogs (
    id bigint NOT NULL,
    battlelog_id bigint,
    frobot_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: frobots_battlelogs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.frobots_battlelogs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: frobots_battlelogs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.frobots_battlelogs_id_seq OWNED BY public.frobots_battlelogs.id;


--
-- Name: frobots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.frobots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: frobots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.frobots_id_seq OWNED BY public.frobots.id;


--
-- Name: matches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.matches (
    id bigint NOT NULL,
    status character varying(255),
    match_template jsonb,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    frobots integer[]
);


--
-- Name: matches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.matches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: matches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.matches_id_seq OWNED BY public.matches.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(255),
    username character varying(255) NOT NULL,
    password_hash character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    admin boolean DEFAULT false,
    active boolean DEFAULT false
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: battlelogs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.battlelogs ALTER COLUMN id SET DEFAULT nextval('public.battlelogs_id_seq'::regclass);


--
-- Name: frobots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.frobots ALTER COLUMN id SET DEFAULT nextval('public.frobots_id_seq'::regclass);


--
-- Name: frobots_battlelogs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.frobots_battlelogs ALTER COLUMN id SET DEFAULT nextval('public.frobots_battlelogs_id_seq'::regclass);


--
-- Name: matches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matches ALTER COLUMN id SET DEFAULT nextval('public.matches_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: battlelogs battlelogs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.battlelogs
    ADD CONSTRAINT battlelogs_pkey PRIMARY KEY (id);


--
-- Name: frobots_battlelogs frobots_battlelogs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.frobots_battlelogs
    ADD CONSTRAINT frobots_battlelogs_pkey PRIMARY KEY (id);


--
-- Name: frobots frobots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.frobots
    ADD CONSTRAINT frobots_pkey PRIMARY KEY (id);


--
-- Name: matches matches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: battlelogs_match_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX battlelogs_match_id_index ON public.battlelogs USING btree (match_id);


--
-- Name: frobots_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX frobots_user_id_index ON public.frobots USING btree (user_id);


--
-- Name: users_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_name_index ON public.users USING btree (name);


--
-- Name: users_username_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_username_index ON public.users USING btree (username);


--
-- Name: battlelogs battlelogs_match_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.battlelogs
    ADD CONSTRAINT battlelogs_match_id_fkey FOREIGN KEY (match_id) REFERENCES public.matches(id);


--
-- Name: frobots_battlelogs frobots_battlelogs_battlelog_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.frobots_battlelogs
    ADD CONSTRAINT frobots_battlelogs_battlelog_id_fkey FOREIGN KEY (battlelog_id) REFERENCES public.battlelogs(id);


--
-- Name: frobots_battlelogs frobots_battlelogs_frobot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.frobots_battlelogs
    ADD CONSTRAINT frobots_battlelogs_frobot_id_fkey FOREIGN KEY (frobot_id) REFERENCES public.frobots(id);


--
-- Name: frobots frobots_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.frobots
    ADD CONSTRAINT frobots_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20220312041536);
INSERT INTO public."schema_migrations" (version) VALUES (20220312043043);
INSERT INTO public."schema_migrations" (version) VALUES (20220517075110);
INSERT INTO public."schema_migrations" (version) VALUES (20220602124455);
INSERT INTO public."schema_migrations" (version) VALUES (20220712171111);
INSERT INTO public."schema_migrations" (version) VALUES (20220715175743);
INSERT INTO public."schema_migrations" (version) VALUES (20220717142355);
INSERT INTO public."schema_migrations" (version) VALUES (20220728165937);
