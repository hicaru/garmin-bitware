using Toybox.WatchUi;

class MainViewDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onKey(event) {
        var key = event.getKey();

        if (key == WatchUi.KEY_ESC) {
            return BehaviorDelegate.onKey(event);
        }

        var words = [
            "decrease", "love",
            "annual", "garlic",
            "mandate", "horse",
            "sick", "lift",
            "december", "where",
            "hurdle", "crystal"
        ];
        var seed = [
            232, 231, 9, 115, 59, 224, 164, 230,
            22, 69, 30, 38, 149, 136, 96, 85, 140,
            82, 12, 125, 201, 62, 161, 96, 109, 145,
            32, 166, 193, 172, 55, 59, 239, 87, 52,
            62, 195, 136, 95, 60, 64, 192, 163, 0,
            206, 146, 116, 255, 135, 129, 195, 47,
            55, 16, 106, 48, 214, 83, 52, 48, 237,
            155, 196, 80
        ]b;

        var view = new MnemonicRememberView(words, seed);

        // generate Mnemonic.
        // var view = new MnemonicView();
        WatchUi.pushView(view, new MnemonicRememberDelegate(view), WatchUi.SLIDE_RIGHT);
    }

    function onSelect() {
    }
}
