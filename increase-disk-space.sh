#!/bin/bash

# Script designed to increase the disk space on your boot disk without turning off the machine
# The steps include the creation of a snapshot of your current disk as a back-up before increasing the size
# To run, you must include an arugement ($1) for the percentage you would like your disk space to be increased
# For example:
#   ./increase_disk_space.sh 10 
# This will increase your current disk space by 10% 

if [ $1 -gt 50 ]
then
    echo "You cannot increase the disk space by more than 50% using this script. You can do so via the console if you wish."
    exit 
fi

# Get the name of the VM, its zone, and use the name and today's date to create a name for the snapshot
NAME=$(hostname)
ZONE=$(gcloud compute instances list --filter="name=($NAME)" --format "value(zone)")
SNAPSHOT_NAME=$NAME$(date +"%Y-%m-%d")

# List the disks attached to this VM
gcloud compute instances list --filter=$NAME --format="table(name,zone,disks[].deviceName)"
# And then prompt the user to enter the name of their disk
read -p "Above are the disks on attached to your instance. Which is the one you would like to resize? Simply type your response in console, quotation marks are NOT needed. " SOURCE_DISK

# Create a snaphsot of the disk to store as a back-up in case of emergency 
echo "Creating a snapshot..."
gcloud compute snapshots create $SNAPSHOT_NAME \
    --source-disk $SOURCE_DISK \
    --snapshot-type STANDARD \
    --source-disk-zone $ZONE

# Get the current size of the disk (in GBs)
CURRENT_SIZE=$(gcloud compute disks describe $SOURCE_DISK --zone $ZONE --format="value(sizeGb)")

# Calculate the new size of the disk based on the arguement given when the script was called - increasing the disk space by X%
((x=$CURRENT_SIZE, y=$1, a=x*y, b=a/100, NEW_SIZE=b+x))

# In case of a non-integer value, round the NEW_SIZE variable to nearest integer
NEW_SIZE_R=$(printf '%.*f\n' 0 $NEW_SIZE)

# Resize the disk 
gcloud compute disks resize $SOURCE_DISK --zone $ZONE --size $NEW_SIZE_R

# Grow the partition
sudo growpart /dev/sda 1

# Resize the file system 
sudo resize2fs /dev/sda1

# Check to make sure changes worked
df -h
