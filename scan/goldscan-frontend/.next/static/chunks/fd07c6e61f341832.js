(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,476604,e=>{"use strict";e.i(287940),e.s([])},435036,e=>{"use strict";e.i(588984);var t=e.i(399702),r=e.i(872857);e.i(759703);var i=e.i(698797);e.i(781840);var o=e.i(86988),n=e.i(689783),s=e.i(945182),a=e.i(518335),l=e.i(944411),c=e.i(843028);e.i(302184);var u=e.i(938559);e.i(237029),e.i(162085),e.i(331658),e.i(451801),e.i(176375);var p=e.i(118827);let d=p.css`
  :host > wui-grid {
    max-height: 360px;
    overflow: auto;
  }

  wui-flex {
    transition: opacity var(--wui-ease-out-power-1) var(--wui-duration-md);
    will-change: opacity;
  }

  wui-grid::-webkit-scrollbar {
    display: none;
  }

  wui-flex.disabled {
    opacity: 0.3;
    pointer-events: none;
    user-select: none;
  }
`;var m=function(e,t,r,i){var o,n=arguments.length,s=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,r,i);else for(var a=e.length-1;a>=0;a--)(o=e[a])&&(s=(n<3?o(s):n>3?o(t,r,s):o(t,r))||s);return n>3&&s&&Object.defineProperty(t,r,s),s};let h=class extends t.LitElement{constructor(){super(),this.unsubscribe=[],this.selectedCurrency=a.OnRampController.state.paymentCurrency,this.currencies=a.OnRampController.state.paymentCurrencies,this.currencyImages=n.AssetController.state.currencyImages,this.checked=c.OptionsStateController.state.isLegalCheckboxChecked,this.unsubscribe.push(a.OnRampController.subscribe(e=>{this.selectedCurrency=e.paymentCurrency,this.currencies=e.paymentCurrencies}),n.AssetController.subscribeKey("currencyImages",e=>this.currencyImages=e),c.OptionsStateController.subscribeKey("isLegalCheckboxChecked",e=>{this.checked=e}))}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}render(){let{termsConditionsUrl:e,privacyPolicyUrl:t}=l.OptionsController.state,i=l.OptionsController.state.features?.legalCheckbox,n=!!(e||t)&&!!i&&!this.checked;return r.html`
      <w3m-legal-checkbox></w3m-legal-checkbox>
      <wui-flex
        flexDirection="column"
        .padding=${["0","s","s","s"]}
        gap="xs"
        class=${(0,o.ifDefined)(n?"disabled":void 0)}
      >
        ${this.currenciesTemplate(n)}
      </wui-flex>
      <w3m-legal-footer></w3m-legal-footer>
    `}currenciesTemplate(e=!1){return this.currencies.map(t=>r.html`
        <wui-list-item
          imageSrc=${(0,o.ifDefined)(this.currencyImages?.[t.id])}
          @click=${()=>this.selectCurrency(t)}
          variant="image"
          tabIdx=${(0,o.ifDefined)(e?-1:void 0)}
        >
          <wui-text variant="paragraph-500" color="fg-100">${t.id}</wui-text>
        </wui-list-item>
      `)}selectCurrency(e){e&&(a.OnRampController.setPaymentCurrency(e),s.ModalController.close())}};h.styles=d,m([(0,i.state)()],h.prototype,"selectedCurrency",void 0),m([(0,i.state)()],h.prototype,"currencies",void 0),m([(0,i.state)()],h.prototype,"currencyImages",void 0),m([(0,i.state)()],h.prototype,"checked",void 0),h=m([(0,u.customElement)("w3m-onramp-fiat-select-view")],h),e.s(["W3mOnrampFiatSelectView",()=>h],853330);var w=t,g=e.i(207176),y=e.i(301847),f=e.i(881936),v=e.i(375054),b=e.i(355376),x=e.i(142844),C=t,k=e.i(392074),R=e.i(589408);e.i(982221),e.i(476604),e.i(609247),e.i(850139);let O=p.css`
  button {
    padding: var(--wui-spacing-s);
    border-radius: var(--wui-border-radius-xs);
    border: none;
    outline: none;
    background-color: var(--wui-color-gray-glass-002);
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: flex-start;
    gap: var(--wui-spacing-s);
    transition: background-color var(--wui-ease-out-power-1) var(--wui-duration-md);
    will-change: background-color;
  }

  button:hover {
    background-color: var(--wui-color-gray-glass-005);
  }

  .provider-image {
    width: var(--wui-spacing-3xl);
    min-width: var(--wui-spacing-3xl);
    height: var(--wui-spacing-3xl);
    border-radius: calc(var(--wui-border-radius-xs) - calc(var(--wui-spacing-s) / 2));
    position: relative;
    overflow: hidden;
  }

  .provider-image::after {
    content: '';
    display: block;
    width: 100%;
    height: 100%;
    position: absolute;
    inset: 0;
    border-radius: calc(var(--wui-border-radius-xs) - calc(var(--wui-spacing-s) / 2));
    box-shadow: inset 0 0 0 1px var(--wui-color-gray-glass-005);
  }

  .network-icon {
    width: var(--wui-spacing-m);
    height: var(--wui-spacing-m);
    border-radius: calc(var(--wui-spacing-m) / 2);
    overflow: hidden;
    box-shadow:
      0 0 0 3px var(--wui-color-gray-glass-002),
      0 0 0 3px var(--wui-color-modal-bg);
    transition: box-shadow var(--wui-ease-out-power-1) var(--wui-duration-md);
    will-change: box-shadow;
  }

  button:hover .network-icon {
    box-shadow:
      0 0 0 3px var(--wui-color-gray-glass-005),
      0 0 0 3px var(--wui-color-modal-bg);
  }
`;var $=function(e,t,r,i){var o,n=arguments.length,s=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,r,i);else for(var a=e.length-1;a>=0;a--)(o=e[a])&&(s=(n<3?o(s):n>3?o(t,r,s):o(t,r))||s);return n>3&&s&&Object.defineProperty(t,r,s),s};let P=class extends C.LitElement{constructor(){super(...arguments),this.disabled=!1,this.color="inherit",this.label="",this.feeRange="",this.loading=!1,this.onClick=null}render(){return r.html`
      <button ?disabled=${this.disabled} @click=${this.onClick} ontouchstart>
        <wui-visual name=${(0,o.ifDefined)(this.name)} class="provider-image"></wui-visual>
        <wui-flex flexDirection="column" gap="4xs">
          <wui-text variant="paragraph-500" color="fg-100">${this.label}</wui-text>
          <wui-flex alignItems="center" justifyContent="flex-start" gap="l">
            <wui-text variant="tiny-500" color="fg-100">
              <wui-text variant="tiny-400" color="fg-200">Fees</wui-text>
              ${this.feeRange}
            </wui-text>
            <wui-flex gap="xxs">
              <wui-icon name="bank" size="xs" color="fg-150"></wui-icon>
              <wui-icon name="card" size="xs" color="fg-150"></wui-icon>
            </wui-flex>
            ${this.networksTemplate()}
          </wui-flex>
        </wui-flex>
        ${this.loading?r.html`<wui-loading-spinner color="fg-200" size="md"></wui-loading-spinner>`:r.html`<wui-icon name="chevronRight" color="fg-200" size="sm"></wui-icon>`}
      </button>
    `}networksTemplate(){let e=g.ChainController.getAllRequestedCaipNetworks(),t=e?.filter(e=>e?.assets?.imageId)?.slice(0,5);return r.html`
      <wui-flex class="networks">
        ${t?.map(e=>r.html`
            <wui-flex class="network-icon">
              <wui-image src=${(0,o.ifDefined)(R.AssetUtil.getNetworkImage(e))}></wui-image>
            </wui-flex>
          `)}
      </wui-flex>
    `}};P.styles=[O],$([(0,k.property)({type:Boolean})],P.prototype,"disabled",void 0),$([(0,k.property)()],P.prototype,"color",void 0),$([(0,k.property)()],P.prototype,"name",void 0),$([(0,k.property)()],P.prototype,"label",void 0),$([(0,k.property)()],P.prototype,"feeRange",void 0),$([(0,k.property)({type:Boolean})],P.prototype,"loading",void 0),$([(0,k.property)()],P.prototype,"onClick",void 0),P=$([(0,u.customElement)("w3m-onramp-provider-item")],P);var A=t;e.i(472945);let I=p.css`
  wui-flex {
    border-top: 1px solid var(--wui-color-gray-glass-005);
  }

  a {
    text-decoration: none;
    color: var(--wui-color-fg-175);
    font-weight: 500;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: var(--wui-spacing-3xs);
  }
`,T=class extends A.LitElement{render(){let{termsConditionsUrl:e,privacyPolicyUrl:t}=l.OptionsController.state;return e||t?r.html`
      <wui-flex
        .padding=${["m","s","s","s"]}
        flexDirection="column"
        alignItems="center"
        justifyContent="center"
        gap="s"
      >
        <wui-text color="fg-250" variant="small-400" align="center">
          We work with the best providers to give you the lowest fees and best support. More options
          coming soon!
        </wui-text>

        ${this.howDoesItWorkTemplate()}
      </wui-flex>
    `:null}howDoesItWorkTemplate(){return r.html` <wui-link @click=${this.onWhatIsBuy.bind(this)}>
      <wui-icon size="xs" color="accent-100" slot="iconLeft" name="helpCircle"></wui-icon>
      How does it work?
    </wui-link>`}onWhatIsBuy(){f.EventsController.sendEvent({type:"track",event:"SELECT_WHAT_IS_A_BUY",properties:{isSmartAccount:(0,b.getPreferredAccountType)(g.ChainController.state.activeChain)===x.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT}}),v.RouterController.push("WhatIsABuy")}};T.styles=[I],T=function(e,t,r,i){var o,n=arguments.length,s=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,r,i);else for(var a=e.length-1;a>=0;a--)(o=e[a])&&(s=(n<3?o(s):n>3?o(t,r,s):o(t,r))||s);return n>3&&s&&Object.defineProperty(t,r,s),s}([(0,u.customElement)("w3m-onramp-providers-footer")],T);var E=function(e,t,r,i){var o,n=arguments.length,s=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,r,i);else for(var a=e.length-1;a>=0;a--)(o=e[a])&&(s=(n<3?o(s):n>3?o(t,r,s):o(t,r))||s);return n>3&&s&&Object.defineProperty(t,r,s),s};let D=class extends w.LitElement{constructor(){super(),this.unsubscribe=[],this.providers=a.OnRampController.state.providers,this.unsubscribe.push(a.OnRampController.subscribeKey("providers",e=>{this.providers=e}))}render(){return r.html`
      <wui-flex flexDirection="column" .padding=${["0","s","s","s"]} gap="xs">
        ${this.onRampProvidersTemplate()}
      </wui-flex>
      <w3m-onramp-providers-footer></w3m-onramp-providers-footer>
    `}onRampProvidersTemplate(){return this.providers.filter(e=>e.supportedChains.includes(g.ChainController.state.activeChain??"eip155")).map(e=>r.html`
          <w3m-onramp-provider-item
            label=${e.label}
            name=${e.name}
            feeRange=${e.feeRange}
            @click=${()=>{this.onClickProvider(e)}}
            ?disabled=${!e.url}
            data-testid=${`onramp-provider-${e.name}`}
          ></w3m-onramp-provider-item>
        `)}onClickProvider(e){a.OnRampController.setSelectedProvider(e),v.RouterController.push("BuyInProgress"),y.CoreHelperUtil.openHref(a.OnRampController.state.selectedProvider?.url||e.url,"popupWindow","width=600,height=800,scrollbars=yes"),f.EventsController.sendEvent({type:"track",event:"SELECT_BUY_PROVIDER",properties:{provider:e.name,isSmartAccount:(0,b.getPreferredAccountType)(g.ChainController.state.activeChain)===x.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT}})}};E([(0,i.state)()],D.prototype,"providers",void 0),D=E([(0,u.customElement)("w3m-onramp-providers-view")],D),e.s(["W3mOnRampProvidersView",()=>D],832745);var j=t;let W=p.css`
  :host > wui-grid {
    max-height: 360px;
    overflow: auto;
  }

  wui-flex {
    transition: opacity var(--wui-ease-out-power-1) var(--wui-duration-md);
    will-change: opacity;
  }

  wui-grid::-webkit-scrollbar {
    display: none;
  }

  wui-flex.disabled {
    opacity: 0.3;
    pointer-events: none;
    user-select: none;
  }
`;var B=function(e,t,r,i){var o,n=arguments.length,s=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,r,i);else for(var a=e.length-1;a>=0;a--)(o=e[a])&&(s=(n<3?o(s):n>3?o(t,r,s):o(t,r))||s);return n>3&&s&&Object.defineProperty(t,r,s),s};let S=class extends j.LitElement{constructor(){super(),this.unsubscribe=[],this.selectedCurrency=a.OnRampController.state.purchaseCurrencies,this.tokens=a.OnRampController.state.purchaseCurrencies,this.tokenImages=n.AssetController.state.tokenImages,this.checked=c.OptionsStateController.state.isLegalCheckboxChecked,this.unsubscribe.push(a.OnRampController.subscribe(e=>{this.selectedCurrency=e.purchaseCurrencies,this.tokens=e.purchaseCurrencies}),n.AssetController.subscribeKey("tokenImages",e=>this.tokenImages=e),c.OptionsStateController.subscribeKey("isLegalCheckboxChecked",e=>{this.checked=e}))}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}render(){let{termsConditionsUrl:e,privacyPolicyUrl:t}=l.OptionsController.state,i=l.OptionsController.state.features?.legalCheckbox,n=!!(e||t)&&!!i&&!this.checked;return r.html`
      <w3m-legal-checkbox></w3m-legal-checkbox>
      <wui-flex
        flexDirection="column"
        .padding=${["0","s","s","s"]}
        gap="xs"
        class=${(0,o.ifDefined)(n?"disabled":void 0)}
      >
        ${this.currenciesTemplate(n)}
      </wui-flex>
      <w3m-legal-footer></w3m-legal-footer>
    `}currenciesTemplate(e=!1){return this.tokens.map(t=>r.html`
        <wui-list-item
          imageSrc=${(0,o.ifDefined)(this.tokenImages?.[t.symbol])}
          @click=${()=>this.selectToken(t)}
          variant="image"
          tabIdx=${(0,o.ifDefined)(e?-1:void 0)}
        >
          <wui-flex gap="3xs" alignItems="center">
            <wui-text variant="paragraph-500" color="fg-100">${t.name}</wui-text>
            <wui-text variant="small-400" color="fg-200">${t.symbol}</wui-text>
          </wui-flex>
        </wui-list-item>
      `)}selectToken(e){e&&(a.OnRampController.setPurchaseCurrency(e),s.ModalController.close())}};S.styles=W,B([(0,i.state)()],S.prototype,"selectedCurrency",void 0),B([(0,i.state)()],S.prototype,"tokens",void 0),B([(0,i.state)()],S.prototype,"tokenImages",void 0),B([(0,i.state)()],S.prototype,"checked",void 0),S=B([(0,u.customElement)("w3m-onramp-token-select-view")],S),e.s(["W3mOnrampTokensView",()=>S],734038);var L=t,F=e.i(11961),U=e.i(944396),z=e.i(880985);e.i(81981),e.i(174776),e.i(353612);let K=p.css`
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

  wui-visual {
    width: var(--wui-wallet-image-size-lg);
    height: var(--wui-wallet-image-size-lg);
    border-radius: calc(var(--wui-border-radius-5xs) * 9 - var(--wui-border-radius-xxs));
    position: relative;
    overflow: hidden;
  }

  wui-visual::after {
    content: '';
    display: block;
    width: 100%;
    height: 100%;
    position: absolute;
    inset: 0;
    border-radius: calc(var(--wui-border-radius-5xs) * 9 - var(--wui-border-radius-xxs));
    box-shadow: inset 0 0 0 1px var(--wui-color-gray-glass-005);
  }

  wui-icon-box {
    position: absolute;
    right: calc(var(--wui-spacing-3xs) * -1);
    bottom: calc(var(--wui-spacing-3xs) * -1);
    opacity: 0;
    transform: scale(0.5);
    transition:
      opacity var(--wui-ease-out-power-2) var(--wui-duration-lg),
      transform var(--wui-ease-out-power-2) var(--wui-duration-lg);
    will-change: opacity, transform;
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

  [data-retry='false'] wui-link {
    display: none;
  }

  [data-retry='true'] wui-link {
    display: block;
    opacity: 1;
  }

  wui-link {
    padding: var(--wui-spacing-4xs) var(--wui-spacing-xxs);
  }
`;var M=function(e,t,r,i){var o,n=arguments.length,s=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,r,i);else for(var a=e.length-1;a>=0;a--)(o=e[a])&&(s=(n<3?o(s):n>3?o(t,r,s):o(t,r))||s);return n>3&&s&&Object.defineProperty(t,r,s),s};let N=class extends L.LitElement{constructor(){super(),this.unsubscribe=[],this.selectedOnRampProvider=a.OnRampController.state.selectedProvider,this.uri=F.ConnectionController.state.wcUri,this.ready=!1,this.showRetry=!1,this.buffering=!1,this.error=!1,this.isMobile=!1,this.onRetry=void 0,this.unsubscribe.push(a.OnRampController.subscribeKey("selectedProvider",e=>{this.selectedOnRampProvider=e}))}disconnectedCallback(){this.intervalId&&clearInterval(this.intervalId)}render(){let e="Continue in external window";this.error?e="Buy failed":this.selectedOnRampProvider&&(e=`Buy in ${this.selectedOnRampProvider?.label}`);let t=this.error?"Buy can be declined from your side or due to and error on the provider app":`We’ll notify you once your Buy is processed`;return r.html`
      <wui-flex
        data-error=${(0,o.ifDefined)(this.error)}
        data-retry=${this.showRetry}
        flexDirection="column"
        alignItems="center"
        .padding=${["3xl","xl","xl","xl"]}
        gap="xl"
      >
        <wui-flex justifyContent="center" alignItems="center">
          <wui-visual
            name=${(0,o.ifDefined)(this.selectedOnRampProvider?.name)}
            size="lg"
            class="provider-image"
          >
          </wui-visual>

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
          <wui-text variant="paragraph-500" color=${this.error?"error-100":"fg-100"}>
            ${e}
          </wui-text>
          <wui-text align="center" variant="small-500" color="fg-200">${t}</wui-text>
        </wui-flex>

        ${this.error?this.tryAgainTemplate():null}
      </wui-flex>

      <wui-flex .padding=${["0","xl","xl","xl"]} justifyContent="center">
        <wui-link @click=${this.onCopyUri} color="fg-200">
          <wui-icon size="xs" color="fg-200" slot="iconLeft" name="copy"></wui-icon>
          Copy link
        </wui-link>
      </wui-flex>
    `}onTryAgain(){this.selectedOnRampProvider&&(this.error=!1,y.CoreHelperUtil.openHref(this.selectedOnRampProvider.url,"popupWindow","width=600,height=800,scrollbars=yes"))}tryAgainTemplate(){return this.selectedOnRampProvider?.url?r.html`<wui-button size="md" variant="accent" @click=${this.onTryAgain.bind(this)}>
      <wui-icon color="inherit" slot="iconLeft" name="refresh"></wui-icon>
      Try again
    </wui-button>`:null}loaderTemplate(){let e=z.ThemeController.state.themeVariables["--w3m-border-radius-master"],t=e?parseInt(e.replace("px",""),10):4;return r.html`<wui-loading-thumbnail radius=${9*t}></wui-loading-thumbnail>`}onCopyUri(){if(!this.selectedOnRampProvider?.url){U.SnackController.showError("No link found"),v.RouterController.goBack();return}try{y.CoreHelperUtil.copyToClopboard(this.selectedOnRampProvider.url),U.SnackController.showSuccess("Link copied")}catch{U.SnackController.showError("Failed to copy")}}};N.styles=K,M([(0,i.state)()],N.prototype,"intervalId",void 0),M([(0,i.state)()],N.prototype,"selectedOnRampProvider",void 0),M([(0,i.state)()],N.prototype,"uri",void 0),M([(0,i.state)()],N.prototype,"ready",void 0),M([(0,i.state)()],N.prototype,"showRetry",void 0),M([(0,i.state)()],N.prototype,"buffering",void 0),M([(0,i.state)()],N.prototype,"error",void 0),M([(0,k.property)({type:Boolean})],N.prototype,"isMobile",void 0),M([(0,k.property)()],N.prototype,"onRetry",void 0),N=M([(0,u.customElement)("w3m-buy-in-progress-view")],N),e.s(["W3mBuyInProgressView",()=>N],861257);var V=t;let _=class extends V.LitElement{render(){return r.html`
      <wui-flex
        flexDirection="column"
        .padding=${["xxl","3xl","xl","3xl"]}
        alignItems="center"
        gap="xl"
      >
        <wui-visual name="onrampCard"></wui-visual>
        <wui-flex flexDirection="column" gap="xs" alignItems="center">
          <wui-text align="center" variant="paragraph-500" color="fg-100">
            Quickly and easily buy digital assets!
          </wui-text>
          <wui-text align="center" variant="small-400" color="fg-200">
            Simply select your preferred onramp provider and add digital assets to your account
            using your credit card or bank transfer
          </wui-text>
        </wui-flex>
        <wui-button @click=${v.RouterController.goBack}>
          <wui-icon size="sm" color="inherit" name="add" slot="iconLeft"></wui-icon>
          Buy
        </wui-button>
      </wui-flex>
    `}};_=function(e,t,r,i){var o,n=arguments.length,s=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,r,i);else for(var a=e.length-1;a>=0;a--)(o=e[a])&&(s=(n<3?o(s):n>3?o(t,r,s):o(t,r))||s);return n>3&&s&&Object.defineProperty(t,r,s),s}([(0,u.customElement)("w3m-what-is-a-buy-view")],_),e.s(["W3mWhatIsABuyView",()=>_],821290);var q=t,H=e.i(140018),Y=function(e,t,r,i){var o,n=arguments.length,s=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,r,i);else for(var a=e.length-1;a>=0;a--)(o=e[a])&&(s=(n<3?o(s):n>3?o(t,r,s):o(t,r))||s);return n>3&&s&&Object.defineProperty(t,r,s),s};let Q=class extends q.LitElement{constructor(){super(),this.unsubscribe=[],this.namespace=g.ChainController.state.activeChain,this.features=l.OptionsController.state.features,this.remoteFeatures=l.OptionsController.state.remoteFeatures,this.unsubscribe.push(l.OptionsController.subscribeKey("features",e=>this.features=e),l.OptionsController.subscribeKey("remoteFeatures",e=>this.remoteFeatures=e),g.ChainController.subscribeKey("activeChain",e=>this.namespace=e),g.ChainController.subscribeKey("activeCaipNetwork",e=>{e?.chainNamespace&&(this.namespace=e?.chainNamespace)}))}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}render(){return r.html`
      <wui-flex flexDirection="column" .padding=${["0","s","xl","s"]} gap="xs">
        ${this.onrampTemplate()} ${this.receiveTemplate()} ${this.depositFromExchangeTemplate()}
      </wui-flex>
    `}onrampTemplate(){if(!this.namespace)return null;let e=this.remoteFeatures?.onramp,t=H.ConstantsUtil.ONRAMP_SUPPORTED_CHAIN_NAMESPACES.includes(this.namespace);return e&&t?r.html`
      <wui-list-description
        @click=${this.onBuyCrypto.bind(this)}
        text="Buy crypto"
        icon="card"
        iconColor="success-100"
        iconBackgroundColor="success-100"
        data-testid="wallet-features-onramp-button"
      ></wui-list-description>
    `:null}depositFromExchangeTemplate(){return this.remoteFeatures?.payWithExchange?r.html`
      <wui-list-description
        @click=${this.onDepositFromExchange.bind(this)}
        text="Deposit from exchange"
        icon="download"
        iconColor="fg-200"
        iconBackgroundColor="fg-200"
        data-testid="wallet-features-deposit-from-exchange-button"
      ></wui-list-description>
    `:null}receiveTemplate(){return this.features?.receive?r.html`
      <wui-list-description
        @click=${this.onReceive.bind(this)}
        text="Receive funds"
        icon="qrCode"
        iconColor="fg-200"
        iconBackgroundColor="fg-200"
        data-testid="wallet-features-receive-button"
      ></wui-list-description>
    `:null}onBuyCrypto(){v.RouterController.push("OnRampProviders")}onReceive(){v.RouterController.push("WalletReceive")}onDepositFromExchange(){v.RouterController.push("PayWithExchange")}};Y([(0,i.state)()],Q.prototype,"namespace",void 0),Y([(0,i.state)()],Q.prototype,"features",void 0),Y([(0,i.state)()],Q.prototype,"remoteFeatures",void 0),Q=Y([(0,u.customElement)("w3m-fund-wallet-view")],Q),e.s(["W3mFundWalletView",()=>Q],915674);var X=t,G=t;e.i(999964);let J=p.css`
  :host {
    width: 100%;
  }

  wui-loading-spinner {
    position: absolute;
    top: 50%;
    right: 20px;
    transform: translateY(-50%);
  }

  .currency-container {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    right: var(--wui-spacing-1xs);
    height: 40px;
    padding: var(--wui-spacing-xs) var(--wui-spacing-1xs) var(--wui-spacing-xs)
      var(--wui-spacing-xs);
    min-width: 95px;
    border-radius: var(--FULL, 1000px);
    border: 1px solid var(--wui-color-gray-glass-002);
    background: var(--wui-color-gray-glass-002);
    cursor: pointer;
  }

  .currency-container > wui-image {
    height: 24px;
    width: 24px;
    border-radius: 50%;
  }
`;var Z=function(e,t,r,i){var o,n=arguments.length,s=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,r,i);else for(var a=e.length-1;a>=0;a--)(o=e[a])&&(s=(n<3?o(s):n>3?o(t,r,s):o(t,r))||s);return n>3&&s&&Object.defineProperty(t,r,s),s};let ee=class extends G.LitElement{constructor(){super(),this.unsubscribe=[],this.type="Token",this.value=0,this.currencies=[],this.selectedCurrency=this.currencies?.[0],this.currencyImages=n.AssetController.state.currencyImages,this.tokenImages=n.AssetController.state.tokenImages,this.unsubscribe.push(a.OnRampController.subscribeKey("purchaseCurrency",e=>{e&&"Fiat"!==this.type&&(this.selectedCurrency=this.formatPurchaseCurrency(e))}),a.OnRampController.subscribeKey("paymentCurrency",e=>{e&&"Token"!==this.type&&(this.selectedCurrency=this.formatPaymentCurrency(e))}),a.OnRampController.subscribe(e=>{"Fiat"===this.type?this.currencies=e.purchaseCurrencies.map(this.formatPurchaseCurrency):this.currencies=e.paymentCurrencies.map(this.formatPaymentCurrency)}),n.AssetController.subscribe(e=>{this.currencyImages={...e.currencyImages},this.tokenImages={...e.tokenImages}}))}firstUpdated(){a.OnRampController.getAvailableCurrencies()}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}render(){let e=this.selectedCurrency?.symbol||"",t=this.currencyImages[e]||this.tokenImages[e];return r.html`<wui-input-text type="number" size="lg" value=${this.value}>
      ${this.selectedCurrency?r.html` <wui-flex
            class="currency-container"
            justifyContent="space-between"
            alignItems="center"
            gap="xxs"
            @click=${()=>s.ModalController.open({view:`OnRamp${this.type}Select`})}
          >
            <wui-image src=${(0,o.ifDefined)(t)}></wui-image>
            <wui-text color="fg-100">${this.selectedCurrency.symbol}</wui-text>
          </wui-flex>`:r.html`<wui-loading-spinner></wui-loading-spinner>`}
    </wui-input-text>`}formatPaymentCurrency(e){return{name:e.id,symbol:e.id}}formatPurchaseCurrency(e){return{name:e.name,symbol:e.symbol}}};ee.styles=J,Z([(0,k.property)({type:String})],ee.prototype,"type",void 0),Z([(0,k.property)({type:Number})],ee.prototype,"value",void 0),Z([(0,i.state)()],ee.prototype,"currencies",void 0),Z([(0,i.state)()],ee.prototype,"selectedCurrency",void 0),Z([(0,i.state)()],ee.prototype,"currencyImages",void 0),Z([(0,i.state)()],ee.prototype,"tokenImages",void 0),ee=Z([(0,u.customElement)("w3m-onramp-input")],ee);let et=p.css`
  :host > wui-flex {
    width: 100%;
    max-width: 360px;
  }

  :host > wui-flex > wui-flex {
    border-radius: var(--wui-border-radius-l);
    width: 100%;
  }

  .amounts-container {
    width: 100%;
  }
`;var er=function(e,t,r,i){var o,n=arguments.length,s=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,r):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,r,i);else for(var a=e.length-1;a>=0;a--)(o=e[a])&&(s=(n<3?o(s):n>3?o(t,r,s):o(t,r))||s);return n>3&&s&&Object.defineProperty(t,r,s),s};let ei={USD:"$",EUR:"€",GBP:"£"},eo=[100,250,500,1e3],en=class extends X.LitElement{constructor(){super(),this.unsubscribe=[],this.disabled=!1,this.caipAddress=g.ChainController.state.activeCaipAddress,this.loading=s.ModalController.state.loading,this.paymentCurrency=a.OnRampController.state.paymentCurrency,this.paymentAmount=a.OnRampController.state.paymentAmount,this.purchaseAmount=a.OnRampController.state.purchaseAmount,this.quoteLoading=a.OnRampController.state.quotesLoading,this.unsubscribe.push(g.ChainController.subscribeKey("activeCaipAddress",e=>this.caipAddress=e),s.ModalController.subscribeKey("loading",e=>{this.loading=e}),a.OnRampController.subscribe(e=>{this.paymentCurrency=e.paymentCurrency,this.paymentAmount=e.paymentAmount,this.purchaseAmount=e.purchaseAmount,this.quoteLoading=e.quotesLoading}))}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}render(){return r.html`
      <wui-flex flexDirection="column" justifyContent="center" alignItems="center">
        <wui-flex flexDirection="column" alignItems="center" gap="xs">
          <w3m-onramp-input
            type="Fiat"
            @inputChange=${this.onPaymentAmountChange.bind(this)}
            .value=${this.paymentAmount||0}
          ></w3m-onramp-input>
          <w3m-onramp-input
            type="Token"
            .value=${this.purchaseAmount||0}
            .loading=${this.quoteLoading}
          ></w3m-onramp-input>
          <wui-flex justifyContent="space-evenly" class="amounts-container" gap="xs">
            ${eo.map(e=>r.html`<wui-button
                  variant=${this.paymentAmount===e?"accent":"neutral"}
                  size="md"
                  textVariant="paragraph-600"
                  fullWidth
                  @click=${()=>this.selectPresetAmount(e)}
                  >${`${ei[this.paymentCurrency?.id||"USD"]} ${e}`}</wui-button
                >`)}
          </wui-flex>
          ${this.templateButton()}
        </wui-flex>
      </wui-flex>
    `}templateButton(){return this.caipAddress?r.html`<wui-button
          @click=${this.getQuotes.bind(this)}
          variant="main"
          fullWidth
          size="lg"
          borderRadius="xs"
        >
          Get quotes
        </wui-button>`:r.html`<wui-button
          @click=${this.openModal.bind(this)}
          variant="accent"
          fullWidth
          size="lg"
          borderRadius="xs"
        >
          Connect wallet
        </wui-button>`}getQuotes(){this.loading||s.ModalController.open({view:"OnRampProviders"})}openModal(){s.ModalController.open({view:"Connect"})}async onPaymentAmountChange(e){a.OnRampController.setPaymentAmount(Number(e.detail)),await a.OnRampController.getQuote()}async selectPresetAmount(e){a.OnRampController.setPaymentAmount(e),await a.OnRampController.getQuote()}};en.styles=et,er([(0,k.property)({type:Boolean})],en.prototype,"disabled",void 0),er([(0,i.state)()],en.prototype,"caipAddress",void 0),er([(0,i.state)()],en.prototype,"loading",void 0),er([(0,i.state)()],en.prototype,"paymentCurrency",void 0),er([(0,i.state)()],en.prototype,"paymentAmount",void 0),er([(0,i.state)()],en.prototype,"purchaseAmount",void 0),er([(0,i.state)()],en.prototype,"quoteLoading",void 0),en=er([(0,u.customElement)("w3m-onramp-widget")],en),e.s(["W3mOnrampWidget",()=>en],557481),e.s([],574775),e.i(574775),e.i(853330),e.i(832745),e.i(734038),e.i(861257),e.i(821290),e.i(915674),e.i(557481),e.s(["W3mBuyInProgressView",()=>N,"W3mFundWalletView",()=>Q,"W3mOnRampProvidersView",()=>D,"W3mOnrampFiatSelectView",()=>h,"W3mOnrampTokensView",()=>S,"W3mOnrampWidget",()=>en,"W3mWhatIsABuyView",()=>_],435036)}]);