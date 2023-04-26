import Popup from "../popup";
import Steps from "../popup/steps";
import { getTokenFromURL, setTokenOnLinks } from "../token";
import { isMobile, isIOS } from 'mobile-device-detect';
import Bump from "./bump";

class Checkout {
  popups = [];

  constructor() {
    /** Disable for module iFunnels Studio */
    if (["app.local", "app.ifunnels.com"].includes(window.location.host)) {
      return;
    }

    const elCheckout = document.querySelectorAll('[data-checkout="true"]');

    if (elCheckout.length) {
      this.addClickListener(elCheckout);
      const token = getTokenFromURL();

      window.config = {};

      if (token) {
        window.config = { token };
        setTokenOnLinks({ token });
      }
    }
  }

  static init() {
    const _this = new Checkout();
  }

  /** Init popup */
  initPopup(options = {}) {
    return Popup.init(options);
  }

  /** Add Listener for click on element */
  addClickListener(nodeList) {
    if (nodeList) {
      nodeList.forEach((element) => {
        const popupType = element.getAttribute("data-checkout-display");
        const options = {
          className: `ch_popup--${popupType}`,
          closeOverlay: false,
          onAfterOpen: (instance) =>
            Steps.init(instance, {
              membershipid: element.getAttribute("data-checkout-membership"),
              redirect_url: element.getAttribute("data-checkout-redirect"),
            }),
          onAfterClose: (instance) => {
            if (popupType == "regular") {
              instance.setContent(this.regularMarkup());
            }

            if (popupType == "popup") {
              instance.setContent(this.popupMarkup());
            }

            // Steps.init(instance, {
            //   membershipid: element.getAttribute("data-checkout-membership"),
            //   redirect_url: element.getAttribute("data-checkout-redirect"),
            // });
          },
        };

        if (popupType == "regular") {
          options.closeButtonMarkup =
            '<a href="#" data-close class="dark"></a>';
        }

        /** Init modal popup */
        const popup = this.initPopup(options);
        this.popups.push(popup);

        if (popupType == "regular") {
          popup.setContent(this.regularMarkup());
        }

        if (popupType == "popup") {
          popup.setContent(this.popupMarkup());
        }

        /** Add event listener for button */
        element.addEventListener("click", (e) => {
          e.preventDefault();
          popup.showPopup();

		  Bump.init(e.currentTarget);
        });
      });
    }
  }

  regularMarkup() {
    let markup = `
		<div class="form-body">
			<div class="img-holder">
				<div class="bg"></div>
				<div class="info-holder">
					<img class="md-size" alt="" src="https://app.ifunnels.com/skin/ifunnels-studio/dist/img/graphic7.svg">
				</div>
			</div>

			<div class="form-holder">
				<div class="form-content">
					<div class="form-items">
						<h3 class="form-title">Registration</h3>

						<div class="steps">
							<div class="step active" data-step="acount">
								<i class="user icon"></i>
								<div class="content">
									<div class="title">Acount Details</div>
									<div class="description">Enter your information</div>
								</div>
							</div>

							<div class="step" data-step="payment">
								<i class="payment icon"></i>
								<div class="content">
									<div class="title">Payment</div>
									<div class="description">Enter card information</div>
								</div>
							</div>

							<div class="step" data-step="complete">
								<i class="info icon"></i>
								<div class="content">
									<div class="title">Complete Order</div>
									<div class="description">Check order details</div>
								</div>
							</div>
						</div>

						<div class="steps-content">
							<div class="step-content" data-step-content="acount" style="display: block;">
								<form>
									<div class="alerts"></div>

									<div class="form-subtitle">Account information</div>

									<div class="login-block" hidden="">
										<input type="password" placeholder="Enter Password" name="password" ${isMobile && isIOS ? '' : `readonly="readonly" onfocus="this.removeAttribute('readonly');"`}>
										<div class="form-button">
											<button id="login" type="submit">Login</button>
											<p><small>Forgot your password? Click <a data-forgot target="_blank">here</a> to restore it.</small></p>
										</div>
									</div>

									<div class="register-block">
										<input type="text" placeholder="Enter Email" name="email" ${isMobile && isIOS ? '' : `readonly="readonly" onfocus="this.removeAttribute('readonly');"`}>

										<div data-require-shipping="false">
											<div class="form-subtitle">Shipping Address</div>

											<p>Shipping available only in the following countries</p>
											<select name="country" class="selectpicker" data-live-search="true" title="Select country"></select>
	
											<input type="text" placeholder="Name" name="name" autocomplete="off">
											<input type="text" placeholder="Address line" name="address_line_1" autocomplete="off">
											<input type="text" placeholder="City" name="city" autocomplete="off">
											<input type="text" placeholder="ZIP" name="zip" autocomplete="off">
										</div>
	
										<div class="form-button">
											<button type="submit">Next</button>
										</div>
									</div>
								</form>
							</div>

							<div class="step-content" data-step-content="payment">
								<div class="form-subtitle">Payment Information</div>
								
								<div class="bump-box"></div>
								<div class="discount-box"></div>

								<form id="payment-form">
									<div class="form-subtitle">Card Details</div>
									
									<div class="alerts"></div>
									
									<div id="card-element"></div>
									<div id="card-errors" role="alert"></div>

									<div class="bump-box"></div>

									<div class="form-button btn-pay">
										<button id="pay">Pay</button>
									</div>
								</form>
							</div>

							<div class="step-content" data-step-content="complete">
								<div class="alerts"></div>

								<div data-payment="true" hidden="">
									<p class="form-subtitle">Thank you! Your payment was processed successfully.</p>
									<p class="redirect">You will be redirected in 5 seconds</p>
								</div>

								<div data-payment="false" hidden="">
									<p class="form-subtitle">Thank you for joining!</p>
									<p class="redirect">You will be redirected in 5 seconds</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>`;

    return markup;
  }

