(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,406627,e=>{"use strict";e.i(588984);var t=e.i(399702),i=e.i(872857);e.i(302184);var r=e.i(938559);e.i(237029),e.i(801461);var l=e.i(118827);let o=l.css`
  :host > wui-flex:first-child {
    height: 500px;
    overflow-y: auto;
    overflow-x: hidden;
    scrollbar-width: none;
  }

  :host > wui-flex:first-child::-webkit-scrollbar {
    display: none;
  }
`,s=class extends t.LitElement{render(){return i.html`
      <wui-flex flexDirection="column" .padding=${["0","m","m","m"]} gap="s">
        <w3m-activity-list page="activity"></w3m-activity-list>
      </wui-flex>
    `}};s.styles=o,s=function(e,t,i,r){var l,o=arguments.length,s=o<3?t:null===r?r=Object.getOwnPropertyDescriptor(t,i):r;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)s=Reflect.decorate(e,t,i,r);else for(var c=e.length-1;c>=0;c--)(l=e[c])&&(s=(o<3?l(s):o>3?l(t,i,s):l(t,i))||s);return o>3&&s&&Object.defineProperty(t,i,s),s}([(0,r.customElement)("w3m-transactions-view")],s),e.s(["W3mTransactionsView",()=>s],848185),e.s([],972533),e.i(972533),e.i(848185),e.s(["W3mTransactionsView",()=>s],406627)}]);