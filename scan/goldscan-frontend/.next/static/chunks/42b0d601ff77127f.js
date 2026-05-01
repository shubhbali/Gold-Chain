(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,567549,r=>{"use strict";var o="[big.js] ",e=o+"Invalid ",i=e+"decimal places",t=e+"rounding mode",a=o+"Division by zero",s={},n=void 0,c=/^-?(\d+(\.\d*)?|\.\d+)(e[+-]?\d+)?$/i;function u(r,o,e,i){var a=r.c;if(e===n&&(e=r.constructor.RM),0!==e&&1!==e&&2!==e&&3!==e)throw Error(t);if(o<1)i=3===e&&(i||!!a[0])||0===o&&(1===e&&a[0]>=5||2===e&&(a[0]>5||5===a[0]&&(i||a[1]!==n))),a.length=1,i?(r.e=r.e-o+1,a[0]=1):a[0]=r.e=0;else if(o<a.length){if(i=1===e&&a[o]>=5||2===e&&(a[o]>5||5===a[o]&&(i||a[o+1]!==n||1&a[o-1]))||3===e&&(i||!!a[0]),a.length=o,i){for(;++a[--o]>9;)if(a[o]=0,0===o){++r.e,a.unshift(1);break}}for(o=a.length;!a[--o];)a.pop()}return r}function l(r,o,e){var i=r.e,t=r.c.join(""),a=t.length;if(o)t=t.charAt(0)+(a>1?"."+t.slice(1):"")+(i<0?"e":"e+")+i;else if(i<0){for(;++i;)t="0"+t;t="0."+t}else if(i>0)if(++i>a)for(i-=a;i--;)t+="0";else i<a&&(t=t.slice(0,i)+"."+t.slice(i));else a>1&&(t=t.charAt(0)+"."+t.slice(1));return r.s<0&&e?"-"+t:t}s.abs=function(){var r=new this.constructor(this);return r.s=1,r},s.cmp=function(r){var o,e=this.c,i=(r=new this.constructor(r)).c,t=this.s,a=r.s,s=this.e,n=r.e;if(!e[0]||!i[0])return e[0]?t:i[0]?-a:0;if(t!=a)return t;if(o=t<0,s!=n)return s>n^o?1:-1;for(t=-1,a=(s=e.length)<(n=i.length)?s:n;++t<a;)if(e[t]!=i[t])return e[t]>i[t]^o?1:-1;return s==n?0:s>n^o?1:-1},s.div=function(r){var o=this.constructor,e=this.c,t=(r=new o(r)).c,s=this.s==r.s?1:-1,c=o.DP;if(c!==~~c||c<0||c>1e6)throw Error(i);if(!t[0])throw Error(a);if(!e[0])return r.s=s,r.c=[r.e=0],r;var l,w,g,b,m,f=t.slice(),d=l=t.length,h=e.length,v=e.slice(0,l),x=v.length,p=r,y=p.c=[],$=0,S=c+(p.e=this.e-r.e)+1;for(p.s=s,s=S<0?0:S,f.unshift(0);x++<l;)v.push(0);do{for(g=0;g<10;g++){if(l!=(x=v.length))b=l>x?1:-1;else for(m=-1,b=0;++m<l;)if(t[m]!=v[m]){b=t[m]>v[m]?1:-1;break}if(b<0){for(w=x==l?t:f;x;){if(v[--x]<w[x]){for(m=x;m&&!v[--m];)v[m]=9;--v[m],v[x]+=10}v[x]-=w[x]}for(;!v[0];)v.shift()}else break}y[$++]=b?g:++g,v[0]&&b?v[x]=e[d]||0:v=[e[d]]}while((d++<h||v[0]!==n)&&s--)return!y[0]&&1!=$&&(y.shift(),p.e--,S--),$>S&&u(p,S,o.RM,v[0]!==n),p},s.eq=function(r){return 0===this.cmp(r)},s.gt=function(r){return this.cmp(r)>0},s.gte=function(r){return this.cmp(r)>-1},s.lt=function(r){return 0>this.cmp(r)},s.lte=function(r){return 1>this.cmp(r)},s.minus=s.sub=function(r){var o,e,i,t,a=this.constructor,s=this.s,n=(r=new a(r)).s;if(s!=n)return r.s=-n,this.plus(r);var c=this.c.slice(),u=this.e,l=r.c,w=r.e;if(!c[0]||!l[0])return l[0]?r.s=-n:c[0]?r=new a(this):r.s=1,r;if(s=u-w){for((t=s<0)?(s=-s,i=c):(w=u,i=l),i.reverse(),n=s;n--;)i.push(0);i.reverse()}else for(e=((t=c.length<l.length)?c:l).length,s=n=0;n<e;n++)if(c[n]!=l[n]){t=c[n]<l[n];break}if(t&&(i=c,c=l,l=i,r.s=-r.s),(n=(e=l.length)-(o=c.length))>0)for(;n--;)c[o++]=0;for(n=o;e>s;){if(c[--e]<l[e]){for(o=e;o&&!c[--o];)c[o]=9;--c[o],c[e]+=10}c[e]-=l[e]}for(;0===c[--n];)c.pop();for(;0===c[0];)c.shift(),--w;return c[0]||(r.s=1,c=[w=0]),r.c=c,r.e=w,r},s.mod=function(r){var o,e=this,i=e.constructor,t=e.s,s=(r=new i(r)).s;if(!r.c[0])throw Error(a);return(e.s=r.s=1,o=1==r.cmp(e),e.s=t,r.s=s,o)?new i(e):(t=i.DP,s=i.RM,i.DP=i.RM=0,e=e.div(r),i.DP=t,i.RM=s,this.minus(e.times(r)))},s.neg=function(){var r=new this.constructor(this);return r.s=-r.s,r},s.plus=s.add=function(r){var o,e,i,t=this.constructor;if(r=new t(r),this.s!=r.s)return r.s=-r.s,this.minus(r);var a=this.e,s=this.c,n=r.e,c=r.c;if(!s[0]||!c[0])return c[0]||(s[0]?r=new t(this):r.s=this.s),r;if(s=s.slice(),o=a-n){for(o>0?(n=a,i=c):(o=-o,i=s),i.reverse();o--;)i.push(0);i.reverse()}for(s.length-c.length<0&&(i=c,c=s,s=i),o=c.length,e=0;o;s[o]%=10)e=(s[--o]=s[o]+c[o]+e)/10|0;for(e&&(s.unshift(e),++n),o=s.length;0===s[--o];)s.pop();return r.c=s,r.e=n,r},s.pow=function(r){var o=this,i=new o.constructor("1"),t=i,a=r<0;if(r!==~~r||r<-1e6||r>1e6)throw Error(e+"exponent");for(a&&(r=-r);1&r&&(t=t.times(o)),r>>=1;)o=o.times(o);return a?i.div(t):t},s.prec=function(r,o){if(r!==~~r||r<1||r>1e6)throw Error(e+"precision");return u(new this.constructor(this),r,o)},s.round=function(r,o){if(r===n)r=0;else if(r!==~~r||r<-1e6||r>1e6)throw Error(i);return u(new this.constructor(this),r+this.e+1,o)},s.sqrt=function(){var r,e,i,t=this.constructor,a=this.s,s=this.e,n=new t("0.5");if(!this.c[0])return new t(this);if(a<0)throw Error(o+"No square root");0===(a=Math.sqrt(+l(this,!0,!0)))||a===1/0?((e=this.c.join("")).length+s&1||(e+="0"),s=((s+1)/2|0)-(s<0||1&s),r=new t(((a=Math.sqrt(e))==1/0?"5e":(a=a.toExponential()).slice(0,a.indexOf("e")+1))+s)):r=new t(a+""),s=r.e+(t.DP+=4);do i=r,r=n.times(i.plus(this.div(i)));while(i.c.slice(0,s).join("")!==r.c.slice(0,s).join(""))return u(r,(t.DP-=4)+r.e+1,t.RM)},s.times=s.mul=function(r){var o,e=this.constructor,i=this.c,t=(r=new e(r)).c,a=i.length,s=t.length,n=this.e,c=r.e;if(r.s=this.s==r.s?1:-1,!i[0]||!t[0])return r.c=[r.e=0],r;for(r.e=n+c,a<s&&(o=i,i=t,t=o,c=a,a=s,s=c),o=Array(c=a+s);c--;)o[c]=0;for(n=s;n--;){for(s=0,c=a+n;c>n;)s=o[c]+t[n]*i[c-n-1]+s,o[c--]=s%10,s=s/10|0;o[c]=s}for(s?++r.e:o.shift(),n=o.length;!o[--n];)o.pop();return r.c=o,r},s.toExponential=function(r,o){var e=this,t=e.c[0];if(r!==n){if(r!==~~r||r<0||r>1e6)throw Error(i);for(e=u(new e.constructor(e),++r,o);e.c.length<r;)e.c.push(0)}return l(e,!0,!!t)},s.toFixed=function(r,o){var e=this,t=e.c[0];if(r!==n){if(r!==~~r||r<0||r>1e6)throw Error(i);for(e=u(new e.constructor(e),r+e.e+1,o),r=r+e.e+1;e.c.length<r;)e.c.push(0)}return l(e,!1,!!t)},s[Symbol.for("nodejs.util.inspect.custom")]=s.toJSON=s.toString=function(){var r=this.constructor;return l(this,this.e<=r.NE||this.e>=r.PE,!!this.c[0])},s.toNumber=function(){var r=+l(this,!0,!0);if(!0===this.constructor.strict&&!this.eq(r.toString()))throw Error(o+"Imprecise conversion");return r},s.toPrecision=function(r,o){var i=this,t=i.constructor,a=i.c[0];if(r!==n){if(r!==~~r||r<1||r>1e6)throw Error(e+"precision");for(i=u(new t(i),r,o);i.c.length<r;)i.c.push(0)}return l(i,r<=i.e||i.e<=t.NE||i.e>=t.PE,!!a)},s.valueOf=function(){var r=this.constructor;if(!0===r.strict)throw Error(o+"valueOf disallowed");return l(this,this.e<=r.NE||this.e>=r.PE,!0)};var w=function r(){function o(i){if(!(this instanceof o))return i===n?r():new o(i);if(i instanceof o)this.s=i.s,this.e=i.e,this.c=i.c.slice();else{if("string"!=typeof i){if(!0===o.strict&&"bigint"!=typeof i)throw TypeError(e+"value");i=0===i&&1/i<0?"-0":String(i)}!function(r,o){var i,t,a;if(!c.test(o))throw Error(e+"number");for(r.s="-"==o.charAt(0)?(o=o.slice(1),-1):1,(i=o.indexOf("."))>-1&&(o=o.replace(".","")),(t=o.search(/e/i))>0?(i<0&&(i=t),i+=+o.slice(t+1),o=o.substring(0,t)):i<0&&(i=o.length),a=o.length,t=0;t<a&&"0"==o.charAt(t);)++t;if(t==a)r.c=[r.e=0];else{for(;a>0&&"0"==o.charAt(--a););for(r.e=i-t-1,r.c=[],i=0;t<=a;)r.c[i++]=+o.charAt(t++)}}(this,i)}this.constructor=o}return o.prototype=s,o.DP=20,o.RM=1,o.NE=-7,o.PE=21,o.strict=!1,o.roundDown=0,o.roundHalfUp=1,o.roundHalfEven=2,o.roundUp=3,o}();r.s(["default",0,w])},118827,r=>{"use strict";var o=r.i(535178),e=r.i(334736);r.s(["CSSResult",()=>e.CSSResult,"ReactiveElement",()=>o.ReactiveElement,"adoptStyles",()=>e.adoptStyles,"css",()=>e.css,"defaultConverter",()=>o.defaultConverter,"getCompatibleStyle",()=>e.getCompatibleStyle,"notEqual",()=>o.notEqual,"supportsAdoptingStyleSheets",()=>e.supportsAdoptingStyleSheets,"unsafeCSS",()=>e.unsafeCSS])},55956,(r,o,e)=>{r.e,o.exports=function(){"use strict";var r="millisecond",o="second",e="minute",i="hour",t="week",a="month",s="quarter",n="year",c="date",u="Invalid Date",l=/^(\d{4})[-/]?(\d{1,2})?[-/]?(\d{0,2})[Tt\s]*(\d{1,2})?:?(\d{1,2})?:?(\d{1,2})?[.:]?(\d+)?$/,w=/\[([^\]]+)]|Y{1,4}|M{1,4}|D{1,2}|d{1,4}|H{1,2}|h{1,2}|a|A|m{1,2}|s{1,2}|Z{1,2}|SSS/g,g=function(r,o,e){var i=String(r);return!i||i.length>=o?r:""+Array(o+1-i.length).join(e)+r},b="en",m={};m[b]={name:"en",weekdays:"Sunday_Monday_Tuesday_Wednesday_Thursday_Friday_Saturday".split("_"),months:"January_February_March_April_May_June_July_August_September_October_November_December".split("_"),ordinal:function(r){var o=["th","st","nd","rd"],e=r%100;return"["+r+(o[(e-20)%10]||o[e]||o[0])+"]"}};var f="$isDayjsObject",d=function(r){return r instanceof p||!(!r||!r[f])},h=function r(o,e,i){var t;if(!o)return b;if("string"==typeof o){var a=o.toLowerCase();m[a]&&(t=a),e&&(m[a]=e,t=a);var s=o.split("-");if(!t&&s.length>1)return r(s[0])}else{var n=o.name;m[n]=o,t=n}return!i&&t&&(b=t),t||!i&&b},v=function(r,o){if(d(r))return r.clone();var e="object"==typeof o?o:{};return e.date=r,e.args=arguments,new p(e)},x={s:g,z:function(r){var o=-r.utcOffset(),e=Math.abs(o);return(o<=0?"+":"-")+g(Math.floor(e/60),2,"0")+":"+g(e%60,2,"0")},m:function r(o,e){if(o.date()<e.date())return-r(e,o);var i=12*(e.year()-o.year())+(e.month()-o.month()),t=o.clone().add(i,a),s=e-t<0,n=o.clone().add(i+(s?-1:1),a);return+(-(i+(e-t)/(s?t-n:n-t))||0)},a:function(r){return r<0?Math.ceil(r)||0:Math.floor(r)},p:function(u){return({M:a,y:n,w:t,d:"day",D:c,h:i,m:e,s:o,ms:r,Q:s})[u]||String(u||"").toLowerCase().replace(/s$/,"")},u:function(r){return void 0===r}};x.l=h,x.i=d,x.w=function(r,o){return v(r,{locale:o.$L,utc:o.$u,x:o.$x,$offset:o.$offset})};var p=function(){function g(r){this.$L=h(r.locale,null,!0),this.parse(r),this.$x=this.$x||r.x||{},this[f]=!0}var b=g.prototype;return b.parse=function(r){this.$d=function(r){var o=r.date,e=r.utc;if(null===o)return new Date(NaN);if(x.u(o))return new Date;if(o instanceof Date)return new Date(o);if("string"==typeof o&&!/Z$/i.test(o)){var i=o.match(l);if(i){var t=i[2]-1||0,a=(i[7]||"0").substring(0,3);return e?new Date(Date.UTC(i[1],t,i[3]||1,i[4]||0,i[5]||0,i[6]||0,a)):new Date(i[1],t,i[3]||1,i[4]||0,i[5]||0,i[6]||0,a)}}return new Date(o)}(r),this.init()},b.init=function(){var r=this.$d;this.$y=r.getFullYear(),this.$M=r.getMonth(),this.$D=r.getDate(),this.$W=r.getDay(),this.$H=r.getHours(),this.$m=r.getMinutes(),this.$s=r.getSeconds(),this.$ms=r.getMilliseconds()},b.$utils=function(){return x},b.isValid=function(){return this.$d.toString()!==u},b.isSame=function(r,o){var e=v(r);return this.startOf(o)<=e&&e<=this.endOf(o)},b.isAfter=function(r,o){return v(r)<this.startOf(o)},b.isBefore=function(r,o){return this.endOf(o)<v(r)},b.$g=function(r,o,e){return x.u(r)?this[o]:this.set(e,r)},b.unix=function(){return Math.floor(this.valueOf()/1e3)},b.valueOf=function(){return this.$d.getTime()},b.startOf=function(r,s){var u=this,l=!!x.u(s)||s,w=x.p(r),g=function(r,o){var e=x.w(u.$u?Date.UTC(u.$y,o,r):new Date(u.$y,o,r),u);return l?e:e.endOf("day")},b=function(r,o){return x.w(u.toDate()[r].apply(u.toDate("s"),(l?[0,0,0,0]:[23,59,59,999]).slice(o)),u)},m=this.$W,f=this.$M,d=this.$D,h="set"+(this.$u?"UTC":"");switch(w){case n:return l?g(1,0):g(31,11);case a:return l?g(1,f):g(0,f+1);case t:var v=this.$locale().weekStart||0,p=(m<v?m+7:m)-v;return g(l?d-p:d+(6-p),f);case"day":case c:return b(h+"Hours",0);case i:return b(h+"Minutes",1);case e:return b(h+"Seconds",2);case o:return b(h+"Milliseconds",3);default:return this.clone()}},b.endOf=function(r){return this.startOf(r,!1)},b.$set=function(t,s){var u,l=x.p(t),w="set"+(this.$u?"UTC":""),g=((u={}).day=w+"Date",u[c]=w+"Date",u[a]=w+"Month",u[n]=w+"FullYear",u[i]=w+"Hours",u[e]=w+"Minutes",u[o]=w+"Seconds",u[r]=w+"Milliseconds",u)[l],b="day"===l?this.$D+(s-this.$W):s;if(l===a||l===n){var m=this.clone().set(c,1);m.$d[g](b),m.init(),this.$d=m.set(c,Math.min(this.$D,m.daysInMonth())).$d}else g&&this.$d[g](b);return this.init(),this},b.set=function(r,o){return this.clone().$set(r,o)},b.get=function(r){return this[x.p(r)]()},b.add=function(r,s){var c,u=this;r=Number(r);var l=x.p(s),w=function(o){var e=v(u);return x.w(e.date(e.date()+Math.round(o*r)),u)};if(l===a)return this.set(a,this.$M+r);if(l===n)return this.set(n,this.$y+r);if("day"===l)return w(1);if(l===t)return w(7);var g=((c={})[e]=6e4,c[i]=36e5,c[o]=1e3,c)[l]||1,b=this.$d.getTime()+r*g;return x.w(b,this)},b.subtract=function(r,o){return this.add(-1*r,o)},b.format=function(r){var o=this,e=this.$locale();if(!this.isValid())return e.invalidDate||u;var i=r||"YYYY-MM-DDTHH:mm:ssZ",t=x.z(this),a=this.$H,s=this.$m,n=this.$M,c=e.weekdays,l=e.months,g=e.meridiem,b=function(r,e,t,a){return r&&(r[e]||r(o,i))||t[e].slice(0,a)},m=function(r){return x.s(a%12||12,r,"0")},f=g||function(r,o,e){var i=r<12?"AM":"PM";return e?i.toLowerCase():i};return i.replace(w,function(r,i){return i||function(r){switch(r){case"YY":return String(o.$y).slice(-2);case"YYYY":return x.s(o.$y,4,"0");case"M":return n+1;case"MM":return x.s(n+1,2,"0");case"MMM":return b(e.monthsShort,n,l,3);case"MMMM":return b(l,n);case"D":return o.$D;case"DD":return x.s(o.$D,2,"0");case"d":return String(o.$W);case"dd":return b(e.weekdaysMin,o.$W,c,2);case"ddd":return b(e.weekdaysShort,o.$W,c,3);case"dddd":return c[o.$W];case"H":return String(a);case"HH":return x.s(a,2,"0");case"h":return m(1);case"hh":return m(2);case"a":return f(a,s,!0);case"A":return f(a,s,!1);case"m":return String(s);case"mm":return x.s(s,2,"0");case"s":return String(o.$s);case"ss":return x.s(o.$s,2,"0");case"SSS":return x.s(o.$ms,3,"0");case"Z":return t}return null}(r)||t.replace(":","")})},b.utcOffset=function(){return-(15*Math.round(this.$d.getTimezoneOffset()/15))},b.diff=function(r,c,u){var l,w=this,g=x.p(c),b=v(r),m=(b.utcOffset()-this.utcOffset())*6e4,f=this-b,d=function(){return x.m(w,b)};switch(g){case n:l=d()/12;break;case a:l=d();break;case s:l=d()/3;break;case t:l=(f-m)/6048e5;break;case"day":l=(f-m)/864e5;break;case i:l=f/36e5;break;case e:l=f/6e4;break;case o:l=f/1e3;break;default:l=f}return u?l:x.a(l)},b.daysInMonth=function(){return this.endOf(a).$D},b.$locale=function(){return m[this.$L]},b.locale=function(r,o){if(!r)return this.$L;var e=this.clone(),i=h(r,o,!0);return i&&(e.$L=i),e},b.clone=function(){return x.w(this.$d,this)},b.toDate=function(){return new Date(this.valueOf())},b.toJSON=function(){return this.isValid()?this.toISOString():null},b.toISOString=function(){return this.$d.toISOString()},b.toString=function(){return this.$d.toUTCString()},g}(),y=p.prototype;return v.prototype=y,[["$ms",r],["$s",o],["$m",e],["$H",i],["$W","day"],["$M",a],["$y",n],["$D",c]].forEach(function(r){y[r[1]]=function(o){return this.$g(o,r[0],r[1])}}),v.extend=function(r,o){return r.$i||(r(o,p,v),r.$i=!0),v},v.locale=h,v.isDayjs=d,v.unix=function(r){return v(1e3*r)},v.en=m[b],v.Ls=m,v.p={},v}()},549984,(r,o,e)=>{r.e,o.exports={name:"en",weekdays:"Sunday_Monday_Tuesday_Wednesday_Thursday_Friday_Saturday".split("_"),months:"January_February_March_April_May_June_July_August_September_October_November_December".split("_"),ordinal:function(r){var o=["th","st","nd","rd"],e=r%100;return"["+r+(o[(e-20)%10]||o[e]||o[0])+"]"}}},488194,(r,o,e)=>{r.e,o.exports=function(r,o,e){r=r||{};var i=o.prototype,t={future:"in %s",past:"%s ago",s:"a few seconds",m:"a minute",mm:"%d minutes",h:"an hour",hh:"%d hours",d:"a day",dd:"%d days",M:"a month",MM:"%d months",y:"a year",yy:"%d years"};function a(r,o,e,t){return i.fromToBase(r,o,e,t)}e.en.relativeTime=t,i.fromToBase=function(o,i,a,s,n){for(var c,u,l,w=a.$locale().relativeTime||t,g=r.thresholds||[{l:"s",r:44,d:"second"},{l:"m",r:89},{l:"mm",r:44,d:"minute"},{l:"h",r:89},{l:"hh",r:21,d:"hour"},{l:"d",r:35},{l:"dd",r:25,d:"day"},{l:"M",r:45},{l:"MM",r:10,d:"month"},{l:"y",r:17},{l:"yy",d:"year"}],b=g.length,m=0;m<b;m+=1){var f=g[m];f.d&&(c=s?e(o).diff(a,f.d,!0):a.diff(o,f.d,!0));var d=(r.rounding||Math.round)(Math.abs(c));if(l=c>0,d<=f.r||!f.r){d<=1&&m>0&&(f=g[m-1]);var h=w[f.l];n&&(d=n(""+d)),u="string"==typeof h?h.replace("%d",d):h(d,i,f.l,l);break}}if(i)return u;var v=l?w.future:w.past;return"function"==typeof v?v(u):v.replace("%s",u)},i.to=function(r,o){return a(r,o,this,!0)},i.from=function(r,o){return a(r,o,this)};var s=function(r){return r.$u?e.utc():e()};i.toNow=function(r){return this.to(s(this),r)},i.fromNow=function(r){return this.from(s(this),r)}}},555634,(r,o,e)=>{r.e,o.exports=function(r,o,e){e.updateLocale=function(r,o){var i=e.Ls[r];if(i)return(o?Object.keys(o):[]).forEach(function(r){i[r]=o[r]}),i}}},302184,504609,864429,34691,660506,414737,938559,r=>{"use strict";let o,e,i;r.s(["MathUtil",0,{interpolate(r,o,e){if(2!==r.length||2!==o.length)throw Error("inputRange and outputRange must be an array of length 2");let i=r[0]||0,t=r[1]||0,a=o[0]||0,s=o[1]||0;return e<i?a:e>t?s:(s-a)/(t-i)*(e-i)+a}}],504609),r.i(588984);var t=r.i(118827),a=r.i(263342);function s(r,t){o=document.createElement("style"),e=document.createElement("style"),i=document.createElement("style"),o.textContent=u(r).core.cssText,e.textContent=u(r).dark.cssText,i.textContent=u(r).light.cssText,document.head.appendChild(o),document.head.appendChild(e),document.head.appendChild(i),n(t)}function n(r){e&&i&&("light"===r?(e.removeAttribute("media"),i.media="enabled"):(i.removeAttribute("media"),e.media="enabled"))}function c(r){o&&e&&i&&(o.textContent=u(r).core.cssText,e.textContent=u(r).dark.cssText,i.textContent=u(r).light.cssText)}function u(r){return{core:t.css`
      ${r?.["--w3m-font-family"]?t.css``:t.css`
            @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
          `}
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
      @keyframes w3m-iframe-fade-out {
        0% {
          opacity: 1;
        }
        100% {
          opacity: 0;
        }
      }
      @keyframes w3m-iframe-zoom-in {
        0% {
          transform: translateY(50px);
          opacity: 0;
        }
        100% {
          transform: translateY(0px);
          opacity: 1;
        }
      }
      @keyframes w3m-iframe-zoom-in-mobile {
        0% {
          transform: scale(0.95);
          opacity: 0;
        }
        100% {
          transform: scale(1);
          opacity: 1;
        }
      }
      :root {
        --w3m-modal-width: 360px;
        --w3m-color-mix-strength: ${(0,t.unsafeCSS)(r?.["--w3m-color-mix-strength"]?`${r["--w3m-color-mix-strength"]}%`:"0%")};
        --w3m-font-family: ${(0,t.unsafeCSS)(r?.["--w3m-font-family"]||"Inter, Segoe UI, Roboto, Oxygen, Ubuntu, Cantarell, Fira Sans, Droid Sans, Helvetica Neue, sans-serif;")};
        --w3m-font-size-master: ${(0,t.unsafeCSS)(r?.["--w3m-font-size-master"]||"10px")};
        --w3m-border-radius-master: ${(0,t.unsafeCSS)(r?.["--w3m-border-radius-master"]||"4px")};
        --w3m-z-index: ${(0,t.unsafeCSS)(r?.["--w3m-z-index"]||999)};

        --wui-font-family: var(--w3m-font-family);

        --wui-font-size-mini: calc(var(--w3m-font-size-master) * 0.8);
        --wui-font-size-micro: var(--w3m-font-size-master);
        --wui-font-size-tiny: calc(var(--w3m-font-size-master) * 1.2);
        --wui-font-size-small: calc(var(--w3m-font-size-master) * 1.4);
        --wui-font-size-paragraph: calc(var(--w3m-font-size-master) * 1.6);
        --wui-font-size-medium: calc(var(--w3m-font-size-master) * 1.8);
        --wui-font-size-large: calc(var(--w3m-font-size-master) * 2);
        --wui-font-size-title-6: calc(var(--w3m-font-size-master) * 2.2);
        --wui-font-size-medium-title: calc(var(--w3m-font-size-master) * 2.4);
        --wui-font-size-2xl: calc(var(--w3m-font-size-master) * 4);

        --wui-border-radius-5xs: var(--w3m-border-radius-master);
        --wui-border-radius-4xs: calc(var(--w3m-border-radius-master) * 1.5);
        --wui-border-radius-3xs: calc(var(--w3m-border-radius-master) * 2);
        --wui-border-radius-xxs: calc(var(--w3m-border-radius-master) * 3);
        --wui-border-radius-xs: calc(var(--w3m-border-radius-master) * 4);
        --wui-border-radius-s: calc(var(--w3m-border-radius-master) * 5);
        --wui-border-radius-m: calc(var(--w3m-border-radius-master) * 7);
        --wui-border-radius-l: calc(var(--w3m-border-radius-master) * 9);
        --wui-border-radius-3xl: calc(var(--w3m-border-radius-master) * 20);

        --wui-font-weight-light: 400;
        --wui-font-weight-regular: 500;
        --wui-font-weight-medium: 600;
        --wui-font-weight-bold: 700;

        --wui-letter-spacing-2xl: -1.6px;
        --wui-letter-spacing-medium-title: -0.96px;
        --wui-letter-spacing-title-6: -0.88px;
        --wui-letter-spacing-large: -0.8px;
        --wui-letter-spacing-medium: -0.72px;
        --wui-letter-spacing-paragraph: -0.64px;
        --wui-letter-spacing-small: -0.56px;
        --wui-letter-spacing-tiny: -0.48px;
        --wui-letter-spacing-micro: -0.2px;
        --wui-letter-spacing-mini: -0.16px;

        --wui-spacing-0: 0px;
        --wui-spacing-4xs: 2px;
        --wui-spacing-3xs: 4px;
        --wui-spacing-xxs: 6px;
        --wui-spacing-2xs: 7px;
        --wui-spacing-xs: 8px;
        --wui-spacing-1xs: 10px;
        --wui-spacing-s: 12px;
        --wui-spacing-m: 14px;
        --wui-spacing-l: 16px;
        --wui-spacing-2l: 18px;
        --wui-spacing-xl: 20px;
        --wui-spacing-xxl: 24px;
        --wui-spacing-2xl: 32px;
        --wui-spacing-3xl: 40px;
        --wui-spacing-4xl: 90px;
        --wui-spacing-5xl: 95px;

        --wui-icon-box-size-xxs: 14px;
        --wui-icon-box-size-xs: 20px;
        --wui-icon-box-size-sm: 24px;
        --wui-icon-box-size-md: 32px;
        --wui-icon-box-size-mdl: 36px;
        --wui-icon-box-size-lg: 40px;
        --wui-icon-box-size-2lg: 48px;
        --wui-icon-box-size-xl: 64px;

        --wui-icon-size-inherit: inherit;
        --wui-icon-size-xxs: 10px;
        --wui-icon-size-xs: 12px;
        --wui-icon-size-sm: 14px;
        --wui-icon-size-md: 16px;
        --wui-icon-size-mdl: 18px;
        --wui-icon-size-lg: 20px;
        --wui-icon-size-xl: 24px;
        --wui-icon-size-xxl: 28px;

        --wui-wallet-image-size-inherit: inherit;
        --wui-wallet-image-size-sm: 40px;
        --wui-wallet-image-size-md: 56px;
        --wui-wallet-image-size-lg: 80px;

        --wui-visual-size-size-inherit: inherit;
        --wui-visual-size-sm: 40px;
        --wui-visual-size-md: 55px;
        --wui-visual-size-lg: 80px;

        --wui-box-size-md: 100px;
        --wui-box-size-lg: 120px;

        --wui-ease-out-power-2: cubic-bezier(0, 0, 0.22, 1);
        --wui-ease-out-power-1: cubic-bezier(0, 0, 0.55, 1);

        --wui-ease-in-power-3: cubic-bezier(0.66, 0, 1, 1);
        --wui-ease-in-power-2: cubic-bezier(0.45, 0, 1, 1);
        --wui-ease-in-power-1: cubic-bezier(0.3, 0, 1, 1);

        --wui-ease-inout-power-1: cubic-bezier(0.45, 0, 0.55, 1);

        --wui-duration-lg: 200ms;
        --wui-duration-md: 125ms;
        --wui-duration-sm: 75ms;

        --wui-path-network-sm: path(
          'M15.4 2.1a5.21 5.21 0 0 1 5.2 0l11.61 6.7a5.21 5.21 0 0 1 2.61 4.52v13.4c0 1.87-1 3.59-2.6 4.52l-11.61 6.7c-1.62.93-3.6.93-5.22 0l-11.6-6.7a5.21 5.21 0 0 1-2.61-4.51v-13.4c0-1.87 1-3.6 2.6-4.52L15.4 2.1Z'
        );

        --wui-path-network-md: path(
          'M43.4605 10.7248L28.0485 1.61089C25.5438 0.129705 22.4562 0.129705 19.9515 1.61088L4.53951 10.7248C2.03626 12.2051 0.5 14.9365 0.5 17.886V36.1139C0.5 39.0635 2.03626 41.7949 4.53951 43.2752L19.9515 52.3891C22.4562 53.8703 25.5438 53.8703 28.0485 52.3891L43.4605 43.2752C45.9637 41.7949 47.5 39.0635 47.5 36.114V17.8861C47.5 14.9365 45.9637 12.2051 43.4605 10.7248Z'
        );

        --wui-path-network-lg: path(
          'M78.3244 18.926L50.1808 2.45078C45.7376 -0.150261 40.2624 -0.150262 35.8192 2.45078L7.6756 18.926C3.23322 21.5266 0.5 26.3301 0.5 31.5248V64.4752C0.5 69.6699 3.23322 74.4734 7.6756 77.074L35.8192 93.5492C40.2624 96.1503 45.7376 96.1503 50.1808 93.5492L78.3244 77.074C82.7668 74.4734 85.5 69.6699 85.5 64.4752V31.5248C85.5 26.3301 82.7668 21.5266 78.3244 18.926Z'
        );

        --wui-width-network-sm: 36px;
        --wui-width-network-md: 48px;
        --wui-width-network-lg: 86px;

        --wui-height-network-sm: 40px;
        --wui-height-network-md: 54px;
        --wui-height-network-lg: 96px;

        --wui-icon-size-network-xs: 12px;
        --wui-icon-size-network-sm: 16px;
        --wui-icon-size-network-md: 24px;
        --wui-icon-size-network-lg: 42px;

        --wui-color-inherit: inherit;

        --wui-color-inverse-100: #fff;
        --wui-color-inverse-000: #000;

        --wui-cover: rgba(20, 20, 20, 0.8);

        --wui-color-modal-bg: var(--wui-color-modal-bg-base);

        --wui-color-accent-100: var(--wui-color-accent-base-100);
        --wui-color-accent-090: var(--wui-color-accent-base-090);
        --wui-color-accent-080: var(--wui-color-accent-base-080);

        --wui-color-success-100: var(--wui-color-success-base-100);
        --wui-color-success-125: var(--wui-color-success-base-125);

        --wui-color-warning-100: var(--wui-color-warning-base-100);

        --wui-color-error-100: var(--wui-color-error-base-100);
        --wui-color-error-125: var(--wui-color-error-base-125);

        --wui-color-blue-100: var(--wui-color-blue-base-100);
        --wui-color-blue-90: var(--wui-color-blue-base-90);

        --wui-icon-box-bg-error-100: var(--wui-icon-box-bg-error-base-100);
        --wui-icon-box-bg-blue-100: var(--wui-icon-box-bg-blue-base-100);
        --wui-icon-box-bg-success-100: var(--wui-icon-box-bg-success-base-100);
        --wui-icon-box-bg-inverse-100: var(--wui-icon-box-bg-inverse-base-100);

        --wui-all-wallets-bg-100: var(--wui-all-wallets-bg-100);

        --wui-avatar-border: var(--wui-avatar-border-base);

        --wui-thumbnail-border: var(--wui-thumbnail-border-base);

        --wui-wallet-button-bg: var(--wui-wallet-button-bg-base);

        --wui-box-shadow-blue: var(--wui-color-accent-glass-020);
      }

      @supports (background: color-mix(in srgb, white 50%, black)) {
        :root {
          --wui-color-modal-bg: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-modal-bg-base)
          );

          --wui-box-shadow-blue: color-mix(in srgb, var(--wui-color-accent-100) 20%, transparent);

          --wui-color-accent-100: color-mix(
            in srgb,
            var(--wui-color-accent-base-100) 100%,
            transparent
          );
          --wui-color-accent-090: color-mix(
            in srgb,
            var(--wui-color-accent-base-100) 90%,
            transparent
          );
          --wui-color-accent-080: color-mix(
            in srgb,
            var(--wui-color-accent-base-100) 80%,
            transparent
          );
          --wui-color-accent-glass-090: color-mix(
            in srgb,
            var(--wui-color-accent-base-100) 90%,
            transparent
          );
          --wui-color-accent-glass-080: color-mix(
            in srgb,
            var(--wui-color-accent-base-100) 80%,
            transparent
          );
          --wui-color-accent-glass-020: color-mix(
            in srgb,
            var(--wui-color-accent-base-100) 20%,
            transparent
          );
          --wui-color-accent-glass-015: color-mix(
            in srgb,
            var(--wui-color-accent-base-100) 15%,
            transparent
          );
          --wui-color-accent-glass-010: color-mix(
            in srgb,
            var(--wui-color-accent-base-100) 10%,
            transparent
          );
          --wui-color-accent-glass-005: color-mix(
            in srgb,
            var(--wui-color-accent-base-100) 5%,
            transparent
          );
          --wui-color-accent-002: color-mix(
            in srgb,
            var(--wui-color-accent-base-100) 2%,
            transparent
          );

          --wui-color-fg-100: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-fg-100)
          );
          --wui-color-fg-125: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-fg-125)
          );
          --wui-color-fg-150: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-fg-150)
          );
          --wui-color-fg-175: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-fg-175)
          );
          --wui-color-fg-200: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-fg-200)
          );
          --wui-color-fg-225: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-fg-225)
          );
          --wui-color-fg-250: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-fg-250)
          );
          --wui-color-fg-275: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-fg-275)
          );
          --wui-color-fg-300: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-fg-300)
          );
          --wui-color-fg-325: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-fg-325)
          );
          --wui-color-fg-350: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-fg-350)
          );

          --wui-color-bg-100: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-bg-100)
          );
          --wui-color-bg-125: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-bg-125)
          );
          --wui-color-bg-150: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-bg-150)
          );
          --wui-color-bg-175: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-bg-175)
          );
          --wui-color-bg-200: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-bg-200)
          );
          --wui-color-bg-225: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-bg-225)
          );
          --wui-color-bg-250: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-bg-250)
          );
          --wui-color-bg-275: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-bg-275)
          );
          --wui-color-bg-300: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-bg-300)
          );
          --wui-color-bg-325: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-bg-325)
          );
          --wui-color-bg-350: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-bg-350)
          );

          --wui-color-success-100: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-success-base-100)
          );
          --wui-color-success-125: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-success-base-125)
          );

          --wui-color-warning-100: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-warning-base-100)
          );

          --wui-color-error-100: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-error-base-100)
          );
          --wui-color-blue-100: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-blue-base-100)
          );
          --wui-color-blue-90: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-blue-base-90)
          );
          --wui-color-error-125: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-color-error-base-125)
          );

          --wui-icon-box-bg-error-100: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-icon-box-bg-error-base-100)
          );
          --wui-icon-box-bg-accent-100: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-icon-box-bg-blue-base-100)
          );
          --wui-icon-box-bg-success-100: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-icon-box-bg-success-base-100)
          );
          --wui-icon-box-bg-inverse-100: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-icon-box-bg-inverse-base-100)
          );

          --wui-all-wallets-bg-100: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-all-wallets-bg-100)
          );

          --wui-avatar-border: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-avatar-border-base)
          );

          --wui-thumbnail-border: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-thumbnail-border-base)
          );

          --wui-wallet-button-bg: color-mix(
            in srgb,
            var(--w3m-color-mix) var(--w3m-color-mix-strength),
            var(--wui-wallet-button-bg-base)
          );
        }
      }
    `,light:t.css`
      :root {
        --w3m-color-mix: ${(0,t.unsafeCSS)(r?.["--w3m-color-mix"]||"#fff")};
        --w3m-accent: ${(0,t.unsafeCSS)((0,a.getW3mThemeVariables)(r,"dark")["--w3m-accent"])};
        --w3m-default: #fff;

        --wui-color-modal-bg-base: ${(0,t.unsafeCSS)((0,a.getW3mThemeVariables)(r,"dark")["--w3m-background"])};
        --wui-color-accent-base-100: var(--w3m-accent);

        --wui-color-blueberry-100: hsla(230, 100%, 67%, 1);
        --wui-color-blueberry-090: hsla(231, 76%, 61%, 1);
        --wui-color-blueberry-080: hsla(230, 59%, 55%, 1);
        --wui-color-blueberry-050: hsla(231, 100%, 70%, 0.1);

        --wui-color-fg-100: #e4e7e7;
        --wui-color-fg-125: #d0d5d5;
        --wui-color-fg-150: #a8b1b1;
        --wui-color-fg-175: #a8b0b0;
        --wui-color-fg-200: #949e9e;
        --wui-color-fg-225: #868f8f;
        --wui-color-fg-250: #788080;
        --wui-color-fg-275: #788181;
        --wui-color-fg-300: #6e7777;
        --wui-color-fg-325: #9a9a9a;
        --wui-color-fg-350: #363636;

        --wui-color-bg-100: #141414;
        --wui-color-bg-125: #191a1a;
        --wui-color-bg-150: #1e1f1f;
        --wui-color-bg-175: #222525;
        --wui-color-bg-200: #272a2a;
        --wui-color-bg-225: #2c3030;
        --wui-color-bg-250: #313535;
        --wui-color-bg-275: #363b3b;
        --wui-color-bg-300: #3b4040;
        --wui-color-bg-325: #252525;
        --wui-color-bg-350: #ffffff;

        --wui-color-success-base-100: #26d962;
        --wui-color-success-base-125: #30a46b;

        --wui-color-warning-base-100: #f3a13f;

        --wui-color-error-base-100: #f25a67;
        --wui-color-error-base-125: #df4a34;

        --wui-color-blue-base-100: rgba(102, 125, 255, 1);
        --wui-color-blue-base-90: rgba(102, 125, 255, 0.9);

        --wui-color-success-glass-001: rgba(38, 217, 98, 0.01);
        --wui-color-success-glass-002: rgba(38, 217, 98, 0.02);
        --wui-color-success-glass-005: rgba(38, 217, 98, 0.05);
        --wui-color-success-glass-010: rgba(38, 217, 98, 0.1);
        --wui-color-success-glass-015: rgba(38, 217, 98, 0.15);
        --wui-color-success-glass-020: rgba(38, 217, 98, 0.2);
        --wui-color-success-glass-025: rgba(38, 217, 98, 0.25);
        --wui-color-success-glass-030: rgba(38, 217, 98, 0.3);
        --wui-color-success-glass-060: rgba(38, 217, 98, 0.6);
        --wui-color-success-glass-080: rgba(38, 217, 98, 0.8);

        --wui-color-success-glass-reown-020: rgba(48, 164, 107, 0.2);

        --wui-color-warning-glass-reown-020: rgba(243, 161, 63, 0.2);

        --wui-color-error-glass-001: rgba(242, 90, 103, 0.01);
        --wui-color-error-glass-002: rgba(242, 90, 103, 0.02);
        --wui-color-error-glass-005: rgba(242, 90, 103, 0.05);
        --wui-color-error-glass-010: rgba(242, 90, 103, 0.1);
        --wui-color-error-glass-015: rgba(242, 90, 103, 0.15);
        --wui-color-error-glass-020: rgba(242, 90, 103, 0.2);
        --wui-color-error-glass-025: rgba(242, 90, 103, 0.25);
        --wui-color-error-glass-030: rgba(242, 90, 103, 0.3);
        --wui-color-error-glass-060: rgba(242, 90, 103, 0.6);
        --wui-color-error-glass-080: rgba(242, 90, 103, 0.8);

        --wui-color-error-glass-reown-020: rgba(223, 74, 52, 0.2);

        --wui-color-gray-glass-001: rgba(255, 255, 255, 0.01);
        --wui-color-gray-glass-002: rgba(255, 255, 255, 0.02);
        --wui-color-gray-glass-005: rgba(255, 255, 255, 0.05);
        --wui-color-gray-glass-010: rgba(255, 255, 255, 0.1);
        --wui-color-gray-glass-015: rgba(255, 255, 255, 0.15);
        --wui-color-gray-glass-020: rgba(255, 255, 255, 0.2);
        --wui-color-gray-glass-025: rgba(255, 255, 255, 0.25);
        --wui-color-gray-glass-030: rgba(255, 255, 255, 0.3);
        --wui-color-gray-glass-060: rgba(255, 255, 255, 0.6);
        --wui-color-gray-glass-080: rgba(255, 255, 255, 0.8);
        --wui-color-gray-glass-090: rgba(255, 255, 255, 0.9);

        --wui-color-dark-glass-100: rgba(42, 42, 42, 1);

        --wui-icon-box-bg-error-base-100: #3c2426;
        --wui-icon-box-bg-blue-base-100: #20303f;
        --wui-icon-box-bg-success-base-100: #1f3a28;
        --wui-icon-box-bg-inverse-base-100: #243240;

        --wui-all-wallets-bg-100: #222b35;

        --wui-avatar-border-base: #252525;

        --wui-thumbnail-border-base: #252525;

        --wui-wallet-button-bg-base: var(--wui-color-bg-125);

        --w3m-card-embedded-shadow-color: rgb(17 17 18 / 25%);
      }
    `,dark:t.css`
      :root {
        --w3m-color-mix: ${(0,t.unsafeCSS)(r?.["--w3m-color-mix"]||"#000")};
        --w3m-accent: ${(0,t.unsafeCSS)((0,a.getW3mThemeVariables)(r,"light")["--w3m-accent"])};
        --w3m-default: #000;

        --wui-color-modal-bg-base: ${(0,t.unsafeCSS)((0,a.getW3mThemeVariables)(r,"light")["--w3m-background"])};
        --wui-color-accent-base-100: var(--w3m-accent);

        --wui-color-blueberry-100: hsla(231, 100%, 70%, 1);
        --wui-color-blueberry-090: hsla(231, 97%, 72%, 1);
        --wui-color-blueberry-080: hsla(231, 92%, 74%, 1);

        --wui-color-fg-100: #141414;
        --wui-color-fg-125: #2d3131;
        --wui-color-fg-150: #474d4d;
        --wui-color-fg-175: #636d6d;
        --wui-color-fg-200: #798686;
        --wui-color-fg-225: #828f8f;
        --wui-color-fg-250: #8b9797;
        --wui-color-fg-275: #95a0a0;
        --wui-color-fg-300: #9ea9a9;
        --wui-color-fg-325: #9a9a9a;
        --wui-color-fg-350: #d0d0d0;

        --wui-color-bg-100: #ffffff;
        --wui-color-bg-125: #f5fafa;
        --wui-color-bg-150: #f3f8f8;
        --wui-color-bg-175: #eef4f4;
        --wui-color-bg-200: #eaf1f1;
        --wui-color-bg-225: #e5eded;
        --wui-color-bg-250: #e1e9e9;
        --wui-color-bg-275: #dce7e7;
        --wui-color-bg-300: #d8e3e3;
        --wui-color-bg-325: #f3f3f3;
        --wui-color-bg-350: #202020;

        --wui-color-success-base-100: #26b562;
        --wui-color-success-base-125: #30a46b;

        --wui-color-warning-base-100: #f3a13f;

        --wui-color-error-base-100: #f05142;
        --wui-color-error-base-125: #df4a34;

        --wui-color-blue-base-100: rgba(102, 125, 255, 1);
        --wui-color-blue-base-90: rgba(102, 125, 255, 0.9);

        --wui-color-success-glass-001: rgba(38, 181, 98, 0.01);
        --wui-color-success-glass-002: rgba(38, 181, 98, 0.02);
        --wui-color-success-glass-005: rgba(38, 181, 98, 0.05);
        --wui-color-success-glass-010: rgba(38, 181, 98, 0.1);
        --wui-color-success-glass-015: rgba(38, 181, 98, 0.15);
        --wui-color-success-glass-020: rgba(38, 181, 98, 0.2);
        --wui-color-success-glass-025: rgba(38, 181, 98, 0.25);
        --wui-color-success-glass-030: rgba(38, 181, 98, 0.3);
        --wui-color-success-glass-060: rgba(38, 181, 98, 0.6);
        --wui-color-success-glass-080: rgba(38, 181, 98, 0.8);

        --wui-color-success-glass-reown-020: rgba(48, 164, 107, 0.2);

        --wui-color-warning-glass-reown-020: rgba(243, 161, 63, 0.2);

        --wui-color-error-glass-001: rgba(240, 81, 66, 0.01);
        --wui-color-error-glass-002: rgba(240, 81, 66, 0.02);
        --wui-color-error-glass-005: rgba(240, 81, 66, 0.05);
        --wui-color-error-glass-010: rgba(240, 81, 66, 0.1);
        --wui-color-error-glass-015: rgba(240, 81, 66, 0.15);
        --wui-color-error-glass-020: rgba(240, 81, 66, 0.2);
        --wui-color-error-glass-025: rgba(240, 81, 66, 0.25);
        --wui-color-error-glass-030: rgba(240, 81, 66, 0.3);
        --wui-color-error-glass-060: rgba(240, 81, 66, 0.6);
        --wui-color-error-glass-080: rgba(240, 81, 66, 0.8);

        --wui-color-error-glass-reown-020: rgba(223, 74, 52, 0.2);

        --wui-icon-box-bg-error-base-100: #f4dfdd;
        --wui-icon-box-bg-blue-base-100: #d9ecfb;
        --wui-icon-box-bg-success-base-100: #daf0e4;
        --wui-icon-box-bg-inverse-base-100: #dcecfc;

        --wui-all-wallets-bg-100: #e8f1fa;

        --wui-avatar-border-base: #f3f4f4;

        --wui-thumbnail-border-base: #eaefef;

        --wui-wallet-button-bg-base: var(--wui-color-bg-125);

        --wui-color-gray-glass-001: rgba(0, 0, 0, 0.01);
        --wui-color-gray-glass-002: rgba(0, 0, 0, 0.02);
        --wui-color-gray-glass-005: rgba(0, 0, 0, 0.05);
        --wui-color-gray-glass-010: rgba(0, 0, 0, 0.1);
        --wui-color-gray-glass-015: rgba(0, 0, 0, 0.15);
        --wui-color-gray-glass-020: rgba(0, 0, 0, 0.2);
        --wui-color-gray-glass-025: rgba(0, 0, 0, 0.25);
        --wui-color-gray-glass-030: rgba(0, 0, 0, 0.3);
        --wui-color-gray-glass-060: rgba(0, 0, 0, 0.6);
        --wui-color-gray-glass-080: rgba(0, 0, 0, 0.8);
        --wui-color-gray-glass-090: rgba(0, 0, 0, 0.9);

        --wui-color-dark-glass-100: rgba(233, 233, 233, 1);

        --w3m-card-embedded-shadow-color: rgb(224 225 233 / 25%);
      }
    `}}let l=t.css`
  *,
  *::after,
  *::before,
  :host {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-style: normal;
    text-rendering: optimizeSpeed;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    -webkit-tap-highlight-color: transparent;
    font-family: var(--wui-font-family);
    backface-visibility: hidden;
  }
`,w=t.css`
  button,
  a {
    cursor: pointer;
    display: flex;
    justify-content: center;
    align-items: center;
    position: relative;
    transition:
      color var(--wui-duration-lg) var(--wui-ease-out-power-1),
      background-color var(--wui-duration-lg) var(--wui-ease-out-power-1),
      border var(--wui-duration-lg) var(--wui-ease-out-power-1),
      border-radius var(--wui-duration-lg) var(--wui-ease-out-power-1),
      box-shadow var(--wui-duration-lg) var(--wui-ease-out-power-1);
    will-change: background-color, color, border, box-shadow, border-radius;
    outline: none;
    border: none;
    column-gap: var(--wui-spacing-3xs);
    background-color: transparent;
    text-decoration: none;
  }

  wui-flex {
    transition: border-radius var(--wui-duration-lg) var(--wui-ease-out-power-1);
    will-change: border-radius;
  }

  button:disabled > wui-wallet-image,
  button:disabled > wui-all-wallets-image,
  button:disabled > wui-network-image,
  button:disabled > wui-image,
  button:disabled > wui-transaction-visual,
  button:disabled > wui-logo {
    filter: grayscale(1);
  }

  @media (hover: hover) and (pointer: fine) {
    button:hover:enabled {
      background-color: var(--wui-color-gray-glass-005);
    }

    button:active:enabled {
      background-color: var(--wui-color-gray-glass-010);
    }
  }

  button:disabled > wui-icon-box {
    opacity: 0.5;
  }

  input {
    border: none;
    outline: none;
    appearance: none;
  }
`,g=t.css`
  .wui-color-inherit {
    color: var(--wui-color-inherit);
  }

  .wui-color-accent-100 {
    color: var(--wui-color-accent-100);
  }

  .wui-color-error-100 {
    color: var(--wui-color-error-100);
  }

  .wui-color-blue-100 {
    color: var(--wui-color-blue-100);
  }

  .wui-color-blue-90 {
    color: var(--wui-color-blue-90);
  }

  .wui-color-error-125 {
    color: var(--wui-color-error-125);
  }

  .wui-color-success-100 {
    color: var(--wui-color-success-100);
  }

  .wui-color-success-125 {
    color: var(--wui-color-success-125);
  }

  .wui-color-inverse-100 {
    color: var(--wui-color-inverse-100);
  }

  .wui-color-inverse-000 {
    color: var(--wui-color-inverse-000);
  }

  .wui-color-fg-100 {
    color: var(--wui-color-fg-100);
  }

  .wui-color-fg-200 {
    color: var(--wui-color-fg-200);
  }

  .wui-color-fg-300 {
    color: var(--wui-color-fg-300);
  }

  .wui-color-fg-325 {
    color: var(--wui-color-fg-325);
  }

  .wui-color-fg-350 {
    color: var(--wui-color-fg-350);
  }

  .wui-bg-color-inherit {
    background-color: var(--wui-color-inherit);
  }

  .wui-bg-color-blue-100 {
    background-color: var(--wui-color-accent-100);
  }

  .wui-bg-color-error-100 {
    background-color: var(--wui-color-error-100);
  }

  .wui-bg-color-error-125 {
    background-color: var(--wui-color-error-125);
  }

  .wui-bg-color-success-100 {
    background-color: var(--wui-color-success-100);
  }

  .wui-bg-color-success-125 {
    background-color: var(--wui-color-success-100);
  }

  .wui-bg-color-inverse-100 {
    background-color: var(--wui-color-inverse-100);
  }

  .wui-bg-color-inverse-000 {
    background-color: var(--wui-color-inverse-000);
  }

  .wui-bg-color-fg-100 {
    background-color: var(--wui-color-fg-100);
  }

  .wui-bg-color-fg-200 {
    background-color: var(--wui-color-fg-200);
  }

  .wui-bg-color-fg-300 {
    background-color: var(--wui-color-fg-300);
  }

  .wui-color-fg-325 {
    background-color: var(--wui-color-fg-325);
  }

  .wui-color-fg-350 {
    background-color: var(--wui-color-fg-350);
  }
`;r.s(["colorStyles",0,g,"elementStyles",0,w,"initializeTheming",()=>s,"resetStyles",0,l,"setColorTheme",()=>n,"setThemeVariables",()=>c],864429);let b={getSpacingStyles:(r,o)=>Array.isArray(r)?r[o]?`var(--wui-spacing-${r[o]})`:void 0:"string"==typeof r?`var(--wui-spacing-${r})`:void 0,getFormattedDate:r=>new Intl.DateTimeFormat("en-US",{month:"short",day:"numeric"}).format(r),getHostName(r){try{return new URL(r).hostname}catch(r){return""}},getTruncateString:({string:r,charsStart:o,charsEnd:e,truncate:i})=>r.length<=o+e?r:"end"===i?`${r.substring(0,o)}...`:"start"===i?`...${r.substring(r.length-e)}`:`${r.substring(0,Math.floor(o))}...${r.substring(r.length-Math.floor(e))}`,generateAvatarColors(r){let o=r.toLowerCase().replace(/^0x/iu,"").replace(/[^a-f0-9]/gu,"").substring(0,6).padEnd(6,"0"),e=this.hexToRgb(o),i=getComputedStyle(document.documentElement).getPropertyValue("--w3m-border-radius-master"),t=100-3*Number(i?.replace("px","")),a=`${t}% ${t}% at 65% 40%`,s=[];for(let r=0;r<5;r+=1){let o=this.tintColor(e,.15*r);s.push(`rgb(${o[0]}, ${o[1]}, ${o[2]})`)}return`
    --local-color-1: ${s[0]};
    --local-color-2: ${s[1]};
    --local-color-3: ${s[2]};
    --local-color-4: ${s[3]};
    --local-color-5: ${s[4]};
    --local-radial-circle: ${a}
   `},hexToRgb(r){let o=parseInt(r,16);return[o>>16&255,o>>8&255,255&o]},tintColor(r,o){let[e,i,t]=r;return[Math.round(e+(255-e)*o),Math.round(i+(255-i)*o),Math.round(t+(255-t)*o)]},isNumber:r=>/^[0-9]+$/u.test(r),getColorTheme:r=>r?r:"u">typeof window&&window.matchMedia&&"function"==typeof window.matchMedia?window.matchMedia("(prefers-color-scheme: dark)")?.matches?"dark":"light":"dark",splitBalance(r){let o=r.split(".");return 2===o.length?[o[0],o[1]]:["0","00"]},roundNumber:(r,o,e)=>r.toString().length>=o?Number(r).toFixed(e):r};r.s(["UiHelperUtil",0,b],34691);var m=r.i(55956),f=r.i(549984),d=r.i(488194),h=r.i(555634);m.default.extend(d.default),m.default.extend(h.default);let v={...f.default,name:"en-web3-modal",relativeTime:{future:"in %s",past:"%s ago",s:"%d sec",m:"1 min",mm:"%d min",h:"1 hr",hh:"%d hrs",d:"1 d",dd:"%d d",M:"1 mo",MM:"%d mo",y:"1 yr",yy:"%d yr"}},x=["January","February","March","April","May","June","July","August","September","October","November","December"];m.default.locale("en-web3-modal",v);let p={getMonthNameByIndex:r=>x[r],getYear:(r=new Date().toISOString())=>(0,m.default)(r).year(),getRelativeDateFromNow:r=>(0,m.default)(r).locale("en-web3-modal").fromNow(!0),formatDate:(r,o="DD MMM")=>(0,m.default)(r).format(o)};r.s(["DateUtil",0,p],660506);let y=["receive","deposit","borrow","claim"],$=["withdraw","repay","burn"],S={getTransactionGroupTitle(r,o){let e=p.getYear(),i=p.getMonthNameByIndex(o);return r===e?i:`${i} ${r}`},getTransactionImages(r){let[o,e]=r,i=!!o&&r?.every(r=>!!r.nft_info),t=r?.length>1;return r?.length!==2||i?t?r.map(r=>this.getTransactionImage(r)):[this.getTransactionImage(o)]:[this.getTransactionImage(e),this.getTransactionImage(o)]},getTransactionImage:r=>({type:S.getTransactionTransferTokenType(r),url:S.getTransactionImageURL(r)}),getTransactionImageURL(r){let o,e=!!r?.nft_info,i=!!r?.fungible_info;return r&&e?o=r?.nft_info?.content?.preview?.url:r&&i&&(o=r?.fungible_info?.icon?.url),o},getTransactionTransferTokenType:r=>r?.fungible_info?"FUNGIBLE":r?.nft_info?"NFT":void 0,getTransactionDescriptions(r){let o=r?.metadata?.operationType,e=r?.transfers,i=r?.transfers?.length>0,t=r?.transfers?.length>1,a=i&&e?.every(r=>!!r?.fungible_info),[s,n]=e,c=this.getTransferDescription(s),u=this.getTransferDescription(n);if(!i)return("send"===o||"receive"===o)&&a?[c=b.getTruncateString({string:r?.metadata.sentFrom,charsStart:4,charsEnd:6,truncate:"middle"}),b.getTruncateString({string:r?.metadata.sentTo,charsStart:4,charsEnd:6,truncate:"middle"})]:[r.metadata.status];if(t)return e.map(r=>this.getTransferDescription(r)).reverse();let l="";return y.includes(o)?l="+":$.includes(o)&&(l="-"),[c=l.concat(c)]},getTransferDescription(r){let o="";return r&&(r?.nft_info?o=r?.nft_info?.name||"-":r?.fungible_info&&(o=this.getFungibleTransferDescription(r)||"-")),o},getFungibleTransferDescription(r){return r?[this.getQuantityFixedValue(r?.quantity.numeric),r?.fungible_info?.symbol].join(" ").trim():null},getQuantityFixedValue:r=>r?parseFloat(r).toFixed(3):null};function M(r){return function(o){return"function"==typeof o?(customElements.get(r)||customElements.define(r,o),o):function(r,o){let{kind:e,elements:i}=o;return{kind:e,elements:i,finisher(o){customElements.get(r)||customElements.define(r,o)}}}(r,o)}}r.s(["TransactionUtil",0,S],414737),r.s(["customElement",()=>M],938559),r.s([],302184)}]);