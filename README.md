sos-sso
=======

Web administration system for user accounts suitable for small organizations or schools.

## Screenshots ##

Screenshots are the best and most useful!

![Welcome page](http://myrtana.sk/sos-sso/welcome-page.jpg)
![Add a user](http://myrtana.sk/sos-sso/add-user.jpg)
![RADIUS auths](http://myrtana.sk/sos-sso/radpostauth.jpg)

## Introduction ##

Features:

- data are stored in [MySQL/MariaDB](https://mariadb.org/) database
- multilanguage interface
- implements *passwd*, *group* and *shadow* structures
- easy use only via web interface
- integrity and consistency checks for the best health of our system

Integrates with:

- *Dovecot* (POP3, POP3s, IMAP, IMAPs) - receive mails via mail clients - [Roundcube](http://roundcube.net/), Outlook, [Thunderbird/Icedove](https://www.mozilla.org/en-US/thunderbird/all.html), ...
- *Postfix* (SMTP, SMTPs) - sending mail from mail client to mail server and from mail server to another mail server
- *Postfix* (alias) - define aliases for email accounts
- *Samba* - "Windows sharing"
- *freeRADIUS* - *EAP-TLS*, *EAP-TTLS*, *PEAP* - connecting mobile (Wifi) devices to the network via certificate or username/password
- *quota* - set restrictions for user's data size and files count
- *nss-mysql* - provide naming service for *ls*, *who*, *getent* and other utilities. Also *SSH* respects this

## Installation and configuration ##

There are steps to run this application for skilled users. More detailed howto and complete steps will follow.

- do not run this under root user
- `git clone` this
- run `bundle install`
- set up your database settings in `config/database.yml`
- set up secret for cookies in `config/secrets.yml`
- run `RAILS_ENV=production rake db:migrate assets:precompile`
- set up [Phusion Passenger (mod_rails)](https://www.phusionpassenger.com/) or run `RAILS_ENV=production rails s`
- add Admin user via `RAILS_ENV=production rails c`
- merge configuration files with your configuration
- copy `external_configs/sudo/sosssoroot` into `/usr/local/sbin`, *chmod* 500 it and *chown* to root only
- run this under *https* or run on localhost and access via ssh tunnel!
- all should work

## License ##

Copyright 2014 Ivan Stana. The license of *sos-sso* is AGPL for all files with some exceptions, so users of the softwre should be able to get source code of this application

- external_configs directory consists mostly of collection of configuration files taken from respective software
- documentation is under CC0 license, equivalent to public domain
- config directory is also CC0
- any CSS, JavaScript and image in app/assets is also CC0
- sos-sso uses many components and libraries with its own license

At this point I don't really care about trademark and such stuff. But I want users to know they are using this software and they can inspect and maybe improve it. Also maybe should I relicense this to MIT license.

## About/History ##

I've started this project, because I wanted something for managing teachers and students in a high school. Teachers should have mail account, some of them mail aliases. Students should have only access to their authenticated windows share on the server. And some of the teachers and students should have access to the network via RADIUS authentication.

Of course I didn't found such piece of software. Tutorials for Dovecot-mysql and libnss-mysql were rather sketchy and didn't really modified SQL queries or SQL tables or columns. But I wanted to use the same data for more services, so I began to change the SQL queries. I've written automated tests to test if they are correct and because I modified the SQL schema and queries many (tens) times, it was a good idea. And later other things followed. I've finished this in six weeks, but there were more (failed) generations before this, so original idea is maybe two years old.

*sos-sso* is a shortname for *stredná odborná škola - single sign on*, in translation something like *specialized high school - single sign on*

## TODO and roadmap ##

While the software is fit for production use, there are some things which needs improvement:

- authorization for users connected via freeRADIUS. The first generation of software of this idea had it. Requires communication with wifi access points
- pair RADIUS users, DHCP requests with MAC addresses to track their devices use/abuse
- more automated tests
- better handling of non-ideal states like changing uid or username should chown and chmod his home directory, quota, samba, ...
- resolve many less important TODOs
- some strings are hard coded in Slovak language
- mail and wifi groups are hardcoded
- use management group from config (username generation from fullname)
- somehow test sosssoroot automatically
- do something with currently unused tables from freeRADIUS
- create separate user and rights for standard libnss (password to SQL is exposed to other shell users)
