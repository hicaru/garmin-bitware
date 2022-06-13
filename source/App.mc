//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Application;
using Toybox.Cryptography;
using BytesModule;
using CryptoModule;


class BitWareApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
        // var secret = BytesModule.base16ToBytes("80000000000000000000000000000080");
        // var data = BytesModule.base16ToBytes("30dfe64740ed459ea115b517bd737bbadf21b838");
        // var hmac = CryptoModule.hmacSHA2(secret, data);

        // System.print(BytesModule.bytesToBase16(hmac));

        var salt = BytesModule.base16ToBytes("30dfe64740ed459ea115b517bd737bbadf21b838");
        var test = CryptoModule.pbkdf2("test", salt, 10, 256);

        System.print(BytesModule.bytesToBase16(test));
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new MainView(), new MainViewDelegate() ];
    }
}