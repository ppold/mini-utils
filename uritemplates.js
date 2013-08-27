/*! Mini-utils 2013-09-03 */
define(function(){var a;return a=function(a,b){return a.replace(/\{(\w+)\}/g,function(a,c){return escape(b[c])})},{expand:a}});