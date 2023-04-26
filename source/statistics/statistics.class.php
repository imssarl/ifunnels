<?php
/**
 * WorkHorse Framework
 *
 * @category WorkHorse
 * @package ProjectSource
 * @license http://opensource.org/licenses/ MIT License
 * @copyright Copyright (c) 2005-2012, Rodion Konnov
 * @author Rodion Konnov <kindzadza@mail.ru>
 * @date 22.11.2011
 * @version 2.0
 */


/**
 * Statistics
 *
 * @category WorkHorse
 * @package ProjectSource
 * @copyright Copyright (c) 2005-2012, Rodion Konnov
 * @license http://opensource.org/licenses/ MIT License
 */
class statistics extends Core_Module {

	public final function set_cfg() {
		$this->inst_script=array(
			'module'=>array(
				'title'=>'Statistics',
			),
			'actions'=>array(
				array( 'action'=>'creditsinternal', 'title'=>'Credits Internal Transactions' ),
				array( 'action'=>'creditsexternal', 'title'=>'Credits External Transactions' ),
				array( 'action'=>'rewards', 'title'=>'Credits Reward Transactions' ),
				array( 'action'=>'cnmstatistics', 'title'=>'CNM Statistics' ),
			),
		);
	}

	public function rewards(){
		$_model=new Core_Payment_Purse();
		$_model
				->withType(array(Core_Payment_Purse::TYPE_REWARD_SITES,Core_Payment_Purse::TYPE_REWARD_HOSTING))
				->withPaging( array( 'url'=>$_GET ) )
				->withUsers()
				->getList( $this->out['arrList'] )
				->getPaging( $this->out['arrPg'] );
	}

	public function cnmstatistics(){
		$_statistics=new Project_Statistics();
		$_statistics->getTotalNumberOfMembers( $this->out['totalNumberOfMembers'] );
		$_statistics->getNumberDomainsPurchased( $this->out['DomainsPurchased'] );
		$_statistics->getNumberDomainHosted( $this->out['DomainsHosted'] );
		$_statistics->getNumberMembersWhoBoughtCredits( $this->out['BoughtCredits'] );
		$_statistics->getNumberCreditsConsumed( $this->out['CreditsConsumed'] );
		$_statistics->getNumberCreditsPurchased( $this->out['CreditsPurchased'] );
		$this->out['arrPg']=$_statistics->getWhoUsingHosting( $this->out['arrList'] );
	}

	public function creditsinternal(){
		$_model=new Core_Payment_Purse();
		$_model
				->onlyInternal()
				->withPaging( array( 'url'=>$_GET ) )
				->withUsers()
				->getList( $this->out['arrList'] )
				->getPaging( $this->out['arrPg'] );
	}

	public function creditsexternal(){
		$_model=new Core_Payment_Purse();
		$_model
				->onlyExternal()
				->withPaging( array( 'url'=>$_GET ) )
				->withUsers()
				->getList( $this->out['arrList'] )
				->getPaging( $this->out['arrPg'] );
	}

}
?>