//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Application;
using Toybox.Cryptography;
using BytesModule;
using CryptoModule;


(:glance)
class BitWareApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
        log(DEBUG, "App onStart");
        // var secret = BytesModule.base16ToBytes("80000000000000000000000000000080");
        // var data = BytesModule.base16ToBytes("30dfe64740ed459ea115b517bd737bbadf21b838");
        // var hmac = CryptoModule.hmacSHA2(secret, data);

        // System.print(BytesModule.bytesToBase16(hmac));

        // var salt = BytesModule.base16ToBytes("30dfe64740ed459ea115b517bd737bbadf21b838");
        // var key = BytesModule.base16ToBytes("07da3d45b0f1390083097a95a8915fc2f6b06c6f");
        // var test = CryptoModule.pbkdf2(key, salt, 30, 256);

        // log(DEBUG, BytesModule.bytesToBase16(test));
        // log(DEBUG, test);

        // var salt = BytesModule.base16ToBytes("30dfe64740ed459ea115b517bd737bbadf21b838");
        // var key = BytesModule.base16ToBytes("07da3d45b0f1390083097a95a8915fc2f6b06c6f");
        // var test = CryptoModule.pbkdf2(key, salt, 10, 256);

        // log(DEBUG, key.toString());
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
