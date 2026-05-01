(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,588675,(t,e,r)=>{"use strict";e.exports=function(t){for(var e=5381,r=t.length;r;)e=33*e^t.charCodeAt(--r);return e>>>0}},836608,(t,e,r)=>{e.exports=(t,e,r)=>[[t,e,r],[(t+120)%360,e,r],[(t+240)%360,e,r]]},977236,(t,e,r)=>{let o=(t,e,r)=>(r<0&&(r+=1),r>1&&(r-=1),r<1/6)?t+(e-t)*6*r:r<.5?e:r<2/3?t+(e-t)*(2/3-r)*6:t;e.exports=(t,e,r)=>{let i,l,n;if(t/=360,0==e)i=l=n=r;else{let s=r<.5?r*(1+e):r+e-r*e,a=2*r-s;i=o(a,s,t+1/3),l=o(a,s,t),n=o(a,s,t-1/3)}return[Math.max(0,Math.min(Math.round(255*i),255)),Math.max(0,Math.min(Math.round(255*l),255)),Math.max(0,Math.min(Math.round(255*n),255))]}},72058,(t,e,r)=>{let o=t.r(588675),i=t.r(836608),l=t.r(977236);e.exports=(t,e,r)=>{let n=i(o(t)%360,1,.5),s=l(n[0][0],n[0][1],n[0][2]),a=l(n[1][0],n[1][1],n[1][2]),h=`rgb(${s[0]}, ${s[1]}, ${s[2]})`,d=`rgb(${a[0]}, ${a[1]}, ${a[2]})`,c=Math.floor(Math.random()*Date.now()),x="circle"===r?`<circle id="Circle" fill="url(#${c})" cx="40" cy="40" r="40" />`:`<rect id="Rectangle" fill="url(#${c})" x="0" y="0" width="80" height="80"></rect>`;return`<?xml version="1.0" encoding="UTF-8"?>
<svg ${void 0!=e?`width="${e}px" height="${e}px"`:""} viewBox="0 0 80 80" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
  <defs>
    <linearGradient x1="0%" y1="0%" x2="100%" y2="100%" id="${c}">
      <stop stop-color="${h}" offset="0%"></stop>
      <stop stop-color="${d}" offset="100%"></stop>
    </linearGradient>
  </defs>
  <g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
    ${x}
  </g>
</svg>`}},265042,t=>{t.n(t.i(72058))}]);