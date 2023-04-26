<div class="row">
    <div class="col-lg-12">
        {if $msg!=''}
        <div class="alert alert-success alert-dismissable">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">x</button>
            <div>{$msg}</a></div>
        </div>
        {/if}
        {if $error!=''}
            {include file='../../message.tpl' type='error' message=$error}
        {/if}
        <div class="form-group">
            <a href="https://help.ifunnels.com/collection/40-affiliate-funnels" target="_blank" class="btn btn-info btn-rounded waves-effect waves-light">
               <span class="btn-label"><i class="fa fa-exclamation"></i></span>Watch the Online Tutorials Here
           </a>
        </div>
    </div>      
    <div class="col-lg-12">
        <ul class="nav nav-tabs navtab-bg nav-justified">
            <li class="nav-item active">
                <a href="#affiliate" data-toggle="tab" aria-expanded="false" class="nav-link">
                    Affiliate Settings
                </a>
            </li>
            <li class="nav-item">
                <a href="#autoresponder" data-toggle="tab" aria-expanded="true" class="nav-link active">
                    Autoresponder Settings
                </a>
            </li>
        </ul>
        <div class="tab-content">
            <div class="tab-pane active" id="affiliate">
                <form method="post">
                    <input type="hidden" name="arrCnt[id]" value="{if !empty($arrCnt.id)}{$arrCnt.id}{/if}">
                    <input type="hidden" name="arrCnt[flg_source]" value="102" />
                    <input type="hidden" name="arrCnt[flg_default]" value="1" />
                    <div class="form-group row">
                        <label class="col-md-12 col-form-label">Warrior Plus &nbsp;<a href="https://warriorplus.com" traget="_blank">Join Here</a></label>
                        <div class="col-md-12">
                            <input type="text" class="form-control" name="arrCnt[settings][warrior_plus]" value="{if !empty($arrCnt.settings.warrior_plus)}{$arrCnt.settings.warrior_plus}{/if}" />
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-md-12 col-form-label">Jvzoo ID &nbsp;<a href="https://jvzoo.com" traget="_blank">Join Here</a></label>
                        <div class="col-md-12">
                            <input type="text" class="form-control" name="arrCnt[settings][jvzoo]" value="{if !empty($arrCnt.settings.jvzoo)}{$arrCnt.settings.jvzoo}{/if}" />
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-md-12 col-form-label">Clickbank ID &nbsp;<a href="https://clickbank.com" traget="_blank">Join Here</a></label>
                        <div class="col-md-12">
                            <input type="text" class="form-control" name="arrCnt[settings][clickbank]" value="{if !empty($arrCnt.settings.clickbank)}{$arrCnt.settings.clickbank}{/if}" />
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-md-12 col-form-label">PaykickStart &nbsp;<a href="https://app.paykickstart.com/register/affiliate" traget="_blank">Join Here</a></label>
                        <div class="col-md-12">
                            <input type="text" class="form-control" name="arrCnt[settings][paykickstart]" value="{if !empty($arrCnt.settings.paykickstart)}{$arrCnt.settings.paykickstart}{/if}" />
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-md-12 col-form-label">Zaxaa &nbsp;<a href="https://zaxaa.com" traget="_blank">Join Here</a></label>
                        <div class="col-md-12">
                            <input type="text" class="form-control" name="arrCnt[settings][zaxaa]" value="{if !empty($arrCnt.settings.zaxaa)}{$arrCnt.settings.zaxaa}{/if}" />
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-md-12 col-form-label">ThriveCart</label>
                        <div class="col-md-12">
                            <input type="text" class="form-control" name="arrCnt[settings][thrivecart]" value="{if !empty($arrCnt.settings.thrivecart)}{$arrCnt.settings.thrivecart}{/if}" />
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-md-12 col-form-label">Paydtotcom&nbsp;<a href="https://paydotcom.com/" traget="_blank">Join Here</a></label>
                        <div class="col-md-12">
                            <input type="text" class="form-control" name="arrCnt[settings][paydotcom]" value="{if !empty($arrCnt.settings.paydotcom)}{$arrCnt.settings.paydotcom}{/if}" />
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-md-12 col-form-label">Clickfunnels</label>
                        <div class="col-md-12">
                            <input type="text" class="form-control" name="arrCnt[settings][clickfunnels]" value="{if !empty($arrCnt.settings.clickfunnels)}{$arrCnt.settings.clickfunnels}{/if}" />
                        </div>
                    </div>
                    <div class="form-group">
                        <button class="submit button btn btn-success waves-effect waves-light">Save</button>
                    </div>
                </form>
            </div>
            <div class="tab-pane" id="autoresponder">
				<div class="card-box">
					<a href="{url name='site1_mooptin' action='autoresponder'}" class="popup" title="Add New Lead Setting">Add New Lead Setting</a><br/>
					<table class="table table-striped" style="width:98%">
						<thead>
							<tr>
								<th>Name</th>
								<th width="180">Options</th>
							</tr>
						</thead>
						<tbody>{if count($arrList)>0}
							{foreach $arrList as $v}
							<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
								<td>{$v.name}</td>
								<td class="option">
									<a href="{url name='site1_mooptin' action='autoresponder' wg="id={$v.id}"}" class="popup"><i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i></a>
									<a href="{url name='site1_funnels' action='settings' wg="del={$v.id}"}"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
								</td>
							</tr>
							{/foreach}
							<tr>
								<td colspan="2">{include file="../../pgg_backend.tpl"}</td>
							</tr>
							{else}
							<tr>
								<td colspan="2">No elements</td>
							</tr>
							{/if}
						</tbody>
					</table>
					
				</div>
				{literal}
				<script type="text/javascript">
					window.placeAutoresponder=function(){
						location.reload();
					}

					window.mooptinpopup=new CeraBox( $$('.popup'), {
						group: false,
						width:'{/literal}{$arrUser.arrSettings.popup_width|default:80}{literal}%',
						height:'{/literal}{$arrUser.arrSettings.popup_height|default:80}{literal}%',
						displayTitle: true,
						titleFormat: '{title}',
						fixedPosition: true
					});
				</script>
				{/literal}
            </div>
        </div>
    </div>
