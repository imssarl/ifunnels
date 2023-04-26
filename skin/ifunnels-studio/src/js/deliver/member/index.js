import axios from "axios";
import Swal from "sweetalert2";
import MicroModal from 'micromodal';
import '../../../scss/member/index.scss';

export default class Member {
	btn = null;

	static init() {
		const _this = new Member();

		const btnUnsubscribe = document.querySelectorAll("[data-unsubscribe]");

		if (btnUnsubscribe.length) {
			btnUnsubscribe.forEach((btn) => {
				btn.addEventListener("click", (e) => _this.unsubscribe(e));
			});
		}

		const btnResend = document.querySelectorAll("[data-resend]");

		if (btnResend.length) {
			btnResend.forEach((btn) => {
				btn.addEventListener("click", (e) => _this.resend(e));
			});
		}

		const btnSetPassword = document.querySelectorAll("[data-set-password]");

		if (btnSetPassword.length) {
			btnSetPassword.forEach((btn) => {
				btn.addEventListener("click", (e) => _this.setPassword(e));
			});
		}

		const btnRemove = document.querySelectorAll("[data-remove]");

		if (btnRemove.length) {
			btnRemove.forEach((btn) => {
				btn.addEventListener("click", (e) => _this.removeMember(e));
			});
		}

		const btnAdd = document.querySelectorAll("[data-add]");

		if (btnAdd.length) {
			btnAdd.forEach((btn) => {
				btn.addEventListener("click", (e) => _this.addToMembership(e));
			});
		}

		const btnShowModal = document.querySelector("[data-show-modal]");
		if (btnShowModal) {
			btnShowModal.addEventListener("click", e => {
				e.preventDefault();

				// Show modal and reset value of fields
				MicroModal.show("add-new-member", {
					onShow: modal => {
						modal.querySelectorAll('div.text-danger').forEach(n => n.innerText = '');
						modal.querySelector('input[type="text"]').value = null;
						window.jQuery(modal.querySelector('select')).selectpicker('val', '');
						modal.querySelector('.alerts').innerHTML = null;
						btnAddMember.classList.remove('loading');
					}
				});
			});

			_this.input = document.querySelector('#add-new-member input');
			_this.select = document.querySelector('#add-new-member select');
			_this.alerts = document.querySelector('#add-new-member .alerts');

			const btnAddMember = document.getElementById('add-member');
			btnAddMember.addEventListener('click', _this.addNewMember.bind(_this));
		}
	}

	unsubscribe(e) {
		e.preventDefault();

		const { target } = e;

		this.btn = target.closest(".btn-group").querySelector("button");
		this.btn.disabled = true;

		axios({
			method: "post",
			url: ajaxURL,
			data: {
				subscribe_id: target.getAttribute("data-subsciption-id"),
				action: "unsubscribe",
				payment_id: target.getAttribute("data-payment-id"),
				membership_id: target.getAttribute("data-membership-id"),
			},
			headers: { "Content-Type": "multipart/form-data" },
		}).then((response) => {
			if (response.data.status === "canceled") {
				const parentContainer = this.btn.parentNode;
				const subName = this.btn.querySelector("strong").innerText;
				parentContainer.removeChild(this.btn);
				const label = document.createElement("span");
				label.classList.add("label", "label-primary");
				label.innerText = subName;

				parentContainer.appendChild(label);
			}
		});
	}

	resend(e) {
		e.preventDefault();

		const mid = e.currentTarget.getAttribute('data-mid');

		Swal.fire({
			title: "Confirm action",
			showCancelButton: true,
			icon: "warning",
			text: `Resend login details?`,
			confirmButtonText: "Proceed",
			cancelButtonText: "Cancel",
			showLoaderOnConfirm: true,
			allowOutsideClick: false,
			allowEscapeKey: false,
			preConfirm: () => {
				return axios.post(ajaxURL, { action: 'resend', data: { mid } });
			},
		}).then((response) => {
			const { isConfirmed, value } = response;

			if (isConfirmed) {
				if (value.status === 200 && value.data.status) {
					Swal.fire({
						title: "Successfuly resend!",
						icon: "success"
					});
				} else {
					Swal.fire({
						title: "An error has occurred. Try again!",
						icon: "error"
					});
				}
			}
		});
	}

