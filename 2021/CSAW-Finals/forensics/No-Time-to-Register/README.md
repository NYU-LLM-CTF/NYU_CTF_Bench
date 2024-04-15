# No Time to Register  
Premise:
James Bond has retrieved some files from an enemy agent's system. As one of Q branch's support engineers, Bond is trusting you to find any information relevant to his investigation. Q has send you a checklist of what he wants you to find. Should be easy for an agent such as yourself.

## Author
Regulus915ap, aka Andrew Prajogi

## Questions & Answers:
1) Hostname/Computer Name: 5P3C7r3-1MP3r1UM
2) Timezone and Region: Singapore (Will be used as timezone for all answers; NOT GMT)
	Notes:
		HKLM\SYSTEM\ControlSet001\Control\TimeZoneInformation\TimeZoneKeyName

3) User
	a) Username: Spectre
	b) GUID: S-1-5-21-4228526091-1870561526-3973218081-1001
	c) Last Login: 09:01:28 11/01/2021 (Use format HH:MM:SS MM:DD:YYYY)
	d) Any other accounts that can be used: Administrator (Has been enabled)
	Notes:
		HKLM/SAM\SAM\Domains\Account\Users
		Keys will contin data that will identify the correct information
		Regripper will simplify this process

4) Attached USB
	a) USB Serial Number: 04016cd7fe9bdb2e12fdc62886a111831a8be58c0143f781b2179f053e9682a or 04016CD7FE9BDB2E12FDC62886A111831A8BE58C0143F781B2179F053E9682A 
	b) Last Connected: 15:49:01 11/01/2021
	c) First Connected: 04:36:59 10/31/2021
	d) Last Write: 15:49:13 11/01/2021
	e) USB Name: 3v1L_Dr1v3	
	f) Drive Letter: E 
	g) GUID: d53e38d0-36db-11ec-ae51-080027ec0de9 or D53E38D0-36DB-11EC-AE51-080027EC0DE9

	Notes: 		
		HKLM\SYSTEM\ControlSet001\Enum\USBSTOR\Ven_Prod_Version\USB iSerial #\Properties\{83da6326-97a6-4088-9453-a1923f573b29}\#### 
		•  Time is recorded in GMT/UTC
		•  0064 = First Install    (Win7 / 8) 
			o  Also found in setupapi.log / setupapi.dev.log 
		•  0066 = Last Connected  (Win8+ only) 
			o  Also \Enum\USB\VID_XXXX&PID_YYYY last write time of USB Serial # key 
			o  Also \MountPoints2\{GUID} last write time of key 
		•  0067 = Last Removal  (Win8+ only)
		
		HKLM\SOFTWARE\Microsoft\Windows Portable Devices\Devices 
		•  Find Serial # and then look for FriendlyName to obtain the Volume Name of the USB device
		
		HKLM\SYSTEM\MountedDevices 
		•  Find Serial # to obtain the Drive Letter of the USB device 
		•  Find Serial # to obtain the Volume GUID of the USB device

5) System Questions
	a) Windows Activation Key: VK7JG-NPHTM-C97JM-9MPGT-3V66T
		Note: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\BackupProductKeyDefault
	b) Windows Edition: Windows 10 Pro
		Note: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProductName
	c) Windows 10 Version: 21H1
		Note: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DisplayVersion
	d) Windows 10 Registered Owner: Spectre
		Note: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\RegisteredOwner
	e) Windows 10 Install Date: 16:02:09 10/26/2021
		Note: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\InstallDate
			InstallDate	REG_DWORD	0x6177b601 (1635235329) Needs Unix Timestamp Decode if done manually

