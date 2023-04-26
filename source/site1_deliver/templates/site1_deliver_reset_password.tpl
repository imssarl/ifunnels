<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset password</title>
    <link rel="stylesheet" href="/skin/ifunnels-studio/dist/css/protect.bundle.css" />
</head>

<body>
    <div class="sign-in">
        <div class="form-body">
            <div class="img-holder">
                <div class="bg"></div>
                <div class="info-holder">
                    <img src="/skin/ifunnels-studio/dist/img/graphic2.svg" alt="" />
                </div>
            </div>

            <div class="form-holder">
                <div class="form-content">
                    <h3>Password Reset</h3>
                    <p>Enter a new passwordd</p>

                    <form method="POST">
                        
                        {if isset($status)}
                        <div class="alerts">
                            <div class="alert-message alert-{if ! $status}error{else}success{/if}">{$message}</div>
                        </div>
                        {/if}

                        <input class="form-control" type="password" name="arrData[password]" placeholder="Password" />
                        <input class="form-control" type="password" name="arrData[confirm_password]" placeholder="Confirm Password" />

                        <div class="form-button">
                            <button type="submit">Submit</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>

</html>