<div class="form-group" xmlns="http://www.w3.org/1999/html">
	<fieldset>
		<div class="form-group">
			<label>Admin Email</label>
			<input type="text" class="text-input medium-input form-control" title="Amin Email"  value="{$arrBlog.admin_email}" name="arrBlog[admin_email]" /><p id="emailAdvice"></p>
		</div>
		<div class="form-group">
			<label>Number of Post Per Page</label>
			<input type="text" class="text-input medium-input form-control" title="Number of Post Per Page"  value="{if !$arrBlog.post_perpage}10{else}{$arrBlog.post_perpage}{/if}" name="arrBlog[post_perpage]" value="10" />
		</div>
		<div class="form-group">
			<label>Permalink Structure</label>
			<select name="arrBlog[flg_permalink]" class="medium-input btn dropdown-toggle btn-info">
				{foreach from=$arrPermalink item=i key=k}
				<option {if $arrBlog.flg_permalink == $k}selected='1'{/if} value="{$k}">{$i}
				{/foreach}
			</select>
		</div>
		<div class="form-group">
			<label>Posts Per RSS Feed</label>
			<input type="text" name="arrBlog[post_per_rss]" title="Posts Per RSS Feed" class="text-input medium-input form-control" value="{if !$arrBlog.post_per_rss}10{else}{$arrBlog.post_per_rss}{/if}">
		</div>
		{if !$arrBlog.id}
		<div class="form-group">
			<label>Create Default "Hello World" Post & "About" Page?</label>
			<div class="radio radio-primary">
				<input type="radio" name="arrBlog[create_default_pages]" value="1" {if !isset($arrBlog.create_default_pages) || $arrBlog.create_default_pages == 1}checked=""{/if}>
				<label>Yes</label>
			</div>
			<div class="radio radio-primary">
				<input type="radio" name="arrBlog[create_default_pages]" {if $arrBlog.create_default_pages == 0}checked='1'{/if} value="0">
				<label>No</label>
			</div>
		</div>
		{/if}
		<div class="form-group">
			<label>Activate blogroll & links block?</label>
			<div class="radio radio-primary">
				<input type="radio" name="arrBlog[flg_blogroll_links]" value="1" {if !isset($arrBlog.flg_blogroll_links) || $arrBlog.flg_blogroll_links == 1}checked=""{/if}>
				<label>Yes</label>
			</div>
			<div class="radio radio-primary">
				<input type="radio" name="arrBlog[flg_blogroll_links]" value="0" {if $arrBlog.flg_blogroll_links == 0}checked=""{/if}>
				<label>No</label>
			</div>
		</div>
		<div class="form-group">
			<label>Show Full Text or Summary in Feed?</label>
			<div class="radio radio-primary">
				<input type="radio" name="arrBlog[flg_summary]" value="0" {if !isset($arrBlog.flg_summary) || $arrBlog.flg_summary == 0}checked=""{/if} />
				<label>Full text</label>
			</div>
			<div class="radio radio-primary">
				<input type="radio" name="arrBlog[flg_summary]" value="1" {if $arrBlog.flg_summary == 1}checked=""{/if} />
				<label>Summary</label>
			</div>
		</div>
		<div class="form-group">
			<legend>Post Comments Status</legend>
			<div class="radio radio-primary">
				<input type="radio" name="arrBlog[flg_comment_status]" value="0" {if !isset($arrBlog.flg_comment_status) || $arrBlog.flg_comment_status == 0}checked=""{/if}>
				<label>Open</label>
			</div>
			<div class="radio radio-primary">
				<input type="radio" name="arrBlog[flg_comment_status]" value="1" {if $arrBlog.flg_comment_status == 1}checked=""{/if}>
				<label>Closed</label>
			</div>
		</div>
		<div class="form-group">
			<label>Comments to be Moderated?</label>
			<div class="radio radio-primary">
				<input type="radio" name="arrBlog[flg_comment_moderated]" value="0" {if !isset($arrBlog.flg_comment_moderated) || $arrBlog.flg_comment_moderated == 0}checked=""{/if}>
				<label>Yes</label>
			</div>
			<div class="radio radio-primary">
				<input type="radio" name="arrBlog[flg_comment_moderated]" value="1" {if $arrBlog.flg_comment_moderated == 1}checked=""{/if}>
				<label>No</label>
			</div>
		</div>
		<div class="form-group">
			<label>Notify By Email on New Comment?</label>
			<div class="radio radio-primary">
				<input type="radio" name="arrBlog[flg_comment_notification]" value="0" {if !isset($arrBlog.flg_comment_notification) || $arrBlog.flg_comment_notification == 0}checked=""{/if}>
				<label>Yes</label>
			</div>
			<div class="radio radio-primary">
				<input type="radio" name="arrBlog[flg_comment_notification]" value="1" {if $arrBlog.flg_comment_notification == 1}checked=""{/if}>
				<label>No</label>
			</div>
		</div>
		<div class="form-group">
			<label>Post Pingbacks Status</label>
			<div class="radio radio-primary">
				<input type="radio" name="arrBlog[flg_ping_status]" value="0" {if !isset($arrBlog.flg_ping_status) || $arrBlog.flg_ping_status == 0}checked=""{/if}>
				<label>Open</label>
			</div>
			<div class="radio radio-primary">
				<input type="radio" name="arrBlog[flg_ping_status]" value="1" {if $arrBlog.flg_ping_status == 1}checked=""{/if}>
				<label>Closed</label>
			</div>
		</div>
		<div class="form-group">
			<label>Ping Sites on New Post?</label>
			<div class="radio radio-primary">
				<input type="radio" name="arrBlog[flg_ping_newpost]" value="0" {if !isset($arrBlog.flg_ping_newpost) || $arrBlog.flg_ping_newpost == 0}checked=""{/if} />
				<label>Yes</label>
			</div>
			<div class="radio radio-primary">
				<input type="radio" name="arrBlog[flg_ping_newpost]" value="1" {if $arrBlog.flg_ping_newpost == 1}checked=""{/if} />
				<label>No</label>
			</div>
		</div>
		<div class="form-group">
			<label>List of Sites to Ping</label>
			<textarea style="height:100px" class="text-input textarea form-control" name="arrBlog[pingsite_list]">{$arrBlog.pingsite_list}</textarea>
			<small>Select from list: <a href="#mbtest" rel="type:element,width:900,height:400"  class="mb"> Popup with ping services</a></small>
				
			<div style="display:none;">
				<div  id="mbtest">
					General Ping Services:
					<table>
						<tr>
							<td align="left" valign="top">
								http://1470.net/api/ping<br/>
								http://www.a2b.cc/setloc/bp.a2b<br/>
								http://api.feedster.com/ping<br/>
								http://api.moreover.com/RPC2<br/>
								http://api.moreover.com/ping<br/>
								http://api.my.yahoo.com/RPC2<br/>
								http://api.my.yahoo.com/rss/ping<br/>
								http://www.bitacoles.net/ping.php<br/>
								http://bitacoras.net/ping<br/>
								http://blogdb.jp/xmlrpc<br/>
								http://www.blogdigger.com/RPC2<br/>
								http://blogmatcher.com/u.php<br/>
								http://www.blogoole.com/ping/<br/>
								http://www.blogoon.net/ping/<br/>
								http://www.blogpeople.net/servlet/weblogUpdates<br/>
								http://www.blogroots.com/tb_populi.blog?id=1<br/>
								http://www.blogshares.com/rpc.php<br/>
								http://www.blogsnow.com/ping<br/>
								http://www.blogstreet.com/xrbin/xmlrpc.cgi<br/>
								http://blog.goo.ne.jp/XMLRPC<br/>		
								http://bulkfeeds.net/rpc<br/>
								http://coreblog.org/ping/<br/>		
								http://www.lasermemory.com/lsrpc/<br/>
							</td>
							<td align="left" valign="top">
								http://mod-pubsub.org/kn_apps/blogchatt<br/>
								http://www.mod-pubsub.org/kn_apps/blogchatter/ping.php<br/>
								http://www.newsisfree.com/xmlrpctest.php<br/>
								http://ping.amagle.com/<br/>
								http://ping.bitacoras.com<br/>
								http://ping.blo.gs/<br/>
								http://ping.bloggers.jp/rpc/<br/>
								http://ping.blogmura.jp/rpc/<br/>
								http://ping.cocolog-nifty.com/xmlrpc<br/>
								http://ping.exblog.jp/xmlrpc<br/>
								http://ping.feedburner.com<br/>
								http://ping.myblog.jp<br/>
								http://ping.rootblog.com/rpc.php<br/>
								http://ping.syndic8.com/xmlrpc.php<br/>
								http://ping.weblogalot.com/rpc.php<br/>
								http://ping.weblogs.se/<br/>
								http://pingoat.com/goat/RPC2<br/>
								http://www.popdex.com/addsite.php<br/>
								http://rcs.datashed.net/RPC2/<br/>
								http://rpc.blogbuzzmachine.com/RPC2<br/>
								http://rpc.blogrolling.com/pinger/<br/>
								http://rpc.icerocket.com:10080/<br/>		
								http://rpc.pingomatic.com/<br/>
								http://rpc.technorati.com/rpc/ping<br/>
							</td>
							<td valign="top" align="left">
								http://rpc.weblogs.com/RPC2<br/>
								http://www.snipsnap.org/RPC2<br/>
								http://trackback.bakeinu.jp/bakeping.php<br/>
								http://topicexchange.com/RPC2<br/>
								http://www.weblogues.com/RPC/<br/>
								http://xping.pubsub.com/ping/<br/>
								http://xmlrpc.blogg.de/<br/>
								<br/><br/>
								Special Ping Services:<br/>
								These ping services are for users of a<br/> 
								particular language, blogging platform, <br/>
								or other unique flavor, and are included <br/>
								for completeness only. <br/>
								DonтАЩt ping them unless you really know<br/> 
								you want to, and fit their user demographic.<br/>
								<br/><br/>
								http://bblog.com/ping.php<br/>
								http://blogbot.dk/io/xml-rpc.php<br/>
								http://www.catapings.com/ping.php<br/>
								http://effbot.org/rpc/ping.cgi<br/>
								http://thingamablog.sourceforge.net/ping.php<br/>		
							</td>
						</tr>
					</table>
					<br/><br/>
				</div>
			</div>
		</div>
		<div class="form-group">
			<a href="#" class="acc_prev button">Prev step</a>
		</div>
	</fieldset>
</div>