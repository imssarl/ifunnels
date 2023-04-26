/** global var [config] */

import axios from 'axios';
import Helper from '../helper';
import { loadStripe } from '@stripe/stripe-js';
import Payment from './payment';
import Store from '../store';
import { setTokenOnLinks, checkToken } from '../token';
import Swal from 'sweetalert2';
import Discounts from '../includes/discounts';

export default class Register {
	modal = null;
	stepsContainer = null;
	steps = {};
	static store = {};
	alerts = null;
	request_url = null;
	active_steps = [];
	stripe = null;
	btnLogin = null;
	cardElement = null;
	customerList = null;

	constructor() {
		this.modal = document.querySelector('.register');
		this.stepsContainer = this.modal.querySelector('.steps');
		this.steps = {
			acount: {
				/** 
				 * f - function
				 * el - step element in navbar
				 * c - content element for step 
				 */
				f: () => this.acountStep(),
				el: this.stepsContainer.querySelector('.step[data-step="acount"]'),
				c: this.modal.querySelector('.step-content[data-step-content="acount"]'),
			},
			payment: {
				f: () => this.paymentStep(),
				el: this.stepsContainer.querySelector('.step[data-step="payment"]'),
				c: this.modal.querySelector('.step-content[data-step-content="payment"]')
			},
			complete: {
				f: () => this.completeStep(),
				el: this.stepsContainer.querySelector('.step[data-step="complete"]'),
				c: this.modal.querySelector('.step-content[data-step-content="complete"]')
			}
		};

		this.request_url = config.request_url || 'https://app.ifunnels.com/services/deliver-request.php';
	}

	static init() {
		const _this = new Register();
		_this.showModal();
	}

	showModal() {
		this.initSteps();
		this.modal.style.display = 'flex';
	}

	/** Init steps */
	initSteps() {
		const { free } = config.primary_membership;
		this.active_steps = [];

		if (!free) {
			this.active_steps.push('acount', 'payment', 'complete');
		} else {
			this.active_steps.push('acount', 'complete');
		}

		/** Show active steps */
		this.active_steps.forEach(step => {
			this.steps[step].el.setAttribute('data-active', true)
		});

		/** Run action for first step (acount) */
		this.steps.acount.f();
	}

