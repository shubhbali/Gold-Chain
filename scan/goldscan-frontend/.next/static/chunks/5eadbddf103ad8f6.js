(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,156575,e=>{"use strict";e.i(588984);var t=e.i(399702),a=e.i(872857);e.i(759703);var i=e.i(392074);e.i(596548);var n=e.i(864429),s=e.i(938559),r=e.i(118827);let o=r.css`
  :host {
    position: relative;
    display: flex;
    width: 100%;
    height: 1px;
    background-color: var(--wui-color-gray-glass-005);
    justify-content: center;
    align-items: center;
  }

  :host > wui-text {
    position: absolute;
    padding: 0px 10px;
    background-color: var(--wui-color-modal-bg);
    transition: background-color var(--wui-duration-lg) var(--wui-ease-out-power-1);
    will-change: background-color;
  }
`;var l=function(e,t,a,i){var n,s=arguments.length,r=s<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,a):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)r=Reflect.decorate(e,t,a,i);else for(var o=e.length-1;o>=0;o--)(n=e[o])&&(r=(s<3?n(r):s>3?n(t,a,r):n(t,a))||r);return s>3&&r&&Object.defineProperty(t,a,r),r};let c=class extends t.LitElement{constructor(){super(...arguments),this.text=""}render(){return a.html`${this.template()}`}template(){return this.text?a.html`<wui-text variant="small-500" color="fg-200">${this.text}</wui-text>`:null}};c.styles=[n.resetStyles,o],l([(0,i.property)()],c.prototype,"text",void 0),c=l([(0,s.customElement)("wui-separator")],c),e.s([],156575)},353612,e=>{"use strict";e.i(588984);var t=e.i(399702),a=e.i(872857);e.i(759703);var i=e.i(392074),n=e.i(864429),s=e.i(938559),r=e.i(118827);let o=r.css`
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
`;var l=function(e,t,a,i){var n,s=arguments.length,r=s<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,a):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)r=Reflect.decorate(e,t,a,i);else for(var o=e.length-1;o>=0;o--)(n=e[o])&&(r=(s<3?n(r):s>3?n(t,a,r):n(t,a))||r);return s>3&&r&&Object.defineProperty(t,a,r),r};let c=class extends t.LitElement{constructor(){super(...arguments),this.radius=36}render(){return this.svgLoaderTemplate()}svgLoaderTemplate(){let e=this.radius>50?50:this.radius,t=36-e;return a.html`
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
    `}};c.styles=[n.resetStyles,o],l([(0,i.property)({type:Number})],c.prototype,"radius",void 0),c=l([(0,s.customElement)("wui-loading-thumbnail")],c),e.s([],353612)},162085,e=>{"use strict";e.i(588984);var t=e.i(399702),a=e.i(872857);e.i(759703);var i=e.i(392074);e.i(781840);var n=e.i(86988);e.i(630572),e.i(287940),e.i(829162),e.i(596548),e.i(108476);var s=e.i(864429),r=e.i(938559);e.i(839432);var o=e.i(118827);let l=o.css`
  button {
    column-gap: var(--wui-spacing-s);
    padding: 11px 18px 11px var(--wui-spacing-s);
    width: 100%;
    background-color: var(--wui-color-gray-glass-002);
    border-radius: var(--wui-border-radius-xs);
    color: var(--wui-color-fg-250);
    transition:
      color var(--wui-ease-out-power-1) var(--wui-duration-md),
      background-color var(--wui-ease-out-power-1) var(--wui-duration-md);
    will-change: color, background-color;
  }

  button[data-iconvariant='square'],
  button[data-iconvariant='square-blue'] {
    padding: 6px 18px 6px 9px;
  }

  button > wui-flex {
    flex: 1;
  }

  button > wui-image {
    width: 32px;
    height: 32px;
    box-shadow: 0 0 0 2px var(--wui-color-gray-glass-005);
    border-radius: var(--wui-border-radius-3xl);
  }

  button > wui-icon {
    width: 36px;
    height: 36px;
    transition: opacity var(--wui-ease-out-power-1) var(--wui-duration-md);
    will-change: opacity;
  }

  button > wui-icon-box[data-variant='blue'] {
    box-shadow: 0 0 0 2px var(--wui-color-accent-glass-005);
  }

  button > wui-icon-box[data-variant='overlay'] {
    box-shadow: 0 0 0 2px var(--wui-color-gray-glass-005);
  }

  button > wui-icon-box[data-variant='square-blue'] {
    border-radius: var(--wui-border-radius-3xs);
    position: relative;
    border: none;
    width: 36px;
    height: 36px;
  }

  button > wui-icon-box[data-variant='square-blue']::after {
    content: '';
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    border-radius: inherit;
    border: 1px solid var(--wui-color-accent-glass-010);
    pointer-events: none;
  }

  button > wui-icon:last-child {
    width: 14px;
    height: 14px;
  }

  button:disabled {
    color: var(--wui-color-gray-glass-020);
  }

  button[data-loading='true'] > wui-icon {
    opacity: 0;
  }

  wui-loading-spinner {
    position: absolute;
    right: 18px;
    top: 50%;
    transform: translateY(-50%);
  }
`;var c=function(e,t,a,i){var n,s=arguments.length,r=s<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,a):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)r=Reflect.decorate(e,t,a,i);else for(var o=e.length-1;o>=0;o--)(n=e[o])&&(r=(s<3?n(r):s>3?n(t,a,r):n(t,a))||r);return s>3&&r&&Object.defineProperty(t,a,r),r};let u=class extends t.LitElement{constructor(){super(...arguments),this.tabIdx=void 0,this.variant="icon",this.disabled=!1,this.imageSrc=void 0,this.alt=void 0,this.chevron=!1,this.loading=!1}render(){return a.html`
      <button
        ?disabled=${!!this.loading||!!this.disabled}
        data-loading=${this.loading}
        data-iconvariant=${(0,n.ifDefined)(this.iconVariant)}
        tabindex=${(0,n.ifDefined)(this.tabIdx)}
      >
        ${this.loadingTemplate()} ${this.visualTemplate()}
        <wui-flex gap="3xs">
          <slot></slot>
        </wui-flex>
        ${this.chevronTemplate()}
      </button>
    `}visualTemplate(){if("image"===this.variant&&this.imageSrc)return a.html`<wui-image src=${this.imageSrc} alt=${this.alt??"list item"}></wui-image>`;if("square"===this.iconVariant&&this.icon&&"icon"===this.variant)return a.html`<wui-icon name=${this.icon}></wui-icon>`;if("icon"===this.variant&&this.icon&&this.iconVariant){let e=["blue","square-blue"].includes(this.iconVariant)?"accent-100":"fg-200",t="square-blue"===this.iconVariant?"mdl":"md",i=this.iconSize?this.iconSize:t;return a.html`
        <wui-icon-box
          data-variant=${this.iconVariant}
          icon=${this.icon}
          iconSize=${i}
          background="transparent"
          iconColor=${e}
          backgroundColor=${e}
          size=${t}
        ></wui-icon-box>
      `}return null}loadingTemplate(){return this.loading?a.html`<wui-loading-spinner
        data-testid="wui-list-item-loading-spinner"
        color="fg-300"
      ></wui-loading-spinner>`:a.html``}chevronTemplate(){return this.chevron?a.html`<wui-icon size="inherit" color="fg-200" name="chevronRight"></wui-icon>`:null}};u.styles=[s.resetStyles,s.elementStyles,l],c([(0,i.property)()],u.prototype,"icon",void 0),c([(0,i.property)()],u.prototype,"iconSize",void 0),c([(0,i.property)()],u.prototype,"tabIdx",void 0),c([(0,i.property)()],u.prototype,"variant",void 0),c([(0,i.property)()],u.prototype,"iconVariant",void 0),c([(0,i.property)({type:Boolean})],u.prototype,"disabled",void 0),c([(0,i.property)()],u.prototype,"imageSrc",void 0),c([(0,i.property)()],u.prototype,"alt",void 0),c([(0,i.property)({type:Boolean})],u.prototype,"chevron",void 0),c([(0,i.property)({type:Boolean})],u.prototype,"loading",void 0),u=c([(0,r.customElement)("wui-list-item")],u),e.s([],162085)},274071,e=>{"use strict";e.i(588984);var t=e.i(399702),a=e.i(872857);e.i(759703);var i=e.i(392074);e.i(630572);var n=e.i(864429),s=e.i(938559),r=e.i(118827);let o=r.css`
  :host {
    position: relative;
  }

  button {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 48px;
    width: 100%;
    background-color: var(--wui-color-accent-glass-010);
    border-radius: var(--wui-border-radius-xs);
    border: 1px solid var(--wui-color-accent-glass-010);
    transition: background-color var(--wui-ease-out-power-1) var(--wui-duration-md);
    will-change: background-color;
  }

  wui-tooltip {
    padding: 7px var(--wui-spacing-s) 8px var(--wui-spacing-s);
    position: absolute;
    top: -8px;
    left: 50%;
    transform: translate(-50%, -100%);
    opacity: 0;
    display: none;
  }

  @media (hover: hover) and (pointer: fine) {
    button:hover:enabled {
      background-color: var(--wui-color-accent-glass-015);
    }

    button:active:enabled {
      background-color: var(--wui-color-accent-glass-020);
    }
  }
`;var l=function(e,t,a,i){var n,s=arguments.length,r=s<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,a):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)r=Reflect.decorate(e,t,a,i);else for(var o=e.length-1;o>=0;o--)(n=e[o])&&(r=(s<3?n(r):s>3?n(t,a,r):n(t,a))||r);return s>3&&r&&Object.defineProperty(t,a,r),r};let c=class extends t.LitElement{constructor(){super(...arguments),this.text="",this.icon="card"}render(){return a.html`<button>
      <wui-icon color="accent-100" name=${this.icon} size="lg"></wui-icon>
    </button>`}};c.styles=[n.resetStyles,n.elementStyles,o],l([(0,i.property)()],c.prototype,"text",void 0),l([(0,i.property)()],c.prototype,"icon",void 0),c=l([(0,s.customElement)("wui-icon-button")],c),e.s([],274071)},152076,e=>{"use strict";e.i(588984);var t=e.i(872857);let a=t.svg`<svg width="86" height="96" fill="none">
  <path
    d="M78.3244 18.926L50.1808 2.45078C45.7376 -0.150261 40.2624 -0.150262 35.8192 2.45078L7.6756 18.926C3.23322 21.5266 0.5 26.3301 0.5 31.5248V64.4752C0.5 69.6699 3.23322 74.4734 7.6756 77.074L35.8192 93.5492C40.2624 96.1503 45.7376 96.1503 50.1808 93.5492L78.3244 77.074C82.7668 74.4734 85.5 69.6699 85.5 64.4752V31.5248C85.5 26.3301 82.7668 21.5266 78.3244 18.926Z"
  />
</svg>`;e.s(["networkSvgLg",0,a])},493416,e=>{"use strict";e.i(588984);var t=e.i(872857);let a=t.svg`<svg  viewBox="0 0 48 54" fill="none">
  <path
    d="M43.4605 10.7248L28.0485 1.61089C25.5438 0.129705 22.4562 0.129705 19.9515 1.61088L4.53951 10.7248C2.03626 12.2051 0.5 14.9365 0.5 17.886V36.1139C0.5 39.0635 2.03626 41.7949 4.53951 43.2752L19.9515 52.3891C22.4562 53.8703 25.5438 53.8703 28.0485 52.3891L43.4605 43.2752C45.9637 41.7949 47.5 39.0635 47.5 36.114V17.8861C47.5 14.9365 45.9637 12.2051 43.4605 10.7248Z"
  />
</svg>`;e.s(["networkSvgMd",0,a])},894687,200964,e=>{"use strict";e.i(588984);var t=e.i(399702),a=e.i(872857);e.i(759703);var i=e.i(392074),n=e.i(152076),s=e.i(493416);let r=a.svg`
  <svg fill="none" viewBox="0 0 36 40">
    <path
      d="M15.4 2.1a5.21 5.21 0 0 1 5.2 0l11.61 6.7a5.21 5.21 0 0 1 2.61 4.52v13.4c0 1.87-1 3.59-2.6 4.52l-11.61 6.7c-1.62.93-3.6.93-5.22 0l-11.6-6.7a5.21 5.21 0 0 1-2.61-4.51v-13.4c0-1.87 1-3.6 2.6-4.52L15.4 2.1Z"
    />
  </svg>
`;e.i(630572),e.i(287940);var o=e.i(864429),l=e.i(938559),c=e.i(118827);let u=c.css`
  :host {
    position: relative;
    border-radius: inherit;
    display: flex;
    justify-content: center;
    align-items: center;
    width: var(--local-width);
    height: var(--local-height);
  }

  :host([data-round='true']) {
    background: var(--wui-color-gray-glass-002);
    border-radius: 100%;
    outline: 1px solid var(--wui-color-gray-glass-005);
  }

  svg {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 1;
    fill: var(--wui-color-gray-glass-002);
  }

  svg > path {
    stroke: var(--local-stroke);
  }

  wui-image {
    width: 100%;
    height: 100%;
    -webkit-clip-path: var(--local-path);
    clip-path: var(--local-path);
    background: var(--wui-color-gray-glass-002);
  }

  wui-icon {
    transform: translateY(-5%);
    width: var(--local-icon-size);
    height: var(--local-icon-size);
  }
`;var h=function(e,t,a,i){var n,s=arguments.length,r=s<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,a):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)r=Reflect.decorate(e,t,a,i);else for(var o=e.length-1;o>=0;o--)(n=e[o])&&(r=(s<3?n(r):s>3?n(t,a,r):n(t,a))||r);return s>3&&r&&Object.defineProperty(t,a,r),r};let d=class extends t.LitElement{constructor(){super(...arguments),this.size="md",this.name="uknown",this.networkImagesBySize={sm:r,md:s.networkSvgMd,lg:n.networkSvgLg},this.selected=!1,this.round=!1}render(){return this.round?(this.dataset.round="true",this.style.cssText=`
      --local-width: var(--wui-spacing-3xl);
      --local-height: var(--wui-spacing-3xl);
      --local-icon-size: var(--wui-spacing-l);
    `):this.style.cssText=`

      --local-path: var(--wui-path-network-${this.size});
      --local-width:  var(--wui-width-network-${this.size});
      --local-height:  var(--wui-height-network-${this.size});
      --local-icon-size:  var(--wui-icon-size-network-${this.size});
    `,a.html`${this.templateVisual()} ${this.svgTemplate()} `}svgTemplate(){return this.round?null:this.networkImagesBySize[this.size]}templateVisual(){return this.imageSrc?a.html`<wui-image src=${this.imageSrc} alt=${this.name}></wui-image>`:a.html`<wui-icon size="inherit" color="fg-200" name="networkPlaceholder"></wui-icon>`}};d.styles=[o.resetStyles,u],h([(0,i.property)()],d.prototype,"size",void 0),h([(0,i.property)()],d.prototype,"name",void 0),h([(0,i.property)({type:Object})],d.prototype,"networkImagesBySize",void 0),h([(0,i.property)()],d.prototype,"imageSrc",void 0),h([(0,i.property)({type:Boolean})],d.prototype,"selected",void 0),h([(0,i.property)({type:Boolean})],d.prototype,"round",void 0),d=h([(0,l.customElement)("wui-network-image")],d),e.s([],200964),e.s([],894687)},662541,e=>{"use strict";e.i(588984);var t=e.i(399702),a=e.i(872857);e.i(759703);var i=e.i(392074);e.i(630572),e.i(287940),e.i(108476);var n=e.i(864429),s=e.i(938559);e.i(839432);var r=e.i(118827);let o=r.css`
  :host {
    position: relative;
    background-color: var(--wui-color-gray-glass-002);
    display: flex;
    justify-content: center;
    align-items: center;
    width: var(--local-size);
    height: var(--local-size);
    border-radius: inherit;
    border-radius: var(--local-border-radius);
  }

  :host > wui-flex {
    overflow: hidden;
    border-radius: inherit;
    border-radius: var(--local-border-radius);
  }

  :host::after {
    content: '';
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    border-radius: inherit;
    border: 1px solid var(--wui-color-gray-glass-010);
    pointer-events: none;
  }

  :host([name='Extension'])::after {
    border: 1px solid var(--wui-color-accent-glass-010);
  }

  :host([data-wallet-icon='allWallets']) {
    background-color: var(--wui-all-wallets-bg-100);
  }

  :host([data-wallet-icon='allWallets'])::after {
    border: 1px solid var(--wui-color-accent-glass-010);
  }

  wui-icon[data-parent-size='inherit'] {
    width: 75%;
    height: 75%;
    align-items: center;
  }

  wui-icon[data-parent-size='sm'] {
    width: 18px;
    height: 18px;
  }

  wui-icon[data-parent-size='md'] {
    width: 24px;
    height: 24px;
  }

  wui-icon[data-parent-size='lg'] {
    width: 42px;
    height: 42px;
  }

  wui-icon[data-parent-size='full'] {
    width: 100%;
    height: 100%;
  }

  :host > wui-icon-box {
    position: absolute;
    overflow: hidden;
    right: -1px;
    bottom: -2px;
    z-index: 1;
    border: 2px solid var(--wui-color-bg-150, #1e1f1f);
    padding: 1px;
  }
`;var l=function(e,t,a,i){var n,s=arguments.length,r=s<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,a):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)r=Reflect.decorate(e,t,a,i);else for(var o=e.length-1;o>=0;o--)(n=e[o])&&(r=(s<3?n(r):s>3?n(t,a,r):n(t,a))||r);return s>3&&r&&Object.defineProperty(t,a,r),r};let c=class extends t.LitElement{constructor(){super(...arguments),this.size="md",this.name="",this.installed=!1,this.badgeSize="xs"}render(){let e="xxs";return e="lg"===this.size?"m":"md"===this.size?"xs":"xxs",this.style.cssText=`
       --local-border-radius: var(--wui-border-radius-${e});
       --local-size: var(--wui-wallet-image-size-${this.size});
   `,this.walletIcon&&(this.dataset.walletIcon=this.walletIcon),a.html`
      <wui-flex justifyContent="center" alignItems="center"> ${this.templateVisual()} </wui-flex>
    `}templateVisual(){return this.imageSrc?a.html`<wui-image src=${this.imageSrc} alt=${this.name}></wui-image>`:this.walletIcon?a.html`<wui-icon
        data-parent-size="md"
        size="md"
        color="inherit"
        name=${this.walletIcon}
      ></wui-icon>`:a.html`<wui-icon
      data-parent-size=${this.size}
      size="inherit"
      color="inherit"
      name="walletPlaceholder"
    ></wui-icon>`}};c.styles=[n.elementStyles,n.resetStyles,o],l([(0,i.property)()],c.prototype,"size",void 0),l([(0,i.property)()],c.prototype,"name",void 0),l([(0,i.property)()],c.prototype,"imageSrc",void 0),l([(0,i.property)()],c.prototype,"walletIcon",void 0),l([(0,i.property)({type:Boolean})],c.prototype,"installed",void 0),l([(0,i.property)()],c.prototype,"badgeSize",void 0),c=l([(0,s.customElement)("wui-wallet-image")],c),e.s([],662541)},830976,e=>{"use strict";e.i(662541),e.s([])},476604,e=>{"use strict";e.i(287940),e.s([])},322703,e=>{"use strict";e.i(588984);var t=e.i(399702),a=e.i(872857);e.i(759703);var i=e.i(698797);e.i(781840);var n=e.i(86988),s=e.i(596590),r=e.i(207176),o=e.i(11961),l=e.i(301847),c=e.i(945182),u=e.i(944396);e.i(302184);var h=e.i(938559);e.i(81981),e.i(237029),e.i(982221),e.i(274071),e.i(679556),e.i(476604),e.i(162085),e.i(609247),e.i(894687),e.i(156575),e.i(331658),e.i(830976);var d=e.i(725519),p=e.i(941031),m=e.i(138230),w=e.i(222328),g=e.i(881936),y=e.i(375054),f=e.i(859192);let v="INVALID_PAYMENT_CONFIG",b="INVALID_RECIPIENT",x="INVALID_ASSET",P="INVALID_AMOUNT",k="UNABLE_TO_INITIATE_PAYMENT",C="INVALID_CHAIN_NAMESPACE",S="GENERIC_PAYMENT_ERROR",E="UNABLE_TO_GET_EXCHANGES",I="ASSET_NOT_SUPPORTED",A="UNABLE_TO_GET_PAY_URL",j="UNABLE_TO_GET_BUY_STATUS",T={[v]:"Invalid payment configuration",[b]:"Invalid recipient address",[x]:"Invalid asset specified",[P]:"Invalid payment amount",UNKNOWN_ERROR:"Unknown payment error occurred",[k]:"Unable to initiate payment",[C]:"Invalid chain namespace",[S]:"Unable to process payment",[E]:"Unable to get exchanges",[I]:"Asset not supported by the selected exchange",[A]:"Unable to get payment URL",[j]:"Unable to get buy status"};class U extends Error{get message(){return T[this.code]}constructor(e,t){super(T[e]),this.name="AppKitPayError",this.code=e,this.details=t,Error.captureStackTrace&&Error.captureStackTrace(this,U)}}var N=e.i(944411);class D extends Error{}async function $(e,t){let a,i=(a=N.OptionsController.getSnapshot().projectId,`https://rpc.walletconnect.org/v1/json-rpc?projectId=${a}`),{sdkType:n,sdkVersion:s,projectId:r}=N.OptionsController.getSnapshot(),o={jsonrpc:"2.0",id:1,method:e,params:{...t||{},st:n,sv:s,projectId:r}},l=await fetch(i,{method:"POST",body:JSON.stringify(o),headers:{"Content-Type":"application/json"}}),c=await l.json();if(c.error)throw new D(c.error.message);return c}async function R(e){return(await $("reown_getExchanges",e)).result}async function z(e){return(await $("reown_getExchangePayUrl",e)).result}async function O(e){return(await $("reown_getExchangeBuyStatus",e)).result}let L=["eip155","solana"],_={eip155:{native:{assetNamespace:"slip44",assetReference:"60"},defaultTokenNamespace:"erc20"},solana:{native:{assetNamespace:"slip44",assetReference:"501"},defaultTokenNamespace:"token"}};function M(e,t){let{chainNamespace:a,chainId:i}=w.ParseUtil.parseCaipNetworkId(e),n=_[a];if(!n)throw Error(`Unsupported chain namespace for CAIP-19 formatting: ${a}`);let s=n.native.assetNamespace,r=n.native.assetReference;"native"!==t&&(s=n.defaultTokenNamespace,r=t);let o=`${a}:${i}`;return`${o}/${s}:${r}`}var W=e.i(279327);async function V(e){let{paymentAssetNetwork:t,activeCaipNetwork:a,approvedCaipNetworkIds:i,requestedCaipNetworks:n}=e,s=l.CoreHelperUtil.sortRequestedNetworks(i,n).find(e=>e.caipNetworkId===t);if(!s)throw new U(v);if(s.caipNetworkId===a.caipNetworkId)return;let o=r.ChainController.getNetworkProp("supportsAllNetworks",s.chainNamespace);if(!(i?.includes(s.caipNetworkId)||o))throw new U(v);try{await r.ChainController.switchActiveNetwork(s)}catch(e){throw new U(S,e)}}async function B(e,t,a){if(t!==m.ConstantsUtil.CHAIN.EVM)throw new U(C);if(!a.fromAddress)throw new U(v,"fromAddress is required for native EVM payments.");let i="string"==typeof a.amount?parseFloat(a.amount):a.amount;if(isNaN(i))throw new U(v);let n=e.metadata?.decimals??18,s=o.ConnectionController.parseUnits(i.toString(),n);if("bigint"!=typeof s)throw new U(S);return await o.ConnectionController.sendTransaction({chainNamespace:t,to:a.recipient,address:a.fromAddress,value:s,data:"0x"})??void 0}async function H(e,t){if(!t.fromAddress)throw new U(v,"fromAddress is required for ERC20 EVM payments.");let a=e.asset,i=t.recipient,n=Number(e.metadata.decimals),s=o.ConnectionController.parseUnits(t.amount.toString(),n);if(void 0===s)throw new U(S);return await o.ConnectionController.writeContract({fromAddress:t.fromAddress,tokenAddress:a,args:[i,s],method:"transfer",abi:W.ContractUtil.getERC20Abi(a),chainNamespace:m.ConstantsUtil.CHAIN.EVM})??void 0}async function Y(e,t){if(e!==m.ConstantsUtil.CHAIN.SOLANA)throw new U(C);if(!t.fromAddress)throw new U(v,"fromAddress is required for Solana payments.");let a="string"==typeof t.amount?parseFloat(t.amount):t.amount;if(isNaN(a)||a<=0)throw new U(v,"Invalid payment amount.");try{if(!f.ProviderUtil.getProvider(e))throw new U(S,"No Solana provider available.");let i=await o.ConnectionController.sendTransaction({chainNamespace:m.ConstantsUtil.CHAIN.SOLANA,to:t.recipient,value:a,tokenMint:t.tokenMint});if(!i)throw new U(S,"Transaction failed.");return i}catch(e){if(e instanceof U)throw e;throw new U(S,`Solana payment failed: ${e}`)}}let F="unknown",q=(0,d.proxy)({paymentAsset:{network:"eip155:1",asset:"0x0",metadata:{name:"0x0",symbol:"0x0",decimals:0}},recipient:"0x0",amount:0,isConfigured:!1,error:null,isPaymentInProgress:!1,exchanges:[],isLoading:!1,openInNewTab:!0,redirectUrl:void 0,payWithExchange:void 0,currentPayment:void 0,analyticsSet:!1,paymentId:void 0}),K={state:q,subscribe:e=>(0,d.subscribe)(q,()=>e(q)),subscribeKey:(e,t)=>(0,p.subscribeKey)(q,e,t),async handleOpenPay(e){this.resetState(),this.setPaymentConfig(e),this.subscribeEvents(),this.initializeAnalytics(),q.isConfigured=!0,g.EventsController.sendEvent({type:"track",event:"PAY_MODAL_OPEN",properties:{exchanges:q.exchanges,configuration:{network:q.paymentAsset.network,asset:q.paymentAsset.asset,recipient:q.recipient,amount:q.amount}}}),await c.ModalController.open({view:"Pay"})},resetState(){q.paymentAsset={network:"eip155:1",asset:"0x0",metadata:{name:"0x0",symbol:"0x0",decimals:0}},q.recipient="0x0",q.amount=0,q.isConfigured=!1,q.error=null,q.isPaymentInProgress=!1,q.isLoading=!1,q.currentPayment=void 0},setPaymentConfig(e){if(!e.paymentAsset)throw new U(v);try{q.paymentAsset=e.paymentAsset,q.recipient=e.recipient,q.amount=e.amount,q.openInNewTab=e.openInNewTab??!0,q.redirectUrl=e.redirectUrl,q.payWithExchange=e.payWithExchange,q.error=null}catch(e){throw new U(v,e.message)}},getPaymentAsset:()=>q.paymentAsset,getExchanges:()=>q.exchanges,async fetchExchanges(){try{q.isLoading=!0;let e=await R({page:0,asset:M(q.paymentAsset.network,q.paymentAsset.asset),amount:q.amount.toString()});q.exchanges=e.exchanges.slice(0,2)}catch(e){throw u.SnackController.showError(T.UNABLE_TO_GET_EXCHANGES),new U(E)}finally{q.isLoading=!1}},async getAvailableExchanges(e){try{let t=e?.asset&&e?.network?M(e.network,e.asset):void 0;return await R({page:e?.page??0,asset:t,amount:e?.amount?.toString()})}catch(e){throw new U(E)}},async getPayUrl(e,t,a=!1){try{let i=Number(t.amount),n=await z({exchangeId:e,asset:M(t.network,t.asset),amount:i.toString(),recipient:`${t.network}:${t.recipient}`});return g.EventsController.sendEvent({type:"track",event:"PAY_EXCHANGE_SELECTED",properties:{source:"pay",exchange:{id:e},configuration:{network:t.network,asset:t.asset,recipient:t.recipient,amount:i},currentPayment:{type:"exchange",exchangeId:e},headless:a}}),a&&(this.initiatePayment(),g.EventsController.sendEvent({type:"track",event:"PAY_INITIATED",properties:{source:"pay",paymentId:q.paymentId||F,configuration:{network:t.network,asset:t.asset,recipient:t.recipient,amount:i},currentPayment:{type:"exchange",exchangeId:e}}})),n}catch(e){if(e instanceof Error&&e.message.includes("is not supported"))throw new U(I);throw Error(e.message)}},async openPayUrl(e,t,a=!1){try{let i=await this.getPayUrl(e.exchangeId,t,a);if(!i)throw new U(A);let n=e.openInNewTab??!0;return l.CoreHelperUtil.openHref(i.url,n?"_blank":"_self"),i}catch(e){throw e instanceof U?q.error=e.message:q.error=T.GENERIC_PAYMENT_ERROR,new U(A)}},subscribeEvents(){q.isConfigured||(o.ConnectionController.subscribeKey("connections",e=>{e.size>0&&this.handlePayment()}),s.AccountController.subscribeKey("caipAddress",e=>{let t=o.ConnectionController.hasAnyConnection(m.ConstantsUtil.CONNECTOR_ID.WALLET_CONNECT);e&&(t?setTimeout(()=>{this.handlePayment()},100):this.handlePayment())}))},async handlePayment(){q.currentPayment={type:"wallet",status:"IN_PROGRESS"};let e=s.AccountController.state.caipAddress;if(!e)return;let{chainId:t,address:a}=w.ParseUtil.parseCaipAddress(e),i=r.ChainController.state.activeChain;if(!a||!t||!i||!f.ProviderUtil.getProvider(i))return;let n=r.ChainController.state.activeCaipNetwork;if(n&&!q.isPaymentInProgress)try{this.initiatePayment();let e=r.ChainController.getAllRequestedCaipNetworks(),t=r.ChainController.getAllApprovedCaipNetworkIds();switch(await V({paymentAssetNetwork:q.paymentAsset.network,activeCaipNetwork:n,approvedCaipNetworkIds:t,requestedCaipNetworks:e}),await c.ModalController.open({view:"PayLoading"}),i){case m.ConstantsUtil.CHAIN.EVM:"native"===q.paymentAsset.asset&&(q.currentPayment.result=await B(q.paymentAsset,i,{recipient:q.recipient,amount:q.amount,fromAddress:a})),q.paymentAsset.asset.startsWith("0x")&&(q.currentPayment.result=await H(q.paymentAsset,{recipient:q.recipient,amount:q.amount,fromAddress:a})),q.currentPayment.status="SUCCESS";break;case m.ConstantsUtil.CHAIN.SOLANA:q.currentPayment.result=await Y(i,{recipient:q.recipient,amount:q.amount,fromAddress:a,tokenMint:"native"===q.paymentAsset.asset?void 0:q.paymentAsset.asset}),q.currentPayment.status="SUCCESS";break;default:throw new U(C)}}catch(e){e instanceof U?q.error=e.message:q.error=T.GENERIC_PAYMENT_ERROR,q.currentPayment.status="FAILED",u.SnackController.showError(q.error)}finally{q.isPaymentInProgress=!1}},getExchangeById:e=>q.exchanges.find(t=>t.id===e),validatePayConfig(e){let{paymentAsset:t,recipient:a,amount:i}=e;if(!t)throw new U(v);if(!a)throw new U(b);if(!t.asset)throw new U(x);if(null==i||i<=0)throw new U(P)},handlePayWithWallet(){let e=s.AccountController.state.caipAddress;if(!e)return void y.RouterController.push("Connect");let{chainId:t,address:a}=w.ParseUtil.parseCaipAddress(e),i=r.ChainController.state.activeChain;a&&t&&i?this.handlePayment():y.RouterController.push("Connect")},async handlePayWithExchange(e){try{q.currentPayment={type:"exchange",exchangeId:e};let{network:t,asset:a}=q.paymentAsset,i={network:t,asset:a,amount:q.amount,recipient:q.recipient},n=await this.getPayUrl(e,i);if(!n)throw new U(k);return q.currentPayment.sessionId=n.sessionId,q.currentPayment.status="IN_PROGRESS",q.currentPayment.exchangeId=e,this.initiatePayment(),{url:n.url,openInNewTab:q.openInNewTab}}catch(e){return e instanceof U?q.error=e.message:q.error=T.GENERIC_PAYMENT_ERROR,q.isPaymentInProgress=!1,u.SnackController.showError(q.error),null}},async getBuyStatus(e,t){try{let a=await O({sessionId:t,exchangeId:e});return("SUCCESS"===a.status||"FAILED"===a.status)&&g.EventsController.sendEvent({type:"track",event:"SUCCESS"===a.status?"PAY_SUCCESS":"PAY_ERROR",properties:{source:"pay",paymentId:q.paymentId||F,configuration:{network:q.paymentAsset.network,asset:q.paymentAsset.asset,recipient:q.recipient,amount:q.amount},currentPayment:{type:"exchange",exchangeId:q.currentPayment?.exchangeId,sessionId:q.currentPayment?.sessionId,result:a.txHash}}}),a}catch(e){throw new U(j)}},async updateBuyStatus(e,t){try{let a=await this.getBuyStatus(e,t);q.currentPayment&&(q.currentPayment.status=a.status,q.currentPayment.result=a.txHash),("SUCCESS"===a.status||"FAILED"===a.status)&&(q.isPaymentInProgress=!1)}catch(e){throw new U(j)}},initiatePayment(){q.isPaymentInProgress=!0,q.paymentId=crypto.randomUUID()},initializeAnalytics(){q.analyticsSet||(q.analyticsSet=!0,this.subscribeKey("isPaymentInProgress",e=>{if(q.currentPayment?.status&&"UNKNOWN"!==q.currentPayment.status){let e={IN_PROGRESS:"PAY_INITIATED",SUCCESS:"PAY_SUCCESS",FAILED:"PAY_ERROR"}[q.currentPayment.status];g.EventsController.sendEvent({type:"track",event:e,properties:{source:"pay",paymentId:q.paymentId||F,configuration:{network:q.paymentAsset.network,asset:q.paymentAsset.asset,recipient:q.recipient,amount:q.amount},currentPayment:{type:q.currentPayment.type,exchangeId:q.currentPayment.exchangeId,sessionId:q.currentPayment.sessionId,result:q.currentPayment.result}}})}}))}};var G=e.i(118827);let Z=G.css`
  wui-separator {
    margin: var(--wui-spacing-m) calc(var(--wui-spacing-m) * -1) var(--wui-spacing-xs)
      calc(var(--wui-spacing-m) * -1);
    width: calc(100% + var(--wui-spacing-s) * 2);
  }

  .token-display {
    padding: var(--wui-spacing-s) var(--wui-spacing-m);
    border-radius: var(--wui-border-radius-s);
    background-color: var(--wui-color-bg-125);
    margin-top: var(--wui-spacing-s);
    margin-bottom: var(--wui-spacing-s);
  }

  .token-display wui-text {
    text-transform: none;
  }

  wui-loading-spinner {
    padding: var(--wui-spacing-xs);
  }
`;var J=function(e,t,a,i){var n,s=arguments.length,r=s<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,a):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)r=Reflect.decorate(e,t,a,i);else for(var o=e.length-1;o>=0;o--)(n=e[o])&&(r=(s<3?n(r):s>3?n(t,a,r):n(t,a))||r);return s>3&&r&&Object.defineProperty(t,a,r),r};let X=class extends t.LitElement{constructor(){super(),this.unsubscribe=[],this.amount="",this.tokenSymbol="",this.networkName="",this.exchanges=K.state.exchanges,this.isLoading=K.state.isLoading,this.loadingExchangeId=null,this.connectedWalletInfo=s.AccountController.state.connectedWalletInfo,this.initializePaymentDetails(),this.unsubscribe.push(K.subscribeKey("exchanges",e=>this.exchanges=e)),this.unsubscribe.push(K.subscribeKey("isLoading",e=>this.isLoading=e)),this.unsubscribe.push(s.AccountController.subscribe(e=>this.connectedWalletInfo=e.connectedWalletInfo)),K.fetchExchanges()}get isWalletConnected(){return"connected"===s.AccountController.state.status}render(){return a.html`
      <wui-flex flexDirection="column">
        <wui-flex flexDirection="column" .padding=${["0","l","l","l"]} gap="s">
          ${this.renderPaymentHeader()}

          <wui-flex flexDirection="column" gap="s">
            ${this.renderPayWithWallet()} ${this.renderExchangeOptions()}
          </wui-flex>
        </wui-flex>
      </wui-flex>
    `}initializePaymentDetails(){let e=K.getPaymentAsset();this.networkName=e.network,this.tokenSymbol=e.metadata.symbol,this.amount=K.state.amount.toString()}renderPayWithWallet(){return!function(e){let{chainNamespace:t}=w.ParseUtil.parseCaipNetworkId(e);return L.includes(t)}(this.networkName)?a.html``:a.html`<wui-flex flexDirection="column" gap="s">
        ${this.isWalletConnected?this.renderConnectedView():this.renderDisconnectedView()}
      </wui-flex>
      <wui-separator text="or"></wui-separator>`}renderPaymentHeader(){let e=this.networkName;if(this.networkName){let t=r.ChainController.getAllRequestedCaipNetworks().find(e=>e.caipNetworkId===this.networkName);t&&(e=t.name)}return a.html`
      <wui-flex flexDirection="column" alignItems="center">
        <wui-flex alignItems="center" gap="xs">
          <wui-text variant="large-700" color="fg-100">${this.amount||"0.0000"}</wui-text>
          <wui-flex class="token-display" alignItems="center" gap="xxs">
            <wui-text variant="paragraph-600" color="fg-100">
              ${this.tokenSymbol||"Unknown Asset"}
            </wui-text>
            ${e?a.html`
                  <wui-text variant="small-500" color="fg-200"> on ${e} </wui-text>
                `:""}
          </wui-flex>
        </wui-flex>
      </wui-flex>
    `}renderConnectedView(){let e=this.connectedWalletInfo?.name||"connected wallet";return a.html`
      <wui-list-item
        @click=${this.onWalletPayment}
        ?chevron=${!0}
        data-testid="wallet-payment-option"
      >
        <wui-flex alignItems="center" gap="s">
          <wui-wallet-image
            size="sm"
            imageSrc=${(0,n.ifDefined)(this.connectedWalletInfo?.icon)}
            name=${(0,n.ifDefined)(this.connectedWalletInfo?.name)}
          ></wui-wallet-image>
          <wui-text variant="paragraph-500" color="inherit">Pay with ${e}</wui-text>
        </wui-flex>
      </wui-list-item>

      <wui-list-item
        variant="icon"
        iconVariant="overlay"
        icon="disconnect"
        @click=${this.onDisconnect}
        data-testid="disconnect-button"
        ?chevron=${!1}
      >
        <wui-text variant="paragraph-500" color="fg-200">Disconnect</wui-text>
      </wui-list-item>
    `}renderDisconnectedView(){return a.html`<wui-list-item
      variant="icon"
      iconVariant="overlay"
      icon="walletPlaceholder"
      @click=${this.onWalletPayment}
      ?chevron=${!0}
      data-testid="wallet-payment-option"
    >
      <wui-text variant="paragraph-500" color="inherit">Pay from wallet</wui-text>
    </wui-list-item>`}renderExchangeOptions(){return this.isLoading?a.html`<wui-flex justifyContent="center" alignItems="center">
        <wui-spinner size="md"></wui-spinner>
      </wui-flex>`:0===this.exchanges.length?a.html`<wui-flex justifyContent="center" alignItems="center">
        <wui-text variant="paragraph-500" color="fg-100">No exchanges available</wui-text>
      </wui-flex>`:this.exchanges.map(e=>a.html`
        <wui-list-item
          @click=${()=>this.onExchangePayment(e.id)}
          data-testid="exchange-option-${e.id}"
          ?chevron=${!0}
          ?disabled=${null!==this.loadingExchangeId}
        >
          <wui-flex alignItems="center" gap="s">
            ${this.loadingExchangeId===e.id?a.html`<wui-loading-spinner color="accent-100" size="md"></wui-loading-spinner>`:a.html`<wui-wallet-image
                  size="sm"
                  imageSrc=${(0,n.ifDefined)(e.imageUrl)}
                  name=${e.name}
                ></wui-wallet-image>`}
            <wui-text flexGrow="1" variant="paragraph-500" color="inherit"
              >Pay with ${e.name} <wui-spinner size="sm" color="fg-200"></wui-spinner
            ></wui-text>
          </wui-flex>
        </wui-list-item>
      `)}onWalletPayment(){K.handlePayWithWallet()}async onExchangePayment(e){try{this.loadingExchangeId=e;let t=await K.handlePayWithExchange(e);t&&(await c.ModalController.open({view:"PayLoading"}),l.CoreHelperUtil.openHref(t.url,t.openInNewTab?"_blank":"_self"))}catch(e){console.error("Failed to pay with exchange",e),u.SnackController.showError("Failed to pay with exchange")}finally{this.loadingExchangeId=null}}async onDisconnect(e){e.stopPropagation();try{await o.ConnectionController.disconnect()}catch{console.error("Failed to disconnect"),u.SnackController.showError("Failed to disconnect")}}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}};X.styles=Z,J([(0,i.state)()],X.prototype,"amount",void 0),J([(0,i.state)()],X.prototype,"tokenSymbol",void 0),J([(0,i.state)()],X.prototype,"networkName",void 0),J([(0,i.state)()],X.prototype,"exchanges",void 0),J([(0,i.state)()],X.prototype,"isLoading",void 0),J([(0,i.state)()],X.prototype,"loadingExchangeId",void 0),J([(0,i.state)()],X.prototype,"connectedWalletInfo",void 0),X=J([(0,h.customElement)("w3m-pay-view")],X),e.s(["W3mPayView",()=>X],513912);var Q=t,ee=e.i(589408),et=e.i(729702),ea=e.i(880985);e.i(353612);let ei=G.css`
  :host {
    display: block;
    height: 100%;
    width: 100%;
  }

  wui-flex:first-child:not(:only-child) {
    position: relative;
  }

  wui-loading-thumbnail {
    position: absolute;
  }
`;var en=function(e,t,a,i){var n,s=arguments.length,r=s<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,a):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)r=Reflect.decorate(e,t,a,i);else for(var o=e.length-1;o>=0;o--)(n=e[o])&&(r=(s<3?n(r):s>3?n(t,a,r):n(t,a))||r);return s>3&&r&&Object.defineProperty(t,a,r),r};let es=class extends Q.LitElement{constructor(){super(),this.loadingMessage="",this.subMessage="",this.paymentState="in-progress",this.paymentState=K.state.isPaymentInProgress?"in-progress":"completed",this.updateMessages(),this.setupSubscription(),this.setupExchangeSubscription()}disconnectedCallback(){clearInterval(this.exchangeSubscription)}render(){return a.html`
      <wui-flex
        flexDirection="column"
        alignItems="center"
        .padding=${["xl","xl","xl","xl"]}
        gap="xl"
      >
        <wui-flex justifyContent="center" alignItems="center"> ${this.getStateIcon()} </wui-flex>
        <wui-flex flexDirection="column" alignItems="center" gap="xs">
          <wui-text align="center" variant="paragraph-500" color="fg-100">
            ${this.loadingMessage}
          </wui-text>
          <wui-text align="center" variant="small-400" color="fg-200">
            ${this.subMessage}
          </wui-text>
        </wui-flex>
      </wui-flex>
    `}updateMessages(){switch(this.paymentState){case"completed":this.loadingMessage="Payment completed",this.subMessage="Your transaction has been successfully processed";break;case"error":this.loadingMessage="Payment failed",this.subMessage="There was an error processing your transaction";break;default:K.state.currentPayment?.type==="exchange"?(this.loadingMessage="Payment initiated",this.subMessage="Please complete the payment on the exchange"):(this.loadingMessage="Awaiting payment confirmation",this.subMessage="Please confirm the payment transaction in your wallet")}}getStateIcon(){switch(this.paymentState){case"completed":return this.successTemplate();case"error":return this.errorTemplate();default:return this.loaderTemplate()}}setupExchangeSubscription(){K.state.currentPayment?.type==="exchange"&&(this.exchangeSubscription=setInterval(async()=>{let e=K.state.currentPayment?.exchangeId,t=K.state.currentPayment?.sessionId;e&&t&&(await K.updateBuyStatus(e,t),K.state.currentPayment?.status==="SUCCESS"&&clearInterval(this.exchangeSubscription))},4e3))}setupSubscription(){K.subscribeKey("isPaymentInProgress",e=>{e||"in-progress"!==this.paymentState||(K.state.error||!K.state.currentPayment?.result?this.paymentState="error":this.paymentState="completed",this.updateMessages(),setTimeout(()=>{"disconnected"!==o.ConnectionController.state.status&&c.ModalController.close()},3e3))}),K.subscribeKey("error",e=>{e&&"in-progress"===this.paymentState&&(this.paymentState="error",this.updateMessages())})}loaderTemplate(){let e=ea.ThemeController.state.themeVariables["--w3m-border-radius-master"],t=e?parseInt(e.replace("px",""),10):4,i=this.getPaymentIcon();return a.html`
      <wui-flex justifyContent="center" alignItems="center" style="position: relative;">
        ${i?a.html`<wui-wallet-image size="lg" imageSrc=${i}></wui-wallet-image>`:null}
        <wui-loading-thumbnail radius=${9*t}></wui-loading-thumbnail>
      </wui-flex>
    `}getPaymentIcon(){let e=K.state.currentPayment;if(e){if("exchange"===e.type){let t=e.exchangeId;if(t){let e=K.getExchangeById(t);return e?.imageUrl}}if("wallet"===e.type){let e=s.AccountController.state.connectedWalletInfo?.icon;if(e)return e;let t=r.ChainController.state.activeChain;if(!t)return;let a=et.ConnectorController.getConnectorId(t);if(!a)return;let i=et.ConnectorController.getConnectorById(a);if(!i)return;return ee.AssetUtil.getConnectorImage(i)}}}successTemplate(){return a.html`<wui-icon size="xl" color="success-100" name="checkmark"></wui-icon>`}errorTemplate(){return a.html`<wui-icon size="xl" color="error-100" name="close"></wui-icon>`}};async function er(e){return K.handleOpenPay(e)}async function eo(e,t=3e5){if(t<=0)throw new U(v,"Timeout must be greater than 0");try{await er(e)}catch(e){if(e instanceof U)throw e;throw new U(k,e.message)}return new Promise((e,a)=>{var i;let n=!1,s=setTimeout(()=>{n||(n=!0,o(),a(new U(S,"Payment timeout")))},t);function r(){if(n)return;let t=K.state.currentPayment,a=K.state.error,i=K.state.isPaymentInProgress;if(t?.status==="SUCCESS"){n=!0,o(),clearTimeout(s),e({success:!0,result:t.result});return}if(t?.status==="FAILED"){n=!0,o(),clearTimeout(s),e({success:!1,error:a||"Payment failed"});return}!a||i||t||(n=!0,o(),clearTimeout(s),e({success:!1,error:a}))}let o=(i=[ed("currentPayment",r),ed("error",r),ed("isPaymentInProgress",r)],()=>{i.forEach(e=>{try{e()}catch{}})});r()})}function el(){return K.getExchanges()}function ec(){return K.state.currentPayment?.result}function eu(){return K.state.error}function eh(){return K.state.isPaymentInProgress}function ed(e,t){return K.subscribeKey(e,t)}es.styles=ei,en([(0,i.state)()],es.prototype,"loadingMessage",void 0),en([(0,i.state)()],es.prototype,"subMessage",void 0),en([(0,i.state)()],es.prototype,"paymentState",void 0),es=en([(0,h.customElement)("w3m-pay-loading-view")],es),e.s(["W3mPayLoadingView",()=>es],973742);let ep={network:"eip155:8453",asset:"native",metadata:{name:"Ethereum",symbol:"ETH",decimals:18}},em={network:"eip155:8453",asset:"0x833589fcd6edb6e08f4c7c32d4f71b54bda02913",metadata:{name:"USD Coin",symbol:"USDC",decimals:6}},ew={network:"eip155:84532",asset:"native",metadata:{name:"Ethereum",symbol:"ETH",decimals:18}},eg={network:"eip155:1",asset:"0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",metadata:{name:"USD Coin",symbol:"USDC",decimals:6}},ey={network:"eip155:10",asset:"0x0b2c639c533813f4aa9d7837caf62653d097ff85",metadata:{name:"USD Coin",symbol:"USDC",decimals:6}},ef={network:"eip155:42161",asset:"0xaf88d065e77c8cC2239327C5EDb3A432268e5831",metadata:{name:"USD Coin",symbol:"USDC",decimals:6}},ev={network:"eip155:137",asset:"0x3c499c542cef5e3811e1192ce70d8cc03d5c3359",metadata:{name:"USD Coin",symbol:"USDC",decimals:6}},eb={network:"solana:5eykt4UsFv8P8NJdTREpY1vzqKqZKvdp",asset:"EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v",metadata:{name:"USD Coin",symbol:"USDC",decimals:6}},ex={network:"eip155:1",asset:"0xdAC17F958D2ee523a2206206994597C13D831ec7",metadata:{name:"Tether USD",symbol:"USDT",decimals:6}},eP={network:"eip155:10",asset:"0x94b008aA00579c1307B0EF2c499aD98a8ce58e58",metadata:{name:"Tether USD",symbol:"USDT",decimals:6}},ek={network:"eip155:42161",asset:"0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9",metadata:{name:"Tether USD",symbol:"USDT",decimals:6}},eC={network:"eip155:137",asset:"0xc2132d05d31c914a87c6611c10748aeb04b58e8f",metadata:{name:"Tether USD",symbol:"USDT",decimals:6}},eS={network:"solana:5eykt4UsFv8P8NJdTREpY1vzqKqZKvdp",asset:"Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB",metadata:{name:"Tether USD",symbol:"USDT",decimals:6}},eE={network:"solana:5eykt4UsFv8P8NJdTREpY1vzqKqZKvdp",asset:"native",metadata:{name:"Solana",symbol:"SOL",decimals:9}};e.s(["arbitrumUSDC",0,ef,"arbitrumUSDT",0,ek,"baseETH",0,ep,"baseSepoliaETH",0,ew,"baseUSDC",0,em,"ethereumUSDC",0,eg,"ethereumUSDT",0,ex,"optimismUSDC",0,ey,"optimismUSDT",0,eP,"polygonUSDC",0,ev,"polygonUSDT",0,eC,"solanaSOL",0,eE,"solanaUSDC",0,eb,"solanaUSDT",0,eS],462977),e.s([],263992),e.i(263992),e.i(513912),e.i(973742),e.i(462977),e.s(["W3mPayLoadingView",()=>es,"W3mPayView",()=>X,"arbitrumUSDC",0,ef,"arbitrumUSDT",0,ek,"baseETH",0,ep,"baseSepoliaETH",0,ew,"baseUSDC",0,em,"ethereumUSDC",0,eg,"ethereumUSDT",0,ex,"getExchanges",()=>el,"getIsPaymentInProgress",()=>eh,"getPayError",()=>eu,"getPayResult",()=>ec,"openPay",()=>er,"optimismUSDC",0,ey,"optimismUSDT",0,eP,"pay",()=>eo,"polygonUSDC",0,ev,"polygonUSDT",0,eC,"solanaSOL",0,eE,"solanaUSDC",0,eb,"solanaUSDT",0,eS],322703)},370120,e=>{e.v(t=>Promise.all(["static/chunks/26e0a8e49472e8b2.js"].map(t=>e.l(t))).then(()=>t(907496)))},101594,e=>{e.v(t=>Promise.all(["static/chunks/97923f7a558363e7.js"].map(t=>e.l(t))).then(()=>t(111408)))},53619,e=>{e.v(t=>Promise.all(["static/chunks/d2d95687802cc51a.js"].map(t=>e.l(t))).then(()=>t(945285)))},647729,e=>{e.v(t=>Promise.all(["static/chunks/b9333ed8ed5db8d8.js"].map(t=>e.l(t))).then(()=>t(503272)))},42060,e=>{e.v(t=>Promise.all(["static/chunks/63e0528672c9261d.js"].map(t=>e.l(t))).then(()=>t(418817)))},646255,e=>{e.v(t=>Promise.all(["static/chunks/c41b751c0d58294f.js"].map(t=>e.l(t))).then(()=>t(509808)))},27402,e=>{e.v(t=>Promise.all(["static/chunks/f56269ce9627e4eb.js"].map(t=>e.l(t))).then(()=>t(609450)))},242317,e=>{e.v(t=>Promise.all(["static/chunks/c25bafba4e65b9d9.js"].map(t=>e.l(t))).then(()=>t(805544)))},189728,e=>{e.v(t=>Promise.all(["static/chunks/1c17bb6d6b722db7.js"].map(t=>e.l(t))).then(()=>t(39234)))},933805,e=>{e.v(t=>Promise.all(["static/chunks/eec4c7518d5ef1b7.js"].map(t=>e.l(t))).then(()=>t(83012)))},306521,e=>{e.v(t=>Promise.all(["static/chunks/c7ea8683df715cf9.js"].map(t=>e.l(t))).then(()=>t(153401)))},529497,e=>{e.v(t=>Promise.all(["static/chunks/e49251e635894a10.js"].map(t=>e.l(t))).then(()=>t(912290)))},821462,e=>{e.v(t=>Promise.all(["static/chunks/faa73acfb705c2af.js"].map(t=>e.l(t))).then(()=>t(81778)))},576367,e=>{e.v(t=>Promise.all(["static/chunks/4047e10b7e0020db.js"].map(t=>e.l(t))).then(()=>t(441939)))},719175,e=>{e.v(t=>Promise.all(["static/chunks/c8d13ffd8cb258f2.js"].map(t=>e.l(t))).then(()=>t(136442)))},585172,e=>{e.v(t=>Promise.all(["static/chunks/af37e47fd05aff94.js"].map(t=>e.l(t))).then(()=>t(376835)))},660404,e=>{e.v(t=>Promise.all(["static/chunks/4923abb4f10984df.js"].map(t=>e.l(t))).then(()=>t(622164)))},656661,e=>{e.v(t=>Promise.all(["static/chunks/9335ff44e74a1319.js"].map(t=>e.l(t))).then(()=>t(677958)))},115985,e=>{e.v(t=>Promise.all(["static/chunks/2f33c53c900a30f0.js"].map(t=>e.l(t))).then(()=>t(263541)))},798562,e=>{e.v(t=>Promise.all(["static/chunks/b7b39b35bc8e37e7.js"].map(t=>e.l(t))).then(()=>t(127098)))},995740,e=>{e.v(t=>Promise.all(["static/chunks/e023d779fabed8ba.js"].map(t=>e.l(t))).then(()=>t(466451)))},392121,e=>{e.v(t=>Promise.all(["static/chunks/bd3f5a87bd76ddf2.js"].map(t=>e.l(t))).then(()=>t(917665)))},954007,e=>{e.v(t=>Promise.all(["static/chunks/28f045a8aea535ed.js"].map(t=>e.l(t))).then(()=>t(685345)))},510739,e=>{e.v(t=>Promise.all(["static/chunks/1ce8b24df6c38238.js"].map(t=>e.l(t))).then(()=>t(922360)))},518349,e=>{e.v(t=>Promise.all(["static/chunks/abff0b62e58a0623.js"].map(t=>e.l(t))).then(()=>t(183250)))},23210,e=>{e.v(t=>Promise.all(["static/chunks/d590609f31b2b6f2.js"].map(t=>e.l(t))).then(()=>t(449291)))},69872,e=>{e.v(t=>Promise.all(["static/chunks/a90386f31e65e7c6.js"].map(t=>e.l(t))).then(()=>t(606784)))},473425,e=>{e.v(t=>Promise.all(["static/chunks/f6ce4ba8446e5b4e.js"].map(t=>e.l(t))).then(()=>t(699844)))},86124,e=>{e.v(t=>Promise.all(["static/chunks/ca0c357681404336.js"].map(t=>e.l(t))).then(()=>t(11252)))},449547,e=>{e.v(t=>Promise.all(["static/chunks/66de8be4c4f97e40.js"].map(t=>e.l(t))).then(()=>t(886888)))},107380,e=>{e.v(t=>Promise.all(["static/chunks/6786c08fb6566531.js"].map(t=>e.l(t))).then(()=>t(31913)))},417532,e=>{e.v(t=>Promise.all(["static/chunks/4c3dd4391186697a.js"].map(t=>e.l(t))).then(()=>t(165607)))},400114,e=>{e.v(t=>Promise.all(["static/chunks/e875ff35e86f2cd4.js"].map(t=>e.l(t))).then(()=>t(839832)))},371013,e=>{e.v(t=>Promise.all(["static/chunks/d5ef2cd1d5f0ce31.js"].map(t=>e.l(t))).then(()=>t(306387)))},592346,e=>{e.v(t=>Promise.all(["static/chunks/0b53bfb3dd94b07e.js"].map(t=>e.l(t))).then(()=>t(905711)))},692886,e=>{e.v(t=>Promise.all(["static/chunks/cc38ee16a99c453d.js"].map(t=>e.l(t))).then(()=>t(288445)))},559568,e=>{e.v(t=>Promise.all(["static/chunks/8893cb0dd5e75428.js"].map(t=>e.l(t))).then(()=>t(52422)))},727099,e=>{e.v(t=>Promise.all(["static/chunks/be85831826444acc.js"].map(t=>e.l(t))).then(()=>t(873099)))},106183,e=>{e.v(t=>Promise.all(["static/chunks/33ac89a1fcda0ac9.js"].map(t=>e.l(t))).then(()=>t(28900)))},276516,e=>{e.v(t=>Promise.all(["static/chunks/1f16ba9408c624e2.js"].map(t=>e.l(t))).then(()=>t(554519)))},526211,e=>{e.v(t=>Promise.all(["static/chunks/398933b68cf253b0.js"].map(t=>e.l(t))).then(()=>t(938626)))},377532,e=>{e.v(t=>Promise.all(["static/chunks/76a249fc4d7468f3.js"].map(t=>e.l(t))).then(()=>t(583927)))},146719,e=>{e.v(t=>Promise.all(["static/chunks/fc0ab7c2b70600a0.js"].map(t=>e.l(t))).then(()=>t(790998)))},343268,e=>{e.v(t=>Promise.all(["static/chunks/59373d2a49f83685.js"].map(t=>e.l(t))).then(()=>t(428068)))},921373,e=>{e.v(t=>Promise.all(["static/chunks/e523dcfe0a640736.js"].map(t=>e.l(t))).then(()=>t(127251)))},114361,e=>{e.v(t=>Promise.all(["static/chunks/1ddd2185911125ed.js"].map(t=>e.l(t))).then(()=>t(198663)))},978898,e=>{e.v(t=>Promise.all(["static/chunks/422223ea541cc4ec.js"].map(t=>e.l(t))).then(()=>t(969846)))},497619,e=>{e.v(t=>Promise.all(["static/chunks/ae8f8bf14344cd0f.js"].map(t=>e.l(t))).then(()=>t(879809)))},99077,e=>{e.v(t=>Promise.all(["static/chunks/4afd407365684745.js"].map(t=>e.l(t))).then(()=>t(706888)))},999971,e=>{e.v(t=>Promise.all(["static/chunks/b9e5b4b0b40b4966.js"].map(t=>e.l(t))).then(()=>t(954962)))},14879,e=>{e.v(t=>Promise.all(["static/chunks/03ed00251b9f8f96.js"].map(t=>e.l(t))).then(()=>t(494536)))},187203,e=>{e.v(t=>Promise.all(["static/chunks/9331bedf749a8b03.js"].map(t=>e.l(t))).then(()=>t(210924)))},517776,e=>{e.v(t=>Promise.all(["static/chunks/3fe1020423119ecd.js"].map(t=>e.l(t))).then(()=>t(705976)))},98067,e=>{e.v(t=>Promise.all(["static/chunks/8ee0a99124a40521.js"].map(t=>e.l(t))).then(()=>t(403692)))},180529,e=>{e.v(t=>Promise.all(["static/chunks/c0ffd2c02e3b49f9.js"].map(t=>e.l(t))).then(()=>t(356216)))},33772,e=>{e.v(t=>Promise.all(["static/chunks/c26fa44e80d4552b.js"].map(t=>e.l(t))).then(()=>t(354159)))},612617,e=>{e.v(t=>Promise.all(["static/chunks/2800c4437d7ec1c8.js"].map(t=>e.l(t))).then(()=>t(981722)))},99078,e=>{e.v(t=>Promise.all(["static/chunks/18b5586311477356.js"].map(t=>e.l(t))).then(()=>t(879190)))},484585,e=>{e.v(t=>Promise.all(["static/chunks/24678d38918cff86.js"].map(t=>e.l(t))).then(()=>t(390585)))},766513,e=>{e.v(t=>Promise.all(["static/chunks/b4f4414200774c70.js"].map(t=>e.l(t))).then(()=>t(856636)))},682754,e=>{e.v(t=>Promise.all(["static/chunks/20a8a0f412961150.js"].map(t=>e.l(t))).then(()=>t(703951)))},219316,e=>{e.v(t=>Promise.all(["static/chunks/5d1a1b0db1f6f280.js"].map(t=>e.l(t))).then(()=>t(961511)))},277176,e=>{e.v(t=>Promise.all(["static/chunks/63b01ab668891c59.js"].map(t=>e.l(t))).then(()=>t(355495)))},560377,e=>{e.v(t=>Promise.all(["static/chunks/a73126aecb5194b1.js"].map(t=>e.l(t))).then(()=>t(699252)))},461996,e=>{e.v(t=>Promise.all(["static/chunks/014ac0ae0eb0d977.js"].map(t=>e.l(t))).then(()=>t(595684)))},760084,e=>{e.v(t=>Promise.all(["static/chunks/3d2cf405c5be67f1.js"].map(t=>e.l(t))).then(()=>t(821645)))},23765,e=>{e.v(t=>Promise.all(["static/chunks/19daf80189af3cb5.js"].map(t=>e.l(t))).then(()=>t(669874)))},669065,e=>{e.v(t=>Promise.all(["static/chunks/39c5ab3d449138ef.js"].map(t=>e.l(t))).then(()=>t(756209)))},137985,e=>{e.v(t=>Promise.all(["static/chunks/a96e5b3c0bcf745a.js"].map(t=>e.l(t))).then(()=>t(862181)))},984531,e=>{e.v(t=>Promise.all(["static/chunks/7e2b21a05f35e2fb.js"].map(t=>e.l(t))).then(()=>t(654201)))},14671,e=>{e.v(t=>Promise.all(["static/chunks/2e833c4f8897d285.js"].map(t=>e.l(t))).then(()=>t(400433)))},661706,e=>{e.v(t=>Promise.all(["static/chunks/9d7994b2925eedff.js"].map(t=>e.l(t))).then(()=>t(406011)))},808545,e=>{e.v(t=>Promise.all(["static/chunks/c12e7e357bd73885.js"].map(t=>e.l(t))).then(()=>t(590802)))},86125,e=>{e.v(t=>Promise.all(["static/chunks/6674dde5fce56b90.js"].map(t=>e.l(t))).then(()=>t(127530)))},25054,e=>{e.v(t=>Promise.all(["static/chunks/5f43b8de108d82a8.js"].map(t=>e.l(t))).then(()=>t(404202)))},189409,e=>{e.v(t=>Promise.all(["static/chunks/04c3bd1cc3433abb.js"].map(t=>e.l(t))).then(()=>t(838366)))},105736,e=>{e.v(t=>Promise.all(["static/chunks/3ab13667b822299a.js"].map(t=>e.l(t))).then(()=>t(511626)))},75220,e=>{e.v(t=>Promise.all(["static/chunks/136b1b881256e27c.js"].map(t=>e.l(t))).then(()=>t(981111)))},164632,e=>{e.v(t=>Promise.all(["static/chunks/27a0455f9ed4cbe2.js"].map(t=>e.l(t))).then(()=>t(235153)))},6768,e=>{e.v(t=>Promise.all(["static/chunks/65b36f3821731273.js"].map(t=>e.l(t))).then(()=>t(614051)))},82206,e=>{e.v(t=>Promise.all(["static/chunks/cd86ccbd9d28ee36.js"].map(t=>e.l(t))).then(()=>t(56751)))},458662,e=>{e.v(t=>Promise.all(["static/chunks/ae5b22bbf1fab4fc.js"].map(t=>e.l(t))).then(()=>t(972606)))},405625,e=>{e.v(t=>Promise.all(["static/chunks/42b23260469ed281.js"].map(t=>e.l(t))).then(()=>t(56717)))}]);