<?php
/**
 * Organizer module
 *
 * @category CNM Project
 * @package ProjectSource
 */

class site1_ecom_funnels extends Core_Module {
	
	public function set_cfg(){
		$this->inst_script=array(
			'module' =>array( 'title'=>'CNM iFunnels Studio', ),
			'actions'=>array(
				array( 'action'=>'create', 'title'=>'Create Site', 'flg_tree'=>1, 'flg_tpl' => 1 ),
				array( 'action'=>'browse', 'title'=>'Browse FTP', 'flg_tree'=>1, 'flg_tpl' => 1 ),
				array( 'action'=>'livepreview', 'title'=>'Live Preview', 'flg_tpl'=>1, 'flg_tree'=>1 ),
				array( 'action'=>'loadsinglepage', 'title'=>'Load single page', 'flg_tpl'=>1, 'flg_tree'=>1 ),
				array( 'action'=>'manage', 'title'=>'Manage Sites', 'flg_tree'=>1 ),
				array( 'action'=>'reporting', 'title'=>'Reporting', 'flg_tree'=>1 ),
				array( 'action'=>'save', 'title'=>'Save Site', 'flg_tpl'=>3, 'flg_tree'=>1 ),
				array( 'action'=>'siteData', 'title'=>'Site Data', 'flg_tpl'=>3, 'flg_tree'=>1 ),
				array( 'action'=>'getframe', 'title'=>'Get Frame', 'flg_tpl'=>1, 'flg_tree'=>1 ),
				array( 'action'=>'delimage', 'title'=>'Delete Image', 'flg_tpl'=>3, 'flg_tree'=>1 ),
				array( 'action'=>'loadAll', 'title'=>'Load All', 'flg_tpl'=>3, 'flg_tree'=>1 ),
				array( 'action'=>'favoriteblock', 'title'=>'Save Favorite Block', 'flg_tpl'=>3, 'flg_tree'=>1 ),
				array( 'action'=>'updateTemplate', 'title'=>'Update Site from Template', 'flg_tpl'=>3, 'flg_tree'=>1 ),
				array( 'action'=>'deleteblock', 'title'=>'Delete Favorite Block', 'flg_tpl'=>3, 'flg_tree'=>1 ),
				array( 'action'=>'updatePageData', 'title'=>'Update Page Data', 'flg_tpl'=>3, 'flg_tree'=>1 ),
				array( 'action'=>'updateSettingsSite', 'title'=>'Update Page Data', 'flg_tpl'=>3, 'flg_tree'=>1 ),
				array( 'action'=>'export', 'title'=>'Export', 'flg_tpl'=>3, 'flg_tree'=>1 ),
				array( 'action'=>'publish', 'title'=>'Publish', 'flg_tpl'=>3, 'flg_tree'=>1 ),
				array( 'action'=>'getLeadChannelsForm', 'title'=>'Get Lead Channels Form', 'flg_tpl'=>3, 'flg_tree'=>1 ),
				array( 'action'=>'ajax', 'title'=>'Ajax', 'flg_tpl'=>3, 'flg_tree'=>2 ),
				array( 'action'=>'pageData', 'title'=>'Page Data', 'flg_tpl'=>3, 'flg_tree'=>2 ),
				array( 'action'=>'imageUploadAjax', 'title'=> 'Image Upload Ajax', 'flg_tpl'=>3, 'flg_tree'=>2 ),
				array( 'action'=>'resizeImage', 'title'=> 'Resize Image', 'flg_tpl'=>3, 'flg_tree'=>2 ),
				array( 'action'=>'save_as_template', 'title'=>'Save as Template', 'flg_tpl'=>3, 'flg_tree'=>2 ),
				array( 'action'=>'show_video', 'title'=> 'Show Video', 'flg_tpl'=>1, 'flg_tree'=>1 ),
				array( 'action'=>'optimization', 'title' => 'Optimization', 'flg_tree' => 1 ),

				// backend actions
				array( 'action'=>'create_template', 'title'=>'Create Template' ),
				array( 'action'=>'file_edit', 'title'=>'File Edit', 'flg_tpl'=>1 ),
				array( 'action'=>'manage_template', 'title'=>'Manage Template' ),
				array( 'action'=>'manage_blocks', 'title'=>'Manage Blocks' ),
				array( 'action'=>'manage_components', 'title'=>'Manage Components' ),
				array( 'action'=>'category_template', 'title'=>'Category Template' ),
				array( 'action'=>'sharelog', 'title'=>'Share Log' ),
				array( 'action'=>'backend_siteData', 'title'=>'Site Data', 'flg_tpl'=>3 ),
				array( 'action'=>'backend_loadAll', 'title'=>'Load All', 'flg_tpl'=>3 ),
				array( 'action'=>'loadBlock', 'title'=>'Load Block', 'flg_tpl'=>3 ),
				array( 'action'=>'loadComponent', 'title'=>'Load Component', 'flg_tpl'=>3 ),
				array( 'action'=>'addcomponents', 'title'=>'Add Component', 'flg_tpl'=>3 ),
				array( 'action'=>'backend_tsave', 'title'=>'Template Save', 'flg_tpl'=>3 ),
				array( 'action'=>'backend_favoriteblock', 'title'=>'Save Favorite Block', 'flg_tpl'=>3 ),
				array( 'action'=>'backend_deleteblock', 'title'=>'Delete Favorite Block', 'flg_tpl'=>3 ),
				array( 'action'=>'b_deleteBlock', 'title'=>'Delete Block', 'flg_tpl'=>3 ),
				array( 'action'=>'b_updateBlock', 'title'=>'Update Block', 'flg_tpl'=>3 ),
				array( 'action'=>'b_updateComponent', 'title'=>'Update Component', 'flg_tpl'=>3 ),
				array( 'action'=>'b_deletecomponent', 'title'=>'Delete Component', 'flg_tpl'=>3 ),
				array( 'action'=>'cloneoriginal_block', 'title'=>'Clone Original Block', 'flg_tpl'=>3 ),
				array( 'action'=>'updateoriginal_block', 'title'=>'Update Original Block', 'flg_tpl'=>3 ),
				array( 'action'=>'deleteoriginal_block', 'title'=>'Delete Original Block', 'flg_tpl'=>3 ),
				array( 'action'=>'backend_getframe', 'title'=>'Get Frame', 'flg_tpl'=>1 ),
				array( 'action'=>'load_file', 'title'=>'Load File', 'flg_tpl'=>1 ),
				array( 'action'=>'save_file', 'title'=>'Save File', 'flg_tpl'=>3 ),
				array( 'action'=>'backend_livepreview', 'title'=>'Live Preview', 'flg_tpl'=>1 ),
				array( 'action'=>'backend_updateSettingsSite', 'title'=>'Update Settings Site', 'flg_tpl'=>3 ),
				array( 'action'=>'backend_resizeImage', 'title'=>'Resize Image', 'flg_tpl'=>3 ),
				array( 'action'=>'template2group', 'title'=>'Template to group' ),
				array( 'action'=>'block2group', 'title'=>'Block to group' ),
				array( 'action'=>'backend_delimage', 'title'=>'Delete Image', 'flg_tpl'=>3 ),
				
				array( 'action'=>'auth', 'title'=>'Auth', 'flg_tpl'=>3, 'flg_tree'=>1 ),
				array( 'action'=>'auth_back', 'title'=>'Auth', 'flg_tpl'=>3 ),
				
				array( 'action'=>'share', 'title'=>'Share', 'flg_tree'=>1 ),
			),
		);
	}

	/**
	 * Backend actions
	 */

	public function create_template(){
		$this->objStore->getAndClear( $this->out );
		$sites = new Project_Pagebuilder_Sites();
		
		if( isset( $_GET['new'] ) ){
			$sites = new Project_Pagebuilder_Sites();
			$templateID = $sites->createNew( $_GET['template'], false, true );
			
			unset( $_GET['new'] );
			unset( $_GET['template'] );
			$_SESSION['templateID'] = $templateID;
			$this->location( array( 'action' => 'create_template', 'wg' => 'id=' . $templateID . '&p=index' ) );
		}

		if( ! empty( $_GET['id'] ) ){
			$_SESSION['templateID'] = $_GET['id'];
			require_once Zend_Registry::get( 'config' )->path->relative->library . 'Helper/directory_helper.php';

			$siteData = $sites->isTemplate()->getSite( $_GET['id'] );
			
			$this->out['templateID'] = $_SESSION['templateID'];
			$this->out['siteData'] = $siteData;
	
			/** Collect data for the image library */
			$userID = Core_Users::$info['id'];

			/** Collect data for the image library */
			$userID = Core_Users::$info['id'];
			$this->out['userImages'] = array();
			if ( is_dir( Zend_Registry::get('config')->path->relative->user_data . "/" . $userID ) ){
				$folderContent = directory_map( Zend_Registry::get('config')->path->relative->user_data . "/" . $userID, 2 );
				if ( $folderContent ){
					foreach( $folderContent as $key => $item ){
						if ( ! is_array( $item ) ){
							/** check the file extension */
							$ext = pathinfo( $item, PATHINFO_EXTENSION );
							/** prep allowed extensions array */
							if ( in_array( $ext, array("jpg", "png", "gif", "svg") ) ){
								array_push( $this->out['userImages'], $item );
							}
						}
					}
				}
			}

			$this->out['adminImages'] = array();
			$folderContent = directory_map( Zend_Registry::get( 'config' )->path->relative->root . 'skin/pagebuilder/images', 2 );

			if ($folderContent){
				foreach( $folderContent as $key => $item ){
					if( ! is_array( $item ) ){
						/** check the file extension */
						$ext = pathinfo( $item, PATHINFO_EXTENSION );
						if( in_array( $ext, array( "jpg", "png", "gif", "svg" ) ) ){
							array_push( $this->out['adminImages'], $item );
						}
					}
				}
			}
	
			/*$this->out['categories'] = $this->MTemplates->getCategories();
			if ( $templateID ) 
				$this->data['categoryID'] = $this->MTemplates->getTemplateCategory($templateID);
			*/
		}

		

		$sites = new Project_Pagebuilder_Sites();
		$sites->isTemplate()->getList( $this->out['arrTemplates'] );
			
		$pages = new Project_Pagebuilder_Pages();
		foreach( $this->out['arrTemplates'] as &$_template ){
			$pages
				->withSiteId( $_template['id'] )
				->withOrder( 'id--dn' )
				->getList( $_template['arrPages'] );
		}

		$category = new Project_Pagebuilder_Category_Template();
		$category->getList( $this->out['arrCategory'] );

		$category = new Project_Pagebuilder_Category_Blocks();
		$category->withOrder( 'category_name--dn' )->getList( $this->out['arrBlocksCategory'] );
	}

	public function show_video(){
		if( isset( $_GET['url'] ) && !empty( $_GET['url'] ) ){
			$this->out['videoURL']=$_GET['url'];
			$this->out['HTTP_REFERER'] = $_SERVER['HTTP_REFERER'];
		}
	}

	public function backend_tsave(){
		$smarty = new Core_View_Smarty();
		/** Do we have some frames to save? */
		

		reset($_POST['pages']);
		$first_key = key($_POST['pages']);
		$flg_empty = false;

		foreach ($_POST['pages'] as $name => $page) {			
			if( isset($page['blocks'])){
				$flg_empty = true;
			}			
		}

		if (!$flg_empty) {
			$temp = array();
			$temp['header'] = 'Ouch! Something went wrong:';
			$temp['content'] = 'Your template has already been saved.';
			$smarty->_smarty->assign($temp);
			$this->out_js['responseCode'] = 0;
			$this->out_js['responseHTML'] = $smarty->_smarty->fetch(__DIR__ . "/templates/site1_ecom_funnels_error.tpl");
			echo json_encode($this->out_js);
			exit;
		}
		
		/** Delete any pages? */
		if( isset($_POST['toDelete']) && is_array($_POST['toDelete']) && count($_POST['toDelete']) > 0 ){
			foreach ($_POST['toDelete'] as $page){
				$pages = new Project_Pagebuilder_Pages();
				$pages->withSiteId($_POST['siteData']['id'])->withPageName($page)->onlyIds()->getList($arrPages);
				if(!empty($arrPages)){
					$pages->withIds($arrPages)->del();
				}
			}
		}

		$sites = new Project_Pagebuilder_Sites();
		$templateID = $sites->saveTemplate($_POST);

		$this->out_js['debug'] = $_POST;

		/** All good */
		if ($templateID){
			$temp = array();
			$temp['header'] = 'Success!';
			$temp['content'] = 'The template was saved successfully. The new template will be available from the left menu after reloading this page.';
			$smarty->_smarty->assign($temp);
			$this->out_js['responseCode'] = 1;
			$this->out_js['templateID'] = $templateID;
			$this->out_js['responseHTML'] = $smarty->_smarty->fetch(__DIR__ . "/templates/site1_ecom_funnels_success.tpl");
		}
		/** Not good */
		else {
			$temp = array();
			$temp['header'] = 'Ouch!';
			$temp['content'] = 'The template good not be saved. Please reload the page and try again.';
			$smarty->_smarty->assign($temp);
			$this->out_js['responseCode'] = 0;
			$this->out_js['responseHTML'] = $smarty->_smarty->fetch(__DIR__ . "/templates/site1_ecom_funnels_error.tpl");
		}
		echo json_encode($this->out_js);
		exit;
	}

	public function manage_template(){
		$sites = new Project_Pagebuilder_Sites();
		$sites->isTemplate()->getList($this->out['arrTemplates']);
		if(isset($_GET['duplicate']) && !empty($_GET['duplicate'])){
			$sites->duplicateTempalate($_GET['duplicate']);
			$this->location();
		}
		if(isset($_GET['del'])){
			$sites->withIds($_GET['del'])->del();
			$this->location();
		}
		$category = new Project_Pagebuilder_Category_Template();
		$category->getList( $this->out['arrCategories'] );
		$_categoryArray=array();
		foreach( $this->out['arrCategories'] as $_cat ){
			$_categoryArray[$_cat['id']]=$_cat['category_name'];
		}
		$this->out['arrCategories']=$_categoryArray;
	}

