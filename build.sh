#!/bin/sh
echo "Building site locally in /public"
emacs -Q --script build-site.el
echo "Done."

echo
echo "Sending files to github"
git push origin master
echo "Done."

# modify links for IITGN system (Base is ~gauravs)
# change all occurrences of href="/~gauravs/~gauravs/~gauravs/" to href="/~gauravs/~gauravs/~gauravs/~gauravs/"
cd public
grep -rli 'href=\"\/' | xargs -i@ sed -i 's/href=\"\//href=\"\/~gauravs\//g' @
# echo $?

echo
echo "Transmitting it to iitgn /public_html via FTP"
pwd
ftp -in <<EOF
open ftp.gauravs.people.iitgn.ac.in
user gauravs $(cat ~/.authinfo | grep ftp.gauravs.people.iitgn.ac.in | awk '{print $8}')
cd /public_html
mput *
close
bye
EOF
cd ..
echo "Done."
