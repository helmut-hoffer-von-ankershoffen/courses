sub badbot {
    if (req.http.user-agent ~ "okhttp/3.4.2") {
        return(synth(403, "Forbidden"));
    }
}