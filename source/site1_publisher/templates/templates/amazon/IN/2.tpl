<div id="item_{$ASIN}">
	<div class="amz_box">
		<div class="amz_left_box">
			<a title="{$title}" href="{$link}">
				<img alt="{$title}" src="{$LargeImage}" />
			</a>
		</div>
		<div class="amz_right_box">
			<b>Rating:</b>&nbsp;<img src="{Zend_Registry::get( 'config' )->domain->url}{Zend_Registry::get( 'config' )->path->html->user_files}publishing/amazon/0/stars/{$stars}stars.png" /><br/>
			<div class="hide_list_price"><b>List Price:&nbsp;</b><span class="amz_list_price">&nbsp;{$oldPrice}</span><br/></div>
			<b>Sale Price:</b>&nbsp;<span class="amz_sale_price">{$smallPrice}</span><br/>
			<b>Availability:</b>&nbsp;{$availability}<br/>
			<br/><br/>
			<a target="_blank" href="{$link}" class="amz_more_info">
				<img src="images/more_info.png"/>
			</a>
		</div>
	</div>
	<div class="amz_clearfix">&nbsp;</div>
	<div class="amz_content_box">
		<div class="hide_description"><span class="amz_details_header">Product Description</span><br/><p class="check_body">{$body}</p><br/></div>
		<div class="hide_feature"><span class="amz_details_header">Details</span><br /><p class="check_feature">{$feature}</p><br /></div>
		<div class="hide_related_items"><br/><span class="amz_details_header">Related Items</span><br/><p class="check_related_items">{$relatedItems}</p><br/></div>
		<center>
			<a target="_blank" href="{$link}" class="amz_more_info">
				<img src="images/more_info.png"/>
			</a>
		</center>
		<br/>
	</div>
</div>
<script type="text/javascript">
var amItem=document.getElementById('item_{$ASIN}');
if( amItem.getElementsByClassName("amz_list_price")[0].innerHTML == amItem.getElementsByClassName("amz_sale_price")[0].innerHTML || amItem.getElementsByClassName("amz_list_price")[0].innerHTML == '&nbsp;0.00' ){
	amItem.getElementsByClassName("hide_list_price")[0].style.display='none';
}
if( amItem.getElementsByClassName("check_related_items")[0].innerHTML == '' ){
	amItem.getElementsByClassName("hide_related_items")[0].style.display='none';
}
if( amItem.getElementsByClassName("check_feature")[0].innerHTML == '' ){
	amItem.getElementsByClassName("hide_feature")[0].style.display='none';
}
if( amItem.getElementsByClassName("check_body")[0].innerHTML == '' ){
	amItem.getElementsByClassName("hide_description")[0].style.display='none';
}
</script>
<style text="text/css">
#item_{$ASIN} img{
	border: 0px;
	float:none;
}
#item_{$ASIN} .amz_clearfix{
	float: left;
	position:relative;
	width:100%;
}
#item_{$ASIN} .amz_box{
	border-style:none;
	align:center;
	width:100%;
	background-color:transparent;
	padding:0px;
	float: left;
	position:relative;
}
#item_{$ASIN} .amz_left_box{
	vertical-align:top;
	border-style:none;
	background-color:transparent;
	padding:0px;
	margin:0px;
	width:40%;
	float:left;
	position:relative;
}
#item_{$ASIN} .amz_left_box a{
	padding:10px 10px;
	text-decoration:none;
	border-style:none;
	position:relative;
	width:100%;
}
#item_{$ASIN} .amz_left_box a img{
	position:relative;
	max-width:450px;
}
#item_{$ASIN} .amz_right_box{
	vertical-align:top;
	font-size:14px;
	border-style:none;
	background-color:transparent;
	padding:0 1% 0 1%;
	margin:0px;
	float:left;
	position:relative;
	width:58%;
}
#item_{$ASIN} .amz_right_box .amz_list_price{
	color:red;
	text-decoration:line-through;
}
#item_{$ASIN} .amz_right_box .amz_sale_price{
	font-weight:bold;
	color:green;
}
#item_{$ASIN} .amz_content_box{
	float: left;
	position:relative;
	width:100%;
}
#item_{$ASIN} .amz_more_info{
	padding:10px 10px;
	text-decoration:none;
	border-style:none;
}
#item_{$ASIN} .amz_details_header{
	font-size:15px;
	font-weight:bold;
}
@media all and (max-device-width: 800px) {
	#item_{$ASIN} .amz_left_box{
		width:100%;
	}
	#item_{$ASIN} .amz_left_box a img{
		position:relative;
		width:90%;
	}
}
</style>