// 원본 WebContent/ 와 src/struts.xml 에서 정적 데모(dist/)를 만든다. 외부 패키지 없이 Node만 쓴다.
import { cpSync, mkdirSync, readdirSync, rmSync, writeFileSync } from 'node:fs';
import { createHash } from 'node:crypto';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';
import { DEMO_ROOT, WEB_ROOT, readSource, looksLikeMojibake } from './lib/source.mjs';
import { compileJsp, templateStrings, TRANSFORMS, DROPPED_SCRIPTS } from './lib/jsp.mjs';
import { loadConfig } from './lib/config.mjs';
import { ACTIONS, UNAVAILABLE } from '../src/actions.js';

const DIST = join(DEMO_ROOT, 'dist');

// 데모에서 그리지 않는 mainpage (도달하는 액션이 모두 UNAVAILABLE)
const EXCLUDED_MAINPAGES = {
  signup: 'SignUp 액션 미제공', findid: 'Find 액션 미제공', findpwd: 'Find 액션 미제공', findresult: 'Find 액션 미제공',
  myprojmodify: '원본에서 이 mainpage를 설정하는 액션이 없음 (프로젝트 수정은 ProjModify → projwrite)',
};
const SHELL = { top: 'top/top.jsp', right: 'right/right.jsp', bottom: 'bottom/bottom.jsp' };

