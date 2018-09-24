(*
	The Haxe Compiler
	Copyright (C) 2005-2018  Haxe Foundation

	This program is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License
	as published by the Free Software Foundation; either version 2
	of the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 *)

open EvalValue

let vstring s = VString s

let create_ascii s =
	{
		sstring = s;
		slength = String.length s;
	}


let create_ucs2 s length = {
	sstring = s;
	slength = length;
}

let concat s1 s2 =
	create_ucs2 (s1.sstring ^ s2.sstring) (s1.slength + s2.slength)

let join sep sl =
	let l_sep = sep.slength in
	let buf = Buffer.create 0 in
	let _,length = List.fold_left (fun (first,length) s ->
		let length = if first then 0 else length + l_sep in
		let length = length + s.slength in
		if not first then Buffer.add_string buf sep.sstring;
		Buffer.add_string buf s.sstring;
		(false,length)
	) (true,0) sl in
	create_ucs2 (Buffer.contents buf) length

let get s =
	s.sstring

let create_unknown s =
	vstring (create_ucs2 s (UTF8.length s))

let read_char s index =
	UChar.int_of_uchar (UTF8.get s.sstring index)

let from_char_code i =
	create_ucs2 (UTF8.init 1 (fun _ ->  UChar.uchar_of_int i)) 1


let find_substring this sub reverse =
	let s_this = this.sstring in
	let l_this = String.length s_this in
	let s_sub = sub.sstring in
	let l_sub = String.length s_sub in
	let rec scan i k =
		if k = l_sub then true
		else if String.unsafe_get s_this (i + k) = String.unsafe_get s_sub k then scan i (k + 1)
		else false
	in
	let inc = 1 in
	if reverse then begin
		let rec loop i =
			if i < 0 then raise Not_found;
			if scan i 0 then
				i,i + l_sub
			else
				loop (i - inc)
		in
		loop
	end else begin
		let rec loop i =
			if i > l_this - l_sub then raise Not_found;
			if scan i 0 then
				i,i + l_sub
			else
				loop (i + inc)
		in
		loop
	end

let case_map this upper =
	let dest = Bytes.of_string this.sstring in
	let a,m = if upper then EvalBytes.Unicase._UPPER,1022 else EvalBytes.Unicase._LOWER,1021 in
	let f i c =
		let up = c lsr 6 in
		if up < m then begin
			let c' = a.(up).(c land ((1 lsl 6) - 1)) in
			if c' <> 0 then EvalBytes.write_ui16 dest i c'
		end
	in
	let l = Bytes.length dest in
	let rec loop i =
		if i = l then
			()
		else begin
			let c = EvalBytes.read_ui16 dest i in
			f i c;
			loop (i + 2)
		end
	in
	loop 0;
	(create_ucs2 (Bytes.unsafe_to_string dest) this.slength)

module AwareBuffer = struct
	type t = vstring_buffer

	let create () = {
		bbuffer = Buffer.create 0;
		blength = 0;
	}

	let add_string this s =
		Buffer.add_string this.bbuffer s.sstring;
		this.blength <- this.blength + s.slength

	let contents this =
		create_ucs2 (Buffer.contents this.bbuffer) this.blength
end

