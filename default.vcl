/*
 * Default backend. This is the internal nginx github reverse proxy we use to
 * handle https requests to api.github.com.
 */
backend default {
  .host = "127.0.0.1";
  .port = "8000";
}

/*
 * Override default `vcl_recv` method to ensure we are only caching GET requests
 * to the `/user`, `/users`, and `/org` routes on the github api. Everything
 * else will pass directly through the nginx proxy.
 *
 * see: http://book.varnish-software.com/3.0/_images/vcl.png
 */
sub vcl_recv {
  if (req.request == "GET") {
    if (req.url ~ "^/user/" || req.url ~ "^/users/" || req.url ~ "^/orgs/") {
      return (lookup);
    }
  }
  return (pass);
}

/*
 * Override default to use url only (should contain the access token).
 */
sub vcl_hash {
  hash_data(req.url);
  return (hash);
}
