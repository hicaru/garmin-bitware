using Toybox.Lang;
using Toybox.StringUtil;
using Toybox.System;
using Toybox.Test;


module BytesModule {
    (:glance)
    function hex(char) {
        switch(char.toUpper()) {
        case '0': return 0x0;
        case '1': return 0x1;
        case '2': return 0x2;
        case '3': return 0x3;
        case '4': return 0x4;
        case '5': return 0x5;
        case '6': return 0x6;
        case '7': return 0x7;
        case '8': return 0x8;
        case '9': return 0x9;
        case 'A': return 0xA;
        case 'B': return 0xB;
        case 'C': return 0xC;
        case 'D': return 0xD;
        case 'E': return 0xE;
        case 'F': return 0xF;
        default:
            throw new UnexpectedSymbolException(char);
        }
    }

    (:glance)
    function convertToBinary(number) {
        var num = number;
        var binary = (num % 2).toString();

        for (; num > 1; ) {
            num = num / 2;
            binary = (num % 2) + (binary);
        }

        return binary;
    }

    (:glance)
    function lpad(str as String, padString as String, length as Number) {
        while (str.length() < length) {
            str = padString + str;
        }
        return str;
    }

    (:glance)
    function bytesToBinary(bytes as ByteArray) {
        var binary = "";
        for (var i = 0; i < bytes.size(); i++) {
            binary += lpad(convertToBinary(bytes[i]), "0", 8);
        }

        return binary;
    }

    (:glance)
    function bytesToBase16(bytes) {
        var str = "";
        for (var i = 0; i < bytes.size(); i++) {
            if (bytes[i] == null) {
                throw new UnexpectedSymbolException("null");
            }
            if (bytes[i] < 0x10) {
                str += "0";
            }
            str += bytes[i].format("%X");
        }
        return str;
    }

    (:glance)
    function base16ToBytes(string) {
        // pad zero
        var l = string.length();
        if (l % 2 == 1) {
            string = "0" + string;
            l = l + 1;
        }
        var cs = string.toCharArray();
        var bs = new [l/2]b;
        for (var i = 0; i < cs.size(); i += 2) {
            bs[i/2] = hex(cs[i]) << 4 | hex(cs[i+1]);
        }
        return bs;
    }

    (:glance)
    function bufferCopy(source, target, targetStart, sourceStart, sourceEnd) {
        // Copy 0 bytes; we're done
        if (sourceEnd == sourceStart) {
            return target;
        }

        if (target.size() == 0 || source.size() == 0) {
            return target;
        }

        // Fatal error conditions
        if (targetStart < 0) {
            throw new RangeErrorException("Index out of range");
        }
        if (sourceStart < 0 || sourceStart >= source.size()) {
            throw new RangeErrorException("Index out of range");
        }
        if (sourceEnd < 0) {
            throw new RangeErrorException("sourceEnd out of bounds");
        }

          // Are we oob?
        if (sourceEnd > source.size()) {
            sourceEnd = source.size();
        }

        if (target.size() - targetStart < sourceEnd - sourceStart) {
            sourceEnd = target.size() - targetStart + sourceStart;
        }

        var newTarget = target;

        for (var index = sourceStart; index < sourceEnd; index++) {
            newTarget[targetStart + index] = source[index];
        }

        return newTarget;
    }

    (:glance)
    function writeUint32BE(source as ByteArray, value, offset) {
        offset = offset >> 0;

        source[offset] = (value >> 24);
        source[offset + 1] = (value >> 16);
        source[offset + 2] = (value >> 8);
        source[offset + 3] = (value & 0xff);

        return source;
    }

    (:glance)
    function xorArray(source as ByteArray, target as ByteArray, length) {
        var newTarget = target;

        for (var k = 0; k < length; k++) {
            newTarget[k] ^= source[k];
        }

        return newTarget;
    }

    (:glance)
    class UnexpectedSymbolException extends Lang.Exception {
        var _symbol;

        function initialize(symbol) {
            Exception.initialize();
            self._symbol = symbol;
        }

        function getErrorMessage() {
            return "Unexpected symbol: " + self._symbol;
        }
    }

    (:glance)
    class RangeErrorException extends Lang.Exception {
        var _msg;

        function initialize(msg) {
            Exception.initialize();
            self._msg = msg;
        }

        function getErrorMessage() {
            return self._msg;
        }
    }
}
