import LazyLoad from "vanilla-lazyload";

(function() {
	"use strict";
    const lazyload = new LazyLoad({
        callback_loaded: (el) => {
            const preloader = el.previousElementSibling;
            if( preloader && preloader.classList.contains( 'lazyload-preload' ) ) {
                preloader.parentNode.removeChild( preloader );
            }
        }
    });
}());