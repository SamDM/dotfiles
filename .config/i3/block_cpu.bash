#!/usr/bin/bash

AVG_CPU=$(/usr/libexec/i3blocks/cpu_usage | head -n1)
AVG_LOAD=$(uptime | sed 's/,//g' | awk '{printf("%s %s %s", $8, $9, $10)}')
echo $AVG_CPU $AVG_LOAD
