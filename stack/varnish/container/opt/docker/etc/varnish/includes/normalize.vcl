/*
 * Normalize the request to increase cache hit rate
 */

sub normalize_recv {
    # Normalize the query arguments
    # if (req.url !~ "^/magazin") {
    #  set req.url = std.querysort(req.url);
    #}

    # Strip a trailing ? if it exists
    if (req.url ~ "\?$") {
      set req.url = regsub(req.url, "\?$", "");
    }
}

sub normalize_deliver {
  # Remove some headers: PHP version
  unset resp.http.X-Powered-By;

  # Remove some headers: Apache version & OS
  unset resp.http.Server;
  unset resp.http.X-Drupal-Cache;
  unset resp.http.X-Varnish;
  unset resp.http.Via;
  unset resp.http.Link;
  unset resp.http.X-Generator;
  unset resp.http.X-Page-Speed;
  unset resp.http.X-Source;
  unset resp.http.X-Cache-Debug;
}