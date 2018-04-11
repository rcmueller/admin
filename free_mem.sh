#!/bin/bash

## script for the Generic Monitor goody (XFWM)
## http://goodies.xfce.org/projects/panel-plugins/xfce4-genmon-plugin

free -h|awk '$1~/Mem/ {print $4}'
