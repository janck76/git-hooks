#!/bin/bash - 

INTERACTIVE='false'
if [[ $1 == '-i' ]]; then
    INTERACTIVE='true'
fi

# Environment variable PROJECTS
# Kolon-separarert streng av prosjekter som skal oppdateres
if [[ ! $0 =~ ^\./ ]]; then 
    curpath=$(dirname $0)
else
    curpath='.'
fi

source "$curpath/common.sh"

IFS=':' read -a DIRS <<< "${PROJECTS}"

if [[ -z $PROJECTS ]]; then
    echo "Please specify projects to update:"
    echo "export PROJECTS=/path/to/project1:/path/to/project2:..."
    exit 1
fi
for P in "${DIRS[@]}"; do
    update_project $P
    echo
done

