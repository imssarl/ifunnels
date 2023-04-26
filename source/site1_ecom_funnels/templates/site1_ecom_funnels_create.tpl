<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">

	<base href="{if !empty($smarty.server.HTTPS) && 'off' !== strtolower($smarty.server.HTTPS)}https://{else}http://{/if}{$smarty.server.HTTP_HOST}/">

	<title>Builder</title>

	<link href="/skin/pagebuilder/build/builder.css" rel="stylesheet">
	<link rel="stylesheet" href="/skin/ifunnels-studio/dist/css/lockscreen.bundle.css">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">

	<!-- HTML5 shim, for IE6-8 support of HTML5 elements. All other JS at the end of file. -->
	<!--[if lt IE 9]>
	<script src="/skin/pagebuilder/assets/js/html5shiv.js"></script>
	<script src="/skin/pagebuilder/assets/js/respond.min.js"></script>
	<![endif]-->
	<!--[if lt IE 10]>
	<link href="/skin/pagebuilder/assets/css/ie-masonry.css" rel="stylesheet">
	<script src="/skin/pagebuilder/assets/js/masonry.pkgd.min.js"></script>
	<![endif]-->

	{literal}
	<script>
		var baseUrl = '{/literal}{if !empty($smarty.server.HTTPS) && 'off' !== strtolower($smarty.server.HTTPS)}https://{else}http://{/if}{$smarty.server.HTTP_HOST}/{literal}';
		var siteUrl = '{/literal}{if !empty($smarty.server.HTTPS) && 'off' !== strtolower($smarty.server.HTTPS)}https://{else}http://{/if}{$smarty.server.HTTP_HOST}/{literal}';
		var dataURLs = {
			siteData: '{/literal}{url name="site1_ecom_funnels" action="siteData" w="id={$smarty.get.id}"}{literal}',
			pageDataUrl: '{/literal}{url name="site1_ecom_funnels" action="pageData"}{literal}',
			loadAll: '{/literal}{url name="site1_ecom_funnels" action="loadAll"}{literal}',
			getframe: '{/literal}{url name="site1_ecom_funnels" action="getframe"}{literal}',
			save: '{/literal}{url name="site1_ecom_funnels" action="save"}{literal}',
			create: '{/literal}{url name="site1_ecom_funnels" action="create"}{literal}',
			favoriteblock: '{/literal}{url name="site1_ecom_funnels" action="favoriteblock"}{literal}',
			deleteblock: '{/literal}{url name="site1_ecom_funnels" action="deleteblock"}{literal}',
			delimage: '{/literal}{url name="site1_ecom_funnels" action="delimage"}{literal}',
			uploadTemplate: '{/literal}{url name="site1_ecom_funnels" action="updateTemplate"}{literal}',
			getLeadChannelsForm: '{/literal}{url name="site1_ecom_funnels" action="getLeadChannelsForm"}{literal}',
			resizeImage: '{/literal}{url name="site1_ecom_funnels" action="resizeImage"}{literal}',
			sendEmail: 'services/ifunnels.php',
			saveAsTemplate: '{/literal}{url name="site1_ecom_funnels" action="save_as_template"}{literal}',
			ajax: '{/literal}{url name="site1_ecom_funnels" action="ajax"}{literal}',
		};
		var showModal = {/literal}{if !empty($smarty.get.id)} false{else} true{/if}{literal};
		var beforeSaveMessage = 'Your changes will be saved now. Please wait until the process finishes.';
		var isSigned = true;
		var isTemplate = false;

		var lockscreen = {
			requestUrl : '{/literal}{url name="site1_ecom_funnels" action="auth"}{literal}',
			authUrl : '{/literal}{url name="site1_ecom_funnels" action="auth" w="auth"}{literal}',
		};
	</script>
	{/literal}

</head>

