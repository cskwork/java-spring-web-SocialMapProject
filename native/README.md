# SocialMap native 실행 전환

이 폴더는 원본 Struts 2.0.14 / iBATIS 2.3 / Tiles 2.1 앱의 로컬 검증 경로다. 정적 데모와 native 앱은 별도 실행한다. 실제 사용자·운영 DB·메일 공급자에는 연결하지 않았다. 구형 프레임워크 때문에 공개 운영 준비 완료 상태가 아니다.

## 두 실행 경로

- `portfolio-demo`: 원본 JSP/Tiles/action 이름을 브라우저에서 합성 데이터로 실행한다. 외부 통신을 차단하며 변경은 localStorage에 저장한다.
- `native/build/socialmap.war`: 원본 Java action을 실제 servlet 요청으로 실행한다. `RequestGuard` → Struts `FilterDispatcher` → 원본 action → iBATIS/JDBC → 원본 result/chain/Tiles/JSP 흐름이다. DB가 없으면 명시적으로 실패한다. 모의 성공으로 대체하지 않는다.

`native/runtime/http-transport.mjs`는 `/socialmap/Login.action`, `MsgWrite.action` 등 원본 endpoint를 호출하고 HTML을 받는다. JSON state endpoint는 요구하지 않는다. 최초 GET의 `X-SocialMap-CSRF` 값을 다음 POST의 `X-CSRF-Token`으로 보낸다. EUC-KR 응답도 해독한다. 기존 native JSP에서는 `WebContent/js/native-forms.js`가 동일한 CSRF와 POST 전환을 처리한다. 정적 dist에 이 HTTP 모듈을 포함하지 않아 공개 데모의 네트워크 차단을 유지한다.

## 빌드

JDK 17로 Java 8 bytecode를 만든다. 기존 `WEB-INF/lib`를 사용하고 Servlet API는 container provided다. `struts2-config-browser-plugin`과 기존 `build/classes` 산출물·DB 접속 설정은 WAR에 넣지 않는다.

```sh
export SERVLET_API_JAR=/absolute/path/to/servlet-api-2.5.jar
python3 native/scripts/build.py
```

Java/JSP 원본 인코딩을 유지하고 컴파일용 임시 복사본만 UTF-8로 만든다. 출력은 `native/build/socialmap.war`. `native/build`는 Git에서 제외한다.

## 새 합성 Oracle schema

`native/env.example`의 값을 개발자가 새 로컬 Oracle schema에 맞춰 지정한다. `SOCIALMAP_DB_URL`, `SOCIALMAP_DB_USER`, `SOCIALMAP_DB_PASSWORD`가 모두 없으면 서버는 DB를 열지 않는다. `001-empty-schema.sql`은 mapper의 테이블·열·sequence에서 작성한 초기 schema이며 기존 운영 DB의 migration이 아니다. 격리된 빈 schema에서만 `001` 다음 `002-synthetic-seed.sql`을 실행한다. 실행 전 schema가 비어 있는지 운영자가 확인한다. 초기화 취소는 이 작업에 전용으로 만든 schema를 폐기하는 방식으로 수행한다. 기존 schema를 삭제하는 자동 스크립트는 제공하지 않는다.

초기 계정의 비밀번호는 `RESET_REQUIRED`다. Find에서 합성 ID와 이메일로 복구를 요청한 뒤, 해당 격리 DB의 `local_outbox`에 생성된 토큰을 확인해 ResetPassword로 설정한다. 앱은 비밀번호를 조회·표시하지 않는다. 관리자를 포함한 기존 평문 계정도 재설정이 필요하다. 자동 평문 변환이나 운영 DB 변경은 없다. 원본 계정 역할은 관리자 `0`, 팀장 `1`, 팀원 `2`다. 공개 가입은 `1`과 `2`만 허용한다.

신규 비밀번호는 PBKDF2-HMAC-SHA256 600,000회, 16-byte random salt, 256-bit 결과로 저장한다. 검증은 상수시간 비교이며 반복 횟수 600,000~1,000,000 범위 외 저장값은 거절한다. 복구 토큰은 32-byte random 값, DB에는 SHA-256 digest, 15분 만료와 1회 소비 조건을 사용한다. 로컬 outbox는 개발용이며 실제 이메일 adapter로 교체·검증하기 전 외부 서비스에 사용할 수 없다.

## 안전 경계

