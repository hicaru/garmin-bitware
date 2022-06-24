using Toybox.Test;


module ArrayModule {
    (:glance)
    function chunk(arr, chunkSize as Number) {
        Test.assert(chunkSize > 0);
        var R = [];
        var len = arr.size();

        for (var i = 0; i < len; i += chunkSize) {
            R.add(arr.slice(i, i + chunkSize));
        }

        return R;
    }
}
