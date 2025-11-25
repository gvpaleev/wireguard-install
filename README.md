# WireGuard Install Scripts

Simple bash scripts for installing and managing WireGuard VPN server.

## Installation

```bash
sudo ./install.sh
```

Installs WireGuard and configures the server with:
- Network: 10.66.66.0/24
- Port: 51820
- Interface: eth0

## User Management

### Add User
```bash
sudo ./addUser.sh <username>
```

Creates a client configuration file at `/etc/wireguard/client<N>:<username>.conf`

### Delete User
```bash
sudo ./delUser.sh <username>
```

Removes the user's configuration and peer entry.

## Requirements

- Ubuntu/Debian-based system
- Root/sudo access
- eth0 network interface
