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

    private var _T as ByteArray;
    private var _U as ByteArray;

    private var _DK as ByteArray;
    private var _block1 as ByteArray;
    private var _length as Number;

    private var _hmac as Hmac512Async;

    private var _destPos = 0;
    private var _next_index = 1;
    private var _iterations_index = 1;
    private var _type = STEP0;

    enum {
        STEP0, // create block and first step hmac.
        STEP1, // finish create hmac.
        STEP2, // start mix bytes.
        STEP3, // finish mix bytes.
        DONE
    }

    function initialize(
        password as ByteArray,
        salt as ByteArray,
        iterations as Number,
        keylen as Number
    ) {
        Test.assert(keylen > 0);
        Test.assert(keylen < CryptoModule.MAX_ALLOC);

        self._password = password;
        self._salt = salt;
        self._iterations = iterations;
        self._keylen = keylen;

        self._length = Math.ceil(keylen / self.hLen);
        self._DK = new [keylen]b;
        self._block1 = new [salt.size() + 4]b;
        self._block1 = BytesModule.bufferCopy(salt, self._block1, 0, 0, salt.size());
    }

    public function getResult() {
        if (self._type == DONE) {
            return self._DK;
        }

        return null;
    }

    public function start() {
        if (self._type == STEP2 || self._type == STEP3) {
            self._mixBytes();

            return;
        }

        if (self._next_index <= self._length) {
            switch(self._type) {
                case STEP0:
                    self._block1 = BytesModule.writeUint32BE(
                        self._block1,
                        self._next_index,
                        self._salt.size()
                    );
                    self._hmac = new Hmac512Async(self._password, self._block1);
                    self._hmac.nextStep();
                    self._type = STEP1;
                    return;
                case STEP1:
                    var hmcaHash = self._hmac.getHmac();
                    if (hmcaHash != null) {
                        self._T = hmcaHash;
                        self._U = self._T;
                        self._type = STEP2;
                        self._mixBytes();
                    } else {
                        self._hmac.nextStep();
                    }
                    return;
            }
        } else {
            // STOP loop.
            self._type = DONE;
            self._U = new [0];
            self._T = new [0];
            self._block1 = new [0];
        }

        return;
    }

    private function _xorBytes() {
        switch(self._type) {
            case STEP2:
                self._hmac = new Hmac512Async(self._password, self._U);
                self._type = STEP3;
                self._hmac.nextStep();
                return;
            case STEP3:
                var hmacHash = self._hmac.getHmac();
                if (hmacHash != null) {
                    self._U = hmacHash;
                    self._T = BytesModule.xorArray(self._U, self._T, self.hLen);
                    self._type = STEP2;
                    self._iterations_index++;
                } else {
                    self._hmac.nextStep();
                }
                return;
        }
    }

    private function _mixBytes() {
        self._xorBytes();

        if (self._iterations_index == self._iterations) {
            self._DK = BytesModule.bufferCopy(self._T, self._DK, self._destPos, 0, self._T.size());
            self._destPos += self.hLen;
            self._next_index++;
            self._iterations_index = 1; // reset index
            self._type = STEP0; // next step
        }
    }
}

class MnemonicView extends WatchUi.View {
    private const _max_interactions = 10242f;

    private var _type = START;

    private var _pbkdf2 as Pbkdf2Async;

    var screen_shape;
    private var _mnemonicBytes as ByteArray;
    private var _counter = 0f;

    enum {
        MNEMONIC,
        NONE,
        START,
        PBKDF2
    }


    function initialize() {
        View.initialize();
        screen_shape = System.getDeviceSettings().screenShape;
    }

    function onShow() {
        log(DEBUG, "Show MnemonicView");
    }

    function onUpdate(dc) {
        self._counter++;

        dc.clear();

        drawProgress(
            dc,
            (self._counter * 100f) / self._max_interactions + 1f,
            100,
            Graphics.COLOR_BLUE
        );

        if (self._counter == 1) {
            dc.drawText(
                dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM,
                "Loading...",
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            );
        }

        switch(self._type) {
            case PBKDF2:
                self._pbkdf2.start();
                var hash = self._pbkdf2.getResult();
                if (hash != null) {
                    log(DEBUG, [
                        "HASH",
                        hash
                    ]);
                } else {
                    WatchUi.requestUpdate();
                }
                return;
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
        var entropy = Cryptography.randomBytes(32l);
        var words = BIP39Module.entropyToMnemonic(entropy);

        // self._mnemonicBytes = BytesModule.strToBytes(words);

        // self._startPbkdf2();

        // self._type = PBKDF2;

        // WatchUi.requestUpdate();
    }

    private function _startPbkdf2() {
        self._pbkdf2 = new Pbkdf2Async(
            self._mnemonicBytes,
            SALT,
            2048,
            64
        );
    }

    /// views
    function drawProgress(dc, value, max, codeColor) {
        dc.setPenWidth(dc.getHeight() / 40);
        dc.setColor(codeColor, Graphics.COLOR_TRANSPARENT);
        if (self.screen_shape == System.SCREEN_SHAPE_ROUND) {
            // Available from 3.2.0
            if (dc has :setAntiAlias) {
                dc.setAntiAlias(true);
            }

            dc.drawArc(dc.getWidth() / 2, dc.getHeight() / 2, (dc.getWidth() / 2) - 2, Graphics.ARC_COUNTER_CLOCKWISE, 90, ((value * 360) / max) + 90);
            // Available from 3.2.0
            if (dc has :setAntiAlias) {
                dc.setAntiAlias(false);
            }
        } else {
            dc.fillRectangle(0, 0, ((value * dc.getWidth()) / max), dc.getHeight() / 40);
        }
    }
    /// views
}
