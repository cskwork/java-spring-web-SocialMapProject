/** Real native transport: original action => HTML/Tiles result, not mock JSON. */
export function createNativeTransport({origin, context='/socialmap', request=globalThis.fetch}) {
 const base=new URL(context.replace(/\/$/,'')+'/',origin);
 if(base.origin!==new URL(origin).origin)throw new Error('Same-origin context required');
 let csrf='';
 return async function action(name,params={},method='GET') {
  if(!/^\w+$/.test(name))throw new Error('Invalid action');
  const url=new URL(name+'.action',base),body=new URLSearchParams(params);
  const write=method==='POST';if(write&&!csrf)throw new Error('Load a native action before submitting (CSRF token required)');
  if(!write)url.search=body.toString();
  const result=await request(url,{method,credentials:'same-origin',redirect:'follow',headers:write?{'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8','X-CSRF-Token':csrf}:{},...(write?{body:body.toString()}:{})});
  if(new URL(result.url||url).origin!==base.origin)throw new Error('Cross-origin redirect refused');
  if(!result.ok)throw new Error(`Native action failed (${result.status})`);
  const type=result.headers.get('content-type')||'';if(!type.includes('text/html'))throw new Error('Expected native HTML result');
  csrf=result.headers.get('x-socialmap-csrf')||csrf;
  const encoding=/charset\s*=\s*euc-kr/i.test(type)?'euc-kr':'utf-8';
  const html=new TextDecoder(encoding,{fatal:true}).decode(await result.arrayBuffer());
  return {kind:'native-html',html,url:result.url||url.href,csrf};
 };
}