- 서버는 DB에 저장된 회원 역할로 권한을 판단한다. 프로젝트/문의/쪽지 소유와 비공개 스펙을 검사한다.
- 민감한 쓰기는 POST와 CSRF를 요구한다. request parameter의 중첩 OGNL 이름은 거절한다.
- 신청·알림, 수락·소속·인원·신청 삭제, 완료·소속 해제, 탈퇴 의존 정리는 한 iBATIS request transaction에 포함한다. 예외나 HTTP 오류 결과는 commit하지 않는다. Action HTML은 제한된 응답 버퍼에 보관하고 transaction·파일 정리를 마친 뒤 내보내므로 JSP flush가 미완료 성공을 노출하지 않는다.
- 수락은 요청에 들어온 id/leaderid를 신뢰하지 않고 DB 신청 행에서 대상을 찾는다. 행 잠금, 남은 자리 조건부 update와 affected-row 검사로 마지막 자리 충돌을 처리한다.
- 탈퇴는 세션 ID와 최근 비밀번호 확인을 요구한다. 진행 중인 프로젝트가 있으면 명시적으로 거절한다. 같은 비밀번호의 다른 회원은 유지한다.
- 완료 시 `project_history`에 동료 집합을 남기고 소속을 해제한다. 평점은 이 집합과 완료 상태를 검사한다. 완료·해산은 기존에 없던 호환 업무다.
- 실제 공모전 작성/수정은 원본 `CompWrite.action`/`CompModify.action`에서 로컬 PNG/JPEG 업로드를 지원한다. `SOCIALMAP_UPLOAD_DIR`에 webroot 밖의 전용 절대 경로를 지정한다. 최대 2 MiB, 가로/세로 4096px와 전체 1600만 pixel 제한, 실제 ImageIO decode와 재인코딩, 경로 없는 파일명, UUID 저장키, 관리자 DB 역할·POST·CSRF를 검사한다. 오래된 Struts multipart interceptor를 우회하는 제한된 form parser가 최대 요청/파트/필드 크기를 적용한다. 기타 multipart 경로는 거절한다.
- 다운로드는 `competition-image?no=<공모전 번호>`로 현재 공모전에 연결된 이미지만 찾으며 임의 경로나 URL을 받지 않는다. PNG/JPEG MIME과 nosniff, attachment/sandbox 응답을 사용한다. 파일 교체/삭제는 DB commit 후 이전 파일을 정리하고 실패한 DB transaction은 새 파일을 정리한다. 정적 데모는 실제 파일을 받지 않고 합성 fixture를 선택한다.

## 검증 명령

```sh
npm --prefix portfolio-demo test
export H2_TEST_JAR=/absolute/path/to/h2-2.3.232.jar
sh native/scripts/test.sh
```

H2는 test-only dependency다. 배포 WAR에 포함하지 않고 Oracle adapter를 바꾸지 않는다. Java 테스트는 실제 Service SQL, RequestGuard, 암호 검증을 실행한다. 중간 DB 실패의 rollback, 같은 비밀번호 회원 보존, 마지막 자리 동시 수락을 포함한다. HTTP transport 테스트의 간단한 Node 서버는 URL/method/CSRF/encoding/error 계약만 증명한다. 실제 Tomcat HTTP 검증은 별도 `NativeHttpIntegration.java`로 수행하며, 결과 범위는 delivery 기록에서 확인한다.

## 공개 운영 전 필요한 지원 버전 전환

Apache는 2.x를 지원 종료로 분류한다. 요청 필터를 추가해도 프레임워크 자체 취약점이 해결되지는 않는다. 공식 [지원 종료 안내](https://struts.apache.org/eol-versions.html), [보안 지원 표](https://github.com/apache/struts/security), [릴리즈 안내](https://struts.apache.org/releases)를 기준으로 운영 시점의 지원 중인 패치 버전을 선택해야 한다.

원본 `.action` 이름과 result/Tiles 계약을 유지하는 전환의 최소 범위는 지원 중인 Struts 6 계열 검토, `FilterDispatcher`를 지원 filter로 교체, Java 8+/Servlet 3.1/JSP 2.1 이상 환경, 새 parameter/OGNL 허용 정책, 파일 업로드 interceptor 제거 또는 지원 방식 전환, Tiles plugin 호환성 검증이다. Struts 7은 Jakarta/패키지 이동 등 더 큰 전환을 수반한다. 이 작업은 종속성 한 줄 교체로 확인할 수 없어 이번 원본 유지 범위에서 임의 수행하지 않았다. [공식 2024 변경 안내](https://struts.apache.org/announce-2024)는 6.x 요구 환경과 7.x 패키지 변경을 설명한다. iBATIS/Tiles 및 기존 JDBC driver도 지원성 검토가 필요하다.

실제 Oracle 통합, 기존 데이터 migration 승인, 전용 업로드 디렉터리 권한/백업, 비밀번호 재설정 전달, HTTPS/세션 쿠키, 감사·로그·백업·접근제어, 반응형 화면과 키보드 검증이 남아 있다. 브라우저·배포·외부 전송은 이번 작업에서 실행하지 않았다.
