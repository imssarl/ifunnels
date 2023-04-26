<?php
class site1_mooptin extends Core_Module {

	public function set_cfg(){
		$this->inst_script=array(
			'module'=>array( 'title'=>'CNM MO Optin', ),
			'actions'=>array(
				array( 'action'=>'create', 'title'=>'Campaign Builder ', 'flg_tree'=>1 ),
				array( 'action'=>'createpopup', 'title'=>'Campaign Builder Popup', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'manage', 'title'=>'Manage Campaigns', 'flg_tree'=>1 ),
				array( 'action'=>'autoresponder', 'title'=>'Create Autoresponder Campaign', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'providenumber', 'title'=>'Provision a New Number', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'autoresponders', 'title'=>'Manage Autoresponder Campaigns', 'flg_tree'=>1 ),
				array( 'action'=>'request', 'title'=>'AJAX Request', 'flg_tpl'=>3, 'flg_tree'=>2 ),
				array( 'action'=>'twilio_api', 'title'=>'Twilio Api', 'flg_tpl'=>2, 'flg_tree'=>2 ),
				array( 'action'=>'getcode', 'title'=>'Get Code', 'flg_tpl'=>1, 'flg_tree'=>1 ),
				array( 'action'=>'form', 'title'=>'Get Form', 'flg_tpl'=>3, 'flg_tree'=>2 ),
			),
		);
	}

	public function form(){
		$_fileName=time();
		ob_start();
		$_mooptinId = Core_Payment_Encode::decode( $_REQUEST['id'] );
		$_REQUEST['id'] = $_mooptinId[0];
		if( $_REQUEST['userAgent'] == 'F' ){
			if (!empty($_SERVER["HTTP_CLIENT_IP"])){
				$_REQUEST['ip']=$_SERVER["HTTP_CLIENT_IP"];
			}elseif (!empty($_SERVER["HTTP_X_FORWARDED_FOR"])){
				$_REQUEST['ip']=$_SERVER["HTTP_X_FORWARDED_FOR"];
			}else{
				$_REQUEST['ip']=$_SERVER["REMOTE_ADDR"];
			}
		}
		$obj=new Project_Mooptin_Autoresponders();
		$obj->sendAutorespond( $_REQUEST, $arrCallback );
		$out = ob_get_contents();
		$out = json_decode( trim( $out, '()' ), true ); 
		if( !empty( $_REQUEST['redirect_url'] ) ){
			if( substr( $_REQUEST['redirect_url'], 0, strlen('#everwebinar_') ) == '#everwebinar_' && isset( $arrCallback[substr( $_REQUEST['redirect_url'], strlen('#everwebinar_') )]['callback']->user->thank_you_url ) ){
				header( 'Location: ' . $arrCallback[substr( $_REQUEST['redirect_url'], strlen('#everwebinar_') )]['callback']->user->thank_you_url );
			}elseif( substr( $_REQUEST['redirect_url'], 0, strlen('#webinarjam_') ) == '#webinarjam_' && isset( $arrCallback[substr( $_REQUEST['redirect_url'], strlen('#webinarjam_') )]['callback']->user->thank_you_url ) ){
				header( 'Location: ' . $arrCallback[substr( $_REQUEST['redirect_url'], strlen('#webinarjam_') )]['callback']->user->thank_you_url );
			}else{
				header( 'Location: '.$_REQUEST['redirect_url'] );
			}
		} elseif( !is_null( $out['return_url'] ) ){
			header( 'Location: ' . $out['return_url'] );
		} else {
			header( 'Location: ' . $_SERVER["HTTP_REFERER"] );
		}
		ob_end_clean();
		echo $out;
	}

	public function getcode(){
		$_mooptin = new Project_Mooptin();
		$_mooptin->withIds( $_GET['id'] )->onlyOne()->getList( $_arrMoData );
		$this->out['form'] = str_replace("\r\n", '', Project_Mooptin::getCodeForm( $_arrMoData['settings']['optin_form'], $_arrMoData['settings']['form'], $_arrMoData['id'] ) );
		$this->out['flg_everwebinar_redirect']=isset( $_arrMoData['settings']['options']['everwebinar_webinar_id'] ) && !empty( $_arrMoData['settings']['options']['everwebinar_webinar_id'] );
		$this->out['flg_webinarjam_redirect']=isset( $_arrMoData['settings']['options']['webinarjam_webinar_id'] ) && !empty( $_arrMoData['settings']['options']['webinarjam_webinar_id'] );
		$this->out['everwebinar_id']=(isset( $_arrMoData['settings']['options']['everwebinar_webinar_id'] ) && !empty( $_arrMoData['settings']['options']['everwebinar_webinar_id'] ) )?array_keys( $_arrMoData['settings']['options']['everwebinar_webinar_id'] )[0]:0;
		$this->out['webinarjam_id']=(isset( $_arrMoData['settings']['options']['webinarjam_webinar_id'] ) && !empty( $_arrMoData['settings']['options']['webinarjam_webinar_id'] ) )?array_keys( $_arrMoData['settings']['options']['webinarjam_webinar_id'] )[0]:0;
	}	

	public function providenumber(){
		//добавляем только новые номера в базу
		if( !empty( $_POST['arrData']['sms_number'] ) ){
			// добавляем новый номер в твилио
			try{
				$twilio = new Project_Ccs_Twilio_Abstract();
				$numbers=$twilio->_client
					->incomingPhoneNumbers
					->create(array(
						'friendlyName'=>$_POST['arrData']['sms_number'],
						'phoneNumber'=>$_POST['arrData']['sms_number'],
						'SmsUrl'=>Zend_Registry::get( 'config' )->domain->url.Core_Module_Router::getCurrentUrl( array( 'name'=>'site1_mooptin','action'=>'twilio_api') ).Project_Widget_Mutator::encode( Core_Users::$info['id'] ).'/',
						'SmsMethod'=>'POST'
					));
			}catch(Exception $ex){
				$_phones->getErrors($this->out['errors']);
				return true;
			}
			//добавляем новый номер в базу
			$_phones=new Project_Squeeze_Twilio();
			if( !$_phones->setEntered( array( 
				'phone'=>$_POST['arrData']['sms_number'],
				'country'=>$_POST['arrData']['sms_number_counry']
			))->set() ){
				$_phones
					->getEntered($this->out['arrData'])
					->getErrors($this->out['errors']);
			}
			$_phones->getEntered($this->out['arrData']);
		}
	}

	public function autoresponder(){
		$this->objStore->getAndClear( $this->out );
		$company = new Project_Mooptin_Autoresponders();
		if( !isset( $this->out['flgLoad'] ) )
			$this->out['flgLoad']=true;
		if (!empty($_POST)) {
			
			$dom = new DOMDocument;
			$dom->loadHTML( $_POST['arrData']['settings']['options']['html_form'] );
			$forms = $dom->getElementsByTagName('form');
			if( in_array( 'html', $_POST['arrData']['settings']['integration'] ) && $forms->length == 0 ){
				$this->objStore->toAction( 'autoresponder' )->set( array( 'error'=>'Your HTML Code is not valid. Try validating it at https://validator.w3.org/check', 'flgLoad'=>true ) );
				$this->location( array( 'action'=>'autoresponder' ) );
			}
			foreach ($forms as $form) {
				$_POST['arrData']['settings']['options']['action']=$form->getAttribute('action');
				if( in_array( 'html', $_POST['arrData']['settings']['integration'] ) && empty( $_POST['arrData']['settings']['options']['action'] ) ){
					$this->objStore->toAction( 'autoresponder' )->set( array( 'error'=>'Your HTML Code is not valid. Try validating it at https://validator.w3.org/check', 'flgLoad'=>true ) );
					$this->location( array( 'action'=>'autoresponder' ) );
				}
				$_POST['arrData']['settings']['options']['method']=$form->getAttribute('method');
				if( empty( $_POST['arrData']['settings']['options']['method'] ) ){
					$_POST['arrData']['settings']['options']['method']='GET';
				}
				$inputs=$form->getElementsByTagName('input');
				$_countInput = $inputs->length;
				$_inputs=array();
				foreach ($inputs as $input) {
					if( $input->getAttribute('type') == 'submit' || $input->getAttribute('type') == 'button' || $input->getAttribute('type') == 'image' ){
						$_countInput--;
						continue;
					}
					$_hidden=false;
					if( $input->getAttribute('type')=='hidden' ){
						$_hidden=true;
					}
					$_POST['arrData']['settings']['options']['newFields'][]=array( 'name'=>$input->getAttribute('name'), 'static_value'=>$input->getAttribute('value'), 'hidden'=>$_hidden );
				}
				if( in_array( 'html', $_POST['arrData']['settings']['integration'] ) && count( $_POST['arrData']['settings']['options']['newFields'] ) != $_countInput ){
					$this->objStore->toAction( 'autoresponder' )->set( array( 'error'=>'Your HTML Code is not valid. Try validating it at https://validator.w3.org/check', 'flgLoad'=>true ) );
					$this->location( array( 'action'=>'autoresponder' ) );
				}
			}
			if ( $company->setEntered( $_POST['arrData'] )->set() ) {
				$company->getEntered( $returnData );
				$this->objStore->toAction( 'autoresponder' )->set( array( 'msg'=>'Autoresponder created successfully', 'arrData'=>$returnData, 'flgLoad'=>false ) );
				$this->location( array( 'action'=>'autoresponder' ) );
			}
			$this->objStore->toAction( 'autoresponder' )->set( array( 'error'=>'Autoresponder not created', 'flgLoad'=>true ) );
			$this->location( array( 'action'=>'autoresponder' ) );
		}
		if( !isset( $this->out['arrData'] ) && isset($_GET['id']) && !empty( $_GET['id'] ) ){
			$company
				->withIds( $_GET['id'] )
				->onlyOwner()
				->onlyOne()
				->getList( $this->out['arrData'] );
			
			$this->out['flgLoad']=true;
		}
		// IO
		$_options=new Project_Exquisite_Options();
		$_options->onlyOwner()->getList( $this->out['popup_io_options'] );
		$this->out['popup_io_options']=array_filter( empty( $this->out['popup_io_options'] ) ?array():$this->out['popup_io_options'] )+array_filter( Project_Exquisite_Options::$defaultOptions );
		if( isset( $this->out['arrData']['settings'] ) ){
			$this->out['popup_io_options']=array_filter( empty( $this->out['arrData']['settings'] )?array():$this->out['arrData']['settings'] )+array_filter( empty( $this->out['popup_io_options'] )?array():$this->out['popup_io_options'] );
		}
		if( isset( $this->out['arrData']['settings']['optin_form_settings'] ) ){
			$this->out['settings']=$this->out['arrData']['settings']['optin_form_settings'];
		}
	}

