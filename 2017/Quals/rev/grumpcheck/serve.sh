#!/bin/bash
socat TCP-LISTEN:7890,reuseaddr,fork EXEC:"python -u grumpcheck.py"
