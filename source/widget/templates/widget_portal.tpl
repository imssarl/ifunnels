<html>
<head>
<meta name="GENERATOR" content="Microsoft FrontPage 12.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>1stInfoNow</title>
<style>
<!--
a            { font-family: Tahoma; font-size: 11.5px; color: #222A45; text-decoration: none; font-weight: bold }
a:hover    { font-family: Tahoma; font-size: 11.5px; text-decoration: underline; color: #BC1B00; font-weight: bold }
a:visited    { font-family: Tahoma; font-size: 11.5px; text-decoration: none; color: #222A45; font-weight: bold }
-->
</style>
<script type="text/javascript"><!--
google_ad_client = "{$data.adsense_id}";
google_ad_width = 728;
google_ad_height = 90;
/*
google_ad_format = "##ad_format##";
google_ad_type ="##ad_type##";
google_ad_channel ="##adsense_channel##";
google_color_border = "##color_border##";
google_color_bg = "##color_bg##";
google_color_link = "##color_link##";
google_color_url = "##color_url";
google_color_text = "##color_text##";
google_alternate_ad_url = "##alternurl##";
*/
//--></script>
</head>
<body>
<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="750" id="AutoNumber1">
    <tr>
      <td>
      <table border="0" cellpadding="3" cellspacing="3" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber2">
        <tr>
          <td width="100%" colspan="2">
			  <div align="center"><script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script><br /><br />&nbsp;</div>
		  </td>
        </tr>
        <tr>
	  		<td valign="top" width="50%">
				<ul>
			{foreach from=$arrContent item=i key=k name=j}
				<li><b><font face="Tahoma" size="2"><a href="./{$i.primary_keyword|replace:' ':'_'}/">{$i.primary_keyword}</a></font></b></li>
				{if ( $smarty.foreach.j.iteration >= (count($arrContent)/2) ) && !isset($flag)}{assign var=flag value=1}</ul></td><td width="50%" valign="top"><ul>{/if}
			{/foreach}
				</ul>
			</td>
        </tr>
        <tr>
          <td width="100%" colspan="2">&nbsp;</td>
        </tr>
        <tr>
          <td width="100%" colspan="2">
		  		<p class="style1" align="center">
                <font face="Verdana" size="1" color="#919191">WEBSITE URL</font><font face="Verdana" size="1" color="#919191"> &copy;YEAR</span></font></p>
		  </td>
        </tr>
      </table>
      </td>
    </tr>
  </table>
  </center>
</div>
</body>
</html>