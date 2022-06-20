
using Toybox.Lang;

using BytesModule;
using CryptoModule;


module BIP39Module {
    const MESSAGE_INVALID_ENTROPY = "Invalid entropy should be 128 <= ENT <= 256";

    (:glance)
    function sliceIntoChunks(string as String, chunkSize) {
        var res = [];
        var length = string.length();

        for (var i = 0; i < length; i += chunkSize) {
            var chunk = string.substring(i, i + chunkSize);
            res.add(chunk);
        }

        return res;
    }

    (:glance)
    function deriveChecksumBits(entropy as ByteArray) {
        var ENT = entropy.size() * 8;
        var CS = ENT / 32;
        var hash = CryptoModule.sha256(entropy);

        return BytesModule.bytesToBinary(hash).substring(0, CS);
    }

    (:glance)
    function getWords(chunks as Array) {
        var length = chunks.size();
        var words = [];

        for (var i = 0; i < length; i++) {
            var index = chunks[i].toNumberWithBase(2);
            var word = WORD_LIST[index];
            if (word != null) {
                words.add(word);
            } 
        }

        return words;
    }

    (:glance)
    function entropyToMnemonic(entropy as ByteArray) {
        var entropySize = entropy.size();
        // 128 <= ENT <= 256
        if (entropySize < 16) {
            throw new EntropyException(MESSAGE_INVALID_ENTROPY);
        }
        if (entropySize > 32) {
            throw new EntropyException(MESSAGE_INVALID_ENTROPY);
        }
        if (entropySize % 4 != 0) {
            throw new EntropyException(MESSAGE_INVALID_ENTROPY);
        }

        var entropyBits = BytesModule.bytesToBinary(entropy);
        var checksumBits = BIP39Module.deriveChecksumBits(entropy);
        var bits = entropyBits + checksumBits;
        var chunks = sliceIntoChunks(bits, 11);

        return getWords(chunks);
    }


    (:glance)
    class EntropyException extends Lang.Exception {
        var _msg;

        function initialize(msg) {
            Exception.initialize();
            self._msg = msg;
        }

        function getErrorMessage() {
            return self._msg;
        }
    }
}
