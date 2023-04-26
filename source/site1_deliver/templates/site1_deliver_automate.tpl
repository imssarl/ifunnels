<h4 class="page-title m-b-30">Automate Settings for <span class="label label-default">{$arrData.name}</span></h4>

<div class="card-box">
    <form method="post" action="">
        <div class="row">
            <div class="col-md-6">
                <div class="panel panel-color panel-info">
                    <div class="panel-heading">
                        <h3 class="panel-title">Email Funnels for Cart Abandonment</h3>
                    </div>
                    <div class="panel-body">
                        {foreach from=$arrEF item=ef}
                        <div class="checkbox checkbox-primary">
                            <input id="cl-1-{$ef.id}" type="checkbox" name="arrData[aic][]" value="{$ef.id}" {if in_array( $ef.id, $arrAIC )}checked{/if} />
                            <label for="cl-1-{$ef.id}">{$ef.title}</label>
                        </div>
                        {/foreach}
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="panel panel-color panel-primary">
                    <div class="panel-heading">
                        <h3 class="panel-title">Email Funnels for Customers</h3>
                    </div>
                    <div class="panel-body">
                        {foreach from=$arrEF item=ef}
                        <div class="checkbox checkbox-primary">
                            <input id="cl-2-{$ef.id}" type="checkbox" name="arrData[acc][]" value="{$ef.id}" {if in_array( $ef.id, $arrACC )}checked{/if} />
                            <label for="cl-2-{$ef.id}">{$ef.title}</label>
                        </div>
                        {/foreach}
                    </div>
                </div>
            </div>
        </div>

        <div class="form-group">
            <button type="submit" class="btn btn-default waves-effect waves-light">Save</button>
        </div>
    </form>
</div>