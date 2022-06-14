using Toybox.System;
using Toybox.WatchUi;

using Toybox.Cryptography;
using BytesModule;
using CryptoModule;


(:glance)
class WidgetGlanceView extends WatchUi.GlanceView {
    function initialize() {
        GlanceView.initialize();

        log(DEBUG, "GlanceView onShow");
    }

    function onLayout(dc) {
        onUpdate(dc);
    }

    function onShow() {
        log(DEBUG, "GlanceView onShow");
    }

    function onHide() {
        log(DEBUG, "GlanceView onHide");
    }

    function onUpdate(dc) {
        log(DEBUG, "loading");
    }
}
