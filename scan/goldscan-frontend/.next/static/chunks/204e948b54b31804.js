(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,493623,e=>{"use strict";e.i(588984);var t=e.i(399702),i=e.i(872857);e.i(759703);var r=e.i(698797);e.i(781840);var o=e.i(86988),s=e.i(596590),a=e.i(589408),l=e.i(207176),n=e.i(301847),c=e.i(375054),u=e.i(944396),d=e.i(880985),p=e.i(355376);e.i(302184);var w=e.i(34691),h=e.i(938559);e.i(330885);var m=t,f=e.i(392074);e.i(630572),e.i(287940),e.i(596548),e.i(108476);var g=e.i(864429),v=e.i(118827);let k=v.css`
  button {
    display: flex;
    gap: var(--wui-spacing-xl);
    width: 100%;
    background-color: var(--wui-color-gray-glass-002);
    border-radius: var(--wui-border-radius-xxs);
    padding: var(--wui-spacing-m) var(--wui-spacing-s);
  }

  wui-text {
    width: 100%;
  }

  wui-flex {
    width: auto;
  }

  .network-icon {
    width: var(--wui-spacing-2l);
    height: var(--wui-spacing-2l);
    border-radius: calc(var(--wui-spacing-2l) / 2);
    overflow: hidden;
    box-shadow:
      0 0 0 3px var(--wui-color-gray-glass-002),
      0 0 0 3px var(--wui-color-modal-bg);
  }
`;var b=function(e,t,i,r){var o,s=arguments.length,a=s<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,i,r);else for(var l=e.length-1;l>=0;l--)(o=e[l])&&(a=(s<3?o(a):s>3?o(t,i,a):o(t,i))||a);return s>3&&a&&Object.defineProperty(t,i,a),a};let C=class extends m.LitElement{constructor(){super(...arguments),this.networkImages=[""],this.text=""}render(){return i.html`
      <button>
        <wui-text variant="small-400" color="fg-200">${this.text}</wui-text>
        <wui-flex gap="3xs" alignItems="center">
          ${this.networksTemplate()}
          <wui-icon name="chevronRight" size="sm" color="fg-200"></wui-icon>
        </wui-flex>
      </button>
    `}networksTemplate(){let e=this.networkImages.slice(0,5);return i.html` <wui-flex class="networks">
      ${e?.map(e=>i.html` <wui-flex class="network-icon"> <wui-image src=${e}></wui-image> </wui-flex>`)}
    </wui-flex>`}};C.styles=[g.resetStyles,g.elementStyles,k],b([(0,f.property)({type:Array})],C.prototype,"networkImages",void 0),b([(0,f.property)()],C.prototype,"text",void 0),C=b([(0,h.customElement)("wui-compatible-network")],C),e.i(237029),e.i(143880),e.i(331658);var y=e.i(142844);let x=v.css`
  wui-compatible-network {
    margin-top: var(--wui-spacing-l);
  }
`;var N=function(e,t,i,r){var o,s=arguments.length,a=s<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,i,r);else for(var l=e.length-1;l>=0;l--)(o=e[l])&&(a=(s<3?o(a):s>3?o(t,i,a):o(t,i))||a);return s>3&&a&&Object.defineProperty(t,i,a),a};let R=class extends t.LitElement{constructor(){super(),this.unsubscribe=[],this.address=s.AccountController.state.address,this.profileName=s.AccountController.state.profileName,this.network=l.ChainController.state.activeCaipNetwork,this.unsubscribe.push(s.AccountController.subscribe(e=>{e.address?(this.address=e.address,this.profileName=e.profileName):u.SnackController.showError("Account not found")}),l.ChainController.subscribeKey("activeCaipNetwork",e=>{e?.id&&(this.network=e)}))}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}render(){if(!this.address)throw Error("w3m-wallet-receive-view: No account provided");let e=a.AssetUtil.getNetworkImage(this.network);return i.html` <wui-flex
      flexDirection="column"
      .padding=${["0","l","l","l"]}
      alignItems="center"
    >
      <wui-chip-button
        data-testid="receive-address-copy-button"
        @click=${this.onCopyClick.bind(this)}
        text=${w.UiHelperUtil.getTruncateString({string:this.profileName||this.address||"",charsStart:this.profileName?18:4,charsEnd:4*!this.profileName,truncate:this.profileName?"end":"middle"})}
        icon="copy"
        size="sm"
        imageSrc=${e||""}
        variant="gray"
      ></wui-chip-button>
      <wui-flex
        flexDirection="column"
        .padding=${["l","0","0","0"]}
        alignItems="center"
        gap="s"
      >
        <wui-qr-code
          size=${232}
          theme=${d.ThemeController.state.themeMode}
          uri=${this.address}
          ?arenaClear=${!0}
          color=${(0,o.ifDefined)(d.ThemeController.state.themeVariables["--w3m-qr-color"])}
          data-testid="wui-qr-code"
        ></wui-qr-code>
        <wui-text variant="paragraph-500" color="fg-100" align="center">
          Copy your address or scan this QR code
        </wui-text>
      </wui-flex>
      ${this.networkTemplate()}
    </wui-flex>`}networkTemplate(){let e=l.ChainController.getAllRequestedCaipNetworks(),t=l.ChainController.checkIfSmartAccountEnabled(),r=l.ChainController.state.activeCaipNetwork,o=e.filter(e=>e?.chainNamespace===r?.chainNamespace);if((0,p.getPreferredAccountType)(r?.chainNamespace)===y.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT&&t)return r?i.html`<wui-compatible-network
        @click=${this.onReceiveClick.bind(this)}
        text="Only receive assets on this network"
        .networkImages=${[a.AssetUtil.getNetworkImage(r)??""]}
      ></wui-compatible-network>`:null;let s=(o?.filter(e=>e?.assets?.imageId)?.slice(0,5)).map(a.AssetUtil.getNetworkImage).filter(Boolean);return i.html`<wui-compatible-network
      @click=${this.onReceiveClick.bind(this)}
      text="Only receive assets on these networks"
      .networkImages=${s}
    ></wui-compatible-network>`}onReceiveClick(){c.RouterController.push("WalletCompatibleNetworks")}onCopyClick(){try{this.address&&(n.CoreHelperUtil.copyToClopboard(this.address),u.SnackController.showSuccess("Address copied"))}catch{u.SnackController.showError("Failed to copy")}}};R.styles=x,N([(0,r.state)()],R.prototype,"address",void 0),N([(0,r.state)()],R.prototype,"profileName",void 0),N([(0,r.state)()],R.prototype,"network",void 0),R=N([(0,h.customElement)("w3m-wallet-receive-view")],R),e.s(["W3mWalletReceiveView",()=>R],524858),e.s([],518471),e.i(518471),e.i(524858),e.s(["W3mWalletReceiveView",()=>R],493623)}]);