<?php
/**
 * Organizer module
 *
 * @category CNM Project
 * @package ProjectSource
 */
class site1_funnels extends Core_Module {
	
	public function set_cfg(){
		$this->inst_script=array(
			'module' =>array( 'title'=>'CNM Funnels', ),
			'actions'=>array(
				array( 'action'=>'dashboard', 'title'=>'Dashboard', 'flg_tree'=>1 ),
				array( 'action'=>'settings', 'title'=>'Settings', 'flg_tree'=>1 ),
				array( 'action'=>'create', 'title'=>'Create Funnel', 'flg_tree'=>1 ),
				array( 'action'=>'manage', 'title'=>'Your Funnels', 'flg_tree'=>1 ),
				array( 'action'=>'leads', 'title'=>'Your Leads', 'flg_tree'=>1 ),
				array( 'action'=>'ajax', 'title'=>'Ajax', 'flg_tpl'=>3, 'flg_tree'=>2 ),
				array( 'action'=>'popup_templates', 'title'=>'Popup templates', 'flg_tpl'=>1, 'flg_tree'=>1 ),
			),
		);
	}

	public function dashboard(){
		$this->objStore->getAndClear( $this->out );
		$_squeeze=new Project_Squeeze();
		if(empty($_GET['arrFilter']['time'])){
			$_GET['arrFilter']['time']=4;
		}
		if(!empty($_GET['id'])){
			$_squeeze
				->withReportById($_GET['id'])
				->withListFromTracker()
				->withOrder('c.crt--dn')
				->withFilter(@$_GET['arrFilter'])
				->getList($this->out['arrList']);
		}else{
			$_squeeze
				->withListFromTracker()
				->withOrder('c.crt--dn')
				->withFilter(@$_GET['arrFilter'])
				->getList($this->out['arrList'])
				->getFilter( $this->out['arrFilter'] );

			$clicks=0; $visitors=0;
			foreach ($this->out['arrList'] as $key => $value){
				$clicks += $value['clicks'];
				$visitors += $value['visitors'];
			}
			$this->out['statistic']=array(
				'clicks' => $clicks,
				'visitors' => $visitors
			);
		}
		$_squeeze
			->onlyOwner()
			->getList( $this->out['arrCount'] );
		$this->out['arrDate']=$this->out['arrCountryList']=array();
		foreach( $this->out['arrList'] as $_page ){
			// блок графика
			if( isset( $_page['arr_visitors']['date'] ) ){
				foreach( $_page['arr_visitors']['date'] as $_date=>$_count ){
					if( isset( $this->out['arrDate'][$_date] ) ){
						$this->out['arrDate'][$_date]['view']+=$_count;
					}else{
						$this->out['arrDate'][$_date]=array(
							'date'=>$_date,
							'click'=>0,
							'view'=>$_count 
						);
					}
				}
			}
			if( isset( $_page['arr_clicks']['date'] ) ){
				foreach( $_page['arr_clicks']['date'] as $_date=>$_count ){
					if( isset( $this->out['arrDate'][$_date] ) ){
						$this->out['arrDate'][$_date]['click']+=$_count;
					}else{
						$this->out['arrDate'][$_date]=array(
							'date'=>$_date,
							'click'=>$_count ,
							'view'=>0
						);
					}
				}
			}
			// блок стран
			if( isset( $_page['arr_visitors']['countries'] ) ){
				foreach( $_page['arr_visitors']['countries'] as $_date=>$_count ){
					if( isset( $this->out['arrCountryList'][$_date] ) ){
						$this->out['arrCountryList'][$_date]['view']+=$_count;
					}else{
						$this->out['arrCountryList'][$_date]=array(
							'country'=>$_date,
							'click'=> 0,
							'view'=>$_count
						);
					}
				}
			}
			if( isset( $_page['arr_clicks']['countries'] ) ){
				foreach( $_page['arr_clicks']['countries'] as $_date=>$_count ){
					if( isset( $this->out['arrCountryList'][$_date] ) ){
						$this->out['arrCountryList'][$_date]['click']+=$_count;
					}else{
						$this->out['arrCountryList'][$_date]=array(
							'country'=>$_date,
							'click'=>$_count ,
							'view'=>0
						);
					}
				}
			}
			// utm
			if( isset( $_page['utm_log'] ) ){
				foreach( $_page['utm_log'] as $_utmLogData ){
					if( !in_array( $_utmLogData['utm_source'], $this->out['arrUtmSourceFilter'] ) && $_utmLogData['utm_source']!='' )
						$this->out['arrUtmSourceFilter'][]=$_utmLogData['utm_source'];
					if( !in_array( $_utmLogData['utm_medium'], $this->out['arrUtmMediumFilter'] ) && $_utmLogData['utm_medium']!='' )
						$this->out['arrUtmMediumFilter'][]=$_utmLogData['utm_medium'];
					if( !in_array( $_utmLogData['utm_campaign'], $this->out['arrUtmCampaignFilter'] ) && $_utmLogData['utm_campaign']!='' )
						$this->out['arrUtmCampaignFilter'][]=$_utmLogData['utm_campaign'];
					if( isset( $_GET['arrFilter'] ) && isset( $_GET['arrFilter']['utm_source'] ) && !empty($_GET['arrFilter']['utm_source']) && $_GET['arrFilter']['utm_source']!=$_utmLogData['utm_source'] ){
						continue;
					}
					if( isset( $_GET['arrFilter'] ) && isset( $_GET['arrFilter']['utm_medium'] ) &&  !empty($_GET['arrFilter']['utm_medium']) && $_GET['arrFilter']['utm_medium']!=$_utmLogData['utm_medium'] ){
						continue;
					}
					if( isset( $_GET['arrFilter'] ) && isset( $_GET['arrFilter']['utm_campaign'] ) &&  !empty($_GET['arrFilter']['utm_campaign']) && $_GET['arrFilter']['utm_campaign']!=$_utmLogData['utm_campaign'] ){
						continue;
					}
					$flgUpdatePrev=false;
					foreach( $this->out['arrUtmList'] as &$_utmUpdate ){
						if( $_utmUpdate['utm_source'] == $_utmLogData['utm_source']
							&& $_utmUpdate['utm_medium'] == $_utmLogData['utm_medium']
							&& $_utmUpdate['utm_term'] == $_utmLogData['utm_term']
							&& $_utmUpdate['utm_content'] == $_utmLogData['utm_content']
							&& $_utmUpdate['utm_campaign'] == $_utmLogData['utm_campaign'] ){
								$flgUpdatePrev=true;
								$_utmUpdate['visitors']+=$_utmLogData['visitors'];
								$_utmUpdate['clicks']+=$_utmLogData['clicks'];
								continue;
							}
					}
					if( !$flgUpdatePrev ){
						$this->out['arrUtmList'][]=$_utmLogData;
					}
				}
			}
		}
		
		foreach( $this->out['arrList'] as &$_adata ){
			$_adata['rate']=$_adata['clicks']/$_adata['visitors']*100;
		}
		$_func_mv='cmp_view_up';
		if($_GET['order_mv'] == 'view--dn') $_func_mv='cmp_view_dn';
		if($_GET['order_mv'] == 'view--up') $_func_mv='cmp_view_up';
		if($_GET['order_mv'] == 'click--up') $_func_mv='cmp_click_up';
		if($_GET['order_mv'] == 'click--dn') $_func_mv='cmp_click_dn';
		if($_GET['order_mv'] == 'rate--up') $_func_mv='cmp_rate_up';
		if($_GET['order_mv'] == 'rate--dn') $_func_mv='cmp_rate_dn';	
		if( count( $this->out['arrList'] ) > 1 ){
			function cmp_view_up($a, $b){
				return $a["visitors"] <  $b["visitors"];
			}
			function cmp_view_dn($a, $b){
				return $a["visitors"] >  $b["visitors"];
			}
			function cmp_click_up($a, $b){
				return $a["clicks"] <  $b["clicks"];
			}
			function cmp_click_dn($a, $b){
				return $a["clicks"] >  $b["clicks"];
			}
			function cmp_rate_up($a, $b){
				return $a["rate"] <  $b["rate"];
			}
			function cmp_rate_dn($a, $b){
				return $a["rate"] >  $b["rate"];
			}
			uasort($this->out['arrList'], $_func_mv);
		}
		foreach( $this->out['arrCountryList'] as &$_cdata ){
			$_cdata['rate']=$_cdata['click']/$_cdata['view']*100;
		}
		$_func='up_rate';
		if($_GET['order'] == 'view--up') $_func='up_view';
		if($_GET['order'] == 'view--dn') $_func='dn_view';
		if($_GET['order'] == 'click--up') $_func='up_click';
		if($_GET['order'] == 'click--dn') $_func='dn_click';	
		if($_GET['order'] == 'rate--up') $_func='up_rate';
		if($_GET['order'] == 'rate--dn') $_func='dn_rate';
		if($_GET['order'] == 'country--up') $_func='up_country';
		if($_GET['order'] == 'country--dn') $_func='dn_country';

		if( count( $this->out['arrCountryList'] ) > 1 ){
			function up_rate($a, $b){
				return $a["rate"] <  $b["rate"];
			}
			function dn_rate($a, $b){
				return $a["rate"] >  $b["rate"];
			}
			function up_view($a, $b){
				return $a["view"] <  $b["view"];
			}
			function dn_view($a, $b){
				return $a["view"] >  $b["view"];
			}
			function up_click($a, $b){
				return $a["click"] <  $b["click"];
			}
			function dn_click($a, $b){
				return $a["click"] >  $b["click"];
			}
			function up_country($a, $b){
				return $a["country"] <  $b["country"];
			}
			function dn_country($a, $b){
				return $a["country"] >  $b["country"];
			}
			uasort($this->out['arrCountryList'], $_func);
		}

		if(!empty($_GET)){
			$_get=$_GET;
			//$id=$_GET['id'];
			unSet($_get['order']);
			unSet($_get['order_mv']);
			unSet($_get['id']);
			$this->out['sortParam']=http_build_query($_get);
			//$_GET['id']=$id;
		}
		$this->out['strDate']='[';
		foreach( $this->out['arrDate'] as $_data ){
			$this->out['strDate'].='{y:\''.$_data['date'].'\',a:'.$_data['click'].',b:'.$_data['view'].'},';
		}
		$this->out['strDate'].=']';
		function cmp_view_up_2($a, $b){
			return $a["visitors"] < $b["visitors"];
		}
		uasort($this->out['arrUtmList'], 'cmp_view_up_2');
	}

