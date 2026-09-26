// 모의 어댑터: 원본 Struts 액션(struts.xml의 name)을 하나씩 브라우저 안의 함수로 바꾼다.
// DB 대신 state(원본 테이블과 같은 모양의 배열)를 읽고 고친다. 네트워크·쪽지·결제는 없다.
// 각 함수는 원본 Java 메서드의 흐름(mainpage, step, check, result 이름)을 따르고,
// 원본에 없던 검증은 "데모 규칙" 주석으로 표시한다.
import { pageOf } from './paging.js';
import { REGIONS } from './fixtures.js';

// 원본 규칙: 한 회원은 member.teamno1 한 칸으로 진행 중인 프로젝트를 하나만 가진다.
// (ProjectTeamAction.write 가 teamno1이 있으면 등록을 막고 list.jsp가 이 문구를 띄운다.
//  hopelist.insertTeam 도 teamno1 을 덮어쓴다.) 데모는 같은 규칙을 참여 신청·수락에도 적용한다.
export const ONE_PROJECT_MESSAGE = '프로젝트를 2개 이상 진행할 수 없습니다.';

const one = (v) => (Array.isArray(v) ? v[0] : v);
const many = (v) => (v === undefined || v === null || v === '' ? [] : (Array.isArray(v) ? v : [v])).filter((x) => x !== '');
const blank = (v) => v === undefined || v === null || String(v).trim() === '';
const filled = (v) => !blank(v) && String(v) !== '0';
const like = (value, q) => String(value ?? '').toLowerCase().includes(String(q).toLowerCase());
const pad = (n) => String(n).padStart(2, '0');
export const stamp = (d) => `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`;

function base(ctx, mainpage) {
  const s = ctx.state.session;
  return { id: s.id ?? null, name: s.name ?? null, auth: s.auth ?? null, mainpage: mainpage ?? null };
}
const me = (ctx) => ctx.state.member.find((m) => m.id === ctx.state.session.id) || null;
const projectOf = (ctx, teamno) => ctx.state.projectteam.find((p) => String(p.teamno) === String(teamno)) || null;
const projectOfLeader = (ctx, leaderid) => ctx.state.projectteam.find((p) => p.leaderid === leaderid) || null;
const redirect = (action, alert, params = []) => ({ redirect: { action, params }, alert });
const needLogin = () => redirect('Login', '로그인이 필요합니다. 아래 데모 계정으로 로그인해 보세요.');
const nextSeq = (ctx, table) => { const n = ctx.state.seq[table]; ctx.state.seq[table] = n + 1; return n; };

function projectInput(p) {
  return {
    title: String(one(p.title) ?? '').trim(), comp: String(one(p.comp) ?? '').trim(),
    startdate: String(one(p.startdate) ?? ''), enddate: String(one(p.enddate) ?? ''),
    recmem: String(one(p.recmem) ?? '').trim(), maj: String(one(p.maj) ?? '').trim(),
    cont: String(one(p.cont) ?? '').trim(), loc: String(one(p.loc) ?? '').trim(), sal: String(one(p.sal) ?? '').trim(),
  };
}

// 데모 규칙: 원본 write.jsp의 제목/내용 필수 검사에 더해 숫자 칸과 기간을 확인한다. (원본 서버는 검사하지 않았다)
export function validateProject(v) {
  if (!v.title) return '제목을 입력해주세요';
  if (!v.cont) return '내용을 입력해주세요';
  if (!/^\d{1,2}$/.test(v.recmem) || Number(v.recmem) < 1) return '모집인원은 1~99 사이의 숫자로 입력해주세요';
  if (v.sal && !/^\d{1,6}$/.test(v.sal)) return '임금은 6자리 이하의 숫자로 입력해주세요';
  if (v.startdate && v.enddate && v.enddate < v.startdate) return '종료일은 시작일보다 빠를 수 없습니다';
  return null;
}

function listModel(ctx, list, action, keep, blockCount = 10) {
  const pg = pageOf(list, { currentPage: one(ctx.params.currentPage) || 1, blockCount, blockPage: 5, action, keep });
  return { list: pg.list, pagingHtml: pg.pagingHtml, currentPage: pg.currentPage, totalCount: list.length };
}

