---
id: RC-0003
title: Enable remote device access to local app
type: spike
status: backlog
value: 4                   # high UX value — phone review workflow
effort: 2                  # pick one approach and wire it up
urgency: 3                 # needed for mobile review workflow
risk: 2                    # external dependency on tunnel/deploy tool
score: 3.5                 # (4 + 3) / 2
owner: dave
created: 2026-03-14
updated: 2026-03-14
completed:
parent: null
depends_on: [RC-0002]
area: infrastructure
adr_refs: []
links: []
labels: [devops, mobile]
---

## Why

The app runs on localhost but needs to be accessible from an iPhone
or other devices for testing and daily use. Currently there is no
routable IP from the phone to the dev machine.

## Outcome

A documented, repeatable way to access the running app from a phone
browser with minimal friction.

## Options to Evaluate

### 1. ngrok (recommended for quick access)
- `ngrok http 4567` gives a public HTTPS URL
- Free tier has session limits; paid tier for stable subdomain
- No install on the phone, just open the URL in Safari
- Tradeoff: traffic goes through ngrok servers

### 2. Tailscale (recommended for persistent access)
- Mesh VPN, install on both machine and phone
- Access via stable Tailscale IP (e.g., `http://100.x.x.x:4567`)
- No port forwarding, works across networks
- Tradeoff: requires Tailscale account and app on phone

### 3. SSH reverse tunnel
- `ssh -R 8080:localhost:4567 your-server`
- Access via `http://your-server:8080`
- Requires a remote server you control
- Tradeoff: manual setup, depends on SSH connection staying up

### 4. Deploy to cloud (Fly.io / Render / Railway)
- Push to a PaaS, get a persistent public URL
- Good for sharing with others
- Tradeoff: need to manage deployment, may need DB changes for persistence

### 5. Local network (same Wi-Fi)
- `rackup -o 0.0.0.0 -p 4567` and find machine's local IP
- Works when both devices share a network
- Tradeoff: doesn't work across networks, IP may change

## Acceptance Criteria

- [ ] Pick one approach and document setup steps
- [ ] Verify app loads and functions on iPhone Safari
- [ ] Add startup script or Makefile target for the chosen approach

## Notes

- For development: ngrok is fastest to get going
- For daily use: Tailscale is more stable and private
- For sharing/demo: cloud deploy is best

## LLM Context

- Files likely affected: `Makefile` or `bin/` scripts, `README.md`
- Invariants to preserve: app must still work on plain localhost
- Style constraints: keep it simple, one-command startup
- Known traps: ngrok free tier rotates URLs on restart
