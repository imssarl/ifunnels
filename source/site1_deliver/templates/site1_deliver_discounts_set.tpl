<h4 class="page-title m-b-20">Create DisCount</h4>

<div class="card-box">
    {include file='../../error.tpl' fields=['name' => 'Name', 'discount_amount' => 'Discounted Amount', 'duration' => 'Discount Duration without Change', 'rate' => 'Decrease Rate', 'products' => 'Products']}

    <form action="" method="post">
        <input type="hidden" name="arrData[id]" value="{$arrData.id}" />

        <div class="form-group">
            <label for="" class="control-label">Name <span class="text-danger">*</span></label>
            <input type="text" name="arrData[name]" class="form-control" value="{$arrData.name}" />
        </div>

        <div class="form-group">
            <label for="" class="control-label">Select products, for which the discount will be applied <span class="text-danger">*</span></label>
            <select name="arrData[products][]" multiple class="selectpicker m-l-10" data-selected-text-format="count" data-live-search="true">
                {foreach from=$arrMemberships key=site item=list}
                <optgroup label="{$site}">
                    {foreach from=$list item=item}
                    <option value="{$item.id}" {if in_array($item.id, $arrData.products_id)}selected{/if}>{$item.name}</option>
                    {/foreach}
                </optgroup>
                {/foreach}
            </select>
        </div>

        <div class="form-group">
            <label class="control-label m-r-10">Apply to all recurring payments in case of subscription</label>
            <input type="hidden" name="arrData[recurring]" value="0" />
            <input type="checkbox" name="arrData[recurring]" {if !empty($arrData.recurring)}checked{/if} data-plugin="switchery" data-color="#5d9cec" value="1" />
        </div>

        <div class="form-group">
            <label class="control-label m-r-10">Conditional <small class="text-muted">(optional)</small></label>
            <input type="hidden" name="arrData[conditional][enabled]" value="0" />
            <input type="checkbox" name="arrData[conditional][enabled]" {if !empty($arrData.conditional.enabled)}checked{/if} data-type="conditional" data-plugin="switchery" data-color="#5d9cec" value="1" />
        </div>

        <div class="card-box {if empty($arrData.conditional.enabled) || $arrData.conditional.enabled == '0'}hidden{/if}" data-block="conditional">
            <div class="checkbox checkbox-primary form-inline">
                <input id="lead" type="checkbox" data-type="lead" {if !empty($arrData.conditional.lead)}checked{/if} />
                <label for="lead">If a customer is a Lead for product</label>

                <div class="form-group m-l-10 {if empty($arrData.conditional.lead)}hidden{/if}" data-block="lead">
                    <select name="arrData[conditional][lead][]" class="selectpicker" multiple data-selected-text-format="count" data-live-search="true">
                        {foreach from=$arrMemberships key=site item=list}
                        <optgroup label="{$site}">
                            {foreach from=$list item=item}
                            <option value="{$item.id}" {if in_array($item.id, $arrData.conditional.lead)}selected{/if}>{$item.name}</option>
                            {/foreach}
                        </optgroup>
                        {/foreach}
                    </select>
                </div>
            </div>

            <div class="checkbox checkbox-primary form-inline">
                <input id="member" type="checkbox" data-type="member" {if !empty($arrData.conditional.member)}checked{/if} />
                <label for="member">If a customer is a Member for product</label>

                <div class="form-group m-l-10 {if empty($arrData.conditional.member)}hidden{/if}" data-block="member">
                    <select name="arrData[conditional][member][]" class="selectpicker" multiple data-selected-text-format="count" data-live-search="true">
                        {foreach from=$arrMemberships key=site item=list}
                        <optgroup label="{$site}">
                            {foreach from=$list item=item}
                            <option value="{$item.id}" {if in_array($item.id, $arrData.conditional.member)}selected{/if}>{$item.name}</option>
                            {/foreach}
                        </optgroup>
                        {/foreach}
                    </select>
                </div>
            </div>
        </div>

        <div class="form-group">
            <label for="" class="control-label">Discounted Amount <span class="text-danger">*</span></label>
            <div class="input-group">
                <div class="input-group-btn">
                    <select name="arrData[discount_type]" class="bootstrap-selectpicker non-caret" data-style="btn-muted" data-width="38px">
                        <option value="1" {if $arrData.discount_type == '1'}selected{/if}>$</option>
                        <option value="2" {if $arrData.discount_type == '2'}selected{/if}>%</option>
                    </select>
                </div>

                <input type="text" name="arrData[discount_amount]" value="{$arrData.discount_amount}" class="form-control" />
            </div>
        </div>

        <div class="form-group">
            <label class="control-label m-r-10">Dynamic <small class="text-muted">(optional)</small></label>
            <input type="hidden" name="arrData[dynamic][enabled]" value="0" />
            <input type="checkbox" name="arrData[dynamic][enabled]" {if $arrData.dynamic.enabled == '1'}checked{/if} data-type="dynamic" data-plugin="switchery" data-color="#5d9cec" value="1" />
        </div>

        <div class="card-box {if empty($arrData.dynamic.enabled) || $arrData.dynamic.enabled == '0'}hidden{/if}" data-block="dynamic">
            <div class="form-group">
                <label for="" class="control-label">
                    Discount Duration without Change <span class="text-danger">*</span>
                </label>

                <div class="input-group">
                    <input type="text" name="arrData[dynamic][duration]" value="{$arrData.dynamic.duration}" class="form-control" />

                    <div class="input-group-btn">
                        <select name="arrData[dynamic][type]" class="bootstrap-selectpicker" data-style="btn-muted" data-width="auto">
                            <option value="hours" {if $arrData.dynamic.type == 'hours'}selected{/if}>Hours</option>
                            <option value="days" {if $arrData.dynamic.type == 'days'}selected{/if}>Days</option>
                            <option value="weeks" {if $arrData.dynamic.type == 'weeks'}selected{/if}>Weeks</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label for="" class="control-label">Decrease Rate <span class="text-danger">*</span></label>
                <input type="text" name="arrData[dynamic][rate]" value="{$arrData.dynamic.rate}" class="form-control" />
            </div>

            <div class="form-group">
                <label for="" class="control-label">Pause after X Days <small class="text-muted">(optional)</small></label>
                <input type="text" name="arrData[dynamic][pause_after]" value="{$arrData.dynamic.pause_after}" class="form-control" />
            </div>
        </div>

        <div class="form-group">
            <button type="submit" class="btn btn-default waves-effect waves-light btn-md">
                Save
            </button>
        </div>
    </form>
</div>

<script src="/skin/light/plugins/switchery/dist/switchery.min.js"></script>
<script src="/skin/light/plugins/autoNumeric/autoNumeric.js" type="text/javascript"></script>
<script src="/skin/site/dist/js/discounts.bundle.js"></script>