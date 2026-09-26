---
version: 1
slug: "webcontent-main-main-jsp"
primary_target: "WebContent/main/main.jsp"
related_targets: []
---

# 업무 배정 데스크

Mode: Operate. Scope: 이 저장소의 전체 메뉴·목록·상세·입력·관리 흐름. 사용자는 5개 별도 전문 서비스, 코드 우선 재설계를 승인했다. 기능 전체 복원/실사용 연결 작업과 함께 수행한다. 브라우저 조작과 배포는 보류, GitHub 반영은 승인됨.

## Direction contract

THESIS: 업무 배정 데스크에서 핵심 업무를 시작하고 완료한다. 원본의 외형과 낡은 조작 요소를 새로 설계하되 원본 업무·데이터 계약은 이어간다.

OWN-WORLD: 종이색이 아닌 깨끗한 흰색 작업면, 연한 보라 회색 분리면, 진한 보라 주요 액션과 먹색 본문. 일정한 검색/탭/행 정보 규칙, 8px 모서리, 무거운 그림자 없는 단정한 도구.

STORY: 방문자는 실제 업무 항목을 보고 검색·등록·검토·저장하며 상태가 다음 화면에 이어지는 것을 확인한다. 합성 데이터와 실제 연결 환경은 명확히 구분한다.

FIRST VIEWPORT: 왼쪽 짧은 업무 탐색과 넓은 중앙 모집 피드. 상단 검색·역할·주요 등록 행동, 아래 제목/기간/역할/남은 모집 인원을 한 번에 읽는 모집 행. 내 작업은 별도 패널로 바로 접근한다.

FORM: 후보 6, 업무 배정 데스크; seed key 4ee5fc49. 후보 목록은 redesign-2026-09-26/direction-candidates.json에 기록했다. 사용자 지정 clean/professional을 우선하며 물리적 은유의 장식을 그대로 복제하지 않는다.

SIGNATURE: 신청→수락→내 프로젝트의 동일한 상태와 인원이 역할 전환에서도 이어지며 받은 신청에서 작업을 완료한다. 상태 변화는 150–200ms 이내, reduced motion에서는 즉시 반영하고 처음부터 내용을 보인다.

FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance

## Verification boundary

원본 기반 자동 검사와 새로운 역할별 실패/저장/권한 경계를 검사한다. 2026-09-26 모집 화면 개선은 템플릿 렌더 검사로 확인했고, 실제 화면 판정은 root의 데스크톱/모바일 캡처 검토에 맡긴다. 코드 검토를 시각 통과로 표현하지 않는다. 새 장식 이미지는 필요하지 않다. 기능 원본이 없는 부분은 새 호환 구현으로 기록한다. 완성 뒤 실제 토큰에 근거한 DESIGN.md와 .impeccable/design.json을 작성한다.
