# Sos-sso

## What is this?

Sos-sso is a web administration system for managing users in Linux. Technically it uses *Ruby on Rails* as web framework, *rails_admin* as user interface generator and MySQL/MariaDB for storing user data.

It is suitable for small organizations or schools, but unsuitable for virtual hosting providers. If you need more than one domain, use [http://www.vimbadmin.net/](http://www.vimbadmin.net/). While you can use more than one domain for email with *sos-sso* (f.e. example.org, example.net), there is only one account for both of them.

### Main features:

- all users and user data are stored in the SQL database
- there are three "master" types - *User*, *Group* and *Alias*, equivalents of Linux accounts
- every other service is synchronized with these or use them directly
- a user may have certain services enabled or disabled



- name service switch (libnss-mysql) - `ls` won't show numbers instead of usernames and groups
- Dovecot - receive email via IMAPs or POP3s
- NSS allows to see user and group names when listing directories instead of a number
- granularity of access. Users belonging in *mail* group can login into mail system and also receive mail and send mail at all.
User can be deactivated and then he cannot do anything, mail won't work for him.
- filesystem quotas - synchronizes from user in database, quota is also sent via IMAP (you can see it in Roundcube or Thunderbird)
- performance: i3@3.3GHz, 8GB RAM - NSS handle cca 10 000 calls/s for 1000 users and 1000 groups
- unit tests for dovecot, postfix and libnss present, benchmarks for them area also available
- helping functions for managing users - find redundant home directories, missing directories, weak hash functions in crypt
formatted passwords, synchronize quotas, and find missing and redundant users in Samba.

- synchronization with *Samba* and *quota* via system calls





# sos-sso

Single sign on system for small organizations or schools (one domain) for Linux systems and MySQL/MariaDB database
- a combination of Linux, Dovecot (IMAP, POP3), Postfix (SMTP(D)), and libnss-mysql(-bg) for naming system, Freeradius
for Wifi access via EAP-TLS, EAP-TTLS and EAP-PEAP, and Samba (for Windows shares and PEAP).

## Screenshots

## Features



## Installation of sos-sso

Install Ruby version more than or equal 1.9.3. For Debian Stable type this:

    apt-get install ruby1.9.3

Now you should have ruby and gem command.

Install bundler (automatic package downloader):

    gem install bundler

Good. Now clone or download this project:

    git clone https://github.com/istana/sos-sso

or click "Download ZIP" somewhere on Github. Enter directory and run bundler:

    cd sos-sso
    bundle install

Now you have to set up the database info. Edit *config/database.yml*. If you plan to use the application,
change only production section. If you want to run benchmarks and tests, fill in test section. Don't enter the same
info for test and production/development, tests and benchmarks are cleaning up the database. Now run database migrations.
This will create structures like users, aliases and groups in the database.

    RAILS_ENV=production rake db:migrate

You need also change some secret keys. If you do not do this, your keys are known from this repository and you may be cracked.
Enter key into config/secrets.yml or specify it in command line - but this may be pain in the ass. Then uncomment config.secret_key
and enter your own string. Good, now your cookies and login sessions are safe.

You should strongly consider to run this under HTTPS, for this you will need a certificate. See section obtaining certificate.


Now run application - the easiest way - 

    rails server -e production

This will use internal web server and you can access your site on port 3000.

## Configure external services

Copy files from sos-sso/external files to respective locations.

### Dovecot


### Postfix

### libnss-mysql(-bg)

To be honest, libnss-mysql has its age. I could imagine much better behavious. It was programmed in year 2002-2005 (last version)
in age of MySQL 3 and MySQL 4. It uses persistent connection and don't bother to close them. You will see in syslog something about
aborted connections.


#### MySQL

Change timeout_wait in MySQL from 600 (Debian) or 24800 (RH) to 30 seconds. Otherwise your RAM or TCP connections will be exhausted.
Restart MySQL (service mysql restart).

#### NSS

Edit /etc/nss.conf and add mysql to passwd, group and shadow. It should look like this:


Funny thing is uid or gid collision - two users or group has different names, but the same ID, one from passwd file and other from
MySQL. In my case tar stopped to work. Also rbenv was behaving the same - it ran, but didn't output anyting. With passwd and LDAP it
worked properly...somehow.

files or compat should always be first - you have there root and system users. They shouldn't be overriden by some SQL record.

### Freeradius





## Lots of Details

In fact it is not completely single sign on, internally Freeradius has it's own users, which are synchronized from
MySQL database and Samba database (TDB).

Postfix uses Dovecot for authentication. Only queries for aliases are configured there.

NSS is defined in glibc, see pwd.h, grp.h and shadow.h for more details.


## Run benchmarks

    rake test:benchmark
    
## Run tests

    rake test

## Roadmap

- better tests
- rake tasks for more comfortable use
- add NT passwords to user, sync them to RADIUS - this way Freeradius would take password for PEAP directly from the
database, therefore can skip messing with Samba - joining domains, installing Winbind. We have mostly Home and Home Premium
editions of Windows, so there is no point. Windows sharing in workgroup is enough.

## Hardening


## Help

I could use some help. Run benchmarks. Use this. Improve English language of this documentation. Give feedback.


TODO integrity check for user primary group is in groups


mysqldump --no-create-db --no-data -u root -p sos-sso

# Quotas

Dovecot may use quota definitions from SQL database, but we are using filesystem quotas.
This is better way in this case, because all files are taken into consideration such as whole home directory.

require quota plugins (see file external_configs/05-local.conf) here

On the server: /etc/dovecot/conf.d/90-quota.conf

````
plugin {
  quota = fs:User quota:user
  quota2 = fs:group quota:group
}
````

That's enough. Now quota apply, you may use warnquota program to send warnings and imap_quota plugin sends
quota to imap clients. POP3 don't have such possibility.

There is one thing, which was skipped. Dovecot wiki2 advises to move control files into another, non-quota directory,
otherwise, when the user will reach (hard) quota, he cannot remove no mail. In this case administrator must take
action and enlarge permitted quota or remove some files by hand. These control files aren't too big (< 2MB), so
who cares, maybe we will deal with this later.

quota is set via edquota user or aquota. One block is 4096 bytes by default. Number of files < number of inodes.
Soft quota triggers alarm, hard quota don't allow no more data to be stored. Set inode number to cca 10000 - it's
cca 7GB of data - mail, big files, images, documents.

blockdev --getbsz /dev/sdXN



### Queries

- never assign to user 'mail' as primary group. His mail and aliases won't work.
- generally never assign some service as primary group.



== README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.
