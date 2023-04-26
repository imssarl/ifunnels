{include file='../../box-top.tpl' title=$arrNest.title}
<form action="" method="POST" class="wh validate">
<fieldset>
	<legend>Search terms</legend>
	<div class="form-group">
		<label>Enter your keyword <em>*</em>:</label>
		<textarea name="keywords" id="keywords" class="required medium-input form-control" style="height:27px">{if !$smarty.post.keywords}Example: adobe photoshop cs4{else}{$smarty.post.keywords}{/if}</textarea>
	</div>
</fieldset>
<fieldset>
	<legend>Filters</legend>
	<div class="form-group">
		<label>Scope:</label>
		<select name="scope" class="medium-input btn-group selectpicker show-tick">
			<option {if $smarty.post.scope == 'google' || !$smarty.post.scope}selected='1'{/if} value="google">Web search
			<option {if $smarty.post.scope == 'images'}selected='1'{/if} value="images">Images search
			<option {if $smarty.post.scope == 'news'}selected='1'{/if} value="news">News search
			<option {if $smarty.post.scope == 'froogle'}selected='1'{/if} value="froogle">Product search
			<option {if $smarty.post.scope == 'youtube'}selected='1'{/if} value="youtube">YouTube Search
		</select>
	</div>
	<div class="form-group">
		<label><span>Date:</span></label>
		<select name="time" class="medium-input btn-group selectpicker show-tick">
			<option {if $smarty.post.time == 'all'}selected='1'{/if}  value="all">2004 - present
			<option {if $smarty.post.time == 'today 7-d'}selected='1'{/if}  value="today 7-d">Last 7 days
			<option {if $smarty.post.time == 'today 1-m'}selected='1'{/if}  value="today 1-m">Last 30 days
			<option {if !$smarty.post.time || $smarty.post.time == 'today 3-m'}selected='1'{/if}  value="today 3-m">Last 90 days
			<option {if $smarty.post.time == 'today 12-m'}selected='1'{/if}  value="today 12-m">Last year
		</select>
	</div>
	<div class="form-group">
		<button id="display" type="submit" class="button btn btn-success waves-effect waves-light" {is_acs_write}>Display Trends</button>
	</div>
</fieldset>
{if $google_display}
<fieldset>
	<legend>{if $smarty.post.scope == 'empty'}Web&nbsp;search
		{elseif $smarty.post.scope == 'images'}Images&nbsp;search
		{elseif $smarty.post.scope == 'news'}News&nbsp;search
		{elseif $smarty.post.scope == 'froogle'}Product&nbsp;search
		{elseif $smarty.post.scope == 'youtube'}YouTube&nbsp;search
		{/if}</legend>
		<div align="center">
			<iframe src="//www.google.com/trends/fetchComponent?hl=en-US&q={$keywords}&cid=TIMESERIES_GRAPH_0&export=5&w=800&h=400&date={$time}&gprop={$scope}" width="700px" height="295px" scrolling="no"></iframe>
			<iframe sandbox src="//www.google.com/trends/fetchComponent?hl=en-US&q={$keywords}&geo=US&cid=RISING_QUERIES_0_0&output=embed" width="700px" height="300px"></iframe>
			<iframe sandbox src="//www.google.com/trends/fetchComponent?hl=en-US&q={$keywords}&geo=US&cid=RISING_QUERIES_1_0&output=embed" width="700px" height="300px"></iframe>
		</div>
</fieldset>
{/if}
</form>
{literal}
<script>
$('keywords').addEvent('click', function(){
	if( $('keywords').value == 'Example: adobe photoshop cs4') {
		$('keywords').value = '';
	}
});
$('keywords').addEvent('blur', function(){
	if( $('keywords').value == '') {
		$('keywords').value = 'Example: adobe photoshop cs4';
	}
});
</script>
{/literal}
{include file='../../box-bottom.tpl'}