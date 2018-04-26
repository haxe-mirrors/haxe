/*
 * Copyright (C)2005-2018 Haxe Foundation
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
package haxe.http;

#if nodejs

class HttpNodeJs extends haxe.http.HttpBase<HttpNodeJs> {
	var req:js.node.http.ClientRequest;

	public function new(url:String) {
		super(url);
	}

	/**
		Cancels `this` Http request if `request` has been called and a response
		has not yet been received.
	**/
	public function cancel()
	{
		if (req == null) return;
		req.abort();
		req = null;
	}

	public override function request(?post:Bool) {
		responseData = null;
		var parsedUrl = js.node.Url.parse(url);
		var secure = (parsedUrl.protocol == "https:");
		var host = parsedUrl.hostname;
		var path = parsedUrl.path;
		var port = if (parsedUrl.port != null) Std.parseInt(parsedUrl.port) else (secure ? 443 : 80);
		var h:Dynamic = {};
		for (i in headers) {
			var arr = Reflect.field(h, i.name);
			if (arr == null) {
				arr = new Array<String>();
				Reflect.setField(h, i.name, arr);
			}

			arr.push(i.value);
		}
		if( postData != null )
			post = true;
		var uri = null;
		for( p in params ) {
			if( uri == null )
				uri = "";
			else
				uri += "&";
			uri += StringTools.urlEncode(p.name)+"="+StringTools.urlEncode(p.value);
		}
		var question = path.split("?").length <= 1;
		if (uri != null) path += (if( question ) "?" else "&") + uri;

		var opts = {
			protocol: parsedUrl.protocol,
			hostname: host,
			port: port,
			method: post ? 'POST' : 'GET',
			path: path,
			headers: h
		};
		function httpResponse (res) {
			var s = res.statusCode;
			if (s != null)
				onStatus(s);
			var body = '';
			res.on('data', function (d) {
				body += d;
			});
			res.on('end', function (_) {
				responseData = body;
				req = null;
				if (s != null && s >= 200 && s < 400) {
					onData(body);
				} else {
					onError("Http Error #"+s);
				}
			});
		}
		req = secure ? js.node.Https.request(untyped opts, httpResponse) : js.node.Http.request(untyped opts, httpResponse);
		if (post) req.write(postData);
		req.end();
	}
}

#end
