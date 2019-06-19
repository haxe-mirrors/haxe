open JvmGlobals
open JvmData
open JvmSignature
open JvmAttribute

type annotation_kind =
	| AInt of Int32.t
	| ADouble of float
	| AString of string
	| ABool of bool
	| AEnum of jsignature * string
	| AArray of annotation_kind list

and annotation = (string * annotation_kind) list

type export_config = {
	export_debug : bool;
}

class base_builder = object(self)
	val mutable access_flags = 0
	val attributes = DynArray.create ()
	val annotations = DynArray.create ()
	val mutable was_exported = false

	method add_access_flag i =
		access_flags <- i lor access_flags

	method add_attribute (a : j_attribute) =
		DynArray.add attributes a

	method add_annotation (path : jpath) (a : annotation) =
		DynArray.add annotations ((TObject(path,[])),a)

	method private commit_annotations pool =
		if DynArray.length annotations > 0 then begin
			let open JvmAttribute in
			let a = DynArray.to_array annotations in
			let a = Array.map (fun (jsig,l) ->
				let offset = pool#add_string (generate_signature false jsig) in
				let l = List.map (fun (name,ak) ->
					let offset = pool#add_string name in
					let rec loop ak = match ak with
						| AInt i32 ->
							'I',ValConst(pool#add (ConstInt i32))
						| ADouble f ->
							'D',ValConst(pool#add (ConstDouble f))
						| AString s ->
							's',ValConst(pool#add_string s)
						| ABool b ->
							'Z',ValConst(pool#add (ConstInt (if b then Int32.one else Int32.zero)))
						| AEnum(jsig,name) ->
							'e',ValEnum(pool#add_string (generate_signature false jsig),pool#add_string name)
						| AArray l ->
							let l = List.map (fun ak -> loop ak) l in
							'[',ValArray(Array.of_list l)
					in
					offset,loop ak
				) l in
				{
					ann_type = offset;
					ann_elements = Array.of_list l;
				}
			) a in
			self#add_attribute (AttributeRuntimeVisibleAnnotations a)
		end

	method export_attributes (pool : JvmConstantPool.constant_pool) =
		DynArray.to_array (DynArray.map (write_attribute pool) attributes)
end