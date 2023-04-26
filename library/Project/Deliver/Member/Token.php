<?php

class Project_Deliver_Member_Token {

    private static $_table = 'deliver_member_token';

    /**
     * Create table on database
     *
     * @return void
     */
    public static function install() {
        try {
            Core_Sql::setConnectToServer( 'lpb.tracker' );

            Core_Sql::setExec( "DROP TABLE IF EXISTS deliver_member_token" );
		    Core_Sql::setExec( 
                "CREATE TABLE `deliver_member_token` (
                    `id` INT(11) NOT NULL AUTO_INCREMENT,
                    `member_id` INT(11) NULL DEFAULT NULL,
                    `token` VARCHAR(255) NULL DEFAULT NULL,
                    `added` INT(11) UNSIGNED NOT NULL DEFAULT '0',
                    UNIQUE INDEX `id` (`id`)
                )
                COLLATE='utf8_general_ci'
                ENGINE=InnoDB;" 
            );

            Core_Sql::renewalConnectFromCashe();
        } catch( Exception $e ) {
			Core_Sql::renewalConnectFromCashe();
			echo $e->getMessage();
		}
    }
    
    /**
     * Generate new token and saved in base
     *
     * @param [int] $uid
     * @return [string] - Generated token
     */
    public static function generateToken( $uid ) {
        if( empty( $uid ) ) {
            throw new Exception( 'Empty parameter {$uid}' );
        }

        $instance = new Project_Deliver_SignIn();
        $instance
            ->withCustomerId( $uid )
            ->onlyOne()
            ->getList( $uData );

        if( empty( $uData ) ) {
            throw new Exception( "Non-existent user with id $uid" );
        }

        $ip = null;

        if( ! empty( $_SERVER['HTTP_CLIENT_IP'] ) ) {
            $ip = $_SERVER['HTTP_CLIENT_IP'];
        } elseif( ! empty( $_SERVER['HTTP_X_FORWARDED_FOR'] ) ) {
            $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
        } else {
            $ip = $_SERVER['REMOTE_ADDR'];
        }

        $token = md5( $uData['secretkey'] . $ip );
        $added = time();

        try {
            Core_Sql::setConnectToServer( 'lpb.tracker' );
            Core_Sql::setExec( "INSERT INTO `deliver_member_token` (`member_id`, `token`, `added`) VALUES ( '$uid',  '$token', $added )" );
            Core_Sql::renewalConnectFromCashe();
        } catch( Exception $e ) {
			Core_Sql::renewalConnectFromCashe();
		}

        return $token;
    }

    /**
     * Check token
     *
     * @param [string] $token
     * @return [boolean or int]
     */
    public static function checkToken( $token ) {
        try {
            Core_Sql::setConnectToServer( 'lpb.tracker' );
            $result = Core_Sql::getRecord( sprintf( "SELECT * FROM `%s` WHERE token=%s", self::$_table, Core_Sql::fixInjection( $token ) ) );
            Core_Sql::renewalConnectFromCashe();

            if( ! $result ) {
                return false;
            }

            $ip = null;

            if( ! empty( $_SERVER['HTTP_CLIENT_IP'] ) ) {
                $ip = $_SERVER['HTTP_CLIENT_IP'];
            } elseif( ! empty( $_SERVER['HTTP_X_FORWARDED_FOR'] ) ) {
                $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
            } else {
                $ip = $_SERVER['REMOTE_ADDR'];
            }

            $instance = new Project_Deliver_SignIn();
            $instance
                ->withCustomerId( $result['member_id'] )
                ->onlyOne()
                ->getList( $signData );

            if( strcmp( $token, md5( $signData['secretkey'] . $ip ) ) === 0 ) {
                return $result['member_id'];
            }
            
            return false;
        } catch( Exception $e ) {
			Core_Sql::renewalConnectFromCashe();
        }
        
        return false;
    }

    /**
     * Remove tokens if 24 hours have passed
     *
     * @return void
     */
    public static function removeTokens() {
        $time = time() - 24 * 60 * 60;
        try {
            Core_Sql::setConnectToServer( 'lpb.tracker' );
            Core_Sql::setExec( sprintf( "DELETE FROM `%s` WHERE added < %s", self::$_table, $time ) );
            Core_Sql::renewalConnectFromCashe();
        } catch( Exception $e ) {
			Core_Sql::renewalConnectFromCashe();
		}
    }
}