</div>
{literal}
<script type="text/javascript">
    {/literal}{if !$flgLoad}{literal}
    {/literal}{/if}{literal}
    function aweber_disconnect() {
        jQuery("#ulp-aweber-loading").fadeIn(350);
        jQuery("#ulp-aweber-message").slideUp(350);
        var data = {action: "aweber-disconnect"};
        jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', data, function(return_data) {
            jQuery("#ulp-aweber-loading").fadeOut(350);
            try {
                //alert(return_data);
                var data = jQuery.parseJSON(return_data);
                var status = data.status;
                if (status == "OK") {
                    jQuery("#ulp-aweber-connection").slideUp(350, function() {
                        jQuery("#ulp-aweber-connection").html(data.html);
                        jQuery("#ulp-aweber-connection").slideDown(350);
                    });
                } else if (status == "ERROR") {
                    jQuery("#ulp-aweber-message").html(data.message);
                    jQuery("#ulp-aweber-message").slideDown(350);
                } else {
                    jQuery("#ulp-aweber-message").html("Service for disconnect aweber is not available.");
                    jQuery("#ulp-aweber-message").slideDown(350);
                }
            } catch(error) {
                jQuery("#ulp-aweber-message").html("Service for disconnect aweber is not available. Error: "+error);
                jQuery("#ulp-aweber-message").slideDown(350);
            }
        });
        return false;
    }
    
    function aweber_connect() {
        jQuery("#ulp-aweber-loading").fadeIn(350);
        jQuery("#ulp-aweber-message").slideUp(350);
        var data = {action: "aweber-connect", "aweber-oauth-id": jQuery("#aweber_oauth_id").val()};
        jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', data, function(return_data) {
            jQuery("#ulp-aweber-loading").fadeOut(350);
            try {
                //alert(return_data);
                var data = jQuery.parseJSON(return_data);
                var status = data.status;
                if (status == "OK") {
                    jQuery("#ulp-aweber-connection").slideDown(350, function() {
                        // тут getList =======================================================
                        var flgHaveLists=false;
                        for (var listId in data.lists) {
                            flgHaveLists=true;
                        }
                        $('aweber_consumer_key').set('value', data.api_settings.aweber_consumer_key);
                        $('aweber_consumer_secret').set('value', data.api_settings.aweber_consumer_secret);
                        $('aweber_access_key').set('value', data.api_settings.aweber_access_key);
                        $('aweber_access_secret').set('value', data.api_settings.aweber_access_secret);
                        if( !flgHaveLists ){
                            jQuery("#aweber_empty_lists").slideDown(350);
                            jQuery("#aweber_show_lists").slideUp(350);
                        }else{
                            jQuery("#aweber_show_lists").slideDown(350);
                            jQuery("#aweber_empty_lists").slideUp(350);
                        }
                        /*jQuery('.selectpicker').selectpicker('refresh');*/
                        //================================================================
                    });
                } else if (status == "ERROR") {
                    jQuery("#ulp-aweber-message").html(data.message);
                    jQuery("#ulp-aweber-message").slideDown(350);
                } else {
                    jQuery("#ulp-aweber-message").html("Service for connect aweber is not available.");
                    jQuery("#ulp-aweber-message").slideDown(350);
                }
            } catch(error) {
                jQuery("#ulp-aweber-message").html("Service for connect aweber is not available. Error: "+error);
                jQuery("#ulp-aweber-message").slideDown(350);
            }
            /*jQuery('.selectpicker').selectpicker('refresh');*/
        });
        return false;
    }

    var active_icontact_appid = "";
    var active_icontact_apiusername = "";
    var active_icontact_apipassword = "";
    function icontact_check() {
        if (active_icontact_appid != jQuery("#icontact_appid").val() || 
            active_icontact_apiusername != jQuery("#icontact_apiusername").val() ||
            active_icontact_apipassword != jQuery("#icontact_apipassword").val()) {
            jQuery("#icontact_status").html('Connection...');
            jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
                    "action": 'icontact-lists',
                    "icontact_appid": jQuery("#icontact_appid").val(),
                    "icontact_apiusername": jQuery("#icontact_apiusername").val(),
                    "icontact_apipassword": jQuery("#icontact_apipassword").val(),
                    "icontact_listid": "{/literal}{$popup_options['icontact_listid']}{literal}"
                },
                function(return_data) {
                    try {
                        data = jQuery.parseJSON(return_data);
                        if (data) {
                            jQuery("#icontact_status").html('iContact connected.');
                        } else {
                            jQuery("#icontact_status").html('Connection Error.');
                        }
                    } catch(e) {
                        jQuery("#icontact_status").html('Connection Error.'+e);
                    }
                    /*jQuery('.selectpicker').selectpicker({
                        style: 'btn-info',
                        size: 4
                    });*/
                }
            );
        }
    }
    var active_getresponse_api_key = "";
    function getresponse_check() {
        if (active_getresponse_api_key != jQuery("#getresponse_api_key").val()) {
            jQuery("#getresponse_status").html('Connection...');
            jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
                    "action": 'getresponse-campaigns',
                    "getresponse_api_key": jQuery("#getresponse_api_key").val(),
                    "getresponse_campaign": "{/literal}{$popup_options['getresponse_campaign']}{literal}"
                },
                function(return_data) {
                    try {
                        data = jQuery.parseJSON(return_data);
                        if (data) {
                            jQuery("#getresponse_status").html('Getresponse connected.');
                            active_getresponse_api_key = jQuery("#getresponse_api_key").val();
                        } else{
                            jQuery("#getresponse_status").html('Connection Error.');
                        }
                    } catch(e) {
                        jQuery("#icontact_status").html('Connection Error.'+e);
                    }
                    /*jQuery('.selectpicker').selectpicker('refresh');*/
                }
            );
        }
    }
    var active_madmimi_login = "";
    var active_madmimi_api_key = "";
    function madmimi_loadlist() {
        if (active_madmimi_login != jQuery("#madmimi_login").val() || active_madmimi_api_key != jQuery("#madmimi_api_key").val()) {
            jQuery("#madmimi_list_id").html("<option>-- Loading Lists --</option>");
            jQuery("#madmimi_list_id").attr("disabled", "disabled");
            jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
                    "action": 'madmimi-lists',
                    "madmimi_login": jQuery("#madmimi_login").val(),
                    "madmimi_api_key": jQuery("#madmimi_api_key").val(),
                    "madmimi_list_id": "{/literal}{$popup_options['madmimi_list_id']}{literal}"
                },
                function(return_data) {
                    try {
                        data = jQuery.parseJSON(return_data);
                        if (data) {
                            jQuery("#madmimi_list_id").html(data.options);
                            jQuery("#madmimi_list_id").removeAttr("disabled");
                            active_madmimi_api_key = jQuery("#madmimi_api_key").val();
                        } else jQuery("#madmimi_list_id").html("<option>-- Can not get Lists --</option>");
                    } catch(e) {
                        jQuery("#madmimi_list_id").html("<option>-- Can not get Lists --</option>");
                    }
                    /*jQuery('.selectpicker').selectpicker('refresh');*/
                }
            );
        }
    }
    var active_benchmark_api_key = "";
    function benchmark_loadlist() {
        if (active_benchmark_api_key != jQuery("#benchmark_api_key").val()) {
            jQuery("#benchmark_list_id").html("<option>-- Loading Lists --</option>");
            jQuery("#benchmark_list_id").attr("disabled", "disabled");
            jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
                    "action": 'benchmark-lists',
                    "benchmark_api_key": jQuery("#benchmark_api_key").val(),
                    "benchmark_list_id": "{/literal}{$popup_options['benchmark_list_id']}{literal}"
                },
                function(return_data) {
                    try {
                        data = jQuery.parseJSON(return_data);
                        if (data) {
                            jQuery("#benchmark_list_id").html(data.options);
                            jQuery("#benchmark_list_id").removeAttr("disabled");
                            active_benchmark_api_key = jQuery("#benchmark_api_key").val();
                        } else jQuery("#benchmark_list_id").html("<option>-- Can not get Lists --</option>");
                    } catch(e) {
                        jQuery("#benchmark_list_id").html("<option>-- Can not get Lists --</option>");
                    }
                    /*jQuery('.selectpicker').selectpicker('refresh');*/
                }
            );
        }
    }
    var active_activecampaign_url = "";
    var active_activecampaign_api_key = "";
    function activecampaign_check() {
        if (active_activecampaign_api_key != jQuery("#activecampaign_api_key").val() || active_activecampaign_url != jQuery("#activecampaign_url").val()) {
            jQuery("#activecampaign_status").html('Connection...');
            jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
                    "action": 'activecampaign-lists',
                    "activecampaign_url": jQuery("#activecampaign_url").val(),
                    "activecampaign_api_key": jQuery("#activecampaign_api_key").val(),
                    "activecampaign_list_id": "{/literal}{$popup_options['activecampaign_list_id']}{literal}"
                },
                function(return_data) {
                    try {
                        data = jQuery.parseJSON(return_data);
                        if (data) {
                            jQuery("#activecampaign_status").html('Getresponse connected.');
                            active_activecampaign_url = jQuery("#activecampaign_url").val();
                            active_activecampaign_api_key = jQuery("#activecampaign_api_key").val();
                        } else {
                            jQuery("#activecampaign_status").html('Connection Error.');
                        }
                    } catch(e) {
                        jQuery("#activecampaign_status").html('Connection Error.'+e);
                    }
                }
            );
        }
    }
    
    var gotowebinar_response_key = "";
    var gotowebinar_consumer_secret = "";
    var gotowebinar_consumer_key = "";
    function gotowebinar_getkey() {
        if (gotowebinar_consumer_secret != jQuery("#gotowebinar_consumer_secret").val() || gotowebinar_consumer_key != jQuery("#gotowebinar_consumer_key").val()) {
            jQuery("#gotowebinar_loading").html('Connection...');
            jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
                    "action": 'gotowebinar-getcode',
                    "consumer_key": jQuery("#gotowebinar_consumer_key").val(),
                    "consumer_secret": jQuery("#gotowebinar_consumer_secret").val()
                },
                function(return_data) {
                    try {
                        jQuery("#gotowebinar_loading").html('Get Response Key from pop-up window.');
                        var newWin=window.open(return_data,"GoTo Webinar Response Key","width=420,height=230,resizable=yes,scrollbars=yes,status=yes");
                    } catch(e) {
                        jQuery("#gotowebinar_loading").html('Connection Error.'+e);
                    }
                }
            );
        }
    }
    function gotowebinar_check() {
        if (gotowebinar_consumer_secret != jQuery("#gotowebinar_consumer_secret").val() 
            || gotowebinar_consumer_key != jQuery("#gotowebinar_consumer_key").val()
            || gotowebinar_response_key != jQuery("#gotowebinar_response_key").val()
        ){
            jQuery("#gotowebinar_activate_loading").html('Connection...');
            jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
                    "action": 'gotowebinar-connect',
                    "consumer_key": jQuery("#gotowebinar_consumer_key").val(),
                    "consumer_secret": jQuery("#gotowebinar_consumer_secret").val(),
                    "response_key": jQuery("#gotowebinar_response_key").val()
                },
                function(return_data) {
                    try {
                        if (return_data) {
                            jQuery("#gotowebinar_activate_loading").html('GoToWebinar connected.');
                            jQuery("#gotowebinar_activation").attr('value',return_data);
                        } else {
                            jQuery("#gotowebinar_activate_loading").html('Connection Error.');
                        }
                    } catch(e) {
                        jQuery("#gotowebinar_activate_loading").html('Connection Error.'+e);
                    }
                }
            );
        }
    }
    var active_interspire_url = "";
    var active_interspire_username = "";
    var active_interspire_token = "";
    var active_interspire_listid = "";
    function interspire_loadlist() {
        if (active_interspire_url != jQuery("#interspire_url").val() || active_interspire_username != jQuery("#interspire_username").val() || active_interspire_token != jQuery("#interspire_token").val()) {
            jQuery("#interspire_listid").html("<option>-- Loading Lists --</option>");
            jQuery("#interspire_listid").attr("disabled", "disabled");
            jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
                    "action": 'interspire-lists',
                    "interspire_url": jQuery("#interspire_url").val(),
                    "interspire_username": jQuery("#interspire_username").val(),
                    "interspire_token": jQuery("#interspire_token").val(),
                    "interspire_listid": "{/literal}{$popup_options['interspire_listid']}{literal}"
                },
                function(return_data) {
                    try {
                        data = jQuery.parseJSON(return_data);
                        if (data) {
                            jQuery("#interspire_listid").html(data.options);
                            jQuery("#interspire_listid").removeAttr("disabled");
                            active_interspire_url = jQuery("#interspire_url").val();
                            active_interspire_username = jQuery("#interspire_username").val();
                            active_interspire_token = jQuery("#interspire_token").val();
                        } else jQuery("#interspire_listid").html("<option>-- Can not get Lists --</option>");
                    } catch(e) {
                        jQuery("#interspire_listid").html("<option>-- Can not get Lists --</option>");
                    }
                    /*jQuery('.selectpicker').selectpicker('refresh');*/
                    interspire_loadfield();
                }
            );
        }
    }
    function interspire_loadfield() {
        if (active_interspire_url != jQuery("#interspire_url").val() || active_interspire_username != jQuery("#interspire_username").val() || active_interspire_token != jQuery("#interspire_token").val() || active_interspire_listid != jQuery("#interspire_listid").val()) {
            //jQuery("#interspire_nameid").html("<option>-- Loading Fields --</option>");
            //jQuery("#interspire_nameid").attr("disabled", "disabled");
            jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
                    "action": 'interspire-fields',
                    "interspire_url": jQuery("#interspire_url").val(),
                    "interspire_username": jQuery("#interspire_username").val(),
                    "interspire_token": jQuery("#interspire_token").val(),
                    "interspire_listid": jQuery("#interspire_listid").val(),
                    //"interspire_nameid": "{/literal}{$popup_options['interspire_nameid']}{literal}"
                },
                function(return_data) {
                    try {
                        data = jQuery.parseJSON(return_data);
                        if (data) {
                        //  jQuery("#interspire_nameid").html(data.options);
                        //  jQuery("#interspire_nameid").removeAttr("disabled");
                            active_interspire_url = jQuery("#interspire_url").val();
                            active_interspire_username = jQuery("#interspire_username").val();
                            active_interspire_token = jQuery("#interspire_token").val();
                            active_interspire_lsitid = jQuery("#interspire_listid").val();
                        } //else jQuery("#interspire_nameid").html("<option>-- Can not get Fields --</option>");
                    } catch(e) {
                        //jQuery("#interspire_nameid").html("<option>-- Can not get Fields --</option>");
                    }
                    /*jQuery('.selectpicker').selectpicker('refresh');*/
                }
            );
        }
    }
    icontact_check();
    getresponse_check();
    madmimi_loadlist();
    benchmark_loadlist();
    activecampaign_check();
    interspire_loadlist();
</script>
{/literal}