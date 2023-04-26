(function(){
	"use strict";
	document.addEventListener("DOMContentLoaded", () => {
        /** Get all elements with have attr [data-effects] */
        document.querySelectorAll( '[data-effects]' ).forEach( ( element ) => {
            const effect = element.getAttribute( 'data-effects' );

            if( effect !== 'none' ) {
                /** Get delay for start animate */
                const effectDelay = element.getAttribute( 'data-delayef' ) || 1;

                /** Start animation after await selected delay */
                setTimeout( () => {
                        element.classList.remove( 'hide' );
                        element.classList.add( 'animated', effect );
                    },  
                    effectDelay * 1000 
                );
            }
        } );
    });
}());