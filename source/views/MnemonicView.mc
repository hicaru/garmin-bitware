using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Cryptography;
using Toybox.Math;
using Toybox.Test;

using BIP39Module;
using BytesModule;
using CryptoModule;
using HashModule;


class Hmac512Async {
    private var _type = START;
    private var _blocksize = 128;
    private var _hash = new HashModule.Sha512();
    private var _key_ipad = new [self._blocksize]b;
    private var _key_opad = new [self._blocksize]b;

    private var _tmp as ByteArray;

    public var key as ByteArray;
    public var data as ByteArray;
    public var hmac as ByteArray;

    enum {
        START,
        MIDDLE,
        MIDDLE_HASH,
        END
    }


    function initialize(key as ByteArray, data as ByteArray) {
        self.key = key;
        self.data = data;

        if (self.key.size() > self._blocksize) {
            self.key = CryptoModule.sha512(self.key);
            log(DEBUG, "key.size() > self._blocksize");
        }
    }

    public function getHmac() {
        return self.hmac;
    }

    public function nextStep() {
        switch(self._type) {
            case MIDDLE_HASH:
                self._tmp = self._hash.digest();
                self._hash = new HashModule.Sha512();
                self._type = MIDDLE;
                return;
            case START:
                for (var i = 0; i < self._blocksize; i++) {
                    var k = i < self.key.size() ? self.key[i].toNumber() : 0x00;
                    self._key_ipad[i] = k ^ 0x36;
                    self._key_opad[i] = k ^ 0x5C;
                }
                self._hash.update(self._key_ipad.addAll(self.data));
                self._type = MIDDLE_HASH;
                return;
            case MIDDLE:
                self._key_opad = self._key_opad.addAll(self._tmp);
                self._hash.update(self._key_opad);
                self._type = END;
                self._tmp = new [0]b;
                return;
            case END:
                self.hmac = self._hash.digest();
                return;
            default:
                // Throw new 
                log(ERROR, "incorrect type");
                return;
        }

        return;
    }
}


class Pbkdf2Async {
    public const hLen = 64; // 64 bytes len

    private var _password as ByteArray;
    private var _salt as ByteArray;
    private var _iterations as Number;
    private var _keylen as Number;

    private var _DK as ByteArray;
    private var _block1 as ByteArray;
    private var _length as Number;

    private var _destPos = 0;

    enum {
        STEP0
    }

    function initialize(
        password as ByteArray,
        salt as ByteArray,
        iterations as Number,
        keylen as Number
    ) {
        Test.assert(keylen > 0);
        Test.assert(keylen < MAX_ALLOC);

        self._password = password;
        self._salt = salt;
        self._iterations = iterations;
        self._keylen = keylen;

        self._length = Math.ceil(keylen / self.hLen);
        self._DK = new [keylen]b;
        self._block1 = new [salt.size() + 4]b;
        self._block1 = BytesModule.bufferCopy(salt, self._block1, 0, 0, salt.size());
    }

    public function start() {
        switch(self._type) {
            case STEP0:
                return;
        }
    }
}

class MnemonicView extends WatchUi.View {
    private var _type = START;

    private var _hmac as Hmac512Async;

    var screen_shape;
    private var _mnemonicBytes as ByteArray;


    enum {
        MNEMONIC,
        NONE,
        START,
        HMAC
    }


    function initialize() {
        View.initialize();
        screen_shape = System.getDeviceSettings().screenShape;
    }

    function onShow() {
        log(DEBUG, "Show MnemonicView");
    }

    function onUpdate(dc) {
        switch(self._type) {
            case HMAC:
                if (self._hmac.getHmac() == null) {
                    self._hmac.nextStep();
                    WatchUi.requestUpdate();
                } else {
                    log(DEBUG, self._hmac.hmac);
                    self._type = NONE;
                }
                break;
            case NONE:
                break;
            case MNEMONIC:
                self._generateMnemonic();
                break;
            default:
                self._type = MNEMONIC;
                return;
        }
    }

    private function _generateMnemonic() {
        // 16 - 12 words, 32 - 24 words.
        var entropy = Cryptography.randomBytes(16l);
        var words = BIP39Module.entropyToMnemonic(entropy);

        self._mnemonicBytes = BytesModule.strToBytes(words);

        self._startHmac();

        self._type = HMAC;

        WatchUi.requestUpdate();
    }

    private function _startHmac() {
        var key = [38, 149, 136,  96,  85, 140,  82,  12, 125, 201,  62]b;
        var data = [206, 146, 116, 255, 135, 129, 195,  47,  55,  16, 106]b;

        self._hmac = new Hmac512Async(key, data);
    }
}
