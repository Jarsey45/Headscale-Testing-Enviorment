# Headscale Test Environment

Test setup for Headscale with multiple client types and ACL configurations.

Sharing this, because i needed utility for testing Headscale ACLs fast.
Features an example ACL list (not really good).

## Structure

```
headscale-test/
├── clients/          # Tailscale client containers
├── config/           # Headscale configuration and ACLs
├── docker/           # Headscale server and Headplane UI
├── headplane/        # Headplane web UI configuration
├── keys/             # Key storage
└── run/              # Runtime files
```

## Setup

You can use docker or podman, whatever you like :)

1. Create network:

```bash
podman network create headscale-net
```

2. Copy environment file:

```bash
cp clients/.env.example clients/.env
```

3. Start Headscale server with Headplane UI:

```bash
cd docker && podman compose up -d
```

4. Generate auth keys for each user type (can also use Headplane webUI):

```bash
podman exec -it headscale headscale users create tailscale-admin@example.com
podman exec -it headscale headscale preauthkeys create --user tailscale-admin@example.com
# Repeat for other users, that's the biggest manual bottleneck. Can be automated, I guess...
```

5. Add auth keys to `clients/.env`.

6. Start client containers:

```bash
cd clients && podman compose up -d
```

## Access

- Headscale API: http://localhost:4001
- Headplane UI: http://localhost:4000

## Client Types

- **Admin**: Full network access
- **Trusted**: Exit node + trusted network access
- **Untrusted**: Exit node only
- **VM Users**: VM access only
- **Exit Nodes**: Route traffic
- **VMs**: Target machines

## Management

Check client status:

```bash
./clients/tailscale-check-statuses.sh
```

Example output:

```
=== tailscale-trusted ===
100.64.1.9      ts-trusted           tailscale-trusted@ linux   -
100.64.1.1      ts-admin-alt         tailscale-admin@ linux   -
100.64.1.2      ts-admin             tailscale-admin@ linux   -
100.64.1.18     ts-exit-node-1       tailscale-service@ linux   -
100.64.1.3      ts-exit-node-2       tailscale-service@ linux   -
100.64.1.13     ts-trusted-2         tailscale-trusted@ linux   -

=== tailscale-vm-1 ===
100.64.1.17     ts-vm-1              tailscale-service@ linux   -
100.64.1.1      ts-admin-alt         tailscale-admin@ linux   -
100.64.1.16     ts-vm-user-two       tailscale-vm-two@ linux   -
100.64.1.7      ts-vm-user           tailscale-vm@ linux   -

=== tailscale-exit-node-1 ===
100.64.1.18     ts-exit-node-1       tailscale-service@ linux   -
100.64.1.1      ts-admin-alt         tailscale-admin@ linux   -
100.64.1.2      ts-admin             tailscale-admin@ linux   -
100.64.1.13     ts-trusted-2         tailscale-trusted@ linux   -
100.64.1.15     ts-trusted-two       tailscale-trusted-two@ linux   -
100.64.1.9      ts-trusted           tailscale-trusted@ linux   -
100.64.1.14     ts-untrusted-2       tailscale-untrusted@ linux   -
100.64.1.10     ts-untrusted-two     tailscale-untrusted-two@ linux   -
100.64.1.5      ts-untrusted         tailscale-untrusted@ linux   -
100.64.1.16     ts-vm-user-two       tailscale-vm-two@ linux   -
100.64.1.7      ts-vm-user           tailscale-vm@ linux   -
```

View ACL configuration:

```bash
cat config/acl.json
```
