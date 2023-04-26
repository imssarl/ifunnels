(function () {
    "use strict";

    let storage = {};

    /** Set data in the storage */
    exports.setData = (key, value) => {
        storage[key] = value;
    };

    /** Get data at key in from storage */
    exports.getData = (key) => {
        if( storage.hasOwnProperty(key) ) {
            return storage[key];
        }
        
        return null;
    };

    /** Empty storage */
    exports.empty = () => {
        storage = {};
    };
})();