	public function manage_blocks(){
		$blocks = new Project_Pagebuilder_Blocks();
		$blocks
			->withOrder('id--dn')
			/*->withPaging(array(
				'page'=>@$_GET['page'],
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			))
			->withOrder( @$_GET['order'] )*/
			->getList($this->out['arrBlocks']);
			/*->getPaging( $this->out['arrPg'] );*/

		$category = new Project_Pagebuilder_Category_Blocks();
		$category->withOrder('category_name--dn')->getList($this->out['arrCategoryes']);

		/**
		 * POST request's
		 */

		if($_POST['action'] == 'new_block'){
			ob_clean();
			$this->out['responseCode'] = 0;
			if(!empty($_POST['blockCategory']) && !empty($_POST['blockUrl'])){
				$dataBlock = array(
					'blocks_category' => $_POST['blockCategory'],
					'blocks_url' => $_POST['blockUrl'],
				);

				if (!empty($_POST['blockFullHeight'])){
					$dataBlock['blocks_height'] = "90vh";
				}
				else {
					$dataBlock['blocks_height'] = "567";
				}
				
				$blocks = new Project_Pagebuilder_Blocks();
				$blocks->setEntered($dataBlock)->set();
				$blocks->getEntered($dataBlock);

				$screenshot_url = (!empty($_SERVER['HTTPS']) && 'off' !== strtolower($_SERVER['HTTPS']) ? 'https://' : 'http://') . $_SERVER['HTTP_HOST'] . '/' . Zend_Registry::get('config')->path->html->pagebuilder . $_POST['blockUrl'];
				$filename = 'blockthumb_' . $dataBlock['id'] . '.jpg';
				$_deltaWidth=600;
				$_deltaHeight=intval( intval( $dataBlock['blocks_height'] )*1.0/( 1024/600 ) );
				$screenModel = new Project_Pagebuilder_Screenshot();
				$screenshot = $screenModel->make_screenshot($screenshot_url, $filename, $_deltaWidth.'x'.$_deltaHeight, Zend_Registry::get('config')->path->absolute->pagebuilder . 'tmp' . DIRECTORY_SEPARATOR . 'blockthumbs' . DIRECTORY_SEPARATOR );
				
				$dataBlock['blocks_thumb'] = 'tmp/blockthumbs/' . $screenshot;
				$blocks->setEntered($dataBlock)->set();
				$this->out['responseCode'] = 1;	
			}
			echo json_encode($this->out);
			exit();
		}
		if($_POST['action'] == 'new_category'){
			ob_clean();
			$this->out['responseCode'] = 0;			
			if(!empty($_POST['catname'])){
				if($category->setEntered(array('category_name' => $_POST['catname']))->set()){
					$this->out['responseCode'] = 1;
					$category->withOrder('category_name--dn')->getList($this->out['arrCategory']);
				}
			}
			echo json_encode($this->out);
			exit();
		}
		if(isset($_POST['category_id']) && !empty($_POST['category_id']) && isset($_POST['category_name'])){
			ob_clean();
			$this->out['responseCode'] = 0;
			if($category->setEntered(array('id' => $_POST['category_id'], 'category_name' => $_POST['category_name']))->set()){
				$this->out['responseCode'] = 1;
			}
			echo json_encode($this->out);
			exit();
		}
		if(isset($_POST['category_id']) && !empty($_POST['category_id'])){
			ob_clean();
			if($category->withIds($_POST['category_id'])->del()){
				$this->out['responseCode'] = 1;
			} else {
				$this->out['responseCode'] = 0;
			}

			echo json_encode($this->out);
			exit();
		}
	}

	public function manage_components(){
		$components = new Project_Pagebuilder_Components();
		$components->getList($this->out['arrComponents']);

		$category = new Project_Pagebuilder_Category_Components();
		$category->withOrder('category_name--dn')->getList($this->out['arrCategoryes']);

		if($_POST['action'] == 'new_block'){
			ob_clean();
			$this->out['responseCode'] = 0;
			if(!empty($_POST['blockCategory']) && !empty($_POST['blockUrl'])){
				$dataBlock = array(
					'blocks_category' => $_POST['blockCategory'],
					'blocks_url' => $_POST['blockUrl'],
				);

				if (!empty($_POST['blockFullHeight'])){
					$dataBlock['blocks_height'] = "90vh";
				}
				else {
					$dataBlock['blocks_height'] = "567";
				}

				$blocks = new Project_Pagebuilder_Blocks();
				$blocks->setEntered($dataBlock)->set();
				$blocks->getEntered($dataBlock);

				$screenshot_url = (!empty($_SERVER['HTTPS']) && 'off' !== strtolower($_SERVER['HTTPS']) ? 'https://' : 'http://') . $_SERVER['HTTP_HOST'] . '/' . Zend_Registry::get('config')->path->html->pagebuilder . $_POST['blockUrl'];
				$filename = 'blockthumb_' . $dataBlock['id'] . '.jpg';
				$_deltaWidth=600;
				$_deltaHeight=intval( intval( $dataBlock['blocks_height'] )*1.0/( 1024/600 ) );
				$screenModel = new Project_Pagebuilder_Screenshot();
				$screenshot = $screenModel->make_screenshot($screenshot_url, $filename, $_deltaWidth.'x'.$_deltaHeight, Zend_Registry::get('config')->path->absolute->pagebuilder . 'tmp' . DIRECTORY_SEPARATOR . 'blockthumbs' . DIRECTORY_SEPARATOR );
				
				$dataBlock['blocks_thumb'] = 'tmp/blockthumbs/' . $screenshot;
				$blocks->setEntered($dataBlock)->set();
				$this->out['responseCode'] = 1;	
			}
			echo json_encode($this->out);
			exit();
		}
		if($_POST['action'] == 'new_category'){
			ob_clean();
			$this->out['responseCode'] = 0;			
			if(!empty($_POST['catname'])){
				if($category->setEntered(array('category_name' => $_POST['catname']))->set()){
					$this->out['responseCode'] = 1;
					$category->withOrder('category_name--dn')->getList($this->out['arrCategory']);
				}
			}
			echo json_encode($this->out);
			exit();
		}
		if(isset($_POST['category_id']) && !empty($_POST['category_id']) && isset($_POST['category_name'])){
			ob_clean();
			$this->out['responseCode'] = 0;
			if($category->setEntered(array('id' => $_POST['category_id'], 'category_name' => $_POST['category_name']))->set()){
				$this->out['responseCode'] = 1;
			}
			echo json_encode($this->out);
			exit();
		}
		if(isset($_POST['category_id']) && !empty($_POST['category_id'])){
			ob_clean();
			if($category->withIds($_POST['category_id'])->del()){
				$this->out['responseCode'] = 1;
			} else {
				$this->out['responseCode'] = 0;
			}

			echo json_encode($this->out);
			exit();
		}
	}

	public function loadComponent(){
		$smarty = new Core_View_Smarty();
		$components = new Project_Pagebuilder_Components();
		$components->withIds($_POST['component_id'])->onlyOne()->getList($this->out_js['forTemplate']['component']);
		$category = new Project_Pagebuilder_Category_Components();
		$category->withOrder('category_name--up')->getList($this->out_js['forTemplate']['componentCategories']);

		$smarty->_smarty->assign($this->out_js);
		$this->out_js['markup'] = $smarty->_smarty->fetch(__DIR__ . "/templates/site1_ecom_partial_componentdetails.tpl");
	}

	public function loadBlock(){
		$smarty = new Core_View_Smarty();
		$blocks = new Project_Pagebuilder_Blocks();
		$blocks->withIds($_POST['block_id'])->onlyOne()->getList($this->out_js['forTemplate']['block']);
		$category = new Project_Pagebuilder_Category_Blocks();
		$category->withOrder('category_name--up')->getList($this->out_js['forTemplate']['blockCategories']);

		$this->out_js['forTemplate']['templates'] = $this->out_js['templates'] = Project_Pagebuilder_Blocks::loadTemplateFiles();

		$smarty->_smarty->assign($this->out_js);
		$this->out_js['markup'] = $smarty->_smarty->fetch(__DIR__ . "/templates/site1_ecom_partial_blockdetails.tpl");
	}

	public function category_template(){
		$category = new Project_Pagebuilder_Category_Template();
		if(!empty($_POST)){
			$category->setEntered($_POST['arrData'])->set();
			$this->location();
		}
		if(!empty($_GET['del'])){
			$category->withIds($_GET['del'])->del();
			$this->location();
		}
		$category->getList($this->out['arrCategory']);
	}

	public function backend_siteData(){
		$this->siteData();
	}

	public function backend_loadAll(){
		$this->loadAll();
	}

	public function backend_getframe(){
		$this->getframe();
	}

	public function cloneoriginal_block(){
		$this->out_js['responseCode'] = 1;
		$this->out_js['content'] = "It's all good!";
		$errors = array();

		if(empty($_POST['frames_content'])){
			$errors[] = 'Frame content';
		}

		if(empty($_POST['frames_height'])){
			$errors[] = 'Block height';
		}

		if(empty($_POST['frames_width'])){
			$errors[] = 'Block width';
		}

		if(empty($_POST['category'])){
			$errors[] = 'Category ID';
		}

		if (!empty($errors)){
			$this->out_js['responseCode'] = 0;
			$this->out_js['content'] = "Something went wrong; it appears the data is incorrect:<br>" . implode('<br />', $errors);
		}
		else {
			if (!file_exists( Zend_Registry::get('config')->path->absolute->pagebuilder . 'elements' . DIRECTORY_SEPARATOR . 'clones')) {
				if (!mkdir(Zend_Registry::get('config')->path->absolute->pagebuilder . 'elements'. DIRECTORY_SEPARATOR .'clones', 0777, true)){
					$this->out_js['responseCode'] = 0;
					$this->out_js['content'] = "Could not clone block; the template file could not be created. Please make sure the folder is writable";
					return;
				}
			}

			$theNewFile = 'elements' . DIRECTORY_SEPARATOR . 'clones' . DIRECTORY_SEPARATOR . 'clone_' . Project_Pagebuilder_Blocks::random_string('numeric', 10) . '.html';

			$content_decoded = urldecode(base64_decode(str_replace(' ', '+', $_POST['frames_content'])));
			$content_prepped = Project_Pagebuilder_Frames::processFrameContent($content_decoded);

			if (file_put_contents(Zend_Registry::get('config')->path->absolute->pagebuilder . $theNewFile, $content_prepped) !== FALSE){
				// Make the screenshot
				$screenshot_url = (!empty($_SERVER['HTTPS']) && 'off' !== strtolower($_SERVER['HTTPS']) ? 'https://' : 'http://') . $_SERVER['HTTP_HOST'] . '/' . Zend_Registry::get('config')->path->html->pagebuilder .  DIRECTORY_SEPARATOR . $theNewFile;
				$filename = 'blockthumb_' . Project_Pagebuilder_Blocks::random_string('numeric', 12) . '.jpg';

				$screenModel = new Project_Pagebuilder_Screenshot();
				$screenshot = $screenModel->make_screenshot($screenshot_url, $filename, $_POST['frames_width'] . 'x' . $_POST['frames_height'], Zend_Registry::get('config')->path->absolute->pagebuilder . 'tmp' . DIRECTORY_SEPARATOR . 'blockthumbs' . DIRECTORY_SEPARATOR );
				//DIRECTORY_SEPARATOR
				$newBlock['blocks_category'] = $_POST['category'];
				$newBlock['blocks_url'] = $theNewFile;
				$newBlock['blocks_height'] = $_POST['frames_height'];
				$newBlock['blocks_thumb'] = 'tmp/blockthumbs/' . $screenshot;

				$blocks = new Project_Pagebuilder_Blocks();
				$blocks->setEntered($newBlock)->set();
				
				$this->out_js['responseCode'] = 1;
				$this->out_js['content'] = "The block was cloned successfully in the selected category";
			}
			else {
				$this->out_js['responseCode'] = 0;
				$this->out_js['content'] = "Could not clone block; the template file could not be created. Please make sure the folder is writable";
			}
		}
	}

	public function updateoriginal_block(){
		$errors = array();

		if(empty($_POST['frames_content'])){
			$errors[] = 'Frame content';
		}
		if(empty($_POST['frames_url'])){
			$errors[] = 'Block template url';
		}
		if(empty($_POST['frames_height'])){
			$errors[] = 'Block height';
		}
		if(empty($_POST['frames_width'])){
			$errors[] = 'Block width';
		}
		$blocks = new Project_Pagebuilder_Blocks();

		/** All did not go well */
		if (!empty($errors)) {
			$this->out_js['responseCode'] = 0;
			$this->out_js['content'] = "Something went wrong; it appears the data is incorrect:<br>" . implode('<br />', $errors);
		}
		else {
			$content_decoded = urldecode(base64_decode(str_replace(' ', '+', $_POST['frames_content'])));
			$content_prepped = Project_Pagebuilder_Frames::processFrameContent($content_decoded);

			if ($blocks->updateOriginal($_POST['frames_url'], $content_prepped)) {
				$this->out_js['responseCode'] = 1;
				$this->out_js['content'] = "This blocks original source code has been updated";

				// Screenshot time
				$screenshot_url = $_POST['frames_url'];
				$filename = 'blockthumb_' . Project_Pagebuilder_Blocks::random_string('numeric', 12) . '.jpg';

				$screenModel = new Project_Pagebuilder_Screenshot();
				$screenshot = $screenModel->make_screenshot($screenshot_url, $filename, $_POST['frames_width'] . 'x' . $_POST['frames_height'], Zend_Registry::get('config')->path->absolute->pagebuilder . 'tmp' . DIRECTORY_SEPARATOR . 'blockthumbs' . DIRECTORY_SEPARATOR);

				// Update the database
				$blocks->withUrl(str_replace((!empty($_SERVER['HTTPS']) && 'off' !== strtolower($_SERVER['HTTPS']) ? 'https://' : 'http://') . $_SERVER['HTTP_HOST'] . '/skin/pagebuilder/', '', $_POST['frames_url']))->onlyOne()->getList($dataBlock);
				$blocks->setEntered(array('id' => $dataBlock['id'], 'blocks_thumb' => 'tmp/blockthumbs/' . $screenshot))->set();
			}
			else {
				$this->out_js['responseCode'] = 0;
				$this->out_js['content'] = "Could not save block source code; file does not exist or you do not have sufficient permissions to modify this file. Make sure this block is still present and that it's template file is writable.";
			}
		}
	}

