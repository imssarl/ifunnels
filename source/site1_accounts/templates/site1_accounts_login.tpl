<link href="/skin/_css/login.css" rel="stylesheet" type="text/css" media="screen" />
<!---->
<div id="wrap">
	<div class="account-pages"></div>
	<div class="clearfix"></div>
	<div class="wrapper-page">
		{if !empty($arrError.login)||!empty($arrError.forgot)}
		<div class="alert alert-danger">
			{if !empty($arrError.login)}
				Wrong authorize data entered!
			{elseif !empty($arrError.forgot)}
				Email not found
			{/if}
		</div>
		{/if}
		{if isset($smarty.get.change)}
		<div class="alert alert-success">Your password has been updated. Please login now.</div>
		{/if}
		{if isset($smarty.get.send_email)}
		<div class="alert alert-success">Please check your email for instructions.</div>
		{/if}
    	<div class="card-box" id="login_form"{if !empty($intError.forgot)} style="display:none"{/if}>
            <div class="panel-heading"> 
				<img src="/skin/i/frontends/ifunnels-logo-vertical-centered.png" alt="" class="img-responsive center-block" style="width: 135px;">
            </div> 

            <div class="panel-body">
            	<form method="post" action="" name="login" class="form-horizontal m-t-20" >
	                <div class="form-group ">
	                    <div class="col-xs-12">
	                        <input class="form-control" type="text" required="" placeholder="Username" name="arrLogin[username]">
	                    </div>
	                </div>

	                <div class="form-group">
	                    <div class="col-xs-12">
	                        <input class="form-control" type="password" required="" placeholder="Password" name="arrLogin[passwd]">
	                    </div>
	                </div>

	                <div class="form-group ">
	                    <div class="col-xs-12">
	                        <div class="checkbox checkbox-primary">
	                            <input id="checkbox" type="checkbox" name="arrLogin[rem]" value="0">
	                            <label for="checkbox">
	                                Remember me
	                            </label>
	                        </div>
	                        
	                    </div>
	                </div>
	                
	                <div class="form-group text-center m-t-40">
	                    <div class="col-xs-12">
	                        <button class="btn btn-primary text-uppercase waves-effect waves-light" type="submit">Log In</button>
	                    </div>
	                </div>

	                <div class="form-group m-t-30 m-b-0">
	                    <div class="col-sm-12">
	                        <a href="#forgot" id="open_forgot" class="forgot text-dark"><i class="fa fa-lock m-r-5"></i> Forgot your password?</a>
	                    </div>
	                </div>
	            </form> 
            </div> 
			<div class="privacy-terms text-center">
				<a href="{url name='site1_accounts' action='termspage'}" target="_blank" class="m-r-10">Terms and Conditions</a> <a href="{url name='site1_accounts' action='apppolicypage'}" target="_blank">Privacy Policy</a>
			</div>  
        </div>        

        <div class="card-box" id="forgot_form"{if empty($intError.forgot)} style="display:none"{/if}>
			<div class="panel-heading">
				<h3 class="text-center"> Reset Password </h3>
			</div>

			<div class="panel-body">
				<form method="post" action="#" role="form" class="text-center">
					<div class="alert alert-info alert-dismissable">
						<button type="button" class="close" data-dismiss="alert" aria-hidden="true">
							<i class="ti-close"></i>
						</button>
						Enter your <b>Email</b> and instructions will be sent to you!
					</div>
					<div class="form-group m-b-0">
						<div class="input-group">
							<input type="email" class="form-control" placeholder="Enter Email" required="" name="arrForgot[email]">
							<span class="input-group-btn">
								<button type="submit" class="btn btn-primary w-sm waves-effect waves-light">
									Reset
								</button> 
							</span>
						</div>
					</div>

				</form>
			</div>
		</div>                      
    </div>
</div>
{literal}
<script type="text/javascript">
	jQuery('#checkbox').change(function(){
		if(jQuery(this).prop('checked')) {
			jQuery(this).val("1");
		} else {
			jQuery(this).val("0");
		}

	});
	$$('.email').addEvents({
		'focus':function(){
			if(this.value=='Email'){
				this.value='';
				this.style.color='#000';
			}else{
				this.select();
			}
		},
		'blur':function(){
			if(this.value==''){
				this.value='Email';
				this.style.color='000';
			}
		}
	});
	$$('.username').addEvents({
		'focus':function(){
			if(this.value=='Email / Username'){
				this.value='';
				this.style.color='#000';
			}else{
				this.select();
			}
		},
		'blur':function(){
			if(this.value==''){
				this.value='Email / Username';
				this.style.color='000';
			}
		}
	});
	$('open_forgot').addEvent('click',function(event){
		event&&event.stop();
		$('login_form').toggle();
		$('forgot_form').toggle();
		this.set('html',(this.get('html')=='Login')?'Forgot password?':'Login');
		if(this.hasClass('forgot')){
			this.removeClass('forgot');
			this.addClass('login');
        } else {
			this.addClass('forgot');
			this.removeClass('login');
        }
	});
</script>
{/literal}