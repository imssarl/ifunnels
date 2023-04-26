import axios from 'axios';
import Cookies from 'js-cookie';
import Register from './register';

export default class SignIn {
	form = null;
	modal = null;
	btnSubmit = null;
	alerts = null;
	authData = {};

	constructor() {
		this.modal = document.querySelector('.sign-in');

		if (!this.modal) {
			return false;
		}

		this.form = this.modal.querySelector('form');
		this.btnSubmit = this.form.querySelector('button');
		this.init();
	}

	static getUrl() {
		return config.auth_url || 'https://app.ifunnels.com/services/deliver-signin.php';
	}

	/** Inital method */
	init() {
		if (this.form) {
			/** Check auth for user */
			// this.checkToken();

			document.body.classList.add('overflow-hidden');

			this.form.addEventListener('submit', e => this.handlerSubmitForm(e));
			this.alerts = this.form.querySelector('.alerts');
			const forgot_link = this.form.querySelector('a[data-forgot]');

			if (forgot_link) {
				forgot_link.setAttribute("href", config.forgot_url);
			}

			document.getElementById('register').addEventListener('click', e => {
				e.preventDefault();
				this.modal.style.display = 'none';

				Register.init();
			});
		}
	}

	/** Event Listener for submitting form */
	handlerSubmitForm(e) {
		e.preventDefault();

		this.btnSubmit.disabled = true;

		this.authData.login = this.form.querySelector('input[name="login"]').value;
		this.authData.password = this.form.querySelector('input[name="password"]').value;
		this.authData.memberships = config.memberships || [];
		this.authData.pageid = pageid !== undefined ? pageid : null;

		axios({
			method: 'post',
			url: SignIn.getUrl(),
			data: this.authData,
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
					this.saveToken(data['auth-token']);

					window.location.reload();
				}

				this.btnSubmit.disabled = false;
			})
			.catch(error => {
				this.outputErrors([{ message: error.message }]);
				this.btnSubmit.disabled = false;
			});
	}

	/** Added auth token for a user cookies */
	saveToken(token) {
		Cookies.set('token', token, { expires: 1 });
	}

	/** Check auth for user */
	checkToken() {
		const token = Cookies.get('token');

		if (token) {
			this.btnSubmit.disabled = true;

			axios({
				method: 'post',
				url: SignIn.getUrl(),
				data: { token, memberships: config.memberships || [] },
				headers: { 'Content-Type': 'multipart/form-data' }
			})
				.then(response => {
					const { data } = response;

					if (data.status) {
						document.querySelector('.sign-in').style.display = 'none';
						document.body.classList.remove('overflow-hidden');
					}

					this.btnSubmit.disabled = false;
				});
		}
	}

	/** Print errors */
	outputErrors(errors) {
		this.alerts.innerHTML = '';

		errors.forEach(error => {
			const alert = document.createElement('div');
			alert.classList.add('alert-message', 'alert-error');
			alert.innerText = error.message;

			this.alerts.appendChild(alert);
		});
	}

	/** Clear all alerts in a form */
	clearAlerts() {
		this.alerts.innerHTML = '';
	}
}