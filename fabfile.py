#!/usr/bin/env fab
from fabric.api import sudo, env
from fabric.contrib.console import confirm


env.hosts = ['ficwww.ic.org:8282']


def make_staging():
    warning_text = '''
    This is a destructive action that will clear out any modifications to
    current staging files & database.

    Are you sure you wish to continue?
    '''
    if confirm(warning_text):
        sudo('bash /root/bin/make_staging.sh')


def make_adam_staging():
    warning_text = '''
    This is a destructive action that will clear out any modifications to
    current staging files & database.

    Are you sure you wish to continue?
    '''
    if confirm(warning_text):
        sudo('/root/bin/make_adam_staging.sh', shell=False)


def backup_wordpress():
    sudo('bash /root/bin/backup_wordpress.sh manual')


def safe_upgrade():
    sudo('apt-get update -yqq && apt-get upgrade -yqq')
