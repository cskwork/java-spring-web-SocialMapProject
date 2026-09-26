# java-spring-web-SocialMapProject
  프로젝트 협업 웹사이트

## 구성

- 실제 스택: Struts 2.0 + Tiles 2.1 + iBATIS 2.3 + JSP(EUC-KR) + Oracle (저장소 이름과 달리 Spring은 쓰지 않습니다)
- 화면: `WebContent/`, 액션·SQL: `src/`, 액션 연결: `src/struts.xml`, 레이아웃: `WebContent/WEB-INF/tiles-service.xml`

## 정적 데모

`portfolio-demo/`는 이 저장소의 원본 JSP·CSS·JS를 읽어 13개 업무 모듈의 가상 데이터 데모를 만듭니다(모의 데이터, 외부 전송 없음).
화면은 프로젝트 모집과 내 작업을 중심으로 재설계했습니다. 실행 방법은 [portfolio-demo/README.md](portfolio-demo/README.md), 원본 기능 대응은 [native/FEATURE-MATRIX.md](native/FEATURE-MATRIX.md)에 있습니다.

## 실제 서버 실행

[native/README.md](native/README.md)에 원본 Java·SQL·WAR 빌드와 환경 설정, 새 격리 DB 준비를 정리했습니다. 실제 서버의 역할·소유권·CSRF·비밀번호 재설정·거래 처리를 보완했으며 PNG/JPEG 업로드는 전용 로컬 디렉터리에 저장합니다.

검증: 데모 58개, native SQL·보안 44개, 실제 Tomcat·Struts·Tiles HTTP 46개. 격리된 H2와 가상 파일을 사용했으며 운영 Oracle·브라우저 화면·새 Vercel 배포는 검증하지 않았습니다. 오래된 프레임워크의 운영 적합성과 기존 DB 마이그레이션은 별도 검토가 필요합니다.
