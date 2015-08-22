# Git hooks
Git hooks for henting av oppdatering fra remote servere 


## Installasjon
```
git clone https://github.com/janck76/git-hooks
mkdir <git-prosjekt>/.helpers
cp -R git-hooks <git-prosjekt>/.helpers
cd <git-prosjekt>/.helpers
./install_hooks.sh
``` 

#### post-checkout
* Henter oppdateringer fra alle remote servere 
* Varsling dersom current branch ligger bak remote branch

#### post-commit
* Henter oppdateringer fra alle remote servere
* Varsling dersom current branch ligger bak remote branch


