--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: survey; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA survey;


SET search_path = public, pg_catalog;

--
-- Name: ghstore; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE ghstore;


--
-- Name: ghstore_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ghstore_in(cstring) RETURNS ghstore
    LANGUAGE c STRICT
    AS '$libdir/hstore', 'ghstore_in';


--
-- Name: ghstore_out(ghstore); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ghstore_out(ghstore) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/hstore', 'ghstore_out';


--
-- Name: ghstore; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE ghstore (
    INTERNALLENGTH = variable,
    INPUT = ghstore_in,
    OUTPUT = ghstore_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


--
-- Name: hstore; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE hstore;


--
-- Name: hstore_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION hstore_in(cstring) RETURNS hstore
    LANGUAGE c STRICT
    AS '$libdir/hstore', 'hstore_in';


--
-- Name: hstore_out(hstore); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION hstore_out(hstore) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/hstore', 'hstore_out';


--
-- Name: hstore; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE hstore (
    INTERNALLENGTH = variable,
    INPUT = hstore_in,
    OUTPUT = hstore_out,
    ALIGNMENT = int4,
    STORAGE = extended
);


--
-- Name: akeys(hstore); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION akeys(hstore) RETURNS text[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'akeys';


--
-- Name: avals(hstore); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION avals(hstore) RETURNS text[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'avals';


--
-- Name: defined(hstore, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION defined(hstore, text) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'defined';


--
-- Name: delete(hstore, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION delete(hstore, text) RETURNS hstore
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'delete';


--
-- Name: each(hstore); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION each(hs hstore, OUT key text, OUT value text) RETURNS SETOF record
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'each';


--
-- Name: exist(hstore, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION exist(hstore, text) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'exists';


--
-- Name: fetchval(hstore, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fetchval(hstore, text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'fetchval';


--
-- Name: ghstore_compress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ghstore_compress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'ghstore_compress';


--
-- Name: ghstore_consistent(internal, internal, integer, oid, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ghstore_consistent(internal, internal, integer, oid, internal) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'ghstore_consistent';


--
-- Name: ghstore_decompress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ghstore_decompress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'ghstore_decompress';


--
-- Name: ghstore_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ghstore_penalty(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'ghstore_penalty';


--
-- Name: ghstore_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ghstore_picksplit(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'ghstore_picksplit';


--
-- Name: ghstore_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ghstore_same(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'ghstore_same';


--
-- Name: ghstore_union(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ghstore_union(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'ghstore_union';


--
-- Name: gin_consistent_hstore(internal, smallint, internal, integer, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION gin_consistent_hstore(internal, smallint, internal, integer, internal, internal) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'gin_consistent_hstore';


--
-- Name: gin_extract_hstore(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION gin_extract_hstore(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'gin_extract_hstore';


--
-- Name: gin_extract_hstore_query(internal, internal, smallint, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION gin_extract_hstore_query(internal, internal, smallint, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'gin_extract_hstore_query';


--
-- Name: hs_concat(hstore, hstore); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION hs_concat(hstore, hstore) RETURNS hstore
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'hs_concat';


--
-- Name: hs_contained(hstore, hstore); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION hs_contained(hstore, hstore) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'hs_contained';


--
-- Name: hs_contains(hstore, hstore); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION hs_contains(hstore, hstore) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'hs_contains';


--
-- Name: isdefined(hstore, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isdefined(hstore, text) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'defined';


--
-- Name: isexists(hstore, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isexists(hstore, text) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'exists';


--
-- Name: skeys(hstore); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION skeys(hstore) RETURNS SETOF text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'skeys';


--
-- Name: svals(hstore); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION svals(hstore) RETURNS SETOF text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'svals';


--
-- Name: tconvert(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION tconvert(text, text) RETURNS hstore
    LANGUAGE c IMMUTABLE
    AS '$libdir/hstore', 'tconvert';


--
-- Name: ->; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR -> (
    PROCEDURE = fetchval,
    LEFTARG = hstore,
    RIGHTARG = text
);


--
-- Name: <@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR <@ (
    PROCEDURE = hs_contained,
    LEFTARG = hstore,
    RIGHTARG = hstore,
    COMMUTATOR = @>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: =>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR => (
    PROCEDURE = tconvert,
    LEFTARG = text,
    RIGHTARG = text
);


--
-- Name: ?; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ? (
    PROCEDURE = exist,
    LEFTARG = hstore,
    RIGHTARG = text,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: @; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR @ (
    PROCEDURE = hs_contains,
    LEFTARG = hstore,
    RIGHTARG = hstore,
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: @>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR @> (
    PROCEDURE = hs_contains,
    LEFTARG = hstore,
    RIGHTARG = hstore,
    COMMUTATOR = <@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: ||; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR || (
    PROCEDURE = hs_concat,
    LEFTARG = hstore,
    RIGHTARG = hstore
);


--
-- Name: ~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ~ (
    PROCEDURE = hs_contained,
    LEFTARG = hstore,
    RIGHTARG = hstore,
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: gin_hstore_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS gin_hstore_ops
    DEFAULT FOR TYPE hstore USING gin AS
    STORAGE text ,
    OPERATOR 7 @>(hstore,hstore) ,
    OPERATOR 9 ?(hstore,text) ,
    FUNCTION 1 bttextcmp(text,text) ,
    FUNCTION 2 gin_extract_hstore(internal,internal) ,
    FUNCTION 3 gin_extract_hstore_query(internal,internal,smallint,internal,internal) ,
    FUNCTION 4 gin_consistent_hstore(internal,smallint,internal,integer,internal,internal);


--
-- Name: gist_hstore_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS gist_hstore_ops
    DEFAULT FOR TYPE hstore USING gist AS
    STORAGE ghstore ,
    OPERATOR 7 @>(hstore,hstore) ,
    OPERATOR 9 ?(hstore,text) ,
    OPERATOR 13 @(hstore,hstore) ,
    FUNCTION 1 ghstore_consistent(internal,internal,integer,oid,internal) ,
    FUNCTION 2 ghstore_union(internal,internal) ,
    FUNCTION 3 ghstore_compress(internal) ,
    FUNCTION 4 ghstore_decompress(internal) ,
    FUNCTION 5 ghstore_penalty(internal,internal,internal) ,
    FUNCTION 6 ghstore_picksplit(internal,internal) ,
    FUNCTION 7 ghstore_same(internal,internal,internal);


SET search_path = survey, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: public_data; Type: TABLE; Schema: survey; Owner: -; Tablespace: 
--

CREATE TABLE public_data (
    sn uuid NOT NULL,
    start_time timestamp without time zone NOT NULL,
    finish_time timestamp without time zone NOT NULL,
    cookie uuid,
    ip cidr DEFAULT '0.0.0.0/32'::cidr NOT NULL,
    p_1 character varying(32),
    p_2 character varying(128),
    p_3 integer,
    p_4 integer,
    p_5 integer,
    p_6 integer,
    p_7 integer[],
    p_8 integer
);


--
-- Name: TABLE public_data; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON TABLE public_data IS '公众调查数据表';


--
-- Name: COLUMN public_data.start_time; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN public_data.start_time IS '开始进入调查时间';


--
-- Name: COLUMN public_data.finish_time; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN public_data.finish_time IS '完成调查时间';


--
-- Name: COLUMN public_data.cookie; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN public_data.cookie IS '用户cookie编号';


--
-- Name: COLUMN public_data.ip; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN public_data.ip IS '用户IP地址';


--
-- Name: COLUMN public_data.p_1; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN public_data.p_1 IS '用户姓名';


--
-- Name: COLUMN public_data.p_2; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN public_data.p_2 IS 'Email地址';


--
-- Name: COLUMN public_data.p_3; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN public_data.p_3 IS '性别 1＝男 2＝女';


--
-- Name: COLUMN public_data.p_4; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN public_data.p_4 IS '你玩过网络游戏吗 1=是 2=否';


--
-- Name: COLUMN public_data.p_5; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN public_data.p_5 IS '你玩过多长时间游戏了 1=半年 2=半年到1年 3=1年到3年 4=3年以上';


--
-- Name: COLUMN public_data.p_6; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN public_data.p_6 IS '你是男人吗 1=是 2=否';


--
-- Name: COLUMN public_data.p_7; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN public_data.p_7 IS '你是女人吗 1=是 2=否 3=不清楚';


--
-- Name: COLUMN public_data.p_8; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN public_data.p_8 IS '是否盛大用户 1=是 2＝否';


--
-- Name: user_data; Type: TABLE; Schema: survey; Owner: -; Tablespace: 
--

CREATE TABLE user_data (
    sn uuid NOT NULL,
    start_time timestamp without time zone NOT NULL,
    finish_time timestamp without time zone NOT NULL,
    cookie uuid,
    ip cidr DEFAULT '0.0.0.0/32'::cidr NOT NULL,
    s_1 integer[],
    s_2a integer,
    s_2b integer,
    s_2c integer,
    s_2d integer,
    s_2e integer,
    snda_id character varying(32)
);


--
-- Name: TABLE user_data; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON TABLE user_data IS '用户调查数据表';


--
-- Name: COLUMN user_data.start_time; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN user_data.start_time IS '开始进入调查时间';


--
-- Name: COLUMN user_data.finish_time; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN user_data.finish_time IS '完成调查时间';


--
-- Name: COLUMN user_data.cookie; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN user_data.cookie IS '用户cookie编号';


--
-- Name: COLUMN user_data.ip; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN user_data.ip IS '用户IP地址';


--
-- Name: COLUMN user_data.s_1; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN user_data.s_1 IS '你玩过哪些游戏 1=传奇 2=传世 3=冒险岛 4=霸王大陆 5=魔兽世界';


--
-- Name: COLUMN user_data.s_2a; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN user_data.s_2a IS '题目s2选项a的得分';


--
-- Name: COLUMN user_data.s_2b; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN user_data.s_2b IS '题目s2选项b的得分';


--
-- Name: COLUMN user_data.s_2c; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN user_data.s_2c IS '题目s2选项c的得分';


--
-- Name: COLUMN user_data.s_2d; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN user_data.s_2d IS '题目s2选项d的得分';


--
-- Name: COLUMN user_data.s_2e; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN user_data.s_2e IS '题目s2选项e的得分';


--
-- Name: COLUMN user_data.snda_id; Type: COMMENT; Schema: survey; Owner: -
--

COMMENT ON COLUMN user_data.snda_id IS '盛大帐号ID';


--
-- Name: user_data_s14_seq; Type: SEQUENCE; Schema: survey; Owner: -
--

CREATE SEQUENCE user_data_s14_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: user_data_s14_seq; Type: SEQUENCE OWNED BY; Schema: survey; Owner: -
--

ALTER SEQUENCE user_data_s14_seq OWNED BY user_data.s_2d;


--
-- Name: user_data_s15_seq; Type: SEQUENCE; Schema: survey; Owner: -
--

CREATE SEQUENCE user_data_s15_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: user_data_s15_seq; Type: SEQUENCE OWNED BY; Schema: survey; Owner: -
--

ALTER SEQUENCE user_data_s15_seq OWNED BY user_data.s_2e;


--
-- Name: public_data_pkey; Type: CONSTRAINT; Schema: survey; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public_data
    ADD CONSTRAINT public_data_pkey PRIMARY KEY (sn);


--
-- Name: user_data_pkey; Type: CONSTRAINT; Schema: survey; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_data
    ADD CONSTRAINT user_data_pkey PRIMARY KEY (sn);


--
-- PostgreSQL database dump complete
--

