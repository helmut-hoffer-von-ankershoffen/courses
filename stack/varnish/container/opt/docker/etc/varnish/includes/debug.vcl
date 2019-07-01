/*
 * Show debug info in response
 */

sub debug_deliver {
    # Add X-Cache header if debugging is enabled
    # if (resp.http.X-Cache-Debug) {
        if (obj.hits > 0) {
            set resp.http.X-Cache = "HIT";
        } else {
            set resp.http.X-Cache = "MISS";
        }
        set resp.http.X-Cache-Hits = obj.hits;
    # }
}
