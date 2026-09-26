#!/bin/sh
set -eu
cd "$(dirname "$0")/../.."
python3 native/scripts/build.py
servlet_api=${SERVLET_API_JAR:-/tmp/socialmap-servlet-api-2.5.jar}
h2_test=${H2_TEST_JAR:-/tmp/socialmap-h2-test.jar}
[ -f "$h2_test" ] || { echo 'Set H2_TEST_JAR to H2 2.3.232 (test-only dependency).'; exit 1; }
cp="native/build/classes:WebContent/WEB-INF/lib/*:$servlet_api:$h2_test"
javac -encoding UTF-8 -cp "$cp" -d native/build/classes native/test/NativeRegression.java
java -cp "$cp" NativeRegression
