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
    var screen_shape;

    function initialize() {
        View.initialize();
        screen_shape = System.getDeviceSettings().screenShape;
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
        drawProgress(dc, 10, 30, Graphics.COLOR_GREEN);
    }

    function drawProgress(dc, value, max, codeColor) {
        dc.setPenWidth(dc.getHeight() / 40);
        dc.setColor(codeColor, Graphics.COLOR_TRANSPARENT);
        if (self.screen_shape == System.SCREEN_SHAPE_ROUND) {
            // Available from 3.2.0
            if (dc has :setAntiAlias) {
                dc.setAntiAlias(true);
            }

            dc.drawArc(dc.getWidth() / 2, dc.getHeight() / 2, (dc.getWidth() / 2) - 2, Graphics.ARC_COUNTER_CLOCKWISE, 90, ((value * 360) / max) + 90);
            // Available from 3.2.0
            if (dc has :setAntiAlias) {
                dc.setAntiAlias(false);
            }
        } else {
            dc.fillRectangle(0, 0, ((value * dc.getWidth()) / max), dc.getHeight() / 40);
        }
    }
}

