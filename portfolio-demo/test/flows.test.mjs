// struts.xml 결과 → JSP 연결을 따라 실제 화면 HTML까지 그려 보는 흐름 시험 (브라우저 없이)
import { test, before } from 'node:test';
import assert from 'node:assert/strict';
import { build } from '../scripts/build.mjs';
import { dispatch } from '../src/dispatch.js';
import { render } from '../src/render.js';
import { seedState } from '../src/fixtures.js';

let T;
before(async () => {
  build();
  T = await import(`../dist/app/templates.js?t=${Date.now()}`);
});

const NOW = new Date('2026-09-26T10:00:00');
function go(state, name, params = {}) {
  const out = dispatch(name, params, { state, now: NOW, routes: T.ROUTES, mainpages: T.MAINPAGES });
  if (out.kind !== 'page') return { ...out, html: '' };
  const page = T.TEMPLATES[out.jsp];
  const html = render(page.template, out.model, out.state.session);
  const scripts = page.headScripts.map((s) => render(s, out.model, out.state.session)).join('\n');
  return { ...out, html, scripts };
}
const login = (id) => go(seedState(), 'Login', { check: '0', id, pwd: 'demo' }).state;

test('mainpage 표는 원본 homepage.jsp 분기와 tiles-service.xml에서 온다', () => {
  assert.equal(T.MAINPAGES.projlist, 'content/project/list.jsp');
  assert.equal(T.MAINPAGES.sendcomplete, 'mypage/hopelist/sendcomplete.jsp', '고친 tiles 설정');
  assert.equal(T.MAINPAGES.deletehopelist, 'mypage/hopelist/check.jsp', '고친 homepage 분기');
  assert.equal(T.MAINPAGES.signup, undefined, '회원가입 화면은 빼 둔다');
});

test('비로그인 메인 → 역할별 메인 (원본 main.jsp 분기)', () => {
  assert.match(go(seedState(), 'SocialMap').html, /<h3>로그인<\/h3>[\s\S]*<h3>가이드<\/h3>/);
  assert.match(go(login('leader01'), 'SocialMap').html, /프리랜서찾기[\s\S]*프로젝트 등록하기/);
  assert.match(go(login('member01'), 'SocialMap').html, /프로젝트찾기[\s\S]*스펙등록/);
});

test('팀원: 상세 → 참여 희망 → 신청 완료 화면, 두 번째는 막힘', () => {
  let s = login('member01');
  const info = go(s, 'ProjInfo', { teamno: '1' });
  assert.match(info.html, /value="프로젝트 참여 희망" onclick="javascript:window.location='#\/ProjHopeMsg\.action\?getid=leader01'"/);
  assert.doesNotMatch(info.html, /프로젝트 삭제/, '남의 프로젝트는 삭제 버튼이 없다');
  const sent = go(s, 'ProjHopeMsg', { getid: 'leader01' });
  assert.equal(sent.jsp, 'mypage/hopelist/sendcomplete.jsp');
  assert.match(sent.html, /<h2>신청 완료<\/h2>/);
  s = sent.state;
  const again = go(s, 'ProjHopeMsg', { getid: 'leader01' });
  assert.equal(again.kind, 'redirect');
  assert.deepEqual(again.alerts, ['이미 참여를 희망한 프로젝트입니다.']);
});