	async acountStep() {
		const { token, forgot_url } = config;
		const form = this.steps.acount.c.querySelector('form');
		const require_shipping_el = form.querySelector('[data-require-shipping]');
		const btn_submit = form.querySelector('button');
		const forgot_link = form.querySelector('a[data-forgot]');
		this.alerts = form.querySelector('.alerts');

		if (forgot_link) {
			forgot_link.setAttribute("href", forgot_url);
		}

		/** Getting list of customers */
		this.customerList = await this.getCustomerList();

		/** Activate step in navigation menu */
		this.setActiveStep('acount');

		if (token) {
			const { data } = await checkToken({
				request_url: this.request_url,
				token,
				primary_membership: config.primary_membership.id
			});

			if (data.cid) {
				Store.buffer["account"] = { cid: data.cid };
				this.setCompleteStep("acount");
				const next_step = this.active_steps[1];

				/** Run action for next step */
				this.steps[next_step].f();

				return;
			}

			if (data.hasOwnProperty("error")) {
				this.outputErrors(data.error);
			}
		}

		if (!this.customerList) {
			return;
		}

		if (require_shipping_el) {
			const { allowed_contries } = config.primary_membership;
			const select = form.querySelector('select[name="country"]');

			require_shipping_el.setAttribute('data-require-shipping', config.primary_membership.require_shipping);

			if (config.primary_membership.require_shipping) {
				this.addAllowedCountries({ allowed_contries, select });
			}
		}

		form.addEventListener('submit', e => {
			e.preventDefault();

			const serialize = Helper.serializeArray(form);
			const { id, require_shipping } = config.primary_membership;
			const errors = [];

			/** Validating email field */
			if (Helper.validateValue(serialize.email, { name: 'email' }) !== true) {
				errors.push({ message: 'Input your email' });
			}

			/** Require Shipping */
			if (require_shipping) {
				/** Validating country field */
				if (Helper.validateValue(serialize.country, { name: 'not_empty' }) === false) {
					errors.push({ message: 'Input your country' });
				}

				/** Validating name field */
				if (Helper.validateValue(serialize.name, { name: 'not_empty' }) === false) {
					errors.push({ message: 'Input your name' });
				}

				/** Validating address_line_1 field */
				if (Helper.validateValue(serialize.address_line_1, { name: 'not_empty' }) === false) {
					errors.push({ message: 'Input your Address Line 1' });
				}

				/** Validating city field */
				if (Helper.validateValue(serialize.city, { name: 'not_empty' }) === false) {
					errors.push({ message: 'Input your city' });
				}

				/** Validating zip field */
				// TODO Убрана проверка валидации (сообщение в Slack 10.02.2021)
				// if (Helper.validateValue(serialize.zip, { name: 'digital' }) !== true) {
				// 	errors.push({ message: 'Input your zip' });
				// }
			}

			if (errors.length) {
				this.outputErrors(errors);
				return;
			}

			/** Rewardful */
			if (window.Rewardful) {
				serialize['referral'] = Rewardful.referral;
			}

			/** Disabled button */
			btn_submit.disabled = true;

			axios({
				method: 'post',
				url: this.request_url,
				data: {
					action: 'account',
					uid: window.uid,
					data: Object.assign(serialize, { primary_membership: id, require_shipping, memberships: config.memberships })
				},
				headers: { 'Content-Type': 'multipart/form-data' }
			})
				.then(response => {
					btn_submit.disabled = false;

					const { data } = response;

					if (data.hasOwnProperty('error')) {
						this.outputErrors(data.error);

						if (data.login) {
							this.steps.acount.c.querySelector('.register-block').setAttribute('hidden', true);
							this.steps.acount.c.querySelector('.login-block').removeAttribute('hidden');
							this.btnLogin = this.steps.acount.c.querySelector('#login');
							const password = this.steps.acount.c.querySelector('input[type="password"]');

							/** Try Login */
							this.btnLogin.addEventListener('click', e => {
								e.preventDefault();

								this.btnLogin.disabled = true;
								this.auth({ cid: data.data.cid, password: password.value });
							});
						}
					} else {
						Store.buffer['account'] = response.data;
						this.setCompleteStep('acount');
						const next_step = this.active_steps[1];

						/** Run action for next step */
						this.steps[next_step].f();
					}
				})
				.catch(e => console.log(e));
		});

		/** If customer list is not empty */
		if (this.customerList.length) {
			form
				.querySelector('input[name="email"]')
				.addEventListener('change', e => {
					const registerNode = this.steps.acount.c.querySelector('.register-block');

					if (!registerNode) {
						return;
					}

					/** If exist customer */
					const customer = this.customerList.find(customer => customer.email === e.currentTarget.value);

					if (customer) {
						const { id, email } = customer;

						/** Print alert */
						this.outputErrors([{ message: `User <b>${email}</b> already exists. Please login for continue` }]);

						/** Remove Node with register form */
						registerNode.parentNode.removeChild(registerNode);

						this.steps.acount.c.querySelector('.login-block').removeAttribute('hidden');
						this.btnLogin = this.steps.acount.c.querySelector('#login');
						const password = this.steps.acount.c.querySelector('input[type="password"]');

						/** Try Login */
						this.btnLogin.addEventListener('click', e => {
							e.preventDefault();

							this.btnLogin.disabled = true;
							this.auth({ cid: id, email, primary_membership: config.primary_membership.id, password: password.value });
						});
					}
				});
		}

		this.steps.acount.c.removeAttribute('data-loader');
	}

