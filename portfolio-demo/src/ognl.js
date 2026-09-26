// 원본 JSP의 Struts 태그가 쓰는 OGNL 식 가운데 실제로 등장하는 부분집합만 해석한다.
// (경로, #session/#stat 참조, 인덱스, size(), 비교, &&/||, !, +/-, 리터럴)
// 모르는 문법은 조용히 넘기지 않고 예외를 던진다. 빌드가 모든 식을 미리 파싱해 검증한다.

const TOKEN = /\s*(?:(\d+(?:\.\d+)?)|('(?:[^'\\]|\\.)*'|"(?:[^"\\]|\\.)*")|(==|!=|<=|>=|&&|\|\||[<>!+\-.()[\]#,])|([A-Za-z_][\w]*))/y;

function tokenize(src) {
  const out = [];
  TOKEN.lastIndex = 0;
  let pos = 0;
  while (pos < src.length) {
    if (/^\s*$/.test(src.slice(pos))) break;
    TOKEN.lastIndex = pos;
    const m = TOKEN.exec(src);
    if (!m) throw new Error(`OGNL: 해석할 수 없는 문자 (${JSON.stringify(src)} @${pos})`);
    pos = TOKEN.lastIndex;
    if (m[1] !== undefined) out.push({ t: 'num', v: Number(m[1]) });
    else if (m[2] !== undefined) out.push({ t: 'str', v: m[2].slice(1, -1).replace(/\\(.)/g, '$1') });
    else if (m[3] !== undefined) out.push({ t: 'op', v: m[3] });
    else {
      const w = m[4];
      if (w === 'and') out.push({ t: 'op', v: '&&' });
      else if (w === 'or') out.push({ t: 'op', v: '||' });
      else if (w === 'null') out.push({ t: 'lit', v: null });
      else if (w === 'true' || w === 'false') out.push({ t: 'lit', v: w === 'true' });
      else out.push({ t: 'id', v: w });
    }
  }
  return out;
}

export function parse(src) {
  const text = String(src).trim().replace(/^%\{([\s\S]*)\}$/, '$1');
  const toks = tokenize(text);
  let i = 0;
  const peek = (v) => toks[i] && toks[i].t === 'op' && toks[i].v === v;
  const eat = (v) => {
    if (!peek(v)) throw new Error(`OGNL: '${v}' 이(가) 필요합니다 (${JSON.stringify(text)})`);
    i += 1;
  };
  const binary = (next, ops) => () => {
    let left = next();
    while (toks[i] && toks[i].t === 'op' && ops.includes(toks[i].v)) {
      const op = toks[i++].v;
      left = { k: 'bin', op, l: left, r: next() };
    }
    return left;
  };
  const primary = () => {
    const tok = toks[i];
    if (!tok) throw new Error(`OGNL: 식이 끝났습니다 (${JSON.stringify(text)})`);
    if (tok.t === 'num' || tok.t === 'str' || tok.t === 'lit') { i += 1; return { k: 'lit', v: tok.v }; }
    if (peek('(')) { i += 1; const e = or(); eat(')'); return e; }
    let node;
    if (peek('#')) {
      i += 1;
      const id = toks[i++];
      if (!id || id.t !== 'id') throw new Error(`OGNL: # 뒤에 이름이 필요합니다 (${JSON.stringify(text)})`);
      node = { k: 'ctx', name: id.v };
    } else if (tok.t === 'id') {
      i += 1;
      node = { k: 'name', name: tok.v };
    } else {
      throw new Error(`OGNL: 예상하지 못한 토큰 ${JSON.stringify(tok.v)} (${JSON.stringify(text)})`);
    }
    for (;;) {
      if (peek('.')) {
        i += 1;
        const id = toks[i++];
        if (!id || id.t !== 'id') throw new Error(`OGNL: . 뒤에 속성 이름이 필요합니다 (${JSON.stringify(text)})`);
        if (peek('(')) {
          i += 1; eat(')');
          if (id.v !== 'size') throw new Error(`OGNL: 지원하지 않는 메서드 ${id.v}() (${JSON.stringify(text)})`);
          node = { k: 'size', o: node };
        } else {
          node = { k: 'get', o: node, name: id.v };
        }
      } else if (peek('[')) {
        i += 1; const idx = or(); eat(']');
        node = { k: 'index', o: node, i: idx };
      } else break;
    }
    return node;
  };
  const unary = () => {
    if (peek('!')) { i += 1; return { k: 'not', e: unary() }; }
    if (peek('-')) { i += 1; return { k: 'neg', e: unary() }; }
    return primary();
  };
  const add = binary(unary, ['+', '-']);
  const rel = binary(add, ['<', '<=', '>', '>=']);
  const eq = binary(rel, ['==', '!=']);
  const and = binary(eq, ['&&']);
  const or = binary(and, ['||']);
  const ast = or();
  if (i !== toks.length) throw new Error(`OGNL: 식 뒤에 남은 토큰이 있습니다 (${JSON.stringify(text)})`);
  return ast;
}

