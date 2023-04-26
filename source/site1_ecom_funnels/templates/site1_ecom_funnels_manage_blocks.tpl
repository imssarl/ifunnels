<style>
	.m-b-20 {
		margin-bottom: 20px;
	}
	[data-block-container] {
		-moz-column-count: 5;
		-moz-column-gap: 20px;
		-webkit-column-count: 5;
		-webkit-column-gap: 20px;
		column-count: 5;
		column-gap: 20px;
		width: 99%;
	}

	[data-block-container] *,
	#manageBlockModal * {
		box-sizing: border-box;
	}

	[data-block-id] {
		display: inline-block;
		margin-bottom: 30px;
		width: 100%;
		-webkit-column-break-inside: avoid;
		page-break-inside: avoid;
		break-inside: avoid;

		border-radius: 5px;
		border: 2px solid #d4dadd;
		cursor: pointer;
		transition: border-color 0.5s ease-in-out;
		padding: 10px;
	}

	[data-block-container] [data-block-id]:hover {
		border-color: #239F85;
	}

	[data-block-id] > img {
		max-width: 100%;
	}

	.modal-header .close {
		float: right;
		font-size: 21px;
		font-weight: 700;
		line-height: 1;
		color: #000;
		text-shadow: 0 1px 0 #fff;
		filter: alpha(opacity=20);
		opacity: .2;
		-webkit-appearance: none;
		padding: 0;
		cursor: pointer;
		background: 0 0;
		border: 0;
		-webkit-appearance: none;
		padding: 0;
		cursor: pointer;
		background: 0 0;
		border: 0;
	}

	.modal-header .close span:first-child {
		margin: 5px 0 0;
		padding: 0;
		font-size: 18px;
		line-height: 1;
		color: #34495e;
	}

	[data-toggle="tooltip"] {
		display: inline;
		line-height: 1;
		color: #fff;
		text-align: center;
		white-space: nowrap;
		vertical-align: baseline;
		border-radius: .25em;
		font-size: 76%;
		font-weight: normal;
		padding: .25em .6em .29em;
		background-color: #ebedef;
		color: #7b8996;
		cursor: help;
		}

</style>
<link rel="stylesheet" href="/skin/_css/bootstrap-button/css/bootstrap.css">
<h3>{$arrPrm.title}</h3>
<div class="row m-b-20">
	<div class="col-md-2">
		Filter Category: 
		<select name="category">
			<option value="">-select-</option>
			{foreach from=$arrCategoryes item=category}
			<option value="{$category.id}">{$category.category_name}</option>
			{/foreach}
		</select>
	</div>
	<div class="col-md-2 col-md-offset-4">
		<a href="#manageCategoriesModal" data-toggle="modal" class="js-manageCategories btn btn-info"><span class="fui-arrow-right"></span> Manage block categories</a>
	</div>
	<div class="col-md-2">
		<a href="#addBlockModal" data-toggle="modal" class="js-manageCategories btn btn-info"><span class="fui-arrow-right"></span> Add block</a>
	</div>
</div>
<div class="card-box" data-block-container="">
	{foreach from=$arrBlocks item=block}
	<div class="block" data-block-id="{$block.id}" data-block-cat="{$block.blocks_category}">
		<img src="{Zend_Registry::get('config')->path->html->pagebuilder}{$block.blocks_thumb}" alt="" />
	</div>
	{/foreach}

	<div class="row">
		{include file="../../pgg_backend.tpl"}
	</div>
</div>

