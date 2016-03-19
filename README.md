# Fellowship of Intentional Community Automated VPS Deployment

This repository contains the [Ansbile][ansible] playbook used to automatically
setup and configure FIC's website VPS, along with a [Fabric][fabric] file used
to script maintenance tasks.

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

Passwords and other secrets are stored in an Ansbile Vault file. You'll need to
stick the password in `playbook/pass.secret`. You can edit or view the vaulted
file by running `ansible-vault edit group_vars/all/vault.yml`. If you're
forking or re-using this playbook, you should replace our vault file with your
own.

Now you can run the ansible playbook. You can specify a different inventory
file using the `-i` flag:

```bash
cd playbook/
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
[Linode's Security Guide][linode-secure] is applied, including Unattended
Upgrades, SSH Hardening, Fail2Ban, & an IPTables ruleset.

Outbound mail is sent using [SSMTP][ssmtp], which is configured to relay mail
to an external SMTP server.

We then install [MariaDB][mariadb] and create databases and users for
`production` & `staging`. MariaDB is then secured using [Digital Ocean's
Guide][d-o-mysql].

[Nginx][nginx] is then installed & configured using [Linode's LEMP Server
Guide][linode-lemp]. [Adminer][adminer], & Wordpress Production/Staging sites
proxying PHP-FPM are added to Nginx. The Wordpress site configurations are
tweaked for usage with [Cloudflare][cloudflare] and the [W3TC][w3tc] plugin. A
self-signed, wildcard SSL certificate is generated for the server.

[PHP-FPM][php-fpm] is installed & configured using [Digital Ocean's LEMP Stack
Guide][d-o-lemp].

[Varnish][varnish] is installed & configured to listen on the public interface
and forward requests to Nginx(which listens on the internal interface). The
Varnish VCL is customized for caching Wordpress sites & skips processing of the
Adminer subdomain.



[ansible]: https://www.ansible.com/
[fabric]: http://www.fabfile.org/

[linode-starting]: https://www.linode.com/docs/getting-started
[linode-secure]: https://www.linode.com/docs/security/securing-your-server/
[ssmtp]: https://wiki.debian.org/sSMTP
[mariadb]: https://mariadb.org/
[d-o-mysql]: https://www.digitalocean.com/community/tutorials/how-to-secure-mysql-and-mariadb-databases-in-a-linux-vps
[nginx]: https://www.nginx.com/
[linode-lemp]: https://www.linode.com/docs/websites/lemp/lemp-server-on-debian-8
[adminer]: https://www.adminer.org/
[cloudflare]: https://www.cloudflare.com/
[w3tc]: https://wordpress.org/plugins/w3-total-cache/
[php-fpm]: http://php-fpm.org/
[d-o-lemp]: https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-on-debian-7
[varnish]: https://www.varnish-cache.org/
