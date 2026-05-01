(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,846880,e=>{"use strict";e.i(588984);var t=e.i(399702),r=e.i(872857);e.i(759703);var i=e.i(392074),o=e.i(938559),s=e.i(118827);let a=s.css`
  :host {
    display: block;
    box-shadow: inset 0 0 0 1px var(--wui-color-gray-glass-005);
    background: linear-gradient(
      120deg,
      var(--wui-color-bg-200) 5%,
      var(--wui-color-bg-200) 48%,
      var(--wui-color-bg-300) 55%,
      var(--wui-color-bg-300) 60%,
      var(--wui-color-bg-300) calc(60% + 10px),
      var(--wui-color-bg-200) calc(60% + 12px),
      var(--wui-color-bg-200) 100%
    );
    background-size: 250%;
    animation: shimmer 3s linear infinite reverse;
  }

  :host([variant='light']) {
    background: linear-gradient(
      120deg,
      var(--wui-color-bg-150) 5%,
      var(--wui-color-bg-150) 48%,
      var(--wui-color-bg-200) 55%,
      var(--wui-color-bg-200) 60%,
      var(--wui-color-bg-200) calc(60% + 10px),
      var(--wui-color-bg-150) calc(60% + 12px),
      var(--wui-color-bg-150) 100%
    );
    background-size: 250%;
  }

  @keyframes shimmer {
    from {
      background-position: -250% 0;
    }
    to {
      background-position: 250% 0;
    }
  }
`;var l=function(e,t,r,i){var o,s=arguments.length,a=s<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,r,i);else for(var l=e.length-1;l>=0;l--)(o=e[l])&&(a=(s<3?o(a):s>3?o(t,r,a):o(t,r))||a);return s>3&&a&&Object.defineProperty(t,r,a),a};let n=class extends t.LitElement{constructor(){super(...arguments),this.width="",this.height="",this.borderRadius="m",this.variant="default"}render(){return this.style.cssText=`
      width: ${this.width};
      height: ${this.height};
      border-radius: clamp(0px,var(--wui-border-radius-${this.borderRadius}), 40px);
    `,r.html`<slot></slot>`}};n.styles=[a],l([(0,i.property)()],n.prototype,"width",void 0),l([(0,i.property)()],n.prototype,"height",void 0),l([(0,i.property)()],n.prototype,"borderRadius",void 0),l([(0,i.property)()],n.prototype,"variant",void 0),n=l([(0,o.customElement)("wui-shimmer")],n),e.s([],846880)},211366,e=>{"use strict";e.i(846880),e.s([])},229581,675164,231971,e=>{"use strict";var t=e.i(138230),r=e.i(596590),i=e.i(207176),o=e.i(729702),s=e.i(881936),a=e.i(375054),l=e.i(944396),n=e.i(301847),c=e.i(148018);async function u(){a.RouterController.push("ConnectingFarcaster");let e=o.ConnectorController.getAuthConnector();if(e&&!r.AccountController.state.farcasterUrl)try{let{url:t}=await e.provider.getFarcasterUri();r.AccountController.setFarcasterUrl(t,i.ChainController.state.activeChain)}catch(e){a.RouterController.goBack(),l.SnackController.showError(e)}}async function h(e){a.RouterController.push("ConnectingSocial");let s=o.ConnectorController.getAuthConnector(),u=null;try{let o=setTimeout(()=>{throw Error("Social login timed out. Please try again.")},45e3);if(s&&e){if(n.CoreHelperUtil.isTelegram()||(u=function(){try{return n.CoreHelperUtil.returnOpenHref(`${t.ConstantsUtil.SECURE_SITE_SDK_ORIGIN}/loading`,"popupWindow","width=600,height=800,scrollbars=yes")}catch(e){throw Error("Could not open social popup")}}()),u)r.AccountController.setSocialWindow(u,i.ChainController.state.activeChain);else if(!n.CoreHelperUtil.isTelegram())throw Error("Could not create social popup");let{uri:a}=await s.provider.getSocialRedirectUri({provider:e});if(!a)throw u?.close(),Error("Could not fetch the social redirect uri");if(u&&(u.location.href=a),n.CoreHelperUtil.isTelegram()){c.StorageUtil.setTelegramSocialProvider(e);let t=n.CoreHelperUtil.formatTelegramSocialLoginUrl(a);n.CoreHelperUtil.openHref(t,"_top")}clearTimeout(o)}}catch(e){u?.close(),l.SnackController.showError(e?.message)}}async function d(e){r.AccountController.setSocialProvider(e,i.ChainController.state.activeChain),s.EventsController.sendEvent({type:"track",event:"SOCIAL_LOGIN_STARTED",properties:{provider:e}}),"farcaster"===e?await u():await h(e)}e.s(["executeSocialLogin",()=>d],229581),e.i(588984);var p=e.i(399702),m=e.i(872857);e.i(759703);var f=e.i(392074);e.i(781840);var v=e.i(86988);e.i(596548);var g=e.i(864429),b=e.i(938559),w=p;e.i(630572);var y=e.i(118827);let C=y.css`
  :host {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 40px;
    height: 40px;
    border-radius: var(--wui-border-radius-3xl);
    border: 1px solid var(--wui-color-gray-glass-005);
    overflow: hidden;
  }

  wui-icon {
    width: 100%;
    height: 100%;
  }
`;var x=function(e,t,r,i){var o,s=arguments.length,a=s<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,r,i);else for(var l=e.length-1;l>=0;l--)(o=e[l])&&(a=(s<3?o(a):s>3?o(t,r,a):o(t,r))||a);return s>3&&a&&Object.defineProperty(t,r,a),a};let k=class extends w.LitElement{constructor(){super(...arguments),this.logo="google"}render(){return m.html`<wui-icon color="inherit" size="inherit" name=${this.logo}></wui-icon> `}};k.styles=[g.resetStyles,C],x([(0,f.property)()],k.prototype,"logo",void 0),k=x([(0,b.customElement)("wui-logo")],k),e.s([],675164);let P=y.css`
  button {
    column-gap: var(--wui-spacing-s);
    padding: 7px var(--wui-spacing-l) 7px var(--wui-spacing-xs);
    width: 100%;
    justify-content: flex-start;
    background-color: var(--wui-color-gray-glass-002);
    border-radius: var(--wui-border-radius-xs);
    color: var(--wui-color-fg-100);
  }

  wui-text {
    text-transform: capitalize;
  }

  wui-text[data-align='left'] {
    display: flex;
    flex: 1;
  }

  wui-text[data-align='center'] {
    display: flex;
    flex: 1;
    justify-content: center;
  }

  .invisible {
    opacity: 0;
    pointer-events: none;
  }

  button:disabled {
    background-color: var(--wui-color-gray-glass-015);
    color: var(--wui-color-gray-glass-015);
  }
`;var j=function(e,t,r,i){var o,s=arguments.length,a=s<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,r,i);else for(var l=e.length-1;l>=0;l--)(o=e[l])&&(a=(s<3?o(a):s>3?o(t,r,a):o(t,r))||a);return s>3&&a&&Object.defineProperty(t,r,a),a};let E=class extends p.LitElement{constructor(){super(...arguments),this.logo="google",this.name="Continue with google",this.align="left",this.disabled=!1}render(){return m.html`
      <button ?disabled=${this.disabled} tabindex=${(0,v.ifDefined)(this.tabIdx)}>
        <wui-logo logo=${this.logo}></wui-logo>
        <wui-text
          data-align=${this.align}
          variant="paragraph-500"
          color="inherit"
          align=${this.align}
          >${this.name}</wui-text
        >
        ${this.templatePlacement()}
      </button>
    `}templatePlacement(){return"center"===this.align?m.html` <wui-logo class="invisible" logo=${this.logo}></wui-logo>`:null}};E.styles=[g.resetStyles,g.elementStyles,P],j([(0,f.property)()],E.prototype,"logo",void 0),j([(0,f.property)()],E.prototype,"name",void 0),j([(0,f.property)()],E.prototype,"align",void 0),j([(0,f.property)()],E.prototype,"tabIdx",void 0),j([(0,f.property)({type:Boolean})],E.prototype,"disabled",void 0),E=j([(0,b.customElement)("wui-list-social")],E),e.s([],231971)},906328,(e,t,r)=>{"use strict";var i={single_source_shortest_paths:function(e,t,r){var o,s,a,l,n,c,u,h={},d={};d[t]=0;var p=i.PriorityQueue.make();for(p.push(t,0);!p.empty();)for(a in s=(o=p.pop()).value,l=o.cost,n=e[s]||{})n.hasOwnProperty(a)&&(c=l+n[a],u=d[a],(void 0===d[a]||u>c)&&(d[a]=c,p.push(a,c),h[a]=s));if(void 0!==r&&void 0===d[r])throw Error("Could not find a path from "+t+" to "+r+".");return h},extract_shortest_path_from_predecessor_list:function(e,t){for(var r=[],i=t;i;)r.push(i),e[i],i=e[i];return r.reverse(),r},find_path:function(e,t,r){var o=i.single_source_shortest_paths(e,t,r);return i.extract_shortest_path_from_predecessor_list(o,r)},PriorityQueue:{make:function(e){var t,r=i.PriorityQueue,o={};for(t in e=e||{},r)r.hasOwnProperty(t)&&(o[t]=r[t]);return o.queue=[],o.sorter=e.sorter||r.default_sorter,o},default_sorter:function(e,t){return e.cost-t.cost},push:function(e,t){this.queue.push({value:e,cost:t}),this.queue.sort(this.sorter)},pop:function(){return this.queue.shift()},empty:function(){return 0===this.queue.length}}};t.exports=i},567815,(e,t,r)=>{"use strict";t.exports=function(e){for(var t=[],r=e.length,i=0;i<r;i++){var o=e.charCodeAt(i);if(o>=55296&&o<=56319&&r>i+1){var s=e.charCodeAt(i+1);s>=56320&&s<=57343&&(o=(o-55296)*1024+s-56320+65536,i+=1)}if(o<128){t.push(o);continue}if(o<2048){t.push(o>>6|192),t.push(63&o|128);continue}if(o<55296||o>=57344&&o<65536){t.push(o>>12|224),t.push(o>>6&63|128),t.push(63&o|128);continue}if(o>=65536&&o<=1114111){t.push(o>>18|240),t.push(o>>12&63|128),t.push(o>>6&63|128),t.push(63&o|128);continue}t.push(239,191,189)}return new Uint8Array(t).buffer}},143880,e=>{"use strict";e.i(588984);var t=e.i(399702),r=e.i(872857);e.i(759703);var i=e.i(392074);e.i(630572),e.i(287940);var o=e.i(520209);function s(e,t,r){return e!==t&&(e-t<0?t-e:e-t)<=r+.1}let a={generate({uri:e,size:t,logoSize:i,dotColor:a="#141414"}){let l,n,c=[],u=(n=Math.sqrt((l=Array.prototype.slice.call(o.default.create(e,{errorCorrectionLevel:"Q"}).modules.data,0)).length),l.reduce((e,t,r)=>(r%n==0?e.push([t]):e[e.length-1].push(t))&&e,[])),h=t/u.length,d=[{x:0,y:0},{x:1,y:0},{x:0,y:1}];d.forEach(({x:e,y:t})=>{let i=(u.length-7)*h*e,o=(u.length-7)*h*t;for(let e=0;e<d.length;e+=1){let t=h*(7-2*e);c.push(r.svg`
            <rect
              fill=${2===e?a:"transparent"}
              width=${0===e?t-5:t}
              rx= ${0===e?(t-5)*.45:.45*t}
              ry= ${0===e?(t-5)*.45:.45*t}
              stroke=${a}
              stroke-width=${5*(0===e)}
              height=${0===e?t-5:t}
              x= ${0===e?o+h*e+2.5:o+h*e}
              y= ${0===e?i+h*e+2.5:i+h*e}
            />
          `)}});let p=Math.floor((i+25)/h),m=u.length/2-p/2,f=u.length/2+p/2-1,v=[];u.forEach((e,t)=>{e.forEach((e,r)=>{!u[t][r]||t<7&&r<7||t>u.length-8&&r<7||t<7&&r>u.length-8||t>m&&t<f&&r>m&&r<f||v.push([t*h+h/2,r*h+h/2])})});let g={};return v.forEach(([e,t])=>{g[e]?g[e]?.push(t):g[e]=[t]}),Object.entries(g).map(([e,t])=>{let r=t.filter(e=>t.every(t=>!s(e,t,h)));return[Number(e),r]}).forEach(([e,t])=>{t.forEach(t=>{c.push(r.svg`<circle cx=${e} cy=${t} fill=${a} r=${h/2.5} />`)})}),Object.entries(g).filter(([e,t])=>t.length>1).map(([e,t])=>{let r=t.filter(e=>t.some(t=>s(e,t,h)));return[Number(e),r]}).map(([e,t])=>{t.sort((e,t)=>e<t?-1:1);let r=[];for(let e of t){let t=r.find(t=>t.some(t=>s(e,t,h)));t?t.push(e):r.push([e])}return[e,r.map(e=>[e[0],e[e.length-1]])]}).forEach(([e,t])=>{t.forEach(([t,i])=>{c.push(r.svg`
              <line
                x1=${e}
                x2=${e}
                y1=${t}
                y2=${i}
                stroke=${a}
                stroke-width=${h/1.25}
                stroke-linecap="round"
              />
            `)})}),c}};var l=e.i(864429),n=e.i(938559),c=e.i(118827);let u=c.css`
  :host {
    position: relative;
    user-select: none;
    display: block;
    overflow: hidden;
    aspect-ratio: 1 / 1;
    width: var(--local-size);
  }

  :host([data-theme='dark']) {
    border-radius: clamp(0px, var(--wui-border-radius-l), 40px);
    background-color: var(--wui-color-inverse-100);
    padding: var(--wui-spacing-l);
  }

  :host([data-theme='light']) {
    box-shadow: 0 0 0 1px var(--wui-color-bg-125);
    background-color: var(--wui-color-bg-125);
  }

  :host([data-clear='true']) > wui-icon {
    display: none;
  }

  svg:first-child,
  wui-image,
  wui-icon {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translateY(-50%) translateX(-50%);
  }

  wui-image {
    width: 25%;
    height: 25%;
    border-radius: var(--wui-border-radius-xs);
  }

  wui-icon {
    width: 100%;
    height: 100%;
    color: var(--local-icon-color) !important;
    transform: translateY(-50%) translateX(-50%) scale(0.25);
  }
`;var h=function(e,t,r,i){var o,s=arguments.length,a=s<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,r,i);else for(var l=e.length-1;l>=0;l--)(o=e[l])&&(a=(s<3?o(a):s>3?o(t,r,a):o(t,r))||a);return s>3&&a&&Object.defineProperty(t,r,a),a};let d=class extends t.LitElement{constructor(){super(...arguments),this.uri="",this.size=0,this.theme="dark",this.imageSrc=void 0,this.alt=void 0,this.arenaClear=void 0,this.farcaster=void 0}render(){return this.dataset.theme=this.theme,this.dataset.clear=String(this.arenaClear),this.style.cssText=`
     --local-size: ${this.size}px;
     --local-icon-color: ${this.color??"#3396ff"}
    `,r.html`${this.templateVisual()} ${this.templateSvg()}`}templateSvg(){let e="light"===this.theme?this.size:this.size-32;return r.svg`
      <svg height=${e} width=${e}>
        ${a.generate({uri:this.uri,size:e,logoSize:this.arenaClear?0:e/4,dotColor:this.color})}
      </svg>
    `}templateVisual(){return this.imageSrc?r.html`<wui-image src=${this.imageSrc} alt=${this.alt??"logo"}></wui-image>`:this.farcaster?r.html`<wui-icon
        class="farcaster"
        size="inherit"
        color="inherit"
        name="farcaster"
      ></wui-icon>`:r.html`<wui-icon size="inherit" color="inherit" name="walletConnect"></wui-icon>`}};d.styles=[l.resetStyles,u],h([(0,i.property)()],d.prototype,"uri",void 0),h([(0,i.property)({type:Number})],d.prototype,"size",void 0),h([(0,i.property)()],d.prototype,"theme",void 0),h([(0,i.property)()],d.prototype,"imageSrc",void 0),h([(0,i.property)()],d.prototype,"alt",void 0),h([(0,i.property)()],d.prototype,"color",void 0),h([(0,i.property)({type:Boolean})],d.prototype,"arenaClear",void 0),h([(0,i.property)({type:Boolean})],d.prototype,"farcaster",void 0),d=h([(0,n.customElement)("wui-qr-code")],d),e.s([],143880)},155284,e=>{"use strict";e.s(["REOWN_URL",0,"https://reown.com","numbersRegex",0,/[0-9,.]/u,"specialCharactersRegex",0,/[.*+?^${}()|[\]\\]/gu])},353612,e=>{"use strict";e.i(588984);var t=e.i(399702),r=e.i(872857);e.i(759703);var i=e.i(392074),o=e.i(864429),s=e.i(938559),a=e.i(118827);let l=a.css`
  :host {
    display: block;
    width: var(--wui-box-size-md);
    height: var(--wui-box-size-md);
  }

  svg {
    width: var(--wui-box-size-md);
    height: var(--wui-box-size-md);
  }

  rect {
    fill: none;
    stroke: var(--wui-color-accent-100);
    stroke-width: 4px;
    stroke-linecap: round;
    animation: dash 1s linear infinite;
  }

  @keyframes dash {
    to {
      stroke-dashoffset: 0px;
    }
  }
`;var n=function(e,t,r,i){var o,s=arguments.length,a=s<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,r,i);else for(var l=e.length-1;l>=0;l--)(o=e[l])&&(a=(s<3?o(a):s>3?o(t,r,a):o(t,r))||a);return s>3&&a&&Object.defineProperty(t,r,a),a};let c=class extends t.LitElement{constructor(){super(...arguments),this.radius=36}render(){return this.svgLoaderTemplate()}svgLoaderTemplate(){let e=this.radius>50?50:this.radius,t=36-e;return r.html`
      <svg viewBox="0 0 110 110" width="110" height="110">
        <rect
          x="2"
          y="2"
          width="106"
          height="106"
          rx=${e}
          stroke-dasharray="${116+t} ${245+t}"
          stroke-dashoffset=${360+1.75*t}
        />
      </svg>
    `}};c.styles=[o.resetStyles,l],n([(0,i.property)({type:Number})],c.prototype,"radius",void 0),c=n([(0,s.customElement)("wui-loading-thumbnail")],c),e.s([],353612)},843028,451801,933370,176375,e=>{"use strict";var t=e.i(725519),r=e.i(941031);let i=(0,t.proxy)({isLegalCheckboxChecked:!1}),o={state:i,subscribe:e=>(0,t.subscribe)(i,()=>e(i)),subscribeKey:(e,t)=>(0,r.subscribeKey)(i,e,t),setIsLegalCheckboxChecked(e){i.isLegalCheckboxChecked=e}};e.s(["OptionsStateController",0,o],843028),e.i(588984);var s=e.i(399702),a=e.i(872857);e.i(759703);var l=e.i(698797),n=e.i(944411);e.i(302184);var c=e.i(938559),u=s,h=e.i(392074);e.i(781840);var d=e.i(86988);e.i(812492);var p=e.i(568633);e.i(630572);var m=e.i(864429),f=e.i(118827);let v=f.css`
  label {
    display: flex;
    align-items: center;
    cursor: pointer;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    column-gap: var(--wui-spacing-1xs);
  }

  label > input[type='checkbox'] {
    height: 0;
    width: 0;
    opacity: 0;
    pointer-events: none;
    position: absolute;
  }

  label > span {
    width: var(--wui-spacing-xl);
    height: var(--wui-spacing-xl);
    min-width: var(--wui-spacing-xl);
    min-height: var(--wui-spacing-xl);
    border-radius: var(--wui-border-radius-3xs);
    border-width: 1px;
    border-style: solid;
    border-color: var(--wui-color-gray-glass-010);
    display: flex;
    align-items: center;
    justify-content: center;
    transition: background-color var(--wui-ease-out-power-1) var(--wui-duration-lg);
    will-change: background-color;
  }

  label > span:hover,
  label > input[type='checkbox']:focus-visible + span {
    background-color: var(--wui-color-gray-glass-010);
  }

  label input[type='checkbox']:checked + span {
    background-color: var(--wui-color-blue-base-90);
  }

  label > span > wui-icon {
    opacity: 0;
    transition: opacity var(--wui-ease-out-power-1) var(--wui-duration-lg);
    will-change: opacity;
  }

  label > input[type='checkbox']:checked + span wui-icon {
    opacity: 1;
  }
`;var g=function(e,t,r,i){var o,s=arguments.length,a=s<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,r,i);else for(var l=e.length-1;l>=0;l--)(o=e[l])&&(a=(s<3?o(a):s>3?o(t,r,a):o(t,r))||a);return s>3&&a&&Object.defineProperty(t,r,a),a};let b=class extends u.LitElement{constructor(){super(...arguments),this.inputElementRef=(0,p.createRef)(),this.checked=void 0}render(){return a.html`
      <label>
        <input
          ${(0,p.ref)(this.inputElementRef)}
          ?checked=${(0,d.ifDefined)(this.checked)}
          type="checkbox"
          @change=${this.dispatchChangeEvent}
        />
        <span>
          <wui-icon name="checkmarkBold" color="inverse-100" size="xxs"></wui-icon>
        </span>
        <slot></slot>
      </label>
    `}dispatchChangeEvent(){this.dispatchEvent(new CustomEvent("checkboxChange",{detail:this.inputElementRef.value?.checked,bubbles:!0,composed:!0}))}};b.styles=[m.resetStyles,v],g([(0,h.property)({type:Boolean})],b.prototype,"checked",void 0),b=g([(0,c.customElement)("wui-checkbox")],b),e.i(331658);let w=f.css`
  :host {
    display: flex;
    align-items: center;
    justify-content: center;
  }
  wui-checkbox {
    padding: var(--wui-spacing-s);
  }
  a {
    text-decoration: none;
    color: var(--wui-color-fg-150);
    font-weight: 500;
  }
`;var y=function(e,t,r,i){var o,s=arguments.length,a=s<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,r,i);else for(var l=e.length-1;l>=0;l--)(o=e[l])&&(a=(s<3?o(a):s>3?o(t,r,a):o(t,r))||a);return s>3&&a&&Object.defineProperty(t,r,a),a};let C=class extends s.LitElement{constructor(){super(),this.unsubscribe=[],this.checked=o.state.isLegalCheckboxChecked,this.unsubscribe.push(o.subscribeKey("isLegalCheckboxChecked",e=>{this.checked=e}))}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}render(){let{termsConditionsUrl:e,privacyPolicyUrl:t}=n.OptionsController.state,r=n.OptionsController.state.features?.legalCheckbox;return(e||t)&&r?a.html`
      <wui-checkbox
        ?checked=${this.checked}
        @checkboxChange=${this.onCheckboxChange.bind(this)}
        data-testid="wui-checkbox"
      >
        <wui-text color="fg-250" variant="small-400" align="left">
          I agree to our ${this.termsTemplate()} ${this.andTemplate()} ${this.privacyTemplate()}
        </wui-text>
      </wui-checkbox>
    `:null}andTemplate(){let{termsConditionsUrl:e,privacyPolicyUrl:t}=n.OptionsController.state;return e&&t?"and":""}termsTemplate(){let{termsConditionsUrl:e}=n.OptionsController.state;return e?a.html`<a rel="noreferrer" target="_blank" href=${e}>terms of service</a>`:null}privacyTemplate(){let{privacyPolicyUrl:e}=n.OptionsController.state;return e?a.html`<a rel="noreferrer" target="_blank" href=${e}>privacy policy</a>`:null}onCheckboxChange(){o.setIsLegalCheckboxChecked(!this.checked)}};C.styles=[w],y([(0,l.state)()],C.prototype,"checked",void 0),C=y([(0,c.customElement)("w3m-legal-checkbox")],C),e.s([],451801);var x=s;e.i(237029);var k=s;e.i(596548),e.i(108476);var P=e.i(155284);let j=f.css`
  .reown-logo {
    height: var(--wui-spacing-xxl);
  }

  a {
    text-decoration: none;
    cursor: pointer;
  }

  a:hover {
    opacity: 0.9;
  }
`,E=class extends k.LitElement{render(){return a.html`
      <a
        data-testid="ux-branding-reown"
        href=${P.REOWN_URL}
        rel="noreferrer"
        target="_blank"
        style="text-decoration: none;"
      >
        <wui-flex
          justifyContent="center"
          alignItems="center"
          gap="xs"
          .padding=${["0","0","l","0"]}
        >
          <wui-text variant="small-500" color="fg-100"> UX by </wui-text>
          <wui-icon name="reown" size="xxxl" class="reown-logo"></wui-icon>
        </wui-flex>
      </a>
    `}};E.styles=[m.resetStyles,m.elementStyles,j],E=function(e,t,r,i){var o,s=arguments.length,a=s<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,r,i);else for(var l=e.length-1;l>=0;l--)(o=e[l])&&(a=(s<3?o(a):s>3?o(t,r,a):o(t,r))||a);return s>3&&a&&Object.defineProperty(t,r,a),a}([(0,c.customElement)("wui-ux-by-reown")],E),e.s([],933370);let $=f.css`
  :host > wui-flex {
    background-color: var(--wui-color-gray-glass-005);
  }

  :host wui-ux-by-reown {
    padding-top: 0;
  }

  :host wui-ux-by-reown.branding-only {
    padding-top: var(--wui-spacing-m);
  }

  a {
    text-decoration: none;
    color: var(--wui-color-fg-175);
    font-weight: 500;
  }
`;var O=function(e,t,r,i){var o,s=arguments.length,a=s<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,r,i);else for(var l=e.length-1;l>=0;l--)(o=e[l])&&(a=(s<3?o(a):s>3?o(t,r,a):o(t,r))||a);return s>3&&a&&Object.defineProperty(t,r,a),a};let S=class extends x.LitElement{constructor(){super(),this.unsubscribe=[],this.remoteFeatures=n.OptionsController.state.remoteFeatures,this.unsubscribe.push(n.OptionsController.subscribeKey("remoteFeatures",e=>this.remoteFeatures=e))}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}render(){let{termsConditionsUrl:e,privacyPolicyUrl:t}=n.OptionsController.state,r=n.OptionsController.state.features?.legalCheckbox;return(e||t)&&!r?a.html`
      <wui-flex flexDirection="column">
        <wui-flex .padding=${["m","s","s","s"]} justifyContent="center">
          <wui-text color="fg-250" variant="small-400" align="center">
            By connecting your wallet, you agree to our <br />
            ${this.termsTemplate()} ${this.andTemplate()} ${this.privacyTemplate()}
          </wui-text>
        </wui-flex>
        ${this.reownBrandingTemplate()}
      </wui-flex>
    `:a.html`
        <wui-flex flexDirection="column"> ${this.reownBrandingTemplate(!0)} </wui-flex>
      `}andTemplate(){let{termsConditionsUrl:e,privacyPolicyUrl:t}=n.OptionsController.state;return e&&t?"and":""}termsTemplate(){let{termsConditionsUrl:e}=n.OptionsController.state;return e?a.html`<a href=${e} target="_blank" rel="noopener noreferrer"
      >Terms of Service</a
    >`:null}privacyTemplate(){let{privacyPolicyUrl:e}=n.OptionsController.state;return e?a.html`<a href=${e} target="_blank" rel="noopener noreferrer"
      >Privacy Policy</a
    >`:null}reownBrandingTemplate(e=!1){return this.remoteFeatures?.reownBranding?e?a.html`<wui-ux-by-reown class="branding-only"></wui-ux-by-reown>`:a.html`<wui-ux-by-reown></wui-ux-by-reown>`:null}};S.styles=[$],O([(0,l.state)()],S.prototype,"remoteFeatures",void 0),S=O([(0,c.customElement)("w3m-legal-footer")],S),e.s([],176375)},175041,e=>{"use strict";e.i(588984);var t=e.i(399702),r=e.i(872857);e.i(759703);var i=e.i(698797);e.i(781840);var o=e.i(86988),s=e.i(944411),a=e.i(843028);e.i(302184);var l=e.i(938559);e.i(237029),e.i(451801),e.i(176375);var n=t,c=e.i(392074),u=e.i(525417),h=e.i(729702),d=e.i(140018),p=e.i(375054),m=e.i(229581),f=e.i(301847);e.i(231971);var v=e.i(718454),g=e.i(118827);let b=g.css`
  :host {
    margin-top: var(--wui-spacing-3xs);
  }
  wui-separator {
    margin: var(--wui-spacing-m) calc(var(--wui-spacing-m) * -1) var(--wui-spacing-xs)
      calc(var(--wui-spacing-m) * -1);
    width: calc(100% + var(--wui-spacing-s) * 2);
  }
`;var w=function(e,t,r,i){var o,s=arguments.length,a=s<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,r,i);else for(var l=e.length-1;l>=0;l--)(o=e[l])&&(a=(s<3?o(a):s>3?o(t,r,a):o(t,r))||a);return s>3&&a&&Object.defineProperty(t,r,a),a};let y=class extends n.LitElement{constructor(){super(),this.unsubscribe=[],this.tabIdx=void 0,this.connectors=h.ConnectorController.state.connectors,this.authConnector=this.connectors.find(e=>"AUTH"===e.type),this.remoteFeatures=s.OptionsController.state.remoteFeatures,this.isPwaLoading=!1,this.unsubscribe.push(h.ConnectorController.subscribeKey("connectors",e=>{this.connectors=e,this.authConnector=this.connectors.find(e=>"AUTH"===e.type)}),s.OptionsController.subscribeKey("remoteFeatures",e=>this.remoteFeatures=e))}connectedCallback(){super.connectedCallback(),this.handlePwaFrameLoad()}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}render(){let e=this.remoteFeatures?.socials||[],t=!!this.authConnector,i=e?.length,o="ConnectSocials"===p.RouterController.state.view;return t&&i||o?(o&&!i&&(e=d.ConstantsUtil.DEFAULT_SOCIALS),r.html` <wui-flex flexDirection="column" gap="xs">
      ${e.map(e=>r.html`<wui-list-social
            @click=${()=>{this.onSocialClick(e)}}
            data-testid=${`social-selector-${e}`}
            name=${e}
            logo=${e}
            ?disabled=${this.isPwaLoading}
          ></wui-list-social>`)}
    </wui-flex>`):null}async onSocialClick(e){e&&await (0,m.executeSocialLogin)(e)}async handlePwaFrameLoad(){if(f.CoreHelperUtil.isPWA()){this.isPwaLoading=!0;try{this.authConnector?.provider instanceof v.W3mFrameProvider&&await this.authConnector.provider.init()}catch(e){u.AlertController.open({displayMessage:"Error loading embedded wallet in PWA",debugMessage:e.message},"error")}finally{this.isPwaLoading=!1}}}};y.styles=b,w([(0,c.property)()],y.prototype,"tabIdx",void 0),w([(0,i.state)()],y.prototype,"connectors",void 0),w([(0,i.state)()],y.prototype,"authConnector",void 0),w([(0,i.state)()],y.prototype,"remoteFeatures",void 0),w([(0,i.state)()],y.prototype,"isPwaLoading",void 0),y=w([(0,l.customElement)("w3m-social-login-list")],y);let C=g.css`
  wui-flex {
    max-height: clamp(360px, 540px, 80vh);
    overflow: scroll;
    scrollbar-width: none;
    transition: opacity var(--wui-ease-out-power-1) var(--wui-duration-md);
    will-change: opacity;
  }
  wui-flex::-webkit-scrollbar {
    display: none;
  }
  wui-flex.disabled {
    opacity: 0.3;
    pointer-events: none;
    user-select: none;
  }
`;var x=function(e,t,r,i){var o,s=arguments.length,a=s<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,r,i);else for(var l=e.length-1;l>=0;l--)(o=e[l])&&(a=(s<3?o(a):s>3?o(t,r,a):o(t,r))||a);return s>3&&a&&Object.defineProperty(t,r,a),a};let k=class extends t.LitElement{constructor(){super(),this.unsubscribe=[],this.checked=a.OptionsStateController.state.isLegalCheckboxChecked,this.unsubscribe.push(a.OptionsStateController.subscribeKey("isLegalCheckboxChecked",e=>{this.checked=e}))}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}render(){let{termsConditionsUrl:e,privacyPolicyUrl:t}=s.OptionsController.state,i=s.OptionsController.state.features?.legalCheckbox,a=!!(e||t)&&!!i,l=a&&!this.checked;return r.html`
      <w3m-legal-checkbox></w3m-legal-checkbox>
      <wui-flex
        flexDirection="column"
        .padding=${a?["0","s","s","s"]:"s"}
        gap="xs"
        class=${(0,o.ifDefined)(l?"disabled":void 0)}
      >
        <w3m-social-login-list tabIdx=${(0,o.ifDefined)(l?-1:void 0)}></w3m-social-login-list>
      </wui-flex>
      <w3m-legal-footer></w3m-legal-footer>
    `}};k.styles=C,x([(0,i.state)()],k.prototype,"checked",void 0),k=x([(0,l.customElement)("w3m-connect-socials-view")],k),e.s(["W3mConnectSocialsView",()=>k],26870);var P=t,j=e.i(596590),E=e.i(207176),$=e.i(11961),O=e.i(881936),S=e.i(945182),R=e.i(944396),T=e.i(148018),L=e.i(880985);e.i(174776),e.i(353612),e.i(675164),e.i(331658);var _=e.i(827824),A=e.i(924487);let U=g.css`
  wui-logo {
    width: 80px;
    height: 80px;
    border-radius: var(--wui-border-radius-m);
  }
  @keyframes shake {
    0% {
      transform: translateX(0);
    }
    25% {
      transform: translateX(3px);
    }
    50% {
      transform: translateX(-3px);
    }
    75% {
      transform: translateX(3px);
    }
    100% {
      transform: translateX(0);
    }
  }
  wui-flex:first-child:not(:only-child) {
    position: relative;
  }
  wui-loading-thumbnail {
    position: absolute;
  }
  wui-icon-box {
    position: absolute;
    right: calc(var(--wui-spacing-3xs) * -1);
    bottom: calc(var(--wui-spacing-3xs) * -1);
    opacity: 0;
    transform: scale(0.5);
    transition: all var(--wui-ease-out-power-2) var(--wui-duration-lg);
  }
  wui-text[align='center'] {
    width: 100%;
    padding: 0px var(--wui-spacing-l);
  }
  [data-error='true'] wui-icon-box {
    opacity: 1;
    transform: scale(1);
  }
  [data-error='true'] > wui-flex:first-child {
    animation: shake 250ms cubic-bezier(0.36, 0.07, 0.19, 0.97) both;
  }
  .capitalize {
    text-transform: capitalize;
  }
`;var I=function(e,t,r,i){var o,s=arguments.length,a=s<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,r,i);else for(var l=e.length-1;l>=0;l--)(o=e[l])&&(a=(s<3?o(a):s>3?o(t,r,a):o(t,r))||a);return s>3&&a&&Object.defineProperty(t,r,a),a};let F=class extends P.LitElement{constructor(){super(),this.unsubscribe=[],this.socialProvider=j.AccountController.state.socialProvider,this.socialWindow=j.AccountController.state.socialWindow,this.error=!1,this.connecting=!1,this.message="Connect in the provider window",this.remoteFeatures=s.OptionsController.state.remoteFeatures,this.address=j.AccountController.state.address,this.connectionsByNamespace=$.ConnectionController.getConnections(E.ChainController.state.activeChain),this.hasMultipleConnections=this.connectionsByNamespace.length>0,this.authConnector=h.ConnectorController.getAuthConnector(),this.handleSocialConnection=async e=>{if(e.data?.resultUri)if(e.origin===A.ConstantsUtil.SECURE_SITE_ORIGIN){window.removeEventListener("message",this.handleSocialConnection,!1);try{if(this.authConnector&&!this.connecting){this.socialWindow&&(this.socialWindow.close(),j.AccountController.setSocialWindow(void 0,E.ChainController.state.activeChain)),this.connecting=!0,this.updateMessage();let t=e.data.resultUri;this.socialProvider&&O.EventsController.sendEvent({type:"track",event:"SOCIAL_LOGIN_REQUEST_USER_DATA",properties:{provider:this.socialProvider}}),await $.ConnectionController.connectExternal({id:this.authConnector.id,type:this.authConnector.type,socialUri:t},this.authConnector.chain),this.socialProvider&&(T.StorageUtil.setConnectedSocialProvider(this.socialProvider),O.EventsController.sendEvent({type:"track",event:"SOCIAL_LOGIN_SUCCESS",properties:{provider:this.socialProvider}}))}}catch(e){this.error=!0,this.updateMessage(),this.socialProvider&&O.EventsController.sendEvent({type:"track",event:"SOCIAL_LOGIN_ERROR",properties:{provider:this.socialProvider}})}}else p.RouterController.goBack(),R.SnackController.showError("Untrusted Origin"),this.socialProvider&&O.EventsController.sendEvent({type:"track",event:"SOCIAL_LOGIN_ERROR",properties:{provider:this.socialProvider}})},_.ErrorUtil.EmbeddedWalletAbortController.signal.addEventListener("abort",()=>{this.socialWindow&&(this.socialWindow.close(),j.AccountController.setSocialWindow(void 0,E.ChainController.state.activeChain))}),this.unsubscribe.push(j.AccountController.subscribe(e=>{e.socialProvider&&(this.socialProvider=e.socialProvider),e.socialWindow&&(this.socialWindow=e.socialWindow)}),s.OptionsController.subscribeKey("remoteFeatures",e=>{this.remoteFeatures=e}),j.AccountController.subscribeKey("address",e=>{let t=this.remoteFeatures?.multiWallet;e&&e!==this.address&&(this.hasMultipleConnections&&t?(p.RouterController.replace("ProfileWallets"),R.SnackController.showSuccess("New Wallet Added")):(S.ModalController.state.open||s.OptionsController.state.enableEmbedded)&&S.ModalController.close())})),this.authConnector&&this.connectSocial()}disconnectedCallback(){this.unsubscribe.forEach(e=>e()),window.removeEventListener("message",this.handleSocialConnection,!1),this.socialWindow?.close(),j.AccountController.setSocialWindow(void 0,E.ChainController.state.activeChain)}render(){return r.html`
      <wui-flex
        data-error=${(0,o.ifDefined)(this.error)}
        flexDirection="column"
        alignItems="center"
        .padding=${["3xl","xl","xl","xl"]}
        gap="xl"
      >
        <wui-flex justifyContent="center" alignItems="center">
          <wui-logo logo=${(0,o.ifDefined)(this.socialProvider)}></wui-logo>
          ${this.error?null:this.loaderTemplate()}
          <wui-icon-box
            backgroundColor="error-100"
            background="opaque"
            iconColor="error-100"
            icon="close"
            size="sm"
            border
            borderColor="wui-color-bg-125"
          ></wui-icon-box>
        </wui-flex>
        <wui-flex flexDirection="column" alignItems="center" gap="xs">
          <wui-text align="center" variant="paragraph-500" color="fg-100"
            >Log in with
            <span class="capitalize">${this.socialProvider??"Social"}</span></wui-text
          >
          <wui-text align="center" variant="small-400" color=${this.error?"error-100":"fg-200"}
            >${this.message}</wui-text
          ></wui-flex
        >
      </wui-flex>
    `}loaderTemplate(){let e=L.ThemeController.state.themeVariables["--w3m-border-radius-master"],t=e?parseInt(e.replace("px",""),10):4;return r.html`<wui-loading-thumbnail radius=${9*t}></wui-loading-thumbnail>`}connectSocial(){let e=setInterval(()=>{this.socialWindow?.closed&&(this.connecting||"ConnectingSocial"!==p.RouterController.state.view||(this.socialProvider&&O.EventsController.sendEvent({type:"track",event:"SOCIAL_LOGIN_CANCELED",properties:{provider:this.socialProvider}}),p.RouterController.goBack()),clearInterval(e))},1e3);window.addEventListener("message",this.handleSocialConnection,!1)}updateMessage(){this.error?this.message="Something went wrong":this.connecting?this.message="Retrieving user data":this.message="Connect in the provider window"}};F.styles=U,I([(0,i.state)()],F.prototype,"socialProvider",void 0),I([(0,i.state)()],F.prototype,"socialWindow",void 0),I([(0,i.state)()],F.prototype,"error",void 0),I([(0,i.state)()],F.prototype,"connecting",void 0),I([(0,i.state)()],F.prototype,"message",void 0),I([(0,i.state)()],F.prototype,"remoteFeatures",void 0),F=I([(0,l.customElement)("w3m-connecting-social-view")],F),e.s(["W3mConnectingSocialView",()=>F],675713);var D=t;e.i(81981),e.i(982221),e.i(472945),e.i(143880),e.i(211366);let W=g.css`
  @keyframes fadein {
    from {
      opacity: 0;
    }
    to {
      opacity: 1;
    }
  }

  wui-shimmer {
    width: 100%;
    aspect-ratio: 1 / 1;
    border-radius: clamp(0px, var(--wui-border-radius-l), 40px) !important;
  }

  wui-qr-code {
    opacity: 0;
    animation-duration: 200ms;
    animation-timing-function: ease;
    animation-name: fadein;
    animation-fill-mode: forwards;
  }

  wui-logo {
    width: 80px;
    height: 80px;
    border-radius: var(--wui-border-radius-m);
  }

  wui-flex:first-child:not(:only-child) {
    position: relative;
  }
  wui-loading-thumbnail {
    position: absolute;
  }
  wui-icon-box {
    position: absolute;
    right: calc(var(--wui-spacing-3xs) * -1);
    bottom: calc(var(--wui-spacing-3xs) * -1);
    opacity: 0;
    transform: scale(0.5);
    transition: all var(--wui-ease-out-power-2) var(--wui-duration-lg);
  }
`;var z=function(e,t,r,i){var o,s=arguments.length,a=s<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,r,i);else for(var l=e.length-1;l>=0;l--)(o=e[l])&&(a=(s<3?o(a):s>3?o(t,r,a):o(t,r))||a);return s>3&&a&&Object.defineProperty(t,r,a),a};let N=class extends D.LitElement{constructor(){super(),this.unsubscribe=[],this.timeout=void 0,this.socialProvider=j.AccountController.state.socialProvider,this.uri=j.AccountController.state.farcasterUrl,this.ready=!1,this.loading=!1,this.remoteFeatures=s.OptionsController.state.remoteFeatures,this.authConnector=h.ConnectorController.getAuthConnector(),this.forceUpdate=()=>{this.requestUpdate()},this.unsubscribe.push(j.AccountController.subscribeKey("farcasterUrl",e=>{e&&(this.uri=e,this.connectFarcaster())}),j.AccountController.subscribeKey("socialProvider",e=>{e&&(this.socialProvider=e)}),s.OptionsController.subscribeKey("remoteFeatures",e=>{this.remoteFeatures=e})),window.addEventListener("resize",this.forceUpdate)}disconnectedCallback(){super.disconnectedCallback(),clearTimeout(this.timeout),window.removeEventListener("resize",this.forceUpdate)}render(){return this.onRenderProxy(),r.html`${this.platformTemplate()}`}platformTemplate(){return f.CoreHelperUtil.isMobile()?r.html`${this.mobileTemplate()}`:r.html`${this.desktopTemplate()}`}desktopTemplate(){return this.loading?r.html`${this.loadingTemplate()}`:r.html`${this.qrTemplate()}`}qrTemplate(){return r.html` <wui-flex
      flexDirection="column"
      alignItems="center"
      .padding=${["0","xl","xl","xl"]}
      gap="xl"
    >
      <wui-shimmer borderRadius="l" width="100%"> ${this.qrCodeTemplate()} </wui-shimmer>

      <wui-text variant="paragraph-500" color="fg-100">
        Scan this QR Code with your phone
      </wui-text>
      ${this.copyTemplate()}
    </wui-flex>`}loadingTemplate(){return r.html`
      <wui-flex
        flexDirection="column"
        alignItems="center"
        .padding=${["xl","xl","xl","xl"]}
        gap="xl"
      >
        <wui-flex justifyContent="center" alignItems="center">
          <wui-logo logo="farcaster"></wui-logo>
          ${this.loaderTemplate()}
          <wui-icon-box
            backgroundColor="error-100"
            background="opaque"
            iconColor="error-100"
            icon="close"
            size="sm"
            border
            borderColor="wui-color-bg-125"
          ></wui-icon-box>
        </wui-flex>
        <wui-flex flexDirection="column" alignItems="center" gap="xs">
          <wui-text align="center" variant="paragraph-500" color="fg-100">
            Loading user data
          </wui-text>
          <wui-text align="center" variant="small-400" color="fg-200">
            Please wait a moment while we load your data.
          </wui-text>
        </wui-flex>
      </wui-flex>
    `}mobileTemplate(){return r.html` <wui-flex
      flexDirection="column"
      alignItems="center"
      .padding=${["3xl","xl","xl","xl"]}
      gap="xl"
    >
      <wui-flex justifyContent="center" alignItems="center">
        <wui-logo logo="farcaster"></wui-logo>
        ${this.loaderTemplate()}
        <wui-icon-box
          backgroundColor="error-100"
          background="opaque"
          iconColor="error-100"
          icon="close"
          size="sm"
          border
          borderColor="wui-color-bg-125"
        ></wui-icon-box>
      </wui-flex>
      <wui-flex flexDirection="column" alignItems="center" gap="xs">
        <wui-text align="center" variant="paragraph-500" color="fg-100"
          >Continue in Farcaster</span></wui-text
        >
        <wui-text align="center" variant="small-400" color="fg-200"
          >Accept connection request in the app</wui-text
        ></wui-flex
      >
      ${this.mobileLinkTemplate()}
    </wui-flex>`}loaderTemplate(){let e=L.ThemeController.state.themeVariables["--w3m-border-radius-master"],t=e?parseInt(e.replace("px",""),10):4;return r.html`<wui-loading-thumbnail radius=${9*t}></wui-loading-thumbnail>`}async connectFarcaster(){if(this.authConnector)try{await this.authConnector?.provider.connectFarcaster(),this.socialProvider&&(T.StorageUtil.setConnectedSocialProvider(this.socialProvider),O.EventsController.sendEvent({type:"track",event:"SOCIAL_LOGIN_REQUEST_USER_DATA",properties:{provider:this.socialProvider}})),this.loading=!0;let e=$.ConnectionController.getConnections(this.authConnector.chain).length>0;await $.ConnectionController.connectExternal(this.authConnector,this.authConnector.chain);let t=this.remoteFeatures?.multiWallet;this.socialProvider&&O.EventsController.sendEvent({type:"track",event:"SOCIAL_LOGIN_SUCCESS",properties:{provider:this.socialProvider}}),this.loading=!1,e&&t?(p.RouterController.replace("ProfileWallets"),R.SnackController.showSuccess("New Wallet Added")):S.ModalController.close()}catch(e){this.socialProvider&&O.EventsController.sendEvent({type:"track",event:"SOCIAL_LOGIN_ERROR",properties:{provider:this.socialProvider}}),p.RouterController.goBack(),R.SnackController.showError(e)}}mobileLinkTemplate(){return r.html`<wui-button
      size="md"
      ?loading=${this.loading}
      ?disabled=${!this.uri||this.loading}
      @click=${()=>{this.uri&&f.CoreHelperUtil.openHref(this.uri,"_blank")}}
    >
      Open farcaster</wui-button
    >`}onRenderProxy(){!this.ready&&this.uri&&(this.timeout=setTimeout(()=>{this.ready=!0},200))}qrCodeTemplate(){if(!this.uri||!this.ready)return null;let e=this.getBoundingClientRect().width-40;return r.html` <wui-qr-code
      size=${e}
      theme=${L.ThemeController.state.themeMode}
      uri=${this.uri}
      ?farcaster=${!0}
      data-testid="wui-qr-code"
      color=${(0,o.ifDefined)(L.ThemeController.state.themeVariables["--w3m-qr-color"])}
    ></wui-qr-code>`}copyTemplate(){let e=!this.uri||!this.ready;return r.html`<wui-link
      .disabled=${e}
      @click=${this.onCopyUri}
      color="fg-200"
      data-testid="copy-wc2-uri"
    >
      <wui-icon size="xs" color="fg-200" slot="iconLeft" name="copy"></wui-icon>
      Copy link
    </wui-link>`}onCopyUri(){try{this.uri&&(f.CoreHelperUtil.copyToClopboard(this.uri),R.SnackController.showSuccess("Link copied"))}catch{R.SnackController.showError("Failed to copy")}}};N.styles=W,z([(0,i.state)()],N.prototype,"socialProvider",void 0),z([(0,i.state)()],N.prototype,"uri",void 0),z([(0,i.state)()],N.prototype,"ready",void 0),z([(0,i.state)()],N.prototype,"loading",void 0),z([(0,i.state)()],N.prototype,"remoteFeatures",void 0),N=z([(0,l.customElement)("w3m-connecting-farcaster-view")],N),e.s(["W3mConnectingFarcasterView",()=>N],375361),e.s([],126701),e.i(126701),e.i(26870),e.i(675713),e.i(375361),e.s(["W3mConnectSocialsView",()=>k,"W3mConnectingFarcasterView",()=>N,"W3mConnectingSocialView",()=>F],175041)},370120,e=>{e.v(t=>Promise.all(["static/chunks/26e0a8e49472e8b2.js"].map(t=>e.l(t))).then(()=>t(907496)))},101594,e=>{e.v(t=>Promise.all(["static/chunks/97923f7a558363e7.js"].map(t=>e.l(t))).then(()=>t(111408)))},53619,e=>{e.v(t=>Promise.all(["static/chunks/d2d95687802cc51a.js"].map(t=>e.l(t))).then(()=>t(945285)))},647729,e=>{e.v(t=>Promise.all(["static/chunks/b9333ed8ed5db8d8.js"].map(t=>e.l(t))).then(()=>t(503272)))},42060,e=>{e.v(t=>Promise.all(["static/chunks/63e0528672c9261d.js"].map(t=>e.l(t))).then(()=>t(418817)))},646255,e=>{e.v(t=>Promise.all(["static/chunks/c41b751c0d58294f.js"].map(t=>e.l(t))).then(()=>t(509808)))},27402,e=>{e.v(t=>Promise.all(["static/chunks/f56269ce9627e4eb.js"].map(t=>e.l(t))).then(()=>t(609450)))},242317,e=>{e.v(t=>Promise.all(["static/chunks/c25bafba4e65b9d9.js"].map(t=>e.l(t))).then(()=>t(805544)))},189728,e=>{e.v(t=>Promise.all(["static/chunks/1c17bb6d6b722db7.js"].map(t=>e.l(t))).then(()=>t(39234)))},933805,e=>{e.v(t=>Promise.all(["static/chunks/eec4c7518d5ef1b7.js"].map(t=>e.l(t))).then(()=>t(83012)))},306521,e=>{e.v(t=>Promise.all(["static/chunks/c7ea8683df715cf9.js"].map(t=>e.l(t))).then(()=>t(153401)))},529497,e=>{e.v(t=>Promise.all(["static/chunks/e49251e635894a10.js"].map(t=>e.l(t))).then(()=>t(912290)))},821462,e=>{e.v(t=>Promise.all(["static/chunks/faa73acfb705c2af.js"].map(t=>e.l(t))).then(()=>t(81778)))},576367,e=>{e.v(t=>Promise.all(["static/chunks/4047e10b7e0020db.js"].map(t=>e.l(t))).then(()=>t(441939)))},719175,e=>{e.v(t=>Promise.all(["static/chunks/c8d13ffd8cb258f2.js"].map(t=>e.l(t))).then(()=>t(136442)))},585172,e=>{e.v(t=>Promise.all(["static/chunks/af37e47fd05aff94.js"].map(t=>e.l(t))).then(()=>t(376835)))},660404,e=>{e.v(t=>Promise.all(["static/chunks/4923abb4f10984df.js"].map(t=>e.l(t))).then(()=>t(622164)))},656661,e=>{e.v(t=>Promise.all(["static/chunks/9335ff44e74a1319.js"].map(t=>e.l(t))).then(()=>t(677958)))},115985,e=>{e.v(t=>Promise.all(["static/chunks/2f33c53c900a30f0.js"].map(t=>e.l(t))).then(()=>t(263541)))},798562,e=>{e.v(t=>Promise.all(["static/chunks/b7b39b35bc8e37e7.js"].map(t=>e.l(t))).then(()=>t(127098)))},995740,e=>{e.v(t=>Promise.all(["static/chunks/e023d779fabed8ba.js"].map(t=>e.l(t))).then(()=>t(466451)))},392121,e=>{e.v(t=>Promise.all(["static/chunks/bd3f5a87bd76ddf2.js"].map(t=>e.l(t))).then(()=>t(917665)))},954007,e=>{e.v(t=>Promise.all(["static/chunks/28f045a8aea535ed.js"].map(t=>e.l(t))).then(()=>t(685345)))},510739,e=>{e.v(t=>Promise.all(["static/chunks/1ce8b24df6c38238.js"].map(t=>e.l(t))).then(()=>t(922360)))},518349,e=>{e.v(t=>Promise.all(["static/chunks/abff0b62e58a0623.js"].map(t=>e.l(t))).then(()=>t(183250)))},23210,e=>{e.v(t=>Promise.all(["static/chunks/d590609f31b2b6f2.js"].map(t=>e.l(t))).then(()=>t(449291)))},69872,e=>{e.v(t=>Promise.all(["static/chunks/a90386f31e65e7c6.js"].map(t=>e.l(t))).then(()=>t(606784)))},473425,e=>{e.v(t=>Promise.all(["static/chunks/f6ce4ba8446e5b4e.js"].map(t=>e.l(t))).then(()=>t(699844)))},86124,e=>{e.v(t=>Promise.all(["static/chunks/ca0c357681404336.js"].map(t=>e.l(t))).then(()=>t(11252)))},449547,e=>{e.v(t=>Promise.all(["static/chunks/66de8be4c4f97e40.js"].map(t=>e.l(t))).then(()=>t(886888)))},107380,e=>{e.v(t=>Promise.all(["static/chunks/6786c08fb6566531.js"].map(t=>e.l(t))).then(()=>t(31913)))},417532,e=>{e.v(t=>Promise.all(["static/chunks/4c3dd4391186697a.js"].map(t=>e.l(t))).then(()=>t(165607)))},400114,e=>{e.v(t=>Promise.all(["static/chunks/e875ff35e86f2cd4.js"].map(t=>e.l(t))).then(()=>t(839832)))},371013,e=>{e.v(t=>Promise.all(["static/chunks/d5ef2cd1d5f0ce31.js"].map(t=>e.l(t))).then(()=>t(306387)))},592346,e=>{e.v(t=>Promise.all(["static/chunks/0b53bfb3dd94b07e.js"].map(t=>e.l(t))).then(()=>t(905711)))},692886,e=>{e.v(t=>Promise.all(["static/chunks/cc38ee16a99c453d.js"].map(t=>e.l(t))).then(()=>t(288445)))},559568,e=>{e.v(t=>Promise.all(["static/chunks/8893cb0dd5e75428.js"].map(t=>e.l(t))).then(()=>t(52422)))},727099,e=>{e.v(t=>Promise.all(["static/chunks/be85831826444acc.js"].map(t=>e.l(t))).then(()=>t(873099)))},106183,e=>{e.v(t=>Promise.all(["static/chunks/33ac89a1fcda0ac9.js"].map(t=>e.l(t))).then(()=>t(28900)))},276516,e=>{e.v(t=>Promise.all(["static/chunks/1f16ba9408c624e2.js"].map(t=>e.l(t))).then(()=>t(554519)))},526211,e=>{e.v(t=>Promise.all(["static/chunks/398933b68cf253b0.js"].map(t=>e.l(t))).then(()=>t(938626)))},377532,e=>{e.v(t=>Promise.all(["static/chunks/76a249fc4d7468f3.js"].map(t=>e.l(t))).then(()=>t(583927)))},146719,e=>{e.v(t=>Promise.all(["static/chunks/fc0ab7c2b70600a0.js"].map(t=>e.l(t))).then(()=>t(790998)))},343268,e=>{e.v(t=>Promise.all(["static/chunks/59373d2a49f83685.js"].map(t=>e.l(t))).then(()=>t(428068)))},921373,e=>{e.v(t=>Promise.all(["static/chunks/e523dcfe0a640736.js"].map(t=>e.l(t))).then(()=>t(127251)))},114361,e=>{e.v(t=>Promise.all(["static/chunks/1ddd2185911125ed.js"].map(t=>e.l(t))).then(()=>t(198663)))},978898,e=>{e.v(t=>Promise.all(["static/chunks/422223ea541cc4ec.js"].map(t=>e.l(t))).then(()=>t(969846)))},497619,e=>{e.v(t=>Promise.all(["static/chunks/ae8f8bf14344cd0f.js"].map(t=>e.l(t))).then(()=>t(879809)))},99077,e=>{e.v(t=>Promise.all(["static/chunks/4afd407365684745.js"].map(t=>e.l(t))).then(()=>t(706888)))},999971,e=>{e.v(t=>Promise.all(["static/chunks/b9e5b4b0b40b4966.js"].map(t=>e.l(t))).then(()=>t(954962)))},14879,e=>{e.v(t=>Promise.all(["static/chunks/03ed00251b9f8f96.js"].map(t=>e.l(t))).then(()=>t(494536)))},187203,e=>{e.v(t=>Promise.all(["static/chunks/9331bedf749a8b03.js"].map(t=>e.l(t))).then(()=>t(210924)))},517776,e=>{e.v(t=>Promise.all(["static/chunks/3fe1020423119ecd.js"].map(t=>e.l(t))).then(()=>t(705976)))},98067,e=>{e.v(t=>Promise.all(["static/chunks/8ee0a99124a40521.js"].map(t=>e.l(t))).then(()=>t(403692)))},180529,e=>{e.v(t=>Promise.all(["static/chunks/c0ffd2c02e3b49f9.js"].map(t=>e.l(t))).then(()=>t(356216)))},33772,e=>{e.v(t=>Promise.all(["static/chunks/c26fa44e80d4552b.js"].map(t=>e.l(t))).then(()=>t(354159)))},612617,e=>{e.v(t=>Promise.all(["static/chunks/2800c4437d7ec1c8.js"].map(t=>e.l(t))).then(()=>t(981722)))},99078,e=>{e.v(t=>Promise.all(["static/chunks/18b5586311477356.js"].map(t=>e.l(t))).then(()=>t(879190)))},484585,e=>{e.v(t=>Promise.all(["static/chunks/24678d38918cff86.js"].map(t=>e.l(t))).then(()=>t(390585)))},766513,e=>{e.v(t=>Promise.all(["static/chunks/b4f4414200774c70.js"].map(t=>e.l(t))).then(()=>t(856636)))},682754,e=>{e.v(t=>Promise.all(["static/chunks/20a8a0f412961150.js"].map(t=>e.l(t))).then(()=>t(703951)))},219316,e=>{e.v(t=>Promise.all(["static/chunks/5d1a1b0db1f6f280.js"].map(t=>e.l(t))).then(()=>t(961511)))},277176,e=>{e.v(t=>Promise.all(["static/chunks/63b01ab668891c59.js"].map(t=>e.l(t))).then(()=>t(355495)))},560377,e=>{e.v(t=>Promise.all(["static/chunks/a73126aecb5194b1.js"].map(t=>e.l(t))).then(()=>t(699252)))},461996,e=>{e.v(t=>Promise.all(["static/chunks/014ac0ae0eb0d977.js"].map(t=>e.l(t))).then(()=>t(595684)))},760084,e=>{e.v(t=>Promise.all(["static/chunks/3d2cf405c5be67f1.js"].map(t=>e.l(t))).then(()=>t(821645)))},23765,e=>{e.v(t=>Promise.all(["static/chunks/19daf80189af3cb5.js"].map(t=>e.l(t))).then(()=>t(669874)))},669065,e=>{e.v(t=>Promise.all(["static/chunks/39c5ab3d449138ef.js"].map(t=>e.l(t))).then(()=>t(756209)))},137985,e=>{e.v(t=>Promise.all(["static/chunks/a96e5b3c0bcf745a.js"].map(t=>e.l(t))).then(()=>t(862181)))},984531,e=>{e.v(t=>Promise.all(["static/chunks/7e2b21a05f35e2fb.js"].map(t=>e.l(t))).then(()=>t(654201)))},14671,e=>{e.v(t=>Promise.all(["static/chunks/2e833c4f8897d285.js"].map(t=>e.l(t))).then(()=>t(400433)))},661706,e=>{e.v(t=>Promise.all(["static/chunks/9d7994b2925eedff.js"].map(t=>e.l(t))).then(()=>t(406011)))},808545,e=>{e.v(t=>Promise.all(["static/chunks/c12e7e357bd73885.js"].map(t=>e.l(t))).then(()=>t(590802)))},86125,e=>{e.v(t=>Promise.all(["static/chunks/6674dde5fce56b90.js"].map(t=>e.l(t))).then(()=>t(127530)))},25054,e=>{e.v(t=>Promise.all(["static/chunks/5f43b8de108d82a8.js"].map(t=>e.l(t))).then(()=>t(404202)))},189409,e=>{e.v(t=>Promise.all(["static/chunks/04c3bd1cc3433abb.js"].map(t=>e.l(t))).then(()=>t(838366)))},105736,e=>{e.v(t=>Promise.all(["static/chunks/3ab13667b822299a.js"].map(t=>e.l(t))).then(()=>t(511626)))},75220,e=>{e.v(t=>Promise.all(["static/chunks/136b1b881256e27c.js"].map(t=>e.l(t))).then(()=>t(981111)))},164632,e=>{e.v(t=>Promise.all(["static/chunks/27a0455f9ed4cbe2.js"].map(t=>e.l(t))).then(()=>t(235153)))},6768,e=>{e.v(t=>Promise.all(["static/chunks/65b36f3821731273.js"].map(t=>e.l(t))).then(()=>t(614051)))},82206,e=>{e.v(t=>Promise.all(["static/chunks/cd86ccbd9d28ee36.js"].map(t=>e.l(t))).then(()=>t(56751)))},458662,e=>{e.v(t=>Promise.all(["static/chunks/ae5b22bbf1fab4fc.js"].map(t=>e.l(t))).then(()=>t(972606)))},405625,e=>{e.v(t=>Promise.all(["static/chunks/42b23260469ed281.js"].map(t=>e.l(t))).then(()=>t(56717)))}]);