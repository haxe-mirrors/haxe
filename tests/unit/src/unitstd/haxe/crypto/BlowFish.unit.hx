var blowfish = new haxe.crypto.Blowfish("password",haxe.io.Bytes.ofString("someIVec"));
blowfish.init("password");
blowfish.iv = haxe.io.Bytes.ofString("someIVec");
blowfish.getBlockSize();

blowFish.encrypt(Mode.CBC,haxe.io.Bytes.ofString("Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor")).toHex() == "e532f49e13e401b0fe15482207417daeed4cb14bb9910fe9a7ade06bf4d152de8e2add697f56dd0204a3426a3a4ba458b1432db500e842b5844b89d92c78cbc24c976818777fcd00bc5370a5d5a1e57b98a2009e440656df1e5f9c0e63d155df";
blowFish.encrypt(Mode.CFB,haxe.io.Bytes.ofString("Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor")).toHex() == "0f6905dac7e17ad4e74992edc0c45568352b203ee9217040174eecc5cb1aa0572dfbfea42176762ac25789cb1632eba1c0eb284907bf7b2f8fdd669e139b3e679364add461c4d0270d83c63dd6e6f29ba6b96fa2fb0c430733ef";
blowFish.encrypt(Mode.CTR,haxe.io.Bytes.ofString("Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor")).toHex() == "0f6905dac7e17ad4cf2d03d40925e278f8a5de4696012cea49fda204657f5eed96bf63f3451ae942fe639fb5449398117a07424d276904bc1c547ff4f142fcb89df0830f25c1973743421e92aa5e3cfe2617ed7beda1bb7e8b6a167a069f895d";
blowFish.encrypt(Mode.ECB,haxe.io.Bytes.ofString("Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor")).toHex() == "5027df2684ab6f6e719c734220d25685ccc5e6be791d634a16ff334d1f28c3030bb2de59cf82f84e63d6d4acec2d12edc513f56ee3b93159a52f2c9003c30dd41d19884f1ee36e3a8a62c649d852c345dce08f517cad9877b4d408bbd1151c0c";
blowFish.encrypt(Mode.OFB,haxe.io.Bytes.ofString("Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor")).toHex() == "0f6905dac7e17ad4c16603374ad314ca93c894ddd807b252855f0d402b350fb49003fe7c0ce34370d0792410549903215e8433d9d8d95a864d167d00a35850a49de3a27685a2ba576d361394535039b1655d35141b051dc0a143";
blowFish.encrypt(Mode.PCBC,haxe.io.Bytes.ofString("Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor")).toHex() == "e532f49e13e401b0a17dd20704a6d86ab8f4da36a85d419ddcd49dbe11f2e422f4f3f8ac912293ce93d497c11cf8b91c1302b807c3bd183edaee43acc810295512c4d416030c397503b6d34123ba4a04d3f77b45396994d913574e33db44c971";

blowFish.decrypt(Mode.CBC,haxe.io.Bytes.ofHex("e532f49e13e401b0fe15482207417daeed4cb14bb9910fe9a7ade06bf4d152de8e2add697f56dd0204a3426a3a4ba458b1432db500e842b5844b89d92c78cbc24c976818777fcd00bc5370a5d5a1e57b98a2009e440656df1e5f9c0e63d155df")).toString() == "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor";
blowFish.decrypt(Mode.CFB,haxe.io.Bytes.ofHex("0f6905dac7e17ad4e74992edc0c45568352b203ee9217040174eecc5cb1aa0572dfbfea42176762ac25789cb1632eba1c0eb284907bf7b2f8fdd669e139b3e679364add461c4d0270d83c63dd6e6f29ba6b96fa2fb0c430733ef")).toString() == "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor";
blowFish.decrypt(Mode.CTR,haxe.io.Bytes.ofHex("0f6905dac7e17ad4cf2d03d40925e278f8a5de4696012cea49fda204657f5eed96bf63f3451ae942fe639fb5449398117a07424d276904bc1c547ff4f142fcb89df0830f25c1973743421e92aa5e3cfe2617ed7beda1bb7e8b6a167a069f895d")).toString() == "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor";
blowFish.decrypt(Mode.ECB,haxe.io.Bytes.ofHex("5027df2684ab6f6e719c734220d25685ccc5e6be791d634a16ff334d1f28c3030bb2de59cf82f84e63d6d4acec2d12edc513f56ee3b93159a52f2c9003c30dd41d19884f1ee36e3a8a62c649d852c345dce08f517cad9877b4d408bbd1151c0c")).toString() == "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor";
blowFish.decrypt(Mode.OFB,haxe.io.Bytes.ofHex("0f6905dac7e17ad4c16603374ad314ca93c894ddd807b252855f0d402b350fb49003fe7c0ce34370d0792410549903215e8433d9d8d95a864d167d00a35850a49de3a27685a2ba576d361394535039b1655d35141b051dc0a143")).toString() == "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor";
blowFish.decrypt(Mode.PCBC,haxe.io.Bytes.ofHex("e532f49e13e401b0a17dd20704a6d86ab8f4da36a85d419ddcd49dbe11f2e422f4f3f8ac912293ce93d497c11cf8b91c1302b807c3bd183edaee43acc810295512c4d416030c397503b6d34123ba4a04d3f77b45396994d913574e33db44c971")).toString() == "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor";
