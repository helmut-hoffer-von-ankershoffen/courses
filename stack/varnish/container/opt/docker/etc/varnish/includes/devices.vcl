sub devices_recv {
    set req.http.X-User-Agent-Type = "desktop";

    if (req.http.User-Agent ~ "(?i)(google|bot|spider|pinterest|crawler|archiver|flipboardproxy|mediapartners|facebookexternalhit|insights|quora|whatsapp|slurp)") {
        set req.http.X-User-Agent-Type = "crawler";
    }  elseif (
        req.http.User-Agent ~ "iP(hone|od)" ||
        req.http.User-Agent ~ "Android" ||
        req.http.User-Agent ~ "Symbian" ||
        req.http.User-Agent ~ "^BlackBerr$" ||
        req.http.User-Agent ~ "^Build/FROYO" ||
        req.http.User-Agent ~ "^XOOM"
       ) {
       set req.http.X-User-Agent-Type = "mobile";
    }
}

sub devices_hash {
    if (req.http.X-User-Agent-Type) {
        hash_data(req.http.X-User-Agent-Type);
    }
}

sub devices_deliver {
    # Add X-User-Agent-Type
    set resp.http.X-User-Agent-Type = req.http.X-User-Agent-Type;
}
