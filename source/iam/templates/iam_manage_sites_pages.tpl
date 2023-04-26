<div>
{if !$arrList}
	<div style="float:left; width: 100%">
		Select IAM templates <a href="{url name='iam' action='manage_templates'}">HERE</a>
	</div>
{else}
	<input type="button" value="Stop Check" id="stop"/>
	<form action="" id="current-form" method="post">
		<table class="info glow" style="width:90%;">
			<thead>
				<tr>
					<th><span id="load_percent_title">Page URLs</span> <span id="load_percent"></span></th>
				</tr>
			</thead>
			<tbody>
			{foreach from=$arrList key='k' item='v'}
				<tr{if $k%2=='0'} class="alt-row"{/if}>
					<td style="padding-right:0;">
						{*<a href="?backup_id={$v.id}">Download Backup</a><br/>*}
						<p rel="{$v.id}" href="{$v.url}" class="home_page check_pages" data-url="{$v.url}index.html">{$v.url}index-z-[MM_Member_Data name='customField_1'].html</p>
					</td>
				</tr>
			{/foreach}
			</tbody>
		</table>
	</form>
{/if}
</div>
{literal}
<script type="text/javascript">
var allPages=$$('.home_page').length;
var allChecked=0;
var flgStopCheck=false;
$('stop').addEvent( 'click', function() {
	flgStopCheck=true;
});
var loadPages=function(){
	if( flgStopCheck ){
		return;
	}
	var counter = $$('.home_page').length;
	if( counter > 0 ){
		new Request({
			url: '',
			onComplete:function( string ){
				Array.each( JSON.decode( string ), function(item){
					new Element('p',{
							'data-url':$$('.home_page')[0].get('href')+item.link+".html",
							'class':'check_pages',
							html: $$('.home_page')[0].get('href')+item.link+"-z-[MM_Member_Data name='customField_1'].html"
						})
						.inject(
							$$('.home_page')[0],
							'before'
						);
				});
				$$('.home_page')[0].removeClass('home_page');
				$('load_percent').set('html', ( (allPages-counter)*100/allPages ).toFixed(2)+'%' );
				loadPages();
			}
		}).post({ 'site_id':$$('.home_page')[0].get('rel') });
	}else{
		allChecked=$$('.check_pages').length;
		updatePages();
		$('load_percent_title').set('html', 'Check inside urls: ' );
		$('load_percent').set('html', '0%' );
	}
}
var updatePages=function(){
	var counter = $$('.check_pages').length;
	if( counter > 0 ){
		new Request({
			url: '',
			onComplete:function( string ){
				//console.log('next load ');
				//console.log($$('.home_page')[0]);
				Array.each( JSON.decode( string ), function(item){
					//console.log( $$('.home_page')[0].get('href')+item.link+"-z-[MM_Member_Data name='customField_1'].html" );
					new Element('p',{'style':'padding-left:10px;color:red;',html:item})
						.inject(
							$$('.check_pages')[0],
							'after'
						);
				});
				$$('.check_pages')[0].removeClass('check_pages');
				$('load_percent').set('html', ( (allChecked-counter)*100/allChecked ).toFixed(2)+'%' );
				updatePages();
			}
		}).post({ 'page_url':$$('.check_pages')[0].get('data-url') });
	}else{
		$('load_percent_title').set('html', 'End' );
		$('load_percent').set('html', '' );
	}
}
window.addEvent('domready', function(){
	loadPages();
});
</script>
{/literal}