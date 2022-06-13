//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Application;
using Toybox.Cryptography;
using BytesModule;


class BitWareApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
        var entropy = Cryptography.randomBytes(64l);
        System.print(BytesModule.base16ToBytes("80000000000000000000000000000080"));

        // var sha1 = new Cryptography.Hash({
        //     :algorithm => Cryptography.HASH_SHA256
        // });

        // sha1.update(entropy);
        // var res = sha1.digest();
        // System.print(res);
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new MainView(), new MainViewDelegate() ];
    }
}