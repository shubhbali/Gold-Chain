(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,873117,t=>{"use strict";var e=t.i(138230),r=t.i(944411),i=t.i(924487);t.s(["HelpersUtil",0,{getTabsByNamespace:t=>t&&t===e.ConstantsUtil.CHAIN.EVM?r.OptionsController.state.remoteFeatures?.activity===!1?i.ConstantsUtil.ACCOUNT_TABS.filter(t=>"Activity"!==t.label):i.ConstantsUtil.ACCOUNT_TABS:[],isValidReownName:t=>/^[a-zA-Z0-9]+$/gu.test(t),validateReownName:t=>t.replace(/\^/gu,"").toLowerCase().replace(/[^a-zA-Z0-9]/gu,"")}])},510290,t=>{"use strict";t.i(588984);var e=t.i(399702),r=t.i(872857);t.i(759703);var i=t.i(392074);t.i(630572),t.i(287940),t.i(596548);var a=t.i(864429),o=t.i(34691),s=t.i(938559),n=t.i(118827);let l=n.css`
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
`;var c=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let u=class extends e.LitElement{constructor(){super(...arguments),this.variant="fill",this.imageSrc=void 0,this.imageIcon=void 0,this.imageIconSize="md",this.disabled=!1,this.icon="externalLink",this.href="",this.text=void 0}render(){let t="success"===this.variant||"transparent"===this.variant||"shadeSmall"===this.variant;return r.html`
      <a
        rel="noreferrer"
        target="_blank"
        href=${this.href}
        class=${this.disabled?"disabled":""}
        data-variant=${this.variant}
      >
        ${this.imageTemplate()}
        <wui-text variant=${t?"small-600":"paragraph-600"} color="inherit">
          ${this.title?this.title:o.UiHelperUtil.getHostName(this.href)}
        </wui-text>
        <wui-icon name=${this.icon} color="inherit" size="inherit"></wui-icon>
      </a>
    `}imageTemplate(){return this.imageSrc?r.html`<wui-image src=${this.imageSrc}></wui-image>`:this.imageIcon?r.html`<wui-icon
        name=${this.imageIcon}
        color="inherit"
        size=${this.imageIconSize}
        class="image-icon"
      ></wui-icon>`:null}};u.styles=[a.resetStyles,a.elementStyles,l],c([(0,i.property)()],u.prototype,"variant",void 0),c([(0,i.property)()],u.prototype,"imageSrc",void 0),c([(0,i.property)()],u.prototype,"imageIcon",void 0),c([(0,i.property)()],u.prototype,"imageIconSize",void 0),c([(0,i.property)({type:Boolean})],u.prototype,"disabled",void 0),c([(0,i.property)()],u.prototype,"icon",void 0),c([(0,i.property)()],u.prototype,"href",void 0),c([(0,i.property)()],u.prototype,"text",void 0),u=c([(0,s.customElement)("wui-chip")],u),t.s([],510290)},692100,t=>{"use strict";t.s(["NavigationUtil",0,{URLS:{FAQ:"https://walletconnect.com/faq"}}])},999964,t=>{"use strict";t.i(525370),t.s([])},155284,t=>{"use strict";t.s(["REOWN_URL",0,"https://reown.com","numbersRegex",0,/[0-9,.]/u,"specialCharactersRegex",0,/[.*+?^${}()|[\]\\]/gu])},156575,t=>{"use strict";t.i(588984);var e=t.i(399702),r=t.i(872857);t.i(759703);var i=t.i(392074);t.i(596548);var a=t.i(864429),o=t.i(938559),s=t.i(118827);let n=s.css`
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
`;var l=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let c=class extends e.LitElement{constructor(){super(...arguments),this.text=""}render(){return r.html`${this.template()}`}template(){return this.text?r.html`<wui-text variant="small-500" color="fg-200">${this.text}</wui-text>`:null}};c.styles=[a.resetStyles,n],l([(0,i.property)()],c.prototype,"text",void 0),c=l([(0,o.customElement)("wui-separator")],c),t.s([],156575)},370507,t=>{"use strict";t.i(588984);var e=t.i(399702),r=t.i(872857);t.i(759703);var i=t.i(392074);t.i(287940);var a=t.i(864429),o=t.i(34691),s=t.i(938559),n=t.i(118827);let l=n.css`
  :host {
    display: block;
    width: var(--local-width);
    height: var(--local-height);
    border-radius: var(--wui-border-radius-3xl);
    box-shadow: 0 0 0 8px var(--wui-color-gray-glass-005);
    overflow: hidden;
    position: relative;
  }

  :host([data-variant='generated']) {
    --mixed-local-color-1: var(--local-color-1);
    --mixed-local-color-2: var(--local-color-2);
    --mixed-local-color-3: var(--local-color-3);
    --mixed-local-color-4: var(--local-color-4);
    --mixed-local-color-5: var(--local-color-5);
  }

  @supports (background: color-mix(in srgb, white 50%, black)) {
    :host([data-variant='generated']) {
      --mixed-local-color-1: color-mix(
        in srgb,
        var(--w3m-color-mix) var(--w3m-color-mix-strength),
        var(--local-color-1)
      );
      --mixed-local-color-2: color-mix(
        in srgb,
        var(--w3m-color-mix) var(--w3m-color-mix-strength),
        var(--local-color-2)
      );
      --mixed-local-color-3: color-mix(
        in srgb,
        var(--w3m-color-mix) var(--w3m-color-mix-strength),
        var(--local-color-3)
      );
      --mixed-local-color-4: color-mix(
        in srgb,
        var(--w3m-color-mix) var(--w3m-color-mix-strength),
        var(--local-color-4)
      );
      --mixed-local-color-5: color-mix(
        in srgb,
        var(--w3m-color-mix) var(--w3m-color-mix-strength),
        var(--local-color-5)
      );
    }
  }

  :host([data-variant='generated']) {
    box-shadow: 0 0 0 8px var(--wui-color-gray-glass-005);
    background: radial-gradient(
      var(--local-radial-circle),
      #fff 0.52%,
      var(--mixed-local-color-5) 31.25%,
      var(--mixed-local-color-3) 51.56%,
      var(--mixed-local-color-2) 65.63%,
      var(--mixed-local-color-1) 82.29%,
      var(--mixed-local-color-4) 100%
    );
  }

  :host([data-variant='default']) {
    box-shadow: 0 0 0 8px var(--wui-color-gray-glass-005);
    background: radial-gradient(
      75.29% 75.29% at 64.96% 24.36%,
      #fff 0.52%,
      #f5ccfc 31.25%,
      #dba4f5 51.56%,
      #9a8ee8 65.63%,
      #6493da 82.29%,
      #6ebdea 100%
    );
  }
`;var c=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let u=class extends e.LitElement{constructor(){super(...arguments),this.imageSrc=void 0,this.alt=void 0,this.address=void 0,this.size="xl"}render(){return this.style.cssText=`
    --local-width: var(--wui-icon-box-size-${this.size});
    --local-height: var(--wui-icon-box-size-${this.size});
    `,r.html`${this.visualTemplate()}`}visualTemplate(){if(this.imageSrc)return this.dataset.variant="image",r.html`<wui-image src=${this.imageSrc} alt=${this.alt??"avatar"}></wui-image>`;if(this.address){this.dataset.variant="generated";let t=o.UiHelperUtil.generateAvatarColors(this.address);return this.style.cssText+=`
 ${t}`,null}return this.dataset.variant="default",null}};u.styles=[a.resetStyles,l],c([(0,i.property)()],u.prototype,"imageSrc",void 0),c([(0,i.property)()],u.prototype,"alt",void 0),c([(0,i.property)()],u.prototype,"address",void 0),c([(0,i.property)()],u.prototype,"size",void 0),u=c([(0,s.customElement)("wui-avatar")],u),t.s([],370507)},696794,t=>{"use strict";t.i(588984);var e=t.i(399702),r=t.i(872857);t.i(759703);var i=t.i(392074),a=t.i(437059);t.i(630572),t.i(287940),t.i(596548),t.i(108476);var o=t.i(864429),s=t.i(938559),n=t.i(118827);let l=n.css`
  button {
    padding: 6.5px var(--wui-spacing-l) 6.5px var(--wui-spacing-xs);
    display: flex;
    justify-content: space-between;
    width: 100%;
    border-radius: var(--wui-border-radius-xs);
    background-color: var(--wui-color-gray-glass-002);
  }

  button[data-clickable='false'] {
    pointer-events: none;
    background-color: transparent;
  }

  wui-image,
  wui-icon {
    width: var(--wui-spacing-3xl);
    height: var(--wui-spacing-3xl);
  }

  wui-image {
    border-radius: var(--wui-border-radius-3xl);
  }
`;var c=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let u=class extends e.LitElement{constructor(){super(...arguments),this.tokenName="",this.tokenImageUrl="",this.tokenValue=0,this.tokenAmount="0.0",this.tokenCurrency="",this.clickable=!1}render(){return r.html`
      <button data-clickable=${String(this.clickable)}>
        <wui-flex gap="s" alignItems="center">
          ${this.visualTemplate()}
          <wui-flex flexDirection="column" justifyContent="spaceBetween">
            <wui-text variant="paragraph-500" color="fg-100">${this.tokenName}</wui-text>
            <wui-text variant="small-400" color="fg-200">
              ${a.NumberUtil.formatNumberToLocalString(this.tokenAmount,4)} ${this.tokenCurrency}
            </wui-text>
          </wui-flex>
        </wui-flex>
        <wui-text variant="paragraph-500" color="fg-100">$${this.tokenValue.toFixed(2)}</wui-text>
      </button>
    `}visualTemplate(){return this.tokenName&&this.tokenImageUrl?r.html`<wui-image alt=${this.tokenName} src=${this.tokenImageUrl}></wui-image>`:r.html`<wui-icon name="coinPlaceholder" color="fg-100"></wui-icon>`}};u.styles=[o.resetStyles,o.elementStyles,l],c([(0,i.property)()],u.prototype,"tokenName",void 0),c([(0,i.property)()],u.prototype,"tokenImageUrl",void 0),c([(0,i.property)({type:Number})],u.prototype,"tokenValue",void 0),c([(0,i.property)()],u.prototype,"tokenAmount",void 0),c([(0,i.property)()],u.prototype,"tokenCurrency",void 0),c([(0,i.property)({type:Boolean})],u.prototype,"clickable",void 0),u=c([(0,s.customElement)("wui-list-token")],u),t.s([],696794)},274071,t=>{"use strict";t.i(588984);var e=t.i(399702),r=t.i(872857);t.i(759703);var i=t.i(392074);t.i(630572);var a=t.i(864429),o=t.i(938559),s=t.i(118827);let n=s.css`
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
`;var l=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let c=class extends e.LitElement{constructor(){super(...arguments),this.text="",this.icon="card"}render(){return r.html`<button>
      <wui-icon color="accent-100" name=${this.icon} size="lg"></wui-icon>
    </button>`}};c.styles=[a.resetStyles,a.elementStyles,n],l([(0,i.property)()],c.prototype,"text",void 0),l([(0,i.property)()],c.prototype,"icon",void 0),c=l([(0,o.customElement)("wui-icon-button")],c),t.s([],274071)},662541,t=>{"use strict";t.i(588984);var e=t.i(399702),r=t.i(872857);t.i(759703);var i=t.i(392074);t.i(630572),t.i(287940),t.i(108476);var a=t.i(864429),o=t.i(938559);t.i(839432);var s=t.i(118827);let n=s.css`
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
`;var l=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let c=class extends e.LitElement{constructor(){super(...arguments),this.size="md",this.name="",this.installed=!1,this.badgeSize="xs"}render(){let t="xxs";return t="lg"===this.size?"m":"md"===this.size?"xs":"xxs",this.style.cssText=`
       --local-border-radius: var(--wui-border-radius-${t});
       --local-size: var(--wui-wallet-image-size-${this.size});
   `,this.walletIcon&&(this.dataset.walletIcon=this.walletIcon),r.html`
      <wui-flex justifyContent="center" alignItems="center"> ${this.templateVisual()} </wui-flex>
    `}templateVisual(){return this.imageSrc?r.html`<wui-image src=${this.imageSrc} alt=${this.name}></wui-image>`:this.walletIcon?r.html`<wui-icon
        data-parent-size="md"
        size="md"
        color="inherit"
        name=${this.walletIcon}
      ></wui-icon>`:r.html`<wui-icon
      data-parent-size=${this.size}
      size="inherit"
      color="inherit"
      name="walletPlaceholder"
    ></wui-icon>`}};c.styles=[a.elementStyles,a.resetStyles,n],l([(0,i.property)()],c.prototype,"size",void 0),l([(0,i.property)()],c.prototype,"name",void 0),l([(0,i.property)()],c.prototype,"imageSrc",void 0),l([(0,i.property)()],c.prototype,"walletIcon",void 0),l([(0,i.property)({type:Boolean})],c.prototype,"installed",void 0),l([(0,i.property)()],c.prototype,"badgeSize",void 0),c=l([(0,o.customElement)("wui-wallet-image")],c),t.s([],662541)},493416,t=>{"use strict";t.i(588984);var e=t.i(872857);let r=e.svg`<svg  viewBox="0 0 48 54" fill="none">
  <path
    d="M43.4605 10.7248L28.0485 1.61089C25.5438 0.129705 22.4562 0.129705 19.9515 1.61088L4.53951 10.7248C2.03626 12.2051 0.5 14.9365 0.5 17.886V36.1139C0.5 39.0635 2.03626 41.7949 4.53951 43.2752L19.9515 52.3891C22.4562 53.8703 25.5438 53.8703 28.0485 52.3891L43.4605 43.2752C45.9637 41.7949 47.5 39.0635 47.5 36.114V17.8861C47.5 14.9365 45.9637 12.2051 43.4605 10.7248Z"
  />
</svg>`;t.s(["networkSvgMd",0,r])},830976,t=>{"use strict";t.i(662541),t.s([])},152076,t=>{"use strict";t.i(588984);var e=t.i(872857);let r=e.svg`<svg width="86" height="96" fill="none">
  <path
    d="M78.3244 18.926L50.1808 2.45078C45.7376 -0.150261 40.2624 -0.150262 35.8192 2.45078L7.6756 18.926C3.23322 21.5266 0.5 26.3301 0.5 31.5248V64.4752C0.5 69.6699 3.23322 74.4734 7.6756 77.074L35.8192 93.5492C40.2624 96.1503 45.7376 96.1503 50.1808 93.5492L78.3244 77.074C82.7668 74.4734 85.5 69.6699 85.5 64.4752V31.5248C85.5 26.3301 82.7668 21.5266 78.3244 18.926Z"
  />
</svg>`;t.s(["networkSvgLg",0,r])},894687,200964,t=>{"use strict";t.i(588984);var e=t.i(399702),r=t.i(872857);t.i(759703);var i=t.i(392074),a=t.i(152076),o=t.i(493416);let s=r.svg`
  <svg fill="none" viewBox="0 0 36 40">
    <path
      d="M15.4 2.1a5.21 5.21 0 0 1 5.2 0l11.61 6.7a5.21 5.21 0 0 1 2.61 4.52v13.4c0 1.87-1 3.59-2.6 4.52l-11.61 6.7c-1.62.93-3.6.93-5.22 0l-11.6-6.7a5.21 5.21 0 0 1-2.61-4.51v-13.4c0-1.87 1-3.6 2.6-4.52L15.4 2.1Z"
    />
  </svg>
`;t.i(630572),t.i(287940);var n=t.i(864429),l=t.i(938559),c=t.i(118827);let u=c.css`
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
`;var d=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let p=class extends e.LitElement{constructor(){super(...arguments),this.size="md",this.name="uknown",this.networkImagesBySize={sm:s,md:o.networkSvgMd,lg:a.networkSvgLg},this.selected=!1,this.round=!1}render(){return this.round?(this.dataset.round="true",this.style.cssText=`
      --local-width: var(--wui-spacing-3xl);
      --local-height: var(--wui-spacing-3xl);
      --local-icon-size: var(--wui-spacing-l);
    `):this.style.cssText=`

      --local-path: var(--wui-path-network-${this.size});
      --local-width:  var(--wui-width-network-${this.size});
      --local-height:  var(--wui-height-network-${this.size});
      --local-icon-size:  var(--wui-icon-size-network-${this.size});
    `,r.html`${this.templateVisual()} ${this.svgTemplate()} `}svgTemplate(){return this.round?null:this.networkImagesBySize[this.size]}templateVisual(){return this.imageSrc?r.html`<wui-image src=${this.imageSrc} alt=${this.name}></wui-image>`:r.html`<wui-icon size="inherit" color="fg-200" name="networkPlaceholder"></wui-icon>`}};p.styles=[n.resetStyles,u],d([(0,i.property)()],p.prototype,"size",void 0),d([(0,i.property)()],p.prototype,"name",void 0),d([(0,i.property)({type:Object})],p.prototype,"networkImagesBySize",void 0),d([(0,i.property)()],p.prototype,"imageSrc",void 0),d([(0,i.property)({type:Boolean})],p.prototype,"selected",void 0),d([(0,i.property)({type:Boolean})],p.prototype,"round",void 0),p=d([(0,l.customElement)("wui-network-image")],p),t.s([],200964),t.s([],894687)},801461,t=>{"use strict";t.i(588984);var e,r,i=t.i(399702),a=t.i(872857);t.i(759703);var o=t.i(392074),s=t.i(698797),n=t.i(660506),l=t.i(207176),c=t.i(301847),u=t.i(881936),d=t.i(944411),p=t.i(375054),h=t.i(557618),w=t.i(355376);t.i(302184);var v=t.i(414737),g=t.i(938559);t.i(237029),t.i(174776),t.i(472945),t.i(331658);var m=i;t.i(781840);var b=t.i(86988);t.i(630572),t.i(596548),t.i(108476);var y=t.i(864429);(e=r||(r={})).approve="approved",e.bought="bought",e.borrow="borrowed",e.burn="burnt",e.cancel="canceled",e.claim="claimed",e.deploy="deployed",e.deposit="deposited",e.execute="executed",e.mint="minted",e.receive="received",e.repay="repaid",e.send="sent",e.sell="sold",e.stake="staked",e.trade="swapped",e.unstake="unstaked",e.withdraw="withdrawn";var f=i;t.i(287940),t.i(839432);var x=t.i(118827);let k=x.css`
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
`;var C=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let $=class extends f.LitElement{constructor(){super(...arguments),this.images=[],this.secondImage={type:void 0,url:""}}render(){let[t,e]=this.images,r=t?.type==="NFT",i=e?.url?"NFT"===e.type:r;return this.style.cssText=`
    --local-left-border-radius: ${r?"var(--wui-border-radius-xxs)":"var(--wui-border-radius-s)"};
    --local-right-border-radius: ${i?"var(--wui-border-radius-xxs)":"var(--wui-border-radius-s)"};
    `,a.html`<wui-flex> ${this.templateVisual()} ${this.templateIcon()} </wui-flex>`}templateVisual(){let[t,e]=this.images,r=t?.type;return 2===this.images.length&&(t?.url||e?.url)?a.html`<div class="swap-images-container">
        ${t?.url?a.html`<wui-image src=${t.url} alt="Transaction image"></wui-image>`:null}
        ${e?.url?a.html`<wui-image src=${e.url} alt="Transaction image"></wui-image>`:null}
      </div>`:t?.url?a.html`<wui-image src=${t.url} alt="Transaction image"></wui-image>`:"NFT"===r?a.html`<wui-icon size="inherit" color="fg-200" name="nftPlaceholder"></wui-icon>`:a.html`<wui-icon size="inherit" color="fg-200" name="coinPlaceholder"></wui-icon>`}templateIcon(){let t,e="accent-100";return(t=this.getIcon(),this.status&&(e=this.getStatusColor()),t)?a.html`
      <wui-icon-box
        size="xxs"
        iconColor=${e}
        backgroundColor=${e}
        background="opaque"
        icon=${t}
        ?border=${!0}
        borderColor="wui-color-bg-125"
      ></wui-icon-box>
    `:null}getDirectionIcon(){switch(this.direction){case"in":return"arrowBottom";case"out":return"arrowTop";default:return}}getIcon(){return this.onlyDirectionIcon?this.getDirectionIcon():"trade"===this.type?"swapHorizontalBold":"approve"===this.type?"checkmark":"cancel"===this.type?"close":this.getDirectionIcon()}getStatusColor(){switch(this.status){case"confirmed":return"success-100";case"failed":return"error-100";case"pending":return"inverse-100";default:return"accent-100"}}};$.styles=[k],C([(0,o.property)()],$.prototype,"type",void 0),C([(0,o.property)()],$.prototype,"status",void 0),C([(0,o.property)()],$.prototype,"direction",void 0),C([(0,o.property)({type:Boolean})],$.prototype,"onlyDirectionIcon",void 0),C([(0,o.property)({type:Array})],$.prototype,"images",void 0),C([(0,o.property)({type:Object})],$.prototype,"secondImage",void 0),$=C([(0,g.customElement)("wui-transaction-visual")],$);let z=x.css`
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
`;var R=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let S=class extends m.LitElement{constructor(){super(...arguments),this.type="approve",this.onlyDirectionIcon=!1,this.images=[],this.price=[],this.amount=[],this.symbol=[]}render(){return a.html`
      <wui-flex>
        <wui-transaction-visual
          .status=${this.status}
          direction=${(0,b.ifDefined)(this.direction)}
          type=${this.type}
          onlyDirectionIcon=${(0,b.ifDefined)(this.onlyDirectionIcon)}
          .images=${this.images}
        ></wui-transaction-visual>
        <wui-flex flexDirection="column" gap="3xs">
          <wui-text variant="paragraph-600" color="fg-100">
            ${r[this.type]||this.type}
          </wui-text>
          <wui-flex class="description-container">
            ${this.templateDescription()} ${this.templateSecondDescription()}
          </wui-flex>
        </wui-flex>
        <wui-text variant="micro-700" color="fg-300"><span>${this.date}</span></wui-text>
      </wui-flex>
    `}templateDescription(){let t=this.descriptions?.[0];return t?a.html`
          <wui-text variant="small-500" color="fg-200">
            <span>${t}</span>
          </wui-text>
        `:null}templateSecondDescription(){let t=this.descriptions?.[1];return t?a.html`
          <wui-icon class="description-separator-icon" size="xxs" name="arrowRight"></wui-icon>
          <wui-text variant="small-400" color="fg-200">
            <span>${t}</span>
          </wui-text>
        `:null}};S.styles=[y.resetStyles,z],R([(0,o.property)()],S.prototype,"type",void 0),R([(0,o.property)({type:Array})],S.prototype,"descriptions",void 0),R([(0,o.property)()],S.prototype,"date",void 0),R([(0,o.property)({type:Boolean})],S.prototype,"onlyDirectionIcon",void 0),R([(0,o.property)()],S.prototype,"status",void 0),R([(0,o.property)()],S.prototype,"direction",void 0),R([(0,o.property)({type:Array})],S.prototype,"images",void 0),R([(0,o.property)({type:Array})],S.prototype,"price",void 0),R([(0,o.property)({type:Array})],S.prototype,"amount",void 0),R([(0,o.property)({type:Array})],S.prototype,"symbol",void 0),S=R([(0,g.customElement)("wui-transaction-list-item")],S);var O=i;t.i(846880);let T=x.css`
  :host > wui-flex:first-child {
    column-gap: var(--wui-spacing-s);
    padding: 7px var(--wui-spacing-l) 7px var(--wui-spacing-xs);
    width: 100%;
  }

  wui-flex {
    display: flex;
    flex: 1;
  }
`,j=class extends O.LitElement{render(){return a.html`
      <wui-flex alignItems="center">
        <wui-shimmer width="40px" height="40px"></wui-shimmer>
        <wui-flex flexDirection="column" gap="2xs">
          <wui-shimmer width="72px" height="16px" borderRadius="4xs"></wui-shimmer>
          <wui-shimmer width="148px" height="14px" borderRadius="4xs"></wui-shimmer>
        </wui-flex>
        <wui-shimmer width="24px" height="12px" borderRadius="5xs"></wui-shimmer>
      </wui-flex>
    `}};j.styles=[y.resetStyles,T],j=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s}([(0,g.customElement)("wui-transaction-list-item-loader")],j);var E=t.i(142844);let P=x.css`
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
`;var I=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let D="last-transaction",A=class extends i.LitElement{constructor(){super(),this.unsubscribe=[],this.paginationObserver=void 0,this.page="activity",this.caipAddress=l.ChainController.state.activeCaipAddress,this.transactionsByYear=h.TransactionsController.state.transactionsByYear,this.loading=h.TransactionsController.state.loading,this.empty=h.TransactionsController.state.empty,this.next=h.TransactionsController.state.next,h.TransactionsController.clearCursor(),this.unsubscribe.push(l.ChainController.subscribeKey("activeCaipAddress",t=>{t&&this.caipAddress!==t&&(h.TransactionsController.resetTransactions(),h.TransactionsController.fetchTransactions(t)),this.caipAddress=t}),l.ChainController.subscribeKey("activeCaipNetwork",()=>{this.updateTransactionView()}),h.TransactionsController.subscribe(t=>{this.transactionsByYear=t.transactionsByYear,this.loading=t.loading,this.empty=t.empty,this.next=t.next}))}firstUpdated(){this.updateTransactionView(),this.createPaginationObserver()}updated(){this.setPaginationObserver()}disconnectedCallback(){this.unsubscribe.forEach(t=>t())}render(){return a.html` ${this.empty?null:this.templateTransactionsByYear()}
    ${this.loading?this.templateLoading():null}
    ${!this.loading&&this.empty?this.templateEmpty():null}`}updateTransactionView(){h.TransactionsController.resetTransactions(),this.caipAddress&&h.TransactionsController.fetchTransactions(c.CoreHelperUtil.getPlainAddress(this.caipAddress))}templateTransactionsByYear(){return Object.keys(this.transactionsByYear).sort().reverse().map(t=>{let e=parseInt(t,10),r=Array(12).fill(null).map((t,r)=>({groupTitle:v.TransactionUtil.getTransactionGroupTitle(e,r),transactions:this.transactionsByYear[e]?.[r]})).filter(({transactions:t})=>t).reverse();return r.map(({groupTitle:t,transactions:e},i)=>{let o=i===r.length-1;return e?a.html`
          <wui-flex
            flexDirection="column"
            class="group-container"
            last-group="${o?"true":"false"}"
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
              ${this.templateTransactions(e,o)}
            </wui-flex>
          </wui-flex>
        `:null})})}templateRenderTransaction(t,e){let{date:r,descriptions:i,direction:o,isAllNFT:s,images:n,status:l,transfers:c,type:u}=this.getTransactionListItemProps(t),d=c?.length>1;return c?.length!==2||s?d?c.map((t,i)=>{let o=v.TransactionUtil.getTransferDescription(t),s=e&&i===c.length-1;return a.html` <wui-transaction-list-item
          date=${r}
          direction=${t.direction}
          id=${s&&this.next?D:""}
          status=${l}
          type=${u}
          .onlyDirectionIcon=${!0}
          .images=${[n[i]]}
          .descriptions=${[o]}
        ></wui-transaction-list-item>`}):a.html`
      <wui-transaction-list-item
        date=${r}
        .direction=${o}
        id=${e&&this.next?D:""}
        status=${l}
        type=${u}
        .images=${n}
        .descriptions=${i}
      ></wui-transaction-list-item>
    `:a.html`
        <wui-transaction-list-item
          date=${r}
          .direction=${o}
          id=${e&&this.next?D:""}
          status=${l}
          type=${u}
          .images=${n}
          .descriptions=${i}
        ></wui-transaction-list-item>
      `}templateTransactions(t,e){return t.map((r,i)=>{let o=e&&i===t.length-1;return a.html`${this.templateRenderTransaction(r,o)}`})}emptyStateActivity(){return a.html`<wui-flex
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
    </wui-flex>`}emptyStateAccount(){return a.html`<wui-flex
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
    </wui-flex>`}templateEmpty(){return"account"===this.page?a.html`${this.emptyStateAccount()}`:a.html`${this.emptyStateActivity()}`}templateLoading(){return"activity"===this.page?Array(7).fill(a.html` <wui-transaction-list-item-loader></wui-transaction-list-item-loader> `).map(t=>t):null}onReceiveClick(){p.RouterController.push("WalletReceive")}createPaginationObserver(){let{projectId:t}=d.OptionsController.state;this.paginationObserver=new IntersectionObserver(([e])=>{e?.isIntersecting&&!this.loading&&(h.TransactionsController.fetchTransactions(c.CoreHelperUtil.getPlainAddress(this.caipAddress)),u.EventsController.sendEvent({type:"track",event:"LOAD_MORE_TRANSACTIONS",properties:{address:c.CoreHelperUtil.getPlainAddress(this.caipAddress),projectId:t,cursor:this.next,isSmartAccount:(0,w.getPreferredAccountType)(l.ChainController.state.activeChain)===E.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT}}))},{}),this.setPaginationObserver()}setPaginationObserver(){this.paginationObserver?.disconnect();let t=this.shadowRoot?.querySelector(`#${D}`);t&&this.paginationObserver?.observe(t)}getTransactionListItemProps(t){let e=n.DateUtil.formatDate(t?.metadata?.minedAt),r=v.TransactionUtil.getTransactionDescriptions(t),i=t?.transfers,a=t?.transfers?.[0],o=!!a&&t?.transfers?.every(t=>!!t.nft_info),s=v.TransactionUtil.getTransactionImages(i);return{date:e,direction:a?.direction,descriptions:r,isAllNFT:o,images:s,status:t.metadata?.status,transfers:i,type:t.metadata?.operationType}}};A.styles=P,I([(0,o.property)()],A.prototype,"page",void 0),I([(0,s.state)()],A.prototype,"caipAddress",void 0),I([(0,s.state)()],A.prototype,"transactionsByYear",void 0),I([(0,s.state)()],A.prototype,"loading",void 0),I([(0,s.state)()],A.prototype,"empty",void 0),I([(0,s.state)()],A.prototype,"next",void 0),A=I([(0,g.customElement)("w3m-activity-list")],A),t.s([],801461)},229581,675164,231971,t=>{"use strict";var e=t.i(138230),r=t.i(596590),i=t.i(207176),a=t.i(729702),o=t.i(881936),s=t.i(375054),n=t.i(944396),l=t.i(301847),c=t.i(148018);async function u(){s.RouterController.push("ConnectingFarcaster");let t=a.ConnectorController.getAuthConnector();if(t&&!r.AccountController.state.farcasterUrl)try{let{url:e}=await t.provider.getFarcasterUri();r.AccountController.setFarcasterUrl(e,i.ChainController.state.activeChain)}catch(t){s.RouterController.goBack(),n.SnackController.showError(t)}}async function d(t){s.RouterController.push("ConnectingSocial");let o=a.ConnectorController.getAuthConnector(),u=null;try{let a=setTimeout(()=>{throw Error("Social login timed out. Please try again.")},45e3);if(o&&t){if(l.CoreHelperUtil.isTelegram()||(u=function(){try{return l.CoreHelperUtil.returnOpenHref(`${e.ConstantsUtil.SECURE_SITE_SDK_ORIGIN}/loading`,"popupWindow","width=600,height=800,scrollbars=yes")}catch(t){throw Error("Could not open social popup")}}()),u)r.AccountController.setSocialWindow(u,i.ChainController.state.activeChain);else if(!l.CoreHelperUtil.isTelegram())throw Error("Could not create social popup");let{uri:s}=await o.provider.getSocialRedirectUri({provider:t});if(!s)throw u?.close(),Error("Could not fetch the social redirect uri");if(u&&(u.location.href=s),l.CoreHelperUtil.isTelegram()){c.StorageUtil.setTelegramSocialProvider(t);let e=l.CoreHelperUtil.formatTelegramSocialLoginUrl(s);l.CoreHelperUtil.openHref(e,"_top")}clearTimeout(a)}}catch(t){u?.close(),n.SnackController.showError(t?.message)}}async function p(t){r.AccountController.setSocialProvider(t,i.ChainController.state.activeChain),o.EventsController.sendEvent({type:"track",event:"SOCIAL_LOGIN_STARTED",properties:{provider:t}}),"farcaster"===t?await u():await d(t)}t.s(["executeSocialLogin",()=>p],229581),t.i(588984);var h=t.i(399702),w=t.i(872857);t.i(759703);var v=t.i(392074);t.i(781840);var g=t.i(86988);t.i(596548);var m=t.i(864429),b=t.i(938559),y=h;t.i(630572);var f=t.i(118827);let x=f.css`
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
`;var k=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let C=class extends y.LitElement{constructor(){super(...arguments),this.logo="google"}render(){return w.html`<wui-icon color="inherit" size="inherit" name=${this.logo}></wui-icon> `}};C.styles=[m.resetStyles,x],k([(0,v.property)()],C.prototype,"logo",void 0),C=k([(0,b.customElement)("wui-logo")],C),t.s([],675164);let $=f.css`
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
`;var z=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let R=class extends h.LitElement{constructor(){super(...arguments),this.logo="google",this.name="Continue with google",this.align="left",this.disabled=!1}render(){return w.html`
      <button ?disabled=${this.disabled} tabindex=${(0,g.ifDefined)(this.tabIdx)}>
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
    `}templatePlacement(){return"center"===this.align?w.html` <wui-logo class="invisible" logo=${this.logo}></wui-logo>`:null}};R.styles=[m.resetStyles,m.elementStyles,$],z([(0,v.property)()],R.prototype,"logo",void 0),z([(0,v.property)()],R.prototype,"name",void 0),z([(0,v.property)()],R.prototype,"align",void 0),z([(0,v.property)()],R.prototype,"tabIdx",void 0),z([(0,v.property)({type:Boolean})],R.prototype,"disabled",void 0),R=z([(0,b.customElement)("wui-list-social")],R),t.s([],231971)},567815,(t,e,r)=>{"use strict";e.exports=function(t){for(var e=[],r=t.length,i=0;i<r;i++){var a=t.charCodeAt(i);if(a>=55296&&a<=56319&&r>i+1){var o=t.charCodeAt(i+1);o>=56320&&o<=57343&&(a=(a-55296)*1024+o-56320+65536,i+=1)}if(a<128){e.push(a);continue}if(a<2048){e.push(a>>6|192),e.push(63&a|128);continue}if(a<55296||a>=57344&&a<65536){e.push(a>>12|224),e.push(a>>6&63|128),e.push(63&a|128);continue}if(a>=65536&&a<=1114111){e.push(a>>18|240),e.push(a>>12&63|128),e.push(a>>6&63|128),e.push(63&a|128);continue}e.push(239,191,189)}return new Uint8Array(e).buffer}},143880,t=>{"use strict";t.i(588984);var e=t.i(399702),r=t.i(872857);t.i(759703);var i=t.i(392074);t.i(630572),t.i(287940);var a=t.i(520209);function o(t,e,r){return t!==e&&(t-e<0?e-t:t-e)<=r+.1}let s={generate({uri:t,size:e,logoSize:i,dotColor:s="#141414"}){let n,l,c=[],u=(l=Math.sqrt((n=Array.prototype.slice.call(a.default.create(t,{errorCorrectionLevel:"Q"}).modules.data,0)).length),n.reduce((t,e,r)=>(r%l==0?t.push([e]):t[t.length-1].push(e))&&t,[])),d=e/u.length,p=[{x:0,y:0},{x:1,y:0},{x:0,y:1}];p.forEach(({x:t,y:e})=>{let i=(u.length-7)*d*t,a=(u.length-7)*d*e;for(let t=0;t<p.length;t+=1){let e=d*(7-2*t);c.push(r.svg`
            <rect
              fill=${2===t?s:"transparent"}
              width=${0===t?e-5:e}
              rx= ${0===t?(e-5)*.45:.45*e}
              ry= ${0===t?(e-5)*.45:.45*e}
              stroke=${s}
              stroke-width=${5*(0===t)}
              height=${0===t?e-5:e}
              x= ${0===t?a+d*t+2.5:a+d*t}
              y= ${0===t?i+d*t+2.5:i+d*t}
            />
          `)}});let h=Math.floor((i+25)/d),w=u.length/2-h/2,v=u.length/2+h/2-1,g=[];u.forEach((t,e)=>{t.forEach((t,r)=>{!u[e][r]||e<7&&r<7||e>u.length-8&&r<7||e<7&&r>u.length-8||e>w&&e<v&&r>w&&r<v||g.push([e*d+d/2,r*d+d/2])})});let m={};return g.forEach(([t,e])=>{m[t]?m[t]?.push(e):m[t]=[e]}),Object.entries(m).map(([t,e])=>{let r=e.filter(t=>e.every(e=>!o(t,e,d)));return[Number(t),r]}).forEach(([t,e])=>{e.forEach(e=>{c.push(r.svg`<circle cx=${t} cy=${e} fill=${s} r=${d/2.5} />`)})}),Object.entries(m).filter(([t,e])=>e.length>1).map(([t,e])=>{let r=e.filter(t=>e.some(e=>o(t,e,d)));return[Number(t),r]}).map(([t,e])=>{e.sort((t,e)=>t<e?-1:1);let r=[];for(let t of e){let e=r.find(e=>e.some(e=>o(t,e,d)));e?e.push(t):r.push([t])}return[t,r.map(t=>[t[0],t[t.length-1]])]}).forEach(([t,e])=>{e.forEach(([e,i])=>{c.push(r.svg`
              <line
                x1=${t}
                x2=${t}
                y1=${e}
                y2=${i}
                stroke=${s}
                stroke-width=${d/1.25}
                stroke-linecap="round"
              />
            `)})}),c}};var n=t.i(864429),l=t.i(938559),c=t.i(118827);let u=c.css`
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
`;var d=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let p=class extends e.LitElement{constructor(){super(...arguments),this.uri="",this.size=0,this.theme="dark",this.imageSrc=void 0,this.alt=void 0,this.arenaClear=void 0,this.farcaster=void 0}render(){return this.dataset.theme=this.theme,this.dataset.clear=String(this.arenaClear),this.style.cssText=`
     --local-size: ${this.size}px;
     --local-icon-color: ${this.color??"#3396ff"}
    `,r.html`${this.templateVisual()} ${this.templateSvg()}`}templateSvg(){let t="light"===this.theme?this.size:this.size-32;return r.svg`
      <svg height=${t} width=${t}>
        ${s.generate({uri:this.uri,size:t,logoSize:this.arenaClear?0:t/4,dotColor:this.color})}
      </svg>
    `}templateVisual(){return this.imageSrc?r.html`<wui-image src=${this.imageSrc} alt=${this.alt??"logo"}></wui-image>`:this.farcaster?r.html`<wui-icon
        class="farcaster"
        size="inherit"
        color="inherit"
        name="farcaster"
      ></wui-icon>`:r.html`<wui-icon size="inherit" color="inherit" name="walletConnect"></wui-icon>`}};p.styles=[n.resetStyles,u],d([(0,i.property)()],p.prototype,"uri",void 0),d([(0,i.property)({type:Number})],p.prototype,"size",void 0),d([(0,i.property)()],p.prototype,"theme",void 0),d([(0,i.property)()],p.prototype,"imageSrc",void 0),d([(0,i.property)()],p.prototype,"alt",void 0),d([(0,i.property)()],p.prototype,"color",void 0),d([(0,i.property)({type:Boolean})],p.prototype,"arenaClear",void 0),d([(0,i.property)({type:Boolean})],p.prototype,"farcaster",void 0),p=d([(0,l.customElement)("wui-qr-code")],p),t.s([],143880)},843028,451801,933370,176375,t=>{"use strict";var e=t.i(725519),r=t.i(941031);let i=(0,e.proxy)({isLegalCheckboxChecked:!1}),a={state:i,subscribe:t=>(0,e.subscribe)(i,()=>t(i)),subscribeKey:(t,e)=>(0,r.subscribeKey)(i,t,e),setIsLegalCheckboxChecked(t){i.isLegalCheckboxChecked=t}};t.s(["OptionsStateController",0,a],843028),t.i(588984);var o=t.i(399702),s=t.i(872857);t.i(759703);var n=t.i(698797),l=t.i(944411);t.i(302184);var c=t.i(938559),u=o,d=t.i(392074);t.i(781840);var p=t.i(86988);t.i(812492);var h=t.i(568633);t.i(630572);var w=t.i(864429),v=t.i(118827);let g=v.css`
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
`;var m=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let b=class extends u.LitElement{constructor(){super(...arguments),this.inputElementRef=(0,h.createRef)(),this.checked=void 0}render(){return s.html`
      <label>
        <input
          ${(0,h.ref)(this.inputElementRef)}
          ?checked=${(0,p.ifDefined)(this.checked)}
          type="checkbox"
          @change=${this.dispatchChangeEvent}
        />
        <span>
          <wui-icon name="checkmarkBold" color="inverse-100" size="xxs"></wui-icon>
        </span>
        <slot></slot>
      </label>
    `}dispatchChangeEvent(){this.dispatchEvent(new CustomEvent("checkboxChange",{detail:this.inputElementRef.value?.checked,bubbles:!0,composed:!0}))}};b.styles=[w.resetStyles,g],m([(0,d.property)({type:Boolean})],b.prototype,"checked",void 0),b=m([(0,c.customElement)("wui-checkbox")],b),t.i(331658);let y=v.css`
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
`;var f=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let x=class extends o.LitElement{constructor(){super(),this.unsubscribe=[],this.checked=a.state.isLegalCheckboxChecked,this.unsubscribe.push(a.subscribeKey("isLegalCheckboxChecked",t=>{this.checked=t}))}disconnectedCallback(){this.unsubscribe.forEach(t=>t())}render(){let{termsConditionsUrl:t,privacyPolicyUrl:e}=l.OptionsController.state,r=l.OptionsController.state.features?.legalCheckbox;return(t||e)&&r?s.html`
      <wui-checkbox
        ?checked=${this.checked}
        @checkboxChange=${this.onCheckboxChange.bind(this)}
        data-testid="wui-checkbox"
      >
        <wui-text color="fg-250" variant="small-400" align="left">
          I agree to our ${this.termsTemplate()} ${this.andTemplate()} ${this.privacyTemplate()}
        </wui-text>
      </wui-checkbox>
    `:null}andTemplate(){let{termsConditionsUrl:t,privacyPolicyUrl:e}=l.OptionsController.state;return t&&e?"and":""}termsTemplate(){let{termsConditionsUrl:t}=l.OptionsController.state;return t?s.html`<a rel="noreferrer" target="_blank" href=${t}>terms of service</a>`:null}privacyTemplate(){let{privacyPolicyUrl:t}=l.OptionsController.state;return t?s.html`<a rel="noreferrer" target="_blank" href=${t}>privacy policy</a>`:null}onCheckboxChange(){a.setIsLegalCheckboxChecked(!this.checked)}};x.styles=[y],f([(0,n.state)()],x.prototype,"checked",void 0),x=f([(0,c.customElement)("w3m-legal-checkbox")],x),t.s([],451801);var k=o;t.i(237029);var C=o;t.i(596548),t.i(108476);var $=t.i(155284);let z=v.css`
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
`,R=class extends C.LitElement{render(){return s.html`
      <a
        data-testid="ux-branding-reown"
        href=${$.REOWN_URL}
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
    `}};R.styles=[w.resetStyles,w.elementStyles,z],R=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s}([(0,c.customElement)("wui-ux-by-reown")],R),t.s([],933370);let S=v.css`
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
`;var O=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let T=class extends k.LitElement{constructor(){super(),this.unsubscribe=[],this.remoteFeatures=l.OptionsController.state.remoteFeatures,this.unsubscribe.push(l.OptionsController.subscribeKey("remoteFeatures",t=>this.remoteFeatures=t))}disconnectedCallback(){this.unsubscribe.forEach(t=>t())}render(){let{termsConditionsUrl:t,privacyPolicyUrl:e}=l.OptionsController.state,r=l.OptionsController.state.features?.legalCheckbox;return(t||e)&&!r?s.html`
      <wui-flex flexDirection="column">
        <wui-flex .padding=${["m","s","s","s"]} justifyContent="center">
          <wui-text color="fg-250" variant="small-400" align="center">
            By connecting your wallet, you agree to our <br />
            ${this.termsTemplate()} ${this.andTemplate()} ${this.privacyTemplate()}
          </wui-text>
        </wui-flex>
        ${this.reownBrandingTemplate()}
      </wui-flex>
    `:s.html`
        <wui-flex flexDirection="column"> ${this.reownBrandingTemplate(!0)} </wui-flex>
      `}andTemplate(){let{termsConditionsUrl:t,privacyPolicyUrl:e}=l.OptionsController.state;return t&&e?"and":""}termsTemplate(){let{termsConditionsUrl:t}=l.OptionsController.state;return t?s.html`<a href=${t} target="_blank" rel="noopener noreferrer"
      >Terms of Service</a
    >`:null}privacyTemplate(){let{privacyPolicyUrl:t}=l.OptionsController.state;return t?s.html`<a href=${t} target="_blank" rel="noopener noreferrer"
      >Privacy Policy</a
    >`:null}reownBrandingTemplate(t=!1){return this.remoteFeatures?.reownBranding?t?s.html`<wui-ux-by-reown class="branding-only"></wui-ux-by-reown>`:s.html`<wui-ux-by-reown></wui-ux-by-reown>`:null}};T.styles=[S],O([(0,n.state)()],T.prototype,"remoteFeatures",void 0),T=O([(0,c.customElement)("w3m-legal-footer")],T),t.s([],176375)},180594,t=>{"use strict";t.i(588984);var e=t.i(399702),r=t.i(872857);t.i(759703);var i=t.i(392074);t.i(781840);var a=t.i(86988);t.i(596548);var o=t.i(864429),s=t.i(938559);t.i(525370);var n=t.i(118827);let l=n.css`
  :host {
    position: relative;
    display: inline-block;
  }

  wui-text {
    margin: var(--wui-spacing-xxs) var(--wui-spacing-m) var(--wui-spacing-0) var(--wui-spacing-m);
  }
`;var c=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let u=class extends e.LitElement{constructor(){super(...arguments),this.disabled=!1}render(){return r.html`
      <wui-input-text
        type="email"
        placeholder="Email"
        icon="mail"
        size="mdl"
        .disabled=${this.disabled}
        .value=${this.value}
        data-testid="wui-email-input"
        tabIdx=${(0,a.ifDefined)(this.tabIdx)}
      ></wui-input-text>
      ${this.templateError()}
    `}templateError(){return this.errorMessage?r.html`<wui-text variant="tiny-500" color="error-100">${this.errorMessage}</wui-text>`:null}};u.styles=[o.resetStyles,l],c([(0,i.property)()],u.prototype,"errorMessage",void 0),c([(0,i.property)({type:Boolean})],u.prototype,"disabled",void 0),c([(0,i.property)()],u.prototype,"value",void 0),c([(0,i.property)()],u.prototype,"tabIdx",void 0),u=c([(0,s.customElement)("wui-email-input")],u),t.s([],180594)},330885,t=>{"use strict";t.i(588984);var e=t.i(399702),r=t.i(872857);t.i(759703);var i=t.i(392074);t.i(630572),t.i(287940),t.i(596548);var a=t.i(864429),o=t.i(938559),s=t.i(118827);let n=s.css`
  button {
    border: none;
    border-radius: var(--wui-border-radius-3xl);
  }

  button[data-variant='main'] {
    background-color: var(--wui-color-accent-100);
    color: var(--wui-color-inverse-100);
    box-shadow: inset 0 0 0 1px var(--wui-color-gray-glass-010);
  }

  button[data-variant='accent'] {
    background-color: var(--wui-color-accent-glass-010);
    color: var(--wui-color-accent-100);
    box-shadow: inset 0 0 0 1px var(--wui-color-gray-glass-005);
  }

  button[data-variant='gray'] {
    background-color: transparent;
    color: var(--wui-color-fg-200);
    box-shadow: inset 0 0 0 1px var(--wui-color-gray-glass-010);
  }

  button[data-variant='shade'] {
    background-color: transparent;
    color: var(--wui-color-accent-100);
    box-shadow: inset 0 0 0 1px var(--wui-color-gray-glass-010);
  }

  button[data-size='sm'] {
    height: 32px;
    padding: 0 var(--wui-spacing-s);
  }

  button[data-size='md'] {
    height: 40px;
    padding: 0 var(--wui-spacing-l);
  }

  button[data-size='sm'] > wui-image {
    width: 16px;
    height: 16px;
  }

  button[data-size='md'] > wui-image {
    width: 24px;
    height: 24px;
  }

  button[data-size='sm'] > wui-icon {
    width: 12px;
    height: 12px;
  }

  button[data-size='md'] > wui-icon {
    width: 14px;
    height: 14px;
  }

  wui-image {
    border-radius: var(--wui-border-radius-3xl);
    overflow: hidden;
  }

  button.disabled > wui-icon,
  button.disabled > wui-image {
    filter: grayscale(1);
  }

  button[data-variant='main'] > wui-image {
    box-shadow: inset 0 0 0 1px var(--wui-color-accent-090);
  }

  button[data-variant='shade'] > wui-image,
  button[data-variant='gray'] > wui-image {
    box-shadow: inset 0 0 0 1px var(--wui-color-gray-glass-010);
  }

  @media (hover: hover) and (pointer: fine) {
    button[data-variant='main']:focus-visible {
      background-color: var(--wui-color-accent-090);
    }

    button[data-variant='main']:hover:enabled {
      background-color: var(--wui-color-accent-090);
    }

    button[data-variant='main']:active:enabled {
      background-color: var(--wui-color-accent-080);
    }

    button[data-variant='accent']:hover:enabled {
      background-color: var(--wui-color-accent-glass-015);
    }

    button[data-variant='accent']:active:enabled {
      background-color: var(--wui-color-accent-glass-020);
    }

    button[data-variant='shade']:focus-visible,
    button[data-variant='gray']:focus-visible,
    button[data-variant='shade']:hover,
    button[data-variant='gray']:hover {
      background-color: var(--wui-color-gray-glass-002);
    }

    button[data-variant='gray']:active,
    button[data-variant='shade']:active {
      background-color: var(--wui-color-gray-glass-005);
    }
  }

  button.disabled {
    color: var(--wui-color-gray-glass-020);
    background-color: var(--wui-color-gray-glass-002);
    box-shadow: inset 0 0 0 1px var(--wui-color-gray-glass-002);
    pointer-events: none;
  }
`;var l=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let c=class extends e.LitElement{constructor(){super(...arguments),this.variant="accent",this.imageSrc="",this.disabled=!1,this.icon="externalLink",this.size="md",this.text=""}render(){let t="sm"===this.size?"small-600":"paragraph-600";return r.html`
      <button
        class=${this.disabled?"disabled":""}
        data-variant=${this.variant}
        data-size=${this.size}
        ?disabled=${this.disabled}
      >
        ${this.imageSrc?r.html`<wui-image src=${this.imageSrc}></wui-image>`:null}
        <wui-text variant=${t} color="inherit"> ${this.text} </wui-text>
        ${this.icon?r.html`<wui-icon name=${this.icon} color="inherit" size="inherit"></wui-icon>`:null}
      </button>
    `}};c.styles=[a.resetStyles,a.elementStyles,n],l([(0,i.property)()],c.prototype,"variant",void 0),l([(0,i.property)()],c.prototype,"imageSrc",void 0),l([(0,i.property)({type:Boolean})],c.prototype,"disabled",void 0),l([(0,i.property)()],c.prototype,"icon",void 0),l([(0,i.property)()],c.prototype,"size",void 0),l([(0,i.property)()],c.prototype,"text",void 0),c=l([(0,o.customElement)("wui-chip-button")],c),t.s([],330885)},474025,t=>{"use strict";t.i(588984);var e=t.i(399702),r=t.i(872857);t.i(759703);var i=t.i(698797),a=t.i(375054),o=t.i(420435);t.i(302184);var s=t.i(938559),n=t.i(924487),l=t.i(118827);let c=l.css`
  :host {
    --prev-height: 0px;
    --new-height: 0px;
    display: block;
  }

  div.w3m-router-container {
    transform: translateY(0);
    opacity: 1;
  }

  div.w3m-router-container[view-direction='prev'] {
    animation:
      slide-left-out 150ms forwards ease,
      slide-left-in 150ms forwards ease;
    animation-delay: 0ms, 200ms;
  }

  div.w3m-router-container[view-direction='next'] {
    animation:
      slide-right-out 150ms forwards ease,
      slide-right-in 150ms forwards ease;
    animation-delay: 0ms, 200ms;
  }

  @keyframes slide-left-out {
    from {
      transform: translateX(0px);
      opacity: 1;
    }
    to {
      transform: translateX(10px);
      opacity: 0;
    }
  }

  @keyframes slide-left-in {
    from {
      transform: translateX(-10px);
      opacity: 0;
    }
    to {
      transform: translateX(0);
      opacity: 1;
    }
  }

  @keyframes slide-right-out {
    from {
      transform: translateX(0px);
      opacity: 1;
    }
    to {
      transform: translateX(-10px);
      opacity: 0;
    }
  }

  @keyframes slide-right-in {
    from {
      transform: translateX(10px);
      opacity: 0;
    }
    to {
      transform: translateX(0);
      opacity: 1;
    }
  }
`;var u=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let d=class extends e.LitElement{constructor(){super(),this.resizeObserver=void 0,this.prevHeight="0px",this.prevHistoryLength=1,this.unsubscribe=[],this.view=a.RouterController.state.view,this.viewDirection="",this.unsubscribe.push(a.RouterController.subscribeKey("view",t=>this.onViewChange(t)))}firstUpdated(){this.resizeObserver=new ResizeObserver(([t])=>{let e=`${t?.contentRect.height}px`;"0px"!==this.prevHeight&&(this.style.setProperty("--prev-height",this.prevHeight),this.style.setProperty("--new-height",e),this.style.animation="w3m-view-height 150ms forwards ease",this.style.height="auto"),setTimeout(()=>{this.prevHeight=e,this.style.animation="unset"},n.ConstantsUtil.ANIMATION_DURATIONS.ModalHeight)}),this.resizeObserver?.observe(this.getWrapper())}disconnectedCallback(){this.resizeObserver?.unobserve(this.getWrapper()),this.unsubscribe.forEach(t=>t())}render(){return r.html`<div class="w3m-router-container" view-direction="${this.viewDirection}">
      ${this.viewTemplate()}
    </div>`}viewTemplate(){switch(this.view){case"AccountSettings":return r.html`<w3m-account-settings-view></w3m-account-settings-view>`;case"Account":return r.html`<w3m-account-view></w3m-account-view>`;case"AllWallets":return r.html`<w3m-all-wallets-view></w3m-all-wallets-view>`;case"ApproveTransaction":return r.html`<w3m-approve-transaction-view></w3m-approve-transaction-view>`;case"BuyInProgress":return r.html`<w3m-buy-in-progress-view></w3m-buy-in-progress-view>`;case"ChooseAccountName":return r.html`<w3m-choose-account-name-view></w3m-choose-account-name-view>`;case"Connect":default:return r.html`<w3m-connect-view></w3m-connect-view>`;case"Create":return r.html`<w3m-connect-view walletGuide="explore"></w3m-connect-view>`;case"ConnectingWalletConnect":return r.html`<w3m-connecting-wc-view></w3m-connecting-wc-view>`;case"ConnectingWalletConnectBasic":return r.html`<w3m-connecting-wc-basic-view></w3m-connecting-wc-basic-view>`;case"ConnectingExternal":return r.html`<w3m-connecting-external-view></w3m-connecting-external-view>`;case"ConnectingSiwe":return r.html`<w3m-connecting-siwe-view></w3m-connecting-siwe-view>`;case"ConnectWallets":return r.html`<w3m-connect-wallets-view></w3m-connect-wallets-view>`;case"ConnectSocials":return r.html`<w3m-connect-socials-view></w3m-connect-socials-view>`;case"ConnectingSocial":return r.html`<w3m-connecting-social-view></w3m-connecting-social-view>`;case"DataCapture":return r.html`<w3m-data-capture-view></w3m-data-capture-view>`;case"DataCaptureOtpConfirm":return r.html`<w3m-data-capture-otp-confirm-view></w3m-data-capture-otp-confirm-view>`;case"Downloads":return r.html`<w3m-downloads-view></w3m-downloads-view>`;case"EmailLogin":return r.html`<w3m-email-login-view></w3m-email-login-view>`;case"EmailVerifyOtp":return r.html`<w3m-email-verify-otp-view></w3m-email-verify-otp-view>`;case"EmailVerifyDevice":return r.html`<w3m-email-verify-device-view></w3m-email-verify-device-view>`;case"GetWallet":return r.html`<w3m-get-wallet-view></w3m-get-wallet-view>`;case"Networks":return r.html`<w3m-networks-view></w3m-networks-view>`;case"SwitchNetwork":return r.html`<w3m-network-switch-view></w3m-network-switch-view>`;case"ProfileWallets":return r.html`<w3m-profile-wallets-view></w3m-profile-wallets-view>`;case"Transactions":return r.html`<w3m-transactions-view></w3m-transactions-view>`;case"OnRampProviders":return r.html`<w3m-onramp-providers-view></w3m-onramp-providers-view>`;case"OnRampTokenSelect":return r.html`<w3m-onramp-token-select-view></w3m-onramp-token-select-view>`;case"OnRampFiatSelect":return r.html`<w3m-onramp-fiat-select-view></w3m-onramp-fiat-select-view>`;case"UpgradeEmailWallet":return r.html`<w3m-upgrade-wallet-view></w3m-upgrade-wallet-view>`;case"UpdateEmailWallet":return r.html`<w3m-update-email-wallet-view></w3m-update-email-wallet-view>`;case"UpdateEmailPrimaryOtp":return r.html`<w3m-update-email-primary-otp-view></w3m-update-email-primary-otp-view>`;case"UpdateEmailSecondaryOtp":return r.html`<w3m-update-email-secondary-otp-view></w3m-update-email-secondary-otp-view>`;case"UnsupportedChain":return r.html`<w3m-unsupported-chain-view></w3m-unsupported-chain-view>`;case"Swap":return r.html`<w3m-swap-view></w3m-swap-view>`;case"SwapSelectToken":return r.html`<w3m-swap-select-token-view></w3m-swap-select-token-view>`;case"SwapPreview":return r.html`<w3m-swap-preview-view></w3m-swap-preview-view>`;case"WalletSend":return r.html`<w3m-wallet-send-view></w3m-wallet-send-view>`;case"WalletSendSelectToken":return r.html`<w3m-wallet-send-select-token-view></w3m-wallet-send-select-token-view>`;case"WalletSendPreview":return r.html`<w3m-wallet-send-preview-view></w3m-wallet-send-preview-view>`;case"WhatIsABuy":return r.html`<w3m-what-is-a-buy-view></w3m-what-is-a-buy-view>`;case"WalletReceive":return r.html`<w3m-wallet-receive-view></w3m-wallet-receive-view>`;case"WalletCompatibleNetworks":return r.html`<w3m-wallet-compatible-networks-view></w3m-wallet-compatible-networks-view>`;case"WhatIsAWallet":return r.html`<w3m-what-is-a-wallet-view></w3m-what-is-a-wallet-view>`;case"ConnectingMultiChain":return r.html`<w3m-connecting-multi-chain-view></w3m-connecting-multi-chain-view>`;case"WhatIsANetwork":return r.html`<w3m-what-is-a-network-view></w3m-what-is-a-network-view>`;case"ConnectingFarcaster":return r.html`<w3m-connecting-farcaster-view></w3m-connecting-farcaster-view>`;case"SwitchActiveChain":return r.html`<w3m-switch-active-chain-view></w3m-switch-active-chain-view>`;case"RegisterAccountName":return r.html`<w3m-register-account-name-view></w3m-register-account-name-view>`;case"RegisterAccountNameSuccess":return r.html`<w3m-register-account-name-success-view></w3m-register-account-name-success-view>`;case"SmartSessionCreated":return r.html`<w3m-smart-session-created-view></w3m-smart-session-created-view>`;case"SmartSessionList":return r.html`<w3m-smart-session-list-view></w3m-smart-session-list-view>`;case"SIWXSignMessage":return r.html`<w3m-siwx-sign-message-view></w3m-siwx-sign-message-view>`;case"Pay":return r.html`<w3m-pay-view></w3m-pay-view>`;case"PayLoading":return r.html`<w3m-pay-loading-view></w3m-pay-loading-view>`;case"FundWallet":return r.html`<w3m-fund-wallet-view></w3m-fund-wallet-view>`;case"PayWithExchange":return r.html`<w3m-deposit-from-exchange-view></w3m-deposit-from-exchange-view>`}}onViewChange(t){o.TooltipController.hide();let e=n.ConstantsUtil.VIEW_DIRECTION.Next,{history:r}=a.RouterController.state;r.length<this.prevHistoryLength&&(e=n.ConstantsUtil.VIEW_DIRECTION.Prev),this.prevHistoryLength=r.length,this.viewDirection=e,setTimeout(()=>{this.view=t},n.ConstantsUtil.ANIMATION_DURATIONS.ViewTransition)}getWrapper(){return this.shadowRoot?.querySelector("div")}};d.styles=c,u([(0,i.state)()],d.prototype,"view",void 0),u([(0,i.state)()],d.prototype,"viewDirection",void 0),d=u([(0,s.customElement)("w3m-router")],d),t.s(["W3mRouter",()=>d],474025)},641912,420435,t=>{"use strict";t.i(588984);var e=t.i(399702),r=t.i(872857);t.i(759703);var i=t.i(698797),a=t.i(725519),o=t.i(941031),s=t.i(869067);let n=(0,a.proxy)({message:"",open:!1,triggerRect:{width:0,height:0,top:0,left:0},variant:"shade"}),l=(0,s.withErrorBoundary)({state:n,subscribe:t=>(0,a.subscribe)(n,()=>t(n)),subscribeKey:(t,e)=>(0,o.subscribeKey)(n,t,e),showTooltip({message:t,triggerRect:e,variant:r}){n.open=!0,n.message=t,n.triggerRect=e,n.variant=r},hide(){n.open=!1,n.message="",n.triggerRect={width:0,height:0,top:0,left:0}}});t.s(["TooltipController",0,l],420435),t.i(302184);var c=t.i(938559);t.i(237029),t.i(982221),t.i(331658);var u=t.i(118827);let d=u.css`
  :host {
    pointer-events: none;
  }

  :host > wui-flex {
    display: var(--w3m-tooltip-display);
    opacity: var(--w3m-tooltip-opacity);
    padding: 9px var(--wui-spacing-s) 10px var(--wui-spacing-s);
    border-radius: var(--wui-border-radius-xxs);
    color: var(--wui-color-bg-100);
    position: fixed;
    top: var(--w3m-tooltip-top);
    left: var(--w3m-tooltip-left);
    transform: translate(calc(-50% + var(--w3m-tooltip-parent-width)), calc(-100% - 8px));
    max-width: calc(var(--w3m-modal-width) - var(--wui-spacing-xl));
    transition: opacity 0.2s var(--wui-ease-out-power-2);
    will-change: opacity;
  }

  :host([data-variant='shade']) > wui-flex {
    background-color: var(--wui-color-bg-150);
    border: 1px solid var(--wui-color-gray-glass-005);
  }

  :host([data-variant='shade']) > wui-flex > wui-text {
    color: var(--wui-color-fg-150);
  }

  :host([data-variant='fill']) > wui-flex {
    background-color: var(--wui-color-fg-100);
    border: none;
  }

  wui-icon {
    position: absolute;
    width: 12px !important;
    height: 4px !important;
    color: var(--wui-color-bg-150);
  }

  wui-icon[data-placement='top'] {
    bottom: 0px;
    left: 50%;
    transform: translate(-50%, 95%);
  }

  wui-icon[data-placement='bottom'] {
    top: 0;
    left: 50%;
    transform: translate(-50%, -95%) rotate(180deg);
  }

  wui-icon[data-placement='right'] {
    top: 50%;
    left: 0;
    transform: translate(-65%, -50%) rotate(90deg);
  }

  wui-icon[data-placement='left'] {
    top: 50%;
    right: 0%;
    transform: translate(65%, -50%) rotate(270deg);
  }
`;var p=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let h=class extends e.LitElement{constructor(){super(),this.unsubscribe=[],this.open=l.state.open,this.message=l.state.message,this.triggerRect=l.state.triggerRect,this.variant=l.state.variant,this.unsubscribe.push(l.subscribe(t=>{this.open=t.open,this.message=t.message,this.triggerRect=t.triggerRect,this.variant=t.variant}))}disconnectedCallback(){this.unsubscribe.forEach(t=>t())}render(){this.dataset.variant=this.variant;let t=this.triggerRect.top,e=this.triggerRect.left;return this.style.cssText=`
    --w3m-tooltip-top: ${t}px;
    --w3m-tooltip-left: ${e}px;
    --w3m-tooltip-parent-width: ${this.triggerRect.width/2}px;
    --w3m-tooltip-display: ${this.open?"flex":"none"};
    --w3m-tooltip-opacity: ${+!!this.open};
    `,r.html`<wui-flex>
      <wui-icon data-placement="top" color="fg-100" size="inherit" name="cursor"></wui-icon>
      <wui-text color="inherit" variant="small-500">${this.message}</wui-text>
    </wui-flex>`}};h.styles=[d],p([(0,i.state)()],h.prototype,"open",void 0),p([(0,i.state)()],h.prototype,"message",void 0),p([(0,i.state)()],h.prototype,"triggerRect",void 0),p([(0,i.state)()],h.prototype,"variant",void 0),h=p([(0,c.customElement)("w3m-tooltip"),(0,c.customElement)("w3m-tooltip")],h),t.s([],641912)},679556,282969,t=>{"use strict";t.i(588984);var e=t.i(399702),r=t.i(872857);t.i(759703);var i=t.i(392074);t.i(630572);var a=t.i(864429),o=t.i(938559),s=t.i(118827);let n=s.css`
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
`;var l=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let c=class extends e.LitElement{constructor(){super(...arguments),this.size="md",this.disabled=!1,this.icon="copy",this.iconColor="inherit"}render(){this.dataset.size=this.size;let t="",e="";switch(this.size){case"lg":t="--wui-border-radius-xs",e="--wui-spacing-1xs";break;case"sm":t="--wui-border-radius-3xs",e="--wui-spacing-xxs";break;default:t="--wui-border-radius-xxs",e="--wui-spacing-2xs"}return this.style.cssText=`
    --local-border-radius: var(${t});
    --local-padding: var(${e});
    `,r.html`
      <button ?disabled=${this.disabled}>
        <wui-icon color=${this.iconColor} size=${this.size} name=${this.icon}></wui-icon>
      </button>
    `}};c.styles=[a.resetStyles,a.elementStyles,a.colorStyles,n],l([(0,i.property)()],c.prototype,"size",void 0),l([(0,i.property)({type:Boolean})],c.prototype,"disabled",void 0),l([(0,i.property)()],c.prototype,"icon",void 0),l([(0,i.property)()],c.prototype,"iconColor",void 0),c=l([(0,o.customElement)("wui-icon-link")],c),t.s([],282969),t.s([],679556)},990237,185212,t=>{"use strict";t.i(588984);var e=t.i(399702),r=t.i(872857);t.i(759703);var i=t.i(392074);t.i(596548);var a=t.i(864429),o=t.i(938559),s=t.i(118827);let n=s.css`
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
`;var l=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let c=class extends e.LitElement{constructor(){super(...arguments),this.variant="main",this.size="lg"}render(){this.dataset.variant=this.variant,this.dataset.size=this.size;let t="md"===this.size||"xs"===this.size?"mini-700":"micro-700";return r.html`
      <wui-text data-variant=${this.variant} variant=${t} color="inherit">
        <slot></slot>
      </wui-text>
    `}};c.styles=[a.resetStyles,n],l([(0,i.property)()],c.prototype,"variant",void 0),l([(0,i.property)()],c.prototype,"size",void 0),c=l([(0,o.customElement)("wui-tag")],c),t.s([],185212),t.s([],990237)},211366,t=>{"use strict";t.i(846880),t.s([])},982221,t=>{"use strict";t.i(630572),t.s([])},287940,t=>{"use strict";t.i(588984);var e=t.i(399702),r=t.i(872857);t.i(759703);var i=t.i(392074),a=t.i(864429),o=t.i(938559),s=t.i(118827);let n=s.css`
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
`;var l=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let c=class extends e.LitElement{constructor(){super(...arguments),this.src="./path/to/image.jpg",this.alt="Image",this.size=void 0,this.objectFit="cover"}render(){return this.objectFit&&(this.dataset.objectFit=this.objectFit),this.style.cssText=`
      --local-width: ${this.size?`var(--wui-icon-size-${this.size});`:"100%"};
      --local-height: ${this.size?`var(--wui-icon-size-${this.size});`:"100%"};
      `,r.html`<img src=${this.src} alt=${this.alt} @error=${this.handleImageError} />`}handleImageError(){this.dispatchEvent(new CustomEvent("onLoadError",{bubbles:!0,composed:!0}))}};c.styles=[a.resetStyles,a.colorStyles,n],l([(0,i.property)()],c.prototype,"src",void 0),l([(0,i.property)()],c.prototype,"alt",void 0),l([(0,i.property)()],c.prototype,"size",void 0),l([(0,i.property)()],c.prototype,"objectFit",void 0),c=l([(0,o.customElement)("wui-image")],c),t.s([],287940)},829162,t=>{"use strict";t.i(588984);var e=t.i(399702),r=t.i(872857);t.i(759703);var i=t.i(392074),a=t.i(864429),o=t.i(938559),s=t.i(118827);let n=s.css`
  :host {
    display: flex;
  }

  :host([data-size='sm']) > svg {
    width: 12px;
    height: 12px;
  }

  :host([data-size='md']) > svg {
    width: 16px;
    height: 16px;
  }

  :host([data-size='lg']) > svg {
    width: 24px;
    height: 24px;
  }

  :host([data-size='xl']) > svg {
    width: 32px;
    height: 32px;
  }

  svg {
    animation: rotate 2s linear infinite;
  }

  circle {
    fill: none;
    stroke: var(--local-color);
    stroke-width: 4px;
    stroke-dasharray: 1, 124;
    stroke-dashoffset: 0;
    stroke-linecap: round;
    animation: dash 1.5s ease-in-out infinite;
  }

  :host([data-size='md']) > svg > circle {
    stroke-width: 6px;
  }

  :host([data-size='sm']) > svg > circle {
    stroke-width: 8px;
  }

  @keyframes rotate {
    100% {
      transform: rotate(360deg);
    }
  }

  @keyframes dash {
    0% {
      stroke-dasharray: 1, 124;
      stroke-dashoffset: 0;
    }

    50% {
      stroke-dasharray: 90, 124;
      stroke-dashoffset: -35;
    }

    100% {
      stroke-dashoffset: -125;
    }
  }
`;var l=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let c=class extends e.LitElement{constructor(){super(...arguments),this.color="accent-100",this.size="lg"}render(){return this.style.cssText=`--local-color: ${"inherit"===this.color?"inherit":`var(--wui-color-${this.color})`}`,this.dataset.size=this.size,r.html`<svg viewBox="25 25 50 50">
      <circle r="20" cy="50" cx="50"></circle>
    </svg>`}};c.styles=[a.resetStyles,n],l([(0,i.property)()],c.prototype,"color",void 0),l([(0,i.property)()],c.prototype,"size",void 0),c=l([(0,o.customElement)("wui-loading-spinner")],c),t.s([],829162)},839432,t=>{"use strict";t.i(588984);var e=t.i(399702),r=t.i(872857);t.i(759703);var i=t.i(392074);t.i(630572);var a=t.i(864429),o=t.i(938559),s=t.i(118827);let n=s.css`
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
`;var l=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let c=class extends e.LitElement{constructor(){super(...arguments),this.size="md",this.backgroundColor="accent-100",this.iconColor="accent-100",this.background="transparent",this.border=!1,this.borderColor="wui-color-bg-125",this.icon="copy"}render(){let t=this.iconSize||this.size,e="lg"===this.size,i="xl"===this.size,a="gray"===this.background,o="opaque"===this.background,s="accent-100"===this.backgroundColor&&o||"success-100"===this.backgroundColor&&o||"error-100"===this.backgroundColor&&o||"inverse-100"===this.backgroundColor&&o,n=`var(--wui-color-${this.backgroundColor})`;return s?n=`var(--wui-icon-box-bg-${this.backgroundColor})`:a&&(n=`var(--wui-color-gray-${this.backgroundColor})`),this.style.cssText=`
       --local-bg-value: ${n};
       --local-bg-mix: ${s||a?"100%":e?"12%":"16%"};
       --local-border-radius: var(--wui-border-radius-${e?"xxs":i?"s":"3xl"});
       --local-size: var(--wui-icon-box-size-${this.size});
       --local-border: ${"wui-color-bg-125"===this.borderColor?"2px":"1px"} solid ${this.border?`var(--${this.borderColor})`:"transparent"}
   `,r.html` <wui-icon color=${this.iconColor} size=${t} name=${this.icon}></wui-icon> `}};c.styles=[a.resetStyles,a.elementStyles,n],l([(0,i.property)()],c.prototype,"size",void 0),l([(0,i.property)()],c.prototype,"backgroundColor",void 0),l([(0,i.property)()],c.prototype,"iconColor",void 0),l([(0,i.property)()],c.prototype,"iconSize",void 0),l([(0,i.property)()],c.prototype,"background",void 0),l([(0,i.property)({type:Boolean})],c.prototype,"border",void 0),l([(0,i.property)()],c.prototype,"borderColor",void 0),l([(0,i.property)()],c.prototype,"icon",void 0),c=l([(0,o.customElement)("wui-icon-box")],c),t.s([],839432)},81981,998281,t=>{"use strict";t.i(588984);var e=t.i(399702),r=t.i(872857);t.i(759703);var i=t.i(392074);t.i(829162),t.i(596548);var a=t.i(864429),o=t.i(938559),s=t.i(118827);let n=s.css`
  :host {
    width: var(--local-width);
    position: relative;
  }

  button {
    border: none;
    border-radius: var(--local-border-radius);
    width: var(--local-width);
    white-space: nowrap;
  }

  /* -- Sizes --------------------------------------------------- */
  button[data-size='xs'] {
    padding: var(--wui-spacing-3xs) var(--wui-spacing-s) var(--wui-spacing-3xs) var(--wui-spacing-s);
    height: 24px;
  }

  button[data-size='xs'][data-icon-left='true'][data-icon-right='false'] {
    padding: var(--wui-spacing-3xs) var(--wui-spacing-s) var(--wui-spacing-3xs) var(--wui-spacing-s);
  }

  button[data-size='xs'][data-icon-right='true'][data-icon-left='false'] {
    padding: var(--wui-spacing-3xs) var(--wui-spacing-s) var(--wui-spacing-3xs) var(--wui-spacing-s);
  }

  button[data-size='sm'] {
    padding: 7.2px var(--wui-spacing-s) 7.2px var(--wui-spacing-s);
    height: 32px;
  }

  button[data-size='sm'][data-icon-left='true'][data-icon-right='false'] {
    padding: 7.2px var(--wui-spacing-s) 7.2px var(--wui-spacing-s);
  }

  button[data-size='sm'][data-icon-right='true'][data-icon-left='false'] {
    padding: 7.2px var(--wui-spacing-s) 7.2px var(--wui-spacing-s);
  }

  button[data-size='md'] {
    padding: 8.2px var(--wui-spacing-l) 9px var(--wui-spacing-l);
    height: 36px;
  }

  button[data-size='md'][data-icon-left='true'][data-icon-right='false'] {
    padding: 8.2px var(--wui-spacing-l) 9px var(--wui-spacing-s);
  }

  button[data-size='md'][data-icon-right='true'][data-icon-left='false'] {
    padding: 8.2px var(--wui-spacing-s) 9px var(--wui-spacing-l);
  }

  button[data-size='lg'] {
    padding: var(--wui-spacing-m) var(--wui-spacing-2l);
    height: 48px;
  }

  /* -- Variants --------------------------------------------------------- */
  button[data-variant='main'] {
    background-color: var(--wui-color-accent-100);
    color: var(--wui-color-inverse-100);
    border: none;
    box-shadow: inset 0 0 0 1px var(--wui-color-gray-glass-010);
  }

  button[data-variant='inverse'] {
    background-color: var(--wui-color-inverse-100);
    color: var(--wui-color-inverse-000);
    border: none;
    box-shadow: inset 0 0 0 1px var(--wui-color-gray-glass-010);
  }

  button[data-variant='accent'] {
    background-color: var(--wui-color-accent-glass-010);
    color: var(--wui-color-accent-100);
    border: none;
    box-shadow: inset 0 0 0 1px var(--wui-color-gray-glass-005);
  }

  button[data-variant='accent-error'] {
    background: var(--wui-color-error-glass-015);
    color: var(--wui-color-error-100);
    border: none;
    box-shadow: inset 0 0 0 1px var(--wui-color-error-glass-010);
  }

  button[data-variant='accent-success'] {
    background: var(--wui-color-success-glass-015);
    color: var(--wui-color-success-100);
    border: none;
    box-shadow: inset 0 0 0 1px var(--wui-color-success-glass-010);
  }

  button[data-variant='neutral'] {
    background: transparent;
    color: var(--wui-color-fg-100);
    border: none;
    box-shadow: inset 0 0 0 1px var(--wui-color-gray-glass-005);
  }

  button[data-variant='shade'] {
    background: var(--wui-color-gray-glass-002);
    color: var(--wui-color-fg-200);
    border: none;
    box-shadow: inset 0 0 0 1px var(--wui-color-gray-glass-005);
  }

  /* -- Focus states --------------------------------------------------- */
  button[data-variant='main']:focus-visible:enabled {
    background-color: var(--wui-color-accent-090);
    box-shadow:
      inset 0 0 0 1px var(--wui-color-accent-100),
      0 0 0 4px var(--wui-color-accent-glass-020);
  }
  button[data-variant='inverse']:focus-visible:enabled {
    background-color: var(--wui-color-inverse-100);
    box-shadow:
      inset 0 0 0 1px var(--wui-color-gray-glass-010),
      0 0 0 4px var(--wui-color-accent-glass-020);
  }
  button[data-variant='accent']:focus-visible:enabled {
    background-color: var(--wui-color-accent-glass-010);
    box-shadow:
      inset 0 0 0 1px var(--wui-color-accent-100),
      0 0 0 4px var(--wui-color-accent-glass-020);
  }
  button[data-variant='accent-error']:focus-visible:enabled {
    background: var(--wui-color-error-glass-015);
    box-shadow:
      inset 0 0 0 1px var(--wui-color-error-100),
      0 0 0 4px var(--wui-color-error-glass-020);
  }
  button[data-variant='accent-success']:focus-visible:enabled {
    background: var(--wui-color-success-glass-015);
    box-shadow:
      inset 0 0 0 1px var(--wui-color-success-100),
      0 0 0 4px var(--wui-color-success-glass-020);
  }
  button[data-variant='neutral']:focus-visible:enabled {
    background: var(--wui-color-gray-glass-005);
    box-shadow:
      inset 0 0 0 1px var(--wui-color-gray-glass-010),
      0 0 0 4px var(--wui-color-gray-glass-002);
  }
  button[data-variant='shade']:focus-visible:enabled {
    background: var(--wui-color-gray-glass-005);
    box-shadow:
      inset 0 0 0 1px var(--wui-color-gray-glass-010),
      0 0 0 4px var(--wui-color-gray-glass-002);
  }

  /* -- Hover & Active states ----------------------------------------------------------- */
  @media (hover: hover) and (pointer: fine) {
    button[data-variant='main']:hover:enabled {
      background-color: var(--wui-color-accent-090);
    }

    button[data-variant='main']:active:enabled {
      background-color: var(--wui-color-accent-080);
    }

    button[data-variant='accent']:hover:enabled {
      background-color: var(--wui-color-accent-glass-015);
    }

    button[data-variant='accent']:active:enabled {
      background-color: var(--wui-color-accent-glass-020);
    }

    button[data-variant='accent-error']:hover:enabled {
      background: var(--wui-color-error-glass-020);
      color: var(--wui-color-error-100);
    }

    button[data-variant='accent-error']:active:enabled {
      background: var(--wui-color-error-glass-030);
      color: var(--wui-color-error-100);
    }

    button[data-variant='accent-success']:hover:enabled {
      background: var(--wui-color-success-glass-020);
      color: var(--wui-color-success-100);
    }

    button[data-variant='accent-success']:active:enabled {
      background: var(--wui-color-success-glass-030);
      color: var(--wui-color-success-100);
    }

    button[data-variant='neutral']:hover:enabled {
      background: var(--wui-color-gray-glass-002);
    }

    button[data-variant='neutral']:active:enabled {
      background: var(--wui-color-gray-glass-005);
    }

    button[data-size='lg'][data-icon-left='true'][data-icon-right='false'] {
      padding-left: var(--wui-spacing-m);
    }

    button[data-size='lg'][data-icon-right='true'][data-icon-left='false'] {
      padding-right: var(--wui-spacing-m);
    }

    button[data-variant='shade']:hover:enabled {
      background: var(--wui-color-gray-glass-002);
    }

    button[data-variant='shade']:active:enabled {
      background: var(--wui-color-gray-glass-005);
    }
  }

  /* -- Disabled state --------------------------------------------------- */
  button:disabled {
    background-color: var(--wui-color-gray-glass-002);
    box-shadow: inset 0 0 0 1px var(--wui-color-gray-glass-002);
    color: var(--wui-color-gray-glass-020);
    cursor: not-allowed;
  }

  button > wui-text {
    transition: opacity var(--wui-ease-out-power-1) var(--wui-duration-md);
    will-change: opacity;
    opacity: var(--local-opacity-100);
  }

  ::slotted(*) {
    transition: opacity var(--wui-ease-out-power-1) var(--wui-duration-md);
    will-change: opacity;
    opacity: var(--local-opacity-100);
  }

  wui-loading-spinner {
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
    opacity: var(--local-opacity-000);
  }
`;var l=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let c={main:"inverse-100",inverse:"inverse-000",accent:"accent-100","accent-error":"error-100","accent-success":"success-100",neutral:"fg-100",disabled:"gray-glass-020",shade:"fg-100"},u={lg:"paragraph-600",md:"small-600",sm:"small-600",xs:"tiny-600"},d={lg:"md",md:"md",sm:"sm",xs:"sm"},p=class extends e.LitElement{constructor(){super(...arguments),this.size="lg",this.disabled=!1,this.fullWidth=!1,this.loading=!1,this.variant="main",this.hasIconLeft=!1,this.hasIconRight=!1,this.borderRadius="m"}render(){this.style.cssText=`
    --local-width: ${this.fullWidth?"100%":"auto"};
    --local-opacity-100: ${+!this.loading};
    --local-opacity-000: ${+!!this.loading};
    --local-border-radius: var(--wui-border-radius-${this.borderRadius});
    `;let t=this.textVariant??u[this.size];return r.html`
      <button
        data-variant=${this.variant}
        data-icon-left=${this.hasIconLeft}
        data-icon-right=${this.hasIconRight}
        data-size=${this.size}
        ?disabled=${this.disabled}
      >
        ${this.loadingTemplate()}
        <slot name="iconLeft" @slotchange=${()=>this.handleSlotLeftChange()}></slot>
        <wui-text variant=${t} color="inherit">
          <slot></slot>
        </wui-text>
        <slot name="iconRight" @slotchange=${()=>this.handleSlotRightChange()}></slot>
      </button>
    `}handleSlotLeftChange(){this.hasIconLeft=!0}handleSlotRightChange(){this.hasIconRight=!0}loadingTemplate(){if(this.loading){let t=d[this.size],e=this.disabled?c.disabled:c[this.variant];return r.html`<wui-loading-spinner color=${e} size=${t}></wui-loading-spinner>`}return r.html``}};p.styles=[a.resetStyles,a.elementStyles,n],l([(0,i.property)()],p.prototype,"size",void 0),l([(0,i.property)({type:Boolean})],p.prototype,"disabled",void 0),l([(0,i.property)({type:Boolean})],p.prototype,"fullWidth",void 0),l([(0,i.property)({type:Boolean})],p.prototype,"loading",void 0),l([(0,i.property)()],p.prototype,"variant",void 0),l([(0,i.property)({type:Boolean})],p.prototype,"hasIconLeft",void 0),l([(0,i.property)({type:Boolean})],p.prototype,"hasIconRight",void 0),l([(0,i.property)()],p.prototype,"borderRadius",void 0),l([(0,i.property)()],p.prototype,"textVariant",void 0),p=l([(0,o.customElement)("wui-button")],p),t.s([],998281),t.s([],81981)},846880,t=>{"use strict";t.i(588984);var e=t.i(399702),r=t.i(872857);t.i(759703);var i=t.i(392074),a=t.i(938559),o=t.i(118827);let s=o.css`
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
`;var n=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let l=class extends e.LitElement{constructor(){super(...arguments),this.width="",this.height="",this.borderRadius="m",this.variant="default"}render(){return this.style.cssText=`
      width: ${this.width};
      height: ${this.height};
      border-radius: clamp(0px,var(--wui-border-radius-${this.borderRadius}), 40px);
    `,r.html`<slot></slot>`}};l.styles=[s],n([(0,i.property)()],l.prototype,"width",void 0),n([(0,i.property)()],l.prototype,"height",void 0),n([(0,i.property)()],l.prototype,"borderRadius",void 0),n([(0,i.property)()],l.prototype,"variant",void 0),l=n([(0,a.customElement)("wui-shimmer")],l),t.s([],846880)},908961,t=>{"use strict";t.i(588984);var e=t.i(399702),r=t.i(872857);t.i(759703);var i=t.i(392074),a=t.i(698797),o=t.i(945182),s=t.i(375054),n=t.i(420435);t.i(302184);var l=t.i(938559),c=t.i(118827);let u=c.css`
  :host {
    width: 100%;
    display: block;
  }
`;var d=function(t,e,r,i){var a,o=arguments.length,s=o<3?e:null===i?i=Object.getOwnPropertyDescriptor(e,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(t,e,r,i);else for(var n=t.length-1;n>=0;n--)(a=t[n])&&(s=(o<3?a(s):o>3?a(e,r,s):a(e,r))||s);return o>3&&s&&Object.defineProperty(e,r,s),s};let p=class extends e.LitElement{constructor(){super(),this.unsubscribe=[],this.text="",this.open=n.TooltipController.state.open,this.unsubscribe.push(s.RouterController.subscribeKey("view",()=>{n.TooltipController.hide()}),o.ModalController.subscribeKey("open",t=>{t||n.TooltipController.hide()}),n.TooltipController.subscribeKey("open",t=>{this.open=t}))}disconnectedCallback(){this.unsubscribe.forEach(t=>t()),n.TooltipController.hide()}render(){return r.html`
      <div
        @pointermove=${this.onMouseEnter.bind(this)}
        @pointerleave=${this.onMouseLeave.bind(this)}
      >
        ${this.renderChildren()}
      </div>
    `}renderChildren(){return r.html`<slot></slot> `}onMouseEnter(){let t=this.getBoundingClientRect();this.open||n.TooltipController.showTooltip({message:this.text,triggerRect:{width:t.width,height:t.height,left:t.left,top:t.top},variant:"shade"})}onMouseLeave(t){this.contains(t.relatedTarget)||n.TooltipController.hide()}};p.styles=[u],d([(0,i.property)()],p.prototype,"text",void 0),d([(0,a.state)()],p.prototype,"open",void 0),p=d([(0,l.customElement)("w3m-tooltip-trigger")],p),t.s([],908961)}]);