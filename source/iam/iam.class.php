<?php
class iam extends Core_Module {

	public final function set_cfg(){
		$this->inst_script=array(
			'module'=>array(
				'title'=>'Instant Affiliate Marketer',
			),
			'actions'=>array(
				array( 'action'=>'edit_user', 'title'=>'Add Customer' ),
				array( 'action'=>'manage_users', 'title'=>'Manage Customers' ),
				array( 'action'=>'manage_templates', 'title'=>'Manage Templates' ),
				array( 'action'=>'manage_site', 'title'=>'Check Websites' ),
				array( 'action'=>'manage_sites_pages', 'title'=>'All Sites Pages' ),
				array( 'action'=>'create_form', 'title'=>'Create Form' ),
				array( 'action'=>'manage_forms', 'title'=>'Manage Forms' ),
				
				array( 'action'=>'aweber', 'title'=>'AWeber' ),
				
				array( 'action'=>'registration', 'title'=>'Registration & Activation', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'remove_user', 'title'=>'Remove Customer', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				
				array( 'action'=>'create_site', 'title'=>'Create IAM Site' ),
				array( 'action'=>'manage_sites', 'title'=>'Manage IAM Sites' ),
				
				
			),
		);
	}

	public function aweber(){
		if( !isset( $_GET['cbid'] ) ){
			return false;
		}
		try {
			set_time_limit(0);
			require_once 'library/AWeberAPI/aweber.php';
			/*
			$code='AzwGFJtzXoCbA6btAt0Psdac|9Yvm4F1x4lTXAaWNPnSPIeZd3Ahupd3J9fCO0DWD|AqyASFquCEfShRGJi62jaX56|tQU2EIupJ5gxPh1rc3bEba1x1LY9qUczGiPnv5oD|l5pph2|';
			$credentials = AWeberAPI::getDataFromAweberID( $code );
			var_export( $credentials );exit;
			*/
			$consumerKey='AzwGFJtzXoCbA6btAt0Psdac';
			$consumerSecret='9Yvm4F1x4lTXAaWNPnSPIeZd3Ahupd3J9fCO0DWD';
			$accessKey='Agb1jGfAokz4XtRQkt1MJCUX';
			$accessSecret='jpMsofO4xNDgMlrBPVgdVXGifnWVKRjUzvgryE44';
			$aweber=new AWeberAPI( $consumerKey, $consumerSecret);
			$account=$aweber->getAccount($accessKey, $accessSecret);
			$lists=$account->lists->find(array());
			$_lists=array('0'=>array('name'=>'All Lists'));
			foreach( $lists->data['entries'] as $list ){
				$_lists[$list['id']]=array(
					'name'=>$list['name']
				);
			}
			$_allCount=count( $lists );
			for( $i=100; isset( $lists->data['next_collection_link'] ) && $i<$_allCount; $i+=100 ){
				$lists=$account->lists->find( array('ws.start'=>$i) );
				foreach( $lists->data['entries'] as $list ){
					$_lists[$list['id']]=array(
						'name'=>$list['name']
					);
				}
			}
			$params = array('status' =>'subscribed', 'custom_fields'=>array('cbid'=>$_GET['cbid']) );
			$found_subscribers=$account->findSubscribers($params);
			$_arrDataS8r=$found_subscribers->data['entries'];
			$_allCount=count( $found_subscribers );
			for( $i=100; isset( $found_subscribers->data['next_collection_link'] ) && $i<$_allCount; $i+=100 ){
				$params['ws.start']=$i;
				$found_subscribers=$account->findSubscribers($params);
				foreach( $found_subscribers->data['entries'] as $_dataS8r ){
					$_arrDataS8r[]=$_dataS8r;
				}
			}
			$_arrS8r=array();
			foreach($_arrDataS8r as $subscriber) {
				$matches=array();
				preg_match( '/https(.*)lists\/(.*)\/subscribers(.*)/' , $subscriber['self_link'], $matches );
				if( !isset( $_arrS8r[@$_lists[@$matches[2]]['name']] ) ){
					$_arrS8r[@$_lists[@$matches[2]]['name']]=array();
				}
				$_arrS8r[@$_lists[@$matches[2]]['name']][$subscriber['email']]=1;
			}
			if( count( $_arrS8r ) == 0 ){
				$this->out['error']='Nothing found';
				$this->out['cbid']=$_GET['cbid'];
			}else{
				ob_end_clean();
				header("Content-Disposition: attachment; filename=cbid_".$_GET['cbid'].".txt\r\n");  
				header("Content-Type: application/octet-stream\r\n");  
				header("Content-Transfer-Encoding: binary\r\n");  
				foreach( $_arrS8r as $_listName=>$values ){
					echo "\t".$_listName."\n\r";
					foreach( $values as $_email=>$tmp ){
						echo $_email."\n\r";
					}
					echo "\n\r";
				}
				exit;
			}
		}catch(AWeberAPIException $e) {
			$this->out['error']=$e->message;
		}
	}

	public function manage_sites(){
		$_model=new Project_Iam_Manager();
		if( !empty( $_GET['delete'] ) ){
			if( $_model->withIds( $_GET['delete'] )->del() ){
				$this->objStore->toAction( 'manage_sites' )->set( array( 'msg'=>'deleted' ) );
				$this->location( array( 'action' => 'manage_sites' ) );
			}
		}
		if( !empty( $_GET['download'] ) ){
			if( $_model->withIds( $_GET['download'] )->onlyOne()->getList( $_arrGetData ) ){
				$_POST['arrOpt']['id']=$_arrGetData['id'];
				$_POST['arrData']=$_arrGetData['settings'];
				$this->create_site();
			}
		}
		$_model
		//	->onlyOwner()
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] );
	}

	public function create_site(){
		if( !empty( $_POST ) ){
			$_data=$_POST['arrData'];
			$_sourceName='source.zip';
			if( $_POST['arrData']['type']=='master' ){
				$_sourceName='master.zip';
			}
			// заливаем файлы с шаблоном в каталог подготовки
			
			
			$_dirSource=Zend_Registry::get('config')->path->absolute->user_files.'iam'.DIRECTORY_SEPARATOR;
			$_dirPrepare='Project_IAM@generate';
			if ( !Zend_Registry::get( 'objUser' )->prepareTmpDir( $_dirPrepare ) ) {
				echo Core_Data_Errors::getInstance()->setError('Can\'t create dir '.$_dirPrepare);
			}
			if( !copy($_dirSource.$_sourceName,$_dirPrepare.'source.zip') ){
				echo Core_Data_Errors::getInstance()->setError('Cant copy source');
			}
			Core_Zip::getInstance()->setDir( $_dirPrepare.'source'.DIRECTORY_SEPARATOR )->extractZip( $_dirPrepare.'source.zip');
			if( !empty( $_FILES ) && isset($_FILES['images']['tmp_name']) ){
				$_data['file_images_name']=md5( $_FILES['images']['tmp_name'] ).'.zip';
				if( !move_uploaded_file(  $_FILES['images']['tmp_name'], $_dirSource.'images'.$_data['file_images_name'] ) ){
					p( 'Cant copy tpm file to '.$_dirSource.'images'.$_data['file_images_name'] );
				}
			}
			if( isset( $_data['file_images_name'] ) && !empty( $_data['file_images_name'] ) ){
				if( !is_file( $_dirSource.'images'.$_data['file_images_name'] ) ){
					p( 'No file in '.$_dirSource.'images'.$_data['file_images_name'] );
				}else{
					Core_Zip::getInstance()->setDir( $_dirPrepare.'source'.DIRECTORY_SEPARATOR.'images'.DIRECTORY_SEPARATOR )->extractZip( $_dirSource.'images'.$_data['file_images_name'] );
				}
			}
			unlink($_dirPrepare.'source.zip');
			// собираем нужные данные воедино
			$_arrReplaceData=$_arrSearchData=array();
			// ----------------------------------------- menu
			$_menuTitles='';
			$_menuLinksStr='$menu_links=array( ';
			foreach( $_data['menu_title'] as $_id=>$_text ){
				$_arrSearchData[]='{*menu_title_'.$_id.'*}';
				$_arrReplaceData[]=$_text;
				$_arrSearchData[]='{*menu_title_tag_'.$_id.'*}';
				$_arrReplaceData[]=str_replace(' ','_', strtolower($_text));
				$_menuTitles.='
<li><a href="#">{*menu_title_'.$_id.'*}</a>
<ul>
	<?php foreach ($menu_links["{*menu_title_tag_'.$_id.'*}"] as $link) { ?>
	<li><a href="<?php echo $posts[$link]["url"];?>"><?php echo $posts[$link]["title"];?></a></li>	
	<?php } ?>
</ul>
</li>';
				$_menuLinksStr.='"{*menu_title_tag_'.$_id.'*}" => array('.implode( ',', $_data['menu_articles'][$_id] ).'),';
			}
			$_menuLinksStr.=');';
			//---------------------------------------- tags
			foreach( $_data['tags'] as $_tagId=>$_tagName ){
				$_arrSearchData[]='{*article_tag_'.$_tagId.'*}';
				$_arrReplaceData[]=$_tagName;
				$_arrSearchData[]='{*article_tag_tolink _'.$_tagId.'*}';
				$_arrReplaceData[]=strtolower(trim(preg_replace('~[^0-9a-z]+~i', '-', html_entity_decode(preg_replace('~&([a-z]{1,2})(?:acute|cedil|circ|grave|lig|orn|ring|slash|th|tilde|uml);~i', '$1', htmlentities($_tagName, ENT_QUOTES, 'UTF-8')), ENT_QUOTES, 'UTF-8')), '-'));
			}
			//----------------------------------articles
			$_articleBox='$posts = array(';
			$_articlePageLetters="ABCDEFGHIJKLMNOPQRSTUVWXYZ";
			foreach( $_data['article_title'] as $_id=>$_title ){
				$_arrSearchData[]='{*article_title_'.$_id.'*}';
				$_arrReplaceData[]=$_title;
				
				$_arrTitle=explode( ' ', $_title );
				$_arrTitleChunk=array_chunk( $_arrTitle, ceil( count($_arrTitle)/2 ) );
				foreach( $_arrTitleChunk as &$_titleChunk ){
					$_titleChunk=implode(' ',$_titleChunk);
				}
				$_arrSearchData[]='{*article_title_d2_'.$_id.'*}';
				$_arrReplaceData[]=implode( '<br/>', $_arrTitleChunk );
				
				$_arrSearchData[]='{*article_short_description_'.$_id.'*}';
				$_arrReplaceData[]=str_replace( array('"','“', '”', '’' ), array('\\"','\\"', '\\"', "'"), $_data['article_summary'][$_id] );
				
				$_articleLink=strtolower(trim(preg_replace('~[^0-9a-z]+~i', '-', html_entity_decode(preg_replace('~&([a-z]{1,2})(?:acute|cedil|circ|grave|lig|orn|ring|slash|th|tilde|uml);~i', '$1', htmlentities($_title, ENT_QUOTES, 'UTF-8')), ENT_QUOTES, 'UTF-8')), '-'));;
				$_arrSearchData[]='{*article_title_tolink_'.$_id.'*}';
				$_arrReplaceData[]=$_articleLink;
				
				$_arrSearchData[]='{*article_vendorid_'.$_id.'*}';
				$_arrReplaceData[]=$_data['article_vendorid'][$_id];
				
				$_content=str_replace( array('“', '”', '’' ), array('"', '"', "'"), $_data['article_text'][$_id] );
				
				Core_Files::setContent( $_content, $_dirPrepare.'source'.DIRECTORY_SEPARATOR.'templates'.DIRECTORY_SEPARATOR.$_articleLink.'.html' ) ;
				
				$_idLetter=$_articlePageLetters[$_id];
				$_articleBox.='
'.$_id.' => array(
	"title" => "{*article_title_'.$_id.'*}",
	"short_description" => "{*article_short_description_'.$_id.'*}",
	"url" => "{*article_title_tolink_'.$_id.'*}.html",
	"tags" => array(
';
				foreach( $_data['article_tags'][$_id] as $_tagId ){
					$_articleBox.='		array("{*article_tag_'.$_tagId.'*}", "{*article_tag_tolink _'.$_tagId.'*}"),
';
				}
$_articleBox.='	),
	"thumb" => array(
		"src" => "images/products/product'.$_idLetter.'-2.jpg",
		"title" => "{*article_title_'.$_id.'*}"';
if( $_id == 3 ){
$_articleBox.=',
		array(
			array(
				"src" => "images/products/product'.$_idLetter.'-3.jpg",
				"title" => "{*article_title_'.$_id.'*}",
			),
			array(
				"src" => "images/products/product'.$_idLetter.'-4.jpg",
				"title" => "{*article_title_'.$_id.'*}",
			),
			array(
				"src" => "images/products/product'.$_idLetter.'-5.jpg",
				"title" => "{*article_title_'.$_id.'*}",
			)
		)';
}
$_articleBox.='
	),
	"inner_image" => array(
		"src" => "images/products/product'.$_idLetter.'.jpg",
		"title" => "{*article_title_'.$_id.'*}"
	),
	"sidebar_image" => array(
		"src" => "images/products/sidebar/product'.$_idLetter.'.jpg",
		"title" => "{*article_title_'.$_id.'*}"
	),
	"like_image" => array(
		"src" => "images/products/product'.$_idLetter.'-like.jpg",
		"title" => "{*article_title_'.$_id.'*}"
	),
	"thumb_link" => clickbankReplacer( "http://ethiccash.{*article_vendorid_'.$_id.'*}.hop.clickbank.net" ),
	"content" => clickbankReplacer( file_get_contents("templates/{*article_title_tolink_'.$_id.'*}.html") ),
),
';
			}
			$_articleBox.=');';
			$_arrTitle=explode( ' ', $_data['title'] );
			$_arrTitleHeaderChunk=array_chunk( $_arrTitle, 2 );
			$_firstLetter=$_arrTitleHeaderChunk[0][0][0];
			$_arrTitleHeaderChunk[0][0]=substr( $_arrTitleHeaderChunk[0][0], 1 );
			$_arrTitleHeaderChunk[0][0]='<em>'.$_firstLetter.'</em>&nbsp;'.$_arrTitleHeaderChunk[0][0];
			foreach( $_arrTitleHeaderChunk as &$_titleChunk ){
				$_titleChunk=implode(' ',$_titleChunk);
			}
			$_arrTitleHeaderChunk=implode( '<br />&nbsp;&nbsp;', $_arrTitleHeaderChunk );
			$_arrTitleSingleHeaderChunk=implode( ' ', $_arrTitleHeaderChunk );
			
			$_arrSearchData[]='{*author_text*}';
			$_arrReplaceData[]=$_data['author_text'];
			$_arrSearchData[]='{*site_url*}';
			$_arrReplaceData[]=$_data['site_url'];
			$_arrSearchData[]='{*title*}';
			$_arrReplaceData[]=$_data['title'];
			$_arrSearchData[]='{*keyword*}';
			$_arrReplaceData[]=$_data['keyword'];
			$_arrSearchData[]='{*title_for_header*}';
			$_arrReplaceData[]=$_arrTitleHeaderChunk;
			$_arrSearchData[]='{*title_for_single_header*}';
			$_arrReplaceData[]=$$_arrTitleSingleHeaderChunk;
			$_arrSearchData[]='{*awlist*}';
			$_arrReplaceData[]=$_data['awlist'];
			$_arrSearchData[]='{*form_title*}';
			$_arrReplaceData[]=$_data['form_title'];
			$_arrSearchData[]='{*form_text*}';
			$_arrReplaceData[]=$_data['form_text'];
			$_arrSearchData[]='{*header_teaser*}';
			$_arrReplaceData[]=$_data['header_teaser'];
			$_arrSearchData[]='{*custom_header*}';
			$_arrReplaceData[]=$_data['custom_header'];
			$_arrSearchData[]='{*custom_footer*}';
			$_arrReplaceData[]=$_data['custom_footer'];
			$_arrSearchData[]='{*after_autor*}';
			$_arrReplaceData[]='<div class="widget newsletter-widget">'.$_data['after_autor'].'</div>';
			$_arrSearchData[]='{*on_product_bottom*}';
			$_arrReplaceData[]=$_data['on_product_bottom'];

			// теперь можно раотать с файлами
			$arrFiles=array();
			Core_Files::dirScan( $_arrFilesList, $_dirPrepare.'source' );
			foreach( $_arrFilesList[$_dirPrepare.'source'] as $_fileName ){
				Core_Files::getContent($arrFiles[$_fileName],$_dirPrepare.'source'.DIRECTORY_SEPARATOR.$_fileName);
				$arrFiles[$_fileName]=str_replace(
					array(
						'{*menu_titles*}',
						'{*menu_links*}',
						'{*post_array*}',
					),
					array(
						$_menuTitles,
						$_menuLinksStr,
						$_articleBox
					),
					$arrFiles[$_fileName]
				);
				$arrFiles[$_fileName]=str_replace($_arrSearchData,$_arrReplaceData,$arrFiles[$_fileName]);
			}
			// все изменеия заливаем вместе
			Core_Files::setContentMass($arrFiles,$_dirPrepare.'source'.DIRECTORY_SEPARATOR);
			
			
			$_entered=array();
			if( isset( $_POST['arrOpt']['id'] ) && !empty( $_POST['arrOpt']['id'] ) ){
				$_entered['id']=(int)$_POST['arrOpt']['id'];
			}
			$_entered['site_url']=$_data['site_url'];
			$_entered['settings']=$_data;
			$_class=new Project_Iam_Manager();
			$_class->setEntered( $_entered )->set();
			$_class->getEntered( $_entered );
			
			ob_clean();
			// собственно архивируем и выдаем пользователю
			if( !isset( $_data['action'] ) || $_data['action'] == '' ){
				header( 'Location: ?id='.$_entered['id'] );
			}elseif( isset( $_data['action'] ) && $_data['action'] == 'download' ){
				Core_Zip::getInstance()->open( $_dirPrepare.str_replace( array('http://', 'https://', '/', '.'), array('','','','_'), $_data['site_url'] ).'.zip', ZipArchive::CREATE );
				Core_Zip::getInstance()->addDirAndClose( $_dirPrepare.'source'.DIRECTORY_SEPARATOR );
				Core_Files::download( $_dirPrepare.str_replace( array('http://', 'https://', '/', '.'), array('','','','_'), $_data['site_url'] ).'.zip' );
				die();
			}elseif( isset( $_data['action'] ) && $_data['action'] == 'upload' ){
				Core_Zip::getInstance()->open( $_dirPrepare.str_replace( array('http://', 'https://', '/', '.'), array('','','','_'), $_data['site_url'] ).'.zip', ZipArchive::CREATE );
				Core_Zip::getInstance()->addDirAndClose( $_dirPrepare.'source'.DIRECTORY_SEPARATOR );
				$_obj=new Project_Iam_Sites();
				$_obj->onlyActive()->getList( $arrSites );
				foreach( $arrSites as $_site ){
					if( strtolower( str_replace( array('http://', 'https://', '/', '.'), array('','','','_'), $_data['site_url'] ) ) != strtolower( str_replace( array('http://', 'https://', '/', '.'), array('','','','_'), $_site['url'] ) ) ){
						continue;
					}
					if( $_site['flg_type'] == Project_Sites::NCSB ){
						$_driver=new Project_Sites_Adapter_Ncsb();
						$_newUserId=Core_Sql::getCell( 'SELECT user_id FROM '.$_driver->table.' WHERE id='.Core_Sql::fixInjection( $_site['id'] ) );
						if( !empty( $_newUserId ) ){
							$_admin=false;
							if( isset( Core_Users::$info['id'] ) && !empty( Core_Users::$info['id'] ) ){
								$_admin=Core_Users::$info['id'];
							}
							Core_Users::getInstance()->setById( $_newUserId );
						}
						$_model=new Project_Sites( $_site['flg_type'] );
						$_model->getSite( $_arr, $_site['id'] );
						if( !empty( $_newUserId ) && !empty( $_admin ) ){
							Core_Users::getInstance()->setById( $_admin );
						}
						$arrSite=$_arr['arrNcsb'];
					}elseif( $_site['flg_type'] == Project_Sites::NVSB ){
						$_driver=new Project_Sites_Adapter_Nvsb();
						$_newUserId=Core_Sql::getCell( 'SELECT user_id FROM '.$_driver->table.' WHERE id='.Core_Sql::fixInjection( $_site['id'] ) );
						if( !empty( $_newUserId ) ){
							$_admin=Core_Users::$info['id'];
							Core_Users::getInstance()->setById( $_newUserId );
						}
						$_model=new Project_Sites( $_site['flg_type'] );
						$_model->getSite( $_arr, $_site['id'] );
						if( !empty( $_newUserId ) ){
							Core_Users::getInstance()->setById( $_admin );
						}
						$arrSite=$_arr['arrNvsb'];
					}elseif( $_site['flg_type'] == Project_Sites::BF ){
						header( 'Location: ?id='.@$_GET['id'] );
					}
					$_placement=new Project_Placement();
					$_placement->withIds( $arrSite['placement_id'] )->onlyOne()->getList( $arrSite['domen'] );
					$_transport=new Project_Placement_Transport();
					if( !$_transport
						->setInfo( $arrSite )
						->setSourceDir( $_dirPrepare.str_replace( array('http://', 'https://', '/', '.'), array('','','','_'), $_data['site_url'] ).'.zip' )
						->placeAndBreakConnect() ){
						Core_Data_Errors::getInstance()->setError('Cant upload source');
					}
					header( 'Location: ?id='.$_entered['id'].'&saved' );
					break;
				}
				header( 'Location: ?id='.$_entered['id'].'&nourl' );
			}
			header( 'Location: ?id='.@$_GET['id'] );
		}
		if( isset( $_GET['id'] ) ){
			$_class=new Project_Iam_Manager();
			$_class->withIds( $_GET['id'] )->onlyOne()->getList( $this->out['arrOpt'] );
			$this->out['arrData']=$this->out['arrOpt']['settings'];
			unset($this->out['arrOpt']['settings']);
		}
	}

	public function registration(){
		Core_Errors::off();
		$_model=new Project_Iam_Users();
		if( isset($_GET['v']) && !empty( $_GET['v'] ) && isset($_GET['u']) && !empty( $_GET['u'] ) ){
			// activatiion
			$_userId=base64_decode( urldecode( $_GET['u'] ) );
			$_model->withIds( $_userId )->onlyOne()->getList( $_checkUser );
			if( !empty( $_checkUser ) 
				&& $_checkUser['email_verify']==$_GET['v'] 
				&& $_model->withIds( $_userId )->activate()
			){
				$this->out['flg_activate']=true;
			}else{
				$_model->getErrors( $this->out['error'] );
			}
		}
		if( isset($_REQUEST['check']) && isset($_REQUEST['email']) && !empty( $_REQUEST['email'] ) ){
			$_model
				->onlyOne()
				->withLinks()
				->withEmail( $_REQUEST['email'] )
				->getList( $_arrUser );
			$_forms=new Project_Iam_Forms();
			$_forms->getList( $_arrForms );
			$_arrPackagesNames=array();
			foreach( $_arrUser['forms'] as $_arrPackageData ){
				foreach( $_arrForms as $_formData ){
					if( $_arrPackageData == $_formData['id'] ){
						$_arrPackagesNames[$_formData['id']]=$_formData['name'];
					}
				}
			}
			if( !empty( $_arrPackagesNames ) ){
				$_return=implode( ', ', $_arrPackagesNames )." package".(count($_arrPackagesNames)>1?'s':'').'.';
			}else{
				$_return='No website activated so far.';
			}
			if( !isset( $_REQUEST['text'] ) ){
				header('Content-Type: application/javascript');
				echo "document.write('".$_return."');";
			}else{
				header('Content-Type: text/plain');
				echo $_return;
			}
			exit;
		}
		if( isset($_REQUEST['code']) && !empty( $_REQUEST['code'] ) 
			&& isset($_REQUEST['cbid']) && !empty( $_REQUEST['cbid'] ) 
			&& isset($_REQUEST['email']) && !empty( $_REQUEST['email'] )
		){
			// registration
			$_forms=new Project_Iam_Forms();
			$_forms->withSecretId( $_REQUEST['code'] )->onlyOne()->getList( $_arrForm );
			if( $_arrForm['activations_limit'] > 0 
				&& $_arrForm['activations_limit'] >= $_model->getFormActivationsCount( $_arrForm['id'] )
			){
				$this->out['flg_registered']=false;
			}
			if( !empty( $_arrForm ) && $_model
				->setEntered(array(
					'form_id'=>@$_arrForm['id'],
					'clickbank_id'=>$_REQUEST['cbid'],
					'email'=>$_REQUEST['email'],
					'client_ip'=>$this->getRealIP(),
					'sid'=>@$_REQUEST['sid'],
					'flg_active'=>1
				))
				->set()
			){
				$_model->getEntered( $_arrUser );
				$_iam=new Project_Iam();
				if( !empty( $_arrUser['id'] ) 
					&& $_iam->addLinks( @$_arrForm['sites_settings'], array( $_arrUser['id'] ) )
				){
					$this->out['flg_activate']=true;
					// -------------------------------
					$_link='https://zapier.com/hooks/catch/3xcbbl,37mrfq/?email='.@urlencode( $_REQUEST['email'] ).'&name='.@urlencode( @$_arrForm['name'] ).( isset( $_REQUEST['sid'] )?'&sid='.$_REQUEST['sid']:'' ) ;
					$ch=curl_init();
					curl_setopt($ch, CURLOPT_URL, $_link);
					curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
					curl_setopt($ch, CURLOPT_HEADER, 0);
					/*$output = */curl_exec($ch);
					curl_close($ch);
					// --------------------------------
				}else{
					$this->out['flg_activate']=false;
					$_iam->getErrors( $this->out['error'] );
				}
			}else{
				$this->out['flg_registered']=false;
				$_model->getErrors( $this->out['error'] );
			}
		}
		if( isset($_REQUEST['remove']) && !empty( $_REQUEST['remove'] )
			&& isset($_REQUEST['email']) && !empty( $_REQUEST['email'] )
		){
			// remover
			$_forms=new Project_Iam_Forms();
			$_forms
				->withSecretId( $_REQUEST['remove'] )
				->onlyOne()
				->getList( $_arrForm );
			$_model
				->withEmail( $_REQUEST['email'] )
				->withLinks()
				->onlyOne()
				->getList( $_arrUser );
			$_iam=new Project_Iam();
			if( !empty( $_arrForm ) 
				&& !empty( $_arrUser ) 
				&& $_iam->removeLinks( $_arrForm['sites_settings'], $_arrUser['id'] )
				&& $_model->removeLink( $_arrUser['id'], $_arrForm['id'] )
			){
				$_model
					->withEmail( $_REQUEST['email'] )
					->withLinks()
					->onlyOne()
					->getList( $_arrUser );
				if( empty( $_arrUser['forms'] ) ){
					$_model->withIds( $_arrUser['id'] )->del();
				}
				$this->out['flg_remove']=true;
			}else{
				$this->out['flg_remove']=false;
			}
		}
		if( isset($_REQUEST["cf_2"]) && !empty($_REQUEST["cf_2"]) 
			&& isset($_REQUEST["cf_1"]) && !empty( $_REQUEST["cf_1"] ) 
			&& isset($_REQUEST['email']) && !empty( $_REQUEST['email'] )
		){
			// registration
			$_forms=new Project_Iam_Forms();
			$_forms->withSecretId( $_REQUEST["cf_2"] )->onlyOne()->getList( $_arrForm );
			if( $_arrForm['activations_limit'] > 0 
				&& $_arrForm['activations_limit'] >= $_model->getFormActivationsCount( $_arrForm['id'] )
			){
				$this->out['flg_registered']=false;
			}
			if( !empty( $_arrForm ) && $_model
				->setEntered(array(
					'form_id'=>@$_arrForm['id'],
					'clickbank_id'=>$_REQUEST["cf_1"],
					'email'=>$_REQUEST['email'],
					'client_ip'=>$this->getRealIP(),
					'flg_active'=>1
				))
				->set() ){
					$_model->getEntered( $_arrUser );
					$_iam=new Project_Iam();
					if( !empty( $_arrUser['id'] ) 
						&& $_iam->addLinks( @$_arrForm['sites_settings'], array( $_arrUser['id'] ) )
					){
						$this->out['flg_activate']=true;
					}else{
						$this->out['flg_activate']=false;
						$_iam->getErrors( $this->out['error'] );
					}
			}else{
				$this->out['flg_registered']=false;
				$_model->getErrors( $this->out['error'] );
			}
		}
		if( isset( $_SERVER['HTTP_REFERER'] ) && !empty( $_SERVER['HTTP_REFERER'] ) ){
			header( 'Location: '.$_SERVER['HTTP_REFERER'] );
			exit;
		}elseif( isset( $_REQUEST['from'] ) && !empty( $_REQUEST['from'] ) ){
			$_obj=new Project_Iam_Sites();
			$_obj->onlyActive()->getList( $arrSites );
			foreach( $arrSites as $_site ){
				if( trim(str_replace(array('http://','https://','//'),'',$_site['url'] ),'/') == $_REQUEST['from'] ){
					$_iam=new Project_Iam();
					$_iam->getLinks( $_arrLinks );
					$_site2user=array();
					foreach( $_arrLinks as $_link ){
						if( $_link['site_id'] == $_site['id'] ){
							$_site2user[]=$_link['user_id'];
						}
					}
					$_users=new Project_Iam_Users();
					$_users
						->onlyCBIDs()
						->onlyIds()
						->withIds( $_site2user )
						->getList( $_arrCBIDs );
					echo implode( ':', $_arrCBIDs );
					exit;
				}
			}
		}
	}
	
	function getRealIP(){
		if( $_SERVER['HTTP_X_FORWARDED_FOR'] != '' ){
			$client_ip=(!empty($_SERVER['REMOTE_ADDR']))?$_SERVER['REMOTE_ADDR']:((!empty($_ENV['REMOTE_ADDR']))?$_ENV['REMOTE_ADDR']:"undefined");
			$entries=split('[, ]', $_SERVER['HTTP_X_FORWARDED_FOR']);
			reset($entries);
			while (list(, $entry)=each($entries)){
				$entry=trim($entry);
				if( preg_match("/^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)/", $entry, $ip_list) ){
					// http://www.faqs.org/rfcs/rfc1918.html
					$private_ip=array(
						'/^0\./',
						'/^127\.0\.0\.1/',
						'/^192\.168\..*/',
						'/^172\.((1[6-9])|(2[0-9])|(3[0-1]))\..*/',
						'/^10\..*/');
					$found_ip=preg_replace($private_ip, $client_ip, $ip_list[1]);
					if($client_ip != $found_ip){
						$client_ip=$found_ip;
						break;
					}
				}
			}
		} else {
			$client_ip=(!empty($_SERVER['REMOTE_ADDR']) )?$_SERVER['REMOTE_ADDR']:((!empty($_ENV['REMOTE_ADDR']))?$_ENV['REMOTE_ADDR']:"undefined");
		}
		return $client_ip;
	}
	
	public function manage_forms(){
		$_model=new Project_Iam_Forms();
		if( !empty( $_GET['delete'] ) ){
			if( $_model->withIds( $_GET['delete'] )->del() ){
				$this->objStore->toAction( 'manage_forms' )->set( array( 'msg'=>'deleted' ) );
				$this->location( array( 'action' => 'manage_forms' ) );
			}
		}
		$_model
			->withPaging( array( 'url'=>$_GET ) )
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] );
		$this->out['htmlspecialchars_form']=htmlspecialchars( Project_Iam_Forms::getForm() );
		$this->out['htmlspecialchars_remove_form']=htmlspecialchars( Project_Iam_Forms::getRemoveForm() );
		$this->out['htmlspecialchars_remove_link']=htmlspecialchars( Project_Iam_Forms::getRemoveLink() );
		$this->out['htmlspecialchars_activate_link']=htmlspecialchars( Project_Iam_Forms::getActivateLink() );
	}

	public function create_form(){
		$_model=new Project_Iam_Forms();
		if( isset($_GET['id']) && !empty( $_GET['id'] ) ){
			$_model
				->withIds( @$_GET['id'] )
				->onlyOne()
				->getList( $this->out['arrData'] );
		}
		if( !empty( $_POST ) ){
			if( $_model->setEntered( $_POST['arrData'] )->set() ){
				$this->objStore->toAction( 'manage_forms' )->set( array( 'msg'=>'added' ) );
				$this->location( array( 'action' => 'manage_forms' ) );
			}
			$_model
				->getEntered( $this->out['arrData'] )
				->getErrors( $this->out['arrErrors'] );
		}
		if( !isset( $this->out['arrData'] ) ){
			$this->out['arrData']=array();
		}
		if( !isset( $this->out['arrData']['secret_id'] ) ){
			$this->out['arrData']['secret_id']=$_model->generateUniqueSecret();
		}
		$this->out['htmlspecialchars_form']=htmlspecialchars( Project_Iam_Forms::getForm( $this->out['arrData']['secret_id'] ) );
		$this->out['htmlspecialchars_remove_form']=htmlspecialchars( Project_Iam_Forms::getRemoveForm( $this->out['arrData']['secret_id'] ) );
		$this->out['htmlspecialchars_remove_link']=htmlspecialchars( Project_Iam_Forms::getRemoveLink( $this->out['arrData']['secret_id'] ) );
		$this->out['htmlspecialchars_activate_link']=htmlspecialchars( Project_Iam_Forms::getActivateLink( $this->out['arrData']['secret_id'] ) );
		$_sites=new Project_Iam_Sites();
		$_sites
			->onlyActive()
			->getList( $this->out['arrSites'] );
		$category=new Core_Category( 'Blog Fusion' );
		$category->getLevel( $this->out['arrCategories'] );
		$category->getTree( $arrTree );
		foreach( $this->out['arrSites'] as $_k=>&$_elt ){
			$this->check_node( $_elt['category_name'], $arrTree, $_elt['category_id'] );
			$_elt['category_name']=implode( ' -> ', array_reverse( $_elt['category_name'] ) );
			$_elt['link_id']=$_elt['id'].'_'.$_elt['flg_type'];
			if( isset( $_GET['site_id_type'] ) && $_elt['link_id'] == $_GET['site_id_type'] ){
				$this->out['arrData']['name']='Single site \''.$_elt['name'].'\' form';
				$this->out['arrData']['sites_settings'][$_k]=$_elt['link_id'];
			}
		}
	}

	public function edit_user(){
		$_model=new Project_Iam_Users();
		if( isset($_GET['id']) && !empty( $_GET['id'] ) ){
			$_model
				->withIds( @$_GET['id'] )
				->onlyOne()
				->withLinks()
				->getList( $this->out['arrData'] );
		}
		if( !empty( $_POST ) ){
			if( $_model
				->setEntered( $_POST['arrData'] )
				->set() 
			){
				$_model->getEntered( $this->out['arrData'] );
				$_iam=new Project_Iam();
				if( !empty( $this->out['arrData']['id'] ) 
					&& $_iam->updateLinks( @$_POST['arrData']['arrLinks'], array( $this->out['arrData']['id'] ) )
				){
					$this->objStore->toAction( 'manage_users' )->set( array( 'msg'=>'added' ) );
					$this->location( array( 'action' => 'manage_users' ) );
				}
			}
			$_model
				->getEntered( $this->out['arrData'] )
				->getErrors( $this->out['arrErrors'] );
		}
		$_sites=new Project_Iam_Sites();
		$_sites
			->onlyActive()
			->getList( $this->out['arrSites'] );
		$category=new Core_Category( 'Blog Fusion' );
		$category->getLevel( $this->out['arrCategories'] );
		$category->getTree( $arrTree );
		foreach( $this->out['arrSites'] as &$_elt ){
			$this->check_node( $_elt['category_name'], $arrTree, $_elt['category_id'] );
			$_elt['category_name']=implode( ' -> ', array_reverse( $_elt['category_name'] ) );
			$_elt['link_id']=$_elt['id'].'_'.$_elt['flg_type'];
		}
	}

	public function manage_users(){
		$_model=new Project_Iam_Users();
		if( !empty( $_GET['delete'] ) ){
			set_time_limit(0);
			if( $_model->withIds( $_GET['delete'] )->del() ){
				$this->objStore->toAction( 'manage_users' )->set( array( 'msg'=>'deleted' ) );
				$this->location( array( 'action' => 'manage_users' ) );
			}
		}
		$_sites=new Project_Iam_Sites();
		$_sites
			->onlyActive()
			->getList( $this->out['arrSites'] );
		$_forms=new Project_Iam_Forms();
		$_forms->getList( $this->out['arrForms'] );
		if( !empty( $this->out['arrForms'] ) ){
			$_arrNewForms=array();
			foreach( $this->out['arrForms'] as $_form ){
				$_arrNewForms[$_form['id']]=$_form['name'];
			}
			$this->out['arrForms']=$_arrNewForms;
		}
		if( isset( $_GET['arrFilter']['search']['siteid'] ) ){
			$_model->withSiteId( $_GET['arrFilter']['search']['siteid'] );
		}
		if( isset( $_GET['arrFilter']['search']['cbid'] ) ){
			$_model->withCBID( $_GET['arrFilter']['search']['cbid'] );
		}
		if( isset( $_GET['arrFilter']['search']['email'] ) ){
			$_model->withEmail( $_GET['arrFilter']['search']['email'] );
		}
		$_model
			->withOrder( @$_GET['order'] )
		//	->setFilter( @$_GET['arrType'] )
			->withLinks()
			->withPaging( array( 'url'=>$_GET ) )
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] )
		;
	}

	public function remove_user(){
		$_model=new Project_Iam_Users();
		if( isset( $_GET['email'] ) ){
			$_model->withEmail( $_GET['email'] )->onlyOne()->getList( $_user );
			if( !empty($_user) && $_user['client_ip']==$this->getRealIP() ){
				$_model->withIds( $_user['id'] )->del();
				die("true");
			}
		}
		die("false");
	}

	public function manage_templates(){
		$_model=new Project_Iam_Templates();
		if( !empty( $_POST ) ){
			$_model->updateLinks( $_POST );
		}
		$_model->getLinks( $this->out['activeTemplates'] );
		foreach( $this->out['activeTemplates'] as $_t2l ){
			$this->out['activeTemplatesLinks'][]=$_t2l['template2type'];
		}
		$_template=new Project_Sites_Templates(Project_Sites::NCSB);
		$_template->withPreview()->onlyCommon()->getList($this->out['templates'][Project_Sites::NCSB]);
		$_template=new Project_Sites_Templates(Project_Sites::NVSB);
		$_template->withPreview()->onlyCommon()->getList($this->out['templates'][Project_Sites::NVSB]);
		$_wpTemplates=new Project_Wpress_Theme();
		$_wpTemplates->withPreview()->onlyCommon()->getList($this->out['templates'][Project_Sites::BF]);
	}

	private $_dir='IAM_backup@site';
	private $_usedDir, $_hostDir, $_domain, $_dirname;
	protected $_error;
	
	protected function checkPlacementId( $id='' ) {
		if ( empty( $id ) ) {
			return false;
		}
		$obj=new Project_Placement();
		if ( !$obj->withIds( $id )->onlyOne()->getList( $_info )->checkEmpty() ) {
			return false;
		}
		return true;
	}

	protected function addDir( $_dir='' ) {
		if( empty( $this->_domain ) ){
			return false;
		}
		$this->_hostDir=$_dir;
		$this->_usedDir=Zend_Registry::get('config')->path->absolute->user_temp.Core_Users::$info['id'].DIRECTORY_SEPARATOR.$this->_dir.$this->_domain.$this->_dirname.$_dir;
		if ( !is_dir( $this->_usedDir ) ) {
			mkdir( Zend_Registry::get('config')->path->absolute->user_temp.Core_Users::$info['id'].DIRECTORY_SEPARATOR.$this->_usedDir, 0755, true );
		}
		if ( !is_dir( $this->_usedDir ) ) {
			return $this->_error->setError( 'Can\'t create dir '.$this->_usedDir );
		}
		return true;
	}

	protected function addContent( $filename=false, $_transport=false ){
		if( empty( $this->_usedDir ) || empty( $filename ) || empty( $_transport ) || empty( $this->_domain ) ){
			return false;
		}
		$_old=$filename;
		while( strlen( $filename ) > 150 ){
			$_arrFile=explode( '.', $filename );
			$_arrName=explode( '-', $_arrFile[0] );
			if( count( $_arrName ) == 1 ){
				$filename=md5( $_arrName[0] ).'.'.$_arrFile[1];
				break;
			}
			array_pop($_arrName);
			$filename=implode( '-',$_arrName ).'.'.$_arrFile[1];
		}
		$_sshFile='/data/www/'.$this->_domain.'/html'.$this->_dirname.$this->_hostDir.$filename;
		$_localFile=Zend_Registry::get('config')->path->absolute->user_temp.Core_Users::$info['id'].DIRECTORY_SEPARATOR.$this->_usedDir.$filename;
		if( !$_transport->download( $_sshFile, $_localFile ) ){
			return $this->_error->setError( 'Can\'t download file '.$_sshFile.' to '.$_localFile );
		}
		return true;
	}
	
	public function manage_sites_pages(){
		$_sites=new Project_Iam_Sites();
		if( isset( $_GET['backup_id'] ) ){
			$_sites
				->onlyOne()
				->withIds( array( $_GET['backup_id'] ) )
				->getList( $_siteOldData );
				
			$_admin=Core_Users::$info['id'];
			if( isset( $_siteOldData['user_id'] ) ){
				Core_Users::getInstance()->setById( $_siteOldData['user_id'] );
			}
			
			$_object=new Project_Sites_Content( Project_Sites::NCSB );
			$_model=new Project_Sites( Project_Sites::NCSB );
			$_model->getSite( $_siteData, $_GET['backup_id'] );
			$_placement=new Project_Placement();
			$_placement->withIds( $_siteData['arrNcsb']['placement_id'] )->onlyOne()->getList( $_siteData['arrNcsb']['domen'] );
			$this->_domain=$_siteData['arrNcsb']['domen']['domain_http'];
			$this->_dirname=$_siteData['arrNcsb']['ftp_directory'];
			$_log.="\nGet site ".$this->_domain.$this->_dirname;
			$arrRes=array();
			if( !$this->checkPlacementId( $_siteData['arrNcsb']['placement_id'] ) ){
				$_log.="\nRe-check ".$_siteData['arrNcsb']['url'];
				$_arrUrl=parse_url( $_siteData['arrNcsb']['url'] );
				$this->_domain=$_arrUrl['host'];
				$_siteData['arrNcsb']=array( 
						'flg_type' => '1',
						'flg_passive' => '1',
						'flg_checked' => '2',
						'flg_sended_hosting' => '0',
						'flg_sended_domain' => '0',
						'flg_auto' => '1',
						'domain_http' => $this->_domain,
						'domain_ftp' => NULL,
						'username' => NULL,
						'password' => NULL,
						'db_host' => NULL,
						'db_name' => NULL,
						'db_username' => NULL,
						'db_password' => NULL,
						'publishing_options' => 'local'
					)+$_siteData['arrNcsb'];
			}
			$errors='';
			ob_start();
			$_transport=new Project_Placement_Transport();
			$_transport->setInfo( $_siteData['arrNcsb'] )->dirScan( $arrRes, '' );
			$errors=ob_get_contents();
			ob_end_clean();
			foreach( $arrRes as $_dirName => $_html ){
				if( strpos( $_dirName, 'html' ) ){
					$this->_dirname='/';
				}
				if( !$this->addDir( $this->_dirname ) ){
					$_log.="\nError in ".$this->_domain.$this->_dirname;
				}
				foreach( $_html as $_fileName ){
					if( !$this->addContent( $_fileName, $_transport ) ){
						$_log.="\nError in ".$this->_domain.$this->_dirname.' '.$_fileName;
					}
				}
			}
			$_downloadFilename=preg_replace("([^\w\s\d\-_~,;:\[\]\(\].]|[\.]{2,})", '', $this->_domain );
			if( !is_dir( Zend_Registry::get('config')->path->absolute->user_temp.Core_Users::$info['id'].DIRECTORY_SEPARATOR.$this->_dir ) ){
				mkdir( Zend_Registry::get('config')->path->absolute->user_temp.Core_Users::$info['id'].DIRECTORY_SEPARATOR.$this->_dir );
			}
			Core_Zip::getInstance()->open( Zend_Registry::get('config')->path->absolute->user_temp.Core_Users::$info['id'].DIRECTORY_SEPARATOR.$this->_dir.$_downloadFilename.'_'.$_siteID.'.zip', ZipArchive::CREATE );
			Core_Zip::getInstance()->addDirAndClose( Zend_Registry::get('config')->path->absolute->user_temp.Core_Users::$info['id'].DIRECTORY_SEPARATOR.$this->_dir );
			Core_Users::getInstance()->setById( $_admin );
			Core_Files::download( Zend_Registry::get('config')->path->absolute->user_temp.Core_Users::$info['id'].DIRECTORY_SEPARATOR.$this->_dir.$_downloadFilename.'_'.$_siteID.'.zip' );
			exit;
		}
		if( isset( $_POST['site_id'] ) ){
		//	$_content=new Project_Sites_Content( Project_Sites::NCSB );
		//	$_content
		//		->withSiteId( $_POST['site_id'] )
		//		->getList( $arrPagesList );
			$arrPagesList=array();
			$_sites
				->onlyOne()
				->withIds( array( $_POST['site_id'] ) )
				->getList( $_site );
			$ch = curl_init();
			curl_setopt($ch, CURLOPT_URL, $_site['url'].'index.html');
			curl_setopt($ch, CURLOPT_HEADER, true);
			curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
			$_content = curl_exec($ch);
			$info = curl_getinfo($ch);
			curl_close( $ch );
			if( empty($info['http_code']) || $info['http_code'] != 200 ){
				//$arrPagesList[]=$_POST['page_url'].' Error: '.$info['http_code'];
			}else{
				$dom=new DOMDocument();
				@$dom->loadHTML( $_content );
				$xpath=new DOMXPath( $dom );
				$hrefs=$xpath->evaluate( "/html/body//a" );
				$_checkedUrls=array();
				for ($i=0; $i < $hrefs->length; $i++) {
					$_url=$hrefs->item( $i )->getAttribute( 'href' );
					if( strpos( $_url, '//') === false && strpos( $_url, 'tag/') === false && strpos( $_url, '.html') !== false ){
						$_urlOnSite=explode( '/', $_url );
						$_urlOnSite=str_replace('.html','',$_urlOnSite[count( $_urlOnSite )-1]);
						if( !in_array( $_urlOnSite, array( 'privacy', 'disclaimer' ) ) ){
							$_checkedUrls[ $_urlOnSite ]=true;
						}
					}
				}
				foreach( $arrPagesList as $_page ){
					if( isset( $_checkedUrls[ $_page['link'] ] ) ){
						unset( $_checkedUrls[ $_page['link'] ] );
					}
				}
				foreach( $_checkedUrls as $_url => $_flg ){
					$arrPagesList[]=array( 'link' => $_url );
				}
			}
			ob_end_clean();
			echo json_encode( $arrPagesList );
			exit;
		}
		if( isset( $_POST['page_url'] ) ){
			$arrPagesList=array();
			$ch = curl_init();
			curl_setopt($ch, CURLOPT_URL, $_POST['page_url']);
			curl_setopt($ch, CURLOPT_HEADER, true);
			curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
			$_content = curl_exec($ch);
			$info = curl_getinfo($ch);
			curl_close( $ch );
			if( empty($info['http_code']) || $info['http_code'] != 200 ){
				$arrPagesList[]=$_POST['page_url'].' Error: '.$info['http_code'];
			}else{
				$dom=new DOMDocument();
				@$dom->loadHTML( $_content );
				$xpath=new DOMXPath( $dom );
				$hrefs=$xpath->evaluate( "/html/body//a" );
				$_checkedUrls=array();
				for ($i=0; $i < $hrefs->length; $i++) {
					$_url=$hrefs->item( $i )->getAttribute( 'href' );
					if( !in_array( $_url, $_checkedUrls ) && strpos( $_url, '//' ) !== false && strpos( $_url, 'w3.org' ) === false ){
						$ch = curl_init();
						curl_setopt($ch, CURLOPT_URL, $_url);
						curl_setopt($ch, CURLOPT_HEADER, true);
						curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
						curl_setopt($ch, CURLOPT_VERBOSE, true);
						curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
						curl_exec($ch);
						$info=curl_getinfo($ch);
						curl_close( $ch );
						if( empty($info['http_code']) || $info['http_code'] != 200 ){
							$arrPagesList[]=$_url.' Error: '.$info['http_code'];
						}
					}
					$_checkedUrls[$i]=$_url;
				}
			}
			ob_end_clean();
			echo json_encode( $arrPagesList );
			exit;
		}
		
		if( isset( $_GET['form_id'] ) ){
			$_forms=new Project_Iam_Forms();
			$_forms
				->withIds( @$_GET['form_id'] )
				->onlyOne()
				->getList( $_arrForm );
			$_sites
				->onlyActive()
				->withIds( $_arrForm['sites_settings'] )
				->getList( $this->out['arrList'] );
		}else{
			$_sites->getList( $this->out['arrList'] );
		}

	}

	public function manage_site(){
		$_model=new Project_Iam_Sites();
		if( !empty( $_POST ) && $_POST['mode']=='activate' ){
			$_model->updateLinks( array_keys( $_POST['active'] ), array_keys( array_filter( $_POST['old'] ) ) );
		}
		if( !empty( $_GET ) && $_GET['download']=='true' ){
			$_model->withIds( $_GET['site_id'] )->onlyOne()->getList( $_arrSite );
			ob_end_clean();
			header( 'HTTP/1.1 200 OK' );
			header( 'Content-Type:  text/plain; charset="utf8"' );
			header( 'Content-Disposition: attachment; filename="'.trim( str_replace( array( "http://", "https://", ".", "/" ), array( "","","_","_" ), $_arrSite['url'] ), "_" ).'.txt"' );
			$_content=new Project_Sites_Content( Project_Sites::NCSB );
			$_content
				->withSiteId( $_GET['site_id'] )
				->getList( $arrPages );
			echo $_arrSite['url']."index-z-[MM_Member_Data name='customField_1'].html";
			foreach( $arrPages as $page ){
				echo "\r".$_arrSite['url'].$page['link']."-z-[MM_Member_Data name='customField_1'].html";
			}
			exit;
		}
		if( !empty( $_GET ) && $_GET['update_template']=='true' ){
			ob_end_clean();
			$_getAdmin=Core_Users::$info['id'];
			Zend_Registry::get( 'objUser' )->setById( $_GET['user_id'] );
			$_site=new Project_Sites( Project_Sites::NCSB );
			$_site->getSite( $_arrSite, $_GET['site_id'] );
			if( $_arrSite['arrNcsb']['ftp_directory'] == '/' || $_arrSite['arrNcsb']['ftp_directory'] == '//' ){
				$_arrSite['arrNcsb']['ftp_root']=1;
			}
			if( $_arrSite['arrNcsb']['flg_snippet']==1 ){
				$_arrSite['arrNcsb']['flg_snippet']='yes';
			}else{
				$_arrSite['arrNcsb']['flg_snippet']='no';
			}
			$_arrSite['arrNcsb']['url']='';
			$_arrSite['arrNcsb']['old_template_id']=0;
			$_options=new Project_Options( '2' /*NCSB*/, $_GET['site_id'] );
			$_options->get( $_arrSite['arrOpt'] );
			$_site->setEntered( $_arrSite )->set();
			Zend_Registry::get( 'objUser' )->setById( $_getAdmin );
			exit;
		}
		$_model
			->withOrder( @$_GET['order'] )
			->withPaging( array( 'url'=>$_GET, 'reconpage'=>15 ) )
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
		$_model->getList( $arrSites );
		$_placementIds=array();
		$time=time();
		$_model2=new Project_Iam_Sites();
		$_model2->getList( $arrAllSites );
		foreach( $arrAllSites as $_site ){
			$_placementIds[]=$_site['placement_id'];
		}
		$_place=new Project_Placement();
		$_place->withIds( $_placementIds )->getList( $_sites );
		$_namecheap=new Project_Placement_Domen_Namecheap();
		foreach( $_sites as &$_site ){
			$_site['expiry_domain_timer']=$_site['expiry_domain']-$time;
			if( $_site['expiry_domain_timer'] <= 30*24*60*60 ){
				$_return=$_namecheap->setEntered( array('DomainName'=>$_site['domain_http']) )->getInfo( $_domainInfo );
				if( $_return !== false && $_site['checked'] < $time-24*60*60  ){
					$newExpiredDate=strtotime( $_domainInfo['DomainDetails']['ExpiredDate'] );
					if( $newExpiredDate-$time > 30*24*60*60 && $_domainInfo['Status'] == 'Ok' ){
						$_site['expiry_domain']=$_site['expiry_hosting']=$newExpiredDate;
						$_site['checked']=$time;
						$_site['flg_checked']=1;
						$_place->setEntered( $_site )->set();
						$this->out['arrUpdate'][]=$_site;
					}
				}else{
					$this->out['arrExpiry']['Domain'][]=$_site;
				}
			}
			$_site['expiry_hosting_timer']=$_site['expiry_hosting']-$time;
			if( $_site['expiry_hosting_timer'] <= 30*24*60*60 ){
				$this->out['arrExpiry']['Hosting'][]=$_site;
			}
		}
		$category=new Core_Category( 'Blog Fusion' );
		$category->getLevel( $this->out['arrCategories'] );
		$category->getTree( $arrTree );
		foreach( $this->out['arrList'] as &$_elt ){
			$this->check_node( $_elt['category_name'], $arrTree, $_elt['category_id'] );
			$_elt['category_name']=implode( ' -> ', array_reverse( $_elt['category_name'] ) );
		}
		$this->out['treeJson']=Zend_Registry::get('CachedCoreString')->php2json($arrTree);
	}
	
	private function check_node( &$array, $_arrTree=array(), $_id ){
		if( empty( $_arrTree ) ){
			return false;
		}
		foreach( $_arrTree as $_node ){
			if( $_node['id'] == $_id || $this->check_node( $array, $_node['node'], $_id ) ){
				$array[]=$_node['title'];
				return true;
			}
		}
		return false;
	}
}
?>