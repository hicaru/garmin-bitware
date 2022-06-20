//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Application;
using Toybox.Cryptography;
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

         var toArray = {
            :fromRepresentation => StringUtil.REPRESENTATION_STRING_PLAIN_TEXT,
            :toRepresentation => StringUtil.REPRESENTATION_BYTE_ARRAY,
            :encoding => StringUtil.CHAR_ENCODING_UTF8
        };
        var seed = "album shy marriage excite wrist multiply want remind tower gun private soup";
        var bytes = StringUtil.convertEncodedString(seed, toArray);

        log(DEBUG, bytes);
        
        // var hash = new HashModule.Sha512();
        // var secret = [7,218,61,69,176,241,57,0,131,9,122,149,168,145,95,194,246,176,108,111]b;

        // hash.update(secret);
        // var bytes = hash.digest();

        // // var bytes = BytesModule.zeroFillRightShift(-9, 2);

        // log(DEBUG, BytesModule.bytesToBase16(bytes));


        // var entropy = Cryptography.randomBytes(32l);
        // var words = BIP39Module.entropyToMnemonic(entropy);

        // log(DEBUG, words);

        // log(DEBUG, checksumBits);

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
