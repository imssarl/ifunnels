/* globals baseUrl: false */
/*
    CSS
*/
require('../css/load-main.css');

/*
    scripts (as conventional globals)
*/
require("script-loader!./vendor/jquery.min.js");
require("script-loader!./vendor/jquery-ui.min.js");
require("script-loader!./vendor/flat-ui-pro.min.js");

(function () {
    "use strict";

    require('./modules/shared/ui');
    require('./modules/users/users');
    require('./modules/shared/account');
    require('./modules/shared/sitesettings');

}());


/* this attempts to load custom JS code to include in the users page */
try {
	require('./custom/users.js');
} catch (e) {
	
}