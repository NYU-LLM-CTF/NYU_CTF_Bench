# i am afRAID of loss
## Description
I lost my pictures of striped cats on these hard drives. You can recover it for me, right?

[link to challenge download redacted: this was a 6GB file and we couldn't keep hosting it in AWS. Oh well! Here's the solution below in case you have the file from the CTF or just want to know how one of these is done.]



## MD5 Hash of the challenge file: c5fbcf72ab0652be1ec0e10a3e8ebdc1
## Flag for this file: `flag{D0n7_b3_4fRAID_0f_str1p3d_c4ts}`

## Author
Wyatt Roersma, SimSpace

## Evidence Files:
**disk-forensics-ctf.7z**
MD5: c5fbcf72ab0652be1ec0e10a3e8ebdc1
**disk1.vmdk**
SHA256: 0397F73703D30C5C598CC3FB9A4F1581D691634B300529C84C706BC380D1E7BA
**disk2.vmdk**
SHA256: 7010A72361B6FD3A607C279E55FFF72A087168510B4160C72FCA798F35B8ECDE
**disk3.vmdk**
SHA256: 33E2F263FC1E0CFF837B4CF110D3102B07F6A17D33A108DF25644E682B8A4495
**Windows 10 and later x64-cbe8abc0.vmem**
SHA256: 5365CDDE0D9E770B89077F54D33D623446608F8BC4D02A400B4296F2AB0DC292
**Windows 10 and later x64-cbe8abc0.vmss**
SHA256: 8B6173C816F276EF61CC41B332458E7DF09EC2B7E08FAA88613D516794A14B1E

## Disks Make a RAID 5 storage pool on windows 10:
Mount the vmware drives to a windows 10 pro/enterprise system that is fully updated and you will get a prompt to unlock a storage device with the identification of 2EFDA7AA. 

Using the memory dump you can find the drive recovery key. Use strings on the memory image:
- strings -a -td -el wd17-ee06c78a.vmem > strings.txt
- grep 2EFDA7AA strings.txt -C 10 | grep "Recovery Key:" -A 1

## Answer Data
The output gives us the recovery key `142692-508640-543697-489720-660242-028732-320606-452540`. Using the recovered key you can unlock the drive and see 5 files on the system:
- cat1.jpg
- cat2.jpg
- cat3.jpg
- cat4.jpg
- cat5.png --> This has the flag

## Flag
`flag{D0n7_b3_4fRAID_0f_str1p3d_c4ts}`

## Tester Notes from `moat` --> From a previous version of the challenge
I tried mounting the .vmdk files a few different ways, but wasn't successful. I tried mounting them in Windows 10 Pro by mapping the drives, a few command lines apps from VMware to try to rebuild the .vmx file, opening them in VMware Workstation Player 15 and Pro 15, and tried to rebuild the .vmx file by following the instructions here: https://kb.vmware.com/s/article/2010196 It seems like the files may have been built with version 16 as the error said that 15 was too old to run the file. I was able to get the key easily, but the mounting is where I expect most people to get caught. 
