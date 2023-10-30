#!/bin/bash
/bin/yum install hdparm -y
/sbin/hdparm -t /dev/xvda > /tmp/reads.txt
/usr/bin/dd if=/dev/random of=/tmp/write_test bs=1024 count=10240 2> /tmp/writes.txt