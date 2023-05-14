#! /usr/bin/bash
# Config for script to upload and download repo.
# Directory where the repo is stored locally. Example: $HOME/repo/
target="$HOME/BredOS/bred-repo/"
# Replace your_username with your username.
#repo_osdn='rippanda12@storage.osdn.net:/storage/groups/b/br/bredos/repo/'
repo_bred='data@repo.bredos.org:/repo/repo/'
# END OF CONFIG
read -r -p "What do you want to do sync/upload/exit (s/u/CTRL+C) " RESP
if [[ "$RESP" =~ ^[Ss]$ ]]; then
   echo "Syncing from OSDN"
   sleep 5
   rsync -PavHl --safe-links --delete-delay --delay-updates --timeout=600 $repo_osdn $target
   echo "Last sync was $(date -d @$(cat ${target}/lastupdate))"
elif [[ "$RESP" =~ ^[Uu]$ ]]; then
    read -p "Do you want to update the lastupdate file (y/N) " LASTUPD
    if [[ "$LASTUPD" =~ ^[Yy]$ ]]; then
     echo "Updating $target/lastupdate"
     date +'%s' > $target/lastupdate
     echo "$(date -d @$(cat ${target}/lastupdate))"
    fi
    read -r -p "Where do you want to upload changes to OSDN/repo.bredos.org/ALL (o/b/a/CTRL+C) " UPLD
     if [[ "$UPLD" =~ ^[Oo]$ ]]; then
          echo "Uploading to OSDN"
          sleep 5
          rsync -Pavhl --safe-links --delete-delay --delay-updates --timeout=600 --exclude='.git' $target $repo_osdn
     elif [[ "$UPLD" =~ ^[Bb]$ ]]; then
          echo "Uploading to repo.bredos.org"
          sleep 5
          rsync -Pavhl --safe-links --delete-delay --delay-updates --timeout=600 --exclude='.git' $target $repo_bred
     elif [[ "$UPLD" =~ ^[Aa]$ ]]; then
          echo "Uploading to ALL repos"
          echo "Uploading to repo.bredos.org"
          sleep 5
          rsync -Pavhl --safe-links --delete-delay --delay-updates --timeout=600 --exclude='.git' $target $repo_bred
          echo "Uploading to OSDN"
          sleep 2
          rsync -Pavhl --safe-links --delete-delay --delay-updates --timeout=600 --exclude='.git' $target $repo_osdn
     fi
else
  echo "Please run the script again"
fi
