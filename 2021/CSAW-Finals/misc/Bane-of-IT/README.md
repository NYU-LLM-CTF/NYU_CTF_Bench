# Bane of IT
## Description
You have received an IT ticket to repair a server that refuses to boot. Administrator John Doe would like to to fix it ASAP on behalf of the Generic Company.

Just make sure it boots and login in as John to complete this challenge. John has given us no details to the problem and has forgotten his own password. (Sigh)

His only words of wisdom was that "the answer will be found in pieces throughout the day".

## Author
Regulus915ap, aka Andrew Prajogi

## OVA File Download Link
(DO NOT USE) Version 1 --> https://drive.google.com/file/d/1PF9kTvJGc7ItV64-8pOWcncyng6YiRst/view

(NO LONGER VALID) Version 2 --> https://drive.google.com/file/d/1S-gruCeBUISK7o8-j_o4dshsKMa8N008/view?usp=sharing

Version 3 --> https://drive.google.com/file/d/19MRLC_K3n4VeFVjSi_DlDyq-zZNIf1hh/view?usp=sharing

s3 bucket ---> https://csaw-final-challenges.s3.us-east-2.amazonaws.com/IT's+Bane+v3.ova

(December 2021 comment): our regrets that we cannot make these large files available for hackers from the future to download. We hope the walktrough is still useful for you though!

## Solve
The grub and fstab configurations have been sabatoged on purpose.
There are many ways to fix the issus at hand, but the easiest to do for beginners
1) On first boot, the system will load a grub command line. This indicates a corrupted or missing grub configuration files. The fastest way to fix this would be to use the troubleshooting option on a CentOS install disk
	On boot for install disk: select Troubleshooting > Rescue a CentOS System
		When the boot completes, it will load a rescue menu. Select the first option to have it continue to loate the existing CentOS installation
		However this will fail as it would not be able to locate the installation		
			This is an indication that something must be wrong with the mapping to paritions. IE the /etc/fstab file may be pointing in the wrong direction
				Using a live OS to look into the partition would show that the fstab was misconfigured as the root partion points to /root rather than /
				Also it should be noted that CentOS users should be familiar that there is not a /root partition to mount, it would simiply just be / itself
Reboot

2) Fixing the fstab would finally allow the initial steps mentioned above:
	On boot for install disk: select Troubleshooting > Rescue a CentOS System
		When the boot completes, it will load a rescue menu. Select the first option to have it continue to loate the existing CentOS installation
		The partition will now be found. Follow the instructions to get a bash shell
			Note: At this point, people make the mistake of not hitting enter first to get the first shell, so the instruciton to run the chroot /mnt/sysimage is never executed
			When you receive the bash shell, you have succesfully followed the instructions
		To fix the grub issues, "~~run~~ grub2-mkconfig -o /boot/grub2/grub.cfg"
			Note: This system can be identified as a BIOS (not UEFI) based system if one looks at the partitions (lack of /boot/efi) so the command above is the one that will work
Reboot

3) Now that the boot is fixed, you can try to boot normally, however, a FIPS integrity test will fail
	Two ways to fix:
		Go back to Troubleshooting to disable FIPS
			On boot for install disk: select Troubleshooting > Rescue a CentOS System
				When the boot completes, it will load a rescue menu. Select the first option to have it continue to loate the existing CentOS installation
				The partition will now be found. Follow the instructions to get a bash shell
				Modify /etc/default/grub
					Method 1) The easiest if one decides to disable the check
						In the file, find and set "FIPS=0"
					Method 2) If you want to allow the check to work correctly
						In the file, you need to set the UUID to the correct disk as I set it to something else
							Use lsblk and blkid to find the /boot disk UUID and replace the value in the file to fcfd2877-42bb-499b-b8ac-ec28b185ef0b
							Or cheat and just say boot=/dev/sda1
Reboot

4) Finally, the system will boot. But remember, you don't know the password
	Go back to Troubleshooting to disable FIPS
		On boot for install disk: select Troubleshooting > Rescue a CentOS System
			When the boot completes, it will load a rescue menu. Select the first option to have it continue to loate the existing CentOS installation
			The partition will now be found. Follow the instructions to get a bash shell
			Find the username that John logs in on (jdoe) by looking into the "/etc/passwd" file
			Use command "passwd jdoe" to reset the password
Reboot
NOTE: This part can be bypassed if one chooses to boot in rescue mode.

5) System will boot. Enter username and password. Flag will be displayed on GUI background.
			

## Flag
Flag is split into three parts as background screensavers. They rotate depending on the time on the machine. This hint is reference in the prompt above.
There are a number of fake flags to hide the real one in the event one tries to bybass the challenge by trying to find the flag.
1) /usr/share/backgrounds/morning.jpg - flag{7h15_15_
2) /usr/share/backgrounds/day.jpg - why_1T_p30p13_
3) /usr/share/backgrounds/night.jpg - @r3_m3@n}
**flag{7h15_15_why_1T_p30p13_@r3_m3@n}**


## md5sum
Version 1: 3bd408d8973997fa7b7d825a891d5e91  IT's Bane.ova

Play test [here](https://github.com/osirislab/CSAW-CTF-2021-Finals/blob/main/misc/Bane-of-IT/bane%20of%20it.pdf)

## SHA-256
Version 3: 56479CE5A965CDA0D5C0A30A2168234A4CC840D2EEFF3131185371C1C03AA181  IT's Bane v3.ova
