using Toybox.Lang;
using Toybox.StringUtil;
using Toybox.System;
using Toybox.Test;


module BytesModule {
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
    function writeUint32BE(source, value, offset) {
        offset = offset >> 0;

        source[offset] = (value >> 24);
        source[offset + 1] = (value >> 16);
        source[offset + 2] = (value >> 8);
        source[offset + 3] = (value & 0xff);

        return source;
    }

    (:glance)
    function writeInt32BE(source, value, offset) {
        offset = offset >> 0;

        if (value < 0) {
            value = 0xffffffffl + value + 1;
        }

        source[offset] = getInt64Bytes(value, 24).toNumber();
        source[offset + 1] = getInt64Bytes(value, 16).toNumber();
        source[offset + 2] = getInt64Bytes(value, 8).toNumber();
        source[offset + 3] = (value & 0xff).toNumber();

        return source;
    }

    (:glance)
    function getInt64Bytes(value, n) {
        value = zeroFillRightShift(value, n);
        value = value.toNumber() << 24;
        return zeroFillRightShift(value, 24);
    }

    (:glance)
    function writeInt64BE(source as ByteArray, h, l, offset) {
        var length = source.size();
        var bigArray64 = new [length];

        for (var i = 0; i < length; i++) {
            bigArray64[i] = source[i].toNumber();
        }

        var newSource = writeInt32BE(bigArray64, h, offset);
        return writeInt32BE(newSource, l, offset + 4);
    }

    (:glance)
    function readInt32BE(source as ByteArray, offset) {
        var length = source.size();
        offset = offset >> 0;

        if ((offset % 1) != 0 || offset < 0) {
            throw new RangeErrorException("offset is not uint");
        }
        if (offset + 4 > length) {
            throw new RangeErrorException("Trying to access beyond buffer length");
        }

        return (source[offset] << 24) |
            (source[offset + 1] << 16) |
            (source[offset + 2] << 8) |
            (source[offset + 3]);
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
    function zeroFillRightShift(val, n) {
        if (val >= 0) {
            return (val >> n);
        } else {
            return ((val + 0x100000000l) >> n);
        }
    }

    (:glance)
    function fillArray(arr, value, start, end) {
        var newArr = arr;

        for (var index = start; index < end; index++) {
            newArr[index] = value;
        }

        return newArr;
    }

    (:glance)
    function strToBytes(value as String) {
        var toArray = {
            :fromRepresentation => StringUtil.REPRESENTATION_STRING_PLAIN_TEXT,
            :toRepresentation => StringUtil.REPRESENTATION_BYTE_ARRAY,
            :encoding => StringUtil.CHAR_ENCODING_UTF8
        };
        return StringUtil.convertEncodedString(value, toArray);
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
