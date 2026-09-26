// 원본 JSP를 정적 데모용 템플릿 트리로 옮긴다. 범용 JSP 해석기가 아니라,
//  1) 아래 TRANSFORMS 목록의 명시적 문자열 치환을 적용하고
//  2) 원본에 실제로 쓰인 Struts 태그 부분집합(property, iterator, if/elseif/else, url/param, a,
//     hidden, checkbox, textfield, password, textarea, submit)과 ${EL}만 트리로 바꾼다.
// 목록에 없는 태그·스크립틀릿·식은 빌드 오류로 멈춘다.
import { parse as parseOgnl } from '../../src/ognl.js';

// 적용 순서대로. 각 항목은 source-map.json에 적용 횟수와 함께 기록된다.
export const TRANSFORMS = [
  {
    id: 'action-url',
    why: '서버 액션 주소(http://localhost:8080/SocialMap/X.action, /SocialMap/X.action, X.action)를 모의 어댑터가 처리하는 해시 주소 #/X.action 으로 바꾼다.',
    pattern: /(?:https?:\/\/localhost:8080)?(?:\/SocialMap\/)?(?:(?:mypage|Rating)\/)*\b([A-Za-z]\w*)\.action\b/g,
    replace: '#/$1.action',
  },
  {
    id: 'popup-window',
    why: 'window.open 팝업(전공 찾기·쪽지·평점·탈퇴)을 같은 페이지 안의 대화상자(SM.openPopup)로 연다.',
    pattern: /window\.open\(/g,
    replace: 'SM.openPopup(',
  },
  {
    id: 'popup-opener',
    why: 'MajorCheck.jsp의 opener/self.close()를 대화상자 기준으로 바꾼다.',
    pattern: /opener\.document\.|self\.close\(\)|this\.close\(\)/g,
    replace: (m) => (m.startsWith('opener') ? 'document.' : 'SM.closePopup()'),
  },
  {
    id: 'logo-image',
    why: '로고 이미지(images/logo.png)는 출처·라이선스가 확인되지 않아 복사하지 않고 글자 로고 SVG로 대신한다.',
    pattern: /<img src="images\/logo\.png" alt="[^"]*"\s*\/?>/g,
    replace: '<img src="img/logo.svg" alt="SocialMap" class="demo-logo" />',
  },
  {
    id: 'menu-icons',
    why: '메뉴 열기/닫기 아이콘(menu.png, close.png)을 데모용 SVG로 바꾼다. main.js가 img 클릭을 그대로 쓴다.',
    pattern: /images\/(menu|close)\.png/g,
    replace: 'img/$1.svg',
  },
  {
    id: 'decorative-icons',
    why: '출처가 확인되지 않은 장식 아이콘(login/guide/search/proj_reg/spec_reg/comp.png)은 빼고 글자만 남긴다.',
    pattern: /<img src="images\/(?:login|guide|search_1|search_2|proj_reg|spec_reg|comp)\.png" alt="[^"]*"\s*\/?>/g,
    replace: '',
  },
  {
    id: 'guide-screenshots',
    why: '가이드 화면 캡처(guide/images/*.png)는 원본 운영 화면·데이터가 찍혀 있을 수 있어 빼고 안내 문구로 대신한다.',
    pattern: /<img src="guide\/images\/(guide_\d+)\.png"[^>]*>/g,
    replace: '<span class="demo-omitted">원본 안내 화면 캡처($1)는 데모에서 제외했습니다.</span>',
  },
  {
    id: 'competition-poster',
    why: '대회 포스터 업로드 파일(upload/file_N.PNG)은 외부 저작물이라 복사하지 않고 제목 카드로 대신한다.',
    pattern: /<img[^>]*src="\/SocialMap\/upload\/file_<s:property value='([\w.]+)'\/>\.PNG"[^>]*>/g,
    replace: (m, expr) => (expr === 'no'
      ? '<span class="demo-poster"><s:property value="title"/></span>'
      : '<span class="demo-poster">포스터 이미지는 데모에서 제외했습니다</span>'),
  },
  {
    id: 'carousel-bullets',
    why: '포스터 슬라이드 점 버튼(d1.jpg/d2.jpg 배경)은 슬라이드 스크립트와 함께 뺀다. TOP 5는 가로 스크롤 카드로 보인다.',
    pattern: /<ul id="main_scroll_bt">[\s\S]*?<\/ul>/g,
    replace: '',
  },
  {
    id: 'footer-image-credit',
    why: '배경 사진을 복사하지 않으므로 푸터의 Unsplash 사진 출처 문구도 뺀다.',
    pattern: /\s*Images: Unsplash \(<a href="http:\/\/unsplash\.com\/cc0">SocialMap<\/a>\)/g,
    replace: '',
  },
];

