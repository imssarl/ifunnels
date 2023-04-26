<?php

class Project_Deliver_Automate extends Core_Data_Storage
{

    protected $_table = 'deliver_automate';
    protected $_fields = array('id', 'membership_id', 'member_id', 'added');

    private $_withOutAfterTime = false;
    private $_afterTime        = 1 * 15 * 60; // Time after which to call the trigger for adding a user to automation (default 15 mins)
    private $_withMembershipId = false;
    private $_withMemberId     = false;

    /** Installing */
    public static function install()
    {
        Core_Sql::setExec("DROP TABLE IF EXISTS deliver_automate");
        Core_Sql::setExec(
            "CREATE TABLE `deliver_automate` (
				`id` INT(11) NOT NULL AUTO_INCREMENT,
				`membership_id` INT(11) NOT NULL DEFAULT '0',
				`member_id` INT(11) NOT NULL DEFAULT '0',
				`added` INT(11) UNSIGNED NOT NULL DEFAULT '0',
				UNIQUE INDEX `id` (`id`)
			)
			COLLATE='utf8_general_ci'
			ENGINE=InnoDB;"
        );
    }

    public function withOutAfterTime()
    {
        $this->_withOutAfterTime = true;
        return $this;
    }

    public function withMembershipId($membership_id)
    {
        $this->_withMembershipId = $membership_id;
        return $this;
    }

    public function withMemberId($member_id)
    {
        $this->_withMemberId = $member_id;
        return $this;
    }

    protected function assemblyQuery()
    {
        parent::assemblyQuery();

        if ($this->_withMembershipId) {
            $this->_crawler->set_where('d.membership_id=' . Core_Sql::fixInjection($this->_withMembershipId));
        }

        if ($this->_withMemberId) {
            $this->_crawler->set_where('d.member_id=' . Core_Sql::fixInjection($this->_withMemberId));
        }

        if (!$this->_withOutAfterTime) {
            // Select record if the set time has passed
            $this->_crawler->set_where('d.added <= ' . (time() - $this->_afterTime));
        }
    }

    protected function init()
    {
        parent::init();
        $this->_withMembershipId = false;
        $this->_withMemberId     = false;
        $this->_withOutAfterTime = false;
    }

    /**
     * Add new record
     *
     * @param [int] $membership_id
     * @param [int] $member_id
     * @return boolean
     */
    public static function add($membership_id, $member_id)
    {
        $membership = new Project_Deliver_Membership();
        $membership
            ->withIds($membership_id)
            ->onlyOne()
            ->getList($membershipData);

        if ($membershipData['enable_automate'] === '1' && !empty($membershipData['aic']) && !empty($membershipData['acc'])) {
            $instance = new self();

            return $instance
                ->setEntered(['membership_id' => $membership_id, 'member_id' => $member_id])
                ->set();
        }

        return false;
    }

    /**
     * Trigger event on automate
     *
     * @param [int] $membership_id
     * @param [int] $member_id
     * @return boolean
     */
    public static function triggerAutomate($membership_id, $member_id)
    {
        $instance = new self();
        $instance
            ->withMembershipId($membership_id)
            ->withMemberId($member_id)
            ->withOutAfterTime()
            ->getList($triggerData);

        if (empty($triggerData)) {
            return false;
        }

        $member = new Project_Deliver_Member();
        $member
            ->withIds($member_id)
            ->onlyOne()
            ->getList($memberData);

        Project_Automation::setEvent(Project_Automation_Event::$type['COMPLETED_CHECKOUT'], $membership_id, $memberData['email'], ['user_id' => $memberData['user_id']]);
        return $instance->withIds(array_column($triggerData, 'id'))->del();
    }

    /**
     * Run event INITIATED_CHECKOUT on automate after passed 1 hours
     *
     * @return void
     */
    public static function run()
    {
        $instance = new self();
        $instance
            ->withOutAfterTime()
            ->getList($triggersData);

        $member = new Project_Deliver_Member();

        if (!empty($triggersData)) {
            foreach ($triggersData as $data) {
                $member
                    ->withIds($data['member_id'])
                    ->onlyOne()
                    ->getList($memberData);

                Project_Automation::setEvent(Project_Automation_Event::$type['INITIATED_CHECKOUT'], $data['membership_id'], $memberData['email'], ['user_id' => $memberData['user_id']]);
                $instance->withIds($data['id'])->del();
            }
        }
    }
}
