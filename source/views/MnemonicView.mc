using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Math;
using Toybox.System;
using Toybox.Cryptography;

using BIP39Module;
using BytesModule;
using CryptoModule;


class Hmac512Async {
    private var _type = START;
    private var _blocksize = 128;
    private var _key_ipad = new [self._blocksize]b;
    private var _key_opad = new [self._blocksize]b;

    public var key as ByteArray;
    public var data as ByteArray;
    public var hmac as ByteArray;

    enum {
        START,
        MIDDLE,
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
            case START:
                for (var i = 0; i < self._blocksize; i++) {
                    var k = i < self.key.size() ? self.key[i].toNumber() : 0x00;
                    self._key_ipad[i] = k ^ 0x36;
                    self._key_opad[i] = k ^ 0x5C;
                }
                self._type = MIDDLE;
                return;
            case MIDDLE:
                log(DEBUG, CryptoModule.sha512(new [120]b));
                // CryptoModule.sha512(self._key_ipad.addAll(self.data));
                // self._key_opad = self._key_opad.addAll(CryptoModule.sha512(self._key_ipad.addAll(self.data)));
                self._type = END;
                return;
            case END:
                // self.hmac = CryptoModule.sha512(self._key_opad);
                self.hmac = new [10]b;
                return;
            default:
                // Throw new 
                log(ERROR, "incorrect type");
                return;
        }

        return;
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
                    log(DEBUG, "self._hmac.hmac");
                } else {
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
