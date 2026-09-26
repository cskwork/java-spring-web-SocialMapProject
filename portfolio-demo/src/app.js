// 브라우저 런타임: 원본 homepage.jsp(Tiles 레이아웃) 역할을 한다.
// 해시 주소(#/X.action)를 모의 어댑터로 실행하고, 원본 JSP에서 만든 템플릿을 그린 뒤
// 원본 페이지 스크립트(검증 함수 등)를 그대로 실행한다.
import { TEMPLATES, ROUTES, MAINPAGES, SHELL } from './templates.js';
import { render, escapeHtml } from './render.js';
import { dispatch } from './dispatch.js';
import { UNAVAILABLE } from './actions.js';
import { DEMO_ACCOUNTS, DEMO_PASSWORD } from './fixtures.js';
import { loadState, saveState, resetState } from './store.js';

const NOTICE = '원본 프로젝트 기반 데모 · 모의 데이터 · 신청·글은 외부로 전송되지 않습니다';
const $id = (id) => document.getElementById(id);

// ---------- 네트워크 차단: 모의 어댑터 밖으로 나가는 호출은 즉시 실패시킨다 ----------
const blocked = (what) => { throw new Error(`SocialMap 데모: ${what} 호출은 막혀 있습니다 (모의 데이터만 사용)`); };
window.fetch = () => Promise.reject(new Error('SocialMap 데모: 네트워크 호출은 막혀 있습니다'));
XMLHttpRequest.prototype.open = function open() { blocked('XMLHttpRequest'); };
if (navigator.sendBeacon) navigator.sendBeacon = () => blocked('sendBeacon');

let { state, error: loadError } = loadState(localStorage);
let lastHash = null;

// ---------- 알림: 원본의 alert()는 화면을 막지 않는 안내 상자로 보여 준다 ----------
function toast(message, kind = 'info') {
  const box = $id('sm-toast');
  const item = document.createElement('div');
  item.className = `sm-toast-item sm-toast-${kind}`;
  item.setAttribute('role', kind === 'error' ? 'alert' : 'status');
  item.textContent = message;
  box.appendChild(item);
  setTimeout(() => item.remove(), kind === 'error' ? 6000 : 4000);
}
window.alert = (message) => toast(String(message), 'error');

function persist(next) {
  state = next;
  saveState(localStorage, state);
}

// ---------- 화면 그리기 ----------
function activateStylesheets(sheets) {
  const wanted = new Set(['css/header.css', ...sheets]);
  document.querySelectorAll('link[data-sheet]').forEach((link) => { link.disabled = !wanted.has(link.dataset.sheet); });
}

function runScripts(codes, container) {
  for (const code of codes) {
    const s = document.createElement('script');
    s.textContent = code;
    document.head.appendChild(s);
    s.remove();
  }
  if (!container) return;
  container.querySelectorAll('script').forEach((old) => {
    const s = document.createElement('script');
    s.textContent = old.textContent;
    old.replaceWith(s);
  });
}

const ACTION_REF = /#\/(\w+)\.action/;
function markUnavailable(root) {
  root.querySelectorAll('[href], [onclick], form[action]').forEach((el) => {
    const ref = `${el.getAttribute('href') || ''} ${el.getAttribute('onclick') || ''} ${el.tagName === 'FORM' ? el.getAttribute('action') : ''}`;
    const m = ref.match(ACTION_REF);
    const reason = m && UNAVAILABLE[m[1]];
    if (!reason) return;
    const target = el.tagName === 'FORM' ? el.querySelector('[type=submit]') || el : el;
    target.classList.add('demo-unavailable');
    target.setAttribute('aria-disabled', 'true');
    target.setAttribute('title', reason);
    target.dataset.unavailable = reason;
  });
}

function renderTop() {
  const html = render(TEMPLATES[SHELL.top].template, {}, state.session);
  const holder = $id('sm-top');
  holder.innerHTML = html;
  markUnavailable(holder);
}