	public function deleteoriginal_block(){
		$errors = array();
		if(empty($_POST['frames_url'])){
			$errors[] = 'Block template url';
		}
		if (!empty($errors)){
			$this->out_js['responseCode'] = 0;
			$this->out_js['content'] = "Something went wrong; it appears the data is incorrect:<br>". implode('<br />', $errors);
		}
		else {
			$blocks = new Project_Pagebuilder_Blocks();
			$blocks->withUrl(str_replace((!empty($_SERVER['HTTPS']) && 'off' !== strtolower($_SERVER['HTTPS']) ? 'https://' : 'http://') . $_SERVER['HTTP_HOST'] . '/skin/pagebuilder/', '', $_POST['frames_url']))->onlyIds()->getList($blockIds);
			if ($blocks->withIds($blockIds)->del()){
				$this->out_js['responseCode'] = 1;
				$this->out_js['content'] = "Block was deleted successfully.";
			}
			else {
				$this->out_js['responseCode'] = 0;
				$this->out_js['content'] = "Original block could not be deleted; it appears this block no longer exists.";
			}
		}
	}

	public function backend_favoriteblock(){
		if( !empty($_POST) ){
			$frames = new Project_Pagebuilder_Frames();
			$frames->setEntered(array(
				'pages_id' => 0,
				'sites_id' => 0,
				'frames_content' => $_POST['frames_content'],
				'frames_height' => $_POST['frames_height'],
				'frames_original_url' => $_POST['frames_original_url'],
				'favourite' => 1
			))->set();
			$frames->getEntered($frameData);

			if(empty($frameData)){
				$this->out_js['responseCode'] = 1;
				return;
			}
			$frame_id = $frameData['id'];
			$blockPopup='';
			if( $_POST['frames_type'] == 'popup' ){
				$fblock = new Project_Pagebuilder_Blocks();
				$fblock->setEntered(
					array(
						'blocks_category' => 31, // Popups
						'blocks_height' => $_POST['frames_height'],
						'blocks_url' => 'ifunnels-studio/getframe/?id='.$frame_id
					)
				)->set();
				$fblock->getEntered($fblockData);
				$blockPopup='p';
			}else{
				$fblock = new Project_Pagebuilder_Block_Favorite();
				$fblock->setEntered(
					array(
						'block_id' => $frame_id,
						'user_id' => Core_Users::$info['id'],
						'blocks_height' => $_POST['frames_height'],
						'blocks_url' => 'ifunnels-studio/getframe/?id=' . $frame_id
					)
				)->set();
				$fblock->getEntered($fblockData);
				
			}
			$block_id = $fblockData['id'];

			$screenshotUrl = (!empty($_SERVER['HTTPS']) && 'off' !== strtolower($_SERVER['HTTPS']) ? 'https://' : 'http://') . $_SERVER['HTTP_HOST'] . '/ifunnels-studio/loadsinglepage/?id=' . $frame_id;
			$filename = 'fblockthumb_'.$blockPopup.$block_id.'.jpg';
			$_deltaWidth=520;
			$_deltaHeight=intval( intval( $_POST['frames_height'] )*1.0/( 1024/$_deltaWidth ) );
			$screen = new Project_Pagebuilder_Screenshot();
			$screenshot = $screen->make_screenshot($screenshotUrl, $filename, $_deltaWidth.'x'.$_deltaHeight, Zend_Registry::get('config')->path->absolute->pagebuilder . 'tmp/blockthumbs/');
			if ($screenshot !== false){
				$fblock->setEntered(array('blocks_thumb' => 'tmp/blockthumbs/' . $screenshot, 'id' => $block_id))->set();
				$fblock->withIds($block_id)->onlyOne()->getList($this->out_js['block']);
				$this->out_js['responseCode'] = 1;
			}
			else{
				// screenshot failed, remove the frame and fav block
				$frames->withIds($frame_id)->del();
				$fblock->withIds($block_id)->del();
				$this->out_js['responseCode'] = 0;
			}
		}
	}

	public function backend_deleteblock(){
		$this->deleteblock();
	}

	public function b_deleteBlock(){
		$smarty = new Core_View_Smarty();
		$blocks = new Project_Pagebuilder_Blocks();

		/** Successfully deleted */
		if (!empty($_POST['block_id']) && $blocks->withIds($_POST['block_id'])->del()){
			$this->out_js['responseCode'] = 1;
		}
		/** Block stil exists, seomthing went wrong */
		else {
			$temp = array();
			$temp['header'] = "";
			$temp['content'] = "Something went wrong when deleting the block. Please try again.";

			$smarty->_smarty->assign($temp);
			$this->out_js['responseCode'] = 0;
			$this->out_js['responseHTML'] = $smarty->_smarty->fetch(__DIR__ . "/templates/site1_ecom_funnels_error.tpl");
			echo json_encode($this->out_js);
			exit;
		}
	}

	public function b_updateBlock(){
		$errors = array();
		/** All not good */
		if(empty($_POST['blockID'])){
			$errors[] = 'Block id';
		}
		if(empty($_POST['blockCategory'])){
			$errors[] = 'Block category ID';
		}
		if(empty($_POST['blockUrl'])){
			$errors[] = 'Block template URL';
		}
		
		if (!empty($errors)){
			$this->out_js['responseHTML']['header'] = "Something went wrong";
			$this->out_js['responseHTML']['content'] = "There was a problem with the submitted data. Please see the details below: " . implode(', ', $errors);
			$this->out_js['responseCode'] = 0;
		}
		else {
			$data = array();
			$data['blockDetails'] = [];
			$data['blockDetails']['blocks_category'] = $_POST['blockCategory'];
			$data['blockDetails']['blocks_url'] = str_replace(substr(Zend_Registry::get('config')->path->html->pagebuilder, 1), '', $_POST['blockUrl']);
			$data['blockDetails']['id'] = $_POST['blockID'];

        	/** Full height checkbox */
			if (!empty($_POST['blockFullHeight']))	{
				$data['blockDetails']['blocks_height'] = "90vh";
			}
			else {
				$data['blockDetails']['blocks_height'] = $_POST['blockHeight'];
			}
            /** Screenshot */
            if ( $_POST['remakeThumb'] && $_POST['remakeThumb'] == 'check') {
				$screenshot_url = (!empty($_SERVER['HTTPS']) && 'off' !== strtolower($_SERVER['HTTPS']) ? 'https://' : 'http://') . $_SERVER['HTTP_HOST'] . '/' . $_POST['blockUrl'];
				$filename = 'blockthumb_' . Project_Pagebuilder_Blocks::random_string('numeric', 12) . '.jpg';
				$_deltaWidth=600;
				$_deltaHeight=intval( intval( $data['blockDetails']['blocks_height'] )*1.0/( 1024/$_deltaWidth ) );
				$screenModel = new Project_Pagebuilder_Screenshot();
				$screenshot = $screenModel->make_screenshot($screenshot_url, $filename, $_deltaWidth.'x'.$_deltaHeight, Zend_Registry::get('config')->path->absolute->pagebuilder . 'tmp' . DIRECTORY_SEPARATOR . 'blockthumbs' . DIRECTORY_SEPARATOR);
				$data['blockDetails']['blocks_thumb'] = 'tmp/blockthumbs/' . $screenshot;
			}

			$blocks = new Project_Pagebuilder_Blocks();
			$blocks->setEntered($data['blockDetails'])->set();
			$blocks->getEntered($this->out_js['block']);

			$this->out_js['responseHTML']['header'] = "Block updated";
			$this->out_js['responseHTML']['content'] = "The block data has been updated successfully";
			$this->out_js['responseCode'] = 1;
		}
	}

	public function b_updateComponent(){
		$this->out_js['responseCode'] = 0;

		if(empty($_POST)){
			return;
		}

		$dataComponents = array(
			'id' => $_POST['componentID'],
			'components_category' => $_POST['componentCategory'],
			'components_markup' => $_POST['componentMarkup']
		);
		
		if(!empty($_FILES['componentThumbnail']['name'])){
			move_uploaded_file($_FILES['componentThumbnail']['tmp_name'], Zend_Registry::get('config')->path->absolute->pagebuilder . 'images' . DIRECTORY_SEPARATOR . 'uploads' . DIRECTORY_SEPARATOR . $_FILES['componentThumbnail']['name']);
			$dataComponents['components_thumb'] = 'images/uploads/' . $_FILES['componentThumbnail']['name'];
		}

		$components = new Project_Pagebuilder_Components();
		if($components->setEntered($dataComponents)->set()){
			$this->out_js['responseCode'] = 1;
		}
	}

	public function b_deletecomponent(){
		$components = new Project_Pagebuilder_Components();

		/** Successfully deleted */
		if (!empty($_POST['component_id']) && $components->withIds($_POST['component_id'])->del()){
			$this->out_js['responseCode'] = 1;
		}
		/** Block stil exists, seomthing went wrong */
		else {
			$this->out_js['responseCode'] = 0;
		}
	}

	public function file_edit(){
		$blocks = new Project_Pagebuilder_Blocks();
		$blocks->withIds($_GET['block_id'])->onlyOne()->getList($this->out['arrBlock']);
	}

	public function load_file(){
		if ( isset($_GET['file']) && !empty($_GET['file']) && file_exists(Zend_Registry::get('config')->path->absolute->pagebuilder . $_GET['file'])){
			$contents = file_get_contents(Zend_Registry::get('config')->path->absolute->pagebuilder . $_GET['file']);
			die(base64_encode($contents));
		}
		die();
	}

	public function save_file(){
		if ( !empty($_POST['file'])&& isset($_POST['contents'])) {
			if ( file_exists(Zend_Registry::get('config')->path->absolute->pagebuilder . urldecode($_POST['file'])) ){
				
				$contentDecoded = urldecode(base64_decode(str_replace(' ', '+', $_POST['contents'])));

				if ( file_put_contents(Zend_Registry::get('config')->path->absolute->pagebuilder . urldecode($_POST['file']), $contentDecoded) !== false ){
					$this->out_js['responseCode'] = 1;
					$this->out_js['content'] = "The file was saved successfully.";
				}
				else {
					$this->out_js['responseCode'] = 0;
					$this->out_js['content'] = "The file could not be saved. Please try again.";
				}
			}
			else {
				$this->out_js['responseCode'] = 0;
				$this->out_js['content'] = "File does not exist on server.";
			}
		} 
		else {
			$this->out_js['responseCode'] = 0;
			$this->out_js['content'] = "Content or file name missing.";
		}
	}

	public function backend_livepreview(){
		$this->livepreview();
	}

	public function backend_updateSettingsSite(){
		$this->updateSettingsSite();
	}

	public function addcomponents(){
		$this->out_js['responseCode'] = 0;

		if(empty($_POST)){
			return;
		}

		$dataComponents = array(
			'components_category' => $_POST['componentCategory'],
			'components_markup' => $_POST['componentMarkup'],
			'components_height' => 70
		);
		
		if(!empty($_FILES)){
			move_uploaded_file($_FILES['componentThumbnail']['tmp_name'], Zend_Registry::get('config')->path->absolute->pagebuilder . 'images' . DIRECTORY_SEPARATOR . 'uploads' . DIRECTORY_SEPARATOR . $_FILES['componentThumbnail']['name']);
			$dataComponents['components_thumb'] = 'images/uploads/' . $_FILES['componentThumbnail']['name'];
		}

		$components = new Project_Pagebuilder_Components();
		if($components->setEntered($dataComponents)->set()){
			$this->out_js['responseCode'] = 1;
		}
	}

	public function template2group(){
		if ( !empty( $_POST['change_group'] ) ){
			$this->location( array( 'w'=>'group_id='.$_POST['arrR']['group_id'] ) );
		}
		$_groups=new Core_Acs_Groups();
		$_groups->toSelect()->getList( $this->out['arrG'] );
		$_t2g=new Project_Pagebuilder_Access_Template();
		if(!empty($_GET['group_id'])){
			$_t2g->withGroupIds( $_GET['group_id'] )->getList( $_selectedTemplates );
		}
		$this->out['selectedTemplates']=array();
		foreach( $_selectedTemplates as $_template ){
			$this->out['selectedTemplates'][]=$_template['template_id'];
		}
		if(isset($_POST['save'])){
			$_arrData=array();
			$_t2g->withGroupIds( $_POST['arrR']['group_id'] )->del();
			foreach( $_POST['arrT'] as $_t ){
				$_arrData[]=array(
					'template_id'=> $_t, 
					'group_id'=> $_POST['arrR']['group_id']
				);
			}
			$_t2g->setEntered( $_arrData )->set();
			$this->location( array( 'w'=>'group_id='.$_POST['arrR']['group_id'] ) );
		}
		$sites=new Project_Pagebuilder_Sites();
		$sites->isTemplate()->getList( $this->out['arrTemplates'] );
	}

	public function block2group(){
		if ( !empty( $_POST['change_group'] ) ){
			$this->location( array( 'w'=>'group_id='.$_POST['arrR']['group_id'] ) );
		}
		$_groups=new Core_Acs_Groups();
		$_groups->toSelect()->getList( $this->out['arrG'] );
		$_b2g=new Project_Pagebuilder_Access_Block();
		if(!empty($_GET['group_id'])){
			$_b2g->withGroupIds( $_GET['group_id'] )->getList( $_selectedBlocks );
		}
		$this->out['selectedBlocks']=array();
		foreach( $_selectedBlocks as $_block ){
			$this->out['selectedBlocks'][]=$_block['block_id'];
		}
		if(isset($_POST['save'])){
			$_arrData=array();
			$_b2g->withGroupIds( $_POST['arrR']['group_id'] )->del();
			foreach( $_POST['arrB'] as $_b ){
				$_arrData[]=array(
					'block_id'=> $_b, 
					'group_id'=> $_POST['arrR']['group_id']
				);
			}
			$_b2g->setEntered( $_arrData )->set();
			$this->location( array( 'w'=>'group_id='.$_POST['arrR']['group_id'] ) );
		}
		$blocks=new Project_Pagebuilder_Blocks();
		$blocks->getList( $this->out['arrBlocks'] );
	}

	public function backend_resizeImage(){
		$this->resizeImage();
	}

	public function backend_delimage(){
		$this->delimage();
	}

	/**
	 * Frontend actions
	 */

