/*
 * Fail fast on pagespeed beacons
 */

sub pagespeed_recv {
    if (req.url ~ "^/ngx_pagespeed_beacon") {
        return (synth(750));
    }
}

sub pagespeed_synth {
    if (resp.status == 750) {
        # Set a status the client will understand
        set resp.status = 204;
        # Create our synthetic response
        synthetic("");
        return(deliver);
    }
}
