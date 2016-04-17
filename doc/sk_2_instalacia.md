# Inštalácia sos-sso

Sú dva spôsoby ako nainštalovať sos-sso. Prvý spôsob je jednoduchý a práve ten tu popíšem. Druhý využíva Capistrano, čo umožňuje ľahký upload a spustenie sos-sso na vzdialenom serveri, napríklad pri zmene zdrojákov. Vyžaduje unixový systém.

Predpokladané veci v tomto návode:

- linuxový systém
- shell prístup
- užívateľ isabelle
- adresár programu: /home/isabelle/sos-sso
- mysql meno/heslo: sos-sso/Isabelle
- apache ako web server

## Stiahnutie

Sos-sso sa dá stiahnuť odtiaľto: [https://github.com/istana/sos-sso/archive/master.zip](https://github.com/istana/sos-sso/archive/master.zip).

## Inštalácia Ruby

Najprv treba nainštalovať Ruby verzie 1.9.3 a viac. Ja by som doporučoval verziu 2.2.2.

````bash
apt-get install ruby2.2 ruby2.2-dev libxml2-dev libxslt-dev
gem install bundler
````

alebo

````bash
apt-get install ruby2.1 ruby2.1-dev libxml2-dev libxslt-dev
gem install bundler
````

a podobne, ruby sa dá nájsť cez `apt-cache search ruby`

### Rbenv (nepovinné)

Ak nie je na systéme vhodné Ruby, dá sa nainštalovať do domovskej zložky. Použijeme na to program *rbenv*. Ten sa nastrká do PATH a smeruje príkazy `ruby` a `gem` na správne binárky. Pravupovediac nerád spúšťam neznáme skripty z githubu, ale `rbenv-installer` dosť urýchli nastavenie *rbenv*.

Najprv treba nejaké balíky zo systému.

````bash
apt-get install zlib1g-dev libreadline6-dev libssl-dev libxml2-dev libxslt-dev
````

A potom:

````bash
# pod isabelle
curl https://raw.githubusercontent.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
# relog
rbenv install 2.2.2
gem install bundler
````

## Inštalácia MariaDB (mysql)

Ešte je potrebné nainštalovať databázový server. Použijeme namiesto MySQL MariaDB, lebo je to binárne kompatibilné a MariaDB je viac vyvíjaná. Toto pridať do `/etc/apt/sources.list`.

````
# MariaDB 10.0 repository list - created 2015-04-20 20:41 UTC
# http://mariadb.org/mariadb/repositories/
deb http://mirror.vpsfree.cz/mariadb/repo/10.0/debian wheezy main
deb-src http://mirror.vpsfree.cz/mariadb/repo/10.0/debian wheezy main
````

````bash
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
apt-get update
apt-get install mariadb-server mariadb-client libmysqlclient18 libmariadbclient-dev libmariadbclient18
````

## Inštalácia sos-sso

Rozpakuj zip do /home/isabelle/sos-sso.

````bash
unzip sos-sso-master.zip
mv sos-sso-master sos-sso

# inštalovať potrebné gemy
# ak to spadne, tak chýbajú zrejme nejaké knižnice

cd sos-sso
bundle install
````

## Nastavenie sos-sso

Toto sú najdôležitejšie súbory a treba ich zachovať aj pri aktualizácii.

- config/application.yml
- config/database.yml







