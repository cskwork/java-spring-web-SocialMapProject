import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readdirSync, statSync } from 'node:fs';
import { join, relative } from 'node:path';
import { decodeSource, readSource, looksLikeMojibake, WEB_ROOT, SRC_ROOT } from '../scripts/lib/source.mjs';

test('EUC-KR 바이트를 한글로 해독한다', () => {
  assert.deepEqual(decodeSource(Buffer.from('c7c1b7cec1a7c6ae', 'hex')), { text: '프로젝트', encoding: 'euc-kr' });
  assert.equal(decodeSource(Buffer.from('b9e6b0a2c7cf', 'hex')).text, '방각하');
});

test('CP949 확장 한글은 깨진 채 통과시키지 않고 멈춘다 (Node 디코더 한계)', () => {
  assert.throws(() => decodeSource(Buffer.from('8c63b9e6b0a2c7cf', 'hex')), /CP949 확장 문자/); // 똠방각하
  assert.throws(() => decodeSource(Buffer.from('94ee', 'hex')), TypeError); // 뷁 (ICU가 직접 거부)
});

test('UTF-8과 ASCII 파일은 그대로 읽는다', () => {
  assert.equal(decodeSource(Buffer.from('프로젝트', 'utf8')).encoding, 'utf-8');
  assert.equal(decodeSource(Buffer.from('abc')).encoding, 'ascii');
});

test('어느 인코딩으로도 해독되지 않으면 조용히 깨뜨리지 않고 멈춘다', () => {
  assert.throws(() => decodeSource(Buffer.from([0xc7])), TypeError);
});

test('Latin-1로 잘못 읽은 한글(모지바케)을 알아본다', () => {
  const wrong = Buffer.from('c7c1b7cec1a7c6ae', 'hex').toString('latin1');
  assert.equal(looksLikeMojibake(wrong), true);
  assert.equal(looksLikeMojibake('프로젝트 찾기'), false);
});

test('원본 JSP·Java·CSS 전부가 깨짐 없이 해독되고 CSS의 charset 선언은 UTF-8로 바뀐다', () => {
  const files = [];
  const walk = (dir) => readdirSync(dir).forEach((f) => {
    const p = join(dir, f);
    if (statSync(p).isDirectory()) walk(p);
    else if (/\.(jsp|java|css|xml)$/.test(f)) files.push(p);
  });
  walk(WEB_ROOT);
  walk(SRC_ROOT);
  assert.ok(files.length > 100);
  for (const p of files) {
    const { text } = p.startsWith(SRC_ROOT) ? readSource(relative(SRC_ROOT, p), SRC_ROOT) : readSource(relative(WEB_ROOT, p));
    assert.equal(looksLikeMojibake(text), false, p);
    assert.doesNotMatch(text, /@charset\s+"EUC-KR"/i, p);
  }
  const list = readSource('content/project/list.jsp');
  assert.equal(list.encoding, 'euc-kr');
  assert.match(list.text, /<h2>프로젝트 찾기<\/h2>/);
  assert.match(readSource('css/list.css').text, /^@charset "UTF-8";/);
});
