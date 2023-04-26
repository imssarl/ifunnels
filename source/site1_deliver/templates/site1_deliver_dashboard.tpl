<link rel="stylesheet" href="/skin/ifunnels-studio/dist/css/dashboard.bundle.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css" />

<h4 class="page-title m-b-20">Dashboard</h4>

<div class="preloader-overlay">
    <div class="preloader-container">
        <div class="preloader"></div>
        <p>We're gathering your information, please wait as it may take some time</p>
    </div>

    <div class="panel panel-color panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">Filter</h3>
        </div>
        
        <div class="panel-body">
            <form method="get">
                <div class="row">
                    <div class="col-lg-12 form-inline">
                        <select name="arrFilter[time]" class="btn-group selectpicker show-tick m-r-10">
                            <option {if $smarty.get.arrFilter.time == 7}selected="selected"{/if} value="7">All</option>
                            <option {if $smarty.get.arrFilter.time == 1}selected="selected"{/if} value="1">Today</option>
                            <option {if $smarty.get.arrFilter.time == 2}selected="selected"{/if} value="2">Yesterday</option>
                            <option {if $smarty.get.arrFilter.time == 3}selected="selected"{/if} value="3">Last 7 days</option>
                            <option {if $smarty.get.arrFilter.time == 4 || empty( $smarty.get.arrFilter )}selected="selected"{/if} value="4">This month</option>
                            <option {if $smarty.get.arrFilter.time == 5}selected="selected"{/if} value="5">This year</option>
                            <option {if $smarty.get.arrFilter.time == 6}selected="selected"{/if} value="6">Last year</option>
                            <option {if $smarty.get.arrFilter.time == 8}selected="selected"{/if} value="8">Range date</option>
                        </select>

                        <div class="input-group m-r-10 {if $smarty.get.arrFilter.time != 8}hidden{/if}" data-filter="range_date">
                            <input type="text" class="form-control" placeholder="yyyy-mm-dd" id="datepicker" name="arrFilter[date_from]" value="{$smarty.get.arrFilter.date_from}">
                            <span class="input-group-addon bg-custom b-0 text-white"><i class="icon-calender"></i></span>
                        </div>

                        <div class="input-group m-r-10 {if $smarty.get.arrFilter.time != 8}hidden{/if}" data-filter="range_date">
                            <input type="text" class="form-control" placeholder="yyyy-mm-dd" id="datepicker2" name="arrFilter[date_to]" value="{$smarty.get.arrFilter.date_to}">
                            <span class="input-group-addon bg-custom b-0 text-white"><i class="icon-calender"></i></span>
                        </div>

                        <button type="submit" class="btn btn-success waves-effect waves-light">Filter</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="row">
        <div class="col-md-6 col-lg-3">
            <div class="widget-bg-color-icon card-box fadeInDown animated">
                <div class="bg-icon bg-icon-pink pull-left">
                    <i class="md md-add-shopping-cart text-pink"></i>
                </div>

                <div class="text-right">
                    <h3 class="text-dark"><b class="" id="memberships">0</b></h3>
                    <p class="text-muted">Memberships</p>
                </div>

                <div class="clearfix"></div>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="widget-bg-color-icon card-box">
                <div class="bg-icon bg-icon-info pull-left">
                    <i class="md md-attach-money text-info"></i>
                </div>

                <div class="text-right">
                    <h3 class="text-dark"><b class="" id="sales">0</b></h3>
                    <p class="text-muted">Sales</p>
                </div>

                <div class="clearfix"></div>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="widget-bg-color-icon card-box">
                <div class="bg-icon bg-icon-success pull-left">
                    <i class="md md-person text-success"></i>
                </div>

                <div class="text-right">
                    <h3 class="text-dark"><b class="" id="member">0</b></h3>
                    <p class="text-muted">Members</p>
                </div>

                <div class="clearfix"></div>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="widget-bg-color-icon card-box">
                <div class="bg-icon bg-icon-purple pull-left">
                    <i class="md md-perm-identity text-purple"></i>
                </div>

                <div class="text-right">
                    <h3 class="text-dark"><b class="" id="lead">0</b></h3>
                    <p class="text-muted">Leads</p>
                </div>

                <div class="clearfix"></div>
            </div>
        </div>
    </div>

    <div class="row m-b-20" style="display: flex;">
        <div class="col-md-7">
            <div class="card-box" style="height: 100%;">
                <h4 class="text-dark header-title m-t-0 m-b-30">Last 5 subscribers</h4>

                <table class="table table-responsive" id="last_subscribers">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Email</th>
                            <th>Membership</th>
                            <th>Added</th>  
                        </tr>
                    </thead>

                    <tbody>
                        <tr>
                            <td colspan="4" align="center">Empty</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="col-md-5">
            <div class="card-box" style="height: 100%;">
                <h4 class="text-dark header-title m-t-0 m-b-30">Members / Leads</h4>

                <div class="portlet-body" style="display: flex; height: 85%; align-items: center; justify-content: center;">
                    <div id="pie-chart" style="width: 100%;">
                        <canvas id="member_lead"></canvas>
                        <div class="clearfix"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row m-b-20" style="display: flex;">
        <div class="col-md-6">
            <div class="card-box" style="height: 100%;">
                <h4 class="text-dark header-title m-t-0 m-b-30">Payments</h4>

                <div class="portlet-body" style="display: flex;">
                    <div id="dia-chart" style="width: 100%;">
                        <canvas id="payments" style="height: 320px"></canvas>
                        <div class="clearfix"></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card-box" style="height: 100%;">
                <h4 class="text-dark header-title m-t-0 m-b-30">Last 10 Refund payments</h4>

                <table class="table table-responsive" id="last_refunds">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Member</th>
                            <th>Membership</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="4" align="center">Empty</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="row" style="display: flex;">
        <div class="col-md-6">
            <div class="card-box" style="height: 100%;">
                <h4 class="text-dark header-title m-t-0 m-b-30">Last 10 Rebills</h4>

                <table class="table table-responsive" id="last_rebills">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Member</th>
                            <th>Amount</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="4" align="center">Empty</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card-box" style="height: 100%;">
                <h4 class="text-dark header-title m-t-0 m-b-30">Rebills</h4>

                <div class="portlet-body" style="display: flex;">
                    <div id="rebills-chart" style="width: 100%;">
                        <canvas id="rebills" style="height: 320px"></canvas>
                        <div class="clearfix"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{literal}
<script>
    var request_url = '{/literal}{url name="site1_deliver" action="request"}{literal}';
    var params = '{/literal}{json_encode( $smarty.get )}{literal}';
</script>
{/literal}
<script src="/skin/ifunnels-studio/dist/js/dashboard.bundle.js"></script>