#!/bin/sh

sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
sudo killall -9 mDNSResponder
