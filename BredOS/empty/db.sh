#! /usr/bin/bash


dbfile=BredOS.db.tar.gz
# strip file extension from dbfile
basedb=${dbfile%.db.tar.gz}
if [ "$1" = "add" ]; then
    shift 1
    repo-add $dbfile "$@"
elif [ "$1" = "remove" ]; then
    shift 1
    repo-remove $dbfile "$@" 
else
    echo "Usage: $0 add|remove pkgfiles"
fi

rm $basedb.db $basedb.files
cp $basedb.db.tar.gz $basedb.db
cp $basedb.files.tar.gz $basedb.files
