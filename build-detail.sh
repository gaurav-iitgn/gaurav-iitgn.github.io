#!/bin/sh

LOGFILE=log-website.log
SEND_TO_FTP=
echo "Starting..."
echo "Log will be written to $LOGFILE"

echo "Building site locally in /public through Emacs." 
emacs -Q --script build-site.el 2> log-website.log
echo "Done."

while getopts 'hgf' OPTION; do
    case "$OPTION" in
        h)
            echo "Help text Usage"
            ;;
        g)
            echo "Will check and publish to github"
            echo
            echo "Sending files to github"
            git push origin master
            echo "Done."
            ;;
        f)
            echo "Will send public directory to FTP"
            SEND_TO_FTP=True
            ;;
        *)
            echo "Print usage"
            ;;
    esac
done

if [ $CI ]; then
    echo "In CI environment."
else
    echo "Not in CI environment."
    echo "Likely in self hosted system."
    # modify links for IITGN system (Base is ~gauravs)
    # change all occurrences of href="/" to href="/~gauravs/"
    echo "Modifying links within the public folder to consider /~gauravs/"
    cd public
    grep -rli 'href=\"\/' | xargs -i@ sed -i 's/href=\"\//href=\"\/~gauravs\//g' @
    # echo $?
    echo "Done."
fi


if [ $SEND_TO_FTP ]; then
    echo "Transmitting to FTP."
else
    echo "Not transmitting to FTP."
    exit 0
fi


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
