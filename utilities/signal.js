/*! Mini-utils 2013-07-26 */
var __slice=[].slice;define(function(){var a;return a=function(){function a(){this.slots=[]}return a.prototype.add=function(a){return this.slots.push(a)},a.prototype.dispatch=function(){var a,b,c,d,e,f;for(b=1<=arguments.length?__slice.call(arguments,0):[],this.values=b,e=this.slots,f=[],c=0,d=e.length;d>c;c++)a=e[c],f.push(a.apply(null,this.values));return f},a}()});