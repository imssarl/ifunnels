export default class Helper {

	/**
	 * Serialize all form data into an object
	 * @param  {Node} form The form to serialize
	 * @return {Object} the serialized form data
	 */
	static serializeArray(form) {
		// Setup our serialized data
		const serialized = {};

		// Loop through each field in the form
		for (let i = 0; i < form.elements.length; i++) {

			const field = form.elements[i];

			// Don't serialize fields without a name, submits, buttons, file and reset inputs, and disabled fields
			if (!field.name || field.disabled || field.type === 'file' || field.type === 'reset' || field.type === 'submit' || field.type === 'button') continue;

			// If a multi-select, get all selections
			if (field.type === 'select-multiple') {
				for (let n = 0; n < field.options.length; n++) {
					if (!field.options[n].selected) continue;

					if (!serialized.hasOwnProperty(field.name)) {
						serialized[field.name] = [];
					}

					serialized[field.name].push(field.options[n].value);
				}
			}

			else if (field.type == 'checkbox') {
				if (!serialized.hasOwnProperty(field.name)) {
					serialized[field.name] = [];
				}

				serialized[field.name].push(field.value);
			}
			else if (field.type !== 'checkbox' || field.checked) {
				serialized[field.name] = field.value;
			}
		}

		return serialized;
	}

	/**
	 * Validating string on selected rule
	 * @param {String} value for validating
	 * @param {Object} rule for validating
	 * @return {Boolean} result a valitating
	 */
	static validateValue(value, rule) {
		const rules = {
			email: {
				patern: /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/,
				message: 'Input your email'
			},
			not_empty: {
				rule: s => !(s.length === 0 || !s.trim())
			},
			digital: {
				patern: /^\d+$/,
				message: 'Is not digital'
			}
		};

		if (typeof rule == 'object' && rules.hasOwnProperty(rule.name)) {
			const _rule = rules[rule.name];

			if (_rule.hasOwnProperty('patern')) {
				return _rule.patern.test(value) || (rule.message || _rule.message)
			}

			if (_rule.hasOwnProperty('rule')) {
				return _rule.rule(value);
			}
		}
	}

	static getCode(abbr) {
		switch (abbr) {
			case "USD":
			case "CAD":
			case "AUD":
			case "NZD": {
				return '&#36;';
			}

			case "EUR": {
				return '&#8364;';
			}

			case "GBP": {
				return '&#163;';
			}

			default: {
				return '&#36;';
			}
		}
	}

	static getDicountType(type) {
		return type == '1' ? '&#36;' : '&percnt;';
	}

	static getDiscount(type, amount) {
		if (type == '1') {
			return `${Helper.getDicountType(type)}${amount}`; 
		}

		return `${amount}${Helper.getDicountType(type)}`;
	}
}