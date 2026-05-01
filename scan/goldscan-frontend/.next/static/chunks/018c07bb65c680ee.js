(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,950955,e=>{"use strict";var t=e.i(725519),o=e.i(941031),a=e.i(437059),r=e.i(138230),i=e.i(142844),n=e.i(278678),s=e.i(355376),l=e.i(140018),c=e.i(301847),d=e.i(821738);let u={getGasPriceInEther:(e,t)=>Number(t*e)/1e18,getGasPriceInUSD(e,t,o){let r=u.getGasPriceInEther(t,o);return a.NumberUtil.bigNumber(e).times(r).toNumber()},getPriceImpact({sourceTokenAmount:e,sourceTokenPriceInUSD:t,toTokenPriceInUSD:o,toTokenAmount:r}){let i=a.NumberUtil.bigNumber(e).times(t),n=a.NumberUtil.bigNumber(r).times(o);return i.minus(n).div(i).times(100).toNumber()},getMaxSlippage(e,t){let o=a.NumberUtil.bigNumber(e).div(100);return a.NumberUtil.multiply(t,o).toNumber()},getProviderFee:(e,t=.0085)=>a.NumberUtil.bigNumber(e).times(t).toString(),isInsufficientNetworkTokenForGas:(e,t)=>!!a.NumberUtil.bigNumber(e).eq(0)||a.NumberUtil.bigNumber(a.NumberUtil.bigNumber(t||"0")).gt(e),isInsufficientSourceTokenForSwap(e,t,o){let r=o?.find(e=>e.address===t)?.quantity?.numeric;return a.NumberUtil.bigNumber(r||"0").lt(e)}};var p=e.i(869067),m=e.i(596590),h=e.i(525417),w=e.i(746),k=e.i(207176),g=e.i(11961),b=e.i(729702),f=e.i(881936),v=e.i(375054),C=e.i(944396);let y={initializing:!1,initialized:!1,loadingPrices:!1,loadingQuote:!1,loadingApprovalTransaction:!1,loadingBuildTransaction:!1,loadingTransaction:!1,fetchError:!1,approvalTransaction:void 0,swapTransaction:void 0,transactionError:void 0,sourceToken:void 0,sourceTokenAmount:"",sourceTokenPriceInUSD:0,toToken:void 0,toTokenAmount:"",toTokenPriceInUSD:0,networkPrice:"0",networkBalanceInUSD:"0",networkTokenSymbol:"",inputError:void 0,slippage:l.ConstantsUtil.CONVERT_SLIPPAGE_TOLERANCE,tokens:void 0,popularTokens:void 0,suggestedTokens:void 0,foundTokens:void 0,myTokensWithBalance:void 0,tokensPriceMap:{},gasFee:"0",gasPriceInUSD:0,priceImpact:void 0,maxSlippage:void 0,providerFee:void 0},T=(0,t.proxy)({...y}),P={state:T,subscribe:e=>(0,t.subscribe)(T,()=>e(T)),subscribeKey:(e,t)=>(0,o.subscribeKey)(T,e,t),getParams(){let e=k.ChainController.state.activeChain,t=m.AccountController.getCaipAddress(e)??k.ChainController.state.activeCaipAddress,o=c.CoreHelperUtil.getPlainAddress(t),i=(0,s.getActiveNetworkTokenAddress)(),n=b.ConnectorController.getConnectorId(k.ChainController.state.activeChain);if(!o)throw Error("No address found to swap the tokens from.");let l=!T.toToken?.address||!T.toToken?.decimals,d=!T.sourceToken?.address||!T.sourceToken?.decimals||!a.NumberUtil.bigNumber(T.sourceTokenAmount).gt(0),u=!T.sourceTokenAmount;return{networkAddress:i,fromAddress:o,fromCaipAddress:t,sourceTokenAddress:T.sourceToken?.address,toTokenAddress:T.toToken?.address,toTokenAmount:T.toTokenAmount,toTokenDecimals:T.toToken?.decimals,sourceTokenAmount:T.sourceTokenAmount,sourceTokenDecimals:T.sourceToken?.decimals,invalidToToken:l,invalidSourceToken:d,invalidSourceTokenAmount:u,availableToSwap:t&&!l&&!d&&!u,isAuthConnector:n===r.ConstantsUtil.CONNECTOR_ID.AUTH}},setSourceToken(e){if(!e){T.sourceToken=e,T.sourceTokenAmount="",T.sourceTokenPriceInUSD=0;return}T.sourceToken=e,S.setTokenPrice(e.address,"sourceToken")},setSourceTokenAmount(e){T.sourceTokenAmount=e},setToToken(e){if(!e){T.toToken=e,T.toTokenAmount="",T.toTokenPriceInUSD=0;return}T.toToken=e,S.setTokenPrice(e.address,"toToken")},setToTokenAmount(e){T.toTokenAmount=e?a.NumberUtil.toFixed(e,6):""},async setTokenPrice(e,t){let o=T.tokensPriceMap[e]||0;o||(T.loadingPrices=!0,o=await S.getAddressPrice(e)),"sourceToken"===t?T.sourceTokenPriceInUSD=o:"toToken"===t&&(T.toTokenPriceInUSD=o),T.loadingPrices&&(T.loadingPrices=!1),S.getParams().availableToSwap&&S.swapTokens()},switchTokens(){if(T.initializing||!T.initialized)return;let e=T.toToken?{...T.toToken}:void 0,t=T.sourceToken?{...T.sourceToken}:void 0,o=e&&""===T.toTokenAmount?"1":T.toTokenAmount;S.setSourceToken(e),S.setToToken(t),S.setSourceTokenAmount(o),S.setToTokenAmount(""),S.swapTokens()},resetState(){T.myTokensWithBalance=y.myTokensWithBalance,T.tokensPriceMap=y.tokensPriceMap,T.initialized=y.initialized,T.initializing=y.initializing,T.sourceToken=y.sourceToken,T.sourceTokenAmount=y.sourceTokenAmount,T.sourceTokenPriceInUSD=y.sourceTokenPriceInUSD,T.toToken=y.toToken,T.toTokenAmount=y.toTokenAmount,T.toTokenPriceInUSD=y.toTokenPriceInUSD,T.networkPrice=y.networkPrice,T.networkTokenSymbol=y.networkTokenSymbol,T.networkBalanceInUSD=y.networkBalanceInUSD,T.inputError=y.inputError},resetValues(){let{networkAddress:e}=S.getParams(),t=T.tokens?.find(t=>t.address===e);S.setSourceToken(t),S.setToToken(void 0)},getApprovalLoadingState:()=>T.loadingApprovalTransaction,clearError(){T.transactionError=void 0},async initializeState(){if(!T.initializing){if(T.initializing=!0,!T.initialized)try{await S.fetchTokens(),T.initialized=!0}catch(e){T.initialized=!1,C.SnackController.showError("Failed to initialize swap"),v.RouterController.goBack()}T.initializing=!1}},async fetchTokens(){let{networkAddress:e}=S.getParams();await S.getNetworkTokenPrice(),await S.getMyTokensWithBalance();let t=T.myTokensWithBalance?.find(t=>t.address===e);t&&(T.networkTokenSymbol=t.symbol,S.setSourceToken(t),S.setSourceTokenAmount("0"))},async getTokenList(){let e=k.ChainController.state.activeCaipNetwork?.caipNetworkId;if(T.caipNetworkId!==e||!T.tokens)try{T.tokensLoading=!0;let t=await d.SwapApiUtil.getTokenList(e);T.tokens=t,T.caipNetworkId=e,T.popularTokens=t.sort((e,t)=>e.symbol<t.symbol?-1:+(e.symbol>t.symbol)),T.suggestedTokens=t.filter(e=>!!l.ConstantsUtil.SWAP_SUGGESTED_TOKENS.includes(e.symbol))}catch(e){T.tokens=[],T.popularTokens=[],T.suggestedTokens=[]}finally{T.tokensLoading=!1}},async getAddressPrice(e){let t=T.tokensPriceMap[e];if(t)return t;let o=await w.BlockchainApiController.fetchTokenPrice({addresses:[e]}),a=o?.fungibles||[],r=[...T.tokens||[],...T.myTokensWithBalance||[]],i=r?.find(t=>t.address===e)?.symbol,n=parseFloat((a.find(e=>e.symbol.toLowerCase()===i?.toLowerCase())?.price||0).toString());return T.tokensPriceMap[e]=n,n},async getNetworkTokenPrice(){let{networkAddress:e}=S.getParams(),t=await w.BlockchainApiController.fetchTokenPrice({addresses:[e]}).catch(()=>(C.SnackController.showError("Failed to fetch network token price"),{fungibles:[]})),o=t.fungibles?.[0],a=o?.price.toString()||"0";T.tokensPriceMap[e]=parseFloat(a),T.networkTokenSymbol=o?.symbol||"",T.networkPrice=a},async getMyTokensWithBalance(e){let t=await n.BalanceUtil.getMyTokensWithBalance(e),o=d.SwapApiUtil.mapBalancesToSwapTokens(t);o&&(await S.getInitialGasPrice(),S.setBalances(o))},setBalances(e){let{networkAddress:t}=S.getParams(),o=k.ChainController.state.activeCaipNetwork;if(!o)return;let r=e.find(e=>e.address===t);e.forEach(e=>{T.tokensPriceMap[e.address]=e.price||0}),T.myTokensWithBalance=e.filter(e=>e.address.startsWith(o.caipNetworkId)),T.networkBalanceInUSD=r?a.NumberUtil.multiply(r.quantity.numeric,r.price).toString():"0"},async getInitialGasPrice(){let e=await d.SwapApiUtil.fetchGasPrice();if(!e)return{gasPrice:null,gasPriceInUSD:null};switch(k.ChainController.state?.activeCaipNetwork?.chainNamespace){case r.ConstantsUtil.CHAIN.SOLANA:return T.gasFee=e.standard??"0",T.gasPriceInUSD=a.NumberUtil.multiply(e.standard,T.networkPrice).div(1e9).toNumber(),{gasPrice:BigInt(T.gasFee),gasPriceInUSD:Number(T.gasPriceInUSD)};case r.ConstantsUtil.CHAIN.EVM:default:let t=e.standard??"0",o=BigInt(t),i=BigInt(15e4),n=u.getGasPriceInUSD(T.networkPrice,i,o);return T.gasFee=t,T.gasPriceInUSD=n,{gasPrice:o,gasPriceInUSD:n}}},async swapTokens(){let e=m.AccountController.state.address,t=T.sourceToken,o=T.toToken,r=a.NumberUtil.bigNumber(T.sourceTokenAmount).gt(0);if(r||S.setToTokenAmount(""),!o||!t||T.loadingPrices||!r)return;T.loadingQuote=!0;let i=a.NumberUtil.bigNumber(T.sourceTokenAmount).times(10**t.decimals).round(0);try{let r=await w.BlockchainApiController.fetchSwapQuote({userAddress:e,from:t.address,to:o.address,gasPrice:T.gasFee,amount:i.toString()});T.loadingQuote=!1;let n=r?.quotes?.[0]?.toAmount;if(!n)return void h.AlertController.open({displayMessage:"Incorrect amount",debugMessage:"Please enter a valid amount"},"error");let s=a.NumberUtil.bigNumber(n).div(10**o.decimals).toString();S.setToTokenAmount(s),S.hasInsufficientToken(T.sourceTokenAmount,t.address)?T.inputError="Insufficient balance":(T.inputError=void 0,S.setTransactionDetails())}catch(e){T.loadingQuote=!1,T.inputError="Insufficient balance"}},async getTransaction(){let{fromCaipAddress:e,availableToSwap:t}=S.getParams(),o=T.sourceToken,a=T.toToken;if(e&&t&&o&&a&&!T.loadingQuote)try{let t;return T.loadingBuildTransaction=!0,t=await d.SwapApiUtil.fetchSwapAllowance({userAddress:e,tokenAddress:o.address,sourceTokenAmount:T.sourceTokenAmount,sourceTokenDecimals:o.decimals})?await S.createSwapTransaction():await S.createAllowanceTransaction(),T.loadingBuildTransaction=!1,T.fetchError=!1,t}catch(e){v.RouterController.goBack(),C.SnackController.showError("Failed to check allowance"),T.loadingBuildTransaction=!1,T.approvalTransaction=void 0,T.swapTransaction=void 0,T.fetchError=!0;return}},async createAllowanceTransaction(){let{fromCaipAddress:e,sourceTokenAddress:t,toTokenAddress:o}=S.getParams();if(e&&o){if(!t)throw Error("createAllowanceTransaction - No source token address found.");try{let a=await w.BlockchainApiController.generateApproveCalldata({from:t,to:o,userAddress:e}),r=c.CoreHelperUtil.getPlainAddress(a.tx.from);if(!r)throw Error("SwapController:createAllowanceTransaction - address is required");let i={data:a.tx.data,to:r,gasPrice:BigInt(a.tx.eip155.gasPrice),value:BigInt(a.tx.value),toAmount:T.toTokenAmount};return T.swapTransaction=void 0,T.approvalTransaction={data:i.data,to:i.to,gasPrice:i.gasPrice,value:i.value,toAmount:i.toAmount},{data:i.data,to:i.to,gasPrice:i.gasPrice,value:i.value,toAmount:i.toAmount}}catch(e){v.RouterController.goBack(),C.SnackController.showError("Failed to create approval transaction"),T.approvalTransaction=void 0,T.swapTransaction=void 0,T.fetchError=!0;return}}},async createSwapTransaction(){let{networkAddress:e,fromCaipAddress:t,sourceTokenAmount:o}=S.getParams(),a=T.sourceToken,r=T.toToken;if(!t||!o||!a||!r)return;let i=g.ConnectionController.parseUnits(o,a.decimals)?.toString();try{let o=await w.BlockchainApiController.generateSwapCalldata({userAddress:t,from:a.address,to:r.address,amount:i,disableEstimate:!0}),n=a.address===e,s=BigInt(o.tx.eip155.gas),l=BigInt(o.tx.eip155.gasPrice),d=c.CoreHelperUtil.getPlainAddress(o.tx.to);if(!d)throw Error("SwapController:createSwapTransaction - address is required");let p={data:o.tx.data,to:d,gas:s,gasPrice:l,value:n?BigInt(i??"0"):BigInt("0"),toAmount:T.toTokenAmount};return T.gasPriceInUSD=u.getGasPriceInUSD(T.networkPrice,s,l),T.approvalTransaction=void 0,T.swapTransaction=p,p}catch(e){v.RouterController.goBack(),C.SnackController.showError("Failed to create transaction"),T.approvalTransaction=void 0,T.swapTransaction=void 0,T.fetchError=!0;return}},onEmbeddedWalletApprovalSuccess(){C.SnackController.showLoading("Approve limit increase in your wallet"),v.RouterController.replace("SwapPreview")},async sendTransactionForApproval(e){let{fromAddress:t,isAuthConnector:o}=S.getParams();T.loadingApprovalTransaction=!0,o?v.RouterController.pushTransactionStack({onSuccess:S.onEmbeddedWalletApprovalSuccess}):C.SnackController.showLoading("Approve limit increase in your wallet");try{await g.ConnectionController.sendTransaction({address:t,to:e.to,data:e.data,value:e.value,chainNamespace:r.ConstantsUtil.CHAIN.EVM}),await S.swapTokens(),await S.getTransaction(),T.approvalTransaction=void 0,T.loadingApprovalTransaction=!1}catch(e){T.transactionError=e?.displayMessage,T.loadingApprovalTransaction=!1,C.SnackController.showError(e?.displayMessage||"Transaction error"),f.EventsController.sendEvent({type:"track",event:"SWAP_APPROVAL_ERROR",properties:{message:e?.displayMessage||e?.message||"Unknown",network:k.ChainController.state.activeCaipNetwork?.caipNetworkId||"",swapFromToken:S.state.sourceToken?.symbol||"",swapToToken:S.state.toToken?.symbol||"",swapFromAmount:S.state.sourceTokenAmount||"",swapToAmount:S.state.toTokenAmount||"",isSmartAccount:(0,s.getPreferredAccountType)(r.ConstantsUtil.CHAIN.EVM)===i.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT}})}},async sendTransactionForSwap(e){if(!e)return;let{fromAddress:t,toTokenAmount:o,isAuthConnector:n}=S.getParams();T.loadingTransaction=!0;let l=`Swapping ${T.sourceToken?.symbol} to ${a.NumberUtil.formatNumberToLocalString(o,3)} ${T.toToken?.symbol}`,c=`Swapped ${T.sourceToken?.symbol} to ${a.NumberUtil.formatNumberToLocalString(o,3)} ${T.toToken?.symbol}`;n?v.RouterController.pushTransactionStack({onSuccess(){v.RouterController.replace("Account"),C.SnackController.showLoading(l),P.resetState()}}):C.SnackController.showLoading("Confirm transaction in your wallet");try{let o=[T.sourceToken?.address,T.toToken?.address].join(","),a=await g.ConnectionController.sendTransaction({address:t,to:e.to,data:e.data,value:e.value,chainNamespace:r.ConstantsUtil.CHAIN.EVM});return T.loadingTransaction=!1,C.SnackController.showSuccess(c),f.EventsController.sendEvent({type:"track",event:"SWAP_SUCCESS",properties:{network:k.ChainController.state.activeCaipNetwork?.caipNetworkId||"",swapFromToken:S.state.sourceToken?.symbol||"",swapToToken:S.state.toToken?.symbol||"",swapFromAmount:S.state.sourceTokenAmount||"",swapToAmount:S.state.toTokenAmount||"",isSmartAccount:(0,s.getPreferredAccountType)(r.ConstantsUtil.CHAIN.EVM)===i.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT}}),P.resetState(),n||v.RouterController.replace("Account"),P.getMyTokensWithBalance(o),a}catch(e){T.transactionError=e?.displayMessage,T.loadingTransaction=!1,C.SnackController.showError(e?.displayMessage||"Transaction error"),f.EventsController.sendEvent({type:"track",event:"SWAP_ERROR",properties:{message:e?.displayMessage||e?.message||"Unknown",network:k.ChainController.state.activeCaipNetwork?.caipNetworkId||"",swapFromToken:S.state.sourceToken?.symbol||"",swapToToken:S.state.toToken?.symbol||"",swapFromAmount:S.state.sourceTokenAmount||"",swapToAmount:S.state.toTokenAmount||"",isSmartAccount:(0,s.getPreferredAccountType)(r.ConstantsUtil.CHAIN.EVM)===i.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT}});return}},hasInsufficientToken:(e,t)=>u.isInsufficientSourceTokenForSwap(e,t,T.myTokensWithBalance),setTransactionDetails(){let{toTokenAddress:e,toTokenDecimals:t}=S.getParams();e&&t&&(T.gasPriceInUSD=u.getGasPriceInUSD(T.networkPrice,BigInt(T.gasFee),BigInt(15e4)),T.priceImpact=u.getPriceImpact({sourceTokenAmount:T.sourceTokenAmount,sourceTokenPriceInUSD:T.sourceTokenPriceInUSD,toTokenPriceInUSD:T.toTokenPriceInUSD,toTokenAmount:T.toTokenAmount}),T.maxSlippage=u.getMaxSlippage(T.slippage,T.toTokenAmount),T.providerFee=u.getProviderFee(T.sourceTokenAmount))}},S=(0,p.withErrorBoundary)(P);e.s(["SwapController",0,S],950955)},443237,e=>{"use strict";e.i(588984);var t=e.i(399702),o=e.i(872857);e.i(759703);var a=e.i(392074),r=e.i(698797);e.i(781840);var i=e.i(86988),n=e.i(138230),s=e.i(222328),l=e.i(665545),c=e.i(207176),d=e.i(729702),u=e.i(301847),p=e.i(945182),m=e.i(11961),h=e.i(375054),w=e.i(43844);let k={isUnsupportedChainView:()=>"UnsupportedChain"===h.RouterController.state.view||"SwitchNetwork"===h.RouterController.state.view&&h.RouterController.state.history.includes("UnsupportedChain"),async safeClose(){this.isUnsupportedChainView()||await w.SIWXUtil.isSIWXCloseDisabled()?p.ModalController.shake():(("DataCapture"===h.RouterController.state.view||"DataCaptureOtpConfirm"===h.RouterController.state.view)&&m.ConnectionController.disconnect(),p.ModalController.close())}};var g=e.i(944411),b=e.i(944396),f=e.i(950955),v=e.i(880985);e.i(302184);var C=e.i(34691),y=e.i(938559),T=e.i(864429),P=t,S=e.i(118827);let A=S.css`
  :host {
    display: block;
    border-radius: clamp(0px, var(--wui-border-radius-l), 44px);
    box-shadow: 0 0 0 1px var(--wui-color-gray-glass-005);
    background-color: var(--wui-color-modal-bg);
    overflow: hidden;
  }

  :host([data-embedded='true']) {
    box-shadow:
      0 0 0 1px var(--wui-color-gray-glass-005),
      0px 4px 12px 4px var(--w3m-card-embedded-shadow-color);
  }
`,x=class extends P.LitElement{render(){return o.html`<slot></slot>`}};x.styles=[T.resetStyles,A],x=function(e,t,o,a){var r,i=arguments.length,n=i<3?t:null===a?a=Object.getOwnPropertyDescriptor(t,o):a;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)n=Reflect.decorate(e,t,o,a);else for(var s=e.length-1;s>=0;s--)(r=e[s])&&(n=(i<3?r(n):i>3?r(t,o,n):r(t,o))||n);return i>3&&n&&Object.defineProperty(t,o,n),n}([(0,y.customElement)("wui-card")],x),e.i(237029);var N=t,E=e.i(525417),I=t;e.i(630572),e.i(596548),e.i(108476);let U=S.css`
  :host {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: var(--wui-spacing-s);
    border-radius: var(--wui-border-radius-s);
    border: 1px solid var(--wui-color-dark-glass-100);
    box-sizing: border-box;
    background-color: var(--wui-color-bg-325);
    box-shadow: 0px 0px 16px 0px rgba(0, 0, 0, 0.25);
  }

  wui-flex {
    width: 100%;
  }

  wui-text {
    word-break: break-word;
    flex: 1;
  }

  .close {
    cursor: pointer;
  }

  .icon-box {
    height: 40px;
    width: 40px;
    border-radius: var(--wui-border-radius-3xs);
    background-color: var(--local-icon-bg-value);
  }
`;var j=function(e,t,o,a){var r,i=arguments.length,n=i<3?t:null===a?a=Object.getOwnPropertyDescriptor(t,o):a;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)n=Reflect.decorate(e,t,o,a);else for(var s=e.length-1;s>=0;s--)(r=e[s])&&(n=(i<3?r(n):i>3?r(t,o,n):r(t,o))||n);return i>3&&n&&Object.defineProperty(t,o,n),n};let R=class extends I.LitElement{constructor(){super(...arguments),this.message="",this.backgroundColor="accent-100",this.iconColor="accent-100",this.icon="info"}render(){return this.style.cssText=`
      --local-icon-bg-value: var(--wui-color-${this.backgroundColor});
   `,o.html`
      <wui-flex flexDirection="row" justifyContent="space-between" alignItems="center">
        <wui-flex columnGap="xs" flexDirection="row" alignItems="center">
          <wui-flex
            flexDirection="row"
            alignItems="center"
            justifyContent="center"
            class="icon-box"
          >
            <wui-icon color=${this.iconColor} size="md" name=${this.icon}></wui-icon>
          </wui-flex>
          <wui-text variant="small-500" color="bg-350" data-testid="wui-alertbar-text"
            >${this.message}</wui-text
          >
        </wui-flex>
        <wui-icon
          class="close"
          color="bg-350"
          size="sm"
          name="close"
          @click=${this.onClose}
        ></wui-icon>
      </wui-flex>
    `}onClose(){E.AlertController.close()}};R.styles=[T.resetStyles,U],j([(0,a.property)()],R.prototype,"message",void 0),j([(0,a.property)()],R.prototype,"backgroundColor",void 0),j([(0,a.property)()],R.prototype,"iconColor",void 0),j([(0,a.property)()],R.prototype,"icon",void 0),R=j([(0,y.customElement)("wui-alertbar")],R);let B=S.css`
  :host {
    display: block;
    position: absolute;
    top: var(--wui-spacing-s);
    left: var(--wui-spacing-l);
    right: var(--wui-spacing-l);
    opacity: 0;
    pointer-events: none;
  }
`;var W=function(e,t,o,a){var r,i=arguments.length,n=i<3?t:null===a?a=Object.getOwnPropertyDescriptor(t,o):a;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)n=Reflect.decorate(e,t,o,a);else for(var s=e.length-1;s>=0;s--)(r=e[s])&&(n=(i<3?r(n):i>3?r(t,o,n):r(t,o))||n);return i>3&&n&&Object.defineProperty(t,o,n),n};let D={info:{backgroundColor:"fg-350",iconColor:"fg-325",icon:"info"},success:{backgroundColor:"success-glass-reown-020",iconColor:"success-125",icon:"checkmark"},warning:{backgroundColor:"warning-glass-reown-020",iconColor:"warning-100",icon:"warningCircle"},error:{backgroundColor:"error-glass-reown-020",iconColor:"error-125",icon:"exclamationTriangle"}},O=class extends N.LitElement{constructor(){super(),this.unsubscribe=[],this.open=E.AlertController.state.open,this.onOpen(!0),this.unsubscribe.push(E.AlertController.subscribeKey("open",e=>{this.open=e,this.onOpen(!1)}))}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}render(){let{message:e,variant:t}=E.AlertController.state,a=D[t];return o.html`
      <wui-alertbar
        message=${e}
        backgroundColor=${a?.backgroundColor}
        iconColor=${a?.iconColor}
        icon=${a?.icon}
      ></wui-alertbar>
    `}onOpen(e){this.open?(this.animate([{opacity:0,transform:"scale(0.85)"},{opacity:1,transform:"scale(1)"}],{duration:150,fill:"forwards",easing:"ease"}),this.style.cssText="pointer-events: auto"):e||(this.animate([{opacity:1,transform:"scale(1)"},{opacity:0,transform:"scale(0.85)"}],{duration:150,fill:"forwards",easing:"ease"}),this.style.cssText="pointer-events: none")}};O.styles=B,W([(0,r.state)()],O.prototype,"open",void 0),O=W([(0,y.customElement)("w3m-alertbar")],O);var $=t,M=e.i(596590),L=e.i(689783),F=e.i(589408),z=e.i(881936);e.i(679556);var H=t;e.i(287940),e.i(839432);let K=S.css`
  button {
    display: block;
    display: flex;
    align-items: center;
    padding: var(--wui-spacing-xxs);
    gap: var(--wui-spacing-xxs);
    transition: all var(--wui-ease-out-power-1) var(--wui-duration-md);
    border-radius: var(--wui-border-radius-xxs);
  }

  wui-image {
    border-radius: 100%;
    width: var(--wui-spacing-xl);
    height: var(--wui-spacing-xl);
  }

  wui-icon-box {
    width: var(--wui-spacing-xl);
    height: var(--wui-spacing-xl);
  }

  button:hover {
    background-color: var(--wui-color-gray-glass-002);
  }

  button:active {
    background-color: var(--wui-color-gray-glass-005);
  }
`;var _=function(e,t,o,a){var r,i=arguments.length,n=i<3?t:null===a?a=Object.getOwnPropertyDescriptor(t,o):a;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)n=Reflect.decorate(e,t,o,a);else for(var s=e.length-1;s>=0;s--)(r=e[s])&&(n=(i<3?r(n):i>3?r(t,o,n):r(t,o))||n);return i>3&&n&&Object.defineProperty(t,o,n),n};let G=class extends H.LitElement{constructor(){super(...arguments),this.imageSrc=""}render(){return o.html`<button>
      ${this.imageTemplate()}
      <wui-icon size="xs" color="fg-200" name="chevronBottom"></wui-icon>
    </button>`}imageTemplate(){return this.imageSrc?o.html`<wui-image src=${this.imageSrc} alt="select visual"></wui-image>`:o.html`<wui-icon-box
      size="xxs"
      iconColor="fg-200"
      backgroundColor="fg-100"
      background="opaque"
      icon="networkPlaceholder"
    ></wui-icon-box>`}};G.styles=[T.resetStyles,T.elementStyles,T.colorStyles,K],_([(0,a.property)()],G.prototype,"imageSrc",void 0),G=_([(0,y.customElement)("wui-select")],G),e.i(990237),e.i(331658);var V=e.i(924487);let Y=S.css`
  :host {
    height: 64px;
  }

  wui-text {
    text-transform: capitalize;
  }

  wui-flex.w3m-header-title {
    transform: translateY(0);
    opacity: 1;
  }

  wui-flex.w3m-header-title[view-direction='prev'] {
    animation:
      slide-down-out 120ms forwards var(--wui-ease-out-power-2),
      slide-down-in 120ms forwards var(--wui-ease-out-power-2);
    animation-delay: 0ms, 200ms;
  }

  wui-flex.w3m-header-title[view-direction='next'] {
    animation:
      slide-up-out 120ms forwards var(--wui-ease-out-power-2),
      slide-up-in 120ms forwards var(--wui-ease-out-power-2);
    animation-delay: 0ms, 200ms;
  }

  wui-icon-link[data-hidden='true'] {
    opacity: 0 !important;
    pointer-events: none;
  }

  @keyframes slide-up-out {
    from {
      transform: translateY(0px);
      opacity: 1;
    }
    to {
      transform: translateY(3px);
      opacity: 0;
    }
  }

  @keyframes slide-up-in {
    from {
      transform: translateY(-3px);
      opacity: 0;
    }
    to {
      transform: translateY(0);
      opacity: 1;
    }
  }

  @keyframes slide-down-out {
    from {
      transform: translateY(0px);
      opacity: 1;
    }
    to {
      transform: translateY(-3px);
      opacity: 0;
    }
  }

  @keyframes slide-down-in {
    from {
      transform: translateY(3px);
      opacity: 0;
    }
    to {
      transform: translateY(0);
      opacity: 1;
    }
  }
`;var q=function(e,t,o,a){var r,i=arguments.length,n=i<3?t:null===a?a=Object.getOwnPropertyDescriptor(t,o):a;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)n=Reflect.decorate(e,t,o,a);else for(var s=e.length-1;s>=0;s--)(r=e[s])&&(n=(i<3?r(n):i>3?r(t,o,n):r(t,o))||n);return i>3&&n&&Object.defineProperty(t,o,n),n};let X=["SmartSessionList"];function Q(){let e=h.RouterController.state.data?.connector?.name,t=h.RouterController.state.data?.wallet?.name,o=h.RouterController.state.data?.network?.name,a=t??e,r=d.ConnectorController.getConnectors(),i=1===r.length&&r[0]?.id==="w3m-email";return{Connect:`Connect ${i?"Email":""} Wallet`,Create:"Create Wallet",ChooseAccountName:void 0,Account:void 0,AccountSettings:void 0,AllWallets:"All Wallets",ApproveTransaction:"Approve Transaction",BuyInProgress:"Buy",ConnectingExternal:a??"Connect Wallet",ConnectingWalletConnect:a??"WalletConnect",ConnectingWalletConnectBasic:"WalletConnect",ConnectingSiwe:"Sign In",Convert:"Convert",ConvertSelectToken:"Select token",ConvertPreview:"Preview convert",Downloads:a?`Get ${a}`:"Downloads",EmailLogin:"Email Login",EmailVerifyOtp:"Confirm Email",EmailVerifyDevice:"Register Device",GetWallet:"Get a wallet",Networks:"Choose Network",OnRampProviders:"Choose Provider",OnRampActivity:"Activity",OnRampTokenSelect:"Select Token",OnRampFiatSelect:"Select Currency",Pay:"How you pay",ProfileWallets:"Wallets",SwitchNetwork:o??"Switch Network",Transactions:"Activity",UnsupportedChain:"Switch Network",UpgradeEmailWallet:"Upgrade your Wallet",UpdateEmailWallet:"Edit Email",UpdateEmailPrimaryOtp:"Confirm Current Email",UpdateEmailSecondaryOtp:"Confirm New Email",WhatIsABuy:"What is Buy?",RegisterAccountName:"Choose name",RegisterAccountNameSuccess:"",WalletReceive:"Receive",WalletCompatibleNetworks:"Compatible Networks",Swap:"Swap",SwapSelectToken:"Select token",SwapPreview:"Preview swap",WalletSend:"Send",WalletSendPreview:"Review send",WalletSendSelectToken:"Select Token",WhatIsANetwork:"What is a network?",WhatIsAWallet:"What is a wallet?",ConnectWallets:"Connect wallet",ConnectSocials:"All socials",ConnectingSocial:M.AccountController.state.socialProvider?M.AccountController.state.socialProvider:"Connect Social",ConnectingMultiChain:"Select chain",ConnectingFarcaster:"Farcaster",SwitchActiveChain:"Switch chain",SmartSessionCreated:void 0,SmartSessionList:"Smart Sessions",SIWXSignMessage:"Sign In",PayLoading:"Payment in progress",DataCapture:"Profile",DataCaptureOtpConfirm:"Confirm Email",FundWallet:"Fund wallet",PayWithExchange:"Deposit from an exchange"}}let J=class extends $.LitElement{constructor(){super(),this.unsubscribe=[],this.heading=Q()[h.RouterController.state.view],this.network=c.ChainController.state.activeCaipNetwork,this.networkImage=F.AssetUtil.getNetworkImage(this.network),this.showBack=!1,this.prevHistoryLength=1,this.view=h.RouterController.state.view,this.viewDirection="",this.headerText=Q()[h.RouterController.state.view],this.unsubscribe.push(L.AssetController.subscribeNetworkImages(()=>{this.networkImage=F.AssetUtil.getNetworkImage(this.network)}),h.RouterController.subscribeKey("view",e=>{setTimeout(()=>{this.view=e,this.headerText=Q()[e]},V.ConstantsUtil.ANIMATION_DURATIONS.HeaderText),this.onViewChange(),this.onHistoryChange()}),c.ChainController.subscribeKey("activeCaipNetwork",e=>{this.network=e,this.networkImage=F.AssetUtil.getNetworkImage(this.network)}))}disconnectCallback(){this.unsubscribe.forEach(e=>e())}render(){return o.html`
      <wui-flex .padding=${this.getPadding()} justifyContent="space-between" alignItems="center">
        ${this.leftHeaderTemplate()} ${this.titleTemplate()} ${this.rightHeaderTemplate()}
      </wui-flex>
    `}onWalletHelp(){z.EventsController.sendEvent({type:"track",event:"CLICK_WALLET_HELP"}),h.RouterController.push("WhatIsAWallet")}async onClose(){await k.safeClose()}rightHeaderTemplate(){let e=g.OptionsController?.state?.features?.smartSessions;return"Account"===h.RouterController.state.view&&e?o.html`<wui-flex>
      <wui-icon-link
        icon="clock"
        @click=${()=>h.RouterController.push("SmartSessionList")}
        data-testid="w3m-header-smart-sessions"
      ></wui-icon-link>
      ${this.closeButtonTemplate()}
    </wui-flex> `:this.closeButtonTemplate()}closeButtonTemplate(){return o.html`
      <wui-icon-link
        icon="close"
        @click=${this.onClose.bind(this)}
        data-testid="w3m-header-close"
      ></wui-icon-link>
    `}titleTemplate(){let e=X.includes(this.view);return o.html`
      <wui-flex
        view-direction="${this.viewDirection}"
        class="w3m-header-title"
        alignItems="center"
        gap="xs"
      >
        <wui-text variant="paragraph-700" color="fg-100" data-testid="w3m-header-text"
          >${this.headerText}</wui-text
        >
        ${e?o.html`<wui-tag variant="main">Beta</wui-tag>`:null}
      </wui-flex>
    `}leftHeaderTemplate(){let{view:e}=h.RouterController.state,t="Connect"===e,a=g.OptionsController.state.enableEmbedded,r=g.OptionsController.state.enableNetworkSwitch;return"Account"===e&&r?o.html`<wui-select
        id="dynamic"
        data-testid="w3m-account-select-network"
        active-network=${(0,i.ifDefined)(this.network?.name)}
        @click=${this.onNetworks.bind(this)}
        imageSrc=${(0,i.ifDefined)(this.networkImage)}
      ></wui-select>`:this.showBack&&!("ApproveTransaction"===e||"ConnectingSiwe"===e||t&&a)?o.html`<wui-icon-link
        data-testid="header-back"
        id="dynamic"
        icon="chevronLeft"
        @click=${this.onGoBack.bind(this)}
      ></wui-icon-link>`:o.html`<wui-icon-link
      data-hidden=${!t}
      id="dynamic"
      icon="helpCircle"
      @click=${this.onWalletHelp.bind(this)}
    ></wui-icon-link>`}onNetworks(){this.isAllowedNetworkSwitch()&&(z.EventsController.sendEvent({type:"track",event:"CLICK_NETWORKS"}),h.RouterController.push("Networks"))}isAllowedNetworkSwitch(){let e=c.ChainController.getAllRequestedCaipNetworks(),t=!!e&&e.length>1,o=e?.find(({id:e})=>e===this.network?.id);return t||!o}getPadding(){return this.heading?["l","2l","l","2l"]:["0","2l","0","2l"]}onViewChange(){let{history:e}=h.RouterController.state,t=V.ConstantsUtil.VIEW_DIRECTION.Next;e.length<this.prevHistoryLength&&(t=V.ConstantsUtil.VIEW_DIRECTION.Prev),this.prevHistoryLength=e.length,this.viewDirection=t}async onHistoryChange(){let{history:e}=h.RouterController.state,t=this.shadowRoot?.querySelector("#dynamic");e.length>1&&!this.showBack&&t?(await t.animate([{opacity:1},{opacity:0}],{duration:200,fill:"forwards",easing:"ease"}).finished,this.showBack=!0,t.animate([{opacity:0},{opacity:1}],{duration:200,fill:"forwards",easing:"ease"})):e.length<=1&&this.showBack&&t&&(await t.animate([{opacity:1},{opacity:0}],{duration:200,fill:"forwards",easing:"ease"}).finished,this.showBack=!1,t.animate([{opacity:0},{opacity:1}],{duration:200,fill:"forwards",easing:"ease"}))}onGoBack(){h.RouterController.goBack()}};J.styles=Y,q([(0,r.state)()],J.prototype,"heading",void 0),q([(0,r.state)()],J.prototype,"network",void 0),q([(0,r.state)()],J.prototype,"networkImage",void 0),q([(0,r.state)()],J.prototype,"showBack",void 0),q([(0,r.state)()],J.prototype,"prevHistoryLength",void 0),q([(0,r.state)()],J.prototype,"view",void 0),q([(0,r.state)()],J.prototype,"viewDirection",void 0),q([(0,r.state)()],J.prototype,"headerText",void 0),J=q([(0,y.customElement)("w3m-header")],J);var Z=t,ee=t;e.i(829162);let et=S.css`
  :host {
    display: flex;
    column-gap: var(--wui-spacing-s);
    align-items: center;
    padding: var(--wui-spacing-xs) var(--wui-spacing-m) var(--wui-spacing-xs) var(--wui-spacing-xs);
    border-radius: var(--wui-border-radius-s);
    border: 1px solid var(--wui-color-gray-glass-005);
    box-sizing: border-box;
    background-color: var(--wui-color-bg-175);
    box-shadow:
      0px 14px 64px -4px rgba(0, 0, 0, 0.15),
      0px 8px 22px -6px rgba(0, 0, 0, 0.15);

    max-width: 300px;
  }

  :host wui-loading-spinner {
    margin-left: var(--wui-spacing-3xs);
  }
`;var eo=function(e,t,o,a){var r,i=arguments.length,n=i<3?t:null===a?a=Object.getOwnPropertyDescriptor(t,o):a;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)n=Reflect.decorate(e,t,o,a);else for(var s=e.length-1;s>=0;s--)(r=e[s])&&(n=(i<3?r(n):i>3?r(t,o,n):r(t,o))||n);return i>3&&n&&Object.defineProperty(t,o,n),n};let ea=class extends ee.LitElement{constructor(){super(...arguments),this.backgroundColor="accent-100",this.iconColor="accent-100",this.icon="checkmark",this.message="",this.loading=!1,this.iconType="default"}render(){return o.html`
      ${this.templateIcon()}
      <wui-text variant="paragraph-500" color="fg-100" data-testid="wui-snackbar-message"
        >${this.message}</wui-text
      >
    `}templateIcon(){return this.loading?o.html`<wui-loading-spinner size="md" color="accent-100"></wui-loading-spinner>`:"default"===this.iconType?o.html`<wui-icon size="xl" color=${this.iconColor} name=${this.icon}></wui-icon>`:o.html`<wui-icon-box
      size="sm"
      iconSize="xs"
      iconColor=${this.iconColor}
      backgroundColor=${this.backgroundColor}
      icon=${this.icon}
      background="opaque"
    ></wui-icon-box>`}};ea.styles=[T.resetStyles,et],eo([(0,a.property)()],ea.prototype,"backgroundColor",void 0),eo([(0,a.property)()],ea.prototype,"iconColor",void 0),eo([(0,a.property)()],ea.prototype,"icon",void 0),eo([(0,a.property)()],ea.prototype,"message",void 0),eo([(0,a.property)()],ea.prototype,"loading",void 0),eo([(0,a.property)()],ea.prototype,"iconType",void 0),ea=eo([(0,y.customElement)("wui-snackbar")],ea);let er=S.css`
  :host {
    display: block;
    position: absolute;
    opacity: 0;
    pointer-events: none;
    top: 11px;
    left: 50%;
    width: max-content;
  }
`;var ei=function(e,t,o,a){var r,i=arguments.length,n=i<3?t:null===a?a=Object.getOwnPropertyDescriptor(t,o):a;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)n=Reflect.decorate(e,t,o,a);else for(var s=e.length-1;s>=0;s--)(r=e[s])&&(n=(i<3?r(n):i>3?r(t,o,n):r(t,o))||n);return i>3&&n&&Object.defineProperty(t,o,n),n};let en={loading:void 0,success:{backgroundColor:"success-100",iconColor:"success-100",icon:"checkmark"},error:{backgroundColor:"error-100",iconColor:"error-100",icon:"close"}},es=class extends Z.LitElement{constructor(){super(),this.unsubscribe=[],this.timeout=void 0,this.open=b.SnackController.state.open,this.unsubscribe.push(b.SnackController.subscribeKey("open",e=>{this.open=e,this.onOpen()}))}disconnectedCallback(){clearTimeout(this.timeout),this.unsubscribe.forEach(e=>e())}render(){let{message:e,variant:t,svg:a}=b.SnackController.state,r=en[t],{icon:i,iconColor:n}=a??r??{};return o.html`
      <wui-snackbar
        message=${e}
        backgroundColor=${r?.backgroundColor}
        iconColor=${n}
        icon=${i}
        .loading=${"loading"===t}
      ></wui-snackbar>
    `}onOpen(){clearTimeout(this.timeout),this.open?(this.animate([{opacity:0,transform:"translateX(-50%) scale(0.85)"},{opacity:1,transform:"translateX(-50%) scale(1)"}],{duration:150,fill:"forwards",easing:"ease"}),this.timeout&&clearTimeout(this.timeout),b.SnackController.state.autoClose&&(this.timeout=setTimeout(()=>b.SnackController.hide(),2500))):this.animate([{opacity:1,transform:"translateX(-50%) scale(1)"},{opacity:0,transform:"translateX(-50%) scale(0.85)"}],{duration:150,fill:"forwards",easing:"ease"})}};es.styles=er,ei([(0,r.state)()],es.prototype,"open",void 0),es=ei([(0,y.customElement)("w3m-snackbar")],es),e.i(641912),e.i(474025);let el=S.css`
  :host {
    z-index: var(--w3m-z-index);
    display: block;
    backface-visibility: hidden;
    will-change: opacity;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    pointer-events: none;
    opacity: 0;
    background-color: var(--wui-cover);
    transition: opacity 0.2s var(--wui-ease-out-power-2);
    will-change: opacity;
  }

  :host(.open) {
    opacity: 1;
  }

  :host(.appkit-modal) {
    position: relative;
    pointer-events: unset;
    background: none;
    width: 100%;
    opacity: 1;
  }

  wui-card {
    max-width: var(--w3m-modal-width);
    width: 100%;
    position: relative;
    animation: zoom-in 0.2s var(--wui-ease-out-power-2);
    animation-fill-mode: backwards;
    outline: none;
    transition:
      border-radius var(--wui-duration-lg) var(--wui-ease-out-power-1),
      background-color var(--wui-duration-lg) var(--wui-ease-out-power-1);
    will-change: border-radius, background-color;
  }

  :host(.appkit-modal) wui-card {
    max-width: 400px;
  }

  wui-card[shake='true'] {
    animation:
      zoom-in 0.2s var(--wui-ease-out-power-2),
      w3m-shake 0.5s var(--wui-ease-out-power-2);
  }

  wui-flex {
    overflow-x: hidden;
    overflow-y: auto;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 100%;
    height: 100%;
  }

  @media (max-height: 700px) and (min-width: 431px) {
    wui-flex {
      align-items: flex-start;
    }

    wui-card {
      margin: var(--wui-spacing-xxl) 0px;
    }
  }

  @media (max-width: 430px) {
    wui-flex {
      align-items: flex-end;
    }

    wui-card {
      max-width: 100%;
      border-bottom-left-radius: var(--local-border-bottom-mobile-radius);
      border-bottom-right-radius: var(--local-border-bottom-mobile-radius);
      border-bottom: none;
      animation: slide-in 0.2s var(--wui-ease-out-power-2);
    }

    wui-card[shake='true'] {
      animation:
        slide-in 0.2s var(--wui-ease-out-power-2),
        w3m-shake 0.5s var(--wui-ease-out-power-2);
    }
  }

  @keyframes zoom-in {
    0% {
      transform: scale(0.95) translateY(0);
    }
    100% {
      transform: scale(1) translateY(0);
    }
  }

  @keyframes slide-in {
    0% {
      transform: scale(1) translateY(50px);
    }
    100% {
      transform: scale(1) translateY(0);
    }
  }

  @keyframes w3m-shake {
    0% {
      transform: scale(1) rotate(0deg);
    }
    20% {
      transform: scale(1) rotate(-1deg);
    }
    40% {
      transform: scale(1) rotate(1.5deg);
    }
    60% {
      transform: scale(1) rotate(-1.5deg);
    }
    80% {
      transform: scale(1) rotate(1deg);
    }
    100% {
      transform: scale(1) rotate(0deg);
    }
  }

  @keyframes w3m-view-height {
    from {
      height: var(--prev-height);
    }
    to {
      height: var(--new-height);
    }
  }
`;var ec=function(e,t,o,a){var r,i=arguments.length,n=i<3?t:null===a?a=Object.getOwnPropertyDescriptor(t,o):a;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)n=Reflect.decorate(e,t,o,a);else for(var s=e.length-1;s>=0;s--)(r=e[s])&&(n=(i<3?r(n):i>3?r(t,o,n):r(t,o))||n);return i>3&&n&&Object.defineProperty(t,o,n),n};let ed="scroll-lock";class eu extends t.LitElement{constructor(){super(),this.unsubscribe=[],this.abortController=void 0,this.hasPrefetched=!1,this.enableEmbedded=g.OptionsController.state.enableEmbedded,this.open=p.ModalController.state.open,this.caipAddress=c.ChainController.state.activeCaipAddress,this.caipNetwork=c.ChainController.state.activeCaipNetwork,this.shake=p.ModalController.state.shake,this.filterByNamespace=d.ConnectorController.state.filterByNamespace,this.initializeTheming(),l.ApiController.prefetchAnalyticsConfig(),this.unsubscribe.push(p.ModalController.subscribeKey("open",e=>e?this.onOpen():this.onClose()),p.ModalController.subscribeKey("shake",e=>this.shake=e),c.ChainController.subscribeKey("activeCaipNetwork",e=>this.onNewNetwork(e)),c.ChainController.subscribeKey("activeCaipAddress",e=>this.onNewAddress(e)),g.OptionsController.subscribeKey("enableEmbedded",e=>this.enableEmbedded=e),d.ConnectorController.subscribeKey("filterByNamespace",e=>{this.filterByNamespace===e||c.ChainController.getAccountData(e)?.caipAddress||(l.ApiController.fetchRecommendedWallets(),this.filterByNamespace=e)}))}firstUpdated(){if(this.caipAddress){if(this.enableEmbedded){p.ModalController.close(),this.prefetch();return}this.onNewAddress(this.caipAddress)}this.open&&this.onOpen(),this.enableEmbedded&&this.prefetch()}disconnectedCallback(){this.unsubscribe.forEach(e=>e()),this.onRemoveKeyboardListener()}render(){return(this.style.cssText=`
      --local-border-bottom-mobile-radius: ${this.enableEmbedded?"clamp(0px, var(--wui-border-radius-l), 44px)":"0px"};
    `,this.enableEmbedded)?o.html`${this.contentTemplate()}
        <w3m-tooltip></w3m-tooltip> `:this.open?o.html`
          <wui-flex @click=${this.onOverlayClick.bind(this)} data-testid="w3m-modal-overlay">
            ${this.contentTemplate()}
          </wui-flex>
          <w3m-tooltip></w3m-tooltip>
        `:null}contentTemplate(){return o.html` <wui-card
      shake="${this.shake}"
      data-embedded="${(0,i.ifDefined)(this.enableEmbedded)}"
      role="alertdialog"
      aria-modal="true"
      tabindex="0"
      data-testid="w3m-modal-card"
    >
      <w3m-header></w3m-header>
      <w3m-router></w3m-router>
      <w3m-snackbar></w3m-snackbar>
      <w3m-alertbar></w3m-alertbar>
    </wui-card>`}async onOverlayClick(e){e.target===e.currentTarget&&await this.handleClose()}async handleClose(){await k.safeClose()}initializeTheming(){let{themeVariables:e,themeMode:t}=v.ThemeController.state,o=C.UiHelperUtil.getColorTheme(t);(0,T.initializeTheming)(e,o)}onClose(){this.open=!1,this.classList.remove("open"),this.onScrollUnlock(),b.SnackController.hide(),this.onRemoveKeyboardListener()}onOpen(){this.open=!0,this.classList.add("open"),this.onScrollLock(),this.onAddKeyboardListener()}onScrollLock(){let e=document.createElement("style");e.dataset.w3m=ed,e.textContent=`
      body {
        touch-action: none;
        overflow: hidden;
        overscroll-behavior: contain;
      }
      w3m-modal {
        pointer-events: auto;
      }
    `,document.head.appendChild(e)}onScrollUnlock(){let e=document.head.querySelector(`style[data-w3m="${ed}"]`);e&&e.remove()}onAddKeyboardListener(){this.abortController=new AbortController;let e=this.shadowRoot?.querySelector("wui-card");e?.focus(),window.addEventListener("keydown",t=>{if("Escape"===t.key)this.handleClose();else if("Tab"===t.key){let{tagName:o}=t.target;!o||o.includes("W3M-")||o.includes("WUI-")||e?.focus()}},this.abortController)}onRemoveKeyboardListener(){this.abortController?.abort(),this.abortController=void 0}async onNewAddress(e){let t=c.ChainController.state.isSwitchingNamespace,o="ProfileWallets"===h.RouterController.state.view;e?await this.onConnected({caipAddress:e,isSwitchingNamespace:t,isInProfileView:o}):t||this.enableEmbedded||o||p.ModalController.close(),await w.SIWXUtil.initializeIfEnabled(e),this.caipAddress=e,c.ChainController.setIsSwitchingNamespace(!1)}async onConnected(e){if(e.isInProfileView)return;let{chainNamespace:t,chainId:o,address:a}=s.ParseUtil.parseCaipAddress(e.caipAddress),r=`${t}:${o}`,i=!u.CoreHelperUtil.getPlainAddress(this.caipAddress),n=await w.SIWXUtil.getSessions({address:a,caipNetworkId:r}),l=!w.SIWXUtil.getSIWX()||n.some(e=>e.data.accountAddress===a),c=e.isSwitchingNamespace&&l&&!this.enableEmbedded,d=this.enableEmbedded&&i;c?h.RouterController.goBack():d&&p.ModalController.close()}onNewNetwork(e){let t=this.caipNetwork,o=t?.caipNetworkId?.toString(),a=t?.chainNamespace,r=e?.caipNetworkId?.toString(),i=e?.chainNamespace,s=o!==r,l=t?.name===n.ConstantsUtil.UNSUPPORTED_NETWORK_NAME,d="ConnectingExternal"===h.RouterController.state.view,u="ProfileWallets"===h.RouterController.state.view,m=!c.ChainController.getAccountData(e?.chainNamespace)?.caipAddress,w="UnsupportedChain"===h.RouterController.state.view,k=p.ModalController.state.open,g=!1;this.enableEmbedded&&"SwitchNetwork"===h.RouterController.state.view&&(g=!0),s&&f.SwapController.resetState(),k&&!d&&!u&&(m?s&&(g=!0):w?g=!0:s&&a===i&&!l&&(g=!0)),g&&"SIWXSignMessage"!==h.RouterController.state.view&&h.RouterController.goBack(),this.caipNetwork=e}prefetch(){this.hasPrefetched||(l.ApiController.prefetch(),l.ApiController.fetchWalletsByPage({page:1}),this.hasPrefetched=!0)}}eu.styles=el,ec([(0,a.property)({type:Boolean})],eu.prototype,"enableEmbedded",void 0),ec([(0,r.state)()],eu.prototype,"open",void 0),ec([(0,r.state)()],eu.prototype,"caipAddress",void 0),ec([(0,r.state)()],eu.prototype,"caipNetwork",void 0),ec([(0,r.state)()],eu.prototype,"shake",void 0),ec([(0,r.state)()],eu.prototype,"filterByNamespace",void 0);let ep=class extends eu{};ep=ec([(0,y.customElement)("w3m-modal")],ep);let em=class extends eu{};em=ec([(0,y.customElement)("appkit-modal")],em),e.s(["AppKitModal",()=>em,"W3mModal",()=>ep,"W3mModalBase",()=>eu],83332),e.s([],880287),e.i(880287),e.i(83332),e.s(["AppKitModal",()=>em,"W3mModal",()=>ep,"W3mModalBase",()=>eu],443237)},370120,e=>{e.v(t=>Promise.all(["static/chunks/26e0a8e49472e8b2.js"].map(t=>e.l(t))).then(()=>t(907496)))},101594,e=>{e.v(t=>Promise.all(["static/chunks/97923f7a558363e7.js"].map(t=>e.l(t))).then(()=>t(111408)))},53619,e=>{e.v(t=>Promise.all(["static/chunks/d2d95687802cc51a.js"].map(t=>e.l(t))).then(()=>t(945285)))},647729,e=>{e.v(t=>Promise.all(["static/chunks/b9333ed8ed5db8d8.js"].map(t=>e.l(t))).then(()=>t(503272)))},42060,e=>{e.v(t=>Promise.all(["static/chunks/63e0528672c9261d.js"].map(t=>e.l(t))).then(()=>t(418817)))},646255,e=>{e.v(t=>Promise.all(["static/chunks/c41b751c0d58294f.js"].map(t=>e.l(t))).then(()=>t(509808)))},27402,e=>{e.v(t=>Promise.all(["static/chunks/f56269ce9627e4eb.js"].map(t=>e.l(t))).then(()=>t(609450)))},242317,e=>{e.v(t=>Promise.all(["static/chunks/c25bafba4e65b9d9.js"].map(t=>e.l(t))).then(()=>t(805544)))},189728,e=>{e.v(t=>Promise.all(["static/chunks/1c17bb6d6b722db7.js"].map(t=>e.l(t))).then(()=>t(39234)))},933805,e=>{e.v(t=>Promise.all(["static/chunks/eec4c7518d5ef1b7.js"].map(t=>e.l(t))).then(()=>t(83012)))},306521,e=>{e.v(t=>Promise.all(["static/chunks/c7ea8683df715cf9.js"].map(t=>e.l(t))).then(()=>t(153401)))},529497,e=>{e.v(t=>Promise.all(["static/chunks/e49251e635894a10.js"].map(t=>e.l(t))).then(()=>t(912290)))},821462,e=>{e.v(t=>Promise.all(["static/chunks/faa73acfb705c2af.js"].map(t=>e.l(t))).then(()=>t(81778)))},576367,e=>{e.v(t=>Promise.all(["static/chunks/4047e10b7e0020db.js"].map(t=>e.l(t))).then(()=>t(441939)))},719175,e=>{e.v(t=>Promise.all(["static/chunks/c8d13ffd8cb258f2.js"].map(t=>e.l(t))).then(()=>t(136442)))},585172,e=>{e.v(t=>Promise.all(["static/chunks/af37e47fd05aff94.js"].map(t=>e.l(t))).then(()=>t(376835)))},660404,e=>{e.v(t=>Promise.all(["static/chunks/4923abb4f10984df.js"].map(t=>e.l(t))).then(()=>t(622164)))},656661,e=>{e.v(t=>Promise.all(["static/chunks/9335ff44e74a1319.js"].map(t=>e.l(t))).then(()=>t(677958)))},115985,e=>{e.v(t=>Promise.all(["static/chunks/2f33c53c900a30f0.js"].map(t=>e.l(t))).then(()=>t(263541)))},798562,e=>{e.v(t=>Promise.all(["static/chunks/b7b39b35bc8e37e7.js"].map(t=>e.l(t))).then(()=>t(127098)))},995740,e=>{e.v(t=>Promise.all(["static/chunks/e023d779fabed8ba.js"].map(t=>e.l(t))).then(()=>t(466451)))},392121,e=>{e.v(t=>Promise.all(["static/chunks/bd3f5a87bd76ddf2.js"].map(t=>e.l(t))).then(()=>t(917665)))},954007,e=>{e.v(t=>Promise.all(["static/chunks/28f045a8aea535ed.js"].map(t=>e.l(t))).then(()=>t(685345)))},510739,e=>{e.v(t=>Promise.all(["static/chunks/1ce8b24df6c38238.js"].map(t=>e.l(t))).then(()=>t(922360)))},518349,e=>{e.v(t=>Promise.all(["static/chunks/abff0b62e58a0623.js"].map(t=>e.l(t))).then(()=>t(183250)))},23210,e=>{e.v(t=>Promise.all(["static/chunks/d590609f31b2b6f2.js"].map(t=>e.l(t))).then(()=>t(449291)))},69872,e=>{e.v(t=>Promise.all(["static/chunks/a90386f31e65e7c6.js"].map(t=>e.l(t))).then(()=>t(606784)))},473425,e=>{e.v(t=>Promise.all(["static/chunks/f6ce4ba8446e5b4e.js"].map(t=>e.l(t))).then(()=>t(699844)))},86124,e=>{e.v(t=>Promise.all(["static/chunks/ca0c357681404336.js"].map(t=>e.l(t))).then(()=>t(11252)))},449547,e=>{e.v(t=>Promise.all(["static/chunks/66de8be4c4f97e40.js"].map(t=>e.l(t))).then(()=>t(886888)))},107380,e=>{e.v(t=>Promise.all(["static/chunks/6786c08fb6566531.js"].map(t=>e.l(t))).then(()=>t(31913)))},417532,e=>{e.v(t=>Promise.all(["static/chunks/4c3dd4391186697a.js"].map(t=>e.l(t))).then(()=>t(165607)))},400114,e=>{e.v(t=>Promise.all(["static/chunks/e875ff35e86f2cd4.js"].map(t=>e.l(t))).then(()=>t(839832)))},371013,e=>{e.v(t=>Promise.all(["static/chunks/d5ef2cd1d5f0ce31.js"].map(t=>e.l(t))).then(()=>t(306387)))},592346,e=>{e.v(t=>Promise.all(["static/chunks/0b53bfb3dd94b07e.js"].map(t=>e.l(t))).then(()=>t(905711)))},692886,e=>{e.v(t=>Promise.all(["static/chunks/cc38ee16a99c453d.js"].map(t=>e.l(t))).then(()=>t(288445)))},559568,e=>{e.v(t=>Promise.all(["static/chunks/8893cb0dd5e75428.js"].map(t=>e.l(t))).then(()=>t(52422)))},727099,e=>{e.v(t=>Promise.all(["static/chunks/be85831826444acc.js"].map(t=>e.l(t))).then(()=>t(873099)))},106183,e=>{e.v(t=>Promise.all(["static/chunks/33ac89a1fcda0ac9.js"].map(t=>e.l(t))).then(()=>t(28900)))},276516,e=>{e.v(t=>Promise.all(["static/chunks/1f16ba9408c624e2.js"].map(t=>e.l(t))).then(()=>t(554519)))},526211,e=>{e.v(t=>Promise.all(["static/chunks/398933b68cf253b0.js"].map(t=>e.l(t))).then(()=>t(938626)))},377532,e=>{e.v(t=>Promise.all(["static/chunks/76a249fc4d7468f3.js"].map(t=>e.l(t))).then(()=>t(583927)))},146719,e=>{e.v(t=>Promise.all(["static/chunks/fc0ab7c2b70600a0.js"].map(t=>e.l(t))).then(()=>t(790998)))},343268,e=>{e.v(t=>Promise.all(["static/chunks/59373d2a49f83685.js"].map(t=>e.l(t))).then(()=>t(428068)))},921373,e=>{e.v(t=>Promise.all(["static/chunks/e523dcfe0a640736.js"].map(t=>e.l(t))).then(()=>t(127251)))},114361,e=>{e.v(t=>Promise.all(["static/chunks/1ddd2185911125ed.js"].map(t=>e.l(t))).then(()=>t(198663)))},978898,e=>{e.v(t=>Promise.all(["static/chunks/422223ea541cc4ec.js"].map(t=>e.l(t))).then(()=>t(969846)))},497619,e=>{e.v(t=>Promise.all(["static/chunks/ae8f8bf14344cd0f.js"].map(t=>e.l(t))).then(()=>t(879809)))},99077,e=>{e.v(t=>Promise.all(["static/chunks/4afd407365684745.js"].map(t=>e.l(t))).then(()=>t(706888)))},999971,e=>{e.v(t=>Promise.all(["static/chunks/b9e5b4b0b40b4966.js"].map(t=>e.l(t))).then(()=>t(954962)))},14879,e=>{e.v(t=>Promise.all(["static/chunks/03ed00251b9f8f96.js"].map(t=>e.l(t))).then(()=>t(494536)))},187203,e=>{e.v(t=>Promise.all(["static/chunks/9331bedf749a8b03.js"].map(t=>e.l(t))).then(()=>t(210924)))},517776,e=>{e.v(t=>Promise.all(["static/chunks/3fe1020423119ecd.js"].map(t=>e.l(t))).then(()=>t(705976)))},98067,e=>{e.v(t=>Promise.all(["static/chunks/8ee0a99124a40521.js"].map(t=>e.l(t))).then(()=>t(403692)))},180529,e=>{e.v(t=>Promise.all(["static/chunks/c0ffd2c02e3b49f9.js"].map(t=>e.l(t))).then(()=>t(356216)))},33772,e=>{e.v(t=>Promise.all(["static/chunks/c26fa44e80d4552b.js"].map(t=>e.l(t))).then(()=>t(354159)))},612617,e=>{e.v(t=>Promise.all(["static/chunks/2800c4437d7ec1c8.js"].map(t=>e.l(t))).then(()=>t(981722)))},99078,e=>{e.v(t=>Promise.all(["static/chunks/18b5586311477356.js"].map(t=>e.l(t))).then(()=>t(879190)))},484585,e=>{e.v(t=>Promise.all(["static/chunks/24678d38918cff86.js"].map(t=>e.l(t))).then(()=>t(390585)))},766513,e=>{e.v(t=>Promise.all(["static/chunks/b4f4414200774c70.js"].map(t=>e.l(t))).then(()=>t(856636)))},682754,e=>{e.v(t=>Promise.all(["static/chunks/20a8a0f412961150.js"].map(t=>e.l(t))).then(()=>t(703951)))},219316,e=>{e.v(t=>Promise.all(["static/chunks/5d1a1b0db1f6f280.js"].map(t=>e.l(t))).then(()=>t(961511)))},277176,e=>{e.v(t=>Promise.all(["static/chunks/63b01ab668891c59.js"].map(t=>e.l(t))).then(()=>t(355495)))},560377,e=>{e.v(t=>Promise.all(["static/chunks/a73126aecb5194b1.js"].map(t=>e.l(t))).then(()=>t(699252)))},461996,e=>{e.v(t=>Promise.all(["static/chunks/014ac0ae0eb0d977.js"].map(t=>e.l(t))).then(()=>t(595684)))},760084,e=>{e.v(t=>Promise.all(["static/chunks/3d2cf405c5be67f1.js"].map(t=>e.l(t))).then(()=>t(821645)))},23765,e=>{e.v(t=>Promise.all(["static/chunks/19daf80189af3cb5.js"].map(t=>e.l(t))).then(()=>t(669874)))},669065,e=>{e.v(t=>Promise.all(["static/chunks/39c5ab3d449138ef.js"].map(t=>e.l(t))).then(()=>t(756209)))},137985,e=>{e.v(t=>Promise.all(["static/chunks/a96e5b3c0bcf745a.js"].map(t=>e.l(t))).then(()=>t(862181)))},984531,e=>{e.v(t=>Promise.all(["static/chunks/7e2b21a05f35e2fb.js"].map(t=>e.l(t))).then(()=>t(654201)))},14671,e=>{e.v(t=>Promise.all(["static/chunks/2e833c4f8897d285.js"].map(t=>e.l(t))).then(()=>t(400433)))},661706,e=>{e.v(t=>Promise.all(["static/chunks/9d7994b2925eedff.js"].map(t=>e.l(t))).then(()=>t(406011)))},808545,e=>{e.v(t=>Promise.all(["static/chunks/c12e7e357bd73885.js"].map(t=>e.l(t))).then(()=>t(590802)))},86125,e=>{e.v(t=>Promise.all(["static/chunks/6674dde5fce56b90.js"].map(t=>e.l(t))).then(()=>t(127530)))},25054,e=>{e.v(t=>Promise.all(["static/chunks/5f43b8de108d82a8.js"].map(t=>e.l(t))).then(()=>t(404202)))},189409,e=>{e.v(t=>Promise.all(["static/chunks/04c3bd1cc3433abb.js"].map(t=>e.l(t))).then(()=>t(838366)))},105736,e=>{e.v(t=>Promise.all(["static/chunks/3ab13667b822299a.js"].map(t=>e.l(t))).then(()=>t(511626)))},75220,e=>{e.v(t=>Promise.all(["static/chunks/136b1b881256e27c.js"].map(t=>e.l(t))).then(()=>t(981111)))},164632,e=>{e.v(t=>Promise.all(["static/chunks/27a0455f9ed4cbe2.js"].map(t=>e.l(t))).then(()=>t(235153)))},6768,e=>{e.v(t=>Promise.all(["static/chunks/65b36f3821731273.js"].map(t=>e.l(t))).then(()=>t(614051)))},82206,e=>{e.v(t=>Promise.all(["static/chunks/cd86ccbd9d28ee36.js"].map(t=>e.l(t))).then(()=>t(56751)))},458662,e=>{e.v(t=>Promise.all(["static/chunks/ae5b22bbf1fab4fc.js"].map(t=>e.l(t))).then(()=>t(972606)))},405625,e=>{e.v(t=>Promise.all(["static/chunks/42b23260469ed281.js"].map(t=>e.l(t))).then(()=>t(56717)))}]);