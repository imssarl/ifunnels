<?php
class site1_articles extends Core_Module {

	public function set_cfg() {
		$this->inst_script=array(
			'module'=>array( 'title'=>'CNM Article Manager', ),
			'actions'=>array(
				array( 'action'=>'category', 'title'=>'Manage Category', 'flg_tree'=>1 ),
				array( 'action'=>'articles', 'title'=>'Manage Articles', 'flg_tree'=>1 ),
				array( 'action'=>'add', 'title'=>'Add Article', 'flg_tree'=>1 ),
				array( 'action'=>'edit', 'title'=>'Edit Article', 'flg_tree'=>1 ),
				array( 'action'=>'import', 'title'=>'Mass Import', 'flg_tree'=>1 ),
				array( 'action'=>'importpopup', 'title'=>'Mass Import Popup', 'flg_tpl' => 1, 'flg_tree'=>1 ),
				array( 'action'=>'showarticle', 'title'=>'Show Article Popup', 'flg_tpl' => 1, 'flg_tree'=>1 ),
				array( 'action'=>'export', 'title'=>'Mass Export', 'flg_tpl'=>1, 'flg_tree'=>1 ),
				array( 'action'=>'advancedopt', 'title'=>'Advanced content display options', 'flg_tree'=>1 ),
				array( 'action'=>'savedselections', 'title'=>'Saved selections', 'flg_tree'=>1 ),
				array( 'action'=>'savedselections_edit', 'title'=>'Edit saved selections', 'flg_tree'=>1 ),
				array( 'action'=>'getcode', 'title'=>'Get saved selections','flg_tpl'=>1, 'flg_tree'=>1 ),
				array( 'action'=>'multiboxselect', 'title'=>'Select Popup', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'generatecode', 'title'=>'Php code Generator', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'rewriter', 'title'=>'Article Rewriter', 'flg_tree'=>1 ),
				array( 'action'=>'defaultVariations', 'title'=>'Article Rewriter Default Variations', 'flg_tree'=>1, 'flg_tpl'=>3 ),
				array( 'action'=>'userVariations', 'title'=>'Article Rewriter User Variations', 'flg_tree'=>1, 'flg_tpl'=>3 ),				
				array( 'action'=>'get', 'title'=>'Article Rewriter Get', 'flg_tree'=>1, 'flg_tpl'=>3 ),
				array( 'action'=>'view_last_rewrite', 'title'=>'Article Rewriter View', 'flg_tree'=>1 ),
			),
		);
	}

	// добавление категории Default для групп "Site Profit Bot Hosted" и "Site Profit Bot Pro". 
	// необходимо т.к. нет возможности добавить статьи без категорий, а доступа к модулю у групп нет.
	public function before_run_parent(){
		if ( Core_Acs::haveAccess( array('Site Profit Bot Hosted','Site Profit Bot Pro') ) ) {
			return;
		}
		$category=new Project_Articles_Category();
		$category->withFlags(array('active'))->toSelect()->get( $_arrCats, $_arrTmp );
		if ( in_array( 'Default', $_arrCats ) ) {
			return; // такая категория уже есть
		}
		$category->set( $arrCats, $arrErr, array( array('id'=>0,'flag1'=>'on','title'=>'Default') ) );
	}
	
	public function rewriter() {
		if ( !empty( $_POST['arr'] ) ) {
			$model = new Project_Articles();
			switch ($_POST['type']){
				case 1: // сохранить одну выбранную статью.
					if ( $model->setData( $_POST['arr'] )->saveArticles( array( $_POST['arrRes'] ) ) ){
						$this->location( array( 'action'=>'view_last_rewrite' ) );
					}
					$model
						->getErrors( $this->out['arrErr'] )
						->getEntered( $this->out['arr'] );					
					break;
				case 2: // Сохранить статьи в количестве n-штук
					$_POST['arr']['clear_session']=true;
					if ( $model->setData( $_POST['arr'] )->generateArticles( $arrRes ) ) { 
						if ( $model->saveArticles( $arrRes ) ){
							$this->location( array( 'action'=>'view_last_rewrite' ) );
						}
					}
					$model
						->getErrors( $this->out['arrErr'] )
						->getEntered( $this->out['arr'] );
					break;
				case 3: // Сгенерить n статей и отдать пользователю в архиве.
				$_POST['arr']['clear_session']=true;
					if ( $model->setData( $_POST['arr'] )->generateArticles( $arrRes ) ) {
						$model->export( $_strFileZip, array(), $arrRes );
						header( "Content-type: application/octet-stream" );
						header( "Content-disposition: attachment; filename=".Core_Files::getBaseName($_strFileZip) );
						echo file_get_contents( $_strFileZip );
						exit;
					}
					break;					
				default: // генерация статей.
					if ( $model->setData( $_POST['arr'] )->generateArticles( $this->out['arrRes'] ) ) {
						$model->getEntered( $this->out['arr'] );
						$this->out['isLast']=$model->isLast();
					} else {
						$model
							->getErrors( $this->out['arrErr'] )
							->getEntered( $this->out['arr'] );
					}
					break;	
			}
		}
	}
	
