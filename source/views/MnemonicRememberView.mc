using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Lang;

using ArrayModule;


class MnemonicRememberView extends WatchUi.View {
    private var _words as Array;
    private var _chunks as Array;
    private var _seed as ByteArray;

    public var page = 0;

    function initialize(words as Array, seed as ByteArray) {
        View.initialize();
        self._words = words;
        self._seed = seed;
        self._chunks = ArrayModule.chunk(words, 3);
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        self._drowChunksWords(dc);
    }

    public function nextPage() {
        var newpage = self.page + 1;
        var length = self._chunks.size() - 1;

        if (newpage <= length) {
            self.page = newpage;
            WatchUi.requestUpdate();
        }
    }

    public function previousPage() {
        var newpage = self.page - 1;

        if (newpage >= 0) {
            self.page = newpage;
            WatchUi.requestUpdate();
        }
    }

    private function _drowChunksWords(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var margin = 70;

        dc.drawText(
            width / 2, margin, Graphics.FONT_SMALL,
            Lang.format("#$1$ $2$", [self.page + 1, self._chunks[self.page][0]]),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        dc.drawText(
            width / 2, height / 2, Graphics.FONT_LARGE,
            Lang.format("#$1$ $2$", [self.page + 2, self._chunks[self.page][1]]),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        dc.drawText(
            width / 2, height - margin, Graphics.FONT_SMALL,
            Lang.format("#$1$ $2$", [self.page + 3, self._chunks[self.page][2]]),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}
