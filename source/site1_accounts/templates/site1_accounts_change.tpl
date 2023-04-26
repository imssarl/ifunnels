{if $strErr!='forgot time is up'}
<div id="forgot_data" class="wrapper-page">
	<link href="/skin/_css/login.css" rel="stylesheet" type="text/css" media="screen" />
	<div id="wrap">
		{if !empty($arrError.login)||!empty($arrError.forgot)}
		<div class="alert alert-danger">
			{if $strErr}
				Error: {$strErr}
			{/if}
		</div>
		{/if}
	</div>

	<div class="card-box" id="login_form"{if !empty($intError.forgot)} style="display:none"{/if}>
        <div class="panel-body">
        	<form method="post" action="" name="login" id="submit_new_pwd" class="form-horizontal m-t-20" >
                <div class="form-group ">
                    <div class="col-xs-12">
                    	<input name="arrCh[passwd]" type="text" value="New password" class="text form-control" id="pdw_first"/>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-xs-12">
                        <input name="arrCh[repasswd]" type="text" value="Re-enter new password" class="text form-control" id="pwd_second"/>
                    </div>
                </div>

                <div class="form-group text-center m-t-40">
                    <div class="col-xs-12">
                        <button class="btn btn-primary text-uppercase waves-effect waves-light" type="button" id="submit_button">Change</button>
                    </div>
                </div>
            </form> 
        </div>   
    </div>        
	{literal}
	<script type="text/javascript">
		$('submit_button').addEvent('click',function(event){
			event&&event.stop();
			if ( $('pdw_first').value == $('pwd_second').value ){
				$('submit_new_pwd').submit();
			}else{
				alert('Passwords do not coincide!');
			}
		});
		$('pdw_first').addEvents({
			'focus':function(){
				if(this.value=='New password'){
					this.set('type','password');
					this.value='';
					this.style.color='#000';
				}else{
					this.select();
				}
			},
			'blur':function(){
				if(this.value==''){
					this.set('type','text');
					this.value='New password';
					this.style.color='000';
				}
			}
		});
		$('pwd_second').addEvents({
			'focus':function(){
				if(this.value=='Re-enter new password'){
					this.set('type','password');
					this.value='';
					this.style.color='#000';
				}else{
					this.select();
				}
			},
			'blur':function(){
				if(this.value==''){
					this.set('type','text');
					this.value='Re-enter new password';
					this.style.color='000';
				}
			}
		});
	</script>
	{/literal}
</div>
{/if}
{if $strErr=='forgot time is up'}
	<div id="change_password">
		<div id="end_of_date">This temporary link is out of date. <a href="{Core_Module_Router::$offset}" class="forgot_password">Try again!</a></div>
	</div>
	{literal}
	<script type="text/javascript">
		$$('.forgot_password').addEvent('click',function(event){
			event&&event.stop();
			$('change_password').hide();
			$('forgot_data').show();
		});
	</script>
	{/literal}
{/if}