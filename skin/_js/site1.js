// some js for site1
img_preload(['/skin/_js/roar/roar.png']);
var r,tips,validator;
window.addEvent('domready',function(){
	tips=new Tips('.tooltip');
	r=new Roar();
	validator=new WhValidator({className:'validate'});
});