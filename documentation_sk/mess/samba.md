
$$$$$$$$$$ččč
RAILS_ENV=production rails console

require 'from_ldap_convertor'; x = FromLdapConvertor.new("/home/bloodbornemisa/ldapdump082014.txt"); x.populate_primary_groups; "aaa"

x.populate_users
x.populate_aliases
x.populate_groups
x.populate_primary_groups













########### LDAP vyhadzovanie

ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b ou=People,dc=myrtana,dc=sk "gidNumber=1004" | grep dn | sed 's/^dn: \(.*\)/\1/' > to_delete


ldapdelete -h localhost -x -W -D "cn=admin,dc=myrtana,dc=sk" -c `cat to_delete`

ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b ou=People,dc=myrtana,dc=sk | grep gidNumber: | sort | uniq



# skriptovanie

- užitočné ked nejde napr. ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b ou=People,dc=myrtana,dc=sk "gidNumber=1004|1005|1006"

tak treba naskriptovať

for i in "1004 1005 1006" do;  ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b ou=People,dc=myrtana,dc=sk gidNumber=$i; done

