/*
 * Dynamically set the Expires header on every response.
 */
sub expires_deliver {
    if (resp.http.x-obj-ttl) {
        # 1. Calculate and reset the Expires header.
        # (0s is just a fallback value)
        set resp.http.Expires = "" + (now + std.duration(resp.http.x-obj-ttl, 0s));
        # 2. Delete the temporary header from the response.
        unset resp.http.x-obj-ttl;
    }
}
