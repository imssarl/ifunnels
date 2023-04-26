export default class Sale {
	static init() {
		const _this = new Sale();

		console.log( iziModal );

		if( document.querySelector('.modal') ) {
			MicroModal.init();

			console.log( MicroModal );

			document.querySelectorAll( 'a[data-modal]' ).forEach( a => {
				a.addEventListener( e => {
					e.preventDefault();

					MicroModal.show( 'modal-1' );
				} );
			} );
		}
	}
}