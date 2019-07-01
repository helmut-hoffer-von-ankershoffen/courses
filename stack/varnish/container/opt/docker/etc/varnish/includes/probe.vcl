/*
 * Cache given rules in addition to respecting cachng response headers
 */

sub probe_recv {

    // do not cache healtchecks
    if (req.http.User-Agent == "Varnish Health Probe" || req.http.User-Agent == "Go-http-client/1.1") {
        return (pass);
    }

}
