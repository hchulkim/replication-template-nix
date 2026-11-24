# Arch Linux: Penn GlobalProtect VPN and Betty SSH

Reference for `hchulkim`. The original setup worked on October 8, 2026 using the
Wharton FortiClient VPN (`openfortivpn`). Penn is retiring FortiClient access, so
on November 20, 2026 the VPN step was switched to Penn's GlobalProtect VPN, which
connected successfully. The Kerberos and SSH steps are unchanged.
Requires a PennKey, Duo (two-step) enrollment, and a Betty account with access.

Every session follows the same order:

1. **Connect the VPN** (GlobalProtect, `vpn.upenn.edu`).
2. **Get a Kerberos ticket** (`kinit`).
3. **SSH to Betty** (`ssh login.betty`).

Sections 1–4 are one-time setup. Sections 5–8 are the per-session steps.

## 1. Install the packages (one time)

```bash
sudo pacman -Syu --needed globalprotect-openconnect krb5 openssh
```

This also updates the Arch system. `globalprotect-openconnect` comes from the
official Arch `extra` repository (no AUR needed). It is an open-source GlobalProtect
client built on OpenConnect that supports Penn's SAML (PennKey + Duo) login. It
provides `gpclient` (command line) and `gpgui` (graphical). Version 2.6.5 was used
here. See the [Arch package](https://archlinux.org/packages/extra/x86_64/globalprotect-openconnect/)
and [upstream project](https://github.com/yuezk/GlobalProtect-openconnect).

Palo Alto's own Linux client (`globalprotect-bin` in the AUR) is not needed.

The old FortiClient packages (`openfortivpn`, `ppp`) are no longer used. Removing them
is optional:

```bash
sudo pacman -Rs openfortivpn
```

## 2. Kerberos configuration (optional)

**You can skip this section for the working setup on this machine.** `/etc/krb5.conf`
already has `default_realm = UPENN.EDU` and the `upenn.edu` domain mappings, and
`kinit hchulkim@UPENN.EDU` works.

`[libdefaults]` controls Kerberos library defaults. `default_realm` supplies the realm
when omitted; the DNS options control discovery and server-name resolution;
`rdns = false` disables reverse lookup. `noaddresses` requests tickets without
client-address restrictions, and `forwardable` requests forwardable tickets (it does not
itself enable SSH credential delegation).

If you later choose to apply Penn's full sample settings, back up the configuration
once, then edit it:

```bash
sudo cp -an /etc/krb5.conf /etc/krb5.conf.before-penn
sudoedit /etc/krb5.conf
```

Update the existing `[libdefaults]` section to the following. These are
[Penn's documented settings](https://parcc.upenn.edu/wp-content/uploads/2025/10/PI-Kerberos-user-config-250925-160940.pdf):

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

Make sure these mappings are under the `[domain_realm]` section:

```ini
    upenn.edu = UPENN.EDU
    .upenn.edu = UPENN.EDU
```

Keep unrelated entries.

## 3. Prepare SSH files and permissions (one time)

Run as your normal local user (`himakun`):

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/config ~/.ssh/known_hosts
chmod 600 ~/.ssh/config ~/.ssh/known_hosts
```

If these commands fail because the directory/files are owned by root, repair ownership,
then repeat the commands above:

```bash
sudo chown "$USER:$(id -gn)" ~/.ssh
```

For each existing file that is also owned by root, repair it individually:

```bash
sudo chown "$USER:$(id -gn)" ~/.ssh/config
sudo chown "$USER:$(id -gn)" ~/.ssh/known_hosts
```

This fixes the earlier `Failed to add the host to the list of known hosts` error. Run
`kinit` and `ssh` without sudo.

## 4. Configure aliases (one time)

### SSH aliases

Edit `~/.ssh/config` in your text editor. Put these blocks near the top,
merging/replacing your existing PARCC block and preserving unrelated settings:

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

These aliases are installed in `~/.ssh/config`. The exact shared hostname
`login.betty.parcc.upenn.edu` also points to node 01 locally; other full PARCC
hostnames keep their own destinations. The configuration is owned by `himakun` with
mode `600`. `GSSAPIAuthentication yes` is what makes SSH use your Kerberos ticket.

| Command | Server |
| --- | --- |
| `ssh login.betty` | `login01.betty.parcc.upenn.edu` |
| `ssh login.betty.1` | `login01.betty.parcc.upenn.edu` |
| `ssh login.betty.2` | `login02.betty.parcc.upenn.edu` |
| `ssh login.betty.3` | `login03.betty.parcc.upenn.edu` |

These individual nodes are listed in
[PARCC's login guide](https://parcc.upenn.edu/training/getting-started/logging-in/).
A connection to the shared hostname switched between `login01` and `login02` during
Kerberos authentication and failed with `An invalid name was supplied`; directly using
`login01` worked. This strongly suggests a hostname-resolution inconsistency. Use the
direct-node aliases above.

### Shell aliases

`~/.bashrc` contains:

```bash
alias vpn-betty='sudo -E gpclient connect --browser default vpn.upenn.edu'
alias login.betty='TERM=xterm-256color ssh login.betty'
```

After editing `~/.bashrc`, run `source ~/.bashrc` or open a new terminal.

## 5. Step 1 — Connect the VPN (each session)

In **terminal 1**:

```bash
vpn-betty
```

which runs:

```bash
sudo -E gpclient connect --browser default vpn.upenn.edu
```

1. Enter your local sudo password.
2. Your default browser opens the Penn sign-in page. Log in with your PennKey and
   approve the Duo (two-step) prompt.
3. The browser hands the login back to `gpclient` and the tunnel comes up.
4. Leave this terminal open for as long as you need the VPN; minimizing it is fine.

`vpn.upenn.edu` is Penn's university GlobalProtect portal. `-E` keeps your user
environment so `gpclient` can open your normal browser.

If the browser step fails, drop `--browser default` to use `gpclient`'s built-in
login window instead:

```bash
sudo -E gpclient connect vpn.upenn.edu
```

For a graphical client instead of the terminal, run `gpgui` and enter `vpn.upenn.edu`
as the portal.

## 6. Step 2 — Get a Kerberos ticket

In **terminal 2**, as your normal user (no sudo):

```bash
klist
```

If `klist` shows a `krbtgt/UPENN.EDU@UPENN.EDU` ticket that has not expired, skip to
step 3. Otherwise run:

```bash
kinit hchulkim@UPENN.EDU
klist
```

Enter your PennKey password at the `kinit` prompt. `klist` should then show
`Default principal: hchulkim@UPENN.EDU` and an unexpired
`krbtgt/UPENN.EDU@UPENN.EDU` ticket. Tickets last about 10 hours; run `kinit` again
when one expires.

If `kinit` cannot reach the Kerberos server, make sure the VPN from step 1 is up and try
again.

## 7. Step 3 — SSH to Betty

Still in terminal 2:

```bash
login.betty
```

(equivalent to `ssh login.betty`). Complete any Duo prompt during the SSH login. PARCC
supports Kerberos plus Duo; an SSH key is not required for this method. See the
[PARCC login guide](https://parcc.upenn.edu/training/getting-started/logging-in/).

On first connection, compare the offered fingerprint with PARCC's current published
fingerprints before accepting. The ED25519 fingerprint we verified was:

```text
SHA256:talnzpFHiLmQR0xFrC8ZaPdQ9LxfDMb/iamK2pbBd7I
```

To choose another node, use `ssh login.betty.2` or `ssh login.betty.3`. If using `tmux`,
reconnect to the same node where you started that session. Slurm job placement is
separate from your choice of login node.

## 8. Disconnect

1. Run `exit` to leave the remote SSH session.
2. Press **Ctrl+C** in the VPN terminal (terminal 1), or run
   `sudo gpclient disconnect` from any terminal.
3. Optionally run `kdestroy` locally to discard the current Kerberos tickets when
   finished.

## Quick daily checklist

Terminal 1 — start VPN, finish PennKey + Duo sign-in in the browser, leave running:

```bash
vpn-betty
```

Terminal 2 — check/renew the Kerberos ticket, then connect:

```bash
klist                      # ticket still valid? skip kinit
kinit hchulkim@UPENN.EDU   # only if no valid ticket
login.betty
```

## Troubleshooting

Test that Betty is reachable through the VPN:

```bash
ssh -o ConnectTimeout=10 login.betty hostname
```

If this times out, the VPN is not up (check terminal 1). If it fails with an
authentication error, inspect the Kerberos side with the direct-node connection:

```bash
klist
KRB5_TRACE=/dev/stderr ssh -v login.betty.1
```

For more detail from the VPN client, add `-v` (debug) or `-vv` (trace):

```bash
sudo -E gpclient -v connect --browser default vpn.upenn.edu
```

Do not share the credential-cache file (such as `/tmp/krb5cc_1000`). The `known_hosts`
write error is a local permissions problem; `Permission denied (publickey,gssapi-with-mic)`
is an authentication problem.
