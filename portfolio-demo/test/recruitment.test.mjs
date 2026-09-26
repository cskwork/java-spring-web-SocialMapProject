import { test, before } from 'node:test';
import assert from 'node:assert/strict';
import vm from 'node:vm';
import { build } from '../scripts/build.mjs';
import { dispatch } from '../src/dispatch.js';
import { render } from '../src/render.js';
import { runAction, validateProject } from '../src/actions.js';
import { seedState } from '../src/fixtures.js';
import { saveState, loadState } from '../src/store.js';
let T;
before(async()=>{build();T=await import(`../dist/app/templates.js?recruit=${Date.now()}`)});
const now=new Date('2026-09-26T10:00:00');
const run=(state,name,params={})=>runAction(name,{state,params,now});
const login=(s,id)=>run(s,'Login',{check:'0',id,pwd:'demo'}).state;
const draw=(state,name,params={})=>{const o=dispatch(name,params,{state,now,routes:T.ROUTES,mainpages:T.MAINPAGES});return render(T.TEMPLATES[o.jsp].template,o.model,o.state.session)};

test('신청 → 계정 전환 → 수락 → 저장 재로드 → 양쪽 내 프로젝트 인원이 일치한다',()=>{
 let s=login(seedState(),'member01');
 s=run(s,'ProjHopeMsg',{getid:'leader01'}).state;
 const hope=s.hopelist.find(h=>h.sendid==='member01');
 const storage=new Map();const adapter={setItem:(k,v)=>storage.set(k,v),getItem:k=>storage.get(k)??null,removeItem:k=>storage.delete(k)};
 saveState(adapter,s); s=loadState(adapter).state;
 s=login(s,'leader01');
 s=run(s,'insertTeam',{no:String(hope.no),id:'member01',leaderid:'leader01'}).state;
 assert.equal(s.member.find(m=>m.id==='member01').teamno1,'1');
 const project=s.projectteam.find(p=>p.teamno==='1');
 assert.deepEqual([project.currmem,project.recmem],['3','1']);
 assert.match(draw(s,'MyProjList'),/3명 \/ 추가 1명/);
 saveState(adapter,s);s=login(loadState(adapter).state,'member01');
 assert.match(draw(s,'MyProjList'),/캠퍼스 스터디 매칭 앱/);
 assert.match(draw(s,'MyProjList'),/3명 \/ 추가 1명/);
 const blocked=run(s,'ProjHopeMsg',{getid:'leader03'});
 assert.match(blocked.alert,/2개 이상/);
 assert.equal(blocked.state,s);
});

test('중복·없는 프로젝트·수락 권한 실패는 상태를 바꾸지 않고 적절한 화면으로 돌아간다',()=>{
 let s=login(seedState(),'member01');
 const missing=run(s,'ProjHopeMsg',{getid:'absent'});
 assert.equal(missing.redirect.action,'ProjList');assert.equal(missing.state,s);
 s=run(s,'ProjHopeMsg',{getid:'leader01'}).state;
 const repeat=run(s,'ProjHopeMsg',{getid:'leader01'});
 assert.equal(repeat.redirect.action,'ProjInfo');assert.equal(repeat.state,s);assert.match(repeat.alert,/이미 참여/);
 const denied=run(s,'insertTeam',{no:'1',id:'member03',leaderid:'leader01'});
 assert.match(denied.alert,/처리할 수 없는/);assert.equal(denied.state,s);
});

test('원본 등록/수정 JSP validation을 실행해 어댑터와 같은 실패를 차단한다',()=>{
 const page=T.TEMPLATES['content/project/write.jsp'];
 const codes=page.headScripts.map(x=>render(x,{})).join('\n');
 const fields={title:'새 팀',cont:'설명',recmem:'2',sal:'',startdate:'2026-10-01',enddate:'2026-10-31'};
 const check=(overrides)=>{
  const values={...fields,...overrides};let message='';let focused='';
  const form=Object.fromEntries(Object.entries(values).map(([k,value])=>[k,{value,focus(){focused=k}}]));
  const ctx={document:{userinput:form},alert:x=>{message=x},window:{}};
  vm.createContext(ctx);vm.runInContext(codes,ctx);
  const valid=ctx.validation();
  return {valid,message,focused,values};
 };
 for(const input of [{recmem:'0'},{recmem:'100'},{recmem:'1.5'},{recmem:'abc'},{sal:'paid'},{sal:'1000000'},{enddate:'2026-09-30'},{title:'   '},{cont:' '}]){
  const r=check(input);assert.equal(r.valid,false,JSON.stringify(input));assert.equal(r.message,validateProject(Object.fromEntries(Object.entries(r.values).map(([k,v])=>[k,v.trim()]))));
 }
 assert.equal(check({recmem:'99',sal:'0'}).valid,true);
 assert.equal(check({sal:''}).valid,true);
});

test('잘못된 수정은 입력값과 기존 인원을 보존한다',()=>{
 const s=login(seedState(),'leader01');
 const original=s.projectteam.find(p=>p.teamno==='1');
 const out=run(s,'ProjModify',{...original,step:'1',title:'수정 중',recmem:'0'});
 assert.equal(out.state,s);assert.equal(out.model.resultClass.title,'수정 중');assert.equal(out.model.resultClass.recmem,'0');
 assert.equal(s.projectteam.find(p=>p.teamno==='1').title,original.title);
 assert.match(out.alert,/1~99/);
});
