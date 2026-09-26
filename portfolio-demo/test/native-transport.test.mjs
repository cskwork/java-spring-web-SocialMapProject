import {test} from 'node:test';
import assert from 'node:assert/strict';
import {createServer} from 'node:http';
import {createNativeTransport} from '../../native/runtime/http-transport.mjs';
test('real HTTP transport uses native action HTML, cookies/CSRF and explicit failures without mock fallback',async()=>{
 const seen=[];const server=createServer((req,res)=>{let body='';req.on('data',x=>body+=x);req.on('end',()=>{seen.push({url:req.url,method:req.method,csrf:req.headers['x-csrf-token'],body});res.setHeader('content-type','text/html;charset=UTF-8');res.setHeader('x-socialmap-csrf','test-csrf');if(req.url.includes('fail'))res.statusCode=503;res.end('<main>가상 native 결과</main>');});});
 await new Promise(resolve=>server.listen(0,'127.0.0.1',resolve));
 try{const origin='http://127.0.0.1:'+server.address().port;const action=createNativeTransport({origin});await assert.rejects(action('MsgWrite',{title:'x'},'POST'),/CSRF/);const out=await action('SocialMap');assert.equal(out.kind,'native-html');assert.match(out.html,/가상 native 결과/);await action('MsgWrite',{title:'가상 쪽지',getid:'member01'},'POST');assert.equal(seen[1].csrf,'test-csrf');assert.equal(seen[1].method,'POST');assert.equal(new URLSearchParams(seen[1].body).get('title'),'가상 쪽지');await assert.rejects(action('fail'),/503/);assert.throws(()=>createNativeTransport({origin,context:'https://example.invalid'}),/Same-origin/);}
 finally{await new Promise(resolve=>server.close(resolve));}
});
