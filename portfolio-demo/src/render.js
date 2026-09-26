// 빌드가 원본 JSP에서 만든 템플릿 트리를 HTML 문자열로 그린다. DOM 없이 동작하므로 Node 테스트에서도 쓴다.
// 값은 출력 위치(본문/URL/JS 문자열)에 맞춰 항상 이스케이프한다. 이스케이프하지 않는 출력은
// 원본의 <s:property value="pagingHtml" escape="false"/> 하나뿐이며, 빌드가 그 외의 raw 출력을 막는다.
import { evaluate, truthy } from './ognl.js';

const HTML = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' };
export const escapeHtml = (s) => String(s).replace(/[&<>"']/g, (c) => HTML[c]);
const escapeUrl = (s) => encodeURIComponent(s).replace(/'/g, '%27');
const escapeJs = (s) => String(s).replace(/[^A-Za-z0-9_ 가-힣.@-]/g, (c) => `\\u${c.charCodeAt(0).toString(16).padStart(4, '0')}`);

export function formatValue(v) {
  if (v === null || v === undefined) return '';
  if (Array.isArray(v)) return v.map(formatValue).join(', ');
  return String(v);
}

export function encodeValue(v, mode) {
  const s = formatValue(v);
  switch (mode) {
    case 'raw': return s;
    case 'url':
    case 'jsurl': return escapeHtml(escapeUrl(s));
    case 'js': return escapeHtml(escapeJs(s));
    default: return escapeHtml(s);
  }
}

function renderParts(parts, scope) {
  return parts.map((p) => (typeof p === 'string' ? p : encodeValue(p.p ? evaluate(p.p, scope) : scope.stack[0], p.m))).join('');
}

export function actionUrl(action, params) {
  const qs = params
    .filter(([, v]) => v !== null && v !== undefined && v !== '')
    .map(([k, v]) => `${encodeURIComponent(k)}=${encodeURIComponent(formatValue(v))}`)
    .join('&');
  return `#/${action}.action${qs ? `?${qs}` : ''}`;
}

function renderNodes(nodes, scope) {
  let out = '';
  for (const n of nodes) {
    if (typeof n === 'string') { out += n; continue; }
    if ('p' in n) {
      out += encodeValue(n.p ? evaluate(n.p, scope) : scope.stack[0], n.m);
    } else if ('each' in n) {
      const list = evaluate(n.each, scope);
      const items = Array.isArray(list) ? list : [];
      items.forEach((item, index) => {
        const vars = { ...scope.vars };
        if (n.status) vars[n.status] = { index, count: index + 1, first: index === 0, last: index === items.length - 1 };
        out += renderNodes(n.body, { ...scope, stack: [item, ...scope.stack], vars });
      });
    } else if ('if' in n) {
      const branch = n.if.find(([test]) => truthy(evaluate(test, scope)));
      if (branch) out += renderNodes(branch[1], scope);
      else if (n.else) out += renderNodes(n.else, scope);
    } else if ('url' in n) {
      // <s:url id="viewURL"> 는 출력 없이 변수만 만든다.
      scope.vars[n.url] = actionUrl(n.action, n.params.map(([k, e]) => [k, evaluate(e, scope)]));
    } else if ('el' in n) {
      const attrs = n.attrs.map(([k, parts]) => ` ${k}="${renderParts(parts, scope)}"`).join('');
      if (n.el === 'input') out += `<input${attrs}>`;
      else out += `<${n.el}${attrs}>${renderNodes(n.body || [], scope)}</${n.el}>`;
    } else {
      throw new Error(`템플릿 노드를 알 수 없습니다: ${JSON.stringify(n).slice(0, 80)}`);
    }
  }
  return out;
}

// model: 원본 Action 객체의 getter 값에 해당, session: Struts 세션 맵에 해당.
export function render(template, model, session = {}) {
  const scope = { stack: [model], vars: {}, ctx: { session } };
  return renderNodes(template, scope);
}