  popupMarkup() {
    let markup = `
		<div class="form-body">
			<div class="form-holder">
				<div class="form-content">
					<div class="form-items">
						<h3 class="form-title">Registration</h3>

						<div class="steps">
							<div class="step active" data-step="acount">
								<i class="user icon"></i>
								<div class="content">
									<div class="title">Acount Details</div>
									<div class="description">Enter your information</div>
								</div>
							</div>

							<div class="step" data-step="payment">
								<i class="payment icon"></i>
								<div class="content">
									<div class="title">Payment</div>
									<div class="description">Enter card information</div>
								</div>
							</div>

							<div class="step" data-step="complete">
								<i class="info icon"></i>
								<div class="content">
									<div class="title">Complete Order</div>
									<div class="description">Check order details</div>
								</div>
							</div>
						</div>

						<div class="steps-content">
							<div class="step-content" data-step-content="acount">
								<form>
									<div class="alerts"></div>

									<div class="form-subtitle">Account information</div>

									<div class="login-block" hidden="">
										<input type="password" placeholder="Enter Password" name="password" ${isMobile && isIOS ? '' : `readonly="readonly" onfocus="this.removeAttribute('readonly');"`}>
										<div class="form-button">
											<button id="login" type="submit">Login</button>
											<p><small>Forgot your password? Click <a data-forgot target="_blank">here</a> to restore it.</small></p>
										</div>
									</div>

									<div class="register-block">
										<input type="text" placeholder="Enter Email" name="email" ${isMobile && isIOS ? '' : `readonly="readonly" onfocus="this.removeAttribute('readonly');"`}>

										<div data-require-shipping="false">
											<div class="form-subtitle">Shipping Address</div>
	
											<p>Shipping available only in the following countries</p>
											<select name="country" class="selectpicker" data-live-search="true" title="Select country"></select>

											<input type="text" placeholder="Name" name="name" autocomplete="off">
											<input type="text" placeholder="Address line" name="address_line_1" autocomplete="off">
											<input type="text" placeholder="City" name="city" autocomplete="off">
											<input type="text" placeholder="ZIP" name="zip" autocomplete="off">
										</div>
	
										<div class="form-button">
											<button type="submit">Next</button>
										</div>
									</div>
								</form>
							</div>

							<div class="step-content" data-step-content="payment">
								<div class="form-subtitle">Payment Information</div>

								<div class="bump-box"></div>
								<div class="discount-box"></div>

								<form id="payment-form">
									<div class="form-subtitle">Card Details</div>
									
									<div class="alerts"></div>
									
									<div id="card-element"></div>
									<div id="card-errors" role="alert"></div>

									<div class="bump-box"></div>

									<div class="form-button btn-pay">
										<button id="pay">Pay</button>
									</div>
								</form>
							</div>

							<div class="step-content" data-step-content="complete">
								<div class="alerts"></div>

								<div data-payment="true" hidden="">
									<p class="form-subtitle">Thank you! Your payment was processed successfully.</p>
									<p class="redirect">You will be redirected in 5 seconds</p>
								</div>

								<div data-payment="false" hidden="">
									<p class="form-subtitle">Thank you for joining!</p>
									<p class="redirect">You will be redirected in 5 seconds</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>`;

    return markup;
  }
}

Checkout.init();
