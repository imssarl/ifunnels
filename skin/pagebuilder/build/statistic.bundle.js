!function(e){var n={};function t(o){if(n[o])return n[o].exports;var r=n[o]={i:o,l:!1,exports:{}};return e[o].call(r.exports,r,r.exports,t),r.l=!0,r.exports}t.m=e,t.c=n,t.d=function(e,n,o){t.o(e,n)||Object.defineProperty(e,n,{enumerable:!0,get:o})},t.r=function(e){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},t.t=function(e,n){if(1&n&&(e=t(e)),8&n)return e;if(4&n&&"object"==typeof e&&e&&e.__esModule)return e;var o=Object.create(null);if(t.r(o),Object.defineProperty(o,"default",{enumerable:!0,value:e}),2&n&&"string"!=typeof e)for(var r in e)t.d(o,r,function(n){return e[n]}.bind(null,r));return o},t.n=function(e){var n=e&&e.__esModule?function(){return e.default}:function(){return e};return t.d(n,"a",n),n},t.o=function(e,n){return Object.prototype.hasOwnProperty.call(e,n)},t.p="/skin/pagebuilder/build/",t(t.s=443)}({443:function(e,n){!function(){"use strict";var e={init:function(){let e={url:window.location.href,uid:uid,pbid:pbid,pagename:pagename};$.getJSON("https://api.ipify.org?format=jsonp&callback=?",(function(n){e.ip=n.ip,$.post("//fasttrk.net/services/pb_subscribers.php",e).done((function(e){console.log(e)}))})),$('a:not([href="#"])').on("click",(function(n){$.post("//fasttrk.net/services/pb_conversion.php",e).done((function(e){console.log(e)}))})),$("form").on("submit",(function(){$.post("//fasttrk.net/services/pb_conversion.php",e).done((function(e){console.log(e)}))}))}};e.init(),n.statistic=e}()}});