	setPassword(e) {
		e.preventDefault();

		const mid = e.currentTarget.getAttribute('data-mid');

		Swal.fire({
			title: 'Enter new password',
			input: 'password',
			inputPlaceholder: 'Enter new password',
			inputAttributes: {
				autocapitalize: 'off',
				autocorrect: 'off'
			},
			confirmButtonText: 'Proceed',
			showCancelButton: true,
			preConfirm: (password) => {
				return axios.post(ajaxURL, { action: 'set_password', data: { password, mid } });
			},
			inputValidator: (value) => {
				if (!value.trim().length || value.length < 3) {
					return 'Enter new password!'
				}
			},
			showLoaderOnConfirm: true
		}).then(response => {
			const { isConfirmed, value } = response;

			if (isConfirmed) {
				if (value.status === 200 && value.data.status) {
					Swal.fire({
						title: "Successfuly updated!",
						icon: "success"
					});
				} else {
					Swal.fire({
						title: "An error has occurred. Try again!",
						icon: "error"
					});
				}
			}
		});
	}

	removeMember(e) {
		e.preventDefault();

		const mid = e.currentTarget.getAttribute('data-mid');
		const membership_id = e.currentTarget.getAttribute('data-membership-id');

		Swal.fire({
			title: 'Confirm action',
			text: 'Remove this user from membership?',
			confirmButtonText: 'Proceed',
			showCancelButton: true,
			preConfirm: () => {
				return axios.post(ajaxURL, { action: 'remove', data: { mid, membership_id } });
			},
			showLoaderOnConfirm: true
		}).then(response => {
			const { isConfirmed, value } = response;

			if (isConfirmed) {
				if (value.status === 200 && value.data.status) {
					Swal.fire({
						title: "Successfuly updated!",
						icon: "success"
					}).then(() => {
						window.location.reload();
					});

				} else {
					Swal.fire({
						title: "An error has occurred. Try again!",
						icon: "error"
					});
				}
			}
		});
	}

	addToMembership(e) {
		e.preventDefault();

		const mid = e.currentTarget.getAttribute('data-mid');
		const added = JSON.parse(e.currentTarget.getAttribute('data-added'));
		const list = {};

		if (membershipList) {
			membershipList.forEach(({ id, name }) => {
				if (!added.includes(id)) {
					list[id] = name;
				}
			});
		}

		Swal.fire({
			title: '<strong>Add user to membership</strong>',
			input: 'select',
			inputPlaceholder: 'Select a membership',
			inputOptions: list,
			showCloseButton: true,
			showCancelButton: true,
			focusConfirm: true,
			confirmButtonText: '<i class="md md-add-circle"></i> Add',
			cancelButtonText: 'Cancel',
			preConfirm: (membership_id) => {
				return axios.post(ajaxURL, { action: 'add_member', data: { membership_id, mid } });
			},
			inputValidator: (value) => {
				if (!value) {
					return 'Select membership!'
				}
			},
			showLoaderOnConfirm: true
		}).then(response => {
			const { isConfirmed, value } = response;

			if (isConfirmed) {
				if (value.status === 200 && value.data.status) {
					Swal.fire({
						title: "Successfuly updated!",
						icon: "success"
					}).then(() => {
						window.location.reload();
					});
				} else {
					Swal.fire({
						title: "An error has occurred. Try again!",
						icon: "error"
					});
				}
			}
		});
	}

	addNewMember(e) {
		e.preventDefault();

		const { currentTarget } = e;

		const { inputAlert, selectAlert } = {
			inputAlert: this.input.parentNode.querySelector('div.text-danger'),
			selectAlert: this.select.parentNode.querySelector('div.text-danger')
		};

		inputAlert.innerHTML = null;
		selectAlert.innerHTML = null;
		let valid = true;

		const reg = /(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/;
		if (!reg.test(this.input.value)) {
			inputAlert.innerHTML = '<small>Input a email</small>';
			valid = false;
		}

		if (this.select.value == '') {
			selectAlert.innerHTML = '<small>Select a membership</small>';
			valid = false;
		}

		if (!valid) return;

		currentTarget.classList.add('loading', 'disabled');

		axios
			.post(ajaxURL, {
				action: 'add_new_member',
				data: { email: this.input.value, membership: this.select.value }
			})
			.then(({ data }) => {
				this.showAlert(data);
				currentTarget.classList.remove('loading');

				if (data.status == 'error') {
					currentTarget.classList.remove('disabled');
				}
			});
	}

	showAlert({ status, message }) {
		switch (status) {
			case "success":
				this.alerts.innerHTML = `<div class="alert alert-success">${message}</div>`;
				break;

			case "error":
				this.alerts.innerHTML = `<div class="alert alert-danger">${message}</div>`;
				break;
		}
	}
}

document.addEventListener("DOMContentLoaded", () => Member.init());