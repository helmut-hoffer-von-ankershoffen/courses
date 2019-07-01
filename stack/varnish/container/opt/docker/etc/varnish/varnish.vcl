vcl 4.0;

import std;
import directors;

include "/opt/docker/etc/varnish/fos/fos_ban.vcl";
include "/opt/docker/etc/varnish/fos/fos_refresh.vcl";

include "/opt/docker/etc/varnish/includes/assets.vcl";
include "/opt/docker/etc/varnish/includes/backend.vcl";
include "/opt/docker/etc/varnish/includes/badbot.vcl";
include "/opt/docker/etc/varnish/includes/caching.vcl";
include "/opt/docker/etc/varnish/includes/cookies.vcl";
include "/opt/docker/etc/varnish/includes/debug.vcl";
include "/opt/docker/etc/varnish/includes/devices.vcl";
include "/opt/docker/etc/varnish/includes/director.vcl";
include "/opt/docker/etc/varnish/includes/normalize.vcl";
include "/opt/docker/etc/varnish/includes/pagespeed.vcl";
include "/opt/docker/etc/varnish/includes/probe.vcl";
include "/opt/docker/etc/varnish/includes/tracking.vcl";
include "/opt/docker/etc/varnish/includes/websocket.vcl";
include "/opt/docker/etc/varnish/includes/wp.vcl";


acl invalidators {
     "localhost";
     # Add any other IP addresses that your application runs on and that you
     # want to allow invalidation requests from. For instance:
     # "192.168.1.0"/24;
}

# Called at the beginning of a request, after the complete request has been received and parsed.
# Its purpose is to decide whether or not to serve the request, how to do it, and, if applicable,
# which backend to use.
# also used to modify the request
sub vcl_recv {

    call badbot;

    # Used to switch of caching partly or completely for dev by setting the environment variable as needed
    if (req.http.host ~ "<VARNISH_HOST_NEVER_CACHE_REGEX>") {
        return (pass);
    }
    call probe_recv;
    call devices_recv;
    call pagespeed_recv;
    call director_recv;
    call websocket_recv;
    call normalize_recv;
    call fos_refresh_recv;
    call fos_ban_recv;
    call tracking_prune_recv;
    call cookies_prune_blacklist_recv;
    call assets_recv;
    call wp_recv;
    call caching_rules_recv;
}

sub vcl_hash {
    call devices_hash;
    call caching_hash;
}

# Handle the HTTP request coming from our backend
sub vcl_backend_response {
    # retry if backend is down
    if (beresp.status == 503 && bereq.retries < 3 ) {
        return(retry);
    }

    call fos_ban_backend_response;
    call assets_backend_response;
    call wp_backend_response;
    call caching_rules_backend_response;
}

# The routine when we deliver the HTTP request to the user
# Last chance to modify headers that are sent to the client
sub vcl_deliver {
    call fos_ban_deliver;
    call devices_deliver;
    # call debug_deliver;
    call normalize_deliver;
}

sub vcl_backend_error {
    set beresp.http.Content-Type = "text/html; charset=utf-8";
    synthetic(std.fileread("/opt/docker/etc/varnish/html/5xx.html"));
    return (deliver);
}

sub vcl_synth {
    call pagespeed_synth;
}
