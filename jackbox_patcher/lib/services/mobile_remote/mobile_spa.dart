// ignore_for_file: prefer_single_quotes
/// Mobile SPA â€“ full-featured remote control for Jackbox game launcher.
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
html,body{height:100%;overflow:hidden;background:#0d0e1c;color:#e8e9f0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;-webkit-font-smoothing:antialiased}
:root{--bg:#0d0e1c;--sf:#141628;--sf2:#1a1e38;--card:#1e2442;
  --ac:#3a5ce0;--acd:#2a4cc0;--red:#e94560;--grn:#2dd4bf;--yel:#f9c74f;
  --tx:#e8e9f0;--mu:#7a7d99;--bd:rgba(255,255,255,0.08);--r:12px;--sh:0 4px 24px rgba(0,0,0,.5)}
.view{position:fixed;inset:0;display:flex;flex-direction:column;overflow:hidden;opacity:0;pointer-events:none;transform:translateY(14px);transition:opacity .22s ease,transform .22s ease}
.view.active{opacity:1;pointer-events:all;transform:none}
/* WELCOME */
#vw{justify-content:center;align-items:center;gap:20px;padding:32px 24px;
  background:radial-gradient(ellipse at 20% 50%,rgba(74,110,245,.18),transparent 60%),
  radial-gradient(ellipse at 80% 20%,rgba(233,69,96,.12),transparent 50%),#0d0e1c}
.wlogo{font-size:56px;filter:drop-shadow(0 0 20px rgba(74,110,245,.5))}
.wtitle{font-size:28px;font-weight:800;letter-spacing:-.5px;text-align:center;
  background:linear-gradient(135deg,#fff 30%,#a0b4f5);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.wsub{color:var(--mu);font-size:14px;text-align:center}
.rcards{display:flex;flex-direction:column;gap:12px;width:100%;max-width:340px}
.rcard{background:var(--card);border:1px solid var(--bd);border-radius:var(--r);padding:18px 20px;cursor:pointer;
  transition:transform .15s,box-shadow .15s,border-color .2s;display:flex;flex-direction:column;gap:6px;
  -webkit-tap-highlight-color:transparent;box-shadow:0 2px 12px rgba(0,0,0,.3)}
.rcard:active{transform:scale(.97)}
.rcard.admin{border-color:rgba(74,110,245,.45);background:linear-gradient(135deg,rgba(28,40,100,.9),#1e2442)}
.rct{font-size:17px;font-weight:700;display:flex;align-items:center;gap:10px}
.rcs{font-size:13px;color:var(--mu);line-height:1.45}
.wstat{display:flex;align-items:center;gap:8px;font-size:12px;color:var(--mu)}
.wdot{width:8px;height:8px;border-radius:50%;background:#444;transition:background .3s}
.wdot.ok{background:var(--grn);box-shadow:0 0 6px var(--grn)}.wdot.err{background:var(--red)}
/* BROWSE */
#vb{background:var(--bg)}
.bh{background:var(--sf);border-bottom:1px solid var(--bd);padding:10px 14px;
  display:flex;align-items:center;gap:10px;flex-shrink:0;box-shadow:0 2px 8px rgba(0,0,0,.3)}
.blogo{font-weight:800;font-size:16px;flex:1;text-decoration:none;
  -webkit-tap-highlight-color:transparent;cursor:pointer}
.blogo .blt{background:linear-gradient(135deg,#a0b4f5,#e8e9f0);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.blogo .tvsuf{background:linear-gradient(135deg,var(--ac),#7a9aff);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.rbadge{font-size:10px;font-weight:700;padding:3px 8px;border-radius:20px;letter-spacing:.6px;cursor:pointer;-webkit-tap-highlight-color:transparent}
.rbadge.admin{background:rgba(74,110,245,.2);color:#a0b4f5;border:1px solid rgba(74,110,245,.3)}
.rbadge.guest{background:rgba(249,199,79,.15);color:var(--yel);border:1px solid rgba(249,199,79,.2)}
.cdot{width:8px;height:8px;border-radius:50%;background:#444;flex-shrink:0;transition:background .3s}
.cdot.ok{background:var(--grn);box-shadow:0 0 5px var(--grn)}.cdot.err{background:var(--red)}
/* Admin bar */
.abar{display:flex;align-items:center;gap:8px;padding:8px 14px;
  background:rgba(74,110,245,.06);border-bottom:1px solid rgba(74,110,245,.1);flex-shrink:0}
.abar-l{display:flex;gap:6px;flex:1}
.stab{background:var(--sf2);border:1px solid var(--bd);border-radius:8px;padding:5px 12px;
  font-size:12px;font-weight:600;color:var(--mu);cursor:pointer;-webkit-tap-highlight-color:transparent;
  transition:all .15s;white-space:nowrap}
.stab.on.full{background:rgba(45,212,191,.15);border-color:rgba(45,212,191,.4);color:var(--grn)}
.stab.on.paused{background:rgba(249,199,79,.15);border-color:rgba(249,199,79,.3);color:var(--yel)}
.stab:active{transform:scale(.95)}
.muteBtn{background:var(--sf2);border:1px solid var(--bd);border-radius:8px;padding:5px 10px;
  font-size:14px;cursor:pointer;-webkit-tap-highlight-color:transparent;transition:all .15s;line-height:1}
.muteBtn.muted{background:rgba(233,69,96,.15);border-color:rgba(233,69,96,.3)}
.muteBtn:active{transform:scale(.95)}
/* Toolbar */
.bt{padding:10px 14px;display:flex;flex-direction:column;gap:8px;background:var(--sf);border-bottom:1px solid var(--bd);flex-shrink:0}
.srow{display:flex;gap:8px}
.sbox{background:var(--sf2);border:1px solid var(--bd);border-radius:8px;padding:9px 12px;
  color:var(--tx);font-size:14px;flex:1;outline:none;transition:border-color .2s;-webkit-appearance:none}
.sbox:focus{border-color:rgba(74,110,245,.5)}.sbox::placeholder{color:var(--mu)}
.sclr{background:none;border:none;color:var(--mu);font-size:16px;cursor:pointer;padding:0 6px;
  -webkit-tap-highlight-color:transparent;display:none;line-height:1}.sclr.vis{display:block}
.frow{display:flex;gap:6px;overflow-x:auto;scrollbar-width:none;align-items:center}
.frow::-webkit-scrollbar{display:none}
.chip{background:var(--sf2);border:1px solid var(--bd);border-radius:20px;padding:5px 12px;
  font-size:12px;color:var(--mu);cursor:pointer;flex-shrink:0;transition:all .15s;
  -webkit-tap-highlight-color:transparent;white-space:nowrap;font-weight:500}
.chip.on{background:rgba(74,110,245,.2);border-color:rgba(74,110,245,.45);color:#a0b4f5;font-weight:700}
.chip:active{transform:scale(.95)}
.chip.filter-btn{position:relative}
.chip.rand-btn{background:rgba(233,69,96,.1);border-color:rgba(233,69,96,.2);color:#f08090}
.chip.rand-btn:active{background:rgba(233,69,96,.25)}
.fbadge{position:absolute;top:-5px;right:-5px;width:16px;height:16px;background:var(--red);
  border-radius:50%;font-size:9px;font-weight:700;display:flex;align-items:center;
  justify-content:center;color:#fff;line-height:1}
/* Player stepper */
.prow{display:flex;align-items:center;gap:8px}
.prow-lbl{font-size:12px;color:var(--mu);white-space:nowrap;flex-shrink:0}
.prow-val{font-size:13px;font-weight:700;color:var(--tx);min-width:72px;text-align:center;flex-shrink:0}
.pstep{background:var(--sf2);border:1px solid var(--bd);border-radius:6px;width:30px;height:30px;
  display:flex;align-items:center;justify-content:center;font-size:18px;cursor:pointer;
  -webkit-tap-highlight-color:transparent;transition:background .12s;flex-shrink:0;color:var(--tx);
  font-weight:700;line-height:1;user-select:none;-webkit-user-select:none}
.pstep:active{background:var(--card)}
.pclr{background:none;border:none;font-size:11px;color:var(--mu);cursor:pointer;
  padding:3px 7px;-webkit-tap-highlight-color:transparent;flex-shrink:0;border-radius:6px;
  border:1px solid var(--bd)}
.pclr:active{color:var(--tx);background:var(--sf2)}
/* Pills */
.pillrow{display:flex;gap:6px;overflow-x:auto;scrollbar-width:none;align-items:center;min-height:22px}
.pillrow::-webkit-scrollbar{display:none}
.pill{display:inline-flex;align-items:center;gap:5px;background:rgba(74,110,245,.12);
  border:1px solid rgba(74,110,245,.25);border-radius:14px;padding:3px 8px 3px 10px;
  font-size:11px;color:#a0b4f5;white-space:nowrap;flex-shrink:0}
.pill.tag-pill{background:rgba(45,212,191,.1);border-color:rgba(45,212,191,.25);color:var(--grn)}
.pill-x{background:none;border:none;color:inherit;cursor:pointer;font-size:13px;line-height:1;
  padding:0;opacity:.7;-webkit-tap-highlight-color:transparent}
.pill-x:active{opacity:1}
.rcnt{font-size:11px;color:var(--mu);margin-left:auto;flex-shrink:0;white-space:nowrap}
/* Browse content */
.bcont{flex:1;overflow-y:auto;padding:12px 14px 80px;-webkit-overflow-scrolling:touch}
.bcont::-webkit-scrollbar{width:3px}
.bcont::-webkit-scrollbar-thumb{background:var(--bd);border-radius:2px}
.psec{margin-bottom:22px}
.ph{display:flex;align-items:center;gap:10px;margin-bottom:10px}
.pico{width:32px;height:32px;border-radius:7px;object-fit:cover;flex-shrink:0}
.pname{font-size:14px;font-weight:700}.pcnt{font-size:11px;color:var(--mu)}
.punowned{opacity:.38}
.ggrid{display:grid;grid-template-columns:repeat(2,1fr);gap:10px}
@media(min-width:500px){.ggrid{grid-template-columns:repeat(3,1fr);gap:8px}}
@media(min-width:760px){.ggrid{grid-template-columns:repeat(4,1fr);gap:8px}}
@media(min-width:1050px){.ggrid{grid-template-columns:repeat(5,1fr);gap:8px}}
@media(min-width:600px){.bcont{max-width:1100px;margin:0 auto;padding-left:20px;padding-right:20px}}
.gc{background:var(--card);border-radius:11px;overflow:hidden;cursor:pointer;border:1px solid var(--bd);
  transition:transform .14s,box-shadow .14s;-webkit-tap-highlight-color:transparent;position:relative}
.gc:active{transform:scale(.95)}
.gc.hv{border-color:rgba(74,110,245,.6);box-shadow:0 0 12px rgba(74,110,245,.25)}
.gc.hv::after{content:"HOST";position:absolute;top:6px;right:6px;background:var(--ac);
  color:#fff;font-size:8px;font-weight:700;padding:2px 5px;border-radius:4px;z-index:3;letter-spacing:.5px}
.gthumb-w{position:relative;aspect-ratio:16/9;overflow:hidden;background:var(--sf2)}
.gthumb{width:100%;height:100%;object-fit:cover;display:block}
.gpico{position:absolute;bottom:5px;left:5px;width:22px;height:22px;border-radius:5px;
  object-fit:cover;box-shadow:0 2px 6px rgba(0,0,0,.7)}
.gtb{position:absolute;bottom:5px;right:5px;font-size:9px;font-weight:700;padding:2px 5px;
  border-radius:4px;letter-spacing:.3px;backdrop-filter:blur(4px)}
.gtb.VERSUS{background:rgba(233,69,96,.8);color:#fff}
.gtb.COOP{background:rgba(45,212,191,.75);color:#0d2020}
.gtb.TEAM{background:rgba(74,110,245,.8);color:#fff}
.gcb{padding:7px 8px}
.gcn{font-size:12px;font-weight:600;line-height:1.3;margin-bottom:3px}
.gmeta{display:flex;align-items:center;justify-content:space-between}
.plb{font-size:10px;color:var(--mu)}.stars{font-size:10px;color:var(--yel);letter-spacing:-1px}
.nores{text-align:center;color:var(--mu);padding:52px 16px;font-size:15px;line-height:1.7}
/* DETAIL */
#vd{background:var(--bg);overflow:hidden}
.dbg{position:absolute;inset:0;background-size:cover;background-position:center;
  filter:blur(22px) brightness(.28);transform:scale(1.12);z-index:0;transition:background-image .3s}
.dbgo{position:absolute;inset:0;z-index:1;
  background:linear-gradient(to bottom,rgba(13,14,28,.15) 0%,rgba(13,14,28,.88) 50%,#0d0e1c 85%)}
.din{position:relative;z-index:2;height:100%;display:flex;flex-direction:column;overflow:hidden}
.dtop{display:flex;align-items:center;padding:11px 13px;gap:10px;flex-shrink:0}
.bbk{background:rgba(255,255,255,.1);border:none;border-radius:50%;width:38px;height:38px;
  display:flex;align-items:center;justify-content:center;cursor:pointer;color:#fff;font-size:18px;
  flex-shrink:0;-webkit-tap-highlight-color:transparent;transition:background .15s;line-height:1;backdrop-filter:blur(4px)}
.bbk:active{background:rgba(255,255,255,.22)}
.dttl{flex:1;font-weight:700;font-size:14px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;color:rgba(255,255,255,.85)}
.dcnt{color:var(--mu);font-size:12px;flex-shrink:0}
.dscroll{flex:1;overflow-y:auto;padding:0 14px 124px;-webkit-overflow-scrolling:touch}
.dscroll::-webkit-scrollbar{width:2px}.dscroll::-webkit-scrollbar-thumb{background:var(--bd)}
.dthw{display:flex;justify-content:center;margin:0 0 16px;padding:0 4px}
.dth{width:100%;max-width:360px;border-radius:11px;aspect-ratio:16/9;object-fit:cover;
  box-shadow:0 10px 40px rgba(0,0,0,.7);display:block}
.dpk{display:flex;align-items:center;gap:8px;margin-bottom:10px}
.dpki{width:26px;height:26px;border-radius:6px;object-fit:cover}
.dpkn{font-size:11px;color:var(--mu);font-weight:600}
.dgn{font-size:22px;font-weight:800;line-height:1.25;margin-bottom:5px;letter-spacing:-.3px}
.dtagline{color:var(--mu);font-size:13px;margin-bottom:13px;line-height:1.45;font-style:italic}
.dchips{display:flex;flex-wrap:wrap;gap:7px;margin-bottom:15px}
.dchip{display:flex;align-items:center;gap:5px;background:var(--sf2);border-radius:20px;
  padding:5px 11px;font-size:12px;font-weight:600;border:1px solid var(--bd)}
.dchip.VERSUS{background:rgba(233,69,96,.13);border-color:rgba(233,69,96,.3);color:#f08090}
.dchip.COOP{background:rgba(45,212,191,.1);border-color:rgba(45,212,191,.25);color:var(--grn)}
.dchip.TEAM{background:rgba(74,110,245,.13);border-color:rgba(74,110,245,.3);color:#a0b4f5}
.dchip.clickable{cursor:pointer;-webkit-tap-highlight-color:transparent;transition:filter .12s}
.dchip.clickable:active{filter:brightness(1.4)}
.dsec{margin-bottom:15px}
.dsect{font-size:10px;font-weight:700;color:var(--mu);letter-spacing:1.2px;text-transform:uppercase;margin-bottom:8px}
.ddesc{font-size:13px;line-height:1.7;color:rgba(232,233,240,.85)}
.sgrid{display:grid;grid-template-columns:1fr 1fr;gap:8px}
.sgi{background:var(--sf2);border-radius:9px;padding:10px 12px;border:1px solid var(--bd)}
.sgil{font-size:10px;color:var(--mu);margin-bottom:4px;font-weight:600;letter-spacing:.5px;text-transform:uppercase}
.sgiv{font-size:12px;font-weight:700}
.sgiv.yes{color:var(--grn)}.sgiv.no{color:var(--mu)}.sgiv.opt{color:var(--yel)}.sgiv.part{color:#a0b4f5}
.tagsrow{display:flex;flex-wrap:wrap;gap:6px}
.dtag2{background:var(--sf2);border:1px solid var(--bd);border-radius:6px;padding:4px 9px;
  font-size:11px;color:var(--mu);cursor:pointer;-webkit-tap-highlight-color:transparent;transition:all .12s}
.dtag2:active{background:rgba(45,212,191,.15);color:var(--grn);border-color:rgba(45,212,191,.35)}
/* Nav arrows â€“ subtle */
.dnpv,.dnnx{position:absolute;top:50%;transform:translateY(-50%);z-index:5;
  background:rgba(0,0,0,.35);border:none;border-radius:50%;width:30px;height:30px;
  display:flex;align-items:center;justify-content:center;cursor:pointer;color:rgba(255,255,255,.55);
  font-size:15px;-webkit-tap-highlight-color:transparent;transition:opacity .2s,background .15s;
  backdrop-filter:blur(4px);line-height:1;opacity:.35}
.dnpv:hover,.dnnx:hover{opacity:.9;background:rgba(0,0,0,.65)}
.dnpv:active,.dnnx:active{opacity:1;background:rgba(0,0,0,.78)}
.dnpv:disabled,.dnnx:disabled{opacity:0;pointer-events:none}
.dnpv{left:5px}.dnnx{right:5px}
/* Launch bar */
.lbar{position:absolute;bottom:0;left:0;right:0;z-index:6;padding:12px 14px 18px;
  background:linear-gradient(transparent,rgba(13,14,28,.97) 55%)}
.blnch{width:100%;padding:14px;background:var(--ac);border:none;border-radius:var(--r);
  color:#fff;font-size:15px;font-weight:700;cursor:pointer;letter-spacing:.4px;
  -webkit-tap-highlight-color:transparent;transition:background .15s,transform .1s;display:block;margin-bottom:8px}
.blnch:last-child{margin-bottom:0}
.blnch:active{background:var(--acd);transform:scale(.98)}
.blnch.secondary{background:var(--sf2);border:1px solid rgba(74,110,245,.4);color:#a0b4f5}
.blnch.secondary:active{background:var(--card)}
/* FILTER MODAL */
#fmodal{position:fixed;inset:0;z-index:200;pointer-events:none;display:flex;align-items:flex-end;justify-content:center}
#fmodal.open{pointer-events:all}
.fmov{position:absolute;inset:0;background:rgba(0,0,0,0);transition:background .28s}
#fmodal.open .fmov{background:rgba(0,0,0,.6)}
.fmpanel{position:relative;background:var(--sf);width:100%;max-width:640px;max-height:90vh;
  border-radius:22px 22px 0 0;display:flex;flex-direction:column;
  transform:translateY(100%);transition:transform .3s cubic-bezier(.32,0,.67,0)}
#fmodal.open .fmpanel{transform:translateY(0);transition-timing-function:cubic-bezier(.33,1,.68,1)}
.fmh{padding:14px 18px 10px;display:flex;align-items:center;flex-shrink:0;border-bottom:1px solid var(--bd)}
.fmtitle{font-size:16px;font-weight:700;flex:1}
.fmreset{font-size:13px;color:var(--ac);cursor:pointer;-webkit-tap-highlight-color:transparent;padding:4px}
.fmscroll{flex:1;overflow-y:auto;padding:14px 18px 32px;-webkit-overflow-scrolling:touch}
.fmscroll::-webkit-scrollbar{width:2px}.fmscroll::-webkit-scrollbar-thumb{background:var(--bd)}
.fmsec{margin-bottom:18px}
.fmsh{font-size:11px;font-weight:700;color:var(--mu);letter-spacing:1px;text-transform:uppercase;margin-bottom:8px}
.optrow{display:flex;flex-wrap:wrap;gap:7px}
.opt{background:var(--sf2);border:1px solid var(--bd);border-radius:8px;padding:7px 13px;
  font-size:12px;font-weight:600;color:var(--mu);cursor:pointer;-webkit-tap-highlight-color:transparent;transition:all .14s}
.opt.on{background:rgba(74,110,245,.18);border-color:rgba(74,110,245,.45);color:#a0b4f5}
.opt:active{transform:scale(.95)}
.trow{display:flex;align-items:center;gap:10px;justify-content:space-between;background:var(--sf2);
  border-radius:9px;padding:11px 14px;margin-bottom:7px;border:1px solid var(--bd);
  cursor:pointer;-webkit-tap-highlight-color:transparent}
.trow:active{background:var(--card)}
.trow-l{font-size:13px;font-weight:600}.trow-s{font-size:12px;color:var(--mu);margin-top:2px}
.tog{width:40px;height:22px;border-radius:11px;background:var(--sf2);border:2px solid var(--bd);
  position:relative;flex-shrink:0;transition:background .2s,border-color .2s;pointer-events:none}
.tog.on{background:rgba(74,110,245,.5);border-color:var(--ac)}
.tog::after{content:"";position:absolute;top:2px;left:2px;width:14px;height:14px;
  border-radius:50%;background:#fff;transition:transform .2s;opacity:.7}
.tog.on::after{transform:translateX(18px);opacity:1}
.slrow{display:flex;align-items:center;gap:10px;padding:4px 0}
.slrow input[type=range]{flex:1;accent-color:var(--ac);height:4px}
.slval{color:var(--tx);font-weight:700;min-width:44px;text-align:right;font-size:13px;flex-shrink:0}
.tagsgrid{display:flex;flex-wrap:wrap;gap:7px}
.tg{background:var(--sf2);border:1px solid var(--bd);border-radius:7px;padding:6px 11px;
  font-size:12px;color:var(--mu);cursor:pointer;-webkit-tap-highlight-color:transparent;transition:all .14s}
.tg.on{background:rgba(45,212,191,.12);border-color:rgba(45,212,191,.35);color:var(--grn)}
.tg:active{transform:scale(.95)}
.fmapply{width:100%;padding:14px;background:var(--ac);border:none;border-radius:var(--r);
  color:#fff;font-size:15px;font-weight:700;cursor:pointer;margin-top:14px;
  letter-spacing:.4px;-webkit-tap-highlight-color:transparent;transition:background .15s}
.fmapply:active{background:var(--acd)}
/* RANDOM OVERLAY */
#randOv{position:fixed;inset:0;z-index:300;display:flex;flex-direction:column;
  align-items:center;justify-content:center;gap:18px;
  background:rgba(13,14,28,.97);backdrop-filter:blur(14px);
  pointer-events:none;opacity:0;transition:opacity .3s}
#randOv.show{opacity:1;pointer-events:all}
.rand-dice{font-size:72px}
.rand-dice.spin{animation:rspin .35s linear infinite}
@keyframes rspin{from{transform:rotate(0)}to{transform:rotate(360deg)}}
.rand-frame{height:36px;overflow:hidden;width:300px;text-align:center}
.rand-name{font-size:17px;font-weight:700;color:#a0b4f5;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;padding:0 8px}
.rand-hint{font-size:13px;color:var(--mu)}
.rand-winner{font-size:22px;font-weight:800;color:var(--grn);text-align:center;padding:0 16px;line-height:1.35}
/* ADMIN LOCK */
#adminLock{position:fixed;inset:0;z-index:350;display:none;align-items:center;justify-content:center;
  background:rgba(7,8,18,.95);backdrop-filter:blur(10px);padding:20px}
#adminLock.show{display:flex}
.al-panel{width:min(94vw,540px);background:var(--sf);border:1px solid var(--bd);border-radius:14px;padding:14px}
.al-title{font-size:18px;font-weight:800;margin-bottom:6px}
.al-sub{font-size:13px;color:var(--mu);margin-bottom:8px}
.al-picked{font-size:12px;color:#a0b4f5;min-height:18px;margin-bottom:10px}
.al-grid{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:8px}
.al-cell{aspect-ratio:1/1;min-height:42px;height:auto;border-radius:8px;border:1px solid var(--bd);background:var(--sf2);
  color:var(--tx);font-size:11px;font-weight:700;display:flex;align-items:center;justify-content:center;
  cursor:pointer;-webkit-tap-highlight-color:transparent;user-select:none;-webkit-user-select:none}
.al-cell.on{background:rgba(74,110,245,.25);border-color:rgba(74,110,245,.6)}
.al-actions{display:flex;gap:8px;justify-content:flex-end;margin-top:12px}
.al-btn{background:var(--sf2);border:1px solid var(--bd);border-radius:8px;padding:8px 12px;color:var(--tx);cursor:pointer}
.al-btn.primary{background:var(--ac);border-color:rgba(74,110,245,.6);color:#fff}
/* TOAST */
#toast{position:fixed;bottom:26px;left:50%;transform:translateX(-50%) translateY(80px);
  background:rgba(30,34,64,.97);color:#fff;padding:10px 18px;border-radius:24px;
  font-size:13px;border:1px solid var(--bd);pointer-events:none;transition:transform .28s;
  z-index:9999;white-space:nowrap;box-shadow:var(--sh);backdrop-filter:blur(10px)}
#toast.show{transform:translateX(-50%) translateY(0)}
*{scrollbar-width:thin;scrollbar-color:var(--bd) transparent}
</style>
</head>
<body>

<!-- WELCOME -->
<div id="vw" class="view active">
  <div class="wlogo">&#127918;</div>
  <div class="wtitle">JackboxU Remote</div>
  <div class="wsub">Choose your role to continue</div>
  <div class="rcards">
    <div class="rcard admin" id="btnAdmin">
      <div class="rct">&#127919; Host Control</div>
      <div class="rcs">Launch games, sync filters, and control the desktop app.</div>
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

<!-- ADMIN LOCK MODAL -->
<div id="adminLock">
  <div class="al-panel">
    <div class="al-title">Admin Pattern Required</div>
    <div class="al-sub">Tap 4 cells in the configured order (5x5).</div>
    <div class="al-picked" id="alPicked"></div>
    <div class="al-grid" id="alGrid"></div>
    <div class="al-actions">
      <button class="al-btn" id="alClear">Clear</button>
      <button class="al-btn" id="alCancel">Cancel</button>
      <button class="al-btn primary" id="alSubmit">Unlock</button>
    </div>
  </div>
</div>

<!-- BROWSE -->
<div id="vb" class="view">
  <div class="bh">
    <a class="blogo" id="logoLink" href="https://jackbox.tv" target="_blank" rel="noopener">
      <span class="blt">JackboxU</span><span class="tvsuf">.tv</span>
    </a>
    <div class="rbadge" id="roleBadge" title="Tap to switch role"></div>
    <div class="cdot" id="connDot"></div>
  </div>
  <div class="abar" id="adminBar" style="display:none">
    <div class="abar-l">
      <div class="stab on full" id="tabFull">&#10227; Full Sync</div>
      <div class="stab" id="tabPaused">&#9646;&#9646; Paused</div>
    </div>
    <button class="muteBtn" id="muteBtn" title="Toggle SFX">&#128266;</button>
  </div>
  <div class="bt">
    <div class="srow">
      <input class="sbox" id="searchBox" type="search" placeholder="Search games&#8230;"
        autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false">
      <button class="sclr" id="searchClr" aria-label="Clear">&#10005;</button>
    </div>
    <div class="frow">
      <div class="chip on" id="chipAll">All</div>
      <div class="chip" id="chipVS">Versus</div>
      <div class="chip" id="chipCO">Co-op</div>
      <div class="chip" id="chipTM">Team</div>
      <div class="chip filter-btn" id="chipFilter">Filters<span class="fbadge" id="filterBadge" style="display:none">0</span></div>
      <div class="chip" id="chipSort">Sort: Pack</div>
      <div class="chip on" id="chipGrp">&#9783; By Pack</div>
      <div class="chip rand-btn" id="chipRand" style="display:none">&#127922; Random</div>
    </div>
    <div class="prow">
      <span class="prow-lbl">Min Players:</span>
      <button class="pstep" id="pDec">&#8722;</button>
      <span class="prow-val" id="pVal">Any</span>
      <button class="pstep" id="pInc">&#43;</button>
      <button class="pclr" id="pClr" style="display:none">clear</button>
    </div>
    <div class="pillrow" id="pillRow">
      <span class="rcnt" id="resCnt"></span>
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
      <div class="dpk" id="detailPack"></div>
      <div class="dgn" id="detailName"></div>
      <div class="dtagline" id="detailTagline"></div>
      <div class="dchips" id="detailChips"></div>
      <div class="dsec" id="descSec">
        <div class="dsect">About</div>
        <div class="ddesc" id="detailDesc"></div>
      </div>
      <div class="dsec" id="statsSec">
        <div class="dsect">Features</div>
        <div class="sgrid" id="statsGrid"></div>
      </div>
      <div class="dsec" id="tagsSec">
        <div class="dsect">Tags</div>
        <div class="tagsrow" id="tagsRow"></div>
      </div>
    </div>
    <button class="dnpv" id="navPrev" disabled>&#8249;</button>
    <button class="dnnx" id="navNext" disabled>&#8250;</button>
    <div class="lbar" id="launchBar" style="display:none"></div>
  </div>
</div>

<!-- FILTER MODAL -->
<div id="fmodal">
  <div class="fmov" id="fmodalOv"></div>
  <div class="fmpanel">
    <div class="fmh">
      <div class="fmtitle">Filters &amp; Sort</div>
      <div class="fmreset" id="fmReset">Reset All</div>
    </div>
    <div class="fmscroll">
      <div class="fmsec">
        <div class="fmsh">Sort By</div>
        <div class="optrow" id="sortOpts"></div>
        <div style="margin-top:8px">
          <div class="trow" id="sortDirRow">
            <div><div class="trow-l" id="sortDirLabel">Ascending</div></div>
            <div class="tog" id="sortDirTog"></div>
          </div>
        </div>
      </div>
      <div class="fmsec">
        <div class="fmsh">Playtime</div>
        <div class="trow" id="ptTogRow">
          <div><div class="trow-l">Max Playtime</div><div class="trow-s" id="ptVal">Any</div></div>
          <div class="tog" id="ptTog"></div>
        </div>
        <div class="slrow" id="ptSlRow" style="display:none">
          <input type="range" id="ptSl" min="5" max="120" step="5" value="60">
          <span class="slval" id="ptSlVal">60 min</span>
        </div>
      </div>
      <div class="fmsec">
        <div class="fmsh">Pack Settings</div>
        <div class="trow" id="packTogRow">
          <div><div class="trow-l">Show All Packs</div><div class="trow-s">Include unowned packs</div></div>
          <div class="tog" id="packTog"></div>
        </div>
        <div class="trow" id="hiddenTogRow">
          <div><div class="trow-l">Show Hidden</div><div class="trow-s">Include hidden games</div></div>
          <div class="tog" id="hiddenTog"></div>
        </div>
      </div>
      <div class="fmsec">
        <div class="fmsh">View Settings</div>
        <div class="trow" id="overlayTogRow">
          <div><div class="trow-l">Always Show Overlay</div><div class="trow-s">Show card stats without hover</div></div>
          <div class="tog" id="overlayTog"></div>
        </div>
      </div>
      <div class="fmsec">
        <div class="fmsh">Content Filters</div>
        <div id="contentFilters"></div>
      </div>
      <div class="fmsec" id="tagsSection">
        <div class="fmsh">Tags</div>
        <div class="tagsgrid" id="tagsGrid"></div>
      </div>
      <button class="fmapply" id="fmApply">Apply Filters</button>
    </div>
  </div>
</div>

<!-- RANDOM OVERLAY -->
<div id="randOv">
  <div class="rand-dice spin" id="randDice">&#127922;</div>
  <div class="rand-frame"><div class="rand-name" id="randName">Picking&#8230;</div></div>
  <div class="rand-hint" id="randHint">Finding a random game&#8230;</div>
  <div class="rand-winner" id="randWinner" style="display:none"></div>
</div>

<div id="toast"></div>

<script>
"use strict";

const S = {
  role:null, syncMode:'full', sfxMuted:false,
  packs:[], allTags:[], flat:[], filtered:[],
  idx:-1, hostGameId:null,
  search:'', gameType:null,
  filters:{
    FAMILY_FRIENDLY:{activated:false,selected:'FAMILY_FRIENDLY_AVAILABLE'},
    AUDIENCE:       {activated:false,selected:'AUDIENCE_AVAILABLE'},
    STREAM_FRIENDLY:{activated:false,selected:'STREAM_FRIENDLY_BOTH'},
    MODERATION:     {activated:false,selected:'MODERATION_BOTH'},
    SUBTITLES:      {activated:false,selected:'SUBTITLES_AVAILABLE'},
    TRANSLATION:    {activated:false,selected:'TRANSLATION_TRANSLATED'},
  },
  intFilters:{
    minPlayers:{activated:false,selected:2},
    maxPlaytime:{activated:false,selected:60},
  },
  activeTags:new Set(),
  sortOrder:'PACK', sortAscending:true,
  showAllPacks:false, showHidden:false,
  alwaysCardOverlay:false,
  adminLockEnabled:false,
  adminPattern:[],
  adminAttempt:[],
  configLoaded:false,
  groupByPack:true,
  ws:null, wsOk:false,
  draft:null,
};

// Restore player min from localStorage
(function(){
  try{
    const v=parseInt(localStorage.getItem('jb_playerMin')||'0');
    if(v>=2){S.intFilters.minPlayers.activated=true;S.intFilters.minPlayers.selected=v;}
  }catch(_){}
})();

/* HELPERS */
function tagStr(t){return typeof t==='string'?t:(t.name||t.id||String(t));}

/* WS */
function wsConnect(){
  const p=location.protocol==='https:'?'wss:':'ws:';
  S.ws=new WebSocket(p+'//'+location.host+'/ws');
  S.ws.onopen=()=>{S.wsOk=true;dotSet(true);};
  S.ws.onclose=()=>{S.wsOk=false;dotSet(false);setTimeout(wsConnect,3000);};
  S.ws.onerror=()=>{S.wsOk=false;dotSet(false);};
  S.ws.onmessage=e=>{try{handleMsg(JSON.parse(e.data));}catch(_){}};
}
function wsTx(o){if(S.ws&&S.ws.readyState===1)S.ws.send(JSON.stringify(o));}

function handleMsg(m){
  if(m.type==='state'){
    applyDesktopState(m);
  } else if(m.type==='packs'||m.type==='game_list'){
    S.packs=m.packs||[];buildFlat();applyFilter();
    if(isView('vb'))renderBrowse();
  } else if(m.type==='navigate'){
    S.hostGameId=m.gameId||null;
    if(m.random){
      // Random game result â€“ animate then open
      const fi=S.filtered.findIndex(x=>x.game.id===m.gameId);
      const gi=fi>=0?fi:S.flat.findIndex(x=>x.game.id===m.gameId);
      showRandResult(gi>=0?gi:0, fi>=0?'filtered':'flat', m.gameId);
    } else {
      if(S.role==='guest'&&m.gameId){
        const e=S.flat.find(x=>x.game.id===m.gameId);
        if(e)toast('Host viewing: '+xe(e.game.name));
      }
      if(isView('vb'))renderBrowse();
      if(isView('vd'))markHostGame();
    }
  } else if(m.type==='close_detail'){
    if(isView('vd'))showBrowse();
  }
}

function dotSet(ok){
  document.getElementById('wsDot').className='wdot'+(ok?' ok':' err');
  document.getElementById('wsTxt').textContent=ok?'Connected':'Disconnected';
  const cd=document.getElementById('connDot');
  if(cd)cd.className='cdot'+(ok?' ok':' err');
}

/* DATA */
async function loadGames(){
  try{
    const [gr,tr]=await Promise.all([fetch('/api/games'),fetch('/api/tags').catch(()=>null)]);
    const gd=await gr.json();
    S.packs=gd.packs||[];
    const lock=gd.adminLock||{};
    S.adminLockEnabled=!!lock.enabled;
    S.adminPattern=String(lock.pattern||'').split(',').map(v=>parseInt(v,10)).filter(v=>Number.isInteger(v)&&v>=0&&v<25);
    S.configLoaded=true;
    if(gd.state)applyDesktopState(gd.state,true);
    if(tr){const td=await tr.json();S.allTags=td.tags||[];}
    buildFlat();applyFilter();renderBrowse();
    return true;
  }catch(e){toast('Could not load games');return false;}
}

function buildFlat(){
  S.flat=[];
  for(const pk of S.packs)
    for(const g of(pk.games||[]))
      S.flat.push({packId:pk.id,packName:pk.name,packIcon:pk.icon,
        packBg:pk.background,packOwned:pk.owned,game:g});
}

/* FILTER */
function applyFilter(){
  const q=S.search.toLowerCase().trim();
  S.filtered=S.flat.filter(({packOwned,game:g})=>{
    if(!S.showAllPacks&&!packOwned)return false;
    if(!S.showHidden&&g.hidden)return false;
    if(q&&!g.name.toLowerCase().includes(q))return false;
    if(S.gameType&&g.type!==S.gameType)return false;
    if(S.intFilters.minPlayers.activated&&g.players&&g.players.max<S.intFilters.minPlayers.selected)return false;
    if(S.intFilters.maxPlaytime.activated&&g.playtime&&g.playtime.min>S.intFilters.maxPlaytime.selected)return false;
    for(const[k,f]of Object.entries(S.filters)){
      if(f.activated&&!fMatch(g,f.selected))return false;
    }
    if(S.activeTags.size>0){
      const gt=new Set((g.tags||[]).map(tagStr));
      for(const t of S.activeTags)if(!gt.has(t))return false;
    }
    return true;
  });
  S.filtered.sort(sortCmp);
  updatePlayerUI();
  updatePills();
}

function fMatch(g,v){
  switch(v){
    case'FAMILY_FRIENDLY_AVAILABLE':return g.familyFriendly==='FAMILY_FRIENDLY'||g.familyFriendly==='OPTIONAL';
    case'AUDIENCE_AVAILABLE':return g.audience===true;
    case'STREAM_FRIENDLY_PLAYABLE':return g.streamFriendly==='PLAYABLE';
    case'STREAM_FRIENDLY_MIDLY_PLAYABLE':return g.streamFriendly==='MIDLY_PLAYABLE';
    case'STREAM_FRIENDLY_BOTH':return g.streamFriendly==='PLAYABLE'||g.streamFriendly==='MIDLY_PLAYABLE';
    case'MODERATION_FULL_MODERATION':return g.moderation==='FULL_MODERATION';
    case'MODERATION_CENSORING':return g.moderation==='CENSORING';
    case'MODERATION_BOTH':return g.moderation==='FULL_MODERATION'||g.moderation==='CENSORING';
    case'SUBTITLES_AVAILABLE':return g.subtitles===true;
    case'TRANSLATION_DUBBED':return g.translation==='NATIVELY_TRANSLATED'||g.translation==='COMMUNITY_DUBBED';
    case'TRANSLATION_TRANSLATED':return g.translation==='NATIVELY_TRANSLATED'||g.translation==='COMMUNITY_DUBBED'||g.translation==='COMMUNITY_TRANSLATED';
    default:return true;
  }
}

function sortCmp(a,b){
  let v=0;
  const ga=a.game,gb=b.game;
  switch(S.sortOrder){
    case'PACK':v=a.packName.localeCompare(b.packName)||ga.name.localeCompare(gb.name);break;
    case'NAME':v=ga.name.localeCompare(gb.name);break;
    case'STARS':v=(gb.stars||0)-(ga.stars||0);break;
    case'PLAYERS':v=(ga.players?ga.players.max:0)-(gb.players?gb.players.max:0);break;
  }
  return S.sortAscending?v:-v;
}

/* DESKTOP SYNC */
function applyDesktopState(m,force){
  // Admin in full sync: also receive desktop-originated state pushes (no feedback loop since we don't re-push here)
  if(S.role==='admin'&&!force&&S.syncMode!=='full')return;
  if(m.search!==undefined){S.search=m.search;const sb=document.getElementById('searchBox');if(sb)sb.value=S.search;updClr();}
  const tf=(m.filters||[]).find(f=>f.filterType==='TYPE'&&f.activated);
  S.gameType=tf?tf.selected:null;
  for(const[k,f]of Object.entries(S.filters)){
    const mf=(m.filters||[]).find(x=>x.filterType===k);
    if(mf){f.activated=mf.activated;if(mf.selected)f.selected=mf.selected;}
  }
  const mp=(m.intFilters||[]).find(f=>f.type==='minPlayers');
  if(mp){S.intFilters.minPlayers.activated=mp.activated;S.intFilters.minPlayers.selected=mp.selected;savePlayerMin();}
  const pt=(m.intFilters||[]).find(f=>f.type==='maxPlaytime');
  if(pt){S.intFilters.maxPlaytime.activated=pt.activated;S.intFilters.maxPlaytime.selected=pt.selected;}
  if(m.activeTags){S.activeTags=new Set(m.activeTags);}
  if(m.sortOrder)S.sortOrder=m.sortOrder;
  if(m.sortAscending!==undefined)S.sortAscending=m.sortAscending;
  if(m.showAllPacks!==undefined)S.showAllPacks=m.showAllPacks;
  if(m.showHidden!==undefined)S.showHidden=m.showHidden;
  if(m.alwaysCardOverlay!==undefined)S.alwaysCardOverlay=m.alwaysCardOverlay;
  updateTypeChips();
  applyFilter();
  if(isView('vb'))renderBrowse();
}

function pushState(){
  if(S.role!=='admin'||S.syncMode!=='full')return;
  const filters=Object.entries(S.filters).map(([k,f])=>({filterType:k,activated:f.activated,selected:f.selected}));
  filters.push({filterType:'TYPE',activated:!!S.gameType,selected:S.gameType||'VERSUS'});
  wsTx({type:'state_update',search:S.search,filters,
    activeTags:Array.from(S.activeTags),
    sortOrder:S.sortOrder,sortAscending:S.sortAscending,
    intFilters:[
      {type:'minPlayers',activated:S.intFilters.minPlayers.activated,selected:S.intFilters.minPlayers.selected},
      {type:'maxPlaytime',activated:S.intFilters.maxPlaytime.activated,selected:S.intFilters.maxPlaytime.selected},
    ],
    showAllPacks:S.showAllPacks,showHidden:S.showHidden,
    alwaysCardOverlay:S.alwaysCardOverlay});
}

/* ROLE / VIEWS */
async function requestAdminRole(){
  if(!S.configLoaded){
    const ok=await loadGames();
    if(!ok)return;
  }
  if(!S.adminLockEnabled||S.adminPattern.length!==4){setRole('admin');return;}
  openAdminLock();
}

function setRole(role){
  S.role=role;
  const rb=document.getElementById('roleBadge');
  rb.textContent=role==='admin'?'HOST':'GUEST';
  rb.className='rbadge '+role;
  document.getElementById('adminBar').style.display=role==='admin'?'':'none';
  document.getElementById('chipRand').style.display=role==='admin'?'':'none';
  showView('vb');loadGames();
}

function openAdminLock(){
  S.adminAttempt=[];
  renderAdminLock();
  document.getElementById('adminLock').classList.add('show');
}

function closeAdminLock(){
  document.getElementById('adminLock').classList.remove('show');
}

function renderAdminLock(){
  const order={};
  S.adminAttempt.forEach((idx,i)=>order[idx]=i+1);
  document.getElementById('alGrid').innerHTML=Array.from({length:25},(_,idx)=>
    `<div class="al-cell${order[idx]?' on':''}" data-idx="${idx}">${order[idx]||''}</div>`
  ).join('');
  document.getElementById('alPicked').textContent=S.adminAttempt.length?`Selected: ${S.adminAttempt.map(v=>'#'+(v+1)).join(' -> ')}`:'Selected: none';
}

function adminCellTap(idx){
  if(S.adminAttempt.includes(idx)||S.adminAttempt.length>=4)return;
  S.adminAttempt.push(idx);
  renderAdminLock();
}

function submitAdminLock(){
  if(S.adminAttempt.length!==4){toast('Pick 4 cells');return;}
  const ok=S.adminAttempt.every((v,i)=>v===S.adminPattern[i]);
  if(!ok){
    toast('Pattern incorrect');
    S.adminAttempt=[];
    renderAdminLock();
    return;
  }
  closeAdminLock();
  setRole('admin');
}

function isView(id){return document.getElementById(id).classList.contains('active');}
function showView(id){document.querySelectorAll('.view').forEach(v=>v.classList.remove('active'));document.getElementById(id).classList.add('active');}
function showBrowse(){
  // Notify desktop to close detail if in full sync
  if(S.role==='admin'&&S.syncMode==='full'&&isView('vd')){
    wsTx({type:'close_detail'});
  }
  showView('vb');renderBrowse();
}

/* BROWSE */
function renderBrowse(){
  const cont=document.getElementById('browseCont');
  if(!S.flat.length){cont.innerHTML='<div class="nores">Loading games&#8230;</div>';return;}
  if(!S.filtered.length){cont.innerHTML='<div class="nores">No games match your filters.<br><small>Try adjusting them.</small></div>';return;}
  if(S.groupByPack){
    const grp=new Map(),ord=[];
    for(const e of S.filtered){
      if(!grp.has(e.packId)){grp.set(e.packId,{...e,entries:[]});ord.push(e.packId);}
      grp.get(e.packId).entries.push(e);
    }
    cont.innerHTML=ord.map(pid=>{
      const pk=grp.get(pid);
      const cards=pk.entries.map(e=>gcHtml(e,S.filtered.indexOf(e))).join('');
      return `<div class="psec${pk.packOwned?'':' punowned'}">
        <div class="ph">
          ${pk.packIcon?`<img class="pico" src="${xe(pk.packIcon)}" alt="" onerror="this.remove()">`:``}
          <div><div class="pname">${xe(pk.packName)}</div>
          <div class="pcnt">${pk.entries.length} game${pk.entries.length!==1?'s':''}${pk.packOwned?'':' &middot; Not Owned'}</div></div>
        </div>
        <div class="ggrid">${cards}</div>
      </div>`;
    }).join('');
  } else {
    cont.innerHTML=`<div class="ggrid">${S.filtered.map((e,i)=>gcHtml(e,i)).join('')}</div>`;
  }
}

function gcHtml(e,idx){
  const g=e.game,hv=S.hostGameId===g.id;
  const stars=g.stars>0?'&#9733;'.repeat(Math.min(g.stars,5)):'';
  const tb=g.type?`<div class="gtb ${g.type}">${xe(tShort(g.type))}</div>`:'';
  const pico=e.packIcon?`<img class="gpico" src="${xe(e.packIcon)}" alt="" onerror="this.remove()">`:'' ;
  return `<div class="gc${hv?' hv':''}" onclick="openDetail(${idx})">
    <div class="gthumb-w">
      <img class="gthumb" src="${xe(g.thumbnail)}" loading="lazy" alt="" onerror="this.style.opacity=0">
      ${pico}${tb}
    </div>
    <div class="gcb">
      <div class="gcn">${xe(g.name)}</div>
      <div class="gmeta">
        <span class="plb">${xe(plTxt(g.players))}p</span>
        ${stars?`<span class="stars">${stars}</span>`:''}
      </div>
    </div>
  </div>`;
}

function markHostGame(){
  document.querySelectorAll('.gc').forEach((el,i)=>{
    const e=S.filtered[i];if(!e)return;
    el.classList.toggle('hv',S.hostGameId===e.game.id);
  });
}

function updatePlayerUI(){
  const v=S.intFilters.minPlayers;
  const pv=document.getElementById('pVal');
  if(pv)pv.textContent=v.activated?v.selected+'+ players':'Any';
  const pd=document.getElementById('pDec');
  if(pd)pd.disabled=!v.activated;
  const pi=document.getElementById('pInc');
  if(pi)pi.disabled=v.activated&&v.selected>=10;
  const pc=document.getElementById('pClr');
  if(pc)pc.style.display=v.activated?'':'none';
}

function updatePills(){
  const pills=[];
  if(S.search)pills.push(`<span class="pill">&#128269; ${xe(S.search)}<button class="pill-x" onclick="clearSearch()">&#10005;</button></span>`);
  if(S.gameType)pills.push(`<span class="pill">${xe(tName(S.gameType))}<button class="pill-x" onclick="clearType()">&#10005;</button></span>`);
  for(const t of S.activeTags)pills.push(`<span class="pill tag-pill">#${xe(t)}<button class="pill-x" onclick="removeTag('${xe(t)}')">&#10005;</button></span>`);
  for(const[k,f]of Object.entries(S.filters))
    if(f.activated)pills.push(`<span class="pill">${xe(pillLabel(f.selected))}<button class="pill-x" onclick="clearFilter('${k}')">&#10005;</button></span>`);
  if(S.intFilters.maxPlaytime.activated)pills.push(`<span class="pill">&#8804;${S.intFilters.maxPlaytime.selected}min<button class="pill-x" onclick="clearInt('maxPlaytime')">&#10005;</button></span>`);
  const total=pills.length+(S.intFilters.minPlayers.activated?1:0);
  const fb=document.getElementById('filterBadge');
  fb.textContent=String(total);fb.style.display=total?'':'none';
  const cnt=S.filtered.length+' game'+(S.filtered.length!==1?'s':'');
  document.getElementById('pillRow').innerHTML=pills.join('')+`<span class="rcnt">${cnt}</span>`;
}

function pillLabel(v){
  return{FAMILY_FRIENDLY_AVAILABLE:'Family Friendly',AUDIENCE_AVAILABLE:'Audience',
    STREAM_FRIENDLY_PLAYABLE:'Stream: Playable',STREAM_FRIENDLY_MIDLY_PLAYABLE:'Stream: Mild',
    STREAM_FRIENDLY_BOTH:'Stream Friendly',MODERATION_FULL_MODERATION:'Full Moderation',
    MODERATION_CENSORING:'Censoring',MODERATION_BOTH:'Moderation',
    SUBTITLES_AVAILABLE:'Subtitles',TRANSLATION_DUBBED:'Dubbed',
    TRANSLATION_TRANSLATED:'Translated'}[v]||v;
}

/* DETAIL */
function openDetail(idx){
  S.idx=idx;renderDetail();showView('vd');
  if(S.role==='admin'&&S.filtered[idx]){
    S.hostGameId=S.filtered[idx].game.id;
    if(S.syncMode==='full'){
      wsTx({type:'navigate',gameId:S.hostGameId});
      wsTx({type:'show_game',gameId:S.hostGameId});
    }
  }
}

function navGame(dir){
  const ni=S.idx+dir;
  if(ni<0||ni>=S.filtered.length)return;
  S.idx=ni;renderDetail();
  if(S.role==='admin'&&S.filtered[ni]){
    S.hostGameId=S.filtered[ni].game.id;
    if(S.syncMode==='full'){
      wsTx({type:'navigate',gameId:S.hostGameId});
      wsTx({type:'show_game',gameId:S.hostGameId});
    }
  }
}

function renderDetail(){
  const e=S.filtered[S.idx];if(!e)return;
  const g=e.game;
  document.getElementById('detailBg').style.backgroundImage=`url(${xe(e.packBg||g.thumbnail||'')})`;
  document.getElementById('detailThumb').src=g.thumbnail||'';
  document.getElementById('detailTopTitle').textContent=g.name;
  document.getElementById('detailName').textContent=g.name;
  document.getElementById('detailTagline').textContent=g.tagline||'';
  document.getElementById('detailCnt').textContent=`${S.idx+1} / ${S.filtered.length}`;
  document.getElementById('detailScroll').scrollTop=0;
  document.getElementById('navPrev').disabled=S.idx===0;
  document.getElementById('navNext').disabled=S.idx>=S.filtered.length-1;
  const dpk=document.getElementById('detailPack');
  dpk.innerHTML=(e.packIcon?`<img class="dpki" src="${xe(e.packIcon)}" alt="" onerror="this.remove()">`:'')+
    `<div class="dpkn">${xe(e.packName)}</div>`;
  const chips=[];
  if(g.players)chips.push(`<div class="dchip">&#128101; ${xe(plTxt(g.players))}</div>`);
  if(g.playtime)chips.push(`<div class="dchip">&#9201; ${xe(ptTxt(g.playtime))} min</div>`);
  if(g.type)chips.push(`<div class="dchip ${g.type} clickable" onclick="filterByType('${xe(g.type)}')" title="Tap to filter">${xe(tName(g.type))}</div>`);
  if(g.stars)chips.push(`<div class="dchip">&#9733; ${g.stars}/5</div>`);
  document.getElementById('detailChips').innerHTML=chips.join('');
  const desc=g.description||g.smallDescription||'';
  document.getElementById('detailDesc').textContent=desc;
  document.getElementById('descSec').style.display=desc?'':'none';
  const stats=[
    {l:'Family Friendly',v:fmtFF(g.familyFriendly)},
    {l:'Stream Friendly',v:fmtSF(g.streamFriendly)},
    {l:'Moderation',v:fmtMod(g.moderation)},
    {l:'Audience Mode',v:fmtBool(g.audience)},
    {l:'Subtitles',v:fmtBool(g.subtitles)},
    {l:'Translation',v:fmtTr(g.translation)},
  ];
  document.getElementById('statsGrid').innerHTML=stats.map(s=>
    `<div class="sgi"><div class="sgil">${s.l}</div><div class="sgiv ${s.v.cls}">${s.v.txt}</div></div>`
  ).join('');
  const tags=g.tags||[];
  document.getElementById('tagsRow').innerHTML=tags.map(t=>
    `<span class="dtag2" onclick="filterByTag('${xe(tagStr(t))}')" title="Tap to filter">#${xe(tagStr(t))}</span>`
  ).join('');
  document.getElementById('tagsSec').style.display=tags.length?'':'none';
  renderLaunchBar(g);
}

function renderLaunchBar(g){
  const lb=document.getElementById('launchBar');
  if(!g||S.role!=='admin'){lb.style.display='none';return;}
  lb.style.display='';
  if(S.syncMode==='paused'){
    lb.innerHTML=`<button class="blnch secondary" onclick="showOnScreen('${xe(g.id)}')">&#128065; Show on Screen</button>
      <button class="blnch" onclick="launch('${xe(g.id)}','${xe(g.name)}')">&#9654; Launch Game</button>`;
  } else {
    lb.innerHTML=`<button class="blnch" onclick="launch('${xe(g.id)}','${xe(g.name)}')">&#9654; Launch Game</button>`;
  }
}

function launch(id,name){wsTx({type:'launch',gameId:id});toast('Launching '+xe(name)+'&#8230;');}
function showOnScreen(id){wsTx({type:'show_game',gameId:id});S.hostGameId=id;markHostGame();toast('Shown on screen');}

function filterByType(t){
  S.gameType=S.gameType===t?null:t;
  updateTypeChips();applyFilter();showBrowse();pushState();
}
function filterByTag(t){
  S.activeTags.add(t);applyFilter();showBrowse();pushState();
}

function updateTypeChips(){
  document.getElementById('chipAll').className='chip'+(!S.gameType?' on':'');
  document.getElementById('chipVS').className='chip'+(S.gameType==='VERSUS'?' on':'');
  document.getElementById('chipCO').className='chip'+(S.gameType==='COOP'?' on':'');
  document.getElementById('chipTM').className='chip'+(S.gameType==='TEAM'?' on':'');
}

/* FILTER MODAL */
function openFilterModal(){
  S.draft={
    sortOrder:S.sortOrder,sortAscending:S.sortAscending,
    filters:JSON.parse(JSON.stringify(S.filters)),
    intFilters:JSON.parse(JSON.stringify(S.intFilters)),
    activeTags:new Set(S.activeTags),
    showAllPacks:S.showAllPacks,showHidden:S.showHidden,
    alwaysCardOverlay:S.alwaysCardOverlay,
  };
  renderFilterModal();
  document.getElementById('fmodal').classList.add('open');
}
function closeFilterModal(){document.getElementById('fmodal').classList.remove('open');}

function renderFilterModal(){
  const d=S.draft;
  const sorts=[{v:'PACK',l:'By Pack'},{v:'NAME',l:'By Name'},{v:'STARS',l:'By Rating'},{v:'PLAYERS',l:'By Players'}];
  document.getElementById('sortOpts').innerHTML=sorts.map(s=>
    `<div class="opt${d.sortOrder===s.v?' on':''}" onclick="dSetSort('${s.v}')">${s.l}</div>`
  ).join('');
  document.getElementById('sortDirTog').className='tog'+(d.sortAscending?'':' on');
  document.getElementById('sortDirLabel').textContent=d.sortAscending?'Ascending':'Descending';
  const pt=d.intFilters.maxPlaytime;
  document.getElementById('ptTog').className='tog'+(pt.activated?' on':'');
  document.getElementById('ptVal').textContent=pt.activated?pt.selected+' min':'Any';
  document.getElementById('ptSlRow').style.display=pt.activated?'':'none';
  document.getElementById('ptSl').value=pt.selected;
  document.getElementById('ptSlVal').textContent=pt.selected+' min';
  document.getElementById('packTog').className='tog'+(d.showAllPacks?' on':'');
  document.getElementById('overlayTog').className='tog'+(d.alwaysCardOverlay?' on':'');
  document.getElementById('hiddenTog').className='tog'+(d.showHidden?' on':'');
  const cfDefs=[
    {k:'FAMILY_FRIENDLY',label:'Family Friendly',opts:[{v:'FAMILY_FRIENDLY_AVAILABLE',l:'Available'}]},
    {k:'AUDIENCE',label:'Audience Mode',opts:[{v:'AUDIENCE_AVAILABLE',l:'Available'}]},
    {k:'SUBTITLES',label:'Subtitles',opts:[{v:'SUBTITLES_AVAILABLE',l:'Available'}]},
    {k:'STREAM_FRIENDLY',label:'Stream Friendly',opts:[
      {v:'STREAM_FRIENDLY_PLAYABLE',l:'Fully Playable'},
      {v:'STREAM_FRIENDLY_MIDLY_PLAYABLE',l:'Mildly Playable'},
      {v:'STREAM_FRIENDLY_BOTH',l:'Either'},
    ]},
    {k:'MODERATION',label:'Moderation',opts:[
      {v:'MODERATION_FULL_MODERATION',l:'Full'},
      {v:'MODERATION_CENSORING',l:'Censoring'},
      {v:'MODERATION_BOTH',l:'Either'},
    ]},
    {k:'TRANSLATION',label:'Translation',opts:[
      {v:'TRANSLATION_DUBBED',l:'Dubbed'},
      {v:'TRANSLATION_TRANSLATED',l:'Translated (any)'},
    ]},
  ];
  document.getElementById('contentFilters').innerHTML=cfDefs.map(cf=>{
    const f=d.filters[cf.k];
    const opts=cf.opts.map(o=>
      `<div class="opt${f.activated&&f.selected===o.v?' on':''}" onclick="dToggleCF('${cf.k}','${o.v}')">${o.l}</div>`
    ).join('');
    return `<div style="margin-bottom:12px"><div class="fmsh">${cf.label}</div><div class="optrow">${opts}</div></div>`;
  }).join('');
  const tg=document.getElementById('tagsGrid');
  if(S.allTags.length){
    tg.innerHTML=S.allTags.map(t=>{
      const ts=tagStr(t);
      return `<div class="tg${d.activeTags.has(ts)?' on':''}" onclick="dToggleTag('${xe(ts)}')">#${xe(ts)}</div>`;
    }).join('');
    document.getElementById('tagsSection').style.display='';
  } else {
    document.getElementById('tagsSection').style.display='none';
  }
}

function dSetSort(v){S.draft.sortOrder=v;renderFilterModal();}
function dToggleSortDir(){S.draft.sortAscending=!S.draft.sortAscending;renderFilterModal();}
function dTogglePT(){const f=S.draft.intFilters.maxPlaytime;f.activated=!f.activated;renderFilterModal();}
function dToggleCF(k,v){const f=S.draft.filters[k];if(f.activated&&f.selected===v)f.activated=false;else{f.activated=true;f.selected=v;}renderFilterModal();}
function dToggleTag(t){if(S.draft.activeTags.has(t))S.draft.activeTags.delete(t);else S.draft.activeTags.add(t);renderFilterModal();}
function dTogglePack(){S.draft.showAllPacks=!S.draft.showAllPacks;renderFilterModal();}
function dToggleOverlay(){S.draft.alwaysCardOverlay=!S.draft.alwaysCardOverlay;renderFilterModal();}
function dToggleHidden(){S.draft.showHidden=!S.draft.showHidden;renderFilterModal();}

function applyModal(){
  const d=S.draft;
  S.sortOrder=d.sortOrder;S.sortAscending=d.sortAscending;
  Object.assign(S.filters,JSON.parse(JSON.stringify(d.filters)));
  Object.assign(S.intFilters,JSON.parse(JSON.stringify(d.intFilters)));
  S.activeTags=new Set(d.activeTags);
  S.showAllPacks=d.showAllPacks;S.showHidden=d.showHidden;
  S.alwaysCardOverlay=d.alwaysCardOverlay;
  closeFilterModal();applyFilter();renderBrowse();pushState();
}

function resetModal(){
  S.draft={
    sortOrder:'PACK',sortAscending:true,
    filters:{
      FAMILY_FRIENDLY:{activated:false,selected:'FAMILY_FRIENDLY_AVAILABLE'},
      AUDIENCE:{activated:false,selected:'AUDIENCE_AVAILABLE'},
      STREAM_FRIENDLY:{activated:false,selected:'STREAM_FRIENDLY_BOTH'},
      MODERATION:{activated:false,selected:'MODERATION_BOTH'},
      SUBTITLES:{activated:false,selected:'SUBTITLES_AVAILABLE'},
      TRANSLATION:{activated:false,selected:'TRANSLATION_TRANSLATED'},
    },
    intFilters:{minPlayers:{activated:false,selected:2},maxPlaytime:{activated:false,selected:60}},
    activeTags:new Set(),showAllPacks:false,showHidden:false,alwaysCardOverlay:false,
  };
  renderFilterModal();
}

/* PLAYER COUNT STEPPER */
function savePlayerMin(){
  try{
    if(S.intFilters.minPlayers.activated)localStorage.setItem('jb_playerMin',String(S.intFilters.minPlayers.selected));
    else localStorage.removeItem('jb_playerMin');
  }catch(_){}
}

function playerStepBy(d){
  const f=S.intFilters.minPlayers;
  if(!f.activated&&d>0){f.activated=true;f.selected=2;}
  else if(f.activated){
    f.selected=Math.max(2,Math.min(10,f.selected+d));
    if(d<0&&f.selected<=1)f.activated=false;
  }
  savePlayerMin();applyFilter();renderBrowse();pushState();
}
function clearPlayerMin(){
  S.intFilters.minPlayers.activated=false;S.intFilters.minPlayers.selected=2;
  savePlayerMin();applyFilter();renderBrowse();pushState();
}

/* SYNC MODE */
function setSyncMode(m){
  S.syncMode=m;
  document.getElementById('tabFull').className='stab'+(m==='full'?' on full':'');
  document.getElementById('tabPaused').className='stab'+(m==='paused'?' on paused':'');
  wsTx({type:'sync_mode',mode:m});
  if(isView('vd')&&S.filtered[S.idx])renderLaunchBar(S.filtered[S.idx].game);
}

/* QUICK CLEAR */
function clearSearch(){S.search='';document.getElementById('searchBox').value='';updClr();applyFilter();renderBrowse();pushState();}
function clearType(){S.gameType=null;updateTypeChips();applyFilter();renderBrowse();pushState();}
function removeTag(t){S.activeTags.delete(t);applyFilter();renderBrowse();pushState();}
function clearFilter(k){S.filters[k].activated=false;applyFilter();renderBrowse();pushState();}
function clearInt(k){S.intFilters[k].activated=false;if(k==='minPlayers')savePlayerMin();applyFilter();renderBrowse();pushState();}
function updClr(){document.getElementById('searchClr').classList.toggle('vis',S.search.length>0);}

/* SORT CHIP */
function quickSort(){
  const o=['PACK','NAME','STARS','PLAYERS'];
  S.sortOrder=o[(o.indexOf(S.sortOrder)+1)%o.length];
  const l={PACK:'Pack',NAME:'Name',STARS:'Rating',PLAYERS:'Players'};
  document.getElementById('chipSort').textContent='Sort: '+l[S.sortOrder];
  applyFilter();renderBrowse();pushState();
}

/* TYPE CHIPS */
function setTypeChip(t){
  S.gameType=S.gameType===t?null:t;
  updateTypeChips();applyFilter();renderBrowse();pushState();
}

/* GROUP TOGGLE */
function toggleGroup(){
  S.groupByPack=!S.groupByPack;
  document.getElementById('chipGrp').className='chip'+(S.groupByPack?' on':'');
  document.getElementById('chipGrp').innerHTML=(S.groupByPack?'\u2637 By Pack':'\u2630 Flat');
  renderBrowse();
}

/* RANDOM ANIMATION */
let _randCycle=null, _randTimer=null;

function startRandom(){
  if(S.role!=='admin')return;
  const ov=document.getElementById('randOv');
  document.getElementById('randDice').classList.add('spin');
  document.getElementById('randHint').style.display='';
  document.getElementById('randWinner').style.display='none';
  document.getElementById('randName').textContent='Picking\u2026';
  ov.classList.add('show');
  const names=S.filtered.length?S.filtered.map(e=>e.game.name):S.flat.map(e=>e.game.name);
  let i=0;
  const nm=document.getElementById('randName');
  clearInterval(_randCycle);
  _randCycle=setInterval(()=>{if(names.length){i=(i+1)%names.length;nm.textContent=names[i];}},100);
  clearTimeout(_randTimer);
  _randTimer=setTimeout(()=>hideRandOverlay(),8000);
  wsTx({type:'random_game'});
}

function hideRandOverlay(){
  clearInterval(_randCycle);_randCycle=null;
  clearTimeout(_randTimer);_randTimer=null;
  document.getElementById('randOv').classList.remove('show');
}

function showRandResult(idx, source, gameId){
  clearInterval(_randCycle);_randCycle=null;
  clearTimeout(_randTimer);_randTimer=null;
  const arr=source==='flat'?S.flat:S.filtered;
  const gameName=arr[idx]?arr[idx].game.name:'';
  const nm=document.getElementById('randName');
  nm.textContent=gameName;
  document.getElementById('randDice').classList.remove('spin');
  document.getElementById('randDice').textContent='\uD83C\uDF89'; // party popper
  document.getElementById('randHint').style.display='none';
  const rw=document.getElementById('randWinner');
  rw.style.display='';rw.textContent=gameName;
  setTimeout(()=>{
    hideRandOverlay();
    document.getElementById('randDice').textContent='\uD83C\uDFB2';
    document.getElementById('randDice').classList.add('spin');
    if(source==='filtered'&&idx>=0)openDetail(idx);
    else{
      const fi=S.filtered.findIndex(x=>x.game.id===gameId);
      if(fi>=0)openDetail(fi);
    }
  },1400);
}

/* HELPERS */
function plTxt(p){return p?(p.min===p.max?String(p.min):p.min+'-'+p.max):'?';}
function ptTxt(p){return p?(p.min===p.max?String(p.min):p.min+'-'+p.max):'?';}
function tName(t){return{VERSUS:'Versus',COOP:'Co-op',TEAM:'Team'}[t]||t;}
function tShort(t){return{VERSUS:'VS',COOP:'CO',TEAM:'TM'}[t]||t;}
function fmtBool(v){if(v===true)return{txt:'Yes',cls:'yes'};if(v===false)return{txt:'No',cls:'no'};return{txt:'N/A',cls:'no'};}
function enumToLabel(s){return s?s.split('_').map(w=>w?w[0].toUpperCase()+w.slice(1).toLowerCase():'').join(' ').trim():'';}
function fmtFF(v){
  if(!v||v==='NONE')return{txt:'N/A',cls:'no'};
  if(v==='FAMILY_FRIENDLY')return{txt:'Yes',cls:'yes'};
  if(v==='OPTIONAL')return{txt:'Optional',cls:'opt'};
  if(v.includes('NOT')||v.endsWith('_NO'))return{txt:'No',cls:'no'};
  return{txt:enumToLabel(v),cls:'part'};
}
function fmtSF(v){
  if(!v)return{txt:'N/A',cls:'no'};
  if(v==='PLAYABLE')return{txt:'Playable',cls:'yes'};
  if(v==='MIDLY_PLAYABLE')return{txt:'Mild',cls:'opt'};
  if(v.includes('NOT'))return{txt:'No',cls:'no'};
  return{txt:enumToLabel(v),cls:'part'};
}
function fmtMod(v){
  if(!v)return{txt:'N/A',cls:'no'};
  if(v==='FULL_MODERATION')return{txt:'Full',cls:'yes'};
  if(v==='CENSORING')return{txt:'Censoring',cls:'opt'};
  if(v.includes('NOT')||v==='NONE')return{txt:'None',cls:'no'};
  return{txt:enumToLabel(v),cls:'part'};
}
function fmtTr(v){
  if(!v)return{txt:'None',cls:'no'};
  if(v==='NATIVELY_TRANSLATED')return{txt:'Native',cls:'yes'};
  if(v==='COMMUNITY_DUBBED')return{txt:'Dubbed',cls:'opt'};
  if(v==='COMMUNITY_TRANSLATED')return{txt:'Community',cls:'opt'};
  if(v.includes('NOT'))return{txt:'None',cls:'no'};
  return{txt:enumToLabel(v),cls:'part'};
}
function xe(s){if(!s)return'';return String(s).replace(/&/g,'&amp;').replace(/"/g,'&quot;').replace(/</g,'&lt;').replace(/>/g,'&gt;');}
let _tt;
function toast(msg,dur=2500){
  const el=document.getElementById('toast');
  el.innerHTML=msg;el.classList.add('show');
  clearTimeout(_tt);_tt=setTimeout(()=>el.classList.remove('show'),dur);
}

/* SWIPE */
let _tx=0,_ty=0;
document.getElementById('vd').addEventListener('touchstart',e=>{_tx=e.touches[0].clientX;_ty=e.touches[0].clientY;},{passive:true});
document.getElementById('vd').addEventListener('touchend',e=>{
  const dx=e.changedTouches[0].clientX-_tx,dy=e.changedTouches[0].clientY-_ty;
  if(Math.abs(dx)>55&&Math.abs(dx)>Math.abs(dy)*1.4)navGame(dx<0?1:-1);
},{passive:true});

/* KEYBOARD */
document.addEventListener('keydown',e=>{
  if(document.getElementById('fmodal').classList.contains('open')){if(e.key==='Escape')closeFilterModal();return;}
  if(!isView('vd'))return;
  if(e.key==='ArrowLeft')navGame(-1);
  if(e.key==='ArrowRight')navGame(1);
  if(e.key==='Escape')showBrowse();
});

/* WIRE */
document.getElementById('btnAdmin').onclick=requestAdminRole;
document.getElementById('btnGuest').onclick=()=>setRole('guest');
document.getElementById('roleBadge').onclick=()=>showView('vw');
// Prevent logo link from navigating (it's decorative on phone, clickable on desktop)
document.getElementById('logoLink').addEventListener('click',e=>{
  if(window.innerWidth<600)e.preventDefault();
});
let _sd;
document.getElementById('searchBox').addEventListener('input',e=>{
  S.search=e.target.value;updClr();
  clearTimeout(_sd);_sd=setTimeout(()=>{applyFilter();renderBrowse();pushState();},250);
});
document.getElementById('searchClr').onclick=clearSearch;
document.getElementById('chipAll').onclick=()=>setTypeChip(null);
document.getElementById('chipVS').onclick=()=>setTypeChip('VERSUS');
document.getElementById('chipCO').onclick=()=>setTypeChip('COOP');
document.getElementById('chipTM').onclick=()=>setTypeChip('TEAM');
document.getElementById('chipFilter').onclick=openFilterModal;
document.getElementById('chipSort').onclick=quickSort;
document.getElementById('chipGrp').onclick=toggleGroup;
document.getElementById('chipRand').onclick=startRandom;
document.getElementById('btnBack').onclick=showBrowse;
document.getElementById('navPrev').onclick=()=>navGame(-1);
document.getElementById('navNext').onclick=()=>navGame(1);
document.getElementById('tabFull').onclick=()=>setSyncMode('full');
document.getElementById('tabPaused').onclick=()=>setSyncMode('paused');
document.getElementById('muteBtn').onclick=()=>{
  S.sfxMuted=!S.sfxMuted;
  document.getElementById('muteBtn').innerHTML=S.sfxMuted?'&#128263;':'&#128266;';
  document.getElementById('muteBtn').classList.toggle('muted',S.sfxMuted);
  wsTx({type:'mute_sfx',muted:S.sfxMuted});
  toast(S.sfxMuted?'SFX muted':'SFX on');
};
document.getElementById('fmodalOv').onclick=closeFilterModal;
document.getElementById('fmApply').onclick=applyModal;
document.getElementById('fmReset').onclick=resetModal;
document.getElementById('sortDirRow').onclick=dToggleSortDir;
document.getElementById('ptTogRow').onclick=dTogglePT;
document.getElementById('packTogRow').onclick=dTogglePack;
document.getElementById('overlayTogRow').onclick=dToggleOverlay;
document.getElementById('hiddenTogRow').onclick=dToggleHidden;
document.getElementById('ptSl').addEventListener('input',e=>{
  S.draft.intFilters.maxPlaytime.selected=+e.target.value;
  document.getElementById('ptSlVal').textContent=e.target.value+' min';
  document.getElementById('ptVal').textContent=e.target.value+' min';
});
document.getElementById('pDec').onclick=()=>playerStepBy(-1);
document.getElementById('pInc').onclick=()=>playerStepBy(1);
document.getElementById('pClr').onclick=clearPlayerMin;
document.getElementById('randOv').onclick=hideRandOverlay;
document.getElementById('alGrid').onclick=e=>{
  const cell=e.target.closest('.al-cell');
  if(!cell)return;
  adminCellTap(parseInt(cell.dataset.idx,10));
};
document.getElementById('alClear').onclick=()=>{S.adminAttempt=[];renderAdminLock();};
document.getElementById('alCancel').onclick=closeAdminLock;
document.getElementById('alSubmit').onclick=submitAdminLock;

/* BOOT */
wsConnect();
loadGames();
</script>
</body>
</html>
""";
