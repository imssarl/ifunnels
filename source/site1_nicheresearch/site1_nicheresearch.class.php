<?php
/**
 * CNM Project
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 * @author Rodion Konnov <kindzadza@mail.ru>
 * @date 12.04.2012
 * @version 1.0
 */


/**
 * Niche Research module
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 */
class site1_nicheresearch extends Core_Module {

	public function set_cfg(){
		$this->inst_script=array(
			'module'=>array( 'title'=>'CNM Niche Research', ),
			'actions'=>array(
				array( 'action'=>'main', 'title'=>'Main', 'flg_tree'=>1 ),
				array( 'action'=>'top', 'title'=>'Top 1000 Niches', 'flg_tree'=>1 ),
				array( 'action'=>'random', 'title'=>'Random Idea', 'flg_tree'=>1 )
			),
		);
	}

	public function main(){
		$_model=new Project_Nicheresearch();
		if(!empty($_GET['word'])){
			$_model ->withOrder( @$_GET['order'] )
					->withPaging( array(
						'url'=>@$_GET,
						'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
						'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],))
					->withWord( $_GET['word'] )
					->getList($this->out['arrList'])
					->getPaging( $this->out['arrPg'] )
					->getFilter( $this->out['arrFilter'] );
			$this->out['word']=htmlspecialchars($_GET['word']);
		}
	}

	public function top(){
		$_model=new Project_Nicheresearch();
		$_model ->withOrder( @$_GET['order'] )
				->onlyTop()
				->withPaging( array(
					'url'=>@$_GET,
					'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
					'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],))
				->getList($this->out['arrList'])
				->getPaging( $this->out['arrPg'] )
				->getFilter( $this->out['arrFilter'] );
	}

	public function random(){
		$_model=new Project_Nicheresearch();
		$_model ->withRandom()
				->getList($this->out['arrList'])
				->getPaging( $this->out['arrPg'] )
				->getFilter( $this->out['arrFilter'] );
	}
}

?>