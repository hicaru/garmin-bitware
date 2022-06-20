//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Math;
using Toybox.Cryptography;

using BytesModule;
using CryptoModule;


class Bip39View extends WatchUi.View {
    private const _steps = 20;
    private const _max_iteractions = 824;
    private var _type = POS;
    var screen_shape;

    // state
    private var _salt as ByteArray;
    private var _password as ByteArray;
    private var _DK as ByteArray;
    private var _block1 as ByteArray;
    private var _T as ByteArray;
    private var _U as ByteArray;
    private var _hLen = 64;
    private var _keylen = 512;
    private var _iterations = 2048;
    private var _length = Math.ceil(self._keylen / self._hLen);

    private var _destPos = 0;
    private var _next_index = 1;
    private var _iterations_index = 1;
    private var _progress_counter = 1;
    // state

    enum {
        NONE,
        POS,
        BLOCK
    }

    function initialize() {
        View.initialize();
        screen_shape = System.getDeviceSettings().screenShape;

        var mnemonic = "album shy marriage excite wrist multiply want remind tower gun private soup";

        self._DK = new [self._keylen]b;
        self._salt = MNEMONIC_SALT;
        self._password = BytesModule.strToBytes(mnemonic);
        self._block1 = new [self._salt.size() + 4]b;
        self._block1 = BytesModule.bufferCopy(self._salt, self._block1, 0, 0, self._salt.size());

        // log(DEBUG, CryptoModule.hmac512(self._password, self._block1));
    }

    function onShow() {
        log(DEBUG, "Show Bip39View");
    }

    function onUpdate(dc) {
        switch(self._type) {
            case NONE:
                log(DEBUG, "NONE");
                break;
            case POS:
                self._nextDestPost();
                break;
            case BLOCK:
                self._mixBytes();
                break;
            default:
                break;
        }

        dc.clear();

        drawProgress(
            dc,
            (self._progress_counter * 100) / self._max_iteractions + 1,
            100,
            Graphics.COLOR_BLUE
        );

        if (self._progress_counter == 1) {
            dc.drawText(
                dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM,
                "Loading...",
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            );
        }
        self._progress_counter++;
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

    private function _mixBytes() {
        var counter = 0;

        for (var j = 1; self._iterations_index < self._iterations; self._iterations_index++) {
            self._U = CryptoModule.hmac(self._password, self._U);

            counter++;

            self._T = BytesModule.xorArray(self._U, self._T, self._hLen);

            if (counter >= self._steps) {
                self._iterations_index++;
                return WatchUi.requestUpdate();
            }
        }

        if (self._iterations_index == self._iterations) {
            self._DK = BytesModule.bufferCopy(self._T, self._DK, self._destPos, 0, self._T.size());
            self._destPos += self._hLen;
            self._next_index++;
            self._iterations_index = 1; // reset index
            self._type = POS;
        }

        return WatchUi.requestUpdate();
    }

    private function _nextDestPost() {
        if (self._next_index <= self._length) {
            self._block1 = BytesModule.writeUint32BE(self._block1, self._next_index, self._salt.size());
            self._T = CryptoModule.hmac(self._password, self._block1);
            self._U = self._T;
            self._type = BLOCK;

            self._mixBytes();
        } else {
            // STOP loop.
            self._type = NONE;
            self._U = new [0];
            self._T = new [0];
            self._block1 = new [0];
            log(DEBUG, self._DK);
        }
    }
}
