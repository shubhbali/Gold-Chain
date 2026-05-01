(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,175041,e=>{"use strict";e.i(588984);var t=e.i(399702),o=e.i(872857);e.i(759703);var i=e.i(698797);e.i(781840);var r=e.i(86988),n=e.i(944411),s=e.i(843028);e.i(302184);var a=e.i(938559);e.i(237029),e.i(451801),e.i(176375);var l=t,c=e.i(392074),u=e.i(525417),d=e.i(729702),h=e.i(140018),p=e.i(375054),m=e.i(229581),w=e.i(301847);e.i(231971);var g=e.i(718454),C=e.i(118827);let v=C.css`
  :host {
    margin-top: var(--wui-spacing-3xs);
  }
  wui-separator {
    margin: var(--wui-spacing-m) calc(var(--wui-spacing-m) * -1) var(--wui-spacing-xs)
      calc(var(--wui-spacing-m) * -1);
    width: calc(100% + var(--wui-spacing-s) * 2);
  }
`;var f=function(e,t,o,i){var r,n=arguments.length,s=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,o):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,o,i);else for(var a=e.length-1;a>=0;a--)(r=e[a])&&(s=(n<3?r(s):n>3?r(t,o,s):r(t,o))||s);return n>3&&s&&Object.defineProperty(t,o,s),s};let b=class extends l.LitElement{constructor(){super(),this.unsubscribe=[],this.tabIdx=void 0,this.connectors=d.ConnectorController.state.connectors,this.authConnector=this.connectors.find(e=>"AUTH"===e.type),this.remoteFeatures=n.OptionsController.state.remoteFeatures,this.isPwaLoading=!1,this.unsubscribe.push(d.ConnectorController.subscribeKey("connectors",e=>{this.connectors=e,this.authConnector=this.connectors.find(e=>"AUTH"===e.type)}),n.OptionsController.subscribeKey("remoteFeatures",e=>this.remoteFeatures=e))}connectedCallback(){super.connectedCallback(),this.handlePwaFrameLoad()}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}render(){let e=this.remoteFeatures?.socials||[],t=!!this.authConnector,i=e?.length,r="ConnectSocials"===p.RouterController.state.view;return t&&i||r?(r&&!i&&(e=h.ConstantsUtil.DEFAULT_SOCIALS),o.html` <wui-flex flexDirection="column" gap="xs">
      ${e.map(e=>o.html`<wui-list-social
            @click=${()=>{this.onSocialClick(e)}}
            data-testid=${`social-selector-${e}`}
            name=${e}
            logo=${e}
            ?disabled=${this.isPwaLoading}
          ></wui-list-social>`)}
    </wui-flex>`):null}async onSocialClick(e){e&&await (0,m.executeSocialLogin)(e)}async handlePwaFrameLoad(){if(w.CoreHelperUtil.isPWA()){this.isPwaLoading=!0;try{this.authConnector?.provider instanceof g.W3mFrameProvider&&await this.authConnector.provider.init()}catch(e){u.AlertController.open({displayMessage:"Error loading embedded wallet in PWA",debugMessage:e.message},"error")}finally{this.isPwaLoading=!1}}}};b.styles=v,f([(0,c.property)()],b.prototype,"tabIdx",void 0),f([(0,i.state)()],b.prototype,"connectors",void 0),f([(0,i.state)()],b.prototype,"authConnector",void 0),f([(0,i.state)()],b.prototype,"remoteFeatures",void 0),f([(0,i.state)()],b.prototype,"isPwaLoading",void 0),b=f([(0,a.customElement)("w3m-social-login-list")],b);let x=C.css`
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
`;var y=function(e,t,o,i){var r,n=arguments.length,s=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,o):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,o,i);else for(var a=e.length-1;a>=0;a--)(r=e[a])&&(s=(n<3?r(s):n>3?r(t,o,s):r(t,o))||s);return n>3&&s&&Object.defineProperty(t,o,s),s};let k=class extends t.LitElement{constructor(){super(),this.unsubscribe=[],this.checked=s.OptionsStateController.state.isLegalCheckboxChecked,this.unsubscribe.push(s.OptionsStateController.subscribeKey("isLegalCheckboxChecked",e=>{this.checked=e}))}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}render(){let{termsConditionsUrl:e,privacyPolicyUrl:t}=n.OptionsController.state,i=n.OptionsController.state.features?.legalCheckbox,s=!!(e||t)&&!!i,a=s&&!this.checked;return o.html`
      <w3m-legal-checkbox></w3m-legal-checkbox>
      <wui-flex
        flexDirection="column"
        .padding=${s?["0","s","s","s"]:"s"}
        gap="xs"
        class=${(0,r.ifDefined)(a?"disabled":void 0)}
      >
        <w3m-social-login-list tabIdx=${(0,r.ifDefined)(a?-1:void 0)}></w3m-social-login-list>
      </wui-flex>
      <w3m-legal-footer></w3m-legal-footer>
    `}};k.styles=x,y([(0,i.state)()],k.prototype,"checked",void 0),k=y([(0,a.customElement)("w3m-connect-socials-view")],k),e.s(["W3mConnectSocialsView",()=>k],26870);var E=t,S=e.i(596590),P=e.i(207176),O=e.i(11961),L=e.i(881936),R=e.i(945182),$=e.i(944396),A=e.i(148018),T=e.i(880985);e.i(174776),e.i(353612),e.i(675164),e.i(331658);var I=e.i(827824),U=e.i(924487);let W=C.css`
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
`;var F=function(e,t,o,i){var r,n=arguments.length,s=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,o):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,o,i);else for(var a=e.length-1;a>=0;a--)(r=e[a])&&(s=(n<3?r(s):n>3?r(t,o,s):r(t,o))||s);return n>3&&s&&Object.defineProperty(t,o,s),s};let _=class extends E.LitElement{constructor(){super(),this.unsubscribe=[],this.socialProvider=S.AccountController.state.socialProvider,this.socialWindow=S.AccountController.state.socialWindow,this.error=!1,this.connecting=!1,this.message="Connect in the provider window",this.remoteFeatures=n.OptionsController.state.remoteFeatures,this.address=S.AccountController.state.address,this.connectionsByNamespace=O.ConnectionController.getConnections(P.ChainController.state.activeChain),this.hasMultipleConnections=this.connectionsByNamespace.length>0,this.authConnector=d.ConnectorController.getAuthConnector(),this.handleSocialConnection=async e=>{if(e.data?.resultUri)if(e.origin===U.ConstantsUtil.SECURE_SITE_ORIGIN){window.removeEventListener("message",this.handleSocialConnection,!1);try{if(this.authConnector&&!this.connecting){this.socialWindow&&(this.socialWindow.close(),S.AccountController.setSocialWindow(void 0,P.ChainController.state.activeChain)),this.connecting=!0,this.updateMessage();let t=e.data.resultUri;this.socialProvider&&L.EventsController.sendEvent({type:"track",event:"SOCIAL_LOGIN_REQUEST_USER_DATA",properties:{provider:this.socialProvider}}),await O.ConnectionController.connectExternal({id:this.authConnector.id,type:this.authConnector.type,socialUri:t},this.authConnector.chain),this.socialProvider&&(A.StorageUtil.setConnectedSocialProvider(this.socialProvider),L.EventsController.sendEvent({type:"track",event:"SOCIAL_LOGIN_SUCCESS",properties:{provider:this.socialProvider}}))}}catch(e){this.error=!0,this.updateMessage(),this.socialProvider&&L.EventsController.sendEvent({type:"track",event:"SOCIAL_LOGIN_ERROR",properties:{provider:this.socialProvider}})}}else p.RouterController.goBack(),$.SnackController.showError("Untrusted Origin"),this.socialProvider&&L.EventsController.sendEvent({type:"track",event:"SOCIAL_LOGIN_ERROR",properties:{provider:this.socialProvider}})},I.ErrorUtil.EmbeddedWalletAbortController.signal.addEventListener("abort",()=>{this.socialWindow&&(this.socialWindow.close(),S.AccountController.setSocialWindow(void 0,P.ChainController.state.activeChain))}),this.unsubscribe.push(S.AccountController.subscribe(e=>{e.socialProvider&&(this.socialProvider=e.socialProvider),e.socialWindow&&(this.socialWindow=e.socialWindow)}),n.OptionsController.subscribeKey("remoteFeatures",e=>{this.remoteFeatures=e}),S.AccountController.subscribeKey("address",e=>{let t=this.remoteFeatures?.multiWallet;e&&e!==this.address&&(this.hasMultipleConnections&&t?(p.RouterController.replace("ProfileWallets"),$.SnackController.showSuccess("New Wallet Added")):(R.ModalController.state.open||n.OptionsController.state.enableEmbedded)&&R.ModalController.close())})),this.authConnector&&this.connectSocial()}disconnectedCallback(){this.unsubscribe.forEach(e=>e()),window.removeEventListener("message",this.handleSocialConnection,!1),this.socialWindow?.close(),S.AccountController.setSocialWindow(void 0,P.ChainController.state.activeChain)}render(){return o.html`
      <wui-flex
        data-error=${(0,r.ifDefined)(this.error)}
        flexDirection="column"
        alignItems="center"
        .padding=${["3xl","xl","xl","xl"]}
        gap="xl"
      >
        <wui-flex justifyContent="center" alignItems="center">
          <wui-logo logo=${(0,r.ifDefined)(this.socialProvider)}></wui-logo>
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
    `}loaderTemplate(){let e=T.ThemeController.state.themeVariables["--w3m-border-radius-master"],t=e?parseInt(e.replace("px",""),10):4;return o.html`<wui-loading-thumbnail radius=${9*t}></wui-loading-thumbnail>`}connectSocial(){let e=setInterval(()=>{this.socialWindow?.closed&&(this.connecting||"ConnectingSocial"!==p.RouterController.state.view||(this.socialProvider&&L.EventsController.sendEvent({type:"track",event:"SOCIAL_LOGIN_CANCELED",properties:{provider:this.socialProvider}}),p.RouterController.goBack()),clearInterval(e))},1e3);window.addEventListener("message",this.handleSocialConnection,!1)}updateMessage(){this.error?this.message="Something went wrong":this.connecting?this.message="Retrieving user data":this.message="Connect in the provider window"}};_.styles=W,F([(0,i.state)()],_.prototype,"socialProvider",void 0),F([(0,i.state)()],_.prototype,"socialWindow",void 0),F([(0,i.state)()],_.prototype,"error",void 0),F([(0,i.state)()],_.prototype,"connecting",void 0),F([(0,i.state)()],_.prototype,"message",void 0),F([(0,i.state)()],_.prototype,"remoteFeatures",void 0),_=F([(0,a.customElement)("w3m-connecting-social-view")],_),e.s(["W3mConnectingSocialView",()=>_],675713);var D=t;e.i(81981),e.i(982221),e.i(472945),e.i(143880),e.i(211366);let j=C.css`
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
`;var q=function(e,t,o,i){var r,n=arguments.length,s=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,o):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,o,i);else for(var a=e.length-1;a>=0;a--)(r=e[a])&&(s=(n<3?r(s):n>3?r(t,o,s):r(t,o))||s);return n>3&&s&&Object.defineProperty(t,o,s),s};let N=class extends D.LitElement{constructor(){super(),this.unsubscribe=[],this.timeout=void 0,this.socialProvider=S.AccountController.state.socialProvider,this.uri=S.AccountController.state.farcasterUrl,this.ready=!1,this.loading=!1,this.remoteFeatures=n.OptionsController.state.remoteFeatures,this.authConnector=d.ConnectorController.getAuthConnector(),this.forceUpdate=()=>{this.requestUpdate()},this.unsubscribe.push(S.AccountController.subscribeKey("farcasterUrl",e=>{e&&(this.uri=e,this.connectFarcaster())}),S.AccountController.subscribeKey("socialProvider",e=>{e&&(this.socialProvider=e)}),n.OptionsController.subscribeKey("remoteFeatures",e=>{this.remoteFeatures=e})),window.addEventListener("resize",this.forceUpdate)}disconnectedCallback(){super.disconnectedCallback(),clearTimeout(this.timeout),window.removeEventListener("resize",this.forceUpdate)}render(){return this.onRenderProxy(),o.html`${this.platformTemplate()}`}platformTemplate(){return w.CoreHelperUtil.isMobile()?o.html`${this.mobileTemplate()}`:o.html`${this.desktopTemplate()}`}desktopTemplate(){return this.loading?o.html`${this.loadingTemplate()}`:o.html`${this.qrTemplate()}`}qrTemplate(){return o.html` <wui-flex
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
    </wui-flex>`}loadingTemplate(){return o.html`
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
    `}mobileTemplate(){return o.html` <wui-flex
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
    </wui-flex>`}loaderTemplate(){let e=T.ThemeController.state.themeVariables["--w3m-border-radius-master"],t=e?parseInt(e.replace("px",""),10):4;return o.html`<wui-loading-thumbnail radius=${9*t}></wui-loading-thumbnail>`}async connectFarcaster(){if(this.authConnector)try{await this.authConnector?.provider.connectFarcaster(),this.socialProvider&&(A.StorageUtil.setConnectedSocialProvider(this.socialProvider),L.EventsController.sendEvent({type:"track",event:"SOCIAL_LOGIN_REQUEST_USER_DATA",properties:{provider:this.socialProvider}})),this.loading=!0;let e=O.ConnectionController.getConnections(this.authConnector.chain).length>0;await O.ConnectionController.connectExternal(this.authConnector,this.authConnector.chain);let t=this.remoteFeatures?.multiWallet;this.socialProvider&&L.EventsController.sendEvent({type:"track",event:"SOCIAL_LOGIN_SUCCESS",properties:{provider:this.socialProvider}}),this.loading=!1,e&&t?(p.RouterController.replace("ProfileWallets"),$.SnackController.showSuccess("New Wallet Added")):R.ModalController.close()}catch(e){this.socialProvider&&L.EventsController.sendEvent({type:"track",event:"SOCIAL_LOGIN_ERROR",properties:{provider:this.socialProvider}}),p.RouterController.goBack(),$.SnackController.showError(e)}}mobileLinkTemplate(){return o.html`<wui-button
      size="md"
      ?loading=${this.loading}
      ?disabled=${!this.uri||this.loading}
      @click=${()=>{this.uri&&w.CoreHelperUtil.openHref(this.uri,"_blank")}}
    >
      Open farcaster</wui-button
    >`}onRenderProxy(){!this.ready&&this.uri&&(this.timeout=setTimeout(()=>{this.ready=!0},200))}qrCodeTemplate(){if(!this.uri||!this.ready)return null;let e=this.getBoundingClientRect().width-40;return o.html` <wui-qr-code
      size=${e}
      theme=${T.ThemeController.state.themeMode}
      uri=${this.uri}
      ?farcaster=${!0}
      data-testid="wui-qr-code"
      color=${(0,r.ifDefined)(T.ThemeController.state.themeVariables["--w3m-qr-color"])}
    ></wui-qr-code>`}copyTemplate(){let e=!this.uri||!this.ready;return o.html`<wui-link
      .disabled=${e}
      @click=${this.onCopyUri}
      color="fg-200"
      data-testid="copy-wc2-uri"
    >
      <wui-icon size="xs" color="fg-200" slot="iconLeft" name="copy"></wui-icon>
      Copy link
    </wui-link>`}onCopyUri(){try{this.uri&&(w.CoreHelperUtil.copyToClopboard(this.uri),$.SnackController.showSuccess("Link copied"))}catch{$.SnackController.showError("Failed to copy")}}};N.styles=j,q([(0,i.state)()],N.prototype,"socialProvider",void 0),q([(0,i.state)()],N.prototype,"uri",void 0),q([(0,i.state)()],N.prototype,"ready",void 0),q([(0,i.state)()],N.prototype,"loading",void 0),q([(0,i.state)()],N.prototype,"remoteFeatures",void 0),N=q([(0,a.customElement)("w3m-connecting-farcaster-view")],N),e.s(["W3mConnectingFarcasterView",()=>N],375361),e.s([],126701),e.i(126701),e.i(26870),e.i(675713),e.i(375361),e.s(["W3mConnectSocialsView",()=>k,"W3mConnectingFarcasterView",()=>N,"W3mConnectingSocialView",()=>_],175041)}]);