	public function view_last_rewrite(){
		$model=new Project_Articles();
		$model->onlyLast()->getList( $this->out['arrList'] );
	}

	public function get(){
		if ( !empty( $_POST['get_article'] ) ){
			$model=new Project_Articles();
			$model->withIds($_POST['id'])->onlyOne()->getList($this->out_js['arrArticle']);
		}
		$this->out_js['error']=false;
	}

	public function defaultVariations(){
		$this->out_js['arrVariations']=false;
		Core_Rewrite::getSynonimous($this->out_js['arrVariations'],htmlspecialchars($_POST['selectedText']));
		$this->out_js['error']=false;
	}
	
	public function userVariations(){
		$this->out_js['arrVariations']=false;
		Core_Rewrite::getVars($this->out_js['arrVariations'],htmlspecialchars($_POST['selectedText']));
		$this->out_js['error']=false;
	}
	
	public function articles() {
		$this->objStore->getAndClear( $this->out );
		$model=new Project_Articles();
		if ( !empty( $_GET['dup'] ) ) { // duplicate
			if ( $model->dupArticle( $_GET['dup'] ) ) {
				$this->objStore->set( array( 'msg'=>'duplicated' ) );
			}
			$this->location( array( 'action'=>'articles' ) );
		}
		if ( !empty( $_GET['del'] )||!empty( $_POST['ids'] ) ) { // delete
			if ( $model->del( (empty($_POST['ids'])? $_GET['del']:$_POST['ids']) ) ) {
				$this->objStore->set( array( 'msg'=>'deleted' ) );
			}
			$this->location( array( 'action'=>'articles' ) );
		}
		$model->withOrder( @$_GET['order'] )->withCategory( @$_GET['category'] )->withPaging( array(
			'url'=>$_GET, 
			'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
			'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
		) )->getList( $this->out['arrList'] );
		$model->getPaging( $this->out['arrPg'] );
		$model->getFilter( $this->out['arrFilter'] );
		$model->getAdditional( $this->out['arrSelect'] );
		$model->getErrors( $this->out['arrErrors'] );
	}

	public function category() {
		$cat=new Project_Articles_Category();
		if ( !empty( $_POST['arrCats'] )&&$cat->set( $this->out['arrCats'], $this->out['arrErr'], $_POST['arrCats'] ) ) {
			$this->location();
		} else {
			$cat->withPagging( array(
				'page'=>@$_GET['page'], 
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			) )->management( $this->out['arrCats'], $this->out['arrPg'] );
		}
		$cat->getType( $this->out['arrType'] ); // только для оформления формы
		$cat->getFlags( $this->out['arrFlags'] ); // чекбоксы для категорий
		$this->out['arrErrors']=Core_Data_Errors::getInstance()->getErrors();
	}

	public function add() {
		$model=new Project_Articles();
		if ( !empty( $_POST['arrArticle'] ) ) {
			if ( $model->setData( $_POST['arrArticle'] )->set() ) {
				$this->objStore->toAction( 'articles' )->set( array( 'msg'=>'saved' ) );
				$this->location( array( 'action'=>'articles' ) );
			}

			$this->out['arrArticle'] = $_POST['arrArticle'];
		} elseif ( !empty( $_GET['id'] ) ) {
			$model->onlyOne()->withIds( $_GET['id'] )->getList( $this->out['arrArticle'] );
		}
		$model->getErrors( $this->out['arrErrors'] );
		$model->getAdditional( $this->out['arrSelect'] );
	}

	public function edit() {
		$this->add();
	}

