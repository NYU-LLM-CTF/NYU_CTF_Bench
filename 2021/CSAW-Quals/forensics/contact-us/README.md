<h1> Contact Us </h1>
<p> This challenge requires the use of Wireshark or a similar packet capturing and filtering software to open the .pcap file. 
 A flag has been sent to the Diskrete Development team through their Contact Us form on their website; however, the traffic is encrypted.
  To find the flag, challengers must determine how to decrypt traffic using the files provided and filter through the packets to find the flag. </p>
  
  <h1> Solution </h1>
  <p>  To solve this challenge, challenges must complete the following steps:    
    <ol type = "1">
         <li>Download the ContactUs.pcap and sslkeyfile.txt.</li>
         <li>Open ContactUs.pcap in Wireshark.</li>
         <li>Navigate to the <b>Edit</b> tab and then <b>Preferences</b>.</li>
         <li>Expand the <b>Protocols</b> tab and navigate to <b>TLS</b>.</li>
         <li>Click <b>Browse...</b> next to <b>(Pre)-Master_Secret log filename</b> and open the <b>sslkeyfile.txt</b> file.</li>
         <li>Click <b>OK</b> at the bottom of the Preferences window. The traffic should now be decrypted.</li>
      </ol>
      There are a few ways to find the flag in the newly decrypted traffic.<p>
      <ol type = "1">
        <li>Hit <b>CTRL+F</b> on your keyboard, select the following from the dropdown menus: <b>Packet details</b>, <b>Narrow & Wide</b>, <b>String</b>.</li> Then enter <b>flag{</b>.
        The flag should be in the decrypted traffic in packet #2534. The typical flag syntax is flag{.....}; therefore, since we know the flag is in the sent message, we can search for it.
        <li>Hit <b>CTRL+F</b> on your keyboard, select the following from the dropdown menus: <b>Packet details</b>, <b>Narrow & Wide</b>, <b>String</b>.</li> Then enter <b>veronica</b>.
        The flag should be in the decrypted traffic in packet #2534. We know Veronica sent the message and the Contact Us page requires a name, email, and message; therefore, we can search for her name.
        <li>Filter traffic by JSON and HTTP2 to find packet #2534 where the flag will be in the formData. </li></li>
      </ol>
  </p>
