# SSH

Only `ssh/config` is managed here.

Put machine-specific hosts, identities, and secrets in local files:

- `~/.ssh/config.d/*.conf`
- `~/.ssh/config.local`

Do not commit private keys, public keys, known hosts, agent sockets, or machine-specific secrets.
