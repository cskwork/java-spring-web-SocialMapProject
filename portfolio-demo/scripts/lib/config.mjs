// 원본 struts.xml(액션 → 결과), tiles-service.xml(속성 → JSP), homepage.jsp(mainpage → 속성)를 읽어
// 데모 라우터가 쓰는 표로 만든다. 화면 연결은 이 표를 그대로 따른다.
import { readSource, SRC_ROOT } from './source.mjs';

export function parseStruts(xml) {
  const actions = {};
  const body = xml.replace(/<!--[\s\S]*?-->/g, '');
  for (const m of body.matchAll(/<action\s+([^>]*?)(\/?)>([\s\S]*?)<\/action>/g)) {
    const attrs = Object.fromEntries([...m[1].matchAll(/(\w+)="([^"]*)"/g)].map((a) => [a[1], a[2]]));
    const results = {};
    for (const r of m[3].matchAll(/<result([^>]*)>([^<]*)<\/result>/g)) {
      const ra = Object.fromEntries([...r[1].matchAll(/(\w+)="([^"]*)"/g)].map((a) => [a[1], a[2]]));
      const name = ra.name || 'success';
      // 원본 CompWrite/CompModify처럼 같은 이름의 result가 둘이면 Struts와 같이 첫 번째를 쓴다.
      if (!results[name]) results[name] = { type: ra.type || 'dispatcher', target: r[2].trim() };
    }
    actions[attrs.name] = { class: attrs.class, method: attrs.method || 'execute', results };
  }
  return actions;
}

export function parseTiles(xml) {
  const attrs = {};
  for (const m of xml.matchAll(/<put-attribute\s+name="([^"]+)"\s+value="([^"]+)"\s*\/>/g)) attrs[m[1]] = m[2].replace(/^\//, '');
  return attrs;
}

// homepage.jsp의 <s:if/elseif test="mainpage == ('x')"> <tiles:insertAttribute name="y"/> 짝을 모은다.
export function parseHomepage(jsp) {
  const map = {};
  for (const m of jsp.matchAll(/mainpage == \('(\w+)'\)"\s*>\s*<tiles:insertAttribute name=['"](\w+)['"]\s*\/>/g)) map[m[1]] = m[2];
  // 첫 분기 test="mainpage == null || mainpage == ('main')"
  if (/mainpage == null \|\| mainpage == \('main'\)/.test(jsp)) map.main = 'main';
  return map;
}

export function loadConfig() {
  const struts = parseStruts(readSource('struts.xml', SRC_ROOT).text);
  const tiles = parseTiles(readSource('WEB-INF/tiles-service.xml').text);
  const homepage = parseHomepage(readSource('Homepage/homepage.jsp').text);
  return { struts, tiles, homepage };
}
