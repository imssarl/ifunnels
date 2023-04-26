<?php
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');

chdir(dirname(__FILE__));
chdir('../../');
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();

$_v = new Project_Validations();
$_t = new Project_Thechecker();
$_v->withStatus(0)->getList($_arrCheck);

// p($_arrCheck);

foreach ($_arrCheck as &$_data) {
    if (empty($_data['user_id'])) {
        continue;
    }

    $_return = '';
    Core_Users::getInstance()->setById($_data['user_id']);

    if (isset($_data['id_checker'])) {
        if ($_data['type'] == 3) {
            $_return = $_t->checkValidateJson($_data['id_checker']);
        } elseif ($_data['type'] == 2) {
            $_return = $_t->checkValidateJson($_data['id_checker']);
        }

        try {
            if (isset($_data['options']['update_status']) || isset($_data['options']['flg_remove'])) {
                Core_Sql::setConnectToServer('lpb.tracker');
            }

            if (isset($_data['options']['update_status'])) {
                $_time      = time();
                $_arrEmails = array();

                foreach ($_return['undeliverable'] as $updateTypes) {
                    foreach ($updateTypes as $email) {
                        $_arrEmails[] = $email;
                    }
                }

                if (!empty($_arrEmails)) {
                    Core_Sql::setExec('UPDATE s8rs_' . $_data['user_id'] . ' SET `status`="undeliverable", `status_data`="' . $_time . '" WHERE email IN (' . Core_Sql::fixInjection($_arrEmails) . ')');
                }

                $_arrEmails = array();
                foreach ($_return['risky'] as $updateTypes) {
                    foreach ($updateTypes as $email) {
                        $_arrEmails[] = $email;
                    }
                }

                if (!empty($_arrEmails)) {
                    Core_Sql::setExec('UPDATE s8rs_' . $_data['user_id'] . ' SET `status`="risky", `status_data`="' . $_time . '" WHERE email IN (' . Core_Sql::fixInjection($_arrEmails) . ')');
                }

                $_arrEmails = array();
                foreach ($_return['deliverable'] as $updateTypes) {
                    foreach ($updateTypes as $email) {
                        $_arrEmails[] = $email;
                    }
                }

                if (!empty($_arrEmails)) {
                    Core_Sql::setExec('UPDATE s8rs_' . $_data['user_id'] . ' SET `status`="deliverable", `status_data`="' . $_time . '" WHERE email IN (' . Core_Sql::fixInjection($_arrEmails) . ')');
                }
            }

            if (isset($_data['options']['flg_remove'])) {
                $_arrRemoveEmails = array();

                foreach ($_return['undeliverable']['rejected_email'] as $remove) {
                    $_arrRemoveEmails[] = $remove;
                }

                foreach ($_return['undeliverable']['invalid_email'] as $remove) {
                    $_arrRemoveEmails[] = $remove;
                }

                if (!empty($_arrRemoveEmails)) {

                    $_writer = new Zend_Log_Writer_Stream(Zend_Registry::get('config')->path->absolute->logfiles . 'EF_Contacts_Remove.log');
                    $_writer->setFormatter(new Zend_Log_Formatter_Simple("%timestamp% %priorityName% (%priority%): %message%\r\n"));
                    $_logger = new Zend_Log($_writer);
                    $_logger->info('-------------validation.php---------------');
                    $_logger->info(serialize($_SERVER));
                    $_logger->info('DELETE FROM s8rs_' . $_data['user_id'] . ' WHERE email IN (' . Core_Sql::fixInjection($_arrRemoveEmails) . ')');
                    $_logger->info('-------------validation.php---------------');

                    Core_Sql::setExec('DELETE FROM s8rs_' . $_data['user_id'] . ' WHERE email IN (' . Core_Sql::fixInjection($_arrRemoveEmails) . ')');
                }
            }

            if (isset($_data['options']['update_status']) || isset($_data['options']['flg_remove'])) {
                Core_Sql::renewalConnectFromCashe();
            }
        } catch (Exception $e) {
            if (isset($_data['options']['update_status']) || isset($_data['options']['flg_remove'])) {
                Core_Sql::renewalConnectFromCashe();
            }
        }

        if (!isset($_return['message']) && !empty($_return) && !isset($_return['status']['percentage'])) {
            $_v->setEntered(array(
                'id'      => $_data['id'],
                'options' => $_return,
                'status'  => 1,
            ))->set();
        }
    }
}

$_users = new Project_Users_Management();
$_users->onlyForValidation()->getList($_checkUser);

foreach ($_checkUser as $_data) {
    Core_Users::getInstance()->setById($_data['id']);
    $_subscribers = new Project_Subscribers($_data['id']);

    if (isset($_data['validation_mounthly']) && $_data['validation_mounthly'] < time() && !(isset($_data['validation_global']) && $_data['validation_global'] < time())) {
        $_subscribers->onlyMounthlyStatus();
    }

    if (isset($_data['validation_global']) && $_data['validation_global'] < time()) {
        $_subscribers->only6MounthlyStatus();
    }

    $_subscribers->getList($_arrEmailsFull);
    $_arrEmails = array();

    foreach ($_arrEmailsFull as $_email) {
        $_arrEmails[] = $_email['email'];
    }

    $_obj    = new Project_Thechecker();
    $_status = 0;
    $_valid  = new Project_Validations();

    if (!$_valid->getPayment(count($_arrEmails))) {
        $_status = 2;
        $_return = array('message' => 'Have no credits');
    } else {
        $_return = $_obj->sendList($_arrEmails);
    }

    if (!isset($_return['message']) && $_return !== false) {
        $_valid->setEntered(array(
            'name'       => 'Regular Validation #' . @$_return['id'],
            'id_checker' => @$_return['id'],
            'options'    => $_return + array('update_status' => true),
            'type'       => Project_Validations::CNM_LIST,
        ))->set();

        if (isset($_data['validation_mounthly']) && $_data['validation_mounthly'] < time() && !(isset($_data['validation_global']) && $_data['validation_global'] < time())) {
            Core_Sql::setExec('UPDATE u_users SET validation_mounthly=' . (time() + 60 * 60 * 24 * 30.25) . ' WHERE id="' . Core_Users::$info['id'] . '"');
        }

        if (isset($_data['validation_global']) && $_data['validation_global'] < time()) {
            Core_Sql::setExec('UPDATE u_users SET validation_global=' . (time() + 60 * 60 * 24 * 30.25 * 6) . ' WHERE id="' . Core_Users::$info['id'] . '"');
        }
    }
}
