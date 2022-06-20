using Toybox.WatchUi;

class MnemonicDelegate extends WatchUi.BehaviorDelegate {
    private var _view as MnemonicView;

    function initialize(view as MnemonicView) {
        BehaviorDelegate.initialize();
        self._view = view;
    }

    function onKey(event) {
        return BehaviorDelegate.onKey(event);
    }

    function onSelect() {
    }
}