	public function autoresponders(){
		$this->objStore->getAndClear( $this->out );
		if( isset( $_POST['arrData'] ) ){
			$_user=new Project_Users_Management();
			$_user->updateTwilio( $_POST['arrData'] );
		}
		$company = new Project_Mooptin_Autoresponders();
		if ( !empty($_GET['del']) ) {
			if ( $company->withIds( $_GET['del'] )->onlyOwner()->del() ) {
				$this->objStore->set( array( 'msg'=>'Company deleted successfully' ) );
			} else {
				$this->objStore->set( array( 'error'=>'Company notdeleted' ) );
			}
			$this->location( array( 'action'=>'autoresponders') );
		}
		$company
			->onlyOwner()
			->withOrder( @$_GET['order'] )
			->withPaging(array(
				'url'=>@$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			))
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
	}

	public function createpopup(){
		$this->objStore->getAndClear( $this->out );
		$this->out['popup']=true;
		$this->create();
	}
	
	public function select(){
		$this->objStore->getAndClear( $this->out );
		$company = new Project_Mooptin();
		$company->onlyOwner()->getList( $this->out['arrList'] );
	}

	public function request(){
		if( isset( $_GET['code'] )){
			echo 'Response Key: '.$_GET['code'];
			exit;
		}
		if( isset( $_GET['scope'] ) ){
			echo $_GET['scope'];
			exit;
		}
		if( isset( $_REQUEST['action'] ) ){
			$_object=new Project_Exquisite();
			$_mooptin=new Project_Mooptin();
			$jsonp_callback = $_REQUEST['callback'];
			if (isset($_REQUEST['action'])) {
				switch ($_REQUEST['action']) {
					
					case 'fetch-form':
						$_formDataUpdate=Project_Mooptin::fetchForm( $_POST['data'] );
						if( empty( $_formDataUpdate ) ){
							echo 'false';
						}else{
							echo $_formDataUpdate;
						}
						exit;
					break;
					
					case 'gotowebinar-getcode':
						$_REQUEST['consumer_key']='uKmIWh3CQ8NAZC4XiUK244JkmyVkBFs6';
						$_REQUEST['consumer_secret']='TAbXbqgGGrGQWr0D';
						/*if (!isset($_REQUEST['consumer_key']) || empty($_REQUEST['consumer_secret'])) {
							$return_object = array();
							$return_object['status'] = 'ERROR';
							$return_object['message'] = 'Authorization Code not found.';
							echo json_encode($return_object);
							exit;
						}*/
						$goto=new Project_Mooptin_Gotomeeting( 'oauth', array( 'consumer_secret'=>$_REQUEST['consumer_secret'], 'consumer_key'=>$_REQUEST['consumer_key'] ) );
						echo $goto->applicationAuthentication();
						exit;
					break;
					
					case 'gotowebinar-connect':
						$_REQUEST['consumer_key']='uKmIWh3CQ8NAZC4XiUK244JkmyVkBFs6';
						$_REQUEST['consumer_secret']='TAbXbqgGGrGQWr0D';
						if( $_SERVER['HTTP_HOST'] !== 'cnm.local' ){
							$_data='{"access_token":"AKELiVNDPbnHl2OTw3UNWPjfam3z","token_type":"Bearer","refresh_token":"cGHpp1skwi1Ae4GZmyCbln4pABOyBIHT","expires_in":3600,"account_key":"100000000000187172","account_type":"","email":"contact@affiliateoverhaul.com","firstName":"Overhaul","lastName":"Speaker","organizer_key":"100000000000190411","version":"3"}';
							echo base64_encode(json_encode(json_decode($_data)));
							exit;
						}
						$return_object = array();
						if ( isset($_REQUEST['username']) && isset($_REQUEST['password']) ){
							$goto=new Project_Mooptin_Gotomeeting( 'oauth', array( 'consumer_key'=>$_REQUEST['consumer_key'], 'consumer_secret'=>$_REQUEST['consumer_secret'], 'username'=>$_REQUEST['username'], 'password'=>$_REQUEST['password'] ) );
							$return_object=$goto->getToken();
							if( !isset( $return_object->access_token ) ){
								if( isset( $goto->http_error ) && !empty( $goto->http_error  ) ){
									echo json_encode(array('error_message'=>$goto->http_error));
								}elseif( isset( $return_object->error_description ) ){
									echo json_encode(array('error_message'=>$return_object->error_description));
								}
								exit;
							}
						}
						echo base64_encode(json_encode($return_object));
						exit;
					break;
					
					case 'gotowebinar-getwebinars':
					//	if( $_SERVER['HTTP_HOST'] == 'cnm.local' ){
					//		echo '{"status":"OK","lists":[{"numberOfRegistrants": 0,"times": [{"startTime": "2017-02-14T17:00:00Z","endTime":"2017-02-14T18:00:00Z"}],"description": "string","subject": "string","inSession": true,"organizerKey": 0,"webinarKey": 0,"webinarID": "string","timeZone": "string","registrationUrl": "string"}]}';
					//		exit;
					//	}
						$return_object = array();
						if ( isset( $_REQUEST['activation'] ) ){
							$_access=json_decode( base64_decode( $_REQUEST['activation'] ), true );
							
							$_access['consumer_key']='uKmIWh3CQ8NAZC4XiUK244JkmyVkBFs6';
							$_access['consumer_secret']='TAbXbqgGGrGQWr0D';
							
							$goto=new Project_Mooptin_Gotomeeting( 'call', $_access );
							$_arrLists=$goto->getWebinars( /*$_REQUEST['organizer_key'] */ );
							foreach( $_arrLists as $_list ){
								$return_object['lists'][]=array( 'webinarKey'=>'k'.$_list['webinarKey'], 'subject'=>$_list['subject'] );
							}
							$return_object['status'] = 'OK';
						}else{
							$return_object['status'] = 'ERROR';
							$return_object['message'] = 'Authorization Code not found.';
						}
						echo json_encode($return_object, JSON_NUMERIC_CHECK);
						exit;
					break;
					
					case 'aweber-connect':
						if( $_SERVER['HTTP_HOST'] == 'cnm.local' ){
							$_data='{"status":"OK","lists":{"270192":"ethiccash_free","273456":"showclicks_upgr","309222":"socializer"},"html":"\n\t\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t\t<th>Enable AWeber:<\/th>\n\t\t\t\t\t\t\t\t<td>\n\t\t\t\t\t\t\t\t\t<input type=\"checkbox\" id=\"aweber_enable\" name=\"aweber_enable\"\/> Submit contact details to AWeber\n\t\t\t\t\t\t\t\t\t<br \/><em>Please tick checkbox if you want to submit contact details to AWeber.<\/em>\n\t\t\t\t\t\t\t\t<\/td>\n\t\t\t\t\t\t\t<\/tr>\n\t\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t\t<th>List ID:<\/th>\n\t\t\t\t\t\t\t\t<td>\n\t\t\t\t\t\t\t\t\t<select name=\"aweber_listid\" class=\"ic_input_m\"><option value=\"270192\">ethiccash_free<\/option><option value=\"273456\">showclicks_upgr<\/option><option value=\"309222\">socializer<\/option>\n\t\t\t\t\t\t\t\t\t<\/select>\n\t\t\t\t\t\t\t\t\t<br \/><em>Select your List ID.<\/em>\n\t\t\t\t\t\t\t\t<\/td>\n\t\t\t\t\t\t\t<\/tr>","api_settings":{"aweber_consumer_key":"AzdQZZUCIu3yl6WrVm3LfLTQ","aweber_consumer_secret":"AVFiJKCwGn6CEMvmLY7euq3eU6CoaYBbPAi7Q6l7","aweber_access_key":"AgyTpImXiGHvc15tym1x8Hhc","aweber_access_secret":"6PQAkPFjyGzuyHoNMCrzfdk4aVECyfOQRSgtoLtN"}}';
							echo json_encode(json_decode($_data));
							exit;
						}
						if (!isset($_POST['aweber-oauth-id']) || empty($_POST['aweber-oauth-id'])) {
							$return_object = array();
							$return_object['status'] = 'ERROR';
							$return_object['message'] = 'Authorization Code not found.';
							echo json_encode($return_object);
							exit;
						}
						$code=trim(stripslashes($_POST['aweber-oauth-id']));
						$account = null;
						$_errorMessageFromApi='Invalid Authorization Code!';
						ob_start();
						try {
							require_once 'library/AWeberAPI/aweber.php';
							list($consumer_key, $consumer_secret, $access_key, $access_secret) = AWeberAPI::getDataFromAweberID($code);
						} catch (AWeberAPIException $exc) {
							$_errorMessageFromApi=$exc->message;
							list($consumer_key, $consumer_secret, $access_key, $access_secret) = null;
						} catch (AWeberOAuthDataMissing $exc) {
							$_errorMessageFromApi=$exc->message;
							list($consumer_key, $consumer_secret, $access_key, $access_secret) = null;
						} catch (AWeberException $exc) {
							$_errorMessageFromApi=$exc->message;
							list($consumer_key, $consumer_secret, $access_key, $access_secret) = null;
						}
						ob_clean();
						if (!$access_secret) {
							$return_object = array();
							$return_object['status'] = 'ERROR';
							$return_object['message'] = $_errorMessageFromApi;
							echo json_encode($return_object);
							exit;
						}else{
							try {
								$aweber = new AWeberAPI($consumer_key, $consumer_secret);
								$account = $aweber->getAccount($access_key, $access_secret);
							} catch (AWeberException $e) {
								$return_object = array();
								$return_object['status'] = 'ERROR';
								$return_object['message'] = 'Can not access AWeber account!';
								echo json_encode($return_object);
								exit;
							}
						}
						$options['aweber_consumer_key'] = $consumer_key;
						$options['aweber_consumer_secret'] = $consumer_secret;
						$options['aweber_access_key'] = $access_key;
						$options['aweber_access_secret'] = $access_secret;
						if ($options['aweber_access_secret']) {
							$return_object = array();
							$return_object['status'] = 'OK';
							try {
								require_once 'library/AWeberAPI/aweber.php';
								$aweber = new AWeberAPI($options['aweber_consumer_key'], $options['aweber_consumer_secret']);
								$account = $aweber->getAccount($options['aweber_access_key'], $options['aweber_access_secret']);
								$return_object['lists']=array();
								$lists=$account->lists->find(array());
								foreach( $lists->data['entries'] as $list ){
									$return_object['lists'][$list['id']]=$list['name'];
								}
								$_allCount=count( $lists );
								for( $i=100; isset( $lists->data['next_collection_link'] ) && $i<$_allCount; $i+=100 ){
									$lists=$account->lists->find( array('ws.start'=>$i) );
									foreach( $lists->data['entries'] as $list ){
										$return_object['lists'][$list['id']]=$list['name'];
									}
								}
								if( empty($return_object['lists']) ){
									$return_object['html'] = '
									<tr>
										<th>Enable AWeber:</th>
										<td>This AWeber account does not currently have any lists.</td>
									</tr>';
								}else{
								$return_object['html'] = '
								<tr>
									<th>Enable AWeber:</th>
									<td>
										<input type="checkbox" id="aweber_enable" name="aweber_enable" '.(($options['aweber_enable'] == "on")?'checked="checked"':'').' /> Submit contact details to AWeber
										<br /><em>Please tick checkbox if you want to submit contact details to AWeber.</em>
									</td>
								</tr>
								<tr>
									<th>List ID:</th>
									<td>
										<select name="aweber_listid" class="ic_input_m">';
											foreach ( $return_object['lists'] as $listId=>$listName ){
												//$return_object['options']=$return_object['options'].'<option value="'.$listId.'"'.(( $listId == $options['aweber_listid'] )?' selected="selected"':'').'>'.$listName.'</option>';
												$return_object['html']=$return_object['html'].'<option value="'.$listId.'"'.(( $listId == $options['aweber_listid'] )?' selected="selected"':'').'>'.$listName.'</option>';
											}
										$return_object['html']=$return_object['html'].'
										</select>
										<br /><em>Select your List ID.</em>
									</td>
								</tr>';
								}
							} catch (AWeberException $e) {
									$return_object['status'] = 'FALSE';
							}
						}
						$return_object['api_settings']=$options;
						echo json_encode($return_object);
						exit;
					break;

					case 'aweber-loadlist':
						$options['aweber_consumer_key'] = trim(stripslashes($_POST['aweber-consumer_key']));
						$options['aweber_consumer_secret'] = trim(stripslashes($_POST['aweber-consumer_secret']));
						$options['aweber_access_key'] = trim(stripslashes($_POST['aweber-access_key']));
						$options['aweber_access_secret'] = trim(stripslashes($_POST['aweber-access_secret']));
						if (!empty( $options['aweber_access_secret'] ) ) {
							$return_object = array();
							$return_object['status'] = 'OK';
							try {
								require_once 'library/AWeberAPI/aweber.php';
								$aweber = new AWeberAPI($options['aweber_consumer_key'], $options['aweber_consumer_secret']);
								$account = $aweber->getAccount($options['aweber_access_key'], $options['aweber_access_secret']);
								$return_object['lists']=array();
								$lists=$account->lists->find(array());
								foreach( $lists->data['entries'] as $list ){
									$return_object['lists'][$list['id']]=$list['name'];
								}
								$_allCount=count( $lists );
								for( $i=100; isset( $lists->data['next_collection_link'] ) && $i<$_allCount; $i+=100 ){
									$lists=$account->lists->find( array('ws.start'=>$i) );
									foreach( $lists->data['entries'] as $list ){
										$return_object['lists'][$list['id']]=$list['name'];
									}
								}
								if( empty($return_object['lists']) ){
									$return_object['html'] = '
									<tr>
										<th>Enable AWeber:</th>
										<td>This AWeber account does not currently have any lists.</td>
									</tr>';
								}else{
								$return_object['html'] = '
								<tr>
									<th>Enable AWeber:</th>
									<td>
										<input type="checkbox" id="aweber_enable" name="aweber_enable" '.(($options['aweber_enable'] == "on")?'checked="checked"':'').' /> Submit contact details to AWeber
										<br /><em>Please tick checkbox if you want to submit contact details to AWeber.</em>
									</td>
								</tr>
								<tr>
									<th>List ID:</th>
									<td>
										<select name="aweber_listid" class="ic_input_m">';
											foreach ( $return_object['lists'] as $listId=>$listName ){
												//$return_object['options']=$return_object['options'].'<option value="'.$listId.'"'.(( $listId == $options['aweber_listid'] )?' selected="selected"':'').'>'.$listName.'</option>';
												$return_object['html']=$return_object['html'].'<option value="'.$listId.'"'.(( $listId == $options['aweber_listid'] )?' selected="selected"':'').'>'.$listName.'</option>';
											}
										$return_object['html']=$return_object['html'].'
										</select>
										<br /><em>Select your List ID.</em>
									</td>
								</tr>';
								}
							} catch (AWeberException $e) {
									$return_object['status'] = 'FALSE';
							}
						}
						$return_object['api_settings']=$options;
						echo json_encode($return_object);
						exit;
					break;

					case 'ontraport-updatetags':
						if( $_SERVER['HTTP_HOST'] == 'cnm.local' ){
							$_data='{"tags":{"1":"3 Affiliate 2","2":"Stealth Video Profits","3":"Submitted DFY Form","4":"DFY Buyer","5":"started checkout","6":"[Checkout] Instaffiliate Bundle 1","7":"[Cart Abandonment]","8":"[Product User] - Instaffiliate","9":"[Test tags] iframe","10":"Test Tag cookied","11":"[Test OP Cookie]","12":"Test Cookie - Visited Ty Page 3","13":"OP Test Form Rule Cookie","14":"svp affiliate","41":"[WARNING] Instant Refunder","16":"SVP JV","17":"[JV] [SVP] Thank you page","18":"[CHECKOUT] [SVP] [v3] Main Offer","19":"[BUYER] [SVP] Main Offer","20":"[OTO] [SVP] oto1 loaded","21":"Buyer oto2","22":"OTO3 buyer","23":"[PROSPECT] [SVP] Main Offer Loaded","24":"[Instaffiliate] [UK] Registration","25":"[CHECKOUT] [SVP] [v2] Main Offer","26":"[BUYER] [SVP] [OTO] Platinum Level","27":"[BUYER] [SVP] [OTO] DFY Reseller","28":"[BUYER] [SVP] [OTO] DFY Agency Plan","29":"[PROSPECT] [SVP] [OTO] Expert Level","30":"[PROSPECT] [SVP] [OTO] Platinum Level","31":"OTO3 Loaded","32":"JVzoo super affiliate","33":"[JVzoo] Instant","34":"[PROSPECT] [SVP] [OTO] DFY Agency","35":"[PROSPECT] [SVP] [OTO] DFY Plan","36":"[PROSPECT] [SVP] [OTO] DFY Agency Plan","37":"[CHECKOUT] [SVP] Main Offer","38":"[BUYER] [Instaffiliate] [Mobile] UK","39":"[Instaffiliate] UK [Registration] [Step 1]","40":"[BUYER] [SVP] [OTO] Expert Level","42":"[Instaffiliate] [Bonus] Starter","43":"[REFUND] SVP Platinum","44":"[REFUND] [SVP] Main","45":"[PROMOTION] [Covert Commission] Clicked Email","46":"[OPTIN] [SVP] Giveaway","47":"[BUYER] [Instaffiliate] [Mobile] AU","48":"[Instaffiliate] AU [Registration] [Step 1]","49":"[BUYER] [SVP] [OTO] DFY Plan","50":"[REFUND] [SVP] Expert","51":"[SUBSCRIBER] UK Instaff Error Redirect FuLLLL"},"status":"OK","api_settings":{"ontraport_app_id":"2_25731_7DeHdGryD","ontraport_api_key":"S1ZmnRcJGGTcvz2"}}';
							echo json_encode(json_decode($_data));
							exit;
						}
						$options['ontraport_app_id'] = trim(stripslashes($_POST['ontraport_app_id']));
						$options['ontraport_api_key'] = trim(stripslashes($_POST['ontraport_api_key']));
						$options['ontraport_start'] = trim(stripslashes($_POST['ontraport_start']));
						if (!empty( $options['ontraport_app_id'] ) ) {
							$return_object = array('tags'=>array());
							$return_object['status'] = 'OK';
							try {
									$ontraport_url = 'https://api.ontraport.com/1/objects?objectID=14&start='.$options['ontraport_start'];
									$ch = curl_init();
									curl_setopt($ch, CURLOPT_URL, $ontraport_url);
									curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
									curl_setopt($ch, CURLOPT_HEADER, 0);
									curl_setopt($ch, CURLOPT_HTTPHEADER, array(
										'Api-Appid: '.$options['ontraport_app_id'],
										'Api-Key: '.$options['ontraport_api_key'],
										'reqType: fetch_tag'
									));
									$dataTags = curl_exec( $ch );
									curl_close( $ch );
									$dataTags=json_decode( $dataTags, true );
									$_dataCounter=count( $dataTags['data'] );
									foreach( $dataTags['data'] as $tag ){
										$return_object['tags'][$tag['tag_id']]=$tag['tag_name'];
									}
							} catch (Exception $e) {
									$return_object['status'] = 'FALSE';
									$return_object['error'] = $e->getMessage();
							}
						}
						$return_object['api_settings']=$options;
						echo json_encode($return_object);
						exit;
					break;

					case 'ontraport-loadlist':
						if( $_SERVER['HTTP_HOST'] == 'cnm.local' ){
							$_data='{"lists":{"1":"Welcome Partners","2":"Active Re Engagement: Active Re Engagement","3":"SVP JV Early Registration","4":"Follow-up SVP Main To Expert","5":"Follow-Up SVP Expert to Up","6":"Covert Commission Promotion","7":"SVP Give Away Engagement","8":"SVP GiveAway Clickers - Scarcity Sequence","9":"[UK Instaffiliate] New Members","10":"Funnelology 101 Hot Prospects","11":"Upgrade Funnelology 101 to 102","12":"Instant FB TRaffic","13":"Clickers","14":"Tag Openers","15":"LPS Prelaunch","16":"[INSTAFFILIATE] Success Turning Point Free Report (5 tools) To Instaffiliate Free Account","17":"[Instaffiliate] Free Account To Paid Customers","18":"Instaffiliate Step 1 To Step 2 Account Creation","19":"SVP Relaunch 2016","20":"SVP Relaunch - did not open first email","21":"TG Coaching Standard Access Creation","22":"TG Coaching Platinum Access Creation","23":"TG Free Training Access Creation","24":"Teds Woodworking 50 free plans","25":"TGEN Cart Abandonment","26":"Aspire Ascension LEad To Member Sequence","27":"Aspire Member - Onboarding","28":"Leads Flow Pro","29":"Instaffiliate Survival - emails and traffic","30":"Instaffiliate Women In 40s - emails and traffic","31":"Black Friday Openers Sequence"},"tags":{"1":"Affiliate","2":"Stealth Video Profits","3":"Submitted DFY Form","4":"DFY Buyer","5":"started checkout","6":"[Checkout] Instaffiliate Bundle 1","7":"[Cart Abandonment]","8":"[Product User] - Instaffiliate","9":"[Test tags] iframe","10":"Test Tag cookied","11":"[Test OP Cookie]","12":"Test Cookie - Visited Ty Page 3","13":"OP Test Form Rule Cookie","14":"svp affiliate","41":"[WARNING] Instant Refunder","16":"SVP JV","17":"[JV] [SVP] Thank you page","18":"[CHECKOUT] [SVP] [v3] Main Offer","19":"[BUYER] [SVP] Main Offer","20":"[OTO] [SVP] oto1 loaded","21":"Buyer oto2","22":"OTO3 buyer","23":"[PROSPECT] [SVP] Main Offer Loaded","24":"[Instaffiliate] [UK] Registration","25":"[CHECKOUT] [SVP] [v2] Main Offer","26":"[BUYER] [SVP] [OTO] Platinum Level","27":"[BUYER] [SVP] [OTO] DFY Reseller","28":"[BUYER] [SVP] [OTO] DFY Agency Plan","29":"[PROSPECT] [SVP] [OTO] Expert Level","30":"[PROSPECT] [SVP] [OTO] Platinum Level","31":"OTO3 Loaded","32":"JVzoo super affiliate","33":"[JVzoo] Instant","34":"[PROSPECT] [SVP] [OTO] DFY Agency","35":"[PROSPECT] [SVP] [OTO] DFY Plan","36":"[PROSPECT] [SVP] [OTO] DFY Agency Plan","37":"[CHECKOUT] [SVP] Main Offer","38":"[BUYER] [Instaffiliate] [Mobile] UK","39":"[Instaffiliate] UK [Registration] [Step 1]","40":"[BUYER] [SVP] [OTO] Expert Level","42":"[Instaffiliate] [Bonus] Starter","43":"[REFUND] SVP Platinum","44":"[REFUND] [SVP] Main","45":"[PROMOTION] [Covert Commission] Clicked Email","46":"[OPTIN] [SVP] Giveaway","47":"[BUYER] [Instaffiliate] [Mobile] AU","48":"[Instaffiliate] AU [Registration] [Step 1]","49":"[BUYER] [SVP] [OTO] DFY Plan","50":"[REFUND] [SVP] Expert","51":"[SUBSCRIBER] UK Instaff Error Redirect"},"status":"OK","api_settings":{"ontraport_app_id":"2_25731_7DeHdGryD","ontraport_api_key":"S1ZmnRcJGGTcvz2"}}';
							echo json_encode(json_decode($_data));
							exit;
						}
						$options['ontraport_app_id'] = trim(stripslashes($_POST['ontraport_app_id']));
						$options['ontraport_api_key'] = trim(stripslashes($_POST['ontraport_api_key']));
						if (!empty( $options['ontraport_app_id'] ) ) {
							$return_object = array('lists'=>array(), 'tags'=>array());
							$return_object['status'] = 'OK';
							try {
								$ontraport_url = 'https://api.ontraport.com/1/objects?objectID=5';
								$ch = curl_init();
								curl_setopt($ch, CURLOPT_URL, $ontraport_url);
								curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
								curl_setopt($ch, CURLOPT_HEADER, 0);
								curl_setopt($ch, CURLOPT_HTTPHEADER, array(
									'Api-Appid: '.$options['ontraport_app_id'],
									'Api-Key: '.$options['ontraport_api_key'],
									'reqType: fetch_sequences'
								));
								$dataSequences = curl_exec( $ch );
								curl_close( $ch );
								$dataSequences=json_decode( $dataSequences, true );
								foreach( $dataSequences['data'] as $list ){
									if( $list['pause'] != 1 )
									$return_object['lists'][$list['drip_id']]=$list['name'];
								}
								
								$ontraport_url = 'https://api.ontraport.com/1/objects?objectID=14';
								$ch = curl_init();
								curl_setopt($ch, CURLOPT_URL, $ontraport_url);
								curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
								curl_setopt($ch, CURLOPT_HEADER, 0);
								curl_setopt($ch, CURLOPT_HTTPHEADER, array(
									'Api-Appid: '.$options['ontraport_app_id'],
									'Api-Key: '.$options['ontraport_api_key'],
									'reqType: fetch_tag'
								));
								$dataTags = curl_exec( $ch );
								curl_close( $ch );
								$dataTags=json_decode( $dataTags, true );
								$_dataCounter=count( $dataTags['data'] );
								foreach( $dataTags['data'] as $tag ){
									$return_object['tags'][$tag['tag_id']]=$tag['tag_name'];
								}
							} catch (Exception $e) {
									$return_object['status'] = 'FALSE';
									$return_object['error'] = $e->getMessage();
							}
						}
						$return_object['api_settings']=$options;
						echo json_encode($return_object);
						exit;
					break;
					
					case 'mailchimp-loadlists':
						if( $_SERVER['HTTP_HOST'] == 'cnm.local' ){
							$_data='{"lists":[{"id":"fc76e8dcfs","name":"LPS 0"},{"id":"fc76e8dcfa","name":"LPS 1"},{"id":"fc76e8dcf2","name":"LPS 2"}],"status":"OK","api_settings":{"mailchimp_api_key":"e6a39ecbda0e38a1597e7883de42ef9f-us14","mailchimp_user":"imssarl"}}';
							echo json_encode(json_decode($_data));
							exit;
						}
						$options['mailchimp_api_key'] = trim(stripslashes($_POST['mailchimp_api_key']));
						$options['mailchimp_user'] = trim(stripslashes($_POST['mailchimp_user']));
						if (!empty( $options['mailchimp_api_key'] ) ) {
							$return_object = array('lists'=>array());
							$return_object['status'] = 'OK';
							try {
								$server=explode( '-', $options['mailchimp_api_key'] );
								$server=$server[1];
								$ch = curl_init( 'https://'.$server.'.api.mailchimp.com/3.0/lists' );
								curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
								curl_setopt($ch, CURLOPT_USERPWD, $options['mailchimp_user'].':'.$options['mailchimp_api_key']); //Your credentials goes here
								curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
								curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "GET");
								curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); //IMP if the url has https and you don't want to verify source certificate
								$dataSequences = curl_exec( $ch );
								curl_close($ch);
								$dataSequences=json_decode( $dataSequences, true );
								foreach( $dataSequences['lists'] as $list ){
									$return_object['lists'][]=array( 'id'=>$list['id'], 'name'=>$list['name'] );
								}
							} catch (Exception $e) {
									$return_object['status'] = 'FALSE';
									$return_object['error'] = $e->getMessage();
							}
						}
						$return_object['api_settings']=$options;
						echo json_encode($return_object);
						exit;
					break;
					
					case 'mailchimp-loadfields':
						if( $_SERVER['HTTP_HOST'] == 'cnm.local' ){
							$_data='{"status":"OK","fields":[],"api_settings":{"mailchimp_api_key":"e6a39ecbda0e38a1597e7883de42ef9f-us14"}}';
							echo json_encode(json_decode($_data));
							exit;
						}
						$options['mailchimp_api_key'] = trim(stripslashes($_POST['mailchimp_api_key']));
						$options['mailchimp_user'] = trim(stripslashes($_POST['mailchimp_user']));
						$options['mailchimp_list_id'] = trim(stripslashes($_POST['mailchimp_list_id']));
						if (!empty( $options['mailchimp_api_key'] ) && !empty( $options['mailchimp_list_id'] ) ) {
							$return_object = array('fields'=>array());
							$return_object['status'] = 'OK';
							try {
								$server=explode( '-', $options['mailchimp_api_key'] );
								$server=$server[1];
								$ch = curl_init( 'https://'.$server.'.api.mailchimp.com/3.0/lists/'.$options['mailchimp_list_id'].'/merge-fields/' );
								curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
								curl_setopt($ch, CURLOPT_USERPWD, $options['mailchimp_user'].':'.$options['mailchimp_api_key']); //Your credentials goes here
								curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
								curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "GET");
								curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); //IMP if the url has https and you don't want to verify source certificate
								$dataSequences = curl_exec( $ch );
								curl_close($ch);
								$dataSequences=json_decode( $dataSequences, true );
								foreach( $dataSequences['merge_fields'] as $list ){
									$return_object['fields'][]=strtolower( $list['tag'] ).'~'.$list['name'];
								}
							}catch( Exception $e ){
								$return_object['status'] = 'FALSE';
								$return_object['error'] = $e->getMessage();
							}
						}
						$return_object['api_settings']=$options;
						echo json_encode($return_object);
						exit;
					break;
					
					
					case 'ontraport-loadfields':
						if( $_SERVER['HTTP_HOST'] == 'cnm.local' ){
							$_data='{"status":"OK","fields":["firstname~First Name","lastname~Last Name","address~Address","city~City","zip~Zip Code","aff_paypal~Paypal Address","company:Company","address2:Address 2","website:Website","title:Title","referral_page:Referring Page","f1410:Instaffiliate Password","f1411:Clickbank ID","f1412:Sellineo ID","ip_addy:IP Address","f1431:Main Reason to Start an online business","f1436:JVZ referrer","f1466:Selliner Referrer ID (first referrer)","f1463:Transaction ID: offer 1545 (most recent)","f1464:Sellineo Referrer ID (last referrer)","f1465:Transaction ID: offer 1545 (initial one)","f1467~Transaction ID: Offer 1547","f1473~Transaction ID: Offer 1557","f1474~Transaction ID: Offer 1561","f1475~Transaction ID: Offer 1579","last_inbound_sms:Last Inbound SMS"],"api_settings":{"ontraport_app_id":"2_25731_7DeHdGryD","ontraport_api_key":"S1ZmnRcJGGTcvz2"}}';
							echo json_encode(json_decode($_data));
							exit;
						}
						$options['ontraport_app_id'] = trim(stripslashes($_POST['ontraport_app_id']));
						$options['ontraport_api_key'] = trim(stripslashes($_POST['ontraport_api_key']));
						if (!empty( $options['ontraport_app_id'] ) ) {
							$return_object = array('fields'=>array());
							$return_object['status'] = 'OK';
							try {
								$ontraport_url = 'https://api.ontraport.com/1/objects/meta?format=byName&objectID=0';
								$ch = curl_init();
								curl_setopt($ch, CURLOPT_URL, $ontraport_url);
								curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
								curl_setopt($ch, CURLOPT_HEADER, 0);
								curl_setopt($ch, CURLOPT_HTTPHEADER, array(
									'Api-Appid: '.$options['ontraport_app_id'],
									'Api-Key: '.$options['ontraport_api_key'],
									'reqType: fetch_sequences'
								));
								$dataSequences = curl_exec( $ch );
								curl_close( $ch );
								$dataSequences=json_decode( $dataSequences, true );
								foreach( $dataSequences['data'] as $listContacts ){
									foreach( $listContacts["fields"] as $_fieldName=>$_listFieldData ){
										if( isset( $_listFieldData['type'] ) && $_listFieldData['type']=='text' ){
											$return_object['fields'][]=$_fieldName.'~'.$_listFieldData['alias'];
										}
									}
								}
							} catch (Exception $e) {
									$return_object['status'] = 'FALSE';
									$return_object['error'] = $e->getMessage();
							}
						}
						$return_object['api_settings']=$options;
						echo json_encode($return_object);
						exit;
					break;

