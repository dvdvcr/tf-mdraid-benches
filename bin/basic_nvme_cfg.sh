#!/bin/bash
# extremely ugly example script for building md and running some benchmarks.

yum-complete-transaction &>/dev/null
yum install -y hdparm fio

# config the mount point for testing
echo y | mdadm --create --verbose /dev/md0 /dev/nvme2n1 /dev/nvme1n1 --level=1 --raid-devices=2
mkdir /mnt/mdvol
mkfs.xfs /dev/md0
mount /dev/md0 /mnt/mdvol

/sbin/hdparm -t /dev/md0 > /root/hdparm-reads.txt

# async IO
cat >> /root/aio-read.fio << "fiocfg"
[global]
ioengine=libaio
buffered=0
rw=randread
bs=128k
size=512m
directory=/mnt/mdvol/

[file1]
iodepth=4

[file2]
iodepth=32

[file3]
iodepth=8

[file4]
iodepth=16
fiocfg

# random rw
cat >> /root/random-read-write.fio << "fiocfg"
[global]
bs=4K
iodepth=256
direct=1
ioengine=libaio
group_reporting
time_based
runtime=120
numjobs=4
name=raw-randreadwrite
rw=randrw
							
[job1]
filename=/dev/md0
fiocfg

fio aio-read.fio &>/root/aio-read.txt
fio random-read-write.fio &>/root/random-read-write.txt