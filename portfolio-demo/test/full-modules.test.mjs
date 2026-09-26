import {test,before} from 'node:test';
import assert from 'node:assert/strict';
import {runAction,UNAVAILABLE} from '../src/actions.js';
import {seedState} from '../src/fixtures.js';
import {loadState,saveState,resetState} from '../src/store.js';
import {dispatch} from '../src/dispatch.js';
import {render} from '../src/render.js';
import {build} from '../scripts/build.mjs';
const now=new Date('2026-09-26T10:00:00Z');
const run=(state,name,params={})=>runAction(name,{state,params,now});
const login=(state,id)=>run(state,'Login',{id,pwd:'demo',check:1}).state;
let templates;
before(async()=>{build();templates=await import('../dist/app/templates.js');});
test('all original actions have operational adapters, no core menu unavailable',()=>assert.deepEqual(UNAVAILABLE,{}));
test('signup rejects privileged role, duplicate and invalid data; valid signup logs in',()=>{
 let s=seedState(),p={step:1,id:'newuser',pwd:'password88',name:'가상회원',email:'new@example.invalid',auth:'2'};
 assert.ok(run(s,'SignUp',{...p,auth:'0'}).alert);assert.equal(run(s,'SignUp',{...p,pwd:'tiny'}).mutated,undefined);
 s=run(s,'SignUp',p).state;assert.equal(s.member.filter(m=>m.id==='newuser').length,1);assert.ok(run(s,'SignUp',p).alert);
 assert.equal(run(s,'Login',{id:'newuser',pwd:'password88',check:1}).state.session.id,'newuser');
});
test('reset token is one use, expires, and changes password without revealing it',()=>{
 let s=run(seedState(),'Find',{step:1,id:'member01',email:'member01@example.invalid'}).state;
 assert.equal(s.outbox.length,1);assert.ok(!('pwd' in s.outbox[0]));let token=s.outbox[0].token;
 let bad=run(s,'ResetPassword',{token:'forged',pwd:'newpassword'});assert.equal(bad.state,s);
 s=run(s,'ResetPassword',{token,pwd:'newpassword'}).state;assert.equal(run(s,'Login',{id:'member01',pwd:'newpassword',check:1}).state.session.id,'member01');assert.equal(run(s,'ResetPassword',{token,pwd:'secondpassword'}).mutated,false);
 let e=run(seedState(),'Find',{step:1,id:'member01',email:'member01@example.invalid'}).state;e.outbox[0].expires=0;assert.equal(run(e,'ResetPassword',{token:e.outbox[0].token,pwd:'newpassword'}).state,e);
});
test('session expiration persists logout; reset clears all new module state',()=>{
 let s=login(seedState(),'member01');s.session.expiresAt=0; // explicit expiration action also models immediate timeout
 s=run(s,'SessionExpire').state;assert.deepEqual(s.session,{});
 const memory=new Map(),storage={getItem:k=>memory.get(k),setItem:(k,v)=>memory.set(k,v),removeItem:k=>memory.delete(k)};
 s=login(s,'member01');s=run(s,'MsgWrite',{step:1,getid:'leader01',title:'저장 확인',cont:'가상 쪽지'}).state;saveState(storage,s);assert.equal(loadState(storage).state.msg.length,1);assert.equal(resetState(storage).member.length,seedState().member.length);assert.equal(memory.size,0);
});
test('message sender forced to session; ownership, read and per-user delete preserved',()=>{
 let s=login(seedState(),'member01');s=run(s,'MsgWrite',{step:1,sendid:'admin',getid:'leader01',title:'안녕하세요',cont:'프로젝트 문의'}).state;
 assert.equal(s.msg[0].sendid,'member01');const no=s.msg[0].no;assert.equal(run(s,'MsgList',{box:'sent'}).model.list.length,1);
 let other=login(s,'leader02');assert.equal(run(other,'MsgInfo',{no}).state,other);assert.equal(run(other,'MsgDelete',{no}).state,other);
 s=login(s,'leader01');s=run(s,'MsgInfo',{no}).state;assert.equal(s.msg[0].read,true);s=run(s,'MsgDelete',{no}).state;assert.equal(run(s,'MsgList').model.list.length,0);s=login(s,'member01');assert.equal(run(s,'MsgList',{box:'sent'}).model.list.length,1);
 assert.equal(run(s,'MsgWrite',{step:1,getid:'missing',title:'x',cont:'y'}).state,s);
});
test('completion releases members, keeps immutable eligibility and prevents invalid ratings',()=>{
 let s=login(seedState(),'leader01');let denied=run(login(s,'member01'),'ProjLifecycle',{teamno:1,status:'completed'});assert.equal(denied.mutated,false);
 s=run(s,'ProjLifecycle',{teamno:1,status:'closed'}).state;assert.equal(s.projectteam[0].status,'closed');assert.ok(run(login(s,'member01'),'ProjHopeMsg',{getid:'leader01'}).alert);
 s=run(s,'ProjLifecycle',{teamno:1,status:'completed'}).state;assert.equal(s.member.find(m=>m.id==='member05').teamno1,null);assert.equal(s.completed[0].members.length,2);
 assert.ok(run(s,'RatingWrite',{step:1,teamno:1,getid:'leader01',score:5}).alert);assert.ok(run(s,'RatingWrite',{step:1,teamno:1,getid:'member01',score:5}).alert);assert.ok(run(s,'RatingWrite',{step:1,teamno:1,getid:'member05',score:6}).alert);
 s=run(s,'RatingWrite',{step:1,teamno:1,getid:'member05',score:5,cont:'협업했습니다.'}).state;assert.equal(s.rating.length,1);assert.ok(run(s,'RatingWrite',{step:1,teamno:1,getid:'member05',score:5}).alert);
});
test('all three admin publications support create edit delete and reject unsafe fixture uploads',()=>{
 for(const prefix of ['Comp','AS','FAQ']){
 let s=login(seedState(),'member01');assert.equal(run(s,prefix+'Write',{step:1,title:'x',cont:'y'}).state,s);
 s=login(s,'admin');const table=prefix==='Comp'?'competition':'custservice',before=s[table].length;
 assert.equal(run(s,prefix+'Write',{step:1,title:'x',cont:'y',upload:'../../secret'}).state,s);
 s=run(s,prefix+'Write',{step:1,title:'합성 관리 항목',cont:'본문',upload:'fixture-poster.svg'}).state;assert.equal(s[table].length,before+1);const no=s[table].at(-1).no;
 s=run(s,prefix+'Modify',{step:1,no,title:'수정 항목',cont:'수정 본문'}).state;assert.equal(s[table].find(x=>x.no===no).title,'수정 항목');s=run(s,prefix+'Delete',{no}).state;assert.equal(s[table].length,before);
 }
});
test('private questions cannot leak by search/detail, admins can answer then owner sees it',()=>{
 let s=login(seedState(),'member01');assert.ok(run(s,'QnaList',{search:''}).model.list.every(q=>q.id==='member01'));assert.equal(run(s,'QnaInfo',{no:2}).mutated,false);
 assert.equal(run(s,'QnaAdminWrite',{step:1,no:1,cont:'위조 답변'}).state,s);
 s=login(s,'admin');s=run(s,'QnaAdminWrite',{step:1,no:3,title:'답변',cont:'관리자 답변'}).state;s.session={id:'member07',auth:'2'};assert.equal(run(s,'QnaInfo',{no:3}).model.resultClass2.cont,'관리자 답변');
});
test('withdrawal requires fresh reauth and preserves another account with same password',()=>{
 let s=login(seedState(),'member01');assert.equal(run(s,'deleteMember').state,s);assert.equal(run(s,'checkPwd',{pwd:'wrong'}).state,s);s=run(s,'checkPwd',{pwd:'demo'}).state;s=run(s,'deleteMember').state;assert.ok(!s.member.some(m=>m.id==='member01'));assert.ok(s.member.some(m=>m.id==='member02'));assert.deepEqual(s.session,{});
 s=login(seedState(),'leader01');s=run(s,'checkPwd',{pwd:'demo'}).state;assert.equal(run(s,'deleteMember').state,s);
});
test('new workflows produce actionable HTML from actual EUC-KR JSP/Tiles sources',()=>{
 for(const [action,id,params,needle] of [['SignUp',null,{},'name="auth"'],['Find',null,{},'ResetPassword'],['MsgWrite','member01',{},'name="getid"'],['RatingWrite','member01',{teamno:1},'name="score"'],['deleteMemberForm','member01',{},'checkPwd'],['CompWrite','admin',{},'#/CompWrite.action'],['ASWrite','admin',{},'#/ASWrite.action'],['FAQWrite','admin',{},'#/FAQWrite.action'],['AdminHome','admin',{},'QnaList']]){
 const state=id?login(seedState(),id):seedState();const out=dispatch(action,params,{state,now,routes:templates.ROUTES,mainpages:templates.MAINPAGES});assert.equal(out.kind,'page',action);const html=render(templates.TEMPLATES[out.jsp].template,out.model,out.state.session);assert.ok(html.includes(needle),action+' missing '+needle);assert.doesNotMatch(html,/aria-disabled="true"/);
 }
});
