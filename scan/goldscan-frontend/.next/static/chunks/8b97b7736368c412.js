(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,950955,e=>{"use strict";var t=e.i(725519),o=e.i(941031),i=e.i(437059),r=e.i(138230),n=e.i(142844),a=e.i(278678),s=e.i(355376),l=e.i(140018),c=e.i(301847),u=e.i(821738);let d={getGasPriceInEther:(e,t)=>Number(t*e)/1e18,getGasPriceInUSD(e,t,o){let r=d.getGasPriceInEther(t,o);return i.NumberUtil.bigNumber(e).times(r).toNumber()},getPriceImpact({sourceTokenAmount:e,sourceTokenPriceInUSD:t,toTokenPriceInUSD:o,toTokenAmount:r}){let n=i.NumberUtil.bigNumber(e).times(t),a=i.NumberUtil.bigNumber(r).times(o);return n.minus(a).div(n).times(100).toNumber()},getMaxSlippage(e,t){let o=i.NumberUtil.bigNumber(e).div(100);return i.NumberUtil.multiply(t,o).toNumber()},getProviderFee:(e,t=.0085)=>i.NumberUtil.bigNumber(e).times(t).toString(),isInsufficientNetworkTokenForGas:(e,t)=>!!i.NumberUtil.bigNumber(e).eq(0)||i.NumberUtil.bigNumber(i.NumberUtil.bigNumber(t||"0")).gt(e),isInsufficientSourceTokenForSwap(e,t,o){let r=o?.find(e=>e.address===t)?.quantity?.numeric;return i.NumberUtil.bigNumber(r||"0").lt(e)}};var p=e.i(869067),h=e.i(596590),m=e.i(525417),g=e.i(746),w=e.i(207176),k=e.i(11961),f=e.i(729702),v=e.i(881936),b=e.i(375054),T=e.i(944396);let x={initializing:!1,initialized:!1,loadingPrices:!1,loadingQuote:!1,loadingApprovalTransaction:!1,loadingBuildTransaction:!1,loadingTransaction:!1,fetchError:!1,approvalTransaction:void 0,swapTransaction:void 0,transactionError:void 0,sourceToken:void 0,sourceTokenAmount:"",sourceTokenPriceInUSD:0,toToken:void 0,toTokenAmount:"",toTokenPriceInUSD:0,networkPrice:"0",networkBalanceInUSD:"0",networkTokenSymbol:"",inputError:void 0,slippage:l.ConstantsUtil.CONVERT_SLIPPAGE_TOLERANCE,tokens:void 0,popularTokens:void 0,suggestedTokens:void 0,foundTokens:void 0,myTokensWithBalance:void 0,tokensPriceMap:{},gasFee:"0",gasPriceInUSD:0,priceImpact:void 0,maxSlippage:void 0,providerFee:void 0},y=(0,t.proxy)({...x}),C={state:y,subscribe:e=>(0,t.subscribe)(y,()=>e(y)),subscribeKey:(e,t)=>(0,o.subscribeKey)(y,e,t),getParams(){let e=w.ChainController.state.activeChain,t=h.AccountController.getCaipAddress(e)??w.ChainController.state.activeCaipAddress,o=c.CoreHelperUtil.getPlainAddress(t),n=(0,s.getActiveNetworkTokenAddress)(),a=f.ConnectorController.getConnectorId(w.ChainController.state.activeChain);if(!o)throw Error("No address found to swap the tokens from.");let l=!y.toToken?.address||!y.toToken?.decimals,u=!y.sourceToken?.address||!y.sourceToken?.decimals||!i.NumberUtil.bigNumber(y.sourceTokenAmount).gt(0),d=!y.sourceTokenAmount;return{networkAddress:n,fromAddress:o,fromCaipAddress:t,sourceTokenAddress:y.sourceToken?.address,toTokenAddress:y.toToken?.address,toTokenAmount:y.toTokenAmount,toTokenDecimals:y.toToken?.decimals,sourceTokenAmount:y.sourceTokenAmount,sourceTokenDecimals:y.sourceToken?.decimals,invalidToToken:l,invalidSourceToken:u,invalidSourceTokenAmount:d,availableToSwap:t&&!l&&!u&&!d,isAuthConnector:a===r.ConstantsUtil.CONNECTOR_ID.AUTH}},setSourceToken(e){if(!e){y.sourceToken=e,y.sourceTokenAmount="",y.sourceTokenPriceInUSD=0;return}y.sourceToken=e,S.setTokenPrice(e.address,"sourceToken")},setSourceTokenAmount(e){y.sourceTokenAmount=e},setToToken(e){if(!e){y.toToken=e,y.toTokenAmount="",y.toTokenPriceInUSD=0;return}y.toToken=e,S.setTokenPrice(e.address,"toToken")},setToTokenAmount(e){y.toTokenAmount=e?i.NumberUtil.toFixed(e,6):""},async setTokenPrice(e,t){let o=y.tokensPriceMap[e]||0;o||(y.loadingPrices=!0,o=await S.getAddressPrice(e)),"sourceToken"===t?y.sourceTokenPriceInUSD=o:"toToken"===t&&(y.toTokenPriceInUSD=o),y.loadingPrices&&(y.loadingPrices=!1),S.getParams().availableToSwap&&S.swapTokens()},switchTokens(){if(y.initializing||!y.initialized)return;let e=y.toToken?{...y.toToken}:void 0,t=y.sourceToken?{...y.sourceToken}:void 0,o=e&&""===y.toTokenAmount?"1":y.toTokenAmount;S.setSourceToken(e),S.setToToken(t),S.setSourceTokenAmount(o),S.setToTokenAmount(""),S.swapTokens()},resetState(){y.myTokensWithBalance=x.myTokensWithBalance,y.tokensPriceMap=x.tokensPriceMap,y.initialized=x.initialized,y.initializing=x.initializing,y.sourceToken=x.sourceToken,y.sourceTokenAmount=x.sourceTokenAmount,y.sourceTokenPriceInUSD=x.sourceTokenPriceInUSD,y.toToken=x.toToken,y.toTokenAmount=x.toTokenAmount,y.toTokenPriceInUSD=x.toTokenPriceInUSD,y.networkPrice=x.networkPrice,y.networkTokenSymbol=x.networkTokenSymbol,y.networkBalanceInUSD=x.networkBalanceInUSD,y.inputError=x.inputError},resetValues(){let{networkAddress:e}=S.getParams(),t=y.tokens?.find(t=>t.address===e);S.setSourceToken(t),S.setToToken(void 0)},getApprovalLoadingState:()=>y.loadingApprovalTransaction,clearError(){y.transactionError=void 0},async initializeState(){if(!y.initializing){if(y.initializing=!0,!y.initialized)try{await S.fetchTokens(),y.initialized=!0}catch(e){y.initialized=!1,T.SnackController.showError("Failed to initialize swap"),b.RouterController.goBack()}y.initializing=!1}},async fetchTokens(){let{networkAddress:e}=S.getParams();await S.getNetworkTokenPrice(),await S.getMyTokensWithBalance();let t=y.myTokensWithBalance?.find(t=>t.address===e);t&&(y.networkTokenSymbol=t.symbol,S.setSourceToken(t),S.setSourceTokenAmount("0"))},async getTokenList(){let e=w.ChainController.state.activeCaipNetwork?.caipNetworkId;if(y.caipNetworkId!==e||!y.tokens)try{y.tokensLoading=!0;let t=await u.SwapApiUtil.getTokenList(e);y.tokens=t,y.caipNetworkId=e,y.popularTokens=t.sort((e,t)=>e.symbol<t.symbol?-1:+(e.symbol>t.symbol)),y.suggestedTokens=t.filter(e=>!!l.ConstantsUtil.SWAP_SUGGESTED_TOKENS.includes(e.symbol))}catch(e){y.tokens=[],y.popularTokens=[],y.suggestedTokens=[]}finally{y.tokensLoading=!1}},async getAddressPrice(e){let t=y.tokensPriceMap[e];if(t)return t;let o=await g.BlockchainApiController.fetchTokenPrice({addresses:[e]}),i=o?.fungibles||[],r=[...y.tokens||[],...y.myTokensWithBalance||[]],n=r?.find(t=>t.address===e)?.symbol,a=parseFloat((i.find(e=>e.symbol.toLowerCase()===n?.toLowerCase())?.price||0).toString());return y.tokensPriceMap[e]=a,a},async getNetworkTokenPrice(){let{networkAddress:e}=S.getParams(),t=await g.BlockchainApiController.fetchTokenPrice({addresses:[e]}).catch(()=>(T.SnackController.showError("Failed to fetch network token price"),{fungibles:[]})),o=t.fungibles?.[0],i=o?.price.toString()||"0";y.tokensPriceMap[e]=parseFloat(i),y.networkTokenSymbol=o?.symbol||"",y.networkPrice=i},async getMyTokensWithBalance(e){let t=await a.BalanceUtil.getMyTokensWithBalance(e),o=u.SwapApiUtil.mapBalancesToSwapTokens(t);o&&(await S.getInitialGasPrice(),S.setBalances(o))},setBalances(e){let{networkAddress:t}=S.getParams(),o=w.ChainController.state.activeCaipNetwork;if(!o)return;let r=e.find(e=>e.address===t);e.forEach(e=>{y.tokensPriceMap[e.address]=e.price||0}),y.myTokensWithBalance=e.filter(e=>e.address.startsWith(o.caipNetworkId)),y.networkBalanceInUSD=r?i.NumberUtil.multiply(r.quantity.numeric,r.price).toString():"0"},async getInitialGasPrice(){let e=await u.SwapApiUtil.fetchGasPrice();if(!e)return{gasPrice:null,gasPriceInUSD:null};switch(w.ChainController.state?.activeCaipNetwork?.chainNamespace){case r.ConstantsUtil.CHAIN.SOLANA:return y.gasFee=e.standard??"0",y.gasPriceInUSD=i.NumberUtil.multiply(e.standard,y.networkPrice).div(1e9).toNumber(),{gasPrice:BigInt(y.gasFee),gasPriceInUSD:Number(y.gasPriceInUSD)};case r.ConstantsUtil.CHAIN.EVM:default:let t=e.standard??"0",o=BigInt(t),n=BigInt(15e4),a=d.getGasPriceInUSD(y.networkPrice,n,o);return y.gasFee=t,y.gasPriceInUSD=a,{gasPrice:o,gasPriceInUSD:a}}},async swapTokens(){let e=h.AccountController.state.address,t=y.sourceToken,o=y.toToken,r=i.NumberUtil.bigNumber(y.sourceTokenAmount).gt(0);if(r||S.setToTokenAmount(""),!o||!t||y.loadingPrices||!r)return;y.loadingQuote=!0;let n=i.NumberUtil.bigNumber(y.sourceTokenAmount).times(10**t.decimals).round(0);try{let r=await g.BlockchainApiController.fetchSwapQuote({userAddress:e,from:t.address,to:o.address,gasPrice:y.gasFee,amount:n.toString()});y.loadingQuote=!1;let a=r?.quotes?.[0]?.toAmount;if(!a)return void m.AlertController.open({displayMessage:"Incorrect amount",debugMessage:"Please enter a valid amount"},"error");let s=i.NumberUtil.bigNumber(a).div(10**o.decimals).toString();S.setToTokenAmount(s),S.hasInsufficientToken(y.sourceTokenAmount,t.address)?y.inputError="Insufficient balance":(y.inputError=void 0,S.setTransactionDetails())}catch(e){y.loadingQuote=!1,y.inputError="Insufficient balance"}},async getTransaction(){let{fromCaipAddress:e,availableToSwap:t}=S.getParams(),o=y.sourceToken,i=y.toToken;if(e&&t&&o&&i&&!y.loadingQuote)try{let t;return y.loadingBuildTransaction=!0,t=await u.SwapApiUtil.fetchSwapAllowance({userAddress:e,tokenAddress:o.address,sourceTokenAmount:y.sourceTokenAmount,sourceTokenDecimals:o.decimals})?await S.createSwapTransaction():await S.createAllowanceTransaction(),y.loadingBuildTransaction=!1,y.fetchError=!1,t}catch(e){b.RouterController.goBack(),T.SnackController.showError("Failed to check allowance"),y.loadingBuildTransaction=!1,y.approvalTransaction=void 0,y.swapTransaction=void 0,y.fetchError=!0;return}},async createAllowanceTransaction(){let{fromCaipAddress:e,sourceTokenAddress:t,toTokenAddress:o}=S.getParams();if(e&&o){if(!t)throw Error("createAllowanceTransaction - No source token address found.");try{let i=await g.BlockchainApiController.generateApproveCalldata({from:t,to:o,userAddress:e}),r=c.CoreHelperUtil.getPlainAddress(i.tx.from);if(!r)throw Error("SwapController:createAllowanceTransaction - address is required");let n={data:i.tx.data,to:r,gasPrice:BigInt(i.tx.eip155.gasPrice),value:BigInt(i.tx.value),toAmount:y.toTokenAmount};return y.swapTransaction=void 0,y.approvalTransaction={data:n.data,to:n.to,gasPrice:n.gasPrice,value:n.value,toAmount:n.toAmount},{data:n.data,to:n.to,gasPrice:n.gasPrice,value:n.value,toAmount:n.toAmount}}catch(e){b.RouterController.goBack(),T.SnackController.showError("Failed to create approval transaction"),y.approvalTransaction=void 0,y.swapTransaction=void 0,y.fetchError=!0;return}}},async createSwapTransaction(){let{networkAddress:e,fromCaipAddress:t,sourceTokenAmount:o}=S.getParams(),i=y.sourceToken,r=y.toToken;if(!t||!o||!i||!r)return;let n=k.ConnectionController.parseUnits(o,i.decimals)?.toString();try{let o=await g.BlockchainApiController.generateSwapCalldata({userAddress:t,from:i.address,to:r.address,amount:n,disableEstimate:!0}),a=i.address===e,s=BigInt(o.tx.eip155.gas),l=BigInt(o.tx.eip155.gasPrice),u=c.CoreHelperUtil.getPlainAddress(o.tx.to);if(!u)throw Error("SwapController:createSwapTransaction - address is required");let p={data:o.tx.data,to:u,gas:s,gasPrice:l,value:a?BigInt(n??"0"):BigInt("0"),toAmount:y.toTokenAmount};return y.gasPriceInUSD=d.getGasPriceInUSD(y.networkPrice,s,l),y.approvalTransaction=void 0,y.swapTransaction=p,p}catch(e){b.RouterController.goBack(),T.SnackController.showError("Failed to create transaction"),y.approvalTransaction=void 0,y.swapTransaction=void 0,y.fetchError=!0;return}},onEmbeddedWalletApprovalSuccess(){T.SnackController.showLoading("Approve limit increase in your wallet"),b.RouterController.replace("SwapPreview")},async sendTransactionForApproval(e){let{fromAddress:t,isAuthConnector:o}=S.getParams();y.loadingApprovalTransaction=!0,o?b.RouterController.pushTransactionStack({onSuccess:S.onEmbeddedWalletApprovalSuccess}):T.SnackController.showLoading("Approve limit increase in your wallet");try{await k.ConnectionController.sendTransaction({address:t,to:e.to,data:e.data,value:e.value,chainNamespace:r.ConstantsUtil.CHAIN.EVM}),await S.swapTokens(),await S.getTransaction(),y.approvalTransaction=void 0,y.loadingApprovalTransaction=!1}catch(e){y.transactionError=e?.displayMessage,y.loadingApprovalTransaction=!1,T.SnackController.showError(e?.displayMessage||"Transaction error"),v.EventsController.sendEvent({type:"track",event:"SWAP_APPROVAL_ERROR",properties:{message:e?.displayMessage||e?.message||"Unknown",network:w.ChainController.state.activeCaipNetwork?.caipNetworkId||"",swapFromToken:S.state.sourceToken?.symbol||"",swapToToken:S.state.toToken?.symbol||"",swapFromAmount:S.state.sourceTokenAmount||"",swapToAmount:S.state.toTokenAmount||"",isSmartAccount:(0,s.getPreferredAccountType)(r.ConstantsUtil.CHAIN.EVM)===n.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT}})}},async sendTransactionForSwap(e){if(!e)return;let{fromAddress:t,toTokenAmount:o,isAuthConnector:a}=S.getParams();y.loadingTransaction=!0;let l=`Swapping ${y.sourceToken?.symbol} to ${i.NumberUtil.formatNumberToLocalString(o,3)} ${y.toToken?.symbol}`,c=`Swapped ${y.sourceToken?.symbol} to ${i.NumberUtil.formatNumberToLocalString(o,3)} ${y.toToken?.symbol}`;a?b.RouterController.pushTransactionStack({onSuccess(){b.RouterController.replace("Account"),T.SnackController.showLoading(l),C.resetState()}}):T.SnackController.showLoading("Confirm transaction in your wallet");try{let o=[y.sourceToken?.address,y.toToken?.address].join(","),i=await k.ConnectionController.sendTransaction({address:t,to:e.to,data:e.data,value:e.value,chainNamespace:r.ConstantsUtil.CHAIN.EVM});return y.loadingTransaction=!1,T.SnackController.showSuccess(c),v.EventsController.sendEvent({type:"track",event:"SWAP_SUCCESS",properties:{network:w.ChainController.state.activeCaipNetwork?.caipNetworkId||"",swapFromToken:S.state.sourceToken?.symbol||"",swapToToken:S.state.toToken?.symbol||"",swapFromAmount:S.state.sourceTokenAmount||"",swapToAmount:S.state.toTokenAmount||"",isSmartAccount:(0,s.getPreferredAccountType)(r.ConstantsUtil.CHAIN.EVM)===n.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT}}),C.resetState(),a||b.RouterController.replace("Account"),C.getMyTokensWithBalance(o),i}catch(e){y.transactionError=e?.displayMessage,y.loadingTransaction=!1,T.SnackController.showError(e?.displayMessage||"Transaction error"),v.EventsController.sendEvent({type:"track",event:"SWAP_ERROR",properties:{message:e?.displayMessage||e?.message||"Unknown",network:w.ChainController.state.activeCaipNetwork?.caipNetworkId||"",swapFromToken:S.state.sourceToken?.symbol||"",swapToToken:S.state.toToken?.symbol||"",swapFromAmount:S.state.sourceTokenAmount||"",swapToAmount:S.state.toTokenAmount||"",isSmartAccount:(0,s.getPreferredAccountType)(r.ConstantsUtil.CHAIN.EVM)===n.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT}});return}},hasInsufficientToken:(e,t)=>d.isInsufficientSourceTokenForSwap(e,t,y.myTokensWithBalance),setTransactionDetails(){let{toTokenAddress:e,toTokenDecimals:t}=S.getParams();e&&t&&(y.gasPriceInUSD=d.getGasPriceInUSD(y.networkPrice,BigInt(y.gasFee),BigInt(15e4)),y.priceImpact=d.getPriceImpact({sourceTokenAmount:y.sourceTokenAmount,sourceTokenPriceInUSD:y.sourceTokenPriceInUSD,toTokenPriceInUSD:y.toTokenPriceInUSD,toTokenAmount:y.toTokenAmount}),y.maxSlippage=d.getMaxSlippage(y.slippage,y.toTokenAmount),y.providerFee=d.getProviderFee(y.sourceTokenAmount))}},S=(0,p.withErrorBoundary)(C);e.s(["SwapController",0,S],950955)},239139,e=>{"use strict";e.i(588984);var t=e.i(399702),o=e.i(872857);e.i(759703);var i=e.i(392074);e.i(287940),e.i(846880),e.i(596548),e.i(108476);var r=e.i(864429),n=e.i(938559);e.i(839432);var a=e.i(118827);let s=a.css`
  :host {
    display: block;
  }

  :host > button,
  :host > wui-flex {
    gap: var(--wui-spacing-xxs);
    padding: var(--wui-spacing-xs);
    padding-right: var(--wui-spacing-1xs);
    height: 40px;
    border-radius: var(--wui-border-radius-l);
    background: var(--wui-color-gray-glass-002);
    border-width: 0px;
    box-shadow: inset 0 0 0 1px var(--wui-color-gray-glass-002);
  }

  :host > button wui-image {
    width: 24px;
    height: 24px;
    border-radius: var(--wui-border-radius-s);
    box-shadow: inset 0 0 0 1px var(--wui-color-gray-glass-010);
  }
`;var l=function(e,t,o,i){var r,n=arguments.length,a=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,o):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,o,i);else for(var s=e.length-1;s>=0;s--)(r=e[s])&&(a=(n<3?r(a):n>3?r(t,o,a):r(t,o))||a);return n>3&&a&&Object.defineProperty(t,o,a),a};let c=class extends t.LitElement{constructor(){super(...arguments),this.text="",this.loading=!1}render(){return this.loading?o.html` <wui-flex alignItems="center" gap="xxs" padding="xs">
        <wui-shimmer width="24px" height="24px"></wui-shimmer>
        <wui-shimmer width="40px" height="20px" borderRadius="4xs"></wui-shimmer>
      </wui-flex>`:o.html`
      <button>
        ${this.tokenTemplate()}
        <wui-text variant="paragraph-600" color="fg-100">${this.text}</wui-text>
      </button>
    `}tokenTemplate(){return this.imageSrc?o.html`<wui-image src=${this.imageSrc}></wui-image>`:o.html`
      <wui-icon-box
        size="sm"
        iconColor="fg-200"
        backgroundColor="fg-300"
        icon="networkPlaceholder"
      ></wui-icon-box>
    `}};c.styles=[r.resetStyles,r.elementStyles,s],l([(0,i.property)()],c.prototype,"imageSrc",void 0),l([(0,i.property)()],c.prototype,"text",void 0),l([(0,i.property)({type:Boolean})],c.prototype,"loading",void 0),c=l([(0,n.customElement)("wui-token-button")],c),e.s([],239139)},408887,e=>{"use strict";e.i(588984);var t=e.i(399702),o=e.i(872857);e.i(759703);var i=e.i(698797),r=e.i(207176),n=e.i(301847),a=e.i(375054),s=e.i(713606),l=e.i(950955);e.i(302184);var c=e.i(938559);e.i(81981),e.i(237029),e.i(174776);var u=t,d=e.i(392074);e.i(812492);var p=e.i(568633),h=e.i(11961);e.i(982221),e.i(331658);var m=e.i(118827);let g=m.css`
  :host {
    width: 100%;
    height: 100px;
    border-radius: var(--wui-border-radius-s);
    border: 1px solid var(--wui-color-gray-glass-002);
    background-color: var(--wui-color-gray-glass-002);
    transition: background-color var(--wui-ease-out-power-1) var(--wui-duration-lg);
    will-change: background-color;
    position: relative;
  }

  :host(:hover) {
    background-color: var(--wui-color-gray-glass-005);
  }

  wui-flex {
    width: 100%;
    height: fit-content;
  }

  wui-button {
    display: ruby;
    color: var(--wui-color-fg-100);
    margin: 0 var(--wui-spacing-xs);
  }

  .instruction {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    z-index: 2;
  }

  .paste {
    display: inline-flex;
  }

  textarea {
    background: transparent;
    width: 100%;
    font-family: var(--w3m-font-family);
    font-size: var(--wui-font-size-medium);
    font-style: normal;
    font-weight: var(--wui-font-weight-light);
    line-height: 130%;
    letter-spacing: var(--wui-letter-spacing-medium);
    color: var(--wui-color-fg-100);
    caret-color: var(--wui-color-accent-100);
    box-sizing: border-box;
    -webkit-appearance: none;
    -moz-appearance: textfield;
    padding: 0px;
    border: none;
    outline: none;
    appearance: none;
    resize: none;
    overflow: hidden;
  }
`;var w=function(e,t,o,i){var r,n=arguments.length,a=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,o):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,o,i);else for(var s=e.length-1;s>=0;s--)(r=e[s])&&(a=(n<3?r(a):n>3?r(t,o,a):r(t,o))||a);return n>3&&a&&Object.defineProperty(t,o,a),a};let k=class extends u.LitElement{constructor(){super(...arguments),this.inputElementRef=(0,p.createRef)(),this.instructionElementRef=(0,p.createRef)(),this.instructionHidden=!!this.value,this.pasting=!1,this.onDebouncedSearch=n.CoreHelperUtil.debounce(async e=>{if(!e.length)return void this.setReceiverAddress("");let t=r.ChainController.state.activeChain;if(n.CoreHelperUtil.isAddress(e,t))return void this.setReceiverAddress(e);try{let t=await h.ConnectionController.getEnsAddress(e);if(t){s.SendController.setReceiverProfileName(e),s.SendController.setReceiverAddress(t);let o=await h.ConnectionController.getEnsAvatar(e);s.SendController.setReceiverProfileImageUrl(o||void 0)}}catch(t){this.setReceiverAddress(e)}finally{s.SendController.setLoading(!1)}})}firstUpdated(){this.value&&(this.instructionHidden=!0),this.checkHidden()}render(){return o.html` <wui-flex
      @click=${this.onBoxClick.bind(this)}
      flexDirection="column"
      justifyContent="center"
      gap="4xs"
      .padding=${["2xl","l","xl","l"]}
    >
      <wui-text
        ${(0,p.ref)(this.instructionElementRef)}
        class="instruction"
        color="fg-300"
        variant="medium-400"
      >
        Type or
        <wui-button
          class="paste"
          size="md"
          variant="neutral"
          iconLeft="copy"
          @click=${this.onPasteClick.bind(this)}
        >
          <wui-icon size="sm" color="inherit" slot="iconLeft" name="copy"></wui-icon>
          Paste
        </wui-button>
        address
      </wui-text>
      <textarea
        spellcheck="false"
        ?disabled=${!this.instructionHidden}
        ${(0,p.ref)(this.inputElementRef)}
        @input=${this.onInputChange.bind(this)}
        @blur=${this.onBlur.bind(this)}
        .value=${this.value??""}
        autocomplete="off"
      >
${this.value??""}</textarea
      >
    </wui-flex>`}async focusInput(){this.instructionElementRef.value&&(this.instructionHidden=!0,await this.toggleInstructionFocus(!1),this.instructionElementRef.value.style.pointerEvents="none",this.inputElementRef.value?.focus(),this.inputElementRef.value&&(this.inputElementRef.value.selectionStart=this.inputElementRef.value.selectionEnd=this.inputElementRef.value.value.length))}async focusInstruction(){this.instructionElementRef.value&&(this.instructionHidden=!1,await this.toggleInstructionFocus(!0),this.instructionElementRef.value.style.pointerEvents="auto",this.inputElementRef.value?.blur())}async toggleInstructionFocus(e){this.instructionElementRef.value&&await this.instructionElementRef.value.animate([{opacity:+!e},{opacity:+!!e}],{duration:100,easing:"ease",fill:"forwards"}).finished}onBoxClick(){this.value||this.instructionHidden||this.focusInput()}onBlur(){this.value||!this.instructionHidden||this.pasting||this.focusInstruction()}checkHidden(){this.instructionHidden&&this.focusInput()}async onPasteClick(){this.pasting=!0;let e=await navigator.clipboard.readText();s.SendController.setReceiverAddress(e),this.focusInput()}onInputChange(e){let t=e.target;this.pasting=!1,this.value=e.target?.value,t.value&&!this.instructionHidden&&this.focusInput(),s.SendController.setLoading(!0),this.onDebouncedSearch(t.value)}setReceiverAddress(e){s.SendController.setReceiverAddress(e),s.SendController.setReceiverProfileName(void 0),s.SendController.setReceiverProfileImageUrl(void 0),s.SendController.setLoading(!1)}};k.styles=g,w([(0,d.property)()],k.prototype,"value",void 0),w([(0,i.state)()],k.prototype,"instructionHidden",void 0),w([(0,i.state)()],k.prototype,"pasting",void 0),k=w([(0,c.customElement)("w3m-input-address")],k);var f=t,v=e.i(437059),b=e.i(34691),T=t,x=e.i(155284),y=e.i(864429);let C=m.css`
  :host {
    position: relative;
    display: inline-block;
  }

  input {
    background: transparent;
    width: 100%;
    height: auto;
    font-family: var(--wui-font-family);
    color: var(--wui-color-fg-100);

    font-feature-settings: 'case' on;
    font-size: 32px;
    font-weight: var(--wui-font-weight-light);
    caret-color: var(--wui-color-accent-100);
    line-height: 130%;
    letter-spacing: -1.28px;
    box-sizing: border-box;
    -webkit-appearance: none;
    -moz-appearance: textfield;
    padding: 0px;
  }

  input::-webkit-outer-spin-button,
  input::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
  }

  input::placeholder {
    color: var(--wui-color-fg-275);
  }
`;var S=function(e,t,o,i){var r,n=arguments.length,a=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,o):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,o,i);else for(var s=e.length-1;s>=0;s--)(r=e[s])&&(a=(n<3?r(a):n>3?r(t,o,a):r(t,o))||a);return n>3&&a&&Object.defineProperty(t,o,a),a};let A=class extends T.LitElement{constructor(){super(...arguments),this.inputElementRef=(0,p.createRef)(),this.disabled=!1,this.value="",this.placeholder="0"}render(){return this.inputElementRef?.value&&this.value&&(this.inputElementRef.value.value=this.value),o.html`<input
      ${(0,p.ref)(this.inputElementRef)}
      type="text"
      inputmode="decimal"
      pattern="[0-9,.]*"
      placeholder=${this.placeholder}
      ?disabled=${this.disabled}
      autofocus
      value=${this.value??""}
      @input=${this.dispatchInputChangeEvent.bind(this)}
    /> `}dispatchInputChangeEvent(e){let t=e.data;if(t&&this.inputElementRef?.value)if(","===t){let e=this.inputElementRef.value.value.replace(",",".");this.inputElementRef.value.value=e,this.value=`${this.value}${e}`}else x.numbersRegex.test(t)||(this.inputElementRef.value.value=this.value.replace(RegExp(t.replace(x.specialCharactersRegex,"\\$&"),"gu"),""));this.dispatchEvent(new CustomEvent("inputChange",{detail:this.inputElementRef.value?.value,bubbles:!0,composed:!0}))}};A.styles=[y.resetStyles,y.elementStyles,C],S([(0,d.property)({type:Boolean})],A.prototype,"disabled",void 0),S([(0,d.property)({type:String})],A.prototype,"value",void 0),S([(0,d.property)({type:String})],A.prototype,"placeholder",void 0),A=S([(0,c.customElement)("wui-input-amount")],A),e.i(472945),e.i(239139);let P=m.css`
  :host {
    width: 100%;
    height: 100px;
    border-radius: var(--wui-border-radius-s);
    border: 1px solid var(--wui-color-gray-glass-002);
    background-color: var(--wui-color-gray-glass-002);
    transition: background-color var(--wui-ease-out-power-1) var(--wui-duration-lg);
    will-change: background-color;
  }

  :host(:hover) {
    background-color: var(--wui-color-gray-glass-005);
  }

  wui-flex {
    width: 100%;
    height: fit-content;
  }

  wui-button {
    width: 100%;
    display: flex;
    justify-content: flex-end;
  }

  wui-input-amount {
    mask-image: linear-gradient(
      270deg,
      transparent 0px,
      transparent 8px,
      black 24px,
      black 25px,
      black 32px,
      black 100%
    );
  }

  .totalValue {
    width: 100%;
  }
`;var N=function(e,t,o,i){var r,n=arguments.length,a=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,o):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,o,i);else for(var s=e.length-1;s>=0;s--)(r=e[s])&&(a=(n<3?r(a):n>3?r(t,o,a):r(t,o))||a);return n>3&&a&&Object.defineProperty(t,o,a),a};let E=class extends f.LitElement{render(){return o.html` <wui-flex
      flexDirection="column"
      gap="4xs"
      .padding=${["xl","s","l","l"]}
    >
      <wui-flex alignItems="center">
        <wui-input-amount
          @inputChange=${this.onInputChange.bind(this)}
          ?disabled=${!this.token}
          .value=${this.sendTokenAmount?String(this.sendTokenAmount):""}
        ></wui-input-amount>
        ${this.buttonTemplate()}
      </wui-flex>
      <wui-flex alignItems="center" justifyContent="space-between">
        ${this.sendValueTemplate()}
        <wui-flex alignItems="center" gap="4xs" justifyContent="flex-end">
          ${this.maxAmountTemplate()} ${this.actionTemplate()}
        </wui-flex>
      </wui-flex>
    </wui-flex>`}buttonTemplate(){return this.token?o.html`<wui-token-button
        text=${this.token.symbol}
        imageSrc=${this.token.iconUrl}
        @click=${this.handleSelectButtonClick.bind(this)}
      >
      </wui-token-button>`:o.html`<wui-button
      size="md"
      variant="accent"
      @click=${this.handleSelectButtonClick.bind(this)}
      >Select token</wui-button
    >`}handleSelectButtonClick(){a.RouterController.push("WalletSendSelectToken")}sendValueTemplate(){if(this.token&&this.sendTokenAmount){let e=this.token.price*this.sendTokenAmount;return o.html`<wui-text class="totalValue" variant="small-400" color="fg-200"
        >${e?`$${v.NumberUtil.formatNumberToLocalString(e,2)}`:"Incorrect value"}</wui-text
      >`}return null}maxAmountTemplate(){return this.token?this.sendTokenAmount&&this.sendTokenAmount>Number(this.token.quantity.numeric)?o.html` <wui-text variant="small-400" color="error-100">
          ${b.UiHelperUtil.roundNumber(Number(this.token.quantity.numeric),6,5)}
        </wui-text>`:o.html` <wui-text variant="small-400" color="fg-200">
        ${b.UiHelperUtil.roundNumber(Number(this.token.quantity.numeric),6,5)}
      </wui-text>`:null}actionTemplate(){return this.token?this.sendTokenAmount&&this.sendTokenAmount>Number(this.token.quantity.numeric)?o.html`<wui-link @click=${this.onBuyClick.bind(this)}>Buy</wui-link>`:o.html`<wui-link @click=${this.onMaxClick.bind(this)}>Max</wui-link>`:null}onInputChange(e){s.SendController.setTokenAmount(e.detail)}onMaxClick(){if(this.token){let e=v.NumberUtil.bigNumber(this.token.quantity.numeric);s.SendController.setTokenAmount(Number(e.toFixed(20)))}}onBuyClick(){a.RouterController.push("OnRampProviders")}};E.styles=P,N([(0,d.property)({type:Object})],E.prototype,"token",void 0),N([(0,d.property)({type:Number})],E.prototype,"sendTokenAmount",void 0),E=N([(0,c.customElement)("w3m-input-token")],E);let I=m.css`
  :host {
    display: block;
  }

  wui-flex {
    position: relative;
  }

  wui-icon-box {
    width: 40px;
    height: 40px;
    border-radius: var(--wui-border-radius-xs) !important;
    border: 5px solid var(--wui-color-bg-125);
    background: var(--wui-color-bg-175);
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    z-index: 3;
  }

  wui-button {
    --local-border-radius: var(--wui-border-radius-xs) !important;
  }

  .inputContainer {
    height: fit-content;
  }
`;var U=function(e,t,o,i){var r,n=arguments.length,a=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,o):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,o,i);else for(var s=e.length-1;s>=0;s--)(r=e[s])&&(a=(n<3?r(a):n>3?r(t,o,a):r(t,o))||a);return n>3&&a&&Object.defineProperty(t,o,a),a};let R=class extends t.LitElement{constructor(){super(),this.unsubscribe=[],this.token=s.SendController.state.token,this.sendTokenAmount=s.SendController.state.sendTokenAmount,this.receiverAddress=s.SendController.state.receiverAddress,this.receiverProfileName=s.SendController.state.receiverProfileName,this.loading=s.SendController.state.loading,this.message="Preview Send",this.token&&(this.fetchBalances(),this.fetchNetworkPrice()),this.unsubscribe.push(s.SendController.subscribe(e=>{this.token=e.token,this.sendTokenAmount=e.sendTokenAmount,this.receiverAddress=e.receiverAddress,this.receiverProfileName=e.receiverProfileName,this.loading=e.loading}))}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}render(){return this.getMessage(),o.html` <wui-flex flexDirection="column" .padding=${["0","l","l","l"]}>
      <wui-flex class="inputContainer" gap="xs" flexDirection="column">
        <w3m-input-token
          .token=${this.token}
          .sendTokenAmount=${this.sendTokenAmount}
        ></w3m-input-token>
        <wui-icon-box
          size="inherit"
          backgroundColor="fg-300"
          iconSize="lg"
          iconColor="fg-250"
          background="opaque"
          icon="arrowBottom"
        ></wui-icon-box>
        <w3m-input-address
          .value=${this.receiverProfileName?this.receiverProfileName:this.receiverAddress}
        ></w3m-input-address>
      </wui-flex>
      <wui-flex .margin=${["l","0","0","0"]}>
        <wui-button
          @click=${this.onButtonClick.bind(this)}
          ?disabled=${!this.message.startsWith("Preview Send")}
          size="lg"
          variant="main"
          ?loading=${this.loading}
          fullWidth
        >
          ${this.message}
        </wui-button>
      </wui-flex>
    </wui-flex>`}async fetchBalances(){await s.SendController.fetchTokenBalance(),s.SendController.fetchNetworkBalance()}async fetchNetworkPrice(){await l.SwapController.getNetworkTokenPrice()}onButtonClick(){a.RouterController.push("WalletSendPreview")}getMessage(){this.message="Preview Send",this.receiverAddress&&!n.CoreHelperUtil.isAddress(this.receiverAddress,r.ChainController.state.activeChain)&&(this.message="Invalid Address"),this.receiverAddress||(this.message="Add Address"),this.sendTokenAmount&&this.token&&this.sendTokenAmount>Number(this.token.quantity.numeric)&&(this.message="Insufficient Funds"),this.sendTokenAmount||(this.message="Add Amount"),this.sendTokenAmount&&this.token?.price&&(this.sendTokenAmount*this.token.price||(this.message="Incorrect Value")),this.token||(this.message="Select Token")}};R.styles=I,U([(0,i.state)()],R.prototype,"token",void 0),U([(0,i.state)()],R.prototype,"sendTokenAmount",void 0),U([(0,i.state)()],R.prototype,"receiverAddress",void 0),U([(0,i.state)()],R.prototype,"receiverProfileName",void 0),U([(0,i.state)()],R.prototype,"loading",void 0),U([(0,i.state)()],R.prototype,"message",void 0),R=U([(0,c.customElement)("w3m-wallet-send-view")],R),e.s(["W3mWalletSendView",()=>R],905689);var $=t;e.i(999964),e.i(696794),e.i(156575);let B=m.css`
  .contentContainer {
    height: 440px;
    overflow: scroll;
    scrollbar-width: none;
  }

  .contentContainer::-webkit-scrollbar {
    display: none;
  }

  wui-icon-box {
    width: 40px;
    height: 40px;
    border-radius: var(--wui-border-radius-xxs);
  }
`;var D=function(e,t,o,i){var r,n=arguments.length,a=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,o):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,o,i);else for(var s=e.length-1;s>=0;s--)(r=e[s])&&(a=(n<3?r(a):n>3?r(t,o,a):r(t,o))||a);return n>3&&a&&Object.defineProperty(t,o,a),a};let O=class extends $.LitElement{constructor(){super(),this.unsubscribe=[],this.tokenBalances=s.SendController.state.tokenBalances,this.search="",this.onDebouncedSearch=n.CoreHelperUtil.debounce(e=>{this.search=e}),this.fetchBalancesAndNetworkPrice(),this.unsubscribe.push(s.SendController.subscribe(e=>{this.tokenBalances=e.tokenBalances}))}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}render(){return o.html`
      <wui-flex flexDirection="column">
        ${this.templateSearchInput()} <wui-separator></wui-separator> ${this.templateTokens()}
      </wui-flex>
    `}async fetchBalancesAndNetworkPrice(){this.tokenBalances&&this.tokenBalances?.length!==0||(await this.fetchBalances(),await this.fetchNetworkPrice())}async fetchBalances(){await s.SendController.fetchTokenBalance(),s.SendController.fetchNetworkBalance()}async fetchNetworkPrice(){await l.SwapController.getNetworkTokenPrice()}templateSearchInput(){return o.html`
      <wui-flex gap="xs" padding="s">
        <wui-input-text
          @inputChange=${this.onInputChange.bind(this)}
          class="network-search-input"
          size="sm"
          placeholder="Search token"
          icon="search"
        ></wui-input-text>
      </wui-flex>
    `}templateTokens(){return this.tokens=this.tokenBalances?.filter(e=>e.chainId===r.ChainController.state.activeCaipNetwork?.caipNetworkId),this.search?this.filteredTokens=this.tokenBalances?.filter(e=>e.name.toLowerCase().includes(this.search.toLowerCase())):this.filteredTokens=this.tokens,o.html`
      <wui-flex
        class="contentContainer"
        flexDirection="column"
        .padding=${["0","s","0","s"]}
      >
        <wui-flex justifyContent="flex-start" .padding=${["m","s","s","s"]}>
          <wui-text variant="paragraph-500" color="fg-200">Your tokens</wui-text>
        </wui-flex>
        <wui-flex flexDirection="column" gap="xs">
          ${this.filteredTokens&&this.filteredTokens.length>0?this.filteredTokens.map(e=>o.html`<wui-list-token
                    @click=${this.handleTokenClick.bind(this,e)}
                    ?clickable=${!0}
                    tokenName=${e.name}
                    tokenImageUrl=${e.iconUrl}
                    tokenAmount=${e.quantity.numeric}
                    tokenValue=${e.value}
                    tokenCurrency=${e.symbol}
                  ></wui-list-token>`):o.html`<wui-flex
                .padding=${["4xl","0","0","0"]}
                alignItems="center"
                flexDirection="column"
                gap="l"
              >
                <wui-icon-box
                  icon="coinPlaceholder"
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
                  <wui-text variant="paragraph-500" align="center" color="fg-100"
                    >No tokens found</wui-text
                  >
                  <wui-text variant="small-400" align="center" color="fg-200"
                    >Your tokens will appear here</wui-text
                  >
                </wui-flex>
                <wui-link @click=${this.onBuyClick.bind(this)}>Buy</wui-link>
              </wui-flex>`}
        </wui-flex>
      </wui-flex>
    `}onBuyClick(){a.RouterController.push("OnRampProviders")}onInputChange(e){this.onDebouncedSearch(e.detail)}handleTokenClick(e){s.SendController.setToken(e),s.SendController.setTokenAmount(void 0),a.RouterController.goBack()}};O.styles=B,D([(0,i.state)()],O.prototype,"tokenBalances",void 0),D([(0,i.state)()],O.prototype,"tokens",void 0),D([(0,i.state)()],O.prototype,"filteredTokens",void 0),D([(0,i.state)()],O.prototype,"search",void 0),O=D([(0,c.customElement)("w3m-wallet-send-select-token-view")],O),e.s(["W3mSendSelectTokenView",()=>O],148193);var z=t,j=e.i(881936),F=e.i(944396),M=e.i(355376),W=t;e.i(630572),e.i(287940),e.i(596548),e.i(108476),e.i(370507);let L=m.css`
  :host {
    display: flex;
    gap: var(--wui-spacing-xs);
    border-radius: var(--wui-border-radius-3xl);
    border: 1px solid var(--wui-color-gray-glass-002);
    background: var(--wui-color-gray-glass-002);
    padding: var(--wui-spacing-2xs) var(--wui-spacing-xs) var(--wui-spacing-2xs)
      var(--wui-spacing-s);
    align-items: center;
  }

  wui-avatar,
  wui-icon,
  wui-image {
    width: 32px;
    height: 32px;
    border: 1px solid var(--wui-color-gray-glass-002);
    border-radius: var(--wui-border-radius-3xl);
    box-shadow: 0 0 0 2px var(--wui-color-gray-glass-002);
  }
`;var H=function(e,t,o,i){var r,n=arguments.length,a=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,o):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,o,i);else for(var s=e.length-1;s>=0;s--)(r=e[s])&&(a=(n<3?r(a):n>3?r(t,o,a):r(t,o))||a);return n>3&&a&&Object.defineProperty(t,o,a),a};let V=class extends W.LitElement{constructor(){super(...arguments),this.text="",this.address="",this.isAddress=!1}render(){return o.html`<wui-text variant="large-500" color="fg-100">${this.text}</wui-text>
      ${this.imageTemplate()}`}imageTemplate(){return this.isAddress?o.html`<wui-avatar address=${this.address} .imageSrc=${this.imageSrc}></wui-avatar>`:this.imageSrc?o.html`<wui-image src=${this.imageSrc}></wui-image>`:o.html`<wui-icon size="inherit" color="fg-200" name="networkPlaceholder"></wui-icon>`}};V.styles=[y.resetStyles,y.elementStyles,L],H([(0,d.property)()],V.prototype,"text",void 0),H([(0,d.property)()],V.prototype,"address",void 0),H([(0,d.property)()],V.prototype,"imageSrc",void 0),H([(0,d.property)({type:Boolean})],V.prototype,"isAddress",void 0),V=H([(0,c.customElement)("wui-preview-item")],V);var _=e.i(142844),q=t;e.i(781840);var G=e.i(86988),Y=e.i(589408),K=t;let Q=m.css`
  :host {
    display: flex;
    column-gap: var(--wui-spacing-s);
    padding: 17px 18px 17px var(--wui-spacing-m);
    width: 100%;
    background-color: var(--wui-color-gray-glass-002);
    border-radius: var(--wui-border-radius-xs);
    color: var(--wui-color-fg-250);
  }

  wui-image {
    width: var(--wui-icon-size-lg);
    height: var(--wui-icon-size-lg);
    border-radius: var(--wui-border-radius-3xl);
  }

  wui-icon {
    width: var(--wui-icon-size-lg);
    height: var(--wui-icon-size-lg);
  }
`;var J=function(e,t,o,i){var r,n=arguments.length,a=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,o):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,o,i);else for(var s=e.length-1;s>=0;s--)(r=e[s])&&(a=(n<3?r(a):n>3?r(t,o,a):r(t,o))||a);return n>3&&a&&Object.defineProperty(t,o,a),a};let X=class extends K.LitElement{constructor(){super(...arguments),this.imageSrc=void 0,this.textTitle="",this.textValue=void 0}render(){return o.html`
      <wui-flex justifyContent="space-between" alignItems="center">
        <wui-text variant="paragraph-500" color=${this.textValue?"fg-200":"fg-100"}>
          ${this.textTitle}
        </wui-text>
        ${this.templateContent()}
      </wui-flex>
    `}templateContent(){return this.imageSrc?o.html`<wui-image src=${this.imageSrc} alt=${this.textTitle}></wui-image>`:this.textValue?o.html` <wui-text variant="paragraph-400" color="fg-100"> ${this.textValue} </wui-text>`:o.html`<wui-icon size="inherit" color="fg-200" name="networkPlaceholder"></wui-icon>`}};X.styles=[y.resetStyles,y.elementStyles,Q],J([(0,d.property)()],X.prototype,"imageSrc",void 0),J([(0,d.property)()],X.prototype,"textTitle",void 0),J([(0,d.property)()],X.prototype,"textValue",void 0),X=J([(0,c.customElement)("wui-list-content")],X);let Z=m.css`
  :host {
    display: flex;
    width: auto;
    flex-direction: column;
    gap: var(--wui-border-radius-1xs);
    border-radius: var(--wui-border-radius-s);
    background: var(--wui-color-gray-glass-002);
    padding: var(--wui-spacing-s) var(--wui-spacing-1xs) var(--wui-spacing-1xs)
      var(--wui-spacing-1xs);
  }

  wui-text {
    padding: 0 var(--wui-spacing-1xs);
  }

  wui-flex {
    margin-top: var(--wui-spacing-1xs);
  }

  .network {
    cursor: pointer;
    transition: background-color var(--wui-ease-out-power-1) var(--wui-duration-lg);
    will-change: background-color;
  }

  .network:focus-visible {
    border: 1px solid var(--wui-color-accent-100);
    background-color: var(--wui-color-gray-glass-005);
    -webkit-box-shadow: 0px 0px 0px 4px var(--wui-box-shadow-blue);
    -moz-box-shadow: 0px 0px 0px 4px var(--wui-box-shadow-blue);
    box-shadow: 0px 0px 0px 4px var(--wui-box-shadow-blue);
  }

  .network:hover {
    background-color: var(--wui-color-gray-glass-005);
  }

  .network:active {
    background-color: var(--wui-color-gray-glass-010);
  }
`;var ee=function(e,t,o,i){var r,n=arguments.length,a=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,o):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,o,i);else for(var s=e.length-1;s>=0;s--)(r=e[s])&&(a=(n<3?r(a):n>3?r(t,o,a):r(t,o))||a);return n>3&&a&&Object.defineProperty(t,o,a),a};let et=class extends q.LitElement{render(){return o.html` <wui-text variant="small-400" color="fg-200">Details</wui-text>
      <wui-flex flexDirection="column" gap="xxs">
        <wui-list-content
          textTitle="Address"
          textValue=${b.UiHelperUtil.getTruncateString({string:this.receiverAddress??"",charsStart:4,charsEnd:4,truncate:"middle"})}
        >
        </wui-list-content>
        ${this.networkTemplate()}
      </wui-flex>`}networkTemplate(){return this.caipNetwork?.name?o.html` <wui-list-content
        @click=${()=>this.onNetworkClick(this.caipNetwork)}
        class="network"
        textTitle="Network"
        imageSrc=${(0,G.ifDefined)(Y.AssetUtil.getNetworkImage(this.caipNetwork))}
      ></wui-list-content>`:null}onNetworkClick(e){e&&a.RouterController.push("Networks",{network:e})}};et.styles=Z,ee([(0,d.property)()],et.prototype,"receiverAddress",void 0),ee([(0,d.property)({type:Object})],et.prototype,"caipNetwork",void 0),et=ee([(0,c.customElement)("w3m-wallet-send-details")],et);let eo=m.css`
  wui-avatar,
  wui-image {
    display: ruby;
    width: 32px;
    height: 32px;
    border-radius: var(--wui-border-radius-3xl);
  }

  .sendButton {
    width: 70%;
    --local-width: 100% !important;
    --local-border-radius: var(--wui-border-radius-xs) !important;
  }

  .cancelButton {
    width: 30%;
    --local-width: 100% !important;
    --local-border-radius: var(--wui-border-radius-xs) !important;
  }
`;var ei=function(e,t,o,i){var r,n=arguments.length,a=n<3?t:null===i?i=Object.getOwnPropertyDescriptor(t,o):i;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)a=Reflect.decorate(e,t,o,i);else for(var s=e.length-1;s>=0;s--)(r=e[s])&&(a=(n<3?r(a):n>3?r(t,o,a):r(t,o))||a);return n>3&&a&&Object.defineProperty(t,o,a),a};let er=class extends z.LitElement{constructor(){super(),this.unsubscribe=[],this.token=s.SendController.state.token,this.sendTokenAmount=s.SendController.state.sendTokenAmount,this.receiverAddress=s.SendController.state.receiverAddress,this.receiverProfileName=s.SendController.state.receiverProfileName,this.receiverProfileImageUrl=s.SendController.state.receiverProfileImageUrl,this.caipNetwork=r.ChainController.state.activeCaipNetwork,this.loading=s.SendController.state.loading,this.unsubscribe.push(s.SendController.subscribe(e=>{this.token=e.token,this.sendTokenAmount=e.sendTokenAmount,this.receiverAddress=e.receiverAddress,this.receiverProfileName=e.receiverProfileName,this.receiverProfileImageUrl=e.receiverProfileImageUrl,this.loading=e.loading}),r.ChainController.subscribeKey("activeCaipNetwork",e=>this.caipNetwork=e))}disconnectedCallback(){this.unsubscribe.forEach(e=>e())}render(){return o.html` <wui-flex flexDirection="column" .padding=${["0","l","l","l"]}>
      <wui-flex gap="xs" flexDirection="column" .padding=${["0","xs","0","xs"]}>
        <wui-flex alignItems="center" justifyContent="space-between">
          <wui-flex flexDirection="column" gap="4xs">
            <wui-text variant="small-400" color="fg-150">Send</wui-text>
            ${this.sendValueTemplate()}
          </wui-flex>
          <wui-preview-item
            text="${this.sendTokenAmount?b.UiHelperUtil.roundNumber(this.sendTokenAmount,6,5):"unknown"} ${this.token?.symbol}"
            .imageSrc=${this.token?.iconUrl}
          ></wui-preview-item>
        </wui-flex>
        <wui-flex>
          <wui-icon color="fg-200" size="md" name="arrowBottom"></wui-icon>
        </wui-flex>
        <wui-flex alignItems="center" justifyContent="space-between">
          <wui-text variant="small-400" color="fg-150">To</wui-text>
          <wui-preview-item
            text="${this.receiverProfileName?b.UiHelperUtil.getTruncateString({string:this.receiverProfileName,charsStart:20,charsEnd:0,truncate:"end"}):b.UiHelperUtil.getTruncateString({string:this.receiverAddress?this.receiverAddress:"",charsStart:4,charsEnd:4,truncate:"middle"})}"
            address=${this.receiverAddress??""}
            .imageSrc=${this.receiverProfileImageUrl??void 0}
            .isAddress=${!0}
          ></wui-preview-item>
        </wui-flex>
      </wui-flex>
      <wui-flex flexDirection="column" .padding=${["xxl","0","0","0"]}>
        <w3m-wallet-send-details
          .caipNetwork=${this.caipNetwork}
          .receiverAddress=${this.receiverAddress}
        ></w3m-wallet-send-details>
        <wui-flex justifyContent="center" gap="xxs" .padding=${["s","0","0","0"]}>
          <wui-icon size="sm" color="fg-200" name="warningCircle"></wui-icon>
          <wui-text variant="small-400" color="fg-200">Review transaction carefully</wui-text>
        </wui-flex>
        <wui-flex justifyContent="center" gap="s" .padding=${["l","0","0","0"]}>
          <wui-button
            class="cancelButton"
            @click=${this.onCancelClick.bind(this)}
            size="lg"
            variant="neutral"
          >
            Cancel
          </wui-button>
          <wui-button
            class="sendButton"
            @click=${this.onSendClick.bind(this)}
            size="lg"
            variant="main"
            .loading=${this.loading}
          >
            Send
          </wui-button>
        </wui-flex>
      </wui-flex></wui-flex
    >`}sendValueTemplate(){if(this.token&&this.sendTokenAmount){let e=this.token.price*this.sendTokenAmount;return o.html`<wui-text variant="paragraph-400" color="fg-100"
        >$${e.toFixed(2)}</wui-text
      >`}return null}async onSendClick(){if(!this.sendTokenAmount||!this.receiverAddress)return void F.SnackController.showError("Please enter a valid amount and receiver address");try{await s.SendController.sendToken(),F.SnackController.showSuccess("Transaction started"),a.RouterController.replace("Account")}catch(t){F.SnackController.showError("Failed to send transaction. Please try again."),console.error("SendController:sendToken - failed to send transaction",t);let e=t instanceof Error?t.message:"Unknown error";j.EventsController.sendEvent({type:"track",event:"SEND_ERROR",properties:{message:e,isSmartAccount:(0,M.getPreferredAccountType)(r.ChainController.state.activeChain)===_.W3mFrameRpcConstants.ACCOUNT_TYPES.SMART_ACCOUNT,token:this.token?.symbol||"",amount:this.sendTokenAmount,network:r.ChainController.state.activeCaipNetwork?.caipNetworkId||""}})}}onCancelClick(){a.RouterController.goBack()}};er.styles=eo,ei([(0,i.state)()],er.prototype,"token",void 0),ei([(0,i.state)()],er.prototype,"sendTokenAmount",void 0),ei([(0,i.state)()],er.prototype,"receiverAddress",void 0),ei([(0,i.state)()],er.prototype,"receiverProfileName",void 0),ei([(0,i.state)()],er.prototype,"receiverProfileImageUrl",void 0),ei([(0,i.state)()],er.prototype,"caipNetwork",void 0),ei([(0,i.state)()],er.prototype,"loading",void 0),er=ei([(0,c.customElement)("w3m-wallet-send-preview-view")],er),e.s(["W3mWalletSendPreviewView",()=>er],209162),e.s([],733575),e.i(733575),e.i(905689),e.i(148193),e.i(209162),e.s(["W3mSendSelectTokenView",()=>O,"W3mWalletSendPreviewView",()=>er,"W3mWalletSendView",()=>R],408887)}]);