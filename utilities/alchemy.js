/*! Mini-utils 2013-07-18 */
var __slice=[].slice;define(function(){var a,b;return b=function(){var a,b,c,d,e,f,g,h,i;for(c=1<=arguments.length?__slice.call(arguments,0):[],e=Math.max.apply(null,function(){var a,d,e;for(e=[],a=0,d=c.length;d>a;a++)b=c[a],e.push(b.length);return e}()),f=new Array(e),i=[],a=g=0,h=f.length;h>g;a=++g)d=f[a],i.push(f[a]=function(){var d,e,f;for(f=[],d=0,e=c.length;e>d;d++)b=c[d],f.push(b[a]);return f}());return i},a=function(){return"xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g,function(a){var b,c;return b=0|16*Math.random(),c="x"===a?b:8|3&b,c.toString(16)})},{zip:b,generate_guid:a}});