					case 'aweber-loadfields':
						if( $_SERVER['HTTP_HOST'] == 'cnm.local' ){
							$_data='{"status":"OK","fields":{"12":"aff_api"}}';
							echo json_encode(json_decode($_data));
							exit;
						}
						$options['aweber_consumer_key'] = trim(stripslashes($_POST['aweber-consumer_key']));
						$options['aweber_consumer_secret'] = trim(stripslashes($_POST['aweber-consumer_secret']));
						$options['aweber_access_key'] = trim(stripslashes($_POST['aweber-access_key']));
						$options['aweber_access_secret'] = trim(stripslashes($_POST['aweber-access_secret']));
						$options['listId'] = trim(stripslashes($_POST['aweber-listid']));
						if (!empty( $options['aweber_access_secret'] ) ) {
							$return_object = array();
							$return_object['status'] = 'OK';
							try {
								require_once 'library/AWeberAPI/aweber.php';
								$aweber = new AWeberAPI($options['aweber_consumer_key'], $options['aweber_consumer_secret']);
								$account = $aweber->getAccount($options['aweber_access_key'], $options['aweber_access_secret']);
								$return_object['fields']=array();
								$fields = $account->loadFromUrl('/accounts/' . $account->id . '/lists/' . $options['listId'] . '/custom_fields');
								foreach( $fields->data['entries'] as $field ){
									if( isset( $field['name'] ) && !empty( $field['name'] ) )
										$return_object['fields'][ $field['id']]=$field['name'];
								}
								$_allCount=count( $fields );
								for( $i=100; isset( $fields->data['next_collection_link'] ) && $i<$_allCount; $i+=100 ){
									$fields = $account->loadFromUrl('/accounts/' . $account->id . '/lists/' . $options['listId'] . '/custom_fields?ws.start='.$i);
									foreach( $fields->data['entries'] as $field ){
										if( isset( $field['name'] ) && !empty( $field['name'] ) )
											$return_object['fields'][ $field['id']]=$field['name'];
									}
								}
							} catch (AWeberException $e) {
									$return_object['status'] = 'FALSE';
							}
						}
						echo json_encode($return_object);
						exit;
					break;

