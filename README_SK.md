sos-sso
=======

Webový administračný systém na správu užívateľov vhodný pre malé organizácie alebo školy.

## Snímky obrazovky ##

Snímky obrazovky sú najlepšie a najužitočnejšie!

![Úvodná obrazovka](http://myrtana.sk/sos-sso/welcome-page.jpg)
![Pridať užívateľa](http://myrtana.sk/sos-sso/add-user.jpg)
![Autentifikácie RADIUSu](http://myrtana.sk/sos-sso/radpostauth.jpg)

## Úvod ##

Vlastnosti:

- údaje sú uložené v [MySQL/MariaDB](https://mariadb.org/) databázi
- viacjazykové rozhranie
- implementuje štruktúry *passwd*, *group* and *shadow* z Linuxu
- ľahké použitie iba cez webové rozhranie
- je dostupná kontrola integrity účtov pre najlepšie fungovanie systému

Integruje sa s:

- *Dovecot* (POP3, POP3s, IMAP, IMAPs) - prijímaj maily cez mailového klienta - [Roundcube](http://roundcube.net/), Outlook, [Thunderbird/Icedove](https://www.mozilla.org/en-US/thunderbird/all.html), ...
- *Postfix* (SMTP, SMTPs) - posielanie mailov z mailového klienta na server a zo servera na iný server
- *Postfix* (alias) - definuj aliasy pre emailové účty
- *Samba* - "Windowsové zdieľanie"
- *freeRADIUS* - *EAP-TLS*, *EAP-TTLS*, *PEAP* - pripoj mobilné zariadenia na sieť (Wifi) pomocou certifikátu alebo mena a hesla
- *quota* - nastav obmedzenia na veľkosť a počet užívateľových údajov
- *nss-mysql* - poskytuje mennú služvu pre *ls*, *who*, *getent* a iné utility. Tiež *SSH* ho rešpektuje

## Inštalácia a konfigurácia ##

Tu sú kroky ako spustiť túto aplikáciu pre skúsených užívateľov. Viac návodov bude dostupných v budúcnosti.

- nespúšťaj to pod rootom
- `git clone http://github.com/istana/sos-sso` tento repozitár
- spusti `bundle install`
- nastav údaje do databázy v `config/database.yml`
- nastav svoj tajný reťazec pre cookies v `config/secrets.yml`
- spusti `RAILS_ENV=production rake db:migrate assets:precompile`
- nastav [Phusion Passenger (mod_rails)](https://www.phusionpassenger.com/) alebo spusti `RAILS_ENV=production rails s`
- pridaj admin užívateľa cez `RAILS_ENV=production rails c`
- zlúč konfiguračné súbory z *external_configs* s tvojou konfiguráciou
- skopíruj `external_configs/sudo/sosssoroot` do `/usr/local/sbin`, *chmod* 500 to a tiež *chown* iba na roota
- spúšťaj to pod *https* alebo na localhost a pristupuj cez SSH tunel!
- všetko by malo bežať

## Licencia ##

Copyright 2014 Ivan Stana. Licencia *sos-sso* je AGPL pre všetky súbory až na nejaké výnimky:

- adresár *external_configs* sa skladá prevažne z konfiguračných súborov zobratých z príslušného softvéru
- dokumentácia je pod CC0 license, niečo ako public domain - voľné použitie
- adresár *config* je tiež pod CC0
- hocijaký *CSS*, *JavaScript* a obrázok v *app/assets* je tiež pod CC0
- *sos-sso* používa mnoho iných knižníc a súčasti, ktoré majú vlastnú licenciu

V terajšej fáze ma nejak netrápi značka a také veci. Ale chcem, aby užívatelia si boli vedomí, že používajú tento softvér a môžu ho skúmať a prípadne zlepšiť. Tiež možno by som mohol zmeniť licenciu na MIT license, aby bola voľnejšia.

## O/História ##

Začal som tento projekt, lebo som chcel niečo na správu učiteľov a žiakov na strednej škole. Učitelia by mali poštu, niektorí z nich aliasy. Žiaci by mali prístup iba k ich zložkám na serveri cez Windowsové zdieľanie. A niektorí učitelia a žiaci mali prístup na sieť cez RADIUS autentifikáciu.

Samozrejme som nenašiel taký softvér, ktorý som chcel. Návody na Dovecot-mysql a libnss-mysql boli biedne a nejak nemenili východzie SQL dotazy alebo SQL tabuľky. Ale ja som chcel používať rovnaké údaje pre viac služieb, tak som začal meniť SQL dotazy. Napísal som si automatické testy, aby kontrolovali, či sú správne a keďže som ich upravoval desiatky krát a ešte k tomu aj SQL schému, bol to dobrý nápad. Testovať to ručne by zabralo nenormálne množstvo času a odradilo by ma od dokončenia. Potom nasledovali ostatné veci. Toto som dokončil zhruba za šesť týždňov, ale pred týmto boli iné generácie tejto myšlienky, ktoré zlyhali, takže originálna myšlienka je stará asi dva roky.

*sos-sso* je skratka pre *stredná odborná škola - single sign on*, teda jednotné prihlásenie

## TODO a budúce veci ##

Kým softvér už je vhodný pre používanie naostro, treba ešte vyriešiť, či vylepšiť pár vecí:

- autorizáciu pre užívateľov pripojených cez freeRADIUS. Vyžaduje komunikáciu s wifi prístupovými bodmi (ssh+iptables).
- párovať užívateľov RADIUSu, DHCP požiadavky a MAC adresy, aby sa sledovalo používanie/zneužívanie zariadení
- viac automatických testov
- lepšie zotavovanie sa z neštandardných stavov ako napr. zmena uid, username alebo primárnej skupiný by mala zmeniť vlastníka jeho domovského adresára, quota (ktorá používa username), samba (tiež používa username), ...
- vyriesiť mnoho menej dôležitých TODOs
- niektoré reťazce sú natvrdo v slovenčine
- skupiny mail a wifi sú dané natvrdo
- využívať definované skupiny pre "vedenie" (management) (generovanie username z celého mena)
- nejak testuj sosssoroot a systémovú integráciu automaticky (QEMU)
- rob niečo s momentálne nevyužívanými tabuľkami z freeRADIUSu
- vytvoriť samostatného SQL užívateľa pre libnss s vlastnými právami (k heslu k SQL má prístup hocijaký shell užívateľ a môže si stiahnuť všetky zahashované heslá - nateraz nastav užívateľom rssh shell)
- rešpektuj aktívnosť/neaktívnosť užívateľa pre Sambu
