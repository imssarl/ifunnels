Dear Dear {if empty($buyer_name) && empty({$buyer_surname})}User{else}{$buyer_name} {$buyer_surname}{/if}<br/>
<br/>
Thank you for joining <b>{$moduls}</b>.<br/><br/>
Here are your login details to access the service:<br/>
&nbsp;&nbsp;<a href="{Zend_Registry::get( 'config' )->domain->url}">{Zend_Registry::get( 'config' )->domain->url}</a><br/>
&nbsp;&nbsp;Login: {$email}<br/>
{if !empty($password)}&nbsp;&nbsp;Password: {$password}<br/>{/if}
<br/>
Would you need some help, please browse our tutorials at: <a href="https://creativenichemanager.zendesk.com/forums">https://creativenichemanager.zendesk.com/forums</a><br/>
<br/>
iFunnels Team