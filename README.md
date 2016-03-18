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

Spin up a VM and install Debian 8 with just a basic SSH server. Take note of
the IP.

Run the ansible playbook. Specify you're VMs IP using the `-i` flag:

```bash
# To the production server
ansible-playbook fic.yml
# Or to your test server
ansible-playbook fic.yml -i <server_ip>
```



[ansible]: https://www.ansible.com/
[fabric]: http://www.fabfile.org/