	async paymentStep() {
		/** Activate step */
		this.setActiveStep('payment');

		const { publicKey, stripeAccount } = config.stripe;
		this.stripe = await loadStripe(publicKey, { stripeAccount, apiVersion: '2020-03-02' });
		const { account } = Store.buffer;

		if (!account || !account.hasOwnProperty('cid')) {
			this.outputErrors([{ message: 'Failed login' }]);
			return false;
		}

		const discounts = await Payment.getDiscountList(config.primary_membership.id, account.cid);
		Store.buffer.discounts = discounts.data.list;

		if (Store.buffer.discounts && Store.buffer.discounts.length) {
			Discounts.generateDisCountBox(this.steps.payment.c, this.outputDescription);

			document.addEventListener("applyDiscount", (e) => {
				if (config.primary_membership.frequency === 0) {
					this.frequencyOneTime();
				} else {
					this.frequencyRecurring();
				}
			});
		}

		const { data } = await Payment.getCustomerData(account.cid);
		if (data.hasOwnProperty('error')) {
			this.outputErrors(data.error);
			return;
		}

		const { invoice_settings, cardData } = data;

		if (invoice_settings.default_payment_method === null) {
			this.cardElement = Payment.initCardField('#card-element', this.stripe);
		} else {
			const element = this.steps.payment.c.querySelector('#card-element');
			Payment.outputCardData(element, cardData);

			document.querySelector('.change-billing > a').addEventListener('click', (e) => {
				e.preventDefault() && e.stopPropagation();

				Swal.fire({
					title: "Confirm action",
					showCancelButton: true,
					icon: "warning",
					text: `Would you like to use a different credit card? You'll be able to provide new card details now. Click Confirm to proceed or Cancel for going back and using current billing details.`,
					confirmButtonText: "Confirm",
					cancelButtonText: "Cancel",
					showLoaderOnConfirm: true,
					allowOutsideClick: false,
					allowEscapeKey: false
				}).then(response => {
					const { isConfirmed } = response;
					if (isConfirmed) {
						this.cardElement = Payment.initCardField('#card-element', this.stripe);
					}
				})
			});
		}

		/** Frequency [One Time or Recurring] */
		const { primary_membership } = config;
		if (primary_membership.frequency === 0) {
			this.frequencyOneTime();
		} else {
			this.frequencyRecurring();
		}

		this.btnPay = this.steps.payment.c.querySelector('#pay');
		this.btnPay.addEventListener('click', async e => {
			e.preventDefault();

			/** Disabled btn */
			Register.toggleLoader(true);

			const result = await Payment.requestPayment(Register, { stripe: this.stripe, cardElement: this.cardElement, cdata: data, discount: Store.buffer.apply_discount });

			if (result.hasOwnProperty('error')) {
				this.outputErrors(result.error);

				if (result.hasOwnProperty('data')) {
					Store.buffer['payment'] = result.data;
				}

				/** Init card field */
				this.cardElement = Payment.initCardField('#card-element', this.stripe);
			} else if (result.hasOwnProperty('data') && result.data.hasOwnProperty('trial_free')) {
				config.primary_membership.trial_free = result.data.trial_free;
				this.setCompleteStep('payment');
				/** Run action complete */
				this.steps.complete.f();
			} else {
				if (result.hasOwnProperty('data') && result.data.hasOwnProperty('payment_intent')) {
					const { status } = result.data.payment_intent;
					if (['succeeded'].indexOf(status) !== -1) {
						Store.buffer['payment'] = result.data.payment_intent;

						this.setCompleteStep('payment');
						/** Run action complete */
						this.steps.complete.f();
					}
				} else {
					this.outputErrors([{ message: 'Unknown error occurred' }]);
				}
			}

			Register.toggleLoader(false);
		});

		this.steps.payment.c.removeAttribute('data-loader');
	}

