/*
 * Copyright (C)2005-2019 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

package cpp;

@:buildXml('<include name="${HXCPP}/src/hx/libs/ssl/Build.xml"/>')
extern class NativeSsl {
	@:native("_hx_ssl_new")
	public static function ssl_new(conf:Dynamic):Dynamic;

	@:native("_hx_ssl_close")
	public static function ssl_close(ctx:Dynamic):Void;

	@:native("_hx_ssl_handshake")
	public static function ssl_handshake(ctx:Dynamic):Void;

	@:native("_hx_ssl_set_socket")
	public static function ssl_set_socket(ctx:Dynamic, socket:Dynamic):Void;

	@:native("_hx_ssl_set_hostname")
	public static function ssl_set_hostname(ctx:Dynamic, hostname:String):Void;

	@:native("_hx_ssl_get_peer_certificate")
	public static function ssl_get_peer_certificate(ctx:Dynamic):Dynamic;

	@:native("_hx_ssl_get_verify_result")
	public static function ssl_get_verify_result(ctx:Dynamic):Bool;

	@:native("_hx_ssl_send_char")
	public static function ssl_send_char(ctx:Dynamic, char:Int):Void;

	@:native("_hx_ssl_send")
	public static function ssl_send(ctx:Dynamic, buf:haxe.io.BytesData, p:Int, l:Int):Int;

	@:native("_hx_ssl_write")
	public static function ssl_write(ctx:Dynamic, data:haxe.io.BytesData):Void;

	@:native("_hx_ssl_recv_char")
	public static function ssl_recv_char(ctx:Dynamic):Int;

	@:native("_hx_ssl_recv")
	public static function ssl_recv(ctx:Dynamic, buf:haxe.io.BytesData, p:Int, l:Int):Int;

	@:native("_hx_ssl_read")
	public static function ssl_read(ctx:Dynamic):haxe.io.BytesData;

	@:native("_hx_ssl_conf_new")
	public static function conf_new(server:Bool):Dynamic;

	@:native("_hx_ssl_conf_close")
	public static function conf_close(conf:Dynamic):Void;

	@:native("_hx_ssl_conf_set_ca")
	public static function conf_set_ca(conf:Dynamic, cert:Dynamic):Void;

	@:native("_hx_ssl_conf_set_verify")
	public static function conf_set_verify(conf:Dynamic, mode:Int):Void;

	@:native("_hx_ssl_conf_set_cert")
	public static function conf_set_cert(conf:Dynamic, cert:Dynamic, pkey:Dynamic):Void;

	@:native("_hx_ssl_conf_set_servername_callback")
	public static function conf_set_servername_callback(conf:Dynamic, cb:Dynamic):Void;

	@:native("_hx_ssl_cert_load_defaults")
	public static function cert_load_defaults():Dynamic;

	@:native("_hx_ssl_cert_load_file")
	public static function cert_load_file(file:String):Dynamic;

	@:native("_hx_ssl_cert_load_path")
	public static function cert_load_path(path:String):Dynamic;

	@:native("_hx_ssl_cert_get_subject")
	public static function cert_get_subject(cert:Dynamic, field:String):String;

	@:native("_hx_ssl_cert_get_issuer")
	public static function cert_get_issuer(cert:Dynamic, field:String):String;

	@:native("_hx_ssl_cert_get_altnames")
	public static function cert_get_altnames(cert:Dynamic):Array<String>;

	@:native("_hx_ssl_cert_get_notbefore")
	public static function cert_get_notbefore(cert:Dynamic):Array<Int>;

	@:native("_hx_ssl_cert_get_notafter")
	public static function cert_get_notafter(cert:Dynamic):Array<Int>;

	@:native("_hx_ssl_cert_get_next")
	public static function cert_get_next(cert:Dynamic):Dynamic;

	@:native("_hx_ssl_cert_add_pem")
	public static function cert_add_pem(cert:Dynamic, data:String):Dynamic;

	@:native("_hx_ssl_cert_add_der")
	public static function cert_add_der(cert:Dynamic, data:haxe.io.BytesData):Dynamic;

	@:native("_hx_ssl_key_from_der")
	public static function key_from_der(data:haxe.io.BytesData, pub:Bool):Dynamic;

	@:native("_hx_ssl_key_from_pem")
	public static function key_from_pem(data:String, pub:Bool, pass:String):Dynamic;

	@:native("_hx_ssl_dgst_make")
	public static function dgst_make(data:haxe.io.BytesData, alg:String):haxe.io.BytesData;

	@:native("_hx_ssl_dgst_sign")
	public static function dgst_sign(data:haxe.io.BytesData, key:Dynamic, alg:String):haxe.io.BytesData;

	@:native("_hx_ssl_dgst_verify")
	public static function dgst_verify(data:haxe.io.BytesData, sign:haxe.io.BytesData, key:Dynamic, alg:String):Bool;

	@:native("_hx_ssl_init")
	public static function init():Void;
}
