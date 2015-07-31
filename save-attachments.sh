#!/bin/bash
LOG=/dev/stderr
echo "== $(date -Is) ==" >> $LOG

fetchmail 

