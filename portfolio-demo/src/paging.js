// 원본 src/temp/PagingAction.java 를 옮긴 것. 페이지 번호 계산은 같은 저장소에서 함께 고친 식을 쓴다.
// (startPage = ((currentPage-1)/blockPage)*blockPage + 1, endPage = startPage + blockPage - 1)
// 원본은 페이지 링크에 검색 조건을 싣지 않아 2쪽부터 필터가 풀렸다. 데모는 keep 인자로 조건을 이어 붙인다.
import { actionUrl, escapeHtml } from './render.js';

export function paging({ currentPage = 1, totalCount, blockCount = 10, blockPage = 5, action, keep = [] }) {
  const totalPage = Math.max(1, Math.ceil(totalCount / blockCount));
  let page = Math.trunc(Number(currentPage)) || 1;
  if (page > totalPage) page = totalPage;
  if (page < 1) page = 1;

  const startCount = (page - 1) * blockCount;
  const endCount = startCount + blockCount - 1;
  const startPage = Math.floor((page - 1) / blockPage) * blockPage + 1;
  const endPage = Math.min(startPage + blockPage - 1, totalPage);

  const href = (n) => escapeHtml(actionUrl(action, [...keep, ['currentPage', n]]));
  let html = '';
  if (page > blockPage) html += `<a href="${href(startPage - 1)}">이전</a>`;
  html += '&nbsp;|&nbsp;';
  for (let i = startPage; i <= endPage; i += 1) {
    if (i === page) html += `&nbsp;<b> <font color='red'>${i}</font></b>`;
    else html += `&nbsp;<a href='${href(i)}'>${i}</a>`;
    html += '&nbsp;';
  }
  html += '&nbsp;&nbsp;|&nbsp;&nbsp;';
  if (totalPage - startPage >= blockPage) html += `<a href="${href(endPage + 1)}">다음</a>`;

  return { currentPage: page, totalPage, startCount, endCount, startPage, endPage, pagingHtml: html };
}

// 원본 Action들의 공통 패턴: 전체 목록을 받아 현재 페이지 구간(subList)만 남긴다.
export function pageOf(list, opts) {
  const p = paging({ ...opts, totalCount: list.length });
  const last = Math.min(list.length, p.endCount + 1);
  return { ...p, list: list.slice(p.startCount, last) };
}
