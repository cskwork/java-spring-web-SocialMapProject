import { test, before } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, readdirSync } from 'node:fs';
import { join } from 'node:path';
import { build, FORBIDDEN } from '../scripts/build.mjs';
import { compileMarkup, compileJsp, contextAt, templateStrings } from '../scripts/lib/jsp.mjs';
import { readSource, DEMO_ROOT, looksLikeMojibake } from '../scripts/lib/source.mjs';
import { render } from '../src/render.js';
import { parse, evaluate } from '../src/ognl.js';

const DIST = join(DEMO_ROOT, 'dist');
let templates;
before(async () => {
  build();
  ({ TEMPLATES: templates } = await import(`../dist/app/templates.js?t=${Date.now()}`));
});

test('원본 JSP에 쓰인 OGNL 식을 Struts와 같은 뜻으로 계산한다', () => {
  const scope = (model, session = {}, vars = {}) => ({ stack: [model], vars, ctx: { session } });
  assert.equal(evaluate('list.size()<=0', scope({ list: [] })), true);
  assert.equal(evaluate('#session.auth == 2', scope({}, { auth: '2' })), true, '"2" == 2');
  assert.equal(evaluate("mainpage == null || mainpage == ('main')", scope({ mainpage: null })), true);
  assert.equal(evaluate('!check', scope({ check: false })), true);
  assert.equal(evaluate('%{complist[#stat.index]}', scope({ complist: ['a', 'b'] }, {}, { stat: { index: 1 } })), 'b');
  assert.equal(evaluate("id == null || id == ''", scope({ id: '' })), true);
  assert.equal(evaluate('#stat1.index < 5', scope({}, {}, { stat1: { index: 4 } })), true);
  assert.throws(() => parse('list.stream().count()'), /지원하지 않는 메서드/);
  assert.throws(() => parse('a ? b : c'), /해석할 수 없는|예상하지 못한/);
});

