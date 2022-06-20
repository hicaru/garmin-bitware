using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Math;
using Toybox.System;
using Toybox.Cryptography;

using BIP39Module;
using BytesModule;
using CryptoModule;


class MnemonicView extends WatchUi.View {
    var screen_shape;

    private var _type = START;

    private var _mnemonicBytes as ByteArray;

    enum {
        MNEMONIC,
        NONE,
        START
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
            case NONE:
                break;
            case MNEMONIC:
                self._generateMnemonic();
                break;
            default:
                self._type = MNEMONIC;
                return;
        }

        log(DEBUG, self._mnemonicBytes);
    }

    private function _generateMnemonic() {
        // 16 - 12 words, 32 - 24 words.
        var entropy = Cryptography.randomBytes(16l);
        var words = BIP39Module.entropyToMnemonic(entropy);

        self._type = NONE;
        self._mnemonicBytes = BytesModule.strToBytes(words);
    }
}
