// 원본 SocialMap 소스(../WebContent, ../src)를 읽는다. JSP·Java·CSS 대부분이 EUC-KR(CP949)이므로
// 바이트를 보고 ASCII → UTF-8 → EUC-KR 순서로 엄격하게(fatal) 해독한다. 어느 쪽으로도 안 되면 빌드를 멈춘다.
import { readFileSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

export const DEMO_ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '..', '..');
export const REPO_ROOT = resolve(DEMO_ROOT, '..');
export const WEB_ROOT = join(REPO_ROOT, 'WebContent');
export const SRC_ROOT = join(REPO_ROOT, 'src');

export function decodeSource(bytes) {
  if (bytes.every((b) => b < 0x80)) return { text: new TextDecoder('ascii').decode(bytes), encoding: 'ascii' };
  try {
    return { text: new TextDecoder('utf-8', { fatal: true }).decode(bytes), encoding: 'utf-8' };
  } catch {
    const text = new TextDecoder('euc-kr', { fatal: true }).decode(bytes);
    // Node(ICU)의 'euc-kr' 디코더는 CP949 확장 한글(예: 0x8C63 '똠')을 오류 없이 C1 제어문자로 바꿔 버린다.
    // 원본 파일에는 확장 한글이 없지만(KS X 1001 범위), 생기면 깨진 글자를 내보내지 않도록 멈춘다.
    const c1 = text.search(/[\u0080-\u009F]/);
    if (c1 >= 0) throw new TypeError(`CP949 확장 문자는 해독할 수 없습니다 (위치 ${c1}). 파일을 UTF-8로 바꾸거나 해당 글자를 고쳐 주세요.`);
    return { text, encoding: 'euc-kr' };
  }
}

export function readSource(relPath, root = WEB_ROOT) {
  const bytes = readFileSync(join(root, relPath));
  const { text, encoding } = decodeSource(bytes);
  if (text.includes('�')) throw new Error(`${relPath}: 해독 결과에 대체 문자(U+FFFD)가 있습니다`);
  // 원본 CSS의 @charset "EUC-KR" 선언은 UTF-8로 옮긴 뒤에는 틀린 정보이므로 바꾼다.
  return { text: text.replace(/^﻿/, '').replace(/@charset\s+"EUC-KR";/i, '@charset "UTF-8";'), encoding };
}

// EUC-KR을 Latin-1로 잘못 읽었을 때 생기는 전형적인 깨짐(예: "ÇÁ·ÎÁ§Æ®")을 찾는다.
export function looksLikeMojibake(text) {
  return /[À-ÿ][ -ÿ]{2,}/.test(text) || text.includes('�');
}
