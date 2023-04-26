<!DOCTYPE html>
<html lang="en">
	<head>
		<title>Editor</title>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<meta charset="utf-8">
		<link href="{Zend_Registry::get('config')->path->html->pagebuilder}build/file_editor.css" rel="stylesheet" />
		<style>
			#editor {
				position: absolute;
				width: 100%;
				height: 100%;
			}
		</style>
		{literal}
		<script>
			var file = '{/literal}{urlencode($arrBlock.blocks_url)}{literal}';
			var baseUrl = '{/literal}{if !empty($smarty.server.HTTPS) && 'off' !== strtolower($smarty.server.HTTPS)}https://{else}http://{/if}{$smarty.server.HTTP_HOST}{Zend_Registry::get('config')->path->html->pagebuilder}{literal}';
			var siteUrl = '{/literal}{if !empty($smarty.server.HTTPS) && 'off' !== strtolower($smarty.server.HTTPS)}https://{else}http://{/if}{$smarty.server.HTTP_HOST}/{literal}';
			var dataUrls = {
				file_load : '{/literal}{url name="site1_ecom_funnels" action="load_file"}{literal}',
				save_file : '{/literal}{url name="site1_ecom_funnels" action="save_file"}{literal}'
			};
		</script>
		{/literal}
	</head>
	<body>

		<div id="topbar">

			<div class="editing">
				<span class="fui-arrow-right"></span> {$arrBlock.blocks_url}
			</div>

			<button class="btn btn-danger btn-sm pull-right"
				data-toggle="confirmation" data-placement="bottom" data-title="Close
				editor?"
				data-content="Your changes will NOT be saved"
				data-btn-ok-label="Yes"
				data-btn-cancel-label="No"
				data-popout="true" data-on-confirm="closeEditor"
				data-singleton="true">
				<span class="fui-cross-circle"></span>
				Close editor
			</button>
			<button class="btn btn-primary btn-sm pull-right" id="buttonSaveFile"
				data-toggle="confirmation" data-placement="bottom" data-title="Are you
				sure?"
				data-content="This would overwrite the file's content and can not be
				undone."
				data-btn-ok-label="Yes"
				data-btn-cancel-label="No"
				data-popout="true" data-on-confirm="updateFile"
				data-singleton="true">
				<span class="fui-check-circle"></span>
				Save file
			</button>
		</div>
		<div id="editor"></div>

		<!-- Load JS here for greater good =============================-->
		<script src="{Zend_Registry::get('config')->path->html->pagebuilder}build/file_editor.bundle.js"></script>
	</body>
</html>