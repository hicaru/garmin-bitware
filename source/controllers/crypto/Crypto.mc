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
}
