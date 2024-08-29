=== CSAW CrackMe Chromium Plugin ===

Welcome to your brand new CrackMe experience! Now in your web browser!

=== Requirements ===

1. Linux x86-64
2. Chromium Browser
3. python3 and gdb
4. pygdbmi (pip3 install pygdbmi)
5. A strong will

=== Setup Instructions ===

1. Extract this tar.gz somewhere (Good job! You made it this far!)
2. Run `./install_rpc.sh` to install the CrackMe RPC server into Chromium
3. Enabled extension developer mode in Chromium
4. Click "Load Unpacked Extension" and navigate to the uncompressed `plugin` directory
5. Restart Chromium
6. You should now be good to go!

=== Challenge Information ===

* Flag1 is in `NativeMessagingHosts/flag1.txt`
* Flag2 is in `plugin/flag2.txt` and is also accessible at `chrome-extension://cegaaaajnnledpnkmnjenhbakdijgcjo/flag2.txt`
* Flag3 can be obtained by running `/flag3.exe`

(Note: The RPC is running in a copy of `NativeMessagingHosts`)

* Navigate to `/visit` to send our admin bot a URL
* The admin is running the latest Chrome with the plugin installed and will run for 10 seconds.
* All three flags only exist on the box the admin bot is run on.

Have fun with this crack me :)
- itszn
