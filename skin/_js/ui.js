var UI=new Class({
	initialize: function(){
		this.menu();
		this.confirmDelete();
		this.notification();
		this.popup();
		this.actions();
	},

	actions: function(){
		$$('.apply-to-selected').each(function(a){
			a.addEvent('click',function(e){
				e.stop();
				a.getParent('form').submit();
			});
		});
	},

	popup: function(){
		popup=new CeraBox( $$('.popup-sidebar'), {
			group: false,
			width:'70%',
			height:'70%',
			displayTitle: true,
			titleFormat: '{title}'
		});
	},

	notification: function(){
		var collapsibles = new Array();
		$$('.notification .close').each(function(el,i){
			var collapsible = new Fx.Slide(el.getParent(), {
				duration:'500',
				transition:Fx.Transitions.Back.easeOut
			});
			collapsibles[i]=collapsible;
			el.addEvent('click',function(e){
				e.stop();
				for (var j = 0; j < collapsibles.length; j++)
					if (j == i)
						collapsibles[j].slideOut();
			});
		});
	},

	// Sidebar menu
	menu: function(){
		$$('.nav-top-item').set('morph', {
			duration:200
		})
		$$('.nav-top-item').addEvents({
			mouseenter:function () {
				this.morph({
					'padding-right':25
				});
			},
			mouseleave:function () {
				this.morph({
					'padding-right':15
				});
			},
			click: function(){
				$$('.nav-top-item').each(function(el){el.removeClass('current')});
				this.addClass('current');
			}
		});

		var headings = new Array();
		var list = $$('#main-nav li ul');
		list.each(function(ul,i){
			headings[i]=ul.getPrevious('a');
		});
		var collapsibles = new Array();
		headings.each(function (heading, i) {
			var collapsible = new Fx.Slide(list[i], {
				duration:'300',
				transition:Fx.Transitions.quadIn
			});
			collapsibles[i] = collapsible;
			heading.onclick = function () {
				for (var j = 0; j < collapsibles.length; j++)
					if (j != i)
						collapsibles[j].slideOut();
				collapsible.toggle();
				return false;
			}
			if(!heading.hasClass('current')){
				collapsible.hide();
			}
		});
	},

	confirmDelete: function(){
		$$('.confirm-delete').each(function(element){
			element.addEvent('click', function(e){
				return confirm(element.get('confirm'));
			});
		});
	}

});
window.addEvent('domready', function(){
	new UI();
});