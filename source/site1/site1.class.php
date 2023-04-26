<?php
/**
 * CNM Project
 *
 * @category CNM Project
 * @package ProjectSource
 */
class site1 extends Core_Module
{

    public function __construct()
    {
        //$_SERVER['HTTP_HOST']='syndication.qjmpz.com';
        $_arr       = array_chunk(array_reverse(explode('.', $_SERVER['HTTP_HOST'])), 2);
        $_strDomain = implode('.', array_reverse($_arr[0]));
        if ($_strDomain == 'qjmpz.com') {
            die('hi, this is the tracking server!');
        }
        parent::__construct();
    }

    public function set_cfg()
    {
        $this->inst_script = array(
            'module'  => array('title' => 'CNM Frontend'),
            'actions' => array(),
        );
    }

    public function before_run_parent()
    {
        $_group = new Core_Acs_Groups();
        $_group->bySysName(Core_Users::$info['groups'])->getList($this->out['arrCurrentGroups']);

        $_users = new Project_Users_Management();
        $_users->withIds(Core_Users::$info['id'])->onlyOne()->getList($this->out['arrUserData']);

        $_global                 = $this->objMR->getGlobalParams();
        $_checkDpa               = Project_Documents::getBySysName('dpa');
        $this->out['flgShowDPA'] = false;

        if (!empty($_checkDpa)) {
            if (!empty($_global)) {
                $_rights = new Core_Acs_Rights();
                $_rights->withRight($this->out['arrUserData']['right'][$_global['name'] . '_@_' . $_global['action']])->getGroups2right($_arrL);

                if ((!isset(Core_Users::$info['dpa_agree_date']) || Core_Users::$info['dpa_agree_date'] < $_checkDpa['edited']) && $_global['name'] . '_@_' . $_global['action'] != 'site1_accounts_@_dpa' && !isset($_arrL['4'])) {
                    $this->out['flgShowDPA'] = true;
                }
            } elseif (isset(Core_Users::$info['id']) && !empty(Core_Users::$info['id'])) { // странный баг с загрузкой главной страницы
                if ((!isset(Core_Users::$info['dpa_agree_date']) || Core_Users::$info['dpa_agree_date'] < $_checkDpa['edited'])) {
                    $this->out['flgShowDPA'] = true;
                }
            }
        }

        Core_Users::updateStatistic();
        $this->out['intercomUpdatedGroups'] = '';
        foreach ($this->out['arrCurrentGroups'] as $k => $group) {
            if (!in_array($group['title'], array(
                'Default',
                'Support',
                'Email test',
                'Creative Niche Manager 2.0',
                'Popup IO Admin',
                'LPB Admin',
                'Exclusive Content',
                'Campain Opt Pro',
                'Popups IO',
                'Content Builder Beta',
                'Facebook Messenger Bot', 'Free Zonterest Site', 'Zonterest Custom 2.0', 'Zonterest PRO 2.0', 'Zonterest 2.0', 'Copy Prophet', 'Campaign Opt Pro', 'Super Affiliate Package 1', 'Commission Gorilla Partners Offer', 'User Manager PRO', 'User Manager', '100kFactory', 'LPB 100000 Visitors', 'DFY', 'PopUps IO', 'Blog Fusion CSP+', 'Blog Fusion CSP', 'Sub Account', 'Service Provider', 'Zonterest Light', 'Content Website Builder', 'Zonterest PRO', 'Zonterest', 'Domain Parking', 'Video Site Bot', 'Advertiser', 'CNM1.0', 'Clickbank', 'NVSB Hosted Pro', 'NVSB Hosted', 'Syndication review', 'Blog Fusion', 'Site Profit Bot Advanced', 'Visitor', 'Content Admin', 'System Users', 'Super Admin',

            ))) {
                if ($k != 0) {
                    $this->out['intercomUpdatedGroups'] .= ',';
                }
                $this->out['intercomUpdatedGroups'] .= str_replace(array('Affiliate Funnels', 'Lead Profit Systems'), array('AF', 'LPS'), $group['title']);
            }
        }

        if (strlen($this->out['intercomUpdatedGroups']) > 255) {
            $this->out['intercomUpdatedGroups'] = substr($this->out['intercomUpdatedGroups'], 0, 252) . '...';
        }

        unset(Core_Users::$info['send2Intercome']);

        if (!empty($_GET['logout'])) {
            Core_Users::getInstance()->retrieveFromCashe();
            $this->location();
        }

        if (count(Core_Users::$info['groups']) == 2 && isset(Core_Users::$info['groups']['15']) && isset(Core_Users::$info['groups']['102']) && count($this->objML->stack) == 1) { // ONLY FOR Affiliate Funnels Starter
            header('Location: ' . Core_Module_Router::getCurrentUrl(array('name' => 'site1_funnels', 'action' => 'dashboard')));
            exit;
        }
    }