					case 'aweber-disconnect':
						$options['aweber_consumer_key'] = '';
						$options['aweber_consumer_secret'] = '';
						$options['aweber_access_key'] = '';
						$options['aweber_access_secret'] = '';
						$return_object = array();
						$return_object['status'] = 'OK';
						$return_object['html'] = '
							<table class="useroptions">
								<tr>
									<th>Authorization code:</th>
									<td>
										<input type="text" id="aweber_oauth_id" value="" class="widefat" placeholder="AWeber authorization code">
										<br />Get your authorization code <a target="_blank" href="https://auth.aweber.com/1.0/oauth/authorize_app/'.Project_Exquisite::$AWeberAppId.'">here</a>.
									</td>
								</tr>
								<tr>
									<th></th>
									<td style="vertical-align: middle;">
										<input type="button" class="button button-secondary" value="Make Connection" onclick="return aweber_connect();" >
										<img id="ulp-aweber-loading" src="/skin/i/frontends/design/newUI/exquisite_popups/loading.gif">
									</td>
								</tr>
							</table>';
						echo json_encode($return_object);
						exit;
					break;

					case 'perkzilla-campaigns':
						$api_key = trim(stripslashes($_POST['perkzilla_api_key']));
						$campaign_id = trim(stripslashes($_POST['perkzilla_campaign_id']));
						$html_object = new stdClass();
						$perkzilla=new Project_Mooptin_Perkzilla($api_key);
						$result=$perkzilla->getCampaigns();
						$campaigns=array();
						foreach ($result as $value) {
							$campaigns[$value['id']]=$value['campaign_name'];
						}
						if (sizeof($campaigns) > 0) {
							$perkzilla_options = '';
							foreach ($campaigns as $key => $value) {
								$perkzilla_options .= '<option value="'.$key.'"'.($key == $campaign_id ? ' selected="selected"' : '').'>'.htmlspecialchars($value, ENT_QUOTES).'</option>';
							}
							$html_object->options = $perkzilla_options;
						} else {
							$html_object->options = '<option>-- No campaigns found --</option>';
						}
						echo json_encode($html_object);
						exit;
					break;
					
