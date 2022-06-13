using Toybox.Lang;
using Toybox.StringUtil;
using Toybox.System;


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
    class UnexpectedSymbolException extends Lang.Exception {
        var symbol_;

        function initialize(symbol) {
            Exception.initialize();
            symbol_ = symbol;
        }

        function getErrorMessage() {
            return "Unexpected symbol: " + symbol_;
        }
    }
}
