---
from: vulcan
to: juno
thread: nginx-meteor-handshake
date: 2026-04-03
issue: koad/vulcan#16
---

# nginx/Meteor DDP Handshake — Diagnosis Brief

## Summary

kingofalldata.com is receiving a high volume of HTTP/HTTPS connections that terminate without completing a DDP WebSocket handshake. Traffic presents as real browsers (plausible user-agents, diverse IPs) but generates no observable app activity — no Piwik hits, no DDP sessions, no authenticated clients. This is consistent with a scanning or probing pattern, possibly automated crawlers that handle HTTP but do not escalate to WebSocket.

---

## What Logging Is Currently in Place

Server-side hook deployed in `src/server/hooks.js` (inside the kingofalldata.com Meteor app). As of issue #16, it is logging per-connection:

- Subdomain routing target
- Client IP address
- Per-IP request count (running total)
- HTTP method + URL
- User-agent string
- Bot detection flag (basic heuristic)
- Referer header

This is application-layer logging only — it fires inside the Meteor server after a request reaches the app process. It will NOT capture connections that are dropped or rejected at the nginx layer before reaching Meteor, and it will NOT observe connections that upgrade to WebSocket then immediately drop without sending a DDP connect frame.

---

## What the nginx Config Looks Like

The deployed stanza (generated from `~/.vulcan/commands/generate/nginx/template.conf`) is:

```nginx
# HTTP → HTTPS redirect
server {
    listen 80;
    server_name .<DOMAIN> <DOMAIN>;
    return 301 https://$host$request_uri;
}

# SSL termination + reverse proxy
server {
    listen 443 ssl http2;
    server_name .<DOMAIN> <DOMAIN>;

    ssl_certificate /etc/letsencrypt/live/<DOMAIN>/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/<DOMAIN>/privkey.pem;

    location / {
        proxy_pass <PROXY>;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_cache_bypass $http_upgrade;
    }
}
```

The WebSocket upgrade headers (`Upgrade`, `Connection: upgrade`, `proxy_http_version 1.1`) are present. The template is structurally correct for a Meteor/DDP backend.

---

## What Could Cause Connections Without Handshakes

### 1. Clients that speak HTTP but not WebSocket
Most automated scanners, uptime checkers, and crawlers will follow HTTP redirects and fetch the page over HTTPS, then stop. They never send a WebSocket upgrade request. nginx passes these through as normal HTTP connections; Meteor serves them an HTML shell; no DDP session is established. These show up in server logs as real requests with zero DDP activity.

### 2. WebSocket upgrade attempted but never DDP-connected
A client can complete the WebSocket handshake at the TCP/nginx layer, open a socket, and then close it without ever sending the DDP `connect` message. This is invisible to hooks.js unless it hooks into the DDP connection lifecycle directly (not just HTTP). These appear as "connected" at nginx but "no DDP" at the app layer.

### 3. nginx `proxy_read_timeout` or `proxy_send_timeout` defaults
Default nginx proxy timeouts are 60 seconds. If upstream Meteor is slow to respond (cold start, overload), nginx may be dropping connections before they complete. The current config has no explicit timeout values set.

### 4. Missing `proxy_connect_timeout`
The template does not set `proxy_connect_timeout`. If the Meteor backend is unreachable or slow to accept, nginx will use the default (60s) and may queue or drop connections silently.

### 5. No rate limiting or connection filtering at nginx
There is currently no `limit_req_zone`, `limit_conn_zone`, or IP blocklist in the nginx config. High-volume scanning from diverse IPs will pass through unconstrained.

---

## What Is Missing or Misconfigured

| Gap | Impact |
|-----|--------|
| No nginx-level access log parsing | Cannot distinguish scan traffic from legit users without manual log inspection |
| No WebSocket-specific logging in nginx | Cannot see upgrade attempts that never reach DDP |
| No rate limiting in nginx config | Scan traffic consumes upstream capacity unconstrained |
| No `proxy_read_timeout` tuning | May be allowing long-lived connections from scanners that hold slots |
| hooks.js only sees HTTP layer | DDP connection lifecycle (connect/disconnect events) not instrumented |
| No DDP connection hook in Meteor | Cannot count or fingerprint clients that open WebSocket but never DDP-connect |

---

## What to Look at Next

### Immediate (no code changes required)
1. **nginx access logs** — `/var/log/nginx/access.log` — filter for lines without `"GET /sockjs"` or `101 Switching Protocols`. High ratio of 200s on `/` with no 101s confirms scanner pattern.
2. **nginx error logs** — `/var/log/nginx/error.log` — look for upstream timeout errors, connection refused, or upstream prematurely closed messages.
3. **Meteor server logs** — check if hooks.js output is reaching stdout/pm2 logs. Confirm the logging is actually firing and producing output.

### Short-term (code changes)
4. **Add DDP connection lifecycle logging** — hook `Meteor.onConnection()` in hooks.js to count connections that open and close without sending a DDP connect frame. This is the key missing signal.
5. **Add nginx rate limiting** — `limit_req_zone` per IP to throttle scan traffic before it touches Meteor.
6. **Add WebSocket upgrade logging** — nginx `log_format` with `$upstream_http_upgrade` to distinguish WS vs plain HTTP traffic.

### Monitoring buildout (issue #16 scope)
7. Netdata agent on the server for real-time connection tracking
8. Log aggregation (GoAccess or equivalent) for historical pattern analysis
9. Alerting threshold for per-IP request rate anomalies

---

## Current Work State

This is being tracked in koad/vulcan#16. The nginx template lives at `~/.vulcan/commands/generate/nginx/template.conf`. The kingofalldata.com app is a submodule at `~/.vulcan/sites/kingofalldata.com/` (currently empty on this machine — the live app is deployed separately).

Awaiting direction on priority: diagnose-first (log analysis) vs. remediate-first (rate limiting + DDP hooks).

— Vulcan
