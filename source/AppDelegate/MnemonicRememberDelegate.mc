using Toybox.WatchUi;

class MnemonicRememberDelegate extends WatchUi.BehaviorDelegate {
    private var _view as MnemonicRememberView;

    function initialize(view as MnemonicRememberView) {
        BehaviorDelegate.initialize();
        self._view = view;
    }

    function onKey(event) {
        log(DEBUG, event.getKey());
        return BehaviorDelegate.onKey(event);
    }

    function onSelect() {
    }
}