	completeStep() {
		this.setActiveStep('complete');

		const { payment, account } = Store.buffer;
		const { primary_membership } = config;

		if (!primary_membership.free && !primary_membership.trial_free && !payment) {
			this.outputErrors([{ message: '<b>Error!</b> Empty object a payment! ' }]);
			return;
		}

		const nodePayment = this.steps.complete.c.querySelector('[data-payment="true"]');
		const nodeFree = this.steps.complete.c.querySelector('[data-payment="false"]');

		axios({
			method: 'post',
			url: this.request_url,
			data: {
				action: 'complete',
				uid: window.uid,
				data: {
					payment,
					trial: primary_membership.trial,
					membership: primary_membership.id,
					member: account.cid,
					discount: Store.buffer.apply_discount,
					stripe_account: config.stripe.stripeAccount
				}
			},
			headers: { 'Content-Type': 'multipart/form-data' }
		})
			.then(({ data }) => {
				const { primary_membership } = config;

				if (data.hasOwnProperty('error')) {
					this.outputErrors(data.error);
					return;
				}

				if (data.status) {
					if (primary_membership.free) {
						const home_page_url = nodeFree.querySelector('a[data-field="home_page_url"]');

						if (primary_membership.home_page_url) {
							home_page_url.setAttribute('href', primary_membership.home_page_url);
							home_page_url.innerHTML = primary_membership.home_page_url;
						}

						nodeFree.removeAttribute('hidden');
					} else {
						const home_page_url = nodePayment.querySelector('a[data-field="home_page_url"]');

						if (primary_membership.home_page_url) {
							home_page_url.setAttribute('href', primary_membership.home_page_url);
							home_page_url.innerHTML = primary_membership.home_page_url;
						}

						nodePayment.removeAttribute('hidden');
					}

					/** Add token in URL of links */
					setTokenOnLinks({ token: data.token });

					/** Disabled loader */
					this.steps.complete.c.removeAttribute('data-loader');
				}
			});
	}

	/** One Time frequency */
	frequencyOneTime() {
		this.outputDescription(this.steps.payment.c.querySelector('#payment-form'));
	}

	/** Recurring frequency */
	frequencyRecurring() {
		this.outputDescription(this.steps.payment.c.querySelector('#payment-form'));
	}

