# 로컬 검증 종속성

기존 `WebContent/WEB-INF/lib`는 변경하지 않았다. 다음 test/container jar는 Maven Central에서 `/tmp`로 받았고 Git이나 배포 WAR에 넣지 않았다.

| 용도 | 좌표 |
|---|---|
| 컴파일 provided API | javax.servlet:servlet-api:2.5 |
| 합성 DB 테스트 | com.h2database:h2:2.3.232 |
| HTTP 테스트 container | org.apache.tomcat.embed:tomcat-embed-core:9.0.99 |
| HTTP JSP compiler | org.apache.tomcat.embed:tomcat-embed-jasper:9.0.99 |
| HTTP EL | org.apache.tomcat.embed:tomcat-embed-el:9.0.99 |
| JSP Java compiler | org.eclipse.jdt:ecj:3.26.0 |
| container annotations | javax.annotation:javax.annotation-api:1.3.2 |

예: Maven Central artifact URL은 `https://repo.maven.apache.org/maven2/<group-path>/<artifact>/<version>/<artifact>-<version>.jar`다. `test.sh`는 `SERVLET_API_JAR`와 `H2_TEST_JAR`, `test-http.sh`는 추가로 `TOMCAT_TEST_LIBS` 디렉터리를 읽는다. HTTP harness는 127.0.0.1 임의 포트만 열고 finally에서 중지한다. Tomcat 버전은 재현된 테스트 fixture이며 운영 권장 버전으로 제시하지 않는다.

`NativeHttpIntegration`은 WAR의 JSP/web.xml을 임시 폴더로 풀고 원본 컴파일 클래스·jar를 parent classloader에서 공급한다. iBATIS client를 합성 H2 client로 주입하기 위한 테스트 구성이다. application action, guard, Struts, Tiles, JSP는 실제 실행한다. 실제 Oracle이나 배포 환경 classloader 설정을 검증한 것은 아니다.