function renderPage(jsp, model) {
  const page = TEMPLATES[jsp];
  if (!page) throw new Error(`빌드에 없는 JSP입니다: ${jsp}`);
  activateStylesheets(page.stylesheets);
  document.title = page.title || 'SocialMap';
  const main = $id('sm-main');
  main.innerHTML = render(page.template, model, state.session);
  const p = parseHash(location.hash)?.params || {};
  const action = parseHash(location.hash)?.name || '';
  const extra = document.createElement('nav'); extra.className = 'sm-context-actions';
  const link = (name, label, params='') => `<a href="#/${name}.action${params}">${label}</a>`;
  if (state.session.auth === '0') {
    const prefix = {CompList:'Comp', CompInfo:'Comp', ASList:'AS', ASInfo:'AS', FAQList:'FAQ', FAQInfo:'FAQ'}[action];
    if(prefix) extra.innerHTML += link(prefix+'Write','새 항목 등록') + (p.no ? link(prefix+'Modify','수정','?no='+encodeURIComponent(p.no)) + `<form action="#/${prefix}Delete.action" method="post"><input type="hidden" name="no" value="${escapeHtml(p.no)}"><button>삭제</button></form>` : '');
    if(action==='ProjInfo' && p.teamno) extra.innerHTML += link('ProjModify','프로젝트 수정','?teamno='+encodeURIComponent(p.teamno)) + `<form action="#/ProjDelete.action" method="post"><input type="hidden" name="teamno" value="${escapeHtml(p.teamno)}"><button>프로젝트 삭제</button></form>`;
    if(action==='SpecInfo' && p.id) extra.innerHTML += `<form action="#/SpecDelete.action" method="post"><input type="hidden" name="id" value="${escapeHtml(p.id)}"><button>스펙 삭제</button></form>`;
    if(action==='QnaInfo') extra.innerHTML += link('QnaAdminWrite','답변 작성·수정','?no='+encodeURIComponent(p.no));
  }
  if(action==='MyPage') extra.innerHTML += link('modifyMemberForm','정보 수정')+link('deleteMemberForm','회원 탈퇴')+link('SessionExpire','세션 만료 체험');
  if(extra.innerHTML) main.prepend(extra);
  markUnavailable(main);
  runScripts(page.headScripts.map((t) => render(t, model, state.session)), main);
  if (!location.hash.includes('currentPage')) window.scrollTo(0, 0);
  const heading = main.querySelector('h2');
  if (heading) { heading.setAttribute('tabindex', '-1'); heading.focus({ preventScroll: true }); }
}

function renderError(message) {
  activateStylesheets(['css/notice.css']);
  $id('sm-main').innerHTML = `<div class="contents clearfix"><div class="title"><div class="wrap"><h2>처리할 수 없는 요청</h2></div></div>
    <div class="wrap"><p class="demo-error">${escapeHtml(message)}</p><p><a href="#/SocialMap.action">처음 화면으로</a></p></div></div>`;
}

