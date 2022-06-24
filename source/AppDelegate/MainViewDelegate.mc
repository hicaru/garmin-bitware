using Toybox.WatchUi;

class MainViewDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onKeyPressed(event) {
        var key = event.getKey();

        if (key == WatchUi.KEY_ESC) {
            return BehaviorDelegate.onKey(event);
        }

        var entropy = Cryptography.randomBytes(32l);
        var words = BIP39Module.entropyToMnemonic(entropy);
        var view = new MnemonicRememberView(words);

        // generate Mnemonic.
        // var view = new MnemonicView();
        WatchUi.pushView(view, new MnemonicRememberDelegate(view), WatchUi.SLIDE_RIGHT);

        return true;
    }

    function onSelect() {
    }
}
