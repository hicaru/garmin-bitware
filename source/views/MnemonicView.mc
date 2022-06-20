using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Math;
using Toybox.Cryptography;

using BIP39Module;
using BytesModule;
using CryptoModule;


class MnemonicView extends WatchUi.View {
    var screen_shape;

    private var _mnemonicBytes as ByteArray;


    function initialize() {
        View.initialize();
        screen_shape = System.getDeviceSettings().screenShape;
    }

    function onShow() {
        log(DEBUG, "Show MnemonicView");
    }

    function onUpdate(dc) {}

    private function _generateMnemonic() {
        var entropy = Cryptography.randomBytes(32l);
        var words = BIP39Module.entropyToMnemonic();

        self._mnemonicBytes = BytesModule.strToBytes(words);
    }
}
