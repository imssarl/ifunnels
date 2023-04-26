var Tabs = new Class({
	options: {
		onStart: function(slideIndex,tooth) {
			tooth.choseTab(slideIndex)
		}
	},
	initialize: function(tabs, slides, options){
		this.tabs = $$(tabs);
		this.slides = $$(slides);
		if(options.startIndex!=null){
			this.options.onStart(options.startIndex,this)
		}
		this.createTabs()
	},
	createTabs: function () {
		this.tabs.each( function(tab,index) {
			tab.addEvent('click',function(event){
				this.choseTab(index)
			}.bind(this))
		}.bind(this))
	}.protect(),
	choseTab: function (index) {
		this.tabs.removeClass('active');
		this.slides.removeClass('active');
		this.tabs[index].addClass('active');
		this.slides[index].addClass('active')
	}
});