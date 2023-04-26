(function(){
	"use strict";
	document.addEventListener("DOMContentLoaded", () => {
        document.querySelectorAll( 'link' ).forEach( ( link ) => {
            link.setAttribute('rel', 'stylesheet');
        } );
    });
}());