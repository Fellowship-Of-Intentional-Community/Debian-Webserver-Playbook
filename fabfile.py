#!/usr/bin/env fab
from fabric.api import sudo, env
from fabric.contrib.console import confirm


env.roledefs = {
    'production': ['ficwww.ic.org:8282'],
    'test': ['192.168.1.49:8282'],
}


def make_staging():
    warning_text = '''
    This is a destructive action that will clear out any modifications to
    current staging files & database.

    Are you sure you wish to continue?
    '''
    if confirm(warning_text):
        sudo('bash /root/bin/make_staging.sh')


def safe_upgrade():
    sudo('apt-get update -yqq && apt-get upgrade -yqq')
