using Toybox.Lang;
using Toybox.StringUtil;
using Toybox.Cryptography;
using Toybox.System;
using BytesModule;


module CryptoModule {
    // (:glance)
    // function sha256() {
    //     var bytes = BytesModule.base16ToBytes("80000000000000000000000000000080");

    //     System.print(bytes);

    //     var sha1 = new Cryptography.Hash({
    //         :algorithm => Cryptography.HASH_SHA256
    //     });

    //     sha1.update(bytes);
    //     var res = sha1.digest();
    //     System.print(BytesModule.bytesToBase16(res));
    // }

    (:glance)
    function sha256(bytes) {
        var sha2 = new Cryptography.Hash({
            :algorithm => Cryptography.HASH_SHA256
        });

        sha2.update(bytes);
        return sha2.digest();
    }

    (:glance)
    function hmacSHA2(key, text) {
        var BS = 64;
        if (key.size() > BS) {
            key = sha256(key);
        }

        // MAC = H(K XOR opad, H(K XOR ipad, text))
        var key_ipad = new [BS];
        var key_opad = new [BS];

        for (var i = 0; i < BS; i++) {
            var k = i < key.size() ? key[i] : 0x00;
            key_ipad[i] = k ^ 0x36;
            key_opad[i] = k ^ 0x5C;
        }

        return sha256(key_opad.addAll(sha256(key_ipad.addAll(text))));
    }
}