<div class="modal fade manageBlockModal" id="manageBlockModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<form id="formBlockDetails" method="post" action="{url name="site1_ecom_funnels" action="b_updateBlock"}">
			<input type="hidden" name="blockHeight" value="0">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
					<h4 class="modal-title" id="myModalLabel"><span class="fui-info"></span> Edit block</h4>
				</div>

				<div class="modal-body">
					<div id="divBlockLoading" style="text-align: center">
						<img src="{Zend_Registry::get('config')->path->html->pagebuilder}img/loading.gif">
					</div>

					<div class="editBlockDetails" id="divBlockModalBody"></div>
				</div><!-- /.modal-body -->

				<div class="modal-footer">
					<div class="deleteBlock pull-left">
						<a href="#" class="deleteBlock" id="buttonDeleteBlock" style="display: inline;">
							<span class="fui-cross"></span>
							Delete block
						</a>
					</div>
					<button type="submit" class="btn btn-primary" id="buttonUpdateBlock" data-loading="Saving..." data-calc-height="Calculating block height..." data-text="Save changes">
						<span class="fui-check"></span>
						<span class="tlabel">Save changes</span>
					</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">
						<span class="fui-cross"></span>
						Cancel
					</button>
				</div>
			</div><!-- /.modal-content -->
		</form>
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<div class="modal fade manageCategoriesModal" id="manageCategoriesModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title" id="myModalLabel"><span class="fui-info"></span> Manage block categories</h4>
			</div>

			<div class="modal-body">
				<table class="info glow"id="tableBlockCategories">
					<thead>
						<tr>
							<th align="left">Name</th>
							<th style="width: 30%">Actions</th>
						</tr>
					</thead>
					<tbody>
						{foreach from=$arrCategoryes item=category}
						<tr>
							<td class="tdCatName">{$category.category_name}</td>
							<td class="actions">
								<a href="" class="text-primary linkBlockcatEdit" data-cat-id="{$category.id}">Edit</a>
								<a href="" class="text-danger linkBlockcatDel" data-cat-id="{$category.id}">Delete</a>
							</td>
						</tr>
						{/foreach}
					</tbody>
					<tfoot>
						<tr class="rowAddCategory">
							<td colspan="2">
								<div class="input-group">
									<input type="text" class="form-control" name="inputNewCategory" id="inputNewCategory" placeholder="New category" />
									<span class="input-group-btn">
										<button class="btn btn-primary" id="buttonAddNewCategory" disabled data-loading="Adding..." data-text="Add">Add</button>
									</span>
								</div>
							</td>
						</tr>
					</tfoot>
				</table>

			</div><!-- /.modal-body -->

			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal"><span class="fui-cross"></span> Cancel & Close</button>
			</div>

		</div><!-- /.modal-content -->

	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<div class="modal fade addBlockModal in" id="addBlockModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false">
	<div class="modal-dialog">
		<form id="formAddBlock" method="post" action="{url name="site1_ecom_funnels" action="addblock"}">
			<input type="hidden" name="blockHeight" value="0">
			<input type="hidden" name="action" value="new_block">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">Close</span></button>
					<h4 class="modal-title" id="myModalLabel"><span class="fui-info"></span> Add block</h4>
				</div>

				<div class="modal-body">

					<div id="divBlockLoading" style="text-align: center; display: none">
						<img src="{Zend_Registry::get('config')->path->html->pagebuilder}img/loading.gif">
					</div>

					<div class="addBlockDetails" id="divNewBlockModalBody">
						<div class="row">
							<div class="col-md-6">
								<div class="form-group margin-bottom-0" id="divAddBlockCatSelectWrapper">
									<label for="exampleInputEmail1">Block category:</label>
									<select class="form-control select select-default select-block select-sm mbl" name="blockCategory" data-with-search="" tabindex="-1" title="" >
										{foreach from=$arrCategoryes item=category}
										<option value="{$category.id}">{$category.category_name}</option>
										{/foreach}
									</select>
								</div><!-- /.form-group -->
							</div><!-- /.row -->
							<div class="col-md-6 blockTemplate">
								<div class="form-group margin-bottom-0">
									<label>Choose an existing file:</label>
									<select name="blockUrl" class="form-control" placeholder="URL to HTML file" id="selectTemplateFile">
										{foreach from=$arrBlocks item=block}
										<option value="{$block.blocks_url}">{$block.blocks_url}</option>
										{/foreach}
									</select>
								</div><!-- /.form-group -->
							</div><!-- /.row -->
						</div><!-- /.row -->

						<div class="row">
							<div>
								<label class="checkbox col-md-8" for="blockFullHeight">
									<input type="checkbox" value="check" name="blockFullHeight" id="blockFullHeight" data-toggle="checkbox" class="custom-checkbox"><span class="icons"><span class="icon-unchecked"></span><span class="icon-checked"></span></span>
									Block uses full height of viewport <span class="label label-default heightHelp" data-toggle="tooltip" title="" data-original-title="Check this checkbox if you want this block to use the full height of the browser's viewport">?</span>
								</label>
							</div><!-- /.col -->
						</div><!-- /.row -->
					</div>

				</div><!-- /.modal-body -->

				<div class="modal-footer">
					<button type="submit" class="btn btn-primary" id="buttonCreateBlock" data-loading="Saving..." data-calc-height="Calculating block height..." data-text="Create block">
						<span class="fui-check"></span>
						<span class="tlabel">Create block</span>
					</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">
						<span class="fui-cross"></span>
						Cancel                            </button>
				</div>
			</div><!-- /.modal-content -->
		</form>
	</div><!-- /.modal-dialog -->
