# Fellowship of Intentional Community Automated VPS Deployment

This repository contains the [Ansbile][ansible] playbook used to automatically
setup and configure FIC's website VPS, along with a [Fabric][fabric] file used
the script maintenance tasks.

We start with a Debian 8 VM from Linode, add nginx, varnish, php-fpm, &
mariadb.

## Install Dependencies

You'll need to install ansible and fabric on your workstation:

```bash
# Arch Linux
sudo pacman -S ansible fabric
```

Or if you like to use Python virtualenvs:

```bash
cd /path/to/this/repo
mkvirtualenv -a "$(pwd)" -i fabric -i ansible fic-vps
```

## Automated Setup

Spin up a VM and install Debian 8 with just a SSH server, `python`, and
`aptitude`.

Now you can either add the IP address to the `fic-servers` inventory file &
create a new file in the `host_vars` directory or you can just modify the IP &
host variables for the `fic-test` host.

Run the ansible playbook. You can change the inventory file by using the `-i`
flag:

```bash
# To the production server
ansible-playbook fic.yml
# Or to your test server
ansible-playbook fic.yml -i test-servers
```


## Playbook

The playbook does some initial configuration specified by [Linode's Getting
Started Guide][linode-starting], like fixing the hostname, the hosts file, &
the timezone.

Then an administration user is created, and the security configuration from
[Linode's Security Guide][linode-secure] is applied, including SSH Hardening,
Fail2Ban, & an IPTables ruleset.



[ansible]: https://www.ansible.com/
[fabric]: http://www.fabfile.org/

[linode-starting]: https://www.linode.com/docs/getting-started
[linode-secure]: https://www.linode.com/docs/security/securing-your-server/
