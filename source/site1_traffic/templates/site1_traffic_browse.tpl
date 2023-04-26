{include file='../../box-top.tpl' title=$arrNest.title}
<div class="card-box">
<button type="button" class="mb button btn btn-success waves-effect waves-light" href="#promote" title="Start from scratch using the form below or Load a Demo Landing Page of your choice by clicking here and picking the one of your choice">Earn credits by browsing other members' pages</button><br/>
<small>Every time you click the button, you will see a new site. Browse it in order to earn a credit.</small>
</div>
{include file='../../box-bottom.tpl'}
<script type="text/javascript">{literal}
window.addEvent('domready', function(){
	$$('.mb').addEvent('click',function(){
		window.open( '{/literal}{url name="site1_traffic" action="browse"}?browse{literal}', '_blank' ).focus();
	});
});{/literal}
</script>