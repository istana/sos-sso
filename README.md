[![Build Status](http://img.shields.io/travis/istana/sos-sso.svg?style=flat-square)](https://travis-ci.org/istana/sos-sso)
[![GitHub license](https://img.shields.io/github/license/istana/sos-sso)](https://github.com/istana/sos-sso/blob/master/LICENSE)

# sos-sso

Web-based administration system for user accounts suitable for small organizations or schools. Manage users, groups and email aliases easily.

## Introduction ##

Features:

- data are stored in [MySQL/MariaDB](https://mariadb.org/) database
- multilanguage interface
- implements *passwd*, *group* and *shadow* structures
- easy use only via web interface
- integrity and consistency checks for the best health of our system
- UI via rails_admin gem

Integrates with:

- *Dovecot* (POP3, POP3s, IMAP, IMAPs) - receive mails via mail clients - [Roundcube](http://roundcube.net/), Outlook, [Thunderbird/Icedove](https://www.mozilla.org/en-US/thunderbird/all.html), ...
- *Postfix* (SMTP, SMTPs) - sending mail from mail client to mail server and from mail server to another mail server
- *Postfix* (alias) - define aliases for email accounts
- *Samba* - "Windows sharing"
- *freeRADIUS* - *EAP-TLS*, *EAP-TTLS*, *PEAP* - connecting mobile (Wifi) devices to the network via certificate or username/password
- *quota* - set restrictions for user's data size and files count
- *nss-mysql* - provide naming service for *ls*, *who*, *getent* and other utilities. Also *SSH* respects this

## Installation and configuration ##

While using sos-sso is easy, it takes some effort to install and configure it. Documentation is in the *doc* directory. Please don't be upset with inconsistent or nonexistent documentation and please report it in github issues or send me an email.


Here are steps to run this application for skilled users. More detailed howto and complete steps will follow.

- do not run this under root user
- `git clone http://github.com/istana/sos-sso` this
- run `bundle install`
- set up your database settings in `config/database.yml`
- set up secret for cookies in `config/secrets.yml`
- run `RAILS_ENV=production rake db:migrate assets:precompile`
- set up [Phusion Passenger (mod_rails)](https://www.phusionpassenger.com/) or run `RAILS_ENV=production rails s`
- add Admin user via `RAILS_ENV=production rails c`
- merge configuration files from *external_configs* with your configuration
- copy `external_configs/sudo/sosssoroot` into `/usr/local/sbin`, *chmod* 500 it and *chown* to root only
- run this under *https* or run on localhost and access via SSH tunnel!
- all should work

## License ##

Copyright 2014-2020 Ivan Stana. The license of *sos-sso* is MIT. Note that *sos-sso* uses many components and libraries with their own licenses.

If you like it please share that *sos-sso* exists.

## History ##

I've started this project, because I needed something for managing teachers and students in high school. Teachers should have mail account, some of them email aliases. Students should have only access to their authenticated windows share on the server. And some of the teachers and students should have access to the network via RADIUS authentication.

Of course I didn't found such piece of software I wanted. Tutorials for Dovecot-mysql and libnss-mysql were rather sketchy and didn't really modified SQL queries or SQL tables or columns. But I wanted to use the same data for more services, so I began to change the SQL queries. I've written automated tests to test if they are correct and because I modified the SQL schema and queries many (tens) times, it was a good idea. Testing it manually would take insane amount of time and deter me from finishing this. And later other things followed. I've finished this in six weeks, but there were more (failed) generations before this, so original idea is maybe two years old.

*sos-sso* is a shortname for *stredná odborná škola - single sign on*, in translation something like *specialized high school - single sign on*
