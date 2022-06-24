using Toybox.WatchUi;
using Toybox.Graphics;

class MnemonicRememberView extends WatchUi.View {
    private var _words as Array;
    private var _seed as ByteArray;

    function initialize(words as Array, seed as ByteArray) {
        View.initialize();
        self._words = words;
        self._seed = seed;
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
    }
}

