(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,536830,e=>{"use strict";e.i(588984);var t=e.i(399702),i=e.i(872857);e.i(759703);var r=e.i(698797),n=e.i(263342),o=e.i(729702),s=e.i(945182),a=e.i(944411),l=e.i(880985);e.i(302184);var c=e.i(938559),u=e.i(118827);let m=u.css`
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
`;var d=function(e,t,i,r){var n,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var a=e.length-1;a>=0;a--)(n=e[a])&&(s=(o<3?n(s):o>3?n(t,i,s):n(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let p=class extends t.LitElement{constructor(){super(),this.bodyObserver=void 0,this.unsubscribe=[],this.iframe=document.getElementById("w3m-iframe"),this.ready=!1,this.unsubscribe.push(s.ModalController.subscribeKey("open",e=>{e||this.onHideIframe()}),s.ModalController.subscribeKey("shake",e=>{e?this.iframe.style.animation="w3m-shake 500ms var(--wui-ease-out-power-2)":this.iframe.style.animation="none"}))}disconnectedCallback(){this.onHideIframe(),this.unsubscribe.forEach(e=>e()),this.bodyObserver?.unobserve(window.document.body)}async firstUpdated(){await this.syncTheme(),this.iframe.style.display="block";let e=this?.renderRoot?.querySelector("div");this.bodyObserver=new ResizeObserver(t=>{let i=t?.[0]?.contentBoxSize,r=i?.[0]?.inlineSize;this.iframe.style.height="600px",e.style.height="600px",a.OptionsController.state.enableEmbedded?this.updateFrameSizeForEmbeddedMode():(r&&r<=430?(this.iframe.style.width="100%",this.iframe.style.left="0px",this.iframe.style.bottom="0px",this.iframe.style.top="unset"):(this.iframe.style.width="360px",this.iframe.style.left="calc(50% - 180px)",this.iframe.style.top="calc(50% - 300px + 32px)",this.iframe.style.bottom="unset"),this.onShowIframe())}),this.bodyObserver.observe(window.document.body)}render(){return i.html`<div data-ready=${this.ready} id="w3m-frame-container"></div>`}onShowIframe(){let e=window.innerWidth<=430;this.ready=!0,this.iframe.style.animation=e?"w3m-iframe-zoom-in-mobile 200ms var(--wui-ease-out-power-2)":"w3m-iframe-zoom-in 200ms var(--wui-ease-out-power-2)"}onHideIframe(){this.iframe.style.display="none",this.iframe.style.animation="w3m-iframe-fade-out 200ms var(--wui-ease-out-power-2)"}async syncTheme(){let e=o.ConnectorController.getAuthConnector();if(e){let t=l.ThemeController.getSnapshot().themeMode,i=l.ThemeController.getSnapshot().themeVariables;await e.provider.syncTheme({themeVariables:i,w3mThemeVariables:(0,n.getW3mThemeVariables)(i,t)})}}async updateFrameSizeForEmbeddedMode(){let e=this?.renderRoot?.querySelector("div");await new Promise(e=>{setTimeout(e,300)});let t=this.getBoundingClientRect();e.style.width="100%",this.iframe.style.left=`${t.left}px`,this.iframe.style.top=`${t.top}px`,this.iframe.style.width=`${t.width}px`,this.iframe.style.height=`${t.height}px`,this.onShowIframe()}};p.styles=m,d([(0,r.state)()],p.prototype,"ready",void 0),p=d([(0,c.customElement)("w3m-approve-transaction-view")],p),e.s(["W3mApproveTransactionView",()=>p],503845);var h=t,g=e.i(140018);e.i(510290),e.i(237029),e.i(331658);let f=class extends h.LitElement{render(){return i.html`
      <wui-flex flexDirection="column" alignItems="center" gap="xl" padding="xl">
        <wui-text variant="paragraph-400" color="fg-100">Follow the instructions on</wui-text>
        <wui-chip
          icon="externalLink"
          variant="fill"
          href=${g.ConstantsUtil.SECURE_SITE_DASHBOARD}
          imageSrc=${g.ConstantsUtil.SECURE_SITE_FAVICON}
          data-testid="w3m-secure-website-button"
        >
        </wui-chip>
        <wui-text variant="small-400" color="fg-200">
          You will have to reconnect for security reasons
        </wui-text>
      </wui-flex>
    `}};f=function(e,t,i,r){var n,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var a=e.length-1;a>=0;a--)(n=e[a])&&(s=(o<3?n(s):o>3?n(t,i,s):n(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s}([(0,c.customElement)("w3m-upgrade-wallet-view")],f),e.s(["W3mUpgradeWalletView",()=>f],161858);var w=t,b=e.i(392074);e.i(812492);var y=e.i(568633),v=e.i(138230),x=e.i(596590),C=e.i(207176),E=e.i(301847),R=e.i(594424),T=e.i(881936),S=e.i(944396),A=e.i(355376),N=t;e.i(781840);var $=e.i(86988);e.i(829162),e.i(596548);var k=e.i(864429);e.i(525370);let O=u.css`
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
`;var U=function(e,t,i,r){var n,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var a=e.length-1;a>=0;a--)(n=e[a])&&(s=(o<3?n(s):o>3?n(t,i,s):n(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let I=class extends N.LitElement{constructor(){super(...arguments),this.disabled=!1,this.loading=!1}render(){return i.html`
      <wui-input-text
        value=${(0,$.ifDefined)(this.value)}
        ?disabled=${this.disabled}
        .value=${this.value||""}
        data-testid="wui-ens-input"
        inputRightPadding="5xl"
        .onKeyDown=${this.onKeyDown}
      >
        ${this.baseNameTemplate()} ${this.errorTemplate()}${this.loadingTemplate()}
      </wui-input-text>
    `}baseNameTemplate(){return i.html`<wui-text variant="paragraph-400" color="fg-200" class="base-name">
      ${v.ConstantsUtil.WC_NAME_SUFFIX}
    </wui-text>`}loadingTemplate(){return this.loading?i.html`<wui-loading-spinner size="md" color="accent-100"></wui-loading-spinner>`:null}errorTemplate(){return this.errorMessage?i.html`<wui-text variant="tiny-500" color="error-100" class="error"
        >${this.errorMessage}</wui-text
      >`:null}};I.styles=[k.resetStyles,O],U([(0,b.property)()],I.prototype,"errorMessage",void 0),U([(0,b.property)({type:Boolean})],I.prototype,"disabled",void 0),U([(0,b.property)()],I.prototype,"value",void 0),U([(0,b.property)({type:Boolean})],I.prototype,"loading",void 0),U([(0,b.property)({attribute:!1})],I.prototype,"onKeyDown",void 0),I=U([(0,c.customElement)("wui-ens-input")],I),e.i(982221),e.i(679556),e.i(609247),e.i(990237);var D=e.i(142844),_=e.i(873117);let P=u.css`
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
`;var M=function(e,t,i,r){var n,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var a=e.length-1;a>=0;a--)(n=e[a])&&(s=(o<3?n(s):o>3?n(t,i,s):n(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let W=class extends w.LitElement{constructor(){super(),this.formRef=(0,y.createRef)(),this.usubscribe=[],this.name="",this.error="",this.loading=R.EnsController.state.loading,this.suggestions=R.EnsController.state.suggestions,this.profileName=x.AccountController.state.profileName,this.onDebouncedNameInputChange=E.CoreHelperUtil.debounce(e=>{e.length<4?this.error="Name must be at least 4 characters long":_.HelpersUtil.isValidReownName(e)?(this.error="",R.EnsController.getSuggestions(e)):this.error="The value is not a valid username"}),this.usubscribe.push(R.EnsController.subscribe(e=>{this.suggestions=e.suggestions,this.loading=e.loading}),x.AccountController.subscribeKey("profileName",e=>{this.profileName=e,e&&(this.error="You already own a name")}))}firstUpdated(){this.formRef.value?.addEventListener("keydown",this.onEnterKey.bind(this))}disconnectedCallback(){super.disconnectedCallback(),this.usubscribe.forEach(e=>e()),this.formRef.value?.removeEventListener("keydown",this.onEnterKey.bind(this))}render(){return i.html`
      <wui-flex
        flexDirection="column"
        alignItems="center"
        gap="m"
        .padding=${["0","s","m","s"]}
      >
        <form ${(0,y.ref)(this.formRef)} @submit=${this.onSubmitName.bind(this)}>
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
    `}submitButtonTemplate(){let e=this.suggestions.find(e=>e.name?.split(".")?.[0]===this.name&&e.registered);if(this.loading)return i.html`<wui-loading-spinner
        class="input-loading-spinner"
        color="fg-200"
      ></wui-loading-spinner>`;let t=`${this.name}${v.ConstantsUtil.WC_NAME_SUFFIX}`;return i.html`
      <wui-icon-link
        .disabled=${e}
        class="input-submit-button"
        size="sm"
        icon="chevronRight"
        iconColor=${e?"fg-200":"accent-100"}
        @click=${()=>this.onSubmitName(t)}
      >
      </wui-icon-link>
    `}onNameInputChange(e){let t=_.HelpersUtil.validateReownName(e.detail||"");this.name=t,this.onDebouncedNameInputChange(t)}onKeyDown(e){1!==e.key.length||_.HelpersUtil.isValidReownName(e.key)||e.preventDefault()}nameSuggestionTagTemplate(e){return this.loading?i.html`<wui-loading-spinner color="fg-200"></wui-loading-spinner>`:e.registered?i.html`<wui-tag variant="shade" size="lg">Registered</wui-tag>`:i.html`<wui-tag variant="success" size="lg">Available</wui-tag>`}templateSuggestions(){return!this.name||this.name.length<4||this.error?null:i.html`<wui-flex flexDirection="column" gap="xxs" alignItems="center">
      ${this.suggestions.map(e=>i.html`<button
            .disabled=${e.registered||this.loading}
            data-testid="account-name-suggestion"
            class="suggestion"
            @click=${()=>this.onSubmitName(e.name)}
          >
            <wui-text color="fg-100" variant="paragraph-400" class="suggested-name">
              ${e.name}</wui-text
            >${this.nameSuggestionTagTemplate(e)}
          </button>`)}
    </wui-flex>`}isAllowedToSubmit(e){let t=e.split(".")?.[0],i=this.suggestions.find(e=>e.name?.split(".")?.[0]===t&&e.registered);return!this.loading&&!this.error&&!this.profileName&&t&&R.EnsController.validateName(t)&&!i}async onSubmitName(e){try{if(!this.isAllowedToSubmit(e))return;T.EventsController.sendEvent({type:"track",event:"REGISTER_NAME_INITIATED",properties:{isSmartAccount:(0,A.getPreferredAccountType)(C.ChainController.state.activeChain)===D.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT,ensName:e}}),await R.EnsController.registerName(e),T.EventsController.sendEvent({type:"track",event:"REGISTER_NAME_SUCCESS",properties:{isSmartAccount:(0,A.getPreferredAccountType)(C.ChainController.state.activeChain)===D.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT,ensName:e}})}catch(t){S.SnackController.showError(t.message),T.EventsController.sendEvent({type:"track",event:"REGISTER_NAME_ERROR",properties:{isSmartAccount:(0,A.getPreferredAccountType)(C.ChainController.state.activeChain)===D.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT,ensName:e,error:t?.message||"Unknown error"}})}}onEnterKey(e){if("Enter"===e.key&&this.name&&this.isAllowedToSubmit(this.name)){let e=`${this.name}${v.ConstantsUtil.WC_NAME_SUFFIX}`;this.onSubmitName(e)}}};W.styles=P,M([(0,b.property)()],W.prototype,"errorMessage",void 0),M([(0,r.state)()],W.prototype,"name",void 0),M([(0,r.state)()],W.prototype,"error",void 0),M([(0,r.state)()],W.prototype,"loading",void 0),M([(0,r.state)()],W.prototype,"suggestions",void 0),M([(0,r.state)()],W.prototype,"profileName",void 0),W=M([(0,c.customElement)("w3m-register-account-name-view")],W),e.s(["W3mRegisterAccountNameView",()=>W],440153);var j=t,F=e.i(692100),K=e.i(375054);e.i(81981),e.i(174776),e.i(472945);let z=u.css`
  .continue-button-container {
    width: 100%;
  }
`,L=class extends j.LitElement{render(){return i.html`
      <wui-flex
        flexDirection="column"
        alignItems="center"
        gap="xxl"
        .padding=${["0","0","l","0"]}
      >
        ${this.onboardingTemplate()} ${this.buttonsTemplate()}
        <wui-link
          @click=${()=>{E.CoreHelperUtil.openHref(F.NavigationUtil.URLS.FAQ,"_blank")}}
        >
          Learn more
          <wui-icon color="inherit" slot="iconRight" name="externalLink"></wui-icon>
        </wui-link>
      </wui-flex>
    `}onboardingTemplate(){return i.html` <wui-flex
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
    </wui-flex>`}buttonsTemplate(){return i.html`<wui-flex
      .padding=${["0","2l","0","2l"]}
      gap="s"
      class="continue-button-container"
    >
      <wui-button fullWidth size="lg" borderRadius="xs" @click=${this.redirectToAccount.bind(this)}
        >Let's Go!
      </wui-button>
    </wui-flex>`}redirectToAccount(){K.RouterController.replace("Account")}};L.styles=z,L=function(e,t,i,r){var n,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var a=e.length-1;a>=0;a--)(n=e[a])&&(s=(o<3?n(s):o>3?n(t,i,s):n(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s}([(0,c.customElement)("w3m-register-account-name-success-view")],L),e.s(["W3mRegisterAccountNameSuccess",()=>L],899802),e.s([],441163),e.i(441163),e.i(503845),e.i(161858),e.i(440153),e.i(899802),e.s(["W3mApproveTransactionView",()=>p,"W3mRegisterAccountNameSuccess",()=>L,"W3mRegisterAccountNameView",()=>W,"W3mUpgradeWalletView",()=>f],536830)}]);