	public function favoriteblock(){
		if (!empty($_POST)){
			$frames = new Project_Pagebuilder_Frames();
			$frames->setEntered(array(
				'pages_id' => 0,
				'sites_id' => 0,
				'frames_content' => $_POST['frames_content'],
				'frames_height' => $_POST['frames_height'],
				'frames_original_url' => $_POST['frames_original_url'],
				'favourite' => 1
			))->set();
			$frames->getEntered($frameData);

			if(empty($frameData)){
				$this->out_js['responseCode'] = 1;
				return;
			}

			$frame_id = $frameData['id'];
			$fblock = new Project_Pagebuilder_Block_Favorite();
			$fblock->setEntered(
				array(
					'block_id' => $frame_id,
					'user_id' => Core_Users::$info['id'],
					'blocks_height' => $_POST['frames_height'],
					'blocks_url' => 'ifunnels-studio/getframe/?id=' . $frame_id
				)
			)->set();
			$fblock->getEntered($fblockData);
			$block_id = $fblockData['id'];

			$screenshotUrl = (!empty($_SERVER['HTTPS']) && 'off' !== strtolower($_SERVER['HTTPS']) ? 'https://' : 'http://') . $_SERVER['HTTP_HOST'] . '/ifunnels-studio/loadsinglepage/?id=' . $frame_id;
			$filename = 'fblockthumb_' . $block_id . '.jpg';
			$_deltaWidth=520;
			$_deltaHeight=intval( intval( $_POST['frames_height'] )*1.0/( 1024/$_deltaWidth ) );
			$screen = new Project_Pagebuilder_Screenshot();
			$screenshot = $screen->make_screenshot($screenshotUrl, $filename, $_deltaWidth.'x'.$_deltaHeight, Zend_Registry::get('config')->path->absolute->pagebuilder . 'tmp/blockthumbs/');
			if ($screenshot !== false){
				$fblock->setEntered(array('blocks_thumb' => 'tmp/blockthumbs/' . $screenshot, 'id' => $block_id))->set();

				$fblock->withIds($block_id)->onlyOne()->getList($this->out_js['block']);
				$this->out_js['responseCode'] = 1;
			}
			else{
				// screenshot failed, remove the frame and fav block
				$frames->withIds($frame_id)->del();
				$fblock->withIds($block_id)->del();
				$this->out_js['responseCode'] = 0;
			}
		}
	}

	public function deleteblock(){
		$fblock = new Project_Pagebuilder_Block_Favorite();
		if($fblock->withIds($_POST['id'])->del()){
			$this->out_js['responseCode'] = 1;
		} else {
			$this->out_js['responseCode'] = 0;
		}
	}

	public function updatePageData(){
		$smarty = new Core_View_Smarty();
		if ($_POST['arrData']['sites_id'] == '' || $_POST['arrData']['sites_id'] == 'undefined' || ! isset($_POST)){
			$temp = array();
			$temp['header'] = 'Ouch! Something went wrong:';
			$temp['content'] = 'The site ID is missing or corrupt. Please try reloading the page and then try deleting the site once more.';

			$smarty->_smarty->assign($temp);
			$this->out_js['responseCode'] = 0;
			$this->out_js['responseHTML'] = $smarty->_smarty->fetch(__DIR__ . "/templates/site1_ecom_funnels_error.tpl");
			echo json_encode($this->out_js);
			exit;
		}

		/** Update page data */
		$pages = new Project_Pagebuilder_Pages();
		$pages->setEntered($_POST['arrData'])->set();

		$pages->withPageId($_POST['arrData']['site_id'])->getList($pagesData);

		$pagesData = $this->pagemodel->getPageData($_POST['siteID']);
		if (!empty($pagesData)){
			$this->out_js['pagesData'] = array();
			foreach ($pagesData as $page){
				// Include all frames for this page
				$frames = new Project_Pagebuilder_Frames();
				$frames->withPageId($page['id'])->withRevision(0)->getList($page['frames']);
				$out_js['pagesData'][$page['pages_name']] = $page;
			}
		}

		$temp = array();
		$temp['header'] = 'All set!';
		$temp['content'] = 'The page settings were successfully updated.';

		$smarty->_smarty->assign($temp);
		$this->out_js['responseCode'] = 1;
		$this->out_js['responseHTML'] = $smarty->_smarty->fetch(__DIR__ . "/templates/site1_ecom_funnels_success.tpl");
		echo json_encode($this->out_js);
		exit;
	}

	public function delimage(){
		if (isset($_POST['image']) && $_POST['image'] != ''){
			$user_id = Core_Users::$info['id'];
			$temp = explode("/", $_POST['image']);
			$fileName = array_pop( $temp );
			$userDirID = array_pop( $temp );
			if ($user_id == $userDirID){
				unlink($_SERVER['DOCUMENT_ROOT'] . Zend_Registry::get('config')->path->html->user_data . $user_id . "/" . $fileName);
			}
		}
	}

	public function getframe(){
		if(!empty($_GET['id'])){
			$frames = new Project_Pagebuilder_Frames();
			$frames->withIds($_GET['id'])->onlyOne()->getList($this->out);
		}
	}

	public function save(){
		$smarty = new Core_View_Smarty();
		$model = new Project_Pagebuilder_Sites();

		/** Do we have the required data? */
		if( ! isset( $_POST['siteData'] ) ) {
			$temp = array();
			$temp['header'] = "Ouch! Something went wrong:";
			$temp['content'] = "The siteData is missing, please try again.";
			$smarty->_smarty->assign( $temp );
			$this->out_js['responseCode'] = 0;
			$this->out_js['responseHTML'] = $smarty->_smarty->fetch( __DIR__ . "/templates/site1_ecom_funnels_error.tpl" );
			echo json_encode($this->out_js);
			exit;
		}

		/** Do we have some frames to save? */
		if( ( ! isset( $_POST['pages'] ) || $_POST['pages'] == '' ) && ( ! isset( $_POST['toDelete'] ) ) ) {
			$temp = array();
			$temp['header'] = "Ouch! Something went wrong:";
			$temp['content'] = "There's noting to save. Try making some changes and saving again.";
			$smarty->_smarty->assign( $temp );
			$this->out_js['responseCode'] = 0;
			$this->out_js['responseHTML'] = $smarty->_smarty->fetch( __DIR__ . "/templates/site1_ecom_funnels_error.tpl" );
			echo json_encode( $this->out_js );
			exit;
		}

		/** Should we save an existing site or create a new one? */
		$model->setEntered( $_POST )->set();
		$model->getEntered( $siteData );

		/** Delete any pages? */
		if( isset( $_POST['toDelete'] ) && is_array( $_POST['toDelete'] ) && count( $_POST['toDelete'] ) > 0 ) {
			foreach ($_POST['toDelete'] as $page){
				$pages = new Project_Pagebuilder_Pages();
				$pages
					->withSiteId( $_POST['siteData']['id'] )
					->withPageName( $page )
					->onlyIds()
					->getList( $arrPages );

				if( ! empty( $arrPages ) ){
					$pages
						->withIds( $arrPages )
						->del();
				}
			}
		}

		if( ! empty( $siteData['siteData']['settings'] ) && $_POST['autosave'] === 'false'){
			$dir = 'Project_Pagebuilder@generate' . DIRECTORY_SEPARATOR . 'source';
			Zend_Registry::get( 'objUser' )->prepareTmpDir( $dir );
			$_placement = new Project_Placement();
			$_placement
				->withIds( $siteData['siteData']['settings']['placement_id'] )
				->onlyOne()
				->getList( $_place );

			$_newUrl = '';
			if( $_place['flg_type'] == Project_Placement::REMOTE_HOSTING ){
				$_newUrl = $siteData['siteData']['url'];
			} elseif( isset( $_place['domain_http'] ) ) {
				$_newUrl = 'http://' . $_place['domain_http'] . $siteData['siteData']['settings']['ftp_directory'];
			}

			$model
				->setDir( $dir )
				->export( $siteData['id'], $_newUrl );

			$_transport = new Project_Placement_Transport();
			$_transport
				->setInfo( 
					array(
						'publishing_options' => $siteData['siteData']['settings']['publishing_options'], 
						'siteID' => $siteData['id'], 
						'placement_id' => $siteData['siteData']['settings']['placement_id'],
						'ftp_directory' => $siteData['siteData']['settings']['ftp_directory']
					)
				)
				->setSourceDir( $dir )
				->placeAndBreakConnect();

			$model
				->setEntered( 
					array( 
						'id' => $siteData['id'], 
						'url' => $_newUrl, 
						'settings' => $_transport->getInfo()
					)
				)->set();

				
			if ($_place['flg_type'] == Project_Placement::LOCAL_HOSTING_SUBDOMEN) {
				$_newUrl = explode('.', parse_url($_newUrl, PHP_URL_HOST));
				array_splice($_newUrl, 0, 1);
				$_newUrl = implode('.', $_newUrl);
			} else {
				$_newUrl = parse_url($_newUrl, PHP_URL_HOST);
			}

			// Clear cache in CloudFlare
			Project_Pagebuilder_Markup::clearCache($_newUrl);
		}
		
		/** Regular site save */
		if( $forPublish == 0 ){
			$temp = array();
			$temp['header'] = "Success!";
			$temp['content'] = "The site has been saved successfully!";
		}
		/** Saving before publishing, requires different message */
		else if( $forPublish == 1 ){
			$temp = array();
			$temp['header'] = "Success!";
			$temp['content'] = "The site has been saved successfully! You can now proceed with publishing your site.";
		}

		$smarty
			->_smarty
			->assign( $temp );

		$this->out_js['responseCode'] = 1;
		$this->out_js['responseHTML'] = $smarty->_smarty->fetch( __DIR__ . "/templates/site1_ecom_funnels_success.tpl" );

		echo json_encode( $this->out_js );
		exit;
	}

