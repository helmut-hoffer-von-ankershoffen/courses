sub wp_recv {

    # pass on dynamic stuff
    if (req.url ~ "(admin|control|comments|register|login|account|logout|lost-password|shop|product|cart|checkout|addons)" || req.url ~ "(preview|add-to-cart)" || req.url ~ "(xmlrpc|api)") {
        return (pass);
    }

    # pass on relevant cookie set
    if (req.http.cookie ~ "(wp|wordpress|woocommerce|comment|author)") {
        return(pass);
    }

    # pass on ajax requests and urls with ?nocache
    if (req.http.X-Requested-With == "XMLHttpRequest" || req.url ~ "nocache") {
        return (pass);
    }

    # pass on basic authentication
    if (req.http.Authorization) {
      return (pass);
    }

}

sub wp_backend_response {

    # no caching on dynamic stuff
    if (bereq.url ~ "(admin|control|comments|register|login|account|logout|lost-password|shop|product|cart|checkout|addons)" || bereq.url ~ "(preview|add-to-cart)" || bereq.url ~ "(xmlrpc|api)") {
		set beresp.uncacheable = true;
		set beresp.ttl = 0s;
        set beresp.grace = 0s;
        return (deliver);
    }

    # no caching on relevant cookie set
    if (bereq.http.cookie ~ "(wp|wordpress|woocommerce|comment|author)") {
        set beresp.uncacheable = true;
        set beresp.ttl = 0s;
        set beresp.grace = 0s;
        return(deliver);
    }

    # no caching on ajax requests and urls with ?nocache
    if (bereq.http.X-Requested-With == "XMLHttpRequest" || bereq.url ~ "nocache") {
        return (pass);
    }

    # no caching on basic authentication
    if (bereq.http.Authorization) {
        set beresp.uncacheable = true;
        set beresp.ttl = 0s;
        set beresp.grace = 0s;
        return(deliver);
    }

}