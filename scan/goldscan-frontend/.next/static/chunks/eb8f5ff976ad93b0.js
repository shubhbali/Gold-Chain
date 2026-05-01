(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,846880,t=>{"use strict";t.i(588984);var e=t.i(399702),i=t.i(872857);t.i(759703);var r=t.i(392074),o=t.i(938559),a=t.i(118827);let s=a.css`
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
`;var n=function(t,e,i,r){var o,a=arguments.length,s=a<3?e:null===r?r=Object.getOwnPropertyDescriptor(e,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,i,r);else for(var n=t.length-1;n>=0;n--)(o=t[n])&&(s=(a<3?o(s):a>3?o(e,i,s):o(e,i))||s);return a>3&&s&&Object.defineProperty(e,i,s),s};let l=class extends e.LitElement{constructor(){super(...arguments),this.width="",this.height="",this.borderRadius="m",this.variant="default"}render(){return this.style.cssText=`
      width: ${this.width};
      height: ${this.height};
      border-radius: clamp(0px,var(--wui-border-radius-${this.borderRadius}), 40px);
    `,i.html`<slot></slot>`}};l.styles=[s],n([(0,r.property)()],l.prototype,"width",void 0),n([(0,r.property)()],l.prototype,"height",void 0),n([(0,r.property)()],l.prototype,"borderRadius",void 0),n([(0,r.property)()],l.prototype,"variant",void 0),l=n([(0,o.customElement)("wui-shimmer")],l),t.s([],846880)},839432,t=>{"use strict";t.i(588984);var e=t.i(399702),i=t.i(872857);t.i(759703);var r=t.i(392074);t.i(630572);var o=t.i(864429),a=t.i(938559),s=t.i(118827);let n=s.css`
  :host {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    position: relative;
    overflow: hidden;
    background-color: var(--wui-color-gray-glass-020);
    border-radius: var(--local-border-radius);
    border: var(--local-border);
    box-sizing: content-box;
    width: var(--local-size);
    height: var(--local-size);
    min-height: var(--local-size);
    min-width: var(--local-size);
  }

  @supports (background: color-mix(in srgb, white 50%, black)) {
    :host {
      background-color: color-mix(in srgb, var(--local-bg-value) var(--local-bg-mix), transparent);
    }
  }
`;var l=function(t,e,i,r){var o,a=arguments.length,s=a<3?e:null===r?r=Object.getOwnPropertyDescriptor(e,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,i,r);else for(var n=t.length-1;n>=0;n--)(o=t[n])&&(s=(a<3?o(s):a>3?o(e,i,s):o(e,i))||s);return a>3&&s&&Object.defineProperty(e,i,s),s};let c=class extends e.LitElement{constructor(){super(...arguments),this.size="md",this.backgroundColor="accent-100",this.iconColor="accent-100",this.background="transparent",this.border=!1,this.borderColor="wui-color-bg-125",this.icon="copy"}render(){let t=this.iconSize||this.size,e="lg"===this.size,r="xl"===this.size,o="gray"===this.background,a="opaque"===this.background,s="accent-100"===this.backgroundColor&&a||"success-100"===this.backgroundColor&&a||"error-100"===this.backgroundColor&&a||"inverse-100"===this.backgroundColor&&a,n=`var(--wui-color-${this.backgroundColor})`;return s?n=`var(--wui-icon-box-bg-${this.backgroundColor})`:o&&(n=`var(--wui-color-gray-${this.backgroundColor})`),this.style.cssText=`
       --local-bg-value: ${n};
       --local-bg-mix: ${s||o?"100%":e?"12%":"16%"};
       --local-border-radius: var(--wui-border-radius-${e?"xxs":r?"s":"3xl"});
       --local-size: var(--wui-icon-box-size-${this.size});
       --local-border: ${"wui-color-bg-125"===this.borderColor?"2px":"1px"} solid ${this.border?`var(--${this.borderColor})`:"transparent"}
   `,i.html` <wui-icon color=${this.iconColor} size=${t} name=${this.icon}></wui-icon> `}};c.styles=[o.resetStyles,o.elementStyles,n],l([(0,r.property)()],c.prototype,"size",void 0),l([(0,r.property)()],c.prototype,"backgroundColor",void 0),l([(0,r.property)()],c.prototype,"iconColor",void 0),l([(0,r.property)()],c.prototype,"iconSize",void 0),l([(0,r.property)()],c.prototype,"background",void 0),l([(0,r.property)({type:Boolean})],c.prototype,"border",void 0),l([(0,r.property)()],c.prototype,"borderColor",void 0),l([(0,r.property)()],c.prototype,"icon",void 0),c=l([(0,a.customElement)("wui-icon-box")],c),t.s([],839432)},630572,t=>{"use strict";t.i(588984);var e=t.i(399702),i=t.i(872857);t.i(759703);var r=t.i(392074);t.i(891237);var o=t.i(412088);let a=new class{constructor(){this.cache=new Map}set(t,e){this.cache.set(t,e)}get(t){return this.cache.get(t)}has(t){return this.cache.has(t)}delete(t){this.cache.delete(t)}clear(){this.cache.clear()}};var s=t.i(864429),n=t.i(938559),l=t.i(118827);let c=l.css`
  :host {
    display: flex;
    aspect-ratio: var(--local-aspect-ratio);
    color: var(--local-color);
    width: var(--local-width);
  }

  svg {
    width: inherit;
    height: inherit;
    object-fit: contain;
    object-position: center;
  }

  .fallback {
    width: var(--local-width);
    height: var(--local-height);
  }
`;var p=function(t,e,i,r){var o,a=arguments.length,s=a<3?e:null===r?r=Object.getOwnPropertyDescriptor(e,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,i,r);else for(var n=t.length-1;n>=0;n--)(o=t[n])&&(s=(a<3?o(s):a>3?o(e,i,s):o(e,i))||s);return a>3&&s&&Object.defineProperty(e,i,s),s};let u={add:async()=>(await t.A(370120)).addSvg,allWallets:async()=>(await t.A(101594)).allWalletsSvg,arrowBottomCircle:async()=>(await t.A(53619)).arrowBottomCircleSvg,appStore:async()=>(await t.A(647729)).appStoreSvg,apple:async()=>(await t.A(42060)).appleSvg,arrowBottom:async()=>(await t.A(646255)).arrowBottomSvg,arrowLeft:async()=>(await t.A(27402)).arrowLeftSvg,arrowRight:async()=>(await t.A(242317)).arrowRightSvg,arrowTop:async()=>(await t.A(189728)).arrowTopSvg,bank:async()=>(await t.A(933805)).bankSvg,browser:async()=>(await t.A(306521)).browserSvg,bin:async()=>(await t.A(529497)).binSvg,bitcoin:async()=>(await t.A(821462)).bitcoinSvg,card:async()=>(await t.A(576367)).cardSvg,checkmark:async()=>(await t.A(719175)).checkmarkSvg,checkmarkBold:async()=>(await t.A(585172)).checkmarkBoldSvg,chevronBottom:async()=>(await t.A(660404)).chevronBottomSvg,chevronLeft:async()=>(await t.A(656661)).chevronLeftSvg,chevronRight:async()=>(await t.A(115985)).chevronRightSvg,chevronTop:async()=>(await t.A(798562)).chevronTopSvg,chromeStore:async()=>(await t.A(995740)).chromeStoreSvg,clock:async()=>(await t.A(392121)).clockSvg,close:async()=>(await t.A(954007)).closeSvg,compass:async()=>(await t.A(510739)).compassSvg,coinPlaceholder:async()=>(await t.A(518349)).coinPlaceholderSvg,copy:async()=>(await t.A(23210)).copySvg,cursor:async()=>(await t.A(69872)).cursorSvg,cursorTransparent:async()=>(await t.A(473425)).cursorTransparentSvg,circle:async()=>(await t.A(86124)).circleSvg,desktop:async()=>(await t.A(449547)).desktopSvg,disconnect:async()=>(await t.A(107380)).disconnectSvg,discord:async()=>(await t.A(417532)).discordSvg,download:async()=>(await t.A(400114)).downloadSvg,ethereum:async()=>(await t.A(371013)).ethereumSvg,etherscan:async()=>(await t.A(592346)).etherscanSvg,extension:async()=>(await t.A(692886)).extensionSvg,externalLink:async()=>(await t.A(559568)).externalLinkSvg,facebook:async()=>(await t.A(727099)).facebookSvg,farcaster:async()=>(await t.A(106183)).farcasterSvg,filters:async()=>(await t.A(276516)).filtersSvg,github:async()=>(await t.A(526211)).githubSvg,google:async()=>(await t.A(377532)).googleSvg,helpCircle:async()=>(await t.A(146719)).helpCircleSvg,image:async()=>(await t.A(343268)).imageSvg,id:async()=>(await t.A(921373)).idSvg,infoCircle:async()=>(await t.A(114361)).infoCircleSvg,lightbulb:async()=>(await t.A(978898)).lightbulbSvg,mail:async()=>(await t.A(497619)).mailSvg,mobile:async()=>(await t.A(99077)).mobileSvg,more:async()=>(await t.A(999971)).moreSvg,networkPlaceholder:async()=>(await t.A(14879)).networkPlaceholderSvg,nftPlaceholder:async()=>(await t.A(187203)).nftPlaceholderSvg,off:async()=>(await t.A(517776)).offSvg,playStore:async()=>(await t.A(98067)).playStoreSvg,plus:async()=>(await t.A(180529)).plusSvg,qrCode:async()=>(await t.A(33772)).qrCodeIcon,recycleHorizontal:async()=>(await t.A(612617)).recycleHorizontalSvg,refresh:async()=>(await t.A(99078)).refreshSvg,search:async()=>(await t.A(484585)).searchSvg,send:async()=>(await t.A(766513)).sendSvg,swapHorizontal:async()=>(await t.A(682754)).swapHorizontalSvg,swapHorizontalMedium:async()=>(await t.A(219316)).swapHorizontalMediumSvg,swapHorizontalBold:async()=>(await t.A(277176)).swapHorizontalBoldSvg,swapHorizontalRoundedBold:async()=>(await t.A(560377)).swapHorizontalRoundedBoldSvg,swapVertical:async()=>(await t.A(461996)).swapVerticalSvg,solana:async()=>(await t.A(760084)).solanaSvg,telegram:async()=>(await t.A(23765)).telegramSvg,threeDots:async()=>(await t.A(669065)).threeDotsSvg,twitch:async()=>(await t.A(137985)).twitchSvg,twitter:async()=>(await t.A(984531)).xSvg,twitterIcon:async()=>(await t.A(14671)).twitterIconSvg,user:async()=>(await t.A(661706)).userSvg,verify:async()=>(await t.A(808545)).verifySvg,verifyFilled:async()=>(await t.A(86125)).verifyFilledSvg,wallet:async()=>(await t.A(25054)).walletSvg,walletConnect:async()=>(await t.A(189409)).walletConnectSvg,walletConnectLightBrown:async()=>(await t.A(189409)).walletConnectLightBrownSvg,walletConnectBrown:async()=>(await t.A(189409)).walletConnectBrownSvg,walletPlaceholder:async()=>(await t.A(105736)).walletPlaceholderSvg,warningCircle:async()=>(await t.A(75220)).warningCircleSvg,x:async()=>(await t.A(984531)).xSvg,info:async()=>(await t.A(164632)).infoSvg,exclamationTriangle:async()=>(await t.A(6768)).exclamationTriangleSvg,reown:async()=>(await t.A(82206)).reownSvg,"x-mark":async()=>(await t.A(458662)).xMarkSvg,dollar:async()=>(await t.A(405625)).dollarSvg};async function d(t){if(a.has(t))return a.get(t);let e=(u[t]??u.copy)();return a.set(t,e),e}let h=class extends e.LitElement{constructor(){super(...arguments),this.size="md",this.name="copy",this.color="fg-300",this.aspectRatio="1 / 1"}render(){return this.style.cssText=`
      --local-color: var(--wui-color-${this.color});
      --local-width: var(--wui-icon-size-${this.size});
      --local-aspect-ratio: ${this.aspectRatio}
    `,i.html`${(0,o.until)(d(this.name),i.html`<div class="fallback"></div>`)}`}};h.styles=[s.resetStyles,s.colorStyles,c],p([(0,r.property)()],h.prototype,"size",void 0),p([(0,r.property)()],h.prototype,"name",void 0),p([(0,r.property)()],h.prototype,"color",void 0),p([(0,r.property)()],h.prototype,"aspectRatio",void 0),h=p([(0,n.customElement)("wui-icon")],h),t.s([],630572)},399702,392074,698797,759703,t=>{"use strict";var e=t.i(861505);t.i(118827),t.i(872857),t.s(["LitElement",()=>e.LitElement],399702);var i=t.i(535178);let r={attribute:!0,type:String,converter:i.defaultConverter,reflect:!1,hasChanged:i.notEqual};function o(t){return(e,i)=>{let o;return"object"==typeof i?((t=r,e,i)=>{let{kind:o,metadata:a}=i,s=globalThis.litPropertyMetadata.get(a);if(void 0===s&&globalThis.litPropertyMetadata.set(a,s=new Map),"setter"===o&&((t=Object.create(t)).wrapped=!0),s.set(i.name,t),"accessor"===o){let{name:r}=i;return{set(i){let o=e.get.call(this);e.set.call(this,i),this.requestUpdate(r,o,t,!0,i)},init(e){return void 0!==e&&this.C(r,void 0,t,e),e}}}if("setter"===o){let{name:r}=i;return function(i){let o=this[r];e.call(this,i),this.requestUpdate(r,o,t,!0,i)}}throw Error("Unsupported decorator location: "+o)})(t,e,i):(o=e.hasOwnProperty(i),e.constructor.createProperty(i,t),o?Object.getOwnPropertyDescriptor(e,i):void 0)}}function a(t){return o({...t,state:!0,attribute:!1})}t.s(["property",()=>o],392074),t.s(["state",()=>a],698797),t.s([],759703)},364521,t=>{"use strict";let e={ATTRIBUTE:1,CHILD:2,PROPERTY:3,BOOLEAN_ATTRIBUTE:4,EVENT:5,ELEMENT:6},i=t=>(...e)=>({_$litDirective$:t,values:e});class r{constructor(t){}get _$AU(){return this._$AM._$AU}_$AT(t,e,i){this._$Ct=t,this._$AM=e,this._$Ci=i}_$AS(t,e){return this.update(t,e)}update(t,e){return this.render(...e)}}t.s(["Directive",()=>r,"PartType",()=>e,"directive",()=>i])},781840,86988,t=>{"use strict";var e=t.i(872857);let i=t=>t??e.nothing;t.s(["ifDefined",()=>i],86988),t.s([],781840)},865793,513002,t=>{"use strict";var e=t.i(872857),i=t.i(364521);let r=(0,i.directive)(class extends i.Directive{constructor(t){if(super(t),t.type!==i.PartType.ATTRIBUTE||"class"!==t.name||t.strings?.length>2)throw Error("`classMap()` can only be used in the `class` attribute and must be the only part in the attribute.")}render(t){return" "+Object.keys(t).filter(e=>t[e]).join(" ")+" "}update(t,[i]){if(void 0===this.st){for(let e in this.st=new Set,void 0!==t.strings&&(this.nt=new Set(t.strings.join(" ").split(/\s/).filter(t=>""!==t))),i)i[e]&&!this.nt?.has(e)&&this.st.add(e);return this.render(i)}let r=t.element.classList;for(let t of this.st)t in i||(r.remove(t),this.st.delete(t));for(let t in i){let e=!!i[t];e===this.st.has(t)||this.nt?.has(t)||(e?(r.add(t),this.st.add(t)):(r.remove(t),this.st.delete(t)))}return e.noChange}});t.s(["classMap",()=>r],513002),t.s([],865793)},891237,941528,412088,t=>{"use strict";var e=t.i(872857);let{I:i}=e._$LH;var r=t.i(364521);let o=(t,e)=>{let i=t._$AN;if(void 0===i)return!1;for(let t of i)t._$AO?.(e,!1),o(t,e);return!0},a=t=>{let e,i;do{if(void 0===(e=t._$AM))break;(i=e._$AN).delete(t),t=e}while(0===i?.size)},s=t=>{for(let e;e=t._$AM;t=e){let i=e._$AN;if(void 0===i)e._$AN=i=new Set;else if(i.has(t))break;i.add(t),c(e)}};function n(t){void 0!==this._$AN?(a(this),this._$AM=t,s(this)):this._$AM=t}function l(t,e=!1,i=0){let r=this._$AH,s=this._$AN;if(void 0!==s&&0!==s.size)if(e)if(Array.isArray(r))for(let t=i;t<r.length;t++)o(r[t],!1),a(r[t]);else null!=r&&(o(r,!1),a(r));else o(this,t)}let c=t=>{t.type==r.PartType.CHILD&&(t._$AP??=l,t._$AQ??=n)};class p extends r.Directive{constructor(){super(...arguments),this._$AN=void 0}_$AT(t,e,i){super._$AT(t,e,i),s(this),this.isConnected=t._$AU}_$AO(t,e=!0){t!==this.isConnected&&(this.isConnected=t,t?this.reconnected?.():this.disconnected?.()),e&&(o(this,t),a(this))}setValue(t){if(void 0===this._$Ct.strings)this._$Ct._$AI(t,this);else{let e=[...this._$Ct._$AH];e[this._$Ci]=t,this._$Ct._$AI(e,this,0)}}disconnected(){}reconnected(){}}t.s(["AsyncDirective",()=>p],941528);class u{constructor(t){this.G=t}disconnect(){this.G=void 0}reconnect(t){this.G=t}deref(){return this.G}}class d{constructor(){this.Y=void 0,this.Z=void 0}get(){return this.Y}pause(){this.Y??=new Promise(t=>this.Z=t)}resume(){this.Z?.(),this.Y=this.Z=void 0}}let h=t=>null!==t&&("object"==typeof t||"function"==typeof t)&&"function"==typeof t.then,g=(0,r.directive)(class extends p{constructor(){super(...arguments),this._$Cwt=0x3fffffff,this._$Cbt=[],this._$CK=new u(this),this._$CX=new d}render(...t){return t.find(t=>!h(t))??e.noChange}update(t,i){let r=this._$Cbt,o=r.length;this._$Cbt=i;let a=this._$CK,s=this._$CX;this.isConnected||this.disconnected();for(let t=0;t<i.length&&!(t>this._$Cwt);t++){let e=i[t];if(!h(e))return this._$Cwt=t,e;t<o&&e===r[t]||(this._$Cwt=0x3fffffff,o=0,Promise.resolve(e).then(async t=>{for(;s.get();)await s.get();let i=a.deref();if(void 0!==i){let r=i._$Cbt.indexOf(e);r>-1&&r<i._$Cwt&&(i._$Cwt=r,i.setValue(t))}}))}return e.noChange}disconnected(){this._$CK.disconnect(),this._$CX.pause()}reconnected(){this._$CK.reconnect(this),this._$CX.resume()}});t.s(["until",()=>g],412088),t.s([],891237)},237029,108476,t=>{"use strict";t.i(588984);var e=t.i(399702),i=t.i(872857);t.i(759703);var r=t.i(392074),o=t.i(864429),a=t.i(34691),s=t.i(938559),n=t.i(118827);let l=n.css`
  :host {
    display: flex;
    width: inherit;
    height: inherit;
  }
`;var c=function(t,e,i,r){var o,a=arguments.length,s=a<3?e:null===r?r=Object.getOwnPropertyDescriptor(e,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,i,r);else for(var n=t.length-1;n>=0;n--)(o=t[n])&&(s=(a<3?o(s):a>3?o(e,i,s):o(e,i))||s);return a>3&&s&&Object.defineProperty(e,i,s),s};let p=class extends e.LitElement{render(){return this.style.cssText=`
      flex-direction: ${this.flexDirection};
      flex-wrap: ${this.flexWrap};
      flex-basis: ${this.flexBasis};
      flex-grow: ${this.flexGrow};
      flex-shrink: ${this.flexShrink};
      align-items: ${this.alignItems};
      justify-content: ${this.justifyContent};
      column-gap: ${this.columnGap&&`var(--wui-spacing-${this.columnGap})`};
      row-gap: ${this.rowGap&&`var(--wui-spacing-${this.rowGap})`};
      gap: ${this.gap&&`var(--wui-spacing-${this.gap})`};
      padding-top: ${this.padding&&a.UiHelperUtil.getSpacingStyles(this.padding,0)};
      padding-right: ${this.padding&&a.UiHelperUtil.getSpacingStyles(this.padding,1)};
      padding-bottom: ${this.padding&&a.UiHelperUtil.getSpacingStyles(this.padding,2)};
      padding-left: ${this.padding&&a.UiHelperUtil.getSpacingStyles(this.padding,3)};
      margin-top: ${this.margin&&a.UiHelperUtil.getSpacingStyles(this.margin,0)};
      margin-right: ${this.margin&&a.UiHelperUtil.getSpacingStyles(this.margin,1)};
      margin-bottom: ${this.margin&&a.UiHelperUtil.getSpacingStyles(this.margin,2)};
      margin-left: ${this.margin&&a.UiHelperUtil.getSpacingStyles(this.margin,3)};
    `,i.html`<slot></slot>`}};p.styles=[o.resetStyles,l],c([(0,r.property)()],p.prototype,"flexDirection",void 0),c([(0,r.property)()],p.prototype,"flexWrap",void 0),c([(0,r.property)()],p.prototype,"flexBasis",void 0),c([(0,r.property)()],p.prototype,"flexGrow",void 0),c([(0,r.property)()],p.prototype,"flexShrink",void 0),c([(0,r.property)()],p.prototype,"alignItems",void 0),c([(0,r.property)()],p.prototype,"justifyContent",void 0),c([(0,r.property)()],p.prototype,"columnGap",void 0),c([(0,r.property)()],p.prototype,"rowGap",void 0),c([(0,r.property)()],p.prototype,"gap",void 0),c([(0,r.property)()],p.prototype,"padding",void 0),c([(0,r.property)()],p.prototype,"margin",void 0),p=c([(0,s.customElement)("wui-flex")],p),t.s([],108476),t.s([],237029)},596548,t=>{"use strict";t.i(588984);var e=t.i(399702),i=t.i(872857);t.i(759703);var r=t.i(392074);t.i(865793);var o=t.i(513002),a=t.i(864429),s=t.i(938559),n=t.i(118827);let l=n.css`
  :host {
    display: inline-flex !important;
  }

  slot {
    width: 100%;
    display: inline-block;
    font-style: normal;
    font-family: var(--wui-font-family);
    font-feature-settings:
      'tnum' on,
      'lnum' on,
      'case' on;
    line-height: 130%;
    font-weight: var(--wui-font-weight-regular);
    overflow: inherit;
    text-overflow: inherit;
    text-align: var(--local-align);
    color: var(--local-color);
  }

  .wui-line-clamp-1 {
    overflow: hidden;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 1;
  }

  .wui-line-clamp-2 {
    overflow: hidden;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
  }

  .wui-font-medium-400 {
    font-size: var(--wui-font-size-medium);
    font-weight: var(--wui-font-weight-light);
    letter-spacing: var(--wui-letter-spacing-medium);
  }

  .wui-font-medium-600 {
    font-size: var(--wui-font-size-medium);
    letter-spacing: var(--wui-letter-spacing-medium);
  }

  .wui-font-title-600 {
    font-size: var(--wui-font-size-title);
    letter-spacing: var(--wui-letter-spacing-title);
  }

  .wui-font-title-6-600 {
    font-size: var(--wui-font-size-title-6);
    letter-spacing: var(--wui-letter-spacing-title-6);
  }

  .wui-font-mini-700 {
    font-size: var(--wui-font-size-mini);
    letter-spacing: var(--wui-letter-spacing-mini);
    text-transform: uppercase;
  }

  .wui-font-large-500,
  .wui-font-large-600,
  .wui-font-large-700 {
    font-size: var(--wui-font-size-large);
    letter-spacing: var(--wui-letter-spacing-large);
  }

  .wui-font-2xl-500,
  .wui-font-2xl-600,
  .wui-font-2xl-700 {
    font-size: var(--wui-font-size-2xl);
    letter-spacing: var(--wui-letter-spacing-2xl);
  }

  .wui-font-paragraph-400,
  .wui-font-paragraph-500,
  .wui-font-paragraph-600,
  .wui-font-paragraph-700 {
    font-size: var(--wui-font-size-paragraph);
    letter-spacing: var(--wui-letter-spacing-paragraph);
  }

  .wui-font-small-400,
  .wui-font-small-500,
  .wui-font-small-600 {
    font-size: var(--wui-font-size-small);
    letter-spacing: var(--wui-letter-spacing-small);
  }

  .wui-font-tiny-400,
  .wui-font-tiny-500,
  .wui-font-tiny-600 {
    font-size: var(--wui-font-size-tiny);
    letter-spacing: var(--wui-letter-spacing-tiny);
  }

  .wui-font-micro-700,
  .wui-font-micro-600,
  .wui-font-micro-500 {
    font-size: var(--wui-font-size-micro);
    letter-spacing: var(--wui-letter-spacing-micro);
    text-transform: uppercase;
  }

  .wui-font-tiny-400,
  .wui-font-small-400,
  .wui-font-medium-400,
  .wui-font-paragraph-400 {
    font-weight: var(--wui-font-weight-light);
  }

  .wui-font-large-700,
  .wui-font-paragraph-700,
  .wui-font-micro-700,
  .wui-font-mini-700 {
    font-weight: var(--wui-font-weight-bold);
  }

  .wui-font-medium-600,
  .wui-font-medium-title-600,
  .wui-font-title-6-600,
  .wui-font-large-600,
  .wui-font-paragraph-600,
  .wui-font-small-600,
  .wui-font-tiny-600,
  .wui-font-micro-600 {
    font-weight: var(--wui-font-weight-medium);
  }

  :host([disabled]) {
    opacity: 0.4;
  }
`;var c=function(t,e,i,r){var o,a=arguments.length,s=a<3?e:null===r?r=Object.getOwnPropertyDescriptor(e,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,i,r);else for(var n=t.length-1;n>=0;n--)(o=t[n])&&(s=(a<3?o(s):a>3?o(e,i,s):o(e,i))||s);return a>3&&s&&Object.defineProperty(e,i,s),s};let p=class extends e.LitElement{constructor(){super(...arguments),this.variant="paragraph-500",this.color="fg-300",this.align="left",this.lineClamp=void 0}render(){let t={[`wui-font-${this.variant}`]:!0,[`wui-color-${this.color}`]:!0,[`wui-line-clamp-${this.lineClamp}`]:!!this.lineClamp};return this.style.cssText=`
      --local-align: ${this.align};
      --local-color: var(--wui-color-${this.color});
    `,i.html`<slot class=${(0,o.classMap)(t)}></slot>`}};p.styles=[a.resetStyles,l],c([(0,r.property)()],p.prototype,"variant",void 0),c([(0,r.property)()],p.prototype,"color",void 0),c([(0,r.property)()],p.prototype,"align",void 0),c([(0,r.property)()],p.prototype,"lineClamp",void 0),p=c([(0,s.customElement)("wui-text")],p),t.s([],596548)},331658,t=>{"use strict";t.i(596548),t.s([])},287940,t=>{"use strict";t.i(588984);var e=t.i(399702),i=t.i(872857);t.i(759703);var r=t.i(392074),o=t.i(864429),a=t.i(938559),s=t.i(118827);let n=s.css`
  :host {
    display: block;
    width: var(--local-width);
    height: var(--local-height);
  }

  :host([data-object-fit='cover']) img {
    object-fit: cover;
    object-position: center center;
  }

  :host([data-object-fit='contain']) img {
    object-fit: contain;
    object-position: center center;
  }

  img {
    display: block;
    width: 100%;
    height: 100%;
    border-radius: inherit;
  }
`;var l=function(t,e,i,r){var o,a=arguments.length,s=a<3?e:null===r?r=Object.getOwnPropertyDescriptor(e,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,i,r);else for(var n=t.length-1;n>=0;n--)(o=t[n])&&(s=(a<3?o(s):a>3?o(e,i,s):o(e,i))||s);return a>3&&s&&Object.defineProperty(e,i,s),s};let c=class extends e.LitElement{constructor(){super(...arguments),this.src="./path/to/image.jpg",this.alt="Image",this.size=void 0,this.objectFit="cover"}render(){return this.objectFit&&(this.dataset.objectFit=this.objectFit),this.style.cssText=`
      --local-width: ${this.size?`var(--wui-icon-size-${this.size});`:"100%"};
      --local-height: ${this.size?`var(--wui-icon-size-${this.size});`:"100%"};
      `,i.html`<img src=${this.src} alt=${this.alt} @error=${this.handleImageError} />`}handleImageError(){this.dispatchEvent(new CustomEvent("onLoadError",{bubbles:!0,composed:!0}))}};c.styles=[o.resetStyles,o.colorStyles,n],l([(0,r.property)()],c.prototype,"src",void 0),l([(0,r.property)()],c.prototype,"alt",void 0),l([(0,r.property)()],c.prototype,"size",void 0),l([(0,r.property)()],c.prototype,"objectFit",void 0),c=l([(0,a.customElement)("wui-image")],c),t.s([],287940)},472945,t=>{"use strict";t.i(588984);var e=t.i(399702),i=t.i(872857);t.i(759703);var r=t.i(392074);t.i(781840);var o=t.i(86988);t.i(596548);var a=t.i(864429),s=t.i(938559),n=t.i(118827);let l=n.css`
  button {
    padding: var(--wui-spacing-4xs) var(--wui-spacing-xxs);
    border-radius: var(--wui-border-radius-3xs);
    background-color: transparent;
    color: var(--wui-color-accent-100);
  }

  button:disabled {
    background-color: transparent;
    color: var(--wui-color-gray-glass-015);
  }

  button:hover {
    background-color: var(--wui-color-gray-glass-005);
  }
`;var c=function(t,e,i,r){var o,a=arguments.length,s=a<3?e:null===r?r=Object.getOwnPropertyDescriptor(e,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,i,r);else for(var n=t.length-1;n>=0;n--)(o=t[n])&&(s=(a<3?o(s):a>3?o(e,i,s):o(e,i))||s);return a>3&&s&&Object.defineProperty(e,i,s),s};let p=class extends e.LitElement{constructor(){super(...arguments),this.tabIdx=void 0,this.disabled=!1,this.color="inherit"}render(){return i.html`
      <button ?disabled=${this.disabled} tabindex=${(0,o.ifDefined)(this.tabIdx)}>
        <slot name="iconLeft"></slot>
        <wui-text variant="small-600" color=${this.color}>
          <slot></slot>
        </wui-text>
        <slot name="iconRight"></slot>
      </button>
    `}};p.styles=[a.resetStyles,a.elementStyles,l],c([(0,r.property)()],p.prototype,"tabIdx",void 0),c([(0,r.property)({type:Boolean})],p.prototype,"disabled",void 0),c([(0,r.property)()],p.prototype,"color",void 0),p=c([(0,s.customElement)("wui-link")],p),t.s([],472945)},174776,t=>{"use strict";t.i(839432),t.s([])},801461,t=>{"use strict";t.i(588984);var e,i,r=t.i(399702),o=t.i(872857);t.i(759703);var a=t.i(392074),s=t.i(698797),n=t.i(660506),l=t.i(207176),c=t.i(301847),p=t.i(881936),u=t.i(944411),d=t.i(375054),h=t.i(557618),g=t.i(355376);t.i(302184);var w=t.i(414737),y=t.i(938559);t.i(237029),t.i(174776),t.i(472945),t.i(331658);var v=r;t.i(781840);var f=t.i(86988);t.i(630572),t.i(596548),t.i(108476);var m=t.i(864429);(e=i||(i={})).approve="approved",e.bought="bought",e.borrow="borrowed",e.burn="burnt",e.cancel="canceled",e.claim="claimed",e.deploy="deployed",e.deposit="deposited",e.execute="executed",e.mint="minted",e.receive="received",e.repay="repaid",e.send="sent",e.sell="sold",e.stake="staked",e.trade="swapped",e.unstake="unstaked",e.withdraw="withdrawn";var b=r;t.i(287940),t.i(839432);var x=t.i(118827);let $=x.css`
  :host > wui-flex {
    display: flex;
    justify-content: center;
    align-items: center;
    position: relative;
    width: 40px;
    height: 40px;
    box-shadow: inset 0 0 0 1px var(--wui-color-gray-glass-005);
    background-color: var(--wui-color-gray-glass-005);
  }

  :host > wui-flex wui-image {
    display: block;
  }

  :host > wui-flex,
  :host > wui-flex wui-image,
  .swap-images-container,
  .swap-images-container.nft,
  wui-image.nft {
    border-top-left-radius: var(--local-left-border-radius);
    border-top-right-radius: var(--local-right-border-radius);
    border-bottom-left-radius: var(--local-left-border-radius);
    border-bottom-right-radius: var(--local-right-border-radius);
  }

  wui-icon {
    width: 20px;
    height: 20px;
  }

  wui-icon-box {
    position: absolute;
    right: 0;
    bottom: 0;
    transform: translate(20%, 20%);
  }

  .swap-images-container {
    position: relative;
    width: 40px;
    height: 40px;
    overflow: hidden;
  }

  .swap-images-container wui-image:first-child {
    position: absolute;
    width: 40px;
    height: 40px;
    top: 0;
    left: 0%;
    clip-path: inset(0px calc(50% + 2px) 0px 0%);
  }

  .swap-images-container wui-image:last-child {
    clip-path: inset(0px 0px 0px calc(50% + 2px));
  }
`;var A=function(t,e,i,r){var o,a=arguments.length,s=a<3?e:null===r?r=Object.getOwnPropertyDescriptor(e,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,i,r);else for(var n=t.length-1;n>=0;n--)(o=t[n])&&(s=(a<3?o(s):a>3?o(e,i,s):o(e,i))||s);return a>3&&s&&Object.defineProperty(e,i,s),s};let S=class extends b.LitElement{constructor(){super(...arguments),this.images=[],this.secondImage={type:void 0,url:""}}render(){let[t,e]=this.images,i=t?.type==="NFT",r=e?.url?"NFT"===e.type:i;return this.style.cssText=`
    --local-left-border-radius: ${i?"var(--wui-border-radius-xxs)":"var(--wui-border-radius-s)"};
    --local-right-border-radius: ${r?"var(--wui-border-radius-xxs)":"var(--wui-border-radius-s)"};
    `,o.html`<wui-flex> ${this.templateVisual()} ${this.templateIcon()} </wui-flex>`}templateVisual(){let[t,e]=this.images,i=t?.type;return 2===this.images.length&&(t?.url||e?.url)?o.html`<div class="swap-images-container">
        ${t?.url?o.html`<wui-image src=${t.url} alt="Transaction image"></wui-image>`:null}
        ${e?.url?o.html`<wui-image src=${e.url} alt="Transaction image"></wui-image>`:null}
      </div>`:t?.url?o.html`<wui-image src=${t.url} alt="Transaction image"></wui-image>`:"NFT"===i?o.html`<wui-icon size="inherit" color="fg-200" name="nftPlaceholder"></wui-icon>`:o.html`<wui-icon size="inherit" color="fg-200" name="coinPlaceholder"></wui-icon>`}templateIcon(){let t,e="accent-100";return(t=this.getIcon(),this.status&&(e=this.getStatusColor()),t)?o.html`
      <wui-icon-box
        size="xxs"
        iconColor=${e}
        backgroundColor=${e}
        background="opaque"
        icon=${t}
        ?border=${!0}
        borderColor="wui-color-bg-125"
      ></wui-icon-box>
    `:null}getDirectionIcon(){switch(this.direction){case"in":return"arrowBottom";case"out":return"arrowTop";default:return}}getIcon(){return this.onlyDirectionIcon?this.getDirectionIcon():"trade"===this.type?"swapHorizontalBold":"approve"===this.type?"checkmark":"cancel"===this.type?"close":this.getDirectionIcon()}getStatusColor(){switch(this.status){case"confirmed":return"success-100";case"failed":return"error-100";case"pending":return"inverse-100";default:return"accent-100"}}};S.styles=[$],A([(0,a.property)()],S.prototype,"type",void 0),A([(0,a.property)()],S.prototype,"status",void 0),A([(0,a.property)()],S.prototype,"direction",void 0),A([(0,a.property)({type:Boolean})],S.prototype,"onlyDirectionIcon",void 0),A([(0,a.property)({type:Array})],S.prototype,"images",void 0),A([(0,a.property)({type:Object})],S.prototype,"secondImage",void 0),S=A([(0,y.customElement)("wui-transaction-visual")],S);let C=x.css`
  :host > wui-flex:first-child {
    align-items: center;
    column-gap: var(--wui-spacing-s);
    padding: 6.5px var(--wui-spacing-xs) 6.5px var(--wui-spacing-xs);
    width: 100%;
  }

  :host > wui-flex:first-child wui-text:nth-child(1) {
    text-transform: capitalize;
  }

  wui-transaction-visual {
    width: 40px;
    height: 40px;
  }

  wui-flex {
    flex: 1;
  }

  :host wui-flex wui-flex {
    overflow: hidden;
  }

  :host .description-container wui-text span {
    word-break: break-all;
  }

  :host .description-container wui-text {
    overflow: hidden;
  }

  :host .description-separator-icon {
    margin: 0px 6px;
  }

  :host wui-text > span {
    overflow: hidden;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 1;
  }
`;var k=function(t,e,i,r){var o,a=arguments.length,s=a<3?e:null===r?r=Object.getOwnPropertyDescriptor(e,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,i,r);else for(var n=t.length-1;n>=0;n--)(o=t[n])&&(s=(a<3?o(s):a>3?o(e,i,s):o(e,i))||s);return a>3&&s&&Object.defineProperty(e,i,s),s};let T=class extends v.LitElement{constructor(){super(...arguments),this.type="approve",this.onlyDirectionIcon=!1,this.images=[],this.price=[],this.amount=[],this.symbol=[]}render(){return o.html`
      <wui-flex>
        <wui-transaction-visual
          .status=${this.status}
          direction=${(0,f.ifDefined)(this.direction)}
          type=${this.type}
          onlyDirectionIcon=${(0,f.ifDefined)(this.onlyDirectionIcon)}
          .images=${this.images}
        ></wui-transaction-visual>
        <wui-flex flexDirection="column" gap="3xs">
          <wui-text variant="paragraph-600" color="fg-100">
            ${i[this.type]||this.type}
          </wui-text>
          <wui-flex class="description-container">
            ${this.templateDescription()} ${this.templateSecondDescription()}
          </wui-flex>
        </wui-flex>
        <wui-text variant="micro-700" color="fg-300"><span>${this.date}</span></wui-text>
      </wui-flex>
    `}templateDescription(){let t=this.descriptions?.[0];return t?o.html`
          <wui-text variant="small-500" color="fg-200">
            <span>${t}</span>
          </wui-text>
        `:null}templateSecondDescription(){let t=this.descriptions?.[1];return t?o.html`
          <wui-icon class="description-separator-icon" size="xxs" name="arrowRight"></wui-icon>
          <wui-text variant="small-400" color="fg-200">
            <span>${t}</span>
          </wui-text>
        `:null}};T.styles=[m.resetStyles,C],k([(0,a.property)()],T.prototype,"type",void 0),k([(0,a.property)({type:Array})],T.prototype,"descriptions",void 0),k([(0,a.property)()],T.prototype,"date",void 0),k([(0,a.property)({type:Boolean})],T.prototype,"onlyDirectionIcon",void 0),k([(0,a.property)()],T.prototype,"status",void 0),k([(0,a.property)()],T.prototype,"direction",void 0),k([(0,a.property)({type:Array})],T.prototype,"images",void 0),k([(0,a.property)({type:Array})],T.prototype,"price",void 0),k([(0,a.property)({type:Array})],T.prototype,"amount",void 0),k([(0,a.property)({type:Array})],T.prototype,"symbol",void 0),T=k([(0,y.customElement)("wui-transaction-list-item")],T);var z=r;t.i(846880);let R=x.css`
  :host > wui-flex:first-child {
    column-gap: var(--wui-spacing-s);
    padding: 7px var(--wui-spacing-l) 7px var(--wui-spacing-xs);
    width: 100%;
  }

  wui-flex {
    display: flex;
    flex: 1;
  }
`,j=class extends z.LitElement{render(){return o.html`
      <wui-flex alignItems="center">
        <wui-shimmer width="40px" height="40px"></wui-shimmer>
        <wui-flex flexDirection="column" gap="2xs">
          <wui-shimmer width="72px" height="16px" borderRadius="4xs"></wui-shimmer>
          <wui-shimmer width="148px" height="14px" borderRadius="4xs"></wui-shimmer>
        </wui-flex>
        <wui-shimmer width="24px" height="12px" borderRadius="5xs"></wui-shimmer>
      </wui-flex>
    `}};j.styles=[m.resetStyles,R],j=function(t,e,i,r){var o,a=arguments.length,s=a<3?e:null===r?r=Object.getOwnPropertyDescriptor(e,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,i,r);else for(var n=t.length-1;n>=0;n--)(o=t[n])&&(s=(a<3?o(s):a>3?o(e,i,s):o(e,i))||s);return a>3&&s&&Object.defineProperty(e,i,s),s}([(0,y.customElement)("wui-transaction-list-item-loader")],j);var O=t.i(142844);let _=x.css`
  :host {
    min-height: 100%;
  }

  .group-container[last-group='true'] {
    padding-bottom: var(--wui-spacing-m);
  }

  .contentContainer {
    height: 280px;
  }

  .contentContainer > wui-icon-box {
    width: 40px;
    height: 40px;
    border-radius: var(--wui-border-radius-xxs);
  }

  .contentContainer > .textContent {
    width: 65%;
  }

  .emptyContainer {
    height: 100%;
  }
`;var P=function(t,e,i,r){var o,a=arguments.length,s=a<3?e:null===r?r=Object.getOwnPropertyDescriptor(e,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,i,r);else for(var n=t.length-1;n>=0;n--)(o=t[n])&&(s=(a<3?o(s):a>3?o(e,i,s):o(e,i))||s);return a>3&&s&&Object.defineProperty(e,i,s),s};let D="last-transaction",E=class extends r.LitElement{constructor(){super(),this.unsubscribe=[],this.paginationObserver=void 0,this.page="activity",this.caipAddress=l.ChainController.state.activeCaipAddress,this.transactionsByYear=h.TransactionsController.state.transactionsByYear,this.loading=h.TransactionsController.state.loading,this.empty=h.TransactionsController.state.empty,this.next=h.TransactionsController.state.next,h.TransactionsController.clearCursor(),this.unsubscribe.push(l.ChainController.subscribeKey("activeCaipAddress",t=>{t&&this.caipAddress!==t&&(h.TransactionsController.resetTransactions(),h.TransactionsController.fetchTransactions(t)),this.caipAddress=t}),l.ChainController.subscribeKey("activeCaipNetwork",()=>{this.updateTransactionView()}),h.TransactionsController.subscribe(t=>{this.transactionsByYear=t.transactionsByYear,this.loading=t.loading,this.empty=t.empty,this.next=t.next}))}firstUpdated(){this.updateTransactionView(),this.createPaginationObserver()}updated(){this.setPaginationObserver()}disconnectedCallback(){this.unsubscribe.forEach(t=>t())}render(){return o.html` ${this.empty?null:this.templateTransactionsByYear()}
    ${this.loading?this.templateLoading():null}
    ${!this.loading&&this.empty?this.templateEmpty():null}`}updateTransactionView(){h.TransactionsController.resetTransactions(),this.caipAddress&&h.TransactionsController.fetchTransactions(c.CoreHelperUtil.getPlainAddress(this.caipAddress))}templateTransactionsByYear(){return Object.keys(this.transactionsByYear).sort().reverse().map(t=>{let e=parseInt(t,10),i=Array(12).fill(null).map((t,i)=>({groupTitle:w.TransactionUtil.getTransactionGroupTitle(e,i),transactions:this.transactionsByYear[e]?.[i]})).filter(({transactions:t})=>t).reverse();return i.map(({groupTitle:t,transactions:e},r)=>{let a=r===i.length-1;return e?o.html`
          <wui-flex
            flexDirection="column"
            class="group-container"
            last-group="${a?"true":"false"}"
            data-testid="month-indexes"
          >
            <wui-flex
              alignItems="center"
              flexDirection="row"
              .padding=${["xs","s","s","s"]}
            >
              <wui-text variant="paragraph-500" color="fg-200" data-testid="group-title"
                >${t}</wui-text
              >
            </wui-flex>
            <wui-flex flexDirection="column" gap="xs">
              ${this.templateTransactions(e,a)}
            </wui-flex>
          </wui-flex>
        `:null})})}templateRenderTransaction(t,e){let{date:i,descriptions:r,direction:a,isAllNFT:s,images:n,status:l,transfers:c,type:p}=this.getTransactionListItemProps(t),u=c?.length>1;return c?.length!==2||s?u?c.map((t,r)=>{let a=w.TransactionUtil.getTransferDescription(t),s=e&&r===c.length-1;return o.html` <wui-transaction-list-item
          date=${i}
          direction=${t.direction}
          id=${s&&this.next?D:""}
          status=${l}
          type=${p}
          .onlyDirectionIcon=${!0}
          .images=${[n[r]]}
          .descriptions=${[a]}
        ></wui-transaction-list-item>`}):o.html`
      <wui-transaction-list-item
        date=${i}
        .direction=${a}
        id=${e&&this.next?D:""}
        status=${l}
        type=${p}
        .images=${n}
        .descriptions=${r}
      ></wui-transaction-list-item>
    `:o.html`
        <wui-transaction-list-item
          date=${i}
          .direction=${a}
          id=${e&&this.next?D:""}
          status=${l}
          type=${p}
          .images=${n}
          .descriptions=${r}
        ></wui-transaction-list-item>
      `}templateTransactions(t,e){return t.map((i,r)=>{let a=e&&r===t.length-1;return o.html`${this.templateRenderTransaction(i,a)}`})}emptyStateActivity(){return o.html`<wui-flex
      class="emptyContainer"
      flexGrow="1"
      flexDirection="column"
      justifyContent="center"
      alignItems="center"
      .padding=${["3xl","xl","3xl","xl"]}
      gap="xl"
      data-testid="empty-activity-state"
    >
      <wui-icon-box
        backgroundColor="gray-glass-005"
        background="gray"
        iconColor="fg-200"
        icon="wallet"
        size="lg"
        ?border=${!0}
        borderColor="wui-color-bg-125"
      ></wui-icon-box>
      <wui-flex flexDirection="column" alignItems="center" gap="xs">
        <wui-text align="center" variant="paragraph-500" color="fg-100"
          >No Transactions yet</wui-text
        >
        <wui-text align="center" variant="small-500" color="fg-200"
          >Start trading on dApps <br />
          to grow your wallet!</wui-text
        >
      </wui-flex>
    </wui-flex>`}emptyStateAccount(){return o.html`<wui-flex
      class="contentContainer"
      alignItems="center"
      justifyContent="center"
      flexDirection="column"
      gap="l"
      data-testid="empty-account-state"
    >
      <wui-icon-box
        icon="swapHorizontal"
        size="inherit"
        iconColor="fg-200"
        backgroundColor="fg-200"
        iconSize="lg"
      ></wui-icon-box>
      <wui-flex
        class="textContent"
        gap="xs"
        flexDirection="column"
        justifyContent="center"
        flexDirection="column"
      >
        <wui-text variant="paragraph-500" align="center" color="fg-100">No activity yet</wui-text>
        <wui-text variant="small-400" align="center" color="fg-200"
          >Your next transactions will appear here</wui-text
        >
      </wui-flex>
      <wui-link @click=${this.onReceiveClick.bind(this)}>Trade</wui-link>
    </wui-flex>`}templateEmpty(){return"account"===this.page?o.html`${this.emptyStateAccount()}`:o.html`${this.emptyStateActivity()}`}templateLoading(){return"activity"===this.page?Array(7).fill(o.html` <wui-transaction-list-item-loader></wui-transaction-list-item-loader> `).map(t=>t):null}onReceiveClick(){d.RouterController.push("WalletReceive")}createPaginationObserver(){let{projectId:t}=u.OptionsController.state;this.paginationObserver=new IntersectionObserver(([e])=>{e?.isIntersecting&&!this.loading&&(h.TransactionsController.fetchTransactions(c.CoreHelperUtil.getPlainAddress(this.caipAddress)),p.EventsController.sendEvent({type:"track",event:"LOAD_MORE_TRANSACTIONS",properties:{address:c.CoreHelperUtil.getPlainAddress(this.caipAddress),projectId:t,cursor:this.next,isSmartAccount:(0,g.getPreferredAccountType)(l.ChainController.state.activeChain)===O.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT}}))},{}),this.setPaginationObserver()}setPaginationObserver(){this.paginationObserver?.disconnect();let t=this.shadowRoot?.querySelector(`#${D}`);t&&this.paginationObserver?.observe(t)}getTransactionListItemProps(t){let e=n.DateUtil.formatDate(t?.metadata?.minedAt),i=w.TransactionUtil.getTransactionDescriptions(t),r=t?.transfers,o=t?.transfers?.[0],a=!!o&&t?.transfers?.every(t=>!!t.nft_info),s=w.TransactionUtil.getTransactionImages(r);return{date:e,direction:o?.direction,descriptions:i,isAllNFT:a,images:s,status:t.metadata?.status,transfers:r,type:t.metadata?.operationType}}};E.styles=_,P([(0,a.property)()],E.prototype,"page",void 0),P([(0,s.state)()],E.prototype,"caipAddress",void 0),P([(0,s.state)()],E.prototype,"transactionsByYear",void 0),P([(0,s.state)()],E.prototype,"loading",void 0),P([(0,s.state)()],E.prototype,"empty",void 0),P([(0,s.state)()],E.prototype,"next",void 0),E=P([(0,y.customElement)("w3m-activity-list")],E),t.s([],801461)}]);