(* open Globals
open EvalValue
open EvalBytes


let vstring s = VString s

module AwareBuffer = struct
	type t = vstring_buffer

	let create () = {
		bbuffer = Buffer.create 0;
		blength = 0;
	}

	let add_string this s =
		Buffer.add_string this.bbuffer s.sstring;
		this.blength <- this.blength + s.slength

	let contents this =
		create_ucs2 (Buffer.contents this.bbuffer) this.blength
end

let read_char s =
	read_ui16 (Bytes.unsafe_of_string s.sstring)

let utf8_to_utf16 s =
	let only_ascii = ref true in
	let buf = Buffer.create 0 in
	let l = ref 0 in
	let add i =
		incr l;
		Buffer.add_char buf (Char.unsafe_chr i);
		Buffer.add_char buf (Char.unsafe_chr (i lsr 8));
	in
	let length = String.length s in
	let i = ref 0 in
	let get () =
		let i' = int_of_char (String.unsafe_get s !i) in
		incr i;
		i'
	in
	while !i < length do
		let c = get() in
		if c < 0x80 then
			add c
		else if c < 0xE0 then begin
			only_ascii := false;
			add (((c land 0x3F) lsl 6) lor ((get ()) land 0x7F))
		end else if c < 0xF0 then begin
			only_ascii := false;
			let c2 = get () in
			add (((c land 0x1F) lsl 12) lor ((c2 land 0x7F) lsl 6) lor ((get ()) land 0x7F));
		end else begin
			only_ascii := false;
			let c2 = get () in
			let c3 = get () in
			let c = (((c land 0x0F) lsl 18) lor ((c2 land 0x7F) lsl 12) lor ((c3 land 0x7F) lsl 6) lor ((get ()) land 0x7F)) in
			add ((c lsr 10) + 0xD7C0);
			add ((c land 0x3FF) lor 0xDC00);
		end
	done;
	Buffer.contents buf,!only_ascii,!l

let create_ascii s =
	let s,_,l = utf8_to_utf16 s in
	{
		sstring = s;
		slength = l;
	}

let utf16_to_utf8 s =
	let buf = Buffer.create 0 in
	let i = ref 0 in
	let add i =
		Buffer.add_char buf (Char.unsafe_chr i)
	in
	let b = Bytes.unsafe_of_string s in
	let read_byte b i = try read_byte b i with _ -> 0 in
	let get () =
		let ch1 = read_byte b !i in
		let ch2 = read_byte b (!i + 1) in
		let c = ch1 lor (ch2 lsl 8) in
		i := !i + 2;
		c
	in
	let length = String.length s in
	while !i < length do
		let c = get() in
		let c = if 0xD800 <= c && c <= 0xDBFF then
			(((c - 0xD7C0) lsl 10) lor ((get()) land 0X3FF))
		else
			c
		in
		if c <= 0x7F then
			add c
		else if c <= 0x7FF then begin
			add (0xC0 lor (c lsr 6));
			add (0x80 lor (c land 63));
		end else if c <= 0xFFFF then begin
			add (0xE0 lor (c lsr 12));
			add (0x80 lor ((c lsr 6) land 63));
			add (0x80 lor (c land 63));
		end else begin
			add (0xF0 lor (c lsr 18));
			add (0x80 lor ((c lsr 12) land 63));
			add (0x80 lor ((c lsr 6) land 63));
			add (0x80 lor (c land 63));
		end
	done;
	Buffer.contents buf

let concat s1 s2 =
	create_ucs2 (s1.sstring ^ s2.sstring) (s1.slength + s2.slength)

let join sep sl =
	let buf = AwareBuffer.create () in
	let rec loop sl = match sl with
		| [s] ->
			AwareBuffer.add_string buf s;
		| s :: sl ->
			AwareBuffer.add_string buf s;
			AwareBuffer.add_string buf sep;
			loop sl;
		| [] ->
			()
	in
	loop sl;
	AwareBuffer.contents buf

let bytes_to_utf8 s =
	vstring (create_ascii (Bytes.unsafe_to_string s))

let create_unknown s =
	bytes_to_utf8 (Bytes.unsafe_of_string s)

exception InvalidUnicodeChar

let case_map this upper =
	let dest = Bytes.of_string this.sstring in
	let a,m = if upper then EvalBytes.Unicase._UPPER,1022 else EvalBytes.Unicase._LOWER,1021 in
	let f i c =
		let up = c lsr 6 in
		if up < m then begin
			let c' = a.(up).(c land ((1 lsl 6) - 1)) in
			if c' <> 0 then EvalBytes.write_ui16 dest i c'
		end
	in
	let l = Bytes.length dest in
	let rec loop i =
		if i = l then
			()
		else begin
			let c = EvalBytes.read_ui16 dest i in
			f i c;
			loop (i + 2)
		end
	in
	loop 0;
	(create_ucs2 (Bytes.unsafe_to_string dest) this.slength)

let from_char_code i =
	if i < 0 then
		raise Not_found
	else if i < 128 then
		create_ascii (String.make 1 (char_of_int i))
	else if i < 0x10000 then begin
		if i >= 0xD800 && i <= 0xDFFF then raise InvalidUnicodeChar;
		let b = Bytes.create 2 in
		write_ui16 b 0 i;
		create_ucs2 (Bytes.unsafe_to_string b) 1
	end else if i < 0x110000 then begin
		let i = i - 0x10000 in
		let b = Bytes.create 4 in
		write_ui16 b 0 ((i lsr 10 + 0xD800));
		write_ui16 b 2 ((i land 1023) + 0xDC00);
		create_ucs2 (Bytes.unsafe_to_string b) 2
	end else
		raise InvalidUnicodeChar

let find_substring this sub reverse =
	let s_this = this.sstring in
	let l_this = String.length s_this in
	let s_sub = sub.sstring in
	let l_sub = String.length s_sub in
	let rec scan i k =
		if k = l_sub then true
		else if String.unsafe_get s_this (i + k) = String.unsafe_get s_sub k then scan i (k + 1)
		else false
	in
	let inc = 2 in
	if reverse then begin
		let rec loop i =
			if i < 0 then raise Not_found;
			if scan i 0 then
				i,i + l_sub
			else
				loop (i - inc)
		in
		loop
	end else begin
		let rec loop i =
			if i > l_this - l_sub then raise Not_found;
			if scan i 0 then
				i,i + l_sub
			else
				loop (i + inc)
		in
		loop
	end

let get s =
	let s' = s.sstring in
	utf16_to_utf8 s' *)