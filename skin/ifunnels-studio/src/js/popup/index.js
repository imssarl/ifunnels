import '../../scss/popup.scss';

export default class Popup {
	default_options = {
		defaultClassName: 'ch_popup',
		// class name for markup modal popup, default: ch_popup
		className: '',
		// show modal popup after load page
		defaultShow: false,
		// close modal popup after click key esc
		closeEsc: true,
		// close modal popup after click the overlay
		closeOverlay: true,
		// show or hide close button
		closeButton: true,
		// code lists for event listening of keyboard 
		keyCodes: [27],
		// markup for close button
		closeButtonMarkup: '<a href="#" data-close></a>',
		// callback method before open modal popup
		onBeforeOpen: () => {
			console.log('Popup onBeforeOpen()');
		},
		// callback method before close modal popup
		onBeforeClose: () => {
			console.log('Popup onBeforeClose()');
		},
		// callback method after open modal popup
		onAfterOpen: () => {
			console.log('Popup onAfterOpen()');
		},
		// callback method after close modal popup
		onAfterClose: () => {
			console.log('Popup onAfterClose()');
		}
	};

	popup = null;

	constructor(options) {
		this.default_options = Object.assign(this.default_options, options);
		this.initMarkup();
	}

	/** Create new instance and return
	 * @param {object} - Object of settings modal popup
	 * @return {object} - instance of class Popup
	 */
	static init(options = {}) {
		const _this = new Popup(options);
		return _this;
	}

	/** Create markup for modal and append to the body  */
	initMarkup() {
		const { defaultClassName, className, defaultShow, closeButton, closeButtonMarkup } = this.default_options;
		this.popup = document.createElement('div');
		this.popup.classList.add(`${defaultClassName}--overlay`, className);
		this.popup.setAttribute('data-show', defaultShow);

		this.popup.innerHTML = `
			<div class="${defaultClassName}--loader" data-loader="false"><div></div><div></div><div></div><div></div></div>
			<div class="${defaultClassName}--container">
				${closeButton ? closeButtonMarkup : ''}
			</div>
		`;

		document.body.appendChild(this.popup);
		this.bindActions();
	}

	/** Return object of class Popup
	 * @return {object}
	 */
	getElementPopup() {
		return this.popup;
	}

	/** Bind actions */
	bindActions() {
		/** Bind actions for a press key on page */
		const { closeEsc, closeOverlay, keyCodes, closeButton, defaultClassName } = this.default_options;

		/** Close modal popup after click key esc or etc. */
		if (closeEsc) {
			document.addEventListener('keyup', e => {
				if (keyCodes.includes(e.keyCode)) {
					this.closePopup();
				}
			});
		}

		/** Close modal popup after click the overlay */
		if (closeOverlay) {
			this.getElementPopup().addEventListener('click', e => {
				if (e.target.classList.contains(`${defaultClassName}--overlay`)) {
					e.preventDefault();
					this.closePopup();
				}
			});
		}

		/** Close modal popup after click close button */
		if (closeButton) {
			const btnClose = this
				.getElementPopup()
				.querySelector('[data-close]');

			if (btnClose) {
				btnClose.addEventListener('click', e => {
					e.preventDefault();
					this.closePopup();
				});
			}
		}
	}

	/** Show popup */
	async showPopup() {
		const { onBeforeOpen, onAfterOpen, defaultClassName } = this.default_options;
		document.body.classList.add(`${defaultClassName}--overflow`);

		this.toggleLoader(true);
		await onBeforeOpen(this);
		this.popup.setAttribute('data-show', true);
		await onAfterOpen(this);
		this.toggleLoader(false);
	}

	/** Close popup */
	async closePopup() {
		const { onBeforeClose, onAfterClose, defaultClassName } = this.default_options;
		document.body.classList.remove(`${defaultClassName}--overflow`);

		await onBeforeClose(this);
		this.popup.setAttribute('data-show', false);
		await onAfterClose(this);
	}

	/** Show or hide preloader */
	toggleLoader(show) {
		const { defaultClassName } = this.default_options;
		const loader = this.getElementPopup().querySelector(`.${defaultClassName}--loader`)

		if (show) {
			loader.style.display = 'flex';
		} else {
			loader.style.display = 'none';
		}

		loader.setAttribute('data-loader', show);
	}

	setContent(html) {
		const { defaultClassName } = this.default_options;
		const container = this.popup.querySelector(`.${defaultClassName}--container`);

		if (container) {
			const lastChild = container.lastChild;
			if (lastChild && lastChild.nodeType != Node.TEXT_NODE && !lastChild.hasAttribute('data-close')) {
				container.removeChild(lastChild);
			}

			container.insertAdjacentHTML('beforeend', html);
		}
	}
}