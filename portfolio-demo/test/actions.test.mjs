import { test } from 'node:test';
import assert from 'node:assert/strict';
import { runAction, ACTIONS, UNAVAILABLE, UnmockedActionError, ONE_PROJECT_MESSAGE } from '../src/actions.js';
import { seedState } from '../src/fixtures.js';
import { paging } from '../src/paging.js';
import { parseStruts } from '../scripts/lib/config.mjs';
import { readSource, SRC_ROOT } from '../scripts/lib/source.mjs';

const NOW = new Date('2026-09-26T10:00:00');
const as = (id) => {
  const s = seedState();
  const m = s.member.find((x) => x.id === id);
  if (m) s.session = { id: m.id, name: m.name, auth: m.auth };
  return s;
};
const run = (state, name, params = {}) => runAction(name, { params, state, now: NOW });
const project = (s, teamno) => s.projectteam.find((p) => p.teamno === String(teamno));
const member = (s, id) => s.member.find((m) => m.id === id);

test('struts.xml의 모든 액션은 모의 어댑터에 있거나 미제공 이유가 있다', () => {
  const struts = parseStruts(readSource('struts.xml', SRC_ROOT).text);
  for (const name of Object.keys(struts)) assert.ok(ACTIONS[name] || UNAVAILABLE[name], name);
  assert.equal(run(seedState(), 'MsgWrite').unavailable, UNAVAILABLE.MsgWrite);
  assert.throws(() => run(seedState(), 'NoSuchAction'), UnmockedActionError);
});

test('프로젝트 목록: 원본 SearchVO 조건(comp 일치, loc·maj 부분일치)과 제목/팀장ID 검색', () => {
  const s = seedState();
  const titles = (params) => run(s, 'ProjList', params).model.list.map((p) => p.teamno);
  assert.deepEqual(titles({ comp: '캠퍼스 앱 개발대회' }), ['11', '1']);
  assert.deepEqual(titles({ comp: '캠퍼스 앱', loc: '0', maj: '0' }), [], 'comp는 부분일치가 아니다');
  assert.deepEqual(titles({ loc: '부산', maj: '시각' }), ['6']);
  assert.deepEqual(titles({ search: '앱', searchnum: '0' }), ['12', '1']);
  assert.deepEqual(titles({ search: 'leader1', searchnum: '1' }), ['12', '11', '10', '9']);
  const page2 = run(s, 'ProjList', { currentPage: '2', loc: '0' }).model;
  assert.equal(page2.list.length, 2);
  assert.equal(page2.currentPage, 2);
  const filtered = run(s, 'ProjList', { maj: '공학' }).model;
  assert.equal(filtered.totalCount, 8);
  assert.equal(run(s, 'ProjList', { check: 'false' }).model.check, false);
});

