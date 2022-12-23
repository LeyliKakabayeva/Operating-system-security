#!/bin/bash
N=`echo -e "$USER$HOME" | tr -d "\n" | wc -c`
echo "$USER $HOME $N"
