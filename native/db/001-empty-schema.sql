-- Oracle empty, isolated development schema ONLY. Derived from src/sql mappings.
-- Never apply to an existing deployment. New lifecycle/history/reset columns are compatibility additions.
CREATE TABLE member (id VARCHAR2(24) PRIMARY KEY, pwd VARCHAR2(255) NOT NULL, name VARCHAR2(100) NOT NULL, gen VARCHAR2(8), birth VARCHAR2(16), email VARCHAR2(254) NOT NULL, auth VARCHAR2(1) NOT NULL CHECK(auth IN ('0','1','2')), teamno1 NUMBER, teamno2 NUMBER, teamno3 NUMBER, addr VARCHAR2(500), maj VARCHAR2(500), exp VARCHAR2(2000));
CREATE TABLE projectteam (teamno NUMBER PRIMARY KEY, leaderid VARCHAR2(24) NOT NULL, title VARCHAR2(100) NOT NULL, comp VARCHAR2(100), startdate DATE, enddate DATE, recmem NUMBER DEFAULT 1 NOT NULL CHECK(recmem BETWEEN 0 AND 99), currmem NUMBER DEFAULT 1 NOT NULL CHECK(currmem>=1), maj VARCHAR2(500), cont VARCHAR2(4000), loc VARCHAR2(100), sal NUMBER DEFAULT 0 CHECK(sal>=0), status VARCHAR2(16) DEFAULT 'recruiting' NOT NULL CHECK(status IN ('recruiting','closed','completed','released')), CHECK(enddate>=startdate));
CREATE UNIQUE INDEX one_active_leader ON projectteam(CASE WHEN status IN ('recruiting','closed') THEN leaderid ELSE NULL END);
ALTER TABLE member ADD CONSTRAINT member_team_fk FOREIGN KEY(teamno1) REFERENCES projectteam(teamno);
CREATE TABLE specreg (id VARCHAR2(24) PRIMARY KEY REFERENCES member(id), regdate TIMESTAMP, exp VARCHAR2(2000), maj VARCHAR2(500), addr VARCHAR2(500), contadd VARCHAR2(4000), showlog NUMBER CHECK(showlog IN (0,1)));
CREATE TABLE competition (no NUMBER PRIMARY KEY, title VARCHAR2(100) NOT NULL, startdate DATE, regdate DATE, enddate DATE, cont VARCHAR2(4000), contadd VARCHAR2(2000), showlog NUMBER DEFAULT 1, hits NUMBER DEFAULT 0, img VARCHAR2(100), CHECK(enddate>=startdate));
CREATE TABLE major (major_no NUMBER PRIMARY KEY, major_name VARCHAR2(100) NOT NULL);
CREATE TABLE favoritelist (artlog NUMBER NOT NULL CHECK(artlog IN (0,1)), teamno NUMBER, id VARCHAR2(24), leaderid VARCHAR2(24));
CREATE UNIQUE INDEX favorite_project_unique ON favoritelist(CASE WHEN artlog=0 THEN teamno END,CASE WHEN artlog=0 THEN id END);
CREATE UNIQUE INDEX favorite_spec_unique ON favoritelist(CASE WHEN artlog=1 THEN id END,CASE WHEN artlog=1 THEN leaderid END);
CREATE TABLE hopelist (no NUMBER PRIMARY KEY, sendid VARCHAR2(24) NOT NULL REFERENCES member(id), getid VARCHAR2(24) NOT NULL REFERENCES member(id), regdate TIMESTAMP, log NUMBER CHECK(log IN (0,1)), UNIQUE(sendid,getid), CHECK(sendid<>getid));
CREATE TABLE msg (no NUMBER PRIMARY KEY, sendid VARCHAR2(24) NOT NULL, getid VARCHAR2(24) NOT NULL, title VARCHAR2(100) NOT NULL, cont VARCHAR2(2000) NOT NULL, sendtime TIMESTAMP, read_at TIMESTAMP);
CREATE TABLE message_deleted (no NUMBER REFERENCES msg(no), id VARCHAR2(24), PRIMARY KEY(no,id));
CREATE TABLE qna (no NUMBER NOT NULL, qalog NUMBER DEFAULT 0 CHECK(qalog IN (0,1)), id VARCHAR2(24), title VARCHAR2(100), cont VARCHAR2(4000), regdate TIMESTAMP, PRIMARY KEY(no,qalog));
CREATE TABLE custservice (no NUMBER PRIMARY KEY, custlog NUMBER CHECK(custlog IN (0,1)), title VARCHAR2(100), cont VARCHAR2(4000), regdate TIMESTAMP, hits NUMBER DEFAULT 0);
CREATE TABLE project_history (teamno NUMBER REFERENCES projectteam(teamno), id VARCHAR2(24), PRIMARY KEY(teamno,id));
CREATE TABLE rating (sendid VARCHAR2(24), getid VARCHAR2(24), rate NUMBER CHECK(rate BETWEEN 1 AND 5), teamexp NUMBER REFERENCES projectteam(teamno), ratingregdate TIMESTAMP, reputation VARCHAR2(2000), PRIMARY KEY(sendid,getid,teamexp), CHECK(sendid<>getid));
CREATE TABLE password_reset (id VARCHAR2(24) PRIMARY KEY REFERENCES member(id), token_hash VARCHAR2(64) UNIQUE NOT NULL, expires_at TIMESTAMP NOT NULL);
CREATE TABLE local_outbox (id VARCHAR2(24), token VARCHAR2(64) NOT NULL, created_at TIMESTAMP);
CREATE SEQUENCE projectteam_seq START WITH 100;
CREATE SEQUENCE competition_seq START WITH 100;
CREATE SEQUENCE hopelist_seq START WITH 100;
CREATE SEQUENCE qna_seq START WITH 100;
CREATE SEQUENCE custservice_seq START WITH 100;
CREATE SEQUENCE msg_seq START WITH 100;
