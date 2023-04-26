/** Global var sessionId, planId, stripe_account */

import { stripeAccount, publicKey, selectors, ajaxURL } from "./config";
import { loadStripe } from '@stripe/stripe-js';
import { style } from './config';
import '../../scss/styles.scss';

class StripeEntrypoint {

	stripe = null;
	cardElement = null;
	emailElement = null;
	btnSubmit = null;
	trial = false;

	constructor() {
		this.init();
	}

	async init() {
		this.stripe = await loadStripe( publicKey, { stripeAccount, apiVersion: '2020-03-02' } );

		const checkoutBtn = document.getElementById( selectors.checkoutBtn );
		if( checkoutBtn ) {
			this.stripe.redirectToCheckout({ sessionId }).then( result => {
				console.log(result);
			});
			return;
		}

		const elements = this.stripe.elements();
		this.cardElement = elements.create( "card", { style } );
		this.cardElement.mount( `#${selectors.cardElement}` );

		this.emailElement = document.getElementById( selectors.emailField );
		this.btnSubmit = document.getElementById( selectors.subscriptionBtn );

		this.bindAction();
	}

	bindAction() {
		/** Card Element */
		this.cardElement.addEventListener( 'change', (event) => {
			const displayError = document.getElementById( 'card-errors' );

			if( event.error ) {
				displayError.textContent = event.error.message;
			} else {
				displayError.textContent = '';
			}
		} );

		/** Email Element */
		this.emailElement.addEventListener( 'change', (e) => {
			e.preventDefault();
			if( ! /(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@[*[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+]*/.test( e.currentTarget.value ) ) {
				e.currentTarget.classList.add('error');
			} else {
				e.currentTarget.classList.remove('error');
			}
		} );

		this.btnSubmit.addEventListener( 'click', (e) => {
			e.preventDefault();

			/** TODO: Add preloader while a submitting form */
			// changeLoadingState(true);
			
			/** Initiate payment */ 
			this.createPaymentMethodAndCustomer();
		});
	}

	createPaymentMethodAndCustomer() {
		const cardholderEmail = document.querySelector('#email').value;
		this
			.stripe
			.createPaymentMethod( 'card', this.cardElement, {
				billing_details: {
					email: cardholderEmail
				}
			})
			.then( result => {
				if( result.error ) {
					this.showCardError( result.error );
				} else {
					this.createCustomer( result.paymentMethod.id, cardholderEmail );
				}
			});
	}

	async createCustomer(paymentMethod, cardholderEmail) {
		this.trial = document.getElementById('trial') && document.getElementById('trial').checked || false;

		return fetch( ajaxURL, {
			method: 'post',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({
				email: cardholderEmail,
				payment_method: paymentMethod,
				planId,
				stripe_account,
				trial: this.trial
			})
		})
		.then(response => {
			return response.json();
		})
		.then(data => {
			if( ! this.trial ) {
				this.handleSubscription(data);
			} else {
				this.stripe.confirmCardPayment(data.client_secret).then(result => {
					if (result.error) {
						// Display error message in your UI.
						// The card was declined (i.e. insufficient funds, card has expired, etc)
						// changeLoadingState(false);
						this.showCardError(result.error);
					} else {
						this.createTrialSubscription( cardholderEmail, data.payment_intent );
					}
				});
			}
		});
	}

	showCardError( error ) {
		// changeLoadingState(false);

		// The card was declined (i.e. insufficient funds, card has expired, etc)
		const errorMsg = document.querySelector('.sr-field-error');
		errorMsg.textContent = error.message;

		setTimeout(() => {
			errorMsg.textContent = '';
		}, 8000);
	}

	handleSubscription (subscription) {
		const { latest_invoice } = subscription;
		const { payment_intent } = latest_invoice;
		
		if (payment_intent) {
			const { client_secret, status } = payment_intent;
	  
			if (status === 'requires_action') {
				this.stripe.confirmCardPayment(client_secret).then(result => {
					if (result.error) {
						// Display error message in your UI.
						// The card was declined (i.e. insufficient funds, card has expired, etc)
						// changeLoadingState(false);
						this.showCardError(result.error);
					}

					this.confirmSubscription(subscription.id);
				});
			} else {
				// No additional information was needed
				// Show a success message to your customer
				this.confirmSubscription(subscription.id);
			}
		} else {
			this.confirmSubscription(subscription.id);
		}
	}

	createTrialSubscription( email, paymentIntent ) {
		return fetch( ajaxURL, {
			method: 'post',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({
				email,
				planId,
				stripe_account,
				paymentIntent,
				isTrial: true
			})
		})
		.then(response => {
			return response.json();
		})
		.then( subscription => this.handleSubscription(subscription) );
	}

	orderComplete = function(subscription) {
		// changeLoadingState(false);
		
		document.querySelectorAll('.payment-view').forEach(function(view) {
			view.classList.add('hidden');
		});

		document.querySelectorAll('.completed-view').forEach(function(view) {
			view.classList.remove('hidden');
		});

		document.querySelector('.order-status').textContent = subscription.status;
	}

	confirmSubscription(subscriptionId) {
		return fetch( ajaxURL, {
			method: 'post',
			headers: {
				'Content-type': 'application/json'
			},
			body: JSON.stringify({
				subscriptionId: subscriptionId,
				subscriptionData: true,
				stripe_account
			})
		})
		.then( response => {
			return response.json();
		})
		.then( subscription => {
			this.orderComplete(subscription);
		});
	}
}

/** Init Stripe */
new StripeEntrypoint();