// ignore_for_file: prefer_single_quotes
/// Self-contained mobile web app served to phones on the LAN.
/// Redesigned: role-based access (Admin/Guest), game detail view with
/// swipe/arrow navigation, full game info, and admin state sync.
const String kMobileSpaHtml = r"""
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no">
<meta name="theme-color" content="#0d0e1c">
<title>Jackbox Remote</title>
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html,body{height:100%;overflow:hidden;background:#0d0e1c;color:#e8e9f0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif}
:root{
  --bg:#0d0e1c;--sf:#141628;--sf2:#1a1e38;--card:#1e2442;
  --ac:#4a6ef5;--acd:#3a5ce0;--red:#e94560;--grn:#2dd4bf;--yel:#f9c74f;
  --tx:#e8e9f0;--mu:#7a7d99;--bd:rgba(255,255,255,0.08);
  --r:12px;--sh:0 4px 24px rgba(0,0,0,.5);
}
.view{position:fixed;inset:0;display:flex;flex-direction:column;overflow:hidden;
  opacity:0;pointer-events:none;transform:translateY(16px);transition:opacity .25s,transform .25s}
.view.active{opacity:1;pointer-events:all;transform:none}
/* WELCOME */
#vw{justify-content:center;align-items:center;gap:22px;padding:32px;
  background:radial-gradient(ellipse at 20% 50%,rgba(74,110,245,.15),transparent 60%),
  radial-gradient(ellipse at 80% 20%,rgba(233,69,96,.1),transparent 50%),#0d0e1c}
.wlogo{font-size:52px}
.wtitle{font-size:28px;font-weight:800;letter-spacing:-.5px;text-align:center;
  background:linear-gradient(135deg,#fff,#a0b4f5);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.wsub{color:var(--mu);font-size:14px;text-align:center}
.rcards{display:flex;flex-direction:column;gap:14px;width:100%;max-width:340px}
.rcard{background:var(--card);border:1px solid var(--bd);border-radius:var(--r);
  padding:18px;cursor:pointer;transition:transform .15s,border-color .2s;
  display:flex;flex-direction:column;gap:5px;-webkit-tap-highlight-color:transparent}
.rcard:active{transform:scale(.97)}
.rcard.admin{border-color:rgba(74,110,245,.4);background:linear-gradient(135deg,#1c2864,#1e2442)}
.rct{font-size:17px;font-weight:700;display:flex;align-items:center;gap:8px}
.rcs{font-size:13px;color:var(--mu);line-height:1.4}
.wstat{display:flex;align-items:center;gap:8px;font-size:12px;color:var(--mu)}
.wdot{width:8px;height:8px;border-radius:50%;background:#444;transition:background .3s}
.wdot.ok{background:var(--grn)}.wdot.err{background:var(--red)}
/* BROWSE */
#vb{background:var(--bg)}
.bh{background:var(--sf);border-bottom:1px solid var(--bd);
  padding:12px 16px;display:flex;align-items:center;gap:10px;flex-shrink:0}
.blogo{font-weight:800;font-size:16px;flex:1;
  background:linear-gradient(135deg,#a0b4f5,#e8e9f0);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.rbadge{font-size:11px;font-weight:700;padding:3px 8px;border-radius:20px;letter-spacing:.5px}
.rbadge.admin{background:rgba(74,110,245,.2);color:#a0b4f5;border:1px solid rgba(74,110,245,.3)}
.rbadge.guest{background:rgba(249,199,79,.15);color:var(--yel);border:1px solid rgba(249,199,79,.2)}
.cdot{width:8px;height:8px;border-radius:50%;background:#444;flex-shrink:0;transition:background .3s}
.cdot.ok{background:var(--grn)}.cdot.err{background:var(--red)}
.bt{padding:10px 16px;display:flex;flex-direction:column;gap:8px;
  background:var(--sf);border-bottom:1px solid var(--bd);flex-shrink:0}
.sbox{background:var(--sf2);border:1px solid var(--bd);border-radius:8px;
  padding:9px 14px;color:var(--tx);font-size:14px;width:100%;outline:none;transition:border-color .2s}
.sbox:focus{border-color:rgba(74,110,245,.5)}
.sbox::placeholder{color:var(--mu)}
.frow{display:flex;gap:8px;overflow-x:auto;scrollbar-width:none;padding-bottom:2px}
.frow::-webkit-scrollbar{display:none}
.chip{background:var(--card);border:1px solid var(--bd);border-radius:20px;
  padding:6px 14px;font-size:13px;color:var(--mu);cursor:pointer;flex-shrink:0;
  transition:all .15s;-webkit-tap-highlight-color:transparent;white-space:nowrap}
.chip.on{background:rgba(74,110,245,.25);border-color:rgba(74,110,245,.5);color:#a0b4f5;font-weight:600}
.chip:active{transform:scale(.95)}
.prow{display:flex;align-items:center;gap:12px;font-size:13px}
.prow label{color:var(--mu);flex-shrink:0;white-space:nowrap}
.prow input[type=range]{flex:1;accent-color:var(--ac)}
.pval{color:var(--tx);font-weight:600;min-width:28px;text-align:right;flex-shrink:0}
.bcont{flex:1;overflow-y:auto;padding:14px}
.psec{margin-bottom:26px}
.ph{display:flex;align-items:center;gap:10px;margin-bottom:12px}
.pico{width:34px;height:34px;border-radius:8px;object-fit:cover;flex-shrink:0}
.pname{font-size:15px;font-weight:700}
.pcnt{font-size:12px;color:var(--mu)}
.punowned{opacity:.4}
.ggrid{display:grid;grid-template-columns:repeat(auto-fill,minmax(145px,1fr));gap:10px}
.gc{background:var(--card);border-radius:var(--r);overflow:hidden;cursor:pointer;
  border:1px solid var(--bd);transition:transform .15s;
  -webkit-tap-highlight-color:transparent;position:relative}
.gc:active{transform:scale(.96)}
.gc.hv::before{content:"";position:absolute;inset:0;border-radius:var(--r);
  border:2px solid var(--ac);pointer-events:none;z-index:2}
.gc.hv::after{content:"HOST";position:absolute;top:6px;right:6px;background:var(--ac);
  color:#fff;font-size:9px;font-weight:700;padding:2px 5px;border-radius:4px;z-index:3;letter-spacing:.5px}
.gthumb{width:100%;aspect-ratio:16/9;object-fit:cover;display:block;background:var(--sf2)}
.gcb{padding:9px}
.gcn{font-size:13px;font-weight:600;line-height:1.3;margin-bottom:5px}
.gmeta{display:flex;align-items:center;gap:5px;flex-wrap:wrap}
.plb{font-size:11px;color:var(--mu)}
.tb{font-size:10px;font-weight:700;padding:2px 6px;border-radius:4px;letter-spacing:.3px}
.tb.VERSUS{background:rgba(233,69,96,.2);color:#f08090}
.tb.COOP{background:rgba(45,212,191,.15);color:var(--grn)}
.tb.TEAM{background:rgba(74,110,245,.2);color:#a0b4f5}
.nores{text-align:center;color:var(--mu);padding:48px 16px;font-size:15px}
/* DETAIL */
#vd{background:var(--bg);overflow:hidden}
.dbg{position:absolute;inset:0;background-size:cover;background-position:center;
  filter:blur(20px) brightness(.3);transform:scale(1.1);z-index:0}
.dbgo{position:absolute;inset:0;z-index:1;
  background:linear-gradient(to bottom,rgba(13,14,28,.2) 0%,rgba(13,14,28,.92) 55%,#0d0e1c 100%)}
.din{position:relative;z-index:2;height:100%;display:flex;flex-direction:column;overflow:hidden}
.dtop{display:flex;align-items:center;padding:12px 14px;gap:10px;flex-shrink:0}
.bbk{background:rgba(255,255,255,.1);border:none;border-radius:50%;width:40px;height:40px;
  display:flex;align-items:center;justify-content:center;cursor:pointer;color:#fff;font-size:20px;
  flex-shrink:0;-webkit-tap-highlight-color:transparent;transition:background .15s;line-height:1}
.bbk:active{background:rgba(255,255,255,.22)}
.dttl{flex:1;font-weight:700;font-size:15px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.dcnt{color:var(--mu);font-size:12px;flex-shrink:0}
.dscroll{flex:1;overflow-y:auto;padding:0 16px 110px}
.dthw{display:flex;justify-content:center;margin-bottom:16px;padding:0 8px}
.dth{width:100%;max-width:380px;border-radius:var(--r);aspect-ratio:16/9;object-fit:cover;
  box-shadow:0 8px 36px rgba(0,0,0,.65)}
.dgn{font-size:24px;font-weight:800;line-height:1.2;margin-bottom:6px;letter-spacing:-.3px}
.dtag{color:var(--mu);font-size:14px;margin-bottom:14px;line-height:1.4;font-style:italic}
.dchips{display:flex;flex-wrap:wrap;gap:8px;margin-bottom:16px}
.dchip{display:flex;align-items:center;gap:5px;background:var(--sf2);
  border-radius:20px;padding:6px 12px;font-size:13px;font-weight:600;border:1px solid var(--bd)}
.dsec{margin-bottom:16px}
.dsect{font-size:11px;font-weight:700;color:var(--mu);letter-spacing:1px;
  text-transform:uppercase;margin-bottom:8px}
.ddesc{font-size:14px;line-height:1.65;color:var(--tx)}
.dbgs{display:flex;flex-wrap:wrap;gap:8px}
.bdg{font-size:12px;padding:5px 10px;border-radius:6px;font-weight:600}
.bg{background:rgba(45,212,191,.13);color:var(--grn);border:1px solid rgba(45,212,191,.2)}
.by{background:rgba(249,199,79,.13);color:var(--yel);border:1px solid rgba(249,199,79,.2)}
.bb{background:rgba(74,110,245,.13);color:#a0b4f5;border:1px solid rgba(74,110,245,.2)}
.br{background:rgba(233,69,96,.13);color:#f08090;border:1px solid rgba(233,69,96,.2)}
.bm{background:var(--sf2);color:var(--mu);border:1px solid var(--bd)}
.dimgs{display:flex;gap:8px;overflow-x:auto;padding-bottom:4px;scrollbar-width:none}
.dimgs::-webkit-scrollbar{display:none}
.dimg{width:150px;height:84px;object-fit:cover;border-radius:8px;flex-shrink:0;cursor:pointer}
.dnpv,.dnnx{position:absolute;top:50%;transform:translateY(-50%);z-index:5;
  background:rgba(0,0,0,.52);border:none;border-radius:50%;width:44px;height:44px;
  display:flex;align-items:center;justify-content:center;cursor:pointer;color:#fff;font-size:22px;
  -webkit-tap-highlight-color:transparent;transition:background .15s;backdrop-filter:blur(4px);line-height:1}
.dnpv:active,.dnnx:active{background:rgba(0,0,0,.78)}
.dnpv{left:8px}.dnnx{right:8px}
.dnpv:disabled,.dnnx:disabled{opacity:.18;pointer-events:none}
.lbar{position:absolute;bottom:0;left:0;right:0;z-index:6;
  padding:14px 16px;background:linear-gradient(transparent,#0d0e1c 60%)}
.blnch{width:100%;padding:16px;background:var(--ac);border:none;border-radius:var(--r);
  color:#fff;font-size:16px;font-weight:700;cursor:pointer;letter-spacing:.4px;
  -webkit-tap-highlight-color:transparent;transition:background .15s,transform .1s}
.blnch:active{background:var(--acd);transform:scale(.98)}
/* TOAST */
#toast{position:fixed;bottom:28px;left:50%;transform:translateX(-50%) translateY(80px);
  background:#1e2240;color:#fff;padding:10px 18px;border-radius:24px;font-size:13px;
  border:1px solid var(--bd);pointer-events:none;transition:transform .3s;z-index:9999;
  white-space:nowrap;box-shadow:var(--sh)}
#toast.show{transform:translateX(-50%) translateY(0)}
/* LIGHTBOX */
#lb{display:none;position:fixed;inset:0;z-index:1000;background:rgba(0,0,0,.9);
  align-items:center;justify-content:center}
#lb.open{display:flex}
#lb img{max-width:96vw;max-height:90vh;border-radius:8px}
</style>
</head>
<body>

<!-- WELCOME -->
<div id="vw" class="view active">
  <div class="wlogo">&#127918;</div>
  <div class="wtitle">Jackbox Remote</div>
  <div class="wsub">Choose your role to continue</div>
  <div class="rcards">
    <div class="rcard admin" id="btnAdmin">
      <div class="rct">&#127923; Host Control</div>
      <div class="rcs">Full control &#8212; launch games and sync filters with the desktop.</div>
    </div>
    <div class="rcard" id="btnGuest">
      <div class="rct">&#128064; Just Browsing</div>
      <div class="rcs">Explore the game catalogue without affecting the desktop.</div>
    </div>
  </div>
  <div class="wstat">
    <div class="wdot" id="wsDot"></div>
    <span id="wsTxt">Connecting&#8230;</span>
  </div>
</div>

<!-- BROWSE -->
<div id="vb" class="view">
  <div class="bh">
    <div class="blogo">&#127918; Jackbox</div>
    <div class="rbadge" id="roleBadge"></div>
    <div class="cdot" id="connDot"></div>
  </div>
  <div class="bt">
    <input class="sbox" id="searchBox" type="search" placeholder="Search games&#8230;" autocomplete="off" autocorrect="off" autocapitalize="off">
    <div class="frow" id="filterRow"></div>
    <div class="prow">
      <label for="pslider">Min Players</label>
      <input type="range" id="pslider" min="1" max="10" value="1">
      <span class="pval" id="pval">Any</span>
    </div>
  </div>
  <div class="bcont" id="browseCont"></div>
</div>

<!-- DETAIL -->
<div id="vd" class="view">
  <div class="dbg" id="detailBg"></div>
  <div class="dbgo"></div>
  <div class="din">
    <div class="dtop">
      <button class="bbk" id="btnBack">&#8592;</button>
      <div class="dttl" id="detailTopTitle"></div>
      <div class="dcnt" id="detailCnt"></div>
    </div>
    <div class="dscroll" id="detailScroll">
      <div class="dthw"><img class="dth" id="detailThumb" src="" alt=""></div>
      <div class="dgn" id="detailName"></div>
      <div class="dtag" id="detailTagline"></div>
      <div class="dchips" id="detailChips"></div>
      <div class="dsec" id="descSec">
        <div class="dsect">About</div>
        <div class="ddesc" id="detailDesc"></div>
      </div>
      <div class="dsec" id="featSec">
        <div class="dsect">Features</div>
        <div class="dbgs" id="detailBadges"></div>
      </div>
      <div class="dsec" id="imgSec">
        <div class="dsect">Screenshots</div>
        <div class="dimgs" id="detailImgs"></div>
      </div>
    </div>
    <button class="dnpv" id="navPrev" disabled>&#8249;</button>
    <button class="dnnx" id="navNext" disabled>&#8250;</button>
    <div class="lbar" id="launchBar" style="display:none">
      <button class="blnch" id="btnLaunch">&#9654; Launch Game</button>
    </div>
  </div>
</div>

<div id="toast"></div>
<div id="lb" onclick="this.classList.remove('open')"><img id="lbImg" src="" alt=""></div>

<script>
"use strict";
const S={role:null,packs:[],flat:[],filtered:[],idx:-1,search:"",typeFilter:null,
  minPlayers:1,hostId:null,ws:null,wsOk:false};

// WS
function wsConnect(){
  const p=location.protocol==="https:"?"wss:":"ws:";
  S.ws=new WebSocket(p+"//"+location.host+"/ws");
  S.ws.onopen=()=>{S.wsOk=true;dotSet(true);};
  S.ws.onclose=()=>{S.wsOk=false;dotSet(false);setTimeout(wsConnect,3000);};
  S.ws.onerror=()=>{S.wsOk=false;dotSet(false);};
  S.ws.onmessage=e=>{try{wsMsg(JSON.parse(e.data));}catch(_){}};
}
function wsTx(o){if(S.ws&&S.ws.readyState===1)S.ws.send(JSON.stringify(o));}
function wsMsg(m){
  if(m.type==="state"){stateFromDesktop(m);}
  else if(m.type==="game_list"||m.type==="packs"){
    S.packs=m.packs||[];buildFlat();filter();
    if(document.getElementById("vb").classList.contains("active"))renderBrowse();
  }else if(m.type==="navigate"){
    S.hostId=m.gameId||null;
    if(S.role==="guest"&&m.gameId)toast("Host viewing: "+gameName(m.gameId));
    if(document.getElementById("vb").classList.contains("active"))renderBrowse();
  }
}

function dotSet(ok){
  document.getElementById("wsDot").className="wdot"+(ok?" ok":" err");
  document.getElementById("wsTxt").textContent=ok?"Connected":"Disconnected";
  const cd=document.getElementById("connDot");
  if(cd)cd.className="cdot"+(ok?" ok":" err");
}

// API
async function loadGames(){
  try{
    const r=await fetch("/api/games");
    const d=await r.json();
    S.packs=d.packs||[];
    buildFlat();
    if(d.state)stateFromDesktop(d.state);
    filter();renderBrowse();renderChips();
  }catch(_){toast("Could not load games");}
}

function buildFlat(){
  S.flat=[];
  for(const pk of S.packs)
    for(const g of(pk.games||[]))
      S.flat.push({packId:pk.id,packName:pk.name,packIcon:pk.icon,packBg:pk.background,packOwned:pk.owned,game:g});
}

function filter(){
  const q=S.search.toLowerCase().trim();
  const mp=S.minPlayers;
  S.filtered=S.flat.filter(({game:g})=>{
    if(q&&!g.name.toLowerCase().includes(q))return false;
    if(S.typeFilter&&g.type!==S.typeFilter)return false;
    if(mp>1&&g.players&&g.players.max<mp)return false;
    return true;
  });
}

function pushDesktop(){
  if(S.role!=="admin")return;
  wsTx({type:"state_update",search:S.search,
    filters:[{filterType:"TYPE",activated:!!S.typeFilter,selected:S.typeFilter||"VERSUS"}],
    intFilters:[{type:"minPlayers",activated:S.minPlayers>1,selected:S.minPlayers}]});
}

function stateFromDesktop(m){
  if(S.role==="admin")return;
  if(m.search!==undefined){S.search=m.search;document.getElementById("searchBox").value=S.search;}
  const tf=(m.filters||[]).find(f=>f.filterType==="TYPE"&&f.activated);
  S.typeFilter=tf?tf.selected:null;
  const mp=(m.intFilters||[]).find(f=>f.type==="minPlayers");
  if(mp){S.minPlayers=mp.activated?mp.selected:1;const sl=document.getElementById("pslider");if(sl){sl.value=S.minPlayers;updPval();}}
  renderChips();filter();renderBrowse();
}

// Role / views
function setRole(role){
  S.role=role;
  const rb=document.getElementById("roleBadge");
  rb.textContent=role==="admin"?"HOST":"GUEST";
  rb.className="rbadge "+role;
  if(role==="admin")document.getElementById("launchBar").style.display="";
  showView("vb");loadGames();
}

function showView(id){
  document.querySelectorAll(".view").forEach(v=>v.classList.remove("active"));
  document.getElementById(id).classList.add("active");
}

function showBrowse(){showView("vb");renderBrowse();}

function openDetail(idx){
  S.idx=idx;renderDetail();showView("vd");
  if(S.role==="admin"&&S.filtered[idx]){
    const gid=S.filtered[idx].game.id;
    wsTx({type:"navigate",gameId:gid});S.hostId=gid;
  }
}

function navGame(dir){
  const ni=S.idx+dir;
  if(ni<0||ni>=S.filtered.length)return;
  S.idx=ni;renderDetail();
  if(S.role==="admin"&&S.filtered[ni]){
    wsTx({type:"navigate",gameId:S.filtered[ni].game.id});
    S.hostId=S.filtered[ni].game.id;
  }
}

// Render Browse
function renderChips(){
  const types=["VERSUS","COOP","TEAM"];
  const lbl={VERSUS:"Versus",COOP:"Co-op",TEAM:"Team"};
  document.getElementById("filterRow").innerHTML=
    types.map(t=>'<div class="chip'+(S.typeFilter===t?" on":"")+'">'+lbl[t]+'</div>').join("");
  document.getElementById("filterRow").querySelectorAll(".chip").forEach((el,i)=>{
    el.onclick=()=>{S.typeFilter=S.typeFilter===types[i]?null:types[i];renderChips();filter();renderBrowse();pushDesktop();};
  });
}

function renderBrowse(){
  const cont=document.getElementById("browseCont");
  if(!S.flat.length){cont.innerHTML='<div class="nores">Loading games&#8230;</div>';return;}
  if(!S.filtered.length){cont.innerHTML='<div class="nores">No games match your filters.</div>';return;}
  const grp={};const ord=[];
  for(const e of S.filtered){
    if(!grp[e.packId]){grp[e.packId]={name:e.packName,icon:e.packIcon,owned:e.packOwned,entries:[]};ord.push(e.packId);}
    grp[e.packId].entries.push(e);
  }
  cont.innerHTML=ord.map(pid=>{
    const pk=grp[pid];
    const cards=pk.entries.map(e=>{
      const g=e.game;const idx=S.filtered.indexOf(e);const hv=S.hostId===g.id;
      return '<div class="gc'+(hv?" hv":"")+'" onclick="openDetail('+idx+')">'+
        '<img class="gthumb" src="'+xe(g.thumbnail)+'" loading="lazy" alt="" onerror="this.style.display=\'none\'">'+
        '<div class="gcb"><div class="gcn">'+xe(g.name)+'</div>'+
        '<div class="gmeta"><span class="plb">'+plTxt(g.players)+' players</span>'+
        '<span class="tb '+(g.type||"VERSUS")+'">'+(g.type||"VS")+'</span></div></div></div>';
    }).join("");
    return '<div class="psec'+(pk.owned?"":" punowned")+'">'+
      '<div class="ph">'+
        (pk.icon?'<img class="pico" src="'+xe(pk.icon)+'" alt="" onerror="this.style.display=\'none\'">':'')+
        '<div><div class="pname">'+xe(pk.name)+'</div>'+
        '<div class="pcnt">'+pk.entries.length+' game'+(pk.entries.length!==1?'s':'')+(pk.owned?'':' &#183; Not Owned')+'</div></div></div>'+
      '<div class="ggrid">'+cards+'</div></div>';
  }).join("");
}

// Render Detail
function renderDetail(){
  const e=S.filtered[S.idx];if(!e)return;
  const g=e.game;
  document.getElementById("detailBg").style.backgroundImage="url("+xe(e.packBg||g.thumbnail)+")";
  document.getElementById("detailThumb").src=g.thumbnail||"";
  document.getElementById("detailTopTitle").textContent=g.name;
  document.getElementById("detailName").textContent=g.name;
  document.getElementById("detailTagline").textContent=g.tagline||"";
  document.getElementById("detailCnt").textContent=(S.idx+1)+" / "+S.filtered.length;
  document.getElementById("detailScroll").scrollTop=0;

  const chips=[];
  if(g.players)chips.push('<div class="dchip">&#128101; '+plTxt(g.players)+" players</div>");
  if(g.playtime)chips.push('<div class="dchip">&#9201; '+ptTxt(g.playtime)+" min</div>");
  if(g.type)chips.push('<div class="dchip tb '+g.type+'">'+tName(g.type)+"</div>");
  document.getElementById("detailChips").innerHTML=chips.join("");

  const desc=g.description||g.smallDescription||"";
  document.getElementById("detailDesc").textContent=desc;
  document.getElementById("descSec").style.display=desc?"":"none";

  const bdg=[];
  if(g.familyFriendly&&g.familyFriendly!=="FAMILY_FRIENDLY_NOT")
    bdg.push('<span class="bdg bg">Family Friendly</span>');
  if(g.audience)bdg.push('<span class="bdg bb">Audience Mode</span>');
  if(g.streamFriendly&&g.streamFriendly!=="STREAM_FRIENDLY_NOT")
    bdg.push('<span class="bdg by">Stream Friendly</span>');
  if(g.subtitles)bdg.push('<span class="bdg bm">Subtitles</span>');
  if(g.moderation&&g.moderation!=="MODERATION_NOT")
    bdg.push('<span class="bdg br">Moderated</span>');
  document.getElementById("detailBadges").innerHTML=bdg.join("");
  document.getElementById("featSec").style.display=bdg.length?"":"none";

  const imgs=g.images||[];
  if(imgs.length){
    document.getElementById("imgSec").style.display="";
    document.getElementById("detailImgs").innerHTML=imgs.map(u=>
      '<img class="dimg" src="'+xe(u)+'" loading="lazy" onclick="openLb(\''+xe(u)+'\')" alt="">'
    ).join("");
  }else{document.getElementById("imgSec").style.display="none";}

  document.getElementById("navPrev").disabled=S.idx===0;
  document.getElementById("navNext").disabled=S.idx>=S.filtered.length-1;
  if(S.role==="admin"){
    document.getElementById("launchBar").style.display="";
    document.getElementById("btnLaunch").onclick=()=>launch(g.id,g.name);
  }
}

function launch(id,name){wsTx({type:"launch",gameId:id});toast("Launching "+name+"&#8230;");}

// Helpers
function plTxt(p){return p?(p.min===p.max?String(p.min):p.min+"-"+p.max):"?";}
function ptTxt(p){return p?(p.min===p.max?String(p.min):p.min+"-"+p.max):"?";}
function tName(t){return{VERSUS:"Versus",COOP:"Co-op",TEAM:"Team"}[t]||t;}
function gameName(id){const e=S.flat.find(e=>e.game.id===id);return e?e.game.name:id;}
function xe(s){
  if(!s)return "";
  return String(s).replace(/&/g,"&amp;").replace(/"/g,"&quot;").replace(/</g,"&lt;").replace(/>/g,"&gt;");
}
let _tt;
function toast(msg){
  const el=document.getElementById("toast");
  el.textContent=msg;el.classList.add("show");
  clearTimeout(_tt);_tt=setTimeout(()=>el.classList.remove("show"),2500);
}
function openLb(url){document.getElementById("lbImg").src=url;document.getElementById("lb").classList.add("open");}

// Search
let _sd;
document.getElementById("searchBox").addEventListener("input",e=>{
  S.search=e.target.value;
  clearTimeout(_sd);_sd=setTimeout(()=>{filter();renderBrowse();pushDesktop();},280);
});

// Player slider
function updPval(){
  const v=parseInt(document.getElementById("pslider").value);
  document.getElementById("pval").textContent=v>1?v+"+":"Any";
  S.minPlayers=v;
}
document.getElementById("pslider").addEventListener("input",()=>{updPval();filter();renderBrowse();pushDesktop();});

// Swipe on detail
let _tx=0,_ty=0;
document.getElementById("vd").addEventListener("touchstart",e=>{_tx=e.touches[0].clientX;_ty=e.touches[0].clientY;},{passive:true});
document.getElementById("vd").addEventListener("touchend",e=>{
  const dx=e.changedTouches[0].clientX-_tx;
  const dy=e.changedTouches[0].clientY-_ty;
  if(Math.abs(dx)>55&&Math.abs(dx)>Math.abs(dy)*1.4)navGame(dx<0?1:-1);
},{passive:true});

// Keyboard
document.addEventListener("keydown",e=>{
  if(!document.getElementById("vd").classList.contains("active"))return;
  if(e.key==="ArrowLeft")navGame(-1);
  if(e.key==="ArrowRight")navGame(1);
  if(e.key==="Escape")showBrowse();
});

// Wire buttons
document.getElementById("btnAdmin").onclick=()=>setRole("admin");
document.getElementById("btnGuest").onclick=()=>setRole("guest");
document.getElementById("btnBack").onclick=showBrowse;
document.getElementById("navPrev").onclick=()=>navGame(-1);
document.getElementById("navNext").onclick=()=>navGame(1);

// Boot
wsConnect();
renderChips();
</script>
</body>
</html>
""";