					case 'getresponse-campaigns':
						$api_key = trim(stripslashes($_POST['getresponse_api_key']));
						$campaign_id = trim(stripslashes($_POST['getresponse_campaign_id']));
						$html_object = new stdClass();
						$getresponse=new Project_Mooptin_Getresponse($api_key);
						$result=$getresponse->getCampaigns();
						$campaigns=array();
						foreach ($result as $value) {
							$campaigns[$value->campaignId]=$value->name;
						}
						if (sizeof($campaigns) > 0) {
							$getresponse_options = '';
							foreach ($campaigns as $key => $value) {
								$getresponse_options .= '<option value="'.$key.'"'.($key == $campaign_id ? ' selected="selected"' : '').'>'.htmlspecialchars($value, ENT_QUOTES).'</option>';
							}
							$html_object->options = $getresponse_options;
						} else {
							$html_object->options = '<option>-- No campaigns found --</option>';
						}
						echo json_encode($html_object);
						exit;
					break;
					
					case 'convertkit-campaigns':
						$api_key = trim(stripslashes($_POST['convertkit_api_key']));
						$secret_key = trim(stripslashes($_POST['convertkit_secret_key']));
						$campaign_id = trim(stripslashes($_POST['convertkit_webinar_id']));
						$html_object = new stdClass();
						$getresponse=new Project_Mooptin_Convertkit($api_key);
						$result=$getresponse->getCampaigns();
						if( isset( $result->error ) ){
							echo json_encode($result);
							exit;
						}
						$campaigns=array();
						foreach ($result->courses as $value) {
							$campaigns[$value->id]=$value->name;
						}
						if (sizeof($campaigns) > 0) {
							$getresponse_options = '';
							foreach ($campaigns as $key => $value) {
								$getresponse_options .= '<option value="'.$key.'"'.($key == $campaign_id ? ' selected="selected"' : '').'>'.htmlspecialchars($value, ENT_QUOTES).'</option>';
							}
							$html_object->options = $getresponse_options;
						} else {
							$html_object->options = '<option>-- No campaigns found --</option>';
						}
						echo json_encode($html_object);
						exit;
					break;
					