	public function livepreview(){
		$model = new Project_Pagebuilder_Sites();

		if (isset($_POST['siteID']) && $_POST['siteID'] != ''){
			$model->withIds( $_POST['siteID'] )->onlyOne()->getList($siteData);
		}

		$meta = '';
		/** Page title */
		if (isset($_POST['meta_title']) && $_POST['meta_title'] != ''){
			$meta .= '<title>' . $_POST['meta_title'] . '</title>' . "\n";
		}
		/** Page meta description */
		if (isset($_POST['meta_description']) && $_POST['meta_description'] != ''){
			$meta .= '<meta name="description" content="' . $_POST['meta_description'] . '"/>' . "\n";
		}
		/** Page meta keywords */
		if (isset($_POST['meta_keywords']) && $_POST['meta_keywords'] != ''){
			$meta .= '<meta name="keywords" content="' . $_POST['meta_keywords'] . '"/>' . "\n";
		}
		/** Replace meta value */
		$content = str_replace('<!--pageMeta-->', $meta, "<!DOCTYPE html>\n" . base64_decode($_POST['page']));

		/** Replace both inline css image url and image tag src */
		$content = str_replace('../bundles', Zend_Registry::get('config')->path->html->pagebuilder . 'elements/bundles', $content);
		//$content = str_replace('bundles', '/skin/pagebuilder/elements/bundles', $content);

		$head = '';
		/** Page header includes */
		if (isset($_POST['header_includes']) && $_POST['header_includes'] != ''){
			$head .= $_POST['header_includes'] . "\n";
		}

		/** Deal with global CSS and page CSS **/
		$custom_css = "";

		$doc = str_get_html($content);

		$custom_script = '';
		foreach ($doc->find('*[data-effects]') as $key=>$element){
			$_effectType=$element->getAttribute('data-effects');
			if( $_effectType != 'none' ){
				$_effectDelay=(int)$element->getAttribute('data-delayef');
				$_effectId=$element->getAttribute('data-id');
				if( strpos( $element->class, 'hide' ) === false ){
					$_beforeElt=$element->outertext;
					$element->class=$element->class.' hide';
					$content=str_replace( $_beforeElt, $element->outertext, $content );
				}
				$custom_script.='//document.querySelector(\'[data-id="'.$_effectId.'"]\').classList.add("hide");
				setTimeout( function(){
					document.querySelector(\'[data-id="'.$_effectId.'"]\').classList.remove("hide");
					document.querySelector(\'[data-id="'.$_effectId.'"]\').classList.add("animated","'.$_effectType.'");
				}, '.( $_effectDelay*1000+1).' );
				';
			}
		}

		$doc = str_get_html($content);

		if (isset($siteData['global_css']) && $siteData['global_css'] != ''){
			$custom_css .= $siteData['global_css']."\n";
		}

		if (isset($_POST['page_css']) && $_POST['page_css'] != ''){
			$custom_css .= $_POST['page_css'];
		}

		if ($custom_css !== ''){
			$content = str_replace("</head>", "\n<style>\n" . $custom_css . "\n</style>\n</head>", $content);
		}
		
		if ($custom_script !== ''){
			$content = str_replace("</body>", "\n<script type=\"text/javascript\">\nwindow.onload = function() {\n" . $custom_script . "\n};\n</script>\n</body>", $content);
		}

		foreach ($doc->find('*[data-component="code"]') as $key=>$element){
			$_code=$element->find('.code', 0)->getAttribute('data-option');
			$_parseCode=base64_decode( $_code );
			if( $_parseCode !== false ){
				$content = str_replace( $doc->find('*[data-component="code"]', $key)->outertext, '<div>'.$_parseCode.'</div>', $content );
			}
		}		

		$content = str_replace( 'contenteditable="true"', '', $content );
		$content = str_replace( 'sb_open', '', $content );
		$htmlBase = new simple_html_dom();
		
		$htmlBase->load( $content );
		foreach($htmlBase->find('div[data-prntid]') as $element) {
			if( $element->attr["data-options"] == '#' ){
				$element->attr["style"]=str_replace( 'display: none;', '', $element->attr["style"] );
			}else{
				if( strpos( $element->attr["style"], 'display: none;' ) === false ){
					$element->attr["style"].='; display: none;';
				}
			}
		}
		$content=''.$htmlBase;
		$htmlBase->clear();
		unset($htmlBase);
		
		foreach ($doc->find('*[data-component="countdown"]') as $key=>$element){
		//	$_code=$element->find('.code', 0)->getAttribute('data-option');
		//	$_parseCode=base64_decode( $_code );
		//	if( $_parseCode !== false ){
		//		$content = str_replace( $doc->find('*[data-component="code"]', $key)->outertext, '<div>'.$_parseCode.'</div>', $content );
		//	}
		}

		/** Custom header to deal with XSS protection */
		header("X-XSS-Protection: 0");
		echo str_replace('<!--headerIncludes-->', $head, $content);
	}

	public function pageData(){
		$this->out_js = array();
		$pageFrames = array();

		if( ! empty( $_GET['pageID'] ) ){
			$pages = new Project_Pagebuilder_Pages();
			$pages->withIds( $_GET['pageID'] )->onlyOne()->getList( $arrPageData );
	
			$frames = new Project_Pagebuilder_Frames();
			$frames->withPageId( $arrPageData['id'] )->withOrder( 'position--dn' )->getList( $arrFrames );

			foreach( $arrFrames as $_key => $frame ){
				if( $frame['pages_id'] != $arrPageData['id'] ){
					unset( $arrFrames[$_key] );
				}
			}

			$pageDetails = array();
			foreach( $arrFrames as $key => $frame ){
				if( empty( $frame['frames_popup'] ) ){
					$pageDetails['blocks'][] = $frame;
				} else {
					$pageDetails['popups'][] = $frame;
				}
			}

			$pageDetails['page_id'] = $arrPageData['id'];
			$pageDetails['pages_title'] = $arrPageData['pages_title'];
			$pageDetails['meta_description'] = $arrPageData['pages_meta_description'];
			$pageDetails['meta_keywords'] = $arrPageData['pages_meta_keywords'];
			$pageDetails['header_includes'] = $arrPageData['pages_header_includes'];
			$pageDetails['page_css'] = $arrPageData['pages_css'];
			$pageDetails['google_fonts'] = json_decode( $arrPageData['google_fonts'] );
			$pageDetails['header_script'] = $arrPageData['pages_header_script'];
			$pageDetails['footer_script'] = $arrPageData['pages_footer_script'];
			$pageDetails['drip_feed'] = ['enable' => 0, 'after_period' => 'month', 'value' => null];

			$pageFrames[$arrPageData['pages_name']] = $pageDetails;
		}

		$this->out_js['page'] = $pageFrames;
	}
	
	public function siteData(){
		$this->out_js = array();
		if (!empty($_SESSION['templateID'])){
			$sites = new Project_Pagebuilder_Sites();
			$sites->withIds($_SESSION['templateID'])->onlyOne()->getList($this->out['site']);

			$pages = new Project_Pagebuilder_Pages();
			$pages->withSiteId($_SESSION['templateID'])->withOrder('id--dn')->getList($arrPages);
			
			$pageFrames = array();
			foreach ($arrPages as $page){

				$frames = new Project_Pagebuilder_Frames();
				$frames->withPageId($page['id'])->withOrder('position--dn')->getList($arrFrames);
				foreach ($arrFrames as $_key=>$frame){
					if( $frame['sites_id'] != $_SESSION['templateID'] ){
						unset( $arrFrames[$_key] );
					}
				}
				$pageDetails = array();
				foreach ($arrFrames as $key => $frame) {
					if( empty( $frame['frames_popup'] ) ) {
						$pageDetails['blocks'][] = $frame;
					} else {
						$pageDetails['popups'][] = $frame;
					}
				}
				$pageDetails['page_id'] = $page['id'];
				$pageDetails['pages_title'] = $page['pages_title'];
				$pageDetails['meta_description'] = $page['pages_meta_description'];
				$pageDetails['meta_keywords'] = $page['pages_meta_keywords'];
				$pageDetails['header_includes'] = $page['pages_header_includes'];
				$pageDetails['page_css'] = $page['pages_css'];
				$pageDetails['google_fonts'] = json_decode($page['google_fonts']);
				$pageDetails['header_script'] = $page['pages_header_script'];
				$pageDetails['footer_script'] = $page['pages_footer_script'];

				$pageFrames[$page['pages_name']] = $pageDetails;
			}

			$this->out_js['pages'] = $pageFrames;
			$this->out_js['templateID'] = $_SESSION['templateID'];
		} else {
			$sites = new Project_Pagebuilder_Sites();
			if( empty( $_SESSION['siteID'] ) ) {
				$_SESSION['siteID'] = $_GET['id'];
			}
			$this->out_js = $sites->onlyOwner()->getSite($_SESSION['siteID']);
		}

		if (isset($this->out_js['assetFolders'])) unset($this->out_js['assetFolders']);

		$this->out_js['is_admin'] = 1;
		$this->out_js['fonts'] = array(
			array(
				"nice_name" => "Abril Fatface",
				"css_name" => "'Abril Fatface', sans-serif",
				"api_entry" => "Abril Fatface"
			), 
			array(
				"nice_name" => "Alegreya Sans",
				"css_name" => "'Alegreya Sans', sans-serif",
				"api_entry" => "Alegreya Sans"
			),
			array(
				"nice_name" => "Anton",
				"css_name" => "'Anton', sans-serif",
				"api_entry" => "Anton"
			),
			array(
				"nice_name" => "Bree Serif",
				"css_name" => "'Bree Serif', sans-serif",
				"api_entry" => "Bree Serif"
			),
			array(
				"nice_name" => "Nanum Brush Script",
				"css_name" => "'Nanum Brush Script', sans-serif",
				"api_entry" => "Nanum Brush Script"
			),
			array(
				"nice_name" => "Patua One",
				"css_name" => "'Patua One', sans-serif",
				"api_entry" => "Patua One"
			),
			array(
				"nice_name" => "Architects Daughter",
				"css_name" => "'Architects Daughter', sans-serif",
				"api_entry" => "Architects Daughter"
			),
			array(
				"nice_name" => "Give You Glory",
				"css_name" => "'Give You Glory', sans-serif",
				"api_entry" => "Give You Glory"
			),
			array(
				"nice_name" => "Gochi Hand",
				"css_name" => "'Gochi Hand', sans-serif",
				"api_entry" => "Gochi Hand"
			),
			array(
				"nice_name" => "Kaushan Script",
				"css_name" => "'Kaushan Script', sans-serif",
				"api_entry" => "Kaushan Script"
			),
			array(
				"nice_name" => "La Belle Aurore",
				"css_name" => "'La Belle Aurore', sans-serif",
				"api_entry" => "La Belle Aurore"
			),
			array(
				"nice_name" => "Loved by the King",
				"css_name" => "'Loved by the King', sans-serif",
				"api_entry" => "Loved by the King"
			),
			array(
				"nice_name" => "Marck Script",
				"css_name" => "'Marck Script', sans-serif",
				"api_entry" => "Marck Script"
			),
			array(
				"nice_name" => "Over the Rainbow",
				"css_name" => "'Over the Rainbow', sans-serif",
				"api_entry" => "Over the Rainbow"
			),
			array(
				"nice_name" => "Walter Turncoat",
				"css_name" => "'Walter Turncoat', sans-serif",
				"api_entry" => "Walter Turncoat"
			),
			array(
				"nice_name" => "Yellowtail",
				"css_name" => "'Yellowtail', sans-serif",
				"api_entry" => "Yellowtail"
			),
			array(
				"nice_name" => "Cinzel",
				"css_name" => "'Cinzel', sans-serif",
				"api_entry" => "Cinzel"
			),
			array(
				"nice_name" => "Exo",
				"css_name" => "'Exo', sans-serif",
				"api_entry" => "Exo"
			),
			array(
				"nice_name" => "Lato",
				"css_name" => "'Lato', sans-serif",
				"api_entry" => "Lato"
			),
			array(
				"nice_name" => "Magra",
				"css_name" => "'Magra', sans-serif",
				"api_entry" => "Magra"
			),
			array(
				"nice_name" => "Oxygen",
				"css_name" => "'Oxygen', sans-serif",
				"api_entry" => "Oxygen"
			),
			array(
				"nice_name" => "Permanent Marker",
				"css_name" => "'Permanent Marker', sans-serif",
				"api_entry" => "Permanent Marker"
			),
			array(
				"nice_name" => "Rambla",
				"css_name" => "'Rambla', sans-serif",
				"api_entry" => "Rambla"
			),
			array(
				"nice_name" => "Signika Negative",
				"css_name" => "'Signika Negative', sans-serif",
				"api_entry" => "Signika Negative"
			),
			array(
				"nice_name" => "Titillium Web",
				"css_name" => "'Titillium Web', sans-serif",
				"api_entry" => "Titillium Web"
			)
		);
		$this->out_js['language'] = array(
			"front_end_spectrum_cancel" => "Cancel",
			"front_end_spectrum_choose" => "Choose",
			"styles" => array(
				"padding-top" => "Padding top",
				"padding-bottom" => "Padding bottom",
				"padding-left" => "Padding left",
				"padding-right" => "Padding right",
				"margin-top" => "Margin top",
				"margin-bottom" => "Margin bottom",
				"margin-left" => "Margin left",
				"margin-right" => "Margin right",
				"height" => "Height",
				"width" => "Width",
				"color" => "Color",
				"font-size" => "Font size",
				"font-weight" => "Font weight",
				"text-transform" => "Text transform",
				"text-align" => "Text align",
				"background-color" => "Background color",
				"background-color-overlay" => "Background overlay",
				"background-position" => "Background position",
				"parallax" => "Parallax",
				"background-image" => "Background image",
				"border-top-left-radius" => "Top left radius",
				"border-top-right-radius" => "Top right radius",
				"border-bottom-left-radius" => "Bottom left radius",
				"border-bottom-right-radius" => "Bottom right radius",
				"border-color" => "Border color",
				"border-style" => "Border style",
				"border-width" => "Border width",

				"countdown-value" => "Value",
				"countdown-delay" => "Timer delay",
				"countdown-textcolor" => "Text color",
				"countdown-panelcolor" => "Panel color",
				"countdown-labelcolor" => "Labels Color",
				"countdown-redirect" => "Action URL",
				"linkText" => "Text",
				
				"content" => "Content",
				"btn-style" => "Button style",
				"btn-size" => "Button size",
				"btn-block" => "Button block",
				"hover-background-color" => "Hover Background Color"
			)
		);

		$this->out_js['settings']['popup_wrapping_html'] = '<div class="modal fade" tabindex="-1" role="dialog" %s><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button><div class="modal-dialog modal-lg" role="document"><div class="modal-content"><div class="modal-body">%s</div></div></div></div>';
	}

	public function create(){
		header( 'Access-Control-Allow-Origin: *' ); 
		unset( $_SESSION['templateID'] );

		$sites = new Project_Pagebuilder_Sites();
		$pages = new Project_Pagebuilder_Pages();
		
		$_arrGroupsids = array();
		$_group = new Core_Acs_Groups();
		$_group->bySysName( Core_Users::$info['groups'] )->getList( $_arrCurrentGroups );
		
		
		foreach( $_arrCurrentGroups as $_i ){
			$_arrGroupsids[$_i['id']] = $_i['id'];
		}
		
		$_t2g = new Project_Pagebuilder_Access_Template();
		$_t2g->withGroupIds( $_arrGroupsids )->getList( $_accessTemplatesIds );

		if( ! empty( $_accessTemplatesIds ) ){
			$_templateIds = array();
			foreach( $_accessTemplatesIds as $_accessTemplateId ){
				$_templateIds[] = $_accessTemplateId['template_id'];
			}
			$sites
				->isTemplate()
				->withIds( $_templateIds )
				->getList( $this->out['arrTemplates'] );
		} else {
			$this->out['arrTemplates'] = array();
		}

		$category = new Project_Pagebuilder_Category_Template();
		if( ! empty( array_column( $this->out['arrTemplates'], 'category_id' ) ) ){
			$category
				->withIds( array_column( $this->out['arrTemplates'], 'category_id') )
				->getList( $this->out['arrCategory'] );
	
			if( array_search( '0', array_column( $this->out['arrTemplates'], 'category_id' ) ) !== false ){
				array_unshift( $this->out['arrCategory'], array( 'id' => 0, 'category_name' => 'No specific category' ) );
			}
		}
		
		if( isset( $_GET['new'] ) ){
			$sites = new Project_Pagebuilder_Sites();
			$site_id = $sites->createNew( $_GET['template'] );
			
			unset( $_GET['new'] );
			unset( $_GET['template'] );
			$_SESSION['siteID'] = $site_id;
			$this->location( 
				[
					'action' => 'create', 
					'wg' => [
						'id' => $site_id, 
						'p' => Project_Pagebuilder_Sites::getFirstPage($site_id)
					] 
				] 
			);
		}

		if( ! empty( $_GET['id'] ) ){
			unset( $_SESSION['templateID'] );
			$siteID = $_GET['id'];
			require_once Zend_Registry::get( 'config' )->path->relative->library . 'Helper/directory_helper.php';
	
			/** Store the session ID with this session */
			$_SESSION['siteID'] = $siteID;

			$sites = new Project_Pagebuilder_Sites();	
			$siteData = $sites->getSite( $siteID );
	
			if ($siteData !== FALSE) {
				$this->out['siteData'] = $siteData;
	
				// /** Get page data */
				// $pages = new Project_Pagebuilder_Pages();
				// $pages->withSiteId( $siteID )->withOrder( 'id--dn' )->getList( $arrPages );
				// if( ! empty( $arrPages ) ){
				// 	$pagesData = array();
				// 	if( isset( $_GET['pageid'] ) ){
				// 		$_SESSION['pageID'] = $_GET['pageid'];
				// 	} else {
				// 		$_SESSION['pageID'] = $arrPages[0]['id'];
				// 	}

				// 	foreach( $arrPages as $page ){
				// 		$frames = new Project_Pagebuilder_Frames();
				// 		$frames->withPageId( $page['id'] )->withRevision( 0 )->getList( $page['frames'] );
				// 		$pagesData[$page['pages_name']] = $page;
				// 	}
				// }

				if( ! empty( $pagesData ) ) {
					$this->out['pagesData'] = $pagesData;
				}
	
				/** Collect data for the image library */
				$userID = Core_Users::$info['id'];
				$this->out['userImages'] = array();
				if( is_dir( Zend_Registry::get( 'config' )->path->relative->user_data . "/" . $userID ) ){
					$folderContent = directory_map( Zend_Registry::get( 'config' )->path->relative->user_data . "/" . $userID, 2 );
					if( $folderContent ){
						foreach( $folderContent as $key => $item ){
							if( ! is_array($item)){
								/** check the file extension */
								$ext = pathinfo( $item, PATHINFO_EXTENSION );
								/** prep allowed extensions array */
								if ( in_array( $ext, array( "jpg", "png", "gif", "svg" ) ) ){
									array_push( $this->out['userImages'], $item );
								}
							}
						}
					}
				}
	
				$this->out['adminImages'] = array();
				$folderContent = directory_map( Zend_Registry::get( 'config' )->path->relative->root . 'skin/pagebuilder/images', 2 );

				if( $folderContent ){
					foreach( $folderContent as $key => $item ){
						if( ! is_array( $item ) ){
							/** check the file extension */
							$ext = pathinfo( $item, PATHINFO_EXTENSION );
							if( in_array( $ext, array( "jpg", "png", "gif", "svg" ) ) ){
								array_push( $this->out['adminImages'], $item );
							}
						}
					}
				}
				$this->out['templates'] = null;
	
			// 	/** Grab all revisions */
			// 	$this->out['revisions'] = array();
			// 	$pages = new Project_Pagebuilder_Pages();
			// 	$pages
			// 		->withIds( $siteID )
			// 		->withPageName( 'index' )
			// 		->onlyOne()
			// 		->getList( $page );

			// 	if ( ! empty( $page ) ){
			// 		$page_id = $page['id'];
			// 		$this->out['revisions'] = Core_Sql::getAssoc( 'SELECT DISTINCT frames_timestamp FROM pb_frames WHERE sites_id='. $siteID . " AND revision=1 AND pages_id=" . $page_id . " ORDER BY frames_timestamp DESC" );
			// 	}

				$this->out['package'] = array();
				$blockCategory = new Project_Pagebuilder_Category_Blocks();
				$blockCategory->withOrder( 'id--up' )->getList( $this->out['blockCategories'] );
				$this->out['whitelabel_general'] = array();
			}

			$company = new Project_Mooptin();
			$company->onlyOwner()->getList( $this->out['arrLeadChannels'] );

			$sites
				->withoutIds( array( $_GET['id'] ) )
				->onlyOwner()
				->getList( $this->out['arrUserSites'] );

			if( ! empty( $this->out['arrUserSites'] ) ) {
				foreach( $this->out['arrUserSites'] as &$site ) {
					$pages
						->withSiteId( $site['id'] )
						->withOrder( 'id--dn' )
						->getList( $site['arrPages'] );
				}
			}

			$membership = new Project_Deliver_Membership();
			$membership
				->withSiteName()
				->onlyOwner()
				->getList( $this->out['arrMemberships'] );

			$membership
				->withSiteName()
				->onlyOnetime()
				->onlyOwner()
				->getList( $this->out['oneTimeMemberships'] );

			$this->out['group_membership'] = [];
			foreach ($this->out['oneTimeMemberships'] as $value) {
				$this->out['group_membership'][$value['site_name']][] = $value;
			}
		}
		
		foreach( $this->out['arrTemplates'] as &$_template ){
			$pages
				->withSiteId( $_template['id'] )
				->withOrder( 'id--dn' )
				->getList( $_template['arrPages'] );
		}

		$_model = new Project_Placement();
		$_model
			->withType( 
				array( 
					Project_Placement::LOCAL_HOSTING, 
					Project_Placement::LOCAL_HOSTING_DOMEN,
					Project_Placement::LOCAL_HOSTING_SUBDOMEN,
					Project_Placement::IFUNELS_HOSTING
				) 
			)
			->withOptgroup()
			->onlyOwner()
			->getList( $this->out['arrPlacements'] );
	}

	public function loadAll(){
		$category = new Project_Pagebuilder_Category_Blocks();
		$blocks = new Project_Pagebuilder_Blocks();

		if(empty($_SESSION['templateID'])){
			$_arrGroupsids=array();
			$_group=new Core_Acs_Groups();
			$_group->bySysName( Core_Users::$info['groups'] )->getList( $_arrCurrentGroups );
			
			foreach( $_arrCurrentGroups as $_i ){
				$_arrGroupsids[$_i['id']]=$_i['id'];
			}
			
			$_b2g=new Project_Pagebuilder_Access_Block();
			$_b2g->withGroupIds( $_arrGroupsids )->getList( $_accessBlockIds );

			if(!empty( $_accessBlockIds)){
				$_blockIds=array();
				foreach( $_accessBlockIds as $_accessBlockId ){
					$_blockIds[]=$_accessBlockId['block_id'];
				}
				$blocks->withIds($_blockIds)->withOrder('id--dn')->getList($arrBlocks);
			} else {
				$arrBlocks=array();
			}
		} else {
			$blocks->withOrder('id--dn')->getList($arrBlocks);
		}

		$category->withIds(array_column($arrBlocks['blocks_category']))->withOrder('id--dn')->getList($arrCategoryesBlocks);
		
		$this->out = [];
		foreach($arrCategoryesBlocks as $category){
			$this->out['elements'][$category['category_name']] = [];
			foreach($arrBlocks as $block){
				if($category['id'] == $block['blocks_category']){
					$this->out['elements'][$category['category_name']][] = $block;
				}
			}
			if($category['id'] == 1) {
				$this->out['elements'][$category['category_name']] = $arrBlocks;
			}
		}
		$fblock = new Project_Pagebuilder_Block_Favorite();
		$fblock->onlyOwner()->getList( $arrFBlock );
		if(!empty($arrFBlock)){
			$this->out['elements'] = array('Saved blocks' => $arrFBlock) + $this->out['elements'];
		}
		$category = new Project_Pagebuilder_Category_Components();
		$category->withOrder('id--up')->getList($arrCategoryesComponents);

		$components = new Project_Pagebuilder_Components();
		$components->withOrder('id--up')->getList($arrComponents);
		foreach($arrCategoryesComponents as $category){
			/** группа Studio Free: - доступ к Studio модулю (только без доступа к функционалу Share и без компонента Quiz */
			if( Core_Acs::haveAccess( array( 'Studio Free' ) ) 
				&& !( Core_Acs::haveAccess( array( 'iFunnels Studio Starter' ) ) || Core_Acs::haveAccess( array( 'iFunnels LTD Studio Starter' ) ) || Core_Acs::haveAccess( array( 'iFunnels Studio Elite' ) ) ) 
				&& $category['category_name'] == 'Quiz' ){
				continue;
			}
			$this->out['components'][$category['category_name']] = [];
			foreach($arrComponents as $component){
				if($category['id'] == $component['components_category']){
					$this->out['components'][$category['category_name']][] = $component;
				}
			}
		}
		
		$this->out = json_encode($this->out);
		echo str_replace("\\n", "", $this->out);
		exit();
	}

	public function ajax(){
		if( isset( $_POST['pageid'] ) && isset( $_POST['pagename'] ) ){
			Core_Sql::setExec( 'UPDATE pb_pages SET pages_name='.Core_Sql::fixInjection( $_POST['pagename'] ).' WHERE id='.Core_Sql::fixInjection( $_POST['pageid'] ) );
			$this->out_js['responseCode'] = 1;
		}

		$input = json_decode(file_get_contents('php://input'));

		if ($input !== false) {
			switch ($input->action) {
				case 'test_settings':
					$test = new Project_Pagebuilder_TestAB();
					$test
						->withIds($input->data->test_id)
						->onlyOne()
						->getList($testData);

					$this->out_js = $testData;
				break;

				case 'save_settings':
					$test = new Project_Pagebuilder_TestAB();
					$this->out_js['status'] = $test->setEntered(
						[
                            'id'            => $input->data->test_id,
                            'days'          => $input->data->days,
                            'visitors'      => $input->data->visitors,
                            'auto_optimize' => $input->data->auto_optimize,
                            'weight'        => $input->data->weight,
                        ]
					)->set();
				break;
			}
		}

		if (!empty($_POST)) {
			switch ($_POST['action']) {
				case 'csv': {

					$filepath = $_FILES['file']['tmp_name'];

					if (!file_exists($filepath)) {
						Core_Data_Errors::getInstance()->setError("File not find");
					}

					$csv = array_map(function ($str) {
						return str_getcsv($str, ';');
					}, file($filepath));

					$this->out_js = $csv;

					break;
				}
			}
		}

	}

	public function imageUploadAjax(){
		require_once Zend_Registry::get('config')->path->absolute->library . 'Helper/Slim.php';

		try {
			$images = Slim::getImages();
		} catch (Exception $e) {
			$this->out_js = array(
				'status' => SlimStatus::FAILURE,
				'message' => 'An unknown error occurred'
			);
			return;
		}

		if ($images === false){
			$this->out_js = array(
				'status' => SlimStatus::FAILURE,
				'message' => 'No data posted'
			);
			return;
		}

		$image = array_shift($images);
		if (!isset($image)){
			$this->out_js = array(
				'status' => SlimStatus::FAILURE,
				'message' => 'No images found'
			);
			return;
		}

		if (!isset($image['output']['data']) && ! isset($image['input']['data'])){
			$this->out_js = array(
				'status' => SlimStatus::FAILURE,
				'message' => 'No image data'
			);
			return;
		}

		if (isset($image['output']['data'])){
			$name = $image['output']['name'];
			$name = str_replace(" ", "-", $name);
			$data = $image['output']['data'];
			$user_id = Core_Users::$info['id'];
			if ( ! file_exists(Zend_Registry::get('config')->path->html->user_data . $user_id . "/")){
				mkdir(Zend_Registry::get('config')->path->absolute->user_data . $user_id . "/", 0777, TRUE);
			}
			if ( $image['meta']->fresh == 1 ) {
				$output = Slim::saveFile($data, $name, Zend_Registry::get('config')->path->html->user_data . $user_id . "/");
				$thumb = Zend_Registry::get('config')->path->html->user_data . $user_id . "/" . $output['name'];
				$full = Zend_Registry::get('config')->path->html->user_data . $user_id . "/" . $output['name'];
			} else {
				$output = Slim::saveFile($data, $name, Zend_Registry::get('config')->path->html->user_data . $user_id . "/", false);
				$thumb = Zend_Registry::get('config')->path->html->user_data . $user_id . "/" . $output['name'];
				$full = Zend_Registry::get('config')->path->html->user_data . $user_id . "/" . $name;
			}
		}

		if (isset($image['input']['data'])){
			$name = $image['input']['name'];
			$data = $image['input']['data'];
			$user_id = Core_Users::$info['id'];
			if ( ! file_exists(Zend_Registry::get('config')->path->html->user_data . $user_id)){
				mkdir(Zend_Registry::get('config')->path->absolute->user_data . $user_id, 0777, TRUE);
			}
			$input = Slim::saveFile($data, $name, Zend_Registry::get('config')->path->html->user_data . $user_id . "/");
			$thumb = Zend_Registry::get('config')->path->html->user_data . $user_id . "/" . $output['name'];
			$full = Zend_Registry::get('config')->path->html->user_data . $user_id . "/" . $name;
		}

		$response = array(
			'status' => SlimStatus::SUCCESS
		);
		if (isset($output) && isset($input)){
			$response['output'] = array(
				'file' => $output['name'],
				'path' => $output['path']
			);
			$response['input'] = array(
				'file' => $input['name'],
				'path' => $input['path']
			);
		} else {
			$response['file'] = isset($output) ? $output['name'] : $input['name'];
			$response['path'] = isset($output) ? $output['path'] : $input['path'];
		}

		if ( isset($thumb) ) {
			$response['thumb'] = $thumb;
		}
		if (isset($full)){
			$response['full'] = $full;
		}

		$this->out_js = $response;
	}

	public function resizeImage(){
		require_once Zend_Registry::get('config')->path->absolute->library . 'ImageWorkshop' . DIRECTORY_SEPARATOR . 'autoload.php';
		$layer = PHPImageWorkshop\ImageWorkshop::initFromPath(Zend_Registry::get('config')->path->absolute->root . $_POST['image']);
		$layer->resizeInPixel($_POST['width'], $_POST['height'], false);
		$layer->save(Zend_Registry::get('config')->path->absolute->root . pathinfo($_POST['image'], PATHINFO_DIRNAME), pathinfo($_POST['image'], PATHINFO_BASENAME));

		$this->out_js['responseCode'] = 1;
	}

	public function manage(){
		$sites = new Project_Pagebuilder_Sites();
		if(isset($_GET['delete']) && !empty($_GET['delete'])){
			$sites->withIds($_GET['delete'])->del();
			$this->location();
		}
		if(isset($_GET['duplicate']) && !empty($_GET['duplicate'])){
			$sites->duplicate($_GET['duplicate']);
			$this->location();
		}
		$sites
			->onlyOwner()
			->withVisitors()
			->withPaging(array(
				'page'=>@$_GET['page'],
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			))
			->withOrder( @$_GET['order'] )
			->getList($this->out['arrEcom'])
			->getPaging( $this->out['arrPg'] );
	}
	
	public function publish(){
		$dir = 'Project_Pagebuilder@generate' . DIRECTORY_SEPARATOR . 'source';
		$sites = new Project_Pagebuilder_Sites();
		Zend_Registry::get( 'objUser' )->prepareTmpDir( $dir );
		$_transport = new Project_Placement_Transport();

		if( in_array( $_POST['publishing_options'], array('remote', 'external' ) ) && isset( $_POST['placement_id'] ) ){
			$_placement = new Project_Placement();
			$_placement
				->withIds( $_POST['placement_id'] )
				->onlyOne()
				->getList( $_place );

			$_newUrl='';
			if( $_place['flg_type'] == Project_Placement::REMOTE_HOSTING ){
				$_newUrl = $_POST['url'];
			} elseif ( isset( $_place['domain_http'] ) ){
				$_POST['ftp_directory'] = str_replace('//', '/', ($_POST['ftp_root'] == 1) ? '/' : '/' . trim($_POST['ftp_directory'], '/') . '/');
				$_newUrl = '//' . $_place['domain_http'] . $_POST['ftp_directory'];
			}

			$sites
				->setDir($dir)
				->export($_POST['siteID'], $_newUrl);
			$errors = Core_Data_Errors::getInstance()->getErrorsFlow();

			if (!empty($errors)) {
				$errors = array_map(function($error) {
					return "<div class='alert alert-danger'>$error</div>";
				}, $errors);

				$this->out_js['responseCode'] = 0;
				$this->out_js['responseHTML'] = join('', $errors);
				return;
			}

			if (Zend_Registry::get('config')->engine->project_domain !== 'app.local') {
				if (!$_transport
					->setInfo( $_POST )
					->setSourceDir( $dir )
					->placeAndBreakConnect() ){
					$this->out_js['responseCode'] = 0;
					return;
				}
			}

			$sites->setEntered(
				array(
					'id' => $_POST['siteID'], 
					'url' => $_newUrl, 
					'settings' => $_transport->getInfo()
				)
			)->set();

			$this->out_js['placement'] = $_newUrl;
			$this->out_js['responseCode'] = 1;

			if ($_place['flg_type'] == Project_Placement::LOCAL_HOSTING_SUBDOMEN) {
				$_newUrl = explode('.', parse_url($_newUrl, PHP_URL_HOST));
				array_splice($_newUrl, 0, 1);
				$_newUrl = implode('.', $_newUrl);
			} else {
				$_newUrl = parse_url($_newUrl, PHP_URL_HOST);
			}

			// Clear cache in CloudFlare
			Project_Pagebuilder_Markup::clearCache($_newUrl);
		}
	}

	public function browse(){
		$_model=new Project_Placement_Transport();
		if ( !$_model->setInfo( $_GET )->browseDirs( $this->out['arrDirs'] ) ) {
			$this->out['arrErrors']=Core_Data_Errors::getInstance()->getErrors();
			$_model->breakConnect();
			return;
		}
		$_model->isPassive();
		if ( !empty( $_POST['new_folder'] ) ) {
			if ( $_model->makeDirAndBreakConnect( $_POST['new_folder'] ) ) {
				$this->location( Core_Module_Location::URLFULL );
			}
			$this->out['arrErrors']=Core_Data_Errors::getInstance()->getErrors();
		}
		$this->out['strGetCurrentDir']='ftp_directory='.$_model->getCurrentDir();
		$this->out['strCurrentDir']=$_model->getCurrentDir();
		$this->out['strPrevDir']='ftp_directory='.$_model->getPrevDir();
		$this->out['strUrl']=Core_Module_Router::$uriFull;
		$_model->breakConnect();
	}

	public function updateSettingsSite(){
		$sites = new Project_Pagebuilder_Sites();
		$smarty = new Core_View_Smarty();

		if( empty( $_POST['id'] ) || empty( $_POST['sites_name'] ) ) {
			$temp = array();
			$temp['header'] = 'Ouch! Something went wrong:';
			$temp['content'] = 'The site ID is missing or corrupt. Please try reloading the page.';

			$smarty
				->_smarty
				->assign( $temp );
			$this->out_js['responseCode'] = 0;
			$this->out_js['responseHTML'] = $smarty->_smarty->fetch( __DIR__ . "/templates/site1_ecom_funnels_error.tpl" );
			echo json_encode( $this->out_js );
			exit;
		} 

		if( $sites->setEntered( $_POST )->set() ){
			$sites->getEntered( $siteData );

			$temp = array();
			$temp['header'] = 'Yeah! All went well.';
			$temp['content'] = "The site's details were saved successfully!";

			$smarty->_smarty->assign( $temp );
			$this->out_js['responseCode'] = 1;
			$this->out_js['siteName'] = $siteData['sites_name'];
			$this->out_js['siteID'] = $siteData['id'];
			$this->out_js['responseHTML'] = $smarty->_smarty->fetch( __DIR__ . "/templates/site1_ecom_funnels_success.tpl" );
			echo json_encode( $this->out_js );
			exit;
		} else {
			$temp = array();
			$temp['header'] = 'Ouch! Something went wrong:';
			$temp['content'] = 'The site ID is missing or corrupt. Please try reloading the page.';

			$smarty->_smarty->assign( $temp );
			$this->out_js['responseCode'] = 0;
			$this->out_js['responseHTML'] = $smarty->_smarty->fetch( __DIR__ . "/templates/site1_ecom_funnels_error.tpl" );
			echo json_encode( $this->out_js );
			exit;
		}
	}

	public function updateTemplate(){
		if(empty($_POST) || empty($_POST['templateid']) || empty($_POST['currentid'])){
			$this->out_js['responseCode'] = 0;
			return;
		}

		/** Init instances classes */
		$sites = new Project_Pagebuilder_Sites();
		$pages = new Project_Pagebuilder_Pages();
		$frames = new Project_Pagebuilder_Frames();

		/** Getting data current site */
		$sites->withIds($_POST['currentid'])->onlyOne()->getList($currentSite);

		/** Getting data selected template */
		$sites->withIds($_POST['templateid'])->onlyOne()->getList($templateSite);

		/** Save the current site with fields from the template */
		$currentSite['global_css'] = $templateSite['global_css'];
		$currentSite['sitethumb'] = $templateSite['sitethumb'];
		$sites->setEntered($currentSite)->set();

		/** Delete current site pages */
		$pages->withSiteId($_POST['currentid'])->onlyIds()->getList($currentSitePages);
		$pages->withIds($currentSitePages)->del();

		/** Getting pages for template & addit him for current site */
		$pages->withSiteId($_POST['templateid'])->withOrder('id--dn')->getList($templatePages);
		foreach($templatePages as $page){
			$pageID = $page['id'];
			unset($page['id']);
			$page['sites_id'] = $_POST['currentid'];
			$page['pages_template'] = 0;

			$pages->setEntered($page)->set();
			$pages->getEntered($pageData);
			
			/** Getting frames added to the page & adding them to pages */
			$frames->withSiteId($_POST['templateid'])->withPageId($pageID)->withOrder('position--dn')->getList($_arrFrames);

			foreach( $_arrFrames as $frame ){
				$data = array(
					'pages_id'              => $pageData['id'],
					'sites_id'              => $_POST['currentid'],
					'position'				=> $frame['position'],
					'frames_content'        => $frame['frames_content'],
					'frames_height'         => $frame['frames_height'],
					'frames_original_url'   => $frame['frames_original_url'],
					'frames_sandbox'        => $frame['frames_sandbox'],
					'frames_loaderfunction' => $frame['frames_loaderfunction'],
					'frames_timestamp'      => time(),
					'created_at'            => date("Y-m-d H:i:s")
				);
				$frames->withoutDecode()->setEntered($data)->set();
			}
		}

		$this->out_js['responseCode'] = 1;
	}

	public function getLeadChannelsForm(){
		if (!empty($_POST['lead_id'])) {
			$_mooptin = new Project_Mooptin();
			$_mooptin
				->withIds($_POST['lead_id'])
				->onlyOne()
				->getList($_arrMoData);

			require_once Zend_Registry::get('config')->path->absolute->library . 'SimpleHTMLDom' . DIRECTORY_SEPARATOR . 'simple_html_dom.php';
			
			$_prevForm    = str_get_html(trim(base64_decode($_POST['currentform'])));
			$_buttonClass = $_buttonStyle = $_inputStyle = $_inputClass = '';
			
			foreach ($_prevForm->find('input[type!="submit"]') as $_oldInput) {
				if (strpos($_oldInput->getAttribute('style'), 'display:none') === false && $_inputStyle == '') {
					$_inputStyle = $_oldInput->getAttribute('style');
				}

				if ($_inputClass == '') {
					$_inputClass = $_oldInput->getAttribute('class');
				}
			}

			if (!empty($_prevForm->find('button, input[type="submit"]', 0))) {
				$_buttonStyle = $_prevForm->find('button, input[type="submit"]', 0)->getAttribute('style');
				$_buttonClass = $_prevForm->find('button, input[type="submit"]', 0)->getAttribute('class');
			}

			$_formStyle = $_prevForm->find('form', 0)->getAttribute('style');
			$htmlForm   = str_get_html(Project_Mooptin::getCodeForm($_arrMoData['settings']['optin_form'], $_arrMoData['settings']['form'], $_arrMoData['id']));

			$this->out_js['form']['attr']           = $htmlForm->find('form', 0)->getAllAttributes();
			$this->out_js['form']['attr']['action'] = 'https://' . Zend_Registry::get('config')->domain->host . '/services/ifunnels.php';

			if ($_formStyle != false) {
				$this->out_js['form']['attr']['style'] = $_formStyle;
			}

			//$this->out_js['form']['attr']['action'] = '//cnm.local/services/ifunnels.php';
			foreach ($htmlForm->find('input[type!="submit"]') as $input) {
				if ($input->attr['type'] != 'hidden') {
					$this->out_js['form']['input'][] = $input->getAllAttributes() + array('style' => $_inputStyle, 'class' => $_inputClass);
				} else {
					$this->out_js['form']['input'][] = $input->getAllAttributes();
				}
			}
			
			foreach ($htmlForm->find('button, input[type="submit"]') as $button) {
				$this->out_js['form']['input'][] = $button->getAllAttributes() + array('style' => $_buttonStyle, 'class' => $_buttonClass);
			}

			$this->out_js['form']['input'][] = array(
				'type' => 'hidden',
				'name' => '_inputRedirectTo',
			);

			$this->out_js['form']['input'][] = array(
				'type' => 'hidden',
				'name' => '_textareaCustomMessageLeadChannel',
			);

			if (isset($_arrMoData['settings']['form']['flg_gdpr']) && $_arrMoData['settings']['form']['flg_gdpr'] != 0
				&& isset($_arrMoData['settings']['form']['gdpr']) && !empty($_arrMoData['settings']['form']['gdpr'])
			) {
				$this->out_js['form']['gdpr'] = $_arrMoData['settings']['form']['gdpr'];
			}

			$this->out_js['responseCode'] = 1;
		} else {
			$this->out_js['responseCode'] = 0;
		}
	}

	public function reporting(){
		$this->objStore->getAndClear($this->out);

		$sites = new Project_Pagebuilder_Sites();
		$sites
			->onlyOwner()
			->onlyCount()
			->getList($this->out['countSites']);

		$_statistic = new Project_Pagebuilder_Statistic(Core_Users::$info['id']);

		if (empty($_GET['arrFilter']['time'])) {
			$_GET['arrFilter']['time'] = 4;
		}

		if (!empty($_GET['pagename'])) {
			$_statistic->withPbpage($_GET['pagename']);
		}

		if (!empty($_GET['id'])) {
			$_statistic
				->withReportById($_GET['id'])
				->withOrder('c.crt--dn')
				->withFilter(@$_GET['arrFilter'])
				->getList($this->out['arrList']);
		} else {
			$_statistic
				->withOrder('c.crt--dn')
				->withFilter(@$_GET['arrFilter'])
				->getList($this->out['arrList'])
				->getFilter($this->out['arrFilter']);

			$clicks   = 0;
			$visitors = 0;

			foreach ($this->out['arrList'] as $key => $value) {
				$clicks += $value['clicks'];
				$visitors += $value['visitors'];
			}

			$this->out['statistic'] = array(
				'clicks'   => $clicks,
				'visitors' => $visitors,
			);
		}

		$this->out['arrDate'] = $this->out['arrCountryList'] = array();

		foreach ($this->out['arrList'] as $_page) {
			// блок графика
			if (isset($_page['arr_visitors']['date'])) {
				foreach ($_page['arr_visitors']['date'] as $_date => $_count) {
					if (isset($this->out['arrDate'][$_date])) {
						$this->out['arrDate'][$_date]['view'] += $_count;
					} else {
						$this->out['arrDate'][$_date] = array(
							'date'  => $_date,
							'click' => 0,
							'view'  => $_count,
						);
					}
				}
			}

			if (isset($_page['arr_clicks']['date'])) {
				foreach ($_page['arr_clicks']['date'] as $_date => $_count) {
					if (isset($this->out['arrDate'][$_date])) {
						$this->out['arrDate'][$_date]['click'] += $_count;
					} else {
						$this->out['arrDate'][$_date] = array(
							'date'  => $_date,
							'click' => $_count,
							'view'  => 0,
						);
					}
				}
			}

			// блок стран
			if (isset($_page['arr_visitors']['countries'])) {
				foreach ($_page['arr_visitors']['countries'] as $_date => $_count) {
					if (isset($this->out['arrCountryList'][$_date])) {
						$this->out['arrCountryList'][$_date]['view'] += $_count;
					} else {
						$this->out['arrCountryList'][$_date] = array(
							'country' => $_date,
							'click'   => 0,
							'view'    => $_count,
						);
					}
				}
			}

			if (isset($_page['arr_clicks']['countries'])) {
				foreach ($_page['arr_clicks']['countries'] as $_date => $_count) {
					if (isset($this->out['arrCountryList'][$_date])) {
						$this->out['arrCountryList'][$_date]['click'] += $_count;
					} else {
						$this->out['arrCountryList'][$_date] = array(
							'country' => $_date,
							'click'   => $_count,
							'view'    => 0,
						);
					}
				}
			}

			// utm
			if (isset($_page['utm_log'])) {
				foreach ($_page['utm_log'] as $_utmLogData) {
					if (!in_array($_utmLogData['utm_source'], $this->out['arrUtmSourceFilter']) && $_utmLogData['utm_source'] != '') {
						$this->out['arrUtmSourceFilter'][] = $_utmLogData['utm_source'];
					}

					if (!in_array($_utmLogData['utm_medium'], $this->out['arrUtmMediumFilter']) && $_utmLogData['utm_medium'] != '') {
						$this->out['arrUtmMediumFilter'][] = $_utmLogData['utm_medium'];
					}

					if (!in_array($_utmLogData['utm_campaign'], $this->out['arrUtmCampaignFilter']) && $_utmLogData['utm_campaign'] != '') {
						$this->out['arrUtmCampaignFilter'][] = $_utmLogData['utm_campaign'];
					}

					if (isset($_GET['arrFilter']) && isset($_GET['arrFilter']['utm_source']) && !empty($_GET['arrFilter']['utm_source']) && $_GET['arrFilter']['utm_source'] != $_utmLogData['utm_source']) {
						continue;
					}

					if (isset($_GET['arrFilter']) && isset($_GET['arrFilter']['utm_medium']) && !empty($_GET['arrFilter']['utm_medium']) && $_GET['arrFilter']['utm_medium'] != $_utmLogData['utm_medium']) {
						continue;
					}

					if (isset($_GET['arrFilter']) && isset($_GET['arrFilter']['utm_campaign']) && !empty($_GET['arrFilter']['utm_campaign']) && $_GET['arrFilter']['utm_campaign'] != $_utmLogData['utm_campaign']) {
						continue;
					}

					$flgUpdatePrev = false;
					foreach ($this->out['arrUtmList'] as &$_utmUpdate) {
						if ($_utmUpdate['utm_source'] == $_utmLogData['utm_source']
							&& $_utmUpdate['utm_medium'] == $_utmLogData['utm_medium']
							&& $_utmUpdate['utm_term'] == $_utmLogData['utm_term']
							&& $_utmUpdate['utm_content'] == $_utmLogData['utm_content']
							&& $_utmUpdate['utm_campaign'] == $_utmLogData['utm_campaign']) {
							$flgUpdatePrev = true;
							$_utmUpdate['visitors'] += $_utmLogData['visitors'];
							$_utmUpdate['clicks'] += $_utmLogData['clicks'];
							continue;
						}
					}

					unset($_utmUpdate);
					if (!$flgUpdatePrev) {
						$this->out['arrUtmList'][] = $_utmLogData;
					}
				}
			}
		}

		foreach ($this->out['arrList'] as &$_adata) {
			$_adata['rate'] = $_adata['clicks'] / $_adata['visitors'] * 100;
		}

		unset( $_adata );
		$_func_mv='cmp_view_up';

		if ($_GET['order_mv'] == 'view--dn') {
			$_func_mv = 'cmp_view_dn';
		}

		if ($_GET['order_mv'] == 'view--up') {
			$_func_mv = 'cmp_view_up';
		}

		if ($_GET['order_mv'] == 'click--up') {
			$_func_mv = 'cmp_click_up';
		}

		if ($_GET['order_mv'] == 'click--dn') {
			$_func_mv = 'cmp_click_dn';
		}

		if ($_GET['order_mv'] == 'rate--up') {
			$_func_mv = 'cmp_rate_up';
		}

		if ($_GET['order_mv'] == 'rate--dn') {
			$_func_mv = 'cmp_rate_dn';
		}
	
		if (count($this->out['arrList']) > 1) {
			function cmp_view_up($a, $b) {
				return $a["visitors"] < $b["visitors"];
			}

			function cmp_view_dn($a, $b) {
				return $a["visitors"] > $b["visitors"];
			}

			function cmp_click_up($a, $b) {
				return $a["clicks"] < $b["clicks"];
			}

			function cmp_click_dn($a, $b) {
				return $a["clicks"] > $b["clicks"];
			}

			function cmp_rate_up($a, $b) {
				return $a["rate"] < $b["rate"];
			}

			function cmp_rate_dn($a, $b) {
				return $a["rate"] > $b["rate"];
			}

			uasort($this->out['arrList'], $_func_mv);
		}

		foreach ($this->out['arrCountryList'] as &$_cdata) {
			$_cdata['rate'] = $_cdata['click'] / $_cdata['view'] * 100;
		}

		unset($_cdata);
		$_func = 'up_rate';


		if ($_GET['order'] == 'view--up') {
			$_func = 'up_view';
		}

		if ($_GET['order'] == 'view--dn') {
			$_func = 'dn_view';
		}

		if ($_GET['order'] == 'click--up') {
			$_func = 'up_click';
		}

		if ($_GET['order'] == 'click--dn') {
			$_func = 'dn_click';
		}

		if ($_GET['order'] == 'rate--up') {
			$_func = 'up_rate';
		}

		if ($_GET['order'] == 'rate--dn') {
			$_func = 'dn_rate';
		}

		if ($_GET['order'] == 'country--up') {
			$_func = 'up_country';
		}

		if ($_GET['order'] == 'country--dn') {
			$_func = 'dn_country';
		}

		if (count($this->out['arrCountryList']) > 1) {
			function up_rate($a, $b) {
				return $a["rate"] < $b["rate"];
			}

			function dn_rate($a, $b) {
				return $a["rate"] > $b["rate"];
			}

			function up_view($a, $b) {
				return $a["view"] < $b["view"];
			}

			function dn_view($a, $b) {
				return $a["view"] > $b["view"];
			}

			function up_click($a, $b) {
				return $a["click"] < $b["click"];
			}

			function dn_click($a, $b) {
				return $a["click"] > $b["click"];
			}

			function up_country($a, $b) {
				return $a["country"] < $b["country"];
			}

			function dn_country($a, $b) {
				return $a["country"] > $b["country"];
			}

			uasort($this->out['arrCountryList'], $_func);
		}

		if (!empty($_GET)) {
			$_get = $_GET;
			unset($_get['order']);
			unset($_get['order_mv']);
			unset($_get['id']);
			$this->out['sortParam'] = http_build_query($_get);
		}

		$this->out['strDate'] = '[';
		foreach ($this->out['arrDate'] as $_data) {
			$this->out['strDate'] .= '{y:\'' . $_data['date'] . '\',a:' . $_data['click'] . ',b:' . $_data['view'] . '},';
		}
		$this->out['strDate'] .= ']';

		function cmp_view_up_2($a, $b) {
			return $a["visitors"] < $b["visitors"];
		}

		uasort($this->out['arrUtmList'], 'cmp_view_up_2');

		// Quiz statistics
		$quiz = new Project_Pagebuilder_Quiz(Core_Users::$info['id']);
		
		if (!empty($_GET['id'])) {
			$quiz->withSiteId($_GET['id']);
		}

		$quiz
			->withFilter(@$_GET['arrFilter'])
			->getList($this->out['arrQuiz']);
	}

	public function save_as_template() {
		ob_clean();
		if( empty( $_POST['site_id'] ) ) {
			echo json_encode( array( 'status' => 'failed', 'responseHTML' => '<h4>Ouch! Something went wrong:</h4><div>Empty prop site_id!</div>' ) );
			return;
		}
		$sites = new Project_Pagebuilder_Sites();
		
		if( $sites->saveAsTemplate( $_POST['site_id'] ) ) {
			echo json_encode( array( 'status' => 'success', 'responseHTML' => '<h4>Success!</h4><div>The template has been saved successfully!</div>' ) );
		} else {
			echo json_encode( array( 'status' => 'failed', 'responseHTML' => '<h4>Ouch! Something went wrong</h4>' ) ); 
		}
		exit();
	}

	public function optimization() {
		$pages = new Project_Pagebuilder_Pages();
		$pages
			->withEnableTestAB()
			->onlyOwner()
			->getList($this->out['arrPages']);

		if (!empty($this->out['arrPages'])) {
			$this->out['stats'] = Project_Pagebuilder_TestAB::getDataOfStats(array_column($this->out['arrPages'], 'id'));
		}
	}

	/**
	 * for all
	 */

	public function loadsinglepage(){
		if(empty($_GET['id'])) {
			die('Empty Data');
		}
		$frames = new Project_Pagebuilder_Frames();
		$frames->withPageId( $_GET['id'] )->withOrder('position--dn')->getList( $arrFrames );
		if(empty($arrFrames)){
			$frames->withIds( $_GET['id'] )->getList( $arrFrames );
		}
		if (!empty($arrFrames)) {
			$doc = new DOMDocument;
			$doc->loadHTML(file_get_contents(Zend_Registry::get('config')->path->absolute->pagebuilder . 'elements/' . DIRECTORY_SEPARATOR . 'skeleton.html'));
			$xpath = new DOMXpath($doc);

			foreach($xpath->query("//*[@src]") as $element){
				$element->setAttribute('src', Zend_Registry::get('config')->path->html->pagebuilder . 'elements/' . $element->getAttribute('src'));
			}

			foreach($xpath->query("//*[@href]") as $element){
				$element->setAttribute('href', Zend_Registry::get('config')->path->html->pagebuilder . 'elements/' . $element->getAttribute('href'));
			}

			foreach ($arrFrames as $frame){
				$frameDoc = new DOMDocument;
				$frameDoc->loadHTML($frame['frames_content']);
				$frameDoc->normalizeDocument();
				foreach($frameDoc->getElementById('page')->childNodes as $node){
					if(!empty(trim($frameDoc->saveHTML($node)))){
						$doc->getElementById('page')->appendChild( $doc->importNode($node, true) );
					}
				}
			}

			foreach($xpath->query("//*[@data-dragcontext-marker-text]") as $element){
				$element->parentNode->remove($element);
			}

			$linkNode = $doc->createElement( 'link' );
			$linkNode->setAttribute( 'rel', 'stylesheet' );
			$linkNode->setAttribute( 'href', 'https://fasttrk.net/services/testab.css.php' );
			
			$xpath->query('//head')->item(0)->appendChild($linkNode);

			echo $doc->saveHTML();
			exit();
		}
	}

	public function auth() {
		$action = array_keys( $_GET )[0];

		switch( $action ) {
			case 'auth': 
				$_auth=new Project_Users_Auth_Multi();

				if( $_auth->setEntered( $_REQUEST, 'arrLogin' )->authorize() ) {
					setcookie( 'loginName', $_REQUEST['arrLogin']['username'], time() + 3600 );
					$this->out_js = array(
						'authorized' => ! empty( Core_Users::$info['id'] ) || false 
					);
				} else {
					$_auth->getErrors( $error );
					$this->out_js = array( 
						'authorized' => false,
						'error_message' => $error
					);
				}
			break;

			default:
				$this->out_js = array(
					'authorized' => ! empty( Core_Users::$info['id'] ) || false
				);
			break;
		}

		echo json_encode( $this->out_js );
		exit;
	}

	public function auth_back() {
		$action = array_keys( $_GET )[0];

		switch( $action ) {
			case 'auth': 
				$_auth = new Core_Users_Auth_Email();
				if ( $_auth->setEntered( $_REQUEST, 'arrLogin' )->authorize() ) {
					$this->out_js = array(
						'authorized' => ! empty( Core_Users::$info['id'] ) || false 
					);
				} else {
					$_auth->getErrors( $error );
					$this->out_js = array( 
						'authorized' => false,
						'error_message' => $error
					);
				}
			break;

			default:
				$this->out_js = array(
					'authorized' => ! empty( Core_Users::$info['id'] ) || false
				);
			break;
		}

		echo json_encode( $this->out_js );
		exit;
	}
	
	public function sharelog(){
		$_sharelog = new Project_Pagebuilder_Sharelog();
		if( isset( $_GET['install'] ) && $_GET['install']=='true' ){
			$_sharelog->install();
			$this->location( array('wg'=>array( 'install' => end ) ) );
			exit;
		}
		$_sharelog->withPaging(array(
				'page'=>@$_GET['page'],
				'reconpage'=>50,
				'numofdigits'=>20,
			))
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] );
		$_arrPbData=$_arrUsers=array();
		foreach( $this->out['arrList'] as $_data ){
			$_arrPbData[$_data['pb_id']]=$_data['pb_id'];
			$_arrUsers[$_data['s_user']]=$_data['s_user'];
			$_arrUsers[$_data['i_user']]=$_data['i_user'];
		}
		$this->out['arrPb']=$this->out['arrUsers']=array();
		$_pb = new Project_Pagebuilder_Sites();
		$_pb->withIds( $_arrPbData )->getList($_arrPbData);
		foreach( $_arrPbData as $_pbData ){
			$this->out['arrPb'][$_pbData['id']]=$_pbData['sites_name'];
		}
		$_pb = new Project_Users_Management();
		$_pb->withIds( $_arrUsers )->getList($_arrUsersData);
		foreach( $_arrUsersData as $_userData ){
			$this->out['arrUsers'][$_userData['id']]=$_userData['email'];
		}
	}
	
