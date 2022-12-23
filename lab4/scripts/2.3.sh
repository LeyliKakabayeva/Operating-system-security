#!/bin/bash
grep "000000" ~/bash.txt > /tmp/zeros
grep -v "000000" ~/bash.txt > /tmp/nozeros
head -10 /tmp/zeros && tail -10 /tmp/zeros
head -10 /tmp/nozeros && tail -10 /tmp/nozeros