// ---------- 액션 실행 ----------
function parseHash(hash) {
  const m = String(hash || '').match(/^#\/(\w+)\.action(?:\?(.*))?$/);
  if (!m) return null;
  const params = {};
  new URLSearchParams(m[2] || '').forEach((v, k) => {
    params[k] = k in params ? [].concat(params[k], v) : v;
  });
  return { name: m[1], params };
}

const queryOf = (params) => {
  const qs = new URLSearchParams();
  Object.entries(params).forEach(([k, v]) => [].concat(v).forEach((x) => qs.append(k, x)));
  return qs.toString();
};

function setUrl(url, push) {
  if (location.hash === url) return;
  history[push ? 'pushState' : 'replaceState'](null, '', url);
  lastHash = location.hash;
}

function execute(name, params, { method = 'get', depth = 0 } = {}) {
  let out;
  try {
    out = dispatch(name, params, { state, now: new Date(), routes: ROUTES, mainpages: MAINPAGES });
  } catch (e) {
    console.error(e);
    renderError(e.message);
    return;
  }
  if (out.mutated) persist(out.state);
  if (out.kind === 'unavailable') {
    toast(out.reason, 'error');
    if (lastHash) history.replaceState(null, '', lastHash);
    return;
  }
  renderTop();
  if (out.kind === 'redirect') {
    out.alerts.forEach((a) => toast(a, 'error'));
    out.notices.forEach((n) => toast(n));
    if (depth > 3) return renderError('이동이 반복됩니다.');
    const { action, params: rp } = out.redirect;
    setUrl(`#/${action}.action${rp.length ? `?${queryOf(Object.fromEntries(rp))}` : ''}`, method === 'post');
    execute(action, Object.fromEntries(rp), { depth: depth + 1 });
    return;
  }
  // 원본에서 POST 결과는 새 페이지(새 기록)였다. 원본 스크립트의 history.back()(checkError2.jsp)이
  // 제출한 화면으로 돌아가도록, 상태를 바꾸지 않은 POST 결과는 그리기 전에 주소를 남긴다.
  if (method === 'post' && !out.mutated) setUrl(`#/${name}.action${Object.keys(params).length ? `?${queryOf(params)}` : ''}`, true);
  const hashBeforeRender = location.hash;
  renderPage(out.jsp, out.model);
  out.notices.forEach((n) => toast(n));
  out.alerts.forEach((a) => toast(a, 'error'));
  // 원본 JSP 스크립트가 그리는 도중 이동했다면(write.jsp step 2 의 location.href 등) 그 이동을 hashchange 가 이어받는다.
  if (location.hash !== hashBeforeRender) return;
  // 상태를 바꾼 요청은 새로고침해도 다시 실행되지 않도록 결과 화면의 액션 주소로 바꿔 둔다.
  if (out.mutated && !out.keepUrl) setUrl(`#/${out.landing || out.action}.action`, method === 'post');
}

function route() {
  if (location.hash === lastHash) return;
  const parsed = parseHash(location.hash) || { name: 'SocialMap', params: {} };
  lastHash = location.hash;
  execute(parsed.name, parsed.params);
}

// ---------- 팝업(window.open 대신 대화상자) ----------
let popupAction = null;
function renderPopup(name, params) {
  const dialog = $id('sm-popup');
  if (UNAVAILABLE[name]) { toast(UNAVAILABLE[name], 'error'); return; }
  const out = dispatch(name, params, { state, now: new Date(), routes: ROUTES, mainpages: MAINPAGES });
  if (out.kind !== 'page') { toast('팝업을 열 수 없습니다.', 'error'); return; }
  popupAction = name;
  const page = TEMPLATES[out.jsp];
  dialog.querySelector('.sm-popup-body').innerHTML = render(page.template, out.model, state.session);
  dialog.querySelector('.sm-popup-title').textContent = page.title || '';
  runScripts(page.headScripts.map((t) => render(t, out.model, state.session)), dialog);
  if (!dialog.open) dialog.showModal();
}

window.SM = {
  openPopup(url) {
    const parsed = parseHash(url);
    if (!parsed) { toast('데모에서 열 수 없는 창입니다.', 'error'); return null; }
    renderPopup(parsed.name, parsed.params);
    return null;
  },
  closePopup() {
    popupAction = null;
    const dialog = $id('sm-popup');
    if (dialog.open) dialog.close();
  },
};

// ---------- 폼·링크 가로채기 ----------
document.addEventListener('click', (e) => {
  const blockedEl = e.target.closest('[data-unavailable]');
  if (blockedEl) {
    e.preventDefault();
    e.stopPropagation();
    toast(blockedEl.dataset.unavailable, 'error');
    return;
  }
  const a = e.target.closest('a[href="#n"], a[href="#"]');
  if (a) e.preventDefault(); // 원본의 빈 링크(메뉴 제목 등)는 주소를 바꾸지 않는다.
}, true);

document.addEventListener('submit', (e) => {
  if (e.defaultPrevented) return; // 원본 onsubmit 검증이 false 를 돌려준 경우
  e.preventDefault();
  const form = e.target;
  const inPopup = Boolean(form.closest('#sm-popup'));
  const action = form.getAttribute('action') || '';
  const parsed = parseHash(action) || (action ? null : { name: inPopup ? popupAction : (parseHash(location.hash) || { name: 'SocialMap' }).name, params: {} });
  if (!parsed) { toast(`데모에서 처리하지 않는 주소입니다: ${action}`, 'error'); return; }
  const params = { ...parsed.params };
  new FormData(form).forEach((v, k) => {
    if (k === 'submit' || typeof v !== 'string') return;
    params[k] = k in params ? [].concat(params[k], v) : v;
  });
  if (inPopup) renderPopup(parsed.name, params);
  else execute(parsed.name, params, { method: 'post' });
});

window.addEventListener('hashchange', route);

// ---------- 데모 안내 막대 ----------
function renderBar() {
  const bar = $id('sm-demo-bar');
  const current = state.session.id || '';
  bar.innerHTML = `<p class="sm-demo-notice"><strong>${escapeHtml(NOTICE)}</strong></p>
    <div class="sm-demo-controls">
      <label for="sm-account">체험 계정</label>
      <select id="sm-account">
        <option value="">비로그인</option>
        ${DEMO_ACCOUNTS.map((a) => `<option value="${a.id}"${a.id === current ? ' selected' : ''}>${a.id} · ${escapeHtml(a.label)}</option>`).join('')}
      </select>
      <button type="button" id="sm-reset">데모 초기화</button>
    </div>`;
  $id('sm-account').addEventListener('change', (e) => {
    const id = e.target.value;
    if (!id) { lastHash = null; location.hash = '#/Logout.action'; route(); return; }
    execute('Login', { check: '0', id, pwd: DEMO_PASSWORD }, { method: 'post' });
  });
  $id('sm-reset').addEventListener('click', () => {
    if (!confirm('이 브라우저에 저장된 데모 데이터(신청·글·스크랩·로그인)를 처음 상태로 되돌릴까요?')) return;
    state = resetState(localStorage);
    lastHash = null;
    history.replaceState(null, '', '#/SocialMap.action');
    route();
    toast('데모 데이터를 처음 상태로 되돌렸습니다.');
  });
}

// 로그인 화면에 데모 계정 안내를 붙인다. (원본 Login.jsp 폼은 그대로 쓴다)
new MutationObserver(() => {
  const form = document.querySelector('#sm-main form[action="#/Login.action"]');
  if (form && !form.querySelector('.demo-hint')) {
    const hint = document.createElement('p');
    hint.className = 'demo-hint';
    hint.textContent = `데모 계정: ${DEMO_ACCOUNTS.map((a) => a.id).join(', ')} · 비밀번호 ${DEMO_PASSWORD}`;
    form.appendChild(hint);
  }
  const sel = $id('sm-account');
  if (sel && sel.value !== (state.session.id || '')) sel.value = state.session.id || '';
}).observe($id('sm-main'), { childList: true });

function boot() {
  renderBar();
  const right = TEMPLATES[SHELL.right];
  $id('sm-right').innerHTML = '';
  $id('sm-bottom').innerHTML = render(TEMPLATES[SHELL.bottom].template, {}, state.session);
  renderTop();
  if (loadError) toast('저장된 데모 데이터를 읽지 못해 처음 상태로 시작합니다.', 'error');
  route();
}

boot();
