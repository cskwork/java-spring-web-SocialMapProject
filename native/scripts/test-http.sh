#!/bin/sh
set -eu
cd "$(dirname "$0")/../.."
python3 native/scripts/build.py
runtime=${TOMCAT_TEST_LIBS:-/tmp/socialmap-tomcat}
h2_test=${H2_TEST_JAR:-/tmp/socialmap-h2-test.jar}
cp="native/build/classes:src:WebContent/WEB-INF/lib/*:$runtime/*:$h2_test"
javac -cp "$cp" -d native/build/classes native/test/NativeHttpIntegration.java
java --add-opens java.base/java.lang=ALL-UNNAMED --add-opens java.base/java.io=ALL-UNNAMED -cp "$cp" NativeHttpIntegration
