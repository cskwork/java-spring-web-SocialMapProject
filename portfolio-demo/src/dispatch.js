// struts.xml 결과 표를 따라 액션 실행 결과를 화면(JSP)으로 잇는다. DOM이 없어 Node에서 시험한다.
//  - type="chain"            → 다음 액션을 이어서 실행 (원본 Struts chain)
//  - /socialMap.tiles        → model.mainpage 로 homepage.jsp/tiles-service.xml 표에서 JSP를 고른다
//  - 그 밖의 /경로.jsp       → 그 JSP를 바로 그린다 (전공 찾기 팝업, 스크랩 중복 안내 등)
import { runAction } from './actions.js';

export class RouteError extends Error {}

export function dispatch(name, params, { state, now = new Date(), routes, mainpages }) {
  const notices = [];
  const alerts = [];
  let current = name;
  let currentParams = params;
  let chainModel = null;
  let mutated = false;
  let landing = null;
  let keepUrl = false;
  for (let hop = 0; hop < 5; hop += 1) {
    const out = runAction(current, { params: currentParams, state, now, chainModel });
    if (out.unavailable) return { kind: 'unavailable', action: current, reason: out.unavailable, state, mutated };
    state = out.state;
    mutated = mutated || Boolean(out.mutated);
    landing = landing || out.landing || null;
    keepUrl = keepUrl || Boolean(out.keepUrl);
    if (out.notice) notices.push(out.notice);
    if (out.alert) alerts.push(out.alert);
    if (out.redirect) return { kind: 'redirect', action: current, redirect: out.redirect, state, mutated, notices, alerts };
    const route = routes[current];
    if (!route) throw new RouteError(`struts.xml 에 없는 액션입니다: ${current}`);
    const result = route.results[out.result];
    if (!result) throw new RouteError(`${current} 의 result "${out.result}" 가 struts.xml 에 없습니다`);
    if (result.type === 'chain') {
      chainModel = out.model;
      current = result.target;
      currentParams = {};
      continue;
    }
    let jsp;
    if (['msglist','msgwrite','msginfo','ratinglist','ratingwrite','withdraw','managewrite','adminhome'].includes(out.model.mainpage) || result.target === '/socialMap.tiles') {
      const mainpage = out.model.mainpage || 'main';
      jsp = mainpages[mainpage];
      if (!jsp) throw new RouteError(`mainpage "${mainpage}" 에 해당하는 JSP가 homepage.jsp/tiles-service.xml 에 없습니다`);
    } else {
      jsp = result.target.replace(/^\//, '');
    }
    return { kind: 'page', action: current, jsp, model: out.model, state, mutated, landing, keepUrl, notices, alerts };
  }
  throw new RouteError(`chain 이 너무 깁니다: ${name}`);
}
