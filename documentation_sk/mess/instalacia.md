# Inštalácia

Inštalácia pozostáva so samotnej inštalácie *sos-sso* a ostatných služieb. Ako vzorový operačný systém sa berie Debian stable (Wheezy).

## sos-sso

Je viacej spôsobov ako získať *sos-sso*.

Najľahšie je stiahnuť aktuálnu verziu zo [http://sos-sso.myrtana.sk](http://sos-sso.myrtana.sk) alebo z Githubu, kde je hlavný zdrojový kód [https://github.com/istana/sos-sso/](https://github.com/istana/sos-sso/) - tlačítko "Download ZIP" a niekde to rozpakovať.

Alternatívne sa dá *sos-sso* stiahnuť priamo cez `git`.

    git clone https://github.com/istana/sos-sso


### Kompletný postup:

*sos-sso* nebude bežať pod rootom, ale bežným užívateľom:

    adduser alice
    
pre Fedoru a podobné systémy treba nastaviť explicitne heslo:

    passwd alice

prepneme sa na Alicu:

    su - alice    
    git clone https://github.com/istana/sos-sso

prepneme do roota. *sos-sso* vyžaduje Ruby. Označenie ruby1.9.1 v Debiane znamená API Ruby, neinštaluje to staré hlavičky Ruby a ešte *sudo*.

    apt-get install ruby1.9.3 ruby1.9.1-dev sudo

treba nastaviť sudo - treba pridať do `/etc/sudoers` nasledovné veci:

    alice  ALL=/usr/bin/gem
    alice  ALL=NOPASSWD:/usr/local/sbin/sosssoroot

skopírovať skript na veci, čo musia bežať pod rootom:

    cp sos-sso/external_configs/sudo/sosssoroot /usr/local/sbin/

a inštaláciu ďalších Ruby knižníc (ako Alica):

    cd sos-sso

## Ostatné veci

    apt-get install sudo