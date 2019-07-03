/*
 * Cp. https://varnish-cache.org/trac/wiki/VCLExampleRemovingSomeCookies#RemovingallBUTsomecookies
 */

sub cookies_prune_blacklist_recv {
    # Are there cookies left with only spaces or that are empty?
    if (req.http.cookie ~ "^\s*$") {
        unset req.http.cookie;
    }
}

sub cookies_prune_whitelist_recv {
    if (req.http.Cookie) {
        set req.http.Cookie = ";" + req.http.Cookie;
        set req.http.Cookie = regsuball(req.http.Cookie, "; +", ";");
        set req.http.Cookie = regsuball(req.http.Cookie, ";(PHPSESSID)=", "; \1=");
        set req.http.Cookie = regsuball(req.http.Cookie, ";[^ ][^;]*", "");
        set req.http.Cookie = regsuball(req.http.Cookie, "^[; ]+|[; ]+$", "");
    	set req.http.Cookie = regsuball(req.http.Cookie, "has_js=[^;]+(; )?", "");
    	set req.http.Cookie = regsuball(req.http.Cookie, "__utm.=[^;]+(; )?", "");

        # Are there cookies left with only spaces or that are empty?
        if (req.http.cookie ~ "^\s*$") {
            unset req.http.cookie;
        }
    }
}