//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Application;
using Toybox.Cryptography;
using Toybox.WatchUi;
using Toybox.StringUtil;

using BytesModule;
using CryptoModule;
using BIP39Module;
using HashModule;

(:glance)
class BitWareApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
        log(DEBUG, "App onStart");
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
        log(DEBUG, "App onStop");
    }

    // Return the initial view of your application here
    function getInitialView() {
        log(DEBUG, "App InitialView");
        return [
            new MainView(),
            new MainViewDelegate()
        ];
    }
}
