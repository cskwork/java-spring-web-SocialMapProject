// Native JSP transport. Original actions return HTML through Struts/Tiles.
(function(){
 var token=document.querySelector('meta[name="csrf-token"]');if(!token)return;
 function prepare(form){var field=form.querySelector('input[name="csrf"]');if(!field){field=document.createElement('input');field.type='hidden';field.name='csrf';form.appendChild(field);}field.value=token.content;}
 function mutation(name){return /^(Logout|SessionExpire|.*Delete|delete.*|delProj|delSpec|favProj|favSpec|insertTeam|.*HopeMsg)$/.test(name);}
 function post(url){var f=document.createElement('form');f.method='post';f.action=url.pathname;url.searchParams.forEach(function(v,k){var i=document.createElement('input');i.type='hidden';i.name=k;i.value=v;f.appendChild(i);});prepare(f);document.body.appendChild(f);f.submit();}
 document.addEventListener('submit',function(e){prepare(e.target);},true);
 document.addEventListener('click',function(e){
  var a=e.target.closest('a[href],input[onclick],button[onclick]');if(!a)return;
  var inline=a.getAttribute('onclick')||'', match=inline.match(/(?:window.location|location.href)\s*=\s*['"]([^'"]+)['"]/);
  var target=match?match[1]:a.getAttribute('href');if(!target)return;
  var url=new URL(target,location.href),name=url.pathname.split('/').pop().replace('.action','');
  if(url.origin!==location.origin||!mutation(name))return;e.preventDefault();e.stopImmediatePropagation();post(url);
 },true);
 // Legacy validation scripts call form.submit() directly, bypassing submit events.
 var submit=HTMLFormElement.prototype.submit;HTMLFormElement.prototype.submit=function(){prepare(this);return submit.call(this);};
})();
