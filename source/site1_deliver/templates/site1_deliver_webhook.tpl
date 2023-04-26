<h4 class="page-title m-b-20">Webhook for <span class="label label-default">{$arrData.name}</span></h4>

<div class="card-box">
    <form method="POST">
        <div class="form-group">
            <label class="label-control">Webhook URL</label>
            <input type="text" class="form-control" name="arrData[webhook_url]" value="{$arrData.webhook_url}" />
        </div>

        <div class="form-group">
			<button type="submit" class="btn btn-default waves-effect waves-light btn-md">
				Save
			</button>
		</div>
    </form>

    {if ! empty( $arrLogs )}
    <div class="form-group m-t-30">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Logs</h3>
            </div>
            <div class="panel-body">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th width="45%">Data of send</th>
                            <th width="45%">Response</th>
                            <th width="10%">Date and time of send</th>
                        </tr>
                    </thead>
        
                    <tbody>
                        {foreach from=$arrLogs item=log}
                        <tr>
                            <td>
                                <pre>{var_export( $log.data )}</pre>
                            </td>
                            <td>
                                <pre>{var_export( $log.response )}</pre>
                            </td>
                            <td>{date('Y-m-d H:i:s', $log.added)}</td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    {/if}
</div>