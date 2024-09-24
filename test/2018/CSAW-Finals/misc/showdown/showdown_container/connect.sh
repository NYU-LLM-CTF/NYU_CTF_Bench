#!/bin/bash

exec socat tcp-connect:${1-216.165.2.41}:${2-9222} file:`tty`,raw,echo=0
