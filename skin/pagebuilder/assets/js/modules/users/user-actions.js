/** Global var isTemplate */
(function () {
    "use strict";

    let userActive = true;
    const NO_ACTIVE_DELAY = 60;
    const CHECK_DELAY = 1000;
    let currentNoActive = 0;
    const notify = require('../shared/notify');
    const notifyConfig = Object.assign( notify.config, {
        globalPosition: 'top center',
        position: 'top center',
        className: 'warning',
        autoHide: true
    } );

    let intervalHandler = null;

    const runWatcher = () => {
        if( isTemplate ) return;
        intervalHandler = setInterval( () => {
            if( userActive ) {
                currentNoActive++;
            }

            if( currentNoActive >= NO_ACTIVE_DELAY ) {
                userActive = false;
                clearInterval( intervalHandler );
                intervalHandler = null;

                if( typeof ( exports.callbackAfterUserNotActive ) == 'function' && exports.pendingChanges && isSigned ) {
                    $.notify(beforeSaveMessage, notifyConfig);
                    setTimeout(() => exports.callbackAfterUserNotActive(), 5000);
                }
            }
        }, CHECK_DELAY );
    }

    const setActive = () => {
        currentNoActive = 0;
        userActive = true;

        if( intervalHandler === null ) {
            runWatcher();
        }
    }

    /** Run watcher for check active user  */
    runWatcher();

    /** Sets event listeners for root nodes (Menu, Sidebar, etc.) */
    exports.addUserActionsToRoot = () => {
        document.addEventListener('keydown', (e) => {
            setActive();
        });

        document.addEventListener('mousedown', (e) => {
            setActive();
        });

        document.addEventListener('mousemove', (e) => {
            setActive();
        });
    };

    /** Sets event listeners for nodes iframe */
    exports.addUserActionsToIframe = ( iframe ) => {
        iframe.addEventListener('keydown', (e) => {
            setActive();
        });

        iframe.addEventListener('mousedown', (e) => {
            setActive();
        });

        iframe.addEventListener('mousemove', (e) => {
            setActive();
        });
    };

    /** Return user active status */
    exports.getStatus = () => userActive;

    exports.callbackAfterUserNotActive = null;
    exports.pendingChanges = false;
})();