Final Flag: flag{H1570rY 12'N7 k1ND 70 7h053 wh0 Pl4Y g0d} 
			"History isn't kind to those who play god"
			

## Solution / Notes - kent


### 1. Hostname Computer Name
Using reged  
`reged -e SYSTEM`  
`cd ControlSet001`  
`cd Control`  
`cd ComputerName`  
`cd ComputerName`  
`cat ComputerName`  

or
`cat ControlSet001\Control\ComputerName\ComputerName\ComputerName`

### 2. Timezone and Region (Use format HH:MM:SS MM:DD:YYYY)
`cat ControlSet001\Control\TimeZoneInformation\TimeZoneKeyName`

### 3a. User registered on the machine
`reged -e SAM`  
`cd SAM\Domains\Account\Users\Names`  
`ls`  
```
\SAM\Domains\Account\Users\Names> ls
Node has 5 subkeys and 1 values
  key name
  <Administrator>
  <DefaultAccount>
  <Guest>
  <Spectre> <-- answer
  <WDAGUtilityAccount>
  size     type              value name             [value if type DWORD]
     0  0 REG_NONE           <>
```

### 3b. GUID of user from 3a
switched to RegRipper here  
export SOFTWARE.txt  
![[Pasted image 20211107230736.png]]
```
<...>
Path      : C:\Users\Spectre
SID       : S-1-5-21-4228526091-1870561526-3973218081-1001
<...>
```

### 3c. Last login time of user from 3a using the timezone of found in 2.
RegRipper export SAM.txt  
```
<...>
Username        : Spectre [1001]
Full Name       : 
User Comment    : 
Account Type    : 
Last Login Date : Mon Nov  1 09:01:28 2021 Z
<...>
```

### 3d. Other accounts enabled on the machine
found in RegRipper SAM.txt export  
Answer: Administrator  
Guest, DefaultAccount, and WDAGUtilityAccount are shown but have "Account Disabled"  

### 4a. Name of USB attached to the machine
found in RegRipper SOFTWARE.txt export
Answer: 3v1L_Dr1v3

### 4b. Letter assigned to USB attached to the machine
found in RegRipper SYSTEM.txt export  
Answer: E

### 4c. Serial number of USB attached to the machine
found in RegRipper SOFTWARE.txt export  
Answer: 04016CD7FE9BDB2E12FDC62886A111831A8BE58C0143F781B2179F053E9682A  

### 4d. Timestamp of first connection of USB to the machine using the timezone of found in 2. (Use format HH:MM:SS MM:DD:YYYY)  
found in RegRipper SYSTEM.txt export  
or  
open SYSTEM in Autopsy and navigate to ControlSet001\Enum\USBSTORDisk&Ven_SanDisk&Prod_Ultra&Rev_1.00\04016cd7fe9bdb2e12fdc62886a111831a8be58c0143f781b2179f053e9682a\Properties\{83da6326-97a6-4088-9453-a1923f573b29}\0064  
remember convert to SGT time (GMT+8)
Answer: 04:36:59 10/31/2021  

### 4e. Timestamp of last connection of USB to the machine using the timezone of found in 2. (Use format HH:MM:SS MM:DD:YYYY)
found in RegRipper SYSTEM.txt export (labeled "Last Arrival")  
or  
open SYSTEM in Autopsy and navigate to ControlSet001\Enum\USBSTORDisk&Ven_SanDisk&Prod_Ultra&Rev_1.00\04016cd7fe9bdb2e12fdc62886a111831a8be58c0143f781b2179f053e9682a\Properties\{83da6326-97a6-4088-9453-a1923f573b29}\0066  
remember convert to SGT time (GMT+8)  
Answer: 15:49:01 11/01/2021


### 4f. Timestamp of last write to USB attached to the machine using the timezone of found in 2. (Use format HH:MM:SS MM:DD:YYYY)
found in RegRipper SYSTEM.txt export (labeled "Last Removal")  
or  
open SYSTEM in Autopsy and navigate to ControlSet001\Enum\USBSTORDisk&Ven_SanDisk&Prod_Ultra&Rev_1.00\04016cd7fe9bdb2e12fdc62886a111831a8be58c0143f781b2179f053e9682a\Properties\{83da6326-97a6-4088-9453-a1923f573b29}\0067  
remember convert to SGT time (GMT+8)  
Answer: 15:49:13 11/01/2021

### 4g. GUID of USB attached to the machine
found in RegRipper SYSTEM.txt export  
Answer: d53e38d0-36db-11ec-ae51-080027ec0de9  

### 5a. Windows Activation Key
couldnt find in RegRipper export   
`reged -e SYSTEM`
`cat Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\BackupProductKeyDefault`    
Answer: VK7JG-NPHTM-C97JM-9MPGT-3V66T  

### 5b. Windows Edition
RegRipper export SYSTEM.txt  
or   
`reged -e SYSTEM`  
`cat Microsoft\Windows NT\CurrentVersion\ProductName`  
Answer: Windows 10 Pro

### 5c. Windows Version
RegRipper export SYSTEM.txt  
or   
`reged -e SYSTEM`  
`cat Microsoft\Windows NT\CurrentVersion\DisplayVersion`  
Answer: 21H1

### 5d. Windows Registered Owner
RegRipper export SYSTEM.txt  
or   
`reged -e SYSTEM`  
`cat Microsoft\Windows NT\CurrentVersion\RegisteredOwner`  
Answer: Spectre

### 5e. Windows Install Date using the timezone of found in 2. (Use format HH:MM:SS MM:DD:YYYY)

~~install date is wrong~~ oops
~~Tue Oct 26 08:02:09 2021~~

## Updates from OSIRIS Lab author
The install date has been corrected on the `server.py`

## Addendum from Andrew Prajogi
Confirmed that the time originally reported was off by 12 hours due to an incorect coversion from standard to military time
1635235329 translates to Tue Oct 26 08:02:09 2021 GMT
Tue Oct 26 08:02:09 2021 GMT translates to Tue Oct 26 16:02:09 2021 Singapore Standard Time

## Notes on RegRipper,etc - OSIRIS Lab tester
For some reason I could not get RegRipper to give the right answer from a linux VM, had to install it on Windows

I think its a good quality challenge, very straight forawrd!

md5sum: 0a479814de58f2b4ad80af11cf8ef027