test('팀장: 참여 희망자 목록에서 수락/거절 (원본 hopelist/list.jsp 버튼)', () => {
  let s = login('leader01');
  const list = go(s, 'hopeList');
  assert.match(list.html, /insertTeam\.action\?no=1&id=member03&leaderid=leader01/);
  const accepted = go(s, 'insertTeam', { no: '1', id: 'member03', leaderid: 'leader01' });
  assert.equal(accepted.jsp, 'mypage/hopelist/list.jsp');
  assert.doesNotMatch(accepted.html, /member03/);
  s = accepted.state;
  const rejected = go(s, 'deleteHopeList', { no: '2' });
  assert.equal(rejected.jsp, 'mypage/hopelist/check.jsp');
  assert.match(rejected.html, /거절하였습니다/);
  assert.match(rejected.html, /#\/hopeList\.action/, '고친 돌아가기 링크');
});

test('프로젝트 등록: 원본 write.jsp step 2 이동 스크립트와 list.jsp의 "2개 이상" 알림', () => {
  const blocked = go(login('leader01'), 'ProjWrite', { step: '0' });
  assert.match(blocked.html, /<script type="text\/javascript">location\.href="#\/ProjList\.action\?check=false";<\/script>/);
  const list = go(login('leader01'), 'ProjList', { check: 'false' });
  assert.match(list.html, /alert\("프로젝트를 2개 이상 진행할 수 없습니다\."\)/);
  const form = go(login('leader02'), 'ProjWrite', { step: '0' });
  assert.match(form.html, /<form action="#\/ProjWrite\.action" method="post" name="userinput"/);
  assert.match(form.scripts, /var frm = document\.userinput;/);
  assert.match(form.scripts, /url="#\/Major\.action";\s*SM\.openPopup\(url/);
  const modify = go(login('leader01'), 'ProjModify', { teamno: '1', step: '0' });
  assert.match(modify.html, /<form action="#\/ProjModify\.action"/);
  assert.match(modify.html, /name="maj" maxlength="50" value="컴퓨터공학, 시각디자인"/);
  assert.match(modify.html, /<input type="hidden" name="teamno" value="1">/);
});

test('전공 찾기 팝업(MajorCheck.jsp)은 같은 페이지 대화상자에서 값을 넣는다', () => {
  const pop = go(login('leader02'), 'Major', { search: '디자인' });
  assert.equal(pop.jsp, 'major/MajorCheck.jsp');
  assert.match(pop.html, /javascript:sendMajor\('산업디자인'\)/);
  assert.match(pop.scripts, /document\.userinput\.maj\.value = maj;\s*SM\.closePopup\(\);/);
});

test('대회: CompList → chain → CompBestlist 로 목록과 TOP 5가 함께 온다', () => {
  const out = go(seedState(), 'CompList');
  assert.equal(out.action, 'CompBestlist');
  assert.equal(out.jsp, 'content/competition/List.jsp');
  assert.match(out.html, /<span class="demo-poster">가상 데이터 시각화 공모전<\/span>/);
  assert.doesNotMatch(out.html, /upload\/file_/);
});

test('스크랩 중복은 원본 checkError2.jsp(알림 후 뒤로)로 간다', () => {
  const out = go(login('member01'), 'favProj', { teamno: '3' });
  assert.equal(out.jsp, 'mypage/favorite/checkError2.jsp');
  assert.match(out.scripts, /alert\("이미 스크랩하셨습니다\^\^\*"\);\s*history\.back\(-1\);/);
  const ok = go(login('member01'), 'favProj', { teamno: '4' });
  assert.equal(ok.action, 'favProjList');
  assert.match(ok.html, /동네 반찬가게 주문 웹/);
});

test('스펙: 본인 글만 수정·삭제 버튼, 팀장만 권유·스크랩 버튼 (고친 specreg/info.jsp)', () => {
  const mine = go(login('member02'), 'SpecInfo', { id: 'member02' });
  assert.match(mine.html, /글 삭제/);
  assert.doesNotMatch(mine.html, /프로젝트 참여 권유|스크랩하기/);
  const leader = go(login('leader01'), 'SpecInfo', { id: 'member02' });
  assert.doesNotMatch(leader.html, /글 삭제/);
  assert.match(leader.html, /SpecHopeMsg\.action\?getid=member02/);
  assert.match(leader.scripts, /location\.href="#\/favSpec\.action\?id=member02";/);
  const list = go(login('member01'), 'SpecList');
  assert.match(list.html, /<input type="hidden" name="check" id="check" value="0">/);
  assert.match(list.scripts, /function plusFun\(\)/);
  const modify = go(login('member02'), 'SpecModify', { step: '0' });
  assert.match(modify.html, /<input type="checkbox" name="showlog" value="true" checked="checked"\/>/);
});

test('Q&A 상세: 관리자 답변 버튼은 숨기고 작성자에게만 수정/삭제', () => {
  const mine = go(login('member01'), 'QnaInfo', { no: '1' });
  assert.doesNotMatch(mine.html, /답변등록|답변수정/);
  assert.match(mine.html, /QnaModify\.action\?no=1/);
  assert.match(mine.html, /참여 희망은 여러 팀에 보낼 수 있습니다/);
  const other = go(login('leader01'), 'QnaInfo', { no: '1' });
  assert.doesNotMatch(other.html, /질문삭제/);
});

test('미제공 기능은 이유와 함께 막힌다', () => {
  const out = go(login('member01'), 'MsgList');
  assert.equal(out.kind, 'unavailable');
  assert.match(out.reason, /쪽지/);
  const top = render(T.TEMPLATES['top/top.jsp'].template, {}, { id: 'member01', name: '데모팀원', auth: '2' });
  assert.match(top, /SM\.openPopup\('#\/MsgList\.action'/);
  assert.match(top, /<a href="#\/guideHome1\.action">프로젝트\/팀원 찾는방법<\/a>/);
  assert.doesNotMatch(top, /href=""/, '빈 링크가 없다');
});

test('로그아웃하면 비로그인 메인으로 돌아온다', () => {
  const out = go(login('member01'), 'Logout');
  assert.equal(out.jsp, 'main/main.jsp');
  assert.deepEqual(out.state.session, {});
  assert.equal(out.landing, 'SocialMap');
});
