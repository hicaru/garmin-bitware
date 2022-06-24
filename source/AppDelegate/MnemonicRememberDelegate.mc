using Toybox.WatchUi;

class MnemonicRememberDelegate extends WatchUi.BehaviorDelegate {
    private var _view as MnemonicRememberView;

    function initialize(view as MnemonicRememberView) {
        BehaviorDelegate.initialize();
        self._view = view;
    }

    function onKeyPressed(event) {
        var key = event.getKey();

        switch(key) {
            case WatchUi.KEY_UP:
                self._view.previousPage();
                break;
            case WatchUi.KEY_DOWN:
                self._view.nextPage();
                break;
            case WatchUi.KEY_ENTER:
                var view = new MnemonicView(self._view.words);
                WatchUi.pushView(view, new MnemonicDelegate(view), WatchUi.SLIDE_RIGHT);
                break;
        }
    }

    function onSelect() {
    }
}
