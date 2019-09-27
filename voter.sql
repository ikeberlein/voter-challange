--
-- PostgreSQL database dump
--

-- Dumped from database version 9.1.24lts2
-- Dumped by pg_dump version 9.5.0

-- Started on 2019-09-27 12:42:25 MSK

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 164 (class 3079 OID 11645)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 1885 (class 0 OID 0)
-- Dependencies: 164
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 162 (class 1259 OID 290428)
-- Name: users; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying(64) NOT NULL,
    password character varying(64) NOT NULL,
    auth_key character varying(64),
    access_token character varying(64),
    gender character(1) DEFAULT 'M'::bpchar NOT NULL,
    age integer DEFAULT 28 NOT NULL,
    lookfor_gender character(1) DEFAULT 'F'::bpchar NOT NULL,
    lookfor_age_from integer DEFAULT 18 NOT NULL,
    lookfor_age_to integer DEFAULT 85 NOT NULL
);


ALTER TABLE users OWNER TO developer;

--
-- TOC entry 161 (class 1259 OID 290426)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO developer;

--
-- TOC entry 1886 (class 0 OID 0)
-- Dependencies: 161
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- TOC entry 163 (class 1259 OID 298617)
-- Name: votes; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE votes (
    user_id integer NOT NULL,
    candidate_user_id integer NOT NULL,
    vote character(1) NOT NULL,
    CONSTRAINT check_vote CHECK ((vote = ANY (ARRAY['L'::bpchar, 'D'::bpchar])))
);


ALTER TABLE votes OWNER TO developer;

--
-- TOC entry 1755 (class 2604 OID 290431)
-- Name: id; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- TOC entry 1876 (class 0 OID 290428)
-- Dependencies: 162
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: developer
--

COPY users (id, username, password, auth_key, access_token, gender, age, lookfor_gender, lookfor_age_from, lookfor_age_to) FROM stdin;
3	peter	peter	peter-key	peter-token	M	28	F	18	85
5	john	john	john-key	john-token	M	28	F	18	85
7	antony	antony	antony-key	antony-token	M	28	F	18	85
1	admin	admin	test100key	token01	M	28	F	18	85
4	nikolas	nikolas	nikolas-key	nikolas-token	F	28	M	18	85
6	mike	mike	mike-key	mike-token	F	28	M	18	85
2	user01	user01	test200key	token02	F	28	M	18	85
\.


--
-- TOC entry 1887 (class 0 OID 0)
-- Dependencies: 161
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: developer
--

SELECT pg_catalog.setval('users_id_seq', 7, true);


--
-- TOC entry 1877 (class 0 OID 298617)
-- Dependencies: 163
-- Data for Name: votes; Type: TABLE DATA; Schema: public; Owner: developer
--

COPY votes (user_id, candidate_user_id, vote) FROM stdin;
1	4	L
1	2	D
\.


--
-- TOC entry 1763 (class 2606 OID 298651)
-- Name: users_access_token_key; Type: CONSTRAINT; Schema: public; Owner: developer
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_access_token_key UNIQUE (access_token);


--
-- TOC entry 1765 (class 2606 OID 298649)
-- Name: users_auth_key_key; Type: CONSTRAINT; Schema: public; Owner: developer
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_auth_key_key UNIQUE (auth_key);


--
-- TOC entry 1767 (class 2606 OID 290435)
-- Name: users_login_key; Type: CONSTRAINT; Schema: public; Owner: developer
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_login_key UNIQUE (username);


--
-- TOC entry 1769 (class 2606 OID 290433)
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: developer
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 1771 (class 2606 OID 298621)
-- Name: votes_pkey; Type: CONSTRAINT; Schema: public; Owner: developer
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (user_id, candidate_user_id);


--
-- TOC entry 1772 (class 2606 OID 298622)
-- Name: votes_candidate_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: developer
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_candidate_user_id_fkey FOREIGN KEY (candidate_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 1773 (class 2606 OID 298627)
-- Name: votes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: developer
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 1884 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2019-09-27 12:42:25 MSK

--
-- PostgreSQL database dump complete
--

