/*
 * Prune tracking stuff to increase cache hit rate
 */

sub tracking_prune_recv {
    set req.http.Cookie = regsuball(req.http.Cookie, "(^|(?<=; )) *__utm.=[^;]+;? *", "\1"); # removes all cookies named __utm? (utma, utmb...) - tracking thing
    if (req.url ~ "\?(adParams|client|cx|eid|fbid|feed|ref(id|src)?|v(er|iew))=") {
        set req.url = regsub(req.url, "\?.*$", "");
    }
}
