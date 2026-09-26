#!/usr/bin/env python3
"""Compile original mixed-encoding sources and assemble a clean WAR; never connect to DB."""
from pathlib import Path
import os,shutil,subprocess,zipfile,hashlib
ROOT=Path(__file__).resolve().parents[2]; OUT=ROOT/'native'/'build';OUT.mkdir(exist_ok=True)
API=Path(os.environ.get('SERVLET_API_JAR','/tmp/socialmap-servlet-api-2.5.jar'))
if not API.is_file():raise SystemExit('Set SERVLET_API_JAR to the Servlet 2.5 API jar (container provided; not packaged).')
normalized=OUT/'sources';classes=OUT/'classes'
for target in [normalized,classes]:
 if target.exists():shutil.rmtree(target)
 target.mkdir()
files=[]
for p in (ROOT/'src').rglob('*.java'):
 b=p.read_bytes()
 try:s=b.decode('utf-8')
 except UnicodeDecodeError:s=b.decode('cp949')
 dest=normalized/p.relative_to(ROOT/'src');dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(s);files.append(str(dest))
libs=[p for p in (ROOT/'WebContent/WEB-INF/lib').glob('*.jar') if 'config-browser' not in p.name]
subprocess.run(['javac','-encoding','UTF-8','-source','8','-target','8','-cp',os.pathsep.join(map(str,libs+[API])),'-d',str(classes)]+files,check=True)
war=OUT/'socialmap.war'
with zipfile.ZipFile(war,'w',zipfile.ZIP_DEFLATED) as z:
 for p in (ROOT/'WebContent').rglob('*'):
  if p.is_file() and not any(part in ['classes','.DS_Store'] for part in p.parts) and 'config-browser' not in p.name:z.write(p,str(p.relative_to(ROOT/'WebContent')))
 for p in classes.rglob('*.class'):z.write(p,'WEB-INF/classes/'+str(p.relative_to(classes)))
 for p in (ROOT/'src').rglob('*.xml'):z.write(p,'WEB-INF/classes/'+str(p.relative_to(ROOT/'src')))
 for p in (ROOT/'src').glob('*.properties'):
  if p.name!='dbconnect.properties':z.write(p,'WEB-INF/classes/'+p.name)
print(str(war));print('sha256 '+hashlib.sha256(war.read_bytes()).hexdigest())
