(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,801461,e=>{"use strict";e.i(588984);var t,i,r=e.i(399702),a=e.i(872857);e.i(759703);var o=e.i(392074),s=e.i(698797),n=e.i(660506),l=e.i(207176),c=e.i(301847),u=e.i(881936),p=e.i(944411),d=e.i(375054),h=e.i(557618),w=e.i(355376);e.i(302184);var v=e.i(414737),g=e.i(938559);e.i(237029),e.i(174776),e.i(472945),e.i(331658);var m=r;e.i(781840);var y=e.i(86988);e.i(630572),e.i(596548),e.i(108476);var f=e.i(864429);(t=i||(i={})).approve="approved",t.bought="bought",t.borrow="borrowed",t.burn="burnt",t.cancel="canceled",t.claim="claimed",t.deploy="deployed",t.deposit="deposited",t.execute="executed",t.mint="minted",t.receive="received",t.repay="repaid",t.send="sent",t.sell="sold",t.stake="staked",t.trade="swapped",t.unstake="unstaked",t.withdraw="withdrawn";var b=r;e.i(287940),e.i(839432);var x=e.i(118827);let k=x.css`
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
`;var C=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let $=class extends b.LitElement{constructor(){super(...arguments),this.images=[],this.secondImage={type:void 0,url:""}}render(){let[e,t]=this.images,i=e?.type==="NFT",r=t?.url?"NFT"===t.type:i;return this.style.cssText=`
    --local-left-border-radius: ${i?"var(--wui-border-radius-xxs)":"var(--wui-border-radius-s)"};
    --local-right-border-radius: ${r?"var(--wui-border-radius-xxs)":"var(--wui-border-radius-s)"};
    `,a.html`<wui-flex> ${this.templateVisual()} ${this.templateIcon()} </wui-flex>`}templateVisual(){let[e,t]=this.images,i=e?.type;return 2===this.images.length&&(e?.url||t?.url)?a.html`<div class="swap-images-container">
        ${e?.url?a.html`<wui-image src=${e.url} alt="Transaction image"></wui-image>`:null}
        ${t?.url?a.html`<wui-image src=${t.url} alt="Transaction image"></wui-image>`:null}
      </div>`:e?.url?a.html`<wui-image src=${e.url} alt="Transaction image"></wui-image>`:"NFT"===i?a.html`<wui-icon size="inherit" color="fg-200" name="nftPlaceholder"></wui-icon>`:a.html`<wui-icon size="inherit" color="fg-200" name="coinPlaceholder"></wui-icon>`}templateIcon(){let e,t="accent-100";return(e=this.getIcon(),this.status&&(t=this.getStatusColor()),e)?a.html`
      <wui-icon-box
        size="xxs"
        iconColor=${t}
        backgroundColor=${t}
        background="opaque"
        icon=${e}
        ?border=${!0}
        borderColor="wui-color-bg-125"
      ></wui-icon-box>
    `:null}getDirectionIcon(){switch(this.direction){case"in":return"arrowBottom";case"out":return"arrowTop";default:return}}getIcon(){return this.onlyDirectionIcon?this.getDirectionIcon():"trade"===this.type?"swapHorizontalBold":"approve"===this.type?"checkmark":"cancel"===this.type?"close":this.getDirectionIcon()}getStatusColor(){switch(this.status){case"confirmed":return"success-100";case"failed":return"error-100";case"pending":return"inverse-100";default:return"accent-100"}}};$.styles=[k],C([(0,o.property)()],$.prototype,"type",void 0),C([(0,o.property)()],$.prototype,"status",void 0),C([(0,o.property)()],$.prototype,"direction",void 0),C([(0,o.property)({type:Boolean})],$.prototype,"onlyDirectionIcon",void 0),C([(0,o.property)({type:Array})],$.prototype,"images",void 0),C([(0,o.property)({type:Object})],$.prototype,"secondImage",void 0),$=C([(0,g.customElement)("wui-transaction-visual")],$);let R=x.css`
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
`;var S=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let O=class extends m.LitElement{constructor(){super(...arguments),this.type="approve",this.onlyDirectionIcon=!1,this.images=[],this.price=[],this.amount=[],this.symbol=[]}render(){return a.html`
      <wui-flex>
        <wui-transaction-visual
          .status=${this.status}
          direction=${(0,y.ifDefined)(this.direction)}
          type=${this.type}
          onlyDirectionIcon=${(0,y.ifDefined)(this.onlyDirectionIcon)}
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
    `}templateDescription(){let e=this.descriptions?.[0];return e?a.html`
          <wui-text variant="small-500" color="fg-200">
            <span>${e}</span>
          </wui-text>
        `:null}templateSecondDescription(){let e=this.descriptions?.[1];return e?a.html`
          <wui-icon class="description-separator-icon" size="xxs" name="arrowRight"></wui-icon>
          <wui-text variant="small-400" color="fg-200">
            <span>${e}</span>
          </wui-text>
        `:null}};O.styles=[f.resetStyles,R],S([(0,o.property)()],O.prototype,"type",void 0),S([(0,o.property)({type:Array})],O.prototype,"descriptions",void 0),S([(0,o.property)()],O.prototype,"date",void 0),S([(0,o.property)({type:Boolean})],O.prototype,"onlyDirectionIcon",void 0),S([(0,o.property)()],O.prototype,"status",void 0),S([(0,o.property)()],O.prototype,"direction",void 0),S([(0,o.property)({type:Array})],O.prototype,"images",void 0),S([(0,o.property)({type:Array})],O.prototype,"price",void 0),S([(0,o.property)({type:Array})],O.prototype,"amount",void 0),S([(0,o.property)({type:Array})],O.prototype,"symbol",void 0),O=S([(0,g.customElement)("wui-transaction-list-item")],O);var T=r;e.i(846880);let z=x.css`
  :host > wui-flex:first-child {
    column-gap: var(--wui-spacing-s);
    padding: 7px var(--wui-spacing-l) 7px var(--wui-spacing-xs);
    width: 100%;
  }

  wui-flex {
    display: flex;
    flex: 1;
  }
`,E=class extends T.LitElement{render(){return a.html`
      <wui-flex alignItems="center">
        <wui-shimmer width="40px" height="40px"></wui-shimmer>
        <wui-flex flexDirection="column" gap="2xs">
          <wui-shimmer width="72px" height="16px" borderRadius="4xs"></wui-shimmer>
          <wui-shimmer width="148px" height="14px" borderRadius="4xs"></wui-shimmer>
        </wui-flex>
        <wui-shimmer width="24px" height="12px" borderRadius="5xs"></wui-shimmer>
      </wui-flex>
    `}};E.styles=[f.resetStyles,z],E=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s}([(0,g.customElement)("wui-transaction-list-item-loader")],E);var j=e.i(142844);let P=x.css`
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
`;var I=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let A="last-transaction",D=class extends r.LitElement{constructor(){super(),this.unsubscribe=[],this.paginationObserver=void 0,this.page="activity",this.caipAddress=l.ChainController.state.activeCaipAddress,this.transactionsByYear=h.TransactionsController.state.transactionsByYear,this.loading=h.TransactionsController.state.loading,this.empty=h.TransactionsController.state.empty,this.next=h.TransactionsController.state.next,h.TransactionsController.clearCursor(),this.unsubscribe.push(l.ChainController.subscribeKey("activeCaipAddress",e=>{e&&this.caipAddress!==e&&(h.TransactionsController.resetTransactions(),h.TransactionsController.fetchTransactions(e)),this.caipAddress=e}),l.ChainController.subscribeKey("activeCaipNetwork",()=>{this.updateTransactionView()}),h.TransactionsController.subscribe(e=>{this.transactionsByYear=e.transactionsByYear,this.loading=e.loading,this.empty=e.empty,this.next=e.next}))}firstUpdated(){this.updateTransactionView(),this.createPaginationObserver()}updated(){this.setPaginationObserver()}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}render(){return a.html` ${this.empty?null:this.templateTransactionsByYear()}
    ${this.loading?this.templateLoading():null}
    ${!this.loading&&this.empty?this.templateEmpty():null}`}updateTransactionView(){h.TransactionsController.resetTransactions(),this.caipAddress&&h.TransactionsController.fetchTransactions(c.CoreHelperUtil.getPlainAddress(this.caipAddress))}templateTransactionsByYear(){return Object.keys(this.transactionsByYear).sort().reverse().map(e=>{let t=parseInt(e,10),i=Array(12).fill(null).map((e,i)=>({groupTitle:v.TransactionUtil.getTransactionGroupTitle(t,i),transactions:this.transactionsByYear[t]?.[i]})).filter(({transactions:e})=>e).reverse();return i.map(({groupTitle:e,transactions:t},r)=>{let o=r===i.length-1;return t?a.html`
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
                >${e}</wui-text
              >
            </wui-flex>
            <wui-flex flexDirection="column" gap="xs">
              ${this.templateTransactions(t,o)}
            </wui-flex>
          </wui-flex>
        `:null})})}templateRenderTransaction(e,t){let{date:i,descriptions:r,direction:o,isAllNFT:s,images:n,status:l,transfers:c,type:u}=this.getTransactionListItemProps(e),p=c?.length>1;return c?.length!==2||s?p?c.map((e,r)=>{let o=v.TransactionUtil.getTransferDescription(e),s=t&&r===c.length-1;return a.html` <wui-transaction-list-item
          date=${i}
          direction=${e.direction}
          id=${s&&this.next?A:""}
          status=${l}
          type=${u}
          .onlyDirectionIcon=${!0}
          .images=${[n[r]]}
          .descriptions=${[o]}
        ></wui-transaction-list-item>`}):a.html`
      <wui-transaction-list-item
        date=${i}
        .direction=${o}
        id=${t&&this.next?A:""}
        status=${l}
        type=${u}
        .images=${n}
        .descriptions=${r}
      ></wui-transaction-list-item>
    `:a.html`
        <wui-transaction-list-item
          date=${i}
          .direction=${o}
          id=${t&&this.next?A:""}
          status=${l}
          type=${u}
          .images=${n}
          .descriptions=${r}
        ></wui-transaction-list-item>
      `}templateTransactions(e,t){return e.map((i,r)=>{let o=t&&r===e.length-1;return a.html`${this.templateRenderTransaction(i,o)}`})}emptyStateActivity(){return a.html`<wui-flex
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
    </wui-flex>`}templateEmpty(){return"account"===this.page?a.html`${this.emptyStateAccount()}`:a.html`${this.emptyStateActivity()}`}templateLoading(){return"activity"===this.page?Array(7).fill(a.html` <wui-transaction-list-item-loader></wui-transaction-list-item-loader> `).map(e=>e):null}onReceiveClick(){d.RouterController.push("WalletReceive")}createPaginationObserver(){let{projectId:e}=p.OptionsController.state;this.paginationObserver=new IntersectionObserver(([t])=>{t?.isIntersecting&&!this.loading&&(h.TransactionsController.fetchTransactions(c.CoreHelperUtil.getPlainAddress(this.caipAddress)),u.EventsController.sendEvent({type:"track",event:"LOAD_MORE_TRANSACTIONS",properties:{address:c.CoreHelperUtil.getPlainAddress(this.caipAddress),projectId:e,cursor:this.next,isSmartAccount:(0,w.getPreferredAccountType)(l.ChainController.state.activeChain)===j.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT}}))},{}),this.setPaginationObserver()}setPaginationObserver(){this.paginationObserver?.disconnect();let e=this.shadowRoot?.querySelector(`#${A}`);e&&this.paginationObserver?.observe(e)}getTransactionListItemProps(e){let t=n.DateUtil.formatDate(e?.metadata?.minedAt),i=v.TransactionUtil.getTransactionDescriptions(e),r=e?.transfers,a=e?.transfers?.[0],o=!!a&&e?.transfers?.every(e=>!!e.nft_info),s=v.TransactionUtil.getTransactionImages(r);return{date:t,direction:a?.direction,descriptions:i,isAllNFT:o,images:s,status:e.metadata?.status,transfers:r,type:e.metadata?.operationType}}};D.styles=P,I([(0,o.property)()],D.prototype,"page",void 0),I([(0,s.state)()],D.prototype,"caipAddress",void 0),I([(0,s.state)()],D.prototype,"transactionsByYear",void 0),I([(0,s.state)()],D.prototype,"loading",void 0),I([(0,s.state)()],D.prototype,"empty",void 0),I([(0,s.state)()],D.prototype,"next",void 0),D=I([(0,g.customElement)("w3m-activity-list")],D),e.s([],801461)},474025,e=>{"use strict";e.i(588984);var t=e.i(399702),i=e.i(872857);e.i(759703);var r=e.i(698797),a=e.i(375054),o=e.i(420435);e.i(302184);var s=e.i(938559),n=e.i(924487),l=e.i(118827);let c=l.css`
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
`;var u=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let p=class extends t.LitElement{constructor(){super(),this.resizeObserver=void 0,this.prevHeight="0px",this.prevHistoryLength=1,this.unsubscribe=[],this.view=a.RouterController.state.view,this.viewDirection="",this.unsubscribe.push(a.RouterController.subscribeKey("view",e=>this.onViewChange(e)))}firstUpdated(){this.resizeObserver=new ResizeObserver(([e])=>{let t=`${e?.contentRect.height}px`;"0px"!==this.prevHeight&&(this.style.setProperty("--prev-height",this.prevHeight),this.style.setProperty("--new-height",t),this.style.animation="w3m-view-height 150ms forwards ease",this.style.height="auto"),setTimeout(()=>{this.prevHeight=t,this.style.animation="unset"},n.ConstantsUtil.ANIMATION_DURATIONS.ModalHeight)}),this.resizeObserver?.observe(this.getWrapper())}disconnectedCallback(){this.resizeObserver?.unobserve(this.getWrapper()),this.unsubscribe.forEach(e=>e())}render(){return i.html`<div class="w3m-router-container" view-direction="${this.viewDirection}">
      ${this.viewTemplate()}
    </div>`}viewTemplate(){switch(this.view){case"AccountSettings":return i.html`<w3m-account-settings-view></w3m-account-settings-view>`;case"Account":return i.html`<w3m-account-view></w3m-account-view>`;case"AllWallets":return i.html`<w3m-all-wallets-view></w3m-all-wallets-view>`;case"ApproveTransaction":return i.html`<w3m-approve-transaction-view></w3m-approve-transaction-view>`;case"BuyInProgress":return i.html`<w3m-buy-in-progress-view></w3m-buy-in-progress-view>`;case"ChooseAccountName":return i.html`<w3m-choose-account-name-view></w3m-choose-account-name-view>`;case"Connect":default:return i.html`<w3m-connect-view></w3m-connect-view>`;case"Create":return i.html`<w3m-connect-view walletGuide="explore"></w3m-connect-view>`;case"ConnectingWalletConnect":return i.html`<w3m-connecting-wc-view></w3m-connecting-wc-view>`;case"ConnectingWalletConnectBasic":return i.html`<w3m-connecting-wc-basic-view></w3m-connecting-wc-basic-view>`;case"ConnectingExternal":return i.html`<w3m-connecting-external-view></w3m-connecting-external-view>`;case"ConnectingSiwe":return i.html`<w3m-connecting-siwe-view></w3m-connecting-siwe-view>`;case"ConnectWallets":return i.html`<w3m-connect-wallets-view></w3m-connect-wallets-view>`;case"ConnectSocials":return i.html`<w3m-connect-socials-view></w3m-connect-socials-view>`;case"ConnectingSocial":return i.html`<w3m-connecting-social-view></w3m-connecting-social-view>`;case"DataCapture":return i.html`<w3m-data-capture-view></w3m-data-capture-view>`;case"DataCaptureOtpConfirm":return i.html`<w3m-data-capture-otp-confirm-view></w3m-data-capture-otp-confirm-view>`;case"Downloads":return i.html`<w3m-downloads-view></w3m-downloads-view>`;case"EmailLogin":return i.html`<w3m-email-login-view></w3m-email-login-view>`;case"EmailVerifyOtp":return i.html`<w3m-email-verify-otp-view></w3m-email-verify-otp-view>`;case"EmailVerifyDevice":return i.html`<w3m-email-verify-device-view></w3m-email-verify-device-view>`;case"GetWallet":return i.html`<w3m-get-wallet-view></w3m-get-wallet-view>`;case"Networks":return i.html`<w3m-networks-view></w3m-networks-view>`;case"SwitchNetwork":return i.html`<w3m-network-switch-view></w3m-network-switch-view>`;case"ProfileWallets":return i.html`<w3m-profile-wallets-view></w3m-profile-wallets-view>`;case"Transactions":return i.html`<w3m-transactions-view></w3m-transactions-view>`;case"OnRampProviders":return i.html`<w3m-onramp-providers-view></w3m-onramp-providers-view>`;case"OnRampTokenSelect":return i.html`<w3m-onramp-token-select-view></w3m-onramp-token-select-view>`;case"OnRampFiatSelect":return i.html`<w3m-onramp-fiat-select-view></w3m-onramp-fiat-select-view>`;case"UpgradeEmailWallet":return i.html`<w3m-upgrade-wallet-view></w3m-upgrade-wallet-view>`;case"UpdateEmailWallet":return i.html`<w3m-update-email-wallet-view></w3m-update-email-wallet-view>`;case"UpdateEmailPrimaryOtp":return i.html`<w3m-update-email-primary-otp-view></w3m-update-email-primary-otp-view>`;case"UpdateEmailSecondaryOtp":return i.html`<w3m-update-email-secondary-otp-view></w3m-update-email-secondary-otp-view>`;case"UnsupportedChain":return i.html`<w3m-unsupported-chain-view></w3m-unsupported-chain-view>`;case"Swap":return i.html`<w3m-swap-view></w3m-swap-view>`;case"SwapSelectToken":return i.html`<w3m-swap-select-token-view></w3m-swap-select-token-view>`;case"SwapPreview":return i.html`<w3m-swap-preview-view></w3m-swap-preview-view>`;case"WalletSend":return i.html`<w3m-wallet-send-view></w3m-wallet-send-view>`;case"WalletSendSelectToken":return i.html`<w3m-wallet-send-select-token-view></w3m-wallet-send-select-token-view>`;case"WalletSendPreview":return i.html`<w3m-wallet-send-preview-view></w3m-wallet-send-preview-view>`;case"WhatIsABuy":return i.html`<w3m-what-is-a-buy-view></w3m-what-is-a-buy-view>`;case"WalletReceive":return i.html`<w3m-wallet-receive-view></w3m-wallet-receive-view>`;case"WalletCompatibleNetworks":return i.html`<w3m-wallet-compatible-networks-view></w3m-wallet-compatible-networks-view>`;case"WhatIsAWallet":return i.html`<w3m-what-is-a-wallet-view></w3m-what-is-a-wallet-view>`;case"ConnectingMultiChain":return i.html`<w3m-connecting-multi-chain-view></w3m-connecting-multi-chain-view>`;case"WhatIsANetwork":return i.html`<w3m-what-is-a-network-view></w3m-what-is-a-network-view>`;case"ConnectingFarcaster":return i.html`<w3m-connecting-farcaster-view></w3m-connecting-farcaster-view>`;case"SwitchActiveChain":return i.html`<w3m-switch-active-chain-view></w3m-switch-active-chain-view>`;case"RegisterAccountName":return i.html`<w3m-register-account-name-view></w3m-register-account-name-view>`;case"RegisterAccountNameSuccess":return i.html`<w3m-register-account-name-success-view></w3m-register-account-name-success-view>`;case"SmartSessionCreated":return i.html`<w3m-smart-session-created-view></w3m-smart-session-created-view>`;case"SmartSessionList":return i.html`<w3m-smart-session-list-view></w3m-smart-session-list-view>`;case"SIWXSignMessage":return i.html`<w3m-siwx-sign-message-view></w3m-siwx-sign-message-view>`;case"Pay":return i.html`<w3m-pay-view></w3m-pay-view>`;case"PayLoading":return i.html`<w3m-pay-loading-view></w3m-pay-loading-view>`;case"FundWallet":return i.html`<w3m-fund-wallet-view></w3m-fund-wallet-view>`;case"PayWithExchange":return i.html`<w3m-deposit-from-exchange-view></w3m-deposit-from-exchange-view>`}}onViewChange(e){o.TooltipController.hide();let t=n.ConstantsUtil.VIEW_DIRECTION.Next,{history:i}=a.RouterController.state;i.length<this.prevHistoryLength&&(t=n.ConstantsUtil.VIEW_DIRECTION.Prev),this.prevHistoryLength=i.length,this.viewDirection=t,setTimeout(()=>{this.view=e},n.ConstantsUtil.ANIMATION_DURATIONS.ViewTransition)}getWrapper(){return this.shadowRoot?.querySelector("div")}};p.styles=c,u([(0,r.state)()],p.prototype,"view",void 0),u([(0,r.state)()],p.prototype,"viewDirection",void 0),p=u([(0,s.customElement)("w3m-router")],p),e.s(["W3mRouter",()=>p],474025)},641912,420435,e=>{"use strict";e.i(588984);var t=e.i(399702),i=e.i(872857);e.i(759703);var r=e.i(698797),a=e.i(725519),o=e.i(941031),s=e.i(869067);let n=(0,a.proxy)({message:"",open:!1,triggerRect:{width:0,height:0,top:0,left:0},variant:"shade"}),l=(0,s.withErrorBoundary)({state:n,subscribe:e=>(0,a.subscribe)(n,()=>e(n)),subscribeKey:(e,t)=>(0,o.subscribeKey)(n,e,t),showTooltip({message:e,triggerRect:t,variant:i}){n.open=!0,n.message=e,n.triggerRect=t,n.variant=i},hide(){n.open=!1,n.message="",n.triggerRect={width:0,height:0,top:0,left:0}}});e.s(["TooltipController",0,l],420435),e.i(302184);var c=e.i(938559);e.i(237029),e.i(982221),e.i(331658);var u=e.i(118827);let p=u.css`
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
`;var d=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let h=class extends t.LitElement{constructor(){super(),this.unsubscribe=[],this.open=l.state.open,this.message=l.state.message,this.triggerRect=l.state.triggerRect,this.variant=l.state.variant,this.unsubscribe.push(l.subscribe(e=>{this.open=e.open,this.message=e.message,this.triggerRect=e.triggerRect,this.variant=e.variant}))}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}render(){this.dataset.variant=this.variant;let e=this.triggerRect.top,t=this.triggerRect.left;return this.style.cssText=`
    --w3m-tooltip-top: ${e}px;
    --w3m-tooltip-left: ${t}px;
    --w3m-tooltip-parent-width: ${this.triggerRect.width/2}px;
    --w3m-tooltip-display: ${this.open?"flex":"none"};
    --w3m-tooltip-opacity: ${+!!this.open};
    `,i.html`<wui-flex>
      <wui-icon data-placement="top" color="fg-100" size="inherit" name="cursor"></wui-icon>
      <wui-text color="inherit" variant="small-500">${this.message}</wui-text>
    </wui-flex>`}};h.styles=[p],d([(0,r.state)()],h.prototype,"open",void 0),d([(0,r.state)()],h.prototype,"message",void 0),d([(0,r.state)()],h.prototype,"triggerRect",void 0),d([(0,r.state)()],h.prototype,"variant",void 0),h=d([(0,c.customElement)("w3m-tooltip"),(0,c.customElement)("w3m-tooltip")],h),e.s([],641912)},679556,282969,e=>{"use strict";e.i(588984);var t=e.i(399702),i=e.i(872857);e.i(759703);var r=e.i(392074);e.i(630572);var a=e.i(864429),o=e.i(938559),s=e.i(118827);let n=s.css`
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
`;var l=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let c=class extends t.LitElement{constructor(){super(...arguments),this.size="md",this.disabled=!1,this.icon="copy",this.iconColor="inherit"}render(){this.dataset.size=this.size;let e="",t="";switch(this.size){case"lg":e="--wui-border-radius-xs",t="--wui-spacing-1xs";break;case"sm":e="--wui-border-radius-3xs",t="--wui-spacing-xxs";break;default:e="--wui-border-radius-xxs",t="--wui-spacing-2xs"}return this.style.cssText=`
    --local-border-radius: var(${e});
    --local-padding: var(${t});
    `,i.html`
      <button ?disabled=${this.disabled}>
        <wui-icon color=${this.iconColor} size=${this.size} name=${this.icon}></wui-icon>
      </button>
    `}};c.styles=[a.resetStyles,a.elementStyles,a.colorStyles,n],l([(0,r.property)()],c.prototype,"size",void 0),l([(0,r.property)({type:Boolean})],c.prototype,"disabled",void 0),l([(0,r.property)()],c.prototype,"icon",void 0),l([(0,r.property)()],c.prototype,"iconColor",void 0),c=l([(0,o.customElement)("wui-icon-link")],c),e.s([],282969),e.s([],679556)},990237,185212,e=>{"use strict";e.i(588984);var t=e.i(399702),i=e.i(872857);e.i(759703);var r=e.i(392074);e.i(596548);var a=e.i(864429),o=e.i(938559),s=e.i(118827);let n=s.css`
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
`;var l=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let c=class extends t.LitElement{constructor(){super(...arguments),this.variant="main",this.size="lg"}render(){this.dataset.variant=this.variant,this.dataset.size=this.size;let e="md"===this.size||"xs"===this.size?"mini-700":"micro-700";return i.html`
      <wui-text data-variant=${this.variant} variant=${e} color="inherit">
        <slot></slot>
      </wui-text>
    `}};c.styles=[a.resetStyles,n],l([(0,r.property)()],c.prototype,"variant",void 0),l([(0,r.property)()],c.prototype,"size",void 0),c=l([(0,o.customElement)("wui-tag")],c),e.s([],185212),e.s([],990237)},330885,e=>{"use strict";e.i(588984);var t=e.i(399702),i=e.i(872857);e.i(759703);var r=e.i(392074);e.i(630572),e.i(287940),e.i(596548);var a=e.i(864429),o=e.i(938559),s=e.i(118827);let n=s.css`
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
`;var l=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let c=class extends t.LitElement{constructor(){super(...arguments),this.variant="accent",this.imageSrc="",this.disabled=!1,this.icon="externalLink",this.size="md",this.text=""}render(){let e="sm"===this.size?"small-600":"paragraph-600";return i.html`
      <button
        class=${this.disabled?"disabled":""}
        data-variant=${this.variant}
        data-size=${this.size}
        ?disabled=${this.disabled}
      >
        ${this.imageSrc?i.html`<wui-image src=${this.imageSrc}></wui-image>`:null}
        <wui-text variant=${e} color="inherit"> ${this.text} </wui-text>
        ${this.icon?i.html`<wui-icon name=${this.icon} color="inherit" size="inherit"></wui-icon>`:null}
      </button>
    `}};c.styles=[a.resetStyles,a.elementStyles,n],l([(0,r.property)()],c.prototype,"variant",void 0),l([(0,r.property)()],c.prototype,"imageSrc",void 0),l([(0,r.property)({type:Boolean})],c.prototype,"disabled",void 0),l([(0,r.property)()],c.prototype,"icon",void 0),l([(0,r.property)()],c.prototype,"size",void 0),l([(0,r.property)()],c.prototype,"text",void 0),c=l([(0,o.customElement)("wui-chip-button")],c),e.s([],330885)},873117,e=>{"use strict";var t=e.i(138230),i=e.i(944411),r=e.i(924487);e.s(["HelpersUtil",0,{getTabsByNamespace:e=>e&&e===t.ConstantsUtil.CHAIN.EVM?i.OptionsController.state.remoteFeatures?.activity===!1?r.ConstantsUtil.ACCOUNT_TABS.filter(e=>"Activity"!==e.label):r.ConstantsUtil.ACCOUNT_TABS:[],isValidReownName:e=>/^[a-zA-Z0-9]+$/gu.test(e),validateReownName:e=>e.replace(/\^/gu,"").toLowerCase().replace(/[^a-zA-Z0-9]/gu,"")}])},510290,e=>{"use strict";e.i(588984);var t=e.i(399702),i=e.i(872857);e.i(759703);var r=e.i(392074);e.i(630572),e.i(287940),e.i(596548);var a=e.i(864429),o=e.i(34691),s=e.i(938559),n=e.i(118827);let l=n.css`
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
`;var c=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let u=class extends t.LitElement{constructor(){super(...arguments),this.variant="fill",this.imageSrc=void 0,this.imageIcon=void 0,this.imageIconSize="md",this.disabled=!1,this.icon="externalLink",this.href="",this.text=void 0}render(){let e="success"===this.variant||"transparent"===this.variant||"shadeSmall"===this.variant;return i.html`
      <a
        rel="noreferrer"
        target="_blank"
        href=${this.href}
        class=${this.disabled?"disabled":""}
        data-variant=${this.variant}
      >
        ${this.imageTemplate()}
        <wui-text variant=${e?"small-600":"paragraph-600"} color="inherit">
          ${this.title?this.title:o.UiHelperUtil.getHostName(this.href)}
        </wui-text>
        <wui-icon name=${this.icon} color="inherit" size="inherit"></wui-icon>
      </a>
    `}imageTemplate(){return this.imageSrc?i.html`<wui-image src=${this.imageSrc}></wui-image>`:this.imageIcon?i.html`<wui-icon
        name=${this.imageIcon}
        color="inherit"
        size=${this.imageIconSize}
        class="image-icon"
      ></wui-icon>`:null}};u.styles=[a.resetStyles,a.elementStyles,l],c([(0,r.property)()],u.prototype,"variant",void 0),c([(0,r.property)()],u.prototype,"imageSrc",void 0),c([(0,r.property)()],u.prototype,"imageIcon",void 0),c([(0,r.property)()],u.prototype,"imageIconSize",void 0),c([(0,r.property)({type:Boolean})],u.prototype,"disabled",void 0),c([(0,r.property)()],u.prototype,"icon",void 0),c([(0,r.property)()],u.prototype,"href",void 0),c([(0,r.property)()],u.prototype,"text",void 0),u=c([(0,s.customElement)("wui-chip")],u),e.s([],510290)},692100,e=>{"use strict";e.s(["NavigationUtil",0,{URLS:{FAQ:"https://walletconnect.com/faq"}}])},999964,e=>{"use strict";e.i(525370),e.s([])},155284,e=>{"use strict";e.s(["REOWN_URL",0,"https://reown.com","numbersRegex",0,/[0-9,.]/u,"specialCharactersRegex",0,/[.*+?^${}()|[\]\\]/gu])},156575,e=>{"use strict";e.i(588984);var t=e.i(399702),i=e.i(872857);e.i(759703);var r=e.i(392074);e.i(596548);var a=e.i(864429),o=e.i(938559),s=e.i(118827);let n=s.css`
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
`;var l=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let c=class extends t.LitElement{constructor(){super(...arguments),this.text=""}render(){return i.html`${this.template()}`}template(){return this.text?i.html`<wui-text variant="small-500" color="fg-200">${this.text}</wui-text>`:null}};c.styles=[a.resetStyles,n],l([(0,r.property)()],c.prototype,"text",void 0),c=l([(0,o.customElement)("wui-separator")],c),e.s([],156575)},370507,e=>{"use strict";e.i(588984);var t=e.i(399702),i=e.i(872857);e.i(759703);var r=e.i(392074);e.i(287940);var a=e.i(864429),o=e.i(34691),s=e.i(938559),n=e.i(118827);let l=n.css`
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
`;var c=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let u=class extends t.LitElement{constructor(){super(...arguments),this.imageSrc=void 0,this.alt=void 0,this.address=void 0,this.size="xl"}render(){return this.style.cssText=`
    --local-width: var(--wui-icon-box-size-${this.size});
    --local-height: var(--wui-icon-box-size-${this.size});
    `,i.html`${this.visualTemplate()}`}visualTemplate(){if(this.imageSrc)return this.dataset.variant="image",i.html`<wui-image src=${this.imageSrc} alt=${this.alt??"avatar"}></wui-image>`;if(this.address){this.dataset.variant="generated";let e=o.UiHelperUtil.generateAvatarColors(this.address);return this.style.cssText+=`
 ${e}`,null}return this.dataset.variant="default",null}};u.styles=[a.resetStyles,l],c([(0,r.property)()],u.prototype,"imageSrc",void 0),c([(0,r.property)()],u.prototype,"alt",void 0),c([(0,r.property)()],u.prototype,"address",void 0),c([(0,r.property)()],u.prototype,"size",void 0),u=c([(0,s.customElement)("wui-avatar")],u),e.s([],370507)},696794,e=>{"use strict";e.i(588984);var t=e.i(399702),i=e.i(872857);e.i(759703);var r=e.i(392074),a=e.i(437059);e.i(630572),e.i(287940),e.i(596548),e.i(108476);var o=e.i(864429),s=e.i(938559),n=e.i(118827);let l=n.css`
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
`;var c=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let u=class extends t.LitElement{constructor(){super(...arguments),this.tokenName="",this.tokenImageUrl="",this.tokenValue=0,this.tokenAmount="0.0",this.tokenCurrency="",this.clickable=!1}render(){return i.html`
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
    `}visualTemplate(){return this.tokenName&&this.tokenImageUrl?i.html`<wui-image alt=${this.tokenName} src=${this.tokenImageUrl}></wui-image>`:i.html`<wui-icon name="coinPlaceholder" color="fg-100"></wui-icon>`}};u.styles=[o.resetStyles,o.elementStyles,l],c([(0,r.property)()],u.prototype,"tokenName",void 0),c([(0,r.property)()],u.prototype,"tokenImageUrl",void 0),c([(0,r.property)({type:Number})],u.prototype,"tokenValue",void 0),c([(0,r.property)()],u.prototype,"tokenAmount",void 0),c([(0,r.property)()],u.prototype,"tokenCurrency",void 0),c([(0,r.property)({type:Boolean})],u.prototype,"clickable",void 0),u=c([(0,s.customElement)("wui-list-token")],u),e.s([],696794)},274071,e=>{"use strict";e.i(588984);var t=e.i(399702),i=e.i(872857);e.i(759703);var r=e.i(392074);e.i(630572);var a=e.i(864429),o=e.i(938559),s=e.i(118827);let n=s.css`
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
`;var l=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let c=class extends t.LitElement{constructor(){super(...arguments),this.text="",this.icon="card"}render(){return i.html`<button>
      <wui-icon color="accent-100" name=${this.icon} size="lg"></wui-icon>
    </button>`}};c.styles=[a.resetStyles,a.elementStyles,n],l([(0,r.property)()],c.prototype,"text",void 0),l([(0,r.property)()],c.prototype,"icon",void 0),c=l([(0,o.customElement)("wui-icon-button")],c),e.s([],274071)},662541,e=>{"use strict";e.i(588984);var t=e.i(399702),i=e.i(872857);e.i(759703);var r=e.i(392074);e.i(630572),e.i(287940),e.i(108476);var a=e.i(864429),o=e.i(938559);e.i(839432);var s=e.i(118827);let n=s.css`
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
`;var l=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let c=class extends t.LitElement{constructor(){super(...arguments),this.size="md",this.name="",this.installed=!1,this.badgeSize="xs"}render(){let e="xxs";return e="lg"===this.size?"m":"md"===this.size?"xs":"xxs",this.style.cssText=`
       --local-border-radius: var(--wui-border-radius-${e});
       --local-size: var(--wui-wallet-image-size-${this.size});
   `,this.walletIcon&&(this.dataset.walletIcon=this.walletIcon),i.html`
      <wui-flex justifyContent="center" alignItems="center"> ${this.templateVisual()} </wui-flex>
    `}templateVisual(){return this.imageSrc?i.html`<wui-image src=${this.imageSrc} alt=${this.name}></wui-image>`:this.walletIcon?i.html`<wui-icon
        data-parent-size="md"
        size="md"
        color="inherit"
        name=${this.walletIcon}
      ></wui-icon>`:i.html`<wui-icon
      data-parent-size=${this.size}
      size="inherit"
      color="inherit"
      name="walletPlaceholder"
    ></wui-icon>`}};c.styles=[a.elementStyles,a.resetStyles,n],l([(0,r.property)()],c.prototype,"size",void 0),l([(0,r.property)()],c.prototype,"name",void 0),l([(0,r.property)()],c.prototype,"imageSrc",void 0),l([(0,r.property)()],c.prototype,"walletIcon",void 0),l([(0,r.property)({type:Boolean})],c.prototype,"installed",void 0),l([(0,r.property)()],c.prototype,"badgeSize",void 0),c=l([(0,o.customElement)("wui-wallet-image")],c),e.s([],662541)},493416,e=>{"use strict";e.i(588984);var t=e.i(872857);let i=t.svg`<svg  viewBox="0 0 48 54" fill="none">
  <path
    d="M43.4605 10.7248L28.0485 1.61089C25.5438 0.129705 22.4562 0.129705 19.9515 1.61088L4.53951 10.7248C2.03626 12.2051 0.5 14.9365 0.5 17.886V36.1139C0.5 39.0635 2.03626 41.7949 4.53951 43.2752L19.9515 52.3891C22.4562 53.8703 25.5438 53.8703 28.0485 52.3891L43.4605 43.2752C45.9637 41.7949 47.5 39.0635 47.5 36.114V17.8861C47.5 14.9365 45.9637 12.2051 43.4605 10.7248Z"
  />
</svg>`;e.s(["networkSvgMd",0,i])},830976,e=>{"use strict";e.i(662541),e.s([])},152076,e=>{"use strict";e.i(588984);var t=e.i(872857);let i=t.svg`<svg width="86" height="96" fill="none">
  <path
    d="M78.3244 18.926L50.1808 2.45078C45.7376 -0.150261 40.2624 -0.150262 35.8192 2.45078L7.6756 18.926C3.23322 21.5266 0.5 26.3301 0.5 31.5248V64.4752C0.5 69.6699 3.23322 74.4734 7.6756 77.074L35.8192 93.5492C40.2624 96.1503 45.7376 96.1503 50.1808 93.5492L78.3244 77.074C82.7668 74.4734 85.5 69.6699 85.5 64.4752V31.5248C85.5 26.3301 82.7668 21.5266 78.3244 18.926Z"
  />
</svg>`;e.s(["networkSvgLg",0,i])},894687,200964,e=>{"use strict";e.i(588984);var t=e.i(399702),i=e.i(872857);e.i(759703);var r=e.i(392074),a=e.i(152076),o=e.i(493416);let s=i.svg`
  <svg fill="none" viewBox="0 0 36 40">
    <path
      d="M15.4 2.1a5.21 5.21 0 0 1 5.2 0l11.61 6.7a5.21 5.21 0 0 1 2.61 4.52v13.4c0 1.87-1 3.59-2.6 4.52l-11.61 6.7c-1.62.93-3.6.93-5.22 0l-11.6-6.7a5.21 5.21 0 0 1-2.61-4.51v-13.4c0-1.87 1-3.6 2.6-4.52L15.4 2.1Z"
    />
  </svg>
`;e.i(630572),e.i(287940);var n=e.i(864429),l=e.i(938559),c=e.i(118827);let u=c.css`
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
`;var p=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let d=class extends t.LitElement{constructor(){super(...arguments),this.size="md",this.name="uknown",this.networkImagesBySize={sm:s,md:o.networkSvgMd,lg:a.networkSvgLg},this.selected=!1,this.round=!1}render(){return this.round?(this.dataset.round="true",this.style.cssText=`
      --local-width: var(--wui-spacing-3xl);
      --local-height: var(--wui-spacing-3xl);
      --local-icon-size: var(--wui-spacing-l);
    `):this.style.cssText=`

      --local-path: var(--wui-path-network-${this.size});
      --local-width:  var(--wui-width-network-${this.size});
      --local-height:  var(--wui-height-network-${this.size});
      --local-icon-size:  var(--wui-icon-size-network-${this.size});
    `,i.html`${this.templateVisual()} ${this.svgTemplate()} `}svgTemplate(){return this.round?null:this.networkImagesBySize[this.size]}templateVisual(){return this.imageSrc?i.html`<wui-image src=${this.imageSrc} alt=${this.name}></wui-image>`:i.html`<wui-icon size="inherit" color="fg-200" name="networkPlaceholder"></wui-icon>`}};d.styles=[n.resetStyles,u],p([(0,r.property)()],d.prototype,"size",void 0),p([(0,r.property)()],d.prototype,"name",void 0),p([(0,r.property)({type:Object})],d.prototype,"networkImagesBySize",void 0),p([(0,r.property)()],d.prototype,"imageSrc",void 0),p([(0,r.property)({type:Boolean})],d.prototype,"selected",void 0),p([(0,r.property)({type:Boolean})],d.prototype,"round",void 0),d=p([(0,l.customElement)("wui-network-image")],d),e.s([],200964),e.s([],894687)},229581,675164,231971,e=>{"use strict";var t=e.i(138230),i=e.i(596590),r=e.i(207176),a=e.i(729702),o=e.i(881936),s=e.i(375054),n=e.i(944396),l=e.i(301847),c=e.i(148018);async function u(){s.RouterController.push("ConnectingFarcaster");let e=a.ConnectorController.getAuthConnector();if(e&&!i.AccountController.state.farcasterUrl)try{let{url:t}=await e.provider.getFarcasterUri();i.AccountController.setFarcasterUrl(t,r.ChainController.state.activeChain)}catch(e){s.RouterController.goBack(),n.SnackController.showError(e)}}async function p(e){s.RouterController.push("ConnectingSocial");let o=a.ConnectorController.getAuthConnector(),u=null;try{let a=setTimeout(()=>{throw Error("Social login timed out. Please try again.")},45e3);if(o&&e){if(l.CoreHelperUtil.isTelegram()||(u=function(){try{return l.CoreHelperUtil.returnOpenHref(`${t.ConstantsUtil.SECURE_SITE_SDK_ORIGIN}/loading`,"popupWindow","width=600,height=800,scrollbars=yes")}catch(e){throw Error("Could not open social popup")}}()),u)i.AccountController.setSocialWindow(u,r.ChainController.state.activeChain);else if(!l.CoreHelperUtil.isTelegram())throw Error("Could not create social popup");let{uri:s}=await o.provider.getSocialRedirectUri({provider:e});if(!s)throw u?.close(),Error("Could not fetch the social redirect uri");if(u&&(u.location.href=s),l.CoreHelperUtil.isTelegram()){c.StorageUtil.setTelegramSocialProvider(e);let t=l.CoreHelperUtil.formatTelegramSocialLoginUrl(s);l.CoreHelperUtil.openHref(t,"_top")}clearTimeout(a)}}catch(e){u?.close(),n.SnackController.showError(e?.message)}}async function d(e){i.AccountController.setSocialProvider(e,r.ChainController.state.activeChain),o.EventsController.sendEvent({type:"track",event:"SOCIAL_LOGIN_STARTED",properties:{provider:e}}),"farcaster"===e?await u():await p(e)}e.s(["executeSocialLogin",()=>d],229581),e.i(588984);var h=e.i(399702),w=e.i(872857);e.i(759703);var v=e.i(392074);e.i(781840);var g=e.i(86988);e.i(596548);var m=e.i(864429),y=e.i(938559),f=h;e.i(630572);var b=e.i(118827);let x=b.css`
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
`;var k=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let C=class extends f.LitElement{constructor(){super(...arguments),this.logo="google"}render(){return w.html`<wui-icon color="inherit" size="inherit" name=${this.logo}></wui-icon> `}};C.styles=[m.resetStyles,x],k([(0,v.property)()],C.prototype,"logo",void 0),C=k([(0,y.customElement)("wui-logo")],C),e.s([],675164);let $=b.css`
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
`;var R=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let S=class extends h.LitElement{constructor(){super(...arguments),this.logo="google",this.name="Continue with google",this.align="left",this.disabled=!1}render(){return w.html`
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
    `}templatePlacement(){return"center"===this.align?w.html` <wui-logo class="invisible" logo=${this.logo}></wui-logo>`:null}};S.styles=[m.resetStyles,m.elementStyles,$],R([(0,v.property)()],S.prototype,"logo",void 0),R([(0,v.property)()],S.prototype,"name",void 0),R([(0,v.property)()],S.prototype,"align",void 0),R([(0,v.property)()],S.prototype,"tabIdx",void 0),R([(0,v.property)({type:Boolean})],S.prototype,"disabled",void 0),S=R([(0,y.customElement)("wui-list-social")],S),e.s([],231971)},143880,e=>{"use strict";e.i(588984);var t=e.i(399702),i=e.i(872857);e.i(759703);var r=e.i(392074);e.i(630572),e.i(287940);var a=e.i(520209);function o(e,t,i){return e!==t&&(e-t<0?t-e:e-t)<=i+.1}let s={generate({uri:e,size:t,logoSize:r,dotColor:s="#141414"}){let n,l,c=[],u=(l=Math.sqrt((n=Array.prototype.slice.call(a.default.create(e,{errorCorrectionLevel:"Q"}).modules.data,0)).length),n.reduce((e,t,i)=>(i%l==0?e.push([t]):e[e.length-1].push(t))&&e,[])),p=t/u.length,d=[{x:0,y:0},{x:1,y:0},{x:0,y:1}];d.forEach(({x:e,y:t})=>{let r=(u.length-7)*p*e,a=(u.length-7)*p*t;for(let e=0;e<d.length;e+=1){let t=p*(7-2*e);c.push(i.svg`
            <rect
              fill=${2===e?s:"transparent"}
              width=${0===e?t-5:t}
              rx= ${0===e?(t-5)*.45:.45*t}
              ry= ${0===e?(t-5)*.45:.45*t}
              stroke=${s}
              stroke-width=${5*(0===e)}
              height=${0===e?t-5:t}
              x= ${0===e?a+p*e+2.5:a+p*e}
              y= ${0===e?r+p*e+2.5:r+p*e}
            />
          `)}});let h=Math.floor((r+25)/p),w=u.length/2-h/2,v=u.length/2+h/2-1,g=[];u.forEach((e,t)=>{e.forEach((e,i)=>{!u[t][i]||t<7&&i<7||t>u.length-8&&i<7||t<7&&i>u.length-8||t>w&&t<v&&i>w&&i<v||g.push([t*p+p/2,i*p+p/2])})});let m={};return g.forEach(([e,t])=>{m[e]?m[e]?.push(t):m[e]=[t]}),Object.entries(m).map(([e,t])=>{let i=t.filter(e=>t.every(t=>!o(e,t,p)));return[Number(e),i]}).forEach(([e,t])=>{t.forEach(t=>{c.push(i.svg`<circle cx=${e} cy=${t} fill=${s} r=${p/2.5} />`)})}),Object.entries(m).filter(([e,t])=>t.length>1).map(([e,t])=>{let i=t.filter(e=>t.some(t=>o(e,t,p)));return[Number(e),i]}).map(([e,t])=>{t.sort((e,t)=>e<t?-1:1);let i=[];for(let e of t){let t=i.find(t=>t.some(t=>o(e,t,p)));t?t.push(e):i.push([e])}return[e,i.map(e=>[e[0],e[e.length-1]])]}).forEach(([e,t])=>{t.forEach(([t,r])=>{c.push(i.svg`
              <line
                x1=${e}
                x2=${e}
                y1=${t}
                y2=${r}
                stroke=${s}
                stroke-width=${p/1.25}
                stroke-linecap="round"
              />
            `)})}),c}};var n=e.i(864429),l=e.i(938559),c=e.i(118827);let u=c.css`
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
`;var p=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let d=class extends t.LitElement{constructor(){super(...arguments),this.uri="",this.size=0,this.theme="dark",this.imageSrc=void 0,this.alt=void 0,this.arenaClear=void 0,this.farcaster=void 0}render(){return this.dataset.theme=this.theme,this.dataset.clear=String(this.arenaClear),this.style.cssText=`
     --local-size: ${this.size}px;
     --local-icon-color: ${this.color??"#3396ff"}
    `,i.html`${this.templateVisual()} ${this.templateSvg()}`}templateSvg(){let e="light"===this.theme?this.size:this.size-32;return i.svg`
      <svg height=${e} width=${e}>
        ${s.generate({uri:this.uri,size:e,logoSize:this.arenaClear?0:e/4,dotColor:this.color})}
      </svg>
    `}templateVisual(){return this.imageSrc?i.html`<wui-image src=${this.imageSrc} alt=${this.alt??"logo"}></wui-image>`:this.farcaster?i.html`<wui-icon
        class="farcaster"
        size="inherit"
        color="inherit"
        name="farcaster"
      ></wui-icon>`:i.html`<wui-icon size="inherit" color="inherit" name="walletConnect"></wui-icon>`}};d.styles=[n.resetStyles,u],p([(0,r.property)()],d.prototype,"uri",void 0),p([(0,r.property)({type:Number})],d.prototype,"size",void 0),p([(0,r.property)()],d.prototype,"theme",void 0),p([(0,r.property)()],d.prototype,"imageSrc",void 0),p([(0,r.property)()],d.prototype,"alt",void 0),p([(0,r.property)()],d.prototype,"color",void 0),p([(0,r.property)({type:Boolean})],d.prototype,"arenaClear",void 0),p([(0,r.property)({type:Boolean})],d.prototype,"farcaster",void 0),d=p([(0,l.customElement)("wui-qr-code")],d),e.s([],143880)},843028,451801,933370,176375,e=>{"use strict";var t=e.i(725519),i=e.i(941031);let r=(0,t.proxy)({isLegalCheckboxChecked:!1}),a={state:r,subscribe:e=>(0,t.subscribe)(r,()=>e(r)),subscribeKey:(e,t)=>(0,i.subscribeKey)(r,e,t),setIsLegalCheckboxChecked(e){r.isLegalCheckboxChecked=e}};e.s(["OptionsStateController",0,a],843028),e.i(588984);var o=e.i(399702),s=e.i(872857);e.i(759703);var n=e.i(698797),l=e.i(944411);e.i(302184);var c=e.i(938559),u=o,p=e.i(392074);e.i(781840);var d=e.i(86988);e.i(812492);var h=e.i(568633);e.i(630572);var w=e.i(864429),v=e.i(118827);let g=v.css`
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
`;var m=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let y=class extends u.LitElement{constructor(){super(...arguments),this.inputElementRef=(0,h.createRef)(),this.checked=void 0}render(){return s.html`
      <label>
        <input
          ${(0,h.ref)(this.inputElementRef)}
          ?checked=${(0,d.ifDefined)(this.checked)}
          type="checkbox"
          @change=${this.dispatchChangeEvent}
        />
        <span>
          <wui-icon name="checkmarkBold" color="inverse-100" size="xxs"></wui-icon>
        </span>
        <slot></slot>
      </label>
    `}dispatchChangeEvent(){this.dispatchEvent(new CustomEvent("checkboxChange",{detail:this.inputElementRef.value?.checked,bubbles:!0,composed:!0}))}};y.styles=[w.resetStyles,g],m([(0,p.property)({type:Boolean})],y.prototype,"checked",void 0),y=m([(0,c.customElement)("wui-checkbox")],y),e.i(331658);let f=v.css`
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
`;var b=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let x=class extends o.LitElement{constructor(){super(),this.unsubscribe=[],this.checked=a.state.isLegalCheckboxChecked,this.unsubscribe.push(a.subscribeKey("isLegalCheckboxChecked",e=>{this.checked=e}))}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}render(){let{termsConditionsUrl:e,privacyPolicyUrl:t}=l.OptionsController.state,i=l.OptionsController.state.features?.legalCheckbox;return(e||t)&&i?s.html`
      <wui-checkbox
        ?checked=${this.checked}
        @checkboxChange=${this.onCheckboxChange.bind(this)}
        data-testid="wui-checkbox"
      >
        <wui-text color="fg-250" variant="small-400" align="left">
          I agree to our ${this.termsTemplate()} ${this.andTemplate()} ${this.privacyTemplate()}
        </wui-text>
      </wui-checkbox>
    `:null}andTemplate(){let{termsConditionsUrl:e,privacyPolicyUrl:t}=l.OptionsController.state;return e&&t?"and":""}termsTemplate(){let{termsConditionsUrl:e}=l.OptionsController.state;return e?s.html`<a rel="noreferrer" target="_blank" href=${e}>terms of service</a>`:null}privacyTemplate(){let{privacyPolicyUrl:e}=l.OptionsController.state;return e?s.html`<a rel="noreferrer" target="_blank" href=${e}>privacy policy</a>`:null}onCheckboxChange(){a.setIsLegalCheckboxChecked(!this.checked)}};x.styles=[f],b([(0,n.state)()],x.prototype,"checked",void 0),x=b([(0,c.customElement)("w3m-legal-checkbox")],x),e.s([],451801);var k=o;e.i(237029);var C=o;e.i(596548),e.i(108476);var $=e.i(155284);let R=v.css`
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
`,S=class extends C.LitElement{render(){return s.html`
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
    `}};S.styles=[w.resetStyles,w.elementStyles,R],S=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s}([(0,c.customElement)("wui-ux-by-reown")],S),e.s([],933370);let O=v.css`
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
`;var T=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let z=class extends k.LitElement{constructor(){super(),this.unsubscribe=[],this.remoteFeatures=l.OptionsController.state.remoteFeatures,this.unsubscribe.push(l.OptionsController.subscribeKey("remoteFeatures",e=>this.remoteFeatures=e))}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}render(){let{termsConditionsUrl:e,privacyPolicyUrl:t}=l.OptionsController.state,i=l.OptionsController.state.features?.legalCheckbox;return(e||t)&&!i?s.html`
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
      `}andTemplate(){let{termsConditionsUrl:e,privacyPolicyUrl:t}=l.OptionsController.state;return e&&t?"and":""}termsTemplate(){let{termsConditionsUrl:e}=l.OptionsController.state;return e?s.html`<a href=${e} target="_blank" rel="noopener noreferrer"
      >Terms of Service</a
    >`:null}privacyTemplate(){let{privacyPolicyUrl:e}=l.OptionsController.state;return e?s.html`<a href=${e} target="_blank" rel="noopener noreferrer"
      >Privacy Policy</a
    >`:null}reownBrandingTemplate(e=!1){return this.remoteFeatures?.reownBranding?e?s.html`<wui-ux-by-reown class="branding-only"></wui-ux-by-reown>`:s.html`<wui-ux-by-reown></wui-ux-by-reown>`:null}};z.styles=[O],T([(0,n.state)()],z.prototype,"remoteFeatures",void 0),z=T([(0,c.customElement)("w3m-legal-footer")],z),e.s([],176375)},180594,e=>{"use strict";e.i(588984);var t=e.i(399702),i=e.i(872857);e.i(759703);var r=e.i(392074);e.i(781840);var a=e.i(86988);e.i(596548);var o=e.i(864429),s=e.i(938559);e.i(525370);var n=e.i(118827);let l=n.css`
  :host {
    position: relative;
    display: inline-block;
  }

  wui-text {
    margin: var(--wui-spacing-xxs) var(--wui-spacing-m) var(--wui-spacing-0) var(--wui-spacing-m);
  }
`;var c=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let u=class extends t.LitElement{constructor(){super(...arguments),this.disabled=!1}render(){return i.html`
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
    `}templateError(){return this.errorMessage?i.html`<wui-text variant="tiny-500" color="error-100">${this.errorMessage}</wui-text>`:null}};u.styles=[o.resetStyles,l],c([(0,r.property)()],u.prototype,"errorMessage",void 0),c([(0,r.property)({type:Boolean})],u.prototype,"disabled",void 0),c([(0,r.property)()],u.prototype,"value",void 0),c([(0,r.property)()],u.prototype,"tabIdx",void 0),u=c([(0,s.customElement)("wui-email-input")],u),e.s([],180594)},211366,e=>{"use strict";e.i(846880),e.s([])},908961,e=>{"use strict";e.i(588984);var t=e.i(399702),i=e.i(872857);e.i(759703);var r=e.i(392074),a=e.i(698797),o=e.i(945182),s=e.i(375054),n=e.i(420435);e.i(302184);var l=e.i(938559),c=e.i(118827);let u=c.css`
  :host {
    width: 100%;
    display: block;
  }
`;var p=function(e,t,i,r){var a,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var n=e.length-1;n>=0;n--)(a=e[n])&&(s=(o<3?a(s):o>3?a(t,i,s):a(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s};let d=class extends t.LitElement{constructor(){super(),this.unsubscribe=[],this.text="",this.open=n.TooltipController.state.open,this.unsubscribe.push(s.RouterController.subscribeKey("view",()=>{n.TooltipController.hide()}),o.ModalController.subscribeKey("open",e=>{e||n.TooltipController.hide()}),n.TooltipController.subscribeKey("open",e=>{this.open=e}))}disconnectedCallback(){this.unsubscribe.forEach(e=>e()),n.TooltipController.hide()}render(){return i.html`
      <div
        @pointermove=${this.onMouseEnter.bind(this)}
        @pointerleave=${this.onMouseLeave.bind(this)}
      >
        ${this.renderChildren()}
      </div>
    `}renderChildren(){return i.html`<slot></slot> `}onMouseEnter(){let e=this.getBoundingClientRect();this.open||n.TooltipController.showTooltip({message:this.text,triggerRect:{width:e.width,height:e.height,left:e.left,top:e.top},variant:"shade"})}onMouseLeave(e){this.contains(e.relatedTarget)||n.TooltipController.hide()}};d.styles=[u],p([(0,r.property)()],d.prototype,"text",void 0),p([(0,a.state)()],d.prototype,"open",void 0),d=p([(0,l.customElement)("w3m-tooltip-trigger")],d),e.s([],908961)}]);