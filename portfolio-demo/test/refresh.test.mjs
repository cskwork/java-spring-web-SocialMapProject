// 2026-09-26 recruitment refresh: summaries and lifecycle come from stored projects and applications.
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

import { readFileSync } from 'node:fs';

test('home pulse counts only open projects and links each region to the real filter', () => {
  const s = seedState();
  const open = s.projectteam.filter((p) => Number(p.recmem) > 0);
  const home = go(s, 'SocialMap');
  assert.match(home.html, new RegExp(`<strong>${open.length}개 프로젝트</strong>가 팀원 <strong>${open.reduce((a, p) => a + Number(p.recmem), 0)}명</strong>`));
  const region = open[0].loc;
  assert.match(home.html, new RegExp(`href="#/ProjList\\.action\\?loc=${encodeURIComponent(region).replace(/%/g, '%')}"`));
  const filtered = go(s, 'ProjList', { loc: region });
  assert.ok((filtered.html.match(/class="list"/g) || []).length >= open.filter((p) => p.loc === region).length);
  assert.equal((home.html.match(/<article>/g) || []).length, 3);
  assert.match(home.html, /class="sm-desc"/);
  assert.doesNotMatch(home.html, /받은 신청<\/dt>/, 'visitors see no personal counts');
  const leader = go(login('leader01'), 'SocialMap');
  const received = seedState().hopelist.filter((h) => h.getid === 'leader01').length;
  assert.match(leader.html, new RegExp(`받은 신청</dt><dd>${received}건`));
  assert.match(leader.html, /캠퍼스 스터디 매칭 앱/);
});

test('project detail shows description, conditions and state chip without the read-only textarea', () => {
  const info = go(login('member01'), 'ProjInfo', { teamno: '1' });
  assert.match(info.html, /class="sm-preserve"/);
  assert.doesNotMatch(info.html, /<textarea disabled/);
  assert.match(info.html, /모집 중 · 추가 2명/);
  assert.match(info.html, /value="프로젝트 참여 희망"/);
  const closed = go(login('member01'), 'ProjInfo', { teamno: '11' });
  assert.match(closed.html, /sm-chip closed">모집 마감/);
});

test('my project lifecycle and received applications reflect the recruitment state', () => {
  let s = login('leader01');
  const list = go(s, 'MyProjList');
  assert.match(list.html, /3명 \/ 추가 1명|2명 \/ 추가 2명/);
  assert.match(list.html, /class="current">모집 중 · 추가 2명/);
  const hope = go(s, 'hopeList');
  assert.match(hope.html, /<th><strong>신청일<\/strong><\/th>/);
  assert.match(hope.html, /2026-09-24 10:00/);
  assert.match(hope.html, /시각디자인/, 'sender major from member record');
  s = go(s, 'insertTeam', { no: '1', id: 'member03', leaderid: 'leader01' }).state;
  s = go(s, 'ProjLifecycle', { teamno: '1', status: 'closed', csrf: s.session.csrf }).state;
  assert.match(go(s, 'MyProjList').html, /class="current">모집 마감 · 3명 확정/);
  s = go(s, 'ProjLifecycle', { teamno: '1', status: 'completed', csrf: s.session.csrf }).state;
  assert.match(go(s, 'MyProjList').html, /등록된 게시물이 없습니다/, 'completion releases membership, as the lifecycle action already does');
});

test('edited JSPs stay EUC-KR on disk', () => {
  for (const f of ['main/main.jsp', 'content/project/info.jsp', 'mypage/myproject/list.jsp', 'mypage/hopelist/list.jsp']) {
    const bytes = readFileSync(new URL(`../../WebContent/${f}`, import.meta.url));
    assert.throws(() => new TextDecoder('utf-8', { fatal: true }).decode(bytes), f);
    assert.match(new TextDecoder('euc-kr').decode(bytes), /<%@ page language="java" contentType="text\/html; charset=EUC-KR"/);
  }
});