    public function get_client_ip_env()
    {
        $ipaddress = '';
        if (getenv('HTTP_CLIENT_IP')) {
            $ipaddress = getenv('HTTP_CLIENT_IP');
        } else if (getenv('HTTP_X_FORWARDED_FOR')) {
            $ipaddress = getenv('HTTP_X_FORWARDED_FOR');
        } else if (getenv('HTTP_X_FORWARDED')) {
            $ipaddress = getenv('HTTP_X_FORWARDED');
        } else if (getenv('HTTP_FORWARDED_FOR')) {
            $ipaddress = getenv('HTTP_FORWARDED_FOR');
        } else if (getenv('HTTP_FORWARDED')) {
            $ipaddress = getenv('HTTP_FORWARDED');
        } else if (getenv('REMOTE_ADDR')) {
            $ipaddress = getenv('REMOTE_ADDR');
        } else {
            $ipaddress = 'UNKNOWN';
        }

        return $ipaddress;
    }

    public function after_run_parent()
    {
        /*
        if(
        ( isset( $_SESSION['USER']['email'] ) && isset( $_COOKIE['loginName'] ) && strtolower($_SESSION['USER']['email']) != strtolower($_COOKIE['loginName'])
        && strtolower($_SESSION['USER']['email'])!='cadmin@cnm.info' )
        || !in_array( $this->get_client_ip_env(), array( '127.0.0.1', '92.107.28.31', '93.85.82.142', '194.158.200.242', '37.215.35.109', '94.194.64.121', '151.230.149.94' ) ) && Core_Users::$info['id'] == 1
        ){
        $_writer=new Zend_Log_Writer_Stream( Zend_Registry::get('config')->path->absolute->logfiles.'Users_Login_Data_All.log' );
        $_writer->setFormatter( new Zend_Log_Formatter_Simple("%timestamp% %priorityName% (%priority%): %message%\r\n") );
        $_logger=new Zend_Log( $_writer );
        $_logger->info('ip:'.$this->get_client_ip_env() );
        $_logger->info(serialize($_COOKIE) );
        $_logger->info($_SESSION['USER']['email']);
        $_logger->info(serialize($_SERVER) );
        $_logger->info('============================================================================================');
        setcookie("loginName", '', time()-3000);
        Core_Users::logout();
        unset( $_SESSION['flgFirstLogin'] );
        $this->location();
        }
         */

        // TODO On/Off maintenance on production
        // $this->temporaryUnavailable();
    }

    private function temporaryUnavailable()
    {
        $this->out['temporaryUnavailable'] = true;
        if (!empty($_GET['personnel']) && $_GET['personnel'] == 'Rdh4325dhUhfho23ejqfq2fHJEhd32') {
            $this->out['temporaryUnavailable'] = false;
            $_SESSION['personnel']             = 'Rdh4325dhUhfho23ejqfq2fHJEhd32';
        } elseif (!empty($_SESSION['personnel']) && $_SESSION['personnel'] == 'Rdh4325dhUhfho23ejqfq2fHJEhd32') {
            $this->out['temporaryUnavailable'] = false;
        }
    }

    public function breadcrumb()
    {}

    public function head()
    {}
}