// $(function(){ ... }) 호출 한 덩어리를 괄호 짝으로 찾아 뺀다. (문자열 안의 괄호는 원본 해당 블록에 없다)
function stripReadyBlock(code, marker) {
  let from = 0;
  for (;;) {
    const start = code.indexOf('$(function', from);
    if (start < 0) return code;
    let depth = 0;
    let end = -1;
    for (let i = start; i < code.length; i += 1) {
      if (code[i] === '(' || code[i] === '{') depth += 1;
      else if (code[i] === ')' || code[i] === '}') {
        depth -= 1;
        if (depth === 0) { end = code.indexOf(';', i) + 1 || i + 1; break; }
      }
    }
    if (end < 0) throw new Error('$(function 블록의 괄호 짝이 맞지 않습니다');
    if (code.slice(start, end).includes(marker)) return code.slice(0, start) + code.slice(end);
    from = end;
  }
}

// 원본 페이지의 인라인 스크립트 중 정적 데모에서 뺄 것. strip이 있으면 그 부분만 빼고 나머지(예: plusFun)는 남긴다.
export const DROPPED_SCRIPTS = [
  { id: 'jquery-ui-datepicker', test: /datepicker/, strip: (code) => stripReadyBlock(code, 'datepicker'), why: 'jQuery UI(외부 CDN)가 필요하고 대상 입력칸(#fromDate/#toDate)이 원본 화면에 없다. 해당 $(function(){...}) 블록만 뺀다.' },
  { id: 'float-menu-animate', test: /floatMenu/, why: '떠 있는 고객센터 메뉴는 셸 레이아웃이 CSS로 처리한다.' },
  { id: 'poster-carousel', test: /main_scroll/, why: '포스터 이미지를 복사하지 않으므로 이미지 슬라이드도 뺀다.' },
];

const UI_ATTRS = {
  hidden: ['name', 'value', 'id'],
  checkbox: ['name', 'fieldValue', 'id', 'value'],
  textfield: ['name', 'value', 'id', 'maxlength', 'cssStyle', 'onfocus', 'placeholder'],
  password: ['name', 'value', 'id', 'maxlength', 'cssStyle', 'onfocus'],
  textarea: ['name', 'value', 'id', 'rows', 'cols', 'cssStyle'],
  submit: ['value', 'cssStyle', 'id', 'name'],
};

function applyTransforms(text, log) {
  let out = text;
  for (const t of TRANSFORMS) {
    let n = 0;
    out = out.replace(t.pattern, (...args) => {
      n += 1;
      return typeof t.replace === 'function' ? t.replace(...args) : args[0].replace(new RegExp(t.pattern.source), t.replace);
    });
    if (n) log[t.id] = (log[t.id] || 0) + n;
  }
  return out;
}

function parseAttrs(src, where) {
  const attrs = {};
  const re = /([\w-]+)\s*=\s*(?:"([^"]*)"|'([^']*)')/g;
  let m;
  let rest = src;
  while ((m = re.exec(src))) attrs[m[1]] = m[2] ?? m[3];
  rest = src.replace(re, '').trim();
  if (rest) throw new Error(`${where}: 해석할 수 없는 태그 속성 ${JSON.stringify(rest)}`);
  return attrs;
}

const stripOgnl = (v) => v.trim().replace(/^%\{([\s\S]*)\}$/, '$1');

