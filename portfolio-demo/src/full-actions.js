// Compatibility workflows extend the original action names and table-shaped state.
const str = v => String(Array.isArray(v) ? v[0] : v ?? '').trim();
const back = (action, alert, mutated=false) => ({redirect:{action,params:[]},alert,mutated});
const model = (c, mainpage, extra={}) => ({model:{...c.state.session,mainpage,...extra}});
const user = c => c.state.member.find(x=>x.id===c.state.session.id);
const admin = c => c.state.session.auth==='0';
const next = (s,t) => { s.seq[t] ||= 1; return s.seq[t]++; };
export function migrate(s) {
  for (const t of ['msg','rating','outbox','completed']) s[t] ||= [];
  for (const p of s.projectteam) p.status ||= 'recruiting';
  s.seq.msg ||= 1; s.seq.rating ||= 1;
  return s;
}
export function notify(s, from, to, title, cont, now) {
  s.msg.push({no:next(s,'msg'),sendid:from,getid:to,title,cont,sendtime:now.toISOString(),read:false,deleted:[]});
}
export function install(A) {
  A.ConfirmId=c=>model(c,'signup',{check:c.state.member.some(m=>m.id===str(c.params.id))?'1':'0',notice:'아이디 확인 완료'});
  A.SignUp=c=>{
    const p=c.params;
    if(!Number(p.step)) return model(c,'signup');
    const id=str(p.id), pwd=str(p.pwd), name=str(p.name), email=str(p.email),auth=str(p.auth);
    if(!/^[a-zA-Z0-9_]{4,24}$/.test(id)||pwd.length<8||!name||!/^\S+@\S+\.\S+$/.test(email)||!['1','2'].includes(auth)) return {...model(c,'signup'),alert:'아이디 4~24자, 비밀번호 8자 이상, 이름, 이메일과 역할을 확인해주세요.'};
    if(c.state.member.some(m=>m.id===id)) return {...model(c,'signup'),alert:'이미 사용 중인 아이디입니다.'};
    c.state.member.push({id,pwd,name,email,auth,teamno1:null,addr:str(p.addr),maj:str(p.maj),exp:'',gen:'',birth:''});
    return back('Login','가입했습니다. 로그인해주세요.',true);
  };
  A.Find=c=>{
    const p=c.params;
    if(!Number(p.step)) return model(c,p.find==='id'?'findid':'findpwd',{list:c.state.outbox});
    if(p.find==='id'){const m=c.state.member.find(m=>m.name===str(p.name)&&m.email===str(p.email));if(m)c.state.outbox.push({kind:'id',id:m.id,message:'합성 계정 아이디 확인'});return {...model(c,'findid',{list:c.state.outbox.filter(x=>x.kind==='id')}),mutated:!!m,notice:'일치하는 합성 계정이 있으면 로컬 복구함에서 확인할 수 있습니다.'};}
    const m=c.state.member.find(m=>m.id===str(p.id)&&m.email===str(p.email));
    if(m) {const token=globalThis.crypto.randomUUID(); c.state.outbox.push({id:m.id,token,expires:c.now.getTime()+900000,used:false});}
    return {...model(c,'findpwd',{list:c.state.outbox}),mutated:!!m,notice:'일치하는 합성 계정이 있으면 로컬 복구함에 링크를 만들었습니다.'};
  };
  A.ResetPassword=c=>{
    const t=c.state.outbox.find(t=>t.token===str(c.params.token)&&!t.used&&t.expires>c.now.getTime());
    if(!t||str(c.params.pwd).length<8) return back('Find','유효한 복구 토큰과 8자 이상의 비밀번호를 입력해주세요.');
    c.state.member.find(m=>m.id===t.id).pwd=str(c.params.pwd);t.used=true;c.state.session={};return back('Login','비밀번호를 변경했습니다.',true);
  };
  A.SessionExpire=c=>{c.state.session={};return back('Login','세션이 만료되었습니다.',true);};
  A.AdminHome=c=>admin(c)?model(c,'adminhome'):back('Login','관리자 권한이 필요합니다.');
  A.MsgList=c=>user(c)?model(c,'msglist',{list:c.state.msg.filter(m=>(str(c.params.box)==='sent'?m.sendid:m.getid)===c.state.session.id&&!m.deleted.includes(c.state.session.id)),box:str(c.params.box)}):back('Login','로그인이 필요합니다.');
  A.MsgWrite=c=>{
    if(!user(c)) return back('Login','로그인이 필요합니다.');
    if(!Number(c.params.step))return {...model(c,'msgwrite'),result:'write'};
    const p=c.params;
    if(!c.state.member.some(m=>m.id===str(p.getid))||!str(p.title)||!str(p.cont)||str(p.cont).length>2000||str(p.title).length>100) return {...model(c,'msgwrite'),alert:'받는 회원, 제목(100자), 내용(2000자)을 확인해주세요.'};
    notify(c.state,c.state.session.id,str(p.getid),str(p.title),str(p.cont),c.now);return back('MsgList','쪽지를 보냈습니다. 외부 전송은 없습니다.',true);
  };
  A.MsgInfo=c=>{
    const m=c.state.msg.find(m=>m.no===Number(c.params.no)&&[m.sendid,m.getid].includes(c.state.session.id)&&!m.deleted.includes(c.state.session.id));
    if(!m)return back('MsgList','쪽지를 찾을 수 없습니다.');
    if(m.getid===c.state.session.id)m.read=true;
    return {...model(c,'msginfo',{resultClass:m}),mutated:true,keepUrl:true};
  };
  A.MsgDelete=c=>{const m=c.state.msg.find(m=>m.no===Number(c.params.no)&&[m.sendid,m.getid].includes(c.state.session.id));if(!m)return back('MsgList','쪽지를 찾을 수 없습니다.');if(!m.deleted.includes(c.state.session.id))m.deleted.push(c.state.session.id);return back('MsgList','내 쪽지함에서 삭제했습니다.',true);};
  A.ProjLifecycle=c=>{
    const p=c.state.projectteam.find(p=>String(p.teamno)===str(c.params.teamno));
    if(!p||(!admin(c)&&p.leaderid!==c.state.session.id))return back('MyProjList','프로젝트 소유자만 변경할 수 있습니다.');
    const status=str(c.params.status);
    if(!['closed','completed','released'].includes(status)||['completed','released'].includes(p.status))return back('MyProjList','허용되지 않은 상태 변경입니다.');
    p.status=status;p.recmem='0';
    if(status!=='closed'){
      const members=c.state.member.filter(m=>String(m.teamno1)===String(p.teamno));
      if(status==='completed') c.state.completed.push({teamno:p.teamno,title:p.title,members:members.map(m=>m.id),completedAt:c.now.toISOString()});
      members.forEach(m=>m.teamno1=null);
      c.state.hopelist=c.state.hopelist.filter(h=>h.sendid!==p.leaderid&&h.getid!==p.leaderid);
    }
    return back('MyProjList','프로젝트 상태를 변경했습니다.',true);
  };
  A.RatingList=c=>user(c)?model(c,'ratinglist',{list:c.state.rating.filter(r=>r.sendid===c.state.session.id||r.getid===c.state.session.id),completed:c.state.completed.filter(p=>p.members.includes(c.state.session.id)).map(p=>({...p,peers:p.members.filter(id=>id!==c.state.session.id).join(', ')}))}):back('Login','로그인이 필요합니다.');
  A.RatingWrite=c=>{
    if(!user(c))return back('Login','로그인이 필요합니다.');
    if(!Number(c.params.step))return {...model(c,'ratingwrite',{teamno:str(c.params.teamno)}),result:'write'};
    const p=c.params, project=c.state.completed.find(x=>String(x.teamno)===str(p.teamno)), target=str(p.getid), score=Number(p.score);
    if(!project||!project.members.includes(c.state.session.id)||!project.members.includes(target)||target===c.state.session.id||!Number.isInteger(score)||score<1||score>5||c.state.rating.some(r=>r.teamno===project.teamno&&r.sendid===c.state.session.id&&r.getid===target))return {...model(c,'ratingwrite'),alert:'함께 완료한 프로젝트의 동료에게 1~5점으로 한 번만 평가할 수 있습니다.'};
    c.state.rating.push({no:next(c.state,'rating'),teamno:project.teamno,sendid:c.state.session.id,getid:target,score,cont:str(p.cont)});return back('RatingList','평점을 저장했습니다.',true);
  };
  A.deleteMemberForm=c=>user(c)?model(c,'withdraw'):back('Login','로그인이 필요합니다.');
  A.checkPwd=c=>{if(!user(c)||user(c).pwd!==str(c.params.pwd))return {...model(c,'withdraw'),alert:'비밀번호가 일치하지 않습니다.'};c.state.session.reauthUntil=c.now.getTime()+300000;return {...model(c,'withdraw',{verified:true}),mutated:true,keepUrl:true};};
  A.deleteMember=c=>{
    const m=user(c);if(!m||!(c.state.session.reauthUntil>c.now.getTime()))return back('deleteMemberForm','먼저 비밀번호를 확인해주세요.');
    if(m.teamno1)return back('MyProjList','진행 중인 프로젝트를 종료하거나 해산한 뒤 탈퇴해주세요.');
    c.state.member=c.state.member.filter(x=>x!==m);c.state.specreg=c.state.specreg.filter(x=>x.id!==m.id);c.state.hopelist=c.state.hopelist.filter(x=>x.sendid!==m.id&&x.getid!==m.id);c.state.favoritelist=c.state.favoritelist.filter(x=>x.id!==m.id&&x.leaderid!==m.id);c.state.session={};return back('SocialMap','탈퇴했습니다.',true);
  };
  for(const [prefix,table,key,log] of [['Comp','competition','competition',null],['AS','custservice','custservice',0],['FAQ','custservice','custservice',1]]) {
    for(const op of ['Write','Modify','Delete']) A[prefix+op]=c=>{
      if(!admin(c))return back(prefix+'List','관리자 권한이 필요합니다.');
      const item=c.state[table].find(x=>x.no===Number(c.params.no)&&(log===null||x.custlog===log));
      if(op!=='Write'&&!item)return back(prefix+'List','항목을 찾을 수 없습니다.');
      if(op==='Delete'){if(prefix==='Comp'&&c.state.projectteam.some(p=>p.comp===item.title))return back('CompList','연결된 프로젝트가 있어 삭제할 수 없습니다.');c.state[table]=c.state[table].filter(x=>x!==item);return back(prefix+'List','삭제했습니다.',true);}
      const view=()=>model(c,'managewrite',{resultClass:item||{},action:prefix+op,no:item?.no||'',heading:prefix==='Comp'?'공모전 관리':prefix==='AS'?'공지 관리':'FAQ 관리'});
      if(!Number(c.params.step))return view();
      const title=str(c.params.title),cont=str(c.params.cont),upload=str(c.params.fixture || c.params.upload);
      if(!title||title.length>100||!cont||cont.length>5000||upload&&!['fixture-poster.svg','fixture-guide.txt'].includes(upload))return {...view(),alert:'제목, 내용 또는 허용된 합성 첨부를 확인해주세요.'};
      const values={title,cont,upload,img:upload||(item?.img||'competition.svg'),startdate:str(c.params.startdate),enddate:str(c.params.enddate),hits:item?.hits||0,regdate:c.now.toISOString(),custlog:log};
      if(values.startdate&&values.enddate&&values.enddate<values.startdate)return {...view(),alert:'종료일을 확인해주세요.'};
      if(item)Object.assign(item,values);else c.state[table].push({no:next(c.state,key),...values});return back(prefix+'List','저장했습니다.',true);
    };
  }
  A.FAQInfo=c=>{const x=c.state.custservice.find(x=>x.no===Number(c.params.no)&&x.custlog===1);return x?model(c,'asinfo',{resultClass:x,no:x.no,custlog:1}):back('FAQList','항목을 찾을 수 없습니다.');};
  for(const action of ['QnaAdminWrite','QnaAdminModify']) A[action]=c=>{
    if(!admin(c))return back('QnaList','관리자 권한이 필요합니다.');
    const q=c.state.qna.find(q=>q.no===Number(c.params.no)&&q.qalog===0);if(!q)return back('QnaList','질문을 찾을 수 없습니다.');
    const answer=c.state.qna.find(a=>a.no===q.no&&a.qalog===1);
    if(!Number(c.params.step))return model(c,'managewrite',{action,no:q.no,heading:'문의 답변',resultClass:answer||{title:'답변: '+q.title}});
    if(!str(c.params.cont)||str(c.params.cont).length>5000)return {...model(c,'managewrite',{action,no:q.no}),alert:'답변 내용을 입력해주세요.'};
    if(str(c.params.remove)==='1')c.state.qna=c.state.qna.filter(x=>x!==answer);
    else if(answer)answer.cont=str(c.params.cont);else c.state.qna.push({no:q.no,qalog:1,id:c.state.session.id,title:str(c.params.title),cont:str(c.params.cont),regdate:c.now.toISOString()});
    return back('QnaList','답변을 저장했습니다.',true);
  };
  for(const action of ['SpecInfo','favSpecInfo']) {const old=A[action];A[action]=c=>{const spec=c.state.specreg.find(x=>x.id===str(c.params.id));return spec&&(Number(spec.showlog)===1||spec.id===c.state.session.id||admin(c))?old(c):back('SpecList','비공개 스펙은 소유자만 볼 수 있습니다.');};}
  const mine=A.MyProjInfo;A.MyProjInfo=c=>{const p=c.state.projectteam.find(p=>String(p.teamno)===str(c.params.teamno));return p&&(admin(c)||String(user(c)?.teamno1)===String(p.teamno))?mine(c):back('MyProjList','본인의 프로젝트만 볼 수 있습니다.');};
  const qlist=A.QnaList; A.QnaList=c=>{const out=qlist(c);out.model.list=out.model.list.filter(q=>admin(c)||q.id===c.state.session.id);if(admin(c))out.model.list=c.state.qna.filter(q=>q.qalog===0);return out;};
  const qinfo=A.QnaInfo;A.QnaInfo=c=>{const q=c.state.qna.find(q=>q.no===Number(c.params.no)&&q.qalog===0);return q&&(admin(c)||q.id===c.state.session.id)?qinfo(c):back('QnaList','본인의 문의만 볼 수 있습니다.');};
  for(const action of ['ProjHopeMsg','SpecHopeMsg','insertTeam','deleteHopeList']){const old=A[action];A[action]=c=>{const hope=c.state.hopelist.find(h=>h.no===Number(c.params.no));const out=old(c);if(out.mutated){const to=hope?.sendid||str(c.params.getid);notify(c.state,c.state.session.id,to,action==='insertTeam'?'참여 수락':action==='deleteHopeList'?'참여 거절':'프로젝트 참여 요청','내 프로젝트와 받은 신청에서 내용을 확인해주세요.',c.now);}return out;};}
}
