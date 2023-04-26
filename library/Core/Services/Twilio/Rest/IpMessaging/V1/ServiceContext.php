<?php

/**
 * This code was generated by
 * \ / _    _  _|   _  _
 * | (_)\/(_)(_|\/| |(/_  v1.0.0
 * /       /
 */

namespace Twilio\Rest\IpMessaging\V1;

use Twilio\Exceptions\TwilioException;
use Twilio\InstanceContext;
use Twilio\Options;
use Twilio\Rest\IpMessaging\V1\Service\ChannelList;
use Twilio\Rest\IpMessaging\V1\Service\RoleList;
use Twilio\Rest\IpMessaging\V1\Service\UserList;
use Twilio\Values;
use Twilio\Version;

/**
 * @property \Twilio\Rest\IpMessaging\V1\Service\ChannelList channels
 * @property \Twilio\Rest\IpMessaging\V1\Service\RoleList roles
 * @property \Twilio\Rest\IpMessaging\V1\Service\UserList users
 * @method \Twilio\Rest\IpMessaging\V1\Service\ChannelContext channels(string $sid)
 * @method \Twilio\Rest\IpMessaging\V1\Service\RoleContext roles(string $sid)
 * @method \Twilio\Rest\IpMessaging\V1\Service\UserContext users(string $sid)
 */
class ServiceContext extends InstanceContext {
    protected $_channels = null;
    protected $_roles = null;
    protected $_users = null;

    /**
     * Initialize the ServiceContext
     * 
     * @param \Twilio\Version $version Version that contains the resource
     * @param string $sid The sid
     * @return \Twilio\Rest\IpMessaging\V1\ServiceContext 
     */
    public function __construct(Version $version, $sid) {
        parent::__construct($version);
        
        // Path Solution
        $this->solution = array(
            'sid' => $sid,
        );
        
        $this->uri = '/Services/' . $sid . '';
    }

    /**
     * Fetch a ServiceInstance
     * 
     * @return ServiceInstance Fetched ServiceInstance
     */
    public function fetch() {
        $params = Values::of(array());
        
        $payload = $this->version->fetch(
            'GET',
            $this->uri,
            $params
        );
        
        return new ServiceInstance(
            $this->version,
            $payload,
            $this->solution['sid']
        );
    }

    /**
     * Deletes the ServiceInstance
     * 
     * @return boolean True if delete succeeds, false otherwise
     */
    public function delete() {
        return $this->version->delete('delete', $this->uri);
    }

    /**
     * Update the ServiceInstance
     * 
     * @param array|Options $options Optional Arguments
     * @return ServiceInstance Updated ServiceInstance
     */
    public function update($options = array()) {
        $options = new Values($options);
        
        $data = Values::of(array(
            'FriendlyName' => $options['friendlyName'],
            'DefaultServiceRoleSid' => $options['defaultServiceRoleSid'],
            'DefaultChannelRoleSid' => $options['defaultChannelRoleSid'],
            'DefaultChannelCreatorRoleSid' => $options['defaultChannelCreatorRoleSid'],
            'ReadStatusEnabled' => $options['readStatusEnabled'],
            'TypingIndicatorTimeout' => $options['typingIndicatorTimeout'],
            'ConsumptionReportInterval' => $options['consumptionReportInterval'],
            'Webhooks' => $options['webhooks'],
        ));
        
        $payload = $this->version->update(
            'POST',
            $this->uri,
            array(),
            $data
        );
        
        return new ServiceInstance(
            $this->version,
            $payload,
            $this->solution['sid']
        );
    }

    /**
     * Access the channels
     * 
     * @return \Twilio\Rest\IpMessaging\V1\Service\ChannelList 
     */
    protected function getChannels() {
        if (!$this->_channels) {
            $this->_channels = new ChannelList(
                $this->version,
                $this->solution['sid']
            );
        }
        
        return $this->_channels;
    }

    /**
     * Access the roles
     * 
     * @return \Twilio\Rest\IpMessaging\V1\Service\RoleList 
     */
    protected function getRoles() {
        if (!$this->_roles) {
            $this->_roles = new RoleList(
                $this->version,
                $this->solution['sid']
            );
        }
        
        return $this->_roles;
    }

    /**
     * Access the users
     * 
     * @return \Twilio\Rest\IpMessaging\V1\Service\UserList 
     */
    protected function getUsers() {
        if (!$this->_users) {
            $this->_users = new UserList(
                $this->version,
                $this->solution['sid']
            );
        }
        
        return $this->_users;
    }

    /**
     * Magic getter to lazy load subresources
     * 
     * @param string $name Subresource to return
     * @return \Twilio\ListResource The requested subresource
     * @throws \Twilio\Exceptions\TwilioException For unknown subresources
     */
    public function __get($name) {
        if (property_exists($this, '_' . $name)) {
            $method = 'get' . ucfirst($name);
            return $this->$method();
        }
        
        throw new TwilioException('Unknown subresource ' . $name);
    }

    /**
     * Magic caller to get resource contexts
     * 
     * @param string $name Resource to return
     * @param array $arguments Context parameters
     * @return \Twilio\InstanceContext The requested resource context
     * @throws \Twilio\Exceptions\TwilioException For unknown resource
     */
    public function __call($name, $arguments) {
        $property = $this->$name;
        if (method_exists($property, 'getContext')) {
            return call_user_func_array(array($property, 'getContext'), $arguments);
        }
        
        throw new TwilioException('Resource does not have a context');
    }

    /**
     * Provide a friendly representation
     * 
     * @return string Machine friendly representation
     */
    public function __toString() {
        $context = array();
        foreach ($this->solution as $key => $value) {
            $context[] = "$key=$value";
        }
        return '[Twilio.IpMessaging.V1.ServiceContext ' . implode(' ', $context) . ']';
    }
}