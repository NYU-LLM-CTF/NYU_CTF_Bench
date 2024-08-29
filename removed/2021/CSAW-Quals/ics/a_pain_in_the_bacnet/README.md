# A Pain in the BAC(net)

## Overview

Topics Covered:
* BACnet Protocol
  
Challenge Information:
* Flag: flag{Sensor_12345}
* Max Attempts: 3-5
* Attachments: bacnet.pcap

## Prompt

Attached is a packet capture taken from a building management network. 

On of the analog sensors reported values way outside of its normal operating range. Can you determine the object name of this analog sensor? 

Flag Format: flag{Name-of-sensor}. For example if the object name of this analog sensor was Sensor-Temp1, the flag would be flag{Sensor-Temp1}.

### Solution

We know we are looking for an analog sensor and based on the prompt we are probably wanting to focus on the present-value field, as that is the only property that would be able to report values outside of their normal ranges.

We can filter this traffic to look only for present-value fields by adding a filter for present-value by right clicking "Property Identifier: present-value (85)" in the BACnet APDU dissection in Wireshark and adding that field as a filter to Wireshark: `(bacapp.property_identifier == 85)`

We also only really care about the responses, so we can do the same for "APDU Type: Complex-ACK": `(bacapp.type == 3)`.

The Wireshark filter `(bacapp.property_identifier == 85) && (bacapp.type == 3)` shows only present-value response packets.

Looking through each of the analog inputs, we can see most of the values stay relatively within the same range. However, analog-input 7 jumps quickly from around 1400-1500 to 99999.99 for 4 packets before returning to normal.

Now that we know analog-input 7 reported the weird values, we need to find the object name for this sensor. The Wireshark filter `(bacapp.objectType == 0) && (bacapp.instance_number == 7)` will only show traffic to and from analog-input 7.

Scrolling through this traffic we can see various readProperty responses showing it's object-name is "Sensor_12345". Therefore, our flag is **flag{Sensor_12345}**.

### Write-up

Open the `bacnet.pcap` file with Wireshark, use filter `bacapp.type == 3` to show the respond message from sensor devices. We can see that there's several response message types: `object-name`, `units`, `event-state`, `out-of-service`, `present-value`.

Since the challenge is about finding the abnormal sensor values, use filter `bacapp.present_value.real` to see all the present_value response.

After going through the data, I found out that the most of the value range between 0~1700, however, there are 4 abnormal packages that contain value of `99999.9921875`: No.1803, No.1833, No.1973, No.2033.

We can get the object name from the `object-name` package of this sensor, which is Sensor_12345.

Therefore the flag is flag{Sensor_12345}.

### Comment

I think it's a pretty good challenge for understanding BACnet protocol for beginners. 

The instruction is straight forward. And the flag in `challenge.json` matches the real flag.
