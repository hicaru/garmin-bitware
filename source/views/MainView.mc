//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;

class MainView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
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
        WatchUi.pushView(view, new MnemonicRememberDelegate(view), WatchUi.SLIDE_RIGHT);
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(
            dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM,
            "ENTER to start",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}

