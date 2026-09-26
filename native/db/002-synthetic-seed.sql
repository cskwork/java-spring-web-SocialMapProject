-- All identities are synthetic. Passwords deliberately cannot authenticate until reset.
INSERT INTO member(id,pwd,name,email,auth) VALUES('admin','RESET_REQUIRED','Synthetic admin','admin@example.invalid','0');
INSERT INTO member(id,pwd,name,email,auth) VALUES('leader01','RESET_REQUIRED','Synthetic leader','leader01@example.invalid','1');
INSERT INTO member(id,pwd,name,email,auth) VALUES('member01','RESET_REQUIRED','Synthetic member','member01@example.invalid','2');
INSERT INTO member(id,pwd,name,email,auth) VALUES('member02','RESET_REQUIRED','Synthetic colleague','member02@example.invalid','2');
INSERT INTO major VALUES(1,'Software engineering');
INSERT INTO projectteam(teamno,leaderid,title,recmem,currmem,cont,status) VALUES(1,'leader01','Synthetic campus project',2,1,'Local development fixture','recruiting');
UPDATE member SET teamno1=1 WHERE id='leader01';
INSERT INTO competition(no,title,cont,hits) VALUES(1,'Synthetic challenge','Local fixture competition',0);
INSERT INTO custservice(no,custlog,title,cont,hits) VALUES(1,0,'Local development','All records in this schema are synthetic.',0);
INSERT INTO custservice(no,custlog,title,cont,hits) VALUES(2,1,'How to join','Apply, switch synthetic account, accept.',0);
COMMIT;