// 가입 유지 인원 규칙: hopelist.addCurrmem 은 currmem+1, recmem-1 (recmem은 "남은 모집 인원")
function joinTeam(ctx, memberId, leaderId) {
  const member = ctx.state.member.find((m) => m.id === memberId);
  const project = projectOfLeader(ctx, leaderId);
  if (!member) return '회원 정보를 찾을 수 없습니다.';
  if (!project) return '팀장의 프로젝트를 찾을 수 없습니다.';
  if (filled(member.teamno1)) return ONE_PROJECT_MESSAGE;
  if (Number(project.recmem) <= 0) return '모집 인원이 모두 찼습니다.';
  member.teamno1 = String(project.teamno);
  project.currmem = String(Number(project.currmem) + 1);
  project.recmem = String(Number(project.recmem) - 1);
  return null;
}

// 참여 희망(팀원→팀장, log 1)·참여 권유(팀장→팀원, log 0)를 넣기 전 검사. 원본은 검사 없이 넣었다.
export function validateHope(ctx, { sendid, getid, log }) {
  const leaderId = log === 1 ? getid : sendid;
  const memberId = log === 1 ? sendid : getid;
  const member = ctx.state.member.find((m) => m.id === memberId && m.auth === '2');
  const project = projectOfLeader(ctx, leaderId);
  if (!member) return '프리랜서 정보를 찾을 수 없습니다.';
  if (!project) return log === 0 ? '먼저 프로젝트를 등록해주세요.' : '팀장의 프로젝트를 찾을 수 없습니다.';
  if (filled(member.teamno1)) return log === 1 ? ONE_PROJECT_MESSAGE : '이미 다른 프로젝트를 진행 중인 프리랜서입니다.';
  if (Number(project.recmem) <= 0) return '모집 인원이 모두 찼습니다.';
  if (ctx.state.hopelist.some((h) => h.sendid === sendid && h.getid === getid)) {
    return log === 1 ? '이미 참여를 희망한 프로젝트입니다.' : '이미 참여를 권유한 프리랜서입니다.';
  }
  return null;
}

function sendHope(ctx, log) {
  const s = ctx.state.session;
  const getid = String(one(ctx.params.getid) ?? '');
  const hope = { sendid: s.id, getid, log };
  const back = log === 1 ? ['ProjList'] : ['SpecInfo', [['id', getid]]];
  const error = validateHope(ctx, hope);
  if (error) return redirect(back[0], error, back[1]);
  ctx.state.hopelist.push({ no: nextSeq(ctx, 'hopelist'), ...hope, regdate: stamp(ctx.now) });
  // 원본은 여기서 msg 테이블에 알림 쪽지도 넣었다. 데모는 다른 사람에게 쪽지를 보내지 않는다.
  return { model: { ...base(ctx, 'sendcomplete'), pagingHtml: '' }, mutated: true, landing: 'MyPage', notice: '신청을 저장했습니다. 알림 쪽지는 데모에서 보내지 않습니다.' };
}

function specView(spec) {
  return spec && { ...spec, showlog: Number(spec.showlog) === 1 ? '공개' : '비공개' };
}

function hopeListModel(ctx) {
  const list = ctx.state.hopelist.filter((h) => h.getid === ctx.state.session.id);
  return { ...base(ctx, 'hopelist'), ...listModel(ctx, list, 'hopeList', []) };
}

function toggleFavorites(ctx, { artlog, ids, key, owner }) {
  let added = 0;
  for (const value of ids) {
    const exists = ctx.state.favoritelist.some((f) => f.artlog === artlog && String(f[key]) === String(value) && f[owner] === ctx.state.session.id);
    if (!exists) {
      ctx.state.favoritelist.push({ artlog, teamno: null, id: null, leaderid: null, [key]: String(value), [owner]: ctx.state.session.id });
      added += 1;
    }
  }
  return added;
}

