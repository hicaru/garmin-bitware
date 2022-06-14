using Toybox.WatchUi;

class MainViewDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onKey(event) {
        var key = event.getKey();
        System.print(key);

        var view = new Bip39View();
        WatchUi.pushView(view, new Bip39ViewDelegate(view), WatchUi.SLIDE_RIGHT);

        // var salt = [48, 223, 230, 71, 64, 237, 69, 158, 161, 21, 181, 23, 189, 115, 123, 186, 223, 33, 184, 56]b;
        // var key = [7, 218, 61, 69, 176, 241, 57, 0, 131, 9, 122, 149, 168, 145, 95, 194, 246, 176, 108, 111]b;
        // var test = CryptoModule.pbkdf2(key, salt, 10, 256);

        // log(DEBUG, test.toString());

        BehaviorDelegate.onKey(event);
    }

    function onSelect() {
    }
}