	public function share(){
		$_ecomId=false;
		if( !isset( $_GET['ecom'] ) ){
			$this->location( array( 'name'=>'site1_accounts', 'action'=>'login' ) );
			exit;
		}else{
			$_ecomId=Core_Payment_Encode::decode( $_GET['ecom'] );
			$_ecomId=$_ecomId[0];
		}
		if( isset( $_POST['redirect'] ) ){
			$_ecomId=Core_Payment_Encode::decode( $_POST['redirect'] );
			$_ecomId=$_ecomId[0];
		}
		if( empty( $_ecomId ) ){
			$this->location( array( 'name'=>'site1_accounts', 'action'=>'login' ) );
			exit;
		}
		$sites = new Project_Pagebuilder_Sites();
		$this->out['arrEcom']=$sites->getSite( $_ecomId );
		if( isset( $_POST['action'] ) && !empty( $_POST['action'] ) && $_POST['action']=='yes' ){
			$sites->duplicate( $_ecomId );
			$_shareLog=new Project_Pagebuilder_Sharelog();
			$_shareLog->setEntered(array(
				'pb_id'=>$_ecomId,
				's_user'=>Core_Users::$info['id'],
				'i_user'=>$this->out['arrEcom']['site']['user_id'],
			))->set();
			$this->location(array('action'=>'manage'));
			exit;
		}
		if( isset( $_POST['action'] ) && !empty( $_POST['action'] ) && $_POST['action']=='no' ){
			$this->location( array( 'name'=>'site1_accounts', 'action'=>'login' ) );
			exit;
		}
		$_auth=new Project_Users_Auth_Multi();
		if( $_auth->setEntered( $_POST,'arrLogin' )->authorize() ) {
			setcookie("loginName", $_POST['arrLogin']['username'], time()+3600);
			$_subscr=new Core_Payment_Subscription();
			if( $_subscr->onlyExpiry()->onlyOwner()->getList( $_tmp )->checkEmpty() ){
				$this->location( array('action'=>'payment') );
			}
			if( !empty( $_ecomId ) ){
				$sites->duplicate( $_ecomId );
				$_shareLog=new Project_Pagebuilder_Sharelog();
				$_shareLog->setEntered(array(
					'pb_id'=>$_ecomId,
					's_user'=>Core_Users::$info['id'],
					'i_user'=>$this->out['arrEcom']['site']['user_id'],
				))->set();
				$this->location(array('action'=>'manage'));
			}
			$this->location();
		}
		$_auth->getErrors( $this->out['arrError']['login'] );
		$_forgot=new Core_Users_Forgot_Change();
		if( $_forgot->setEntered( $_POST, 'arrForgot' )->send() ) {
			$this->location(array( 'w'=>array( 'send_email'=>true )));
		}
		$_forgot->getEntered( $this->out['arrForgot'] )->getErrors( $this->out['arrError']['forgot'] );
	}
	
}
?>