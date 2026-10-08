# Arch Linux: Wharton VPN and Betty SSH

Reference for `hchulkim`, based on our successful setup on October 8, 2026.
Requires a PennKey, Duo enrollment, and a Betty account with access.

## 1. Install the packages (one time)

```bash
sudo pacman -Syu --needed openfortivpn ppp krb5 openssh
```

This also updates the Arch system. No Ubuntu `.deb` packages or FortiClient installation are needed for this method. See the [openfortivpn documentation](https://github.com/adrienverge/openfortivpn).

## 2. Kerberos configuration (optional)

**You can skip this section for the working setup on this machine.** Inspection confirmed that `/etc/krb5.conf` still uses the original MIT default. Explicitly running `kinit hchulkim@UPENN.EDU` and connecting to a specific Betty node worked without the changes below. These are optional Penn settings, not prerequisites or changes already performed.

`[libdefaults]` controls Kerberos library defaults. `default_realm` supplies the realm when omitted; the DNS options control discovery and server-name resolution; `rdns = false` disables reverse lookup. `noaddresses` requests tickets without client-address restrictions, and `forwardable` requests forwardable tickets (it does not itself enable SSH credential delegation).

If you later choose to apply Penn's sample settings, back up the configuration once, then edit it:

```bash
sudo cp -an /etc/krb5.conf /etc/krb5.conf.before-penn
sudoedit /etc/krb5.conf
```

Update the existing `[libdefaults]` section to the following. These are [Penn's documented settings](https://parcc.upenn.edu/wp-content/uploads/2025/10/PI-Kerberos-user-config-250925-160940.pdf):

```ini
[libdefaults]
    default_realm = UPENN.EDU
    dns_lookup_realm = true
    dns_lookup_kdc = true
    dns_canonicalize_hostname = true
    noaddresses = true
    forwardable = true
    rdns = false
```

Add these mappings under the existing `[domain_realm]` section:

```ini
    upenn.edu = UPENN.EDU
    .upenn.edu = UPENN.EDU
```

Keep unrelated entries. The original Arch configuration on this machine used `ATHENA.MIT.EDU` as its default realm.

## 3. Prepare SSH files and permissions (one time)

Run as your normal local user (`himakun`):

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/config ~/.ssh/known_hosts
chmod 600 ~/.ssh/config ~/.ssh/known_hosts
```

If these commands fail because the directory/files are owned by root, repair ownership, then repeat the commands above:

```bash
sudo chown "$USER:$(id -gn)" ~/.ssh
```

For each existing file that is also owned by root, repair it individually:

```bash
sudo chown "$USER:$(id -gn)" ~/.ssh/config
sudo chown "$USER:$(id -gn)" ~/.ssh/known_hosts
```

This fixes the earlier `Failed to add the host to the list of known hosts` error. Run `kinit` and `ssh` without sudo.

## 4. Configure Betty aliases (one time)

Edit `~/.ssh/config` in your text editor. Put these blocks near the top, merging/replacing your existing PARCC block and preserving unrelated settings:

```sshconfig
Host login.betty login.betty.1 login.betty.parcc.upenn.edu
    HostName login01.betty.parcc.upenn.edu

Host login.betty.2
    HostName login02.betty.parcc.upenn.edu

Host login.betty.3
    HostName login03.betty.parcc.upenn.edu

Host login.betty login.betty.? *.parcc.upenn.edu
    User hchulkim
    VerifyHostKeyDNS yes
    GSSAPIAuthentication yes
```

These aliases have now been installed in `~/.ssh/config`, with a dated backup beside it. The exact shared hostname `login.betty.parcc.upenn.edu` also points to node 01 locally; other full PARCC hostnames keep their own destinations. The configuration is owned by `himakun` with mode `600`.

The aliases mean:

| Command | Server |
| --- | --- |
| `ssh login.betty` | `login01.betty.parcc.upenn.edu` |
| `ssh login.betty.1` | `login01.betty.parcc.upenn.edu` |
| `ssh login.betty.2` | `login02.betty.parcc.upenn.edu` |
| `ssh login.betty.3` | `login03.betty.parcc.upenn.edu` |

These individual nodes are listed in [PARCC's login guide](https://parcc.upenn.edu/training/getting-started/logging-in/). Our shared-hostname connection switched between `login01` and `login02` during Kerberos authentication and failed with `An invalid name was supplied`; directly using `login01` worked. This strongly suggests a hostname-resolution inconsistency. Use the direct-node aliases above.

## 5. Connect the VPN (each session)

In terminal 1:

```bash
sudo openfortivpn cpa-vpn.wharton.upenn.edu:443 \
  --saml-login --realm=whartonusers-SAML
```

1. Open the authentication URL printed by the command in a browser on this machine.
2. Complete PennKey sign-in and MFA while the command is still waiting.
3. Wait for `Tunnel is up and running.`
4. Leave this terminal open; minimizing it is fine.

The correct realm is **`whartonusers-SAML`**, not `wharton-SAML`. The browser returns the SAML result to a local HTTP listener, normally port 8020; see the [openfortivpn manual](https://man.archlinux.org/man/extra/openfortivpn/openfortivpn.1.en).

Optional check in another terminal:

```bash
ip -brief addr
```

Expect `ppp0` with a VPN address. `UNKNOWN` is normal for this interface. On this setup, automatic VPN DNS configuration reported a missing `org.freedesktop.resolve1` service. Betty still resolved and the direct-node login worked; DNS configuration was not repaired during this session. If other internal names fail, troubleshoot your active DNS manager separately.

## 6. Obtain a Kerberos ticket and log in

In terminal 2, as your normal user:

```bash
kinit hchulkim@UPENN.EDU
klist
ssh login.betty
```

Enter your PennKey password at the `kinit` prompt. `klist` should show `hchulkim@UPENN.EDU` and an unexpired `krbtgt/UPENN.EDU@UPENN.EDU` ticket. Complete any Duo prompt during SSH login. PARCC supports Kerberos plus Duo; an SSH key is not required for this initial method. Tickets normally last about 10 hours; renew with `kinit` when needed. See the [PARCC login guide](https://parcc.upenn.edu/training/getting-started/logging-in/).

On first connection, compare the offered fingerprint with PARCC's current published fingerprints before accepting. The ED25519 fingerprint we verified was:

```text
SHA256:talnzpFHiLmQR0xFrC8ZaPdQ9LxfDMb/iamK2pbBd7I
```

To choose another node, use `ssh login.betty.2` or `ssh login.betty.3`. If using `tmux`, reconnect to the same node where you started that session. Slurm job placement is separate from your choice of login node.

## 7. Disconnect

1. Run `exit` to leave the remote SSH session.
2. Press **Ctrl+C** in the VPN terminal to disconnect the VPN.
3. Optionally run `kdestroy` locally to discard the current Kerberos tickets when finished.

## Quick daily checklist

Terminal 1 — start VPN, open its printed URL, finish sign-in, leave running:

```bash
sudo openfortivpn cpa-vpn.wharton.upenn.edu:443 \
  --saml-login --realm=whartonusers-SAML
```

Terminal 2 — obtain ticket and connect:

```bash
kinit hchulkim@UPENN.EDU
ssh login.betty
```

If authentication fails, inspect the direct-node connection:

```bash
klist
KRB5_TRACE=/dev/stderr ssh -v login.betty.1
```

Do not share the credential-cache file (such as `/tmp/krb5cc_1000`). The `known_hosts` write error is a local permissions problem; `Permission denied (publickey,gssapi-with-mic)` is an authentication problem.