					case 'everwebinar-campaigns':
						$api_key = trim(stripslashes($_POST['everwebinar_api_key']));
						$campaign_id = trim(stripslashes($_POST['everwebinar_webinar_id']));
						$html_object = new stdClass();
						$everwebinar=new Project_Mooptin_Everwebinar($api_key);
						$result=$everwebinar->getCampaigns();
						$campaigns=array();
						foreach ($result->webinars as $value) {
							$campaigns[$value->webinar_id]=$value->name;
						}
						if (sizeof($campaigns) > 0) {
							$everwebinar_options = '';
							foreach ($campaigns as $key => $value) {
								$everwebinar_options .= '<option value="'.$key.'"'.($key == $campaign_id ? ' selected="selected"' : '').'>'.htmlspecialchars($value, ENT_QUOTES).'</option>';
							}
							$html_object->options = $everwebinar_options;
						} else {
							$html_object->options = '<option>-- No campaigns found --</option>';
						}
						echo json_encode($html_object);
						exit;
					break;
					
					case 'webinarjam-campaigns':
						$api_key = trim(stripslashes($_POST['webinarjam_api_key']));
						$campaign_id = trim(stripslashes($_POST['webinarjam_webinar_id']));
						$html_object = new stdClass();
						$webinarjam=new Project_Mooptin_Webinarjam($api_key);
						$result=$webinarjam->getCampaigns();
						$campaigns=array();
						foreach ($result->webinars as $value) {
							$campaigns[$value->webinar_id]=$value->name;
						}
						if (sizeof($campaigns) > 0) {
							$webinarjam_options = '';
							foreach ($campaigns as $key => $value) {
								$webinarjam_options .= '<option value="'.$key.'"'.($key == $campaign_id ? ' selected="selected"' : '').'>'.htmlspecialchars($value, ENT_QUOTES).'</option>';
							}
							$html_object->options = $webinarjam_options;
						} else {
							$html_object->options = '<option>-- No campaigns found --</option>';
						}
						echo json_encode($html_object);
						exit;
					break;
					
					case 'сonvertkit-campaigns':
						$api_key = trim(stripslashes($_POST['сonvertkit_api_key']));
						$campaign_id = trim(stripslashes($_POST['сonvertkit_webinar_id']));
						$html_object = new stdClass();
						$сonvertkit=new Project_Mooptin_Convertkit($api_key);
						$result=$сonvertkit->getCampaigns();
						$campaigns=array();
						foreach ($result->webinars as $value) {
							$campaigns[$value->webinar_id]=$value->name;
						}
						if (sizeof($campaigns) > 0) {
							$сonvertkit_options = '';
							foreach ($campaigns as $key => $value) {
								$сonvertkit_options .= '<option value="'.$key.'"'.($key == $campaign_id ? ' selected="selected"' : '').'>'.htmlspecialchars($value, ENT_QUOTES).'</option>';
							}
							$html_object->options = $сonvertkit_options;
						} else {
							$html_object->options = '<option>-- No campaigns found --</option>';
						}
						echo json_encode($html_object);
						exit;
					break;