	public function showarticle() {
		$model=new Project_Articles();
		if ( empty( $_GET['id'] ) ) {
			if ( !empty( $_GET['showall'] ) ) {
				$model->getAdditional( $_arrArticles );
				header('Content-type: application/json;');
				echo Zend_Registry::get( 'CachedCoreString' )->php2json( $_arrArticles );
				exit;
			}
			return;
		}
		$model->onlyOne()->withIds( $_GET['id'] )->getList( $this->out['arrArticle'] );
		$model->getAdditional( $this->out['arrSelect'] );
	}

	public function import() {
		$this->out['return_type'] = (  $_GET['return'] ) ?  $_GET['return'] : $this->params['return'] ; 
		$this->out['save_article_true'] = 0;
		$model = new Project_Articles();
		if (!empty($_POST)){
			$this->out['save_article_true'] = 1;
			$_strNewCategory=( isset( $_POST['import']['manually']['new_category'] ) && $_POST['import']['manually']['new_category']!='' )?$_POST['import']['manually']['new_category']:(( isset( $_POST['import']['file']['new_category'] ) && $_POST['import']['file']['new_category']!='' )?$_POST['import']['file']['new_category']:null);
			if( !empty( $_strNewCategory ) ){
				$model->getAdditional( $_arrCats );
				foreach( $_arrCats['category'] as $key=>$value ){
					$_arrCategories[$key]=array(
						'id'=>$key,
						'flag1'=>'on',
						'title'=>$value
					);
				}
				$_arrCategories[0]=array(
					'id'=>0,
					'flag1'=>'on',
					'title'=>$_strNewCategory
				);
				$_cat=new Project_Articles_Category();
				$_cat->set( $_notUsed, $this->out['arrError'], $_arrCategories );
				$model->getAdditional( $_arrCats );
				$_POST['import']['category'][0]=$_POST['import']['manually']['category']=0;
				foreach( $_arrCats['category'] as $key=>$value ){
					if( $value === $_strNewCategory ){
						$_POST['import']['category'][0]=$_POST['import']['manually']['category']=$key;
					}
				}
			}
			if ( !$model->import( $this->out['strJsonArticles'], $_POST['import'], $_FILES['import'] ) ) {
				$this->out['save_article_true'] = 2;
			}
		}
		$model->getAdditional( $this->out['arrSelect'] );
		$arrCategory = array();
		$i=0;
		foreach ($this->out['arrSelect']['category'] as $keyId=>$catName ) {
			$i++;
			$arrCategory[$i] = array('id' => $keyId, 'name' => $catName);
		}
		$this->out['categoryJson'] = Zend_Registry::get( 'CachedCoreString' )->php2json($arrCategory);
	}

	public function importpopup() { 
		$this->out['return_type'] = (  $_GET['return'] ) ?  $_GET['return'] : $this->params['return'] ; 
	
	
	}

	public function export() {
		$model = new Project_Articles();
		if ( !$model->export( $_strFileZip, @$_POST['ids'] ) ) {
			$this->location( array( 'action'=>'articles' ) );
		}
		header( "Content-type: application/octet-stream" );
		$_arr = explode( DIRECTORY_SEPARATOR, $_strFileZip );
		header( "Content-disposition: attachment; filename=".array_pop( $_arr ) );
		echo file_get_contents( $_strFileZip );
		exit;
	}

	public function advancedopt() {
		$model = new Project_Articles();
		$model->getAdditional( $this->out['arrSelect'] );
	}

	public function savedselections() {
		$this->out['arrPg']  = array(
			'page'=>@$_GET['page'], 
			'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
			'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],		
		);
		if ( isset($_GET['action']) ) {
			
		} else {
			if ( isset($_GET['del']) ) {
				$delId = intval( $_GET['del'] );
				$this->out['deleteResult'] = Project_Articles_Service::deleteSavedSelectionById( $delId ) ;
			}
			$this->out['arrItems'] = Project_Articles_Service::getSavedSelection( $this->out['arrPg']  );
			$this->out['arrSql'] = $arrSql;
		}
	}

	public function savedselections_edit() {
		if ( !isset($_GET['id']) ) {
			$this->location("../");
		}
		if ( isset($_POST['save']) ) {
			if ( Project_Articles_Service::setSavedSelectionById( intval( $_GET['id'] ), $_POST ) ) {
				$url = "../?messages=succes";
				$url .= ($_GET['page'])? "&page={$_GET['page']}":"";
				$this->location( $url );
			} else {
				$url = "../?messages=fail";
				$url .= ($_GET['page'])? "&page={$_GET['page']}":"";
				$this->location( $url );
			}
		}
		$this->out['arrItem'] = Project_Articles_Service::getSavedSelectionById( intval( $_GET['id'] ) );
	}

