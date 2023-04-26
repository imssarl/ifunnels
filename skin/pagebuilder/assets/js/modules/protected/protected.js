(function () {
	"use strict";

	const builder = require( '../builder/builder' );

	const protectedObj = {
		protectedPageCheckbox: document.getElementById('protected_page'),
		dripfeedCheckbox: document.getElementById('drip_feed'),
		membershipLists: document.querySelectorAll( '.membership-lists input[type="checkbox"]' ),
		selectPageSettingsPrimaryMembership: document.getElementById('ss-primary-membership'),

		init: function() {
			// if( ! this.applyBtn ) return; 

			$(this.protectedPageCheckbox).on('switchChange.bootstrapSwitch', function (e, data) {
				$( e.target.closest('.optionPane') ).find( '[data-protected="true"]' ).fadeToggle( 'fast' );
			});

			$(this.dripfeedCheckbox).on('switchChange.bootstrapSwitch', function (e, data) {
				$( e.target.closest('.optionPane') ).find( '[data-drip-feed="true"]' ).fadeToggle( 'fast' );
			});
			
			this.membershipLists.forEach( checkbox => {
				checkbox.addEventListener( 'change', e => {
					this.updateSelectPrimaryMembership();
				} );
			} );

			this.applyHandler = this.applyHandler.bind(this);
			this.updateSelectPrimaryMembership = this.updateSelectPrimaryMembership.bind(this);
		},

		checkedLists: function() {
			const selectedMemberships = [];
			this.membershipLists.forEach( element => {
				if( element.checked ) {
					selectedMemberships.push( element.value );
				}
			} );

			return selectedMemberships;
		},
		
		setProtection: function() {
			builder.site.activePage.pageSettings.protected = '1';
			const {memberships} = builder.site.activePage.pageSettings;
			builder.site.activePage.pageSettings.memberships = memberships.concat( this.diffArray( this.checkedLists(), memberships ) );
			
			if( protectedObj.selectPageSettingsPrimaryMembership.value ) {
				builder.site.activePage.pageSettings.primary_membership = protectedObj.selectPageSettingsPrimaryMembership.value;
			}
		},

		applyHandler: function( e ) {
			e.preventDefault();
			
			builder.site.sitePages.forEach( page => {
				page.pageSettings.protected = '1';
				const {memberships} = page.pageSettings;

				page.pageSettings.memberships = memberships.concat( this.diffArray( this.checkedLists(), memberships ) );

				if( this.selectPageSettingsPrimaryMembership.value ) {
					page.pageSettings.primary_membership = this.selectPageSettingsPrimaryMembership.value;
				}
			} );

			/** Updated the status field on the page on changed */
			builder.site.updatePageStatus( 'changed' );

			this.clearChecked();
			this.applyBtn.disabled = true;

			/** Enabled pending changes */
			// builder.site.setPendingChanges(true);


			console.log( builder.site.sitePages, builder.site.pages );

			$(this.alertMessage).stop( true, true ).fadeIn('fast', () => {
				setTimeout(() => {
					$(this.alertMessage).stop( true, true ).fadeOut('fast');
				}, 2000);
			});
		},

		updateSelectPrimaryMembership : function( e ) {
			const listMembership = [];

			this.membershipLists.forEach( input => {
				if( input.checked ) {
					listMembership.push( { name: input.previousSibling.textContent.trim(), value: input.value } );
				}
			});

			this.selectPageSettingsPrimaryMembership.querySelectorAll( 'option' ).forEach( option => {
				this.selectPageSettingsPrimaryMembership.removeChild( option );
			} );

			listMembership.forEach( membership => {
				const option = document.createElement( 'option');
				option.value = membership.value;
				option.textContent = membership.name;
				
				this.selectPageSettingsPrimaryMembership.appendChild( option );
			} );

			$( this.selectPageSettingsPrimaryMembership ).selectpicker('refresh');
		},

		clearChecked: function() {
			this.membershipLists.forEach( input => input.checked = false );
		},

		diffArray: function( arr1, arr2 ) {
			return arr1.filter(x => !arr2.includes(x));
		}
	};

	protectedObj.init();

	module.exports.protectedObj = protectedObj;
}());