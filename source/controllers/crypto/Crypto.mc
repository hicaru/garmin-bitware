using Toybox.Lang;
using Toybox.StringUtil;
using Toybox.Cryptography;
using Toybox.System;
using Toybox.Math;
using Toybox.Test;

using BytesModule;
using HashModule;


module CryptoModule {
    const MAX_ALLOC = 1073741823; 
    // (:glance)
    // function sha256() {
        // var entropy = Cryptography.randomBytes(64l);
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
    function sha512(bytes) {
        var hash = new HashModule.Sha512();
        hash.update(bytes);
        return hash.digest();
    }

    (:glance)
    function hmac(key, text) {
        var BS = 64;
        if (key.size() > BS) {
            key = sha512(key);
        }

        // MAC = H(K XOR opad, H(K XOR ipad, text))
        var key_ipad = new [BS]b;
        var key_opad = new [BS]b;

        for (var i = 0; i < BS; i++) {
            var k = i < key.size() ? key[i].toNumber() : 0x00;
            key_ipad[i] = k ^ 0x36;
            key_opad[i] = k ^ 0x5C;
        }

        return sha512(key_opad.addAll(sha512(key_ipad.addAll(text))));
    }

    (:glance)
    function pbkdf2(password as ByteArray, salt as ByteArray, iterations, keylen) {
        Test.assert(keylen > 0);
        Test.assert(keylen < MAX_ALLOC);

        var hLen = 64;

        var DK = new [keylen]b;
        var block1 = new [salt.size() + 4]b;

        block1 = BytesModule.bufferCopy(salt, block1, 0, 0, salt.size());

        var destPos = 0;
        var l = Math.ceil(keylen / hLen);

        for (var i = 1; i <= l; i++) {
            block1 = BytesModule.writeUint32BE(block1, i, salt.size());

            var T = hmac(password, block1);
            var U = T;

            for (var j = 1; j < iterations; j++) {
                U = hmac(password, U);
                for (var k = 0; k < hLen; k++) {
                    T[k] ^= U[k];
                }
            }

            DK = BytesModule.bufferCopy(T, DK, destPos, 0, T.size());

            destPos += hLen;
        }

        return DK;
    }
}
