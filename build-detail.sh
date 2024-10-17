#!/bin/sh

LOGFILE=log-website.log
SEND_TO_FTP=
echo "Starting..."
echo "Log will be written to $LOGFILE"

echo "Building site locally in /public through Emacs." 
emacs -Q --script build-site.el 2> log-website.log
echo "Done."

while getopts 'hgfs' OPTION; do
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
            echo "Will send public directory via FTP"
            SEND_TO_FTP=True
            ;;
        s)
            echo "Will send public directory via SSH"
            SEND_TO_SSH=True
            ;;
        *)
            echo "Print usage"
            ;;
    esac
done

if [ $CI ]; then
    echo "In CI environment."
else
    # update links when transmitting to FTP (~gauravs domain)
    if [ $SEND_TO_FTP ]; then
        echo "Not in CI environment."
        echo "Likely in self hosted system."
        # modify links for IITGN system (Base is ~gauravs)
        # change all occurrences of href="/" to href="/~gauravs/"
        echo "Modifying links within the public folder to consider /~gauravs/"
        cd public
        grep -rli 'href=\"\/' | xargs -i@ sed -i 's/href=\"\//href=\"\/~gauravs\//g' @
        # echo $?
        cd ..
        echo "Done."
    fi
fi


# Transmitting via SSH -- link updates not needed as in FTP
# this is gauravs.people.iitgn.ac.in domain
if [ $SEND_TO_SSH ]; then
    echo "Transmitting via SSH."
    cd public
    sshpass -p $(cat ~/.authinfo | grep ftp.gauravs.people.iitgn.ac.in | awk '{print $8}') scp -r * gauravs@gauravs.people.iitgn.ac.in:/home/gauravs/public_html
    cd ..
else
    echo "Not transmitting via SSH."
fi

# Transmitting via FTP
if [ $SEND_TO_FTP ]; then
    echo "Transmitting via FTP."
else
    echo "Not transmitting via FTP."
    exit 0
fi


echo
echo "Transmitting it to iitgn /public_html via FTP"
cd public
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
