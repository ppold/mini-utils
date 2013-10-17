/*! Mini-utils 2013-10-17 */
define(function(){var a;return a=function(a,b){return a.replace(/\{(\w+)\}/g,function(a,c){return escape(b[c])})},{expand:a}});