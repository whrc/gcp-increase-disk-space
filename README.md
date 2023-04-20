# gcp-increase-disk-space
## Shell script to increase the disk space of your GCP virtual machine

Using this script will allow you to increase the disk space on your VM by a percentage (e.g., increase disk space by 20%). 
- Currently, the script will not allow you to increase the disk space by more than 50% at one time.
- If you need to make a larger increase to the disk space, then you can follow the instructions here to do so on the GCP Console or using `gcloud` commands [here](https://cloud.google.com/compute/docs/disks/resize-persistent-disk#console). 

In the process of increasing the disk space, a snapshot of the disk will be created as a back-up in case something goes wrong in the course of increasing the disk space. You can find more information on snapshots [here](https://cloud.google.com/compute/docs/disks/snapshots).  

If you can no longer access your VM via SSH, it is likely you have run out of disk space. Even if you increase the disk space on the Console, you still will likely not be able to access your machine. You have a couple options: 
1.  You can create an instance and recreate the boot disk from a snapshot to resize it. You must know the size of the boot disk you're recreating. Instructions [here](https://cloud.google.com/compute/docs/disks/recover-vm#inaccessible_instance). 
  - **Note:** This will re-cover the data stored on your disk, but may not restore the exact environment of your previous machine (i.e., you may have to re-install software)
2. You can enter your VM in recovery mode using [GCE_Rescue](https://github.com/GoogleCloudPlatform/gce-rescue). More information below: 
- With GCE Rescue, you can boot the VM instance using a temporary boot disk to fix any problem that may be stopping the VM instance. Specifically, GCE Rescue uses a temporary Linux image as the VM instance’s boot disk to let you do maintenance on the faulty boot disk while it is in rescue mode.
- When running GCE Rescue, it creates a snapshot of the existing boot disk for backup.
- After you’ve fixed the faulty disk, you can then restore the original configuration by running GCE Rescue again to reboot the VM instance in normal mode again.
- The advantage of using GCE Rescue is that it uses the resources already configured on the VM instance, such as networking, VPC firewalls or routes, to restore the faulty boot disk instead of creating a duplicate VM instance to restore the faulty boot disk.
- Note: **`GCE Rescue is not an officially supported Google Cloud product`**. The Google Cloud Support team maintains this repository, but the product is experimental and, therefore, it can be unstable.

Please create an issue on this repo if you run into any bugs or need any help. 