					case 'getresponse-loadfields':
						if( $_SERVER['HTTP_HOST'] == 'cnm.local' ){
							$_data='{"status":"OK","fields":{"12":"gr_api"}}';
							echo json_encode(json_decode($_data));
							exit;
						}
						$api_key = trim(stripslashes($_POST['getresponse_api_key']));
						$html_object = new stdClass();
						try {
							$getresponse=new Project_Mooptin_Getresponse($api_key);
							$fields=$getresponse->getCustomFields();
							$return_object = array();
							$return_object['fields']=array();
							$return_object['status'] = 'OK';
							foreach( $fields as $field ){
								if( $field->fieldType == 'text' )
									$return_object['fields'][]=$field->customFieldId.'~'.$field->name;
							}						
						} catch (AWeberException $e) {
							$return_object['status'] = 'FALSE';
						}
						echo json_encode($return_object);
						exit;
					break;
					
					case 'icontact-lists':
						$appid = trim(stripslashes($_POST['icontact_appid']));
						$apiusername = trim(stripslashes($_POST['icontact_apiusername']));
						$apipassword = trim(stripslashes($_POST['icontact_apipassword']));
						$listid = trim(stripslashes($_POST['icontact_listid']));
						$html_object = new stdClass();
						$lists = $_object->icontact_getlists($appid, $apiusername, $apipassword);
						if (sizeof($lists) > 0) {
							$icontact_options = '';
							foreach ($lists as $key => $value) {
								$icontact_options .= '<option value="'.$key.'"'.($key == $listid ? ' selected="selected"' : '').'>'.htmlspecialchars($value, ENT_QUOTES).'</option>';
							}
							$html_object->options = $icontact_options;
						} else {
							$html_object->options = '<option>-- No lists found --</option>';
						}
						echo json_encode($html_object);
						exit;
					break;

					case 'madmimi-lists':
						$madmimi_login = trim(stripslashes($_POST['madmimi_login']));
						$madmimi_api_key = trim(stripslashes($_POST['madmimi_api_key']));
						$madmimi_list_id = trim(stripslashes($_POST['madmimi_list_id']));
						$html_object = new stdClass();
						
						$lists = $_object->madmimi_getlists($madmimi_login, $madmimi_api_key);
						if (sizeof($lists) > 0) {
							$madmimi_options = '';
							foreach ($lists as $key => $value) {
								$madmimi_options .= '<option value="'.$key.'"'.($key == $madmimi_list_id ? ' selected="selected"' : '').'>'.htmlspecialchars($value, ENT_QUOTES).'</option>';
							}
							$html_object->options = $madmimi_options;
						} else {
							$html_object->options = '<option>-- No lists found --</option>';
						}
						echo json_encode($html_object);
						exit;
					break;

					case 'benchmark-lists':
						$benchmark_api_key = trim(stripslashes($_POST['benchmark_api_key']));
						$benchmark_list_id = trim(stripslashes($_POST['benchmark_list_id']));
						$html_object = new stdClass();
						
						$lists = $_object->benchmark_getlists($benchmark_api_key);
						if (sizeof($lists) > 0) {
							$benchmark_options = '';
							foreach ($lists as $key => $value) {
								$benchmark_options .= '<option value="'.$key.'"'.($key == $benchmark_list_id ? ' selected="selected"' : '').'>'.htmlspecialchars($value, ENT_QUOTES).'</option>';
							}
							$html_object->options = $benchmark_options;
						} else {
							$html_object->options = '<option>-- No lists found --</option>';
						}
						echo json_encode($html_object);
						exit;
					break;

					case 'activecampaign-lists':
						$activecampaign_url = trim(stripslashes($_POST['activecampaign_url']));
						$activecampaign_api_key = trim(stripslashes($_POST['activecampaign_api_key']));
						$activecampaign_list_id = trim(stripslashes($_POST['activecampaign_list_id']));
						$html_object = new stdClass();
						
						$lists = $_object->activecampaign_getlists($activecampaign_url, $activecampaign_api_key);
						if (sizeof($lists) > 0) {
							$activecampaign_options = '';
							foreach ($lists as $key => $value) {
								$activecampaign_options .= '<option value="'.$key.'"'.($key == $activecampaign_list_id ? ' selected="selected"' : '').'>'.htmlspecialchars($value, ENT_QUOTES).'</option>';
							}
							$html_object->options = $activecampaign_options;
						} else {
							$html_object->options = '<option>-- No lists found --</option>';
						}
						echo json_encode($html_object);
						exit;
					break;

					case 'interspire-lists':
						$interspire_url = trim(stripslashes($_POST['interspire_url']));
						$interspire_username = trim(stripslashes($_POST['interspire_username']));
						$interspire_token = trim(stripslashes($_POST['interspire_token']));
						$interspire_listid = trim(stripslashes($_POST['interspire_listid']));
						$html_object = new stdClass();
						
						$lists = $_object->interspire_getlists($interspire_url, $interspire_username, $interspire_token);
						if (sizeof($lists) > 0) {
							$interspire_options = '';
							foreach ($lists as $key => $value) {
								$interspire_options .= '<option value="'.$key.'"'.($key == $interspire_listid ? ' selected="selected"' : '').'>'.htmlspecialchars($value, ENT_QUOTES).'</option>';
							}
							$html_object->options = $interspire_options;
						} else {
							$html_object->options = '<option>-- No lists found --</option>';
						}
						echo json_encode($html_object);
						exit;
					break;

					case 'interspire-fields':
						$interspire_url = trim(stripslashes($_POST['interspire_url']));
						$interspire_username = trim(stripslashes($_POST['interspire_username']));
						$interspire_token = trim(stripslashes($_POST['interspire_token']));
						$interspire_listid = trim(stripslashes($_POST['interspire_listid']));
						$interspire_nameid = trim(stripslashes($_POST['interspire_nameid']));
						$html_object = new stdClass();
						
						$fields = $_object->interspire_getfields($interspire_url, $interspire_username, $interspire_token, $interspire_listid);
						if (sizeof($fields) > 0) {
							$interspire_options = '';
							foreach ($fields as $key => $value) {
								$interspire_options .= '<option value="'.$key.'"'.($key == $interspire_nameid ? ' selected="selected"' : '').'>'.htmlspecialchars($value, ENT_QUOTES).'</option>';
							}
							$html_object->options = $interspire_options;
						} else {
							$html_object->options = '<option>-- No fields found --</option>';
						}
						echo json_encode($html_object);
						exit;
					break;
						
