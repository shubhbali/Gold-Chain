(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,476604,e=>{"use strict";e.i(287940),e.s([])},869624,e=>{"use strict";e.i(588984);var t=e.i(399702),n=e.i(872857);e.i(759703);var r=e.i(698797),a=e.i(589408),s=e.i(207176),i=e.i(725519),o=e.i(941031),c=e.i(355376),u=e.i(301847),l=e.i(222328),m=e.i(944411);let p={eip155:{native:{assetNamespace:"slip44",assetReference:"60"},defaultTokenNamespace:"erc20"},solana:{native:{assetNamespace:"slip44",assetReference:"501"},defaultTokenNamespace:"token"}};class h extends Error{}async function d(e,t){let n,r=(n=m.OptionsController.getSnapshot().projectId,`https://rpc.walletconnect.org/v1/json-rpc?projectId=${n}&source=fund-wallet`),{sdkType:a,sdkVersion:s,projectId:i}=m.OptionsController.getSnapshot(),o={jsonrpc:"2.0",id:1,method:e,params:{...t||{},st:a,sv:s,projectId:i}},c=await fetch(r,{method:"POST",body:JSON.stringify(o),headers:{"Content-Type":"application/json"}}),u=await c.json();if(u.error)throw new h(u.error.message);return u}async function g(e){return(await d("reown_getExchanges",e)).result}async function y(e){return(await d("reown_getExchangePayUrl",e)).result}async function w(e){return(await d("reown_getExchangeBuyStatus",e)).result}function x(e,t){let{chainNamespace:n,chainId:r}=l.ParseUtil.parseCaipNetworkId(e),a=p[n];if(!a)throw Error(`Unsupported chain namespace for CAIP-19 formatting: ${n}`);let s=a.native.assetNamespace,i=a.native.assetReference;"native"!==t&&(s=a.defaultTokenNamespace,i=t);let o=`${n}:${r}`;return`${o}/${s}:${i}`}var f=e.i(596590),P=e.i(746),k=e.i(881936),b=e.i(944396);let I={paymentAsset:{network:"eip155:1",asset:"native",metadata:{name:"Ethereum",symbol:"ETH",decimals:0}},amount:0,tokenAmount:0,tokenPrice:null,priceLoading:!1,error:null,exchanges:[],isLoading:!1,currentPayment:void 0,isPaymentInProgress:!1,paymentId:""},v=(0,i.proxy)(I),E={state:v,subscribe:e=>(0,i.subscribe)(v,()=>e(v)),subscribeKey:(e,t)=>(0,o.subscribeKey)(v,e,t),resetState(){Object.assign(v,{...I})},async fetchTokenPrice(){v.priceLoading=!0;let e=(0,c.getActiveNetworkTokenAddress)(),t=await P.BlockchainApiController.fetchTokenPrice({addresses:[e]});v.tokenPrice=t.fungibles?.[0]?.price||null,v.priceLoading=!1},getTokenAmount(){if(!v.tokenPrice)throw Error("Cannot get token price");return Number(new Intl.NumberFormat("en-US",{minimumFractionDigits:0,maximumFractionDigits:4}).format(v.amount/v.tokenPrice))},setAmount(e){v.amount=e,v.tokenPrice&&(v.tokenAmount=this.getTokenAmount())},setPaymentAsset(e){v.paymentAsset=e},async fetchExchanges(){try{v.isLoading=!0;let e=await g({page:0,asset:x(v.paymentAsset.network,v.paymentAsset.asset),amount:v.amount.toString()});v.exchanges=e.exchanges.slice(0,2)}catch(e){throw b.SnackController.showError("Unable to get exchanges"),Error("Unable to get exchanges")}finally{v.isLoading=!1}},async getPayUrl(e,t){try{let n=Number(t.amount),r=await y({exchangeId:e,asset:x(t.network,t.asset),amount:n.toString(),recipient:`${t.network}:${t.recipient}`});return k.EventsController.sendEvent({type:"track",event:"PAY_EXCHANGE_SELECTED",properties:{exchange:{id:e},configuration:{network:t.network,asset:t.asset,recipient:t.recipient,amount:n},currentPayment:{type:"exchange",exchangeId:e},source:"fund-from-exchange",headless:!1}}),r}catch(e){if(e instanceof Error&&e.message.includes("is not supported"))throw Error("Asset not supported");throw Error(e.message)}},async handlePayWithExchange(e){try{if(!f.AccountController.state.address)throw Error("No account connected");v.isPaymentInProgress=!0,v.paymentId=crypto.randomUUID(),v.currentPayment={type:"exchange",exchangeId:e};let{network:t,asset:n}=v.paymentAsset,r={network:t,asset:n,amount:v.tokenAmount,recipient:f.AccountController.state.address},a=await this.getPayUrl(e,r);if(!a)throw Error("Unable to initiate payment");v.currentPayment.sessionId=a.sessionId,v.currentPayment.status="IN_PROGRESS",v.currentPayment.exchangeId=e,u.CoreHelperUtil.openHref(a.url,"_blank","popup=yes,width=480,height=720,noopener,noreferrer")}catch(e){v.error="Unable to initiate payment",b.SnackController.showError(v.error)}},async waitUntilComplete({exchangeId:e,sessionId:t,paymentId:n,retries:r=20}){let a=await this.getBuyStatus(e,t,n);if("SUCCESS"===a.status||"FAILED"===a.status)return a;if(0===r)throw Error("Unable to get deposit status");return await new Promise(e=>{setTimeout(e,5e3)}),this.waitUntilComplete({exchangeId:e,sessionId:t,paymentId:n,retries:r-1})},async getBuyStatus(e,t,n){try{if(!v.currentPayment)throw Error("No current payment");let r=await w({sessionId:t,exchangeId:e});return v.currentPayment.status=r.status,("SUCCESS"===r.status||"FAILED"===r.status)&&(v.currentPayment.result=r.txHash,v.isPaymentInProgress=!1,k.EventsController.sendEvent({type:"track",event:"SUCCESS"===r.status?"PAY_SUCCESS":"PAY_ERROR",properties:{source:"fund-from-exchange",paymentId:n,configuration:{network:v.paymentAsset.network,asset:v.paymentAsset.asset,recipient:f.AccountController.state.address||"",amount:v.amount},currentPayment:{type:"exchange",exchangeId:v.currentPayment?.exchangeId,sessionId:v.currentPayment?.sessionId,result:r.txHash}}})),r}catch(e){return{status:"UNKNOWN",txHash:""}}},reset(){v.currentPayment=void 0,v.isPaymentInProgress=!1,v.paymentId="",v.paymentAsset={network:"eip155:1",asset:"native",metadata:{name:"Ethereum",symbol:"ETH",decimals:0}},v.amount=0,v.tokenAmount=0,v.tokenPrice=null,v.priceLoading=!1,v.error=null,v.exchanges=[],v.isLoading=!1}};var C=e.i(375054);e.i(302184);var A=e.i(938559);e.i(81981),e.i(237029),e.i(679556),e.i(476604),e.i(162085),e.i(211366),e.i(331658);var S=e.i(118827);let $=S.css`
  .amount-input-container {
    border-radius: var(--wui-border-radius-m);
    border-top-right-radius: 0;
    border-top-left-radius: 0;
    border-bottom: 1px solid var(--wui-color-gray-glass-010);
    background-color: var(--wui-color-bg-100);
  }

  .container {
    background-color: var(--wui-color-bg-125);
  }
`;var U=function(e,t,n,r){var a,s=arguments.length,i=s<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,n):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)i=Reflect.decorate(e,t,n,r);else for(var o=e.length-1;o>=0;o--)(a=e[o])&&(i=(s<3?a(i):s>3?a(t,n,i):a(t,n))||i);return s>3&&i&&Object.defineProperty(t,n,i),i};let L=[10,50,100],T=class extends t.LitElement{constructor(){super(),this.unsubscribe=[],this.network=s.ChainController.state.activeCaipNetwork,this.exchanges=E.state.exchanges,this.isLoading=E.state.isLoading,this.amount=E.state.amount,this.tokenAmount=E.state.tokenAmount,this.priceLoading=E.state.priceLoading,this.isPaymentInProgress=E.state.isPaymentInProgress,this.currentPayment=E.state.currentPayment,this.paymentId=E.state.paymentId,this.unsubscribe.push(E.subscribe(e=>{this.exchanges=e.exchanges,this.isLoading=e.isLoading,this.amount=e.amount,this.tokenAmount=e.tokenAmount,this.priceLoading=e.priceLoading,this.paymentId=e.paymentId,this.isPaymentInProgress=e.isPaymentInProgress,this.currentPayment=e.currentPayment,e.isPaymentInProgress&&e.currentPayment?.exchangeId&&e.currentPayment?.sessionId&&e.paymentId&&this.handlePaymentInProgress()}))}disconnectedCallback(){this.unsubscribe.forEach(e=>e()),E.reset()}firstUpdated(){E.fetchExchanges(),E.fetchTokenPrice()}render(){return n.html`
      <wui-flex flexDirection="column" gap="xs" class="container">
        ${this.amountInputTemplate()} ${this.exchangesTemplate()}
      </wui-flex>
    `}exchangesTemplate(){return n.html`
      <wui-flex
        flexDirection="column"
        gap="xs"
        .padding=${["xs","s","s","s"]}
        class="exchanges-container"
      >
        ${this.exchanges.map(e=>n.html`<wui-list-item
              @click=${()=>this.onExchangeClick(e)}
              chevron
              variant="image"
              imageSrc=${e.imageUrl}
              ?loading=${this.isLoading}
              ?disabled=${!this.amount}
            >
              <wui-text variant="paragraph-500" color="fg-200">
                Deposit from ${e.name}
              </wui-text>
            </wui-list-item>`)}
      </wui-flex>
    `}amountInputTemplate(){return n.html`
      <wui-flex flexDirection="column" gap="s" .padding=${["0","s","s","s"]} class="amount-input-container">
        <wui-flex justifyContent="space-between">
          <wui-text variant="paragraph-500" color="fg-200">Asset</wui-text>
          <wui-chip-button
            data-testid="deposit-from-exchange-asset-button"
            text=${this.network?.nativeCurrency.symbol||""}
            imageSrc=${a.AssetUtil.getNetworkImage(this.network)}
            size="sm"
            variant="gray"
            icon=${null}
          ></wui-chip-button>
        </wui-flex>
        <wui-flex flexDirection="column" alignItems="center" justifyContent="center">
          <wui-flex alignItems="center" gap="4xs">
            <wui-text variant="2xl-500" color="fg-200">${this.amount}</wui-text>
            <wui-text variant="paragraph-500" color="fg-200">USD</wui-text>
          </wui-flex>
          ${this.tokenAmountTemplate()}
          </wui-flex>
          <wui-flex justifyContent="space-between" gap="xs">
            ${L.map(e=>n.html`<wui-button @click=${()=>this.onPresetAmountClick(e)} variant=${this.amount===e?"accent":"shade"} size="sm" fullWidth>$${e}</wui-button>`)}
          </wui-flex>
        </wui-flex>
      </wui-flex>
    `}tokenAmountTemplate(){return this.priceLoading?n.html`<wui-shimmer
        width="65px"
        height="20px"
        borderRadius="xxs"
        variant="light"
      ></wui-shimmer>`:n.html`
      <wui-text variant="paragraph-500" color="fg-200">
        ${this.tokenAmount} ${this.network?.nativeCurrency.symbol}
      </wui-text>
    `}async onExchangeClick(e){this.amount&&await E.handlePayWithExchange(e.id)}handlePaymentInProgress(){this.isPaymentInProgress&&this.currentPayment?.exchangeId&&this.currentPayment?.sessionId&&this.paymentId&&(b.SnackController.showLoading("Deposit in progress..."),C.RouterController.replace("Account"),E.waitUntilComplete({exchangeId:this.currentPayment.exchangeId,sessionId:this.currentPayment.sessionId,paymentId:this.paymentId}).then(e=>{"SUCCESS"===e.status?b.SnackController.showSuccess("Deposit completed"):"FAILED"===e.status&&b.SnackController.showError("Deposit failed")}))}onPresetAmountClick(e){E.setAmount(e)}};T.styles=$,U([(0,r.state)()],T.prototype,"network",void 0),U([(0,r.state)()],T.prototype,"exchanges",void 0),U([(0,r.state)()],T.prototype,"isLoading",void 0),U([(0,r.state)()],T.prototype,"amount",void 0),U([(0,r.state)()],T.prototype,"tokenAmount",void 0),U([(0,r.state)()],T.prototype,"priceLoading",void 0),U([(0,r.state)()],T.prototype,"isPaymentInProgress",void 0),U([(0,r.state)()],T.prototype,"currentPayment",void 0),U([(0,r.state)()],T.prototype,"paymentId",void 0),T=U([(0,A.customElement)("w3m-deposit-from-exchange-view")],T),e.s(["W3mDepositFromExchangeView",()=>T],374064),e.s([],30257),e.i(30257),e.i(374064),e.s(["W3mDepositFromExchangeView",()=>T],869624)}]);