#!/bin/bash

exec socat tcp-listen:${1-9222},fork,reuseaddr exec:'./showdown',pty,stderr,setsid,sane
