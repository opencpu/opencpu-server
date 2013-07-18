#!/bin/bash
#This script removes all tempfiles by opencpu that are over an hour old
find /tmp -mmin +60 -user opencpu -delete
find /tmp -mmin +60 -user opencpu -type d -empty -exec rmdir {} \;