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

#### check_updates.sh
Sjekker remote status for git-prosjekter
* Prosjekter som skal sjekkes defineres i environment variabel PROJECTS
  Dette er kolon-sepraret streng med full sti til prosjektene
  Eks.: /home/jc/projects/projectA:/home/jc/projects/projectB
* Kjører "git remote update" for hvert prosjekt og varsler om
  prosjektet ligger bak remote
* Opsjon: -i<br>
  Dersom et prosjekt trenger oppdatering, får man meny med valg om
  å vise logg og å kjøre rebase

Avhengigheter
* Scripetet må befinne seg i samme dir som common.sh

Annet
* Dersom filen `env` finnes i samme dir som scriptet, sources denne
  PROJECTS environemnt kan eksporteres i denne filen


