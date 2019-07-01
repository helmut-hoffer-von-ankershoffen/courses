backend default {
    .host = "<VARNISH_BACKEND_HOST>";
    .port = "<VARNISH_BACKEND_PORT>";
    .max_connections        = <VARNISH_BACKEND_MAX_CONNECTIONS>;
    .first_byte_timeout     = <VARNISH_BACKEND_FIRST_BYTE_TIMEOUT>;     # How long to wait before we receive a first byte from our BACKEND?
    .connect_timeout        = <VARNISH_BACKEND_CONNECT_TIMEOUT>;        # How long to wait for a backend connection?
    .between_bytes_timeout  = <VARNISH_BACKEND_BETWEEN_BYTES_TIMEOUT>;  # How long to wait between bytes received from our BACKEND?
}