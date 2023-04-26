import axios from 'axios';
import Store from '../store';

export default class Payment {

	static getUrl() {
		return config.request_url || 'https://app.ifunnels.com/services/deliver-request.php';
	}

	/** Getting of customer data from stripe */
	static async getCustomerData(cid) {
		const response = await axios({
			method: 'post',
			url: Payment.getUrl(),
			data: {
				action: 'get_customer_data',
				uid: window.uid,
				data: {
					cid,
					stripe_account: config.stripe.stripeAccount
				}
			},
			headers: { 'Content-Type': 'multipart/form-data' }
		});

		return response;
	}

	/**
	 * Getting discount list
	 * 
	 * @param {integer} membershipid 
	 * @param {integer} cid 
	 * @returns {Promise}
	 */
	static async getDiscountList(membershipid, cid) {
		const response = await axios({
			method: 'post',
			url: Payment.getUrl(),
			data: {
				action: 'getdiscountlist',
				uid: window.uid,
				data: {
					cid,
					membershipid
				}
			},
			headers: { 'Content-Type': 'multipart/form-data' }
		});

		return response;
	}

	/** Mounting card field
	 * 
	 * @param {string} - selector a dom element 
	 * @param {object} - stripe object
	 * 
	 * @return {object} 
	 */
	static initCardField(selector, stripe) {
		const elements = stripe.elements();
		const cardElement = elements.create("card");
		cardElement.mount(selector);
		return cardElement;
	}

	/** Add a markup with saved card data of current user
	 * 
	 * @param {Node} - DOM element 
	 * @param {object} - Object of card data
	 * 
	 * @void 
	 */
	static outputCardData(element, { card }) {
		const { brand, exp_month, exp_year, last4 } = card;

		const wrapper = document.createElement('div');
		wrapper.classList.add('change-billing');
		wrapper.innerHTML = `<a href="#">Change Billing Preferences</a>`;
		element.appendChild(wrapper);

		const cardElement = document.createElement('div');
		cardElement.classList.add('card');
		cardElement.innerHTML = `<span class="card--brand ${brand}"></span><span class="card--number">&bull;&bull;&bull;&bull; &bull;&bull;&bull;&bull; &bull;&bull;&bull;&bull; ${last4}</span><span class="card--validity">${exp_month < 10 ? '0' + exp_month : exp_month} / ${exp_year.toString().substr(-2)}</span>`;
		element.appendChild(cardElement);
	}

	/** Request a Payment
	 * @param instance - Instance of Step class
	 * @param obj - Object with data {stripe, cardElement, cdata}
	 * 
	 * @return {Promise OR Object}
	 */
	static async requestPayment(instance, { stripe, cardElement, cdata, discount, order_bump }) {
		let paymentMethod = null;
		const { id, invoice_settings } = cdata;
		const _this = new Payment();

		if (cardElement) {
			const result = await _this.createPaymentMethod({ stripe, cardElement });

			if (result === false) {
				instance.toggleLoader(false);
				return Promise.resolve({ error: [{ message: 'Input your card data' }] });
			}

			if (result.hasOwnProperty('paymentMethod')) {
				const { data } = await _this.addPaymentMethod({ customer_id: id, paymentMethod: result.paymentMethod.id });

				if (data.hasOwnProperty('error')) {
					instance.toggleLoader(false);
					return Promise.resolve(data);
				}

				paymentMethod = result.paymentMethod.id;
			}
		} else {
			if (invoice_settings.default_payment_method) {
				paymentMethod = invoice_settings.default_payment_method;
			}
		}

		if (!paymentMethod) {
			return Promise.resolve({ error: [{ message: 'Default payment method not set' }] });
		}

		if (config.primary_membership.trial === true && config.primary_membership.trial_amount == 0 && order_bump.length == 0) {
			return { data: { trial_free: true } };
		}

		const { data } = await _this.createPaymentOrder({ membership: config.primary_membership.id, cdata, paymentMethod, discount, order_bump });
		const { client_secret, status } = data;
		return _this.confirmCardPayment({ stripe, client_secret, status });
	}

	/** Create Payment Method on a stripe
	 * 
	 * @param {object} - stripe object
	 * @param {object} - DOM element
	 * 
	 * @return {object} - Return a new Payment Method or errors
	 */
	createPaymentMethod({ stripe, cardElement }) {
		const { _complete } = cardElement;

		if (!_complete) {
			return false;
		}

		const result = stripe
			.createPaymentMethod({
				type: 'card',
				card: cardElement
			});
		return result;
	}

	/** 
	 * Add Payment Method for user 
	 * 
	 * @param {string} - Customer Id 
	 * @param {object} - Unique id payment method on stripe
	 * 
	 * @return {Promise}
	 */
	addPaymentMethod({ customer_id, paymentMethod }) {
		const response = axios({
			method: 'post',
			url: Payment.getUrl(),
			data: {
				action: 'add_payment_method',
				uid: window.uid,
				data: {
					cid: customer_id,
					paymentMethod,
					stripe_account: config.stripe.stripeAccount
				}
			},
			headers: { 'Content-Type': 'multipart/form-data' }
		});

		return response;
	}

	/** Create a payment order on stripe.com
	 * 
	 * @param {object} - Membership ID, Customer Data, Payment Method
	 * 
	 * @return {Promise}
	 */
	createPaymentOrder({ membership, cdata, paymentMethod, discount, order_bump }) {
		/** If there was a problem with the user's payment card, 
		 *  replaced the new payment method for the payment intention 
		 */
		if (Store.buffer.hasOwnProperty('payment')) {
			const response = axios({
				method: 'post',
				url: Payment.getUrl(),
				data: {
					action: 'update_payment_method',
					uid: window.uid,
					data: {
						paymentMethod,
						payment_intent: Store.buffer.payment.payment_intent.id,
						membership,
						stripe_account: config.stripe.stripeAccount
					}
				},
				headers: { 'Content-Type': 'multipart/form-data' }
			});

			return response;
		}

		const response = axios({
			method: 'post',
			url: Payment.getUrl(),
			data: {
				action: 'payment',
				uid: window.uid,
				data: {
					membership,
					cid: cdata.id,
					paymentMethod,
					trial: config.primary_membership.trial,
					discount,
					order_bump,
					stripe_account: config.stripe.stripeAccount
				}
			},
			headers: { 'Content-Type': 'multipart/form-data' }
		});

		return response;
	}

	/** Return a status trial 
	 * 
	 * @return {boolean}
	*/
	selectedTrial() {
		const container = document.querySelector('.order-summary');
		if (container) {
			const trial = container.querySelector('#trial');

			if (trial) {
				Store.buffer['trial'] = trial.checked;
				return trial.checked;
			}
		}

		Store.buffer['trial'] = false;

		return false;
	}

	/** Confirm a card payment
	 * 
	 * @param {object} - Stripe, Client Secret, Status
	 * 
	 * @return {Promise}
	 */
	async confirmCardPayment({ stripe, client_secret, status }) {
		const result = await stripe.confirmCardPayment(client_secret);

		if (result.hasOwnProperty('error')) {
			const { message, payment_intent } = result.error;
			return Promise.resolve({ error: [{ message }], data: { payment_intent } });
		} else {
			return Promise.resolve({ data: { payment_intent: result.paymentIntent } });
		}
	}
}