// 정적 결과물에 남으면 안 되는 서버·외부 흔적
export const FORBIDDEN = [
  { re: /<%/, what: 'JSP 스크립틀릿/지시어' },
  { re: /<\/?s:\w+/, what: 'Struts 태그' },
  { re: /<\/?tiles:/, what: 'Tiles 태그' },
  { re: /\$\{/, what: 'EL 식' },
  { re: /localhost/, what: 'localhost 주소' },
  { re: /https?:\/\//, what: '외부 절대 주소' },
  { re: /\/SocialMap\//, what: '원본 컨텍스트 경로' },
  { re: /(?<!#\/)\b[A-Za-z]\w*\.action\b/, what: '어댑터를 거치지 않는 .action 주소' },
  { re: /<img(?![^>]*src="img\/)[^>]*>/, what: '복사하지 않은 이미지 참조' },
  { re: /\beval\(|\bnew Function\(/, what: "CSP(unsafe-eval 없음)에서 막히는 eval" },
];

export function checkStrings(where, strings) {
  for (const s of strings) {
    for (const f of FORBIDDEN) {
      const m = s.match(f.re);
      if (m) throw new Error(`${where}: ${f.what}가 남아 있습니다 → ${JSON.stringify(s.slice(Math.max(0, m.index - 40), m.index + 40))}`);
    }
  }
}

function collectActionRefs(nodes, out = new Set()) {
  for (const s of templateStrings(nodes)) for (const m of s.matchAll(/#\/(\w+)\.action/g)) out.add(m[1]);
  const walk = (list) => list.forEach((n) => {
    if (!n || typeof n !== 'object') return;
    if (n.url) out.add(n.action);
    ['body', 'else'].forEach((k) => Array.isArray(n[k]) && walk(n[k]));
    if (n.if) n.if.forEach(([, b]) => walk(b));
  });
  walk(nodes);
  return out;
}

export function build() {
  const { struts, tiles, homepage } = loadConfig();

  // mainpage → JSP 경로 (homepage.jsp 분기 → tiles 속성 → JSP)
  const mainpages = {};
  for (const [mainpage, attr] of Object.entries(homepage)) {
    if (EXCLUDED_MAINPAGES[mainpage]) continue;
    if (!tiles[attr]) throw new Error(`tiles-service.xml 에 속성 ${attr} 이(가) 없습니다`);
    mainpages[mainpage] = tiles[attr];
  }

  // struts.xml 의 모든 액션은 모의 어댑터에 있거나 명시적으로 미제공이어야 한다.
  const missing = Object.keys(struts).filter((a) => !ACTIONS[a] && !UNAVAILABLE[a]);
  if (missing.length) throw new Error(`모의 어댑터에 없는 struts 액션: ${missing.join(', ')}`);
  const extra = Object.keys(ACTIONS).filter((a) => !struts[a]);
  if (extra.length) throw new Error(`struts.xml 에 없는 모의 액션: ${extra.join(', ')}`);

  // 구현한 액션이 바로 보여 주는 JSP (admin 결과는 관리자 계정이 없어 제외)
  const direct = new Set();
  for (const [name, a] of Object.entries(struts)) {
    if (!ACTIONS[name]) continue;
    for (const [rname, r] of Object.entries(a.results)) {
      if (rname !== 'admin' && r.type !== 'chain' && r.target !== '/socialMap.tiles') direct.add(r.target.replace(/^\//, ''));
    }
  }

  const jsps = [...new Set([...Object.values(SHELL), ...Object.values(mainpages), ...direct])].sort();
  const templates = {};
  const sourceMap = { generatedFrom: 'WebContent/, src/struts.xml, WebContent/WEB-INF/tiles-service.xml', transforms: TRANSFORMS.map(({ id, why }) => ({ id, why })), droppedScripts: DROPPED_SCRIPTS.map(({ id, why }) => ({ id, why })), templates: {} };
  const refs = new Set();
  const sheets = new Set(['css/header.css']);
  for (const jsp of jsps) {
    const { text, encoding } = readSource(jsp);
    if (looksLikeMojibake(text)) throw new Error(`${jsp}: 해독 결과가 깨져 보입니다`);
    const page = compileJsp(text, `WebContent/${jsp}`);
    checkStrings(`WebContent/${jsp}`, [...templateStrings(page.template), ...page.headScripts.flatMap((s) => templateStrings(s))]);
    collectActionRefs(page.template, refs);
    page.headScripts.forEach((s) => collectActionRefs(s, refs));
    page.stylesheets.forEach((s) => sheets.add(s));
    templates[jsp] = { title: page.title, stylesheets: page.stylesheets, headScripts: page.headScripts, template: page.template };
    sourceMap.templates[jsp] = {
      source: `WebContent/${jsp}`, encoding, sha256: createHash('sha256').update(text).digest('hex').slice(0, 16),
      transforms: page.transforms, droppedScripts: page.droppedScripts,
    };
  }
  const unknownRefs = [...refs].filter((a) => !ACTIONS[a] && !UNAVAILABLE[a]);
  if (unknownRefs.length) throw new Error(`템플릿이 가리키지만 어댑터에 없는 액션: ${unknownRefs.join(', ')}`);

  // ---------- 결과물 쓰기 ----------
  rmSync(DIST, { recursive: true, force: true });
  mkdirSync(join(DIST, 'css'), { recursive: true });
  mkdirSync(join(DIST, 'js'), { recursive: true });
  mkdirSync(join(DIST, 'app'), { recursive: true });

  for (const sheet of sheets) writeFileSync(join(DIST, sheet), readSource(sheet).text);
  // 원본 Homepage/homepage.jsp 가 불러오던 스크립트 (jQuery 1.12.4는 MIT 라이선스, 머리 주석 유지)
  const home = readSource('Homepage/homepage.jsp').text;
  const scripts = [...home.matchAll(/<script[^>]*src="([^"]+)"/g)].map((m) => m[1]);
  for (const s of scripts) writeFileSync(join(DIST, s), readSource(s).text);

  for (const f of readdirSync(join(DEMO_ROOT, 'src'))) {
    if (f.endsWith('.js') || f.endsWith('.css')) cpSync(join(DEMO_ROOT, 'src', f), join(DIST, 'app', f));
  }
  cpSync(join(DEMO_ROOT, 'src', 'img'), join(DIST, 'img'), { recursive: true });

  const routes = Object.fromEntries(Object.entries(struts).map(([k, v]) => [k, { results: v.results }]));
  writeFileSync(join(DIST, 'app', 'templates.js'),
    `// 빌드 산출물: 원본 JSP·struts.xml·tiles-service.xml 에서 생성 (scripts/build.mjs). 직접 고치지 마세요.\n`
    + `export const TEMPLATES = ${JSON.stringify(templates)};\n`
    + `export const ROUTES = ${JSON.stringify(routes)};\n`
    + `export const MAINPAGES = ${JSON.stringify(mainpages)};\n`
    + `export const SHELL = ${JSON.stringify(SHELL)};\n`);

  const title = (home.match(/<title>([^<]*)<\/title>/) || [, 'SocialMap'])[1].trim();
  const pageSheets = [...sheets].filter((s) => s !== 'css/header.css').sort();
  const csp = "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; connect-src 'none'; form-action 'self'; base-uri 'none'; object-src 'none'";
  writeFileSync(join(DIST, 'index.html'), `<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Security-Policy" content="${csp}">
<meta name="description" content="SocialMap 원본 JSP 화면을 그대로 옮긴 정적 데모 (모의 데이터)">
<title>${title}</title>
<link rel="icon" href="img/favicon.svg" type="image/svg+xml">
<link rel="stylesheet" href="css/header.css" data-sheet="css/header.css">
${pageSheets.map((s) => `<link rel="stylesheet" href="${s}" data-sheet="${s}" disabled>`).join('\n')}
<link rel="stylesheet" href="app/demo.css">
${scripts.map((s) => `<script src="${s}"></script>`).join('\n')}
<script type="module" src="app/app.js"></script>
</head>
<body>
<!-- 원본 Homepage/homepage.jsp 의 Tiles 배치: top · (본문 + floatMenu[right]) · bottom -->
<div id="sm-top"></div>
<div>
<main id="sm-main" tabindex="-1"><noscript><p>이 데모는 자바스크립트가 필요합니다.</p></noscript></main>
<div class="floatMenu" id="sm-right"></div>
</div>
<div id="sm-bottom"></div>
<div id="sm-demo-bar" role="region" aria-label="데모 안내"><p class="sm-demo-notice"><strong>원본 프로젝트 기반 데모 · 모의 데이터 · 신청·글은 외부로 전송되지 않습니다</strong></p></div>
<dialog id="sm-popup" aria-labelledby="sm-popup-title"><div class="sm-popup-head"><strong class="sm-popup-title" id="sm-popup-title"></strong><button type="button" onclick="SM.closePopup()" aria-label="닫기">×</button></div><div class="sm-popup-body"></div></dialog>
<div id="sm-toast" aria-live="polite"></div>
</body>
</html>
`);
  writeFileSync(join(DIST, 'source-map.json'), `${JSON.stringify(sourceMap, null, 2)}\n`);
  return { templates: Object.keys(templates), mainpages, sheets: [...sheets], scripts };
}

if (import.meta.url === pathToFileURL(process.argv[1]).href) {
  const r = build();
  console.log(`dist/ 생성: 템플릿 ${r.templates.length}개, CSS ${r.sheets.length}개, 원본 스크립트 ${r.scripts.join(', ')}`);
}