<body class="builderUI">

	<div class="side" id="fixedSidebar">

		<nav>
			<button data-side="templates">
				<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
				 viewBox="0 0 64 64" xml:space="preserve" width="64" height="64">
					<g class="nc-icon-wrapper" fill="#bdc3c7">
						<path data-color="color-2" fill="#bdc3c7" d="M63,20V7c0-1.105-0.895-2-2-2H3C1.895,5,1,5.895,1,7v13H63z"></path>
						<path fill="#bdc3c7" d="M19,22H1v35c0,1.105,0.895,2,2,2h16V22z"></path>
						<path fill="#bdc3c7" d="M21,22v37h40c1.105,0,2-0.895,2-2V22H21z"></path>
					</g>
				</svg>
				<span>templates</span>
			</button>
			<button data-side="blocks">
				<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
				 viewBox="0 0 64 64" xml:space="preserve" width="64" height="64">
					<g class="nc-icon-wrapper" fill="#bdc3c7">
						<path fill="#bdc3c7" d="M53,25H11c-1.105,0-2-0.895-2-2V3c0-1.105,0.895-2,2-2h42c1.105,0,2,0.895,2,2v20C55,24.105,54.105,25,53,25 z"></path>
						<path fill="#bdc3c7" d="M53,63H11c-1.105,0-2-0.895-2-2V41c0-1.105,0.895-2,2-2h42c1.105,0,2,0.895,2,2v20 C55,62.105,54.105,63,53,63z"></path>
						<path data-color="color-2" fill="#bdc3c7" d="M62,33H2c-0.553,0-1-0.448-1-1s0.447-1,1-1h60c0.553,0,1,0.448,1,1S62.553,33,62,33z"></path>
					</g>
				</svg>
				<span>blocks</span>
			</button>
			<button data-side="components">
				<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
				 viewBox="0 0 64 64" xml:space="preserve" width="64" height="64">
					<g class="nc-icon-wrapper" fill="#bdc3c7">
						<path fill="#bdc3c7" d="M27,36H6c-0.552,0-1-0.448-1-1V2c0-0.552,0.448-1,1-1h21c0.552,0,1,0.448,1,1v33C28,35.552,27.552,36,27,36z "></path>
						<path data-color="color-2" fill="#bdc3c7" d="M27,63H6c-0.552,0-1-0.448-1-1V45c0-0.552,0.448-1,1-1h21c0.552,0,1,0.448,1,1v17 C28,62.552,27.552,63,27,63z"></path>
						<path data-color="color-2" fill="#bdc3c7" d="M58,20H37c-0.552,0-1-0.448-1-1V2c0-0.552,0.448-1,1-1h21c0.552,0,1,0.448,1,1v17 C59,19.552,58.552,20,58,20z"></path>
						<path fill="#bdc3c7" d="M58,63H37c-0.552,0-1-0.448-1-1V29c0-0.552,0.448-1,1-1h21c0.552,0,1,0.448,1,1v33 C59,62.552,58.552,63,58,63z"></path>
					</g>
				</svg>
				<span>components</span>
			</button>
			<button data-side="pages">
				<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
				 viewBox="0 0 64 64" xml:space="preserve" width="64" height="64">
					<g class="nc-icon-wrapper" fill="#bdc3c7">
						<path fill="#bdc3c7" d="M43,17H5c-1.105,0-2,0.895-2,2v42c0,1.105,0.895,2,2,2h38c1.105,0,2-0.895,2-2V19C45,17.895,44.105,17,43,17 z"></path>
						<path data-color="color-2" fill="#bdc3c7" d="M59,47h-4V9c0-1.105-0.895-2-2-2H19V3c0-1.105,0.895-2,2-2h38c1.105,0,2,0.895,2,2v42 C61,46.105,60.105,47,59,47z"></path>
						<path data-color="color-2" fill="#bdc3c7" d="M51,55h-4V17c0-1.105-0.895-2-2-2H11v-4c0-1.105,0.895-2,2-2h38c1.105,0,2,0.895,2,2v42 C53,54.105,52.105,55,51,55z"></path>
					</g>
				</svg>
				<span>pages</span>
			</button>
			<button data-side="popups">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" width="64" height="64">
					<title>open in browser</title>
					<g class="nc-icon-wrapper" fill="#bdc3c7">
						<path data-color="color-2" d="M32.8,22.4l12,16c0.229,0.303,0.263,0.708,0.095,1.047C44.725,39.786,44.379,40,44,40H34v21 c0,0.552-0.448,1-1,1h-2c-0.552,0-1-0.448-1-1V40H20c-0.379,0-0.725-0.214-0.895-0.553C19.035,39.306,19,39.152,19,39 c0-0.212,0.067-0.424,0.2-0.6l12-16c0.188-0.252,0.485-0.4,0.8-0.4S32.611,22.148,32.8,22.4z"></path> 
						<path fill="#bdc3c7" d="M61,1H3C1.895,1,1,1.895,1,3v46c0,1.105,0.895,2,2,2h21v-2H4c-0.552,0-1-0.448-1-1V14c0-0.552,0.448-1,1-1 h56c0.552,0,1,0.448,1,1v34c0,0.552-0.448,1-1,1H40v2h21c1.105,0,2-0.895,2-2V3C63,1.895,62.105,1,61,1z M7,9C5.895,9,5,8.105,5,7 s0.895-2,2-2c1.105,0,2,0.895,2,2S8.105,9,7,9z M14,9c-1.105,0-2-0.895-2-2s0.895-2,2-2c1.105,0,2,0.895,2,2S15.105,9,14,9z M21,9 c-1.105,0-2-0.895-2-2s0.895-2,2-2c1.105,0,2,0.895,2,2S22.105,9,21,9z"></path>
					</g>
				</svg>
                <span>Popups</span>
			</button>
		</nav>

	</div><!-- /.side -->

	<header class="clearfix">

		<div class="btn-group" style="float: right;">
			<button class="btn btn-inverse dropdown-toggle" data-toggle="dropdown">
				<i class="caret"></i>
			</button>
			<span class="dropdown-arrow dropdown-arrow-inverse"></span>
			<ul class="dropdown-menu dropdown-menu-inverse dropdown-menu-right">
				<li>
					<a href="#siteSettings" id="siteSettingsButton" class="siteSettingsModalButton" data-siteid="1">
						<span class="fui-arrow-right"></span>
						Site Settings </a>
				</li>
				<li>
					<a href="#pageSettingsModal" id="pageSettingsButton" data-toggle="modal" data-siteid="1">
						<span class="fui-arrow-right"></span>
						Page Settings </a>
				</li>
				<li class="divider"></li>
				<li>
					<a href="{url name="site1_ecom_funnels" action="manage"}" id="backButton">
						<span class="fui-arrow-left"></span>
						Exit the builder </a>
				</li>
			</ul>
		</div>

		<a href="#" id="publishPage" class="btn btn-inverse pull-right actionButtons slick">
			<i class="fui-upload"></i>
			<span class="slide">Upload</span>
			<i class="fui-alert text-danger"></i>
		</a>

		<a href="#previewModal" data-toggle="modal" class="btn btn-inverse btn-embossed pull-right slick" style="display: none" id="buttonPreview">
			<i class="fui-window"></i>
			<span class="slide">Preview</span>
		</a>

		<div class="btn-group" style="float: right;">
			<button class="btn btn-primary" id="savePage" data-loading="Saving..." data-label="Nothing to save" data-label2="{if !empty($siteData.site.settings)}Save & Publish (!){else}Save now (!){/if}">
				<span class="fui-check"></span>
				<span class="bLabel">Nothing to save</span>
				{if Core_Acs::haveAccess( array('email test group') )}
				<ul>
					<li><a href="#">Save as Template</a></li>
				</ul>
				{/if}
			</button>
		</div>

		<ul class="nav nav-pills nav-inverse pull-left responsiveToggle" id="responsiveToggle">
			<li>
				<a href="" data-responsive="mobile">
					<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
					 viewBox="0 0 16 16" xml:space="preserve" width="16" height="16">
						<g class="nc-icon-wrapper" fill="#bdc3c7">
							<path fill="#bdc3c7" d="M12,0H4C2.897,0,2,0.897,2,2v12c0,1.103,0.897,2,2,2h8c1.103,0,2-0.897,2-2V2C14,0.897,13.103,0,12,0z M8,14 c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S8.552,14,8,14z M12,10H4V2h8V10z"></path>
						</g>
					</svg>
				</a>
			</li>
			<li>
				<a href="" data-responsive="tablet">
					<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
					 viewBox="0 0 16 16" xml:space="preserve" width="16" height="16">
						<g class="nc-icon-wrapper" fill="#bdc3c7">
							<path fill="#bdc3c7" d="M13,0H3C1.895,0,1,0.895,1,2v12c0,1.105,0.895,2,2,2h10c1.105,0,2-0.895,2-2V2C15,0.895,14.105,0,13,0z M8,14c-0.552,0-1-0.448-1-1c0-0.552,0.448-1,1-1s1,0.448,1,1C9,13.552,8.552,14,8,14z M13,10H3V2h10V10z"></path>
						</g>
					</svg>
				</a>
			</li>
			<li class="active">
				<a href="" data-responsive="desktop">
					<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
					 viewBox="0 0 16 16" xml:space="preserve" width="16" height="16">
						<g class="nc-icon-wrapper" fill="#bdc3c7">
							<path fill="#bdc3c7" d="M15,0H1C0.4,0,0,0.4,0,1v11c0,0.6,0.4,1,1,1h5v1H3v2h10v-2h-3v-1h5c0.6,0,1-0.4,1-1V1C16,0.4,15.6,0,15,0z M14,2v7H2V2H14z"></path>
						</g>
					</svg>
				</a>
			</li>
		</ul>

		<div class="gridViewToggle">
			<div class="bootstrap-switch-square">
				<input type="checkbox" data-toggle="switch" data-on-text='<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 16 16" xml:space="preserve" width="16" height="16"><g class="nc-icon-wrapper" fill="#00b591"><path fill="#00b591" d="M15,0H1C0.4,0,0,0.4,0,1v14c0,0.6,0.4,1,1,1h14c0.6,0,1-0.4,1-1V1C16,0.4,15.6,0,15,0z M14,7H9V2h5V7z M7,2 v5H2V2H7z M2,9h5v5H2V9z M9,14V9h5v5H9z"></path></g></svg>'
				 data-off-text='<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 16 16" xml:space="preserve" width="16" height="16"><g class="nc-icon-wrapper" fill="#ecf0f1"><path fill="#ecf0f1" d="M15,0H1C0.4,0,0,0.4,0,1v14c0,0.6,0.4,1,1,1h14c0.6,0,1-0.4,1-1V1C16,0.4,15.6,0,15,0z M14,7H9V2h5V7z M7,2 v5H2V2H7z M2,9h5v5H2V9z M9,14V9h5v5H9z"></path></g></svg>'
				 name="default-switch" id="gridViewSwitch">
			</div>
		</div>

	</header>

	<div id="builder">

		<div class="builderLayout">

			<div class="sideSecond" data-sidesecond="blocks">

				<div class="sideSecondInner">

					<div class="heading">
						<button class="closeSideSecond" data-js="closeSideSecond">
							<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
							 viewBox="0 0 24 24" xml:space="preserve" width="24" height="24">
								<g class="nc-icon-wrapper" fill="#bdc3c7">
									<path data-color="color-2" fill="#bdc3c7" d="M22,0H10v2h11v20H10v2h12c0.553,0,1-0.447,1-1V1C23,0.447,22.553,0,22,0z"></path>
									<polygon fill="#bdc3c7" points="1,12 8,6 8,11 17,11 17,13 8,13 8,18 "></polygon>
								</g>
							</svg>
						</button>

						<h4>Blocks</h4>
					</div>

					<nav data-no-fav-blocks="You do not have any saved blocks yet..."></nav>

				</div><!-- /.sideSecondInner -->

			</div><!-- /.sideSecond -->

			<div class="sideSecond" data-sidesecond="templates">

				<div class="sideSecondInner">

					<div class="heading">
						<button class="closeSideSecond" data-js="closeSideSecond">
							<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
							 viewBox="0 0 24 24" xml:space="preserve" width="24" height="24">
								<g class="nc-icon-wrapper" fill="#bdc3c7">
									<path data-color="color-2" fill="#bdc3c7" d="M22,0H10v2h11v20H10v2h12c0.553,0,1-0.447,1-1V1C23,0.447,22.553,0,22,0z"></path>
									<polygon fill="#bdc3c7" points="1,12 8,6 8,11 17,11 17,13 8,13 8,18 "></polygon>
								</g>
							</svg>
						</button>

						<h4>Templates</h4>
					</div>

					{if !empty($arrTemplates)}
					<nav>
						<button>
							<span>All templates</span>
							<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 16 16" xml:space="preserve" width="16" height="16">
								<g class="nc-icon-wrapper" fill="#bdc3c7">
									<polygon fill="#bdc3c7" points="4.9,15.7 3.4,14.3 9.7,8 3.4,1.7 4.9,0.3 12.6,8 "></polygon>
								</g>
							</svg>
						</button>
						<ul class="">
							{foreach from=$arrTemplates item=template}
							<li class="templ" data-template-id="{$template.id}">
								<div class="lazyload-preload"></div>
								<img class="lazyload" data-src="{Zend_Registry::get('config')->path->html->pagebuilder}{$template.sitethumb}" />
							</li>
							{/foreach}
						</ul>
						
						{foreach from=$arrCategory item=category}
						{if $category.category_name !== 'No specific category'}
							<button>
								<span>{$category.category_name}</span>
								<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 16 16" xml:space="preserve" width="16" height="16">
									<g class="nc-icon-wrapper" fill="#bdc3c7">
										<polygon fill="#bdc3c7" points="4.9,15.7 3.4,14.3 9.7,8 3.4,1.7 4.9,0.3 12.6,8 "></polygon>
									</g>
								</svg>
							</button>
							<ul>
							{foreach from=$arrTemplates item=template}
								{if $category.id == $template.category_id}
								<li class="templ" data-template-id="{$template.id}">
									<div class="lazyload-preload"></div>
									<img class="lazyload" data-src="{Zend_Registry::get('config')->path->html->pagebuilder}{$template.sitethumb}" />
								</li>
								{/if}
							{/foreach}
							</ul>
						{/if}
						{/foreach}
					</nav>
					{/if}

				</div><!-- /.sideSecondInner -->

			</div><!-- /.sideSecond -->

			<div class="sideSecond" data-sidesecond="components">

				<div class="sideSecondInner">

					<div class="heading">
						<button class="closeSideSecond" data-js="closeSideSecond">
							<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
							 viewBox="0 0 24 24" xml:space="preserve" width="24" height="24">
								<g class="nc-icon-wrapper" fill="#bdc3c7">
									<path data-color="color-2" fill="#bdc3c7" d="M22,0H10v2h11v20H10v2h12c0.553,0,1-0.447,1-1V1C23,0.447,22.553,0,22,0z"></path>
									<polygon fill="#bdc3c7" points="1,12 8,6 8,11 17,11 17,13 8,13 8,18 "></polygon>
								</g>
							</svg>
						</button>

						<h4>Components</h4>
					</div>

					<nav></nav>

				</div><!-- /.sideSecondInner -->

			</div><!-- /.sideSecond -->

			<div class="sideSecond" data-sidesecond="pages">

				<div class="sideSecondInner">

					<div class="heading">
						<button class="closeSideSecond" data-js="closeSideSecond">
							<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
							 viewBox="0 0 24 24" xml:space="preserve" width="24" height="24">
								<g class="nc-icon-wrapper" fill="#bdc3c7">
									<path data-color="color-2" fill="#bdc3c7" d="M22,0H10v2h11v20H10v2h12c0.553,0,1-0.447,1-1V1C23,0.447,22.553,0,22,0z"></path>
									<polygon fill="#bdc3c7" points="1,12 8,6 8,11 17,11 17,13 8,13 8,18 "></polygon>
								</g>
							</svg>
						</button>

						<h4>Pages</h4>
					</div>

					<ul id="pages"></ul>

					<hr>
								
					<div class="buttonWrapper">
						<button class="btn btn-primary btn-lg btn-embossed" id="addPage">
							<span class="fui-plus"></span>
							Add Page </button>
					</div>

				</div><!-- /.sideSecondInner -->

			</div><!-- /.sideSecond -->

			<div class="sideSecond" data-sidesecond="popups">
				<div class="sideSecondInner">
					<div class="heading">
						<button class="closeSideSecond" data-js="closeSideSecond">
							<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 24 24" xml:space="preserve" width="24" height="24">
								<g class="nc-icon-wrapper" fill="#bdc3c7">
									<path data-color="color-2" fill="#bdc3c7" d="M22,0H10v2h11v20H10v2h12c0.553,0,1-0.447,1-1V1C23,0.447,22.553,0,22,0z"></path> 
									<polygon fill="#bdc3c7" points="1,12 8,6 8,11 17,11 17,13 8,13 8,18 "></polygon>
								</g>
							</svg>
						</button>

						<h4>Popups</h4>
					</div>
					<nav></nav>
				</div>
			</div>

			<div class="canvasWrapper">


				<div class="screen" id="screen">

					<div class="toolbar">

						<div class="buttons clearfix">
							<span class="left red"></span>
							<span class="left yellow"></span>
							<span class="left green"></span>
						</div>

						{if Core_Acs::haveAccess( array( 'iFunnels Studio Performance', 'iFunnels LTD Studio Enterprise' ) )}
						<div class="variants clearfix" id="pageVariants"></div>
						{/if}

						<div class="title clearfix">
							<span id="pageTitle">index</span>
						</div>

					</div>

					<div id="frameWrapper" class="frameWrapper empty">
						<div id="pageList">

						</div>
						<div class="start" id="start" {if isset($siteData.pages) && count($siteData.pages)> 0}style="display:none"{/if}>
							<span>Build your page by dragging blocks onto the canvas</span>
						</div>
						<div id="popups" class="popupsWrapper">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close" id="buttonClosePopups"><span aria-hidden="true">&times;</span></button>
							<div class="popupTypeSelectWrapper">
								<select class="form-control select select-sm pull-right select-info mbl" data-toggle="select" id="selectPopupType">
									<option value="Entry">Entry popup</option>
									<option value="Exit">Exit popup</option>
									<option value="Regular">Regular popup</option>
								</select>
							</div>
							<div class="wrapper">
								<div id="entryPopup" class="popupDz entry visible">
									<ul></ul>
									<div class="dzPlaceholder" id="entryDzPlaceholder"><span>Drop an entry popup here</span></div>
								</div>
								<div id="exitPopup" class="popupDz exit">
									<ul></ul>
									<div class="dzPlaceholder" id="exitDzPlaceholder"><span>Drop an exit popup here</span></div>
								</div>
								<div id="regularPopup" class="popupDz regular">
									<ul></ul>
									<div class="dzPlaceholder" id="regularDzPlaceholder"><span>Drop a regular popup here</span></div>
								</div>
							</div>
						</div><!-- /#popups -->
					</div>

				</div><!-- /.screen -->

			</div>

			<div id="styleEditor" class="styleEditor">

				<div class="styleEditorInner">

					<button class="close"><span class="fui-cross-circle"></span></button>

					<h3><span class="fui-new"></span> Detail Editor</h3>

					<ul class="breadcrumb">
						<li>editing:</li>
						<li class="active" id="editingElement">p</li>
					</ul>

					<ul class="nav nav-tabs" id="detailTabs">
						<li class="active showDefault"><a href="#tab1"><span class="fui-new"></span> Style</a></li>
						<li class="showDefault"><a href="#tabEffects"><span class="fui-new"></span> Effects</a></li>
						<li style="display: none;"><a href="#link_Tab" id="link_Link"><span class="fui-clip"></span> Link</a></li>
						<li style="display: none;"><a href="#image_Tab" id="img_Link"><span class="fui-image"></span> Image</a></li>
						<li style="display: none;"><a href="#icon_Tab" id="icon_Link"><span class="fa fa-flag"></span> Icons</a></li>
						<li style="display: none;"><a href="#video_Tab" id="video_Link"><span class="fa fa-youtube-play"></span> Video</a></li>
						<li style="display: none;"><a href="#menuitems_Tab" id="menuitems_Link"><span class="fa fa-list-ul"></span> Brand</a></li>
						<li style="display: none;"><a href="#form_Tab" id="form_Link"><span class="fa fa-file-text-o"></span> Form</a></li>
						<li style="display: none;"><a href="#slideshow_Tab" id="slideshow_Link"><span class="fa fa-cog"></span> Slider</a></li>
						<li style="display: none;"><a href="#code_Tab" id="code_Link"><span class="fa fa-code"></span> Code</a></li>
						<li style="display: none;"><a href="#setting_Tab" id="setting_Link"><span class="fa fa-gears"></span> Settings</a></li>
						<li style="display: none;"><a href="#quiz_Tab" id="quiz_Link"><span class="fa fa-gears"></span> Quiz</a></li>
						<li style="display: none;"><a href="#webinar_Tab" id="webinar_Link"><span class="fa fa-gears"></span> Chat Settings</a></a></li>
						{if Core_Acs::haveAccess( array( 'iFunnels Studio Starter', 'iFunnels LTD Studio Starter' ) )}
						<li style="display: none;"><a href="#checkout_Tab" id="checkout_Link"><span class="fa fa-credit-card" style="font-size: 15px;"></span> Checkout</a></li>
						{/if}
						<li style="display: none;"><a href="#nft_Tab" id="nft_Link"><i class="fa fa-wrench" aria-hidden="true"></i> NFT Settings</a></a></li>
					</ul><!-- /tabs -->

					<div class="tab-content">

						<div class="tab-pane active" id="tab1">

							<form class="" role="form" id="stylingForm">

								<div id="styleElements">

									<div class="form-group clearfix" style="display: none;" id="styleElTemplate">
										<label for="" class="control-label"></label>
										<input type="text" class="form-control input-sm" id="" placeholder="">
									</div>

								</div>

							</form>

						</div>
						
						<div class="tab-pane" id="tabEffects">

							<form role="form" id="effectsForm">

								<div id="effectsElements">

									<div class="form-group fullWidth">
										<label for="intDelay">Delay (sec.): </label>
										<input type="number" class="form-control" id="intDelay" name="intDelay" value="0" min="0" >
									</div>
									
									
								<div class="form-group">
									<label for="flgAnimation">Animation:</label>
									<select id="flgAnimation" class="form-control select select-primary btn-block mbl" data-placeholder="Choose animation">
										<option value="none" selected="selected" >None</option>
										<option value="flash" >Flash</option>
										<option value="pulse" >Pulse</option>
										<option value="rubberBand" >Rubber Band</option>
										<option value="shake" >Shake</option>
										<option value="headShake" >Head Shake</option>
										<option value="swing" >Swing</option>
										<option value="tada" >Tada</option>
										<option value="wobble" >Wobble</option>
										<option value="jello" >Jello</option>
										<option value="bounceIn" >Bounce-In</option>
										<option value="bounceInDown" >Bounce-In Down</option>
										<option value="bounceInLeft" >Bounce-In Left</option>
										<option value="bounceInRight" >Bounce-In Right</option>
										<option value="bounceInUp" >Bounce-In Up</option>
										<option value="bounceOut" >Bounce-Out</option>
										<option value="bounceOutDown" >Bounce-Out Down</option>
										<option value="bounceOutLeft" >Bounce-Out Left</option>
										<option value="bounceOutRight" >Bounce-Out Right</option>
										<option value="bounceOutUp" >Bounce-Out Up</option>
										<option value="fadeIn" >Fade-In</option>
										<option value="fadeInDown" >Fade-In Down</option>
										<option value="fadeInDownBig" >Fade-In Down Big</option>
										<option value="fadeInLeft" >Fade-In Left</option>
										<option value="fadeInLeftBig" >Fade-In Left Big</option>
										<option value="fadeInRight" >Fade-In Right</option>
										<option value="fadeInRightBig" >Fade-In Right Big</option>
										<option value="fadeInUp" >Fade-In Up</option>
										<option value="fadeInUpBig" >Fade-In Up Big</option>
										<option value="fadeOut" >Fade-Out</option>
										<option value="fadeOutDown" >Fade-Out Down</option>
										<option value="fadeOutDownBig" >Fade-Out Down `Big</option>
										<option value="fadeOutLeft" >Fade-Out Left</option>
										<option value="fadeOutLeftBig" >Fade-Out Left Big</option>
										<option value="fadeOutRight" >Fade-Out Right</option>
										<option value="fadeOutRightBig" >Fade-Out Right Big</option>
										<option value="fadeOutUp" >Fade-Out Up</option>
										<option value="fadeOutUpBig" >Fade-Out Up Big</option>
										<option value="flip" >Flip</option>
										<option value="flipInX" >Flip-In X</option>
										<option value="flipInY" >Flip-In Y</option>
										<option value="flipOutX" >Flip-Out X</option>
										<option value="flipOutY" >Flip-Out Y</option>
										<option value="lightSpeedIn" >Light Speed-In</option>
										<option value="lightSpeedOut" >Light Speed-Out</option>
										<option value="rotateIn" >Rotate-In</option>
										<option value="rotateInDownLeft" >Rotate-In Down Left</option>
										<option value="rotateInDownRight" >Rotate-In Down Right</option>
										<option value="rotateInUpLeft" >Rotate-In Up Left</option>
										<option value="rotateInUpRight" >Rotate-In Up Right</option>
										<option value="rotateOut" >Rotate-Out</option>
										<option value="rotateOutDownLeft" >Rotate-Out Down Left</option>
										<option value="rotateOutDownRight" >Rotate-Out Down Right</option>
										<option value="rotateOutUpLeft" >Rotate-Out Up Left</option>
										<option value="rotateOutUpRight" >Rotate-Out Up Right</option>
										<option value="hinge" >Hinge</option>
										<option value="rollIn" >Roll-In</option>
										<option value="rollOut" >Roll-Out</option>
										<option value="zoomIn" >Zoom-In</option>
										<option value="zoomInDown" >Zoom-In Down</option>
										<option value="zoomInLeft" >Zoom-In Left</option>
										<option value="zoomInRight" >Zoom-In Right</option>
										<option value="zoomInUp" >Zoom-In Up</option>
										<option value="zoomOut" >Zoom-Out</option>
										<option value="zoomOutDown" >Zoom-Out Down</option>
										<option value="zoomOutLeft" >Zoom-Out Left</option>
										<option value="zoomOutRight" >Zoom-Out Right</option>
										<option value="zoomOutUp" >Zoom-Out Up</option>
										<option value="slideInDown" >Slide-In Down</option>
										<option value="slideInLeft" >Slide-In Left</option>
										<option value="slideInRight" >Slide-In Right</option>
										<option value="slideInUp" >Slide-In Up</option>
										<option value="slideOutDown" >Slide-Out Down</option>
										<option value="slideOutLeft" >Slide-Out Left</option>
										<option value="slideOutRight" >Slide-Out Right</option>
										<option value="slideOutUp" >Slide-Out Up</option>
									</select>
								</div>

								</div>

							</form>

						</div>

						<!-- /tabs -->
						<div class="tab-pane link_Tab" id="link_Tab">

							{*<div class="form-group fullWidth">
								<input type="text" class="form-control" id="linkText" name="linkText" placeholder="Link text" value="">
							</div>*}

							<div class="form-group">
								<select id="pageLinksDropdown" class="form-control select select-primary btn-block mbl" data-placeholder="Choose a page">
								</select>
							</div>

							<p class="text-center or">
								<span>or</span>
							</p>

							<div class="form-group">
								<select id="internalLinksDropdown" class="form-control select select-primary btn-block mbl" data-placeholder="Choose a block">
								</select>
							</div>

							<p class="text-center or">
								<span>&xvee;</span>
							</p>

							<input type="text" class="form-control" id="internalLinksCustom" placeholder="http://somewhere.com/somepage"
							 value="">

							<label class="checkbox" for="checkboxLinkActive">
								<input type="checkbox" value="1" id="checkboxLinkActive" data-toggle="checkbox">
								Link is active </label>

							<label class="checkbox" for="checkboxTargetBlank">
								<input type="checkbox" value="1" id="checkboxTargetBlank" data-toggle="checkbox">
								Open in new window </label>

						</div>

						<!-- /tabs -->
						<div class="tab-pane imageFileTab" id="image_Tab">

							<a href="#imageModal" data-toggle="modal" type="button" class="btn btn-default btn-embossed btn-block margin-bottom-20"><span
								 class="fui-image"></span> Open image library</a>

							<input type="text" class="form-control margin-bottom-20" id="inputCombinedGallery" placeholder="MyGallery" value="">

							<div class="showHide">

								<label for="toggle_xyz">Toggle advanced options</label>
								<input type="checkbox" id="toggle_xyz">

								<div class="showHideContent">
									<label>Title attribute: </label>
									<input type="text" class="form-control margin-bottom-20" id="inputImageTitle" placeholder="" value="">

									<label>Alt attribute: </label>
									<input type="text" class="form-control margin-bottom-20" id="inputImageAlt" placeholder="" value="">
								</div>

							</div><!-- /.showHide -->

						</div><!-- /.tab-pane -->

						<!-- /tabs -->
						<div class="tab-pane iconTab" id="icon_Tab">

							<label>Choose an icon below: </label>

							<select id="icons" data-placeholder="" class>
								<option value="fa-adjust">&#xf042; adjust</option>
								<option value="fa-adn">&#xf170; adn</option>
								<option value="fa-align-center">&#xf037; align-center</option>
								<option value="fa-align-justify">&#xf039; align-justify</option>
								<option value="fa-align-left">&#xf036; align-left</option>
								<option value="fa-align-right">&#xf038; align-right</option>
								<option value="fa-ambulance">&#xf0f9; ambulance</option>
								<option value="fa-anchor">&#xf13d; anchor</option>
								<option value="fa-android">&#xf17b; android</option>
								<option value="fa-angellist">&#xf209; angellist</option>
								<option value="fa-angle-double-down">&#xf103; angle-double-down</option>
								<option value="fa-angle-double-left">&#xf100; angle-double-left</option>
								<option value="fa-angle-double-right">&#xf101; angle-double-right</option>
								<option value="fa-angle-double-up">&#xf102; angle-double-up</option>
								<option value="fa-angle-down">&#xf107; angle-down</option>
								<option value="fa-angle-left">&#xf104; angle-left</option>
								<option value="fa-angle-right">&#xf105; angle-right</option>
								<option value="fa-angle-up">&#xf106; angle-up</option>
								<option value="fa-apple">&#xf179; apple</option>
								<option value="fa-archive">&#xf187; archive</option>
								<option value="fa-area-chart">&#xf1fe; area-chart</option>
								<option value="fa-arrow-circle-down">&#xf0ab; arrow-circle-down</option>
								<option value="fa-arrow-circle-left">&#xf0a8; arrow-circle-left</option>
								<option value="fa-arrow-circle-o-down">&#xf01a; arrow-circle-o-down</option>
								<option value="fa-arrow-circle-o-left">&#xf190; arrow-circle-o-left</option>
								<option value="fa-arrow-circle-o-right">&#xf18e; arrow-circle-o-right</option>
								<option value="fa-arrow-circle-o-up">&#xf01b; arrow-circle-o-up</option>
								<option value="fa-arrow-circle-right">&#xf0a9; arrow-circle-right</option>
								<option value="fa-arrow-circle-up">&#xf0aa; arrow-circle-up</option>
								<option value="fa-arrow-down">&#xf063; arrow-down</option>
								<option value="fa-arrow-left">&#xf060; arrow-left</option>
								<option value="fa-arrow-right">&#xf061; arrow-right</option>
								<option value="fa-arrow-up">&#xf062; arrow-up</option>
								<option value="fa-arrows">&#xf047; arrows</option>
								<option value="fa-arrows-alt">&#xf0b2; arrows-alt</option>
								<option value="fa-arrows-h">&#xf07e; arrows-h</option>
								<option value="fa-arrows-v">&#xf07d; arrows-v</option>
								<option value="fa-asterisk">&#xf069; asterisk</option>
								<option value="fa-at">&#xf1fa; at</option>
								<option value="fa-automobile">&#xf1b9; automobile</option>
								<option value="fa-backward">&#xf04a; backward</option>
								<option value="fa-ban">&#xf05e; ban</option>
								<option value="fa-bank">&#xf19c; bank</option>
								<option value="fa-bar-chart">&#xf080; bar-chart</option>
								<option value="fa-bar-chart-o">&#xf080; bar-chart-o</option>
								<option value="fa-barcode">&#xf02a; barcode</option>
								<option value="fa-bars">&#xf0c9; bars</option>
								<option value="fa-beer">&#xf0fc; beer</option>
								<option value="fa-behance">&#xf1b4; behance</option>
								<option value="fa-behance-square">&#xf1b5; behance-square</option>
								<option value="fa-bell">&#xf0f3; bell</option>
								<option value="fa-bell-o">&#xf0a2; bell-o</option>
								<option value="fa-bell-slash">&#xf1f6; bell-slash</option>
								<option value="fa-bell-slash-o">&#xf1f7; bell-slash-o</option>
								<option value="fa-bicycle">&#xf206; bicycle</option>
								<option value="fa-binoculars">&#xf1e5; binoculars</option>
								<option value="fa-birthday-cake">&#xf1fd; birthday-cake</option>
								<option value="fa-bitbucket">&#xf171; bitbucket</option>
								<option value="fa-bitbucket-square">&#xf172; bitbucket-square</option>
								<option value="fa-bitcoin">&#xf15a; bitcoin</option>
								<option value="fa-bold">&#xf032; bold</option>
								<option value="fa-bolt">&#xf0e7; bolt</option>
								<option value="fa-bomb">&#xf1e2; bomb</option>
								<option value="fa-book">&#xf02d; book</option>
								<option value="fa-bookmark">&#xf02e; bookmark</option>
								<option value="fa-bookmark-o">&#xf097; bookmark-o</option>
								<option value="fa-briefcase">&#xf0b1; briefcase</option>
								<option value="fa-btc">&#xf15a; btc</option>
								<option value="fa-bug">&#xf188; bug</option>
								<option value="fa-building">&#xf1ad; building</option>
								<option value="fa-building-o">&#xf0f7; building-o</option>
								<option value="fa-bullhorn">&#xf0a1; bullhorn</option>
								<option value="fa-bullseye">&#xf140; bullseye</option>
								<option value="fa-bus">&#xf207; bus</option>
								<option value="fa-cab">&#xf1ba; cab</option>
								<option value="fa-calculator">&#xf1ec; calculator</option>
								<option value="fa-calendar">&#xf073; calendar</option>
								<option value="fa-calendar-o">&#xf133; calendar-o</option>
								<option value="fa-camera">&#xf030; camera</option>
								<option value="fa-camera-retro">&#xf083; camera-retro</option>
								<option value="fa-car">&#xf1b9; car</option>
								<option value="fa-caret-down">&#xf0d7; caret-down</option>
								<option value="fa-caret-left">&#xf0d9; caret-left</option>
								<option value="fa-caret-right">&#xf0da; caret-right</option>
								<option value="fa-caret-square-o-down">&#xf150; caret-square-o-down</option>
								<option value="fa-caret-square-o-left">&#xf191; caret-square-o-left</option>
								<option value="fa-caret-square-o-right">&#xf152; caret-square-o-right</option>
								<option value="fa-caret-square-o-up">&#xf151; caret-square-o-up</option>
								<option value="fa-caret-up">&#xf0d8; caret-up</option>
								<option value="fa-cc">&#xf20a; cc</option>
								<option value="fa-cc-amex">&#xf1f3; cc-amex</option>
								<option value="fa-cc-discover">&#xf1f2; cc-discover</option>
								<option value="fa-cc-mastercard">&#xf1f1; cc-mastercard</option>
								<option value="fa-cc-paypal">&#xf1f4; cc-paypal</option>
								<option value="fa-cc-stripe">&#xf1f5; cc-stripe</option>
								<option value="fa-cc-visa">&#xf1f0; cc-visa</option>
								<option value="fa-certificate">&#xf0a3; certificate</option>
								<option value="fa-chain">&#xf0c1; chain</option>
								<option value="fa-chain-broken">&#xf127; chain-broken</option>
								<option value="fa-check">&#xf00c; check</option>
								<option value="fa-check-circle">&#xf058; check-circle</option>
								<option value="fa-check-circle-o">&#xf05d; check-circle-o</option>
								<option value="fa-check-square">&#xf14a; check-square</option>
								<option value="fa-check-square-o">&#xf046; check-square-o</option>
								<option value="fa-chevron-circle-down">&#xf13a; chevron-circle-down</option>
								<option value="fa-chevron-circle-left">&#xf137; chevron-circle-left</option>
								<option value="fa-chevron-circle-right">&#xf138; chevron-circle-right</option>
								<option value="fa-chevron-circle-up">&#xf139; chevron-circle-up</option>
								<option value="fa-chevron-down">&#xf078; chevron-down</option>
								<option value="fa-chevron-left">&#xf053; chevron-left</option>
								<option value="fa-chevron-right">&#xf054; chevron-right</option>
								<option value="fa-chevron-up">&#xf077; chevron-up</option>
								<option value="fa-child">&#xf1ae; child</option>
								<option value="fa-circle">&#xf111; circle</option>
								<option value="fa-circle-o">&#xf10c; circle-o</option>
								<option value="fa-circle-o-notch">&#xf1ce; circle-o-notch</option>
								<option value="fa-circle-thin">&#xf1db; circle-thin</option>
								<option value="fa-clipboard">&#xf0ea; clipboard</option>
								<option value="fa-clock-o">&#xf017; clock-o</option>
								<option value="fa-close">&#xf00d; close</option>
								<option value="fa-cloud">&#xf0c2; cloud</option>
								<option value="fa-cloud-download">&#xf0ed; cloud-download</option>
								<option value="fa-cloud-upload">&#xf0ee; cloud-upload</option>
								<option value="fa-cny">&#xf157; cny</option>
								<option value="fa-code">&#xf121; code</option>
								<option value="fa-code-fork">&#xf126; code-fork</option>
								<option value="fa-codepen">&#xf1cb; codepen</option>
								<option value="fa-coffee">&#xf0f4; coffee</option>
								<option value="fa-cog">&#xf013; cog</option>
								<option value="fa-cogs">&#xf085; cogs</option>
								<option value="fa-columns">&#xf0db; columns</option>
								<option value="fa-comment">&#xf075; comment</option>
								<option value="fa-comment-o">&#xf0e5; comment-o</option>
								<option value="fa-comments">&#xf086; comments</option>
								<option value="fa-comments-o">&#xf0e6; comments-o</option>
								<option value="fa-compass">&#xf14e; compass</option>
								<option value="fa-compress">&#xf066; compress</option>
								<option value="fa-copy">&#xf0c5; copy</option>
								<option value="fa-copyright">&#xf1f9; copyright</option>
								<option value="fa-credit-card">&#xf09d; credit-card</option>
								<option value="fa-crop">&#xf125; crop</option>
								<option value="fa-crosshairs">&#xf05b; crosshairs</option>
								<option value="fa-css">css3 &#xf13c;</option>
								<option value="fa-cube">&#xf1b2; cube</option>
								<option value="fa-cubes">&#xf1b3; cubes</option>
								<option value="fa-cut">&#xf0c4; cut</option>
								<option value="fa-cutlery">&#xf0f5; cutlery</option>
								<option value="fa-dashboard">&#xf0e4; dashboard</option>
								<option value="fa-database">&#xf1c0; database</option>
								<option value="fa-dedent">&#xf03b; dedent</option>
								<option value="fa-delicious">&#xf1a5; delicious</option>
								<option value="fa-desktop">&#xf108; desktop</option>
								<option value="fa-deviantart">&#xf1bd; deviantart</option>
								<option value="fa-digg">&#xf1a6; digg</option>
								<option value="fa-dollar">&#xf155; dollar</option>
								<option value="fa-dot-circle-o">&#xf192; dot-circle-o</option>
								<option value="fa-download">&#xf019; download</option>
								<option value="fa-dribbble">&#xf17d; dribbble</option>
								<option value="fa-dropbox">&#xf16b; dropbox</option>
								<option value="fa-drupal">&#xf1a9; drupal</option>
								<option value="fa-edit">&#xf044; edit</option>
								<option value="fa-eject">&#xf052; eject</option>
								<option value="fa-ellipsis-h">&#xf141; ellipsis-h</option>
								<option value="fa-ellipsis-v">&#xf142; ellipsis-v</option>
								<option value="fa-empire">&#xf1d1; empire</option>
								<option value="fa-envelope">&#xf0e0; envelope</option>
								<option value="fa-envelope-o">&#xf003; envelope-o</option>
								<option value="fa-envelope-square">&#xf199; envelope-square</option>
								<option value="fa-eraser">&#xf12d; eraser</option>
								<option value="fa-eur">&#xf153; eur</option>
								<option value="fa-euro">&#xf153; euro</option>
								<option value="fa-exchange">&#xf0ec; exchange</option>
								<option value="fa-exclamation">&#xf12a; exclamation</option>
								<option value="fa-exclamation-circle">&#xf06a; exclamation-circle</option>
								<option value="fa-exclamation-triangle">&#xf071; exclamation-triangle</option>
								<option value="fa-expand">&#xf065; expand</option>
								<option value="fa-external-link">&#xf08e; external-link</option>
								<option value="fa-external-link-square">&#xf14c; external-link-square</option>
								<option value="fa-eye">&#xf06e; eye</option>
								<option value="fa-eye-slash">&#xf070; eye-slash</option>
								<option value="fa-eyedropper">&#xf1fb; eyedropper</option>
								<option value="fa-facebook">&#xf09a; facebook</option>
								<option value="fa-facebook-square">&#xf082; facebook-square</option>
								<option value="fa-fast-backward">&#xf049; fast-backward</option>
								<option value="fa-fast-forward">&#xf050; fast-forward</option>
								<option value="fa-fax">&#xf1ac; fax</option>
								<option value="fa-female">&#xf182; female</option>
								<option value="fa-fighter-jet">&#xf0fb; fighter-jet</option>
								<option value="fa-file">&#xf15b; file</option>
								<option value="fa-file-archive-o">&#xf1c6; file-archive-o</option>
								<option value="fa-file-audio-o">&#xf1c7; file-audio-o</option>
								<option value="fa-file-code-o">&#xf1c9; file-code-o</option>
								<option value="fa-file-excel-o">&#xf1c3; file-excel-o</option>
								<option value="fa-file-image-o">&#xf1c5; file-image-o</option>
								<option value="fa-file-movie-o">&#xf1c8; file-movie-o</option>
								<option value="fa-file-o">&#xf016; file-o</option>
								<option value="fa-file-pdf-o">&#xf1c1; file-pdf-o</option>
								<option value="fa-file-photo-o">&#xf1c5; file-photo-o</option>
								<option value="fa-file-picture-o">&#xf1c5; file-picture-o</option>
								<option value="fa-file-powerpoint-o">&#xf1c4; file-powerpoint-o</option>
								<option value="fa-file-sound-o">&#xf1c7; file-sound-o</option>
								<option value="fa-file-text">&#xf15c; file-text</option>
								<option value="fa-file-text-o">&#xf0f6; file-text-o</option>
								<option value="fa-file-video-o">&#xf1c8; file-video-o</option>
								<option value="fa-file-word-o">&#xf1c2; file-word-o</option>
								<option value="fa-file-zip-o">&#xf1c6; file-zip-o</option>
								<option value="fa-files-o">&#xf0c5; files-o</option>
								<option value="fa-film">&#xf008; film</option>
								<option value="fa-filter">&#xf0b0; filter</option>
								<option value="fa-fire">&#xf06d; fire</option>
								<option value="fa-fire-extinguisher">&#xf134; fire-extinguisher</option>
								<option value="fa-flag">&#xf024; flag</option>
								<option value="fa-flag-checkered">&#xf11e; flag-checkered</option>
								<option value="fa-flag-o">&#xf11d; flag-o</option>
								<option value="fa-flash">&#xf0e7; flash</option>
								<option value="fa-flask">&#xf0c3; flask</option>
								<option value="fa-flickr">&#xf16e; flickr</option>
								<option value="fa-floppy-o">&#xf0c7; floppy-o</option>
								<option value="fa-folder">&#xf07b; folder</option>
								<option value="fa-folder-o">&#xf114; folder-o</option>
								<option value="fa-folder-open">&#xf07c; folder-open</option>
								<option value="fa-folder-open-o">&#xf115; folder-open-o</option>
								<option value="fa-font">&#xf031; font</option>
								<option value="fa-forward">&#xf04e; forward</option>
								<option value="fa-foursquare">&#xf180; foursquare</option>
								<option value="fa-frown-o">&#xf119; frown-o</option>
								<option value="fa-futbol-o">&#xf1e3; futbol-o</option>
								<option value="fa-gamepad">&#xf11b; gamepad</option>
								<option value="fa-gavel">&#xf0e3; gavel</option>
								<option value="fa-gbp">&#xf154; gbp</option>
								<option value="fa-ge">&#xf1d1; ge</option>
								<option value="fa-gear">&#xf013; gear</option>
								<option value="fa-gears">&#xf085; gears</option>
								<option value="fa-gift">&#xf06b; gift</option>
								<option value="fa-git">&#xf1d3; git</option>
								<option value="fa-git-square">&#xf1d2; git-square</option>
								<option value="fa-github">&#xf09b; github</option>
								<option value="fa-github-alt">&#xf113; github-alt</option>
								<option value="fa-github-square">&#xf092; github-square</option>
								<option value="fa-gittip">&#xf184; gittip</option>
								<option value="fa-glass">&#xf000; glass</option>
								<option value="fa-globe">&#xf0ac; globe</option>
								<option value="fa-google">&#xf1a0; google</option>
								<option value="fa-google-plus">&#xf0d5; google-plus</option>
								<option value="fa-google-plus-square">&#xf0d4; google-plus-square</option>
								<option value="fa-google-wallet">&#xf1ee; google-wallet</option>
								<option value="fa-graduation-cap">&#xf19d; graduation-cap</option>
								<option value="fa-group">&#xf0c0; group</option>
								<option value="fa-h-square">&#xf0fd; h-square</option>
								<option value="fa-hacker-news">&#xf1d4; hacker-news</option>
								<option value="fa-hand-o-down">&#xf0a7; hand-o-down</option>
								<option value="fa-hand-o-left">&#xf0a5; hand-o-left</option>
								<option value="fa-hand-o-right">&#xf0a4; hand-o-right</option>
								<option value="fa-hand-o-up">&#xf0a6; hand-o-up</option>
								<option value="fa-hdd-o">&#xf0a0; hdd-o</option>
								<option value="fa-header">&#xf1dc; header</option>
								<option value="fa-headphones">&#xf025; headphones</option>
								<option value="fa-heart">&#xf004; heart</option>
								<option value="fa-heart-o">&#xf08a; heart-o</option>
								<option value="fa-history">&#xf1da; history</option>
								<option value="fa-home">&#xf015; home</option>
								<option value="fa-hospital-o">&#xf0f8; hospital-o</option>
								<option value="fa-html">html5 &#xf13b;</option>
								<option value="fa-ils">&#xf20b; ils</option>
								<option value="fa-image">&#xf03e; image</option>
								<option value="fa-inbox">&#xf01c; inbox</option>
								<option value="fa-indent">&#xf03c; indent</option>
								<option value="fa-info">&#xf129; info</option>
								<option value="fa-info-circle">&#xf05a; info-circle</option>
								<option value="fa-inr">&#xf156; inr</option>
								<option value="fa-instagram">&#xf16d; instagram</option>
								<option value="fa-institution">&#xf19c; institution</option>
								<option value="fa-ioxhost">&#xf208; ioxhost</option>
								<option value="fa-italic">&#xf033; italic</option>
								<option value="fa-joomla">&#xf1aa; joomla</option>
								<option value="fa-jpy">&#xf157; jpy</option>
								<option value="fa-jsfiddle">&#xf1cc; jsfiddle</option>
								<option value="fa-key">&#xf084; key</option>
								<option value="fa-keyboard-o">&#xf11c; keyboard-o</option>
								<option value="fa-krw">&#xf159; krw</option>
								<option value="fa-language">&#xf1ab; language</option>
								<option value="fa-laptop">&#xf109; laptop</option>
								<option value="fa-lastfm">&#xf202; lastfm</option>
								<option value="fa-lastfm-square">&#xf203; lastfm-square</option>
								<option value="fa-leaf">&#xf06c; leaf</option>
								<option value="fa-legal">&#xf0e3; legal</option>
								<option value="fa-lemon-o">&#xf094; lemon-o</option>
								<option value="fa-level-down">&#xf149; level-down</option>
								<option value="fa-level-up">&#xf148; level-up</option>
								<option value="fa-life-bouy">&#xf1cd; life-bouy</option>
								<option value="fa-life-buoy">&#xf1cd; life-buoy</option>
								<option value="fa-life-ring">&#xf1cd; life-ring</option>
								<option value="fa-life-saver">&#xf1cd; life-saver</option>
								<option value="fa-lightbulb-o">&#xf0eb; lightbulb-o</option>
								<option value="fa-line-chart">&#xf201; line-chart</option>
								<option value="fa-link">&#xf0c1; link</option>
								<option value="fa-linkedin">&#xf0e1; linkedin</option>
								<option value="fa-linkedin-square">&#xf08c; linkedin-square</option>
								<option value="fa-linux">&#xf17c; linux</option>
								<option value="fa-list">&#xf03a; list</option>
								<option value="fa-list-alt">&#xf022; list-alt</option>
								<option value="fa-list-ol">&#xf0cb; list-ol</option>
								<option value="fa-list-ul">&#xf0ca; list-ul</option>
								<option value="fa-location-arrow">&#xf124; location-arrow</option>
								<option value="fa-lock">&#xf023; lock</option>
								<option value="fa-long-arrow-down">&#xf175; long-arrow-down</option>
								<option value="fa-long-arrow-left">&#xf177; long-arrow-left</option>
								<option value="fa-long-arrow-right">&#xf178; long-arrow-right</option>
								<option value="fa-long-arrow-up">&#xf176; long-arrow-up</option>
								<option value="fa-magic">&#xf0d0; magic</option>
								<option value="fa-magnet">&#xf076; magnet</option>
								<option value="fa-mail-forward">&#xf064; mail-forward</option>
								<option value="fa-mail-reply">&#xf112; mail-reply</option>
								<option value="fa-mail-reply-all">&#xf122; mail-reply-all</option>
								<option value="fa-male">&#xf183; male</option>
								<option value="fa-map-marker">&#xf041; map-marker</option>
								<option value="fa-maxcdn">&#xf136; maxcdn</option>
								<option value="fa-meanpath">&#xf20c; meanpath</option>
								<option value="fa-medkit">&#xf0fa; medkit</option>
								<option value="fa-meh-o">&#xf11a; meh-o</option>
								<option value="fa-microphone">&#xf130; microphone</option>
								<option value="fa-microphone-slash">&#xf131; microphone-slash</option>
								<option value="fa-minus">&#xf068; minus</option>
								<option value="fa-minus-circle">&#xf056; minus-circle</option>
								<option value="fa-minus-square">&#xf146; minus-square</option>
								<option value="fa-minus-square-o">&#xf147; minus-square-o</option>
								<option value="fa-mobile">&#xf10b; mobile</option>
								<option value="fa-mobile-phone">&#xf10b; mobile-phone</option>
								<option value="fa-money">&#xf0d6; money</option>
								<option value="fa-moon-o">&#xf186; moon-o</option>
								<option value="fa-mortar-board">&#xf19d; mortar-board</option>
								<option value="fa-music">&#xf001; music</option>
								<option value="fa-navicon">&#xf0c9; navicon</option>
								<option value="fa-newspaper-o">&#xf1ea; newspaper-o</option>
								<option value="fa-openid">&#xf19b; openid</option>
								<option value="fa-outdent">&#xf03b; outdent</option>
								<option value="fa-pagelines">&#xf18c; pagelines</option>
								<option value="fa-paint-brush">&#xf1fc; paint-brush</option>
								<option value="fa-paper-plane">&#xf1d8; paper-plane</option>
								<option value="fa-paper-plane-o">&#xf1d9; paper-plane-o</option>
								<option value="fa-paperclip">&#xf0c6; paperclip</option>
								<option value="fa-paragraph">&#xf1dd; paragraph</option>
								<option value="fa-paste">&#xf0ea; paste</option>
								<option value="fa-pause">&#xf04c; pause</option>
								<option value="fa-paw">&#xf1b0; paw</option>
								<option value="fa-paypal">&#xf1ed; paypal</option>
								<option value="fa-pencil">&#xf040; pencil</option>
								<option value="fa-pencil-square">&#xf14b; pencil-square</option>
								<option value="fa-pencil-square-o">&#xf044; pencil-square-o</option>
								<option value="fa-phone">&#xf095; phone</option>
								<option value="fa-phone-square">&#xf098; phone-square</option>
								<option value="fa-photo">&#xf03e; photo</option>
								<option value="fa-picture-o">&#xf03e; picture-o</option>
								<option value="fa-pie-chart">&#xf200; pie-chart</option>
								<option value="fa-pied-piper">&#xf1a7; pied-piper</option>
								<option value="fa-pied-piper-alt">&#xf1a8; pied-piper-alt</option>
								<option value="fa-pinterest">&#xf0d2; pinterest</option>
								<option value="fa-pinterest-square">&#xf0d3; pinterest-square</option>
								<option value="fa-plane">&#xf072; plane</option>
								<option value="fa-play">&#xf04b; play</option>
								<option value="fa-play-circle">&#xf144; play-circle</option>
								<option value="fa-play-circle-o">&#xf01d; play-circle-o</option>
								<option value="fa-plug">&#xf1e6; plug</option>
								<option value="fa-plus">&#xf067; plus</option>
								<option value="fa-plus-circle">&#xf055; plus-circle</option>
								<option value="fa-plus-square">&#xf0fe; plus-square</option>
								<option value="fa-plus-square-o">&#xf196; plus-square-o</option>
								<option value="fa-power-off">&#xf011; power-off</option>
								<option value="fa-print">&#xf02f; print</option>
								<option value="fa-puzzle-piece">&#xf12e; puzzle-piece</option>
								<option value="fa-qq">&#xf1d6; qq</option>
								<option value="fa-qrcode">&#xf029; qrcode</option>
								<option value="fa-question">&#xf128; question</option>
								<option value="fa-question-circle">&#xf059; question-circle</option>
								<option value="fa-quote-left">&#xf10d; quote-left</option>
								<option value="fa-quote-right">&#xf10e; quote-right</option>
								<option value="fa-ra">&#xf1d0; ra</option>
								<option value="fa-random">&#xf074; random</option>
								<option value="fa-rebel">&#xf1d0; rebel</option>
								<option value="fa-recycle">&#xf1b8; recycle</option>
								<option value="fa-reddit">&#xf1a1; reddit</option>
								<option value="fa-reddit-square">&#xf1a2; reddit-square</option>
								<option value="fa-refresh">&#xf021; refresh</option>
								<option value="fa-remove">&#xf00d; remove</option>
								<option value="fa-renren">&#xf18b; renren</option>
								<option value="fa-reorder">&#xf0c9; reorder</option>
								<option value="fa-repeat">&#xf01e; repeat</option>
								<option value="fa-reply">&#xf112; reply</option>
								<option value="fa-reply-all">&#xf122; reply-all</option>
								<option value="fa-retweet">&#xf079; retweet</option>
								<option value="fa-rmb">&#xf157; rmb</option>
								<option value="fa-road">&#xf018; road</option>
								<option value="fa-rocket">&#xf135; rocket</option>
								<option value="fa-rotate-left">&#xf0e2; rotate-left</option>
								<option value="fa-rotate-right">&#xf01e; rotate-right</option>
								<option value="fa-rouble">&#xf158; rouble</option>
								<option value="fa-rss">&#xf09e; rss</option>
								<option value="fa-rss-square">&#xf143; rss-square</option>
								<option value="fa-rub">&#xf158; rub</option>
								<option value="fa-ruble">&#xf158; ruble</option>
								<option value="fa-rupee">&#xf156; rupee</option>
								<option value="fa-save">&#xf0c7; save</option>
								<option value="fa-scissors">&#xf0c4; scissors</option>
								<option value="fa-search">&#xf002; search</option>
								<option value="fa-search-minus">&#xf010; search-minus</option>
								<option value="fa-search-plus">&#xf00e; search-plus</option>
								<option value="fa-send">&#xf1d8; send</option>
								<option value="fa-send-o">&#xf1d9; send-o</option>
								<option value="fa-share">&#xf064; share</option>
								<option value="fa-share-alt">&#xf1e0; share-alt</option>
								<option value="fa-share-alt-square">&#xf1e1; share-alt-square</option>
								<option value="fa-share-square">&#xf14d; share-square</option>
								<option value="fa-share-square-o">&#xf045; share-square-o</option>
								<option value="fa-shekel">&#xf20b; shekel</option>
								<option value="fa-sheqel">&#xf20b; sheqel</option>
								<option value="fa-shield">&#xf132; shield</option>
								<option value="fa-shopping-cart">&#xf07a; shopping-cart</option>
								<option value="fa-sign-in">&#xf090; sign-in</option>
								<option value="fa-sign-out">&#xf08b; sign-out</option>
								<option value="fa-signal">&#xf012; signal</option>
								<option value="fa-sitemap">&#xf0e8; sitemap</option>
								<option value="fa-skype">&#xf17e; skype</option>
								<option value="fa-slack">&#xf198; slack</option>
								<option value="fa-sliders">&#xf1de; sliders</option>
								<option value="fa-slideshare">&#xf1e7; slideshare</option>
								<option value="fa-smile-o">&#xf118; smile-o</option>
								<option value="fa-soccer-ball-o">&#xf1e3; soccer-ball-o</option>
								<option value="fa-sort">&#xf0dc; sort</option>
								<option value="fa-sort-alpha-asc">&#xf15d; sort-alpha-asc</option>
								<option value="fa-sort-alpha-desc">&#xf15e; sort-alpha-desc</option>
								<option value="fa-sort-amount-asc">&#xf160; sort-amount-asc</option>
								<option value="fa-sort-amount-desc">&#xf161; sort-amount-desc</option>
								<option value="fa-sort-asc">&#xf0de; sort-asc</option>
								<option value="fa-sort-desc">&#xf0dd; sort-desc</option>
								<option value="fa-sort-down">&#xf0dd; sort-down</option>
								<option value="fa-sort-numeric-asc">&#xf162; sort-numeric-asc</option>
								<option value="fa-sort-numeric-desc">&#xf163; sort-numeric-desc</option>
								<option value="fa-sort-up">&#xf0de; sort-up</option>
								<option value="fa-soundcloud">&#xf1be; soundcloud</option>
								<option value="fa-space-shuttle">&#xf197; space-shuttle</option>
								<option value="fa-spinner">&#xf110; spinner</option>
								<option value="fa-spoon">&#xf1b1; spoon</option>
								<option value="fa-spotify">&#xf1bc; spotify</option>
								<option value="fa-square">&#xf0c8; square</option>
								<option value="fa-square-o">&#xf096; square-o</option>
								<option value="fa-stack-exchange">&#xf18d; stack-exchange</option>
								<option value="fa-stack-overflow">&#xf16c; stack-overflow</option>
								<option value="fa-star">&#xf005; star</option>
								<option value="fa-star-half">&#xf089; star-half</option>
								<option value="fa-star-half-empty">&#xf123; star-half-empty</option>
								<option value="fa-star-half-full">&#xf123; star-half-full</option>
								<option value="fa-star-half-o">&#xf123; star-half-o</option>
								<option value="fa-star-o">&#xf006; star-o</option>
								<option value="fa-steam">&#xf1b6; steam</option>
								<option value="fa-steam-square">&#xf1b7; steam-square</option>
								<option value="fa-step-backward">&#xf048; step-backward</option>
								<option value="fa-step-forward">&#xf051; step-forward</option>
								<option value="fa-stethoscope">&#xf0f1; stethoscope</option>
								<option value="fa-stop">&#xf04d; stop</option>
								<option value="fa-strikethrough">&#xf0cc; strikethrough</option>
								<option value="fa-stumbleupon">&#xf1a4; stumbleupon</option>
								<option value="fa-stumbleupon-circle">&#xf1a3; stumbleupon-circle</option>
								<option value="fa-subscript">&#xf12c; subscript</option>
								<option value="fa-suitcase">&#xf0f2; suitcase</option>
								<option value="fa-sun-o">&#xf185; sun-o</option>
								<option value="fa-superscript">&#xf12b; superscript</option>
								<option value="fa-support">&#xf1cd; support</option>
								<option value="fa-table">&#xf0ce; table</option>
								<option value="fa-tablet">&#xf10a; tablet</option>
								<option value="fa-tachometer">&#xf0e4; tachometer</option>
								<option value="fa-tag">&#xf02b; tag</option>
								<option value="fa-tags">&#xf02c; tags</option>
								<option value="fa-tasks">&#xf0ae; tasks</option>
								<option value="fa-taxi">&#xf1ba; taxi</option>
								<option value="fa-tencent-weibo">&#xf1d5; tencent-weibo</option>
								<option value="fa-terminal">&#xf120; terminal</option>
								<option value="fa-text-height">&#xf034; text-height</option>
								<option value="fa-text-width">&#xf035; text-width</option>
								<option value="fa-th">&#xf00a; th</option>
								<option value="fa-th-large">&#xf009; th-large</option>
								<option value="fa-th-list">&#xf00b; th-list</option>
								<option value="fa-thumb-tack">&#xf08d; thumb-tack</option>
								<option value="fa-thumbs-down">&#xf165; thumbs-down</option>
								<option value="fa-thumbs-o-down">&#xf088; thumbs-o-down</option>
								<option value="fa-thumbs-o-up">&#xf087; thumbs-o-up</option>
								<option value="fa-thumbs-up">&#xf164; thumbs-up</option>
								<option value="fa-ticket">&#xf145; ticket</option>
								<option value="fa-times">&#xf00d; times</option>
								<option value="fa-times-circle">&#xf057; times-circle</option>
								<option value="fa-times-circle-o">&#xf05c; times-circle-o</option>
								<option value="fa-tint">&#xf043; tint</option>
								<option value="fa-toggle-down">&#xf150; toggle-down</option>
								<option value="fa-toggle-left">&#xf191; toggle-left</option>
								<option value="fa-toggle-off">&#xf204; toggle-off</option>
								<option value="fa-toggle-on">&#xf205; toggle-on</option>
								<option value="fa-toggle-right">&#xf152; toggle-right</option>
								<option value="fa-toggle-up">&#xf151; toggle-up</option>
								<option value="fa-trash">&#xf1f8; trash</option>
								<option value="fa-trash-o">&#xf014; trash-o</option>
								<option value="fa-tree">&#xf1bb; tree</option>
								<option value="fa-trello">&#xf181; trello</option>
								<option value="fa-trophy">&#xf091; trophy</option>
								<option value="fa-truck">&#xf0d1; truck</option>
								<option value="fa-try">&#xf195; try</option>
								<option value="fa-tty">&#xf1e4; tty</option>
								<option value="fa-tumblr">&#xf173; tumblr</option>
								<option value="fa-tumblr-square">&#xf174; tumblr-square</option>
								<option value="fa-turkish-lira">&#xf195; turkish-lira</option>
								<option value="fa-twitch">&#xf1e8; twitch</option>
								<option value="fa-twitter">&#xf099; twitter</option>
								<option value="fa-twitter-square">&#xf081; twitter-square</option>
								<option value="fa-umbrella">&#xf0e9; umbrella</option>
								<option value="fa-underline">&#xf0cd; underline</option>
								<option value="fa-undo">&#xf0e2; undo</option>
								<option value="fa-university">&#xf19c; university</option>
								<option value="fa-unlink">&#xf127; unlink</option>
								<option value="fa-unlock">&#xf09c; unlock</option>
								<option value="fa-unlock-alt">&#xf13e; unlock-alt</option>
								<option value="fa-unsorted">&#xf0dc; unsorted</option>
								<option value="fa-upload">&#xf093; upload</option>
								<option value="fa-usd">&#xf155; usd</option>
								<option value="fa-user">&#xf007; user</option>
								<option value="fa-user-md">&#xf0f0; user-md</option>
								<option value="fa-users">&#xf0c0; users</option>
								<option value="fa-video-camera">&#xf03d; video-camera</option>
								<option value="fa-vimeo-square">&#xf194; vimeo-square</option>
								<option value="fa-vine">&#xf1ca; vine</option>
								<option value="fa-vk">&#xf189; vk</option>
								<option value="fa-volume-down">&#xf027; volume-down</option>
								<option value="fa-volume-off">&#xf026; volume-off</option>
								<option value="fa-volume-up">&#xf028; volume-up</option>
								<option value="fa-warning">&#xf071; warning</option>
								<option value="fa-wechat">&#xf1d7; wechat</option>
								<option value="fa-weibo">&#xf18a; weibo</option>
								<option value="fa-weixin">&#xf1d7; weixin</option>
								<option value="fa-wheelchair">&#xf193; wheelchair</option>
								<option value="fa-wifi">&#xf1eb; wifi</option>
								<option value="fa-windows">&#xf17a; windows</option>
								<option value="fa-won">&#xf159; won</option>
								<option value="fa-wordpress">&#xf19a; wordpress</option>
								<option value="fa-wrench">&#xf0ad; wrench</option>
								<option value="fa-xing">&#xf168; xing</option>
								<option value="fa-xing-square">&#xf169; xing-square</option>
								<option value="fa-yahoo">&#xf19e; yahoo</option>
								<option value="fa-yelp">&#xf1e9; yelp</option>
								<option value="fa-yen">&#xf157; yen</option>
								<option value="fa-youtube">&#xf167; youtube</option>
								<option value="fa-youtube-play">&#xf16a; youtube-play</option>
								<option value="fa-youtube-square">&#xf166; youtube-square</option>
							</select>

						</div><!-- /.tab-pane -->

						<!-- /tabs -->
						<div class="tab-pane videoTab" id="video_Tab">
							<input type="text" class="form-control margin-bottom-20" id="videoURL" placeholder="Enter a URL" value="" />
							<p>
								<small style="line-height: 1px;"><span style="display: block; color: #f00">Supported urls:</span>YouTube, Vimeo, Url to Video File (*.mp4)</small>
							</p>

							<label class="checkbox" for="simulate_live">
								<input type="checkbox" value="" id="simulate_live" data-toggle="checkbox">
								Simulate Live
							</label>

							<div data-simulate="false">
								<div class="form-group fullWidth">
									<label class="control-label">Button Text</label>
									<input type="text" class="form-control" value="Join Webinar" id="button_text" />
								</div>

								<div class="form-group">
									<label class="control-label">Button Color:</label>
									<input type="text" id="button_color" value="#02baf2" />
								</div>
							</div>

							<label class="checkbox" for="slick_stick">
								<input type="checkbox" value="" id="slick_stick" data-toggle="checkbox">
								Scroll & Stick
							</label>
						</div><!-- /.tab-pane -->

						<div class="tab-pane menuitemsTab" id="menuitems_Tab">

							Menu items

						</div>

						<div class="tab-pane formTab" id="form_Tab">
							<label class="checkbox" for="checkboxEmailForm">
								<input type="checkbox" value="" id="checkboxEmailForm" data-toggle="checkbox">
								Email data to
							</label>
							
							<label class="checkbox" for="checkboxCustomAction">
								<input type="checkbox" value="" id="checkboxCustomAction" data-toggle="checkbox">
								Custom action
							</label>
							
							<label class="checkbox" for="checkboxUseLeadChannels">
								<input type="checkbox" value="" id="checkboxUseLeadChannels" data-toggle="checkbox">
								Use Lead Channels
							</label>

							
							<label class="checkbox" for="checkboxTriggeredOptin">
								<input type="checkbox" value="" id="checkboxTriggeredOptin" data-toggle="checkbox">
								Triggered Optin
							</label>

							<div class="form-group">
								<p class="text-center or" style="margin-top: 25px;">
									<span>SETTINGS</span>
								</p>

								<label class="checkbox" for="checkboxTriggeredFields">
									<input type="checkbox" value="" id="checkboxTriggeredFields" data-toggle="checkbox">
									Optin Field Inline
								</label>

								<div data-form-type="email">
									<input type="email" class="form-control margin-bottom-20 pull-left" id="inputEmailFormTo" placeholder="Email address" value="admin@admin.test" disabled>
									<textarea rows="6" class="form-control margin-bottom-20 pull-left" id="textareaCustomMessage" placeholder="Custom confirmation message" disabled></textarea>
								</div>
								
								<div data-form-type="action">
									<input type="text" class="form-control margin-bottom-20 pull-left" id="inputCustomAction" placeholder="Action" value="" disabled />
								</div>

								<div data-form-type="leadchannels">
									<select id="selectLeadChannels" class="form-control select select-primary btn-block mbl" data-placeholder="Choose a company" disabled>
										{foreach from=$arrLeadChannels item=leadChannel}
										<option value="{$leadChannel.id}">{$leadChannel.name}</option>
										{/foreach}
									</select>
									
									<textarea rows="6" class="form-control margin-bottom-20 pull-left" id="textareaCustomMessageLeadChannel" placeholder="Custom confirmation message" disabled></textarea>
									<p class="text-center or" style="margin-top: 25px;">
										<span>OR</span>
									</p>
									<input type="text" class="form-control margin-bottom-20 pull-left" id="inputRedirectTo" placeholder="Redirect to URL" value="" disabled />
									<p class="text-center or" style="margin-top: 25px;">
										<span>OR</span>
									</p>
									<select id="selectPages"  class="form-control select select-primary btn-block mbl" data-placeholder="Choose a page"></select>
								</div>
							</div>
						</div>

						<div class="tab-pane slideshowTab" id="slideshow_Tab">

							<div class="row margin-bottom-20">

								<div class="col-md-6">
									Auto play: </div>

								<div class="col-md-6 text-right">
									<input type="checkbox" checked data-toggle="switch" name="default-switch" id="checkboxSliderAutoplay">
								</div>

							</div><!-- /.row -->

							<div class="row margin-bottom-20">

								<div class="col-md-6">
									Pause on hover: </div>

								<div class="col-md-6 text-right">
									<input type="checkbox" checked data-toggle="switch" name="default-switch" id="checkboxSliderPause">
								</div>

							</div><!-- /.row -->

							<div class="row margin-bottom-20">

								<div class="col-md-6">
									Effect: </div>

								<div class="col-md-6">
									<select class="form-control select select-primary select-sm select-block" id="selectSliderAnimation" style="min-width: 0px; width: 100%">
										<option value="">Slide</option>
										<option value="carousel-fade">Fade</option>
									</select>

								</div>

							</div><!-- /.row -->

							<div class="row margin-bottom-20">

								<div class="col-md-6">
									Interval (in ms): </div>

								<div class="col-md-6 text-right">
									<input type="number" class="form-control input-sm" id="inputSlideInterval" placeholder="5000" value="">
								</div>

							</div><!-- /.row -->

							<div class="row margin-bottom-20">

								<div class="col-md-6">
									Nav arrows: </div>

								<div class="col-md-6">
									<select class="form-control select select-primary select-sm select-block" id="selectSliderNavArrows" style="min-width: 0px; width: 100%">
										<option value="nav-arrows-in">Inside</option>
										<option value="nav-arrows-out">Outside</option>
										<option value="nav-arrows-none">Hidden</option>
									</select>

								</div>

							</div><!-- /.row -->

							<div class="row margin-bottom-20">

								<div class="col-md-6">
									Nav indicators: </div>

								<div class="col-md-6">
									<select class="form-control select select-primary select-sm select-block" id="selectSliderNavIndicators" style="min-width: 0px; width: 100%">
										<option value="nav-indicators-in">Inside</option>
										<option value="nav-indicators-out">Outside</option>
										<option value="nav-indicators-none">Hidden</option>
									</select>

								</div>

							</div><!-- /.row -->

						</div>

						<div class="tab-pane codeTab" id="code_Tab">
							<a href="#codeModal" data-toggle="modal" type="button" class="btn btn-default btn-embossed btn-block margin-bottom-20"><span class="fa fa-code"></span> Paste Code</a>
						</div>

						<div class="tab-pane settingTab" id="setting_Tab">
							<div class="form-group clearfix">
								<label for="" class="control-label">ID:</label>
								<input type="text" class="form-control input-sm padding-right" id="settingAttrId" placeholder="" name="background-image">
							</div>
							<p class="text-center or" style="margin-top: 25px;">
								<span>Shape Dividers</span>
							</p>

							<div class="form-group">
								<select id="dividersDropdown" class="form-control select select-primary btn-block mbl" data-placeholder="Choose a position">
									<option value="top">Top</option>
									<option value="bottom">Bottom</option>
								</select>
							</div>

							<div class="form-group">
								<div class="row">
									<div class="col-md-9">
										<a href="#shapeModal" data-toggle="modal" type="button" class="btn btn-default btn-embossed btn-block margin-bottom-20"><i class="fa fa-pencil" aria-hidden="true"></i> Add/Edit Shape</a>
									</div>
									<div class="col-md-3">
										<button class="btn btn-danger btn-embossed btn-block margin-bottom-20 disabled" id="btnDeleteShape"><i class="fa fa-trash" aria-hidden="true"></i></button>
									</div>
								</div>
							</div>
						</div>

						<div class="tab-pane" id="quiz_Tab">
							<div class="form-group">
								<label for="quizAction" class="control-label">Quiz Action</label>
								<select id="quizAction" class="form-control select select-default btn-block select-sm" data-placeholder="Choose a action"></select>
							</div>

							<div class="form-group">
								<label for="quizUrl" class="control-label">Redirect URL</label>
								<input type="text" class="form-control input-sm" id="quizUrl" />
							</div>

							<div class="form-group">
								<label for="quizMessage" class="control-label" style="width: 100%;">Thank You Message (Optional)</label>
								<textarea id="quizThanks" class="form-control"></textarea>
							</div>
						</div>

						<div class="tab-pane" id="webinar_Tab">
							<div class="form-group">
								<a href="#chatModal" data-toggle="modal" type="button" class="btn btn-default btn-embossed btn-block margin-bottom-20"><i class="fa fa-pencil" aria-hidden="true"></i> Add/Edit Messages</a>
							</div>
						</div>

						{if Core_Acs::haveAccess( array( 'iFunnels Studio Starter', 'iFunnels LTD Studio Starter' ) )}
						<div class="tab-pane" id="checkout_Tab">
							<div class="form-group row">
								<div class="col-md-6">
									<label for="" class="control-label">Checkout</label>
								</div>

								<div class="col-md-6 text-right">
									<input type="checkbox" id="checkoutSwitcher" data-toggle="switch" name="default-switch">
								</div>
							</div><!-- /.row -->

							<div data-checkout="false" class="margin-bottom-20">
								<div class="form-group">
									<label for="membershipPlans" class="control-label">Membership Plans <span class="text-danger">*</span></label>
									<select id="membershipPlans" class="form-control select select-default btn-block select-sm" data-placeholder="Choose a membership">
										{foreach from=$arrMemberships item=membership}
										<option value="{$membership.id}">[{$membership.site_name}] {$membership.name}</option>
										{/foreach}
									</select>
								</div>
	
								<div class="form-group">
									<label for="quizUrl" class="control-label">Redirect URL <span class="text-danger">*</span></label>
									<input type="text" class="form-control input-sm" id="checkoutRedirect" />
								</div>
	
								<div class="form-group">
									<label for="checkoutDisplay" class="control-label">Display</label>
									<select id="checkoutDisplay" class="form-control select select-default btn-block select-sm" data-placeholder="Choose a display">
										<option value="regular">Regular Link</option>
										<option value="popup">Popup</option>
									</select>
								</div>

								<div class="form-group row">
									<div class="col-md-7">
										<label class="control-label" style="width: 100%">Add an Order Bump</label>
									</div>
		
									<div class="col-md-5 text-right">
										<input type="checkbox" id="bumpSwitcher" data-toggle="switch" name="default-switch">
									</div>

									<div class="form-group col-md-12 m-t-20" data-bump="false">
										<a href="#bumpModal" data-toggle="modal" type="button" class="btn btn-default btn-embossed btn-block"><span class="label label-warning m-r-10">0</span>Select Products</a>
									</div>
								</div>
							</div>							
						</div>
						{/if}

						<div class="tab-pane" id="nft_Tab">
							<a href="#nftModal" data-toggle="modal" type="button" class="btn btn-default btn-embossed btn-block margin-bottom-20">
								<i class="fa fa-pencil" aria-hidden="true"></i> Settings
							</a>
						</div>
					</div> <!-- /tab-content -->

					<div class="alert alert-success" style="display: none;" id="detailsAppliedMessage">
						<button class="close fui-cross" type="button" id="detailsAppliedMessageHide"></button>
						The changes were applied successfully! </div>

					<div class="margin-bottom-5">
						<button type="button" class="btn btn-primary btn-embossed btn-sm btn-block" id="saveStyling"><span class="fui-check-inverted"></span>
							Apply changes</button>
					</div>

					<div class="sideButtons clearfix">
						<button type="button" class="btn btn-inverse btn-embossed btn-xs" id="cloneElementButton"><span class="fui-windows"></span>
							Clone</button>
						<button type="button" class="btn btn-danger btn-embossed btn-xs" data-target="#deleteElement" data-toggle="modal"
						 id="removeElementButton"><span class="fui-cross-inverted"></span>
							Remove</button>
					</div>

				</div><!-- /.styleEditorInner -->

			</div><!-- /.styleEditor -->

		</div><!-- /.builderLayout -->

		<div id="hidden">
			<iframe src="/skin/pagebuilder/elements/skeleton.html" id="skeleton"></iframe>
		</div>

		<!-- modals -->

		<!-- publish popup -->
		<div class="modal fade publishModal" id="publishModal" tabindex="-1" role="dialog" aria-hidden="TRUE">

			<form action="{url name="site1_ecom_funnels" action="publish"}" target="_blank" id="publishForm" method="post">
				<input type="hidden" name="siteID" value="{$smarty.get.id}" />

				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal"><span aria-hidden="TRUE">&times;</span><span class="sr-only">Close</span></button>
							<h4 class="modal-title" id="myModalLabel"><span class="fui-upload"></span> Upload your site</h4>
						</div>
						<div class="modal-body">

							<div class="loader" style="display: none;">
								<img src="/skin/pagebuilder/img/loading.gif" alt="Loading...">
								Saving data... ...
							</div>

							<div class="alert alert-success" style="display: none;">
								<h4>Hooray!</h4>
								Uploading has finished and all your selected pages and/or assets were successfully
								uploaded.
							</div>

							<div class="alert alert-error">
								<h4>Ouch! Something went wrong:</h4>
								There was a problem with your upload. Please try again later.
							</div>

							<div class="modal-alerts">

							</div>

							<div class="alert alert-info" style="display: none;" id="publishPendingChangesMessage">
								<h4>You have pending changes</h4>
								<p>
									It appears the latest changes to this site have not been saved yet. Before you can
									publish this site, you will need to save the last changes. </p>
								<button type="button" class="btn btn-info btn-wide save" id="buttonSavePendingBeforePublishing">Save
									Changes</button>
							</div>

							<div class="modal-body-content">
								<input type="hidden" name="publishing_options" value="external" />
								{if !empty($siteData.site.settings)}
								<div class="alert alert-info" role="alert"> 
									<strong>URL: </strong> <a href="https:{str_replace(array('http:','https:'),'',$siteData.site.url)}" class="alert-link">https:{str_replace(array('http:','https:'),'',$siteData.site.url)}</a>
								</div>
								<input type="hidden" name="placement_id" value="{$siteData.site.settings.placement_id}" />
								<input type="hidden" name="ftp_directory" value="{$siteData.site.settings.ftp_directory}" />
								{else}
								<div class="optionPane export">
									<div class="form-group">
										<h6>Hosting settings</h6>
										<div class="form-group">
											{if isset($arrPlacements)}
											<select class="selectpicker" name="placement_id" id="domain-settings-id">
												{html_options options=$arrPlacements['Domains hosted with us'] selected=$placement.id}
											</select>
											{/if}
										</div>

										<div class="form-group" id="hosting-set-root-block" style="display: block;">
											<label class="checkbox primary">
												<input type="checkbox" id="hosting-set-root" checked name="ftp_root" data-toggle="checkbox" value="1" class="custom-checkbox">
												Install at root level
											</label>
										</div>
										<div class="form-group" id="hosting-settings-dir-block" style="display: none;">
											<label>Homepage Folder: <em>*</em></label>
											<div>
												<input type="text" class="required form-control" id="domain-settings-directory" name="ftp_directory" value=""
												 local-value="">
											</div>
											<small id="hosting-directory-tips">If folder does not exist, it will be automatically created. For example:
												"forex-software"</small>
										</div>
									</div>
								</div>
								{/if}
							</div>
						</div><!-- /.modal-body -->
						<div class="modal-footer">
							<button type="button" class="btn btn-default btn-embossed" data-dismiss="modal" id="publishCancel">Cancel
								& Close</button>
							<button type="button" type="button" class="btn btn-primary btn-embossed" id="publishSubmit">Publish
								Now</button>
						</div>
					</div><!-- /.modal-content -->
				</div><!-- /.modal-dialog -->
			</form>
		</div><!-- /.modal -->

		<div class="modal fade imageModal" id="imageModal" tabindex="-1" role="dialog" aria-hidden="TRUE">
			<div class="modal-dialog modal-hg">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"><span aria-hidden="TRUE">&times;</span><span class="sr-only">Close</span></button>
						<h4 class="modal-title" id="myModalLabel"><span class="fui-upload"></span> Image Library</h4>
					</div>
					<div class="modal-body">

						<div class="loader" style="display: none;">
							<img src="/skin/pagebuilder/img/loading.gif" alt="Loading...">
							Uploading image... </div>

						<div class="modal-alerts">

						</div>

						<div class="modal-body-content">
							<ul class="nav nav-tabs nav-append-content">
								<li class="active"><a href="#myImagesTab" id="anchorMyImagesTab">My Images</a>
								</li>
								<li><a href="#adminImagesTab">Other Images</a></li>
							</ul> <!-- /tabs -->

							<div class="tab-content forImageLib" id="divImageLibrary">
								<div class="tab-pane active" id="myImagesTab">
									{if isset($userImages)}
									<div class="imageLibraryWrapper">
										<div class="images" id="myImages">
											<div class="slimWrapper">
												<div class="slim" id="slimWithSettings" data-meta-fresh="1" data-ratio="free" data-service="{url name="site1_ecom_funnels" action="imageUploadAjax"}" data-fetcher="fetch.php" data-max-file-size="1>"
												 data-status-file-size="The file you are trying to upload is too large, the maximum file size is $0 MB"
												 data-status-file-type="Invalid file type, expects: $0" data-status-image-too-small="Image is too small, minimum size is: $0 pixels"
												 data-status-unknown-response="An unknown error occurred" data-status-upload-success="Your image was uploaded"
												 data-did-upload="slimImageUpload" data-button-edit-title="Edit" data-button-remove-title="Remove"
												 data-button-upload-title="Upload" data-did-receive-server-error="slimHandleServerError"
												 data-button-cancel-label="Cancel" data-button-confirm-label="Confirm" data-label="<b>+</b><strong>Add Image</strong><br>max size: 1MB">
													<input type="file" name="slim[]" id="slimUpload" accept="image/jpeg,image/png,image/gif,image/bmp,image/svg+xml">
												</div>
											</div>
											{foreach from=$userImages item=img}
											<div class="image">
												<div class="imageWrap" style="background-image: url('{Zend_Registry::get('config')->path->html->user_data}{Core_Users::$info.id}/{$img}')"
												 data-ratio="free" data-service="{url name="site1_ecom_funnels" action="imageUploadAjax"}" data-fetcher="fetch.php"
												 data-max-file-size="1" data-status-file-type="Invalid file type, expects: $0" data-status-image-too-small="Image is too small, minimum size is: $0 pixels"
												 data-status-unknown-response="An unknown error occurred" data-status-upload-success="Your image was uploaded"
												 data-button-cancel-label="Cancel" data-button-confirm-label="Confirm" data-label="<b>+</b><strong>Add Image</strong><br>max size: 1MB"
												 data-org-src="{Zend_Registry::get('config')->path->html->user_data}{Core_Users::$info.id}/{$img}"
												 data-thumb="">
												</div>
											</div>
											{/foreach}

										</div><!-- /.images -->
										<div class="imageDetailPanel" id="imageDetailPanel">
											<a href="" id="linkFullImage" class="linkFullImage" target="_blank" data-toggle="tooltip" title=""></a>

											<div class="slimEditImageWrapper">
												<img src="" alt="" id="slimEditImage">
											</div><!-- /.slimEditImage -->

											<div class="imageDimensionsWrapper">
												<p>Image Dimensions:</p>
												<div class="fileDimensions clearfix">
													<div class="first">
														<div class="form-group has-feedback">
															<input type="number" class="form-control input-sm" id="inputImageWidth" name="inputImageWidth"
															 placeholder="" value="">
															<span class="form-control-feedback">px</span>
														</div>
													</div>
													<div class="second">
														By
													</div>
													<div class="third">
														<div class="form-group has-feedback">
															<input type="number" class="form-control input-sm" id="inputImageHeight" name="inputImageHeight"
															 placeholder="" value="">
															<span class="form-control-feedback">px</span>
														</div>
													</div>
												</div>
												<label class="checkbox" for="checkFixedRation">
													<input type="checkbox" value="" checked id="checkFixedRation" data-toggle="checkbox">
													Fix aspect ratio
												</label>
												<button class="btn btn-info btn-sm btn-block btn-embossed" id="buttonUpdateImageDimensions" data-loading="Working..."
												 data-confirm="Image resized!">Update dimensions</button>
											</div>

											<div class="imageMoreActions">
												<div class="deleteImage">
													<a href="#" class="deleteImage" id="buttonDeleteImage">Delete image</a>
													<div class="confirm" id="confirmDeleteImage"><b>Are you sure?</b> <a href="" class="confirmYes" id="imageDeleteYes">Yes</a>
														/ <a href="" class="confirmNo" id="imageDeleteNo">No</a></div>
												</div>
											</div>

										</div>
									</div><!-- /.imageLibraryWrapper -->
									{else}
									<!-- Alert Info -->
									<div class="alert alert-info">
										<button type="button" class="close fui-cross" data-dismiss="alert"></button>
										You currently have no images uploaded. To upload images, please use the upload panel on your left.
									</div>
									{/if}
								</div><!-- /.tab-pane -->

								<div class="tab-pane" id="adminImagesTab">
									<div class="images clearfix" id="adminImages">
										{if (isset($adminImages))}
										{foreach from=$adminImages item=img}
										<div class="image">
											<div class="imageWrap" data-org-src="/skin/pagebuilder/images/{$img}" data-admin="true" data-thumb="/skin/pagebuilder/images/{$img}"
											 style="background-image: url('/skin/pagebuilder/images/{$img}">
											</div>
										</div><!-- /.image -->
										{/foreach}
										{/if}
									</div><!-- /.adminImages -->
								</div><!-- /.tab-pane -->
							</div> <!-- /tab-content -->
						</div>

					</div><!-- /.modal-body -->
					<div class="modal-footer">
						<button type="button" class="btn btn-default btn-embossed btn-wide" data-dismiss="modal">Cancel & Close</button>
						<button type="button" class="btn btn-primary btn-embossed btn-wide" id="buttonImageModalUseImage">Use and Insert
							Image</button>
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->

		</div><!-- /.modal -->

		<!-- delete single block popup -->
		<div class="modal fade small-modal" id="deleteBlock" tabindex="-1" role="dialog" aria-hidden="TRUE">

			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-body">

						Are you sure you want to delete this block?
					</div><!-- /.modal-body -->
					<div class="modal-footer">
						<button type="button" class="btn btn-default btn-embossed" data-dismiss="modal">Cancel & Close</button>
						<button type="button" type="button" class="btn btn-primary btn-embossed" id="deleteBlockConfirm">Delete</button>
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->

		</div><!-- /.modal -->

		<!-- reset block popup -->
		<div class="modal fade small-modal" id="resetBlock" tabindex="-1" role="dialog" aria-hidden="TRUE">

			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-body">
						<p>
							Are you sure you want to reset this block? </p>
						<p>
							All changes made to the content will be destroyed. </p>
					</div><!-- /.modal-body -->

					<div class="modal-footer">
						<button type="button" class="btn btn-default btn-embossed" data-dismiss="modal">Cancel & Close</button>
						<button type="button" type="button" class="btn btn-primary btn-embossed" id="resetBlockConfirm">Reset
							Block</button>
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->

		</div><!-- /.modal -->

		<!-- delete page popup -->
		<div class="modal fade small-modal" id="deletePage" tabindex="-1" role="dialog" aria-hidden="TRUE">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-body">
						<p>
							Are you sure you want to delete this entire page? </p>
					</div><!-- /.modal-body -->

					<div class="modal-footer">
						<button type="button" class="btn btn-default btn-embossed" data-dismiss="modal" id="deletePageCancel">Cancel
							& Close</button>
						<button type="button" type="button" class="btn btn-primary btn-embossed" id="deletePageConfirm">Delete
							Page</button>
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->

		</div><!-- /.modal -->

		<!-- delete elemnent popup -->
		<div class="modal fade small-modal" id="deleteElement" tabindex="-1" role="dialog" aria-hidden="TRUE">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-body">
						<p>
							Are you sure you want to delete this element? Once deleted, it can not be restored. </p>
					</div><!-- /.modal-body -->

					<div class="modal-footer">
						<button type="button" class="btn btn-default btn-embossed" data-dismiss="modal" id="deletePageCancel">Cancel
							& Close</button>
						<button type="button" type="button" class="btn btn-primary btn-embossed" id="deleteElementConfirm">Delete
							Block</button>
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->

		</div><!-- /.modal -->

		<!-- delete elemnent popup -->
		<div class="modal fade medium-modal" id="codeModal" tabindex="-1" role="dialog" aria-hidden="TRUE">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-body">
						<label for="code--field">Enter in the field HTML or JS code</label>
						<div class="form-group">
							<textarea name="" id="code--field" class="form-control"></textarea>
						</div>
					</div><!-- /.modal-body -->

					<div class="modal-footer">
						<button type="button" class="btn btn-default btn-embossed" data-dismiss="modal" id="enterCodeCancel">Cancel
							& Close</button>
						<button type="button" type="button" class="btn btn-primary btn-embossed" id="enterCodeSave">Save Code</button>
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->

		</div><!-- /.modal -->

		<!-- gradient popup -->
		<div class="modal fade medium-modal" id="gradientModal" tabindex="-1" role="dialog" aria-hidden="TRUE">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-body">
						<div id="gradX"></div>
						<div class="target" id="target"></div>
					</div><!-- /.modal-body -->

					<div class="modal-footer">
						<button type="button" class="btn btn-default btn-embossed" data-dismiss="modal" id="enterCodeCancel">Cancel
							& Close</button>
						<button type="button" type="button" class="btn btn-primary btn-embossed" id="btnGradientSave">Save</button>
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->

		</div><!-- /.modal -->

		<!-- shape dividers popup -->
		<div class="modal fade medium-modal" id="shapeModal" tabindex="-1" role="dialog" aria-hidden="TRUE">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title text-capitalize">Shape Divider</h4>
					</div>
					<div class="modal-body">
						<div class="form-group">
							<label class="control-label">Shape Type</label>
							<div class="uncode-radio-image row">
								<input type="hidden" class="wpb_vc_param_value top_divider uncode_radio_image" name="top_divider" value="curve-opacity">
								<ul class="uncode_radio_images_list">
									<li>
										<label>
											<input type="radio" value="curve" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_curve flip" style="background-image:url(/skin/pagebuilder/img/svg/curve.svg)"></span>
											<span class="uncode_radio_image_title">Curve</span>
										</label>
									</li>
									<li>
										<label class="checked">
											<input type="radio" value="curve-opacity" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_curve-opacity flip" style="background-image:url(/skin/pagebuilder/img/svg/curve-opacity.svg)"></span>
											<span class="uncode_radio_image_title">Curve opacity</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="curve-asym" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_curve-asym flip" style="background-image:url(/skin/pagebuilder/img/svg/curve-asym.svg)"></span>
											<span class="uncode_radio_image_title">Curve asym</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="curve-asym-opacity" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_curve-asym-opacity flip" style="background-image:url(/skin/pagebuilder/img/svg/curve-asym-opacity.svg)"></span>
											<span class="uncode_radio_image_title">Curve asym opacity</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="book" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_book flip" style="background-image:url(/skin/pagebuilder/img/svg/book.svg)"></span>
											<span class="uncode_radio_image_title">Book</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="spear" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_spear flip" style="background-image:url(/skin/pagebuilder/img/svg/spear.svg)"></span>
											<span class="uncode_radio_image_title">Spear</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="arrow" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_arrow flip" style="background-image:url(/skin/pagebuilder/img/svg/arrow.svg)"></span>
											<span class="uncode_radio_image_title">Arrow</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="mountains" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_mountains flip" style="background-image:url(/skin/pagebuilder/img/svg/mountains.svg)"></span>
											<span class="uncode_radio_image_title">Mountains</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="clouds" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_clouds flip" style="background-image:url(/skin/pagebuilder/img/svg/clouds.svg)"></span>
											<span class="uncode_radio_image_title">Clouds</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="city" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_city flip" style="background-image:url(/skin/pagebuilder/img/svg/city.svg)"></span>
											<span class="uncode_radio_image_title">City</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="triangle" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_triangle flip" style="background-image:url(/skin/pagebuilder/img/svg/triangle.svg)"></span>
											<span class="uncode_radio_image_title">Triangle</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="pyramids" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_pyramids flip" style="background-image:url(/skin/pagebuilder/img/svg/pyramids.svg)"></span>
											<span class="uncode_radio_image_title">Pyramids</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="tilt" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_tilt flip" style="background-image:url(/skin/pagebuilder/img/svg/tilt.svg)"></span>
											<span class="uncode_radio_image_title">Tilt</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="tilt-opacity" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_tilt-opacity flip" style="background-image:url(/skin/pagebuilder/img/svg/tilt-opacity.svg)"></span>
											<span class="uncode_radio_image_title">Tilt opacity</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="ray-opacity" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_ray-opacity flip" style="background-image:url(/skin/pagebuilder/img/svg/ray.svg)"></span>
											<span class="uncode_radio_image_title">Ray opacity</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="fan-opacity" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_fan-opacity flip" style="background-image:url(/skin/pagebuilder/img/svg/fan.svg)"></span>
											<span class="uncode_radio_image_title">Fan opacity</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="swoosh" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_swoosh flip" style="background-image:url(/skin/pagebuilder/img/svg/swoosh.svg)"></span>
											<span class="uncode_radio_image_title">Swoosh</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="swoosh-opacity" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_swoosh-opacity flip" style="background-image:url(/skin/pagebuilder/img/svg/swoosh-opacity.svg)"></span>
											<span class="uncode_radio_image_title">Swoosh opacity</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="waves" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_waves flip" style="background-image:url(/skin/pagebuilder/img/svg/waves.svg)"></span>
											<span class="uncode_radio_image_title">Waves</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="waves-opacity" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_waves-opacity flip" style="background-image:url(/skin/pagebuilder/img/svg/waves-opacity.svg)"></span>
											<span class="uncode_radio_image_title">Waves opacity</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="hills" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_hills flip" style="background-image:url(/skin/pagebuilder/img/svg/hills.svg)"></span>
											<span class="uncode_radio_image_title">Hills</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="hills-opacity" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_hills-opacity flip" style="background-image:url(/skin/pagebuilder/img/svg/hills-opacity.svg)"></span>
											<span class="uncode_radio_image_title">Hills opacity</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="flow" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_flow flip" style="background-image:url(/skin/pagebuilder/img/svg/flow.svg)"></span>
											<span class="uncode_radio_image_title">Flow</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="flow-opacity" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_flow-opacity flip" style="background-image:url(/skin/pagebuilder/img/svg/flow-opacity.svg)"></span>
											<span class="uncode_radio_image_title">Flow opacity</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="step" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_step flip" style="background-image:url(/skin/pagebuilder/img/svg/step.svg)"></span>
											<span class="uncode_radio_image_title">Step</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="step_1_2" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_step_1_2 flip" style="background-image:url(/skin/pagebuilder/img/svg/step_1_2.svg)"></span>
											<span class="uncode_radio_image_title">Step 1/2</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="step_2_3" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_step_2_3 flip" style="background-image:url(/skin/pagebuilder/img/svg/step_2_3.svg)"></span>
											<span class="uncode_radio_image_title">Step 2/3</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="step_3_4" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_step_3_4 flip" style="background-image:url(/skin/pagebuilder/img/svg/step_3_4.svg)"></span>
											<span class="uncode_radio_image_title">Step 3/4</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" value="gradient" name="uncode_radio_image" data-svg="/skin/pagebuilder/img/svg/curve.svg">
											<span class="uncode_radio_image_src uncode_radio_image_src_gradient flip" style="background-image:url(/skin/pagebuilder/img/svg/gradient.svg)"></span>
											<span class="uncode_radio_image_title">Gradient</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="curve-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_curve" style="background-image:url(/skin/pagebuilder/img/svg/curve-inv.svg)"></span>
											<span class="uncode_radio_image_title">Curve</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="curve-opacity-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_curve-opacity" style="background-image:url(/skin/pagebuilder/img/svg/curve-opacity-inv.svg)"></span>
											<span class="uncode_radio_image_title">Curve opacity</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="curve-asym-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_curve-asym" style="background-image:url(/skin/pagebuilder/img/svg/curve-asym-inv.svg)"></span>
											<span class="uncode_radio_image_title">Curve asym</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="curve-asym-opacity-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_curve-asym-opacity" style="background-image:url(/skin/pagebuilder/img/svg/curve-asym-opacity-inv.svg)"></span>
											<span class="uncode_radio_image_title">Curve asym opacity</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="book-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_book" style="background-image:url(/skin/pagebuilder/img/svg/book-inv.svg)"></span>
											<span class="uncode_radio_image_title">Book</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="spear-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_spear" style="background-image:url(/skin/pagebuilder/img/svg/spear-inv.svg)"></span>
											<span class="uncode_radio_image_title">Spear</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="arrow-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_arrow" style="background-image:url(/skin/pagebuilder/img/svg/arrow-inv.svg)"></span>
											<span class="uncode_radio_image_title">Arrow</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="mountains-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_mountains" style="background-image:url(/skin/pagebuilder/img/svg/mountains-inv.svg)"></span>
											<span class="uncode_radio_image_title">Mountains</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="clouds-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_clouds" style="background-image:url(/skin/pagebuilder/img/svg/clouds-inv.svg)"></span>
											<span class="uncode_radio_image_title">Clouds</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="city-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_city" style="background-image:url(/skin/pagebuilder/img/svg/city-inv.svg)"></span>
											<span class="uncode_radio_image_title">City</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="triangle-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_triangle" style="background-image:url(/skin/pagebuilder/img/svg/triangle-inv.svg)"></span>
											<span class="uncode_radio_image_title">Triangle</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="pyramids-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_pyramids" style="background-image:url(/skin/pagebuilder/img/svg/pyramids-inv.svg)"></span>
											<span class="uncode_radio_image_title">Pyramids</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="tilt-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_tilt" style="background-image:url(/skin/pagebuilder/img/svg/tilt-inv.svg)"></span>
											<span class="uncode_radio_image_title">Tilt</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="tilt-opacity-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_tilt-opacity" style="background-image:url(/skin/pagebuilder/img/svg/tilt-opacity-inv.svg)"></span>
											<span class="uncode_radio_image_title">Tilt opacity</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="ray-opacity-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_ray-opacity" style="background-image:url(/skin/pagebuilder/img/svg/ray-inv.svg)"></span>
											<span class="uncode_radio_image_title">Ray opacity</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="fan-opacity-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_fan-opacity" style="background-image:url(/skin/pagebuilder/img/svg/fan-inv.svg)"></span>
											<span class="uncode_radio_image_title">Fan opacity</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="swoosh-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_swoosh" style="background-image:url(/skin/pagebuilder/img/svg/swoosh-inv.svg)"></span>
											<span class="uncode_radio_image_title">Swoosh</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="swoosh-opacity-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_swoosh-opacity" style="background-image:url(/skin/pagebuilder/img/svg/swoosh-opacity-inv.svg)"></span>
											<span class="uncode_radio_image_title">Swoosh opacity</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="waves-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_waves" style="background-image:url(/skin/pagebuilder/img/svg/waves-inv.svg)"></span>
											<span class="uncode_radio_image_title">Waves</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="waves-opacity-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_waves-opacity" style="background-image:url(/skin/pagebuilder/img/svg/waves-opacity-inv.svg)"></span>
											<span class="uncode_radio_image_title">Waves opacity</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="hills-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_hills" style="background-image:url(/skin/pagebuilder/img/svg/hills-inv.svg)"></span>
											<span class="uncode_radio_image_title">Hills</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="hills-opacity-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_hills-opacity" style="background-image:url(/skin/pagebuilder/img/svg/hills-opacity-inv.svg)"></span>
											<span class="uncode_radio_image_title">Hills opacity</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="flow-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_flow" style="background-image:url(/skin/pagebuilder/img/svg/flow-inv.svg)"></span>
											<span class="uncode_radio_image_title">Flow</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="flow-opacity-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_flow-opacity" style="background-image:url(/skin/pagebuilder/img/svg/flow-opacity-inv.svg)"></span>
											<span class="uncode_radio_image_title">Flow opacity</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="step_1_2-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_step_1_2" style="background-image:url(/skin/pagebuilder/img/svg/step_1_2-inv.svg)"></span>
											<span class="uncode_radio_image_title">Step 1/2</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="step_2_3-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_step_2_3" style="background-image:url(/skin/pagebuilder/img/svg/step_2_3-inv.svg)"></span>
											<span class="uncode_radio_image_title">Step 2/3</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="step_3_4-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_step_3_4" style="background-image:url(/skin/pagebuilder/img/svg/step_3_4-inv.svg)"></span>
											<span class="uncode_radio_image_title">Step 3/4</span>
										</label>
									</li>
									<li>
										<label>
											<input type="radio" class="uncode_radio_image" value="gradient-inv" name="uncode_radio_image">
											<span class="uncode_radio_image_src uncode_radio_image_src_gradient" style="background-image:url(/skin/pagebuilder/img/svg/gradient-inv.svg)"></span>
											<span class="uncode_radio_image_title">Gradient</span>
										</label>
									</li>
								</ul>
							</div>
						</div>

						<div class="form-group">
							<div class="row">
								<label class="control-label col-md-4">Shape Color</label>
								<div class="col-md-3">
									<input type="text" id="shape-color" value="#464D54" />
								</div>
							</div>
						</div>

						<div class="form-group">
							<div class="row">
								<label class="control-label col-md-4">Shape Flip</label>
								<div class="col-md-8">
									<input type="checkbox" data-toggle="switch" id="shape-flip" data-on-text="Yes" data-off-text="No" />
								</div>
							</div>
						</div>

						<div class="form-group">
							<div class="row">
								<label class="control-label col-md-4">Shape Height</label>
								<div class="col-md-8">
									<input type="checkbox" data-toggle="switch" id="shape-height" data-on-text="%" data-off-text="px" />
								</div>
							</div>
						</div>

						<div class="form-group" data-checked-height="px">
							<div class="row">
								<div class="col-md-11">
									<input type="text" class="form-control input-sm padding-right" id="shape-px" value="150" />
								</div>
								<div class="col-md-1">
									<span class="inputAppend">px</span>
								</div>
							</div>
						</div>

						<div class="form-group" style="display: none" data-checked-height="%">
							<input type="text" id="shape-procent" readonly class="form-control input-sm padding-right m-b-20" />
							<span class="inputAppend">%</span>
							<div class="clearfix"></div>

							<div id="slider-height"></div>
						</div>
						
						<div class="form-group">
							<div class="row">
								<label class="control-label col-md-4">Shape Opacity</label>
								<div class="col-md-8">
									<input type="text" id="shape-opacity" readonly class="form-control input-sm padding-right m-b-20" />
								</div>
							</div>
							<div class="clearfix"></div>
							<div id="slider-shape-opacity"></div>
						</div>

						<div class="form-group">
							<div class="row">
								<label class="control-label col-md-4">Shape Ratio</label>
								<div class="col-md-8">
									<input type="checkbox" data-toggle="switch" id="shape-ratio" data-on-text="Yes" data-off-text="No" />
								</div>
							</div>
						</div>

						<div class="form-group">
							<div class="row">
								<label class="control-label col-md-4">Shape Safe</label>
								<div class="col-md-8">
									<input type="checkbox" data-toggle="switch" id="shape-safe" data-on-text="Yes" data-off-text="No" />
								</div>
							</div>
						</div>

						<div class="form-group">
							<div class="row">
								<label class="control-label col-md-4">Shape Z-Index</label>
								<div class="col-md-8">
									<input type="text" id="shape-z-index" readonly class="form-control input-sm padding-right m-b-20" />
								</div>
							</div>

							<div class="clearfix"></div>
							<div id="slider-shape-z-index"></div>
						</div>
						
						<div class="form-group">
							<div class="row">
								<label class="control-label col-md-4">Shape Responsive</label>
								<div class="col-md-8">
									<input type="checkbox" data-toggle="switch" id="shape-responsive" data-on-text="Yes" data-off-text="No" />
								</div>
							</div>
						</div>

						<div class="form-group" data-checked-resonsive="tablet" style="display: none">
							<div class="row">
								<label class="control-label col-md-4">Shape Tablet Hidden</label>
								<div class="col-md-8">
									<input type="checkbox" data-toggle="switch" id="shape-tablet" data-on-text="Yes" data-off-text="No" />
								</div>
							</div>
						</div>

						<div class="form-group" data-checked-resonsive="mobile" style="display: none">
							<div class="row">
								<label class="control-label col-md-4">Shape Mobile Hidden</label>
								<div class="col-md-8">
									<input type="checkbox" data-toggle="switch" id="shape-mobile" data-on-text="Yes" data-off-text="No" />	
								</div>
							</div>
						</div>
					</div><!-- /.modal-body -->

					<div class="modal-footer">
						<button type="button" class="btn btn-default btn-embossed" data-dismiss="modal" id="enterCodeCancel">Cancel
							& Close</button>
						<button type="button" type="button" class="btn btn-primary btn-embossed" id="btnShapeSave">Save</button>
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->
		</div><!-- /.modal -->

		<!-- Chat messages popup -->
		<div class="modal fade" id="chatModal" tabindex="-1" role="dialog" aria-hidden="TRUE">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title text-capitalize">Webinar Chat</h4>
					</div>

					<div class="modal-body">
						<div class="form-group" style="padding: 15px; background: #eaeaea">
							<div class="form-group">
								<label class="control-label">Import *.csv file</label>
								<input type="file" id="csv-file" class="filestyle" accept=".csv" data-buttonname="btn-primary" data-iconname="fa fa-cloud-upload">
							</div>
						</div>

						<div class="form-group text-right">
							<button class="btn btn-danger" id="clear_all_messages">Clear All Messages</button>
						</div>

						<div class="form-group" style="max-height: 350px; overflow-y: auto;">
							<table class="table">
								<thead>
									<tr>
										<th>Sec</th>
										<th width="21%">User Name</th>
										<th>Message</th>
										<th>Options</th>
									</tr>
								</thead>

								<tbody id="webinar-messages">
									<tr><td colspan="4" align="center">Empty</td></tr>
								</tbody>
							</table>
						</div>

						<div class="form-group">
							<div class="row">
								<div class="col-md-4">
									<input type="number" id="webinar_sec" class="form-control" placeholder="Sec" min="0" />
								</div>
								
								<div class="col-md-8">
									<input type="text" id="webinar_username" class="form-control" placeholder="User Name" />
								</div>
							</div>
						</div>

						<div class="form-group">
							<textarea class="form-control" id="webinar_message" placeholder="Message"></textarea>
						</div>

						<div class="form-group text-right">
							<button type="button" class="btn btn-default btn-embossed" id="add_webinar_message">Add New Message</button>
						</div>
					</div><!-- /.modal-body -->

					<div class="modal-footer">
						<button type="button" class="btn btn-default btn-embossed" data-dismiss="modal">Cancel & Close</button>
						<button type="button" type="button" class="btn btn-primary btn-embossed" id="btnChatSave">Save</button>
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->
		</div><!-- /.modal -->

		<!-- Bump messages popup -->
		<div class="modal fade" id="bumpModal" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title text-capitalize">Memberships</h4>
					</div>

					<div class="modal-body">
						<p><small class="text-danger">* max 3 memberships</small></p>
						{foreach from=$group_membership key=site_name item=memberships}
						<div class="form-group">
							<h4>{$site_name}</h4>

							{foreach from=$memberships item=membership}
							<label class="checkbox" for="memberships_{$membership.id}">
								{$membership.name}
								<input type="checkbox" name="membership[]" value="{$membership.id}" id="memberships_{$membership.id}" data-toggle="checkbox" class="custom-checkbox">
							</label>
							{/foreach}
						</div>
						{/foreach}
					</div><!-- /.modal-body -->

					<div class="modal-footer">
						<button type="button" class="btn btn-default btn-embossed" data-dismiss="modal">Cancel & Close</button>
						<button type="button" type="button" class="btn btn-primary btn-embossed" id="btnBumpSave">Save</button>
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->
		</div><!-- /.modal -->

		<!-- Chat messages popup -->
		<div class="modal fade" id="nftModal" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title text-capitalize">NFT Settings</h4>
					</div>

					<div class="modal-body">
						<div class="form-group">
							<label class="control-label">Network Name</label>&nbsp;
							<select name="network" id="network" class="selectpicker">
								<option value="1">Ethereum Mainnet</option>
								<option value="137">Polygon</option>
								<option value="4">Rinkeby</option>
								<option value="3">Ropsten</option>
								<option value="5">Goerli</option>
							</select>
						</div>

						<div class="form-group">
							<label class="control-label">Contract Address</label>
							<input type="text" name="contract_address" class="form-control" />
						</div>

						<div class="form-group">
							<label class="control-label">Max Supply</label>
							<input type="text" name="max_supply" class="form-control" />
						</div>

						<div class="form-group">
							<label class="checkbox" for="show_quantity">
								Show available quantity
								<input type="checkbox" name="show_quantity" value="1" id="show_quantity" data-toggle="checkbox" class="custom-checkbox">
							</label>
						</div><!-- /.row -->

						<div class="form-group">
							<label class="control-label">Max Mint Amount</label>
							<input type="text" name="max_mint_amount" class="form-control" />
							<small class="text-muted">Note: this setting should be the same as set in the maxMintAmount parameter in the smart contract</small>
						</div>

						<div class="form-group">
							<label class="control-label">Wei Cost</label>
							<input type="text" name="wei_cost" class="form-control" />
						</div>

						<div class="form-group">
							<label class="control-label">Gas Limit</label>
							<input type="text" name="gas_limit" class="form-control" />
						</div>
					</div><!-- /.modal-body -->

					<div class="modal-footer">
						<button type="button" class="btn btn-default btn-embossed" data-dismiss="modal">Cancel & Close</button>
						<button type="button" type="button" class="btn btn-primary btn-embossed" id="btnNftSettingSave">Save</button>
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->
		</div><!-- /.modal -->

		<div id="loader">
			<span> { </span><span> } </span>
		</div>

	</div>

	<!-- modals -->

	<div class="modal fade newSiteModal" id="newSiteModal" tabindex="-1" role="dialog" aria-hidden="true" data-keyboard="false" data-backdrop="static">
		<div class="modal-backdrop fade in" style="height: 100%;"></div>
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title" id="myModalLabel"><span class="fui-window"></span> How would you like to start?</h4>
				</div>
				<div class="modal-body">
					<ul class="catList" id="ulCatList">
						<li>
							<button class="active" data-cat-id="canvas">
								Empty canvas <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px"
								 y="0px" viewBox="0 0 16 16" xml:space="preserve" width="16" height="16">
									<g class="nc-icon-wrapper" fill="#bdc3c7">
										<polygon fill="#bdc3c7" points="4.9,15.7 3.4,14.3 9.7,8 3.4,1.7 4.9,0.3 12.6,8 "></polygon>
									</g>
								</svg>
							</button>
						</li>
						{foreach from=$arrCategory item=category}
						<li>
							<button data-cat-id="{$category.id}" class="">
								{$category.category_name}<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px"
								 y="0px" viewBox="0 0 16 16" xml:space="preserve" width="16" height="16">
									<g class="nc-icon-wrapper" fill="#bdc3c7">
										<polygon fill="#bdc3c7" points="4.9,15.7 3.4,14.3 9.7,8 3.4,1.7 4.9,0.3 12.6,8 "></polygon>
									</g>
								</svg>
							</button>
						</li>
						{/foreach}
					</ul>

					<div class="templateWrapper">
						<div id="divEmptyCanvas" class="divEmptyCanvas" style="display: block;">
							<h2 class="text-center">Start from scratch</h2>
							<h3 class="text-center">Use drag and drop to create your own design</h3>
							<img src="/skin/pagebuilder/img/dnd.png">
						</div>
						<ul id="ulTemplateList" class="templateList" style="display: none;">
							{foreach from=$arrTemplates item=template}
							<li data-cat-id="{$template.category_id}" style="display: list-item;">
								<a href="" data-template-id="{$template.id}" class="">
									<img class="lazyload" data-src="{Zend_Registry::get('config')->path->html->pagebuilder}{$template.sitethumb}">
								</a>
							</li>
							{/foreach}
						</ul>
					</div>
				</div><!-- /.modal-body -->

				<div class="modal-footer">
					<a href="{url name="site1_ecom_funnels" action="create"}?new" class="btn btn-primary btn-embossed" id="linkNewSite">
						<span class="fui-power"></span>
						Launch the builder </a>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div>

	<div class="modal fade newPageModal" id="newPageModal" tabindex="-1" role="dialog" aria-hidden="true" data-keyboard="false" data-backdrop="static">
		<div class="modal-backdrop fade in" style="height: 100%;"></div>
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
					<h4 class="modal-title" id="myModalLabel"><span class="fui-window"></span> How would you like to start?</h4>
				</div>
				<div class="modal-body">
					<ul class="catList" data-list="category">
						<li>
							<button class="active" data-cat-id="canvas">
								Empty canvas <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px"
								 y="0px" viewBox="0 0 16 16" xml:space="preserve" width="16" height="16">
									<g class="nc-icon-wrapper" fill="#bdc3c7">
										<polygon fill="#bdc3c7" points="4.9,15.7 3.4,14.3 9.7,8 3.4,1.7 4.9,0.3 12.6,8 "></polygon>
									</g>
								</svg>
							</button>
						</li>
						<li>
							<button data-cat-id="user_site">
								Your Sites<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px"
								y="0px" viewBox="0 0 16 16" xml:space="preserve" width="16" height="16">
								   <g class="nc-icon-wrapper" fill="#bdc3c7">
									   <polygon fill="#bdc3c7" points="4.9,15.7 3.4,14.3 9.7,8 3.4,1.7 4.9,0.3 12.6,8 "></polygon>
								   </g>
							   </svg>
							</button>
						</li>
						{foreach from=$arrCategory item=category}
						<li>
							<button data-cat-id="{$category.id}">
								{$category.category_name}<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px"
								 y="0px" viewBox="0 0 16 16" xml:space="preserve" width="16" height="16">
									<g class="nc-icon-wrapper" fill="#bdc3c7">
										<polygon fill="#bdc3c7" points="4.9,15.7 3.4,14.3 9.7,8 3.4,1.7 4.9,0.3 12.6,8 "></polygon>
									</g>
								</svg>
							</button>
						</li>
						{/foreach}
					</ul>

					<div class="templateWrapper">
						<div data-cat-id="canvas" class="divEmptyCanvas" style="display: block;">
							<h2 class="text-center">Start from scratch</h2>
							<h3 class="text-center">Use drag and drop to create your own design</h3>
							<img src="/skin/pagebuilder/img/dnd.png">
						</div>

						<div class="templateList" style="display: none;">
							{foreach from=$arrTemplates item=template}
							<div data-cat-id="{$template.category_id}" class="templateList__item">
								<h3>{$template.sites_name}</h3>
								{foreach from=$template.arrPages item=page}
								<a href="" data-page-id="{$page.id}">
									<div class="lazyload-preload"></div>
									<img class="lazyload" data-src="{Zend_Registry::get('config')->path->html->pagebuilder}{if empty($page.pagethumb) }img/nothumb.png{else}{$page.pagethumb}{/if}" alt="">
									<span>{$page.pages_name}</span>
								</a>
								{/foreach}
							</div>
							{/foreach}
							
							{foreach from=$arrUserSites item=site}
							<div data-cat-id="user_site" class="templateList__item">
								<h3>{if ! empty($site.sites_name)}{$site.sites_name}{else}Unnamed{/if}</h3>
								{foreach from=$site.arrPages item=page}
								<a href="" data-page-id="{$page.id}">
									<div class="lazyload-preload"></div>
									<img class="lazyload" data-src="{Zend_Registry::get('config')->path->html->pagebuilder}{if empty($page.pagethumb) }img/nothumb.png{else}{$page.pagethumb}{/if}" alt="">
									<span>{$page.pages_name}</span>
								</a>
								{/foreach}
							</div>
							{/foreach}
						</div>
					</div>
				</div><!-- /.modal-body -->

				<div class="modal-footer">
					<a href="#" class="btn btn-primary btn-embossed" id="linkNewPage">
						<span class="fui-power"></span>
						Add page </a>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div>

	<div class="modal fade siteSettingsModal" id="siteSettings" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">

		<div class="modal-dialog modal-lg">

			<div class="modal-content">

				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
					<h4 class="modal-title" id="myModalLabel"><span class="fui-gear"></span> Site Settings</h4>
				</div>

				<div class="modal-body">
					<div class="loader" style="display: none">
						<img src="/skin/pagebuilder/img/loading.gif" alt="Loading...">
						Loading site data... </div>
					<div class="modal-alerts"></div>
					<div class="modal-body-content">
						<form action="{url name="site1_ecom_funnels" action="updateSettingsSite"}" id="siteSettingsForm" class="form-horizontal" method="post">
							<input type="hidden" name="id" value="{$smarty.get.id}" />
							<div class="siteSettingsWrapper">
								<div class="optionPane">
									<h6>Site details</h6>
						
									<div class="form-group">
										<label for="sites_name" class="col-sm-3 control-label">Site name</label>
										<div class="col-sm-9">
											<input type="text" class="form-control" id="sites_name" name="sites_name" placeholder="Site name" value="{$siteData.site.sites_name}">
										</div>
									</div>
						
									<div class="form-group">
										<label for="global_css" class="col-sm-3 control-label">Global CSS</label>
										<div class="col-sm-9">
											<textarea class="form-control" id="global_css" name="global_css" placeholder="Global CSS" rows="6">{$siteData.site.global_css}</textarea>
										</div>
									</div>

									<div class="form-group">
										<label for="global_css" class="col-sm-3 control-label">Header Script</label>
										<div class="col-sm-9">
											<textarea class="form-control" id="header_script" name="header_script" placeholder="Header Script" rows="6">{$siteData.site.header_script}</textarea>
										</div>
									</div>

									<div class="form-group">
										<label for="global_css" class="col-sm-3 control-label">Footer Script</label>
										<div class="col-sm-9">
											<textarea class="form-control" id="footer_script" name="footer_script" placeholder="Footer Script" rows="6">{$siteData.site.footer_script}</textarea>
										</div>
									</div>
								</div>

								{if Core_Acs::haveAccess( array( 'iFunnels Studio Starter', 'iFunnels LTD Studio Starter' ) )}
								<div class="optionPane">
									<h6>Settings Protect for All Pages</h6>
		
									<div class="form-group" data-protected="true">
										<label class="col-md-3 control-label">Membership Lists:</label>
										
										<div class="col-md-9">
											<div class="blockCatSelection membership-lists">
												<ul>
													{foreach from=$arrMemberships item=membership}
													<li>
														<label class="checkbox" for="memberships_{$membership.id}">
															{$membership.name} / [{$membership.site_name}]
															<input type="checkbox" name="membership[]" value="{$membership.id}" id="memberships_{$membership.id}" data-toggle="checkbox" class="custom-checkbox">
														</label>
													</li>
													{/foreach}
												</ul>
											</div>
										</div>
									</div>

									<div class="form-group">
										<label class="col-md-3 control-label">Primary Membership</label>

										<div class="col-md-9">
											<select class="selectpicker" name="primary_membership" id="ss-primary-membership">
												<option value=""></option>
											</select>
										</div>
									</div>
								</div>
								{/if}
							</div>
						</form>
					</div>
				</div><!-- /.modal-body -->

				<div class="modal-footer">
					<button type="button" class="btn btn-default btn-embossed" data-dismiss="modal"><span class="fui-cross"></span>
						Cancel & Close</button>
					<button type="button" class="btn btn-primary btn-embossed" id="saveSiteSettingsButton"><span class="fui-check"></span>
						Save Settings</button>
				</div>

			</div><!-- /.modal-content -->

		</div><!-- /.modal-dialog -->

	</div><!-- /.modal -->

	<div class="modal fade accountModal" id="accountModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
	 aria-hidden="true">

		<div class="modal-dialog">

			<div class="modal-content">

				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
					<h4 class="modal-title" id="myModalLabel"> My Account</h4>
				</div>

				<div class="modal-body padding-top-40">

					<ul class="nav nav-tabs nav-append-content">
						<li class="active"><a href="#myAccount"><span class="fui-user"></span> Account</a></li>
					</ul> <!-- /tabs -->

					<div class="tab-content">

						<div class="tab-pane active" id="myAccount">

							<form class="form-horizontal" role="form" id="account_details">

								<div class="loader" style="display: none;">
									<img src="/skin/pagebuilder/img/91.gif" alt="Loading...">
								</div>

								<div class="alerts"></div>

								<input type="hidden" name="id" value="1">
								<div class="form-group">
									<label for="first_name" class="col-md-3 control-label">First name</label>
									<div class="col-md-9">
										<input type="text" class="form-control" id="first_name" name="first_name" placeholder="First name" value="Admin">
									</div>
								</div>
								<div class="form-group">
									<label for="last_name" class="col-md-3 control-label">Last name</label>
									<div class="col-md-9">
										<input type="text" class="form-control" id="last_name" name="last_name" placeholder="Last name" value="istrator">
									</div>
								</div>
								<div class="form-group">
									<div class="col-md-offset-3 col-md-9">
										<button type="button" class="btn btn-primary btn-embossed btn-block" id="accountDetailsSubmit"><span class="fui-check"></span>
											Update Details</button>
									</div>
								</div>
							</form>

							<hr class="dashed">

							<form class="form-horizontal" role="form" id="account_login">

								<div class="loader" style="display: none;">
									<img src="/skin/pagebuilder/img/91.gif" alt="Loading...">
								</div>

								<div class="alerts"></div>

								<input type="hidden" name="id" value="1">
								<div class="form-group">
									<label for="email" class="col-md-3 control-label">User name</label>
									<div class="col-md-9">
										<input type="text" class="form-control" id="email" name="email" placeholder="User name" value="admin@admin.test">
									</div>
								</div>
								<div class="form-group">
									<label for="password" class="col-md-3 control-label">Password</label>
									<div class="col-md-9">
										<input type="password" class="form-control" id="password" name="password" placeholder="Password" value="">
									</div>
								</div>
								<div class="form-group">
									<div class="col-md-offset-3 col-md-9">
										<button type="button" class="btn btn-primary btn-embossed btn-block" id="accountLoginSubmit"><span class="fui-check"></span>
											Update Details</button>
									</div>
								</div>
							</form>

						</div>

					</div> <!-- /tab-content -->

				</div><!-- /.modal-body -->

				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal"><span class="fui-cross"></span>
						Cancel & Close</button>
				</div>

			</div><!-- /.modal-content -->

		</div><!-- /.modal-dialog -->

	</div><!-- /.modal -->

	<a href="#optimize_create_block" id="optimize_create_block_button" data-toggle="modal" data-siteid="1" style="display:none;">&nbps;</a>
	<div class="modal fade optimize_create_block" id="optimize_create_block" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					Block Optimize Settings
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" action="#">
						<div class="form-group">
							<label class="col-md-4 control-label">Add new variant or select available</label>
							
							<div class="col-md-6">
								<input type="text" class="form-control w-110 mrm" id="new_variant" style="vertical-align: top; display: inline-block;" name="variants" value="" readonly />
								<select name="variants" id="select_variant" class="selectpicker w-110">
									<option value="Create New">#</option>
								</select>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default btn-embossed" data-dismiss="modal"><span class="fui-cross"></span>Cancel & Close</button>
					<button type="button" class="btn btn-primary btn-embossed" id="btn_test_save"><span class="fui-check"></span>Save Settings</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	
	<a href="#optimize_create_variant" id="optimize_create_variant_button" data-toggle="modal" data-siteid="1" style="display:none;">&nbps;</a>
	<div class="modal fade optimize_create_variant" id="optimize_create_variant" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					Variant Optimize Settings
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" action="#">
					
						<div class="form-group">
							<label class="col-md-4 control-label">Automatically select winner at the end of the test</label>
							<div class="col-md-6" style="padding-top: 6px;">
								<input type="hidden" value="0" name="show" >
								<input type="checkbox" value="1" name="show" id="flg_select_winer" data-toggle="switch" checked>
							</div>
						</div>

						<div class="form-group">
							<label for="name" class="col-sm-3 control-label">How many days to run:</label>
							<div class="col-sm-9">
								<input type="number" class="form-control" id="optimize_days" name="optimize_days" value="1">
							</div>
						</div>
						
						<div class="form-group">
							<label for="name" class="col-sm-3 control-label">How many visits to run:</label>
							<div class="col-sm-9">
								<input type="number" class="form-control" id="optimize_visits" name="optimize_visits" value="100">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default btn-embossed" data-dismiss="modal"><span class="fui-cross"></span>Cancel & Close</button>
					<button type="button" class="btn btn-primary btn-embossed" id="optimize_create_variant_save"><span class="fui-check"></span>Save Settings</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->

	<div class="modal fade" id="optimize_toggle_variant" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					Show/Hide Optimize Settings
				</div>
				<div class="modal-body">
					<div class="form-group">
						<div class="row">
							<label for="" class="col-md-4 control-label">Hide on variants</label>

							<div class="col-md-6" id="variant_lists"></div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default btn-embossed" data-dismiss="modal"><span class="fui-cross"></span>Cancel & Close</button>
					<button type="button" class="btn btn-primary btn-embossed" id="optimize_toggle_variant_save"><span class="fui-check"></span>Save Settings</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->

	<div class="modal fade pageSettingsModal" id="pageSettingsModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="TRUE">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"><span aria-hidden="TRUE">&times;</span><span class="sr-only">Close</span></button>
					<h4 class="modal-title" id="myModalLabel"><span class="fui-gear"></span> Page Settings for <span class="text-primary pName">index.html</span></h4>
				</div>

				<div class="modal-body">
					<div class="loader" style="display: none;">
						<img src="/skin/pagebuilder/img/loading.gif" alt="Loading">
						Saving page settings...
					</div>

					<div class="modal-alerts"></div>
					<form class="form-horizontal" role="form" id="pageSettingsForm" action="{url name='site1_ecom_funnels' action='updatePageData'}">
						<input type="hidden" name="arrData[sites_id]" id="siteID" value="{$siteData.site.id}">
						<input type="hidden" name="arrData[id]" id="pageID" value="{if isset($pagesData.index)}{$pagesData.index.id}{/if}">
						<input type="hidden" name="arrData[pages_name]" id="pageName" value="{$pagesData.index.pages_name}">

						<div class="optionPane">
							<div class="form-group">
								<label for="name" class="col-sm-3 control-label">Page Title:</label>
								<div class="col-sm-9">
									<input type="text" class="form-control" id="pageData_title" name="arrData[pages_title]" placeholder="Page title" value="{if isset($pagesData.index)}{htmlspecialchars( $pagesData.index.pages_title )}{/if}">
								</div>
							</div>

							<div class="form-group">
								<label for="name" class="col-sm-3 control-label">Page Meta Description:</label>
								<div class="col-sm-9">
									<textarea class="form-control" id="pageData_metaDescription" name="arrData[pages_meta_description]" placeholder="Page meta description">{if isset($pagesData.index)}{$pagesData.index.pages_meta_description}{/if}</textarea>
								</div>
							</div>

							<div class="form-group">
								<label for="name" class="col-sm-3 control-label">Page Meta Keywords:</label>
								<div class="col-sm-9">
									<textarea class="form-control" id="pageData_metaKeywords" name="arrData[pages_meta_keywords]" placeholder="Page meta keywords">{if isset($pagesData.index)}{$pagesData.index.pages_meta_keywords}{/if}</textarea>
								</div>
							</div>

							<div class="form-group">
								<label for="name" class="col-sm-3 control-label">Header Includes:</label>
								<div class="col-sm-9">
									<textarea class="form-control" id="pageData_headerIncludes" name="arrData[pages_header_includes]" rows="7"
									 placeholder="Additional code you'd like to include in the <head> section">{if isset($pagesData.index)}{$pagesData.index.pages_header_includes}{/if}</textarea>
								</div>
							</div>

							<div class="form-group">
								<label for="global_css" class="col-sm-3 control-label">Header Script</label>
								<div class="col-sm-9">
									<textarea class="form-control" id="pageData_headerScript" name="arrData[pages_header_script]" placeholder="Header Script" rows="6">{if isset($pagesData.index)}{$pagesData.index.pages_header_script}{/if}</textarea>
								</div>
							</div>

							<div class="form-group">
								<label for="global_css" class="col-sm-3 control-label">Footer Script</label>
								<div class="col-sm-9">
									<textarea class="form-control" id="pageData_footerScript" name="arrData[pages_footer_script]" placeholder="Footer Script" rows="6">{if isset($pagesData.index)}{$pagesData.index.pages_footer_script}{/if}</textarea>
								</div>
							</div>

							<div class="form-group">
								<label for="name" class="col-sm-3 control-label">Page CSS:</label>
								<div class="col-sm-9">
									<textarea class="form-control" id="pageData_headerCss" name="arrData[pages_css]" rows="7" placeholder="CSS applied specifically to this page">{if isset($pagesData.index)}{$pagesData.index.pages_css}{/if}</textarea>
								</div>
							</div>

							<div class="form-group">
								<label for="name" class="col-sm-3 control-label">Included Google fonts:</label>
								<div class="col-sm-9">
									<input name="arrData[google_fonts]" class="tagsinput" id="pageData_googleFonts" placeholder="Google fonts included on this page"
									 value="">
								</div>
							</div>
						</div><!-- /.optionPane -->

						{if Core_Acs::haveAccess( array( 'iFunnels Studio Starter', 'iFunnels LTD Studio Starter' ) )}
						<div class="optionPane">
							<h6>Settings Protect</h6>
							<div class="form-group">
								<label class="col-md-3 control-label">Protection</label>
								<div class="col-md-9" style="padding-top: 6px;">
									<input type="hidden" value="0" name="arrData[protected]" >
									<input type="checkbox" value="1" name="arrData[protected]" id="protected_page" data-toggle="switch">
								</div>
							</div>

							<div class="form-group" data-protected="true" style="display: {if $arrData.protected == 1}block{else}none{/if};">
								<label class="col-md-3 control-label">Membership Lists:</label>
								
								<div class="col-md-9">
									<div class="blockCatSelection">
										<ul>
											{foreach from=$arrMemberships item=membership}
											<li>
												<label class="checkbox" for="membership_{$membership.id}">
													{$membership.name} / [{$membership.site_name}]
													<input type="checkbox" value="{$membership.id}" id="membership_{$membership.id}" data-toggle="checkbox" name="arrData[memberships][]" class="custom-checkbox">
												</label>
											</li>
											{/foreach}
										</ul>
									</div>
								</div>
							</div>

							<div class="form-group" data-protected="true" style="display: {if $arrData.protected == 1}block{else}none{/if};">
								<label class="col-md-3 control-label">Primary Membership:</label>
								
								<div class="col-md-9">
									<select name="arrData[primary_membership]" class="selectpicker" id="primary-membership"></select>
								</div>
							</div>
							
							<div class="form-group" data-protected="true" style="display: {if $arrData.protected == 1}block{else}none{/if};">
								<label class="col-md-3 control-label">Drip Feeding</label>
								<div class="col-md-9" style="padding-top: 6px;">
									<input type="hidden" value="0" name="arrData[drip_feed][enable]" >
									<input type="checkbox" value="1" name="arrData[drip_feed][enable]" id="drip_feed" data-toggle="switch">
								</div>
							</div>

							<div class="form-group" data-drip-feed="true" style="display: {if $arrData.drip_feed == 1}block{else}none{/if};">
								<label class="col-md-3 control-label">
									Available to members after 
								</label>

								<div class="col-md-9">
									<input type="text" class="form-control w-110 mrm" style="vertical-align: top; display: inline-block;" name="arrData[drip_feed][value]" id="drip_value" value="1" />
									<select name="arrData[drip_feed][after_period]" class="selectpicker w-110" id="after_period">
										<option value="week">Week</option>
										<option value="month">Month</option>
										<option value="year">Year</option>
									</select>
								</div>
							</div>
							
							<input type="hidden" value="" id="optimize_page_settings" name="arrData[optimize_page_settings]" >
						</div>
						{/if}

						{if Core_Acs::haveAccess( array( 'iFunnels Studio Performance', 'iFunnels LTD Studio Enterprise' ) )}
						<div class="optionPane">
							<h6>A/B Test <span class="label label-warning" style="margin-left: 10px; vertical-align: top; display: inline-block;">Beta</span></h6>

							<div class="form-group">
								<label class="col-md-4 control-label">Create an Optimization Test</label>

								<div class="col-md-8" style="padding-top: 6px;">
									<input type="hidden" value="0" name="arrData[optimization_test]" >
									<input type="checkbox" value="1" name="arrData[optimization_test]" id="optimization_test" data-toggle="switch">
								</div>
							</div>

							<div class="form-group" data-test="true" style="display: none;">
								<label class="col-sm-3 control-label">Optimization Test Name:</label>

								<div class="col-sm-9">
									<input type="text" class="form-control" name="arrData[optimization_test][name]" placeholder="Test Name" value="">
								</div>
							</div>

							<div class="form-group" data-test="true" style="display: none;">
								<label class="col-md-3 control-label">Goals:</label>
								
								<div class="col-md-9">
									<div class="blockCatSelection">
										<ul>
											<li class="h-auto">
												<label class="checkbox" for="goal_lead">
													Lead
													<input type="checkbox" value="1" id="goal_lead" data-toggle="checkbox" name="arrData[goals][]" class="custom-checkbox">
												</label>

												<div class="form-group clearfix">
													<label for="" class="control-label">Lead Value:</label>
													<div>
														<input type="text" class="form-control input-sm padding-right" name="arrData[goals][lead][value]">
														<span class="inputAppend">&dollar;</span>
													</div>

													<button type="button" class="btn btn-primary btn-embossed" data-goal="1" id="tracking_code_lead" style="margin-left: auto;">
														<span class="fui-upload"></span>&nbsp;
														Copy Tracking Code
													</button>
												</div>	
											</li>

											<li class="h-auto">
												<label class="checkbox" for="goal_registration">
													Registration
													<input type="checkbox" value="2" id="goal_registration" data-toggle="checkbox" name="arrData[goals][]" class="custom-checkbox">
												</label>

												<div class="form-group clearfix">
													<label for="" class="control-label">Registration Value:</label>

													<div>
														<input type="text" class="form-control input-sm padding-right" name="arrData[goals][registration][value]">
														<span class="inputAppend">&dollar;</span>
													</div>

													<button type="button" class="btn btn-primary btn-embossed" data-goal="2" id="tracking_code_registration" style="margin-left: auto;">
														<span class="fui-upload"></span>&nbsp;
														Copy Tracking Code
													</button>
												</div>
											</li>

											<li class="h-auto">
												<label class="checkbox" for="goal_sale">
													Sale
													<input type="checkbox" value="3" id="goal_sale" data-toggle="checkbox" name="arrData[goals][]" class="custom-checkbox">
												</label>

												<div class="form-group clearfix">
													<label for="" class="control-label">Sale Value:</label>

													<div>
														<input type="text" class="form-control input-sm padding-right" name="arrData[goals][sale][value]">
														<span class="inputAppend">&dollar;</span>
													</div>

													<button type="button" class="btn btn-primary btn-embossed" data-goal="3" id="tracking_code_sale" style="margin-left: auto;">
														<span class="fui-upload"></span>&nbsp;
														Copy Tracking Code
													</button>
												</div>
											</li>
										</ul>
									</div>
								</div>
							</div>
						</div>
						{/if}
					</form>
				</div><!-- /.modal-body -->

				<div class="modal-footer">
					<button type="button" class="btn btn-default btn-embossed" data-dismiss="modal"><span class="fui-cross"></span>
						Cancel & Close</button>
					<button type="button" class="btn btn-primary btn-embossed" id="pageSettingsSubmittButton"><span class="fui-check"></span>
						Save Settings</button>
				</div>

			</div><!-- /.modal-content -->

		</div><!-- /.modal-dialog -->

	</div><!-- /.modal -->

	<div class="modal fade errorModal" id="errorModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
	 aria-hidden="TRUE">

		<div class="modal-dialog">

			<div class="modal-content">

				<div class="modal-body">

				</div><!-- /.modal-body -->

				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal"><span class="fui-cross"></span>
						Close</button>
				</div>

			</div><!-- /.modal-content -->

		</div><!-- /.modal-dialog -->

	</div><!-- /.modal -->

	<div class="modal fade successModal" id="successModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
	 aria-hidden="TRUE">

		<div class="modal-dialog">

			<div class="modal-content">

				<div class="modal-body">

				</div><!-- /.modal-body -->

				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal"><span class="fui-cross"></span>
						Close</button>
				</div>

			</div><!-- /.modal-content -->

		</div><!-- /.modal-dialog -->

	</div><!-- /.modal -->

	<div class="modal fade backModal" id="backModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
	 aria-hidden="TRUE">

		<div class="modal-dialog">

			<div class="modal-content">

				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"><span aria-hidden="TRUE">&times;</span><span class="sr-only">Close</span></button>
					<h4 class="modal-title" id="myModalLabel"> Are you sure?</h4>
				</div>

				<div class="modal-body">
					<p>
						You've got pending changes, if you leave this page your changes will be lost. Are you sure? </p>
				</div><!-- /.modal-body -->

				<div class="modal-footer">
					<button type="button" class="btn btn-inverse" data-dismiss="modal"><span class="fui-cross"></span>
						Stay on this page!</button>
					<a href="sites" class="btn btn-primary btn-embossed" id="leavePageButton"><span class="fui-check"></span>
						Leave the page</a>
				</div>

			</div><!-- /.modal-content -->

		</div><!-- /.modal-dialog -->

	</div><!-- /.modal -->

	<!-- edit content popup -->
	<div class="modal fade" id="editContentModal" tabindex="-1" role="dialog" aria-hidden="TRUE">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body">
					<textarea id="contentToEdit"></textarea>
				</div><!-- /.modal-body -->

				<div class="modal-footer">
					<button type="button" class="btn btn-default btn-embossed" data-dismiss="modal">Cancel & Close</button>
					<button type="button" type="button" class="btn btn-primary btn-embossed" id="updateContentInFrameSubmit">Update
						Content</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->

	</div><!-- /.modal -->

	<!-- preview popup -->
	<div class="modal fade" id="previewModal" tabindex="-1" role="dialog" aria-hidden="TRUE">

		<form action="{url name="site1_ecom_funnels" action="livepreview"}" target="_blank" id="markupPreviewForm" method="post"
		 class="form-horizontal">

			<input type="hidden" name="markup" value="" id="markupField2">

			<div class="modal-dialog">

				<div class="modal-content">

					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"><span aria-hidden="TRUE">&times;</span><span class="sr-only">Close</span></button>
						<h4 class="modal-title" id="myModalLabel"><span class="fui-window"></span> Site Preview</h4>
					</div>

					<div class="modal-body">
						<p>
							Please note that the preview will always show your latest changes, even if these have not
							been saved yet. <br><b>Links do not work in the preview; you can only preview the page you
								are currently working on.</b> </p>
					</div><!-- /.modal-body -->

					<div class="modal-footer">
						<button type="button" class="btn btn-default btn-embossed" data-dismiss="modal"><span class="fui-cross"></span>
							Cancel & Close</button>
						<button type="submit" class="btn btn-primary btn-embossed"><span class="fui-export"></span>
							Preview Changes</button>
					</div>

				</div><!-- /.modal-content -->

			</div><!-- /.modal-dialog -->

		</form>

	</div><!-- /.modal -->

	<div class="sandboxes" id="sandboxes" style="display: none"></div>

	<template id="frameCoverPopupTemplate">
        <div class="frameCover forPopup">
            <div class="pull-right divPopupID"></div>
            <div class="pull-right divPopupDelayWrapper">
                <select class="form-control select select-sm pull-right select-default mbl selectPopupDelay" data-toggle="select">
                    <option value="0">Delay 0 seconds</option>
                    <option value="5">Delay 5 seconds</option>
                    <option value="10">Delay 10 seconds</option>
                    <option value="20">Delay 20 seconds</option>
                    <option value="30">Delay 30 seconds</option>
                    <option value="60">Delay 1 minutes</option>
                    <option value="120">Delay 2 minutes</option>
                    <option value="300">Delay 5 minutes</option>
                    <option value="600">Delay 10 minutes</option>
                    <option value="900">Delay 15 minutes</option>
                    <option value="1800">Delay 30 minutes</option>
                </select>
            </div>
            <div class="pull-right divPopupOccurrenceWrapper">
                <select class="form-control select select-sm pull-right select-info mbl selectPopupRecurrence" data-toggle="select">
                    <option value="All">Show popup on every visit</option>
                    <option value="Once">Show popup on first visit only</option>
                </select>
            </div>
            <button class="btn btn-inverse btn-sm deleteBlock" type="button" data-toggle="tooltip" title="Delete this popup from the canvas">
                <i class="fui-trash"></i>
            </button>
            <button class="btn btn-inverse btn-sm resetBlock" type="button" data-toggle="tooltip" title="Reset this popup to its original state">
                <i class="fa fa-refresh"></i>
            </button>
			
			{*<button class="btn btn-inverse btn-sm favBlock" type="button" data-toggle="tooltip" title="Save this popup as a template"
			 data-saving="Saving..." data-confirmation="Saved!">
				<i class="fa fa-star-o"></i>
			</button>*}
			
            <button class="btn btn-inverse btn-sm htmlBlock" type="button" data-toggle="tooltip" title="Edit this popups source code">
                <i class="fa fa-code"></i>
            </button>
            <button class="frameCoverToggle"><span class="fui-gear"></span></button>
        </div>
    </template>

	<template id="frameCoverTemplate">
		<div class="frameCover">
			<button class="btn btn-inverse btn-sm deleteBlock" type="button" data-toggle="tooltip" title="Delete this block from the canvas">
				<i class="fui-trash"></i>
			</button>
			<button class="btn btn-inverse btn-sm resetBlock" type="button" data-toggle="tooltip" title="Reset this block to its original state">
				<i class="fa fa-refresh"></i>
			</button>
			<button class="btn btn-inverse btn-sm htmlBlock" type="button" data-toggle="tooltip" title="Edit this blocks source code">
				<i class="fa fa-code"></i>
			</button>
			<button class="btn btn-inverse btn-sm dragBlock" type="button" data-toggle="tooltip" title="Drag and drop this block">
				<i class="fa fa-arrows"></i>
			</button>
			<button class="btn btn-inverse btn-sm favBlock" type="button" data-toggle="tooltip" title="Save this block as a template" data-saving="Saving..." data-confirmation="Saved!">
                <i class="fa fa-star-o"></i>
            </button>
			<label class="checkbox primary">
				<input type="checkbox" data-toggle="checkbox" class="custom-checkbox">
				Global </label>
			<button class="frameCoverToggle"><span class="fui-gear"></span></button>
		</div>
	</template>

	<template id="templateParallaxInfo">
		<div class="alert alert-info">
			<button class="close fui-cross" data-dismiss="alert"></button>
			<p>
				<b>Please note</b> the parallax functionality does not work inside the page builder; use the preview to
				see the parallax in action. </p>
		</div>
	</template>

	<template id="sourceEditorButtons">
		<button class="btn btn-danger editCancelButton btn-sm" id="editCancelButton"><i class="fui-cross"></i> <span>Cancel</span></button>
		<button class="btn btn-primary editSaveButton btn-sm" id="editSaveButton"><i class="fui-check"></i> <span>Save</span></button>
	</template>

	<section class="lockscreen">
		<div class="lockscreen__container">
			<div class="lockscreen__container__logo">
				<img src="/skin/i/frontends/ifunnels-logo-vertical-centered.png" alt="">
			</div>
			<h4 class="lockscreen__container__username"></h4>
			<p class="lockscreen__container__text">Enter your password to access the dashboard.</p>

			<form method="post">
				<div class="input-group m-t-30">
					<input type="hidden" name="arrLogin[username]" value="" />
					<input type="password" class="form-control" name="arrLogin[passwd]" placeholder="Password" required="" />
					<span class="input-group-btn">
						<button type="submit" class="btn btn-primary w-sm waves-effect waves-light">
							Log In
						</button> 
					</span>
				</div>
			</form>
		</div>
		<p class="lockscreen__signin">Not <span></span>? <a href="/"><strong>Sign In</strong></a></p>
	</section>

	<!-- Load JS here for greater good =============================-->
	<script src="/skin/pagebuilder/build/builder.bundle.js"></script>
	<script src="/skin/ifunnels-studio/dist/js/lockscreen.bundle.js"></script>
	<script src="/skin/pagebuilder/build/lazyload.bundle.js"></script>

	<script src="/skin/light/plugins/bootstrap-filestyle/src/bootstrap-filestyle.min.js" type="text/javascript"></script>
</body>
</html>