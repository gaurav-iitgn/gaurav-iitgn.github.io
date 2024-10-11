#!/bin/sh

# This one is only for running on git hub website (action)
# for creating with options on self machines, use build-detail.sh
emacs -Q --script build-site.el 2> log-website.log
