(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,476604,e=>{"use strict";e.i(287940),e.s([])},322703,e=>{"use strict";e.i(588984);var t=e.i(399702),n=e.i(872857);e.i(759703);var a=e.i(698797);e.i(781840);var r=e.i(86988),s=e.i(596590),i=e.i(207176),o=e.i(11961),c=e.i(301847),l=e.i(945182),u=e.i(944396);e.i(302184);var m=e.i(938559);e.i(81981),e.i(237029),e.i(982221),e.i(274071),e.i(679556),e.i(476604),e.i(162085),e.i(609247),e.i(894687),e.i(156575),e.i(331658),e.i(830976);var d=e.i(725519),p=e.i(941031),h=e.i(138230),y=e.i(222328),w=e.i(881936),g=e.i(375054),f=e.i(859192);let C="INVALID_PAYMENT_CONFIG",P="INVALID_RECIPIENT",x="INVALID_ASSET",S="INVALID_AMOUNT",b="UNABLE_TO_INITIATE_PAYMENT",E="INVALID_CHAIN_NAMESPACE",I="GENERIC_PAYMENT_ERROR",v="UNABLE_TO_GET_EXCHANGES",A="ASSET_NOT_SUPPORTED",U="UNABLE_TO_GET_PAY_URL",N="UNABLE_TO_GET_BUY_STATUS",k={[C]:"Invalid payment configuration",[P]:"Invalid recipient address",[x]:"Invalid asset specified",[S]:"Invalid payment amount",UNKNOWN_ERROR:"Unknown payment error occurred",[b]:"Unable to initiate payment",[E]:"Invalid chain namespace",[I]:"Unable to process payment",[v]:"Unable to get exchanges",[A]:"Asset not supported by the selected exchange",[U]:"Unable to get payment URL",[N]:"Unable to get buy status"};class T extends Error{get message(){return k[this.code]}constructor(e,t){super(k[e]),this.name="AppKitPayError",this.code=e,this.details=t,Error.captureStackTrace&&Error.captureStackTrace(this,T)}}var D=e.i(944411);class R extends Error{}async function _(e,t){let n,a=(n=D.OptionsController.getSnapshot().projectId,`https://rpc.walletconnect.org/v1/json-rpc?projectId=${n}`),{sdkType:r,sdkVersion:s,projectId:i}=D.OptionsController.getSnapshot(),o={jsonrpc:"2.0",id:1,method:e,params:{...t||{},st:r,sv:s,projectId:i}},c=await fetch(a,{method:"POST",body:JSON.stringify(o),headers:{"Content-Type":"application/json"}}),l=await c.json();if(l.error)throw new R(l.error.message);return l}async function O(e){return(await _("reown_getExchanges",e)).result}async function L(e){return(await _("reown_getExchangePayUrl",e)).result}async function $(e){return(await _("reown_getExchangeBuyStatus",e)).result}let M=["eip155","solana"],W={eip155:{native:{assetNamespace:"slip44",assetReference:"60"},defaultTokenNamespace:"erc20"},solana:{native:{assetNamespace:"slip44",assetReference:"501"},defaultTokenNamespace:"token"}};function H(e,t){let{chainNamespace:n,chainId:a}=y.ParseUtil.parseCaipNetworkId(e),r=W[n];if(!r)throw Error(`Unsupported chain namespace for CAIP-19 formatting: ${n}`);let s=r.native.assetNamespace,i=r.native.assetReference;"native"!==t&&(s=r.defaultTokenNamespace,i=t);let o=`${n}:${a}`;return`${o}/${s}:${i}`}var F=e.i(279327);async function Y(e){let{paymentAssetNetwork:t,activeCaipNetwork:n,approvedCaipNetworkIds:a,requestedCaipNetworks:r}=e,s=c.CoreHelperUtil.sortRequestedNetworks(a,r).find(e=>e.caipNetworkId===t);if(!s)throw new T(C);if(s.caipNetworkId===n.caipNetworkId)return;let o=i.ChainController.getNetworkProp("supportsAllNetworks",s.chainNamespace);if(!(a?.includes(s.caipNetworkId)||o))throw new T(C);try{await i.ChainController.switchActiveNetwork(s)}catch(e){throw new T(I,e)}}async function K(e,t,n){if(t!==h.ConstantsUtil.CHAIN.EVM)throw new T(E);if(!n.fromAddress)throw new T(C,"fromAddress is required for native EVM payments.");let a="string"==typeof n.amount?parseFloat(n.amount):n.amount;if(isNaN(a))throw new T(C);let r=e.metadata?.decimals??18,s=o.ConnectionController.parseUnits(a.toString(),r);if("bigint"!=typeof s)throw new T(I);return await o.ConnectionController.sendTransaction({chainNamespace:t,to:n.recipient,address:n.fromAddress,value:s,data:"0x"})??void 0}async function V(e,t){if(!t.fromAddress)throw new T(C,"fromAddress is required for ERC20 EVM payments.");let n=e.asset,a=t.recipient,r=Number(e.metadata.decimals),s=o.ConnectionController.parseUnits(t.amount.toString(),r);if(void 0===s)throw new T(I);return await o.ConnectionController.writeContract({fromAddress:t.fromAddress,tokenAddress:n,args:[a,s],method:"transfer",abi:F.ContractUtil.getERC20Abi(n),chainNamespace:h.ConstantsUtil.CHAIN.EVM})??void 0}async function B(e,t){if(e!==h.ConstantsUtil.CHAIN.SOLANA)throw new T(E);if(!t.fromAddress)throw new T(C,"fromAddress is required for Solana payments.");let n="string"==typeof t.amount?parseFloat(t.amount):t.amount;if(isNaN(n)||n<=0)throw new T(C,"Invalid payment amount.");try{if(!f.ProviderUtil.getProvider(e))throw new T(I,"No Solana provider available.");let a=await o.ConnectionController.sendTransaction({chainNamespace:h.ConstantsUtil.CHAIN.SOLANA,to:t.recipient,value:n,tokenMint:t.tokenMint});if(!a)throw new T(I,"Transaction failed.");return a}catch(e){if(e instanceof T)throw e;throw new T(I,`Solana payment failed: ${e}`)}}let G="unknown",j=(0,d.proxy)({paymentAsset:{network:"eip155:1",asset:"0x0",metadata:{name:"0x0",symbol:"0x0",decimals:0}},recipient:"0x0",amount:0,isConfigured:!1,error:null,isPaymentInProgress:!1,exchanges:[],isLoading:!1,openInNewTab:!0,redirectUrl:void 0,payWithExchange:void 0,currentPayment:void 0,analyticsSet:!1,paymentId:void 0}),z={state:j,subscribe:e=>(0,d.subscribe)(j,()=>e(j)),subscribeKey:(e,t)=>(0,p.subscribeKey)(j,e,t),async handleOpenPay(e){this.resetState(),this.setPaymentConfig(e),this.subscribeEvents(),this.initializeAnalytics(),j.isConfigured=!0,w.EventsController.sendEvent({type:"track",event:"PAY_MODAL_OPEN",properties:{exchanges:j.exchanges,configuration:{network:j.paymentAsset.network,asset:j.paymentAsset.asset,recipient:j.recipient,amount:j.amount}}}),await l.ModalController.open({view:"Pay"})},resetState(){j.paymentAsset={network:"eip155:1",asset:"0x0",metadata:{name:"0x0",symbol:"0x0",decimals:0}},j.recipient="0x0",j.amount=0,j.isConfigured=!1,j.error=null,j.isPaymentInProgress=!1,j.isLoading=!1,j.currentPayment=void 0},setPaymentConfig(e){if(!e.paymentAsset)throw new T(C);try{j.paymentAsset=e.paymentAsset,j.recipient=e.recipient,j.amount=e.amount,j.openInNewTab=e.openInNewTab??!0,j.redirectUrl=e.redirectUrl,j.payWithExchange=e.payWithExchange,j.error=null}catch(e){throw new T(C,e.message)}},getPaymentAsset:()=>j.paymentAsset,getExchanges:()=>j.exchanges,async fetchExchanges(){try{j.isLoading=!0;let e=await O({page:0,asset:H(j.paymentAsset.network,j.paymentAsset.asset),amount:j.amount.toString()});j.exchanges=e.exchanges.slice(0,2)}catch(e){throw u.SnackController.showError(k.UNABLE_TO_GET_EXCHANGES),new T(v)}finally{j.isLoading=!1}},async getAvailableExchanges(e){try{let t=e?.asset&&e?.network?H(e.network,e.asset):void 0;return await O({page:e?.page??0,asset:t,amount:e?.amount?.toString()})}catch(e){throw new T(v)}},async getPayUrl(e,t,n=!1){try{let a=Number(t.amount),r=await L({exchangeId:e,asset:H(t.network,t.asset),amount:a.toString(),recipient:`${t.network}:${t.recipient}`});return w.EventsController.sendEvent({type:"track",event:"PAY_EXCHANGE_SELECTED",properties:{source:"pay",exchange:{id:e},configuration:{network:t.network,asset:t.asset,recipient:t.recipient,amount:a},currentPayment:{type:"exchange",exchangeId:e},headless:n}}),n&&(this.initiatePayment(),w.EventsController.sendEvent({type:"track",event:"PAY_INITIATED",properties:{source:"pay",paymentId:j.paymentId||G,configuration:{network:t.network,asset:t.asset,recipient:t.recipient,amount:a},currentPayment:{type:"exchange",exchangeId:e}}})),r}catch(e){if(e instanceof Error&&e.message.includes("is not supported"))throw new T(A);throw Error(e.message)}},async openPayUrl(e,t,n=!1){try{let a=await this.getPayUrl(e.exchangeId,t,n);if(!a)throw new T(U);let r=e.openInNewTab??!0;return c.CoreHelperUtil.openHref(a.url,r?"_blank":"_self"),a}catch(e){throw e instanceof T?j.error=e.message:j.error=k.GENERIC_PAYMENT_ERROR,new T(U)}},subscribeEvents(){j.isConfigured||(o.ConnectionController.subscribeKey("connections",e=>{e.size>0&&this.handlePayment()}),s.AccountController.subscribeKey("caipAddress",e=>{let t=o.ConnectionController.hasAnyConnection(h.ConstantsUtil.CONNECTOR_ID.WALLET_CONNECT);e&&(t?setTimeout(()=>{this.handlePayment()},100):this.handlePayment())}))},async handlePayment(){j.currentPayment={type:"wallet",status:"IN_PROGRESS"};let e=s.AccountController.state.caipAddress;if(!e)return;let{chainId:t,address:n}=y.ParseUtil.parseCaipAddress(e),a=i.ChainController.state.activeChain;if(!n||!t||!a||!f.ProviderUtil.getProvider(a))return;let r=i.ChainController.state.activeCaipNetwork;if(r&&!j.isPaymentInProgress)try{this.initiatePayment();let e=i.ChainController.getAllRequestedCaipNetworks(),t=i.ChainController.getAllApprovedCaipNetworkIds();switch(await Y({paymentAssetNetwork:j.paymentAsset.network,activeCaipNetwork:r,approvedCaipNetworkIds:t,requestedCaipNetworks:e}),await l.ModalController.open({view:"PayLoading"}),a){case h.ConstantsUtil.CHAIN.EVM:"native"===j.paymentAsset.asset&&(j.currentPayment.result=await K(j.paymentAsset,a,{recipient:j.recipient,amount:j.amount,fromAddress:n})),j.paymentAsset.asset.startsWith("0x")&&(j.currentPayment.result=await V(j.paymentAsset,{recipient:j.recipient,amount:j.amount,fromAddress:n})),j.currentPayment.status="SUCCESS";break;case h.ConstantsUtil.CHAIN.SOLANA:j.currentPayment.result=await B(a,{recipient:j.recipient,amount:j.amount,fromAddress:n,tokenMint:"native"===j.paymentAsset.asset?void 0:j.paymentAsset.asset}),j.currentPayment.status="SUCCESS";break;default:throw new T(E)}}catch(e){e instanceof T?j.error=e.message:j.error=k.GENERIC_PAYMENT_ERROR,j.currentPayment.status="FAILED",u.SnackController.showError(j.error)}finally{j.isPaymentInProgress=!1}},getExchangeById:e=>j.exchanges.find(t=>t.id===e),validatePayConfig(e){let{paymentAsset:t,recipient:n,amount:a}=e;if(!t)throw new T(C);if(!n)throw new T(P);if(!t.asset)throw new T(x);if(null==a||a<=0)throw new T(S)},handlePayWithWallet(){let e=s.AccountController.state.caipAddress;if(!e)return void g.RouterController.push("Connect");let{chainId:t,address:n}=y.ParseUtil.parseCaipAddress(e),a=i.ChainController.state.activeChain;n&&t&&a?this.handlePayment():g.RouterController.push("Connect")},async handlePayWithExchange(e){try{j.currentPayment={type:"exchange",exchangeId:e};let{network:t,asset:n}=j.paymentAsset,a={network:t,asset:n,amount:j.amount,recipient:j.recipient},r=await this.getPayUrl(e,a);if(!r)throw new T(b);return j.currentPayment.sessionId=r.sessionId,j.currentPayment.status="IN_PROGRESS",j.currentPayment.exchangeId=e,this.initiatePayment(),{url:r.url,openInNewTab:j.openInNewTab}}catch(e){return e instanceof T?j.error=e.message:j.error=k.GENERIC_PAYMENT_ERROR,j.isPaymentInProgress=!1,u.SnackController.showError(j.error),null}},async getBuyStatus(e,t){try{let n=await $({sessionId:t,exchangeId:e});return("SUCCESS"===n.status||"FAILED"===n.status)&&w.EventsController.sendEvent({type:"track",event:"SUCCESS"===n.status?"PAY_SUCCESS":"PAY_ERROR",properties:{source:"pay",paymentId:j.paymentId||G,configuration:{network:j.paymentAsset.network,asset:j.paymentAsset.asset,recipient:j.recipient,amount:j.amount},currentPayment:{type:"exchange",exchangeId:j.currentPayment?.exchangeId,sessionId:j.currentPayment?.sessionId,result:n.txHash}}}),n}catch(e){throw new T(N)}},async updateBuyStatus(e,t){try{let n=await this.getBuyStatus(e,t);j.currentPayment&&(j.currentPayment.status=n.status,j.currentPayment.result=n.txHash),("SUCCESS"===n.status||"FAILED"===n.status)&&(j.isPaymentInProgress=!1)}catch(e){throw new T(N)}},initiatePayment(){j.isPaymentInProgress=!0,j.paymentId=crypto.randomUUID()},initializeAnalytics(){j.analyticsSet||(j.analyticsSet=!0,this.subscribeKey("isPaymentInProgress",e=>{if(j.currentPayment?.status&&"UNKNOWN"!==j.currentPayment.status){let e={IN_PROGRESS:"PAY_INITIATED",SUCCESS:"PAY_SUCCESS",FAILED:"PAY_ERROR"}[j.currentPayment.status];w.EventsController.sendEvent({type:"track",event:e,properties:{source:"pay",paymentId:j.paymentId||G,configuration:{network:j.paymentAsset.network,asset:j.paymentAsset.asset,recipient:j.recipient,amount:j.amount},currentPayment:{type:j.currentPayment.type,exchangeId:j.currentPayment.exchangeId,sessionId:j.currentPayment.sessionId,result:j.currentPayment.result}}})}}))}};var q=e.i(118827);let J=q.css`
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
`;var Z=function(e,t,n,a){var r,s=arguments.length,i=s<3?t:null===a?a=Object.getOwnPropertyDescriptor(t,n):a;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)i=Reflect.decorate(e,t,n,a);else for(var o=e.length-1;o>=0;o--)(r=e[o])&&(i=(s<3?r(i):s>3?r(t,n,i):r(t,n))||i);return s>3&&i&&Object.defineProperty(t,n,i),i};let X=class extends t.LitElement{constructor(){super(),this.unsubscribe=[],this.amount="",this.tokenSymbol="",this.networkName="",this.exchanges=z.state.exchanges,this.isLoading=z.state.isLoading,this.loadingExchangeId=null,this.connectedWalletInfo=s.AccountController.state.connectedWalletInfo,this.initializePaymentDetails(),this.unsubscribe.push(z.subscribeKey("exchanges",e=>this.exchanges=e)),this.unsubscribe.push(z.subscribeKey("isLoading",e=>this.isLoading=e)),this.unsubscribe.push(s.AccountController.subscribe(e=>this.connectedWalletInfo=e.connectedWalletInfo)),z.fetchExchanges()}get isWalletConnected(){return"connected"===s.AccountController.state.status}render(){return n.html`
      <wui-flex flexDirection="column">
        <wui-flex flexDirection="column" .padding=${["0","l","l","l"]} gap="s">
          ${this.renderPaymentHeader()}

          <wui-flex flexDirection="column" gap="s">
            ${this.renderPayWithWallet()} ${this.renderExchangeOptions()}
          </wui-flex>
        </wui-flex>
      </wui-flex>
    `}initializePaymentDetails(){let e=z.getPaymentAsset();this.networkName=e.network,this.tokenSymbol=e.metadata.symbol,this.amount=z.state.amount.toString()}renderPayWithWallet(){return!function(e){let{chainNamespace:t}=y.ParseUtil.parseCaipNetworkId(e);return M.includes(t)}(this.networkName)?n.html``:n.html`<wui-flex flexDirection="column" gap="s">
        ${this.isWalletConnected?this.renderConnectedView():this.renderDisconnectedView()}
      </wui-flex>
      <wui-separator text="or"></wui-separator>`}renderPaymentHeader(){let e=this.networkName;if(this.networkName){let t=i.ChainController.getAllRequestedCaipNetworks().find(e=>e.caipNetworkId===this.networkName);t&&(e=t.name)}return n.html`
      <wui-flex flexDirection="column" alignItems="center">
        <wui-flex alignItems="center" gap="xs">
          <wui-text variant="large-700" color="fg-100">${this.amount||"0.0000"}</wui-text>
          <wui-flex class="token-display" alignItems="center" gap="xxs">
            <wui-text variant="paragraph-600" color="fg-100">
              ${this.tokenSymbol||"Unknown Asset"}
            </wui-text>
            ${e?n.html`
                  <wui-text variant="small-500" color="fg-200"> on ${e} </wui-text>
                `:""}
          </wui-flex>
        </wui-flex>
      </wui-flex>
    `}renderConnectedView(){let e=this.connectedWalletInfo?.name||"connected wallet";return n.html`
      <wui-list-item
        @click=${this.onWalletPayment}
        ?chevron=${!0}
        data-testid="wallet-payment-option"
      >
        <wui-flex alignItems="center" gap="s">
          <wui-wallet-image
            size="sm"
            imageSrc=${(0,r.ifDefined)(this.connectedWalletInfo?.icon)}
            name=${(0,r.ifDefined)(this.connectedWalletInfo?.name)}
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
    `}renderDisconnectedView(){return n.html`<wui-list-item
      variant="icon"
      iconVariant="overlay"
      icon="walletPlaceholder"
      @click=${this.onWalletPayment}
      ?chevron=${!0}
      data-testid="wallet-payment-option"
    >
      <wui-text variant="paragraph-500" color="inherit">Pay from wallet</wui-text>
    </wui-list-item>`}renderExchangeOptions(){return this.isLoading?n.html`<wui-flex justifyContent="center" alignItems="center">
        <wui-spinner size="md"></wui-spinner>
      </wui-flex>`:0===this.exchanges.length?n.html`<wui-flex justifyContent="center" alignItems="center">
        <wui-text variant="paragraph-500" color="fg-100">No exchanges available</wui-text>
      </wui-flex>`:this.exchanges.map(e=>n.html`
        <wui-list-item
          @click=${()=>this.onExchangePayment(e.id)}
          data-testid="exchange-option-${e.id}"
          ?chevron=${!0}
          ?disabled=${null!==this.loadingExchangeId}
        >
          <wui-flex alignItems="center" gap="s">
            ${this.loadingExchangeId===e.id?n.html`<wui-loading-spinner color="accent-100" size="md"></wui-loading-spinner>`:n.html`<wui-wallet-image
                  size="sm"
                  imageSrc=${(0,r.ifDefined)(e.imageUrl)}
                  name=${e.name}
                ></wui-wallet-image>`}
            <wui-text flexGrow="1" variant="paragraph-500" color="inherit"
              >Pay with ${e.name} <wui-spinner size="sm" color="fg-200"></wui-spinner
            ></wui-text>
          </wui-flex>
        </wui-list-item>
      `)}onWalletPayment(){z.handlePayWithWallet()}async onExchangePayment(e){try{this.loadingExchangeId=e;let t=await z.handlePayWithExchange(e);t&&(await l.ModalController.open({view:"PayLoading"}),c.CoreHelperUtil.openHref(t.url,t.openInNewTab?"_blank":"_self"))}catch(e){console.error("Failed to pay with exchange",e),u.SnackController.showError("Failed to pay with exchange")}finally{this.loadingExchangeId=null}}async onDisconnect(e){e.stopPropagation();try{await o.ConnectionController.disconnect()}catch{console.error("Failed to disconnect"),u.SnackController.showError("Failed to disconnect")}}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}};X.styles=J,Z([(0,a.state)()],X.prototype,"amount",void 0),Z([(0,a.state)()],X.prototype,"tokenSymbol",void 0),Z([(0,a.state)()],X.prototype,"networkName",void 0),Z([(0,a.state)()],X.prototype,"exchanges",void 0),Z([(0,a.state)()],X.prototype,"isLoading",void 0),Z([(0,a.state)()],X.prototype,"loadingExchangeId",void 0),Z([(0,a.state)()],X.prototype,"connectedWalletInfo",void 0),X=Z([(0,m.customElement)("w3m-pay-view")],X),e.s(["W3mPayView",()=>X],513912);var Q=t,ee=e.i(589408),et=e.i(729702),en=e.i(880985);e.i(353612);let ea=q.css`
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
`;var er=function(e,t,n,a){var r,s=arguments.length,i=s<3?t:null===a?a=Object.getOwnPropertyDescriptor(t,n):a;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)i=Reflect.decorate(e,t,n,a);else for(var o=e.length-1;o>=0;o--)(r=e[o])&&(i=(s<3?r(i):s>3?r(t,n,i):r(t,n))||i);return s>3&&i&&Object.defineProperty(t,n,i),i};let es=class extends Q.LitElement{constructor(){super(),this.loadingMessage="",this.subMessage="",this.paymentState="in-progress",this.paymentState=z.state.isPaymentInProgress?"in-progress":"completed",this.updateMessages(),this.setupSubscription(),this.setupExchangeSubscription()}disconnectedCallback(){clearInterval(this.exchangeSubscription)}render(){return n.html`
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
    `}updateMessages(){switch(this.paymentState){case"completed":this.loadingMessage="Payment completed",this.subMessage="Your transaction has been successfully processed";break;case"error":this.loadingMessage="Payment failed",this.subMessage="There was an error processing your transaction";break;default:z.state.currentPayment?.type==="exchange"?(this.loadingMessage="Payment initiated",this.subMessage="Please complete the payment on the exchange"):(this.loadingMessage="Awaiting payment confirmation",this.subMessage="Please confirm the payment transaction in your wallet")}}getStateIcon(){switch(this.paymentState){case"completed":return this.successTemplate();case"error":return this.errorTemplate();default:return this.loaderTemplate()}}setupExchangeSubscription(){z.state.currentPayment?.type==="exchange"&&(this.exchangeSubscription=setInterval(async()=>{let e=z.state.currentPayment?.exchangeId,t=z.state.currentPayment?.sessionId;e&&t&&(await z.updateBuyStatus(e,t),z.state.currentPayment?.status==="SUCCESS"&&clearInterval(this.exchangeSubscription))},4e3))}setupSubscription(){z.subscribeKey("isPaymentInProgress",e=>{e||"in-progress"!==this.paymentState||(z.state.error||!z.state.currentPayment?.result?this.paymentState="error":this.paymentState="completed",this.updateMessages(),setTimeout(()=>{"disconnected"!==o.ConnectionController.state.status&&l.ModalController.close()},3e3))}),z.subscribeKey("error",e=>{e&&"in-progress"===this.paymentState&&(this.paymentState="error",this.updateMessages())})}loaderTemplate(){let e=en.ThemeController.state.themeVariables["--w3m-border-radius-master"],t=e?parseInt(e.replace("px",""),10):4,a=this.getPaymentIcon();return n.html`
      <wui-flex justifyContent="center" alignItems="center" style="position: relative;">
        ${a?n.html`<wui-wallet-image size="lg" imageSrc=${a}></wui-wallet-image>`:null}
        <wui-loading-thumbnail radius=${9*t}></wui-loading-thumbnail>
      </wui-flex>
    `}getPaymentIcon(){let e=z.state.currentPayment;if(e){if("exchange"===e.type){let t=e.exchangeId;if(t){let e=z.getExchangeById(t);return e?.imageUrl}}if("wallet"===e.type){let e=s.AccountController.state.connectedWalletInfo?.icon;if(e)return e;let t=i.ChainController.state.activeChain;if(!t)return;let n=et.ConnectorController.getConnectorId(t);if(!n)return;let a=et.ConnectorController.getConnectorById(n);if(!a)return;return ee.AssetUtil.getConnectorImage(a)}}}successTemplate(){return n.html`<wui-icon size="xl" color="success-100" name="checkmark"></wui-icon>`}errorTemplate(){return n.html`<wui-icon size="xl" color="error-100" name="close"></wui-icon>`}};async function ei(e){return z.handleOpenPay(e)}async function eo(e,t=3e5){if(t<=0)throw new T(C,"Timeout must be greater than 0");try{await ei(e)}catch(e){if(e instanceof T)throw e;throw new T(b,e.message)}return new Promise((e,n)=>{var a;let r=!1,s=setTimeout(()=>{r||(r=!0,o(),n(new T(I,"Payment timeout")))},t);function i(){if(r)return;let t=z.state.currentPayment,n=z.state.error,a=z.state.isPaymentInProgress;if(t?.status==="SUCCESS"){r=!0,o(),clearTimeout(s),e({success:!0,result:t.result});return}if(t?.status==="FAILED"){r=!0,o(),clearTimeout(s),e({success:!1,error:n||"Payment failed"});return}!n||a||t||(r=!0,o(),clearTimeout(s),e({success:!1,error:n}))}let o=(a=[ed("currentPayment",i),ed("error",i),ed("isPaymentInProgress",i)],()=>{a.forEach(e=>{try{e()}catch{}})});i()})}function ec(){return z.getExchanges()}function el(){return z.state.currentPayment?.result}function eu(){return z.state.error}function em(){return z.state.isPaymentInProgress}function ed(e,t){return z.subscribeKey(e,t)}es.styles=ea,er([(0,a.state)()],es.prototype,"loadingMessage",void 0),er([(0,a.state)()],es.prototype,"subMessage",void 0),er([(0,a.state)()],es.prototype,"paymentState",void 0),es=er([(0,m.customElement)("w3m-pay-loading-view")],es),e.s(["W3mPayLoadingView",()=>es],973742);let ep={network:"eip155:8453",asset:"native",metadata:{name:"Ethereum",symbol:"ETH",decimals:18}},eh={network:"eip155:8453",asset:"0x833589fcd6edb6e08f4c7c32d4f71b54bda02913",metadata:{name:"USD Coin",symbol:"USDC",decimals:6}},ey={network:"eip155:84532",asset:"native",metadata:{name:"Ethereum",symbol:"ETH",decimals:18}},ew={network:"eip155:1",asset:"0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",metadata:{name:"USD Coin",symbol:"USDC",decimals:6}},eg={network:"eip155:10",asset:"0x0b2c639c533813f4aa9d7837caf62653d097ff85",metadata:{name:"USD Coin",symbol:"USDC",decimals:6}},ef={network:"eip155:42161",asset:"0xaf88d065e77c8cC2239327C5EDb3A432268e5831",metadata:{name:"USD Coin",symbol:"USDC",decimals:6}},eC={network:"eip155:137",asset:"0x3c499c542cef5e3811e1192ce70d8cc03d5c3359",metadata:{name:"USD Coin",symbol:"USDC",decimals:6}},eP={network:"solana:5eykt4UsFv8P8NJdTREpY1vzqKqZKvdp",asset:"EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v",metadata:{name:"USD Coin",symbol:"USDC",decimals:6}},ex={network:"eip155:1",asset:"0xdAC17F958D2ee523a2206206994597C13D831ec7",metadata:{name:"Tether USD",symbol:"USDT",decimals:6}},eS={network:"eip155:10",asset:"0x94b008aA00579c1307B0EF2c499aD98a8ce58e58",metadata:{name:"Tether USD",symbol:"USDT",decimals:6}},eb={network:"eip155:42161",asset:"0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9",metadata:{name:"Tether USD",symbol:"USDT",decimals:6}},eE={network:"eip155:137",asset:"0xc2132d05d31c914a87c6611c10748aeb04b58e8f",metadata:{name:"Tether USD",symbol:"USDT",decimals:6}},eI={network:"solana:5eykt4UsFv8P8NJdTREpY1vzqKqZKvdp",asset:"Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB",metadata:{name:"Tether USD",symbol:"USDT",decimals:6}},ev={network:"solana:5eykt4UsFv8P8NJdTREpY1vzqKqZKvdp",asset:"native",metadata:{name:"Solana",symbol:"SOL",decimals:9}};e.s(["arbitrumUSDC",0,ef,"arbitrumUSDT",0,eb,"baseETH",0,ep,"baseSepoliaETH",0,ey,"baseUSDC",0,eh,"ethereumUSDC",0,ew,"ethereumUSDT",0,ex,"optimismUSDC",0,eg,"optimismUSDT",0,eS,"polygonUSDC",0,eC,"polygonUSDT",0,eE,"solanaSOL",0,ev,"solanaUSDC",0,eP,"solanaUSDT",0,eI],462977),e.s([],263992),e.i(263992),e.i(513912),e.i(973742),e.i(462977),e.s(["W3mPayLoadingView",()=>es,"W3mPayView",()=>X,"arbitrumUSDC",0,ef,"arbitrumUSDT",0,eb,"baseETH",0,ep,"baseSepoliaETH",0,ey,"baseUSDC",0,eh,"ethereumUSDC",0,ew,"ethereumUSDT",0,ex,"getExchanges",()=>ec,"getIsPaymentInProgress",()=>em,"getPayError",()=>eu,"getPayResult",()=>el,"openPay",()=>ei,"optimismUSDC",0,eg,"optimismUSDT",0,eS,"pay",()=>eo,"polygonUSDC",0,eC,"polygonUSDT",0,eE,"solanaSOL",0,ev,"solanaUSDC",0,eP,"solanaUSDT",0,eI],322703)}]);