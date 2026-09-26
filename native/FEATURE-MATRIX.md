# 원본 기능과 확장 구현

원본 action 이름·JSP·VO/table 이름을 유지한다. `full-actions.js`, `compat/CompatibilityAction.java`, `security/*`, `WebContent/compat/manage.jsp`, lifecycle/history/reset/outbox schema는 이번에 추가한 호환 코드다. 원본에 있던 것으로 표시하지 않는다.

| 원본 모듈 | 데모 동작과 상태 | 실제 Java 경로 | 추가 검증 |
|---|---|---|---|
| 홈·전공·가이드 | 모집 탐색, 검색·전공 선택, 4개 가이드와 업무 링크 | MemberAction.home, MajorAction, guideAction | 기존 목록/템플릿/가이드 검사 유지 |
| 계정 | 가입·중복·역할 제한, 로그인/로그아웃/만료, 로컬 복구함·토큰 소비 | MemberAction, CompatibilityAction.reset, Passwords, Service.requestReset | privileged signup, reset 만료·재사용·hash, native HTTP 로그인/역할 |
| 프로젝트 | 팀장 등록/수정/삭제, 마감/완료/해산, 1인 1진행 프로젝트 | ProjectTeamAction, CompatibilityAction.lifecycle | 원본 모집 검사, 소유권, 정원·상태·소속 해제 |
| 프리랜서 스펙 | 등록/검색/수정/공개/비공개/삭제 | SpecRegAction + RequestGuard | 비공개 열람, 본인 수정, 1인 1개 |
| 신청·권유·수락 | 두 방향 신청, 받은 신청, 수락/거절과 내부 쪽지 | MsgAction, HopeListAction → Service.hope/accept | 마지막 자리 동시 수락, 중간 SQL 실패 rollback, 대상 위조 |
| 스크랩 | 프로젝트/스펙 추가·중복·목록·해제 | FavoriteAction + RequestGuard/원본 owner mapper | 기존 스크랩 flow와 소유 스코프 |
| 공모전 | 목록/추천/상세, 관리자 CRUD, 데모 fixture 및 native PNG/JPEG 업로드/다운로드 | CompetitionAction, 고정 로컬 첨부 | 비관리자·CSRF 거절, 크기/실제 이미지/파일명/경로 검사, 실패 파일 정리, 교체·삭제·다운로드 |
| 쪽지 | 쓰기·받은/보낸함·읽음·사용자별 삭제 | MsgAction, Service.message, message_deleted | 발신자 강제, 타인 열람/삭제, HTTP 저장·권한 |
| 팀원 평점 | 완료 프로젝트와 동료 확인, 1~5점, 자기/중복/외부인 거절 | RatingAction + project_history | 완료 자격 snapshot, 점수·중복 검사 |
| 내 정보·탈퇴 | 내 정보 저장, 재인증, 활동 중 탈퇴 거절, 본인 삭제 | MyPageAction, Service.withdraw | 같은 비밀번호 타인 보존, 최근 확인·진행 프로젝트 |
| 문의 | 본인 질문 CRUD/검색, 관리자 답변·수정·삭제 | QnaAction + RequestGuard | 검색·상세의 타인 질문 차단, 관리자 답변 역할 교차 |
| 공지·FAQ | 조회·검색, 관리자 등록/수정/삭제 | ASNoticeAction, FAQAction + RequestGuard | CRUD 저장, 비관리자 거절, 누락 ID·필수 입력 |
| 관리자 탐색 | 관리자 로그인, 6개 관리 업무 목록/상세/조치 | 원본 admin JSP + AdminHome 호환 action | 저장된 역할 강제, 가입으로 관리자 생성 불가 |

상태 전환은 모든 데모 역할에서 같은 저장소를 사용한다. reset은 초기 합성 상태로 돌아가며 schema migration은 예전 localStorage 배열과 신규 필드를 함께 읽는다. 쪽지는 실제 다른 사람에게 전송하지 않는다. 합성 관리자 계정은 `admin / demo`; 역할은 화면의 체험 계정에서 바꿀 수 있다.

원본의 명시적 완료 상태가 없던 부분은 새 상태 `recruiting → closed → completed/released`로 보완했다. 완료만 평가 자격을 남기고 완료/해산 모두 소속을 해제한다. 완료 기록은 현재 팀 소속과 별도로 유지한다.

정적 데모의 관리자 publication 화면은 원본 action/result에 연결된 공통 관리 JSP를 사용한다. native 서버는 원본 관리자 화면과 안전한 공모전 공통 폼을 사용한다. 둘은 같은 상태 의미를 가지지만 DTO/HTML이 동일한 JSON 계약이라는 주장은 하지 않는다.
