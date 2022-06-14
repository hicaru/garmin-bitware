using Toybox.WatchUi;

class Bip39ViewDelegate extends WatchUi.BehaviorDelegate {
    private var _view as Bip39View;

    function initialize(view as Bip39View) {
        BehaviorDelegate.initialize();
        self._view = view;
    }

    function onKey(event) {
        return BehaviorDelegate.onKey(event);
    }

    function onSelect() {
    }
}
