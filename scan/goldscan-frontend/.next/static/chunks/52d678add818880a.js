(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,679556,282969,e=>{"use strict";e.i(588984);var t=e.i(399702),a=e.i(872857);e.i(759703);var i=e.i(392074);e.i(630572);var s=e.i(864429),r=e.i(938559),o=e.i(118827);let n=o.css`
  button {
    border-radius: var(--local-border-radius);
    color: var(--wui-color-fg-100);
    padding: var(--local-padding);
  }

  @media (max-width: 700px) {
    :host(:not([size='sm'])) button {
      padding: var(--wui-spacing-s);
    }
  }

  button > wui-icon {
    pointer-events: none;
  }

  button:disabled > wui-icon {
    color: var(--wui-color-bg-300) !important;
  }

  button:disabled {
    background-color: transparent;
  }

  button:hover:not(:disabled) {
    background-color: var(--wui-color-accent-glass-015);
  }

  button:focus-visible:not(:disabled) {
    background-color: var(--wui-color-accent-glass-015);
    box-shadow:
      inset 0 0 0 1px var(--wui-color-accent-100),
      0 0 0 4px var(--wui-color-accent-glass-020);
  }
`;var l=function(e,t,a,i){var s,r=arguments.length,o=r<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,a):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)o=Reflect.decorate(e,t,a,i);else for(var n=e.length-1;n>=0;n--)(s=e[n])&&(o=(r<3?s(o):r>3?s(t,a,o):s(t,a))||o);return r>3&&o&&Object.defineProperty(t,a,o),o};let c=class extends t.LitElement{constructor(){super(...arguments),this.size="md",this.disabled=!1,this.icon="copy",this.iconColor="inherit"}render(){this.dataset.size=this.size;let e="",t="";switch(this.size){case"lg":e="--wui-border-radius-xs",t="--wui-spacing-1xs";break;case"sm":e="--wui-border-radius-3xs",t="--wui-spacing-xxs";break;default:e="--wui-border-radius-xxs",t="--wui-spacing-2xs"}return this.style.cssText=`
    --local-border-radius: var(${e});
    --local-padding: var(${t});
    `,a.html`
      <button ?disabled=${this.disabled}>
        <wui-icon color=${this.iconColor} size=${this.size} name=${this.icon}></wui-icon>
      </button>
    `}};c.styles=[s.resetStyles,s.elementStyles,s.colorStyles,n],l([(0,i.property)()],c.prototype,"size",void 0),l([(0,i.property)({type:Boolean})],c.prototype,"disabled",void 0),l([(0,i.property)()],c.prototype,"icon",void 0),l([(0,i.property)()],c.prototype,"iconColor",void 0),c=l([(0,r.customElement)("wui-icon-link")],c),e.s([],282969),e.s([],679556)},990237,185212,e=>{"use strict";e.i(588984);var t=e.i(399702),a=e.i(872857);e.i(759703);var i=e.i(392074);e.i(596548);var s=e.i(864429),r=e.i(938559),o=e.i(118827);let n=o.css`
  :host {
    display: flex;
    justify-content: center;
    align-items: center;
    height: var(--wui-spacing-m);
    padding: 0 var(--wui-spacing-3xs) !important;
    border-radius: var(--wui-border-radius-5xs);
    transition:
      border-radius var(--wui-duration-lg) var(--wui-ease-out-power-1),
      background-color var(--wui-duration-lg) var(--wui-ease-out-power-1);
    will-change: border-radius, background-color;
  }

  :host > wui-text {
    transform: translateY(5%);
  }

  :host([data-variant='main']) {
    background-color: var(--wui-color-accent-glass-015);
    color: var(--wui-color-accent-100);
  }

  :host([data-variant='shade']) {
    background-color: var(--wui-color-gray-glass-010);
    color: var(--wui-color-fg-200);
  }

  :host([data-variant='success']) {
    background-color: var(--wui-icon-box-bg-success-100);
    color: var(--wui-color-success-100);
  }

  :host([data-variant='error']) {
    background-color: var(--wui-icon-box-bg-error-100);
    color: var(--wui-color-error-100);
  }

  :host([data-size='lg']) {
    padding: 11px 5px !important;
  }

  :host([data-size='lg']) > wui-text {
    transform: translateY(2%);
  }

  :host([data-size='xs']) {
    height: var(--wui-spacing-2l);
    padding: 0 var(--wui-spacing-3xs) !important;
  }

  :host([data-size='xs']) > wui-text {
    transform: translateY(2%);
  }
`;var l=function(e,t,a,i){var s,r=arguments.length,o=r<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,a):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)o=Reflect.decorate(e,t,a,i);else for(var n=e.length-1;n>=0;n--)(s=e[n])&&(o=(r<3?s(o):r>3?s(t,a,o):s(t,a))||o);return r>3&&o&&Object.defineProperty(t,a,o),o};let c=class extends t.LitElement{constructor(){super(...arguments),this.variant="main",this.size="lg"}render(){this.dataset.variant=this.variant,this.dataset.size=this.size;let e="md"===this.size||"xs"===this.size?"mini-700":"micro-700";return a.html`
      <wui-text data-variant=${this.variant} variant=${e} color="inherit">
        <slot></slot>
      </wui-text>
    `}};c.styles=[s.resetStyles,n],l([(0,i.property)()],c.prototype,"variant",void 0),l([(0,i.property)()],c.prototype,"size",void 0),c=l([(0,r.customElement)("wui-tag")],c),e.s([],185212),e.s([],990237)},510290,e=>{"use strict";e.i(588984);var t=e.i(399702),a=e.i(872857);e.i(759703);var i=e.i(392074);e.i(630572),e.i(287940),e.i(596548);var s=e.i(864429),r=e.i(34691),o=e.i(938559),n=e.i(118827);let l=n.css`
  a {
    border: 1px solid var(--wui-color-gray-glass-010);
    border-radius: var(--wui-border-radius-3xl);
  }

  wui-image {
    border-radius: var(--wui-border-radius-3xl);
    overflow: hidden;
  }

  a.disabled > wui-icon:not(.image-icon),
  a.disabled > wui-image {
    filter: grayscale(1);
  }

  a[data-variant='fill'] {
    color: var(--wui-color-inverse-100);
    background-color: var(--wui-color-accent-100);
  }

  a[data-variant='shade'],
  a[data-variant='shadeSmall'] {
    background-color: transparent;
    background-color: var(--wui-color-gray-glass-010);
    color: var(--wui-color-fg-200);
  }

  a[data-variant='success'] {
    column-gap: var(--wui-spacing-xxs);
    border: 1px solid var(--wui-color-success-glass-010);
    background-color: var(--wui-color-success-glass-010);
    color: var(--wui-color-success-100);
  }

  a[data-variant='error'] {
    column-gap: var(--wui-spacing-xxs);
    border: 1px solid var(--wui-color-error-glass-010);
    background-color: var(--wui-color-error-glass-010);
    color: var(--wui-color-error-100);
  }

  a[data-variant='transparent'] {
    column-gap: var(--wui-spacing-xxs);
    background-color: transparent;
    color: var(--wui-color-fg-150);
  }

  a[data-variant='transparent'],
  a[data-variant='success'],
  a[data-variant='shadeSmall'],
  a[data-variant='error'] {
    padding: 7px var(--wui-spacing-s) 7px 10px;
  }

  a[data-variant='transparent']:has(wui-text:first-child),
  a[data-variant='success']:has(wui-text:first-child),
  a[data-variant='shadeSmall']:has(wui-text:first-child),
  a[data-variant='error']:has(wui-text:first-child) {
    padding: 7px var(--wui-spacing-s);
  }

  a[data-variant='fill'],
  a[data-variant='shade'] {
    column-gap: var(--wui-spacing-xs);
    padding: var(--wui-spacing-xxs) var(--wui-spacing-m) var(--wui-spacing-xxs)
      var(--wui-spacing-xs);
  }

  a[data-variant='fill']:has(wui-text:first-child),
  a[data-variant='shade']:has(wui-text:first-child) {
    padding: 9px var(--wui-spacing-m) 9px var(--wui-spacing-m);
  }

  a[data-variant='fill'] > wui-image,
  a[data-variant='shade'] > wui-image {
    width: 24px;
    height: 24px;
  }

  a[data-variant='fill'] > wui-image {
    box-shadow: inset 0 0 0 1px var(--wui-color-accent-090);
  }

  a[data-variant='shade'] > wui-image,
  a[data-variant='shadeSmall'] > wui-image {
    box-shadow: inset 0 0 0 1px var(--wui-color-gray-glass-010);
  }

  a[data-variant='fill'] > wui-icon:not(.image-icon),
  a[data-variant='shade'] > wui-icon:not(.image-icon) {
    width: 14px;
    height: 14px;
  }

  a[data-variant='transparent'] > wui-image,
  a[data-variant='success'] > wui-image,
  a[data-variant='shadeSmall'] > wui-image,
  a[data-variant='error'] > wui-image {
    width: 14px;
    height: 14px;
  }

  a[data-variant='transparent'] > wui-icon:not(.image-icon),
  a[data-variant='success'] > wui-icon:not(.image-icon),
  a[data-variant='shadeSmall'] > wui-icon:not(.image-icon),
  a[data-variant='error'] > wui-icon:not(.image-icon) {
    width: 12px;
    height: 12px;
  }

  a[data-variant='fill']:focus-visible {
    background-color: var(--wui-color-accent-090);
  }

  a[data-variant='shade']:focus-visible,
  a[data-variant='shadeSmall']:focus-visible {
    background-color: var(--wui-color-gray-glass-015);
  }

  a[data-variant='transparent']:focus-visible {
    background-color: var(--wui-color-gray-glass-005);
  }

  a[data-variant='success']:focus-visible {
    background-color: var(--wui-color-success-glass-015);
  }

  a[data-variant='error']:focus-visible {
    background-color: var(--wui-color-error-glass-015);
  }

  a.disabled {
    color: var(--wui-color-gray-glass-015);
    background-color: var(--wui-color-gray-glass-015);
    pointer-events: none;
  }

  @media (hover: hover) and (pointer: fine) {
    a[data-variant='fill']:hover {
      background-color: var(--wui-color-accent-090);
    }

    a[data-variant='shade']:hover,
    a[data-variant='shadeSmall']:hover {
      background-color: var(--wui-color-gray-glass-015);
    }

    a[data-variant='transparent']:hover {
      background-color: var(--wui-color-gray-glass-005);
    }

    a[data-variant='success']:hover {
      background-color: var(--wui-color-success-glass-015);
    }

    a[data-variant='error']:hover {
      background-color: var(--wui-color-error-glass-015);
    }
  }

  a[data-variant='fill']:active {
    background-color: var(--wui-color-accent-080);
  }

  a[data-variant='shade']:active,
  a[data-variant='shadeSmall']:active {
    background-color: var(--wui-color-gray-glass-020);
  }

  a[data-variant='transparent']:active {
    background-color: var(--wui-color-gray-glass-010);
  }

  a[data-variant='success']:active {
    background-color: var(--wui-color-success-glass-020);
  }

  a[data-variant='error']:active {
    background-color: var(--wui-color-error-glass-020);
  }
`;var c=function(e,t,a,i){var s,r=arguments.length,o=r<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,a):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)o=Reflect.decorate(e,t,a,i);else for(var n=e.length-1;n>=0;n--)(s=e[n])&&(o=(r<3?s(o):r>3?s(t,a,o):s(t,a))||o);return r>3&&o&&Object.defineProperty(t,a,o),o};let u=class extends t.LitElement{constructor(){super(...arguments),this.variant="fill",this.imageSrc=void 0,this.imageIcon=void 0,this.imageIconSize="md",this.disabled=!1,this.icon="externalLink",this.href="",this.text=void 0}render(){let e="success"===this.variant||"transparent"===this.variant||"shadeSmall"===this.variant;return a.html`
      <a
        rel="noreferrer"
        target="_blank"
        href=${this.href}
        class=${this.disabled?"disabled":""}
        data-variant=${this.variant}
      >
        ${this.imageTemplate()}
        <wui-text variant=${e?"small-600":"paragraph-600"} color="inherit">
          ${this.title?this.title:r.UiHelperUtil.getHostName(this.href)}
        </wui-text>
        <wui-icon name=${this.icon} color="inherit" size="inherit"></wui-icon>
      </a>
    `}imageTemplate(){return this.imageSrc?a.html`<wui-image src=${this.imageSrc}></wui-image>`:this.imageIcon?a.html`<wui-icon
        name=${this.imageIcon}
        color="inherit"
        size=${this.imageIconSize}
        class="image-icon"
      ></wui-icon>`:null}};u.styles=[s.resetStyles,s.elementStyles,l],c([(0,i.property)()],u.prototype,"variant",void 0),c([(0,i.property)()],u.prototype,"imageSrc",void 0),c([(0,i.property)()],u.prototype,"imageIcon",void 0),c([(0,i.property)()],u.prototype,"imageIconSize",void 0),c([(0,i.property)({type:Boolean})],u.prototype,"disabled",void 0),c([(0,i.property)()],u.prototype,"icon",void 0),c([(0,i.property)()],u.prototype,"href",void 0),c([(0,i.property)()],u.prototype,"text",void 0),u=c([(0,o.customElement)("wui-chip")],u),e.s([],510290)},873117,e=>{"use strict";var t=e.i(138230),a=e.i(944411),i=e.i(924487);e.s(["HelpersUtil",0,{getTabsByNamespace:e=>e&&e===t.ConstantsUtil.CHAIN.EVM?a.OptionsController.state.remoteFeatures?.activity===!1?i.ConstantsUtil.ACCOUNT_TABS.filter(e=>"Activity"!==e.label):i.ConstantsUtil.ACCOUNT_TABS:[],isValidReownName:e=>/^[a-zA-Z0-9]+$/gu.test(e),validateReownName:e=>e.replace(/\^/gu,"").toLowerCase().replace(/[^a-zA-Z0-9]/gu,"")}])},692100,e=>{"use strict";e.s(["NavigationUtil",0,{URLS:{FAQ:"https://walletconnect.com/faq"}}])},536830,e=>{"use strict";e.i(588984);var t=e.i(399702),a=e.i(872857);e.i(759703);var i=e.i(698797),s=e.i(263342),r=e.i(729702),o=e.i(945182),n=e.i(944411),l=e.i(880985);e.i(302184);var c=e.i(938559),u=e.i(118827);let d=u.css`
  div {
    width: 100%;
  }

  [data-ready='false'] {
    transform: scale(1.05);
  }

  @media (max-width: 430px) {
    [data-ready='false'] {
      transform: translateY(-50px);
    }
  }
`;var h=function(e,t,a,i){var s,r=arguments.length,o=r<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,a):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)o=Reflect.decorate(e,t,a,i);else for(var n=e.length-1;n>=0;n--)(s=e[n])&&(o=(r<3?s(o):r>3?s(t,a,o):s(t,a))||o);return r>3&&o&&Object.defineProperty(t,a,o),o};let m=class extends t.LitElement{constructor(){super(),this.bodyObserver=void 0,this.unsubscribe=[],this.iframe=document.getElementById("w3m-iframe"),this.ready=!1,this.unsubscribe.push(o.ModalController.subscribeKey("open",e=>{e||this.onHideIframe()}),o.ModalController.subscribeKey("shake",e=>{e?this.iframe.style.animation="w3m-shake 500ms var(--wui-ease-out-power-2)":this.iframe.style.animation="none"}))}disconnectedCallback(){this.onHideIframe(),this.unsubscribe.forEach(e=>e()),this.bodyObserver?.unobserve(window.document.body)}async firstUpdated(){await this.syncTheme(),this.iframe.style.display="block";let e=this?.renderRoot?.querySelector("div");this.bodyObserver=new ResizeObserver(t=>{let a=t?.[0]?.contentBoxSize,i=a?.[0]?.inlineSize;this.iframe.style.height="600px",e.style.height="600px",n.OptionsController.state.enableEmbedded?this.updateFrameSizeForEmbeddedMode():(i&&i<=430?(this.iframe.style.width="100%",this.iframe.style.left="0px",this.iframe.style.bottom="0px",this.iframe.style.top="unset"):(this.iframe.style.width="360px",this.iframe.style.left="calc(50% - 180px)",this.iframe.style.top="calc(50% - 300px + 32px)",this.iframe.style.bottom="unset"),this.onShowIframe())}),this.bodyObserver.observe(window.document.body)}render(){return a.html`<div data-ready=${this.ready} id="w3m-frame-container"></div>`}onShowIframe(){let e=window.innerWidth<=430;this.ready=!0,this.iframe.style.animation=e?"w3m-iframe-zoom-in-mobile 200ms var(--wui-ease-out-power-2)":"w3m-iframe-zoom-in 200ms var(--wui-ease-out-power-2)"}onHideIframe(){this.iframe.style.display="none",this.iframe.style.animation="w3m-iframe-fade-out 200ms var(--wui-ease-out-power-2)"}async syncTheme(){let e=r.ConnectorController.getAuthConnector();if(e){let t=l.ThemeController.getSnapshot().themeMode,a=l.ThemeController.getSnapshot().themeVariables;await e.provider.syncTheme({themeVariables:a,w3mThemeVariables:(0,s.getW3mThemeVariables)(a,t)})}}async updateFrameSizeForEmbeddedMode(){let e=this?.renderRoot?.querySelector("div");await new Promise(e=>{setTimeout(e,300)});let t=this.getBoundingClientRect();e.style.width="100%",this.iframe.style.left=`${t.left}px`,this.iframe.style.top=`${t.top}px`,this.iframe.style.width=`${t.width}px`,this.iframe.style.height=`${t.height}px`,this.onShowIframe()}};m.styles=d,h([(0,i.state)()],m.prototype,"ready",void 0),m=h([(0,c.customElement)("w3m-approve-transaction-view")],m),e.s(["W3mApproveTransactionView",()=>m],503845);var p=t,v=e.i(140018);e.i(510290),e.i(237029),e.i(331658);let g=class extends p.LitElement{render(){return a.html`
      <wui-flex flexDirection="column" alignItems="center" gap="xl" padding="xl">
        <wui-text variant="paragraph-400" color="fg-100">Follow the instructions on</wui-text>
        <wui-chip
          icon="externalLink"
          variant="fill"
          href=${v.ConstantsUtil.SECURE_SITE_DASHBOARD}
          imageSrc=${v.ConstantsUtil.SECURE_SITE_FAVICON}
          data-testid="w3m-secure-website-button"
        >
        </wui-chip>
        <wui-text variant="small-400" color="fg-200">
          You will have to reconnect for security reasons
        </wui-text>
      </wui-flex>
    `}};g=function(e,t,a,i){var s,r=arguments.length,o=r<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,a):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)o=Reflect.decorate(e,t,a,i);else for(var n=e.length-1;n>=0;n--)(s=e[n])&&(o=(r<3?s(o):r>3?s(t,a,o):s(t,a))||o);return r>3&&o&&Object.defineProperty(t,a,o),o}([(0,c.customElement)("w3m-upgrade-wallet-view")],g),e.s(["W3mUpgradeWalletView",()=>g],161858);var f=t,b=e.i(392074);e.i(812492);var w=e.i(568633),y=e.i(138230),x=e.i(596590),k=e.i(207176),j=e.i(301847),P=e.i(594424),C=e.i(881936),S=e.i(944396),R=e.i(355376),E=t;e.i(781840);var T=e.i(86988);e.i(829162),e.i(596548);var $=e.i(864429);e.i(525370);let A=u.css`
  :host {
    position: relative;
    width: 100%;
    display: inline-block;
    color: var(--wui-color-fg-275);
  }

  .error {
    margin: var(--wui-spacing-xxs) var(--wui-spacing-m) var(--wui-spacing-0) var(--wui-spacing-m);
  }

  .base-name {
    position: absolute;
    right: 45px;
    top: 15px;
    text-align: right;
  }
`;var N=function(e,t,a,i){var s,r=arguments.length,o=r<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,a):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)o=Reflect.decorate(e,t,a,i);else for(var n=e.length-1;n>=0;n--)(s=e[n])&&(o=(r<3?s(o):r>3?s(t,a,o):s(t,a))||o);return r>3&&o&&Object.defineProperty(t,a,o),o};let O=class extends E.LitElement{constructor(){super(...arguments),this.disabled=!1,this.loading=!1}render(){return a.html`
      <wui-input-text
        value=${(0,T.ifDefined)(this.value)}
        ?disabled=${this.disabled}
        .value=${this.value||""}
        data-testid="wui-ens-input"
        inputRightPadding="5xl"
        .onKeyDown=${this.onKeyDown}
      >
        ${this.baseNameTemplate()} ${this.errorTemplate()}${this.loadingTemplate()}
      </wui-input-text>
    `}baseNameTemplate(){return a.html`<wui-text variant="paragraph-400" color="fg-200" class="base-name">
      ${y.ConstantsUtil.WC_NAME_SUFFIX}
    </wui-text>`}loadingTemplate(){return this.loading?a.html`<wui-loading-spinner size="md" color="accent-100"></wui-loading-spinner>`:null}errorTemplate(){return this.errorMessage?a.html`<wui-text variant="tiny-500" color="error-100" class="error"
        >${this.errorMessage}</wui-text
      >`:null}};O.styles=[$.resetStyles,A],N([(0,b.property)()],O.prototype,"errorMessage",void 0),N([(0,b.property)({type:Boolean})],O.prototype,"disabled",void 0),N([(0,b.property)()],O.prototype,"value",void 0),N([(0,b.property)({type:Boolean})],O.prototype,"loading",void 0),N([(0,b.property)({attribute:!1})],O.prototype,"onKeyDown",void 0),O=N([(0,c.customElement)("wui-ens-input")],O),e.i(982221),e.i(679556),e.i(609247),e.i(990237);var U=e.i(142844),z=e.i(873117);let I=u.css`
  wui-flex {
    width: 100%;
  }

  .suggestion {
    border: none;
    width: 100%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: var(--wui-color-gray-glass-002);
    border-radius: var(--wui-border-radius-xs);
    padding: var(--wui-spacing-m);
  }

  .suggestion:disabled {
    opacity: 0.5;
    cursor: default;
  }

  .suggestion:focus-visible:not(:disabled) {
    outline: 1px solid var(--wui-color-gray-glass-020);
    background-color: var(--wui-color-gray-glass-005);
  }

  .suggestion:hover:not(:disabled) {
    background-color: var(--wui-color-gray-glass-005);
  }

  .suggested-name {
    max-width: 75%;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  form {
    width: 100%;
    position: relative;
  }

  .input-submit-button,
  .input-loading-spinner {
    position: absolute;
    top: 26px;
    transform: translateY(-50%);
    right: 10px;
  }
`;var D=function(e,t,a,i){var s,r=arguments.length,o=r<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,a):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)o=Reflect.decorate(e,t,a,i);else for(var n=e.length-1;n>=0;n--)(s=e[n])&&(o=(r<3?s(o):r>3?s(t,a,o):s(t,a))||o);return r>3&&o&&Object.defineProperty(t,a,o),o};let _=class extends f.LitElement{constructor(){super(),this.formRef=(0,w.createRef)(),this.usubscribe=[],this.name="",this.error="",this.loading=P.EnsController.state.loading,this.suggestions=P.EnsController.state.suggestions,this.profileName=x.AccountController.state.profileName,this.onDebouncedNameInputChange=j.CoreHelperUtil.debounce(e=>{e.length<4?this.error="Name must be at least 4 characters long":z.HelpersUtil.isValidReownName(e)?(this.error="",P.EnsController.getSuggestions(e)):this.error="The value is not a valid username"}),this.usubscribe.push(P.EnsController.subscribe(e=>{this.suggestions=e.suggestions,this.loading=e.loading}),x.AccountController.subscribeKey("profileName",e=>{this.profileName=e,e&&(this.error="You already own a name")}))}firstUpdated(){this.formRef.value?.addEventListener("keydown",this.onEnterKey.bind(this))}disconnectedCallback(){super.disconnectedCallback(),this.usubscribe.forEach(e=>e()),this.formRef.value?.removeEventListener("keydown",this.onEnterKey.bind(this))}render(){return a.html`
      <wui-flex
        flexDirection="column"
        alignItems="center"
        gap="m"
        .padding=${["0","s","m","s"]}
      >
        <form ${(0,w.ref)(this.formRef)} @submit=${this.onSubmitName.bind(this)}>
          <wui-ens-input
            @inputChange=${this.onNameInputChange.bind(this)}
            .errorMessage=${this.error}
            .value=${this.name}
            .onKeyDown=${this.onKeyDown.bind(this)}
          >
          </wui-ens-input>
          ${this.submitButtonTemplate()}
          <input type="submit" hidden />
        </form>
        ${this.templateSuggestions()}
      </wui-flex>
    `}submitButtonTemplate(){let e=this.suggestions.find(e=>e.name?.split(".")?.[0]===this.name&&e.registered);if(this.loading)return a.html`<wui-loading-spinner
        class="input-loading-spinner"
        color="fg-200"
      ></wui-loading-spinner>`;let t=`${this.name}${y.ConstantsUtil.WC_NAME_SUFFIX}`;return a.html`
      <wui-icon-link
        .disabled=${e}
        class="input-submit-button"
        size="sm"
        icon="chevronRight"
        iconColor=${e?"fg-200":"accent-100"}
        @click=${()=>this.onSubmitName(t)}
      >
      </wui-icon-link>
    `}onNameInputChange(e){let t=z.HelpersUtil.validateReownName(e.detail||"");this.name=t,this.onDebouncedNameInputChange(t)}onKeyDown(e){1!==e.key.length||z.HelpersUtil.isValidReownName(e.key)||e.preventDefault()}nameSuggestionTagTemplate(e){return this.loading?a.html`<wui-loading-spinner color="fg-200"></wui-loading-spinner>`:e.registered?a.html`<wui-tag variant="shade" size="lg">Registered</wui-tag>`:a.html`<wui-tag variant="success" size="lg">Available</wui-tag>`}templateSuggestions(){return!this.name||this.name.length<4||this.error?null:a.html`<wui-flex flexDirection="column" gap="xxs" alignItems="center">
      ${this.suggestions.map(e=>a.html`<button
            .disabled=${e.registered||this.loading}
            data-testid="account-name-suggestion"
            class="suggestion"
            @click=${()=>this.onSubmitName(e.name)}
          >
            <wui-text color="fg-100" variant="paragraph-400" class="suggested-name">
              ${e.name}</wui-text
            >${this.nameSuggestionTagTemplate(e)}
          </button>`)}
    </wui-flex>`}isAllowedToSubmit(e){let t=e.split(".")?.[0],a=this.suggestions.find(e=>e.name?.split(".")?.[0]===t&&e.registered);return!this.loading&&!this.error&&!this.profileName&&t&&P.EnsController.validateName(t)&&!a}async onSubmitName(e){try{if(!this.isAllowedToSubmit(e))return;C.EventsController.sendEvent({type:"track",event:"REGISTER_NAME_INITIATED",properties:{isSmartAccount:(0,R.getPreferredAccountType)(k.ChainController.state.activeChain)===U.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT,ensName:e}}),await P.EnsController.registerName(e),C.EventsController.sendEvent({type:"track",event:"REGISTER_NAME_SUCCESS",properties:{isSmartAccount:(0,R.getPreferredAccountType)(k.ChainController.state.activeChain)===U.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT,ensName:e}})}catch(t){S.SnackController.showError(t.message),C.EventsController.sendEvent({type:"track",event:"REGISTER_NAME_ERROR",properties:{isSmartAccount:(0,R.getPreferredAccountType)(k.ChainController.state.activeChain)===U.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT,ensName:e,error:t?.message||"Unknown error"}})}}onEnterKey(e){if("Enter"===e.key&&this.name&&this.isAllowedToSubmit(this.name)){let e=`${this.name}${y.ConstantsUtil.WC_NAME_SUFFIX}`;this.onSubmitName(e)}}};_.styles=I,D([(0,b.property)()],_.prototype,"errorMessage",void 0),D([(0,i.state)()],_.prototype,"name",void 0),D([(0,i.state)()],_.prototype,"error",void 0),D([(0,i.state)()],_.prototype,"loading",void 0),D([(0,i.state)()],_.prototype,"suggestions",void 0),D([(0,i.state)()],_.prototype,"profileName",void 0),_=D([(0,c.customElement)("w3m-register-account-name-view")],_),e.s(["W3mRegisterAccountNameView",()=>_],440153);var M=t,W=e.i(692100),F=e.i(375054);e.i(81981),e.i(174776),e.i(472945);let L=u.css`
  .continue-button-container {
    width: 100%;
  }
`,B=class extends M.LitElement{render(){return a.html`
      <wui-flex
        flexDirection="column"
        alignItems="center"
        gap="xxl"
        .padding=${["0","0","l","0"]}
      >
        ${this.onboardingTemplate()} ${this.buttonsTemplate()}
        <wui-link
          @click=${()=>{j.CoreHelperUtil.openHref(W.NavigationUtil.URLS.FAQ,"_blank")}}
        >
          Learn more
          <wui-icon color="inherit" slot="iconRight" name="externalLink"></wui-icon>
        </wui-link>
      </wui-flex>
    `}onboardingTemplate(){return a.html` <wui-flex
      flexDirection="column"
      gap="xxl"
      alignItems="center"
      .padding=${["0","xxl","0","xxl"]}
    >
      <wui-flex gap="s" alignItems="center" justifyContent="center">
        <wui-icon-box
          size="xl"
          iconcolor="success-100"
          backgroundcolor="success-100"
          icon="checkmark"
          background="opaque"
        ></wui-icon-box>
      </wui-flex>
      <wui-flex flexDirection="column" alignItems="center" gap="s">
        <wui-text align="center" variant="medium-600" color="fg-100">
          Account name chosen successfully
        </wui-text>
        <wui-text align="center" variant="paragraph-400" color="fg-100">
          You can now fund your account and trade crypto
        </wui-text>
      </wui-flex>
    </wui-flex>`}buttonsTemplate(){return a.html`<wui-flex
      .padding=${["0","2l","0","2l"]}
      gap="s"
      class="continue-button-container"
    >
      <wui-button fullWidth size="lg" borderRadius="xs" @click=${this.redirectToAccount.bind(this)}
        >Let's Go!
      </wui-button>
    </wui-flex>`}redirectToAccount(){F.RouterController.replace("Account")}};B.styles=L,B=function(e,t,a,i){var s,r=arguments.length,o=r<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,a):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)o=Reflect.decorate(e,t,a,i);else for(var n=e.length-1;n>=0;n--)(s=e[n])&&(o=(r<3?s(o):r>3?s(t,a,o):s(t,a))||o);return r>3&&o&&Object.defineProperty(t,a,o),o}([(0,c.customElement)("w3m-register-account-name-success-view")],B),e.s(["W3mRegisterAccountNameSuccess",()=>B],899802),e.s([],441163),e.i(441163),e.i(503845),e.i(161858),e.i(440153),e.i(899802),e.s(["W3mApproveTransactionView",()=>m,"W3mRegisterAccountNameSuccess",()=>B,"W3mRegisterAccountNameView",()=>_,"W3mUpgradeWalletView",()=>g],536830)},370120,e=>{e.v(t=>Promise.all(["static/chunks/26e0a8e49472e8b2.js"].map(t=>e.l(t))).then(()=>t(907496)))},101594,e=>{e.v(t=>Promise.all(["static/chunks/97923f7a558363e7.js"].map(t=>e.l(t))).then(()=>t(111408)))},53619,e=>{e.v(t=>Promise.all(["static/chunks/d2d95687802cc51a.js"].map(t=>e.l(t))).then(()=>t(945285)))},647729,e=>{e.v(t=>Promise.all(["static/chunks/b9333ed8ed5db8d8.js"].map(t=>e.l(t))).then(()=>t(503272)))},42060,e=>{e.v(t=>Promise.all(["static/chunks/63e0528672c9261d.js"].map(t=>e.l(t))).then(()=>t(418817)))},646255,e=>{e.v(t=>Promise.all(["static/chunks/c41b751c0d58294f.js"].map(t=>e.l(t))).then(()=>t(509808)))},27402,e=>{e.v(t=>Promise.all(["static/chunks/f56269ce9627e4eb.js"].map(t=>e.l(t))).then(()=>t(609450)))},242317,e=>{e.v(t=>Promise.all(["static/chunks/c25bafba4e65b9d9.js"].map(t=>e.l(t))).then(()=>t(805544)))},189728,e=>{e.v(t=>Promise.all(["static/chunks/1c17bb6d6b722db7.js"].map(t=>e.l(t))).then(()=>t(39234)))},933805,e=>{e.v(t=>Promise.all(["static/chunks/eec4c7518d5ef1b7.js"].map(t=>e.l(t))).then(()=>t(83012)))},306521,e=>{e.v(t=>Promise.all(["static/chunks/c7ea8683df715cf9.js"].map(t=>e.l(t))).then(()=>t(153401)))},529497,e=>{e.v(t=>Promise.all(["static/chunks/e49251e635894a10.js"].map(t=>e.l(t))).then(()=>t(912290)))},821462,e=>{e.v(t=>Promise.all(["static/chunks/faa73acfb705c2af.js"].map(t=>e.l(t))).then(()=>t(81778)))},576367,e=>{e.v(t=>Promise.all(["static/chunks/4047e10b7e0020db.js"].map(t=>e.l(t))).then(()=>t(441939)))},719175,e=>{e.v(t=>Promise.all(["static/chunks/c8d13ffd8cb258f2.js"].map(t=>e.l(t))).then(()=>t(136442)))},585172,e=>{e.v(t=>Promise.all(["static/chunks/af37e47fd05aff94.js"].map(t=>e.l(t))).then(()=>t(376835)))},660404,e=>{e.v(t=>Promise.all(["static/chunks/4923abb4f10984df.js"].map(t=>e.l(t))).then(()=>t(622164)))},656661,e=>{e.v(t=>Promise.all(["static/chunks/9335ff44e74a1319.js"].map(t=>e.l(t))).then(()=>t(677958)))},115985,e=>{e.v(t=>Promise.all(["static/chunks/2f33c53c900a30f0.js"].map(t=>e.l(t))).then(()=>t(263541)))},798562,e=>{e.v(t=>Promise.all(["static/chunks/b7b39b35bc8e37e7.js"].map(t=>e.l(t))).then(()=>t(127098)))},995740,e=>{e.v(t=>Promise.all(["static/chunks/e023d779fabed8ba.js"].map(t=>e.l(t))).then(()=>t(466451)))},392121,e=>{e.v(t=>Promise.all(["static/chunks/bd3f5a87bd76ddf2.js"].map(t=>e.l(t))).then(()=>t(917665)))},954007,e=>{e.v(t=>Promise.all(["static/chunks/28f045a8aea535ed.js"].map(t=>e.l(t))).then(()=>t(685345)))},510739,e=>{e.v(t=>Promise.all(["static/chunks/1ce8b24df6c38238.js"].map(t=>e.l(t))).then(()=>t(922360)))},518349,e=>{e.v(t=>Promise.all(["static/chunks/abff0b62e58a0623.js"].map(t=>e.l(t))).then(()=>t(183250)))},23210,e=>{e.v(t=>Promise.all(["static/chunks/d590609f31b2b6f2.js"].map(t=>e.l(t))).then(()=>t(449291)))},69872,e=>{e.v(t=>Promise.all(["static/chunks/a90386f31e65e7c6.js"].map(t=>e.l(t))).then(()=>t(606784)))},473425,e=>{e.v(t=>Promise.all(["static/chunks/f6ce4ba8446e5b4e.js"].map(t=>e.l(t))).then(()=>t(699844)))},86124,e=>{e.v(t=>Promise.all(["static/chunks/ca0c357681404336.js"].map(t=>e.l(t))).then(()=>t(11252)))},449547,e=>{e.v(t=>Promise.all(["static/chunks/66de8be4c4f97e40.js"].map(t=>e.l(t))).then(()=>t(886888)))},107380,e=>{e.v(t=>Promise.all(["static/chunks/6786c08fb6566531.js"].map(t=>e.l(t))).then(()=>t(31913)))},417532,e=>{e.v(t=>Promise.all(["static/chunks/4c3dd4391186697a.js"].map(t=>e.l(t))).then(()=>t(165607)))},400114,e=>{e.v(t=>Promise.all(["static/chunks/e875ff35e86f2cd4.js"].map(t=>e.l(t))).then(()=>t(839832)))},371013,e=>{e.v(t=>Promise.all(["static/chunks/d5ef2cd1d5f0ce31.js"].map(t=>e.l(t))).then(()=>t(306387)))},592346,e=>{e.v(t=>Promise.all(["static/chunks/0b53bfb3dd94b07e.js"].map(t=>e.l(t))).then(()=>t(905711)))},692886,e=>{e.v(t=>Promise.all(["static/chunks/cc38ee16a99c453d.js"].map(t=>e.l(t))).then(()=>t(288445)))},559568,e=>{e.v(t=>Promise.all(["static/chunks/8893cb0dd5e75428.js"].map(t=>e.l(t))).then(()=>t(52422)))},727099,e=>{e.v(t=>Promise.all(["static/chunks/be85831826444acc.js"].map(t=>e.l(t))).then(()=>t(873099)))},106183,e=>{e.v(t=>Promise.all(["static/chunks/33ac89a1fcda0ac9.js"].map(t=>e.l(t))).then(()=>t(28900)))},276516,e=>{e.v(t=>Promise.all(["static/chunks/1f16ba9408c624e2.js"].map(t=>e.l(t))).then(()=>t(554519)))},526211,e=>{e.v(t=>Promise.all(["static/chunks/398933b68cf253b0.js"].map(t=>e.l(t))).then(()=>t(938626)))},377532,e=>{e.v(t=>Promise.all(["static/chunks/76a249fc4d7468f3.js"].map(t=>e.l(t))).then(()=>t(583927)))},146719,e=>{e.v(t=>Promise.all(["static/chunks/fc0ab7c2b70600a0.js"].map(t=>e.l(t))).then(()=>t(790998)))},343268,e=>{e.v(t=>Promise.all(["static/chunks/59373d2a49f83685.js"].map(t=>e.l(t))).then(()=>t(428068)))},921373,e=>{e.v(t=>Promise.all(["static/chunks/e523dcfe0a640736.js"].map(t=>e.l(t))).then(()=>t(127251)))},114361,e=>{e.v(t=>Promise.all(["static/chunks/1ddd2185911125ed.js"].map(t=>e.l(t))).then(()=>t(198663)))},978898,e=>{e.v(t=>Promise.all(["static/chunks/422223ea541cc4ec.js"].map(t=>e.l(t))).then(()=>t(969846)))},497619,e=>{e.v(t=>Promise.all(["static/chunks/ae8f8bf14344cd0f.js"].map(t=>e.l(t))).then(()=>t(879809)))},99077,e=>{e.v(t=>Promise.all(["static/chunks/4afd407365684745.js"].map(t=>e.l(t))).then(()=>t(706888)))},999971,e=>{e.v(t=>Promise.all(["static/chunks/b9e5b4b0b40b4966.js"].map(t=>e.l(t))).then(()=>t(954962)))},14879,e=>{e.v(t=>Promise.all(["static/chunks/03ed00251b9f8f96.js"].map(t=>e.l(t))).then(()=>t(494536)))},187203,e=>{e.v(t=>Promise.all(["static/chunks/9331bedf749a8b03.js"].map(t=>e.l(t))).then(()=>t(210924)))},517776,e=>{e.v(t=>Promise.all(["static/chunks/3fe1020423119ecd.js"].map(t=>e.l(t))).then(()=>t(705976)))},98067,e=>{e.v(t=>Promise.all(["static/chunks/8ee0a99124a40521.js"].map(t=>e.l(t))).then(()=>t(403692)))},180529,e=>{e.v(t=>Promise.all(["static/chunks/c0ffd2c02e3b49f9.js"].map(t=>e.l(t))).then(()=>t(356216)))},33772,e=>{e.v(t=>Promise.all(["static/chunks/c26fa44e80d4552b.js"].map(t=>e.l(t))).then(()=>t(354159)))},612617,e=>{e.v(t=>Promise.all(["static/chunks/2800c4437d7ec1c8.js"].map(t=>e.l(t))).then(()=>t(981722)))},99078,e=>{e.v(t=>Promise.all(["static/chunks/18b5586311477356.js"].map(t=>e.l(t))).then(()=>t(879190)))},484585,e=>{e.v(t=>Promise.all(["static/chunks/24678d38918cff86.js"].map(t=>e.l(t))).then(()=>t(390585)))},766513,e=>{e.v(t=>Promise.all(["static/chunks/b4f4414200774c70.js"].map(t=>e.l(t))).then(()=>t(856636)))},682754,e=>{e.v(t=>Promise.all(["static/chunks/20a8a0f412961150.js"].map(t=>e.l(t))).then(()=>t(703951)))},219316,e=>{e.v(t=>Promise.all(["static/chunks/5d1a1b0db1f6f280.js"].map(t=>e.l(t))).then(()=>t(961511)))},277176,e=>{e.v(t=>Promise.all(["static/chunks/63b01ab668891c59.js"].map(t=>e.l(t))).then(()=>t(355495)))},560377,e=>{e.v(t=>Promise.all(["static/chunks/a73126aecb5194b1.js"].map(t=>e.l(t))).then(()=>t(699252)))},461996,e=>{e.v(t=>Promise.all(["static/chunks/014ac0ae0eb0d977.js"].map(t=>e.l(t))).then(()=>t(595684)))},760084,e=>{e.v(t=>Promise.all(["static/chunks/3d2cf405c5be67f1.js"].map(t=>e.l(t))).then(()=>t(821645)))},23765,e=>{e.v(t=>Promise.all(["static/chunks/19daf80189af3cb5.js"].map(t=>e.l(t))).then(()=>t(669874)))},669065,e=>{e.v(t=>Promise.all(["static/chunks/39c5ab3d449138ef.js"].map(t=>e.l(t))).then(()=>t(756209)))},137985,e=>{e.v(t=>Promise.all(["static/chunks/a96e5b3c0bcf745a.js"].map(t=>e.l(t))).then(()=>t(862181)))},984531,e=>{e.v(t=>Promise.all(["static/chunks/7e2b21a05f35e2fb.js"].map(t=>e.l(t))).then(()=>t(654201)))},14671,e=>{e.v(t=>Promise.all(["static/chunks/2e833c4f8897d285.js"].map(t=>e.l(t))).then(()=>t(400433)))},661706,e=>{e.v(t=>Promise.all(["static/chunks/9d7994b2925eedff.js"].map(t=>e.l(t))).then(()=>t(406011)))},808545,e=>{e.v(t=>Promise.all(["static/chunks/c12e7e357bd73885.js"].map(t=>e.l(t))).then(()=>t(590802)))},86125,e=>{e.v(t=>Promise.all(["static/chunks/6674dde5fce56b90.js"].map(t=>e.l(t))).then(()=>t(127530)))},25054,e=>{e.v(t=>Promise.all(["static/chunks/5f43b8de108d82a8.js"].map(t=>e.l(t))).then(()=>t(404202)))},189409,e=>{e.v(t=>Promise.all(["static/chunks/04c3bd1cc3433abb.js"].map(t=>e.l(t))).then(()=>t(838366)))},105736,e=>{e.v(t=>Promise.all(["static/chunks/3ab13667b822299a.js"].map(t=>e.l(t))).then(()=>t(511626)))},75220,e=>{e.v(t=>Promise.all(["static/chunks/136b1b881256e27c.js"].map(t=>e.l(t))).then(()=>t(981111)))},164632,e=>{e.v(t=>Promise.all(["static/chunks/27a0455f9ed4cbe2.js"].map(t=>e.l(t))).then(()=>t(235153)))},6768,e=>{e.v(t=>Promise.all(["static/chunks/65b36f3821731273.js"].map(t=>e.l(t))).then(()=>t(614051)))},82206,e=>{e.v(t=>Promise.all(["static/chunks/cd86ccbd9d28ee36.js"].map(t=>e.l(t))).then(()=>t(56751)))},458662,e=>{e.v(t=>Promise.all(["static/chunks/ae5b22bbf1fab4fc.js"].map(t=>e.l(t))).then(()=>t(972606)))},405625,e=>{e.v(t=>Promise.all(["static/chunks/42b23260469ed281.js"].map(t=>e.l(t))).then(()=>t(56717)))}]);