function checkExpr(expr, where) {
  try {
    parseOgnl(expr);
  } catch (e) {
    throw new Error(`${where}: ${e.message}`);
  }
  return expr;
}

// 지금까지 출력된 글자를 보고 값이 들어갈 문맥을 정한다: 본문(html), URL(url), JS 문자열(js), JS 안의 URL 값(jsurl)
export function contextAt(emitted) {
  const lastScriptOpen = emitted.lastIndexOf('<script');
  if (lastScriptOpen > emitted.lastIndexOf('</script')) {
    return /[?&][\w]+=$/.test(emitted) ? 'jsurl' : 'js';
  }
  const lt = emitted.lastIndexOf('<');
  if (lt > emitted.lastIndexOf('>')) {
    const tag = emitted.slice(lt);
    const m = tag.match(/([\w-]+)\s*=\s*"([^"]*)$/) || tag.match(/([\w-]+)\s*=\s*'([^']*)$/);
    if (!m) throw new Error(`태그 속성 밖에 값을 출력할 수 없습니다: ${JSON.stringify(tag.slice(0, 60))}`);
    const [, name, value] = m;
    if (/^on/i.test(name) || /^\s*javascript:/i.test(value)) return /[?&][\w]+=$/.test(value) ? 'jsurl' : 'js';
    if (/^(href|action|src)$/i.test(name)) return 'url';
    return 'html';
  }
  return 'html';
}

function attrParts(value, mode, where) {
  const parts = [];
  let last = 0;
  const re = /%\{([^}]*)\}/g;
  let m;
  while ((m = re.exec(value))) {
    if (m.index > last) parts.push(value.slice(last, m.index));
    parts.push({ p: checkExpr(m[1].trim(), where), m: mode });
    last = re.lastIndex;
  }
  if (last < value.length) parts.push(value.slice(last));
  return parts;
}

