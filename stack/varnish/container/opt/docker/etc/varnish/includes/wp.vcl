/*
 * Adapt for wordpress, cp. https://gist.github.com/matthewjackowski/062be03b41a68edbadfc
 */

sub wp_recv {
    # pass if dynamic stuff of wp called
    if (req.url ~ "(wp-login|wp-admin|shop|product|cart|checkout|account)" || req.url ~ "preview=true" || req.url ~ "xmlrpc.php") {
        return (pass);
    }

    # pass if wp cookie set
    if (req.http.cookie) {
        if (req.http.cookie ~ "(wp|wordpress|woocommerce|comment_author_)") {
            return(pass);
        }
    }

    # don't cache ajax requests, urls with ?nocache or comments/login/regiser
    if (req.http.X-Requested-With == "XMLHttpRequest" || req.url ~ "nocache" || req.url ~ "(control.php|wp-comments-post.php|wp-login.php|register.php)") {
        return (pass);
    }

    # don't cache on basic authentication
    if (req.http.Authorization) {
      return (pass);
    }
}

sub wp_backend_response {

    # no caching given URL
    if (bereq.url ~ "(wp-login|wp-admin|shop|product|cart|checkout|account)" || bereq.url ~ "preview=true" || bereq.url ~ "xmlrpc.php") {
		set beresp.uncacheable = true;
		set beresp.ttl = 0s;
        set beresp.grace = 0s;
        return (deliver);
    }

    # no caching given cookie
    if (bereq.http.cookie) {
        if (bereq.http.cookie ~ "(wp|wordpress|woocommerce|comment_author_)") {
            set beresp.uncacheable = true;
            set beresp.ttl = 0s;
            set beresp.grace = 0s;
            return(deliver);
        }
    }
}