	public function settings(){
		$this->objStore->getAndClear( $this->out );
		$_model = new Project_Content_Settings();

		if ( !empty($_POST['arrCnt']) ){
			$_model->setEntered($_POST['arrCnt'])->set();
			$this->objStore->set( array( 'msg'=>'Saved successfully' ) );
			$this->location();
		}
		$_model->onlyOne()->withFlgDefault()->onlySource('102')->getContent( $_getRes );//в $getRes - данные из таблицы
		$this->out['arrCnt']=$_getRes;

		$this->objStore->getAndClear( $this->out );
		if( isset( $_POST['arrData'] ) ){
			$_user=new Project_Users_Management();
			$_user->updateTwilio( $_POST['arrData'] );
		}
		$company = new Project_Mooptin_Autoresponders();
		if ( !empty($_GET['del']) ){
			if ( $company->withIds( $_GET['del'] )->onlyOwner()->del() ){
				$this->objStore->set( array( 'msg'=>'Company deleted successfully' ) );
			} else {
				$this->objStore->set( array( 'error'=>'Company notdeleted' ) );
			}
			$this->location();
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

	public function create(){
		$this->objStore->getAndClear( $this->out );
		if( isset($_POST['name']) && $_POST['name']=='link' ){
			ob_clean();
			header('Content-Type: application/json');
			echo Project_Squeeze::getImageFromLink($_POST['value']);
			die();
		}
		if( isset( $this->out['generatedLink'] ) ){
			Core_Users::$info['send2Intercome']=array(
				'json'=>json_encode( array( 'lps_url'=>$this->out['generatedLink'], 'lps_publishing'=>'CNMHOSTED' ) ),
				'action'=>'LPS-Generated'
			);
		}
		if( !empty($_POST['arrData']) ){
			$_collectSettings=$_POST['arrData'];
			$_squeeze=new Project_Squeeze();
			$_templateId=$_collectSettings['settings']['funnel_tpl'];
			if( isset( $_POST['id'] ) && !empty( $_POST['id'] ) ){
				$_templateId=$_POST['id'];
			}
			if( isset( $_templateId ) ){
				$_squeeze->withIds( $_templateId )->onlyOne()->getList( $_arrParent );
				unset( $_arrParent['id'] );
				unset( $_arrParent['settings']['validation_realtime'] );
				unset( $_arrParent['settings']['flg_powered'] );
				unset( $_arrParent['url'] );
				unset( $_arrParent['settings']['form'] );
				unset( $_arrParent['settings']['form_autoresponder'] );
				unset( $_arrParent['settings']['form_autoresponder_hide'] );
				unset( $_arrParent['user_id'] );
				unset( $_arrParent['flg_template'] );
				unset( $_arrParent['tags'] );
				unset( $_arrParent['settings']['domain_http'] );
				unset( $_arrParent['settings']['url'] );
				unset( $_arrParent['settings']['funnels_jvzoodid'] );
				unset( $_arrParent['settings']['funnels_clickbank'] );
				unset( $_arrParent['settings']['flg_funnels_widget'] );
				$_arrParent['settings']['tracking_code']='';
				$_arrParent['settings']['tracking_code_body']='';
				$_arrParent['settings']['flg_geo_location']=0;
				$_arrParent['settings']['geo_enabled']=array();
				$_arrParent['settings']['publishing_options']='local';
				$_arrParent['settings']['ftp_directory']='';
			}
			if( !isset( $_arrParent['settings']['funnel_tpl'] ) || empty( $_arrParent['settings']['funnel_tpl'] ) ){
				$_arrParent['settings']['funnel_tpl']=$_collectSettings['settings']['funnel_tpl'];
			}
			if( isset( $_collectSettings['ftp_directory'] ) && !empty( $_collectSettings['ftp_directory'] ) && strlen( $_collectSettings['ftp_directory'] ) > 3 ){
				$_arrParent['settings']['ftp_directory']=$_collectSettings['ftp_directory'];
			}

			if( isset( $_POST['id'] ) && !empty( $_POST['id'] ) ){
				$_arrParent['id']=$_POST['id'];
			}
			if( isset( $_POST['url'] ) && !empty( $_POST['url'] ) ){
				$_arrParent['url']=$_POST['url'];	
				$_arrParent['settings']['url']=$_POST['url'];
			}
			if( isset( $_collectSettings['tags'] ) && !empty( $_collectSettings['tags'] ) ){
				$_arrParent['tags']=$_collectSettings['tags'];	
			}
			$_arrParent['flg_funnel']=true;
			$_arrParent['settings']['flg_powered']=$_collectSettings['settings']['flg_powered'];
			$returnData=array();
			if( isset( $_collectSettings['settings']['flg_optin'] ) && $_collectSettings['settings']['flg_optin'] == 1 ){
				// создаем mooptin
				$_mooptin=new Project_Mooptin();
				$_sendMoOptin=array(
					'settings' => array(
						'type' => 'optin',
						'optin_form' => '<form><input type="submit"></form>',
						'form' => $_collectSettings['settings']['form'],
						'flg_conformation' => '0',
						'conformation_line' => '',
						'conformation_text' => '',
						'subject_line' => '',
						'subject_text' => '',
						'integrations' => $_collectSettings['settings']['integrations'],
						'options' => $_collectSettings['settings']['options'],
						'sms_confirmation' => '1',
						'sms_text' => '',
					),
					'tags' => 'funnel, optin',
					'name' => 'Funnel #'.$_arrParent['settings']['funnel_tpl'],
				);
				if( isset( $_GET['id'] ) && !empty( $_arrParent['settings']['mo_optin_id'] ) ){
					$_squeeze->withIds( $_GET['id'] )->onlyOwner()->onlyOne()->getList( $_arrData );
					$_sendMoOptin['id'] = $_arrData['settings']['mo_optin_id'];
					$_mooptin->withIds( $_arrData['settings']['mo_optin_id'] )->onlyOne()->getList( $_sendMoOptin );
					$_sendMoOptin['settings']['integrations'] = $_collectSettings['settings']['integrations'];
					$_sendMoOptin['settings']['options'] = $_collectSettings['settings']['options'];
					$_sendMoOptin['settings']['form'] = $_collectSettings['settings']['form'];
				}
				if ( $_mooptin->setEntered( $_sendMoOptin )->set() ){
					$_mooptin->getEntered( $returnData );
				}
				$_arrParent['settings']['optinButtonAction']='redirect';
				$_arrParent['settings']['optinButtonActionURL']=$_collectSettings['settings']['affiliate_link_after_optin'];
				$_arrParent['settings']['mo_optin_id']=$returnData['id'];
				$_arrParent['settings']['flg_fields_style']=2;
				$_arrParent['settings']['view_button']=1;
				$_arrParent['settings']['type_page']=2; // optin
				$_arrParent['settings']['optin']=array( 'type'=>'mooptin' );
			}
			if( isset( $_collectSettings['settings']['flg_redirect'] ) && $_collectSettings['settings']['flg_redirect'] == 1 ){
				$_arrParent['settings']['link_url']=$_collectSettings['settings']['affiliate_link'];
				$_arrParent['settings']['type_page']=1; // redirect
				$_arrParent['settings']['type_page_through']='0';
			}
			if( isset( $_collectSettings['settings']['flg_messenger'] ) && $_collectSettings['settings']['flg_messenger'] == 1 ){
				$_arrParent['settings']['facebook_username']=$_collectSettings['settings']['user_name'];
				$_arrParent['settings']['type_page']=3; // message
			}
			if( isset( $_collectSettings['settings']['flg_powered'] ) && $_collectSettings['settings']['flg_powered'] == 1 ){
				$_model = new Project_Content_Settings();
				$_model->onlyOne()->withFlgDefault()->onlySource('102')->getContent( $_getRes );
				$_jvzoodid='';
				$_clickbankid='';
				foreach( $_getRes['settings'] as $_name=>$_value ){
					if( strtolower( $_name ) == 'jvzoo' ){
						$_jvzoodid=$_value;
					}
					if( strtolower( $_name ) == 'clickbank' ){
						$_clickbankid=$_value;
					}
				}
				$_arrParent['settings']['funnels_jvzoodid']=$_jvzoodid;
				$_arrParent['settings']['funnels_clickbank']=$_clickbankid;
				$_arrParent['settings']['flg_funnels_widget']=1;
			}else{
				$_arrParent['settings']['flg_powered']=0;
			}
			$_squeeze->setEntered( $_arrParent )->generate();
			$_squeeze->getEntered( $_arrProject );
			if( isset( $_collectSettings['settings']['validation_realtime'] ) ){
				Project_Validations_Realtime::setValue( Project_Validations_Realtime::FUNNEL, $_arrProject['id'], $_collectSettings['settings']['validation_realtime'] );
			}
			$_url=$_squeeze->getGeneratedLink();
			if( isset( $_arrParent['settings']['type_page'] ) && $_arrParent['settings']['type_page'] == 2 ){
				// update Funnel Name
				$_mooptin=new Project_Mooptin();
				$_mooptin->withIds( $returnData['id'] )->onlyOne()->getList( $_update );
				$_update['name']='Funnel '.$_url;
				$_mooptin->setEntered( $_update )->set();
			}
			$this->objStore->toAction( 'manage' )->set( array(
				'generatedLink'=>$_url,
				'arrErrors'=> Core_Data_Errors::getInstance()->getErrors(),
				
			)/*+$_arrProject*/ );
			unset( $_POST );
			$this->location(array('action'=>'manage'));
		}
		if( isset( $_GET['id'] ) ){
			$_squeeze2=new Project_Squeeze();
			$_squeeze2->withIds( $_GET['id'] )->onlyOwner()->onlyOne()->getList( $this->out['arrData'] );
			if( isset( $this->out['arrData']['settings']['funnel_tpl'] ) ){
				$_squeeze3=new Project_Squeeze();
				$_squeeze3->withIds( $this->out['arrData']['settings']['funnel_tpl'] )->onlyOne()->getList( $_arrParent );
				$this->out['arrData']['tpl_settings']=$_arrParent['tpl_settings'];
				$this->out['arrTpl']=$_arrParent;
				if( isset( $this->out['arrData']['settings']['type_page'] ) && $this->out['arrData']['settings']['type_page'] == 2 ){
					$_mooptin=new Project_Mooptin();
					$_mooptin->withIds( $this->out['arrData']['settings']['mo_optin_id'] )->onlyOne()->getList( $this->out['arrMoOptin'] );
					$this->out['b64data']=base64_encode(json_encode($this->out['arrMoOptin']['settings']));
				}
			}
		}
		$company = new Project_Mooptin_Autoresponders();
		$company
			->onlyOwner()
			->getList( $this->out['arList'] );
		foreach( $this->out['arList'] as &$_listData ){
			$_listData['b64opt']=base64_encode(json_encode(
				(isset($_listData['settings']['options'])?$_listData['settings']['options']:array())
				+array('integration'=>$_listData['settings']['integration'][0])
				+array('newFields'=>((isset( $this->out['arrData']['settings']['form'][$_listData['id']] ))?$this->out['arrData']['settings']['form'][$_listData['id']]:array()))
			));
		}

		if( isset( $this->out['arrData']['tpl_settings']['affiliate_link'] ) && !empty( $this->out['arrData']['tpl_settings']['affiliate_link'] ) ){
			$_arrGet=$_arrReplace=array();
			$_model = new Project_Content_Settings();
			$_model->onlyOne()->withFlgDefault()->onlySource('102')->getContent( $_getRes );//в $getRes - данные из таблицы
			$this->out['arrCnt']=$_getRes;
			$_jvzoodid='';
			foreach( $_getRes['settings'] as $_name=>$_value ){
				if( strtolower( $_name ) == 'jvzoo' ){
					$_jvzoodid=$_value;
				}
				$_arrGet[]='%'.strtolower( $_name ).'id%';
				$_arrReplace[]=strtolower( $_value );
			}
			$this->out['arrData']['tpl_settings']['affiliate_link']=str_replace( $_arrGet, $_arrReplace, strtolower( $this->out['arrData']['tpl_settings']['affiliate_link'] ) );
		}
	}

	public function manage(){
		$this->objStore->getAndClear( $this->out );
		$_squeeze=new Project_Squeeze();
		if( isset( $_GET['duplicate'] ) && !empty( $_GET['duplicate'] ) ){
			$_squeeze->withIds( $_GET['duplicate'] )->onlyOwner()->onlyOne()->duplicate_squeeze();
			unset( $_GET );
			$this->location();
		}
		if( isset( $_GET['reset_stats'] ) && !empty( $_GET['reset_stats'] ) ){
			$_squeeze->withIds( $_GET['reset_stats'] )->resetStats();
			unset( $_GET );
			$this->location();
		}
		if( isset( $_GET['delete'] ) && !empty( $_GET['delete'] ) ){
			if( !$_squeeze->withIds( $_GET['delete'] )->onlyOwner()->onlyOne()->del_squeeze() ){
				$this->objStore->set(array( 'error'=>'delete' ));
			}else{
				$this->objStore->set(array( 'msg'=>'success' ));
			}
			unset( $_GET );
			$this->location();
		}
		if( isset( $_GET['download'] ) && !empty( $_GET['download'] ) ){
			if( !$_squeeze->withIds( $_GET['download'] )->onlyOwner()->onlyOne()->getList( $_arrData ) ){
				$this->objStore->set(array( 'error'=>'download' ));
			}else{
				$_oldPub=$_arrData['settings']['publishing_options'];
				$_arrData['settings']['publishing_options']='download';
				$_squeeze->setEntered( $_arrData )->generate();
				$_link=Zend_Registry::get('config')->path->absolute->user_temp.Core_Users::$info['id'].DIRECTORY_SEPARATOR.time().'.zip';
				copy(
					str_replace(
						Zend_Registry::get( 'config' )->domain->url.Zend_Registry::get('config')->path->html->user_temp.Core_Users::$info['id'].'/', 
						Zend_Registry::get('config')->path->absolute->user_temp.Core_Users::$info['id'].DIRECTORY_SEPARATOR,
						$_squeeze->getGeneratedLink() 
					),
					$_link
				);
				$_arrData['settings']['publishing_options']=$_oldPub;
				$_squeeze->setEntered( $_arrData )->generate(); // TODO 2016.07.31 добавить только сохранение с базу, без заливки или скачивания
				Core_Files::download( $_link );
				die;
			}
		}
		if( isset( $_GET['hosting'] ) && !empty( $_GET['hosting'] ) ){
			$_squeeze->withIds( $_GET['hosting'] )->onlyOwner()->onlyOne()->hosting_squeeze();
			unset( $_GET );
			$this->location();
		}
		if( isset( $_GET['hosting_nossl'] ) && !empty( $_GET['hosting_nossl'] ) ){
			$_squeeze->withIds( $_GET['hosting_nossl'] )->onlyOwner()->onlyOne()->hosting_squeeze('nossl');
			unset( $_GET );
			$this->location();
		}
		if( @$_GET['where'] !== false && $_GET['where']=='flg_template-1' ){
			$_squeeze->onlyTemplates();
		}
		if(isset($_GET['search']) && !empty($_GET['search'])){
			$_squeeze->withTags($_GET['search']);
		}
		if(isset($_GET['search_ids']) && !empty($_GET['search_ids']) ){
			$_squeeze->withIds( str_replace(' ', '', explode( ',', $_GET['search_ids'] ) ) );
		}
		if(isset($_GET['url']) && !empty($_GET['url']) && substr( $_GET['url'], 0, strlen('https://onlinenewsletters.net/') )=='https://onlinenewsletters.net/' ){
			$_squeeze->withUrl( $_GET['url'] );	
		}else{
			$_squeeze->withUrl( 'https://onlinenewsletters.net/' );
		}
		if(in_array(@$_GET['order'], array('c.visitors--dn','c.visitors--up','v.subscribers--up','v.subscribers--dn','cv.crt--up','cv.crt--dn'))){
			$_squeeze->withListFromTracker();
		}
		$_squeeze->flgFunnel(1);
		$_squeeze
			->withOrder( @$_GET['order'] )
			->onlyOwner()
			->withPaging( array(
				'page'=>@$_GET['page'], 
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			) )
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
		if(@$_GET['search_ids'] !== false){
			$this->out['arrFilter']['searchIds']=$_GET['search_ids'];
		}
		$this->out['arrFilter']['searchTags']=$_GET['search'];
		$this->out['arrFilter']['where']=$_GET['where'];
		$this->out['arrFilter']['url']=$_GET['url'];
		$this->out['flgHaveVisitors']=false;
		$_arrSqueezeIds=array();
		$_limit=2;
		foreach( $this->out['arrList'] as &$_item ){
			$_item['export_id']=Project_Widget_Mutator::encode( $_item['id'] );
			$_arrSqueezeIds[]= $_item['id'];
			if( !empty( $_item['url'] ) 
				&& !is_file( Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'backgrounds'.DIRECTORY_SEPARATOR.md5( $_item['url'] ).'.jpg' ) 
				&& !is_file( Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'screenshots'.DIRECTORY_SEPARATOR.md5( $_item['url'] ).'.jpg' )
			){
				if( $_limit == 0 ){
					continue;
				}else{
					$_limit--;
				}
				$_getReturn=json_decode( Project_Squeeze::getImageFromLink( $_item['url'] ), true );
				if( isset( $_getReturn['return'] ) && $_getReturn['return']!=0 ){
					$_limit++; // если ошибка не считаем эту картинку
				}
				rename( Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'backgrounds'.DIRECTORY_SEPARATOR.md5( $_item['url'] ).".jpg", Zend_Registry::get('config')->path->absolute->user_files.'squeeze/screenshots/'.md5( $_item['url'] ).".jpg" );
				$_item['image']=Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'screenshots'.DIRECTORY_SEPARATOR.md5( $_item['url'] ).".jpg";
			}elseif( is_file( Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'backgrounds'.DIRECTORY_SEPARATOR.md5( $_item['url'] ).'.jpg' ) ){
				rename( Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'backgrounds'.DIRECTORY_SEPARATOR.md5( $_item['url'] ).".jpg", Zend_Registry::get('config')->path->absolute->user_files.'squeeze/screenshots/'.md5( $_item['url'] ).".jpg" );
				$_item['image']=Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'screenshots'.DIRECTORY_SEPARATOR.md5( $_item['url'] ).".jpg";
			}elseif( is_file( Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'screenshots'.DIRECTORY_SEPARATOR.md5( $_item['url'] ).'.jpg' ) ){
				$_item['image']=Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'screenshots'.DIRECTORY_SEPARATOR.md5( $_item['url'] ).".jpg";
			}
		}
		try {
			Core_Sql::setConnectToServer( 'syndication.qjmpz.com' );
			if(isset($_POST['company_id']) && isset($_POST['split'])){
				$_splittestlink=new Project_Widget_Adapter_Squeeze_Split_Link();
				$_splittestlink->setLink2($_POST['split'], explode(',', $_POST['company_id']));
				$this->location();
			}
			$splittest=new Project_Widget_Adapter_Squeeze_Split ();
			$splittest->onlyOwner()->getList( $this->out['arrSplit'] );
			Core_Sql::renewalConnectFromCashe();
		} catch(Exception $e){
			Core_Sql::renewalConnectFromCashe();
		}
	}

	public function popup_templates(){
		$_squeeze=new Project_Squeeze();
		$_t2g=new Project_Squeeze_Templates();
		$_arrGroupsids=array();
		$_group=new Core_Acs_Groups();
		if( Core_Acs::haveAccess( array( 'LPB Admins' ) ) ){
			$_group->getList( $_arrCurrentGroups );
		}else{
			$_group->bySysName( Core_Users::$info['groups'] )->getList( $_arrCurrentGroups );
		}
		foreach( $_arrCurrentGroups as $_i ){
			$this->out['arrGroupsids'][$_i['id']]=$_i['title'];
		}
		if( Core_Acs::haveAccess( array( 'LPB Admins' ) ) ){
			$_t2g->getList( $_selectedTemplatesIds );
		}else{
			$_t2g->withGroupIds( array_keys( $this->out['arrGroupsids'] ) )->getList( $_selectedTemplatesIds );
		}
		if( !empty( $_selectedTemplatesIds ) ){
			$_squeezeT2G=array();
			foreach( $_selectedTemplatesIds as $_t2g_ids ){
				if( !isset( $_squeezeT2G[$_t2g_ids['squeeze_id']] ) ){
					$_squeezeT2G[$_t2g_ids['squeeze_id']]=array();
				}
				$_squeezeT2G[$_t2g_ids['squeeze_id']][]=$_t2g_ids['group_id'];
			}
			$_squeeze->withIds( array_keys( $_squeezeT2G ) )->onlyTemplates()->getList( $_arrTemplates );
			$this->out['arrTemplates']=array();
			foreach( $_arrTemplates as $_squeezeData ){
				foreach( $_squeezeT2G[$_squeezeData['id']] as $_groupId ){
					if( !isset( $this->out['arrTemplates'][ $_groupId ] ) ){
						$this->out['arrTemplates'][$_groupId]=array( 'name'=>$this->out['arrGroupsids'][$_groupId], 'node'=>array() );
					}
					$this->out['arrTemplates'][$_groupId]['node'][]=$_squeezeData;
				}
			}
		}else{
			$this->out['arrTemplates']=null;
		}
		$this->out['templates_link']=Zend_Registry::get( 'config' )->domain->url.Zend_Registry::get('config')->path->html->user_files.'squeeze/templates/';
	}

	public function leads(){
		$_squeeze=new Project_Squeeze();
		$_squeeze->flgFunnel(1)
			->onlyOwner()
			->getList( $_arrAF );
		$_leadIds=array();
		foreach( array_filter( $_arrAF ) as $_af ){
			$_leadIds[$_af['settings']['mo_optin_id']]=$_af['settings']['mo_optin_id'];
		}
		$_subscribers=new Project_Squeeze_Subscribers(Core_Users::$info['id']);
		if(!empty($_GET['action']) && $_GET['action']='delete'){
			$this->objStore->set( array( 'delete'=>$_subscribers->withIds($_GET['id'])->del() ) );
			$this->location();
		}
		if( !empty( $_COOKIE['filter'] ) ) {
			$this->out['sFilter'] = json_decode( $_COOKIE['filter'], true );
		} 
		if( !empty( $_GET['arrFilter']['lead'] ) ){
			$_subscribers->withSqueezeId( $_GET['arrFilter']['lead'] );
		}else{
			$_subscribers->withSqueezeId( $_leadIds );
		}
		if( !empty( $_GET['arrFilter']['tags'] ) ){
			$_subscribers->withTags( $_GET['arrFilter']['tags'] );
		}
		$_subscribers
			->onlyOwner()
			->withPaging( array( 'url'=>$_GET ) )
			->withOrder( @$_GET['order'] )
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
		$_arIds=array();
		foreach( $this->out['arrList'] as &$cp ){
			foreach( $cp['squeeze_events'] as &$_moEvents ){
				if( isset( $_moEvents['lead_id'] ) ){
					$cp['mo_ids'][$_moEvents['added']]=$_moEvents['lead_id'];
					foreach( $_moEvents as $_paramName=>&$_paramData ){
						$_addArray=array();$_mo2arr='';
						if( strpos( $_paramName, 'mo2ar_message_' ) === 0 ){
							$_mo2arr=substr( $_paramName, strlen( 'mo2ar_message_' ) ).'_'.$_moEvents['added'];
							$_addArray['message']=unserialize( base64_decode( $_paramData ) );
							$_addArray['added']=$_moEvents['added'];
						}
						if( strpos( $_paramName, 'mo2ar_ansver_' ) === 0 ){
							$_mo2arr=substr( $_paramName, strlen( 'mo2ar_ansver_' ) ).'_'.$_moEvents['added'];
							$_addArray['ansver']=base64_decode( $_paramData );
						}
						if( strpos( $_paramName, 'mo2ar_request_' ) === 0 ){
							$_mo2arr=substr( $_paramName, strlen( 'mo2ar_request_' ) ).'_'.$_moEvents['added'];
							$_request=unserialize( base64_decode( $_paramData ) );
							if( isset( $_request['_'] ) ){
								$_addArray['added']=round( $_request['_']/1000 );
							}
						}
						if( strpos( $_paramName, 'mo2ar_hidden_' ) === 0 ){
							$_mo2arr=substr( $_paramName, strlen( 'mo2ar_hidden_' ) ).'_'.$_moEvents['added'];
							foreach( unserialize( base64_decode( $_paramData ) ) as $_name=>$_value ){
								$_addArray['message']=htmlspecialchars( $_name ).':'.htmlspecialchars( $_value );
								$_addArray['added']=$_moEvents['added'];
							}
						}
						if( !empty( $_addArray ) && !empty( $_mo2arr ) ){
							$_mo2arArr=explode( '_', $_mo2arr );
							if( $_mo2arArr[0] == $_moEvents['lead_id'] ){
								$_addArray['arId']=$arIds[$_mo2arArr[1]]=$_mo2arArr[1];
							}
							if( isset( $cp['messages'][$_mo2arr] ) ){
								$cp['messages'][$_mo2arr]=$_addArray+$cp['messages'][$_mo2arr];
							}else{
								$cp['messages'][$_mo2arr]=$_addArray;
							}
						}
					}
				}
				if( isset( $_moEvents['message'] ) ){
					$cp['requests'][$_moEvents['added']]=$_moEvents['message'];
				}
			}
		}
		$company=new Project_Mooptin();
		$company->onlyOwner()->getList($arrData);
		foreach( $arrData as $mocp ){
			$this->out['mo_campaigns'][$mocp['id']]=array('name'=>$mocp['name'],'tag'=>$mocp['tags']);
		}
		$this->out['mo_campaigns']=array_filter( $this->out['mo_campaigns'] );
		$this->out['a8rData']=array();
		if( !empty( $arIds ) ){
			$a8r=new Project_Mooptin_Autoresponders();
			$a8r->onlyOwner()->withIds(array_keys($arIds))->getList($arrA8r);
			foreach( $arrA8r as $_a8r ){
				$this->out['a8rData'][$_a8r['id']]=$_a8r['name'];
			}
		}

	}

	public function ajax(){
		$this->out_js=array();
		if( isset( $_REQUEST['groups'] ) && !empty( $_REQUEST['groups'] ) ){
			header('Content-type: text/html');
			header('Access-Control-Allow-Origin: *');
			$_squeeze=new Project_Squeeze();
			$_t2g=new Project_Squeeze_Templates();
			$_t2g->withGroupIds( @explode( ',', $_REQUEST['groups'] ) )->getList( $_selectedTemplatesIds );
			if( !empty( $_selectedTemplatesIds ) ){
				$_squeezeT2G=array();
				foreach( $_selectedTemplatesIds as $_t2g_ids ){
					if( !isset( $_squeezeT2G[$_t2g_ids['squeeze_id']] ) ){
						$_squeezeT2G[$_t2g_ids['squeeze_id']]=array();
					}
					$_squeezeT2G[$_t2g_ids['squeeze_id']][]=$_t2g_ids['group_id'];
				}
				$_squeeze->withIds( array_keys( $_squeezeT2G ) )->onlyTemplates()->getList( $_arrTemplates );
				$this->out['arrTemplates']=array();
				foreach( $_arrTemplates as $_squeezeData ){
					foreach( $_squeezeT2G[$_squeezeData['id']] as $_groupId ){
						if( !isset( $this->out['arrTemplates'][ $_groupId ] ) ){
							$this->out['arrTemplates'][$_groupId]=array( 'name'=>$this->out['arrGroupsids'][$_groupId], 'node'=>array() );
						}
						$this->out['arrTemplates'][$_groupId]['node'][]=$_squeezeData;
					}
				}
			}else{
				$this->out['arrTemplates']=null;
			}
			$this->out['templates_link']=Zend_Registry::get( 'config' )->domain->url.Zend_Registry::get('config')->path->html->user_files.'squeeze/templates/';
		}
		if( isset( $_POST['template_id'] ) && !empty( $_POST['template_id'] ) ){
			$_squeeze=new Project_Squeeze();
			$_squeeze->withIds( $_POST['template_id'] )->onlyOne()->getList( $this->out_js );
			
			$_model = new Project_Content_Settings();
			$_model->onlyOne()->withFlgDefault()->onlySource('102')->getContent( $_getRes );
			$_arrGet=$_arrReplace=array();
			$_jvzoodid='';
			foreach( $_getRes['settings'] as $_name=>$_value ){
				if( strtolower( $_name ) == 'jvzoo' ){
					$_jvzoodid=$_value;
				}
				$_arrGet[]='%'.strtolower( $_name ).'id%';
				$_arrReplace[]=strtolower( $_value );
			}
			$this->out_js['tpl_settings']['affiliate_link']=str_replace( $_arrGet, $_arrReplace, strtolower( $this->out_js['tpl_settings']['affiliate_link'] ) );
			ob_clean();
			echo json_encode( $this->out_js );
			exit();
		}
		if( isset( $_POST['export'] ) ){
			if( $_POST['url']['page'] == 1 && file_exists( Zend_Registry::get( 'config' )->path->relative->user_temp . "contact-list" . date( 'Y-m-d' ) . "." . Core_Users::$info['id'] . ".csv" ) ){
				unlink( Zend_Registry::get( 'config' )->path->relative->user_temp . "contact-list" . date( 'Y-m-d' ) . "." . Core_Users::$info['id'] . ".csv" );
			}
			$_subscribers=new Project_Squeeze_Subscribers(Core_Users::$info['id']);
			$_subscribers
				->onlyOwner()
				->withPaging( array( 'url'=>$_POST['url'] ) )
				->getList( $arrList );

			foreach ($arrList as $sub) {
				file_put_contents( Zend_Registry::get( 'config' )->path->relative->user_temp . "contact-list" . date( 'Y-m-d' ) . "." . Core_Users::$info['id'] . ".csv", $sub['email'] . ';' . $sub['ip'] . ';' . PHP_EOL, FILE_APPEND );
			}
			$this->out_js = Zend_Registry::get( 'config' )->path->html->user_temp . "contact-list" . date( 'Y-m-d' ) . "." . Core_Users::$info['id'] . ".csv";
		}
	}
}
?>