export const ACTIONS = {
  // ---------- member.MemberAction ----------
  SocialMap(ctx) {
    return { model: { ...base(ctx, 'main'), checkdate: 0 } };
  },
  Login(ctx) {
    const p = ctx.params;
    if (blank(one(p.check))) return { model: { ...base(ctx, 'login'), check: null } };
    const id = String(one(p.id) ?? '').trim();
    const found = ctx.state.member.find((m) => m.id === id);
    // 1: 로그인 허가, 2: 패스워드 틀림, 3: 아이디 없음 (원본 주석)
    if (!found) return { model: { ...base(ctx, 'login'), check: '3' } };
    if (found.pwd !== String(one(p.pwd) ?? '')) return { model: { ...base(ctx, 'login'), id: '', check: '2' } };
    ctx.state.session = { id: found.id, name: found.name, auth: found.auth };
    return { model: { ...base(ctx, 'main'), checkdate: 0 }, mutated: true, landing: 'SocialMap', notice: `${found.name}(${found.id}) 계정으로 로그인했습니다.` };
  },
  Logout(ctx) {
    ctx.state.session = {};
    return { model: { ...base(ctx, null), id: '' }, mutated: true, landing: 'SocialMap' };
  },

  // ---------- major.MajorAction (전공 찾기 팝업) ----------
  Major(ctx) {
    const search = one(ctx.params.search);
    const list = ctx.state.major.filter((m) => search === undefined || like(m.major_name, search));
    return { model: { list, search: search ?? '' } };
  },

  // ---------- content.project.ProjectTeamAction ----------
  ProjList(ctx) {
    const p = ctx.params;
    const comp = one(p.comp); const loc = one(p.loc); const maj = one(p.maj);
    const search = one(p.search); const searchnum = Number(one(p.searchnum) || 0);
    let list = ctx.state.projectteam;
    if (!blank(search)) {
      list = list.filter((x) => like(searchnum === 1 ? x.leaderid : x.title, search));
    } else {
      // SearchVO: comp는 같음, loc·maj는 LIKE '%값%'. "0"(--선택--)은 조건 없음.
      if (filled(comp)) list = list.filter((x) => x.comp === comp);
      if (filled(loc)) list = list.filter((x) => like(x.loc, loc));
      if (filled(maj)) list = list.filter((x) => like(x.maj, maj));
    }
    // 원본은 ORDER BY DBMS_RANDOM.RANDOM. 데모는 새로고침마다 순서가 바뀌지 않도록 최신 등록순.
    list = [...list].sort((a, b) => Number(b.teamno) - Number(a.teamno));
    const keep = [['comp', comp], ['loc', loc], ['maj', maj], ['search', search], ['searchnum', blank(search) ? null : searchnum]]
      .filter(([, v]) => filled(v) || (v === 0 && !blank(search)));
    return {
      model: {
        ...base(ctx, 'projlist'), ...listModel(ctx, list, 'ProjList', keep),
        complist: ctx.state.competition.map((c) => c.title).sort((a, b) => a.localeCompare(b)),
        loclist: REGIONS, majlist: ctx.state.major.map((m) => m.major_name),
        check: one(p.check) !== 'false',
      },
    };
  },
  ProjInfo(ctx) {
    const resultClass = projectOf(ctx, one(ctx.params.teamno));
    if (!resultClass) return redirect('ProjList', '프로젝트를 찾을 수 없습니다.');
    return { model: { ...base(ctx, 'projinfo'), resultClass, teamno: resultClass.teamno } };
  },
  ProjWrite(ctx) {
    const user = me(ctx);
    if (!user) return needLogin();
    if (user.auth !== '1') return redirect('ProjList', '프로젝트 등록은 팀장 계정만 할 수 있습니다.');
    const model = { ...base(ctx, 'projwrite'), check: true };
    if (filled(user.teamno1)) return { model: { ...model, step: 2, check: false } };
    const step = Number(one(ctx.params.step) || 0);
    if (step === 0) return { model: { ...model, step: 0, teamno: null, resultClass: null } };
    const v = projectInput(ctx.params);
    const error = validateProject(v);
    if (error) return { model: { ...model, step: 0, teamno: null, resultClass: v }, alert: error };
    const teamno = String(nextSeq(ctx, 'projectteam'));
    ctx.state.projectteam.push({ teamno, leaderid: user.id, ...v, sal: v.sal || '0', currmem: '1' });
    user.teamno1 = teamno;
    return { model: { ...model, step: 2, check: true }, mutated: true, landing: 'ProjList', notice: '프로젝트를 등록했습니다.' };
  },
  ProjModify(ctx) {
    const project = projectOf(ctx, one(ctx.params.teamno));
    if (!project) return redirect('ProjList', '프로젝트를 찾을 수 없습니다.');
    if (project.leaderid !== ctx.state.session.id) return redirect('ProjList', '자신이 등록한 프로젝트만 수정할 수 있습니다.');
    const step = Number(one(ctx.params.step) || 0);
    const model = { ...base(ctx, 'projwrite'), step: 0, teamno: project.teamno };
    if (step === 0) return { model: { ...model, resultClass: project } };
    const v = projectInput(ctx.params);
    const error = validateProject(v);
    if (error) return { model: { ...model, resultClass: { ...project, ...v } }, alert: error };
    Object.assign(project, v, { sal: v.sal || '0' });
    return { result: 'list', model: base(ctx, 'projlist'), mutated: true, notice: '프로젝트를 수정했습니다.' };
  },
  ProjDelete(ctx) {
    const project = projectOf(ctx, one(ctx.params.teamno));
    if (!project || project.leaderid !== ctx.state.session.id || project.leaderid !== one(ctx.params.leaderid)) {
      return redirect('ProjList', '자신이 등록한 프로젝트만 삭제할 수 있습니다.');
    }
    const s = ctx.state;
    s.projectteam = s.projectteam.filter((p) => p !== project);
    // 데모 규칙: 원본 deleteProj는 projectteam 행만 지워 member.teamno1이 남았다. 데모는 팀장·팀원의 teamno1과 관련 스크랩·신청도 정리한다.
    s.member.forEach((m) => { if (String(m.teamno1) === String(project.teamno)) m.teamno1 = null; });
    s.favoritelist = s.favoritelist.filter((f) => !(f.artlog === 0 && String(f.teamno) === String(project.teamno)));
    s.hopelist = s.hopelist.filter((h) => h.getid !== project.leaderid && h.sendid !== project.leaderid);
    return { model: base(ctx, 'projlist'), mutated: true, notice: '프로젝트를 삭제했습니다.' };
  },
  MyProjList(ctx) {
    const user = me(ctx);
    if (!user) return needLogin();
    const project = filled(user.teamno1) ? projectOf(ctx, user.teamno1) : null;
    return { model: { ...base(ctx, 'myprojlist'), teamno: user.teamno1, list: project ? [project] : [] } };
  },
  MyProjInfo(ctx) {
    const resultClass = projectOf(ctx, one(ctx.params.teamno));
    if (!resultClass) return redirect('MyProjList', '프로젝트를 찾을 수 없습니다.');
    return { model: { ...base(ctx, 'myprojinfo'), resultClass } };
  },

  // ---------- content.specreg.SpecRegAction ----------
  SpecList(ctx) {
    const p = ctx.params;
    const addr = one(p.addr); const maj = one(p.maj); const search = one(p.search);
    let list = ctx.state.specreg;
    if (search !== undefined) {
      list = list.filter((x) => like(x.id, search));
    } else {
      if (filled(addr)) list = list.filter((x) => like(x.addr, addr));
      if (filled(maj)) list = list.filter((x) => like(x.maj, maj));
    }
    list = [...list].sort((a, b) => String(b.regdate).localeCompare(String(a.regdate)));
    const keep = [['addr', addr], ['maj', maj], ['search', search]].filter(([k, v]) => (k === 'search' ? v !== undefined : filled(v)));
    return {
      model: {
        ...base(ctx, 'speclist'), ...listModel(ctx, list, 'SpecList', keep),
        addrlist: REGIONS, majlist: ctx.state.major.map((m) => m.major_name),
        // 원본은 현재 쪽의 목록만 보고 판단했다. 데모는 전체 등록 여부로 판단한다.
        check: ctx.state.specreg.some((x) => x.id === ctx.state.session.id) ? 1 : 0,
      },
    };
  },
  SpecInfo(ctx) {
    const spec = ctx.state.specreg.find((x) => x.id === one(ctx.params.id));
    if (!spec) return redirect('SpecList', '스펙 정보를 찾을 수 없습니다.');
    return { model: { ...base(ctx, 'specinfo'), resultClass: specView(spec) } };
  },
  SpecWrite(ctx) {
    const user = me(ctx);
    if (!user) return needLogin();
    if (user.auth !== '2') return redirect('SpecList', '스펙 등록은 팀원 계정만 할 수 있습니다.');
    if (ctx.state.specreg.some((x) => x.id === user.id)) return redirect('SpecList', '이미 글이 등록되어있습니다.');
    const exp = String(one(ctx.params.exp) ?? '').trim();
    if (!exp) return redirect('SpecList', '기존이력을 입력해주세요');
    if (exp.length > 300) return redirect('SpecList', '기존이력은 300자 이내로 입력해주세요');
    // 원본과 같이 지역·전공은 회원 정보에서, 추가내용(contadd)은 회원의 전공관련 이력(exp)에서 가져온다.
    ctx.state.specreg.push({ id: user.id, regdate: stamp(ctx.now), exp, maj: user.maj, addr: user.addr, contadd: user.exp, showlog: many(ctx.params.showlog).length ? 1 : 0 });
    return { model: base(ctx, 'speclist'), mutated: true, notice: '스펙을 등록했습니다.' };
  },
  SpecModify(ctx) {
    const user = me(ctx);
    if (!user) return needLogin();
    const spec = ctx.state.specreg.find((x) => x.id === user.id);
    if (!spec) return redirect('SpecList', '등록된 스펙이 없습니다.');
    if (Number(one(ctx.params.step) || 0) === 0) return { model: { ...base(ctx, 'specmodify'), step: 0, resultClass: spec } };
    const exp = String(one(ctx.params.exp) ?? '').trim();
    if (!exp) return { model: { ...base(ctx, 'specmodify'), step: 0, resultClass: spec }, alert: '기존이력을 입력해주세요' };
    Object.assign(spec, {
      exp, maj: String(one(ctx.params.maj) ?? '').trim(), addr: String(one(ctx.params.addr) ?? '').trim(),
      contadd: String(one(ctx.params.contadd) ?? '').trim(), showlog: many(ctx.params.showlog).length ? 1 : 0,
    });
    return { model: { ...base(ctx, 'specmodify'), step: 2 }, mutated: true, landing: 'SpecList', notice: '스펙을 수정했습니다.' };
  },
  SpecDelete(ctx) {
    const id = one(ctx.params.id);
    if (!id || id !== ctx.state.session.id) return redirect('SpecList', '자신의 스펙만 삭제할 수 있습니다.');
    ctx.state.specreg = ctx.state.specreg.filter((x) => x.id !== id);
    ctx.state.favoritelist = ctx.state.favoritelist.filter((f) => !(f.artlog === 1 && f.id === id));
    return { model: base(ctx, 'speclist'), mutated: true, notice: '스펙을 삭제했습니다.' };
  },

  // ---------- content.competition.CompetitionAction ----------
  CompList(ctx) {
    const list = [...ctx.state.competition].sort((a, b) => b.no - a.no);
    return { model: { ...base(ctx, 'complist'), ...listModel(ctx, list, 'CompList', [], 8) } };
  },
  CompBestlist(ctx) {
    const list1 = [...ctx.state.competition].sort((a, b) => b.hits - a.hits);
    return { model: { ...base(ctx, ctx.chainModel?.mainpage ?? null), ...(ctx.chainModel || {}), list1 } };
  },
  CompInfo(ctx) {
    const comp = ctx.state.competition.find((c) => String(c.no) === String(one(ctx.params.no)));
    if (!comp) return redirect('CompList', '대회 정보를 찾을 수 없습니다.');
    comp.hits += 1; // content.updateHits
    return { model: { ...base(ctx, 'compinfo'), resultClass: comp }, mutated: true, keepUrl: true };
  },

  // ---------- msg.MsgAction (참여 희망/권유만. 쪽지함은 제공하지 않음) ----------
  SpecHopeMsg(ctx) {
    if (ctx.state.session.auth !== '1') return redirect('SpecList', '참여 권유는 팀장 계정만 할 수 있습니다.');
    return sendHope(ctx, 0);
  },
  ProjHopeMsg(ctx) {
    if (ctx.state.session.auth !== '2') return redirect('ProjList', '참여 희망은 팀원 계정만 할 수 있습니다.');
    return sendHope(ctx, 1);
  },

  // ---------- custservice.QnaAction ----------
  QnaList(ctx) {
    const p = ctx.params;
    const search = one(p.search); const searchnum = Number(one(p.searchnum) || 0);
    const questions = ctx.state.qna.filter((q) => q.qalog === 0);
    const list = search !== undefined
      ? questions.filter((q) => like(searchnum === 1 ? q.id : q.title, search)).sort((a, b) => b.no - a.no)
      : questions.filter((q) => q.id === ctx.state.session.id).sort((a, b) => String(b.regdate).localeCompare(String(a.regdate)));
    const keep = search !== undefined ? [['search', search], ['searchnum', searchnum]] : [];
    return { model: { ...base(ctx, 'qnalist'), ...listModel(ctx, list, 'QnaList', keep) } };
  },
  QnaInfo(ctx) {
    const no = Number(one(ctx.params.no));
    const list = ctx.state.qna.filter((q) => q.no === no).sort((a, b) => a.qalog - b.qalog);
    if (!list.length) return redirect('QnaList', '게시물을 찾을 수 없습니다.');
    return { model: { ...base(ctx, 'qnainfo'), list, no, resultClass1: list[0], resultClass2: list[1] || null, currentPage: one(ctx.params.currentPage) || 1 } };
  },
  QnaWrite(ctx) {
    if (!ctx.state.session.id) return needLogin();
    const model = { ...base(ctx, 'qnawrite'), no: 0, step: 0, currentPage: one(ctx.params.currentPage) || 1 };
    if (Number(one(ctx.params.step) || 0) === 0) return { model };
    const title = String(one(ctx.params.title) ?? '').trim();
    const cont = String(one(ctx.params.cont) ?? '').trim();
    const error = !title ? '제목을 입력해주세요' : !cont ? '내용을 입력해주세요' : title.length > 30 ? '제목은 30자 이내로 입력해주세요' : cont.length > 2000 ? '내용은 2000자 이내로 입력해주세요' : null;
    if (error) return { model: { ...model, resultClass1: { title, cont } }, alert: error };
    ctx.state.qna.push({ no: nextSeq(ctx, 'qna'), qalog: 0, id: ctx.state.session.id, title, cont, regdate: stamp(ctx.now) });
    return { result: 'list', model: base(ctx, 'qnalist'), mutated: true, notice: '질문을 등록했습니다. 데모에서는 관리자 답변이 달리지 않습니다.' };
  },
  QnaModify(ctx) {
    const no = Number(one(ctx.params.no));
    const question = ctx.state.qna.find((q) => q.no === no && q.qalog === 0);
    if (!question || question.id !== ctx.state.session.id) return redirect('QnaList', '자신이 쓴 질문만 수정할 수 있습니다.');
    const model = { ...base(ctx, 'qnawrite'), no, step: 0, currentPage: one(ctx.params.currentPage) || 1, resultClass1: question };
    if (Number(one(ctx.params.step) || 0) === 0) return { model };
    const title = String(one(ctx.params.title) ?? '').trim();
    const cont = String(one(ctx.params.cont) ?? '').trim();
    const error = !title ? '제목을 입력해주세요' : !cont ? '내용을 입력해주세요' : title.length > 30 ? '제목은 30자 이내로 입력해주세요' : null;
    if (error) return { model: { ...model, resultClass1: { ...question, title, cont } }, alert: error };
    Object.assign(question, { title, cont });
    return { result: 'list', model: base(ctx, 'qnalist'), mutated: true, notice: '질문을 수정했습니다.' };
  },
  QnaDelete(ctx) {
    const no = Number(one(ctx.params.no));
    const question = ctx.state.qna.find((q) => q.no === no && q.qalog === 0);
    if (!question || question.id !== ctx.state.session.id) return redirect('QnaList', '자신이 쓴 질문만 삭제할 수 있습니다.');
    ctx.state.qna = ctx.state.qna.filter((q) => q.no !== no);
    return { model: base(ctx, 'qnalist'), mutated: true, notice: '질문을 삭제했습니다.' };
  },

  // ---------- custservice.ASNoticeAction / FAQAction ----------
  ASList(ctx) {
    const search = one(ctx.params.search);
    const notices = ctx.state.custservice.filter((c) => c.custlog === 0);
    // 원본 cust.searchas 는 searchnum과 관계없이 제목만 검색했다.
    const list = (search !== undefined ? notices.filter((c) => like(c.title, search)) : notices).sort((a, b) => b.no - a.no);
    return { model: { ...base(ctx, 'aslist'), ...listModel(ctx, list, 'ASList', search !== undefined ? [['search', search]] : []) } };
  },
  ASInfo(ctx) {
    const item = ctx.state.custservice.find((c) => c.custlog === 0 && String(c.no) === String(one(ctx.params.no)));
    if (!item) return redirect('ASList', '게시물을 찾을 수 없습니다.');
    item.hits += 1;
    return { model: { ...base(ctx, 'asinfo'), resultClass: item, custlog: 0, no: item.no, currentPage: one(ctx.params.currentPage) || 1 }, mutated: true, keepUrl: true };
  },
  FAQList(ctx) {
    const list = ctx.state.custservice.filter((c) => c.custlog === 1).sort((a, b) => b.no - a.no);
    return { model: { ...base(ctx, 'faqlist'), ...listModel(ctx, list, 'FAQList', []) } };
  },

  // ---------- mypage.MyPageAction ----------
  MyPage(ctx) {
    const user = me(ctx);
    if (!user) return needLogin();
    // 원본은 비밀번호를 그대로 보여 줬다. 데모는 가린다.
    return { model: { ...base(ctx, 'memberinfo'), resultClass: { ...user, pwd: '********' } } };
  },
  modifyMemberForm(ctx) {
    const user = me(ctx);
    if (!user) return needLogin();
    return { model: { ...base(ctx, 'membermodify'), resultClass: { ...user, pwd: '' } } };
  },
  modifyMember(ctx) {
    const user = me(ctx);
    if (!user) return needLogin();
    const p = ctx.params;
    const v = (k) => String(one(p[k]) ?? '').trim();
    if (v('email') && !/^[^\s@]+@[^\s@]+$/.test(v('email'))) return redirect('modifyMemberForm', 'E-mail 형식을 확인해주세요.');
    if (!/^\d{6}$/.test(v('birth')) || !/^[1-4]$/.test(v('gen'))) return redirect('modifyMemberForm', '주민등록번호 앞자리 6자리와 뒷자리 첫 숫자를 입력해주세요.');
    // 데모는 비밀번호를 저장하지 않는다(데모 계정 비밀번호는 항상 demo).
    Object.assign(user, { name: v('name') || user.name, birth: v('birth'), gen: v('gen'), email: v('email'), addr: v('addr'), maj: v('maj'), exp: v('exp') });
    ctx.state.session.name = user.name;
    return { model: base(ctx, 'memberinfo'), mutated: true, notice: '회원 정보를 수정했습니다. (비밀번호는 데모에서 저장하지 않습니다)' };
  },

  // ---------- favorite.FavoriteAction ----------
  favSpecList(ctx) {
    if (!ctx.state.session.id) return needLogin();
    const ids = ctx.state.favoritelist.filter((f) => f.artlog === 1 && f.leaderid === ctx.state.session.id).map((f) => f.id);
    const list = ctx.state.specreg.filter((x) => ids.includes(x.id));
    const m = listModel(ctx, list, 'favSpecList', []);
    return { model: { ...base(ctx, 'favspeclist'), favlist: m.list, pagingHtml: m.pagingHtml, currentPage: m.currentPage } };
  },
  favSpec(ctx) {
    if (ctx.state.session.auth !== '1') return redirect('SpecList', '프리랜서 스크랩은 팀장 계정만 할 수 있습니다.');
    const ids = many(ctx.params.id).filter((id) => ctx.state.specreg.some((x) => x.id === id));
    if (!ids.length) return redirect('SpecList', '스크랩할 프리랜서를 선택해주세요.');
    if (!toggleFavorites(ctx, { artlog: 1, ids, key: 'id', owner: 'leaderid' })) return { result: 'error', model: base(ctx, null) };
    return { model: base(ctx, 'favspeclist'), mutated: true };
  },
  favSpecInfo(ctx) {
    const spec = ctx.state.specreg.find((x) => x.id === one(ctx.params.id));
    if (!spec) return redirect('favSpecList', '스펙 정보를 찾을 수 없습니다.');
    return { model: { ...base(ctx, 'favspecinfo'), resultClass: { ...specView(spec), leaderid: ctx.state.session.id } } };
  },
  delSpec(ctx) {
    const id = one(ctx.params.id);
    ctx.state.favoritelist = ctx.state.favoritelist.filter((f) => !(f.artlog === 1 && f.id === id && f.leaderid === ctx.state.session.id));
    return { model: base(ctx, 'favspeclist'), mutated: true, notice: '스크랩을 취소했습니다.' };
  },
  favProjList(ctx) {
    if (!ctx.state.session.id) return needLogin();
    const teamnos = ctx.state.favoritelist.filter((f) => f.artlog === 0 && f.id === ctx.state.session.id).map((f) => String(f.teamno));
    const list = ctx.state.projectteam.filter((p) => teamnos.includes(String(p.teamno)));
    const m = listModel(ctx, list, 'favProjList', []);
    return { model: { ...base(ctx, 'favprojlist'), favlist: m.list, pagingHtml: m.pagingHtml, currentPage: m.currentPage } };
  },
  favProj(ctx) {
    if (ctx.state.session.auth !== '2') return redirect('ProjList', '프로젝트 스크랩은 팀원 계정만 할 수 있습니다.');
    const teamnos = many(ctx.params.teamno).filter((t) => projectOf(ctx, t));
    if (!teamnos.length) return redirect('ProjList', '스크랩할 프로젝트를 선택해주세요.');
    if (!toggleFavorites(ctx, { artlog: 0, ids: teamnos, key: 'teamno', owner: 'id' })) return { result: 'error', model: base(ctx, null) };
    return { model: base(ctx, 'favprojlist'), mutated: true };
  },
  favProjInfo(ctx) {
    const presultClass = projectOf(ctx, one(ctx.params.teamno));
    if (!presultClass) return redirect('favProjList', '프로젝트를 찾을 수 없습니다.');
    return { model: { ...base(ctx, 'favprojinfo'), presultClass } };
  },
  delProj(ctx) {
    const teamno = String(one(ctx.params.teamno));
    ctx.state.favoritelist = ctx.state.favoritelist.filter((f) => !(f.artlog === 0 && String(f.teamno) === teamno && f.id === ctx.state.session.id));
    return { model: base(ctx, 'favprojlist'), mutated: true, notice: '스크랩을 취소했습니다.' };
  },

  // ---------- hopelist.HopeListAction ----------
  hopeList(ctx) {
    if (!ctx.state.session.id) return needLogin();
    return { model: hopeListModel(ctx) };
  },
  insertTeam(ctx) {
    const no = Number(one(ctx.params.no));
    const hope = ctx.state.hopelist.find((h) => h.no === no);
    // 데모 규칙: 받은 사람만 수락할 수 있고, 주소의 id/leaderid 가 신청 내용과 맞아야 한다.
    if (!hope || hope.getid !== ctx.state.session.id) return redirect('hopeList', '처리할 수 없는 신청입니다.');
    const memberId = hope.log === 1 ? hope.sendid : hope.getid;
    const leaderId = hope.log === 1 ? hope.getid : hope.sendid;
    if (one(ctx.params.id) !== memberId || one(ctx.params.leaderid) !== leaderId) return redirect('hopeList', '처리할 수 없는 신청입니다.');
    const error = joinTeam(ctx, memberId, leaderId);
    if (error) return redirect('hopeList', error);
    ctx.state.hopelist = ctx.state.hopelist.filter((h) => h !== hope);
    // 원본은 목록을 다시 읽지 않아 빈 표가 보였다. 데모는 남은 목록을 다시 보여 준다.
    return { model: hopeListModel(ctx), mutated: true, landing: 'hopeList', notice: `수락했습니다. ${memberId} 님이 팀에 합류했습니다.` };
  },
  deleteHopeList(ctx) {
    const no = Number(one(ctx.params.no));
    const hope = ctx.state.hopelist.find((h) => h.no === no);
    if (!hope || hope.getid !== ctx.state.session.id) return redirect('hopeList', '처리할 수 없는 신청입니다.');
    ctx.state.hopelist = ctx.state.hopelist.filter((h) => h !== hope);
    return { model: { ...base(ctx, 'deletehopelist') }, mutated: true, landing: 'hopeList' };
  },

  // ---------- temp.guideAction ----------
  guideHome: (ctx) => ({ model: base(ctx, 'guide') }),
  guideHome1: (ctx) => ({ model: base(ctx, 'guide1') }),
  guideHome2: (ctx) => ({ model: base(ctx, 'guide2') }),
  guideHome3: (ctx) => ({ model: base(ctx, 'guide3') }),
};
// struts.xml 에서 같은 메서드를 가리키는 별칭
ACTIONS.deleteSpec = ACTIONS.SpecDelete;