					default:
					break;
				}
			}
		}
		if(empty($_POST['country_code'])) {
			return false;
		}
		if( isset( $_SERVER['HTTP_HOST'] ) && ( $_SERVER['HTTP_HOST'] == 'cnm.local' || $_SERVER['HTTP_HOST'] == 'cnm.cnmbeta.info' ) ){
			$this->out_js = array('+'.rand(0,99999999999),'+'.rand(0,99999999999),'+'.rand(0,99999999999),'+'.rand(0,99999999999),'+'.rand(0,99999999999)); // TESTING CODE
		}elseif( $_POST['type'] == 'new' ){
			$_phoneNumbers=array();
			try{
				$twilio = new Project_Ccs_Twilio_Abstract();
				$numbers=$twilio->_client->availablePhoneNumbers(@$_POST['country_code'])->local->read(
					array(
						"SmsEnabled" => 'true'
					)
				);
				foreach($numbers as $number) {
					$_phoneNumbers[]=$number->phoneNumber;
				}
			}catch(Exception $ex){}
			try{
				$twilio = new Project_Ccs_Twilio_Abstract();
				$numbers=$twilio->_client->availablePhoneNumbers(@$_POST['country_code'])->mobile->read(
					array(
						"SmsEnabled" => 'true'
					)
				);
				foreach($numbers as $number) {
					$_phoneNumbers[]=$number->phoneNumber;
				}
			}catch(Exception $ex){}
			try{
				$twilio = new Project_Ccs_Twilio_Abstract();
				$numbers=$twilio->_client->availablePhoneNumbers(@$_POST['country_code'])->tollFree->read(
					array(
						"SmsEnabled" => 'true'
					)
				);
				foreach($numbers as $number) {
					$_phoneNumbers[]=$number->phoneNumber;
				}
			}catch(Exception $ex){}
			$_phones=new Project_Squeeze_Twilio();
			$_phones->onlyOwner()->onlyNumbers()->withCountry( @$_POST['country_code'] )->getList( $_oldNumbers );
			$this->out_js = array_merge( (empty($_phoneNumbers))?array():$_phoneNumbers, (empty($_oldNumbers))?array():$_oldNumbers );
		}
		return true;
	}

	public function create(){
		$company = new Project_Mooptin();
		if (!empty($_POST)) {
			$_redirectToaction='manage';
			if( isset( $_POST['flgFromPopup'] ) && $_POST['flgFromPopup']==1 ){
				$_redirectToaction='createpopup';
			}
			if( isset( $_POST['settings'] ) ){
				$_POST['arrData']['settings']=$_POST['arrData']['settings']+array('optin_form_settings'=>$_POST['settings']);
			}
			if ( $company->setEntered( $_POST['arrData'] )->set() ) {
				$company->getEntered( $returnData );
				$this->objStore->toAction( $_redirectToaction )->set( array( 'msg'=>'Integration saved successfully', 'arrData'=>$returnData ) );
				$this->location( array( 'action'=>$_redirectToaction ) );
				return;
			}
			$this->objStore->toAction( $_redirectToaction )->set( array( 'error'=>'Integration not saved' ) );
		}
		if( !isset( $this->out['arrData'] ) && isset($_GET['id']) && !empty( $_GET['id'] ) ){
			$company
				->withIds( $_GET['id'] )
				->onlyOwner()
				->onlyOne()
				->getList( $this->out['arrData'] );
		}
		// IO
		$_options=new Project_Exquisite_Options();
		$_options->onlyOwner()->getList( $this->out['popup_io_options'] );
		$this->out['popup_io_options']=array_filter( empty( $this->out['popup_io_options'] ) ?array():$this->out['popup_io_options'] )+array_filter( Project_Exquisite_Options::$defaultOptions );
		if( isset( $this->out['arrData']['settings'] ) ){
			$this->out['popup_io_options']=array_filter( empty( $this->out['arrData']['settings'] )?array():$this->out['arrData']['settings'] )+array_filter( empty( $this->out['popup_io_options'] )?array():$this->out['popup_io_options'] );
		}
		if( isset( $this->out['arrData']['settings']['optin_form_settings'] ) ){
			$this->out['settings']=$this->out['arrData']['settings']['optin_form_settings'];
		}
		//Project_Mooptin_Autoresponders::install();
		$company = new Project_Mooptin_Autoresponders();
		$company
			->onlyOwner()
			->getList( $this->out['arList'] );
		foreach( $this->out['arList'] as &$_listData ){
			$_mergeFields=array();
			foreach( $this->out['arrData']['settings']['form'][$_listData['id']] as $_newFieldData ){
				$_nameValue='';
				if( isset( $_newFieldData['new_name'] ) ){
					$_nameValue=$_newFieldData['new_name'];
				}
				if( isset( $_newFieldData['name'] ) ){
					$_nameValue=$_newFieldData['name'];
				}
				$_mergeFields[$_nameValue]=$_newFieldData;
			}
			foreach( $_listData['settings']['options']['newFields'] as $_formFieldData ){
				$_nameValue='';
				if( isset( $_formFieldData['new_name'] ) ){
					$_nameValue=$_formFieldData['new_name'];
				}
				if( isset( $_formFieldData['name'] ) ){
					$_nameValue=$_formFieldData['name'];
				}
				if( isset( $_mergeFields[$_nameValue] ) ){
					foreach( $_formFieldData as $_formNameData=>$_formValueData ){
						$_mergeFields[$_nameValue][$_formNameData]=$_formValueData;
					}
				}else{
					$_mergeFields[$_nameValue]=$_formFieldData;
				}
			}
			$_mergeFields=array_values( $_mergeFields );
			$_listData['b64opt']=base64_encode(json_encode(
				array('integration'=>$_listData['settings']['integration'][0])
				+array('newFields'=>$_mergeFields) //((isset( $this->out['arrData']['settings']['form'][$_listData['id']] ))?$this->out['arrData']['settings']['form'][$_listData['id']]:array()))
				+(isset($_listData['settings']['options'])?$_listData['settings']['options']:array())
			));
		}
		$this->out['b64data']=base64_encode(json_encode($this->out['arrData']['settings']));
		$_phones=new Project_Squeeze_Twilio();
		$_phones->onlyOwner()->getList( $_arrTwilioNimbers );
		if( count( $_arrTwilioNimbers )>0 ){
			$this->out['arrUserCountries']=array();
		}
		foreach( $_arrTwilioNimbers as $_number ){
			if( !isset( $this->out['arrUserCountries'][$_number['country']] ) ){
				$this->out['arrUserCountries'][$_number['country']]=array( 'code'=>$_number['country'], 'numbers'=>array() );
			}
			$this->out['arrUserCountries'][$_number['country']]['numbers'][]=$_number['phone'];
		}
	}

	public function twilio_api(){
		$_fileName='twiml'.time();
		file_put_contents('/data/www/'.Zend_Registry::get( 'config' )->domain->host.'/html/services/test_letters/'.$_fileName.'.log', serialize($this->params), FILE_APPEND);
		chmod('/data/www/'.Zend_Registry::get( 'config' )->domain->host.'/html/services/test_letters/'.$_fileName.'.log', 0755);
		file_put_contents('/data/www/'.Zend_Registry::get( 'config' )->domain->host.'/html/services/test_letters/'.$_fileName.'.log', "\n\nPOST".serialize($_POST), FILE_APPEND);
		file_put_contents('/data/www/'.Zend_Registry::get( 'config' )->domain->host.'/html/services/test_letters/'.$_fileName.'.log', "\n\nGET".serialize($_GET), FILE_APPEND);
		$_codedId=Project_Widget_Mutator::decode( $this->params['action_vars'] );
		// == user_id  Project_Widget_Mutator::decode( $this->params['action_vars'] )
		if( empty( $_codedId ) ){
			file_put_contents('/data/www/'.Zend_Registry::get( 'config' )->domain->host.'/html/services/test_letters/'.$_fileName.'.log', "\n\nempty codedId", FILE_APPEND);
			return false;
		}
		$_user=new Project_Users_Management();
		if( !$_user->withIds( $_codedId )->onlyOne()->getList( $arrUser ) ){
			file_put_contents('/data/www/'.Zend_Registry::get( 'config' )->domain->host.'/html/services/test_letters/'.$_fileName.'.log', "\n\nempty user", FILE_APPEND);
			return false;
		}
		if( empty($arrUser['id']) ){
			file_put_contents('/data/www/'.Zend_Registry::get( 'config' )->domain->host.'/html/services/test_letters/'.$_fileName.'.log', "\n\nempty user id", FILE_APPEND);
			return false;
		}
		require_once './library/Core/Services/Twilio/autoload.php';
		$_client=new Twilio\Rest\Client( $arrUser['twilio']['sid'], $arrUser['twilio']['token'] );
		if( empty($_POST['SmsSid']) ){
			file_put_contents('/data/www/'.Zend_Registry::get( 'config' )->domain->host.'/html/services/test_letters/'.$_fileName.'.log', "\n\nempty post", FILE_APPEND);
			return false;
		}
		$_message=$_client
			->messages( $_POST['SmsSid'] )
			->fetch();
		$_model=new Project_Ccs_Sms();
		$_model->setEntered(array(
			'SmsSid'=>$_message->sid,
			'To'=>$_message->to,
			'From'=>$_message->from,
			'SmsStatus'=>$_message->status,
			'Direction'=>$_message->direction,
			'Body'=>$_message->body,
		))->set();
		file_put_contents('/data/www/'.Zend_Registry::get( 'config' )->domain->host.'/html/services/test_letters/'.$_fileName.'.log', "\n\n".serialize($_message), FILE_APPEND);
		$_arrMessage=explode( ' ', $_message->body );
		if( strlen( $_arrMessage[0] ) == 32 ){
			$arrRequest['letterid']=$_arrMessage[0];
			if( strpos( end( $_arrMessage ), '@' ) !== false ){
				$arrRequest['email']=end( $_arrMessage );
			}
			$arrRequest['phone']=$_message->from;
			$obj=new Project_Mooptin_Autoresponders();
			$obj->sendAutorespond( $arrRequest );
		}
		return true;
	}

	public function manage(){
		$this->objStore->getAndClear( $this->out );
		$company = new Project_Mooptin();
		if ( !empty($_GET['del']) ) {
			if ( $company->withIds( $_GET['del'] )->onlyOwner()->del() ) {
				$this->objStore->set( array( 'msg'=>'Company deleted successfully' ) );
			} else {
				$this->objStore->set( array( 'error'=>'Company notdeleted' ) );
			}
			$this->location( array( 'action'=>'manage') );
		}
		$company->onlyOwner();
		if( !isset( $_GET['elementsName'] ) ){
			$company->withOrder( @$_GET['order'] );
			$company->withPaging(array(
				'url'=>@$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			));
		}
		$company->getList( $this->out['arrList'] );
		if( !isset( $_GET['elementsName'] ) ){
			$company->getPaging( $this->out['arrPg'] );
			$company->getFilter( $this->out['arrFilter'] );
		}
		if( isset( $_GET['elementsName'] ) ){ 
			$this->out['elementsName']=$_GET['elementsName'];
		}
		if( isset( $_GET['checkedId'] ) ) $this->out['checkedId']=$_GET['checkedId'];
	}

}
?>