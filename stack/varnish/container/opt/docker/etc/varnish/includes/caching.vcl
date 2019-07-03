/*
 * Cache given rules in addition to respecting cachng response headers
 */

sub caching_rules_recv {

    // always cache cache-me
    if (req.url == "/cache-me") {
        unset req.http.Cookie;
    } else {
        // cache nothing else if the user is logged in
        if (req.http.Cookie ~ "app_user") {
            return (pass);
        }
    }

    // Unset what the browser tells us
    unset req.http.cache-control;
    unset req.http.pragma;

    // move the cookie so the inbuilt rules of varnish will call vcl_hash even if cookies are set
    set req.http.Cookie-Backup = req.http.Cookie;
    unset req.http.Cookie;

    if (req.method == "HEAD") {
        return (pass);
    }

}

sub caching_hash {
    if (req.http.Cookie-Backup) {
        // restore the cookies before the lookup if any
        set req.http.Cookie = req.http.Cookie-Backup;
        unset req.http.Cookie-Backup;
    }
    hash_data(req.http.X-Forwarded-Proto);
}

sub caching_rules_backend_response {

    # don't cache >= 400 responses
    if (beresp.status >= 400 ) {
        unset beresp.http.Cache-Control;
        set beresp.uncacheable = true;
        set beresp.ttl = 0s;
        set beresp.grace = 0s;
        return (deliver);
    }

    // always cache given path
    if (bereq.url == "/cache-me") {
        // so unset cookies and set the ttl for this
        unset beresp.http.Set-Cookie;
        unset beresp.http.Cache-Control;
        set beresp.ttl = 24h;
        return (deliver);
    }

    // always cache given header
    if (beresp.http.X-Type == "FORCE_CACHE") {
        unset beresp.http.Set-Cookie;
        unset beresp.http.Cache-Control;
        set beresp.ttl = 24h;
        return (deliver);
    }

    // Do not cache 301 and 302 redirects
    if (beresp.status == 302 || beresp.status == 301) {
        unset beresp.http.Cache-Control;
        set beresp.uncacheable = true;
        set beresp.ttl = 0s;
        return (deliver);
    }

    # set the default cache time of 24 hours
    set beresp.ttl = 24h;
    return (deliver);

}