function escapeAttr(s) {
  return s.replace(/&(?!(?:[a-z]+|#\d+);)/gi, '&amp;').replace(/"/g, '&quot;');
}

// JSP 본문(태그 포함 문자열)을 템플릿 트리로 바꾼다.
export function compileMarkup(src, where, { allowRaw = ['pagingHtml'], inScript = false } = {}) {
  const TAG = /<s:(\w+)((?:\s+[\w-]+\s*=\s*(?:"[^"]*"|'[^']*'))*)\s*(\/?)>|<\/s:(\w+)\s*>|\$\{([^}]+)\}/g;
  const root = { children: [] };
  const stack = [root];
  // 머리말 스크립트는 <script> 안이라는 문맥에서 시작한다.
  let emitted = inScript ? '<script>' : '';
  let last = 0;
  const top = () => stack[stack.length - 1];
  const pushText = (t) => {
    if (!t) return;
    emitted += t;
    const kids = top().children;
    if (typeof kids[kids.length - 1] === 'string') kids[kids.length - 1] += t;
    else kids.push(t);
  };
  const prop = (expr, escape) => {
    const mode = escape === 'false' ? 'raw' : contextAt(emitted);
    if (mode === 'raw' && !allowRaw.includes(expr)) throw new Error(`${where}: escape="false" 는 ${allowRaw.join(', ')} 에만 허용합니다 (${expr})`);
    top().children.push({ p: checkExpr(expr, where), m: mode });
  };
  let m;
  while ((m = TAG.exec(src))) {
    pushText(src.slice(last, m.index));
    last = TAG.lastIndex;
    const [, open, rawAttrs, selfClose, close, el] = m;
    if (el !== undefined) { prop(el.trim(), undefined); continue; }
    if (close) {
      const node = stack.pop();
      if (!node || node.tag !== close) throw new Error(`${where}: </s:${close}> 짝이 맞지 않습니다`);
      node.finish();
      continue;
    }
    const a = parseAttrs(rawAttrs, `${where} <s:${open}>`);
    const kids = top().children;
    switch (open) {
      case 'property':
        prop(a.value === undefined ? '' : stripOgnl(a.value), a.escape);
        break;
      case 'iterator': {
        const node = { each: checkExpr(stripOgnl(a.value), where), status: a.status || null, body: [] };
        kids.push(node);
        stack.push({ tag: open, children: node.body, finish() {} });
        break;
      }
      case 'if':
      case 'elseif':
      case 'else': {
        let target;
        const body = [];
        if (open === 'if') {
          target = { if: [[checkExpr(a.test, where), body]], else: null };
          kids.push(target);
        } else {
          while (typeof kids[kids.length - 1] === 'string' && !kids[kids.length - 1].trim()) kids.pop();
          target = kids[kids.length - 1];
          if (!target || !('if' in target) || target.else) throw new Error(`${where}: <s:${open}> 앞에 <s:if> 가 없습니다`);
          if (open === 'elseif') target.if.push([checkExpr(a.test, where), body]);
          else target.else = body;
        }
        if (selfClose) break;
        stack.push({ tag: open, children: body, finish() {} });
        break;
      }
      case 'url': {
        const node = { url: a.id, action: a.action.replace(/^#\//, '').replace(/\.action$/, ''), params: [] };
        kids.push(node);
        if (!selfClose) stack.push({ tag: open, children: [], finish() {} , node });
        break;
      }
      case 'param': {
        const parent = top();
        if (parent.tag !== 'url') throw new Error(`${where}: <s:param> 은 <s:url> 안에서만 씁니다`);
        const holder = { tag: open, children: [], finish() {
          const props = this.children.filter((c) => typeof c !== 'string' || c.trim());
          if (props.length !== 1 || typeof props[0] === 'string' || !('p' in props[0])) throw new Error(`${where}: <s:param name="${a.name}"> 안에는 <s:property> 하나만 둡니다`);
          parent.node.params.push([a.name, props[0].p]);
        } };
        stack.push(holder);
        break;
      }
      case 'a': {
        const mode = /^\s*javascript:/i.test(a.href || '') ? 'js' : 'html';
        const node = { el: 'a', attrs: [['href', attrParts(a.href || '', mode, where)]], body: [] };
        kids.push(node);
        stack.push({ tag: open, children: node.body, finish() {} });
        break;
      }
      case 'hidden':
      case 'checkbox':
      case 'textfield':
      case 'password':
      case 'textarea':
      case 'submit': {
        const allowed = UI_ATTRS[open];
        for (const k of Object.keys(a)) {
          if (k !== 'theme' && !allowed.includes(k)) throw new Error(`${where}: <s:${open}> 의 ${k} 속성은 지원하지 않습니다`);
        }
        const attrs = [];
        const lit = (k, v) => attrs.push([k, [escapeAttr(v)]]);
        const valueParts = () => {
          if (a.value !== undefined) return attrParts(a.value, 'html', where);
          // 원본 Struts UI 태그처럼 value가 없으면 name 속성의 값을 채운다.
          return a.name ? [{ p: checkExpr(a.name, where), m: 'html' }] : [];
        };
        if (open === 'textarea') {
          for (const k of ['name', 'id', 'rows', 'cols']) if (a[k] !== undefined) lit(k, a[k]);
          if (a.cssStyle) lit('style', a.cssStyle);
          const node = { el: 'textarea', attrs, body: valueParts() };
          kids.push(node);
          if (!selfClose) stack.push({ tag: open, children: [], finish() {} });
          break;
        }
        const type = { hidden: 'hidden', checkbox: 'checkbox', textfield: 'text', password: 'password', submit: 'submit' }[open];
        lit('type', type);
        for (const k of ['name', 'id', 'maxlength', 'placeholder', 'onfocus']) if (a[k] !== undefined) lit(k, a[k]);
        if (open === 'checkbox') attrs.push(['value', attrParts(a.fieldValue || 'true', 'html', where)]);
        else if (open === 'submit') lit('value', a.value || 'Submit');
        else if (open !== 'password') attrs.push(['value', valueParts()]);
        if (a.cssStyle) lit('style', a.cssStyle);
        kids.push({ el: 'input', attrs });
        if (!selfClose) stack.push({ tag: open, children: [], finish() {} });
        break;
      }
      default:
        throw new Error(`${where}: 지원하지 않는 Struts 태그 <s:${open}>`);
    }
  }
  pushText(src.slice(last));
  if (stack.length !== 1) throw new Error(`${where}: 닫히지 않은 태그 <s:${top().tag}>`);
  return root.children;
}

// JSP 한 파일을 템플릿 정보로 바꾼다.
export function compileJsp(text, where) {
  const log = {};
  let src = text;
  src = src.replace(/<%--[\s\S]*?--%>/g, '');
  src = src.replace(/<%@[\s\S]*?%>/g, '');
  if (/<%/.test(src)) throw new Error(`${where}: 스크립틀릿(<% %>)은 지원하지 않습니다`);
  src = src.replace(/<\?xml[\s\S]*?\?>/g, '').replace(/<!DOCTYPE[^>]*>/gi, '');
  src = src.replace(/<!--[\s\S]*?-->/g, '');
  if (/<tiles:/.test(src)) throw new Error(`${where}: Tiles 레이아웃은 셸에서 따로 처리합니다`);

  const bodyMatch = src.match(/<body[^>]*>([\s\S]*)<\/body>/i);
  if (!bodyMatch) throw new Error(`${where}: <body> 가 없습니다`);
  let body = bodyMatch[1];
  const outside = src.slice(0, bodyMatch.index) + src.slice(bodyMatch.index + bodyMatch[0].length);

  const stylesheets = [...outside.matchAll(/<link[^>]*rel="stylesheet"[^>]*href="([^"]+)"[^>]*>|<link[^>]*href="([^"]+)"[^>]*rel="stylesheet"[^>]*>/g)]
    .map((m) => (m[1] || m[2]).replace(/^\/SocialMap\//, ''));
  const titleMatch = outside.match(/<title>([\s\S]*?)<\/title>/i);
  const title = titleMatch ? titleMatch[1].trim() : '';

  const dropped = [];
  // 규칙에 걸린 스크립트는 strip으로 해당 부분만 빼거나(나머지가 비면 통째로) 뺀다.
  const cleanScript = (code) => {
    let out = code;
    for (const rule of DROPPED_SCRIPTS) {
      if (!rule.test.test(out)) continue;
      dropped.push(rule.id);
      out = rule.strip ? rule.strip(out) : '';
    }
    return out.trim() ? out : null;
  };
  const headScripts = [...outside.matchAll(/<script\b([^>]*)>([\s\S]*?)<\/script>/gi)]
    .filter(([, attrs]) => !/\bsrc=/.test(attrs))
    .map(([, , code]) => cleanScript(code))
    .filter((code) => code !== null)
    .map((code) => compileMarkup(applyTransforms(code, log), `${where} <head> script`, { inScript: true }));

  // 본문 안의 외부 스크립트(src=)는 셸이 한 번만 불러오므로 뺀다. 본문 인라인 스크립트는 원래 자리에서 실행된다.
  body = body.replace(/<script\b[^>]*\bsrc=[^>]*>\s*<\/script>/gi, '');
  body = body.replace(/<script\b([^>]*)>([\s\S]*?)<\/script>/gi, (m0, attrs, code) => {
    const kept = cleanScript(code);
    return kept === null ? '' : `<script${attrs}>${kept}</script>`;
  });
  body = applyTransforms(body, log);

  const template = compileMarkup(body, where);
  return { title, stylesheets, headScripts, template, transforms: log, droppedScripts: dropped };
}

// 템플릿 트리 안의 모든 고정 문자열을 모은다. (정적 검사용)
export function templateStrings(nodes, out = []) {
  for (const n of nodes) {
    if (typeof n === 'string') out.push(n);
    else if (Array.isArray(n)) templateStrings(n, out);
    else if (n && typeof n === 'object') {
      if (n.body) templateStrings(n.body, out);
      if (n.if) n.if.forEach(([, b]) => templateStrings(b, out));
      if (n.else) templateStrings(n.else, out);
      if (n.attrs) n.attrs.forEach(([, parts]) => templateStrings(parts, out));
    }
  }
  return out;
}
