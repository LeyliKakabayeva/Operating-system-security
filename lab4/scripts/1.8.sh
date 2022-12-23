#!/bin/bash
echo "Процессов пользователя:"
echo "$USER"
ps -U $USER | wc -l
echo "Процессов пользователя root:"
ps -U root | wc -l
