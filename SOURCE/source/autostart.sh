#!/bin/bash
# Scripts & Commands listed below will run on bootup (in /etc/rc.d/rc.local)
/opt/sbu/source/check-config.sh
/opt/sbu/source/check-delete-queue.sh
