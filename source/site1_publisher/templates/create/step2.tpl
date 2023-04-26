<div class="panel panel-default"> 
    <div class="panel-heading"> 
        <h4 class="panel-title"> 
            <a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseTwo-2" aria-expanded="false" class="collapsed">
               Content rewriting
            </a> 
        </h4> 
    </div> 
    <div id="collapseTwo-2" class="panel-collapse collapse"> 
        <div class="panel-body">
        	<fieldset>
				<div class="form-group">
					<input type="hidden" name="arrPrj[flg_rewriting]" value="0" />
					<div class="checkbox checkbox-primary">
						<input class="required not_started in_progress cross_linking completed" name="arrPrj[flg_rewriting]" type="checkbox" {if $arrPrj.flg_rewriting=='1'}checked="checked"{/if} value="1"/>
						<label>Use text rewriting<a style="text-decoration:none" class="Tips" title="Use rewrite text."><b> ?</b></a></label>
					</div>
				</div>
				<div class="form-group">
					<label>Select rewriting depth: </label>
					<select class="required not_started in_progress cross_linking completed medium-input btn-group selectpicker show-tick" name="arrPrj[selectdepth]" >
						<option value="{Core_Rewrite::LIGHT}" {if $arrPrj.selectdepth == {Core_Rewrite::LIGHT}||!empty($arrPrj.selectdepth)}selected="selected"{/if}>light</option>
						<option value="{Core_Rewrite::MODERATE}" {if $arrPrj.selectdepth == {Core_Rewrite::MODERATE}}selected="selected"{/if}>moderate</option>
						<option value="{Core_Rewrite::HIGH}" {if $arrPrj.selectdepth == {Core_Rewrite::HIGH}}selected="selected"{/if}>high</option>
					</select>
				</div class="form-group">
				<p style="display: none;"><a href="#" class="acc_prev button">Prev step</a> <a href="#" class="acc_next button">Next step</a></p>
			</fieldset>
        </div>
    </div>
</div>