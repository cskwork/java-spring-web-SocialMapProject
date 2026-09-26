# SocialMap 정적 데모 (portfolio-demo)

원본 SocialMap 프로젝트의 JSP 화면·CSS·자바스크립트를 **그대로 가져와** 서버 없이 도는 정적 사이트로 만든 폴더입니다.
새로 디자인한 앱이 아닙니다. 빌드가 원본 파일을 읽어 화면을 만들고, 서버(Struts 액션 + iBATIS + Oracle) 역할만 브라우저 안의 모의 어댑터가 대신합니다.

> 화면 아래에 항상 표시되는 안내: **원본 프로젝트 기반 데모 · 모의 데이터 · 신청·글은 외부로 전송되지 않습니다**

## 원본 프로젝트 사실 확인

- 저장소 이름은 `java-spring-web-SocialMapProject`지만 실제 코드는 **Struts 2.0.14 + Tiles 2.1 + iBATIS 2.3 + JSP(EUC-KR) + Oracle**입니다. Spring은 쓰지 않습니다.
- SocialMap은 지도 서비스가 아니라 **프로젝트 팀장과 프리랜서(팀원)를 이어 주는 협업 모집 사이트**입니다.
- 원본 JSP·Java·CSS 대부분이 EUC-KR입니다. 빌드는 `TextDecoder('euc-kr', { fatal: true })`로 읽고, 결과물은 UTF-8로 씁니다.

## 실행

Node 18 이상이면 됩니다. 설치할 패키지는 없습니다.

```bash
cd portfolio-demo
npm run build     # ../WebContent, ../src/struts.xml 을 읽어 dist/ 생성
npm test          # 42개 시험 (JDK가 있으면 PagingAction.java 비교 시험 포함)
npm run preview   # http://127.0.0.1:4173/
```

### 데모 계정 (비밀번호는 모두 `demo`)

| 아이디 | 역할 | 상태 |
|---|---|---|
| `leader01` | 팀장 | 진행 중인 프로젝트가 있음 → 새 등록 시 원본 알림 "프로젝트를 2개 이상 진행할 수 없습니다." |
| `leader02` | 팀장 | 프로젝트 없음 → 새 프로젝트 등록 가능 |
| `member01` | 팀원(프리랜서) | 팀 없음, `leader04`의 참여 권유 1건 받음 |

원본 로그인 화면으로 들어가도 되고, 아래 안내 막대의 "체험 계정" 선택으로 바로 바꿔도 됩니다. "데모 초기화"는 이 브라우저에 저장된 데이터를 처음 상태로 되돌립니다.

## 원본에서 그대로 쓰는 것 (정확한 경로)

빌드 산출물 `dist/source-map.json`에 파일별 인코딩, 해시, 적용한 변환 횟수가 기록됩니다.

- **화면 연결 표**: `src/struts.xml`(액션 → result), `WebContent/WEB-INF/tiles-service.xml`(속성 → JSP), `WebContent/Homepage/homepage.jsp`(mainpage → 속성)
- **레이아웃**: `WebContent/Homepage/homepage.jsp`의 top · 본문 · floatMenu(right) · bottom 배치, `WebContent/top/top.jsp`, `WebContent/right/right.jsp`, `WebContent/bottom/bottom.jsp`
- **메인·로그인**: `WebContent/main/main.jsp`, `WebContent/login/Login.jsp`
- **프로젝트**: `WebContent/content/project/list.jsp`, `info.jsp`, `write.jsp`(등록·수정 공용), `WebContent/major/MajorCheck.jsp`(전공 찾기 팝업)
- **프리랜서(스펙)**: `WebContent/content/specreg/list.jsp`(원본 `plusFun()` 스펙 등록 포함), `info.jsp`, `modify.jsp`
- **대회/공모전**: `WebContent/content/competition/List.jsp`, `Info.jsp`
- **고객센터**: `WebContent/custService/qna/List.jsp`, `Info.jsp`, `Write.jsp`, `WebContent/custService/faq/List.jsp`, `WebContent/custService/as/List.jsp`, `Info.jsp`
- **마이페이지**: `WebContent/mypage/myPageHome.jsp`, `mypage/favorite/modifyMember.jsp`, `favProjList.jsp`, `favProjinfo.jsp`, `favSpecList.jsp`, `favSpecinfo.jsp`, `checkError2.jsp`, `mypage/hopelist/list.jsp`, `check.jsp`, `sendcomplete.jsp`, `mypage/myproject/list.jsp`, `info.jsp`
- **가이드**: `WebContent/guide/guideHome.jsp` ~ `guideHome3.jsp` (글은 그대로, 화면 캡처 이미지는 제외)
- **CSS**: `WebContent/css/header.css`, `list.css`, `write.css`, `notice.css`, `faq.css` (페이지마다 원본이 링크한 CSS만 켭니다)
- **JS**: `WebContent/js/jquery-1.12.4.min.js`(MIT), `WebContent/js/main.js`(메뉴 열기·FAQ `toggles()`), 각 JSP 안의 검증 함수(`validation()`, `checkIt()`, `plusFun()`, `sendMajor()`, `ErrorMessage()` 등)
- **업무 규칙 출처**: `src/content/project/ProjectTeamAction.java`, `src/msg/MsgAction.java`, `src/hopelist/HopeListAction.java`, `src/favorite/FavoriteAction.java`, `src/content/specreg/SpecRegAction.java`, `src/custservice/QnaAction.java`, `src/temp/PagingAction.java`, `src/sql/*.xml`

## 빌드가 하는 일 (JSP 해석기가 아닙니다)

`scripts/lib/jsp.mjs`가 파일마다 다음만 합니다. 목록에 없는 것은 빌드를 멈춥니다.

