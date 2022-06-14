//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;

using Toybox.Cryptography;
using BytesModule;
using CryptoModule;

class MainView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
        onUpdate(dc);
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(
            dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM,
            "ENTER to start",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}


class MainViewDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onKey(event) {
        // var key = event.getKey();
        // // System.print(key);

        // var salt = [48, 223, 230, 71, 64, 237, 69, 158, 161, 21, 181, 23, 189, 115, 123, 186, 223, 33, 184, 56]b;
        // var key = [7, 218, 61, 69, 176, 241, 57, 0, 131, 9, 122, 149, 168, 145, 95, 194, 246, 176, 108, 111]b;
        // var test = CryptoModule.pbkdf2(key, salt, 10, 256);

        // log(DEBUG, test.toString());
    }

    function onSelect() {
    }
}
