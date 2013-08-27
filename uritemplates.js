/*! Mini-utils 2013-08-27 */
define(function(){var a;return a=function(a,b){return a.replace(/\{(\w+)\}/g,function(a,c){return escape(b[c])})},{expand:a}});