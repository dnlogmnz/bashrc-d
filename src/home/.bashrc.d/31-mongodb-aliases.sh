#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/mongodb-aliases.sh
# Aliases para facilitar o uso do MongoDB Atlas tools
# ==========================================================================================

# Aliases para mongosh
alias mongosh-connect="mongosh --quiet"
alias mongosh-local="mongosh mongodb://localhost:27017"
alias mongosh-version="mongosh --version"

# Aliases para mongoexport
alias mongo-export-json="mongoexport --type=json --pretty"
alias mongo-export-csv="mongoexport --type=csv --fieldFile"

# Aliases para mongoimport
alias mongo-import-json="mongoimport --type=json --jsonArray"
alias mongo-import-csv="mongoimport --type=csv --headerline"

# Aliases para mongodump
alias mongo-dump="mongodump --gzip"
alias mongo-dump-local="mongodump --host localhost:27017 --gzip"

# Aliases para mongorestore
alias mongo-restore="mongorestore --gzip"
alias mongo-restore-local="mongorestore --host localhost:27017 --gzip"

# Aliases para Atlas CLI
alias atlas-login="atlas auth login"
alias atlas-logout="atlas auth logout"
alias atlas-whoami="atlas auth whoami"
alias atlas-projects="atlas projects list"
alias atlas-clusters="atlas clusters list"

#--------------------------------------------------------------------------------------------
#--- Final do script 'mongodb-aliases.sh'
#--------------------------------------------------------------------------------------------