const cache = new Map();
function compiled(src) {
  if (!cache.has(src)) cache.set(src, parse(src));
  return cache.get(src);
}

const isNumeric = (v) => typeof v === 'number' || (typeof v === 'string' && v.trim() !== '' && !Number.isNaN(Number(v)));

// OGNL 비교: 한쪽이 숫자면 숫자로, 아니면 문자열로 비교한다. ("1" == 1 은 참)
function equals(a, b) {
  if (a === undefined) a = null;
  if (b === undefined) b = null;
  if (a === null || b === null) return a === b;
  if ((typeof a === 'number' || typeof b === 'number') && isNumeric(a) && isNumeric(b)) return Number(a) === Number(b);
  if (typeof a === 'boolean' || typeof b === 'boolean') return String(a) === String(b);
  return String(a) === String(b);
}

function compare(a, b) {
  if (isNumeric(a) && isNumeric(b)) return Number(a) - Number(b);
  return String(a ?? '').localeCompare(String(b ?? ''));
}

// scope: { stack: [top, ..., root], vars: {name: value}, ctx: {session, stat...} }
function lookup(scope, name) {
  if (Object.prototype.hasOwnProperty.call(scope.vars, name)) return scope.vars[name];
  for (const obj of scope.stack) {
    if (obj !== null && typeof obj === 'object' && Object.prototype.hasOwnProperty.call(obj, name)) return obj[name];
  }
  return undefined;
}

function evalNode(n, scope) {
  switch (n.k) {
    case 'lit': return n.v;
    case 'name': return lookup(scope, n.name);
    case 'ctx': return Object.prototype.hasOwnProperty.call(scope.vars, n.name) ? scope.vars[n.name] : scope.ctx[n.name];
    case 'get': {
      const o = evalNode(n.o, scope);
      return o === null || o === undefined ? undefined : o[n.name];
    }
    case 'index': {
      const o = evalNode(n.o, scope);
      return o === null || o === undefined ? undefined : o[evalNode(n.i, scope)];
    }
    case 'size': {
      const o = evalNode(n.o, scope);
      return o === null || o === undefined ? 0 : o.length;
    }
    case 'not': return !truthy(evalNode(n.e, scope));
    case 'neg': return -Number(evalNode(n.e, scope));
    case 'bin': {
      if (n.op === '&&') return truthy(evalNode(n.l, scope)) && truthy(evalNode(n.r, scope));
      if (n.op === '||') return truthy(evalNode(n.l, scope)) || truthy(evalNode(n.r, scope));
      const l = evalNode(n.l, scope);
      const r = evalNode(n.r, scope);
      switch (n.op) {
        case '==': return equals(l, r);
        case '!=': return !equals(l, r);
        case '<': return compare(l, r) < 0;
        case '<=': return compare(l, r) <= 0;
        case '>': return compare(l, r) > 0;
        case '>=': return compare(l, r) >= 0;
        case '+': return isNumeric(l) && isNumeric(r) ? Number(l) + Number(r) : `${l ?? ''}${r ?? ''}`;
        case '-': return Number(l) - Number(r);
        default: throw new Error(`OGNL: 연산자 ${n.op}`);
      }
    }
    default: throw new Error(`OGNL: 노드 ${n.k}`);
  }
}

export function truthy(v) {
  if (v === null || v === undefined) return false;
  if (typeof v === 'string') return v !== '' && v !== 'false';
  if (typeof v === 'number') return v !== 0;
  return Boolean(v);
}

export function evaluate(src, scope) {
  return evalNode(compiled(src), scope);
}
