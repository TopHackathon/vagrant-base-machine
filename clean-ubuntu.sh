#!/bin/bash

# When creating a base box from ubuntu, its a good idea to clean the install
# so its not so bloated. This script contains ideas on how to do this:

# Nuke libreoffice
sudo apt-get remove --purge libreoffice*

sudo apt-get autoclean
sudo apt-get clean
sudo apt-get autoremove

# Clear bash
cat /dev/null > ~/.bash_history && history -c

# Pack zeroes into image so it can be compressed better
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