	/** Output info about payment in form 
	 * 
	 * @param {node} - Node element
	 * @param {boolean} - Redraw
	 * 
	 * @return void
	*/
	outputDescription(container, redraw_trial = false) {
		let firstChild = container.firstChild;
		const node = document.createElement('div');
		const order_summary = container.querySelector('.order-summary');
		let { 
			logo, title, currency, add_charges, 
			label_charges, add_taxes, total_amount, trial, 
			trial_amount, trial_duration, frequency, 
			billing_frequency, add_charges_frequency, limit_rebills } = config.primary_membership;

		let discount = null;

		if (order_summary) {
			container.removeChild(order_summary);
			firstChild = container.firstChild;
		}

		/** Discount */
		if (Store.buffer.apply_discount) {
			discount = Store.buffer.discounts.find((disc) => disc.id === Store.buffer.apply_discount);

			if (discount) {
				if (discount.recurring == '0') {
					if (trial_amount != 0) {
						trial_amount -= discount.discount_type == '1' ? parseFloat(discount.discount_amount) : total_amount * parseFloat(discount.discount_amount) / 100;
					}
				} else {
					if (trial_amount != 0) {
						trial_amount -= discount.discount_type == '1' ? parseFloat(discount.discount_amount) : total_amount * parseFloat(discount.discount_amount) / 100;
					}

					total_amount -= discount.discount_type == '1' ? parseFloat(discount.discount_amount) : total_amount * parseFloat(discount.discount_amount) / 100;
				}
			}
		}

		if (total_amount - Math.floor(total_amount) > 0) {
			total_amount = total_amount.toFixed(2);
		}

		if (trial_amount - Math.floor(trial_amount) > 0) {
			trial_amount = trial_amount.toFixed(2);
		}

		container.insertBefore(node, firstChild);

		let html = `<div class="order-summary">`;

		/** Logo */
		if (logo) {
			html += `<img class="lazyload" src="${logo}" />`;
		}

		/** Title */
		html += `<h3 class="form-subtitle">${title}</h3>`;

		/** Trial */
		if (trial) {
			html += `
				<div class="order-summary__choice">
					<input id="trial" type="radio" ${!redraw_trial ? 'checked' : ''} name="period" />
					<label for="trial">
						<span>
							Trial Period
							<span>${Helper.getCode(currency)}${trial_amount} for ${trial_duration}-day${[1, 0].indexOf(trial_duration % 10) === -1 || trial_duration == 11 ? 's' : ''}</span>
						</span>
					</label>
					
					<input id="full" type="radio" name="period" ${redraw_trial ? 'checked' : ''} />
					<label for="full">
						<span>
							After Trial
							<span>${Helper.getCode(currency)}${total_amount}/ per ${billing_frequency}${limit_rebills ? ' during ' + limit_rebills + ' ' + billing_frequency + (limit_rebills % 10 !== 1 ? 's' : '') : ''}</span>
						</span>
					</label>
				</div>`;
		}

		/** Order Subtotal */
		html += `
			<div>
				<div class="order-summary__detail">
					<span>${redraw_trial ? 'Order Subtotal' : 'Total Billed Today'}</span>
					<span></span>
					<span>${Helper.getCode(currency)}`

		if (redraw_trial || !trial) {
			if (frequency == 1) {
				if (add_charges && add_charges_frequency == '0') {
					html += `${total_amount} (${Helper.getCode(currency)}${this.roundPrice(total_amount - add_charges)} / per ${billing_frequency})`;
				} else {
					html += `${total_amount} / per ${billing_frequency}`;
				}
			} else {
				html += `${total_amount}`;
			}
		} else {
			html += `${trial_amount} for ${trial_duration}-day${[1, 0].indexOf(trial_duration % 10) === -1 || trial_duration == 11 ? 's' : ''}`;
		}

		html += `</span>
				</div>`;

		if (redraw_trial) {
			/** Additional Charges */
			if (add_charges) {
				html += `
					<div class="order-summary__detail">
						<span>${label_charges ? label_charges : 'Additional Charges'}${frequency && add_charges_frequency == '0' ? ' (One Time)' : ''}</span>
						<span></span>
						<span>${Helper.getCode(currency)}${add_charges}</span>
					</div>`;
			}

			/** Add taxes */
			if (add_taxes) {
				html += `
					<div class="order-summary__detail">
						<span>Taxes</span>
						<span></span>
						<span>${add_taxes}%</span>
					</div>`;
			}
		}

		/** Discount */
		if (Store.buffer.apply_discount) {
			if (discount) {
				if (trial_amount > 0 && !redraw_trial) {
					html += `
						<div class="order-summary__detail">
							<span>${discount.name}</span>
							<span></span>
							<span>-${Helper.getDiscount(discount.discount_type, discount.discount_amount)}</span>
						</div>`;
				}

				if (redraw_trial) {
					if (discount.recurring != '0' || trial_amount == 0) {
						html += `
							<div class="order-summary__detail">
								<span>${discount.name}</span>
								<span></span>
								<span>-${Helper.getDiscount(discount.discount_type, discount.discount_amount)} ${discount.recurring == '0' ? 'once' : 'forever'}</span>
							</div>`;
					}
				}
			}
		}

		/** Total Amount */
		html += `
				<div class="order-summary__total-amount">
					<span>Total</span>
					<span>${Helper.getCode(currency)}${trial ? trial_amount : total_amount}</span>
				</div>
			</div>
		</div>`;

		const btn = container.querySelector('button');
		if (btn) {
			btn.innerHTML = `Pay &nbsp;${Helper.getCode(currency)}${trial ? trial_amount : total_amount}`;
		}

		node.outerHTML = html;

		if (trial) {
			container.querySelector('input#full').addEventListener('change', e => this.outputDescription(container, true));
			container.querySelector('input#trial').addEventListener('change', e => this.outputDescription(container));
		}
	}

