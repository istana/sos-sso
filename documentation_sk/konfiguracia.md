# Konfigurácia

1. nastavenie premenných (Rails)
2. nastavenie premenných (shell)
3. nastavenie web servera (Apache)



2. Bash

Nainštalovať Bundler


````bash
RBENV_VERSION=2.2.2 gem install bundler
````

Ak bude aplikácia bežať example.org/sos-sso, tak treba pridať:

````bash
# .bash_profile alebo .bashrc alebo .profile

export RAILS_RELATIVE_URL_ROOT='/sos-sso'
````