test('값은 출력 위치에 맞게 이스케이프되어 스크립트를 주입할 수 없다', () => {
  const t = compileMarkup(`<td><s:property value="title"/></td>
<input type="button" onclick="javascript:location.href='QnaDelete.action?no=<s:property value="no"/>'">
<a href="javascript:sendMajor('<s:property value="maj"/>')">x</a>
<input type="text" value="<s:property value='title'/>">`, 'test');
  const html = render(t, { title: '"><img src=x onerror=alert(1)>', no: "1');alert(1);('", maj: "a');alert(1);//" });
  assert.doesNotMatch(html, /<img/);
  assert.match(html, /&quot;&gt;&lt;img src=x onerror=alert\(1\)&gt;/);
  assert.match(html, /no=1%27\)%3Balert\(1\)%3B\(%27'/, 'JS 안 URL 값은 퍼센트 인코딩');
  assert.ok(html.includes("sendMajor('a\\u0027\\u0029\\u003balert\\u00281\\u0029\\u003b\\u002f\\u002f')"), 'JS 문자열 값은 \\u 이스케이프');
});

test('출력 문맥 판별', () => {
  assert.equal(contextAt('<td>'), 'html');
  assert.equal(contextAt('<input value="'), 'html');
  assert.equal(contextAt(`<input onclick="location.href='X.action?id=`), 'jsurl');
  assert.equal(contextAt('<script>location.href="X.action?id='), 'jsurl');
  assert.equal(contextAt('<a href="#/X.action?id='), 'url');
});

test('지원 목록 밖의 태그·스크립틀릿·raw 출력은 빌드를 멈춘다', () => {
  assert.throws(() => compileMarkup('<s:select list="x"/>', 't'), /지원하지 않는 Struts 태그/);
  assert.throws(() => compileMarkup('<s:property value="cont" escape="false"/>', 't'), /escape="false"/);
  assert.throws(() => compileJsp('<body><% out.print(1); %></body>', 't'), /스크립틀릿/);
  assert.throws(() => compileMarkup('<s:if test="a">x', 't'), /닫히지 않은/);
  assert.throws(() => compileMarkup('<s:else>x</s:else>', 't'), /<s:if> 가 없습니다/);
});

test('원본 목록 화면 마크업이 그대로 쓰인다 (표 구조·필드·버튼)', () => {
  const src = readSource('content/project/list.jsp').text;
  const page = templates['content/project/list.jsp'];
  const html = render(page.template, {
    list: [{ teamno: '7', leaderid: 'leader08', title: '민원 신청 화면 개선안', comp: 'c', maj: 'm', startdate: '2026-10-10', enddate: '2026-11-28', currmem: '2', recmem: '2', loc: '세종', sal: '0' }],
    complist: ['c'], loclist: ['세종'], majlist: ['m'], check: true, pagingHtml: '',
  }, { auth: '2' });
  for (const piece of ['<table class="listtable sm-project-list">', '<td><strong>현재 참여 / 추가 모집</strong></td>', '<select name="searchnum">', '<input type="submit" value="스크랩하기"/>']) {
    assert.ok(src.includes(piece), `원본에 ${piece}`);
    assert.ok(html.includes(piece), `결과에 ${piece}`);
  }
  assert.match(html, /<a href="#\/ProjInfo\.action\?leaderid=leader08&amp;teamno=7">민원 신청 화면 개선안<\/a>/);
  assert.match(html, /<input type="checkbox" name="teamno" value="7">/);
});

test('dist 결과물에 서버 태그·외부 주소·깨진 한글·복사하지 않은 이미지가 없다', () => {
  for (const [jsp, page] of Object.entries(templates)) {
    const strings = [...templateStrings(page.template), ...page.headScripts.flatMap((s) => templateStrings(s)), page.title];
    for (const s of strings) {
      for (const f of FORBIDDEN) assert.doesNotMatch(s, f.re, `${jsp}: ${f.what}`);
      assert.equal(looksLikeMojibake(s), false, jsp);
    }
  }
  const index = readFileSync(join(DIST, 'index.html'), 'utf8');
  assert.match(index, /connect-src 'none'/);
  assert.match(index, /원본 프로젝트 기반 데모 · 모의 데이터 · 신청·글은 외부로 전송되지 않습니다/);
  const files = readdirSync(DIST, { recursive: true }).map(String);
  assert.deepEqual(files.filter((f) => /\.(png|jpe?g|gif|PNG|eot|ttf|woff|otf)$/.test(f)), [], '원본 이미지·폰트를 복사하지 않는다');
  assert.ok(!files.some((f) => /sqlMapConfig|web\.xml|\.java$|\.class$/.test(f)), '설정·백엔드 파일을 내보내지 않는다');
});

test('데모 코드는 네트워크를 쓰지 않는다 (막는 코드만 있다)', () => {
  for (const f of readdirSync(join(DIST, 'app'))) {
    const code = readFileSync(join(DIST, 'app', f), 'utf8');
    const uses = code.replace(/window\.fetch = [^\n]*|XMLHttpRequest\.prototype\.open = [^\n]*|navigator\.sendBeacon[^\n]*/g, '');
    assert.doesNotMatch(uses, /\bfetch\(|XMLHttpRequest|sendBeacon|WebSocket|EventSource|\$\.(ajax|get|post|getJSON)\(/, f);
  }
});

test('모든 템플릿이 원본 JSP에서 왔고 변환 기록이 남는다', () => {
  const map = JSON.parse(readFileSync(join(DIST, 'source-map.json'), 'utf8'));
  assert.deepEqual(Object.keys(map.templates).sort(), Object.keys(templates).sort());
  assert.equal(map.templates['content/project/list.jsp'].encoding, 'euc-kr');
  assert.ok(map.templates['content/project/list.jsp'].droppedScripts.includes('jquery-ui-datepicker'));
  assert.ok(map.templates['top/top.jsp'].transforms['logo-image'] === 1);
});
