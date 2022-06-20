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

    private var _type = MNEMONIC;

    private var _mnemonicBytes as ByteArray;

    enum {
        MNEMONIC,
        NONE
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
                break;
        }

        log(DEBUG, self._mnemonicBytes);
    }

    private function _generateMnemonic() {
        // var entropy = Cryptography.randomBytes(16l);
        var entropy = [57, 48, 140, 37, 175, 232, 112, 219, 177, 244, 11, 56, 191, 73, 190, 26]b;
        var words = BIP39Module.entropyToMnemonic(entropy);

        self._type = NONE;
        self._mnemonicBytes = BytesModule.strToBytes(words);
    }
}
