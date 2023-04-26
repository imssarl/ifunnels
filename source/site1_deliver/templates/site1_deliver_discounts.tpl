<h4 class="page-title m-b-20">DisCounts 
    <a href="{url name='site1_deliver' action='discounts_set'}" class="btn btn-success btn-rounded waves-effect waves-light m-l-10">
        <span class="btn-label"><i class="fa fa-plus-circle"></i></span>
        Create DisCount
    </a>
</h4>

<div class="card-box">
    <table class="table table-stiped">
        <thead>
            <th width="40%">Name</th>
            <th width="40%">Products</th>
            <th width="10%">Discounted Amount</th>
            <th width="10%">Options</th>
        </thead>

        <tbody>
            {foreach from=$arrDiscounts item=discount}
            <tr>
                <td>{$discount.name}</td>

                <td>
                    {foreach from=$discount.products item=product}
                    <span class="label label-{if $product.type == '1'}primary{else}default{/if} m-b-5 p-5 d-inline-block">{$product.name}</span>
                    {/foreach}
                </td>

                <td align="center"><span class="badge badge-danger">{if $discount.discount_type == '1'}&dollar;{$discount.discount_amount}{else}{$discount.discount_amount}&percnt;{/if}</span></td>

                <td>
                    <a href="#" class="m-l-5 m-r-5" data-btn="play" data-id="{$discount.id}"><i class="{if $discount.flg_pause == '0'}ion-pause{else}ion-play{/if} text-danger" style="font-size: 19px; vertical-align: bottom;"></i></a>
                    <a href="{url name='site1_deliver' action='discounts_set'}?id={$discount.id}" class="m-l-5 m-r-5" title="Edit DisCount"><i class="ion-edit text-warning" style="font-size: 18px; vertical-align: bottom;"></i></a> 
					<a href="?delete={$discount.id}" class="delete m-l-5 m-r-5" title="Delete DisCount"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111;"></i></a>
					<a href="#" class="reset m-l-5 m-r-5" data-id="{$discount.id}" title="Reset DisCount"><i class="ion-refresh text-muted" style="font-size: 20px; vertical-align: bottom;"></i></a>
                </td>
            </tr>
            {foreachelse}
            <tr>
                <td colspan="4" align="center">Empty List</td>
            </tr>
            {/foreach}
        </tbody>
    </table>

    {include file="../../pgg_backend.tpl"}
</div>

<script>
    var ajaxUrl = '{url name="site1_deliver" action="request"}';
</script>
<script src="/skin/site/dist/js/discounts.bundle.js"></script>