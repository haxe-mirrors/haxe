package haxe;

import flash.errors.Error;

@:coreApi
class Exception extends NativeException {
	public var message(get,never):String;
	public var stack(get,never):CallStack;
	public var previous(get,never):Null<Exception>;
	public var native(get,never):Any;

	@:noCompletion var __exceptionStack:Null<CallStack>;
	@:noCompletion var __nativeStack:String;
	@:noCompletion var __nativeException:Error;
	@:noCompletion var __previousException:Null<Exception>;

	static public function caught(value:Any):Exception {
		if(Std.is(value, Exception)) {
			return value;
		} else if(Std.isOfType(value, Error)) {
			return new Exception((value:Error).message, null, value);
		} else {
			return new ValueException(value, null, value);
		}
	}

	static public function thrown(value:Any):Any {
		if(Std.isOfType(value, Exception)) {
			return (value:Exception).native;
		} else if(Std.isOfType(value, Error)) {
			return value;
		} else {
			return new ValueException(value);
		}
	}

	public function new(message:String, ?previous:Exception, ?native:Any) {
		super(message);
		__previousException = previous;
		if(native != null && Std.isOfType(native, Error)) {
			__nativeException = native;
			__nativeStack = Std.isOfType(native, Exception) ? (native:Exception).__nativeStack : (native:Error).getStackTrace();
		} else {
			__nativeException = cast this;
			__nativeStack = new Error().getStackTrace();
		}
	}

	public function unwrap():Any {
		return __nativeException;
	}

	public function toString():String {
		return inline CallStack.exceptionToString(this);
	}

	function get_message():String {
		return (cast this:Error).message;
	}

	function get_previous():Null<Exception> {
		return __previousException;
	}

	final function get_native():Any {
		return __nativeException;
	}

	function get_stack():CallStack {
		return switch __exceptionStack {
			case null:
				__exceptionStack = CallStack.makeStack(__nativeStack);
			case s: s;
		}
	}
}

@:dox(hide)
@:native('flash.errors.Error')
extern class NativeException {
	@:noCompletion @:flash.property private var errorID(get,never):Int;
	// @:noCompletion private var message:Dynamic;
	@:noCompletion private var name:Dynamic;
	@:noCompletion private function new(?message:Dynamic, id:Dynamic = 0):Void;
	@:noCompletion private function getStackTrace():String;
	@:noCompletion private function get_errorID():Int;
}