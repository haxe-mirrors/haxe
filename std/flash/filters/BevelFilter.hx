package flash.filters;

extern final class BevelFilter extends BitmapFilter {
	@:flash.property var angle(get,set) : Float;
	@:flash.property var blurX(get,set) : Float;
	@:flash.property var blurY(get,set) : Float;
	@:flash.property var distance(get,set) : Float;
	@:flash.property var highlightAlpha(get,set) : Float;
	@:flash.property var highlightColor(get,set) : UInt;
	@:flash.property var knockout(get,set) : Bool;
	@:flash.property var quality(get,set) : Int;
	@:flash.property var shadowAlpha(get,set) : Float;
	@:flash.property var shadowColor(get,set) : UInt;
	@:flash.property var strength(get,set) : Float;
	@:flash.property var type(get,set) : BitmapFilterType;
	function new(distance : Float = 4, angle : Float = 45, highlightColor : UInt = 0xFFFFFF, highlightAlpha : Float = 1, shadowColor : UInt = 0, shadowAlpha : Float = 1, blurX : Float = 4, blurY : Float = 4, strength : Float = 1, quality : Int = 1, ?type : BitmapFilterType, knockout : Bool = false) : Void;
	private function get_angle() : Float;
	private function get_blurX() : Float;
	private function get_blurY() : Float;
	private function get_distance() : Float;
	private function get_highlightAlpha() : Float;
	private function get_highlightColor() : UInt;
	private function get_knockout() : Bool;
	private function get_quality() : Int;
	private function get_shadowAlpha() : Float;
	private function get_shadowColor() : UInt;
	private function get_strength() : Float;
	private function get_type() : BitmapFilterType;
	private function set_angle(value : Float) : Float;
	private function set_blurX(value : Float) : Float;
	private function set_blurY(value : Float) : Float;
	private function set_distance(value : Float) : Float;
	private function set_highlightAlpha(value : Float) : Float;
	private function set_highlightColor(value : UInt) : UInt;
	private function set_knockout(value : Bool) : Bool;
	private function set_quality(value : Int) : Int;
	private function set_shadowAlpha(value : Float) : Float;
	private function set_shadowColor(value : UInt) : UInt;
	private function set_strength(value : Float) : Float;
	private function set_type(value : BitmapFilterType) : BitmapFilterType;
}
