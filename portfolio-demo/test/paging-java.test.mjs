// 원본 src/temp/PagingAction.java 와 데모 paging.js 가 같은 쪽 구간을 계산하는지 JDK로 직접 비교한다.
// JDK(javac/java)가 없으면 건너뛴다.
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { mkdtempSync, mkdirSync, writeFileSync, copyFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { SRC_ROOT } from '../scripts/lib/source.mjs';
import { paging } from '../src/paging.js';

let hasJdk = true;
try { execFileSync('javac', ['-version'], { stdio: 'ignore' }); } catch { hasJdk = false; }

const CASES = [[1, 0], [1, 7], [1, 12], [2, 12], [3, 12], [5, 95], [6, 95], [7, 95], [10, 95], [11, 120], [99, 30]];

test('PagingAction.java 와 paging.js 결과가 같다', { skip: !hasJdk && 'JDK 없음' }, () => {
  const dir = mkdtempSync(join(tmpdir(), 'sm-paging-'));
  mkdirSync(join(dir, 'temp'));
  copyFileSync(join(SRC_ROOT, 'temp', 'PagingAction.java'), join(dir, 'temp', 'PagingAction.java'));
  writeFileSync(join(dir, 'Probe.java'), `import temp.PagingAction;
public class Probe {
  public static void main(String[] a) {
    int[][] cases = {${CASES.map(([p, t]) => `{${p},${t}}`).join(',')}};
    for (int[] c : cases) {
      PagingAction p = new PagingAction(c[0], c[1], 10, 5, 0, "ProjList", "");
      String html = p.getPagingHtml().toString();
      System.out.println(p.getStartCount() + " " + p.getEndCount() + " " + p.getStartPage() + " " + p.getEndPage() + " " + html.contains("이전") + " " + html.contains("다음") + " " + html.replaceAll("[^0-9>]+", " ").replaceAll("\\\\s+", " ").trim());
    }
  }
}
`);
  execFileSync('javac', ['-encoding', 'EUC-KR', '-d', dir, join(dir, 'temp', 'PagingAction.java')]);
  execFileSync('javac', ['-encoding', 'UTF-8', '-cp', dir, '-d', dir, join(dir, 'Probe.java')]);
  const lines = execFileSync('java', ['-Dfile.encoding=UTF-8', '-Dstdout.encoding=UTF-8', '-cp', dir, 'Probe'], { encoding: 'utf8' }).trim().split('\n');
  CASES.forEach(([currentPage, totalCount], i) => {
    const js = paging({ currentPage, totalCount, blockCount: 10, blockPage: 5, action: 'ProjList' });
    const [startCount, endCount, startPage, endPage, prev, next] = lines[i].split(' ');
    const label = `currentPage=${currentPage}, totalCount=${totalCount}`;
    assert.equal(js.startCount, Number(startCount), label);
    assert.equal(js.endCount, Number(endCount), label);
    assert.equal(js.startPage, Number(startPage), label);
    // Java는 endPage를 전체 쪽수로 줄인 값을 저장한다
    assert.equal(js.endPage, Number(endPage), label);
    assert.equal(js.pagingHtml.includes('이전'), prev === 'true', label);
    assert.equal(js.pagingHtml.includes('다음'), next === 'true', label);
  });
});
