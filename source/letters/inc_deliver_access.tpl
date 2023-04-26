<div style="background-color: #f6f6f6; font-family: sans-serif; -webkit-font-smoothing: antialiased; font-size: 14px; line-height: 1.4; margin: 0; padding: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;">
	<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; background-color: #f6f6f6; width: 100%;" width="100%" bgcolor="#f6f6f6">
	  	<tr>
			<td style="font-family: sans-serif; font-size: 14px; vertical-align: top;" valign="top">&nbsp;</td>
			<td style="font-family: sans-serif; font-size: 14px; vertical-align: top; display: block; max-width: 580px; padding: 10px; width: 580px; margin: 0 auto;" width="580" valign="top">
		  		<div style="box-sizing: border-box; display: block; margin: 0 auto; max-width: 580px; padding: 10px;">
					<table style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; background: #ffffff; border-radius: 3px; width: 100%;" width="100%">
				  		<tr>
							<td style="font-family: sans-serif; font-size: 14px; vertical-align: top; box-sizing: border-box; padding: 20px;" valign="top">
					  			<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;" width="100%">
									<tr>
						  				<td style="font-family: sans-serif; font-size: 14px; vertical-align: top;" valign="top">
											<p style="font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 15px;">Dear {$email}</p>
											<p style="font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 15px;">Thank you for purchasing <b>{$membership}</b>.<br/><br/></p>
											<p style="font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 15px;">Here are your login details to access the service:</p>
											<p style="font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0;">Login: {$email}</p>
											<p style="font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0;">Password: you should have received your password before, but you can always restore it by clicking <a href="{$forgot_link}">HERE</a></p>
											<p style="font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0;">{if ! empty( $membership_home_page_url )}Membership Home Page: {$membership_home_page_url}{/if}</p>
											<br/>
											<p style="font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 15px;">Hope you enjoy it!</p>
						  				</td>
									</tr>
					  			</table>
							</td>
				  		</tr>
					</table>
					<div style="clear: both; margin-top: 10px; text-align: center; width: 100%;">
					  	<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;" width="100%">
							<tr>
						  		<td style="font-family: sans-serif; vertical-align: top; padding-bottom: 10px; padding-top: 10px; color: #999999; font-size: 12px; text-align: center;" valign="top" align="center">
									© {date('Y',time())} <a href="https://ifunnels.com" target="_blank">ifunnels.com</a>, All Rights Reserved. 
						  		</td>
							</tr>
					  	</table>
					</div>
		  		</div>
			</td>
			<td style="font-family: sans-serif; font-size: 14px; vertical-align: top;" valign="top">&nbsp;</td>
  		</tr>
	</table>
</div>