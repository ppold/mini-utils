/*! Mini-utils 2013-09-03 */
var __bind=function(a,b){return function(){return a.apply(b,arguments)}};define(function(){var a,b;return b=function(){var a,b,c,d,e,f;for(c=window,f=["ms","moz","webkit","o"],d=0,e=f.length;e>d&&(b=f[d],!c.requestAnimationFrame);d++)c.requestAnimationFrame=c[b+"RequestAnimationFrame"],c.cancelAnimationFrame=c[b+"CancelAnimationFrame"]||c[b+"CancelRequestAnimationFrame"];return a=0,c.requestAnimationFrame||(c.requestAnimationFrame=function(b){var d;return a=Math.max(a+16,d=+new Date),c.setTimeout(function(){return b(+new Date)},a-d)}),c.cancelAnimationFrame||(c.cancelAnimationFrame=function(a){return clearTimeout(a)})},b(),a=function(){function a(a){this.deltaCallback=a,this.timestampCallback=__bind(this.timestampCallback,this),this.firstTimestampCallback=__bind(this.firstTimestampCallback,this)}return a.prototype.previousTimestamp=null,a.prototype.requestID=null,a.prototype.start=function(){return this.requestID=requestAnimationFrame(this.firstTimestampCallback)},a.prototype.stop=function(){return cancelAnimationFrame(this.requestID)},a.prototype.firstTimestampCallback=function(a){return this.previousTimestamp=a,this.requestID=requestAnimationFrame(this.timestampCallback)},a.prototype.timestampCallback=function(a){return this.deltaCallback(a-this.previousTimestamp),this.firstTimestampCallback(a)},a}(),{Animation:a}});