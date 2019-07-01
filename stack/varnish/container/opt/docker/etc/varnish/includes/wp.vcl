/*
 * Adapt for wordpress, cp. https://gist.github.com/matthewjackowski/062be03b41a68edbadfc
 */

sub wp_recv {
    # pass if dynamic stuff of wp called
    if (req.url ~ "(wp-login|wp-admin)" || req.url ~ "preview=true" || req.url ~ "xmlrpc.php") {
        return (pass);
    }

    # pass if wp cookie set
    if (req.http.cookie) {
        if (req.http.cookie ~ "(wordpress_|wp-settings-)") {
            return(pass);
        }
    }
}

sub wp_backend_response {

    # deliver without pruning cookies when in admin part of wp
    if (bereq.url ~ "(wp-login|wp-admin)" || bereq.url ~ "preview=true" || bereq.url ~ "xmlrpc.php") {
        return (deliver);
    }

}