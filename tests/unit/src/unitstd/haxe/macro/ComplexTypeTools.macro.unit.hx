#if macro
var tt = function(c) return Std.string(haxe.macro.ComplexTypeTools.toType(c));
tt(macro : String) == "String";
tt(macro : Int) == "String";
#else
1 == 1;
#end