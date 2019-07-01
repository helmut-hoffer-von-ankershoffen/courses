backend default {
    .host = "<VARNISH_BACKEND_HOST>";
    .port = "<VARNISH_BACKEND_PORT>";
    .max_connections        = <VARNISH_BACKEND_MAX_CONNECTIONS>;
    .first_byte_timeout     = <VARNISH_BACKEND_FIRST_BYTE_TIMEOUT>;     # How long to wait before we receive a first byte from our BACKEND?
    .connect_timeout        = <VARNISH_BACKEND_CONNECT_TIMEOUT>;        # How long to wait for a backend connection?
    .between_bytes_timeout  = <VARNISH_BACKEND_BETWEEN_BYTES_TIMEOUT>;  # How long to wait between bytes received from our BACKEND?

    .probe = {
        .request =
          "GET <VARNISH_BACKEND_PROBE_PATH> HTTP/1.1"
          "Host: <VARNISH_BACKEND_PROBE_HOST>"
          "X-Forwarded-Proto: <VARNISH_BACKEND_PROBE_FORWARDED_SCHEME>"
          "Connection: close"
          "User-Agent: Varnish Health Probe";
        .interval  = <VARNISH_BACKEND_PROBE_INTERVAL>s; # check the health of each backend every 5 seconds
        .timeout   = 1s; # timing out after 1 second.
        .window    = 5;  # If 3 out of the last 5 polls succeeded the backend is considered healthy, otherwise it will be marked as sick
        .threshold = <VARNISH_BACKEND_PROBE_THRESHOLD>;
    }
}