	public function multiboxselect() {
		$arrTmp = array();
		$this->out['type_input_element'] = "checkbox";
		if ( $_GET['type_input_element'] == "radio" ) {
			$this->out['type_input_element'] = "radio";
		}
		if( $_GET['content_type']!='pure_content' ){
			$model = new Project_Articles();
			$model->getAdditional( $this->out['arrSelect'] );
			$model->withCategory( @$_POST['category'] )
			->withPaging( array(
					'url'=>@$_GET,
					'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
					'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
				) )
			->withOrder( @$_GET['order'] )
			->getList( $this->out['arrArticles'] );
			$model->getFilter( $this->out['arrFilter'] );
			$model->getPaging( $this->out['arrPg'] );
		}else{
			Project_Content::factory( 4 )
				->setFilter( ((isset($_POST['arrCnt'][4]['settings'])&&is_array($_POST['arrCnt'][4]['settings']))?$_POST['arrCnt'][4]['settings']:array())+array('flg_language'=>1,'category_id'=>0) )
				->withPaging( array(
					'url'=>@$_GET,
					'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
					'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
				) )
				->getList( $this->out['arrArticles'] )
				->getPaging( $this->out['arrPg'] )
				->getFilter( $this->out['arrFilter'] );
			Project_Content::factory( 4 )
				->getAdditional( $_GET['pid'] )
				->setPost( array ('arrCnt' => array ( '4' => array ( 'settings' => array ('flg_language' => 1)))) )
				->getResult( $this->out['arrRes'] );
			$this->out['arrPureArtCategories'] = $this->out['arrRes'][4]['arrCategories'];
			$_arrCatWIthoutTree=array();
			foreach( $this->out['arrRes'][4]['arrTree'] as $_parent ){
				$_arrCatWIthoutTree[$_parent['id']]=$_parent['title'];
				if( $_parent['node'] != array() ){
					foreach( $_parent['node'] as $_child ){
						$_arrCatWIthoutTree[$_child['id']]=$_child['title'];
					}
				}
			}
			foreach( $this->out['arrArticles'] as &$_arrArticle ){
				$_arrArticle['category_title']=$_arrCatWIthoutTree[$_arrArticle['category_id']];
			}
			$this->out['arrCatArtTree'] = $this->out['arrRes'][4]['arrTree'];
		}
/*		
		$model->withCategory( @$_GET['category'] )->withPagging( array(
			'page'=>@$_GET['page'], 
			'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
			'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
		) )->getArticles( $this->out['arrArticles'] );
		$model->getPaging( $this->out['arrPg'] );
*/	}

	public function generatecode() {
		if ( isset($_GET['save_code']) ) {
			$this->out['save_code'] = Project_Articles_CodeGenerator::saveCode($_POST);
		} else {
			switch ( $_POST['optArt'] ) {
				case "art":
					$this->out['php'] =	Project_Articles_CodeGenerator::getCodeSingle( $_POST );
					break;
				case "randart":
					$this->out['php'] =	Project_Articles_CodeGenerator::getCodeRandom( $_POST );
					break;
				case "artcat":
					$this->out['php'] =	Project_Articles_CodeGenerator::getCodeNumber( $_POST );
					break;
				case "kwdart":
					$this->out['php'] =	Project_Articles_CodeGenerator::getCodeKeyword( $_POST );
					break;
				case "artsnip":
					$this->out['php'] =	Project_Articles_CodeGenerator::getCodeSnippets( $_POST );
					break;
			}
		}
	}
	
	public function getcode(){
		if (isset($_GET['type'])) {
			if ($_GET['type'] == 'art') {
				$this->out['arrItem']['code'] = Project_Articles_CodeGenerator::getCodeSingle($_GET);	
			}
			if ( $_GET['type'] == 'cat' ) {
				$this->out['arrItem']['code'] = Project_Articles_CodeGenerator::getCodeCategory($_GET['id']);
			}
		} else {
			$this->out['arrItem'] = Project_Articles_Service::getSavedSelectionById( $_GET['id'] );
		}
	}

	// там всё на js, данные все передаются из вне
	public function multiboxplace() {}
}
?>