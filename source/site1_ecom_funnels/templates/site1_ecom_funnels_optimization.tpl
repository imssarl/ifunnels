<h3>Optimization</h3>

<div class="card-box">
    <table class="table table-responsive table-striped">
        <thead>
            <tr>
                <th>Funnel Title</th>
                <th>Funnel URL</th>
                <th>Optimization Test Name</th>
                <th>Options</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$arrPages item=page}
            <tr>
                <td>{$page.sites_name}</td>
                <td><strong><a href="{$page.url}{$page.pages_name}.php" target="_blank" rel="noopener noreferrer">{$page.url}{$page.pages_name}.php</a></td>
                <td data-test-name>{$page.optimization_test.name}</td>
                <td><a href="#settings-modal" data-toggle="modal" title="Settings" data-test="{$page.testab_page_id}"><i class="ion-settings text-custom" style="font-size: 18px;"></i></a></td>
            </tr>

            <tr class="hidden">
                <td colspan="4">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Variation</th>
                                
                                <th class="text-center"># of Visitors</th>
                
                                <th class="text-center"># of Leads</th>
                                <th class="text-center">Leads Value, $</th>
                                <th class="text-center">Leads Conversion Rate, %</th>
                
                                <th class="text-center"># of Registrations</th>
                                <th class="text-center">Registrations Value, $</th>
                                <th class="text-center">Registrations Conversion Rate, %</th>
                
                                <th class="text-center"># of Sales</th>
                                <th class="text-center">Sales Value, $</th>
                                <th class="text-center">Sales Conversion Rate, %</th>
                            </tr>
                        </thead>
                
                        <tbody>
                            {foreach from=$stats[$page.id] key=v item=stat}
                            <tr class="text-center">
                                <td>{$v}</td> 
                                <td>{$stat.view}</td> 

                                <!-- Lead -->
                                <td>{$stat.lead}</td> 
                                <td>
                                    {if $page.optimization_test.goals.lead.enable === 'true' && ! empty($page.optimization_test.goals.lead.value)}
                                    {$stat.lead * $page.optimization_test.goals.lead.value}
                                    {else}
                                    -
                                    {/if}
                                </td>
                                <td>
                                    <span>
                                        {$stat.crt} ({$stat.calc})
                                        {if $v != '#'}
                                        <br><small class="text-{if $stat.improvement > 0}custom{else}danger{/if}">{$stat.improvement}%</small>&nbsp;<small>(CTW: {$stat.chance_to_win}%)</small>
                                        {/if}
                                    </span>
                                </td>
                                <!-- Lead End -->

                                <!-- Registration -->
                                <td>{$stat.registration}</td> 
                                <td>
                                    {if $page.optimization_test.goals.registration.enable === 'true' && ! empty($page.optimization_test.goals.registration.value)}
                                    {$stat.registration * $page.optimization_test.goals.registration.value}
                                    {else}
                                    -
                                    {/if}
                                </td> 
                                <td>
                                    <span>
                                        {$stat.crt_reg} ({$stat.calc_reg})
                                        {if $v != '#'}
                                        <br><small class="text-{if $stat.improvement_reg > 0}custom{else}danger{/if}">{$stat.improvement_reg}%</small>&nbsp;<small>(CTW: {$stat.chance_to_win_reg}%)</small>
                                        {/if}
                                    </span>
                                </td> 
                                <!-- Registration End -->

                                <!-- Sale -->
                                <td>{$stat.sale}</td> 
                                <td>
                                    {if $page.optimization_test.goals.sale.enable === 'true' && ! empty($page.optimization_test.goals.sale.value)}
                                    {$stat.sale * $page.optimization_test.goals.sale.value}
                                    {else}
                                    -
                                    {/if}
                                </td> 
                                <td>
                                    <span>
                                        {$stat.crt_sale} ({$stat.calc_sale})
                                        {if $v != '#'}
                                        <br><small class="text-{if $stat.improvement_sale > 0}custom{else}danger{/if}">{$stat.improvement_sale}%</small>&nbsp;<small>(CTW: {$stat.chance_to_win_sale}%)</small>
                                        {/if}
                                    </span>
                                </td> 
                                <!-- Sale End -->
                             </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </td>
            </tr>
            {foreachelse}
            <tr><td colspan="4" align="center">Empty</td></tr>
            {/foreach}
        </tbody>
    </table>
</div>

<!-- sample modal content -->
<div id="settings-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title" id="myModalLabel">Settings</h4>
            </div>

            <div class="modal-body">
                <form>
                    <div class="alert alert-success hidden">
                        <strong>Success!</strong> Update was saved successfully.
                    </div>

                    <div class="form-group">
                        <label for="" class="control-label"># of days to run this test</label>
                        <input name="days" type="number" id="days" min="0" class="form-control">
                    </div>

                    <div class="form-group">
                        <label for="" class="control-label"># of visitors to limit this test</label>
                        <input name="visitors" type="number" id="visitors" min="0" class="form-control">
                    </div>

                    <div class="form-group">
                        <div class="checkbox checkbox-custom">
                            <input name="auto_optimize" id="auto-optimize" type="checkbox" value="1" disabled>
                            <label for="auto-optimize">Auto Optimize</label>    
                            <br>
                            <span class="text-muted small" style="margin-left: -20px;">Note: automatically selects and displays the winning variation at the end of the test</span>
                        </div>    
                    </div>

                    <div class="form-group">
                        <label>Weight of the variants</label>

                        <div data-variants></div>
                    </div>
                </form>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default waves-effect" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary waves-effect waves-light" id="save_settings">Save changes</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<link rel="stylesheet" href="/skin/site/dist/css/optimization.bundle.css">
{literal}
<script>
    var ajaxURL = '{/literal}{url name="site1_ecom_funnels" action="ajax"}{literal}';
</script>
{/literal}
<script src="/skin/site/dist/js/optimization.bundle.js"></script>