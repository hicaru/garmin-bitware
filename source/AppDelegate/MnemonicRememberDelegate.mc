using Toybox.WatchUi;

class MnemonicRememberDelegate extends WatchUi.BehaviorDelegate {
    private var _view as MnemonicRememberView;

    function initialize(view as MnemonicRememberView) {
        BehaviorDelegate.initialize();
        self._view = view;
    }

    function onKey(event) {
        var key = event.getKey();
        // log(DEBUG, event.getKey());

        if (key == KEY_UP) {
            self._view.previousPage();
        } else if (key == KEY_DOWN) {
            self._view.nextPage();
        }
    }

    function onSelect() {
    }
}