</div>

<link rel="stylesheet" href="/skin/_js/bootstrap-modal/css/bootstrap.min.css" />
<script src="/skin/light/js/jquery.min.js"></script>
<script src="/skin/_js/bootstrap-modal/js/bootstrap.min.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

{literal}
<script>
	jQuery(document).ready(function(){
		jQuery('.menu_js_hdl').on('click', function(){
			jQuery('#' + jQuery(this).prop('rel')).stop(true, true).slideToggle('fast');
			return false;
		});

		jQuery('[name="category"]').on('change', function(){
			jQuery('[data-block-id]').show();
			if(jQuery(this).prop('value') !== '1' && jQuery(this).prop('value') !== ''){
				jQuery('[data-block-id]:not([data-block-cat="' + jQuery(this).prop('value') + '"])').stop(true, true).fadeOut('fast');
			}
		});

		jQuery('.linkBlockcatEdit').on('click', editCategory);

		jQuery('#inputNewCategory').on('keyup', function () {
			let self = this;
			// empty input field?
			if ( this.value !== '' ) jQuery('#buttonAddNewCategory').prop('disabled', false);
			else jQuery('#buttonAddNewCategory').prop('disabled', true);

			// unique input field value?
			if ( this.value !== '' ) {
				jQuery('#tableBlockCategories').find('.tdCatName').each(function(){
					if (jQuery(this).text() === self.value) jQuery('#buttonAddNewCategory').prop('disabled', true)
				});
			}
		});

		jQuery('#buttonAddNewCategory').on('click', function(){
			buttonAddNewCategory.innerText = buttonAddNewCategory.getAttribute('data-loading');
			buttonAddNewCategory.setAttribute('disabled', true);

			$.ajax({
				url: '{/literal}{url name="site1_ecom_funnels" action="manage_blocks"}{literal}',
				type: 'post',
				dataType: 'json',
				data: {
					action: 'new_category',
					catname: inputNewCategory.value
				}
			}).done(function (ret) {

				buttonAddNewCategory.innerText = buttonAddNewCategory.getAttribute('data-text');
				buttonAddNewCategory.removeAttribute('disabled');

				if ( ret.responseCode === 1 ) {// all good

					$('#tableBlockCategories').find('tbody').empty();
					ret.arrCategory.forEach(function(item){
						$('#tableBlockCategories')
							.find('tbody')
							.append(
								'<tr>' +
									'<td class="tdCatName">${item.category_name}</td>' +
									'<td class="actions">' +
										'<a href="" class="text-primary linkBlockcatEdit" data-cat-id="${item.id}">Edit</a> ' +
										'<a href="" class="text-danger linkBlockcatDel" data-cat-id="${item.id}">Delete</a>' +
									'</td>' +
								'</tr>'
							);
					});

					jQuery('.linkBlockcatDel').off('click').on('click', deleteCategory);
					jQuery('.linkBlockcatEdit').off('click').on('click', editCategory);

					inputNewCategory.value = "";
					buttonAddNewCategory.disabled = true;

				} else if ( ret.responseCode === 0 ) {// not so good
					$('#tableBlockCategories').insertBefore('<p style="margin-bottom: 20px; color: #fff; background: rgba(255, 0, 0, .6); padding: 5px;">Error! Reload page and try again.</p>');
				}
			});
			return false;
		});

		jQuery('.linkBlockcatDel').on('click', deleteCategory);

		function removeCatUpdate(catID) {

			var catName = $('#tableBlockCategories').find('.input-group[data-cat-id="' + catID + '"]').find('input').val(),
				theTR = $('#tableBlockCategories').find('.input-group[data-cat-id="' + catID + '"]').closest('tr');

			// remove INPUT
			$('#tableBlockCategories').find('.input-group[data-cat-id="' + catID + '"]').fadeOut(function () {

				theTR.find('.tdCatName').text(catName).removeAttr('colspan');
				theTR.find('.actions').css('display', 'table-cell');

			});

		}

		function deleteCategory(){
			let self = this;
			jQuery.ajax({
				url: '{/literal}{url name="site1_ecom_funnels" action="manage_blocks"}{literal}',
				type: 'post',
				data : {
					category_id :  jQuery(this).data('cat-id')
				},
				dataType: 'json'
			}).done(function (result) {
				if(result.responseCode === 1){
					jQuery(self).parent().parent().stop(true, true).fadeOut('fast', () => {
						jQuery(self).parent().parent().remove();
					});
				} else {
					swal({
						title: "Error",
						text: "Please, try again",
						icon: "warning",
						buttons: false,
						timer: 2000
					})
				}
			});
			
			return false;
		}

		function editCategory(){
			var catID = this.getAttribute('data-cat-id');

			// create INPUT
			var input = jQuery('<div class="input-group" style="display: none; width: 100%" data-cat-id="${catID}">\
					<input type="text" class="form-control" name="inputNewCategory" id="inputNewCategory" placeholder="">\
					<span class="input-group-btn">\
						<button class="btn btn-primary js_buttonEditCategorySave" >Save</button>\
						<button class="btn btn-default js_buttonEditCategoryCancel" >Cancel</button>\
					</span>\
				</div>');

			input.find('input').val(jQuery(this).closest('tr').find('.tdCatName').text());
			jQuery(this).closest('tr').find('.tdCatName').text('');

			// place INPUT in TD
			jQuery(this).closest('tr').find('.tdCatName').append(input);

			// focus on INPUT
			input.find('input').focus();

			// modify table layout
			jQuery(this).closest('td').css('display', 'none');
			jQuery(this).closest('tr').find('.tdCatName').attr('colspan', 2);

			input.fadeIn();

			jQuery('.js_buttonEditCategoryCancel').on('click', function () {
				var catID = jQuery(this).closest('.input-group').attr('data-cat-id');
				removeCatUpdate(catID);
				return false;
			});

			jQuery('.js_buttonEditCategorySave').on('click', function(){
				var catID = jQuery(this).closest('.input-group').attr('data-cat-id');
				var catName = $('#tableBlockCategories').find('.input-group[data-cat-id="' + catID + '"]').find('input').val();
				jQuery.ajax({
					url: '{/literal}{url name="site1_ecom_funnels" action="manage_blocks"}{literal}',
					type: 'post',
					data : {
						category_id :  catID,
						category_name : catName
					},
					dataType: 'json'
				}).done(function (result) {
					if(result.responseCode === 1){
						removeCatUpdate(catID);
					} else {
						swal({
							title: "Error",
							text: "Please, try again",
							icon: "warning",
							buttons: false,
							timer: 2000
						})
					}
				});
			});	

			return false;
		}

		jQuery('[data-block-id]').on('click', function(){
			jQuery('#divBlockModalBody').html('');
			jQuery('#blockLoaderAnimation').fadeIn();

			jQuery('#manageBlockModal').modal('show');

			jQuery.ajax({
				url: '{/literal}{url name="site1_ecom_funnels" action="loadBlock"}{literal}',
				type: 'post',
				data : {
					block_id :  jQuery(this).data('block-id')
				},
				dataType: 'json'
			}).done(function (ret) {
				jQuery('#divBlockLoading').fadeOut(function () {
					jQuery('#manageBlockModal').find('input[name="blockHeight"]').prop('value', ret.forTemplate.block.blocks_height);
					jQuery('#divBlockModalBody').append(jQuery(ret.markup.replace(/(?:\\r\\n|\\r|\\n|\t)/g, ' ')));
					
					jQuery('#formBlockDetails').off('submit').on('submit', (e) => {
						e.preventDefault();
						jQuery(this).prop('disabled', true);
						jQuery(this).find('.tlabel').html(jQuery(this).data('loading'));

						let form = jQuery('#formBlockDetails');
						let formAction = form.prop('action');

						jQuery.ajax({
							url : formAction,
							data : form.serialize(),
							cache : false,
							dataType: "json",
							type : 'POST'
						}).done(function(ret) {

							jQuery('#buttonUpdateBlock').prop('disabled', false);
							jQuery('#buttonUpdateBlock').find('.tlabel').html(jQuery('#buttonUpdateBlock').data('text'));

							if(ret.responseCode === 0){
								swal({
									title: ret.responseHTML.header,
									text: ret.responseHTML.content,
									icon: "warning",
									buttons: false,
  									timer: 2000
								})
							}
							if(ret.responseCode === 1){
								swal({
									title: ret.responseHTML.header,
									text: ret.responseHTML.content,
									icon: "success",
									buttons: false,
  									timer: 2000
								});

								if(ret.block.blocks_thumb !== undefined){
									jQuery('.blockThumbnail img').prop('src', "{/literal}{Zend_Registry::get('config')->path->html->pagebuilder}{literal}" + ret.block.blocks_thumb);
									jQuery('[data-block-id="' + ret.block.id + '"] img').prop('src', "{/literal}{Zend_Registry::get('config')->path->html->pagebuilder}{literal}" + ret.block.blocks_thumb);
								}
							}
						});
						return false;
					});

					jQuery('#buttonDeleteBlock').off('click').on('click', (e) => {
						swal({
							title: "Are you sure?",
							text: "Can not be undone. Confirm?",
							icon: "warning",
							buttons: true,
							dangerMode: true,
						})
						.then((willDelete) => {
							if (willDelete) {
								let block_id = jQuery('[name="blockID"]').prop('value')
								jQuery.ajax({
									url: '{/literal}{url name="site1_ecom_funnels" action="b_deleteBlock"}{literal}',
									type: 'post',
									data : {
										block_id : block_id
									},
									dataType: 'json'
								}).done(function(ret){
									if( ret.responseCode === 0 ) {
										jQuery('#divBlockModalBody').prepend(jQuery(ret.responseHTML));
									} else if ( ret.responseCode === 1 ) {
										jQuery('#manageBlockModal').modal('hide');
										jQuery('[data-block-id="' + block_id + '"]').stop(true, true).fadeOut('fast');
									}
								});
							}
						});
						return false;
					});
				});
			});
		});
	
		jQuery('#formAddBlock').on('submit', function () {

			jQuery('#buttonCreateBlock').prop('disabled', true);
			jQuery('#buttonCreateBlock').find('.tlabel').html(jQuery('#buttonCreateBlock').prop('data-loading'));

			let form = $(this);
			let formdata = false;

			if (window.FormData){
				formdata = new FormData(form[0]);
			}

			let formAction = form.attr('action');

			$.ajax({
				url : formAction,
				data : formdata ? formdata : form.serialize(),
				cache : false,
				contentType : false,
				processData : false,
				dataType: "json",
				type : 'POST'
			}).done(function (ret) {

				buttonCreateBlock.removeAttribute('disabled');
				buttonCreateBlock.querySelector('.tlabel').innerText = buttonCreateBlock.getAttribute('data-text');

				if ( ret.responseCode === 1 ) {
					swal("Success!", "Block was added!", "success").then((willDelete) => {
						window.location.reload();
					});
				} else {
					swal({
						title: "Error!",
						text: "Reload page & try again",
						icon: "error"
					});
				}
			});

			return false;

		});
	});
</script>
{/literal}