const ACCOUNT = '회원가입·아이디/비밀번호 찾기는 데모에서 제공하지 않습니다. 아래 데모 계정으로 로그인해 보세요.';
const MESSAGE = '쪽지(다른 사람에게 메시지 보내기)는 데모에서 제공하지 않습니다.';
const RATING = '팀원 평점은 실제 사람을 평가하는 기능이라 데모에서 제공하지 않습니다.';
const WITHDRAW = '회원 탈퇴는 데모에서 제공하지 않습니다. 하단의 "데모 초기화"로 처음 상태로 되돌릴 수 있습니다.';
const ADMIN = '관리자 기능은 데모에서 제공하지 않습니다.';

// 원본에는 있지만 데모에서 실행하지 않는 액션과 그 이유
export const UNAVAILABLE = {
  Find: ACCOUNT, SignUp: ACCOUNT, ConfirmId: ACCOUNT,
  MsgList: MESSAGE, MsgWrite: MESSAGE, MsgInfo: MESSAGE, MsgDelete: MESSAGE,
  RatingList: RATING, RatingWrite: RATING,
  deleteMemberForm: WITHDRAW, checkPwd: WITHDRAW, deleteMember: WITHDRAW,
  CompWrite: ADMIN, CompDelete: ADMIN, CompModify: ADMIN,
  QnaAdminWrite: ADMIN, QnaAdminModify: ADMIN,
  ASWrite: ADMIN, ASModify: ADMIN, ASDelete: ADMIN,
  FAQInfo: ADMIN, FAQWrite: ADMIN, FAQModify: ADMIN, FAQDelete: ADMIN,
};

export class UnmockedActionError extends Error {
  constructor(name) {
    super(`모의 어댑터에 없는 액션입니다: ${name}.action`);
    this.name = 'UnmockedActionError';
    this.action = name;
  }
}

// 액션 하나를 실행한다. state는 복사본을 고치고, 바뀐 경우에만 새 state를 돌려준다.
export function runAction(name, { params = {}, state, now = new Date(), chainModel = null }) {
  if (UNAVAILABLE[name]) return { unavailable: UNAVAILABLE[name] };
  const fn = ACTIONS[name];
  if (!fn) throw new UnmockedActionError(name);
  const draft = structuredClone(state);
  const out = fn({ params, state: draft, now, chainModel });
  return { result: 'success', ...out, state: out.mutated ? draft : state };
}