test('페이지 번호: 원본 PagingAction(고친 식)과 같은 구간을 계산하고 검색 조건을 이어 준다', () => {
  const p = paging({ currentPage: 7, totalCount: 95, blockCount: 10, blockPage: 5, action: 'ProjList', keep: [['loc', '서울']] });
  assert.equal(p.startPage, 6);
  assert.equal(p.endPage, 10);
  assert.equal(p.startCount, 60);
  assert.match(p.pagingHtml, /#\/ProjList\.action\?loc=%EC%84%9C%EC%9A%B8&amp;currentPage=5">이전/);
  assert.doesNotMatch(p.pagingHtml, /다음/);
  assert.equal(paging({ currentPage: 99, totalCount: 3, action: 'X' }).currentPage, 1);
});

test('참여 희망: 한 사람은 한 프로젝트만 진행 (원본 teamno1 규칙) · 중복·마감 막기', () => {
  let s = as('member01');
  const ok = run(s, 'ProjHopeMsg', { getid: 'leader01' });
  assert.equal(ok.model.mainpage, 'sendcomplete');
  s = ok.state;
  assert.deepEqual(s.hopelist.at(-1), { no: 4, sendid: 'member01', getid: 'leader01', log: 1, regdate: '2026-09-26 10:00' });
  assert.equal(run(s, 'ProjHopeMsg', { getid: 'leader01' }).alert, '이미 참여를 희망한 프로젝트입니다.');
  assert.equal(run(s, 'ProjHopeMsg', { getid: 'leader12' }).alert, '모집 인원이 모두 찼습니다.');
  assert.equal(run(as('member05'), 'ProjHopeMsg', { getid: 'leader03' }).alert, ONE_PROJECT_MESSAGE);
  assert.equal(run(as('leader02'), 'ProjHopeMsg', { getid: 'leader01' }).alert, '참여 희망은 팀원 계정만 할 수 있습니다.');
  assert.equal(s.hopelist.filter((h) => h.sendid === 'member01').length, 1, '실패한 신청은 저장되지 않는다');
});

test('팀장 수락: 팀원 teamno1 설정, currmem+1 / recmem-1, 신청 삭제, 정원 초과 막기', () => {
  let s = as('leader01');
  let out = run(s, 'insertTeam', { no: '1', id: 'member03', leaderid: 'leader01' });
  s = out.state;
  assert.equal(member(s, 'member03').teamno1, '1');
  assert.deepEqual([project(s, 1).currmem, project(s, 1).recmem], ['3', '1']);
  assert.equal(s.hopelist.some((h) => h.no === 1), false);
  assert.equal(out.model.list.length, 1, '남은 신청 목록을 다시 보여 준다');
  s = run(s, 'insertTeam', { no: '2', id: 'member04', leaderid: 'leader01' }).state;
  assert.deepEqual([project(s, 1).currmem, project(s, 1).recmem], ['4', '0']);
  s.hopelist.push({ no: 9, sendid: 'member02', getid: 'leader01', regdate: '', log: 1 });
  out = run(s, 'insertTeam', { no: '9', id: 'member02', leaderid: 'leader01' });
  assert.equal(out.alert, '모집 인원이 모두 찼습니다.');
  assert.equal(member(out.state, 'member02').teamno1, null);
});

test('팀원이 권유를 수락하면 그 뒤 다른 프로젝트 참여는 막힌다', () => {
  let s = as('member01');
  s = run(s, 'insertTeam', { no: '3', id: 'member01', leaderid: 'leader04' }).state;
  assert.equal(member(s, 'member01').teamno1, '3');
  assert.deepEqual([project(s, 3).currmem, project(s, 3).recmem], ['4', '0']);
  assert.equal(run(s, 'ProjHopeMsg', { getid: 'leader05' }).alert, ONE_PROJECT_MESSAGE);
  assert.equal(run(s, 'MyProjList').model.list[0].title, '분리배출 안내 챗봇');
});

test('수락·거절은 받은 사람만, 주소를 바꿔도 다른 사람을 팀에 넣을 수 없다', () => {
  assert.equal(run(as('leader03'), 'insertTeam', { no: '1', id: 'member03', leaderid: 'leader01' }).alert, '처리할 수 없는 신청입니다.');
  assert.equal(run(as('leader01'), 'insertTeam', { no: '1', id: 'member02', leaderid: 'leader01' }).alert, '처리할 수 없는 신청입니다.');
  const rej = run(as('leader01'), 'deleteHopeList', { no: '2' });
  assert.equal(rej.model.mainpage, 'deletehopelist');
  assert.equal(rej.state.hopelist.length, 2);
  assert.equal(run(as('member01'), 'deleteHopeList', { no: '1' }).alert, '처리할 수 없는 신청입니다.');
});

test('참여 권유(팀장→프리랜서): 프로젝트가 있어야 하고, 이미 팀이 있는 사람에게는 못 보낸다', () => {
  const ok = run(as('leader01'), 'SpecHopeMsg', { getid: 'member02' });
  assert.equal(ok.state.hopelist.at(-1).log, 0);
  assert.equal(run(as('leader02'), 'SpecHopeMsg', { getid: 'member02' }).alert, '먼저 프로젝트를 등록해주세요.');
  assert.equal(run(as('leader01'), 'SpecHopeMsg', { getid: 'member05' }).alert, '이미 다른 프로젝트를 진행 중인 프리랜서입니다.');
  assert.equal(run(ok.state, 'SpecHopeMsg', { getid: 'member02' }).alert, '이미 참여를 권유한 프리랜서입니다.');
});

test('프로젝트 등록: 진행 중이면 원본처럼 step 2 + check=false, 새 팀장은 등록되고 teamno1이 채워진다', () => {
  const blocked = run(as('leader01'), 'ProjWrite', { step: '0' });
  assert.deepEqual([blocked.model.step, blocked.model.check], [2, false]);
  const form = { step: '1', title: '새 프로젝트', comp: '', startdate: '2026-10-01', enddate: '2026-11-01', recmem: '3', maj: '경영학', cont: '내용입니다', loc: '경기도', sal: '' };
  const out = run(as('leader02'), 'ProjWrite', form);
  assert.equal(out.model.step, 2);
  assert.equal(member(out.state, 'leader02').teamno1, '13');
  const { step, ...fields } = form;
  assert.deepEqual(project(out.state, 13), { teamno: '13', leaderid: 'leader02', ...fields, sal: '', currmem: '1' });
  assert.equal(run(out.state, 'ProjWrite', { step: '0' }).model.check, false, '두 번째 등록은 막힌다');
  assert.equal(run(as('leader02'), 'ProjWrite', { ...form, recmem: 'abc' }).alert, '모집인원은 1~99 사이의 숫자로 입력해주세요');
  assert.equal(run(as('leader02'), 'ProjWrite', { ...form, enddate: '2026-09-01' }).alert, '종료일은 시작일보다 빠를 수 없습니다');
  assert.equal(run(as('member01'), 'ProjWrite').alert, '프로젝트 등록은 팀장 계정만 할 수 있습니다.');
  assert.deepEqual(run(seedState(), 'ProjWrite').redirect, { action: 'Login', params: [] });
});

test('프로젝트 수정·삭제는 등록한 팀장만, 삭제하면 팀원 teamno1과 스크랩도 정리된다', () => {
  assert.equal(run(as('leader03'), 'ProjModify', { teamno: '1', step: '0' }).alert, '자신이 등록한 프로젝트만 수정할 수 있습니다.');
  const mod = run(as('leader01'), 'ProjModify', { teamno: '1', step: '1', title: '바뀐 제목', comp: '', startdate: '', enddate: '', recmem: '5', maj: 'x', cont: 'y', loc: '서울', sal: '' });
  assert.equal(mod.result, 'list');
  assert.equal(project(mod.state, 1).title, '바뀐 제목');
  assert.equal(project(mod.state, 1).currmem, '2', '현재 인원은 유지');
  let s = as('member01');
  s = run(s, 'favProj', { teamno: '1' }).state;
  s.session = { id: 'leader01', name: '', auth: '1' };
  assert.equal(run(s, 'ProjDelete', { teamno: '1', leaderid: 'leader03' }).alert, '자신이 등록한 프로젝트만 삭제할 수 있습니다.');
  s = run(s, 'ProjDelete', { teamno: '1', leaderid: 'leader01' }).state;
  assert.equal(project(s, 1), undefined);
  assert.equal(member(s, 'leader01').teamno1, null);
  assert.equal(member(s, 'member05').teamno1, null);
  assert.equal(s.favoritelist.some((f) => f.teamno === '1'), false);
});

test('스크랩: 중복은 원본 checkError2(error 결과), 취소는 내 스크랩만', () => {
  let s = as('member01');
  const out = run(s, 'favProj', { teamno: ['4', '5'] });
  assert.equal(out.result, 'success');
  s = out.state;
  assert.equal(s.favoritelist.filter((f) => f.id === 'member01').length, 3);
  assert.equal(run(s, 'favProj', { teamno: '4' }).result, 'error');
  assert.equal(run(s, 'favProj', {}).alert, '스크랩할 프로젝트를 선택해주세요.');
  s.favoritelist.push({ artlog: 0, teamno: '4', id: 'member02', leaderid: null });
  s = run(s, 'delProj', { teamno: '4' }).state;
  assert.equal(s.favoritelist.some((f) => f.teamno === '4' && f.id === 'member02'), true, '다른 회원의 스크랩은 남는다');
  assert.equal(run(as('leader01'), 'favSpec', { id: 'member06' }).result, 'error');
  assert.equal(run(as('leader01'), 'favSpec', { id: ['member06', 'member02'] }).result, 'success');
});

test('스펙 등록은 팀원 한 번만, 수정·삭제는 본인만', () => {
  let s = as('member01');
  assert.equal(run(s, 'SpecList').model.check, 0);
  assert.equal(run(s, 'SpecWrite', { exp: '' }).alert, '기존이력을 입력해주세요');
  s = run(s, 'SpecWrite', { exp: '디자인 공모전 2회', showlog: 'on' }).state;
  const spec = s.specreg.find((x) => x.id === 'member01');
  assert.deepEqual([spec.maj, spec.addr, spec.contadd, spec.showlog], ['시각디자인', '경기도', 'UI 디자인 공모전 2회 참여', 1]);
  assert.equal(run(s, 'SpecList').model.check, 1);
  assert.equal(run(s, 'SpecWrite', { exp: '또' }).alert, '이미 글이 등록되어있습니다.');
  s = run(s, 'SpecModify', { step: '1', exp: '수정', maj: '산업디자인', addr: '서울', contadd: '' }).state;
  assert.deepEqual([s.specreg.find((x) => x.id === 'member01').maj, s.specreg.find((x) => x.id === 'member01').showlog], ['산업디자인', 0]);
  assert.equal(run(s, 'SpecDelete', { id: 'member02' }).alert, '자신의 스펙만 삭제할 수 있습니다.');
  assert.equal(run(s, 'SpecDelete', { id: 'member01' }).state.specreg.some((x) => x.id === 'member01'), false);
  assert.equal(run(as('leader01'), 'SpecInfo', { id: 'member07' }).redirect.action, 'SpecList');
});

test('Q&A: 로그인해야 쓰고, 내 질문만 목록·수정·삭제, 검색도 본인만', () => {
  assert.equal(run(seedState(), 'QnaWrite').redirect.action, 'Login');
  let s = as('member01');
  assert.deepEqual(run(s, 'QnaList').model.list.map((q) => q.no), [1]);
  assert.equal(run(s, 'QnaWrite', { step: '1', title: '', cont: 'x' }).alert, '제목을 입력해주세요');
  const out = run(s, 'QnaWrite', { step: '1', title: '데모 질문', cont: '내용' });
  assert.equal(out.result, 'list');
  s = out.state;
  assert.deepEqual(run(s, 'QnaList').model.list.map((q) => q.no), [5, 1]);
  assert.equal(run(s, 'QnaList', { search: '', searchnum: '0' }).model.list.length, 2);
  assert.equal(run(s, 'QnaModify', { no: '2', step: '0' }).alert, '자신이 쓴 질문만 수정할 수 있습니다.');
  s = run(s, 'QnaModify', { no: '5', step: '1', title: '고친 질문', cont: '고친 내용' }).state;
  assert.equal(s.qna.find((q) => q.no === 5).title, '고친 질문');
  const info = run(s, 'QnaInfo', { no: '1' }).model;
  assert.equal(info.resultClass2.id, 'admin');
  assert.equal(run(s, 'QnaDelete', { no: '2' }).alert, '자신이 쓴 질문만 삭제할 수 있습니다.');
  assert.equal(run(s, 'QnaDelete', { no: '5' }).state.qna.some((q) => q.no === 5), false);
});

test('로그인: 원본 check 코드(2 비밀번호 틀림, 3 아이디 없음)와 세션', () => {
  const s = seedState();
  assert.equal(run(s, 'Login', { check: '0', id: 'nobody', pwd: 'demo' }).model.check, '3');
  assert.equal(run(s, 'Login', { check: '0', id: 'leader01', pwd: 'x' }).model.check, '2');
  const ok = run(s, 'Login', { check: '0', id: 'leader01', pwd: 'demo' });
  assert.deepEqual(ok.state.session, { id: 'leader01', name: '데모팀장', auth: '1', expiresAt: NOW.getTime() + 3600000 });
  assert.deepEqual(run(ok.state, 'Logout').state.session, {});
  assert.equal(run(as('leader01'), 'MyPage').model.resultClass.pwd, '********', '비밀번호는 화면에 보이지 않는다');
});

test('실패한 요청은 저장 상태를 바꾸지 않는다', () => {
  const s = as('member05');
  const out = run(s, 'ProjHopeMsg', { getid: 'leader03' });
  assert.equal(out.state, s);
  assert.equal(out.mutated, undefined);
});
