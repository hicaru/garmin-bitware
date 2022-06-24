using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Lang;

using ArrayModule;


class MnemonicRememberView extends WatchUi.View {
    private var _words as Array;
    private var _chunks as Array;

    public var page = 0;

    function initialize(words as Array) {
        View.initialize();
        self._words = words;
        self._chunks = ArrayModule.chunk(words, 3);

        log(DEBUG, self._chunks);
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
        var length = self._chunks.size();
        var chunk = self._chunks[self.page];

        dc.drawText(
            width / 2, margin, Graphics.FONT_SMALL,
            Lang.format("#$1$ $2$", [self._words.indexOf(chunk[0]) + 1, chunk[0]]),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        dc.drawText(
            width / 2, height / 2, Graphics.FONT_LARGE,
            Lang.format("#$1$ $2$", [self._words.indexOf(chunk[1]) + 1, chunk[1]]),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        dc.drawText(
            width / 2, height - margin, Graphics.FONT_SMALL,
            Lang.format("#$1$ $2$", [self._words.indexOf(chunk[2]) + 1, chunk[2]]),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}