1. JSP 지시어·주석 제거. 스크립틀릿(`<% %>`)이 있으면 실패.
2. 이름 붙은 문자열 치환(`TRANSFORMS`): `X.action` → `#/X.action`, `window.open` → 같은 페이지 대화상자, 라이선스 불명 이미지 → SVG/안내 문구, 푸터 사진 출처 제거.
3. 원본에 실제로 쓰인 Struts 태그 부분집합(`property`, `iterator`, `if/elseif/else`, `url/param`, `a`, `hidden`, `checkbox`, `textfield`, `password`, `textarea`, `submit`)과 `${EL}`만 템플릿 트리로 바꿈. OGNL 식은 `src/ognl.js`가 미리 파싱해 검증합니다.
4. 외부 CDN이 필요한 jQuery UI datepicker 블록, 이미지 슬라이드, floatMenu 애니메이션 스크립트만 뺌(`DROPPED_SCRIPTS`).
5. 결과물에 JSP·Struts 태그, `localhost`, 외부 주소, 어댑터를 거치지 않는 `.action`, 복사하지 않은 이미지가 남으면 실패.

값 출력은 위치에 따라 이스케이프합니다(본문/속성 = HTML, URL = 퍼센트 인코딩, JS 문자열 = `\uXXXX`). 이스케이프하지 않는 출력은 원본의 `pagingHtml` 하나뿐입니다.

## 모의 어댑터 (`src/actions.js`)

`struts.xml`의 액션 이름마다 함수가 하나씩 있고, 원본 테이블 모양(`member`, `projectteam`, `specreg`, `favoritelist`, `hopelist`, `qna`, `custservice`, `competition`, `major`)의 데이터를 `localStorage`에서 읽고 씁니다. 결과는 원본 `result` 이름(`success`, `list`, `error`)으로 돌려주고, `src/dispatch.js`가 `struts.xml`의 chain/Tiles/JSP 연결을 그대로 따릅니다. 어댑터에 없는 액션을 부르면 `UnmockedActionError`로 멈춥니다. `fetch`, `XMLHttpRequest`, `sendBeacon`은 막혀 있고 CSP는 `connect-src 'none'`입니다.

### 지킨 업무 규칙

- **한 사람은 프로젝트 하나만 진행** (원본 `member.teamno1` 한 칸): 팀장은 진행 중이면 새 등록이 막히고(원본 `ProjectTeamAction.write` → `list.jsp` 알림), 팀원은 이미 팀이 있으면 참여 희망·수락이 같은 문구로 막힙니다.
- **수락 시 인원 변경** (원본 `hopelist.addCurrmem`): 현재 인원 +1, 남은 모집 인원 −1. 남은 인원이 0이면 수락·신청을 막습니다(데모 규칙).
- **참여 희망(팀원→팀장, log 1)·참여 권유(팀장→팀원, log 0)** 구분, 받은 사람만 수락·거절.
- **스크랩 중복**은 원본 `checkError2.jsp`("이미 스크랩하셨습니다^^*" 후 뒤로)로 처리.
- **스펙은 한 사람당 하나**, 지역·전공·추가내용은 회원 정보에서 가져옴(원본 `SpecRegAction.write`).
- **목록 조건**: 프로젝트는 대회 일치 + 지역·전공 부분일치, 제목/팀장ID 검색. 프리랜서는 지역·전공 부분일치, ID 검색. Q&A 목록은 내 질문만, 검색은 전체.

### 데모에서 막아 둔 기능 (눌러도 이유만 안내)

회원가입·아이디/비밀번호 찾기, 쪽지(다른 사람에게 메시지), 팀원 평점, 회원 탈퇴, 관리자 기능. 원본 주소는 남기고 `UNAVAILABLE` 표에 이유를 적었습니다. 참여 희망/권유 때 원본이 보내던 알림 쪽지도 보내지 않습니다.

## 복사하지 않은 자산

`images/header.jpg`(스톡 일러스트), `images/logo.png` 및 아이콘 PNG(출처 불명), `guide/images/*`(원본 운영 화면 캡처), `upload/file_*.PNG`(대회 포스터), `css/font/*`(쓰지 않음). 로고·메뉴 아이콘은 `src/img/*.svg`의 데모용 그림으로 대신합니다. `sqlMapConfig.xml` 등 설정 파일과 Java 코드는 결과물에 들어가지 않습니다.

## Vercel

- 프로젝트 Root Directory: `portfolio-demo`
- `vercel.json`: `npm run build` → `dist/`, 설치 단계 없음, CSP·보안 헤더 설정

## 폴더

```
scripts/build.mjs        원본 → dist/ (템플릿, CSS, 원본 JS, 결과 표, source-map.json)
scripts/lib/source.mjs   EUC-KR 읽기와 깨짐 검사
scripts/lib/jsp.mjs      JSP → 템플릿 (변환 목록, 태그 부분집합)
scripts/lib/config.mjs   struts.xml / tiles-service.xml / homepage.jsp 표
scripts/preview.mjs      로컬 정적 서버
src/ognl.js, render.js   OGNL 부분집합 계산, 템플릿 그리기 (Node·브라우저 공용)
src/actions.js           모의 어댑터 (Struts 액션 대체)
src/dispatch.js          struts.xml 결과 연결
src/paging.js            PagingAction 이식
src/fixtures.js          가상 초기 데이터
src/store.js, app.js     localStorage 저장, 브라우저 런타임
src/demo.css, img/       데모 안내 막대·반응형 보정, SVG
test/                    EUC-KR, 템플릿 정화, 업무 규칙, 흐름, PagingAction.java 비교
```

원본 소스 수정 내역과 확인 절차는 저장소 최상위의 `SOURCE-HANDOFF.md`에 있습니다.