	/** Print errors
	 * 
	 * @param {array} - Array of error messages
	 * @return void
	 */
	outputErrors(errors) {
		this.alerts.innerHTML = '';

		errors.forEach(error => {
			const alert = document.createElement('div');
			alert.classList.add('alert-message', 'alert-error');
			alert.innerHTML = error.message;

			this.alerts.appendChild(alert);
		});

		setTimeout(() => this.clearAlerts(), 10000);
	}

	/** Clear all alerts in a form */
	clearAlerts() {
		this.alerts.innerHTML = '';
	}

	/** Auth user if exist on system */
	auth({ cid, email, primary_membership, password }) {
		axios({
			method: 'post',
			url: this.request_url,
			data: {
				action: 'login',
				uid: window.uid,
				data: {
					cid,
					password,
					email,
					primary_membership,
					referral: (window.Rewardful ? Rewardful.referral : false)
				}
			},
			headers: { 'Content-Type': 'multipart/form-data' }
		})
			.then(response => {
				const { data } = response;
				this.clearAlerts();

				/** Check for errors */
				if (data.hasOwnProperty('errors')) {
					this.outputErrors(data.errors);
				}

				/** Check status auth */
				if (data.hasOwnProperty('status') && data.status) {
					Store.buffer['account'] = response.data;
					this.steps.acount.el.classList.add('completed');
					this.steps.acount.c.style.display = 'none';

					const next_step = this.active_steps[1];

					/** Run action for next step */
					this.steps[next_step].f();
				}

				this.btnLogin.disabled = false;
			})
			.catch(error => {
				this.outputErrors([{ message: error.message }]);
				this.btnLogin.disabled = false;
			});
	}

	/** Show/Hide loader on button
	 * 
	 * @param {bool} - Show (true) or hide (false)
	 * @return void
	 */
	static toggleLoader(show) {
		const pay = document.querySelector('#pay');
		if (pay) {
			pay.disabled = show;
		}
	}

	/** Activated step in navigation
	 * 
	 * @param {string} - Step name
	 */
	setActiveStep(step_name) {
		this.steps[step_name].el.classList.add('active');
		this.steps[step_name].c.style.display = 'block';
		this.steps[step_name].c.setAttribute('data-loader', true);
		this.alerts = this.steps[step_name].c.querySelector('.alerts');
	}

	/** Completed step in navigation
	 * 
	 * @param {string} - Step name
	 */
	setCompleteStep(step_name) {
		this.steps[step_name].el.classList.add('completed');
		this.steps[step_name].c.style.display = 'none';
	}

	/** Getting list of customer for current user 
	 * @return {mixed} - Return promise or boolean
	*/
	async getCustomerList() {
		try {
			let { data } = await axios.post(
				this.request_url,
				{ action: "customer_list", uid: window.uid, data: { uid } },
				{ headers: { "Content-Type": "multipart/form-data" } }
			);

			if (data.length) {
				data = data.map(item => ({ id: item.id, email: atob(item.email) }));
			}

			return Promise.resolve(data);
		} catch (e) {
			this.outputErrors([{ message: '<b>Critical Error!</b> Reload this page and try again.' }]);
			return false;
		}
	}

	/** Add list of country to select
	 * @param {object} - Object with keys [allowed_contries, select]
	 * @return {Promise}
	 */
	addAllowedCountries({ allowed_contries, select }) {
		allowed_contries.map((country) => {
			const option = document.createElement("option");
			option.innerText = country.name;
			option.value = country.iso;
			select.appendChild(option);
		});

		return Promise.resolve(true);
	}

	roundPrice(value) {
		if (value - Math.floor(value) > 0) {
			value = value.toFixed(2);
		}

		return value;
	}
}