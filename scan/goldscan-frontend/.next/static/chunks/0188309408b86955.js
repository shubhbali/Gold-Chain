(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,950955,e=>{"use strict";var t=e.i(725519),o=e.i(941031),r=e.i(437059),a=e.i(138230),i=e.i(142844),n=e.i(278678),s=e.i(355376),l=e.i(140018),c=e.i(301847),d=e.i(821738);let u={getGasPriceInEther:(e,t)=>Number(t*e)/1e18,getGasPriceInUSD(e,t,o){let a=u.getGasPriceInEther(t,o);return r.NumberUtil.bigNumber(e).times(a).toNumber()},getPriceImpact({sourceTokenAmount:e,sourceTokenPriceInUSD:t,toTokenPriceInUSD:o,toTokenAmount:a}){let i=r.NumberUtil.bigNumber(e).times(t),n=r.NumberUtil.bigNumber(a).times(o);return i.minus(n).div(i).times(100).toNumber()},getMaxSlippage(e,t){let o=r.NumberUtil.bigNumber(e).div(100);return r.NumberUtil.multiply(t,o).toNumber()},getProviderFee:(e,t=.0085)=>r.NumberUtil.bigNumber(e).times(t).toString(),isInsufficientNetworkTokenForGas:(e,t)=>!!r.NumberUtil.bigNumber(e).eq(0)||r.NumberUtil.bigNumber(r.NumberUtil.bigNumber(t||"0")).gt(e),isInsufficientSourceTokenForSwap(e,t,o){let a=o?.find(e=>e.address===t)?.quantity?.numeric;return r.NumberUtil.bigNumber(a||"0").lt(e)}};var p=e.i(869067),m=e.i(596590),w=e.i(525417),h=e.i(746),g=e.i(207176),k=e.i(11961),C=e.i(729702),b=e.i(881936),f=e.i(375054),v=e.i(944396);let y={initializing:!1,initialized:!1,loadingPrices:!1,loadingQuote:!1,loadingApprovalTransaction:!1,loadingBuildTransaction:!1,loadingTransaction:!1,fetchError:!1,approvalTransaction:void 0,swapTransaction:void 0,transactionError:void 0,sourceToken:void 0,sourceTokenAmount:"",sourceTokenPriceInUSD:0,toToken:void 0,toTokenAmount:"",toTokenPriceInUSD:0,networkPrice:"0",networkBalanceInUSD:"0",networkTokenSymbol:"",inputError:void 0,slippage:l.ConstantsUtil.CONVERT_SLIPPAGE_TOLERANCE,tokens:void 0,popularTokens:void 0,suggestedTokens:void 0,foundTokens:void 0,myTokensWithBalance:void 0,tokensPriceMap:{},gasFee:"0",gasPriceInUSD:0,priceImpact:void 0,maxSlippage:void 0,providerFee:void 0},T=(0,t.proxy)({...y}),S={state:T,subscribe:e=>(0,t.subscribe)(T,()=>e(T)),subscribeKey:(e,t)=>(0,o.subscribeKey)(T,e,t),getParams(){let e=g.ChainController.state.activeChain,t=m.AccountController.getCaipAddress(e)??g.ChainController.state.activeCaipAddress,o=c.CoreHelperUtil.getPlainAddress(t),i=(0,s.getActiveNetworkTokenAddress)(),n=C.ConnectorController.getConnectorId(g.ChainController.state.activeChain);if(!o)throw Error("No address found to swap the tokens from.");let l=!T.toToken?.address||!T.toToken?.decimals,d=!T.sourceToken?.address||!T.sourceToken?.decimals||!r.NumberUtil.bigNumber(T.sourceTokenAmount).gt(0),u=!T.sourceTokenAmount;return{networkAddress:i,fromAddress:o,fromCaipAddress:t,sourceTokenAddress:T.sourceToken?.address,toTokenAddress:T.toToken?.address,toTokenAmount:T.toTokenAmount,toTokenDecimals:T.toToken?.decimals,sourceTokenAmount:T.sourceTokenAmount,sourceTokenDecimals:T.sourceToken?.decimals,invalidToToken:l,invalidSourceToken:d,invalidSourceTokenAmount:u,availableToSwap:t&&!l&&!d&&!u,isAuthConnector:n===a.ConstantsUtil.CONNECTOR_ID.AUTH}},setSourceToken(e){if(!e){T.sourceToken=e,T.sourceTokenAmount="",T.sourceTokenPriceInUSD=0;return}T.sourceToken=e,A.setTokenPrice(e.address,"sourceToken")},setSourceTokenAmount(e){T.sourceTokenAmount=e},setToToken(e){if(!e){T.toToken=e,T.toTokenAmount="",T.toTokenPriceInUSD=0;return}T.toToken=e,A.setTokenPrice(e.address,"toToken")},setToTokenAmount(e){T.toTokenAmount=e?r.NumberUtil.toFixed(e,6):""},async setTokenPrice(e,t){let o=T.tokensPriceMap[e]||0;o||(T.loadingPrices=!0,o=await A.getAddressPrice(e)),"sourceToken"===t?T.sourceTokenPriceInUSD=o:"toToken"===t&&(T.toTokenPriceInUSD=o),T.loadingPrices&&(T.loadingPrices=!1),A.getParams().availableToSwap&&A.swapTokens()},switchTokens(){if(T.initializing||!T.initialized)return;let e=T.toToken?{...T.toToken}:void 0,t=T.sourceToken?{...T.sourceToken}:void 0,o=e&&""===T.toTokenAmount?"1":T.toTokenAmount;A.setSourceToken(e),A.setToToken(t),A.setSourceTokenAmount(o),A.setToTokenAmount(""),A.swapTokens()},resetState(){T.myTokensWithBalance=y.myTokensWithBalance,T.tokensPriceMap=y.tokensPriceMap,T.initialized=y.initialized,T.initializing=y.initializing,T.sourceToken=y.sourceToken,T.sourceTokenAmount=y.sourceTokenAmount,T.sourceTokenPriceInUSD=y.sourceTokenPriceInUSD,T.toToken=y.toToken,T.toTokenAmount=y.toTokenAmount,T.toTokenPriceInUSD=y.toTokenPriceInUSD,T.networkPrice=y.networkPrice,T.networkTokenSymbol=y.networkTokenSymbol,T.networkBalanceInUSD=y.networkBalanceInUSD,T.inputError=y.inputError},resetValues(){let{networkAddress:e}=A.getParams(),t=T.tokens?.find(t=>t.address===e);A.setSourceToken(t),A.setToToken(void 0)},getApprovalLoadingState:()=>T.loadingApprovalTransaction,clearError(){T.transactionError=void 0},async initializeState(){if(!T.initializing){if(T.initializing=!0,!T.initialized)try{await A.fetchTokens(),T.initialized=!0}catch(e){T.initialized=!1,v.SnackController.showError("Failed to initialize swap"),f.RouterController.goBack()}T.initializing=!1}},async fetchTokens(){let{networkAddress:e}=A.getParams();await A.getNetworkTokenPrice(),await A.getMyTokensWithBalance();let t=T.myTokensWithBalance?.find(t=>t.address===e);t&&(T.networkTokenSymbol=t.symbol,A.setSourceToken(t),A.setSourceTokenAmount("0"))},async getTokenList(){let e=g.ChainController.state.activeCaipNetwork?.caipNetworkId;if(T.caipNetworkId!==e||!T.tokens)try{T.tokensLoading=!0;let t=await d.SwapApiUtil.getTokenList(e);T.tokens=t,T.caipNetworkId=e,T.popularTokens=t.sort((e,t)=>e.symbol<t.symbol?-1:+(e.symbol>t.symbol)),T.suggestedTokens=t.filter(e=>!!l.ConstantsUtil.SWAP_SUGGESTED_TOKENS.includes(e.symbol))}catch(e){T.tokens=[],T.popularTokens=[],T.suggestedTokens=[]}finally{T.tokensLoading=!1}},async getAddressPrice(e){let t=T.tokensPriceMap[e];if(t)return t;let o=await h.BlockchainApiController.fetchTokenPrice({addresses:[e]}),r=o?.fungibles||[],a=[...T.tokens||[],...T.myTokensWithBalance||[]],i=a?.find(t=>t.address===e)?.symbol,n=parseFloat((r.find(e=>e.symbol.toLowerCase()===i?.toLowerCase())?.price||0).toString());return T.tokensPriceMap[e]=n,n},async getNetworkTokenPrice(){let{networkAddress:e}=A.getParams(),t=await h.BlockchainApiController.fetchTokenPrice({addresses:[e]}).catch(()=>(v.SnackController.showError("Failed to fetch network token price"),{fungibles:[]})),o=t.fungibles?.[0],r=o?.price.toString()||"0";T.tokensPriceMap[e]=parseFloat(r),T.networkTokenSymbol=o?.symbol||"",T.networkPrice=r},async getMyTokensWithBalance(e){let t=await n.BalanceUtil.getMyTokensWithBalance(e),o=d.SwapApiUtil.mapBalancesToSwapTokens(t);o&&(await A.getInitialGasPrice(),A.setBalances(o))},setBalances(e){let{networkAddress:t}=A.getParams(),o=g.ChainController.state.activeCaipNetwork;if(!o)return;let a=e.find(e=>e.address===t);e.forEach(e=>{T.tokensPriceMap[e.address]=e.price||0}),T.myTokensWithBalance=e.filter(e=>e.address.startsWith(o.caipNetworkId)),T.networkBalanceInUSD=a?r.NumberUtil.multiply(a.quantity.numeric,a.price).toString():"0"},async getInitialGasPrice(){let e=await d.SwapApiUtil.fetchGasPrice();if(!e)return{gasPrice:null,gasPriceInUSD:null};switch(g.ChainController.state?.activeCaipNetwork?.chainNamespace){case a.ConstantsUtil.CHAIN.SOLANA:return T.gasFee=e.standard??"0",T.gasPriceInUSD=r.NumberUtil.multiply(e.standard,T.networkPrice).div(1e9).toNumber(),{gasPrice:BigInt(T.gasFee),gasPriceInUSD:Number(T.gasPriceInUSD)};case a.ConstantsUtil.CHAIN.EVM:default:let t=e.standard??"0",o=BigInt(t),i=BigInt(15e4),n=u.getGasPriceInUSD(T.networkPrice,i,o);return T.gasFee=t,T.gasPriceInUSD=n,{gasPrice:o,gasPriceInUSD:n}}},async swapTokens(){let e=m.AccountController.state.address,t=T.sourceToken,o=T.toToken,a=r.NumberUtil.bigNumber(T.sourceTokenAmount).gt(0);if(a||A.setToTokenAmount(""),!o||!t||T.loadingPrices||!a)return;T.loadingQuote=!0;let i=r.NumberUtil.bigNumber(T.sourceTokenAmount).times(10**t.decimals).round(0);try{let a=await h.BlockchainApiController.fetchSwapQuote({userAddress:e,from:t.address,to:o.address,gasPrice:T.gasFee,amount:i.toString()});T.loadingQuote=!1;let n=a?.quotes?.[0]?.toAmount;if(!n)return void w.AlertController.open({displayMessage:"Incorrect amount",debugMessage:"Please enter a valid amount"},"error");let s=r.NumberUtil.bigNumber(n).div(10**o.decimals).toString();A.setToTokenAmount(s),A.hasInsufficientToken(T.sourceTokenAmount,t.address)?T.inputError="Insufficient balance":(T.inputError=void 0,A.setTransactionDetails())}catch(e){T.loadingQuote=!1,T.inputError="Insufficient balance"}},async getTransaction(){let{fromCaipAddress:e,availableToSwap:t}=A.getParams(),o=T.sourceToken,r=T.toToken;if(e&&t&&o&&r&&!T.loadingQuote)try{let t;return T.loadingBuildTransaction=!0,t=await d.SwapApiUtil.fetchSwapAllowance({userAddress:e,tokenAddress:o.address,sourceTokenAmount:T.sourceTokenAmount,sourceTokenDecimals:o.decimals})?await A.createSwapTransaction():await A.createAllowanceTransaction(),T.loadingBuildTransaction=!1,T.fetchError=!1,t}catch(e){f.RouterController.goBack(),v.SnackController.showError("Failed to check allowance"),T.loadingBuildTransaction=!1,T.approvalTransaction=void 0,T.swapTransaction=void 0,T.fetchError=!0;return}},async createAllowanceTransaction(){let{fromCaipAddress:e,sourceTokenAddress:t,toTokenAddress:o}=A.getParams();if(e&&o){if(!t)throw Error("createAllowanceTransaction - No source token address found.");try{let r=await h.BlockchainApiController.generateApproveCalldata({from:t,to:o,userAddress:e}),a=c.CoreHelperUtil.getPlainAddress(r.tx.from);if(!a)throw Error("SwapController:createAllowanceTransaction - address is required");let i={data:r.tx.data,to:a,gasPrice:BigInt(r.tx.eip155.gasPrice),value:BigInt(r.tx.value),toAmount:T.toTokenAmount};return T.swapTransaction=void 0,T.approvalTransaction={data:i.data,to:i.to,gasPrice:i.gasPrice,value:i.value,toAmount:i.toAmount},{data:i.data,to:i.to,gasPrice:i.gasPrice,value:i.value,toAmount:i.toAmount}}catch(e){f.RouterController.goBack(),v.SnackController.showError("Failed to create approval transaction"),T.approvalTransaction=void 0,T.swapTransaction=void 0,T.fetchError=!0;return}}},async createSwapTransaction(){let{networkAddress:e,fromCaipAddress:t,sourceTokenAmount:o}=A.getParams(),r=T.sourceToken,a=T.toToken;if(!t||!o||!r||!a)return;let i=k.ConnectionController.parseUnits(o,r.decimals)?.toString();try{let o=await h.BlockchainApiController.generateSwapCalldata({userAddress:t,from:r.address,to:a.address,amount:i,disableEstimate:!0}),n=r.address===e,s=BigInt(o.tx.eip155.gas),l=BigInt(o.tx.eip155.gasPrice),d=c.CoreHelperUtil.getPlainAddress(o.tx.to);if(!d)throw Error("SwapController:createSwapTransaction - address is required");let p={data:o.tx.data,to:d,gas:s,gasPrice:l,value:n?BigInt(i??"0"):BigInt("0"),toAmount:T.toTokenAmount};return T.gasPriceInUSD=u.getGasPriceInUSD(T.networkPrice,s,l),T.approvalTransaction=void 0,T.swapTransaction=p,p}catch(e){f.RouterController.goBack(),v.SnackController.showError("Failed to create transaction"),T.approvalTransaction=void 0,T.swapTransaction=void 0,T.fetchError=!0;return}},onEmbeddedWalletApprovalSuccess(){v.SnackController.showLoading("Approve limit increase in your wallet"),f.RouterController.replace("SwapPreview")},async sendTransactionForApproval(e){let{fromAddress:t,isAuthConnector:o}=A.getParams();T.loadingApprovalTransaction=!0,o?f.RouterController.pushTransactionStack({onSuccess:A.onEmbeddedWalletApprovalSuccess}):v.SnackController.showLoading("Approve limit increase in your wallet");try{await k.ConnectionController.sendTransaction({address:t,to:e.to,data:e.data,value:e.value,chainNamespace:a.ConstantsUtil.CHAIN.EVM}),await A.swapTokens(),await A.getTransaction(),T.approvalTransaction=void 0,T.loadingApprovalTransaction=!1}catch(e){T.transactionError=e?.displayMessage,T.loadingApprovalTransaction=!1,v.SnackController.showError(e?.displayMessage||"Transaction error"),b.EventsController.sendEvent({type:"track",event:"SWAP_APPROVAL_ERROR",properties:{message:e?.displayMessage||e?.message||"Unknown",network:g.ChainController.state.activeCaipNetwork?.caipNetworkId||"",swapFromToken:A.state.sourceToken?.symbol||"",swapToToken:A.state.toToken?.symbol||"",swapFromAmount:A.state.sourceTokenAmount||"",swapToAmount:A.state.toTokenAmount||"",isSmartAccount:(0,s.getPreferredAccountType)(a.ConstantsUtil.CHAIN.EVM)===i.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT}})}},async sendTransactionForSwap(e){if(!e)return;let{fromAddress:t,toTokenAmount:o,isAuthConnector:n}=A.getParams();T.loadingTransaction=!0;let l=`Swapping ${T.sourceToken?.symbol} to ${r.NumberUtil.formatNumberToLocalString(o,3)} ${T.toToken?.symbol}`,c=`Swapped ${T.sourceToken?.symbol} to ${r.NumberUtil.formatNumberToLocalString(o,3)} ${T.toToken?.symbol}`;n?f.RouterController.pushTransactionStack({onSuccess(){f.RouterController.replace("Account"),v.SnackController.showLoading(l),S.resetState()}}):v.SnackController.showLoading("Confirm transaction in your wallet");try{let o=[T.sourceToken?.address,T.toToken?.address].join(","),r=await k.ConnectionController.sendTransaction({address:t,to:e.to,data:e.data,value:e.value,chainNamespace:a.ConstantsUtil.CHAIN.EVM});return T.loadingTransaction=!1,v.SnackController.showSuccess(c),b.EventsController.sendEvent({type:"track",event:"SWAP_SUCCESS",properties:{network:g.ChainController.state.activeCaipNetwork?.caipNetworkId||"",swapFromToken:A.state.sourceToken?.symbol||"",swapToToken:A.state.toToken?.symbol||"",swapFromAmount:A.state.sourceTokenAmount||"",swapToAmount:A.state.toTokenAmount||"",isSmartAccount:(0,s.getPreferredAccountType)(a.ConstantsUtil.CHAIN.EVM)===i.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT}}),S.resetState(),n||f.RouterController.replace("Account"),S.getMyTokensWithBalance(o),r}catch(e){T.transactionError=e?.displayMessage,T.loadingTransaction=!1,v.SnackController.showError(e?.displayMessage||"Transaction error"),b.EventsController.sendEvent({type:"track",event:"SWAP_ERROR",properties:{message:e?.displayMessage||e?.message||"Unknown",network:g.ChainController.state.activeCaipNetwork?.caipNetworkId||"",swapFromToken:A.state.sourceToken?.symbol||"",swapToToken:A.state.toToken?.symbol||"",swapFromAmount:A.state.sourceTokenAmount||"",swapToAmount:A.state.toTokenAmount||"",isSmartAccount:(0,s.getPreferredAccountType)(a.ConstantsUtil.CHAIN.EVM)===i.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT}});return}},hasInsufficientToken:(e,t)=>u.isInsufficientSourceTokenForSwap(e,t,T.myTokensWithBalance),setTransactionDetails(){let{toTokenAddress:e,toTokenDecimals:t}=A.getParams();e&&t&&(T.gasPriceInUSD=u.getGasPriceInUSD(T.networkPrice,BigInt(T.gasFee),BigInt(15e4)),T.priceImpact=u.getPriceImpact({sourceTokenAmount:T.sourceTokenAmount,sourceTokenPriceInUSD:T.sourceTokenPriceInUSD,toTokenPriceInUSD:T.toTokenPriceInUSD,toTokenAmount:T.toTokenAmount}),T.maxSlippage=u.getMaxSlippage(T.slippage,T.toTokenAmount),T.providerFee=u.getProviderFee(T.sourceTokenAmount))}},A=(0,p.withErrorBoundary)(S);e.s(["SwapController",0,A],950955)},443237,e=>{"use strict";e.i(588984);var t=e.i(399702),o=e.i(872857);e.i(759703);var r=e.i(392074),a=e.i(698797);e.i(781840);var i=e.i(86988),n=e.i(138230),s=e.i(222328),l=e.i(665545),c=e.i(207176),d=e.i(729702),u=e.i(301847),p=e.i(945182),m=e.i(11961),w=e.i(375054),h=e.i(43844);let g={isUnsupportedChainView:()=>"UnsupportedChain"===w.RouterController.state.view||"SwitchNetwork"===w.RouterController.state.view&&w.RouterController.state.history.includes("UnsupportedChain"),async safeClose(){this.isUnsupportedChainView()||await h.SIWXUtil.isSIWXCloseDisabled()?p.ModalController.shake():(("DataCapture"===w.RouterController.state.view||"DataCaptureOtpConfirm"===w.RouterController.state.view)&&m.ConnectionController.disconnect(),p.ModalController.close())}};var k=e.i(944411),C=e.i(944396),b=e.i(950955),f=e.i(880985);e.i(302184);var v=e.i(34691),y=e.i(938559),T=e.i(864429),S=t,A=e.i(118827);let x=A.css`
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
`,P=class extends S.LitElement{render(){return o.html`<slot></slot>`}};P.styles=[T.resetStyles,x],P=function(e,t,o,r){var a,i=arguments.length,n=i<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,o):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)n=Reflect.decorate(e,t,o,r);else for(var s=e.length-1;s>=0;s--)(a=e[s])&&(n=(i<3?a(n):i>3?a(t,o,n):a(t,o))||n);return i>3&&n&&Object.defineProperty(t,o,n),n}([(0,y.customElement)("wui-card")],P),e.i(237029);var N=t,E=e.i(525417),I=t;e.i(630572),e.i(596548),e.i(108476);let U=A.css`
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
`;var R=function(e,t,o,r){var a,i=arguments.length,n=i<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,o):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)n=Reflect.decorate(e,t,o,r);else for(var s=e.length-1;s>=0;s--)(a=e[s])&&(n=(i<3?a(n):i>3?a(t,o,n):a(t,o))||n);return i>3&&n&&Object.defineProperty(t,o,n),n};let B=class extends I.LitElement{constructor(){super(...arguments),this.message="",this.backgroundColor="accent-100",this.iconColor="accent-100",this.icon="info"}render(){return this.style.cssText=`
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
    `}onClose(){E.AlertController.close()}};B.styles=[T.resetStyles,U],R([(0,r.property)()],B.prototype,"message",void 0),R([(0,r.property)()],B.prototype,"backgroundColor",void 0),R([(0,r.property)()],B.prototype,"iconColor",void 0),R([(0,r.property)()],B.prototype,"icon",void 0),B=R([(0,y.customElement)("wui-alertbar")],B);let W=A.css`
  :host {
    display: block;
    position: absolute;
    top: var(--wui-spacing-s);
    left: var(--wui-spacing-l);
    right: var(--wui-spacing-l);
    opacity: 0;
    pointer-events: none;
  }
`;var D=function(e,t,o,r){var a,i=arguments.length,n=i<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,o):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)n=Reflect.decorate(e,t,o,r);else for(var s=e.length-1;s>=0;s--)(a=e[s])&&(n=(i<3?a(n):i>3?a(t,o,n):a(t,o))||n);return i>3&&n&&Object.defineProperty(t,o,n),n};let O={info:{backgroundColor:"fg-350",iconColor:"fg-325",icon:"info"},success:{backgroundColor:"success-glass-reown-020",iconColor:"success-125",icon:"checkmark"},warning:{backgroundColor:"warning-glass-reown-020",iconColor:"warning-100",icon:"warningCircle"},error:{backgroundColor:"error-glass-reown-020",iconColor:"error-125",icon:"exclamationTriangle"}},$=class extends N.LitElement{constructor(){super(),this.unsubscribe=[],this.open=E.AlertController.state.open,this.onOpen(!0),this.unsubscribe.push(E.AlertController.subscribeKey("open",e=>{this.open=e,this.onOpen(!1)}))}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}render(){let{message:e,variant:t}=E.AlertController.state,r=O[t];return o.html`
      <wui-alertbar
        message=${e}
        backgroundColor=${r?.backgroundColor}
        iconColor=${r?.iconColor}
        icon=${r?.icon}
      ></wui-alertbar>
    `}onOpen(e){this.open?(this.animate([{opacity:0,transform:"scale(0.85)"},{opacity:1,transform:"scale(1)"}],{duration:150,fill:"forwards",easing:"ease"}),this.style.cssText="pointer-events: auto"):e||(this.animate([{opacity:1,transform:"scale(1)"},{opacity:0,transform:"scale(0.85)"}],{duration:150,fill:"forwards",easing:"ease"}),this.style.cssText="pointer-events: none")}};$.styles=W,D([(0,a.state)()],$.prototype,"open",void 0),$=D([(0,y.customElement)("w3m-alertbar")],$);var M=t,L=e.i(596590),F=e.i(689783),z=e.i(589408),j=e.i(881936);e.i(679556);var H=t;e.i(287940),e.i(839432);let K=A.css`
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
`;var _=function(e,t,o,r){var a,i=arguments.length,n=i<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,o):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)n=Reflect.decorate(e,t,o,r);else for(var s=e.length-1;s>=0;s--)(a=e[s])&&(n=(i<3?a(n):i>3?a(t,o,n):a(t,o))||n);return i>3&&n&&Object.defineProperty(t,o,n),n};let G=class extends H.LitElement{constructor(){super(...arguments),this.imageSrc=""}render(){return o.html`<button>
      ${this.imageTemplate()}
      <wui-icon size="xs" color="fg-200" name="chevronBottom"></wui-icon>
    </button>`}imageTemplate(){return this.imageSrc?o.html`<wui-image src=${this.imageSrc} alt="select visual"></wui-image>`:o.html`<wui-icon-box
      size="xxs"
      iconColor="fg-200"
      backgroundColor="fg-100"
      background="opaque"
      icon="networkPlaceholder"
    ></wui-icon-box>`}};G.styles=[T.resetStyles,T.elementStyles,T.colorStyles,K],_([(0,r.property)()],G.prototype,"imageSrc",void 0),G=_([(0,y.customElement)("wui-select")],G),e.i(990237),e.i(331658);var V=e.i(924487);let Y=A.css`
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
`;var q=function(e,t,o,r){var a,i=arguments.length,n=i<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,o):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)n=Reflect.decorate(e,t,o,r);else for(var s=e.length-1;s>=0;s--)(a=e[s])&&(n=(i<3?a(n):i>3?a(t,o,n):a(t,o))||n);return i>3&&n&&Object.defineProperty(t,o,n),n};let X=["SmartSessionList"];function Q(){let e=w.RouterController.state.data?.connector?.name,t=w.RouterController.state.data?.wallet?.name,o=w.RouterController.state.data?.network?.name,r=t??e,a=d.ConnectorController.getConnectors(),i=1===a.length&&a[0]?.id==="w3m-email";return{Connect:`Connect ${i?"Email":""} Wallet`,Create:"Create Wallet",ChooseAccountName:void 0,Account:void 0,AccountSettings:void 0,AllWallets:"All Wallets",ApproveTransaction:"Approve Transaction",BuyInProgress:"Buy",ConnectingExternal:r??"Connect Wallet",ConnectingWalletConnect:r??"WalletConnect",ConnectingWalletConnectBasic:"WalletConnect",ConnectingSiwe:"Sign In",Convert:"Convert",ConvertSelectToken:"Select token",ConvertPreview:"Preview convert",Downloads:r?`Get ${r}`:"Downloads",EmailLogin:"Email Login",EmailVerifyOtp:"Confirm Email",EmailVerifyDevice:"Register Device",GetWallet:"Get a wallet",Networks:"Choose Network",OnRampProviders:"Choose Provider",OnRampActivity:"Activity",OnRampTokenSelect:"Select Token",OnRampFiatSelect:"Select Currency",Pay:"How you pay",ProfileWallets:"Wallets",SwitchNetwork:o??"Switch Network",Transactions:"Activity",UnsupportedChain:"Switch Network",UpgradeEmailWallet:"Upgrade your Wallet",UpdateEmailWallet:"Edit Email",UpdateEmailPrimaryOtp:"Confirm Current Email",UpdateEmailSecondaryOtp:"Confirm New Email",WhatIsABuy:"What is Buy?",RegisterAccountName:"Choose name",RegisterAccountNameSuccess:"",WalletReceive:"Receive",WalletCompatibleNetworks:"Compatible Networks",Swap:"Swap",SwapSelectToken:"Select token",SwapPreview:"Preview swap",WalletSend:"Send",WalletSendPreview:"Review send",WalletSendSelectToken:"Select Token",WhatIsANetwork:"What is a network?",WhatIsAWallet:"What is a wallet?",ConnectWallets:"Connect wallet",ConnectSocials:"All socials",ConnectingSocial:L.AccountController.state.socialProvider?L.AccountController.state.socialProvider:"Connect Social",ConnectingMultiChain:"Select chain",ConnectingFarcaster:"Farcaster",SwitchActiveChain:"Switch chain",SmartSessionCreated:void 0,SmartSessionList:"Smart Sessions",SIWXSignMessage:"Sign In",PayLoading:"Payment in progress",DataCapture:"Profile",DataCaptureOtpConfirm:"Confirm Email",FundWallet:"Fund wallet",PayWithExchange:"Deposit from an exchange"}}let J=class extends M.LitElement{constructor(){super(),this.unsubscribe=[],this.heading=Q()[w.RouterController.state.view],this.network=c.ChainController.state.activeCaipNetwork,this.networkImage=z.AssetUtil.getNetworkImage(this.network),this.showBack=!1,this.prevHistoryLength=1,this.view=w.RouterController.state.view,this.viewDirection="",this.headerText=Q()[w.RouterController.state.view],this.unsubscribe.push(F.AssetController.subscribeNetworkImages(()=>{this.networkImage=z.AssetUtil.getNetworkImage(this.network)}),w.RouterController.subscribeKey("view",e=>{setTimeout(()=>{this.view=e,this.headerText=Q()[e]},V.ConstantsUtil.ANIMATION_DURATIONS.HeaderText),this.onViewChange(),this.onHistoryChange()}),c.ChainController.subscribeKey("activeCaipNetwork",e=>{this.network=e,this.networkImage=z.AssetUtil.getNetworkImage(this.network)}))}disconnectCallback(){this.unsubscribe.forEach(e=>e())}render(){return o.html`
      <wui-flex .padding=${this.getPadding()} justifyContent="space-between" alignItems="center">
        ${this.leftHeaderTemplate()} ${this.titleTemplate()} ${this.rightHeaderTemplate()}
      </wui-flex>
    `}onWalletHelp(){j.EventsController.sendEvent({type:"track",event:"CLICK_WALLET_HELP"}),w.RouterController.push("WhatIsAWallet")}async onClose(){await g.safeClose()}rightHeaderTemplate(){let e=k.OptionsController?.state?.features?.smartSessions;return"Account"===w.RouterController.state.view&&e?o.html`<wui-flex>
      <wui-icon-link
        icon="clock"
        @click=${()=>w.RouterController.push("SmartSessionList")}
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
    `}leftHeaderTemplate(){let{view:e}=w.RouterController.state,t="Connect"===e,r=k.OptionsController.state.enableEmbedded,a=k.OptionsController.state.enableNetworkSwitch;return"Account"===e&&a?o.html`<wui-select
        id="dynamic"
        data-testid="w3m-account-select-network"
        active-network=${(0,i.ifDefined)(this.network?.name)}
        @click=${this.onNetworks.bind(this)}
        imageSrc=${(0,i.ifDefined)(this.networkImage)}
      ></wui-select>`:this.showBack&&!("ApproveTransaction"===e||"ConnectingSiwe"===e||t&&r)?o.html`<wui-icon-link
        data-testid="header-back"
        id="dynamic"
        icon="chevronLeft"
        @click=${this.onGoBack.bind(this)}
      ></wui-icon-link>`:o.html`<wui-icon-link
      data-hidden=${!t}
      id="dynamic"
      icon="helpCircle"
      @click=${this.onWalletHelp.bind(this)}
    ></wui-icon-link>`}onNetworks(){this.isAllowedNetworkSwitch()&&(j.EventsController.sendEvent({type:"track",event:"CLICK_NETWORKS"}),w.RouterController.push("Networks"))}isAllowedNetworkSwitch(){let e=c.ChainController.getAllRequestedCaipNetworks(),t=!!e&&e.length>1,o=e?.find(({id:e})=>e===this.network?.id);return t||!o}getPadding(){return this.heading?["l","2l","l","2l"]:["0","2l","0","2l"]}onViewChange(){let{history:e}=w.RouterController.state,t=V.ConstantsUtil.VIEW_DIRECTION.Next;e.length<this.prevHistoryLength&&(t=V.ConstantsUtil.VIEW_DIRECTION.Prev),this.prevHistoryLength=e.length,this.viewDirection=t}async onHistoryChange(){let{history:e}=w.RouterController.state,t=this.shadowRoot?.querySelector("#dynamic");e.length>1&&!this.showBack&&t?(await t.animate([{opacity:1},{opacity:0}],{duration:200,fill:"forwards",easing:"ease"}).finished,this.showBack=!0,t.animate([{opacity:0},{opacity:1}],{duration:200,fill:"forwards",easing:"ease"})):e.length<=1&&this.showBack&&t&&(await t.animate([{opacity:1},{opacity:0}],{duration:200,fill:"forwards",easing:"ease"}).finished,this.showBack=!1,t.animate([{opacity:0},{opacity:1}],{duration:200,fill:"forwards",easing:"ease"}))}onGoBack(){w.RouterController.goBack()}};J.styles=Y,q([(0,a.state)()],J.prototype,"heading",void 0),q([(0,a.state)()],J.prototype,"network",void 0),q([(0,a.state)()],J.prototype,"networkImage",void 0),q([(0,a.state)()],J.prototype,"showBack",void 0),q([(0,a.state)()],J.prototype,"prevHistoryLength",void 0),q([(0,a.state)()],J.prototype,"view",void 0),q([(0,a.state)()],J.prototype,"viewDirection",void 0),q([(0,a.state)()],J.prototype,"headerText",void 0),J=q([(0,y.customElement)("w3m-header")],J);var Z=t,ee=t;e.i(829162);let et=A.css`
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
`;var eo=function(e,t,o,r){var a,i=arguments.length,n=i<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,o):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)n=Reflect.decorate(e,t,o,r);else for(var s=e.length-1;s>=0;s--)(a=e[s])&&(n=(i<3?a(n):i>3?a(t,o,n):a(t,o))||n);return i>3&&n&&Object.defineProperty(t,o,n),n};let er=class extends ee.LitElement{constructor(){super(...arguments),this.backgroundColor="accent-100",this.iconColor="accent-100",this.icon="checkmark",this.message="",this.loading=!1,this.iconType="default"}render(){return o.html`
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
    ></wui-icon-box>`}};er.styles=[T.resetStyles,et],eo([(0,r.property)()],er.prototype,"backgroundColor",void 0),eo([(0,r.property)()],er.prototype,"iconColor",void 0),eo([(0,r.property)()],er.prototype,"icon",void 0),eo([(0,r.property)()],er.prototype,"message",void 0),eo([(0,r.property)()],er.prototype,"loading",void 0),eo([(0,r.property)()],er.prototype,"iconType",void 0),er=eo([(0,y.customElement)("wui-snackbar")],er);let ea=A.css`
  :host {
    display: block;
    position: absolute;
    opacity: 0;
    pointer-events: none;
    top: 11px;
    left: 50%;
    width: max-content;
  }
`;var ei=function(e,t,o,r){var a,i=arguments.length,n=i<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,o):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)n=Reflect.decorate(e,t,o,r);else for(var s=e.length-1;s>=0;s--)(a=e[s])&&(n=(i<3?a(n):i>3?a(t,o,n):a(t,o))||n);return i>3&&n&&Object.defineProperty(t,o,n),n};let en={loading:void 0,success:{backgroundColor:"success-100",iconColor:"success-100",icon:"checkmark"},error:{backgroundColor:"error-100",iconColor:"error-100",icon:"close"}},es=class extends Z.LitElement{constructor(){super(),this.unsubscribe=[],this.timeout=void 0,this.open=C.SnackController.state.open,this.unsubscribe.push(C.SnackController.subscribeKey("open",e=>{this.open=e,this.onOpen()}))}disconnectedCallback(){clearTimeout(this.timeout),this.unsubscribe.forEach(e=>e())}render(){let{message:e,variant:t,svg:r}=C.SnackController.state,a=en[t],{icon:i,iconColor:n}=r??a??{};return o.html`
      <wui-snackbar
        message=${e}
        backgroundColor=${a?.backgroundColor}
        iconColor=${n}
        icon=${i}
        .loading=${"loading"===t}
      ></wui-snackbar>
    `}onOpen(){clearTimeout(this.timeout),this.open?(this.animate([{opacity:0,transform:"translateX(-50%) scale(0.85)"},{opacity:1,transform:"translateX(-50%) scale(1)"}],{duration:150,fill:"forwards",easing:"ease"}),this.timeout&&clearTimeout(this.timeout),C.SnackController.state.autoClose&&(this.timeout=setTimeout(()=>C.SnackController.hide(),2500))):this.animate([{opacity:1,transform:"translateX(-50%) scale(1)"},{opacity:0,transform:"translateX(-50%) scale(0.85)"}],{duration:150,fill:"forwards",easing:"ease"})}};es.styles=ea,ei([(0,a.state)()],es.prototype,"open",void 0),es=ei([(0,y.customElement)("w3m-snackbar")],es),e.i(641912),e.i(474025);let el=A.css`
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
`;var ec=function(e,t,o,r){var a,i=arguments.length,n=i<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,o):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)n=Reflect.decorate(e,t,o,r);else for(var s=e.length-1;s>=0;s--)(a=e[s])&&(n=(i<3?a(n):i>3?a(t,o,n):a(t,o))||n);return i>3&&n&&Object.defineProperty(t,o,n),n};let ed="scroll-lock";class eu extends t.LitElement{constructor(){super(),this.unsubscribe=[],this.abortController=void 0,this.hasPrefetched=!1,this.enableEmbedded=k.OptionsController.state.enableEmbedded,this.open=p.ModalController.state.open,this.caipAddress=c.ChainController.state.activeCaipAddress,this.caipNetwork=c.ChainController.state.activeCaipNetwork,this.shake=p.ModalController.state.shake,this.filterByNamespace=d.ConnectorController.state.filterByNamespace,this.initializeTheming(),l.ApiController.prefetchAnalyticsConfig(),this.unsubscribe.push(p.ModalController.subscribeKey("open",e=>e?this.onOpen():this.onClose()),p.ModalController.subscribeKey("shake",e=>this.shake=e),c.ChainController.subscribeKey("activeCaipNetwork",e=>this.onNewNetwork(e)),c.ChainController.subscribeKey("activeCaipAddress",e=>this.onNewAddress(e)),k.OptionsController.subscribeKey("enableEmbedded",e=>this.enableEmbedded=e),d.ConnectorController.subscribeKey("filterByNamespace",e=>{this.filterByNamespace===e||c.ChainController.getAccountData(e)?.caipAddress||(l.ApiController.fetchRecommendedWallets(),this.filterByNamespace=e)}))}firstUpdated(){if(this.caipAddress){if(this.enableEmbedded){p.ModalController.close(),this.prefetch();return}this.onNewAddress(this.caipAddress)}this.open&&this.onOpen(),this.enableEmbedded&&this.prefetch()}disconnectedCallback(){this.unsubscribe.forEach(e=>e()),this.onRemoveKeyboardListener()}render(){return(this.style.cssText=`
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
    </wui-card>`}async onOverlayClick(e){e.target===e.currentTarget&&await this.handleClose()}async handleClose(){await g.safeClose()}initializeTheming(){let{themeVariables:e,themeMode:t}=f.ThemeController.state,o=v.UiHelperUtil.getColorTheme(t);(0,T.initializeTheming)(e,o)}onClose(){this.open=!1,this.classList.remove("open"),this.onScrollUnlock(),C.SnackController.hide(),this.onRemoveKeyboardListener()}onOpen(){this.open=!0,this.classList.add("open"),this.onScrollLock(),this.onAddKeyboardListener()}onScrollLock(){let e=document.createElement("style");e.dataset.w3m=ed,e.textContent=`
      body {
        touch-action: none;
        overflow: hidden;
        overscroll-behavior: contain;
      }
      w3m-modal {
        pointer-events: auto;
      }
    `,document.head.appendChild(e)}onScrollUnlock(){let e=document.head.querySelector(`style[data-w3m="${ed}"]`);e&&e.remove()}onAddKeyboardListener(){this.abortController=new AbortController;let e=this.shadowRoot?.querySelector("wui-card");e?.focus(),window.addEventListener("keydown",t=>{if("Escape"===t.key)this.handleClose();else if("Tab"===t.key){let{tagName:o}=t.target;!o||o.includes("W3M-")||o.includes("WUI-")||e?.focus()}},this.abortController)}onRemoveKeyboardListener(){this.abortController?.abort(),this.abortController=void 0}async onNewAddress(e){let t=c.ChainController.state.isSwitchingNamespace,o="ProfileWallets"===w.RouterController.state.view;e?await this.onConnected({caipAddress:e,isSwitchingNamespace:t,isInProfileView:o}):t||this.enableEmbedded||o||p.ModalController.close(),await h.SIWXUtil.initializeIfEnabled(e),this.caipAddress=e,c.ChainController.setIsSwitchingNamespace(!1)}async onConnected(e){if(e.isInProfileView)return;let{chainNamespace:t,chainId:o,address:r}=s.ParseUtil.parseCaipAddress(e.caipAddress),a=`${t}:${o}`,i=!u.CoreHelperUtil.getPlainAddress(this.caipAddress),n=await h.SIWXUtil.getSessions({address:r,caipNetworkId:a}),l=!h.SIWXUtil.getSIWX()||n.some(e=>e.data.accountAddress===r),c=e.isSwitchingNamespace&&l&&!this.enableEmbedded,d=this.enableEmbedded&&i;c?w.RouterController.goBack():d&&p.ModalController.close()}onNewNetwork(e){let t=this.caipNetwork,o=t?.caipNetworkId?.toString(),r=t?.chainNamespace,a=e?.caipNetworkId?.toString(),i=e?.chainNamespace,s=o!==a,l=t?.name===n.ConstantsUtil.UNSUPPORTED_NETWORK_NAME,d="ConnectingExternal"===w.RouterController.state.view,u="ProfileWallets"===w.RouterController.state.view,m=!c.ChainController.getAccountData(e?.chainNamespace)?.caipAddress,h="UnsupportedChain"===w.RouterController.state.view,g=p.ModalController.state.open,k=!1;this.enableEmbedded&&"SwitchNetwork"===w.RouterController.state.view&&(k=!0),s&&b.SwapController.resetState(),g&&!d&&!u&&(m?s&&(k=!0):h?k=!0:s&&r===i&&!l&&(k=!0)),k&&"SIWXSignMessage"!==w.RouterController.state.view&&w.RouterController.goBack(),this.caipNetwork=e}prefetch(){this.hasPrefetched||(l.ApiController.prefetch(),l.ApiController.fetchWalletsByPage({page:1}),this.hasPrefetched=!0)}}eu.styles=el,ec([(0,r.property)({type:Boolean})],eu.prototype,"enableEmbedded",void 0),ec([(0,a.state)()],eu.prototype,"open",void 0),ec([(0,a.state)()],eu.prototype,"caipAddress",void 0),ec([(0,a.state)()],eu.prototype,"caipNetwork",void 0),ec([(0,a.state)()],eu.prototype,"shake",void 0),ec([(0,a.state)()],eu.prototype,"filterByNamespace",void 0);let ep=class extends eu{};ep=ec([(0,y.customElement)("w3m-modal")],ep);let em=class extends eu{};em=ec([(0,y.customElement)("appkit-modal")],em),e.s(["AppKitModal",()=>em,"W3mModal",()=>ep,"W3mModalBase",()=>eu],83332),e.s([],880287),e.i(880287),e.i(83332),e.s(["AppKitModal",()=>em,"W3mModal",()=>ep,"W3mModalBase",()=>eu],443237)}]);