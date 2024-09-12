#!/bin/bash
#J.S. Jun 6 2022
#ASCII Rickroll! Now with 100% more sound! Written fully in BASH! This file contains the first ~25 seconds worth of frames from "Never gonna give you up". They were converted to ASCII images and appended to the end of this script. The script steps through the file printing one frame worth of lines at a time. The MP3 audio is also appended to the end of this file. When played as an MP3 the script and ASCII frames are ignored, leaving only the magical notes of never gonna give you up.
#Remember, since these lines cause an offset you must have 25 lines here unless you update the step offset. Otherwise it all goes wrong.
#This is the small version for 130x36 terminal resolution
echo ""
echo "The answer to life, the universe, and all things is:"
sleep 2
echo "Calculating.... 0%"
sleep 1
echo "Calculating.... 20%"
sleep 1
echo "Calculating.... 50%"
sleep 1
echo "Calculating.... 90%"
sleep 1
printf '\e[3;0;0t'; printf '\e[8;36;130t' #set window to top right and resize window
ffplay -nodisp -loglevel quiet $0 2> /dev/null &
for i in  $(seq 61 36 5425); do #Using a for loop, step through the frames.
	printf '\e[2J\e[1H\n\n\n' # Clears screen after every frame.
	cat $0 | head -$i | tail -36 #Get frame at (offset+(frame_number*y_resolution) lines, then only show last y_resolution lines. This displays each frame one after the other.
	sleep 0.12 #Delay to set the frame rate. Smaller is fater, bigger is slower.
done
exit #Now end the script before it tries to execute ASCII images as code. ASCII frames begin after line 25.
-----BEGIN RICK ROLL----
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
               lxxxkkkOkkOOkxxxxOOkOOOOOko:;;;,'....  ...............,'..'',,,,,,,oddxxxxxxdoo:               
               lxxkkkkOOOOOxxxxkOOkOOkkkkol:;,............................''''',,:ddddddxxxdoo:               
               lxxkOkkOkOOkxxxxkkkkkkkkkxxo:,'............  ........ .....'...'',cddddddxxxdoo:               
               lkkOOOOOOOOkxxxxxxxxxxxxdddo:;,.............   ...........'''...'':ooooooooddoo:               
               lkO0OOOOOOOkxxxxxxxxxxxxdddo:;,.........................',;;,'..',;oooooooooooo:               
               oOO0OOOOOOkxxxxkkkkxxxxxxxdl;''''''''''..........'',,;::clll:,'',;codooooooddddc               
               oO00000OOOkxxxxkkxxxxxxxxxdl,..'',,,,,,,,,,,,',,;::cclloooolc:,,;:loddxxxxxddddc               
               oO0O00OOOkxxxxxkxxxxxxxxdddl,''',,;;;,,,,,;;;;;::::cclloooool:;,;:ldddddxxxddddc               
               d000KK000kxxxxxxxxxxxxkxdddo,''',;;;;,,,,,;;;;;::::::clllloolc;,;lddddddxxxxdddc               
               d0000000OkxxxxxxxxxxkkOkxxdo:,',,;;;;,,,,,;;;;:::::::ccllllllc;,:oxxddddddxxdddc               
               dK0KKKKK0kxxxxxxxxkkOkkOkxddl,',;;;;,,,,,,;;::::;::ccclllllllc;,cdxxxdooodddddxc               
               dK0KK0K0OkkkkxxxxkkOOOkkkdoc:;,;;;,,,,,,,,,;;::;;;::ccllllllol::oxkxkkddddddxxxl               
               d0000000OkkkkkkkkOOOkkkkkxc,,;;;;,,,'''..'',,;;;;;;;;:::ccloooc:lcxxxxdddddxxxxl               
               d000OO0OkkkkkOOO00OOOOOkkkd;,;::;;,,,,,,,'''',;;;,''',,;;::codlllcdxxxdddddxxxxl               
               d0K0000OkkkkOOOOOOkOOkkkkkxc,,cl:;;,,,''''''',;clc;,',;:ccclodl:ldxxxkxxkkkxxxxl               
               d000000kkkkkOOOOOOkOOOkkkkko;':l:;;;,,,''',,,,;clol:;,;;clloodl:ldddxxxxxkkxxxxl               
               dKK0KK0kkkkO00000OO0OOOOOOOkl,,c:;;,,,,,,,,,,,:looolccccllooddooxxxxkkkkkkkxxxxl               
               xXKKKK0kkkkO000000000O00O00Odc;cc;;,,,,,,,,,,,:lollccccclllooooxkkkkOkxxOOkxxxkl               
               xKKKKKOkkkk00OO0OO00OO00O00Oxxddl:;,,,,,,,,,,,:lolc::ccclllodxkkkOOOOOOO00kxxxkl               
               xKKKKKOkkkk000000000O000O00kxxxdo:;;,,,,,,''',;cccc:::ccllooxkkkkkkOOOkOOOkxxxxl               
               xK000OkkkkkOOO00OO000000000kxxxxdc;;,,,,,,,,'',:cclc::ccllodkkkkOOOO00OO0Okxxxxl               
               xKKKKOkkxkO0O00OOOOOO0OOOOOxxxxxko;;;,,,,,,,,;;:cllc::ccllodoxkkOOO00OOO00kxxxxl               
               xKKK0kkkxk00000000000000000xxxxxkkl;;,,''''',,,;:ccc;;:clloo;;coxkkkOkkkOkxxxxxl               
               xKKKOkkkkO0O000O0000000000OxxxxkkOdc;,,,,,,''',;:ccc:;:cllodl''':okOOOOOOOxxxxxl               
               dKKKOkxxkO000KK00KK0KK0000kxxxxkkkoc:;,,,,,,,,,;:cccccclloodd'...':ldxkkOkxdddxl               
               d00Okxxxk0000K00KK00K00000kxxxxkxl:c;,,,,,,,,;:cccccclllloodd'........,:cclooddc               
               dK0OxxxxOKKKKK00KK0KK0000Okxxxxo:;l:;,,,,,,,,,;:ccccclllllldd,..............',;,               
               dK0kxxxk0KKKKKKKKKKKK00K0Oxxdl:;,cl;;,,''',,'',;;::cccllccdxd'..................               
               d0OkxxkkO000000000000OOkdlc:;;,,;oc',,,'''''''',,;;:ccc:cdxxd'..................               
               d0kxxxkO000000000OOkxl:,,,,',,,'co;',,,,,;:,'',,,;;::;;cdxxxd'.................                
               dOxxxxxO00000OOkdl:;,''.....''''ll,'''',,::;''''',,,,:lddxxxo..................                
               dOxxxxk00O00ko:;,,''............lc;,,,''';;;'''''',;coddxxxd:..................                
               dkxxxxk00xoc;,,'................cc,'',',,::;,,''',;loddxxxxo............ .   ..                
               dkkxxxdlc;,,''..................'c,''''',:::,,',;:loodxxxxd;.............  ....                
               okkxd:;,''.......................:,'''',,;::,,;:clooddxxxxc..............  ....                
               oxxxc''..........................:,''''',;::,;ccloodddxxxd,...........  .  ....                
               lxxxkkkkkkOOkxxxxOOkOOOOOOkOkxl:;:::,.............  .........'''.,cdxdxxxxxxdoo:               
               lxxxkkkOkOOOxxxxkOOkOkkkkkkkxl;'';;,.......  ..... ..........',;,,:ldddxdxxxdoo:               
               lxxkOkkOkOOkxxxxkkkkkkkkkkxxc;'..'.........................',;;;;;;;cddddxxxdoo:               
               lkkOOkOOOOOkxxxxxxxxxxxxddddl:,'............................'''',;::coooooooooo:               
               lkOOOOOOOOOxxxxxxxxxxxxxddddoc;'.....................'.........',;,;loooooooooo:               
               oOOOOOOkOOkxxxxxkkkxxxxxxxxdo:,'...............................''',;looooooodddc               
               oO00000OOOkxxxxkkxxxxxxxxxxdl:,...............................'''',;cdddxxxddddc               
               oOOO00OOOkxxxxxkxxxxxxxxddddl:'........''................'',,::,'',:ldddxxdddddc               
               d000KK000kxxxxxxxxxxxxkxdddoc,.....',,,,,,,,,,,'''''',;;:clllllc;,:loddddxxddddc               
               d0000000OkxxxxxxxxxxkkOkxddoc,....',,,,,,,,,;;;;;;;::ccllooooolc:;:odddooddddddc               
               dK0KKKKK0kxxxxxxxxkkkkkkkxdoc;....,,;;,,,,,,;;:::::::ccccllloool;;coddoooodddddc               
               d00KK0K0OkkxxxxxxxkOOOkkkddoc,'..',;;;,,,,,,;;::::::ccccccllllll:;ldxxdooddddxxc               
               d0000000kkkkkkkkkkOOkkkkkxoc:,''',,;;,,,,,,,,;;:::::ccccccllllll:coxxxdddddxxxxl               
               d000OOOOkkkkkOOOOOOOOOkkkd:,,,'',;;,,,,,,,,,,;;::::::cccclllllll:oxxxxdddddxxxxl               
               d000000OkkkkOOOOOOkOkkkkkd:;,,'',;,,,'''''''',,;;::::::cccllloolcoxxxkxxkkkxxxxl               
               d000000kkkkkOOOOOOkkkkkkkko;,,,,;;;,,,''''''...'',;;;;;;;;;:clolcoddxxxxxkkxxxxl               
               dKK0KK0kkkkkO0000OOOOOOOOkx;;;;,;;;,,,,'''''''''',;;,''',,;;:coodxxxkkkxkkkxxxxl               
               xXKKKK0kkkkO00000O000O00OOOl;;,;;;;,,,,,'''''''',;cll:,,,;ccloddkkkkkkxxkOkxxxkl               
               xKKKKKOkkkkO0OOOOOOOOO00OOOxl;,,,,,,,,,,,,,,,,'',;llolcccclloddxkkkOOOOOO0Oxxxkl               
               xKKKKKOkkxk000000000O000O0Okxooc;;,,,,,,,,,,,,,,,:llllllllllodxkkkkOOOkOOOkxxxxl               
               xK000OkkkkkOOO00OO00000000Okxxdoc;,,,,,,,,,,,,,,,:lllccccclloxkkOOOO00OO00kxxxxl               
               xKKKKOkkxkO0OOOOOOOOOOOOOOOxxxddl;;,,,,,,,,,'',,,;lll::ccclldkkOOOOO0OO000kxxxxl               
               xKKK0kkkxk000000O0000000000xxxxdo:;,,,,,,,,,,'''';ccc:::ccloxkkkkkkOOOkOOOxxxxxl               
               xKKKOkkxxOOOO00OO00O00OO00Oxxxxxoc;,,,,''',,,,,,,:lllc::cloxkOOOOOO00OO000xxxxxl               
               dKKKOkxxkO000KK00K00KK0000kxxxxxxc;,,,,,''''',,;;;ccc::::lodkkOOkkkOOOOOOOxxxxxl               
               d00Okxxxk0000K000K00K00000kxxxxkxc;;,,,,,,,'''',;;:cc;;:coo;coxkOkkOOkkOOkxxxxxl               
               d00OxxxxOKK0KK00K00000000Oxxxxxxlc;,,,,,,,,,,',,;:cccccclod:',:okxkkkkkOOkxxxxxl               
               d0Okxxxk000KKK0KKK0KK00K0Oxxxxo:l:,,',,,,,,,,;;::ccccclloodo'..':ldxxxkkkxdddxxl               
               dOkxxxxkO00000O00OOOOOOOOkxxoc,cc;,,''',,,,',;;:cccccclllldd'......,;codxxddddxl               
               d0kxxxxk00000000OOO0OOOOxol:;,,ll;;'',,,,,;;'',,;:::cccccldd'..........'';:clodc               
               dOxxxxxOO00000O00OOOxoc;,,,,,':oc,,'',,,,;::,',,;;::cc::ldxd'................','               
               dOxxxxkO0O000O0Okoc;,'.....'''llc,;,,,''';:,,,,,;;:::;;cdxxd'...................               
               dkxxxxk00O00kdl;,''..........'llc,,,',,,,;:;;''',;;,,;codxxd'..................                
               dkxxxkO0Oxoc:,''..............llc:;''''',;:c;'''',,,:lodxxxo...................                
               okxxxxxo:;,''.................cllc:''''',;::;,''',;cloddxxd;...................                
               oxxdoc;,,''...................:llc:''''',,::,,'',;cloddxxxo'.........   .......                
               lxxxkkkkkkOOkxxxxOOkOOOOOOOOOkOOkdddol;,;;,'''..........,:ccodddxxxxddxxxkkkxdd:               
               lxxxkkkOkOOOxxxxkOOOOOkkOkkOkkkkxdolcc:;:;'..............,::cloodddddddxxxkxddo:               
               lxxkOkkOkOOkxxxxkkkkkkkkkkkkkxxdolcc:;,,,,,...............'',;::ccldddddxxxxdoo:               
               lkkOOkOOOOOkxxxxxxxxxxxxxdddddollc;'.'',,,,'.................',,;;;coooooooddoo:               
               lkOOOOOOOOOxxxxxxxxxxxxxxxdddolc;'....,,''......................',;cooooooooooo:               
               oOOOOOOOOOkxxxxxkkkkxxxxxxxxo:;'..............................''';::looooooodddc               
               oO00000OOOkxxxxkkxxxxxxxxxkko;............................'''','',;;cdddxxxddddc               
               oO0O00OOOkxxxxxkkxxxxxxxxxxxoc'.........................'''''.....',:oodxxdddddc               
               d000KK000kxxxxxxxxxxxxkxddddo:,...........................''.......,cooddxxddddc               
               d0000000OkxxxxxxxxxxkkOkxddol:,'..................................';looooddddddc               
               dK0KKKKK0kxxxxxxxxkkOkkOkxdolc,.................................',;:odoooodddddc               
               dK00K0K0OkkkxxxxxxkkOOOkkdocc;'........'''''''''............',;:cc:ldddooddddxxc               
               d0000000kkkkkkkkkOOOkkkkkdl::;'......'',,,,,,,,,,;;,,,,'',;:clooolcodxdodddxxxxl               
               d000OO0OkkkkkOOOO0OOOOkkkxl:;'......'',,,,,,,,,,;;:::::::clloooodlldxxdddddxxxxl               
               d0K0000OkkkkOOOOOOkOkkkkkxl:,.......'',,,,,,,,,,,;::ccccclllllloolldxxxxkkkxxxxl               
               d000000kkkkkOOOOOOkkkkkkkkd:,'.....',,,,,,,,,,,,;;::ccccccllllllooodxxxxxkkxxxxl               
               dKK0KK0kkkkkO0O00OOOOOOOkl,,,,'...',,,,,,,,,,,,,;;;:ccccclllllllodxxkkkkkkkxxxxl               
               xXK0KK0kkkkO00000O000O00Ol;;;,''''',;,,,,,,,,,,,,,;::ccccclllllodkkkOkxxkOOxxkkl               
               xKKKKKOkkkkO0OOOOOOOOO00Ok:;,,,,,',;;,,,,,'''''''',,;::cc:cccccldkkOOOOOO0Oxxkkl               
               xKKKKKkkkxk000000000O000O0o,,,,;,,,;,,,,,,,,'''''..'',;:;;,,;;:cdkkOOOkOO0Oxxxkl               
               xK000OkkkkkOOO00OO00000000x:;,;;;;,;,,,,,,,,''''''''',:c:,,;;cldkOOO00OO00kxxxkl               
               xKKKKOkkxkO0OOOOOOOOOOOOOOOd:,;,;;,,,,,,,,;;;;;;,,',,,:lol:::loxkOO000O000kxxxkl               
               xKKK0kkkxkO000000000000000Oxdoc;;;,,,,,,,,;;::c:;,,',,:llllllooxkkkOOOkOOOxxxxxl               
               xKKKOkkxxkOOO00OO00O00OO00kxxxo:;;,,,,,,,,,;;::;,'''',:llllllodkOOO00OO000kxxxxl               
               xKKKOkxxkO000KK00KK0KK0000kxxxdl;;,,,,,,,,,,;;;,'''',;:llccclokkkkOOOOOOOOxxxxxl               
               d00Okxxxk0000K000K00K000K0kxxxxo;,,,,,,,,,,,,,,'''''',:cc:ccoxkOOkOOOkkOOkxxxxxl               
               d00OxxxxO0K0KK00KK0000000Okxxxkd:;,,,,,,,,,,,,,,,,''';:clcccdkkkOkOOOOOOOkxxxxxl               
               d0Okxxxk0000KK0KKK0KK00K0Oxxxxkx:;,,,,,,,,,,''',,,;;:cllcccoxkkkkkkkkkkkkxxxxxxl               
               dOOxxxxkO00000000OOOOOOOOkxxxxdo:;,,'',,,,,,,''''',;::ccc:cloxxxxxkkkkkkOxxxxxxl               
               d0kxxxxO000000000000OO00Oxxxxlc:::'',,,,,;;,,,,',,,:ccccloc'';lxxxxkkxkkkxxxxxxl               
               dOxxxxxO0000000000000O00kxxdc;l;;;''',,,;c:,,,,,;;;:ccllldc....,cldxxxxxxddddxxl               
               dOxxxxk00O0000000000OOOkdoc;,;l;';,,,''',c,;,,,,;:cccclcoxc.......';cldxxddddxxl               
               dkxxxxk00O00000000OOxoc;,,,,'ll;';'',,,,,::;,''',,;ccc:ldxc...........',:coddxxl               
               dkxxxkO0OO0OOOOOxoc;'''''''',ol;';''''',;c:;,'',,;:::;cdxx:...............',:coc               
               okkkkk00000Oxoc;,'.........';ol;,:''''',;::;''',,;;;;lddxx:.....................               
               okkkkk0K0Od:;,'............';ol:;:''''',,::;,''',,,;coddxx:.....................               
               lxxxkkkOOOOOkxxxkOOOO0OO0OOOOOOOkddxxkkkkxkdddddddddddddddddxxxxxxxxxxxkkkkkxdd:               
               lxxxkkkOOO0OkxxxkOOOOOOOOOkOOkkkxddddxkxxddolc:;,,,;;;::cldddddxddxxddxxxxkxxdd:               
               lxxkOkOOOOOkxxxxkOOkOOkkkkkkkkkkxddddxxdoc;,'...........'';lodddddddddxxxxkxdoo:               
               lkkOOOOOOOOkxxxxxxxxxxxxxxxxxdddddddoll:,,,,'''''..........,:llooodooooooodddoo:               
               lkO0OOOOOOOkxxxxxxxxxxxxxxxxxxdddool:,;::;,,'...............';:cllooooooooooooo:               
               oOO0OOOOOOkxxxxkkkkkxxxxxxkkxxxdol:::::;'....................''';::llooooooddddc               
               oO00000O0Okxxxxkkxxxxxxxxkkkkkxooc::;'..........................'',;:codxxxddddc               
               o00O00OOOkxxxxxkkxxxxxxxxxxkkdlcc:,............................'''',;:ldxxdddddc               
               d000KK000kkxxxxxxxxxxxkxxxxxdl,,,...............................',,,;:cldxxddddc               
               d0000000OkkxxxxxxxxxkkOkxxddol:'............................'''''','',;coddddddc               
               dK0KKKKK0kkkxxxxxxkkOkkOkxdolcc,............................'''''.....':dooddddc               
               dK0KK0K0OkkkkxxxxxkOOOOkkddolc:'...............................''.....,cdodddxxc               
               d0000000kkkkkkkkkOOOkkkkkdoll;'.....................................',coddddxxxl               
               d000OO0OkkkkkOOOO0OOOOOOkxolc;,..................................',;:ldxdddxxxxl               
               d0K0000OkkkkOOOOOOkOOkkkkdc:,'.............'''''''''''''.....'',;clodxxxkkkxxxxl               
               d000000kkkkkOOOOOOkkOkkkko:;'............'',,,,,,,,;;:::;;,,;:cllodddxxxxkkxxxxl               
               dKK0KK0kkkkkO0O00OOOOOOOkd:'.............',,,,,,,,,;::ccccccclllooddxkkkkkkxxxxl               
               xXKKKK0kkkkO00000O000O00Okc,'...........'',,,,,,,,,;::cccccclllllloxkkxxkOkxxxkl               
               xKKKKKOkkkkO0OOOOOOOOO0OOOxc:,'.......'',,,,,,,,,,,;;:ccclllllllllokOOOOO0kxxxkl               
               xKKKKKOkkkk000000000O000O0o,,,,,'....',,,,,,,,,,,;;;;::ccclllllllodkOOkOO0kxxxkl               
               xK000OkkkkkOOO00OO00000000o;;,,,,''''',,,,,,'',,,,;;;;;:ccccclllloxO00OO00kxxxkl               
               xKKKKOkkxkO00OOOOOOOO0OOOOx:;,,,,;,,,,,,,,,,''''''''',,;;:c::::ccldO0OO000kxxxkl               
               xKKK0kkkxk0000000000000000kc;;,,,;;,,;,,,,,,,,''''''''''';::,,,;cdkOOOkOOOxxxxxl               
               xKKKOkkxxOOOO00OO00O00OO00Odc;;;;;;;;;,,,,,,,;,,,,,,,,,,,:ll:;:cdkO00OO000kxxxxl               
               xKKKOkxxkO000KK00KK0KK0000kxdl;;,,,,,,,,,,,,,;:::cc::;,,,:lolllodkkOOOOOOOxxxxxl               
               d000kxxxk0000K000K00K000K0kxxxd:;;,,,,,,,,,,,;;:cccc:;,,,:llllooxkOOOkOOOkxxxxxl               
               d00OxxxxOKK0KK00KK0KK0000Okxxxdc;;,,,,,,,,,,,,;::cc:;,,,,:llllodkkOOOOOOOkxxxxkl               
               d0Okxxxk000KKK0KKKKKK00KKOkxxxxl;;,,,,,,,,,,,,;;:::,''',,:lllloxkkkkkkkOOkxxxxkl               
               dOOxxxkkO000000000000OOOOkxxxxxo:;,,,,,,,,,,,,,;;;,,''''';clcodxkkkkkkkOOxxxxxkl               
               d0kxxxkO0000000000000O00Oxxxxxkd:;,,,,,;;:,,,,,,,,,,,,,,;ccccoxxxxxkkxkkkxxxxxkl               
               dOxxxxxO0000000000000000kxxxxxxoc;'',,,;::,,,,,'''',,;::ccccoxkkxxxxxxxxxdddxxkl               
               dOxxxxk00O0000000000OO00kxxxdlccc;,,,'',:,,,,,,,,,''',;::c:;:lxxxxxxxxxxxdoddxxl               
               dkxxxxk00O00000000000000kxxo:c:::,,',,,,:;;,,,,,,,,,;;:cld:..';odxxxxxkkxddddxxl               
               dkxkkkO0OO0OOO00OO00OO0kxdc;;o:,:,'''',;c::,,,,,,;;::cclox:....'';coxxxkxdodddxl               
               okkkkk0K0000O000O000Oxoc:;,,co:':,''',,,:::,,,,,,,;:cclldx;.........,;clooodddxl               
               okkkkk0K00K0OO00OOkdc;,',,,,ll:':,'',,,,c::,,,,,,,,;:cloxx;.............';loddxl               
               lxxxkkkOOOOOkxxxkOOOO0OO0OOOOOOOkddxxkkkkkkxxxxxxxxxkxxddddxxxxxxxxxxxxkkkkkxdd:               
               lxxkkkkOOOOOkxxxkOOOOOOOOOOOOkkkxddddxkxxxxdxxxxxddxxxddddddxxxxxdxxddxxxxkxxdd:               
               lxxkOkOOOOOkxxxxkOOOOOOOOOkkkkkkxddddxxxdxdddddlc::;;:;::cloddddddddddxxxxkxdoo:               
               lkkOOOOOOOOkxxxxxxxxxxxxxxxxxxxddddddoddooool:;,'........'',:coooooooooooodddoo:               
               lkO0OOOOOOOkxxxxxxxxxxxxxxxxxxxdddddoooolcc;'................'';coooooooooooooo:               
               oOO0OOOOOOkxxxxkkkkkxxxxxkkkxxxdddddooc;'..'',''................';clooddoooddddc               
               oO00000O0Okxxxxkkxxxxxxxxkkkkkxdddool;'...,,'.....................':cldxxxxddddc               
               o00O00OOOkkxxxxkkxxxxxxxxxxkkkxddool:,,,,'.........................;:;:ldddddddc               
               d000KK000kkxxxxxxxxxxkkkxxxxkkxoll:,,;;,...........................';;;;:ldddddc               
               d0000000OkkxxxxxxxxxkkOOkxxxxddl:'.';'..............................,;:ccllodddc               
               dK0KKKKK0kkkkxxxxxkkOkkOOxxdddol:,................................''',,;c:cldddc               
               dK0KK0K0OkkkkkxxxkkOOOOkkddddlc;;;.................................'''',,;,:dxxc               
               d00K0000OkkkkkkkkOOOkkkkkxxdoc:;;'..............................'...'',,;,,cdxxc               
               d000OO0OkkkkkOOOO0OOOOOOkkxolc:,'......................................''';odxxc               
               d0K0000OkkkkOOOOOOkOOkkkkkdc:;,........................................';codxxxl               
               d000000kkkkkOOOOOOkkkkkkkko;,'....................''''''..............,codxxxxxl               
               dKK0KK0kkkkkO0O00OOOOOOOkkl,'..................''',,,,;;;;;;;;,'''',;codxxkxxxxl               
               xXKKKK0kkkkO00000O000O00OOo,'.................'',,,,;;;;::cllllc::cloodxkOkxxxkl               
               xKKKKKOkkkkO0OOOOOOOOO00OOk;'................''',,,,;;;;;:ccllllclllloxkOOkxxxkl               
               xKKKKKOkkkk000000000O000O0Ol;;,,''..........'',,,,,,,,,;;::cclllllllldxOOOkxxxkl               
               xK000OkkkkkOOO00OO00000000Oo:,,,,,'.......',,,,,,,,,;;;;:::ccllllllloxOOOOkxxxkl               
               xKKKKOkkxkO00OOOOOOOO0OOOOkd:;,,,''''....',,,,,,,,,,;;:::::ccclllllodkOO00kxxxkl               
               xKKK0kkkxk0000000000000000Oxl;,,,',,,,''',,,,,,,'''',,,,;;;;:ccccllldkkOOOxxxxxl               
               xKKKOkkxxOOOO00OO00O00OO00Oxd:,,,,,,;;,,,,,,,,,,,'''',,''''',;::;;:lxOO000kxxxxl               
               xKKKOkxxkO000KK00KK0KK0000Oxxo:;;,,,,;;,,,,,,,,;;;;,,,,,,,,,,:c;;cdOOOOOOOxxxxxl               
               d000kxxxk0000K000K00K000K0kxxxo:;;,,,,,,,,,,,,,;;::ccccccc:;;cllldkOOkOOOOxxxxxl               
               d00OxxxxOKK0KK00KK0KK0000Okxxxo:;;;,,,,,,,,,,,,,;::cllllcc:;:clooxOOOOOO0Oxxxxkl               
               d0Okxxxk000KKKKKKKKKK00KKOkxxxd:;;;;,,,,,,,,,,,,;;:cclll:;;;;clooxkkkkkOOkxxxxkl               
               dOOxxxkkO000000000000OOOOkxxxxo:;;;;,,,,,,,,,,,,,;::ccc:,,,;:clodkkOkkkOOkxxxxkl               
               d0kxxxkO0000000000000O00Oxxxxdl:;:;',,,,,;:;,,,,,;;::c;,''',;:loxxxkkkkkkxxxxxkl               
               dOxxxxxO0000000000000000kxxxdoc;;;,'',,,,:c;,,,,,;;;;,,,,'',;:cdxxxxxxxxxdddxxkl               
               dOxxxxk00O0000000000OO00kxdolc:;;;;,,,,'';;,,,,,;;,''',,,;:clodxxxxxxxxxxddddxxl               
               dkxxxxk00O00000000000000xl:occ;;;;,,',,,,;:;,,,,,;,,,'''';:clxkkxxxxxxkkxddddxxl               
               dkxkkkO0OO0OOO00OO00OOOd:,:o:;;;;:;'''',,:::,,,,,;;;;;;;:cc;:odxxxkxxkkkxdddddxl               
               okkkkk0K0000O000O00kdo:,,'cl;';;;:;'''',,:::,,,,,,;;;::cc:'....':ldxkkkkxdddddxl               
               okkkkk0K00K0OO00Oxo:,'''''ll;',;;:;'',,,,;::,,,,,,;;:ccll'........':oxkkxdddddxl               
               lxxxkkkOOOOOkxxxkOOOO0OO0OOOOOOOkddxxkkkkkkxxxxxxkxkkxdooodxxxxxxxxxxxkkkkkkxdd:               
               lxxxkkkOOOOOkxxxkOOOOOOOOOOOOkkkxddddxkkxxxddxxxxxxxkxdoooddxxxxxdxxxxxxxxkxxdd:               
               lxxkOkOOOOOkxxxxkOOOOOOOOOkkkkkkxddddxxxddddxxdddocccccccloddddddddxddxxxxkxdoo:               
               lkkOOOOOOOOkxxxxxxxxxxxxxxxxxxxdddddddooooooollc;,'''...'',;:loooooooooooodddoo:               
               lkO0OOOOOOOkxxxxxxxxxxxxxxxxxxxddddddooooolc:;,.............',;:clooooooooooooo:               
               oOO0OOOOOOkxxxxkkkkkxxxxxkkkxxxdddddddolc;'................'''''',:cloooooooooo:               
               oO00000OOOkxxxxkkxxxxxxxxkkkkkxddddddoc;..........................';:codxxxddodc               
               oO0O00OOOkxxxxxkkxxxxxxxxxxkkkxddooooc,..''........................',;cldxdddddc               
               d000KK000kkxxxxxxxxxxkkkxxxxkkxooooc;'..,,..........................'.;::ldddddc               
               d0000000OkkxxxxxxxxxkkOOkxxxxddolc,....,'...........................''';cllddddc               
               dK0KKKKK0kkkxxxxxxkkOkkOOxxddddooc,..................................'',ccoooddc               
               dK0KK0K0OkkkkkxxxkkOOOOkkddddooc;'...............................''...,,,;:::lxc               
               d0000000OkkkkkkkkOOOkOkkkxxdol:,'................................'''...'',;;;lxc               
               d000OO0OkkkkkOOOO0OOOOOOkkxolc;'.................................''.....',;:coxc               
               d0K0000OkkkkOOOOOOOOOkkkkkdl:,'...........................................,codxl               
               d000000kkkkkOOOOOOkkkkkkkko:'........................''..................,cdxxxl               
               dKK0KK0kkkkkO0O00OOOOOOOOkl,......................''',,,,;;;;;,,,'....';coxxxxxl               
               xXKKKK0kkkkO00000O000O00OOd,....................'',,,,;::::cclllcc;;;:lxkOkxxxxl               
               xKKKKKOkkkkO0OOOOOOOOO00OOd;'..................''',,,,;;::::cclllllcllokOOkxxxxl               
               xKKKKKOkkkk0000000000000O0x:'.'''''...........''',,,,,,;::::ccllllllllokOOkxxxkl               
               xK000OkkkkkOOO00OO00000000kc,,,,,,''........'',,,,,,,,;;::::ccllllllllxOOOkxxxkl               
               xKKKKOkkkkO0OOOOOOOOO0OOOOkl;,,,,,''''.....'',,,,,,,,;;:::::cccllllllokO00kxxxxl               
               xKKK0kkkxk0000000000000000Oo;,,,,,,',,,''''',,,,,,,,,,;;;::::cccllllodkOOOxxxxxl               
               xKKKOkkxxOOOO00O000O00OO00Odc,,,,,,,,,,,,,,,,,,,,,,'''',,,,',,;:ccclokO000kxxxxl               
               xKKKOkxxkO000KK00KK0KK0000kxo:;;,,,,,,,,,,,,,,,,;;;;;,',,;,,,,,:::cxOOOOOOxxxxxl               
               d00Okxxxk0000K000K00K00000kxdl:;,,,,,,,,,,,,,,,,;;::cc::ccccc:cllokOOOOOOkxxxxxl               
               d00OxxxxOKK0KK00KK0KK0000Okxdo:;;,;,,,,,,,,,,,,,,;;:cclllllccccloxOOOOOO0kxxxxkl               
               d0Okxxxk000KKK0KKKKKK00K0Okxdo:;;;;;,,,,,,,,,,,,,,;::cllllcc::cloxkkkkkOOkxxxxkl               
               d0OkxxkkO000000000000OOOOkdlol:;;;;;,,,,,,,,,,,,,,;::ccll:::::cldxkOkkOOOkxxxxkl               
               d0kxxxxO0000000000000OOOkl:cl:;;;;;'',,,,,;:,,,,,,;;:ccc:,,,;:cloxxkkkkkkxxxxxkl               
               dOxxxxxO0000000000000OOx::llc;;;;;;'',,,,;c:,,,,,,;;;:::;,''',;:oxxxxxxxxdddxxkl               
               dOxxxxk00O00000K00000kl,:occ:;;,,;;,,,''',:,,,,,,;;;;;;;;;;;:dxxxxxxxxxxxddddxxl               
               dkxxxxk00O000000000ko:,.cl::;;,,,,;,',,,,,:;;,,,,;:;,,'',,;coxkxxxxxxxkkxddddxxl               
               dkxxxkO0OO0OOO0Oxdo:,,''lc,,;;;,,;:''''',;::;,,,,;;::;;;;;cxkOkkkkkkkkkkxdddddxl               
               okkkkk00000kdlc;''''''.,lc,,,;,,,;;'''',,,::;,,,,,;:::::::;:ldxkkkOOkkkkxdddddxl               
               oxkkkk0KOxc;,'.........,lc,',,,,,;;''',,,,::;,,,,,,;:cccc,...';oxkOOkkkkxdddddxl               
               cdddddddddddddddddddddddooooooddddxxxxddxxxxxxxxxxxxxxxxxxxxddddddddodddxxxxxxxc               
               cdddddddddddddddddddxxxxoooooodxxxxddddddddddxddxxxddddddxxxdddddddoodddxxxxxxxc               
               cdddddddddddxxddddddddddoooooodddoooooodddddddddddxxddddddddxxdddoooodddddddxxxc               
               cdddddddddxkkxdkkxxxxxxdddooooooooooooddxxxddddddddddddddddddddoooooddddddddxxxc               
               cdddddxxkkkkxddkkkkkkkkkxddoodxxxdooodxxxxxxdodddddddoddddddddddxxdddddddddddxxc               
               cdddxxxxkkkxxxkOkkkkkkxxdddoddddddoodxxxxxxxxddoddxddoooodxxxxxxxxdddddddddddddc               
               cxxkkkkxxxxxxkOOkkkxxdddxddddxoooddooodxxxxxdoooooooodoooooddxxxxxxdooddxddddddc               
               ckOOOOOkxxxxkOOkxxxxddxkkxdddddxxkkdooolooodoodxxxdoodoooddooodddxxxdooddoodddo:               
               lkkOOOOkkxxxkkxxxxkOkxxkkxdddxkkkkd:;,,.''',,:dkkkxxdooooxxooodoodxxxddddodxxxdc               
               lOOOOOOOkxxxxxxxxkOOkxxxxddddxkkxc,...........;xxxxxxooooxdodxxdooodxxdddxxxkxxl               
               lOOOO000kxxkxxkkxxxkxxkkxddddkOkkc'...',;,'....oxxkkxooooooddxxxdoooodddxkkkkxxl               
               lOOO0000kkkOOxxxxkkxxkOOkdddddxkkxc;;::clc;'..'cxkkxdoooodxxddddodxxddddxkkkkkxl               
               lOOOOOkkxxkOOOxxkOOOxkOOkdddxddxxxl:;;:cllc,''':xxxdodooodkkxddxdddddkxdxkkkkkxl               
               lkOOkkxxxxxxxxxxxkOOxkOOkdddxdddddc;;;,;:cl:;;:cdoooodooodxkxdxxxdddxkxddddxkkxl               
               lxxxkOOkkkOOkxkkxxkOkxkkxddddxkkkxl;:c;;:ccccccodxxdooooodxxdxxxxoooodoooooddxxl               
               lxxxOOOOOOOOxxkkxxxkxdddddddxkkxdol:cc;;::;::cooodxxxdooodxxdxxxoddodxxxdddddddc               
               cxxxOOOOOOOkxxkxxddddxxdddddxkxdodd:;;;;::;;:lddoodxxxdoooodddxdoxkddxxkxxkxxdo:               
               cxxkOOkkOOkkxxxxddddxkkxdoooodooodxo:,;;;:;;:oxxxdodddooooxxxdooodddddxkxxkkkdo:               
               cxxkkkxxxxxxxkkxdddddxkxooooooodxxddl;;;;::cllcoxddoooooddxxxdooodddoddxkxxkxxd:               
               cdxxxxxxxdxkOkkxdxxdodxxoooodol:;,,cl;,,,;colc;.,codddddddxxdoododkkxddddodxxxd:               
               cdxxkkkkkxxkkkkddxxdooxxoll:;'.....co:,,,;:ooo;....,coddddxxdodxddxkkkxdddddooo:               
               cxkkOkkkkddxkkkddxxdoodxl'.........llo:,,,:lol........,:odddoodxxodkkkkddxxxxdo:               
               cdxkOOkkxdddxkxdxxoodddd,..........;;::;:coc:'...........,cdddodxddxkxdodxxxkxxc               
               cxxxkkxxxkkxdddooodddddl............','',:c:...............cddooddodxddoodxxxxdc               
               lkkxxdxxkkkkxdoodxxxxddl............',,,,,,;...............;ddddooooodxxdoddddoc               
               lxxxxdxxxxxxxdodxxxxxxd,............',,;,'',...............,dxxxdddoddxxxddooddl               
               lkkkxdxkkkkkxooodxxxxd:..............,''''',.....  ........'dddxdddddddddddddddc               
               lkkxddxkkkkkxdooodxxdd'.............','',,',.....  ........'odddddddxxxxxxddddxl               
               cxkxddxkkkkkxoodddddd:....... ......',''',,,.....  ..   ....lddddddddxxxxxxdddxl               
               cxxdddxxxxxxdoodddddo'... ...........'''''''....  ...   ....cddddddddddxxxxdddxl               
               cddooodddddddoodddddc.......':::;;....''''''...   ..    ....:ddddddddddxxxxdddxl               
               cddooddxxxdddooddddd;.....',:;;::,..''..',''. .   ..    ....,oddddddddddxxxxddxc               
               :ddoodddxxxxdooddddo....',,,;;;:;...'''.''''. .   ..    ....'oodddddddddxxxxdxxc               
               cddoodxxxxxxdodddddc.......',,;,.....''''..'   . ...     ....lodddddddddxxxxdxxc               
               cddoodddxxxxddddddxo'...........  ..''.'''''     ...     ....:odddddddddxxxxdxxc               
               coooooddddddddddddxxd,.......    ...''''''.'     ...     ....:odddddddddxxxxdxxc               
               cdddddddddddddooodddddddooooooddddddddddddxxxxxxxxxxxxxxxxxxddddddddodddxxxxxxxc               
               cddddddddddddoodddddxxxxoooooodxxddddddddddddddddddddddddddxddddddooodddxxxxxxxc               
               cdddddddddddxxddddoooddooooooodddoooooodddddddddddxddddddddddddddoooodddddddxxxc               
               cdddddddddxkkxdxkxxxxxxdooooooooooooooddxxddoodddoddddddddddddooooooddddddddxxxc               
               cdddddxxkkkkxddxkkkkkkkkxdoooodxddooodxxxxxxdooddddddoddodddddddxxddddddddddddxc               
               cdddxxxxkkkxdxkkkkkkkkxxdddoooddddoodxxxxxxxxddoddxdooooodxxxxxxxxdddddddddddddc               
               cdxxkkxxdxxdxkkkkkxxxdddxdddddoooddooooooodddoooooooodooooodddxxxxxdooodxddddddc               
               ckkkOOOxxddxkOOkxxxxdddkkxdddddxxdlc;''''',,;oxxxddoodoooddooodddxxxdooddoodddo:               
               lkkkOOOkkxdxkkxxdxkkkxdkkxdddxkdl,...........;xxkxxddooooxxooodoodxxxdddoodxxddc               
               lkOOOOOOkxxxxxxxxkOOkxxxxddddxko,....',,,'...'dxxxxxxooooddodxxdooodxxdddxxxxxxc               
               lOOOO00Okxxkxxkkxxxkxxxkdddddkkko;',;:ccc,'...lkkkkkxoooooooddxxdoooodddxkxkkxxl               
               lOOOO000kxkOOxxxxkkxxkOOkdddddxkxl:;;:ccl:,'''ckkkkxdoooodxxddddodxxdddddkkkkkxl               
               lOOOOOkkxxkOOOxxkOOOxkOOkdddxddddc;;;;;:clc;;:ldxxxoodooodxkxddxdddddkxdxkkkkkxl               
               lkOOkkxxxxxxxxxxxkOOxkOOxdddxddddl;;:;,:clccccooooooodooodxkxdxxxdodxkxddddxxxxl               
               cxxxkkOkkkOOkxkkdxkkkxkkxdddddxkxdc:c:;:cccccododxxdooooodxxdxxxdooooooooooodxxl               
               lxxxOOOOOOOOxxkkxdxkxdddddooxkkxdoc;;:;:::;;:ldoodxxxdooodxddxxxoddodxxxdddddddc               
               cxxxkOOkOOOkxxkxdddddxxddooodxxdoddc;;;;::;;:ldddooxxxooooodddxdoxxdddxxxxxxxdo:               
               cxxkOOkkOOkkxdxxdddddkkxdoooooooddooc;;;::;::cl:ododddoooodxxoooooddodxxxxkkxdo:               
               cxxkkkxxxxxxxkkxdddodxxxooooool:,,',c,,,,;:cc:l,.';cooooodxxxdooodddoodxxxxxxxd:               
               cdddxxxxxdxkOkkxdxddodxxoolc;,......:l:,,,:oolo,......;:lddxdoododkkxddododdxxd:               
               cdxxkkkkkdxkkkkddxxdooxd:'..........cldc;,;oddc..........':ddodxddxkkkxddddoooo:               
               cxkkkkkkxddxkkkddxxdoodo............,;:::;clol'............:dodxxodkkkxddxxxxdo:               
               cdxkkOkkxdddxkxdxxoooddc..............,,,,;;;'.............'ddodxdoxkxdodxxxxxd:               
               cxdxkkxdxkkxddooooddddoc.............';:::;;,..............'ddooddodxdoooddxxxd:               
               lxxxxddxkkkkxdoooxxxxdd:...........,::::;;;,'..............,dddddoooodxxdoddddoc               
               cxxxxdxxxxxxxdodxxxdddo,..........::;:::;,,;'..............'ddddddooddxxxddooddl               
               lkkxddxkkkkkxooodxxxxdc..........,:;;:c:;'','.......... ...'odddddddddddddddoddc               
               lkkxddxkkkkkxooooddxdd;.........';;;;::,,'','.........  ....oddddddddxxxxxddddxl               
               cxxxddxkkkkkxooddodddl........''',;;'..',,,,..........   ...lodddddddxxxxxddddxl               
               cxxdddxxxxxxdoodddddd:...........','...'''''.........    ...odddddddddddxxxdddxl               
               cddooodddddddoodddddd:.................'''''........     ..'odddddddddddxxxdddxc               
               cddooddxxddddoodddddd;............ ....'''''. ......     ..'odddddddddddxxxxddxc               
               :ddoodddxxxxdoodddddd'...........  ....'''''. ......     ..;odddddddddddxxxxddxc               
               :ddooddxxxxxdooddddddc......      .....'''''.  .....    ...lodddddddddddddddddxc               
               :ddoodddddddddddddddddl,....      .......'''.   ....    ..,oodddddddddddddddddxc               
               :oooooddddddddddddddddddoo:.      .........'.    ....   ..:oodddddddddddddddddxc               
               cddddddddddddoooddddddddoooododdddxddddddddxxxxxxdddddddxdddddddddddodddxxxxxxxc               
               cdddddddddddddooddddddxxoooooodxddddddddddddddddxxxddddddddxdddddoooodddxxxxxxxc               
               cdddddddddddxxddddoooodooooooodddoooooodddddddddddxxdddddddddddddoooodddddddxxxc               
               cdddddddddxkkxdxkxxxxxddooooooooooooooddxxddoodddoddddddddddddooooooddddddddxxxc               
               cdddddxxkkkkxddxkkkkkkkkxdoooodxddoooooddddxdooodddddoddodddddddxxddddddddddddxc               
               cdddxxxxkkkxdxkkkkkkkkxxddooooddddl;,;,,,,,cdddoddddooooodxxxxxxxxdddddddddddddc               
               cdxxkkxddxxdxkOOkkxxxdddxddodddl;;'.........coooooooodoooooddxxxxxxdoooddddddddc               
               ckkkOOOxxddxkOOkxxxxdddkkxdddoc,............'oxxxddoodoooddooodddxxxdooddoodddo:               
               lkkkOOOkkxdxkkxddxkOkxdkkddddxo,...';:c:,....lxxxxxddooooxxooodoodxxxddooodxxddc               
               lOOOOOOOkxxxxxxxxkOOkxxxxddddxkd:;;;:clc;,'''cxxxxxxxooooddodxxdooodxxdddxxxkxxc               
               lOOOO00Okxxkxxkkxxxkxxxxxddddkkkl;;;::cll:;;:lxxxkkkxoooooooddxxdoooodddxkkkkxxl               
               lOOOO00OkxkOOxxxxkkxxkOOkdddddxkd;;;,,;clccccoxxxkkxdoooodxxddddodxxdddddkkkkkxl               
               lOOOOOkkxxkOOOxxkOOOxkOOkdddxdddxc;c:;;:ccccloodxxxoodooodxkxddxdddddxxddkkkkkxl               
               lkOOkxxxxxxxxxxxxkOOxkOOxddddddddo:::;;:ccccoddoooooodooodxkxdxxxdodxkxddddxxxxl               
               cxxxkkOkkkOOkxkkxxkkkxkkxoooddxxxxl;;;;:cccclodddxxdooooodxxdxxxxooooooooooddxxl               
               cxxxOOOOOOOOxxkkxxxkxdddddoodxxdoc,';;;:::;;::ol;:ldddooodxddxxxoddodxxxdddddddc               
               cxxxOOOOOOOkxxkxdddddxxdoooodo:'....':;,;:;;;:ol....',:codddddxdoxxddxxxxxxxxdo:               
               cxxkOOkkOOkkxdxxdddodkxxool:,........:l:::;;:cdo'........cdxxoooodddodxxxxkkxdo:               
               cxxkkkxxxxxxxkkxdddodxxo;,...........:c:c:::lod:.........;dxxdooodddoodxxxxxxxd:               
               cdddxxxxxdxkOkkxddxoodd:..............::;;::cc:..........,dxdoododkkxddododdxxd:               
               cdxxkkkkkxxkkkkddxxdood:..............c;,;:cl:,'.........;dddodxddxkkkxdoddoooo:               
               cxkkkkkkxddxkkkddxddoodc.............,:;;;:::;,'.........:ddoodxxodkkkxddxxxxdo:               
               cdxkkOkkxdddxkxdxxoooddo'...........,,,,,;:;;','.........lddddodxdoxkxdodxxxxxd:               
               cxdxkkxxxkkxdddooodddddo'..........'..',;c:;,,,'........'oddddddddodxdooodxxxxd:               
               lxxxxddxkkkkxdoodxxxxddo'................;;;,,,,........,odddddddoooodxxdoddddoc               
               lxxxxdxxxxxxxdodxxxddddd,................,,',,,'........,oddddddddooddxxxddooddl               
               lkkkddxkkkkkxooodxxxxxdd,................',','''........:odddddddddddddddddooddc               
               lkkxddxkkkkkxoooodxxdddl........... .....'',''''........lddddddddddddxxxxxddddxl               
               cxkxddxkkkkkxoodoodddddc..........  ......',,''..  ....'oddddddddddddxxxxxddddxl               
               cxxdddxxxxxxdooddddddddo'......      .....'''''..  ....:oddddddddddddxxxxxddddxl               
               cddooodddddddooddddddddd:.....        ....''''........:odddddddddddddxxxxxxdddxc               
               cddooddxxxdddoodddddddddd:....         ...''''.......:odddddddddddddddxxxxxxddxc               
               :ddooddxxxxxdoodddddddddddc...         ....'''......;oodddddddddddxxxxxxxxxxddxc               
               :ddooddxxxxxdodddddddddddo,...          ...''.. ....loodddddddddddddddddxxxddddc               
               :ddoodddddddddddddddddddl,...            .,,;,'.....cooddddddddddddddddddddddxdc               
               :ooooodddddddddddddddddo;...             .;;:;''....;ooddddddddddddddddddddddxdc               
               lkkkkkkkkkkkx;';oxxxxkxxxxxxxxxkkkkxdoollooooollllllllloooooooooddkkkkkkkkkkkkko               
               lkkkkkkkkkkkd,';dxxxxxxxxxxxxxxxkkkxdolllllolllllllllllooooooooodxkkkkkkkkkkkkko               
               lkkkkkkkkkkkd,':dxxxkkkkkkkkkkkkkkkxollllllllllllllllllooooooooodkkkkkkkkkkkkkko               
               lkkkkkkkkkkxo,':dxkkkkkkkkkkkkkkkkkdollllllllllllllllllooooooooodkkkkkkkkkkkkkko               
               lkkkkkkkkkkxo',:dxkkkkkkkkkkkkkkkkkdoollllllllllllllloooooooooodxkkkkkkkkkkkkkko               
               lkkkkkkkkkkko',cxkkkkkkkkkkkkkkkkkxoolllllllllllllllooooooooooodxkkkkkkkkkkkkkko               
               lkkkkkkkkkkko',cxkkkkkkkkkkkkkkkkkxollllllllllllllloooooooooooodkkkkkkkkkkkkkkko               
               lkkkkkkkkkkko',lkkkkkkkkkkkkkkkkkkxollllllllllllllllloooooooooodkkkkkkkkkkkkkkko               
               lkkkkkkkkkkkl',lkkkkkkkkkkkkkkkkkkkolllllllllllllllllllooooooooxkkkkkkkkkkkkOOOo               
               lkkkkkkkkkkkl';lkkkkkkkkkkkkkkkkkkkolllllllllllllllllllllloooodkkkkkkkkkkkkkOOOo               
               lkkkkkkkkkkkl';okkkkkkkkkkkkkkkkkkkdllllllllllloolllllllllllodxkkkkkkkkkOOOOOOOo               
               lkkkkkkkkkkkc,;okkkkkkkkkkkkkkkkkkkdllllllllllloollllllllllooxkkkkkkkkkkOOOOOOOo               
               lxxxxxxxxxkx:';okkkkkkkkkkkkkkkkkkxollllllllllloolllllllooooxkkkkkkkkkOOOOOOOOOo               
               lxxxxxxxxxxd:';oxxxxxxkkkkkkkkkkkxolllllllllloooolllllloooodxkkkkkkkkkOOOOOOOOOo               
               lxxxxxxxxxxd:,:ddxxxxxxxxxxxxxxxxollllllllllllolllloooooooodkkkkkkkkkkOOOOOOOOOo               
               lxxxxxxxxxxd;,:ddxxxxxxxxxxxxxxdollllllllllllllllllllllooo::xkkkkkkkkkkkkkkkOOOo               
               lxxxxxxxxxxd;,:dxxxxxxdddddddddc:clllllllllllllllllllllll,.;dkkkkkkkkkkkkkkOOOOo               
               lxxxxxxxxxxd;,cdxxxxdddddddddl,...;cllllllllloollooooooc'..,dkkkkkkkkkkkkkOOOOOo               
               lxxxxxxxxxxo;,cdxxdddddddddo;...   ..',::clllllllllllc;....'lxkkkkkkkkkkkkOOOOOo               
               lxxxxxxxxxxo;,cdxxddddddol:'.......... ........'''.........'cxxxxkkkkkkkkkOOOOOo               
               lxxxxxxxxxxo;;lddddddoc:;,'................................':ddxxxxxkkkkkkkOOOOo               
               lkkkkxxxxxxo;;ldddolc:;;,,'....................   .........':dddddxxxxxxkkkkkkko               
               lkkkkkkkkxxo;;loc,''''''...........'.......................':dddddxxxxxxxxxxxxkl               
               lkkkkkkkkkko;;l;........',,,,;;'.........................,:codddddxxxxxxxxxxxxkl               
               lkkkkkkkkkxl,;l,.......''''''..............'',,,,,,,;:cloooodddddxxxxxxxxxxxxxkl               
               lkkkkkkkkxxl;:l:,'..''................'',;;;;:ccclllloooooooddddxxxxxxxxxxxxxxkl               
               lkkkkkkkkxdl;:lc;,'''....''..''''',;:ccccccllooooooooooodddddddddxxxxxxxxxxxkkkl               
               lkkkkkkxxxdl:colccc:::::;:::cccllllollllooodddddddddddxxxxxxxxxxxxxxxxxxxxxxkkkl               
               lkkkxxxxxxdlclodoooooooooooooooooodddddddxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkkl               
               lkxxxxxxxxdllooddddddddddddddddddxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkko               
               lxxxxxxxxxdlloddddddddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkko               
               lxxxxxxxxxdlloddddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkko               
               lxxxxxxddddlloddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkko               
               :ollcccc::::ccccccllloodxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkkl               
               ';;;;;;;;;;,,,;:::::::::::clloxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkxl               
               ';;;;;::::,'',;:::::::::;;;;;;:oxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkxl               
               lkkkkkkkkkkkkkd,';oxxxxxxxxxdoooooooooooolllllloooooooooxkkkkkkkkkkkkkkkkkkdooo:               
               lkkkkkkkkxxxxxd,';oxxxxxxxxxdooolllllllollllllloooooooooxkkkkkkkkkkkkkkkkkkdooo:               
               lkkkkkkkxxxxxxo'':dxxxxxxxxxxolllllllllllllllllooooooooooxkkkkkkkkkkkkkkkkkdooo:               
               lkkkkkxxxxxxxxo'':dxxxxxxxxxxxolllllllllllllllllllloooooodxkkkkkkkkkkkkkkkkxooo:               
               lkkkkkxxxxxxxxo',cdxxxxkkkxxxxdoollllllllllllllllllooooooodxkkkkkkkkkkkkkkkxooo:               
               lkkkkkkkkkxxxxo',cxxkkkkkkkkkkdooooolllllllllllllllooooooodxkkkkkkkkkkkkkkkkxdo:               
               lkkkkkkkkkkkkko',lxkkkkkkkkkkkxdooollllllllllllllllloooooodxkkkkkkkkkkkkkkkkkxd:               
               lkkkkkkkkkkkkkl',lxkkkkkkkkkkkkxollllllllllolllllllllllooodxkkkkkkkkkkkkkkkkkkd:               
               lkkkkkkkkkkkkkc';lxkkkkkkkkkkkkkdlllllllllloooollllllllooddxkkkkkkkkkkkkkkkkkkxc               
               lkkkkkkkkkkkkkc';oxkkkkkkkkkkkkkxollllllllllooolllllooooodxxkkkkkkkkkkkkkkkkkkkl               
               lkkkkkkkkkkkkkc';okkkkkkkkkkkkkkkxllllllllllloooooooooooodxkkkkkkkkkkkkkkkkkkkko               
               lkkkkkkkkkkkkkc';okkkkkkkkkkkkkkkxolllllllllloooooooooooodxkkkkkkkkkkkkkkkkkkkko               
               lxxxxxkkkkkkkx:';dkkkkkkkkkkkxkkkxolllcllllllooooooooooooooxkkkkkkkkkkkkkkkkOOko               
               lxxxxxxxxxxxxx:':dkkkkkkkkkkkxkxxdlllllllllllooooooooooool;lxkkkkkkkkkkkkkkkOOko               
               lxxxxxxxxxxxxd:':dxxxxxxxkkkkxkxdlllllllllllllllllolllllc'.;dkkkkkkkkkkkkkkkOOko               
               lxxxxxxxxxxxxd;':oxxxxxxxxxxxxxxolllllllllllllllllllllll'..'lxkkkkkkkkkkkkkkOOko               
               lxxxxxxxxxxxxo;,codddddddddddddoclllllllllllllllllloool,....:xxkkkkkkkkkkkkkOOko               
               lxxxxxxxxxxxxo,,coddddddddddddl...,:cllllllllllllllll:'.....,oxxxkkkkkkkkkkkOOko               
               lxxxxxxxxxxxxo,,coddddddddddo;...   ....,,,,,,,;;,,.........'cxxxkkkkkkkkkkkOOko               
               lxxxxxxxxxxxxo,,cddddddddddl,................................;dxxxkkkkkkkkkkOOko               
               lxxxxxxxxxxxxo;;ldddddddoc;'.....................  ..........,oxxxxkkkkkkkkkOOko               
               lxxxxxxxxxxxxo;;ldddddo:;;,''..............................';cddddxxxxxkkkkkkkko               
               lkxxxxxxxxxxxl,;lddoc:;;;,,'.............................,:loooddddddxxxxxxxkkkl               
               lkkkkkkxxxxxxl,:ll'............'''..............'''...',,;:loodddddxxxxxxxxxxxxl               
               lkkkkkkkkkkxxl,:l,.......',,,,'''..........',,,,,;;:::cclooodddddxxxxxxxxxxxxxxl               
               lkkkkkkkkkxxdc,:l,......................',;::cccllllooooooooddddxxxxxxxxxxxxxxxl               
               lkkkkkkxxxxxdl;:l;''.....'......''',;::ccllooooooooooooooodddddddxxxxxxxxxxxxxxl               
               lkkxxxxxxxxxdl;clc::;;;;;,;;:::ccllooooodddddddddddddddddddxxxxxxxxxxxxxxxxxxxxl               
               lkxxxxxxxxxxdlcloooooooooooooooodddddxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkl               
               lxxxxxxxxxxxdllloddddddddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkko               
               lxxxxxxxxxxxdllldddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkko               
               lxxxxxxxxxxddlllddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkxl               
               lxxxxxxxxxdddllldxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkxxxxxxxxxxxxkkkl               
               cddooollllccc:cccclloodddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkxl               
               ,:::::::::::;,,;;::::::::::cllodxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkxl               
               ';;:::::::::,',,;:::::;;;;;;;;;;coxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkxl               
               lkkkkkkkkkkkxxxxo'.;oxdooooooooooooolllloooooooooodxkkkkkkkkkkkkkkkkkkkkkkkkkkkl               
               lkkkkkxxxxxxxxxxl'';oxxdoooollooooollllloooooooooooxxkkkkkkkkkkkkkkkkkkkkkkkkkkl               
               lkkkkkxxxxxxxxxxl'':dxxdoooollllllolllllloollloooooodxkkkkkkkkkkkkkkkkkkkkkkkkkl               
               lkkkkkxxxxxxxxxxc.':dxxxdooolllllooolllllllllllllooodxkkkkkkkkkkkkkkkkkkkkkkkkko               
               lkkkkkxxxxxxxxxxc.,cdxxxxdoooooooooolllllllllllllooodxkkkkkkkkkkkkkkkkkkkkkkkkko               
               lkkkkkxxxxxxxxxx:',cxxxxxxooooooooooooooollllllloooodxxkkkkkkkkkkkkkkkkkkkkkkkko               
               lkkkkkkkkkkkkkkx:',lxkkkkxxoollllllooooooooooooooooodxxkkkkkkkkkkkkkkkkkkkkkkkko               
               lkkkkkkkkkkkkkkx:',lxkkkkkkxollllllllllooodddddddooodxxkkkkkkkkkkkkkkkkkkkkkkkko               
               lkkkkkkkkkkkkkkx:';oxkkkkkkkdlllllllllloooddddddddoodxxkkkkkkkkkkkkkkkkkkkkkOOko               
               lkkkkkkkkkkkkkkx:';oxkkkkkkkxdllllllllllloodddddddoodxxxkkkkkkkkkkkkkkkkkkkkOOko               
               lkkkkkkkkkkkkkkx;,:okkkkkkkkkxolllllllllllllooooooooooccxkkkkkkkkkkkkkkkkkkkkkko               
               lkkkkkkkkkkkkkkd;,:okkkkkkkkkxdllllllllllllloooooolool,.cxkkkkkkkkkkkkkkkkkkkkko               
               lxkkkkkkkkkkkkkd;,:dkkkkkxkkkkxlllllllllllllloooooooo:..'cxkkkkkkkkkkkkkkkkkOOko               
               lxxxxxxxxxxxxxxd,,:dkkkkkxxkkkxollllllllooolllloooool'...'okkkkkkkkkkkkkkkkkOOko               
               lxxxxxxxxxxxxxxo,,cdxxxxxxxxxxxlllllllloooooooooooll;....':dkkkkkkkkkkkkkkkkOOko               
               lxxxxxxxxxxxxxdl,,cddddddxxxxxdlllllllllooooooolll:'......'lxkkkkkkkkkkkkkkkOOko               
               lxxxxxxxxxxxxxdl,,ldddddddddddl:clllllllolllc:;;,..........;dxxkkkkkkkkkkkkkOOko               
               lxxxxxxxxxxxxxdl,;lddddddddddo'....''''''..................;dxxkkkkkkkkkkkkkOOko               
               lxxxxxxxxxxxxxdc';ldddddddddl,...   .....................,ldxkkkkkkkkkkkkkkkOOko               
               lxxxxxxxxxxxxxdc,;lddddddddl,.........................,:odxxxkkkkkkkkkkkkkkOOOOo               
               lxxxxxxxxxxxxxdc,:lddddddo:'..................':lllllloddxxxxxxxxkkkkkkkkkkkOOko               
               lxxxxxxxxxxxxxdc,:oddddoc;,,'................':llllooooodddddddxdxxxxxkkkkkkkkko               
               lkxxxxxxxxxxxxdc,:odddl:;;;,'..............',,;;;;:clooooooddddddddxxxxxxxxxkkkl               
               lkkkkkkxxxxxxxd:,codo:....................',,;;;;;::lloooooddddddxxxxxxxxxxxxxxl               
               lkkkkkkkkkkkxxd;,lol;......',,'..........',;;::::clloooooodddddxxxxxxxxxxxxxxxxl               
               lkkkkkxxxxxxxxo;;lol,.......'''''''''',;:clloooooooooooooddddddxxxxxxxxxxxxxxxxl               
               lkkxxxxxxxxxxxo:;llc;''........'',;:clloodddddddddddddddddddddddxxxxxxxxxxxxxxxl               
               lkxxxxxxxxxxxxo::lolc;;,,,;;::llooodddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkxxkl               
               lxxxxxxxxxxxxxoccoddoooooooooddddddxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkkl               
               lxxxxxxxxxxxxxocloddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkkko               
               lxxxxxxxxxxxxdollodxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkxxkkkkkkkkkkkkkkkkkkkkkko               
               lxxxxxxxxxxxxdllloxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkkl               
               lxxxxxxxxxxxxxolloxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkxkkkkkkkkkkkkkkkkkkkkkkl               
               cxxdddoooollllcccclloooodddxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkxxxxxxxkkkkkl               
               ;c::::::::::::;,;;::::::::::cclodxxxxxxxxxxxxxxxxxxxxkkkkkkkxxxxxxxxxxxxxxxxkkxl               
               ';;::::::::::;,,,,::::::;;;;;;;;;:oxxxxxxxxxxxxxxxxxxkxkkkkxxxxxxxxxxxxxxxxxkkxl               
               lkkkkkkkkkkkkxxxxxl'':dxdooooooodddxdoooollllloooooooooxkkkkkkkkkkkkkkkkkkkkkkko               
               lkkkkkxxxxxxxxxxxxc'':dxxdoooooooddxxdooollllloooooooooxkkkkkkkkkkkkkkkkkkkkkkko               
               lkkkkkxxxxxxxxxxxxc.'cxxxdoooooooodxxdooolllllooooooooodxkkkkkkkkkkkkkkkkkkkkkko               
               lkkkkkxxxxxxxxxxxx:.,cxxxxooooooooodddddoollllolllloooodxkkkkkkkkkkkkkkkkkkkkkko               
               lkkkkkxxxxxxxxxxxx:.,lxxxxdoooooooooddddooolllllllllooodxkkkkkkkkkkkkkkkkkkkkkko               
               lkkkkkxxxxxxxxxxxx:',oxxkkdooooooooooodddoolllllllloooodxxkkkkkkkkkkkkkkOOOkkkko               
               lkkkkkkkkkkkkkkkkx:',oxkkkxdooooooooooodddoooollloooooodxxkkkkkkkkkkkkkkOOOkkkko               
               lkkkkkkkkkkkkkkkkd;';okkkkkdooooooooooooooooodddddddooodxxkkkkkkkkkkkkkkkkOOkkko               
               lkkkkkkkkkkkkkkkkd,';dkkkkkxollllllllllllooooddddddddoodxxkkkkkkkkkkkkkkkkOOOOko               
               lkkkkkkkkkkkkkkkkd;':dkkkkkkxollllllllllllloooddddddddddxxkkkkkkkkkkkkkkkkOOkOko               
               lkkkkkkkkkkkkkkkko,,:dkkkkkkkdlllllllllllllllooodddddddddxxkkkkkkkkkkkkkkkkkkkko               
               lkkkkkkkkkkkkkkkko,,:dkkkkkkkxolllllllllllllllloooooooooookkkkkkkkkkkkkkkkkkkkko               
               lxxxxkkkkkkkkkxxxl,,cxkkkkkkkkdlllllllllllllllloooooooolc;oxkkkkkkkkkkkkkkOOOOko               
               lxxxxxxxxxxxxxxxxl',cdxxxxxxxkxdolllllllllllooollloooool;':xkkkkkkkkkkkkkkOOOOko               
               lxxxxxxxxxxxxxxxdc',cdxxxxxxxxxdolllllllllooooooooooool:'',lkkkkkkkkkkkkkkkOOOko               
               lxxxxxxxxxxxxxxxd:',ldddddddddxdollllloooooooooooooool:'..,cxkkkkkkkkkkkkkkOOOko               
               lxxxxxxxxxxxxxxxd:',ldddddddddddolllllloooooooooollc;'....':dkkkkkkkkkkkkkkOOOko               
               lxxxxxxxxxxxxxxxd:';lddddddddddol:cllllooooollc:;,'.......',oxxkkkkkkkkkkkOOOOko               
               lxxxxxxxxxxxxxxxd:';ldddddddddl,....';;;;,,'...............'lxxkkkkkkkkkkkOOOOko               
               lxxxxxxxxxxxxxxxd:,;odddddddl:'..........................';lodxxxxkkkkkkkkOOOOOo               
               lkkkkkkxxxxxxxxxd:,:oddddddl;'.........................,:loodddddxxxxkkkkkkkOOko               
               lkkkkkkkkkkkkkxxd:,:odddddc,,,''.........'...'...'',',;:coooddddddxxxxxxkkkkkkko               
               lkkkkkkkkkkkkkkkd;,coddddc,,;,,,'.............'',,,,,;:cloooddddddxxxxxxxxxxxkkl               
               lkkkkkkkkkkkkkkkd;,coddo:''''...............',,;:::cclloooodddddxxxxxxxxxxxxxxxl               
               lkkkkkkkkkkkkkkkd;,cool;...................',:cllloooooodddddddxxxxxxxxxxxxxxxxl               
               lkkkkkkkkxxxxxkxo;;loll,......'''........'';cooooooooddddddddddxxxxxxxxxxxxxxxxl               
               lkkkkxxxxxxxxxxxo:;loll,.......'''''',,;;:lodddddddddddxxxxxxxxxxxxxxxxxxxxxxxxl               
               lkxxxxxxxxxxxxxxo::ldol:,'''''',,;;:cllodddxxxxxxxxxxxxxkkkkkkkxxxkkkkkkkkkkkkxl               
               lkxxxxxxxxxxxxxxoclodddoooolllooddddddxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkkkko               
               lxxxxxxxxxxxxxxdollodddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkOOko               
               lxxxxxxxxxxxxxxdlllodxddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkOOOOko               
               lxxxxxxxxxdddxxdllloxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkkkko               
               lxxxxxxxxxxxxxddllloxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkkkkkko               
               cxxxddooollllccc:ccccllloooddxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkkkkkl               
               :lc::::::::::::;,,;;:::::;;;;::cloddxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkkkkl               
               ';;;;::::::::::;',,;::::;;;;;;;;;;;codxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkkkkl               
               lkkkkkkkkkkkkkxxxxxl''cdxxxxxxxxxxxxdooooooooddxxddoooooooooodxkkkkkkkkkkkkkkkko               
               lkkkkkkxxxxxxxxxxxxc.'cdxxxxxxxxxxxxdoooollooddxxdooooooooooodxkkkkkkkkkkkkkkkko               
               lkkkkkkkkkxxxxxxxxxc.,lxxxxxxxxxxxxxxdolllloooddddooooooooooodxkkkkkkkkkkkkkkkko               
               lkkkkkkkkkxxxxxxxxx:.,lxxxxxxxxxxxxxxdoooooooooddddoooooooooodxkkkkkkkkkkkkkkkko               
               lkkkkkkkkkxxxxxxxxx:.;oxxkxxxxkkkkkxxdoooooooooddddoooooooooooxkkkkkkkkkkkkkkkko               
               lkkkkkkkkkxxxxxxxxx:';oxxkkxxxkkkkkkxdooooooooooddddooooooooodxkkkkkkkkkkkkkkkko               
               lkkkkkkkkkkkkkkkkkx:';dkkkkkkkkkkkkkxdoooooooooooddddoooooooodxkkkkkkkOkkkkkkkko               
               lkkkkkkkkkkkkkkkkkx;';dkkkkkkkkkkkkxdoooooooooooodddddooooooddxkkkkkkkOOkkOkkkko               
               lkkkkkkkkkkkkkkkkkd;':dkkkkkkkkkkkkxoooooooooooooooddddoooodddxkkkkkkkkkkkOOOOOo               
               lkkkkkkkkkkkkkkkkkd;,:dkkkkkkkkkkkxdooooooooooooooodddddddddddxkkkkkkkkkkkOOOOko               
               lkkkkkkkkkkkkkkkkkd;,cdkkkkkkkkkkkxollllllllllllooooddddddddddxkkkkkkkkkkkkkkkko               
               lkxxxxxkkkkkkkkkkkd;,cdkkkkkkkkkkkxdlllllcccccccllooooddddddddxkkkkkkkkkkkkkkkko               
               lxxxxxxxxxxxxxxxxxo,,cxkkkkkkkkxkkkdlllllllllcccclllooooddddddxkkkkkkkkkkkOOOOko               
               lxxxxxxxxxxxxxxxxxl,,ldxxxxxxxxxxxkdllllllllllllllllloooooddddxkkkkkkkkkkkOOOOko               
               lxxxxxxxxxxxxxxxxdc,,ldxdddddxxxxxxdolllllllllllllllllloooddddxkkkkkkkkkkkkOOOko               
               lxxxxxxxxxxxxxxxxdc';ldxddddddddddddollllllllllllllllllloodooldkkkkkkkkkkkkOOOko               
               lxxxxxxxxxxxxxxxxd:';lddddddddddddddolllllllloolllllloooooooc:lxkkkkkkkkkkkOOOko               
               lxxxxxxxxxxxxxxxxdc';lddddddddddddoc,;cllllooooooooooooooolc,;lxkkkkkkkkkkOOOOko               
               lxxxxxxxxxxxxxxxxd:';lddddddddddol,....,:looooooooooooool:;'',lxkkkkkkkkkkOOOOko               
               lxxxxxxxxxxxxxxxxd:,:oddddddddo:'.........;:ccllloolcc:,'....,cdxxxxkkkkkkkkOOko               
               lkkkkkkxxxxxxxxxxd:,:odddddddc;,'.........,,.................':ddddxxxxxkkkkOOko               
               lkkkkkkkkkkkkkxxxd:,:odddddo;,,,,,'.......',.................'cdddddxxxxxxxkkkko               
               lkkkkkkkkkkkkkkkkd;,coddddl;,,;,,'........................',:loddddxxxxxxxxxxxxl               
               lkkkkkkkkkkkkkkkkd;,cdddd:'',,''......'...........',;;;:clooodddddxxxxxxxxxxxxkl               
               lkkkkkkkkkkkkkkkko;,lodo;.............'.......',;:cllloooooddddddxxxxxxxxxxxxxxl               
               lkkkkkkkkkkkkkkkxo;;looc'......','..........';cloooooooooodddddddxxxxxxxxxxxxxxl               
               lkkkkkkkkkkkkxxxxo:;lol:'................'';cooddddddddddddddddddxxxxxxxxxxxxxxl               
               lkkkkkkkkkxxxxxxxo::oolc,''...'''''',,;::clodddxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkxl               
               lkkkkkkkxxxxxxxxxoclodddollccccccllooooooddddxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkko               
               lkkkkkxxxxxxxxxxdllloddddddoooooooddddddddxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkOOOko               
               lxxxxxxxxxxxddxxdllloddddddddddddddddddxxxxxxxxxxxxxxxxkkkxkkkkkkkkkkkkkkkkkOOko               
               lxxxxxxxxxxxddxddllooddddddddddxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkkkko               
               lxxxxxxxxxxxdddddlllodddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkko               
               cxxxxddoolllccccc:ccccllloodddxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkl               
               :occ:;;;;;;;::::;,,;;:::;;;;;:::clodxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkxl               
               ';,,;;;;;;;:::::;',,;:::;;;;;;;;;;;;:oxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkxkkxl               
               lkkkkkkkkkkkkkxxxxkx:.,lxxxxxxxxxxxxxxdooodoooooooooooooooxkkkkkkkkkkkkkkkkkkkko               
               lkkkkkkkkkkkxxxxxxxx;.,lxxxxxxxxxxxxxxdooodooooolllooooooodxkkkkkkkkkkkkkkkkkkko               
               lkkkkkkkkkxxxxxxxxxd;.;oxxxxxxxxxxxxxxdooooooooollloooooooodkkkkkkkkkkkkkkkkkkko               
               lkkkkkkkkkxxxxxxxxxd,';oxxxxxxxxxxxxxxdoooooooolllllooooooodxkkkkkkkkkkkkkkkkkko               
               lkkkkkkkkkxxxxxxxxxd,':dxxxxxxkkkkkkxxdoooooooollllloooooooddkkkkkkkkkkkkkkkkkko               
               lkkkkkkkkkxxxxxxxxxd,':dkkkkkxkkkkkkxdooooooooooollloooooooddxkkkkkkkkkkOOOOkkko               
               lkkkkkkkkkkkkkkkkkkd,':dkkkkkkkkkkkkxdoooooooooooooooooooooddkkkkkkkkkkkkkOOOOOo               
               lkkkkkkkkkkkkkkkkkkd,'cxkkkkkkkkkkkkxdoooooooooooooooooooodddxkkkkkkkkkkkkOOOOOo               
               lkkkkkkkkkkkkkkkkkko,,cxkkkkkkkkkkkxdooooooooooooooodooddddddxkkkkkkkkkkkkkkOOko               
               lkkkkkkkkkkkkkkkkkko,,lxkkkkkkkkkkkxoooooooooooooooodddddddddxkkkkkkkkkkkkkkkkko               
               lkkkkkkkkkkkkkkkkkko,,lxkkkkkkkkkkkdlllllllllllooooooddddddddxkkkkkkkkkkkkkkOOko               
               lkkkkkkkkkkkkkkkkkko,,lxkkkkkkkkkkkxollllccccclllooooooddddddxkkkkkkkkkkkkkkOOko               
               lxkkkkkkkkkkkkkkkkkl,,lxkkkkkkkkkkkxolllllllcccclllooooodddddxkkkkkkkkkkkkOOOOko               
               lxxxxxxxxxxxxxxxkxxl',oxkkkkkkkkkkkxolllllllllllllllloooodddddokkkkkkkkkkkOOOOko               
               lxxxxxxxxxxxxxxxxxdc';oxxxxxkkkxxxxxdllllllllllllllllooooddooolxkkkkkkkkkkkOOOko               
               lxxxxxxxxxxxxxxxxxdc';odddxxxxxxxxxxxolllllllllllllllllooodooc:dkkkkkkkkkkkOOOko               
               lxxxxxxxxxxxxxxxxxd:';odddddxxdddddddollllllllllllllllooooool;;okkkkkkkkkkOOOOko               
               lxxxxxxxxxxxxxxxxxd:':oddddddddddddolclllllllloooooooooooool;,,lkkkkkkkkkkOOOOko               
               lxxxxxxxxxxxxxxxxxd:':oddddddddddoc,...;cllllloooooooooolc;'.',lkkkkkkkkkkOOOOko               
               lxxxxxxxxxxxxxxxxxd:':oddddddddoc,........;::cllllllc:;,'.....,lxkkkkkkkkkOOOOko               
               lkxxxxxxxxxxxxxxxxd:,:oddddddoc,'.............................'cxxxkkkkkkkkkOOko               
               lkkkkkxxxxxxxxxxxxd:,codddddl;,,,,'...........................'cddxxxxxxkkkkkkko               
               lkkkkkkkkkkxxxxxxxd;,cdddddl;,,,,,'.........................':loddddxxxxxxxxxxkl               
               lkkkkkkkkkkkkkkkkxo;,ldddd:,,,,,'..................'',,,;:cloodddddxxxxxxxxxxxxl               
               lkkkkkkkkkkkkkkkkko;;lddo;......................';::clllooooodddddxxxxxxxxxxxxxl               
               lkkkkkkkkkkkkkkkkxo;:lol:......',,'............;clllloooooooddddddxxxxxxxxxxxxxl               
               lkkkkkkkkkkkkkxxxxl;:lll;.................'',:clloooooooooddddddddxxxxxxxxxxxxxl               
               lkkkkkkkkkkxxxxxxdl::ool:,'....''''',,;;::clodddddddddddddddddxxxxxxxxxxxxkkkkkl               
               lkkkkkkkkxxxxxxxxdlcloddollcccccccllooooooddddxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkko               
               lkkkkkxxxxxxxxxxxdlllodddddddoooooodddddddxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkOOko               
               lxxxxxxxxxxxdxxxxdllloddddddddddddddxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkOOko               
               lxxxxxxxxxxxxxxxxdlloodddddddddxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkkko               
               lxxxxxxxxxxxxxddddlllodddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkkkko               
               cxxxxxxddooolllllccccclllooddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkl               
               cdolcc:;;::::::::;,;;;:::::;:::ccloddxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkxxxxxxxxkkxl               
               ,:,,;;;;:::::::::;,,,;::::;;;;;;;;;;:ldxxxxxxxxxxxxxxxxxxxxkkkkkkkkkxxxxxxxxxxxl               
               lkkkkkkkkkkkkkkxxxxd;.,oxxxxxxxxdoooooooooollllllooooooodxkkkkkkkkkkkkkkkkkkkkdc               
               lkkkkkkkkkkkkxxxxxxd,.,oxxxxxxxxdoooooooooolllllloooooooodkkkkkkkkkkkkkkkkkkkkxc               
               lkkkkkkkkkxxxxxxxxxd,';dxxxxxxxxdoooooooooolllllloooooooodxkkkkkkkkkkkkkkkkkkkxl               
               lkkkkkkkkkxxxxxxxxxd'':dxxxxxxxxdoooooooooollllllooooooooddkkkkkkkkkkkkkkkkkkkkl               
               lkkkkkkkkkxxxxxxxxxo'':dxxkxxxxxdoooooooooolllllloooooodddxxkkkkkkkkkkkkkkkkkkkl               
               lkkkkkkkkkxxxxxxxxxo',cxkkkxxxxxdooooooooooollllllllooodxxxkkkkkkkkkkkkkkkkkkkko               
               lkkkkkkkkkkkkkkkkkxo',cxkkkkkkkkxoooooooooooooolllllloodxkkkkkkkkkkkkkkkkkkkOOOo               
               lkkkkkkkkkkkkkkkkkko',cxkkkkkkkkkoooooooooooooooooolloodxkkkkkkkkkkkkkkkkkkOOOOo               
               lkkkkkkkkkkkkkkkkkkl',lxkkkkkkkkkooolllllooooooooddddddddxxxkkkkkkkkkkkkkkOOOOOo               
               lkkkkkkkkkkkkkkkkkkl';lxkkkkkkkkkdollllllllooooooodddddddddxkkkkkkkkkkkkkkOOOOOo               
               lkkkkkkkkkkkkkkkkkxc';oxkkkkkkkkkxollllllclllloooooddddddddxkkkkkkkkkkkkkkOOOOko               
               lkkkkkkkkkkkkkkkkkxc';oxkkkkkkkkkkdlllllllcccllllooddooddddxkkkkkkkkkkkkkkOOOOOo               
               lxxxxxkkkkkkkkkkkkx:';oxkkkkkkkkkkxllllllllllllllllooodooodxkkkkkkkkkkkkkkOOOOOo               
               lxxxxxxxxxxxxxxxxxd:';oxkkkkkkkkkkxollllllllllllllloooodooodlokkkkkkkkkkkkOOOOOo               
               lxxxxxxxxxxxxxxxxxd:':oxxxxxxxxxxxxdllllllllllllllllloooolol,:xkkkkkkkkkkkkkOOOo               
               lxxxxxxxxxxxxxxxxxo;,:oddddxxxxxxxxxllllllllllllllllllooooo;';okkkkkkkkkkkkkOOOo               
               lxxxxxxxxxxxxxxxxxo;,:odddddddddddddlllllllllolllllllloollc'',lxkkkkkkkkkkkkOOOo               
               lxxxxxxxxxxxxxxxxxo;,codddddddddddoc:clllllllllooooooool:,''',cxkkkkkkkkkkkkOOOo               
               lxxxxxxxxxxxxxxxxxo;,coddddddddddl;...';ccclllllllcc:;,'.....':xkkkkkkkkkkkkOOOo               
               lxxxxxxxxxxxxxxxxxo,,codddddddoc;'...........................':dxkkkkkkkkkkkOOOo               
               lxxxxxxxxxxxxxxxxxo;,cdddddddl;'.............................';oxxxkkkkkkkkkOOOo               
               lkxxxxxxxxxxxxxxxxl;;ldddddoc,,,''...........................':oxxxxxkkkkkkkkkko               
               lkkkkkxxxxxxxxxxxdl,;lddddl:;;;;,'.........................';lodddxxxxxxxxxxkkkl               
               lkkkkkkkkkkxxxxxxxc,:odddc,.''....................'',;;;:clooodddddxxxxxxxxxxxxl               
               lkkkkkkkkkkkkkkkxd:,:ooo:.......'.............',;:ccllllooooodddddxxxxxxxxxxxxxl               
               lkkkkkkkkkkkkkxxxd:,coll;......''............';cllllooooooooddddddxxxxxxxxxxxxxl               
               lkkkkkkkkxxxxxxxxdc;coll;'....''''''''''''',;clooooooooooooodddddxxxxxxxxxxxxxxl               
               lkkkkkkxxxxxxxxxxdc;cool:,,'..'''',,;::clllooooddddooooddddddddddxxxxxxxxxxxkkkl               
               lkkkkxxxxxxxxxxxxdlcloddoooolooooooodddddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkxxl               
               lxxxxxxxxxxxxxxdxdlllodddddddddddddxxxxxxddxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkxxxl               
               lxxxxxxxxxxxdddddolllodddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkxxl               
               lxxxxxxxxxxxxxddxollldxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkl               
               lxxxxxxxxxxxxxxxxollldxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkl               
               lxxxxxdddooolllllccccclloooddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkl               
               cdllc::::::::::::;,,;;:::::::::ccloddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxl               
               ,;;;;;;;:::::::::,',,;::;;;;;;;;;;;;:lxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxl               
               lkkkkkkkkkkkkkkkkkxx;.,oxxxxxxxxoooooooooooooooollloooooodxxxxkkkkkkkkkkkkkdooo:               
               lkkkkkkkkkkkkkxxxxxd,.,oxxxxxxxxoooooooooolllllllllloooooddxxxkkkkkkkkkkkkkdooo:               
               lkkkkkkkkkxxxxxxxxxd,';oxxxxxxxxdooolllllllllllllllloooodddxxxkkkkkkkkkkkkkdooo:               
               lkkkkkkkkkxxxxxxxxxd,';dxxxxxxxxxoollllllllllllllllloooddxxxxxkkkkkkkkkkkkkxooo:               
               lkkkkkkkkkxxxxxxxxxo'':dxxkxxxxkxdolllllllllllllllllooodxxxkkkkkkkkkkkkkkkkkdoo:               
               lkkkkkkkkkxxxxxxxxxo',cxkxkkkxxkkdollllllllllllllllllooodxkkkkkkkkkkkkkkkkkkxdo:               
               lkkkkkkkkkkkkkkkkkxl',cxkkkkkkkkkdolllllllloooooooollooddxkkkkkkkkkkkkkkkkkkxdd:               
               lkkkkkkkkkkkkkkkkkkl',cxkkkkkkkkkxolllllllllooooooodoooddxxkkkkkkkkkkkkkkkOOkxd:               
               lkkkkkkkkkkkkkkkkkkl',lxkkkkkkkkkxollllllllllloooooddxddddxxkkkkkkkkkkkkkkOOOkd:               
               lkkkkkkkkkkkkkkkkkkl';lxkkkkkkkkkxdllllllllcllllloooddddddddxkkkkkkkkkkkkkkOOOx:               
               lkkkkkkkkkkkkkkkkkxc';oxkkkkkkkkkxxolllllllcclllllllodddddddxkkkkkkkkkkkkkkkOOxc               
               lxxxxxkkkkkkkkkkkkxc';oxkkkkkkkkkkkdllllllllllllllllooooooodxkkkkkkkkkkkkkkkOOxc               
               lxxxxxxxxxxxxxxxxkx:':oxkxkkkkkkkkkdlllllllllllllllllooodoooxxkkkkkkkkkkkkkOOOxc               
               lxxxxxxxxxxxxxxxxxd;':oxxxxxxxxxxxxxolllllllllllllllloooooooookkkkkkkkkkkkOOOOxc               
               lxxxxxxxxxxxxxxxxdd;':oxxxxxxxxxxxxxdllllllllllllllllllloool;:dkkkkkkkkkkkkkOOkl               
               lxxxxxxxxxxxxxxxxxo;,:oddddddddddddxdlllllllllllloolloooool;';oxkkkkkkkkkkkkOOkl               
               lxxxxxxxxxxxxxxxxxo,,coddddddddddddol:ccclllllllloooooolc:,'',cxxkkkkkkkkkkkOOko               
               lxxxxxxxxxxxxxxxxxo,,cddddddddddddo:'....';::::ccc:::;,''..''':dxkkkkkkkkkkkOOOo               
               lxxxxxxxxxxxxxxxxxo,,cddddddddddoc'..........................':dxxxkkkkkkkkkOOOo               
               lxxxxxxxxxxxxxxxxxl,,cddddddddoc;,'..........................':dxxkkkkkkkkkkOOOo               
               lxxxxxxxxxxxxxxxxxl,;lddddddo:::;,'..........................';oxxxxxxkkkkkkOOko               
               lkkkxxxxxxxxxxxxxxl,;lddddo;'................................':oxxxxxkkkkkkkkkko               
               lkkkkkkkxxxxxxxxddc,;ldddo,................................,;lodddxxxxxxkkkkkkkl               
               lkkkkkkkkkkkkxxxxdc,:odddc,'.....'...............'',,;::clloooodddddxxxxxxxxxxxl               
               lkkkkkkkkkkkkkxxdd:,:ooollc:;;,,,,,'''........';;:cllloooooooodddddddxxxxxxxxxxl               
               lkkkkkkkkkkkxxxddo:,cooolllc:,''''''.........,cllllloooooooooddddddddxxxxxxxxxxl               
               lkkkkkkxxxxxxxxxxoc;cooooll:;;,,,,,,;,,,,,,,:llooooooooooooddddddddddxxxxxxxxxxl               
               lkkkkxxxxxxxxxxxxoc;codddoolllllllllllllllloooooooooooooooodddddddddxxxxxxxxxxxl               
               lkxxxxxxxxxxxxxxxolclddddddooooooooodddddddddddddxxddddddddddddddddxxxxxxxxxxxxl               
               lxxxxxxxxxxxxxxddollldddddddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkxxxddddc               
               lxxxxxxxxxxxdddddolllddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkxxxxdddc               
               lxxxxxxxxxxxxddxxollldxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkxxxxxxxxxxxxxxxdc               
               lxxxxxxxxxxxxxxxxollldxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxl               
               lxxxxxdddooolllllcccccllooooddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxl               
               collc:::::::::::;,,,,;::::;;;::ccloddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxl               
               ,;;;;;::::::::::;,',,:::;;;;;;;;;;;;:lxxxxxxxxxxxxxxxxxxxxddddxxxxxxxxxxxxxxxxxl               
               lkkkkkkkkkkkkkkkkkxx;.,lxxxxxxxxxxxxxollllllllllllloolllooooddxxxkkkkkkkkkkkkkd:               
               lkkkkkkkkkkkkkkkxxxd;.,oxxxxxxxxxxxxxollllllllllllllllllooooodxxxkkkkkkkkkkkkkxc               
               lkkkkkkkkkkkkkkxxxxd,.;oxxxxxxxxxxxxxollllllllllllllllllooooddxxxkkkkkkkkkkkkkkc               
               lkkkkkkkkkkkkkxxxxxd,';oxxxxxxxxxxxxdolllllllllllllloooooooodxxxxkkkkkkkkkkkkkkc               
               lkkkkkkkkkkkkkxxxxxd,':dxxkxxxxxxxxxdlllllllllllllllloooooodxxxkkkkkkkkkkkkkkkkc               
               lkkkkkkkkkkkkkkkxxxo',cdxxkkkxxxxxxxolllllllllllllllllooooodxkkkkkkkkkkkkkkkkkkl               
               lkkkkkkkkkkkkkkkkkxo',cxkkkkkkkkkkkxollllllcccccclllllooddddxxkkkkkkkkkkkkkkkkkl               
               lkkkkkkkkkkkkkkkkkko',cxkkkkkkkkkkkxolllllcccccccllllllloddddxkkkkkkkkkkkkkkkkko               
               lkkkkkkkkkkkkkkkkkkl',lxkkkkkkkkkkkkdllllcccccccclllllllloddddxxkkkkkkkkkkkkkkko               
               lkkkkkkkkkkkkkkkkkkl';lxkkkkkkkkkkkkxlllllllccllllllllllllodddxxkkkkkkkkkkkkkkko               
               lkxxxkkkkkkkkkkkkkxc';oxkkkkkkkkkkkkxolllllccccccclllllllooooddxkkkkkkkkkkkkkkko               
               lxxxxxxxxxkkkkkkkkxc';oxkkkkkkkkkkkkxolllllllllllllllllllooooodxkkkkkkkkkkkkOOOo               
               lxxxxxxxxxxxxxxxxxx:':oxxxxkkkkkkkkxkdlllllllllllllllllllloooodxkkkkkkkkkkkkOOOo               
               lxxxxxxxxxxxxxxxxxd;':oxxxxxxxxxxxxxxxllcccclllllllllllllloooodkkkkkkkkkkkkkOOOo               
               lxxxxxxxxxxxxxxxxxd;':odddddddxxxxxddl;,,,;cllllllllloooooooc;oxkkkkkkkkkkkkOOOo               
               lxxxxxxxxxxxxxxxxxo;':oddddddddddddo:.......',;:ccllllllllc:,,cxxkkkkkkkkkkkOOOo               
               lxxxxxxxxxxxxxxxxxo;'codddddddddol:'......... .....',,,,'.''',:dxkkkkkkkkkkkOOOo               
               lxxxxxxxxxxxxxxxxxo,,codddddoc:::;,''...............'.......'';dxkkkkkkkkkkkOOOo               
               lxxxxxxxxxxxxxxxxxo,,codddd:'................................';dxxkkkkkkkkkkOOOo               
               lkxxxxxxxxxxxxxxxxl,,codddc.................................',;dxxkkkkkkkkkkOOOo               
               lkkkkkxxxxxxxxxxxxl,,cdddd:,'''''''.........................'';oxxxxxxkkkkkkOOko               
               lkkkkkkkkkxxxxxxxxl,;lddddolc:;;;,,,'''......................,:dxxxxxxkkkkkkkkko               
               lkkkkkkkkkkxxxxxddc,;lddddddoolllc:::;;;,,''.......''.....';looddxxxkkkkkkkkkkkl               
               lkkkkkkkkkkxxxxxdd:,:oddoooollllllllcc::;;,,''''',,,;;::cllooodddddxxxxxxxxxxxxl               
               lkkkkkkkkkkkkxxddo:,:ooolllllllllcc::;;,,,,,,,;;::cllloloooooooddddddxxxxxxxxxxl               
               lkkkkkkkkkkkxxxddo:,cooooooooollllc::;;;;;;;;cllllllooooooooooddddddddxxxxxxxxxl               
               lkkkkkkkkxxxxxxxxoc;coddddddddooooollllccccclooooooooooooooodddddddddxxxxxxxxxxl               
               lkkkkkxxxxxxxxxxxoc;codddddddoooooooooooddddddddddooooooooodddddddddxxxxxxxxxxxl               
               lkxxxxxxxxxxxxxxxolclddddddddoooooodddddxxxxxxxxxxxxddddddddddddddddxxxxxxxxxxxl               
               lxxxxxxxxxxxxxxddolllddddddddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxdddxxxxxxxxxxxxxl               
               lxxxxxxxxxxxdddddollldddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdddoc               
               lxxxxxxxxxxxxddxxollldxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkxxddoo:               
               lxxxxxxxxxxxxxxxxollldxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdoo:               
               lxxxxxddoooolllllcccccllooodddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxddc               
               collc:::::::::::;,,,,;::::;;:::ccloddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxc               
               ,;;;;;::::::::::;,',,:::;;;;;;;;;;;;:lxxxxxxxxxxxxxxxxxxxxddddddxdxxxxxxxxxxxxxc               
               lkkkkkkkkkkkkkkkkkxo'':dxxxxxxxxxxxxxxoooooddxxxxxxdoooolooooodddxkkkkkkkkkkkkkl               
               lkkkkkkkkkkkkkkkxxxl'':dxxxxxxxxxxxxxxooooodddxxxxxooollloooooddddkkkkkkkkkkkkkl               
               lkkkkkkkkkkkkkkxxxxl''cdxxxxxxxxxxxxxxooooooodddxxxddoooooooooodddkkkkkkkkkkkkkl               
               lkkkkkkkkkkkkkxxxxxl''cdxxxxxxxxxxxxxxoooooooooddxxxxdoooooooooddxkkkkkkkkkkkkkl               
               lkkkkkkkkkkkkkxxxxxl',cxxxxxxxxxxxxkkxoooooooooodddxkxdooooooooddxkkkkkkkkkkkkkl               
               lkkkkkkkkkkkkkkkkxxc';lxkkkkkkkkkkkkxoolllllllooooodxxxdoooooodddxkkkkkkkkkkkkkl               
               lkxxxxkkkkkkkkkkkkx:';oxkkkkkkkkkkkkdoolllllllllooodddxxxddddddddxkkkkkkkkkkkkkl               
               lxxxxxxxkkkkkkkkkkx:';oxkkkkkkkkkkkxooolllllllllllooooddxxxxxxxxxxkkkkkkkkkkkkkl               
               lxxxxxxxxkkkkkkkkkx:';oxkkkkkkkkkkkdollllllllllllllllooodddxxxxxxkkkkkkkkkkkkkkl               
               lxxxxxxxxxxxxxkkkkx:':dkkkkkkkkkkkkdlllllllcccccclllllllooodxxxxxkkkkkkkkkkkkkkl               
               lxxxxxxxxxxxxxxxxxd;':dkkkkkkkkkkkkxollllllllcccclllllllllooxxxxxkkkkkkkkkkkkkkl               
               lxxxxxxxxxxxxxxxxxd;,:dkkkkkkkkkkkkxolllllllllllllllllllllloddddxkkkkkkkkkkkkkkl               
               lxxxxxxxxxxxxxxxxxd;,:dxxxxxxxxxxkkkdlllllllloooooolllllllloodddxkkkkkkkkkOOOOkl               
               lxxxxxxxxxxxxxxxxxo,,cdxxxxxxxxxxxxxxollllllloooooolllllllloodddxkkkkkkkkkOOOOkl               
               lxxxxxxxxxxxxxxxxxo,,cdxddddddxxxxxxxolllloooodddoolllllollloodxkkkkkkkkkkkkOOkl               
               lxxxxxxxxxxxxxxxxdl,,cddddddddddddddddollloooodddoollllooooooodxkkkkkkkkkkkkOOkl               
               lxxxxxxxxxxxxxxxxxl,,lddddddddddddddddc'',cloddddoollloooooooldkkkkkkkkkkkkkOOko               
               lxxxxxxxxxxxxxxxxxc,,lddxxddddddddddo:.......;:;:cllllllllc:;;cxkkkkkkkkkkkkOOOo               
               lkkkkkkkkkxxxxxxxxc',ldxxxxxddddddo:'........'......''''''''',cxxkkkkkkkkkkkOOOo               
               lkkkkkkkkkkkkkkkkxc';ldxddddddddoc,.........''......'........,cxxkkkkkkkkkkkOOOo               
               lkkkkkkkkkkkkkkkkx:,;ldxxxdddddl;'..........''...............':dxxxxxkkkkkkkkkko               
               lkkkkkkkkkkkkkkkkx:,:oxxxxdddoc;;,,,'........'...............':odddxxxxkkkkkkkko               
               lkkkkkkkkkkkkkkkkx:,:oxxxxddo;,,,,''.......................':looddddxxxxkkkkkkko               
               lkkkkkkkkkkkkkkkkd:,cdxxddol'..................'...',;;::cloooddddddxxxxxxxxxxkl               
               lkkkkkkkkkkkkkkkkd;,coooool:...................'';:cllolooooooodddddxxxxxxxxxxxl               
               lkkkkkkkkkkkkxxxxo;;looolll:''....''''......''',:looooooooooooddddddxxxxxxxxxxxl               
               lkkkkkkkkkxxxxxxxo:;looolllc:'''''''....''',;cloddddddddooodddddddxxxxxxxxxxxxxl               
               lkkkkkkxxxxxxxxxxo::ldoooool:;;;;;;;;;:ccloddddxxxxddddddddxxxxxxxxxxxxxxxxxxxxl               
               lkxxxxxxxxxxxxxxdoccodddddddooooooooodddddxxxxxxxxxxddddxxxxxxxxkkkkxxxxxxxxxxxl               
               lxxxxxxxxxxxxxxxdollodddddddddddddddxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkxxxxxxxl               
               lxxxxxxxxxxxxxxxdolllddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkxdddc               
               lxxxxxxxxxxxdddxdollodxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkxxddc               
               lxxxxxxxxxxxxxxxxlllodxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxc               
               lxxxxddooollllllc:ccccllloooddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxl               
               :olc::::::::::::;,,,;::::::;;::cclodxxxxxxxxxxxxxxxxxdddddddddddddddxxxxxxxxxxxl               
               ,;;;;:::::::::::;,',,:::::;;;;;;;;;;:oxxxxxxxxxxxxxdddddddddddddddddxxxxxxxxxxxl               
               lkkkkkkkkkkkkkkkkkd,.,oxxxxxxxxxxxxxxdooddxxxkkkkxxdooooooooodddxkkkkkkkkkkkkkko               
               lkkkkkkkkkkkkkkkxxd,';oxxxxxxxxxxxxxxdoooddxxxxkkxxdooooooooodddxkkkkkkkkkkkkkko               
               lkkkkkkkkkkkkkkxxxo'';dxxxxxxxxxxxxxxxoooodddxxxxxxdooooooooddddxkkkkkkkkkkkkkkl               
               lkkkkkkkkkkkkkkkkxo'':dxxxxxxxxkkkxxxxdooooodddxxxkdooooooodddddxkkkkkkkkkkkkkkl               
               lkkkkkkkkkkkkkkkkxo',:dxkxxxxxkkkkkxxxdooooooddddxkkdoooooodddddkkkkkkkkkkkkkkkl               
               lkkkkkkkkkkkkkxkkxl',cxxkkkkkkkkkkkkxxooooooooodddxxxxdooooodddxkkkkkkkkkkkkkkko               
               lxxxxxkkkkkkkkkkkxl',cxkkkkkkkkkkkkxxooooooooooooddxxxxdoooddddxkkkkkkkkkkkkkkOo               
               lxxxxxxxxxkkkkkkkkc',lxkkkkkkkkkkkkxoooooooooooooodddxxxxxddxxxxkkkkkkkkkkkkkkOo               
               lxxxxxxxxxxxkkkkkkc',lxkkkkkkkkkkkkdlllllllllllllooooddxxkxxxxxxkkkkkkkkkkkkkkko               
               lxxxxxxxxxxxxxkkkxc';oxkkkkkkkkkkkxollllllcccccclllloooddxxxxxxxkkkkkkkkkkkkkkko               
               lxxxxxxxxxxxxxxxxd:';oxkkkkkkkkkkkxdlllllllcccccccllllllooodxxxxkkkkkkkkkkkkkkOo               
               lxxxxxxxxxxxxxxxxd:';oxkkkkkkkkkkkkxllllllllllllllloooooolooddxxxkkkkkkkkkkkkkOo               
               lxxxxxxxxxxxxxxxxd;';oxxxxxxxxxxxxxxolllllloooodddddddddooooodddxkkkkkkkkkOOOOOo               
               lxxxxxxxxxxxxxxxxd;':oxxxxxxxxxxxxxxdllloooooooddddoooooooooodddkkkkkkkkkkOOOOOo               
               lxxxxxxxxxxxxxxxxo;':oxxxxdddxdddxxxdolllooooodxxxxddooooooooodxkkkkkkkkkkkkOOOo               
               lxxxxxxxxxxxxxxxxo,,:oddddddddddddddddlllloooodxxxxxddooooooodxkkkkkkkkkkkkkOOOo               
               lxxxxxxxxxxxxxxxxo,,coddddddddddddddddc,,;cooddddddddoooooooooxkkkkkkkkkkkkkOOOo               
               lxxxxxxxxxxxxxxxxo,,coxxxxddddddddddo:.......;:cloooolllollc;cxkkkkkkkkkkkkkOOOo               
               lkkkxxxxxxxxxxxxxo,,coxxxxxxxdddddo:'........'......',,,,''',:xkkkkkkkkkkkkkOOOo               
               lkkkkkkkkkkkkkkkxl',coxxxdddddddl;'.........''......'.......':dxxxkkkkkkkkkkOOOo               
               lkkkkkkkkkkkkkkkkl,;cdxxxxdddddc,''.........''..............';dxxxxxkkkkkkkkkkko               
               lkkkkkkkkkkkkkkkkl,;ldxxxdddddc;;,,,'........''.............':oddddxxxxkkkkkkkko               
               lkkkkkkkkkkkkkkkkc,;oxxxxddddc,,,,''......................,:lodddddxxxxxkkkkkkko               
               lkkkkkkkkkkkkkkkxc,:odxddddo;.................'''..,,;;:clooodddddddxxxxxxkkxxkl               
               lkkkkkkkkkkkkkkkx:,:oooooool'................'''';cllloooooodddddddxxxxxxxxxxxxl               
               lkkkkkkkkkkkkxxxd:,coooolllc'......''.........';cooodddoooodddddddxxxxxxxxxxxxxl               
               lkkkkkkkkkxxxxxxd:,coooolllc;'''''''''''''',;:lddddxxxxddddddddddxxxxxxxxxxxxxxl               
               lkkkkkkxxxxxxxxxdc;codooooll:;,,,,,,,,;::cooddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxl               
               lkkkxxxxxxxxxxxxdlcloddddddooloooooooddddxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkxxxxxxxl               
               lxxxxxxxxxxxxxxxollloddddddddddddddddxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkxxxxxl               
               lxxxxxxxxxxxxxxdollldxddxxddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkxdddc               
               lxxxxxxxxxxxddddollldxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkxxxxkkkkkkkkkxxddc               
               lxxxxxxxxxxxxxxxollldxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxc               
               lxxxddooolllllccccc:ccllloodddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxl               
               :lc:::::::::::::,,,,;:::::;;:::cclodxxxxxxxxxxxxxxxxddddddddddddxxxxxxxxxxxxxxxl               
               ';;;;::::::::::;,',,;:::::;;;;;;;;;;coxxxxxxxxxxxxxdddddddddddddxxxxxxxxxxxxxxxl               
               cxxxxxkkkkOOOOOOko,;dxxxdddddo:.           ..''''''''..                                        
               cxxxxxkkkOOOOOOOko,;dxxxdddddoc.             ........                                          
               cxxxxkkkOOOOOOOOko,:dkxxxxddddl.           ...........                                         
               cxxkkkOOOOOOOOOOko;:xkkkxxxdddo,             ........                                          
               cxxkkOOOOOOOOOOOko,:xkkkkxxxxdd:.          ..........                                          
               cxkkkOOOOOOOOOOOko,:xkkkkkxxxxdl.          ..........                                          
               cxkkkOOOOOOOOOOOkl,ckkkkkkkxxxxd'          ..........                                          
               cxkkkOOOOOOOOOOOkl,cxkkkkkkkxxxd:.    .    ..........                                          
               ckkkOOOOOOOOOOOOkl,ckkkkkkkkkxxdl.  ...     ...........                                        
               lkOOOOOOOOOOOOOOkl,ckkkkkkkkkkxxd,.....    .',;;;;;;;;,'.                                      
               lOOOOOOOOOOOOOOOkl,ckkkkkkkkkkxxd;.....  .';;;;;;;;;;;;;,..                                    
               oOOOOOOOOOOOOOOOkl,lkkkkkkkkkkxxxc......,;;;;;;,,,,;;:::;,'.                                   
               oOOOOOOOOOOOOOOOkl,lkkkkkkkkkkxxxo....',,,,,,,,,,,,;::::::;;'..                                
               oOOOOOOOOOOOOOOOkc,lkkkkkkkkkxxxxd;..,,,,,;;;;;,,,,;::::::::;,,.                               
               oOOOOOOOOOOOOOOOkc,lkkkkkkkkkxxxxdc'',,',,;;;;;;;;;;:::::::::;;'.   ....                       
               oOOOOOOOOOOOOOOOkc,lkkkkkkkkxxxddoc,''',,,,,,,,,;;;;::::::::::;,.   ....                       
               oOOOOOOOOOOOOOOOkc,lkkkkkkkxxxddol;..'''''......'',,;::::::::::,.                              
               oOOOOOOOOOOOOOOOk:,okkkkkkxxxddool...''...       ..',,;;:::::::;..                             
               oOOOOOOOOOOOOOOkk:,okkkkkkxxddoooc......           ...',;;;::::;..                             
               oOOOOOOOOOOOOOkkk:,okkkkxxxddoool;....                ..',,;;;:;'.                             
               oOOOOOOOOOOOOOkkk:;okkkkxxxddoool'                      ...',,,,'.                             
               lOOOOOOOOOOOOOkkx:;okkkxxxxddoooc.                         .......                             
               lkkkkkOOOOOOOOkkx;;okkkxxxddoool;.                                                             
               cxxxxxkkkkkkkkkkx;;okkkxxxddoool'.                                                             
               cdddxxxxxkkkkkkkx;;okkxxxdddooo:.                                     .       ..               
               cddddddxxxkkkkkkx;;oxxxxddooool,                                      .  .......               
               cdddddddxxkkkkkkd;;oxxxdddooool.                                         .......               
               cdddddddxxxxkkkxd,;oxdddoooooo:.                                         ...                   
               cddddddddxxxxxxxo,;lddoooooooo,                                                                
               cdddddddddddddddl',loooooooool'                                                                
               cddddddddddddoooc',loooooooool.                 ..                                             
               cddoooddddooooooc';loooooooooc.            .......                                             
               cdooooddooooooooc';looooooddo;.            .......                                             
               :oooooooooooooooc';looooooooo,             .......                                             
               :oooooooooooooooc';looooooool'            ........                         ...                 
               :ooooooooooooooo:,;looooooooo'            ...'....                        .''..                
               cxxkkkkkkkkkkk:'cdddddc.              ...'''',,,.                                              
               cxxkkkkkkkkkkk:,cdddddl.                       .                                               
               lxkkkkOOOOOOkk:,lxxdddo,              .'''',,''.                                               
               lkkOOOOOOOOOkx;'lxxxddo:.                  .....                                               
               lkOOOOOOOOOOkx;'lxxxxxdl.             ..........                                               
               lkOOOOOOOOOOkk;,lxkxxxxo'              ........                                                
               lOOOOOOOOOOOkx;,lkkkxxxd;             .........                                                
               lOOOOOOOOOOOkx;,okkkkkxd:.             .......                                                 
               lOOOOOOOOOOOkx;;dkkkkkxxl..           ........                                                 
               lOOOOOOOOOOOOx;;dkkkkkxxd;.            .......                                                 
               lOOOOOOOOOOOOx,;dkkkkkkxd:.           .....                                                    
               oOOOOOOOOOOOOx,;dkkkkkkxxo.           ........                                                 
               oOOOOOOOOOOOOd,;dkkkkkxxxd,. .          ...                                                    
               oOOOOOOOOOOOOd,;dkkkkkxxxd:....        ......                                                  
               oOOOOOOOOOOOOd,;dkkkkkxxxxl.......'''..............                                            
               oOOOOOOOOOOOOd,;dkkkkkkxxxd'....',;;;;:::::::::;;;;,..                                         
               oOOOOOOOOOOOOo,;dkkkkkxxxdd:.....',;;;;::::::::::::;;,'..                                      
               oOOOOOOOOOOOkl,:xkkkkxxxdddl....,,,;;;:::::::::::::::::;,..                                    
               oOOOOOOOOOOOkl,:xkkkkxxxdddl......'''',,,;;;;::::::::::::;;,...                                
               oOOOOOOOOOOkkc,:xkkxxxxddool;.  ..    .....',;;::::::::::::::;,.          .                    
               oOOOOOOOOOOkkc,:xkkxxddddooo;.  .....'',,,,;;;;::::::::::::::::,...............                
               lOOOOOOOOOkkkc,:xkkxxdddoooo;.  ......',,,;;:;;;;;::::::::::::::;..............                
               lkkkkkkkOOkkkc,:xkkxxdddoool,. ..      ....'''''',,;;::::::::::::,.............                
               ckkkkkkkkkkkkc,:xkxxxddooooc.   .         ....'',,,,;::::::::::::,.............                
               cxxxkkkkkkkkx:,cxkxxdddooooc..           ..',',,,,,,,;;;;;:::::::,.............                
               cdxxxkkkkkkkx:,cxxxdddooool:..            ..'',,,,,,,'....',;;::;,.............                
               cddxxxkkkkkkx:,cxxddddooool,.               ..'''''...     .......  ...........                
               cdddxxkkkkkkx;,cxxddooooool'                  .....                  ..........                
               cddddxxxxxxxd;,cddooooooool.                                         ..........                
               cdddddddddddo,,cooooooooooc..                                        ..........                
               cdddddddddddl,,coooooooodd:.                                         ........;,.               
               cddoooooooool,,coooooooddd:.                                          ..':;.,,.                
               cdooooooooool,,loooooodddd;.                                            .'.                    
               :oooooooooool,,loooooddddd;.           .                                                       
               :oooooooooooc,,loooooddddo;.           .                                                       
               :oooooooooooc,,loooooooooo;.          ..                                                       
               cxxkkkkkkkkkd';l'                     ..........                                               
               cxxkkkkkkkkkd,;l,                     ........                                                 
               lkkkkkkkkkkkd,;l:.                   ..''',,,,.                                                
               lkkkkkkkkkkko';o:.                                                                             
               lkkkkkkkkkkko';oc.                   ..''''....                                                
               lkkkkkkkkkOko,;ol..                     ......                                                 
               lkkkkkkkkkkko,;ol..                  ........                                                  
               lOOOOkkkkkkko';dl.                    .......                                                  
               lOOOOkkkkkkko,:do.                   ........                                                  
               lOOOOOkkkkkkl,:dd,.                   .......                                                  
               lOOOOOkkkkkkl,:dd,..                  .....                                                    
               oOOOOOkkkkkkl,:dd:...                 ......                                                   
               oOOOOOkkkkkkl,:xxc..                  .               .....                                    
               oOOOOOkkkkkkl,:xxl..                 ......          ..',,'..              ....                
               oOOOOOkkkkkxc,:xxo..                                 ...',,,'.         ...'''''.               
               oOOOOOkkkkkxc,:xxo'.                 ......            ..'',,'..     ......'....               
               oOOOOOkkkkkxc,:xxd;.                                    ...,,;,'.. ......'.....                
               oOOOkkkkkkkk:,:dddc.                                     ...',;;,,'..'''''....                 
               oOOkkkkkkkkk;,cxddc..                                      ...'''''''''',,,'....               
               oOOkkkkkkkkx;,cxxdo,..                                      .....'''''',,,,,'''.               
               oOkkkkkkkkkx;,cxxdoc.                                        ......''''''''''''.               
               lkkkkkkkkkkx;,cxxddo,.                                        ......''''''',;;;'               
               lkkkkkkkkkkx,,cxxdddl.                                          .......'''',;;;'               
               cxxkkkkkkkkx;,cxxddo;.                                            .......''''','               
               cxxxxkkkkkkx;,cxddo;..                                        ...    .....'''','               
               cddxxxkkkkkd;,cxdo:. ....                                    .,,;'     ...',,;:,               
               cddxxxxxxxxd;,ldoc.. ...                                        ..      ...',;:,               
               cddddxxxxxxd,,coo:.  .                                                    ..,;:,               
               cddddddddddl,,col:..                                                       .,;;'               
               cdddddddodoc',lol:..                                                      .';;;'               
               cdoooooooooc',lol:..                                                      ....'.               
               cdoooooooooc',lol:'..              ..                                        ...               
               cooooooooooc',col:...              ..                                       .';'               
               :oooooooooo:';lll:..               .                                                           
               :oooooooooo:,;llc,.                .                                                           
               :oooooooooo:,;llc'.                .                                                           
               cxxxxxxxxxkx:''                                ..                                              
               cxxxkkkkxkkx:''                      ............                                              
               lkkkkkkkkkkx;''.                      ...........                                              
               lkkkkkkkkkkx;,'..                    .........                                                 
               lkkkkkkkkkxd;,'..                    ....'''''..                                               
               lkkkkkkkkkxd;,'..                                                                              
               lkkkkkkkkkxd;,'..                    ...''''''.                                                
               lkkkkkkkkkxd;,'..                                                                              
               lkkkkkkkkkxd;,'..                    ....'''..                                                 
               lkkkkkkkkkkd,;'..                       .....                                                  
               lkkkkkkkkkkd,;...                    ........                                                  
               oOkkkkkkkkkd,;...                     .......                                                  
               oOkkkkkkkkkd,;...                    .......                          ....                     
               oOkkkkkkkkkd,;...                     ......                         ..',,'...                 
               oOkkkkkkkkkd,,...                    ......                          ..',,,,'..                
               oOkkkkkkkkko,,...                    ......                           ..',,;,'..               
               oOkkkkkkkkko,'...                                                      ..',;;;'.               
               oOkkkkkkkxxo''..                     ......                             ..',;;;'               
               okkkkkkkxxxo''..                                                        ...'',;'               
               okkkkkkkxxxo''..                                                         ....''.               
               okkkkkkkxxxo',,.                                                          ......               
               lkkkkkkxxxxl',l'                                                           .....               
               lkkkkkxxxxxl,,ll..                                                          ....               
               cxxxxxxxxxxl';ooc.                  .                                         ..               
               cdddxxxxxxxc',cc;.                                                                             
               cdddxxxxxxdc''.                                                                                
               cddddxxxdd:'''                                                 .,,'.                           
               cddddddddl'.',    ....             ..                          .,,;,.                          
               cdddodddoc..''    ....             ..                            ...                           
               cdooooooo:..''                     ..                                                          
               coooooool;..'.  ..                 ..                                                          
               coooooolc'..'.   .                ...                                                          
               cooooooc;...'.                    ...                                                          
               :ooooolc'...'.                    ...                                                          
               :oooolc'. ..'.                    ..                                                           
               :ooool;.. ..'.                    ..                                                           
               lxxxxxxxxxddxxxxkxkkkkxxdddddddxxxxddddoooddxxxxxdddoooodxdddddddxxxxxxxddoooddc               
               lxxxxxxxxddddxxxxkkkkkkkddddddxkkkxxxxxddoxkkkkkkxxdooooodxxxxxxxxxxxxxxddoooodc               
               cxxxxxxxxxxxxxxxkxxxxxdddddddxxxxddoooodddddxxxxxkkxdooooodxxxkkxxxxxxxxxddooddc               
               cxxxxxxxxxkkOkxkOkkkkkxxxxxxxxxddddddoxkkkkkxdxxxdddoooooooodddxxxxxxxxxxddodddc               
               cxxxxxxxkkOkxxxkOOkkOOOOkxxxxxkkkxdddxkkkOOkxxxxxxxddoooodddxkkkOOkkOkkxdddodddc               
               cxxxxxxkkkkkxkkOOkOOOkkkxxxxxxxkxxddxkkkOOOOOkxxkkkxddoodxxkkkOOOOkxxkkxddoodddc               
               cxxkkkkxxxxxxkOOOkkkxxxxkkxxxkxxxxxdddkkOOOOxxxxxddoddooooddxkkkOOOkxddxxxdddddc               
               lkOOOOOkxxxkOOOOkxxxxxxOOkxxxxxkOOkkxdxxxxxxxxxkkxxdddoodxdddddxkOOkxdddxddxxxxc               
               lkOOOOOOkxxkkkxxxkOOkkkOOkxxxkOOOOOkkxdo:;;:clxkkkkxdooodxxddddddxkkkxdddxkOOOkl               
               lkOOOOOOkxxxxxxxxkOOOkxkkkxxxk00OOOkxoc;'''''',lxkkkxdoodxxddxxxdddxxxxdxkOO00Oo               
               lOOOOOOOkxxkxxkkxxxkxxkOkxxxxO00OOOkd:::::,,''';dkkkxooooddddxkxxddddddxk000000d               
               lkOOOOOOkxxOkxxxxkxxxkOOOxxxxxkOOOkxl;::clollc;:xkkxdoooodxxxxxxddxxdxxxk000000d               
               lkkOkkxxxxkkOkxdkOOkxkOOkxxxkkxxxxdllc:;;cllll:okkxddddooxxkkxkkxdddxkkxkO00000d               
               ckkkxxdxxdxdddddxkkkkxOOkxxxxxxxxdocolccc:c::loddddddddooxkkxxOOkxdxkOOkxkkO000d               
               cdxdxkkxxkkkxxxxdxkkkxkkxdddxxkOkkdoocccccllloddxkkxdoooodkkxkOOkdddddxxxxxxO00o               
               cdddkkkkkkkkxdkkxdxxxdddddddxkOkddolccc:cllloodddxxkxdooodxxxkOkdxxddxkkxkkkxkkl               
               cddxxkkkkkkxddxxdddddxxxddddxkkdocl::::::lloodxxdddxxxooooddddxddxkxdxkkkkOOOkxl               
               cddkkkkkkkxxdddddoooxkkkddolc;,,';l;;;::clooddxkxdoddoooooxkxdooddxxddkkkkOOOkxl               
               cdxxxxxxdddddxxxdooodxoc;'.......;l:;;clllccdxxxxxdoooooooxxxdoddxxxddxkkkkkOOxl               
               cddddxxxdddxxxxdoddooc'..........:ol::cooo,.';ldxddoddooooxxdooddkOOkxdddddxkOkl               
               cdddxkkkxddxxxxdodddl,...........:lolcccdl.....';ododxdoooxxdodkxxO00Okxxxddxxxl               
               cdxxkkkkxoodxxxodxdoc..............,:clcc'........:dddooooxdooxkOxkOO0Oxxkkkkkxl               
               cddxkkxxdooodxdoddoo:..............;::::'.........'odddooododddxOkxOOkxxxkkkOOOl               
               cdddxxdddxxdoooooodd;..............':c;;..........'oddddoooodxxxxkxkOkxxxkkkOOkl               
               cxxddddxxxxxdoooodxl'..............';:;,..........'ddddooooodkkkxdxxxkOOkxdxxxxl               
               cxxddddxxddddooddxd,................,;;,..........;dddddooodxkkOkxddxkOkkkdodxko               
               cxxxddxxxxxxxoodxxc.................',,,..........:dddddooodxkkkkxdddxxxxxdodxkl               
               cxxdddxxxxxxxoood:..................,',,..........:dddddoooodxkkxdddxkkkkxdodkko               
               cxxdddxxxxxxxoodl...................',,'..........cddddddoooodddoooodxxxxxxddxko               
               cxxdodxxxxxxdoodo.......,cl:;,''....',,'..........ldddddddddddoodddodxxxxxxdoxko               
               cddooddddddddoodd:.....'coc;,........'''.........'oddddddddddddddxdodxxxxxxdddkl               
               :ddooddxxxxxdooddo'....,lc;.... .....'''..........:dddddddddddddddddddddxxddddxl               
               :ddoodxxxxxxdooooddl;'..,'....   ......'..... ....:ddddddddddddddddodxxxxxxdddxl               
               :ddoodddxxxxdoooddddo;..........  ...,,'.....   ...coddddddddddddddodxxxxxxdddxl               
               :ddooddddxxxdoodddddo...............:c;,'.....   ..';clloodddddddddddxxxxxxxdddc               
               :oooooooddddooodddddc...............:c:,'......  ..',;;;;;:lddddddddddxxxxxxxddc               
               cxxxxxxxddddxxxxxxxkkkkxdddddddxxxxddddoooodxxxxxddooooooddddddddxxxxxxxddoooddc               
               cxxxxxxxddddddxxxkkkkkkkddddddxkkkxxxxxddoxkkkkkkxxdooooodxxxdxxxxxxxxxxddoooodc               
               cxxxxxxxddxxxxxxkxxxxddddddddxxxxddoooooddddxxxxxkkxdooooodxxxkkxxxxxxxxddoooodc               
               cxxxxxxddxxkkkxkOkkkkxxxxxxxddxddddddodxkkkkxdxxdddooooooooodddxxxxxxxxxxddodddc               
               cxxxxxxxkkOkxxxkOkkkkkOOkxxxxxkkxxdddxkkkOOkxxxxxxxddoooodddxkkkOOkkOkkxddoodddc               
               cxxxxxxkkkkxxkkOOkOOOkkkxxxxxxxxxxddxkkkkOOOOkxxxkkxdoooodxkkkOOOOkxxkkxddoodddc               
               cxxkkkkxxxxxxkOOkkkkxxxxkkxxxxdxxxxdddxkxxkkxxxxddooddooooddxxkkOOOkxddxxxdddxxl               
               ckOOOOOkxxxkOOOkkxxxxxxOOkxxxxxkOOkxddo:;;;:coxkxxddddoodddooddxkOOkxdddxddxkxxl               
               lkOOOOOOkxxkkkxxxxOOkkxOOkxxxkOOOOkxlc:'...''':xkkkxdooodxxdoddddxkkkxdddxkOOOkl               
               lkOOOOOOkxxxxxxxxkOOkkxkkxxxxkOOOOkx:;;::;,,'',dkkkxxooodxxddxxxdddxxxddxkOO000o               
               lOOOOOOOkxxxxxkkxxxkxxkOkxxxxO0O0Okd;::ccllol:;xkkkkxooooodddxkxxddddddxk000000o               
               lkOOOOOOkxxOkxxxxxxxxkOOkxxxxxkOOOdc::;;:clllclkkkkxdoooodxxxxxxddxxdxxxk000000d               
               lkkkkkxxxxxkOkxdxkkkxkOOkxxxkxxxxxlcc:cc:cc:codxkkxdddoooxkkkxxkxdddxOkxkO00000d               
               ckkkxdddddddddddxkkkxxkOkdxxxxxxxdolc:cc:clloxxddddooddooxkkxxOOkddxkOkxxkkOO00o               
               cdddxxkxxkkkxdxxdxkkxdkkxddddxkkkxocccccllloxxxxxkkxdoooodkkxkOOxddddxxxxxxxOO0o               
               cdddxkkxkkkxxdxkxddxxdddddddxkkdlcl::c::cloxdddddxxxxdooodxxdkkkddxddxkkxkkkxkkl               
               cdddxkkxkkkxddxddddddxxdddoolc;'.,c;;:::clddodxxdddxxxooooodddxddxkxdxkkkkOOOkxl               
               cddxkkkkkkxddddddoooxxdl:;'.......l:::::cl::odxxxdoddoooooxxxdooddxxddkkkkkOOkxl               
               cdxxxxxxdddddxxxdodooc'..........'oocclllo,..,cdxxdoooooooxxxdoodxxxddxkkkkkkOxl               
               cddddxxxdddxxxxdoddol'...........,looloodl'.....,cdoddooooxxdooddkOOkxdddddxkOkl               
               cdddxxxkxddxxxxdoddo:..............;:ccll'........loddooooxxdodkxxO00Okxxxdddxxl               
               cdxxkkkkxoodxxxodddo,..............:c:::,.........ldddooooddooxkOxkOO0Oxxkkkkkxl               
               cddxkkxxdooodxdoddol'..............,cc:;,.........lddddooododddxOkxOOkxxxkkkOOOl               
               cdddxxdddxxdooooood:'..............,c::;,.........lddddooooodxxxxkxkkkxxxxkkOOkl               
               cxxdddddxxxxdoooodc'...............'c:;;,........'oddddooooodkkkxddxxkOOkdddxxxl               
               cxxddddddddddooddl,................';;;;,........,dddddoooodxkkOkxddxkkkkkdodxko               
               cxxxddxxxxxxxoooo,.................';;;,'........,dddddoooodxkkkkxdddxxxxxdodxxl               
               cxxdddxxxxxxxooo;...................,,,,'........:dddddooooodxkkxddodxkkkxdodxko               
               cxxdddxxxxxxdood,...................,,,,.........oddddddooooodddoooodxxxxxdooxko               
               cxxdoddxxxxxdood;...................,,,,..........oddddddddddoooddoodxxxxxxddxko               
               cddooodddddddood,...,;:,'''.........,,,,..........:ddddddddddddddddodxxxxxxdddkl               
               :ddooodxxxxxdooo:.'ccc::;,'..........''............,oddddddddddddddoddddddddddxl               
               :odooddxxxxxdoooocllc:,'...........';;;.............'coodddddddddddoddxxxxddddxl               
               :ddooddddxxddoooddo;,..............:cc;,'............',;::cllooddddoddxxxxddddxl               
               :ddooddddxxddooddd:................:cc::,'...,oc,....',,;;:ccloddddddddxxxxxdddc               
               :oolloooodddoooddo,......'.........:cc;c;'...;dddc...',;;::cloooddddddddxxxxdddc               
               cxxxxxxxddddxxxxxxxkkkkxdddddddxxxxddddoooddxxxxxddooooooddddddddxxxxxxdddoooddc               
               cxxxxxxxddddddxxxxkkkkkkddddddxkkkxxxxxddoxkkkkkkxxdooooodxxxxxxxxxxxxxdddoooodc               
               cxxxxxxxxdxxxxxxkxxxdddddddddxxxxddoooodddddxxxxxkxxdooooodxxkkkxxxxxxxxddoooddc               
               cxxxxxxxxxxkkkxkOkkkkxxxxxxdddxdddddoodkkkkkxdxxdddoooooooodddxxxxxxxxxxddoodddc               
               cxxxxxxxkkOkxxxkOkkkkkOOkxxxxxkkxxdddddodxxkxxdxxxxddooodddxxkkkOOkkOkkxddoddddc               
               cxxxxxxkkkkxxkkOOkOOOkkkxxxxxxxxxxdddl,''',;cdxxxkxxdoooddxkkkOOOOkxxkxdddoddddc               
               cxxkkkkxxxxxxkOOkkkkxxxxkkxxxxddddd:;,'.....':xxddooddooooddxxkkOOOkxddxxxdddxxl               
               ckOOOOOkxxxkOOOkkxxxxxxOOkxxxxxkOkx;;::cc:::;:xkxxddddoodddooddxkOOkxdddxddxkxxl               
               lkOOOOOOkxxkkkxxxkOOkkkOOkxxxkOOOOo,:::lllolcckkkkkxddoodxxdoddddxkkkxdddxkOOOkl               
               lOOOOOOOkxxxxxxxxkOOOkxkkxxxxkOOOdc;::;::ccccdkkkkkkxdoodxxddxxxdddxxxddxkO0000o               
               lOOOOOOOkxxxxxkkxxxkxxkOkxxxxO0OOdcc:ccc:llcoxxkkkkkxooooodddxkxxddddddxk000000o               
               lkOOOOOOkxxOkxxxxxxxxkOOkxxxxxkOOkdlc:::ccloodxkkkkxdoooodxxxxxxddxxdxxxk000000d               
               lkkkkkxxxxxkOkxdxkkkxkOOkxxxkxxxxxoc::::cloddodxkkxdddoooxkkkxkkxdddxOkxkO00000d               
               ckkkxdddddddddddxkkkxxkkxdddddoc;:c:::clloxkxxxddddooddooxkkkxOOkddxkOkkxkkO000o               
               cdddxxkxxkkkxdxxddkkxdxxddoc:,...'c;;cccldxxxxxdxkkxooooodkkxkOOxddddxxxxxxxOO0o               
               cdddxkkxkkkxxdxxxddxxdlc;'........cl:c;:lo:loddddxxxxdooodxxdkkkddxddxkkxkkkxkkl               
               cdddxkkxkkkxddxdddddoc............cdlc;:ol..':oxdodxxxooooodddxddxkxdxkkkkOOOkxl               
               cddxkkkkkkxdodddooooc'............;lolclo:.....;ddoddoooooxxxdooddxxddkkkkkOOkxl               
               cdxxxxxxdddddxxxdool'..............;ccll:.......oxdoooooooxxxdoodxxxddxkkkkkOOxl               
               cdddddxxdodxxxxdodd;...............,clll;.......lddoddooooxxxooxdkOOkxdddddxOOkl               
               cdddxxxxxddxxxxoodl'...............'ccc:;.......oddoddooooxxdodkkxO00Okxxxddxxxl               
               cdxxkkxxxoodxxdodo'.................cc:;,......'odddddooooddddxOOxkOO0Oxxkkkkkxl               
               cddxkkxxdooodxdod;..................:c:;,......:dddddddoooddxxxxOkxOOkxxxkkkO0Ol               
               cdddxxdodxxdooooc'..................::;;,......ldddddddooooddxxxxkxkkkxxxxxkOOkl               
               cxxdddddxxxxoooo;...................;:;,'.....codddddddooooodkkkxddxxkOkxddxkxxl               
               cxxddddddddddoo;....................;:;,'.....;odddddddoooodxkkOkxddxkkkkxdodxko               
               cxxxdddxxxxxdod,....................,,,'.......,oddddddoooodxkkkkxdddxxxxxdodxxl               
               cxxddddxxxxxdod,.....,'.............',,,........,ldddddooooodxkkxdoodxkkxxdodxko               
               cxxddddxxxxxddl'.....,..........  ..'','..........,odddddoooodddoooodxxxxxxdoxko               
               cxxdoddxxxxxdl'.....'............ ...''.............:ldddddddoooddoodxxxxxxddxko               
               cddoooddddddd;......................;:;..............,cooddddddddddodxxxxxxdddkl               
               :ddooodxxxxdd,......................cc::;,'...;c'....',;;:::ccloddddddddddddddxl               
               :odooddxxxxdl'.....................'cc:cc;'...:ddoc,..,::::ccllloddoddxxxxddddxl               
               :ddoodddddxdl:;'...................'cc:cc:'...ldddddoccoddolooodddddddxxxxxdddxl               
               :ddoodddddddllccc,.................,cc:ccc,...lddddddddddddoddddddddddxxxxxxdddc               
               :oollooodddoc;',:,.................:cccllc;...ldddddddddddddddddddddddxxxxxxdddc               
               cxxxxxxdddddxxxxxxxkkkxxdddddddxxxxdddddooddxxxxdddooooooddddddxxxxxxxxdddoooddc               
               cxxxxxxdddddddxxxxkkkkkxddddddxkkxxxxxxdddxkkkkkkxxdooooodxxxxxxxxxxxxxdddoooodc               
               cxxxxxxddddxxxxxxxdddddddddddxxxddoooooddxddxxxxxxxxdooooodxkkkkxxxxxxxxddoooodc               
               cxxxxxxxxxxkkkxkOkkkkxxxxxxdddddooddolcclloxxxxxdddooooodoodddxxxxxxxxxxddoddddc               
               cxxxxxxxkkOkxxxkOkkkkkOOkxxxxxkkxdoo:''..'',oxxddxxddooodddxxkkOOOkkOkkddooddddc               
               cxxxxxxkkkkxxkkOOkOOOkkkxxxxxxxxxo;,,'''.''':xxdxkxxdoooodxkkkOOOOkxxxxxddoddddc               
               cxxkkkkxxxxxxkOOOkkkxxxxkkxxxxdddd;,::ccccc::dddddooddooooddxkkkOOOkxddxxxdddxxl               
               ckOOOOOkxxxkOOOkkxxxxxxOOkxxxxxkkd,;::clllllcdxkxxddddoodddooddxkOOkxdddxddxkxxl               
               lkOOOOOOkxxkkkxxxkOOkkxOOkxxxkOOxl;:::::cc:cdxkkkkkxddoodxxdoddddxkkkxdddxkOOOkl               
               lkOOOOOOkxxxxxxxxkOOkkxxkxxxxkOOkl:::cc:clloxxkkkkkkxdoodxxddxkxdodxxxddxOO0000o               
               lOOOOOOOkxxxxxkkxxxkxxkkxxxxxkOOkxl::::cclldxxkkkkkkxooooodddxkxxddddddxO000000o               
               lkOOOOOOkxxOkxxxxxxxxkOOkxxxxxxkxxl:::::clodddxkkkkxdoooodxxxxxxddxxdxxxk000000o               
               lkkkkkxxxxkkkkxdxkkkxkOOkxddxxoc,,c;;::cldxddodxkkxdddoooxkkkxxkxdddxOkxkO00000d               
               cxkkxddddddddddddkkkxxkkxdolc;'...::::cloxxxxxxddddoddoooxkkkxOOkddxkOkxxkkO000o               
               cdddxxkxxkkkxdxxddxkxdoc:,'.......'llccclo;cdxxdxkkxooooodkkxkOOkddddxxxxxxxOOOo               
               cdddxkkxkkkxddxxxddxdl'...........'ldl::ll..':oddxxxxdooodxxdkOkddxddkkkxkkkxkkl               
               cdddxkkxkkkxddxdooooo;.............;ll::l:....:xdodxxdooooodddxddxkxdxkkkkOOOkxl               
               cddkkkkxkxxdodddoool,...............:cc:c'....;xxdoddoooooxxxdooddxxddkkkkOOOkxl               
               cdxxxxxdddoodxxxdoo,................,cloc.....:xxxdoooooooxxxdoodxxxddxkkkkkOOkl               
               cdddddxxdodxxxxdoo;.................'cloc'....oxxxdoddooooxxdooxdkOOkxdddddxOOkl               
               cdddxxxxxodxxxdool..................'ccc:....,ddddooddooooxxdodkkxO0OOkxxxddxxxl               
               cdxxkxxxdoodxxxdo;'..................;:::'...;ddddodddooooddddxOOxkOOOOxxkkkkkxl               
               cddxkxxxdooodxdol,...................;::;'...,dddddddddoooddxxxxOkxOOkxxxkkkO0Ol               
               cdddxxdoddxdoool,....................,::,....;dddddddddooooodxxxxkxkkkxxxxxkOOkl               
               cxxdddddxxxxdol'.....................':,'....;oooddddddoooooxkkkxddxxkOkxddxkxxl               
               cxxddddddddddd:.......................,,'.....:ddddddddoooodxkkOkxddxkkkkxdodxko               
               cxxxdodxxxxxdd;.......'............ ..,,.......':dddddddooodxkkkkxdddxxxxxdodxkl               
               cxxddddxxxxxdl.....'l:'...............''.........,ldddddoooodxkkxdoodxxxxxdodxko               
               cxxdoddxxxxdo,.....co:................''...........,ldddoodoodddoooodxxxxxxooxko               
               cxxdoodxxxdd:.....;o;.................,,............;clloooddoooddoodxxxxxxdoxko               
               cddooodddddl.....;o;..................,::;'....:;...,;,;;;:coddddddoddxxxxxdddxl               
               :ddoooddddl.....'l;...................,ccc;...'dddl:lolcccclloddddddddddddddddxl               
               :odooddxxd'.....c;....................,clc;...,ddddddddddodooddddddodxxxxxxxddxl               
               :odooddddl'....;c.....................;clc:...;ddddddddddddddddddddddxxxxxxxddxl               
               :odoodddo,....;l'................ ...,:clc:'..;dddddddddddddddddddddddxxxxxxdddc               
               :ooooooooc::;;l:...............   ...::clc:'..;dddddddddddddddddddddddxxxxxxdddc               
               cxxxxxxdddddxxxxxxxkkkxxdddddddxxdddddddooddxxxxxddooooodddddddxxxxxxxxdddoooddc               
               cxxxxxxdddddddxxxxxkkkkxddddddxkxxxxxxxdddxkkkkkkxxdooooodxxxxxxxxxxxxxdddoooodc               
               cxxxxxxddddxxxxxxxdddddddddddxxxxddddoodddddxxxxxxxxdooooodxkkkkxxxxxxxxddoodddc               
               cxxxxxxxxxxkkkxkOkkkkxxxxxxxddddoolllcccoxkxxdxxdddoooooooodddxxxxxxxxxxddoddddc               
               cxxxxxxxkkOkxxxkOkkkkkOOkxxxxxkkdc,'...'';xkxxxddxxddooodddxxkkOOOkkOOkddooddddc               
               cxxxxxxkkkkxxkkOOkOOOkkkxxxxxxxlc;'.'.',,,ckkkxdxkxxdoooodxkkkOOOOkxxxxxddoddddc               
               cxxkkkkxxxxxxkOOOkkkxxxxkkxxxxdl,,;:clllol:xxxxdddooddooooddxkkkOOOkxddxxxdddxxl               
               ckOOOOOkxxxkOOOkkxxxxxxkOkxxxxxo,;::clllllldddxxxxdoddoodddooddxkOOkxdddxddxkxxl               
               lkOOOOOOkxxkkkxxxxOOkkxOOkxxxkOx:;::::cccloxxkkkkkkxddoodxxddddddxkkkxdddxkOOOkl               
               lOOOOOOOkxxxxxxxxkOOkkxxkxxxxkOd::c::::llldkkkkkkkkkxdoodxxddxkxddddxkxdxOO0000o               
               lOOOOOOOkxxxxxkkxxxkxxkkxxxxxkOkoc:::::clldxxxkkkkkkxooooddddxkkxdddddxxO000000o               
               lkOOOOOOkxxOkxxxxxxxxkOOkxxxxxxkkd:::::cloddodxkkkkxdoooodxkxxxxddxxxxxxk000000o               
               lkkkkkxxxxkkkkxdxkkkxkOOkxxxkxdo:::;;::loxxxoodxkkxddddooxkkkxxkxdddxOkxkO00000d               
               cxkkxxddddddddddxkkkxxkkxddddl:...:c:ccloxdxxxxddddodddooxkkkxOOkddxkOkxxxkO000o               
               cdxdxxxxxkkxxdxxddkkxdxxdoc:,.....'llcccld;':dxdxkkxooooodkkxkOOxdddddxxxxxxO00o               
               cdddxkkkkkkxddxkdddxxdoc;'.........;dc;:ld,..'oddxxxxdooodxxxkkkddxddxkkxkkkxkkl               
               cddxkkkxkkkxddxddddddl'.............::;coo'..'oxdodxxxooooodddxddxkxdxkkkkOOOkxl               
               cddkkkkxkxxdodddooooo:..............':cc::...,dxxdoddoooooxxxdooddxxddxkkkkOOkxl               
               cdxxxxxdddoodxxdooooc................;llc:...;xxxddoooooooxxxdoodxxxddxkkkkO0Oxl               
               cdddddxddodxxxxdoddl.................;olc:...:xxxxdoddooooxxddodxkOOkxdddddkOOkl               
               cdddxxxxxodxxxdooddc.................':ccc'..:xdddooddooooxxdodkkxO00Okdxxdxxxxl               
               cdxxkxxxdoooxxdoddc...................;:::'..:ddddodddooooddddxOOxkOO0Oxxkkkkkxl               
               cddxxxxxdooodddoo,....................,:c:'..:dddddddddoooddxxxxOkxOOOxxxkxkO0Ol               
               cdddxxdoodddoooo,.....................'':;...cdddddddddoooooxxxxxxxkkkxxxxxkOOkl               
               cxxdddddxxxxdoo,......................'.;,...loooddddddoooooxkkkxddxxkOOxddxkxxl               
               cxxdddddddddddc.......................'.,'...;oddddddddoooodxkkOkxddxkOkkxdodxko               
               cxxxdddxxxxxdo;.......................'.......,odddddddoooodxkkkkxdddxxxxxdodxkl               
               cxxddddxxxxdd:........................'.........,ldddddooooodxkkxdoodxxxxxdodkko               
               cxxdoddxxxdd:.......,............................'cooddddoooodddoooodxxxxxxddxko               
               cddooodxxddl'.....'l;............................,;:cccldddddoooddoodxxxxxxddxko               
               cddoooddddd;.....,oo,.........................'..::;,::;cddddddddddoddxxxxxdddxl               
               :ddooodddd:.....,ool......................,...:dddddolc:cdddddddddddddddddddddxl               
               :odooddxd:.....'oxd:......................,'..cddddddddodddddddddddddxxxxxxxddxl               
               :ddoodddc......cddo'......................;,.'odddddddddddddddddddddddxxxxxxddxl               
               :ddooddl'.....:ddd:.......................:;.,ddddddddddddddddddddddddxxxxxxdddc               
               :oooodd;......oddd;.......................c;.;ddddddddddddddddddddddddxxxxxxdddc               
               cxxxxxxdddddxxxxxxxkkkxxdddddddxxdddddddooddxxxxxddooooodddddddxxxxxxxxdddoooddc               
               cxxxxxxddddddxxxxxxkkkkxddddddxkxxxxxxxdddxkkkkkkxxdooooodxxxxxxxxxxxxxdddoooodc               
               cxxxxxxddddxxxxxxxdddddddddddxxxxdddoooddddxxxxxxxxxdooooodxkkkkxxxxxxxxddoodddc               
               cxxxxxxxxxxkkkxkOkkkkkxxxxxxddddoodoodxkkkkxxdxxdddoooooooodddxxxxxxxxxxdooddddc               
               cxxxxxxxkkOkxxxkOkkkkkOOkxxxxxkxool::cldkkkkxxxddxxddooodddxxkkOOOkkOOkddooddddc               
               cxxxxxxkkkkkxkkOOkOOOkkkxxxxxxdc,,''''';okkOOkxdxkxxdoooodxkkkOOOOkxxxxxddoddddc               
               cxxkkkkxxxxxxkOOkkkkxxxxkkxxxdl;'..',;:;;dkkkxxdddooddooooddxkkkO0Okxddxxxdddxxl               
               ckOOOOOkxxxkOOOkkxxxxxxkOkxxxd:,;;:llooo:lxxddxxxxdoddoodddoddxxkOOkxdddxddxkxxl               
               lkOOOOOOkxxkkkxxxxOOkkxOOkxxxxc,:::clllllodxxxkkkkkxddoodxxddddddxkkkxdddxkOOOkl               
               lOOOOOOOkxxxxxxxxkOOkkxxkxxxxkd;:::::cllloxkkkkkkkkkxdoodxxddxkxddddxkxdxO00000o               
               lOOOOOOOkxxxxxkkxxxkxxkkxxxxxkx::::::clllodxxkkkkkkkxdoooddddxkkxdddddxxO000000o               
               lkOOOOOOkxxOkxxxxxxxxkOOkxxxxxxoc::::cllodddddxkkkkxdoooodxkxxxxddxxxxxxk000000o               
               lkkkkkxxxxkkkkxdxkkkxkOOkxxxkxxxxl::::cldxxxdodxkkxddddooxkkkxxkxdddxOkxkO00000d               
               ckkkxxddddddddddxkkkxxkOkdddxddo:::::clloxdxxxxddddodddooxkkkxOOkddxkOOkxxkO000o               
               cdxdxxxxxkkxxdxxddxkxdxkxddddoc,.'c::cccld;';cddxkkxooooodkkxkOOxddddxxxxxxxO00o               
               cdddxkkkkkkxddxkdddxxddddool:'....;ll:::cd:...;odxxxxdooodxxxkkkddxddxkkxkkkxkkl               
               cdddkkkkkkkxddxddooddxxdlc;'.......co:;cld:...,ddodxxxooooodddxddxkxdxkOkkOOOkxl               
               cddkkkkkkxxdodddoooodxc,'..........,occlll,...;xxdoddoooooxxxdooddxxddxkkkkOOkxl               
               cdxxxxxdddoodxxdoooool'.............,clccc,...:xxddoooooooxxxdoodxxxddxkkkkO0Oxl               
               cddddxxxdodxxxxdooooo,...............;oc::,...:xxxdoddooooxxddodxkOOkxdddddkOOkl               
               cdddxxxxxodxxxdoodddl................':lll:...cxddooddooooxxdodkkxO00Okdxxdxxxxl               
               cdxxkkxxdoooxxdoddddc.................;::::...cdddodddooooddddxOOxkOO0Oxxkkkkkxl               
               cddxxkxxdooodxdoddol'.................,:cc:...lddddddddoooddxxxxOkxOOOxxxkxkO0Ol               
               cdddxxdoodddooooddc'..................',::,..'oddddddddoooooxxxxxxxkkkxxxxxkOOkl               
               cxxdddddxxxxdooooc....................'.::,..,oooddddddoooooxkkkxddxxkOOxddxkxxl               
               cxxddddddddddoool.....................'.';...'oddddddddoooodkkkOkxddxkOkkxdodxko               
               cxxxdddxxxxxddoo;.....................'..'....'odddddddoooodkkkkkxdddxxxxxdodxkl               
               cxxddddxxxxxdddo,.....................'........'cddddddooooddxkkxdoodxxxxxdodkko               
               cxxdoddxxxxxddd;......................'..........,lddddoooooodddoooodxxxxxxddxko               
               cxddoodxxxxxdd;......;:..........................;:clloddddddoooddoodxxxxxxddxko               
               cddooodddddddl......'oc..........................,,,;::ldddddddddddoddxxxxxdddxl               
               :ddoooddxddxd;......cdc......................'l:col:,,;lddddddddddddddddddddddxl               
               :odooddxxxxdo'.....;ddc...............'......,ddddddlldddddddddddddddxxxxxxxddxl               
               :ddoodddxxxdl.....,oxd:......................cddddddddddddddddddddddddxxxxxxddxl               
               :ddoodddddxo'....'oxdd,......................oddddddddddddddddddddddddxxxxxxdddc               
               :ooloooodddc.....:dddd'....................:'oddddddddddddddddddddddddxxxxxxdddc               
               cxxxxxxdddddxxxxxxxxkkxxdddddddxxddxdddoooddxxxxddddoooodddddddxxxxxxxxxddoooddc               
               cxxxxxxxdddddxxxxxxxkkkxddddddxxxxxxxxxdddxkkkkkkxxdooooodxxxxxxxxxxxxxxddooood:               
               cxxxxxxxdddxxxxxxxxxddxddddddxxxdddooooddxxxxxxxxxxxdooooodxkkkkxxxxxxxxddoodddc               
               cxxxxxxxxxkkkkxkOkkkkkxxxxdxddddooddddxkkOkxxdxxddddoooodooddxxxxxxxxxxxddoddddc               
               cxxxxxxkkkOkxxxkOkkkkkOOkxxxxxkkxddddxkOOOOkxxxddxxddooodddxkkkkOOkkOkxxdooddddc               
               cxxxxxxkkOOxxkkOOkOOOkkkxxxxxxxxddodxkkOOOOOOkxxxxxxdoooddxkkOOOOOkxxxxxddoddddc               
               cxxkkkkxxxxxxkOOOkkkxxxxkxxxdl:;,,,,;cxkOOOOkxxdddooddooooddxkkOOOOkxddxxxddxxxl               
               ckOOOOOkxxxkO0OOkxxxxxxOOkxo:'''''',,,lxkOkxdxxxxxddddoodddoddxxkOOkxdddxxxkkxxl               
               lOOOOOOOkxxkOkxxxkOOkkxOOkxo;,',;:lol;:dxxxxxkkkkkkxddoodxxddddddxkkkxddxxkOOOkl               
               lOOOOOOOkxxxxxxxxkOOkkxkkxxo::cclllolc:ddxxkkkkkkkkkxdoodxxddxxxdddxkkxxkOO0000o               
               lOOOOOOOkxxkxxkkxxxkxxkOxxxxc::::cccclcodddxkkkkkkkkxdoooddddxkkxdddddxxO00000Oo               
               lkOOOOOOkxxOkxxxxxxxxOOOkxxxdc::::llllloxxddddxkkkkxdoooodkkxxxxddkxxxxxk000000d               
               lkOOOkxxxxkkkkxdxOkkxkOOkxxxxoc:::cllloxxkxxdodxkkxddddooxkkkxxkxdddxOkxkO00000d               
               ckkkxxddddddddddxkkkxxkkkddxddoc:::llllxkkkkxxxddddodddooxkkkxOOkddxOOOkxkkOO00o               
               cdxdxxkxxkkkxxxxdxkkxdkkxdddxxxo:::clc:cl:::clddxxkxooooodkkxkOOkddddxxxxxxxOO0o               
               cdddkkkkkkkxddkkxdxkxddddoddxxl;:;;;c:::l;.....,cdxxxdooodxxxkOkdxxddxkkkkkkxkkl               
               cddxkkkkkkkxddxddddddxxxdoddo:..:c;;::;col'.....,odxxxooooodddxddxkxdxkOkkOOOkxl               
               cddkkkkkkxxdoddddoddxkkkdol;'....colc:cldo'......loddoooooxxxdoddxxxddkkkkOOOkxl               
               cdxxkxxxddoodxxxoooodxxd:,.......'lddolooc......'odoooooooxxxdoddxxxddxkkkkO0Oxl               
               cddddxxxdddxxxxdoddool;'..........,clclllc'.....,dddddooooxxdoodxkOOkxdddddkOOkl               
               cdddxkxxxddxxxxoodxdo,.............'clccc:'.....;ddoddooooxxdodkkxO0OOkxxxdxxxxl               
               cdxkkkxxxoodxxxoddddl...............,::ccc;.....:dddddooooddodxOOxkOOOOxxkkkOkxl               
               cddxkkxxdooodxdoddoo:................;cccc;.....cddddddoooddxxxxOkxkOOxxxkxkO0Ol               
               cdddxxdooxxdooooodddl'...............';:c:;.....:ddddddoooodxxxxkkxkkkxxxxxkOOkl               
               cxxdddddxxxxdoooddxxo,................;cc:;.....'ddddddoooooxkkkxddxxkOOxddxkxxl               
               cxxddddddddddooodxxx:.................,:::;......cdddddoooodkkkOkxddxkOkkxdodxko               
               cxxxdddxxxxxxdoodxxo..................',::;.......;ddddoooodkkkkkxdddxxxxxdodxkl               
               cxxdddxxxxxxdoooodx:..................'.;;,........lxdddoooodxkkxdoodxxxxxxddxko               
               cxxdodxxxxxxdooddoo,..................'.';,........'lddddoooodddoooodxxxxxxddxko               
               cxxdoddxxxxxdoodddl...................'..,,........,::codddddoooddoodxxxxxxddxko               
               cddooodddddddoodddc...................'...'.....'...,;;cddddddoddddodxxxxxxdddxl               
               :ddoodxxxxdddoddoo;...................'...''....lo:,;,:lddddddddddddddddddddddxl               
               :odoodxxxxxxdooodd,.......................,;'...ldddoloddddddddddddddxxxxxxxddxl               
               :odoodddxxxxdooddo'.......................':;'..lddddddddddddddddddddxxxxxxxdddc               
               :ddoodddddxxdooddo.........................::,..ldddddddddddxdddddddddxxxxxxdddc               
               :oooooooodddoooddo.........................::,..ldddddddddddddddddddddxxxxxxdddc               
               cxxxxxxxdddxxxxxxxxxkkxxdddddddxxddxdddoooddxxxxxdddoooodddddddxxxxxxxxxddoooddc               
               cxxxxxxxddddxxxxxxxxkkkxddddddxxxxxxxxxdddxkkkkkkxxdooooodxxxxxxxxxxxxxxddooood:               
               cxxxxxxxxddxxxxxxxxxddxddddddxxxdddooooddxxxxxxxxxxxdooooodxkkkkxxxxxxxxddoodddc               
               cxxxxxxxxxkkkkxkOkkkkkxxxxddddddooddddxkkOkxxdxxddddoooodooddxxxxxxxxxxxddoddddc               
               cxxxxxxkkkOkxxxkOkkkkkOOkxxxxxkkxxdddxkOOOOOkxxddxxddooodddxkkkkOOkkOkxxdooddddc               
               cxxxxxxkkOOxxkkOOkOOOkkkxxxxxxxxxxddxkkOOOOOOkxxxxxxdooodxxkkOOOOOkxxxxxddoddddc               
               cxxkkkkxxxxxxkOOOkkkxxxxkxxxxxoooddodxxkOOOOkxxdddooddooooddxkkOOOOkxddxxxddxxxl               
               ckOOOOOkxxxkO0OOkxxxxxxOOkxoc:;,,,;,:odxkOkxdxxxxxddddoodddoddxxkOOkxdddxxxkkxxl               
               lOOOOOOOkxxkOkxxxkOOkkxOOko,'''',;;,'cdddxxxkkkkkkkxddoodxxddddddxkkkxddxxkOOOkl               
               lOOOOOOOkxxxxxxxxkOOkkxkkxo;',;clllc,;dxxxxkkkkkkkkkxdoodxxddxxxdddxkkxxkO00000o               
               lOOOOOOOkxxkxxkkxxxkxxkOkxd::cclllll:;oddddxkkkkkkkkxdoooddddxkkxdddddxxO00000Oo               
               lkOOOOOOkxxOkxxxxxxxxkOOkxdc:::ccccllcldxxddddxkkkkxdoooodkkxxxxddkxxxxxk000000d               
               lkOOOkxxxxkkkkxdxOkkxkOOkxxdl::clllllloxkkkxdodxkkxddddooxkkkxxkxdddxOkxkO00000d               
               ckkkxxddddddddddxkkkxxkkkddddc::clllllxkkkkkxxxxdddodddoodkkkxOOkddxOOOkxkkOO00o               
               cdxdxxkxxkkkxxxxdxkkxdkkxddddoc::clllcclxxxxxxxdxxxxooooodkkxkOOxddddxxxxxxxOO0o               
               cdddkkkkkkkxddkkxdxkxddddoddxkd:::ccc::c:;;;;;:cldxxxdooodxxxkkkddxddxkkkkkkxkkl               
               cddxkkkkkkkxddxdddddxxxxdoddxxl:;;;:c::lc'.......,oxxxooooodddxddxkxdxkOkkOOOkxl               
               cddkkkkkkxxdoddddoddxkkkdoodo:'::;;:c::ld;........:ddoooooxxxdoddxxxddkkkkOOOkxl               
               cdxxkxxdddoodxxxdooodxkkdol;...'loc:ccldd;........'odoooooxxxdoddxxxddxkkkkO0Oxl               
               cddddxxxdddxxxxdoddddxxd:,......'lodolllo;.........cddooooxxdoodxkOOkxdddddkOOkl               
               cdddxkxxxddxxxxdodxdoo;'.........,:c::ccc;.........:ddooooxxdodkkxOOOOkxxxdxxxxl               
               cdxkkkxxxoodxxxodxddo,.............;:c:::;'........:dddoooddodxkOxkOOOOxxkkkkkxl               
               cddxkkxxdooodxdoddool..............';;:ccc,........,lddoooddddxxOkxkOOxxxkxkO0Ol               
               cdddxxdooxxdooooodddl...............'::c:;,.........'oddoooddxxxxkxkkkxxxxxkOOkl               
               cxxdddddxxxxdoooddxxo................,::::;..........ldddooodkkkxddxxxOOxddxkxxl               
               cxxddddddddddooodxxxd,................;::;'..........:xddoodkkkkkxddxkOkkxdodxko               
               cxxxddxxxxxxxdoodxxkd'................,:::;'.........,ddddodxkkkkxdddxxxxxdddxkl               
               cxxxddxxxxxxdoooodxxl.................,;:;,'..........,ddddddxkkxdoodxxxxxxddxko               
               cxxdodxxxxxxdooddodd:.................'';;,,..........'lddddodddoooodxxxxxxddxko               
               cxxdoddxxxxxdooddddd:.................'.;,,'......'.,;,:odddddodddoodxxxxxxddxko               
               cddooodddddddoodddoo'.................'..,,'......;c,,,:lddddddddddodxxxxxxdddxl               
               :ddoodxxxxxddooddooo'.................'...........'ol;:codddddddddddddddddddddxl               
               :odoodxxxxxxdooodddd..................'...,;;'.....ldolodddddddddddddxxxxxxxddxl               
               :odoodddxxxxdooddddd'.......... ..........:c:;,....cdddddddddddddddddxxxxxxxdddc               
               :ddoodddddxxdooddddd'.....................:ccc;,...;ddddddddddddddddddxxxxxxdddc               
               :oooooooooddoooddddd'...................  ,ccc:;'..;ddddddddddddddddddxxxxxxdddc               
               cxxxxxxxxxxxxxxxxxxkkkkxdddddddxxxxxxdddodddxxxxxdddooooddxddddxxxxxxxxdddddoddc               
               cxxxxxxxxxdxxxxxxxkkkkkkddddddxkkkxxxxxdddxkkkkkkxxdooooodxxxxxxxxxxxxxxddoooddc               
               cxxxxxxxxddxxkxxkxxxddxddddddxxxxdddoooddxxxxxxxxxxxdooooodxkkkkxxxxxxxxddoddddc               
               cxxxxxxxxxxkkkxkOkkkkkxxxxddddddooddddxkkOkxxdxxddddoooodooddxxxxxxxxxxxddoddddc               
               cxxxxxxkkkOkxxxkOkkkkkOOkxxxxxkkxxdddxkOOOOOkxxddxxddooodddxkkkkOOkkOkxxdooddddc               
               cxxxxxxkkOOxxkkOOkOOOkkkxxxxxxxxxxddxkkkOOOOOkxxxxxxdooodxxkkOOOOOkxxxxdddoddddc               
               cxxkkkkxxxxxxkOOOkkkxxxxkxxxxxddddddddxkOOOOkxxdddooddooooddxkkOOOOkxddxxxddxxxl               
               ckOOOOOkxxxkO0OOkxxxxxxOOkxxdolc:ccclddxkOkxdxxxxxddddoodddoddxxkOOkxdddxxxkkxxl               
               lOOOOOOOkxxkOkxxxkOOkkxOOkxo:;'''',,,;dddxxxkkkkkkkxddoodxxddddddxkkkxddxxkOOOkl               
               lOOOOOOOkxxxxxxxxkOOkkxkkxdc,''',:c:,'lxxxxkkkkkkkkkxdoodxxddxxxdddxkkxxkkO0000o               
               lOOOOOOOkxxkxxkkxxxkxxkOkxxo:::cllol:,:ddddxkkkkkkkkxdoooddddxkkxdddddxxO00000Oo               
               lOOOOOOOkxxOkxxxxxxxxkOOOxxoc:cccccll;:oxxddddxkkkkxdoooodkkxxxxddkxxxxxk000000d               
               lkOOOkxxxxkkkkxdxOkkxkOOkxxdo:;:ccclllcoxkkxdodxkkxddddoodkkkxxkxdddxOkxkO00000d               
               ckkkxxxdddddddddxkkkxxkOkxdddc::cllllloxkkkkxxxxdddodddoodkkkxOOkddxOOOkxkkOO00o               
               cdxdxkkxxkkkxxxxdxkkxdkkxddddoc::clllccoxkkxxxxddxxxooooodkkxkOOxddddxxxxxxxOO0o               
               cdddkkkkkkkkxdkkxdxkxddddoddxko:::ccc::cxxxxddddddxxxdooodxxxkkkddxddxkkkkkkxkkl               
               cddxkkkkkkkxddxxddddxkkxdoddxkkl:::cc::c:,,;,,,,,;:dxdooooodddxddxkxdxkOkkOOOkxl               
               cddkkkkkkkxddddddoddxkkkxdddddlc:;;:cc:ld,.........'ldoooodxxdooddxxddkkkkOOOkxl               
               cdxxkxxxdddddxxxdooodxkkddool;',l:;:cclod:..........;dooooxxxdoodxxxddxkkkkO0Oxl               
               cddddxxxdddxxkxdodddddxkdoc,....:ollccodd:...........cddooxxdooddkOOkxdddddkOOkl               
               cdddxkkkxddxxxxdodxdodxo;'......'cllccclo;...........'ldddxxdodkkxOOOOkdxxdxxxxl               
               cdxkkkkkxoodxxxddxdddo;...........,;:::::,............,codddodxkOxkOOOOxxkkkkkxl               
               cddxkkxxdooodxdoxdoodc.............;;:::::'.............,ldodddxOkxkOOxxxkxkO0Ol               
               cdddxxddoxxdoooooodxxc..............;:::;;'...............ldddddxxxkkkxxxxxkOOkl               
               cxxdddddxkkxdooodxxkk:..............';;:;;,...............lddkkkdddxxxOkxddxkxxl               
               cxxxdddddddddooddxxxxc...............;:;,,,...............:dxkkkkdddxkkkkxdddxko               
               cxxxddxxxxxxxdoodxxkko...............';,,,,'..............,dxkkkxxdodxxxxxdddxkl               
               cxxxddxxxxxxxoooodxxxl................,;;,,'...............odxxxxdoodxxxxxxddxko               
               cxxdddxxxxxxdooddoddoc................,,,',,...............oddddoooodxxxxxxddxko               
               cxxdodxxxxxxdoodddoodl................'',,,,'........,,;:,.odddddddodxxxxxxddxko               
               cddooodddddddoodddodo'................'.,,,,'........,;:c:.ldddddddodxxxxxxdddxl               
               :dxdodxxxxxddoodooodc.......,.........'.',,'.........';;clcdddddddddddddddddddxl               
               :ddoodxxxxxxdoooodddoc......,.............'..'.........'ldddddddddddddxxxxxxddxl               
               :ddoodxxxxxxdooodddddo,..................,::::;,........:dddddddddddddxxxxxxdddc               
               :ddooddddddddooddddddd;..................;llcc::,.......'oddddddddddddxxxxxxdddc               
               :oooooddddddooodddddddc................ .,lllcc:;'.......lddddddddddddxxxxxxdddc               
               lxxxxxxxxxxxxxxxxxxkkkkxdddddddxxxxxxdddodddxxxxxdddoooodddddddxxxxxxxxxddddoddc               
               lxxxxxxxxxdxxxxxxkkkkkkkddddddxkkkxxxxxdddxkkkkkkxxdooooodxxxxxxxxxxxxxxddoooddc               
               lxxxxxxxxddxxkxxkxxxddxddddddxxxxdddoooddxxxxxxxxkxxdooooodxkkkkkxxxxxxxddoddddc               
               cxxxxxxxxxkkkkxkOkkkkkxxxxxxddxdodddddxkOOkkxxxxddddooooddddxxxxxxxxkxxxddoddddc               
               cxxxxxxkkkOkxxxkOkkkOOOOOxxxxxkkxxddxxkOOOOOkxxxxxxddooodddxkkkOOOkkOOkxdooddddc               
               cxxxxxxkkOOkxkkOOkOOOkkkxxxxxxxxxxddxkkOOOOOOkxxxkxxdooodxxkkOOOOOkxxxxxddoddddc               
               cxkkkkkxxxxxxkOOOkkkxxxxkkxxxxxddxdddxxkOOOOkxxdddooddooodddxkkOO0Okxddxxxdxxxxl               
               lkOOOOOkxxxkO0OOkxxxxxxOOkxxxxdddllloodxkkkxxxxkkxddddooddddddxxkOOkxdddxxxkkxxl               
               lOOOOOOOkxxkOkkxxkOOkkxOOkxxxoc:,',,,;;ldxxxkkkkkkkxddoodxxddddddxkkkxddxxkOOOkl               
               lOOOOOOOOxxxxxxxxkOOkkkkkxxxdc'''',;:,';dxxkkkkkkkkkxdoodxxddxkxdddxkkxxkOO0000o               
               lOOOOOOOkxxkxxkkxxkkxxkOxxxxdl:;:clloc,,oddxkkkkkkkkxdoooddddxkxxddddxxxO000000d               
               lOOOOOOOkxxOkxxxxxxxxkOOOxxxdlccccllll:,oxddddxkkkkxdoooodkkxxxxddkkxxxxk000000d               
               lOOOOkxxxxkkOkxxxOkkxkOOkxxxkdl;;:cccll:lxkxdodxkkxddddooxkkkxxkxdddxOkxk000000d               
               ckkkxxxxddddddddxkkkxxOOkxxxxxl:::cllllloxkkxxxxxddodddoodkkkxOOkddxOOOkxkkO000d               
               cdxdxkkxxkkkxxxxdxkkxdkkxdddxxdc::cllcccdkkxxxxdxxxxdoooodkkxkOOxddddxxxxxxxOO0o               
               cdddkkkkkkkkxdkkxddkxdxdddddxkko:::clc::okkxdddddxxxxdooodxxxkOkddxddxkkkkkkkkkl               
               cddxkkkkkkkxddxxddddxkkxddddxkkdl:::cc;:ododoodddodxxxooooodddxddxkxdxkOkkOOOkkl               
               cddkkkkkkkxddddddoddxkkkxddddddoo:;;:c::ll'''',,,,,;cddoooxxxdooddxxddkkkkOOOkxl               
               cdxkkkxxdddddxxxdodddxkkxdddddoccc;;:clcld,..........;ooooxxxdoodxxxddxkkkkO0Okl               
               cddddxxxdddxxxxxodxddxkkddooc;'.,ol:cclodd,...........:doodxdooddkOOkxdddddxOOkl               
               :dddxkkkxddxxxxdoxxdddxkdo:,.....coolclldo'...........'ldddxdodkkxO0OOkdxxdxxxxl               
               :dxkkkkkxoodxxxddxdddddl,'.......':;;:::::'............'odddodxkOxkOOOOxxkkkOkxl               
               :ddxkkkxdododxdoxdoddxl'...........,::::::,.............:ddddddxOkxkOOxxxkkk00Ol               
               cdddxxdddxxdoooooodxxdc............':::;;;,..............,odddddxxxkkkxxxxxkOOkl               
               cxxdddddxxkxdooodxkkkx:.............'::c:;;'...............cdxkkdddxxxOOxddxkxxl               
               cxxxdddxxxdddooddxkkxxc..............;;;,,,'................cxkkkxddxkOkkxdddxko               
               cxkxddxxxxxxxdoodxkkkx:..............,;;;;;,................ldxxxxdodxxxxxdddxkl               
               cxxxddxxxxxxxoooodkkxd:...............,;,,,'................ldxxxdoodxxxxxxddkko               
               cxxdddxxxxxxxooddddddd:...............,,,,,,'...............;dddoooodxxxxxxddxko               
               cxxdodxxxxxxdoodxdodxx;...............,;,,,''...............,ddddddodxxxxxxddxko               
               cdddooddxddddoodddodxo'......'........,,,,,,,........,,;;'..cddddxdodxxxxxxdddko               
               :dxdodxxxxxxdoodoooool'...............,,,;,,,'.......,;:l:.'odddddddddddddddddxl               
               :dddodxxxxxxdooooddddoc'........'',,'.'',,,,'........,;:cc''oxdddddddxxxxxxxddxl               
               :ddoodxxxxxxdoooddddddoc'......';;;:,.''''.'..'........,,;cddddddddddxxxxxxxddxc               
               :ddoodxxxxxxdooddddddddoc;'....,;;;c'.'',;::c::,..........:dddxxxxxddxxxxxxxddxc               
               :ooooodddddddooodddddddddddl:'.';;;:..'.:lllccc;,.........'ddxxxxxxdddxxxxxxddxc               
               lxxxxxxxxxxxxxxxxxkkkkkxxddddddxxxxxxxddodddxxxxxdddoooodddddddxxxxxxxxdddoooddc               
               lxxxxxxxxxdxxxxxxkkkkkkkxddddxxkkkkkxxxdddxkkkkkkxxdooooodxxxxxxxxxxxxxxddoooddc               
               lxxxxxxxxddxxkxxkxxxxxxddxxxxxkxxdddoooddxxxxxxxxkxxdooooodxkkkkkxxxxxxxxdoodddc               
               cxxxxxxxxxkkkkxOOOkkkkxxxxxxxxxdddddddxkOOkkxxxxddddoooodddddxxxxxxxxxxxxdoddddc               
               cxxxxxxkkkOkxxxkOkOOOOOOkkxxxxkkxxddxxkOOOOOkxxxxxxddooodddxxkkkOOkkOOkxddoddddc               
               cxxxxxxkkOOkxkOOOOOOOkkkxxxxxxkkxxddxkkOOOOOOkxxxkxxdooodxxkkOOOOOkxxkkxddoddddc               
               cxkkkkkxxxxxkOOOOkkkxxxxkkxxkkxxxxdddxxkOOOOkxxxxddoddooodddxkkOO0Okxddxxxddxxxl               
               lkOOOOOkxxxkO0OOkxxxxxxOOkxxxxxkkkxdolodkkkxxxxkkxddddooddddddxxkOOOxdddxxxxkxxl               
               lOOOOOOOkxxkOkkxxkOOkkxOOkxxkOOOxl:;,,,;:cdxkkkkkkkxddoodxxddddddxkkkxddxxkOOOkl               
               lOOOOOOOOxxxxxxxxkOOkkxkkkxxxOOkl,'''',,,':kkkkkkkkkxdoodxxddxkxdddxkkxxkkO0000o               
               lOOOOOOOkxxkxxkkxxkkxxOOkxxxkOOkl;;::clll;;xkkkkkkkkxdoooddddxkxxdddddxxO000000d               
               lOOOOOOOkxxOkxxxxxxxxOOOOxxxxxkxcc:ccllllc;oddxkkkkxdoooodkkxxxxddkkxxxxk000000d               
               lOOOOkxxxxkkOkxxkOOOxkOOkxxxkkxxlc::clccllcododxkkxddddooxkkkxxkxdddxOkxk000000d               
               ckkkxxxxddddddddxkOOkkOOkxxxxxxxoo:::lllllloxxxxxddodddoodkkkxOOkxdxOOOkxkkO000d               
               cdxdxkkxxkkkxxxxdxkkkxkOkdddxxkOxoc::clllloxxxxdxxxxdoooodkkxkOOxddddxxxxxxxOO0o               
               cdddkkkkkkkkxdkkxdxkxddxddddkOOkddl:;c::lldxdddddxxxxdooodxxxkOkddxddxkkkkkkkkOl               
               cddxkkkkkkkkddxxddddxkkxddddxkkxdddl::::lloooodddddxxdooooodddxddxkxdxkOkkOOOkkl               
               cddkkkkkkkkxddddddddxkOOxddddddddxxo::::cllo,;:lllodddooooxxxdooddxxddkkkkOOOkxl               
               cdxkkkxxdddddxkxdddddkkkxdddddddxxdo::clccld,.....',;:clooxxxdoodxxxddxkkkkkOOkl               
               cddddxxxdddxkkxxddxddxkkxdddxkdoc::dl:ll:ldo'..........'cddxdooddkOOkxdddddxOOkl               
               :dddxkkkxddxkkxddxxdddkkxddddo:,..,odollldd:............,ddxdodkkxO0OOkdddddxxxl               
               :dxkkkkkxoodxkxddxxddxxkxdoc;'.....:c:::cll,.............lddodxkOxkOOOOxxkkkkkxl               
               :ddxkkkxdoddxxxdxdddxxxxddc..........;;;;;;'.............cdodddxOkxkOOxxxkkkO0Ol               
               cdddxxxddxxxdoooodxkxxdddo:..........;;;;;;'.............,odddddxxxkkkxxxxxkOOkl               
               cxxddddxxkkxxooodxkkOkdddo;..........';;;,,...............:ddkkkdddxxxOOxddxkxxl               
               cxxxdddxxxxxddodxxkkkkkxdo,...........;;;;;'...............oxkkkkxddxkOkkxdodxko               
               cxkxddxkkkkkxdodxxkkOkxxdo,...........';,''................:dxxxxxdodxxxxxdodxkl               
               cxxxddxxkkkkxdooodkkkxxxdo;...........';;,,'................ldxxxdoodxxxxxdddkko               
               cxxdddxxxxxxxooddddxxxxxdd:....';;....';,,'.................:dddoooodxxxxxxddxko               
               cxxdodxxxxxxxooxxdddxkkddd:..,:ccc,...',;,,'................:ddddddodxxxxxxddxko               
               cdddoodxxxxxdooxddddxkkddd:.,;;,;::...',,,,'................lddddxdodxxxxxxdddko               
               :dxdodxxxxxxxoodoodddxkddo:...,;;;'...'',,,''.....,;;;,....:ddddddddddddddddddxl               
               :dddodxxxxxxxoooodxxddddool'..........''','.......,;:cc'...odxdddddddxxxxxxxddxl               
               :ddoodxxxxxxdooodxxxddooooo:''........'..'.'.......,:cc,..;ddddddddddxxxxxxxddxc               
               :ddoodxxxxxxdoodddddddooooddddoc'.....'.'',,,,'.....,;,..cdxdddddddddxxxxxxxddxc               
               :ooooodddddddoooddddddoooodddddo,.....'.,cccc:;'........,ddxddddddddddxxxxxxddxc               
               cxxxxxxxxxxxxxxxxxkkkkkxxddddddxxxxxxdddodddxxxxxdddoooodddddddxxxxxxxxxdddooddc               
               cxxxxxxxxxdxxxxxxkkkkkkkxddddxxkkkkkxxxxddxkkkkkkxxdooooodxxxxxxxxxxxxxxddoooddc               
               cxxxxxxxxxxxxkxxkxxxxxxddxxxxxkxxdddoodddxxxxxxxxxxxdooooodxxkkkxxxxxxxxxddodddc               
               cxxxxxxxxxxkkkxOOOkkkkxxxxxxxxxdddddddxkkOkkxxxxddddoooodddddxxxxkxxxxxxxddodddc               
               cxxxxxxkkkOkkxxkOkOOOOOOkkxxxxkkkxddxxkOOOOOkxxxxxxddooodddxxkkkOOkkOOkxddoddddc               
               cxxxxxxkkOOkxkOOOOOOOkkkxxxxxxxkkxddxkkOOOOOOkxxxkxxdooodxxkkOOOOOkxkkkxddoddddc               
               cxkkkkkxxxxxkOOOOkkkxxxxkkxxkkxxxxddddxxxkOOkxxxxddoddooodddxkkOO0Okxddxxxddxxxc               
               lkOOOOOkxxxkO0OOkxxxxxxOOkxxxxxkOkxl:;,,,;:odxxkkxxdddooddddddxxkOOkxdddxxxxkxxl               
               lOOOOOOOkxxkOkkxxkOOkkxOOkxxkOOOkxl,''',,;,,lkkkkkkxddoodxxdddxddxkkkxddxxkOOOkl               
               lOOOOOOOOxxxxxxxxkOOkkxkkkkxkkOOkdl;:::lloc,:kkkkkkkxdoodxxddxkxdddxkkxxkOO000Oo               
               lOOOOOOOkxxkxxkkxxxkxxOOkxxxkO00Oxcccccllll::xkkkkkkxdoodddddxkxxdddddxxO000000d               
               lOOOOOOOkxxOkxxxxkxxxOOOOxxxxxkOOkl:::ccccllcdxkkkkxdoooodkkxxxxddkxxxxxk000000d               
               lOOOOkxxxxkkOkxxkOOOxkOOkxxxkkxkkkdl::clllloodxxkkxddddooxkkkxxkxdddxkkxkO00000d               
               ckkkxxxdddddddxdxkOOkkOOkxxxkxxxxxdo::clllloddxxxddodddooxkkkxOOkddxkOOkxkkO000d               
               cdxxxkkxxkkkxxxxdxkkkxkOkdddxxkOkkdolccllllodxxdxxkxdoooodkkxkOOxddddxxxxxxxOO0o               
               cddxkkkkkkkkxdkkxddkxddxddddkOOkxdddolc:ccloooodxxxxxdooodxxdkOkddxddxkkkkkkxkkl               
               cddxkkkkkkkxddxxddddxkkxddddxkkxdddxdl::ccllo:',:cloddooooddddxddxkxdxkOkkOOOkxl               
               cddkkkkkkkkxddddddddxkOOxddddddddxxxdo::ccccdc.......',:codxxdooddxxddkkkkOOOkxl               
               cdxkkkxxdddddxkxdddddkkkxddddddddxo:cdllc:ldo,...........,oxxdoodxxxddxkkkkkOOkl               
               cddddxxxdddxkkxxddxddxkkxdddxxdlc;'.,oooccod:.............:xdooddxOOkxdddddxkOkl               
               cdddxkkkxddxkkxddxxdddkkxdddxo:'.....::c:::;..............,ddodxxxOOOOkdddddxxxl               
               cdxkkkkkxdodxkxddxdddxxkxdddo'........';::;,...............ldodkkxkOOOOxxkkkkkxl               
               cddxkkkxdoddxxxdxxddxxxxdddxl.........';;:;'...............;dddxOkxkOOxxxkkkO0Ol               
               cdddxxxddxxxdoooodxxxxdddddxl.........';;;;'...............'odddxxxkkkxxxxxkOOkl               
               cxxddddxxkkxdooodxkkOkxdddddl..........,;;,.................cxkkdddxxxOOxdddkxxl               
               cxxxdddxxxxxddodxxxkkkkxdddxd'.........',;,.................,xkkxdddxkkkkxdodxko               
               cxkxddxkkkkkxdooxxkkOkkxdddxd,.........',,,..................cxxxxdodxxxxxdodxkl               
               cxxxddxkkkkkxdooodkkkxxxddddd,.........'',,'',;,'............'oxxdoodxxxxxxddkOo               
               cxxdddxxxxxxxooddddxxxxxddddd:.........'',,',;;:cc,..........,dxdooodxxxxxxddxko               
               cxxdodxxxxxxxoodxdddxkkxddollc,..........'''',;:ccc'.........cxddddodxxxxxxddxko               
               cdddoodxxxxxdoodddddxkkxddlccc;..........'''...;:cc'........'odddddodxxxxxxdddkl               
               :dxdodxxxxxxdoodoodddxkddol:::,..........................',:oxddddddddddddddddxl               
               :dddodxxxxxxxdooodxxddddooo:,,................... ......codddddddddddxxxxxxxddxl               
               :ddoodxxxxxxdoooddxxddoooool:::::'.......,;::;'.........lddddddddddddxxxxxxxdddc               
               :ddoodxxxxxxdoodddddddooooddddddo;,.....':ccc:,.........:ddddddddddddxxxxxxxdddc               
               :oooooddddddoooooddddoooooddddddoc,.....':ccc:,.........;dddddddddddddxxxxxxdddc               
               cxxxxxxxxxxxxxxxxxkkkkkxxddddddxxxxxxdddodddxxxxxdddooooddddoddxxxxxxxxxdddooddc               
               cxxxxxxxxxdxxxxxxkkkkkkkxddddxxkkkkkxxxxddxkkkkkkxxdooooodxxxdxxxxxxxxxxdddooddc               
               cxxxxxxxxxxxxkxxkxxxxxxddxxxxxkxxddddooddxxxxxxxxxxxdooooodxxkkkxxxxxxxxxddodddc               
               cxxxxxxxxxxkkkxOOOkkkkxxxxxxxxxddddddodkkkkxxxxxddddoooodddddxxxxkxxxxxxxddodddc               
               cxxxxxxkkkOkkxxkOkOOOOOOkkxxxxkkkxddddoolcclodxxxxxddoooddddxkkkOOkkOOkxddoddddc               
               cxxxxxxkkOOkxkOOOOOOOkkkxxxxxxxkkxdddc,''''';:oxxkkxdooodxxkkkOOOOkxkkkxddoddddc               
               cxkkkkkxxxxxkOOOOkkkxxxxkkxxkkxxxxddo;,,,,;;;,;dddooddooodddxkkOO0Okxddxxxddxxxc               
               lkOOOOOkxxxkO0OOkxxxxxxOOkxxxxxkOOkdc:cclllll:;xxxxdddoodddddddxkOOkxdddxxxxkxxl               
               lOOOOOOOkxxkOkkxxkOOkkxOOkxxkOOOOOkxc:::cllllcckkkkxdooodxxddddddxkkkxddxxkOOOkl               
               lOOOOOOOOxxxxxxxxkOOkkxkkkxxkkO00OOkol:::clclllxxkkkxdoodxxddxxxdddxkkxxkOO0000o               
               lOOOOOOOkxxkxxkkxxxkxxOOkxxxkO00OOOkoo:::clllloxxkkkxooooddddxkxxdddddxxkO00000o               
               lOOOOOOOkxxOkxxxxkxxxOOOOxxxxxkOOOOkdoc::clllodkxkkxdoooodxxxxxxddkxdxxxk000000d               
               lOOOOkxxxxkkOkxxkOOOxkOOkxxxkkxkkkxxddl::clllodxkkxdddooodxkkxxkxdddxkkxkO00000d               
               ckkkxxxdddddddxdxkOOkkOOkxxxxxxxxxddxkdc::cllll;lddodxdoodxkxxOkkddxkOkkxxkO000d               
               cdxxxkkxxkkkxxxxdxkkkxkOkdddxkkOkkddxxoccccccoc...,;;::cloxxdxkkxdodddxxxxxxOO0o               
               cddxkkkkkkkkxdkkxddkxddxddddkOOkxdoddol:cc:cod:...........;ddxkxdddodxkkxkkkxkkl               
               cddxkkkkkkkxddxxddddxkkxddddxkkxdddl;:l:::codc'............cddddoxkddxkkkkOOOkxl               
               cddkkkkkkkkxddddddddxkOOxdddddddoc;..'l::ccl:'.............,ddooodddddxkkkOOOkxl               
               cdxkkkxxdddddxkxdddddkkkxdddddl;'.....'cc::;'...............ldooodxddddxxkkkOOkl               
               cddddxxxdddxkkxxddxddxkkxdddxx:.......'lc::;................;oddodkOkxdddddxkOkl               
               cdddxkkkxddxkkxddxxdddkkxdddxx:........c::;,.................:ddddkOOOkddddddxxl               
               cdxkkkkkxdodxkxddxdddxxkxdddxxc........;;;;;;;,'..............;oddxOOOOxxkkkkkxl               
               cddxkkkxdoddxxxdxdddxxxxxddxxdl........,,;;ccccc:'.............,odxkkkxdxkkkOOkl               
               cdddxxxddxxxdoooodxxxxdddddxxdo........,',',:cccc:'.............'odxkxxxxxxkOOkl               
               cxxddddxxkkxdooodxkkOkxddddddxx,.......,','.',;:cc'..............ldddxkkxdddkxxl               
               cxxxdddxxxxxddodxxkkkkkxddddxkx;.......,''......''...............loodxkkkxdodxko               
               cxkxddxkkkkkxdooxxkkOkkxddddxkkc.......,''....... ..,,..........,ooodxxxxxdodxkl               
               cxxxddxkkkkkxdooodkkkxxxddddddxc.......,'....................',:odoodxxxxxxddkOo               
               cxxdddxxxxxxxooddddxxxxxddoolc:'.......'................'oodddxdddoodxxxxxxddxko               
               cxxdodxxxxxxxoodxdddxkkdolc:;..........'................;ddddddddddodxxxxxxddxko               
               cdddoodxxxxxdoodddddxkkdlllc:'.........,','.............,odddddddddddxxxxxxdddkl               
               :dxdodxxxxxxdoodoodddxkddlcc:'..;:;....,,;,'.............lddddddddddddddddddddxl               
               :dddodxxxxxxxdooodxxdddddoc:::lddl.....,;;;'.............cdddddddddddxxxxxxxddxl               
               :ddoodxxxxxxdoooddxxddooooooddxdc,.....,;;;,.............cdddddddddddxxxxxxxdddc               
               :ddoodxxxxxxdoodddddddoooooddxxl'......;;;;,.............;dddddddddddxxxxxxxdddc               
               :oooooddddddooooodddddoooooddddl.......;;::;.............,dxddddddddddxxxxxxdddc               
               cxxxxxxxxxxxxxxxxxkkkkkxxddddddxxxxxxdddooddxxxxxdddooooddddoddxxxxxxxxxdddooddc               
               cxxxxxxxxxdxxxxxxkkkkkkkxddddxxkkkkkxxxdddxkkkkkkxxdooooodxxxdxxxxxxxxxxddoooddc               
               cxxxxxxxxxxxxkxxkxxxxxxddxxxxxkxxddddoooooooxxxxxxxxdooooodxxkkkxxxxxxxxxddodddc               
               cxxxxxxxxxxkkkxOOOkkkkxxxxxxxxxdddddool:;;,',codddddoooodooddxxxxkxxxxxxxddodddc               
               cxxxxxxkkkOkkxxkOkOOOOOOkkxxxxkkkxdddo:'''''',,cdddddoooddddxkkkOOkkOOkxddoddddc               
               cxxxxxxkkOOkxkOOOOOOOkkkxxxxxxxkkxxddl:::::cc:,,dkxxdooodxxkkkOOOOkxkkkxddoddddc               
               cxkkkkkxxxxxkOOOOkkkxxxxkkxxkkxxxxxdo:ccccllll:;odooddooodddxkkOOOOkxddxxxddxxxc               
               lkOOOOOkxxxkO0OOkxxxxxxOOkxxxxxkOOOkdlc;:clccl:cxddoddoodddddddxkOOkxdddxxxxkxxl               
               lOOOOOOOkxxkOkkxxkOOkkxOOkxxkOOOOOOkooc::cllllcoxkkxdooodxxddddddxkkkxddxxkOOOkl               
               lOOOOOOOOxxxxxxxxkOOkkxkkkxxkkO00OOkxoc::cllllodxkkxxdoodxxddxkxdddxxkxxkOO0000o               
               lOOOOOOOkxxkxxkkxxxkxxOOkxxxkO000OOOkxl:::lllldxxxxxxooooddddxkxxdddddxxk000000o               
               lOOOOOOOkxxOkxxxxkxxxOOOOxxxxxkOOOOkddoccclllloxxxxxdoooodxxxxxdddkxdxxxkO00000d               
               lOOOOkxxxxkkOkxxkOOOxkOOkxxxkkxkkkxddddc::cllo;,cooodddoodxkxdxkxdddxkkxkO00000d               
               ckkkxxxdddddddxdxkOOkkOOkxxxxxxxxddddxdc::ccld;...'',;::coxxxxkkkdddkOkkxxkO000d               
               cdxxxkkxxkkkxxxxdxkkkxkOkdddxkkkkdollddccccodl'...........;ddxkkxoodddxxxxxxOO0o               
               cddxkkkkkkkkxdkkxddkxddxddddkOkxdl;''ooc:codl'.............odxkxdddodxkxxxkkxkkl               
               cddxkkkkkkkxddxxddddxkkxddddxko:,'...;:::cc:'..............;odddoxxdddxkkkOOOkxl               
               cddkkkkkkkkxddddddddxkOOxddddo'.......,::::;................ldooodddodxkkkkOOkxl               
               cdxkkkxxdddddxkxdddddkkkxddddl........'cl;;'................'ldoodxddddxxkkkOOkl               
               cddddxxxdddxkkxxddxddxkkxdddxd'.......'ll;;...................;lodkkxxdddddxkOkl               
               cdddxkkkxddxkkxddxxdddkkxdddxd,.......'::;,,:ccc:'.............':okkOOkddddddxxl               
               cdxkkkkkxdodxkxddxdddxxkxdddxd;........;,,'.;:ccc:,...............okOOkxxkkkkxxl               
               cddxkkkxdoddxxxdxdddxxxxxddxxd;........;,,..';::ccc...............ckkxxdxkxkOOkl               
               cdddxxxddxxxdoooodxkxxdddddxddl'.......,,'......';;...............;xxxdxxxxkOOkl               
               cxxddddxxkkxdooodxkkOkxddddddxd,.......,,'............''..........;ddxkkxdddkxxl               
               cxxxdddxxxxxddodxxkkkkkxddddxkd;...,...,,'......................,coodxkkkxdodxko               
               cxkxddxkkkkkxdooxxkkOkkxxdddxxl'.......,'...............coolodddxxooddxxxxdodxkl               
               cxxxddxkkkkkxdooodkkkxxxddolc:'........,'...............ldddddxxddoodxxxxxxddkOo               
               cxxdddxxxxxxxooddddxdxxxddllc:'........'................cdddddddddoodxxxxxxddxko               
               cxxdodxxxxxxxoodxdddxkkxxdoclc,..''...','...............;ddddddddddodxxxxxxddxko               
               cdddoodxxxxxdoodddddxkkxddolcccldo,...,;'................ldddddddddddxxxxxxdddkl               
               :dxdodxxxxxxdoodoodddxkdddoodooooc....,;'................cddddddddddddddddddddxl               
               :dddodxxxxxxxdooodxxddddooooodddo;...';;'................:dddddddddddxxxxxxxddxl               
               :ddoodxxxxxxdooodxxxddooooooddddl,...,;;'................,dddddddddddxxxxxxxdddc               
               :ddoodxxxxxxdoodddddddoooooddxxo,....;;;,.................oddddddddddxxxxxxxdddc               
               :oooooddddddoooooddddooooooddddl.....;:;,.................ldddddddddddxxxxxxdddc               
               lxxxxxxxxxxxxxxxxkkkkkkxxddddddxxxxxxdddooddxxxxddddooooddddodddxxxxxxxxddoooddc               
               lxxxxxxxxxdxxxxxxkkkkkkkxdddddxkkkkxxxxdddxkkkkkxxxdooooodxxxdxxxxxxxxxxddoooddc               
               lxxxxxxxxxxxxkxxkxxxxxxddxxxxxxxxddddoooolllldxxxxxxdooooodxxxxkxxxxxxxxddoodddc               
               lxxxxxxxxxxkkkxkOOkkkkxxxxxxxxxddddddodc,,,'',:lddddoooodoooddxxxxxxxxxxxdoddddc               
               lxxxxxxkkkOkkxxkOkOOOOOOOkxxxxkkkxddddl;'''''',;cxxddooodddxxkkkOOkkOOkxddoddddc               
               lxxxxxxkkOOkxkkOOOOOOkkkxxxxxxxkkxdddlcccccclc:'cxxxdooodxxkkkOOOOkxxkkxdddddddc               
               lxkkkkkxxxxxkOOOOkkkxxxxkkxxkkxxxxxddccc:cllllc;cdooddooodddxkkOOOOkxddxxxddxxxl               
               lkOOOOOkxxxkO0OOkxxxxxxOOkxxxxxkOOkkdol:::cl:cl:dxdoddoodddddddxkOOkxdddxxxxkxxl               
               lOOOOOOOkxxkOkkxxkOOkkxO0kxxkOOOOOOkdol:::clllllxkkxdooodxxddddddxkkkxddxxkOOOkl               
               lOOOOOOOOxxxxxxxxkOOOkxkkkkxxOO0OOOOxdl:::llllodxkkxxooodxxddxxxdddxxkxxkOO0000o               
               lOOOOOOOkxxkxxkkxxxkxxOOkxxxkO0OOOOOkxlc::clloxxkkxxxooooddddxkxxdddddxxkO00000o               
               lOOOOOOOkxxOkxxxxkxxxOOOOxxxxxkOOOOkxdlc::clloxxxxxxdoooodxxxdxdddkxdxxxk000000d               
               lOOOOkxxxxkkkkxxkOOOxkOOkxxxkkxxkkxddol:::cllc,cdxxdodooodxkxdxkxdddxkkxkO00000d               
               lkkkxxxxxddddxxdxkOOkkOOkxxxxxxxxdoodo::::clo:'.',;;clllodxkxxkkkddxkkkkxxkO000d               
               cdxdxkkxxkkkxxxxdxkkkxkOkdddxxxol:;cdoccllodl'..........'cxxdxkkxoodddxxxxxxOO0o               
               cddxkkkkkkkkxdkkxddkxddxddddo:;'...:ll::lodl'.............oddxkxdddodxxkxxkkxkkl               
               cddxkkkkkkkkddxxddddxkkxdddd:.......':::c::'..............;oddddoxxdddxkkkOOOkxl               
               cddkkkkkkkxxddddddddxkOOxddd;.......';:::;,................lxdooodddodxkkkOOOkxl               
               cdxkkkxxdddddxkxdddddkkkxddo,.......';lc;;'................;dddoodxddddxxkkkOOxl               
               cddddxxxdddxkkxxddxddxkkxdoo'........,lc;,..................,lodddkkxxdddddxkOkl               
               cdddxkkkxddxkkxddxxdddkkxddo'.......';c:,'...,;;;,'...........,cddkOOOkddddddxxl               
               cdxkkkkkxoodxkxdxxdddxxkxddo,.......',;;;'...,::cc:'............'lxkOOkxxkkkkkxc               
               cddxkkkxdoodxxxdxxddxxxxdddx:.......',;,'.....,::ccc,............;dkkkxdxkkkOOkl               
               cdddxxxddxxxdoooodxkxxdddddd:.......';;;'......'',:c;............,dxkxdxxxxkOOkl               
               cxxddddxxkkxxooodxkkOkxddddo;....',.',,;'...............'........'oddxkkxdddkxxl               
               cxxxdddxxxxxddodxxkkkkkxdddo;';lll;'',;;'.......... ...........';loodxkkkxdodxko               
               cxkxddxkkkkkxdooxkkkOkkxdddd:,::;;;'',;'................:lccloddxxoodxxxxxdddxxl               
               cxxxddxkkkkkxdooodkkkxxxddddo;,;;;,..,;'................ldddddxxdooodxxxxxxddkOo               
               cxxdddxxxxxxxdoddddxxxxxdddddd:'''...',.................cdddddddddoodxxxxxxddxko               
               cxxdodxxxxxxxooxxdddxkkxdddxxxdlll..',,'................;ddddddddddodxxxxxxddxko               
               cdddoddxxxxxdoodddddkkkxdddxkxxooc..;:;'.................lddddddddddddxxxxxdddko               
               :dxdodxxxxxxxooddodddxkxdddxxddol,..:::,.................:ddddddddddddddddddddxl               
               :dddodxxxxxxxdooodxxdddddddddoddc,..:c:;.................;dddddddddddxxxxxxxddxl               
               :ddoodxxxxxxdooodxxxddoooooodddo:,..:c:c;................'dddddddddddxxxxxxxddxc               
               :ddoodxxxxxxdoodddddddoooooddddo;...:c:c:.................oddddddddddxxxxxxxdddc               
               :oooooddddddooooodddddoooooddddo'...:c:cc'................cdddddddddddxxxxxxdddc               
               lxxxxxxxxxxxxxxxxkkkkkkxxddddddxxxxxxdddooddxxxxddddooooddddodddxxxxxxxxddoooddc               
               lxxxxxxxxxdxxxxxxkkkkkkkxdddddxkkkkxxxxdddxkkkkkxxxdooooodxxxdxxxxxxxxxxddoooddc               
               lxxxxxxxxxxxxkxxkxxxxxxddxxxxxxxxddddooooddxxxxxxxxxdooooodxxkxkxxxxxxxxddoodddc               
               lxxxxxxxxxxkkkxkOOkkkkxxxxxxxxxddddddool::;;;codxdddoooodooddxxxxxxxxxxxddoddddc               
               lxxxxxxkkkOkkxxkOkOOOOOOOkxxxxkkkxddddo;'''''',cdxxddooodddxxkkkOOkkOOkxdooddddc               
               lxxxxxxkkOOkxkkOOOOOOkkkxxxxxxxkkxxddoc;;;;::;,'lxxxdooodxxkkkOOOOkxxkkxdddddddc               
               lxkkkkkxxxxxkOOOOkkkxxxxkkxxkkxxxxxdo:ccccllol:,ldooddooodddxkkOOOOkxddxxxddxxxl               
               lkOOOOOkxxxkO0OOkxxxxxxOOkxxxxxkOOOkdlc:::ccclc:dxdoddoodddddddxkOOkxdddxxxxkxxl               
               lOOOOOOOkxxkOkkxxkOOkkxO0kxxkOOOOOOkloc:::clclldkkkxdooodxxddddddxkkkxddxxkOOOkl               
               lOOOOOOOOxxxxxxxxkOOOkxkkkkxxOOOOOOOdoc:::llllldxkkxxooodxxddxxxdddxxkxxkOO0000o               
               lOOOOOOOkxxkxxkkxxxkxxOOkxxxkO0OOOOOkxc:::lllodxxkxxxooooddddxkxxdddddxxkO00000o               
               lOOOOOOOkxxOkxxxxkxxxOOOOxxxxxkOOOOxddlc:cllldxxxxxxdoooodxxxdxdddkxdxxxk000000d               
               lOOOOkxxxxkkkkxxkOOOxkOOkxxxkkxxkkxddl:::cclloddxxxdodoooxxkxdxkxdddxkkxkO00000d               
               lkkkxxxxxddddxxdxkOOkkOOkdxxxxxxxdodocc::cclo,;coooooddoodxkxxkkkddxkkkkxxkO000d               
               cdxdxkkxxkkkxxxxdxkkkxkkxddddddl:;:ddlcc::odl'...',::looodxxxxkkxoodddxxxxxxOO0o               
               cddxkkkkkkkkxdkkxddkxddxdddlc;'...,ooc:cldxl'..........,cddxdxkxdddodxxkxxkkxkkl               
               cddxkkkkkkkkddxxddddxkkxddd,.......,:::clll,............'oddddddoxxdddxkkkOOOkxl               
               cddkkkkkkkxxddddddddxkkOxdl'........,::c:c;..............cdddoooodxdodxkkkOOOkxl               
               cdxkkkxxdddddxkxdddddkkkdol.........,:lc:;'..............'ddxoooodxddddxxkkkOOxl               
               cddddxxxdddxkkxxddxddxkkdo:.........,cl;;;...............'oddooddxOkxxdddddxkOkl               
               cdddxkkkxddxkkxddxxdddxkdo:.........,::;;'................:ddooxxxOOOOkddddddxxl               
               cdxkkkkkxoodxkxdxxddddxxdo:..........,;;;'....,,,,'........:oddxkxkOOOkxxkkkkkxc               
               cddxkkkxdoodxxxdxxddxxxxdo:..........,;,'.....,::cc:........'cddkxxkkkxdxkkkOOkl               
               cdddxxxddxxxdoooodxkxxdddo;..........';;'......,;ccc;.........;odxdxkxxxxxxkOOkl               
               cxxddddxxkkxxooodxkkOkxddo,..........';,........',;c:..........ldodddxkkxdoxkxxl               
               cxxxdddxxxxxddodxxkkkkkxdd:'...,;;;;;';;.......................lxddddxkkkxdodxko               
               cxkxddxkkkkkxdooxkkkOkkxddo,..'';;;;:';'........... ....'......cxxooddxxxxdodxxl               
               cxxxddxkkkkkxdooodkkkxxxdddc'...';;,,.;'....................';ldddoodxxxxxxddkOo               
               cxxdddxxxxxxxdoddddxxxxxdddddl:'......,.................oddddxddddoodxxxxxxddxko               
               cxxdodxxxxxxxooxxdddxkkxdddxkxdl,.....'.................oddddddddddodxxxxxxddxko               
               cdddoddxxxxxdoodddddkkkxdddxkxdl;'....,.................lddddddddddddxxxxxxdddko               
               :dxdodxxxxxxxooddodddxkxdddxxddc'.....,.................:dddddddddddddddddddddxl               
               :dddodxxxxxxxdooodxxdddddoooodd:......,.................,ddddddddddddxxxxxxxddxl               
               :ddoodxxxxxxdooodxxxddooooooodd,.....,;'................'ddddddddddddxxxxxxxddxc               
               :ddoodxxxxxxdoodddddddooooodddd,.....;:;................'odddddddddddxxxxxxxdddc               
               :oooooddddddooooodddddooooodddo,.....:::................'oddddddddddddxxxxxxdddc               
               lxxxxxxxxxxxxxxxxkkkkkkxxddddddxxxxxxdddooddxxxxddddooooddddodddxxxxxxdddooooddc               
               lxxxxxxxdxxxxxxxxkkkkkkkxdddddxkkkkxxxxdddxkkkkkxxxdooooodxxxdxxxxxxxxdddooooddc               
               lxxxxxxxxdxxxkxxkxxxxxxddxxdxxkxxdddoooddxdxxxxxxxxxdooooodxxkkkxxxxxxxxddoodddc               
               lxxxxxxxxxxkkkxkOOkkkkxxxxxxxxxdddddoooodddddxxxddddoooodooddxxxxxxxxxxxddoddddc               
               lxxxxxxkkkOkkxxkOkOOOOOOOkxxxxkkkxdddl;,,,,;cddddxdddooodddxkkkkOOkkOkxddooddddc               
               lxxxxxxkkOOkxkkOOOOOOkkkxxxxxxxkkxddo;'''''',;odxxxddooodxxkkkOOOOkxxxxddooddddc               
               lxkkkkkxxxxxkOOOOkkkxxxxkkxxxkxxxxdlc::cc:cc;,ldddooddooodddxkkOOOOkxddxxxddxxxl               
               lkOOOOOkxxxkO0OOkxxxxxxOOkxxxxxkOkxc:c:cllool;lxxxdoddoodddddddxkOOkxdddxxxxkxxl               
               lOOOOOOOkxxkOkkxxkOOkkxO0kxxkOOOOOxoc:::cl:cl:dkkkkxdooodxxddddddxkkkxddxxkOOOkl               
               lOOOOOOOOxxxxxxxxkOOOkxkkkkxkkOOOOoll:::clllloxkkkkxxooodxxddxxxdddxxkxxkOO0000o               
               lOOOOOOOkxxkxxkkxxxkxxOOkxxxkOOOOOxdl:::clllldxkkkkkxooooddddxkxxdddddxxkO00000o               
               lOOOOOOOkxxOkxxxxkxxxOOOOxxxxxkOOOkxoc::cllodxxxxkkxdoooodxxxdxdddkxdxxxk000000d               
               lOOOOkxxxxkkkkxxkOOOxkOOkxxxkkxxkkdolc:ccllodddxxxxdodoooxxkxdxkxdddxkkxkO00000d               
               lkkkxxxxxddddxxdxkOOkkOOkxxxxxxxxdooc::cccllldddddoodddoodxkxxkkkddxkkkkxxkO000d               
               cdxdxkkxxkkkxxxxdxkkkxkkxdddxxxolcolccccccll';:codddooooodxxxxkkxoodddxxxxxxOO0o               
               cddxkkkkkkkkxdkkxddkxddxdooll:,'.,ool::clod:.....,:loooooddddxkxdddodxxkxxkkxkkl               
               cddxkkkkkkkkddxxddddxkkxo:,'.....,ooo:;codc'........':loooodddddoxxdddxkkkOOOkxl               
               cddkkkkkkkxxddddddddxkkkl.........';::;clc'...........'lodddxoooodxdodxkkkkOOkxl               
               cdxkkkxxdddddxkxdddddkkkc..........;;:c::,.............cddxxxooodxxddddxxkkkOOxl               
               cddddxxxdddxkkxxddxddxkk,..........,;:l:;..............,dddddooddxOkxxdddddxkOkl               
               cdddxkkkxddxkkxddxxdddxk,..........;:::;,..............,dddddodxxxOOOOkddddddxxl               
               cdxkkkkkxoodxkxdxxdddxdd,..........,;;;,...............'ddddoodkkxkOOOkxxkkkkkxc               
               cddxkkkxdoodxxxdxxddxxdo'..........';;;,.......'........ldddddddkxxkkkxdxkxkOOkl               
               cdddxxxddxxxdoooodxkxxdc............,;,.......,:::;.....:ddoddddxxdxkxxxxxxkOOkl               
               cxxddddxxkkxxooodxkkOkdc............';'.......,::cc'....;ddodxkxdddddxkkxdoxkxxl               
               cxxxdddxxxxxddodxxkkkkxc............',,........;:cc'....'oddxxkkxddddxkkkxdodxko               
               cxkxddxkkkkkxdooxkkkOkxl'...........','.........,;,......ldxxxxxxxoddxxxxxdodxxl               
               cxxxddxkkkxxxdooodkkkxdd:...........','.................;dddddxxddooxxxxxxdddkOo               
               cxxdddxxxxxxxooddddxxxxdc..,ccc;.....''.................lddddddddooodxxxxxxddxko               
               cxxdodxxxxxxxooxxdddxkkdo:';c:;,......................,cdddddddddddddxxxxxxddxko               
               cdddoodddxxxdoodddddkkkdddoc:;;,'.................,lldxxdddddddddddddxxxxxxdddko               
               :dxdodxxxxxxdoodoodddxkdddddc''...................'oddddddddddddddddddxdddddddxl               
               :dddodxxxxxxxoooodxxddddoooo,......................:dddddddddddddddddxxxxxxxddxl               
               :ddoodxxxxxxdooodxxxddoooool.......................;dddddddddddddddddxxxxxxxddxc               
               :ddoodxxxxxxdoodddddddooood:..........'............,dddddddddddddddddxxxxxxxdddc               
               :oooooddddddoooooddddddoodd,..........'............'dddddddddddddddddxxxxxxxdddc               
               cxxxxxxkkkO000000OkkkO0000000000O0kxxdkkkkkxxkxxkkkkxddddxxxxxxxxxxxxxxxxxxxxxxl               
               cxxxxxxkkkO0O000OkkkkOOO0000OOOOOOxxddxxxxxddxxxkkkxdddddxxxxxxxxxxxxxxxxxxxxxxl               
               cxxxxxxxkkOOO000OkkkkOOO0OOOOOOOkkddddoollc::::clllllloodxxxxxxxxxxxxxxdddxxxxxl               
               cxxxxxxxkkOOOOOOkkkkkOOOOOOOOOOkxdlllc::;,,;,'',,,;;;;:::loxkxkxxxxxxxxdddxxxxxc               
               cxxxxxxxkOOO0000kxkkO0000O0OOOkdoollc;,'',;'.''''..'''''',,:cclodxxxkkxddddxxxdc               
               lkkkkkkkkOkOOOOOkxxxkkkkkkxxdddoc;:;,'.................''''',;;:codxdddddddxxxdc               
               lkkkkkkkOOOOOOOkxxxxkkkkxxdollc;'.'.............''''''''''''',,;cloddddddddxxxdc               
               lkkkkkkO0OOOOOOkxxkkOkkkxxoc,',;'............'''''''......'....',:oddddddddxxxxc               
               lOOOOOOOOOOOOOOkxxkOOkkxxxdl;'....................................;ldddddddxxxxc               
               lkOOOOOO000000kxxxkkkxxxxxdoc,.....................................;oddddddxxxxl               
               lkOOOOO0000000kkxxxxxxxxkkxdl;'.................'''''''''........',:odooddxxxxxl               
               lkOOOO0K0KK0K0kkxxxxxxkkkkxdoc,''.............',,;;;;;;,,'.......',:ldooddxxxxkl               
               lOOOOO0KKKKKKOkkkkxxxkOOOkkxdl:;,''......'',,;::clllllc:;,''.....';:ldodddxkkkkl               
               lOOOO0KKKKKK0OkkkkkkkkOkOkkxxdlc;;;,,,,,,;;::ccllllooolc;,''.....';:loddddxkkkkl               
               lOOOO0000000OOkkkOOOOkkOOkkkxxoc::;;;;;;;;;;::cclllooooc:,,'.....,;cldddddxkkkkl               
               lOOOO0000000OkkkOOOkOkOOkkkkkxdl:;;;;;;;;;;;;:cccllloool:;,''...';:coddddxxkkkkl               
               lOOOO000K000OkkkOOOOOOOOOOOkkxoc;;;;;;;;;;;;;:cccclloool:;;,,''',;:cdddddxxkkkkl               
               lOOOOKKKKKKKkkkk0000000000000Odc;;;;;,,;;;;;::ccccclloooc:,,,,,,,;;:oddddxkkkkko               
               lOOO0KKK0KKOkkkk00000000000O0kdc;;;;;,,,,;;;::cccclllooool:;,,,,;;;;ldddxxkkkkko               
               lOOO0KKKKKKOkkkO00KKKKK0K0000ko:,,''',,,,,,,,;;;;:ccllooool:;,,;;::lodddxkkkkkko               
               lOOO0KK000OkkkkOOO0000000OOO0ko;,,,'',,,,''''''',,;::cllooo:;,;;::cccoddxkkkkkko               
               oOO0KKKKK0Okkkk000KK0KKKK0000kdc;,,'',,;;,,,''',,;:::clloooc::cc::cc:lddxkkkkkkl               
               oOO00KK000kkkkO000K00000K000Okxo:;,,,,;:llc;,,,,,;:cccllooolllll:;;cldxxxkkkkkkl               
               oOOK0KK000kkkk0KKKKKKKKKK000Oxdl:;;,;;;clolc:;;;;:ccccllllllloooc::ldxxxkkkkkkkl               
               lO0000000OkkkO0KKK00KK0KK0K0kxdl;;;;;;:loooc:;,,;::cccllllllllllclodxxxxkkkkOOko               
               lOO000000kkkk0KKKXKKKKKKKKK0kxxo:;;:::cllllc;,,,;::cccllllllllcccodkxxxxxkkkOOko               
               lOOOOOOOOkkkkO00000000000000kxxxl;;,;,;::;:c;,,;;::ccllllllllcccoxkkxxxxxkkkkkkl               
               lOOO0OO0OkkkO0KKKK0K0000O00kxxxxd:,,,,,;;;;::;;;;::ccllllllllllodkOkxdxxxkkkkkkl               
               oOO00000OkkkO00KKK0K00K00K0kkxxkkc,,,,,,;::cc:;;;::cclllllllllooxxkxddddxkkkkkkl               
               oO00000Okkkk0K0KKKKK00K0000kkxkOOx:,,,,,,;:::;;,;::ccllllllllloddxxxddddxxxxkkkl               
               oOOOOO0OkkkO000K00KK0KKKKK0kkxkOOk;'',,,;:cc;;;,,;:ccccllllllloddxxddddddxxxkkkl               
               oO00O00kxkkO000000K00000K0OkkkkOOkc;,,''';:,;;:::::cccclllllllodddxdodddddxxxxkl               
               oOO0OOOkxxkO000000000000K0kkkkO00O:,,,,,';:::::::ccccccllllllooooood::oddddxxxxl               
               oO0000OkxxkO000000O000000OkkkkOOOkc,',,,,;cc:::::cc:ccclllllloooccod:',;lddxxxxl               
               oOOO00OkkkkOOO00O0OO00000OkkkkO00k:,''',,:c:;;:::;;::clllllllool;:odc'..';clodxc               
               o00000kkkkO0OOOOOOOOOO000OkkkkOOOk:,,,,,,:cc;,,,,,,;:clllllllolc;cddc......',:lc               
               cxxxxxxkkkO000000OkkkOO000OOOkxolll;'.........................''''',;:odoodddddc               
               cxxxxxxkkkO0O000OkkkkOOOOOOOkxdc,,,'............................'',,,;:ooodddddc               
               cxxxxxxxkkOOO000OkkkkOOOOOOOxoc;,'...............................';::;;coddddddc               
               cxxxxxxxkkOOOOOOkkkkkOOOOOOOxoc,'.................................'::;;:lodddddc               
               cxxxxxxxkOOO0000kxkkO00OOOOOkxo,'...................................,;::lddddddc               
               lkkkkkkkkOkOOOOOkxxxkkkkkkkxxxdl;'...............''...................',codddddc               
               lkkkkkkkOOOOOOOkxxxxkkxxxxxxxddol;'..........',,,,,,,'''...............':lddoddc               
               lkkkkkkO0OOOOOOkxxkkOkkxxxxxxxxdol;,'..'',,,,;:::cc:;,,,''............',:lddddxc               
               lOOOOOOOOOOOOOOkxxkOOkkxxxxxxxxxdl:;;;;;;;;;;:ccccccc:;,''............',:lodddxl               
               lkOOOOOO000000kxxxkkkxxxxxxxxxxxdc::;;;;;;;;;::cccccc:;,,''..........'',:loddddl               
               lkOOOOO0000000kkxxxxxxxxxkxxdddxdc:;;;;;;;;;;::::cccc:;;,'''.........'',:lodddxl               
               lkOOOO0K0KK0K0kkxxxxxxkkkkkxdddddl:;;;;;;;;;;;::::cllc:;,''''.......'',;:loddxxl               
               lOOOOO0KKKKKKOkkkkxxxkOOOkkxdddddl:;;;;;;;;;;;;:::cclcc:;'',,''''''''',;;cdxxxxl               
               lOOOOO0KKK000OkkkkkkkOOOOOkxxdddoc:;;;;,,,;;;;;::ccllllcc;,,,,,,,,,,,,,',:dxxxxl               
               lOOOOO0000000OkkkOOOOkkOOOOkkxddo:,,,,,,,,'',,,;;:cclllllc:;,,,,,,,;;;;'';dxxxxl               
               lOOOO0000000OkkkkOOkOkOOkkkkkxddol,'',,,,''.''',,;;:clllllc;;,,;,;;;:clc':dxxxxl               
               lOOOO0000000OkkkOOOOOOOOOOOOkkxddoc,,,,,,,,'''',,;;:clllllc::;;:;;::::;c:lxxxxxl               
               lOOOOKKKKKKKkkkk0000000000000Oxddoc;;;;;;,,'',,,;;;:clllllllccllc:;;:c::cdxxxkkl               
               lOOO00KK00KOkkkkOOO000000000OOxddl::::::;;,,,,,,;;::cccllllllloll:;;;cc:oxkkxxkl               
               lOOO0KKK0KKOkkxO00KK0KK000000kdddolccclc;,,,,,,,;;::cccccllllllc::cccc:ldxkkkkkl               
               lOOO0KK000OkkkkOOO0000000OOOOkxxxdc;:ccc;,,,,,,,;;::ccccllllllc:;:clc::dxxkkkkkl               
               oOO0KKKK00Okkkk000KK0KKKK00K0kxxxxc;;;;;,,,,,,,,;:::ccccllllll;;::cc::ldxxkkkkkl               
               oOO0000000kkkkO000K00000K000Okxxxxl;:;,,,,,,,,,;;::cccccllllllcclllc:lddxxkkkkkl               
               oOO00K000Okkkk00KKK0KKKKK000OxxxkOxc:;,,,,,,,,,;;::ccccclllllllllllooddxxxkkkkkl               
               lO0000000OkkkO000K00KKKKK0K0OxxxkOOd;,,,,,,,,,,,;;:::cccclllllllllooddddxxkkkkkl               
               lOO000000kkkk0KKKKKKKKKKKKK0kxxkOOOOd;,,,,,,,,,,;;:::cccccllllllllooddoooxxxkkkl               
               lOOOOOOOOkkkkO00000000000000kxxkO00Okl,,,,,,,;;;;;;::::ccclllccclllodooo:codxxxl               
               lOOOOOO0OkkkO0KKKK0K0000O00kxxxkOOOOkx:;,,,,,;;:::::::::cclcccccllloolld:,,:odxl               
               oOO00000OkkkO00KK00K00K00K0kkxxOOOOOkkd:;,,;;;;::::::;::cllcccclloooc;cdc'..';lc               
               oO00000Okkkk0K0KKKKK00K0000kxxkOOOxodddoc::;;;;;;,,,,;:ccccccclllool;;ldc'......               
               oOOOOO0kkkkO000K00KK0KKKKK0kkxkOOk:'',,,,;cc::;,,,,,,,;:cccccclllll;;cddc'......               
               oO00O00kxkkO000000K00000K0OkkxkOOOo;,,''';:,c:,,,,,,,,,;::::cclllc;;cdddc'......               
               oOO0OOOkxxkO000000000000K0kkkkO00Ol,;,,,';::l:,,,,,,,,,,,;;;:cclc,,codddc'......               
               oO0000OkxxkO000000O000000OkkkkOOOkc,,,,,,;cclc,',,,,,,,,',,,;:::,,:oddddc.......               
               oOOO00OkkkkOOO00O0OO00000OkkkkOxoc:,''',,:cclc;''',,,,,''',,,;,,;codddddc.......               
               o00000kkkkO0OOOOOOOOOO000Okkkxo:,,;,,,,,,;cllc:'..',,,,''',,,,,,:oddddddc.......               
               cxxxxxxkkkO000O00kkkkOO0000OOOOOxoc'.........................     ....;c::codddc               
               cxxxxxxkkkOOO0OOOkkkkOOOOOOOOOOkxdc,..........................    .....',;:odddc               
               cxxxxxxxkkOOO000OkkkkOOOOOOOOOOkkkdc,.........'',,;,,''......... ........',cdddc               
               cxxxxxxxkkOOOOOOOkkkkOOO0OOOOOOOkkdo:,'',,,,,;;::::::;,,'................',cdddc               
               cxxxxxxxkOOO0O00kxkkO00OOOOOOOkkkxol:;;;;;;;;;:::cccc:;,''...............';coddc               
               lkkkxkkkkOOOOOOOkxxxkkkkkkkxxxddddl:;;;;;;;;,;;:::ccc:;,''...............';coooc               
               lkkkkkkkOOOOOOOkxxxxkkxxxxxxxdddddoc;;;;;;;,;;;::::cc:;,,''.............',;loodc               
               lkkkkkkOOOOOOOOkxxkkOkkxxxxxxxxxddo:;;;;;;;;;;;;;::ccc:;,''............'',:loddc               
               lkkkkkkOOOOOOOOkxxkOOkkxxxxxxkkxxdl:;;;;;;;;;;;;;:ccccc:,'''''''...'''''',;coddc               
               lkkOOOOO000000kxxxkkkxxxxxxxxxkxxo:,,;;,,,,,,,,;::ccclcc:;,',,,,''''',''',;:oddc               
               lkOOOOO0000000kxxxxxxxxxkkkxddxxdoc,,,,,''''''',;;:clllllc:,,,,,,,,,,,,''',;odxc               
               lkOOOO0K0KK0K0kkxxxxxxkkkkOxddddddo:,,;;;,'..'',,,;;ccclllc:;,,,,,;;;;:;'',:dxxl               
               lkOOOO0KKKKKKOkkkkxxxkOOOOkxddddddol::;;;;,'''',,;;;:cllllc:;;;;;;;;;;:l:''cxxxl               
               lkOOOO0KKK0K0OkkkkkkkkOkOkkkxxddddolc:;;;;,,,,,,;;;::clllllcccclc:;;:::;:,;dxxkl               
               lkOOOO0000000kkkkOOOOkkOOOkkkxxdddoc:::;,,,,,,,,;;::ccccllllllool:;,;:c;;;lxxxkl               
               lkOOO0000000OkkkkOkkOkOOkkkkkxxddoc::cc;,,,,,,,,;;::ccccccllllllc:::;:c;,cxxxxkl               
               lkOOO0000000OkkkOOOOOOOOOOOOOkxddoc;;;;;,,,,,,,,;;::ccccccllllc::;clcc;':dxxxkkl               
               lOOOOKKKKKKKkkkk0000000000000Oxdddocc,,,,,,,,,,,;::cccccclllll;;;;ccc;,;oxxxxkkl               
               lOOO00KK00KOkkxkOOO0000000000Oxdxxdol;,,,,,,,,,;;::cccccclllll;:cccc:;;ldxkkkkkl               
               lkOO0KKK0KKOkkkO00KK0KK000000Oxxdxko;,,,,,,,,,,;;::cccccllllllccclllc:lddxkkkkkl               
               lkOO00K000OkkkkOOO0000000OO00kxxxxkkc;,'''',,,,,;::::cccclllllccllllloddxxkkkkkl               
               oOO0KKKKK0Okkkk000KK0KK0K0000kxxxkOOkc,,,,,,,,,,;;;::::cccllccccllloddddxxkkkkkl               
               oOO0000000kkkkO000K0000000000kxxxkOOko;,,,,,,;;;;;;::::ccccccccclllodddodxkkkkkl               
               oOO00K000Okkkk00KKK0KKKKK000OkxxkOOOOxc;,,,,,;;:::::::::cccccccclllodool:oxxkkkl               
               oO0000000OkkkO000K00KKKKK0K0OxxxkOOOOkd:;,,,;;;::;;;;;:ccccccccclllooloo,;coxxxl               
               lOO000000kkkk0KKKXKKKKKKKKK0kxxkOOOOOOOOddoc;;;,,,,,,;:ccccc:ccclllllcoo,'.,:oxl               
               lkOOOOOOOkkkkO00000000000000kxxkO00OOOO0OOkc:c;,,,,,,;:ccccccccllolc;:do,....';;               
               lOOOOOO0OkkkO0KKKK000000000OxxxkOOOOOOOkxo:;l:;,,,,,,;;:::ccccllllc;;ldo'.......               
               oOO00000OkkkO00KKKKK00K0000kxxxkOOOOkdoc;,,:l;,,,,,,,,,;;;::cclll:,;lddo'.......               
               o000000Okkkk0KKKKKKK00K0000kxxxkkxl:;;;,,,;ll:',,,,,,,,,,,;:cllc;,;ldddc........               
               oOO0OO0OkkkO000K0KKK0KK000Oxdol::;',,,,;;cllc:..',,,,,,,',,;::;,,:lddddc........               
               oO00O00kxxkO000000000000Okdc:,''.,;,,''',c,llc'..',,,,,,'',,,,,;:oddddd:........               
               oOOOOOOkxxkO0000000000Odl:;,.....,,,,,,',::llc:'..',,,,,',,,,,;codddddd;........               
               o00000OkxxkO0000OOOkxoc;,''......,,'''',;::lllo:'.'',,,,,,,,;:loddddddl'.......                
               oOOO00OkkkkOOO0Okxoc;,,'.........,,'''',;cclllddc''',,,,,,,:coodxxdddo,........                
               o00000kkkkO0OOOkl:;,,'...........,,'',,,,::lllood;',,,,,,,cclddxxdddd:.........                
               cxxxxxxxkkkOOOOOOkxxxkOOOOOOOkOOOOko:'.......'''',,,''.........         .;::cldc               
               cxxxxxxxkkOOOOOOOkxxxkOOOOOOOkOOOOxdl:,'',,,,,;;;::;;,''........       ...';cldc               
               cxxxxxxxkkOOOOOOOkxxkOOOOOOOOOOkOkdolc;;,;,,,;;::::::;,,'..................';ldc               
               cxxxxxxxxkOOOOOOkxxxkOOO0OOOOOOOOkdl::;;;;,,,;;::::cc:;,'..................,;ldc               
               cxxxxxxxkkOOOOO0kxxxOOOOOOOOOOkkkxol:;;;;,,,,,;:::ccc:;,''................',:loc               
               lkxxxxxxkkOOOOOOkxxxkkkkkkkxxxxdddol:;;;;,,,,;;;;;:cc:;,''................';cloc               
               lkkkkkkkOOOOOOOkxxxxxxxxxxxxxdddddoc;;;;;,,;;;;;;::ccc:;,''..............'';cloc               
               lkkkkkkOOOOOOOOkxxxkOkkkxxxxxxxxddc;;;;,,,,,,,,;;:ccccc:,'''''..........'',;codc               
               lkkkkkkOOOOOOOOxxxkOOkkxxxxxxkkxxoc,,,,,'''.''',,;:cccccc:,,,,'''''''''''',;:ldc               
               lkkkkOOO000000kxxxkkkxxxxxxxxxkxxdo;',;;;,,...''',;:cclllc:,,,,,,,'''''''',;;ldc               
               lkkOOOO0000000kxxxxxxxxxkkkxddxxdddl::;;;;,''''',,;:cllllc:;;,,,,,,,;;;'.'',;lxc               
               lkkOOO000KK0K0kkxxxxxxkkkkOxdddddddl:;;;;,,,,,,,;;;:clllllc:;;;;;,;;;;cc'.';:dxl               
               lkOOOO00KK0KKOkkkxxxxxOOOkkxddddddl:c:;;,,,,,,,;;::cccclllllcclc::;;::,:;'';lxxl               
               lkkOOO0000000OkkkkkkkkOkOkkkxddddl::c:;,,,,,,,,;;::cccccclllllllc;,,;c::;',cdxxl               
               lkkOOO000OO0OkkkkkOOOkkOOOkkkxdddo:;,',,,,,,,,,;;::cccccclllllccc;;;;c:,',:dxxxl               
               lkkkO0000000OkkkkOkkOkOOkkkkkxddddlc;,,,,,,,,;;;:::ccccccllllc::;:c:cc,.';dxxxxl               
               lkkkO0000000OkkkOOOOOOOOOOOOkkxdddol;,,,,,,,,;;;:::ccccclllll;,,;:lc:,'',oxxxxkl               
               lkOOOKKKKKK0kkkk00O000000000OOxdddo:,,,,,,,,,;;;:::cccccllllc;;::ccc;,';lxxxxkkl               
               lkOO00KK00KOkkxkOOO0000000000Oxdddxc;,'''''',;;;:::::ccccllllccccccc;,;ldxxxkkkl               
               lkkO0KKK0K0OkkxO000K0KK000000Oxddxkxc,,,,,,,,,;;;::::ccccclccccccclc::odxxxxkkkl               
               lkOO000000OkxxkOOO0000000OO00kxxxxOko;,,,,,;;;;;;;:::::cccccccccclllloddxxkkkkkl               
               lkOO0KKK00Okxxk000KK0K0000000kxxxkOOxc;,,,,;;:;;;;;:::::ccccccccllloddddxxkkxxkl               
               okO0000000kkkkO0000000000000OkxxxkOOxc;,,,,;;;:;;;:::::cccccccccllldddddxxxxxxkl               
               oOO000000Okkkk00KKK0KK0K0000OkxxkkOOOdc;,,,,;;;;;;;;;:ccccc::cccllodddddxxkkkkkl               
               lOO000000kxkkO000000000K00K0OxxxkOOOOOOkxo;:;,,,,,,;::ccccc::cccllooodloxxkkkkkl               
               lOO000000kkkkOKKKKKKK0KK0000kxxkOOOOOOOdl;cc;,,,,;;;:cccccccccclllolodc;ldxxxxxl               
               lkkOOOOOOkkkkO0000O00000000OxxxkOOkxdlc;,:c:;,,,,,,;;::ccccccccllll:od:'':oxxxxl               
               lOOOOOO0Okkkk00000000O00OOOkddolc:;,,,,,,lc;;,,,,,,,,;;:::cccclllc;:od;'..':odxl               
               oOOO0000kkkkO0000000000Oxdoc:;,'''''''''clc,,,,,,,,,,,,;;:cccllc:,;ldd,.....',:;               
               oO00000Okkkk00000000kxo:;,''.....'''''';ccc'',,,,,,,,,,,;::clc;,,:lddl'.........               
               oOOOOOOkxxkk000Okdl:;,,'.........','',,,;;c:'',,,,,,,,,,;;::;,,;:oddd:..........               
               o000O00kxxxkkxoc;;,,'.............;;,'''';:,'.',,,,,,,,,;;;,,;:lodddo,.........                
               oOO0OOOkxxxd:;,,,''...............;,,,,'';:;,..',,,,,,,,,,,,:lodddddl'.........                
               oO0000Oxxxd;'''...................;'''',,;:cc'.',,,,,,,,,,;clddddddd;..........                
               oOOOO0kxxx;.......................,'''',,:clol'',,,,,,,,:cloddxdddd:...........                
               o00000kkxd'.......................,''',,,;:lod:',,,,,,:ccloddxxddxc............                
               cxxxxxxxxkkOOOOOOkxxxkOOOOOOOkOOkxl;.........................       ..:c;::ldddc               
               cxxxxxxxxkOOOOOOOkxxxkOOOOOOOkOOkxoc'....'''',,,,,;,'.........       ..';::loddc               
               cxxxxxxxxkOOOOOOOkxxkOOOOOOOOOOkkkdo:;,,,,,;;;::::::;,''.................';coddc               
               cxxxxxxxxkOOOOOOkxxxkOOOOOOOOOOOOkdoc:;,,,,;;;::::cc:,,''.................,codd:               
               cxxxxxxxkkOOOO00kxxxOOOOOOOOOOkkkxoc:;;,,,,,;;::::cc:;,'.................',:odo:               
               lkxxxxxxkkOOOOOOxxxxkkkkkkkxxxddddoc::;;;,,,;;;;::cc:;,''................',:looc               
               lkkkkkkkOOOOOOOkxxxxxxxxxxxxxddddol:;;;;;;;;;;;;:cccc:,'''...............';clooc               
               lkkkkkkOOOOOOOOkxxxkOkkkxxxxxxxddo:;;;,,,,,;,;;::cccc:;,'''.............'':llodc               
               lkkkkkkOOOOOOOOxxxkOOkkxxxxxxkkxd:,,,,,'''''',;::cccccc:,''''''''......'',:loddc               
               lkkkkOOO000000kxxxkkkxxxxxxxxxkxdc,,,,,,'''',,,,;:ccccclc;,,,,,,,'''''''',:coddc               
               lkkOOOO0000000kxxxxxxxxxkkkxdddxdo;;;;;;;,'.''',,;:cllllc;;,,,,,,,'',,'',,;:odxc               
               lkkOOO000KK0K0kkxxxxxxkkkkOxddddddl:;;;;;,,,,,;;;;:cllllc:;;;;,,,,;;:;''',;:ddxl               
               lkkOOO00KK000OkkkxxxxxOOOkkxdddddlc::;;,,,,,,,;;::cccllllc:;::;;;;,;:cc'.,;lxxxl               
               lkkOOO0000000OkkkkkkkkOkOkkkxdddl:ccc;,,,,,,,;;;::ccccclllllllc:;;;:;,:,'';oxxkl               
               lkkOOO000OO0OkkkkkOOOkkOOOkkkxdoc;;;;;,,,,,,,;;;::cccccccllllllc;,,::;;''':dxxxl               
               lkkkO0000000OkkkkOkkOkOOkkkkkxddo:;,,',,,,,,,;;:::ccccccllllccc:::;cc;'',;oxxxxl               
               lkkkO0000000OkkkOOOOOOOOOOOOkkddolc;,,,,,,,,,;:::cccccclllll:;;;cc:c;..';lxxxxxl               
               lkOOOKKKKKK0kkkk00O000000000OOxdooc;,,,,,,,,;;:::ccccccllllc,,;;:cc;'..,oxxxxxkl               
               lkkO00KK00KOkkxkOOO00000000OOkddol;,,''',,,,;;:::::ccccllllc;::ccc:,,',ldxxxkkkl               
               lkkO0KKK0K0OkkxO000K0KK000000Oddddc;,,,,,,,,,;:::::ccccclllccccclc:;,;ldxxxxkkkl               
               lkOO000000OkxxkOOO0000000OO00kxdxxo:,,,,,,,,,;;;;::::ccccccccccclc:;:ldxxxkkkkkl               
               lkOO0KKK00Okxxk000KK0K0000000kxxxkkl;,,,,;;;;;;;;:::::ccccccccclllccodddxkkkxkkl               
               okO0000000kkkkO0000000000000Okxxxkko;;,,,;;;:;;;;:::::cccccccccllodxxxddxkkkxxxl               
               oOO000000Okkkk00KKK0KK0K0000OkxxkkOd:;,,,;;;:::;;;;::cccccccccclloxkxddxxkkkkkkl               
               lOO000000kxxkO000000000K00K0OxxxkOOkxl:;;;;;;;;,,,;::cccc::ccccllodxxddxxxkkkkkl               
               lOO000000kkkkOK0KKKKK0KK0000kxxxkOOOOOOxcc:,,,,,,;::ccccc:::ccllloddddddxxkkkkkl               
               lkkOOOOOOkkkkO0000O00000000OxxxkOOOOOxc;:l;,,,,;;;:ccccccc:ccclllolol:odxxxxxxkl               
               lOOOOOO0Okkkk00000000O00OOOkxxxxkxdlc;,:c:;,,,,,,,;:ccccccccccllllcdc',cdxxxxxxl               
               oOOO0000kkkkO00000000000OOkdlc:,,,',,,;lc;,,,,,,,,;;::::ccccccllc;cdc''',ldxxxxl               
               oO00000Okkkk00000000Okxdl:;,''....,''';c:,;;,,,,,,,,;;:::ccccll:;:od:....',:ldxc               
               oOOOOO0kxxkk0000Okdoc;,''.........,'',,,;;cc,,,,,,,,,;;::cllc:,,:ldd;........,;;               
               oO00O0OkxxkO0Odl:;;,''............,,,'''';:,,,,,,,,,,,,;:cc:;,,:oddo'...........               
               oOO0OOkxxxolc;;,,,'...............;',,,'';:;,,,,,,,,,,,;::,,,:lodddc............               
               oO0000Okd:;,,'''..................;'''',,;c:,',,,,,,,,,,,,,;coddddd:............               
               oOOOO0kd;'''......................;''''',;c:,',,,,,,,,,,,;clodddddo'............               
               o00000ko'.........................;''','';::,',,,,,,,,,,:coodddddd:.............               
               cxxxxxxxxkkOOOOOOkxxxkOOOOOd;,'...............................',;,,;ldddoodddddc               
               cxxxxxxxxkOOOOOOOkxxxkOOOOko;'''...............................,;;,';lddoodddddc               
               cxxxxxxxxkOOOOOOOxxxkOOOOkkkd:,'................................,::;;codoodddddc               
               cxxxxxxxxkOOOOOOkxxxkOOOOOOOxc,........................... .......;;;:cooodddddc               
               cxxxxxxxkkOOOOOOkxxxkOOOOOOOxo:'.......'',,,,;,'''..................',:ooodddddc               
               lkxxxxxxkkOOOOOkxxxxxkkkxxxxxdo:,',,,,,,;;:::::;;,'''................':loodddddc               
               lkkkkkkkOOOOOOOkxxxxxxxxxxxxddol:;;;;;,;;::::cc:;,,''................,;loodddddc               
               lkkkkkkOOOOOOOOkxxxkkkkxxxxxxdlc:;;;;;;;;::::ccc:;,''...............',;coodddddc               
               lkkkkkkOOOOOOOOxxxkkOkxxxxxxxdl::;;;;;;;;;;::ccc:;,''...............',:coodddddc               
               lkkkkOOO000000kxxxkkxxxxxxxxdol::;;;;;;;;;;;:cccc;,,'''.............',:lodddddxc               
               lkkOOOO000000Okxxxxxxxxxkkxxdoc;;;;;;;;;;;;:ccccc:;,'''''...........',cloddxddxl               
               lkkOOO000KK00Okkxxxxxxkkkkkxdc;;;,,,'',,,;;:ccccccc:,,',,'''''''''''',:coodxxxkl               
               lkkOOO00KK000OkkkxxxxxOOOkkxo;,,,,,,''',,,,;:ccccllcc;,,,,,,,,'''',',,;:ooxxxxkl               
               lkkOOO0000000OkkkkkkkkOkOkkkxl;,;;;;,,''''',;;:ccllll:;;,,,,,,,,;;,'',;;ooxxxxkl               
               lkkOOO000OO0OkkkkkOOOkkOOkkkkxl:;;;;;,',,,,,;;:ccllllc:;;;;,;;;;:cc,'';:odxxxxxl               
               lkkkO0000000OkkkkOkkOkOOkkkkkxo:;;;;,,,,,,;;::ccclllllccccc;;;;;:;c,'';:ddxxxxxl               
               lkkkO0000000OkkkOOOOOOOOOOOkkocc:;,,,,,,,,,;::cccclllllllolc;,,;c;:,'',cddxxxxxl               
               lkOOOKKKKKK0kkkk00O000000000d::c:;,,,,,,,,;;::ccccclllllllll;;,,c:;''';odxxxxxkl               
               lkkO00KK00KOkkxkOOO00000000Okl;,,,,,,,,,,,;;::cccclllllllcc::c::c;'',,lddxxkkkkl               
               lkkO0KKK0K0OkkxO000K0KK000000oc:,,,,,,,,,;;:::cccclllllll:;;;clc:'.';lddxxkkkkkl               
               lkOO000000OkxxkOOO0000000OO00xo:;,,,,,,,,;;::::cclllllllc;;;:ccc;'',lxdxxkkkkkkl               
               lkOO0KKK00Okxxk000KK0K0000000xo;,,,,,,,,,;;::::ccclllllllccccccc;,,cxxxxxkkkkkkl               
               oOO0000000kkxkO0000000000000Oxo;,'''''',,,;;:::ccccllllllcccclcc;,lkkxxxxkkkkkkl               
               oOO000000Okkkk00KKK0KK0K0000Oxdl:,,,,,,,,,;;;::::ccccllllccclllc:cxOkxxxxkkkkkkl               
               lOO000000kxkkO000000000K0000kxxdl;,,,,,,,;;;:::::ccccclccccclllooxkkxdxxxkkkkkkl               
               lOO000000kkkkOK0KKKKKKKK0000kxxxdc;;;,;;;;:::::::::cclccccclllooxkkkxddxxkkkkkkl               
               lkkOOOOOOkkkkO0000O00000000Oxxxxxc;,,,;;;;:::::::::cccccccclllodxkkkxdddxkkkkkkl               
               lOOOOOO0Okkkk00000000000OOOkxxxkkdc;,,,;;;;;;;;;::cccccccccllloddxkkxdddxkkkkkkl               
               oOOO0000kkkkO00000000000O00kxxxkOOOxo:;:,,,,,,;;:cccccccccclllooodddddddxxxxxxkl               
               oOOOOO0OkkkkO00000000000000kxxxkkxdoc;::;,;,;;;;:cccccccccclllooldl;lodddxxxxxxl               
               oOOOOOOkxxkk00000000000000Oxxxxkx;'',,,;;cc;,,;;:ccccccccclllllccdl',;ldddxxxxxl               
               oO00OOOkxxkk00000000O0000Odllc:,';;,'''',:,;,,,;;::::cccclllll:;ldl'..':oddxxxxl               
               oOOOOOkxxxkkOO000O0OOkdoc;,''....;,,,,,',::;,,,,,;;;::ccclllc;,:odc.....';lodxxl               
               oOOO00OxxxxO0OOOxdlc:;,'.........,''''',;c:;,,,,,,,;;:ccllc:,,codd:........';coc               
               oOOOO0Oxxxkkxdl:;,,''............,''''',;c:;,,,,,,,,;::cc:;,;loddo,.............               
               o00O00kxkxol:;,,,'...............,''',,';c:;,,,,,,,,;::c;,,;cddddl'.............               
               cxxxxxxxkkkOOOOOOkxxxkOOOOOOOOkxdlccc:;,,,,,,,;cllcccooooddxxxxxxxxxxxxdddxxxxxl               
               cxxxxxxxkkOOOOOOOkxxxkOOOOOkkocccc:::,'''....',,,,'',;clllodxxxxxxxxxxddddxxxxxl               
               cxxxxxxxkkOOOOOOOkxxkOOOOxdo:,''''''..........''.....',;;;:ldddddxxxxxddddddxxxc               
               cxxxxxxxxkOOOOOOkxxxkOOOxoc;'........'''................''',,;cldxkxxxdodddddddc               
               cxxxxxxxkkOOOOOOkxxxkOOko;,'..........'...................',,,,,:dxxxxxddddddddc               
               lkkkkkxxkkOOOOOkxxxxxxkd:,'''..............................';;;,,cdxxxdddddddddc               
               lkkkkkkkOOOOOOOkxxxxxxxxdc;,'...............................,::;;:lddddddddddddc               
               lkkkkkkOOOOOOOOkxxxkkkxxdoc,...........''''...................',;;:odddddddddddc               
               lkkkkkkOOOOOOOOxxxkkOkxxxdo:'.....''',,,;;;,,''..................,;lxxddddddddxc               
               lkkOOOOO000000kxxxkkxxxxxxxo;,,,,,,,,;;:::::;,,''................',codooddddddxc               
               lkOOOOO000000Okxxxxxxxxxkkxdc:;;;;;;;;::::cc:;,,'.................,:ooooodxxdxxl               
               lkOOOO0K0KK00Oxxxxxxxxkkkkxoc:;;;;;;;;::::cc:;,''................',:loooodxxxxxl               
               lkkOOO00KK000OkkkxxxxxkOOkxl::;;;;;;;;;;::ccc;,,''...............',:loooodxxxxkl               
               lkkOOO0000000OkkkkkkkkOkOkxl::;;;;;;;;;;::ccc:;,'''..............',cloooodxxxxkl               
               lkkOOO000OO0OkkkkkOOOkkOkkdc;;;;;;;;;;;;:ccccc:;,''''''.........'';cloooodxxxxkl               
               lkkkO0000000OkkkkOOOOkOOkxo:;;;,,,,,,,;;:ccccccc:;,,,,,''''''''''',;:looddxxxxxl               
               lkkkO0000000OkkkOOOOOOOOkxl;,,,,,'''',,,;:ccccllc:;,,,,,,,''''''',,;;loodxxxxxkl               
               lkOOOKKKKKK0kkkk00O0000000x:,,;,,,'''',,,;;:cllllc:;;,,,,,,,,;;,'',;;loodxxxxxkl               
               lkkO00KK00KOkkxkOOO0000000Oo::;;;;,'''',,,;:cllllc::;;;;;,;;;:cc;'';:odddxxkkkkl               
               lkkO0KKK0K0OkkxO000K0KK0000kl;;;;,,,,,,,;;;:cccllllc::cc:;;,;:;::'',:oddxxkkkkkl               
               lkOO000000OkxxkOOO0000000OOo::;;,,,,,,,,;;::cccccllllllll:;,;c:;;'',lddxxkkkkkkl               
               lkOO0KKK00Okxxk000KK0K00K0o:::;,,,,,,,,;;;:ccccccllllllllc;;,:c;,',:dddxxkkkkkkl               
               oOO0000000kkxkO0000000000Ol:;;,,,,,,,,,;;::ccccllllllllc::::::c'.';xkdxxxkkkkkkl               
               oOO000000Okkkk00KKK00KKKK0Ol;,,,,,,,,,,;;::cccclllllll:;;;:cc:,'',okkxxxxkkkkkkl               
               lOO0000O0kxkkO0000000000000dc;,,,,,,,,;;::::ccclllllll;;;::cc:,''ckkxdxxxkkkkkkl               
               lOO000000kkkkOKKKKKKKKKK00Okl;,,,,,,,,,;::::ccclclllllccccccc:;,ckOkxddxxkkkkkkl               
               lkkOOOOOOkkkkO0000000000000Ol;,,,,,,,,,;;::::ccccllllllcccclc:;:xkkkxddxxkkkkkkl               
               lOOOOOO0OkkkO00000000000OOOkd:,'',,,,,,;;;::::cccclllccccclllccokkOkxdddxkkkkkkl               
               oOOO0000kkkkO000000K0000000kxo:,,,,,,,;;;;:::::ccccllccccllloodkkkkxddddxkkkkkkl               
               oOOOOO0Okkkk0000KKKK00K0000kxxo:;;,,,,;;;::::::::cccccccclllodxkxxxxddddxxxxkkkl               
               oOOOOOOkxxkk000000000KK000Oxxxd:;,'',,,;;cc::::::cccccccclllodxxkkkxdddddxxxxxkl               
               oO00OOOkxxkk00000000000000kxxxxoc;;,,''';;,;;;:::cccccccclllooddxxxxddddddxxxxxl               
               oOOOOOkxxxkkOO000000000000kxxkkOx:,,,,'';:;,,;:cccccccccclllooloxcodddddddxxxxxl               
               oO0O00OxxxkOOO00OOOOOOOO0OkxxkkOx:,''',,;c:;;;:cccccccccllllllcox:,codddddxxxxxl               
               oOOO00kxxkkOOO0OOOOOO0000kkxxxkkx:,''',,:c:;;;:ccccccccllllll:;od:'';cddddxxxxxl               
               o00O00kkkkOOOOOOOOOOOOO00kkxxxdc:;',,,,,:c:;;;::ccccccclllllc,:dd;...':ddxxxxxxl               
               cxxxxxxxkkOOOOOOOkxxxkOOOOOOOkOOOOkxxxkOkkkkkkkkkkkkxdddxxxxxxxxxxxxxxxxxxxxxxxl               
               cxxxxxxxkkOOOOOOOkxxxOOOOOOOOOOOOOxxxxkkkkkxxxxkkkkkxdddxxxxxxxxxxxxxxxddxxxxxxl               
               cxxxxxxxkkOOOOOOOkxxkOOOOOOOOOOOOkxxxxkkkkxxxxxkkkkkxdddxxxxxxxxxxxxxxxdddxxxxxl               
               cxxxxxxxxkOOOOOOkxxxkOOOOOOOOOOOOkxdddxxxxxxxxxkkkkkxdddxkkkkkkkxkkxxxxdddxxxxxl               
               cxxxxxxxkkOOOOOOkxxxkOOOOOOOOkkddolc::;;;;:cloddddddddddxkkkkkkkkkkkkkxdddxxxxdl               
               lkkkkkkkkkOOOOOkxxxxxxkkxxxdll::::;,,,''''',;;;,,;;clooodddxxxxxxxxxxxxdddddxxxc               
               lkkkkkkkOOOOOOOkxxxxxxxddoc;::::;;,''......'''....',;;;;coddddddddddddddddxxxxdc               
               lkkkkkkOOOOOOOOkxxxkkxdol;'.........................,,''',:codddddddddddddxxdddc               
               lkkkkkkOOOOOOOOxxxxkkdc;,........''''.................'''...,:oddxxxxxxddddddddc               
               lkkOOOOO0000O0kxxxkkdl;''..............................''''''';lodxxxxdodddxxxxl               
               lkOOOOO0000000kxxxxxdl;'''..............................',,''',;loddxxdoddxxxxxl               
               lkOOOO0K0KK00Okxxxxxxxd:,'...............................';,,,,,:oooooooddxxxxxl               
               lkOOOO0KKK00KOkkkxxxxxxl;..................................',,,,;looooooodxxxxxl               
               lkOOOO0000000Okkkkkkkkkdc,.......''',,,,''.....................';looooooodxkxxxl               
               lkkOOO000OO0OkkkkkOkOkkkdl;,,,,,,,;;;::;;,'''..................',:oddoooddxxxxxl               
               lkkkO0000000OkkkkOOkOkkkdl:;;;;,,;;::::::;,''..................',:ldddooddxxxxxl               
               lkkkO0000000kkkkkOOOOOOko::;;;;,;;;::::::;,''..................',:coddoodxxxxxxl               
               lkOOOKKKKKK0kkkk00O0000Oo::;;;;,,,;;;::c:;,,''.................';ccoxddddxxxxxkl               
               lkkO00KK00KOkkxkOOO0000kl:;;;;;,,,,,;;ccc;;,''................'';ccoxxdddxkkkkkl               
               lkkO00KKKK0kkxxO00000K0kc;;;;;;,,,,,,;ccc:;,'''...............'';:cdxdddxxkkkkkl               
               lkOO000000OkxxkOOO0000Oo:;;;,,,,,,,;;::ccc:;,'''''''.......''''',,,dkxddxkkkkkkl               
               lkOO0KKK00Okxxk0000000Oo;,,,,'''''',;::cccccc;,'',,''''''''''''',,,dkxdxxkkkkkkl               
               oOO0000000kkxkO0000000OOo;,,,,''''',,,;:cccccc;,,,,,,''''',,'..',,;xxdxxxkkkkkkl               
               oOO000000Okkkk0000000000Oo;;;;,'..''',,;:ccccc:;;,,,,,,,,;:c;...',ckxxxxxkkkkkkl               
               lOO0000O0kxkkO0000000000kl;;;,,,,,,,,,;;::ccclc::;;:;;;;,,;;:'...,okxxxxxkkkkkkl               
               lkO000000kkkkOKKKKKKKK0kc;;;,,,,,,,,,;;::ccccclllcloc:;,',:,;''''ckkxxdxxkkkkkkl               
               lkkOOOOOOkkkkO00000000Ol;;;,,,,,,,,,,;;::cccccclllllcc;,,,::,..';xkkxxdxxkkkkkkl               
               lkOOOOOOOkkkO00000000Od:;;,,,,,,,,,,,;;::::ccccllccc::;:;;c;...,okOkxdddxkkkkkkl               
               oOOO0000kkkkO0000000000xc,,',,,,,,,,,;;::::ccccllcc:;;;ccc:'..'lxxkxddddxxxkkkkl               
               oOOOOO0Okkkk0000KKKK000Oxl;,,,,,,;;,,,;;;::cccllll:,;;;:cc:,''lxxxxxddddxxxxkkkl               
               oOOOOOOkxxkk000000KK0K00Oo;;,,,,,;;'',,,;;ccccllllc:cccccc:,,lkkkkxdddddxxxxkkkl               
               oO00OOOkxxkO0000000000000x:,,'''',;;,'''.,:,cccllccccccclc::lkOkkkxddddddxxxxxxl               
               oOOOOOkxxxkkOO00000000000Od;,,,,,,;,,,,,',:;:cccccccccclllloxkkkkkxdddddxxxxxxxl               
               oOOO00OxxxkOOO00OOOOOOOO0Oxc,,,,,,;'''',,;c::ccccccccccllldxkOOkkkkdddddxxxxxxxl               
               oOOOO0kxxkkOOO00OOOOOO000Oxo:;,'',;''''',;ccc:cccc::cccllldxOOkkkkkdddddxxxxxxxl               
               o00000kkkkOOOOOOOOOOOOO00kxd:;,''',''','';ccc:cccc::cclllldxkkkkkkxddddxxxxxxxxl               
               cxxxxxxxkkOOOOOOOkxxxkOOOOOOOOOOOOkxxxkOkkkkkkkkkkkkxdddxxxxxxxxxxxxxxxxxxxxxxxl               
               cxxxxxxxkkOOOOOOOkxxxOOOOOOOOOOOOOkxxxkkkkkxxxxkkkkkxdddxxxxxxxxxxxxxxxddxxxxxxl               
               cxxxxxxxkkOOOOOOOkxxkOOOOOOOOOOOOkxddxkkkkxxxxkkkkkkxdddxxxxxxxxxxxxxxxdddxxxxxl               
               cxxxxxxxxkOOOOOOkxxxkOOOOOOOOOOOOkxddxkkkkxxkkkkkOOOxxxxkkkkkkkkxkkxxxxdddxxxxxl               
               cxxxxxxxkkOOOOOOkxxxkOOOOOOOOOOOOkddddxkkxxxkkkkkOOkxddxkkkkkkkkkkkkkkxdddxxxxdl               
               lkkkkkkkkkOOOOOkxxxxxxxxxxxxxxxxxddooddddddddddddxxxxddxxxxxxxxxxxxxxxxdddxxxxxc               
               lkkkkkkkOOOOOOOkxxxxxxxxxxxxxdddoolllcc:;::cllodddddddddddddxxxxxxxxddddddxxxxdc               
               lkkkkkkOOOOOOOOkxxxkkkxxxxxddlc:;;;;,,,'''',,;:ccllllodddddxxddxxxxxddddddxxxxdc               
               lkkkkkkOOOOOOOOxxxxkOkxxdddo:,::::::,''.....'',,,,,;;:cooodxdddxxxxxxxxdddxxxxxc               
               lkkOOOOO0000O0kxxxxkxxxoll:,.......''..............',;;;;:ldddddddxxxxdoddxxxxxc               
               lkOOOOO0000000kxxxxxdddl;,'.........''..............',,,',;clddddddxxxdoddxxxxxl               
               lkOOOO0K0KK00Okxxxxxddl;''.......'..''................'''...';codddoooooddxxxxxl               
               lkOOOO0KKK00KOkkkxxxxxdc,''.............................'''...':odooooooddxxxxxl               
               lkOOOO0000000Okkkkkkkkxd:,'..............................,,''.',:oooooooddxxxxxl               
               lkkOOO000OO0Okkkkkkkkkkxl,................................;;,',,,coddoooddxxxxxl               
               lkkkO0000000OkkkkOkkkkkxo:'................................,;;,,;:odddooddxxxxxl               
               lkkkO0000000kkkkkOOOOOOkko:''',,,,',,,,,,''...................'',:odddoodxxxxxxl               
               lkOOOKKKKKK0kkkk00O0000Oxoc:;;;;;;;;:::::;,''...................,:odxddddxxxxxkl               
               lkkO00KK00KOkkxkOOO000Okl::;;;;;;;;:::::::;,'...................,;ldxddddxkkkkkl               
               lkkO00KKKK0kkxxO0000000kl::;;;;,,,;;;::::;,,'..................',:cdkdddxxkkkkkl               
               lkOO000000OkxxkOOOOO000kl::;;;;,,,,;;::c:;,,'..................';ccdkxddxkkkkkkl               
               lkOO0KKK00Okxxk0000000Oxc;;;;;;,,,,,;::cc;,,''.................':lcdxxdxxkkkkkkl               
               oOO0000000kkxkO0000000kc;;;;;,,,,,,;;:ccc:;,'.''............''',:clxxxxxxkkkkkkl               
               oOO000000Okkkk00000000Oo;,,,,'''',,;;:ccc::;,'.''''........''''',;ckxxxxxkkkkkkl               
               lOO0000O0kxkkO000000000kl,,,,'''''',;;:ccccc:;,''''''''''''''..',,lkxxxxxkkkkkkl               
               lkO000000kkkkOKKKKKKKK00kc;;;,'..'',,,;:ccccc:;,,,,''''''','....',okxxdxxkkkkkkl               
               lkkOOOOOOkkkkO0000000OOOo:;;,,,'',,,,,,;:ccccc;,,,,,,,,,,;:;'..',;xkxddxxkkkkkkl               
               lkOOOOOOOkkkO00000000OOo;;;,,,,,,,,,,;;::ccccc:;;;;;,,,,,;;:,...,lkxddddxkkkkkkl               
               oOOO0000kkkkO00000000Oo:;;,,,,,,,,,,,;;::ccccccccccc:;,',;,;,..':xkxddddxkxkkkkl               
               oOOOOO0Okkkk0000KK000x:;;;,,,,,,,,;,,,;;;::cccclllccl;,,,:;;'.':dxxdddddxxxxkkkl               
               oOOOOOOkxxkk000000000Ox:,''',,,,,,;''',,;;cc:cccccc::;:;,::'.':dxxkdddddxxxxkkkl               
               oO00OOOkxxkO0000000000Od:,,,,,,,,,;;,,''.,:,:cccc:;;;;c::;'.'cxxkkxddddddxxxxxxl               
               oOOOOOkxxxkkOO000000000k:;,,,,,,,,;,,,,,',:;:cclc;,;;;:c:,''lkkkkkxdddddxxxxxxxl               
               oOOO00OxxxkOOO00OOOOOOOkl,,,,,,',,;,''',,;::ccclc:::::cc:;;okkkkkkkdddddxxxxxxxl               
               oOOOO0kxxkkOOO00OOOOOOOOk:,''''''';,'''',;cccccccccccccc::lkkkkkkkkdddddxxxxxxxl               
               o00000kkkkOOOOOOOOkkOOOOkl,,,,''.';,'',,',cclcccccccccccclxkkkkkkkxddddxxxxxxxxl               
               cxxxxxxxkkOOOOOOOkxxxkOOOOOOOOOOOOkxxxkOkkkkkkkkkkkkxdddxxxxxxxxxxxxxxxxxxxxxxxl               
               cxxxxxxxkkOOOOOOOkxxxOOOOOOOOOOOOOkxxxkkkkkxxxxkkkkkxdddxxxxxxxxxxxxxxxddxxxxxxl               
               cxxxxxxxkkOOOOOOOkxxkOOOOOOOOOOOOkxddxkkkkxxxxkkkkkkxdddxxxxxxxxxxxxxxxdddxxxxxl               
               cxxxxxxxxkOOOOOOkxxxkOOOOOOOOOOOOkxddxkkkkxxkkkkkOOOxxxxkkkkkkkkxkkxxxxdddxxxxxl               
               cxxxxxxxkkOOOOOOkxxxkOOOOOOOOOOOOkddddxkkxxxkkkkkOOkxddxkkkkkkkkkkkkkkxdddxxxxdl               
               lkkkkkkkkkOOOOOkxxxxxxxxxxxxxxxxddddddddddddxxxxxxxxxxxxxxxkkkkkkkkxxxxdddxxxxxc               
               lkkkkkkkOOOOOOOkxxxxxxxxxxxxxxdddddddddddddddxdddxxxxxxxxxxxxxxxxxxxddddddxxxxdc               
               lkkkkkkOOOOOOOOkxxxkkkxxxxxxxxddddddooooooodddxxxxxxxxxxxxxxxxxxxxxxddddddxxxxdc               
               lkkkkkkOOOOOOOOxxxxkkkxxxxxxxxdolc:::::;;;;:cloxxxdddddxxxxxxxxxxxxkkxxdddxxxxxc               
               lkkOOOOO0000O0kxxxxkxxxxxxdddooc;,,,;;;,,''',;;:cclloddxxxxxxxxxdxxxxxddddxxxxxc               
               lkOOOOO0000000kxxxxxxxxxdol:lc;,..'''''',,''''',,;;::loodddddxxxxdxxxxdoddxxxxxl               
               lkOOOO0K0KK00Okxxxxxxxxool;,,'..........'''......',,',;:ldddxkkkxdddddooddxxxxxl               
               lkOOOO0KKK00KOkkkxxxxxdc;;'''.........''''''''...''...',:::ldxkkkxdddddoddxkxxxl               
               lkOOOO0000000Okkkkkkkkxc,'...............''...........'',:;;;coxxdddddooddxkxxxl               
               lkkOOO000OO0Okkkkkkkkkxo;'.............................''';::;coxdddddoodxxkxxxl               
               lkkkO0000000OkkkkOOkkkxd:,................................':c::cdxxxddoodxxxxxxl               
               lkkkO0000000kkkkkOOOOOOxl;'................'...............':cccoxxxxdoodxxxxxxl               
               lkOOOKKKKKK0kkkk00O00000xc:''........'',,,,,,'''.............,clodxxxddddxxxxxkl               
               lkkO00KK00KOkkxkOOO00OOOklc;;,,,,,,;;:::ccccc:;,,'............,:dxxkkdddxxkkkkkl               
               lkkO00KKKK0kkxxO0000000ko::;;;;;;,;;::cccccllc:;,,''.........',:oxkkkxxxxxkkkkkl               
               lkOO000000OkxxkOOOOO000kl:;;;;;;,,;;::ccccclll:;,'''........',:coxkOkxxxxkkkkkkl               
               lkOO0KKK00Okxxk00000000xl:;;;;;,,,;;;::cccclll:;,'''.......',;cldxkOkxxxxkkkkkkl               
               oOO0000000kkxkO0000000Odl:;;;;;,;;;;;:::cccllc:;,'''.......',;:oxkOOkxxxxkkkkkkl               
               oOO000000Okkkk00000000xl:;;;;;;;;;;;::::cccllc:;,,''......'',;:oxkOOkxxxxkkkkkkl               
               lOO0000O0kxkkO00000000o,,,,,,,,,,,,,;::ccccllcc:,'''''''.''',,,oxkOOxxxxxkkkkkkl               
               lkO000000kkkkOKKKKKKK0Oc,,'',,,'''''',;:cccllllc:,''''''''.'',;xkkOOxddxxkkkkkkl               
               lkkOOOOOOkkkkO0000000OOo,''',,,,,''',,,,;:ccllllc:,''''''''..':xkkOkxxdxxkkkkkkl               
               lkOOOOOOOkkkO00000000Oko;,,,,;;;;,''''',,,:cllllc:,,',,',,;,',lkkkkkxdddxkkkkkkl               
               oOOO0000kkkkO000000000o:;;::::;;;,,'',;;;:ccllllc:;,,,,;;;:cc;dxxxxxddddxkxkkkkl               
               oOOOOO0Okkkk0000KK0000o:ccccllc:::,,,,;;::cclllllc::c:;;;;:;coxxxxxxdoddxxxxkkkl               
               oOOOOOOkxxkk0000000000dc:::cllc:;,'',,,;;ccccllllllloc;,,;c;oxxxkkkdddddxxxxkkkl               
               oO00OOOkxxkO0000000000o;;;;;;::;,;;,,''',:,ccccllllllc;;;;coxkkkkkxddddddxxxxxxl               
               oOOOOOkxxxkkOO00000000l,,,,',,,,,;,,,,,';::ccccllllc:::lcldkkkkkkkxdddddxxxxxxxl               
               oOOO00OxxxkOOO00OOOOOOo;,,,,,,,,,;''''',;c:cclllllc;;;cloxOOOkkkkkkdddddxxxxxxxl               
               oOOOO0kxxkkOOO00OOOOOOd;,,,,,,'',;''''',;cclclllll;;:::lkkOOOOkkkkkdddddxxxxxxxl               
               o00000kkkkOOOOOOOOkkOOkc,''''''.,;''',,';cclclllll:ccccxkOOOOkkkkkxdddddxxxxxxxl               
               cxdxxxxxkkOOOOOOOkkkxOOO00OOOOOOOOkxxxkOOOkkkkkkkkkkxdddxkkkkxxxxxkkkkxxxxxxkkxl               
               cxxxxxxxkkOOOOOOOkxxxOOOOOOOOOOOOOkxxxkkkkkxxkkkkkkkxdddxkkxxxxxxxxxxxxxxxxxkkxl               
               cxxxxxxxkkOOOOOOOkxxkOOOOOOOOOOOOOxxxxkkkkkxxkkkkkOOxxxxxkkkkkxxxxxxxxxdddxxxxxl               
               cxxxxxxxkkOOOOOOkxxxkOOOOOOOOOOOOkxxdxkkkkkkkkkOOOOOxxxxkkkkkkkkkkkkkkxdddxxxxxl               
               cxxxxxxxkkOOOOO0kxxxkOOOOOOOOOOOOkdddxkkkkkkkkkOOOOOxxxxkOkkkkkkkkkkkkxddddxxxxc               
               lkkkkkxxkkOOOOOOxxxxxkkkkkkxxxdddddooodooodddxxxxxxxxxxxxxxxkkkkkkkkkkxddddxxxxc               
               lkkkkkkkOOOOOOOkxxxxxxxxxxxdol::cc::cc:::::ccldddddxxxxxxxxxxxxxxxxxxxddddxxxxxc               
               lkkkkkkOOOOOOOOxxxxkkkxxxdolcccccc:;,,'''''',;:cclodddxxxxxxxxxxxxxxxxxxddxxxxxl               
               lkkkkkkOOOOOOOOxxxxkkkxdollclc;,,,'.........'',;;;;;;coxxkkxxxxxxxkkkkxdddxxxxxl               
               lkkOOOOO00000Okxxxxkxxoc;,,,''...............',;;,,,,,;coxxxxxxxxxxkkkddddxxxxxl               
               oOOOOOO000000Okxxxxxxdl;'...','...........''',;:;,,,,;;;;ldddxxxxxxxxxddddxxxxxl               
               oOOOOO0K0KK0KOkxxxxxdoc;,'.........''''...'''',,,'',,,,,,,:oxkkkxdddddddddxkkkkl               
               okOOOO0KKKKKKOkkxxxxdoc;,'.........''..........''..''''''',:xkkkkxdddddddxxkkkkl               
               okOOOO00K0000Okkkkkkxdc;,'............................''''',lkkkkxdddddddxxkkkkl               
               okOOO0000000Okkkkkkkkdlc;'....................'''''.......'':xxxxxdxdddddxxkkkkl               
               okOOO0000000OkkkkOkkkolc;,''''...........''',,,,,,,''.....';lxxxxxdxxddddxkkkkkl               
               okOOO0000000kkkkkOOOkoc::;;;;,,,,,,',,,;:::ccllllc:,''...',:oxxxxxdxxddddxkkkkkl               
               okOOOKKKKKK0kkkkOOOOOo::c:;;;;;;;;;;:::cccllooooolc;,''''',:dkkkxxxxkxddxxkkkkkl               
               okOO0KKK0KKOkkxkOOOOOl:ll:;;;;;;;;;:::::ccllooooolc;,''.',;cdkkkkkkkkxddxkkkkkkl               
               okOO0KKK000OxxxOOO00Odcol:;;;;;;;;;;;;;::cclllloolc:,,'',;:lxkkkkkkOkxxxxkkkkkkl               
               okOO00K000OkxxxOOOOOOdcol:;;;;;;;;;;;;::ccclllllllc:;,',;:coxkkkkkOOkxxxxkkkkkkl               
               okO0KKKK00OkxxkO00000klol;;;;;,,;;;;;;::ccccllllllc:;,,,;:ldkkkkkkkOkxxxxkkkkkkl               
               okO000K000kxxxOO00000koo:,''',,,,,,,,;;:cccclllllll:;,,,;cokkOOOOOOOkxxxkkkkkkkl               
               oOO000000Okxxk0000000xoc;,,,'''',,,,,,,,;;::clllllll:,,,:lxkOOOOOOOOkxxxkkkkkkOo               
               oOO000000kkkkO0000000kdc;;,,,''',,;;,,'''',,;::cllll:,',:oxkOOOOOOOOkxxxkkkkkkOo               
               lOOO00000kkkkOKKKK000Odc:,,'''',,;ccc;,'',,;;::cllll:,,:cccxkkOOOOOOkxxxkkkkkkOo               
               lkOOOOOOOkkkkO000000Okoc;;,,,,,,,:llll:;;,;::ccllollc:::ll:dkkOOkOOOxxxxkkkkkkOo               
               lOOOOOOOOkkkk00000000ko:;;,,,,,,;cloolcc:::cclllolllllc;:lokkkkOkkOkxxxxkkkkkkOo               
               oOOO0000kkkkO00000000Ox:;;;,,,,;:looolccc::cllllllllllc::okkkkkkkkkxxddxxkkkkkkl               
               oOOO000Okkkk0000000000kc;;;,,,,;:cc:::;;::ccclllllllllllokkkkkkkxkkxddddxxxkkkkl               
               oOOOOOOkxkkk0000000000Ol;;;,,,,,,;''',,,;:lccllllllllloxkOOkkkkkkkkxddddxxxxkkkl               
               oOOOOOOkxxkO0000O000O0Ol;;,,,,,,,;;,,''',c;cccllllloxkOOOOOOkOkkkkkxddddxxxxkkkl               
               oOOOOOOxxxxOOO00OOOOOOOd;;,,,,,,,,,,,,,,,::lclllloodkkOOOOOOkkkkkkkdddddxxxxkkkl               
               oOOOO0OkxxxOOO0OOOOOOOOkc;;,,,,'';,'',',,::lcllllodkOOOOOO0OOOOOkkkxddddxxxxxxkl               
               oOOOOOkxxxkOOOOOOOOOOOOkl;;,,,'.';,'''',,:cllllllodkkOOOOOOOOOOOkkkxdddxxxxxxxxl               
               oO000OkxxkkOkkOOkOOOOOko:;;,,,,..;,'',,,,:cllllllodkkO00OO0OOOOkkkxdddxxxxxxxxxl               
               cxxxxxxxxxxxxxxxxxxxxxxxxxxxddddxxxxdddddddxxxxxddddoooodddddddxddxxxxdddooodddc               
               cxxxxxxxxxxxxxxxkkkxxxxxxxddddddxxxddooddxxxdddddxxdoooodddddxxxxxxxxxdddooodddc               
               cxxxxxxxxxxxxxkkOOkxkOkkkkkkxddddddddodxkkkkxxdddddoooooddddxxkxxkxxxxxxdooodddc               
               cxxxxxxxxxxxxkOOOxxxkOkOOOOOxdddxxkxddxkOOOOkxxxxkxdooodxkxkkOOkxOOkxxxxdooddddc               
               cxxxxxxxxxkkkkkkxxkOOOOOOkkkxxxxxdddddxkOOOkkxxdxxdddooddxkkOO0OkxkOOOxddooddddc               
               lxxxxxxxkOOOOkxxxkOOOkkkxxkOOxxxxxxxxxxxkOOkxxxkkddddooddodxkOOOOxxkkxdddoodxxxc               
               lxxxxxkkO0000OkxkOOOkxkOkxkOOxxxkkkxdolldxxxkkOOkkxdoooxxdddddkOOOxxddxkkxddxxxc               
               lxxxxxOOO00000OkxxkkxxOOOkkkkxxxkxl;,,,,,;lxOOOkkkxxdooxxdxxxddxkOxxxxkkkkkxxxxl               
               lxxkxkOO000000kxxkxkOkkOkkOOkxxxxo;'''',;;,lkkkkkkkxdooddddxxddxxdddxkOOOOOOOkxl               
               lkkOkkOO0000OOkxkOkkkkOOkO00kxxxdc;:ccllll::xxxkkkxddoodkkdddddxxxxdxkOO0000Okxl               
               lkkkxxxkOOOOkxxxkOOkxk00OO00kxxxd::cccllllc:odddxxoddoodkkxxkxdddkxdxkO0000OOkko               
               lkkkxkkkkkkkxxxxxxxxxxO0OOO0kxxxdc::::cccclldxdddxdddoodkkxkOkxdxxdddxxO00OkkkOo               
               ckOOOOOOxxxkOOOOOkxkkkkOOkOOkxxkklc:::clllllddddxkkxooodxxdOkxxxdxxxkkkkkkkkkkko               
               lkkOOOOkxxxkOOOOOkxxkxxxxkkkxxxkkocc::clllooddxxddxxdooodddxxxkkdxkOOO0Okxk0000d               
               lxkkkkkkkxkkkkkkkxdxxdddxkOOxxxdddolccclllldxkkkxdddooooxkxddxxxddkOOOOOkxkO000o               
               lxdxdxkkxxkkxddddxxkkxdddxkkxxxxddxdl::cllloloxkxdooooodxxxodxkxdoxkkkOOOkO000Oo               
               lxdxxxxxdddxxxxddkkkkxxkxxxkxddxxdddl::clllo,.,;::lodoodxxddxdxkkxdddddkkxkOOkkl               
               lddkkkkkxdxkkkkxdxkkkxkkxxxkxdddddodl::::clo'.......',;lddodxddkkOxdxkxxdddxkOkl               
               cddkkkkkddxkkkkdddkkxxkxxxxxddddoc:loll::cdl'...........;ddddxdxOkddkkkkkdxkOOOo               
               lxxxxkxxdddxkxddxxdxxxxkkxxddol;'..;odocclo;............'ododdodxxxxxxkkxddxOOOo               
               lkkxxxxkkkxddddkkkxdddkOOkxoc;'....,;cl::;,.............'odddooodkOkxdxxdxxxxkkl               
               lkkxxxxxxxxxddxxxxxdxkkOOkxo'........';;;;'..............lxxxxddxkkkkxxxxkkxxxxo               
               lkkkxxkkkkkxodkkkkxxxxkOOkxo'........';;;,...............lxxxxddxkOOkkxxkkkkkxxo               
               lkkkdxkkkkkxodkkkkkxxxxkkxdo,.........,,;,...............:xxddddxOOOOOxxkkkOOkxo               
               lkkxdxkkkkkdddxxxkkxxkkxxxxo'.........,,,'................oddxddxOOOOOxxkkkkOxxo               
               lkxxddxxxxxdddxxxxxxxkkxxkkd'.........,,'.................cddxdodkkkkkdxkkkkkxxl               
               lkkxddxxxdxddxxxkkkxxxxxxxxd,.'.......','.................;ddddodxxxxxddxxxxkxxl               
               lxxxddxkxxxddxkkkkkxxxkkkxddc:l'......'''.................,dddoodxxxxxddxxxxkxdl               
               cdddddxxxddddxxxxxxxxxkkxxdoc;:'......'''.................'ddddoddddddddddxxxxdc               
               cddddddddddoodddddddxxxxxxoc;;:'......''..................'oxddddddddddddddddddc               
               cdddodddddddddddddddxxxxxdl;;;:'......'...................'oddddddddddddddddddoc               
               :oooooooooooooooodddxxxxxdl'..........'............  .....'ddddddddddddddddddooc               
               :oooooooooooooooooddddddddo:..........,,''.........  .....'ddddddddddddddddddooc               
               :oooooooooooooooooooddddddoollll,.....;;;;,...............;ddddddddddddddddddooc               
               :ooooooooooooooooooooooooooooddl'.....;;;;;'..............;dddddddddxxxxxdddddoc               
               :ooooooooooooooooooooooooooooooc''....;;;;;'..'...........;ddddddddxxxxxxxxdddoc               
               cxkxxxxxxxxxxxxxxxxxxxxxxxxxddddxxxxdddddddxxxxxddddoooodddddddxddxxxxdddooodddc               
               cxxxxxxxxxxxxxxxkkkxxxxxxxddddddxxxddooddxxxdddddxxdoooodddddxxxxxxxxxdddooodddc               
               cxxxxxxxxxxxxxkkOOkxkOkkkkkkxddddddddodxkkkkxxdddddoooooddddxxkxxkxxxxxxdooddddc               
               cxxxxxxxxxxxxkOOOxxxkOkOOOOOxdddxxkxddxkOOOOkxxxxxxdooodxkxkkOOkxOOkxxxxdooddddc               
               cxxxxxxxxxkkkkkkxxkOOOOOOkkkxxxxxdddddxkOOOkkxxxxxdddooddxkkOO0OkxkOOOxddooddddc               
               lxxxxxxxkOOOOkxxxkOOOkkkxxkOOxxxxxxxxdlcccloxxxkkddddooddodxkOOOOxxkkxdddooddddc               
               lxxxxxkkO0000OkxkOOOkxkOkxkOOxxxxkkxc,''''',:okOkkxdoooxxdddddkOOOxxddxkkxddxxdc               
               lxxxxxOOO00000OkxxkkxxOOOkkkkxxxkkxl;,,,,;::;:xkkkxxdooxxdxxxddxkOxxxxkkkkkkxxxl               
               lxxkxkOO000000kxxkxkOkkOkkOOkxxxkkx::cclllloc:dkkkkxdooddddxxddxxdddxkOOOOOOOkxl               
               lkkOkkOO0000OOkxkOkkkkOOkO00kxxxxxx::::cclllc:dkkkxddoodkkdddddxxxxdxkOO0000Okxl               
               lkkkkxxkOOOOkxxxkOOkxk00OO00kxxkxddc:::::cccllddxxoddoodkkxxkxdddkxdxkO0000OOkko               
               lxkkxkkkkkkkxxxxxxxxxxO0OOO0kxxxxxxcc::::clllodddxdddoodkkxkOkxdxxdddxxO00OkkkOo               
               ckOOOOOOxxxkOOOOOkxkkkkOOkOOkxxkkkxolc:::cllodddxkkxooodxdxOkxxxdxxxkkkkkkkkkkko               
               lkkOOOOkxxxkOOOOOkxxkxxxxkkkxxxkkkdddoc:clllodxxddxxdooodddxxxkkdxkOOO0Okxk0000d               
               cxkkkkkkkxkkkkkkkxdxxdddxkOOxxxddddxxlcccclllc;clodddoodxxxdddxxddkkOOOOkxkO000o               
               lxdddxkkxxkkxddddxxkkxdddxkkxxxddddxxc::ccclo;....,;:cloxxddddkxdodxkkOOOkO000Oo               
               lxdxxxxxdddxxxxddkkkkxxkxxxkxddxxdddoc::c::ld;.........':ododdxkkxdddddxkxkOOkkl               
               lddkkkkkxdxkkkkxdxkkkxkkxxxkxddddl:,,lc:::cdl'...........,odxddkkOxdxkxxdddxkOOl               
               cddkkkkkddxkkkkdddkkxxkxxkxxddoc,'...lol::c:'............'oddxdxOkddkkkkkdxkOOOo               
               lxxxxkxxdddxkxddxxdxxxxkkxxdo:,......;o:;;;'..............ldddodxxxxxxkkxddxOOOo               
               lkkxxxxkkkxddddkkkxdddkOOOkdl'.......,c;;;,...............ldddoodkOkxdxxdxxxxkkl               
               lkxxxxxxxxxxddxxxxxdxkkOOOkxo,........,;;;'...............:xxxddxkkkkxxxxkkxxxxo               
               lkkkxxkkkkkxodkkkkxxxxkOOkxdd:........,,;,'...............'oxxddxkOOkkxxkkkkkxxo               
               lkkkdxkkkkkxodkkkkkxxxxkkxdddc........'','.................;ddddxOOOOOxxkkkOOkxo               
               lkkxdxkkkkkdddxxxkkxxkkxxxkddl'.......,','..................ldddxOOOOOxxkkkkOxxo               
               lkxxddxxxxxdddxxxxxxxkkxxkkxdo;.......''''..................:dxddkkkkkdxkkkkkxxl               
               lkkxddxxxdxddxxxkkkxxxxxxxxddoc.......'.''..................lddddxxxxxddxxxxkxxl               
               lxxxddxkxxxddxkkkkkxxxkOkxddoo;.......'.'..................,oooodxxxxxddxxxxkxdl               
               cdddddxxxddddxxxxxxxxxkkxxddoc'.......'....................cddddddddddddddxxxxdc               
               cddddddddddoodddddddxxxxxolll:'.......'...................'odddddddddddddddddddc               
               cdddodddddddddddddddxxxxdc::cc;.......''......'..........'odddddddddddddddddddoc               
               :oooooooooooooooodddxxxxdoc::c,.......,,,,....;;;;,.....,ldddddddddddddddddddooc               
               :ooooooooooooooooodddddddddc'..,::....,;;;....,::::'....:ddddddddddddddddddddooc               
               :oooooooooooooooooooddddddoo,,ldo,....,;;;'...';:cc,....,ddddddddddddddddddddooc               
               :ooooooooooooooooooooooooooooddl,'....;;;;'....';::,.....oddddddddddxxxxxxddddoc               
               :ooooooooooooooooooooooodddddddc''...';::;,.....,;;'.....cdddddddddxxxxxxxxdddoc               
               cxkxxxxxxxxxxxxxxxxxxxxdxxxxdddddxxxdddddddxxxxxddddoooodddxxddxddxxxxdddooodddc               
               cxxxxxxxxxxxxxxxkkkxxxxdxxdddddddxxddooddxxxdddddxxdooooddddxxxxxdxxxxdddooodddc               
               cxxxxxxxxxxxxxkkOOkxkOkkkkkkxddddddddooxkkkkxdxxdddoooooddddxxkxxkkxxxxxdooddddc               
               cxxxxxxxxxxxxkOOOxxxkOOOOOOOxdddxxxxddxdolllcloxxxxdooodxkkkkOOkxOOkxxxxdooddddc               
               cxxxxxxxxxkkkkkkkxkOOOOOOkkkxxxxxdddddo:,''''';ldxdddooodxkkOO0OkxkOOOxddooddddc               
               lxxxxxxxkOOOOkxxxkOOOkkkxxkOOxxxxxxkxo:,'''',,,;oddddooddodxkOOOOxxkkxddddoddddc               
               lxxxxxkkO0000OkxkOOOkxkOkxkOOxxxxkkkxc;::cllllc;lkxdoooxxdddddkOOOxxddxkkxddxxxc               
               lxxxxxOOO00000OkxxkkxxOOOkkkkxxxkkkkx;;:::cllll:lkxxdooxxdxxxddxkOxdxkkkkkkkxxxc               
               lxxkxkOO000000OxxkxkOkkOkkOOkxxxkkkOxc:::::cccllxkxxdooddddxxddxxdddxkOOOOOOOkxl               
               lkkOkkOO0000OOkxkOkkkkOOkO00kxxxxxkkocc::::cllloxkxddoodkkdddddxxxxdxkOO0000Okxl               
               lkkkkxxkOOOOkxxxkOOkxk00OO00kxxkxddxdlc::::cllldxddddoodkkxxkxdddkxdxkO0000OOkko               
               ckkkxkkkkkkkxxxxxxxxxxO0OOO0kxxxxxkxddoc::cclloodddddoodkxdkOkxdxxdddxxO00Okkkko               
               ckOOOOOOkxxkOOOOOkxkOkkOOkOOkxxkkkkxddlc:::clllldxxddoodxdxOkxxxdxxxkkkkkOkkkkko               
               ckkOOOOkkxxkOOOOOkxxkxxxxkkkxxxkkxddxxl::::clo:',codddoodddxxxkkdxkOOO0OxxkO000d               
               cxkkkkkkkxkkkkkkkxdxxdddxkOOxxxxxddollccc:cclo,....',;cldxdoddddddkkOOOOkxkO000d               
               cxdddxkkxxkkxddddxxkkxdddxkkxxdxdl;,':::c::coo'.........';ooddxxdodxxkOOkxO000Oo               
               lkdxxxxxdddxxxxddkkkkxxkxxxkddlc,'...;;:cccdo,............:ddoxxxxdodddxkxkOOkkl               
               lxdkkkkkxdxkkkkxdxkkkxkkxxxkd;'......';:c:;:,.............;dxddxkOxdxkxxdddxkkkl               
               cddkkkkkddxkkkkdddkkxxkxxxxxo'........:c:::,..............;dxxdxOxddxkkkkdxOOOOo               
               lxxxxkxxdddxkxddxxdxxxxkkxxdo'........cc;;;'.;:,'.........'oddodxxxxxxkkxddxOOOo               
               lkkxxxxxkkxddddkkkxdddkOOkkdo'........:c;;,''cccc;........'oddoodkOkxdxxdxxxxkkl               
               lkkxxxxxxxxxddxxxxxdxkkOOOkdo,........,;,,,.;cccc:.........:ddddxkkkkxdxxkkxxxxo               
               lkkkxxkkkkkxddkkkkkxxxkOOkxdo,........,;;,'.';:cc:..........;dddxkkkkkxxkkkkOxxo               
               lkkkdxkkkkkxodkkkkkxxxxxxxddd;........,,,'....,;:;...........cooxOOOOkxxkkkOOkxo               
               okkxdxkkkkkdodxxxxxxxkkxxxkdd:........,,'......'''.'.........'ldxkOOOOxxkkkkOxxo               
               lkxxddxxxxxdddxxxxxxxkkxxkkxdc........',''..........'........,oodxkkkkdxkkkkkxxl               
               lkkxddxxxdxddxxxkkkxxxxxxxxdo:,'......,,'...................'ododxxxxxddxxxxkxxl               
               lxxxddxxxxxddxkkkkkxxxkkkxdlc::,......,'...................'lddodxxxxxddxxxxkxdl               
               cdddddxxxxdddxxxxxxxxxkkxxdc:::;......,.................,,:oxdddddddddddddxxxxdc               
               cddddddddddoodddddddxxxxxxdl:;;,.''...,'................cddddddddddddddddddddddc               
               cdddodddddddddddddddxxxxxxdol,.,coc..';;;'..............,oddddddddddddddddddddoc               
               :oooooooooooooooodddxxxxxdddollodoc'.,;;;'...............:dddddddddddddddddddooc               
               :oooooooooooooooooddddddddddddddo:;..;;;;,...............,dddddddddddddddddddoo:               
               :oooooooooooooooooooddddddddddddl,'.'::;;;'...............lddddddddddddddddddoo:               
               :oooooooooooooooooooooooddoodddo:'',;::::;,...............;dddddddddxxxxxxddddoc               
               :ooooooooooooooooooooooodddddddo;',,;:cc::;,..............'odddddddxxxxxxxxdddoc               
               cxkxxxxxxxxxxxxxxxxxxxxdxxxxdddddxxxdddddddxxxxxddddoooodddxxddxddxxxxdddooodddc               
               cxxxxxxxxxxxxxxxkkkxxxxdxxdddddddxxddooddxxxdddddxxdooooddddxxxxxdxxxxdddooodddc               
               cxxxxxxxxxxxxxkkOOkxkOkkkkkkxddddddddooxxxxxdddxdddoooooddddxxkxxkxxxxxddooddddc               
               cxxxxxxxxxxxxkOOOxxxkOOOOOOOxdddxxxxddxdc;;,,,:odxxdooodxkkkkOOkxOOkxxxxdooddddc               
               cxxxxxxxxxkkkkkkkxkOOOOOOkkkxxxxxdddddoc,..''',,cddddooodxkkOO0OkxkOOOxddooddddc               
               lxxxxxxxkOOOOkxxxkOOOkkkxxkOOxxxxxxkxoc;;;;;:::;;odddooddodxkOOOOxxkkxddddoddddc               
               lxxxxxkkO0000OkxkOOOkxkOkxkOOxxxxkkkkd;::ccllool;dxdoooxxdddddkOOOxxddxkkxddxxxc               
               lxxxxxOOO00000OkxxkkxxOOOkkkkxxxkkkkkd;::::clcclcxxxdooxxdxxxddxkkxdxkkkkkkkxxxc               
               lxxkxkOO000000OxxkxkOkkOkkOOkxxxkkkkklcc::::lclldxkxdooddddxxddxxdddxkOOOOOOOkxl               
               lkkOkkOO0000OOkxkOkkkkOOkO00kxxxxxkkklcc::::lllldkxdooodkkdddddxdxxdxkOO0000Okxl               
               lkkkkxxkOOOOkxxxkOkkxk00OO00kxxkxddxxdoc:::clloodddddoodkkxxkxdddkxdxkO0000OOkko               
               ckkkxkkkkkkkxxxxxxxxxxO0OOO0kxxxxxkxdddc:::clloodddddoodkxdkOkxdxxdddxxO00Okkkko               
               ckOOOOOOkxxkOOOOOkxkkkkOOkkOkxxxkkxdddoc:::clllldxxddoodxdxkkxxxdxxxkkkkkOkkkkko               
               ckkOOOOkkxxkOOOOOkxxkxxxxkkkxxxxkxddddl:::cclo:',cldddoodddxxxkkdxkOOO0OxxkO000d               
               cxkkkkkkkxkkkkkkkxdxxdddxkkkxdddol:;;cccc:ccco,....',:codxdoddddddkkOOOOkxkO000o               
               cxdddxkkxxkkxddddxxkkxdddxkkdl:,'...':::c:codl'........',cooddxxdodxxkOOkxO00OOo               
               lkdxxxxxdddxxxxddkkkkxxkdxxkc'.......:;:lcloc'.,;;'.......cdddxxxxdodddxkxkkOkkl               
               lxdkkkkkxdxkkkkxdxkkkxkkxxxx;........,:::::;..;:ccc;......:xxddxkOxdxkxxdddxkkkl               
               cddkkkkkddxkkkkdddkkxxkxdxxd,........'c:::;'..;::cc,......;dxxdxOxddxkkkkdxOOOOo               
               lxxxxkxxdddxkxddxxdxxxxkkxdl'........'l:;,;'...':cc;......,dddodxxxxxxkkxddxOOOo               
               lkkxxxxxkkxddddkkkxdddkOOkxl'.........::;,'.....':c;......,dddoodkOkxdxxdxxxxkkl               
               lkkxxxxxxxxxddxxxxxdxkkOOOxl'.........;,,,'.......'.......'cxdddxkkkkxdxxkkxxxxo               
               lkkkxxkkkkkxddkkkkkxxxkOOkxl..........,,,,...........,......:dddxkkkkkxxkkkkOxxo               
               lkkxxxkkkkkxodkkkkkxxxxxxxo:.....'....,'''...................,loxkOOOkxxkkkOOkxo               
               okkxdxkkkkkdodxxxxxxxkkxxxo'..,:cc'...,,,'.....................ldkOOOOxxkkkkOxxo               
               lkxxddxxxxxdddxxxxxxxkkxxkl;,;::::,...,,'.....................:odxkkkkdxkkkkkxxl               
               lkkxddxxxdxddxxxkkkxxxxxxxl,',;;::'...,,''...................;dodxxxxxddxxxxkxxl               
               lxxxddxxxxxddxkkkkkxxxkkkxo;,'',,'....'''...................;ododxxxxxddxxxxkxdl               
               cdddddxxxxdddxxxxxxxxxkkxxxoc;..,.....'.................,::lddddddddddddddxxxxdc               
               cddddddddddoodddddddxxxxxxddooooo'...',.................,odddddddddddddddddddddc               
               cdddodddddddddddddddxxxxxxddddddl....,;;,'...............:ddddddddddddddddddddoc               
               :oooooooooooooooodddxxxxxddddoooc....,;;;'...............'oddddddddddddddddddooc               
               :ooooooooooooooooodddddddddoooooc....;:;;,................cddddddddddddddddddoo:               
               :oooooooooooooooooooddddddoooddd:....,;::;'...............,ddddddddddddddddddoo:               
               :oooooooooooooooooooooooddoodddd,....,::::;'...............ldddddddxxxxxxxddddoc               
               :oooooooooooooooooooooooddoodddd,....::c:::;'..............cdxdddddxxxxxxxxdddoc               
               cxkxxxxxxxxxxxxxxxxxxxxdxxxxdddddxxxdddddddxxxxxddddoooodddxxddxddxxxxdddooodddc               
               cxxxxxxxxxxxxxxxkkkxxxxdxxxddddddxxddooddxxxdddddxxdooooddddxxxxxdxxxxdddooodddc               
               cxxxxxxxxxxxxxkkOOkxkOkkkkkkxddddddddooxkkkkxddxddooooooddddxxkxxkxxxxxddooodddc               
               cxxxxxxxxxxxxkOOOxxxkOOOOOOOxdddxxxxddxxdoooloddxxxdooodxkkkkOOkxOOkxxxxdooddddc               
               cxxxxxxxxxkkkkkkkxkOOOOOOkkkxxxxxddddddc,'''',;ldxdddooodxkkOO0OkxkOOOxddooddddc               
               lxxxxxxxkOOOOkxxxkOOOkkkxxkOOxxxxxxkxoc;'''''',;lddddooddodxkOOOOxxkkxdddooddddc               
               lxxxxxkkO0000OkxkOOOkxkOkkkOOxxxkkkkxl;::cclllc;:xxdoooxxdddddkOOOxxddxkkxddxxxc               
               lxxxxxOOO00000OkxkkkxxO0Okxkkxxxkkkkxc;:::cllll:cxkxoooxxdxxxddxkkxdxkkkkkkkxxxc               
               lxxkxxOO000000OxxkxkOkkkkkOOkxxxkkkkxlc::::cccccdkkxdooddddxxddxxdddxkOOOOOOOkxl               
               lkkOkkOO0000OOkxkOkkkkOOkO00kxxxxxkkdcc::::cloloxkxdooodkkdddddxxxxdxkOO0000Okxl               
               lkkkkxxkOOOOkxxxkOkkxk00OO00kxxkxddxdoc::::cllloxddddoodkkxxkxdddxxdxkOO0000Okko               
               lkkkxkkkkkkkxxxxxxxxxxO0OOO0kxxxxxkxddoc::cllododddddoodkxxkOkxdxxddddxO00Okkkko               
               ckOOOOOOkxxkOOkOOkxxkkxOOkkOkxxxkkxddoc:;:clloddxxxxooodxdxkkxxxdxxxkkkkkkkkkkko               
               ckkOOOOkkxxkOOkkOkdxxxxxxkkkxxxxkxdddoc:::cllooxddxxdooodddxxxkkdxkOOO0Okxk0000d               
               cxkkkkkkkxxkkkkkkxddxdddxkOkdddolc;:llcc:cccll,:llddooodxxddddddddkOOOOOkxkO000o               
               cxxxxxkkxxkkxxdddxxkkxdddxxdc:,'....c::ccccco;....,:coodxxdoddxxdodxkkOOkxO000Oo               
               lkdxxxxddddxxxxxxkkkkxxxddo,........::;cclodo,.......',coxoodoxxkxddodxxkxkkkkxl               
               lxdkkkkkxdxkkkkxdxkkkxkkdd:..........;:::cll,.....';:,'.'lddxddxkkxdxkxxdddxkkkl               
               cddkkkkkddxkkkkdddkkxxkddo,..........;l::::,......,ccc:'.cdddxdxOxdxxkkkkdxOOOOo               
               lxxxxkxxdddxxxddxxddddddl'...........;l:::;.......':cc:'.cddddodxxxxxxkkxddxOOOo               
               lkkxxxxxkkxddodkkkxddddxc............,:;;;,........,cc,..:dxddoodkOkxdxxdxxxxkkl               
               lkkxxxxxxxxdddxxxxxddxkx;............';;;;'........';c,..:xxxxddxkkkkxdxxkkxxxxo               
               lkkkxxkkkkkxddkkkkxxdddl,............';,,,...........''..,dxxxddxkkkkkxxkkkkOxxo               
               lkkkxxkkkkkxodxxxxxxdo;..........':::;;;,,................cxddddxkOOOkxxkkkOOkko               
               okkxdxkkkkkdodxxxxxdd:..........';::::;,,'................':odddxkOOOOxxkkkkOxxo               
               okxxddxxxxxdodxxxxxddl'.........',,,,','''.......... .......'coodxkkkkdxkkkkkxxl               
               lkkxddxxxdxddxxxxkkxdd,...............,,'....................:oodxxxxxddxxxxkxxl               
               cxxxddxkxxxddxxxkkkxddol;,''''........,,,...................,ooodxxxxxddxxxxkxxl               
               cxddddxxxxddddxxxxxddxxxxddool........'''..................'odddddddddddddxxxxdc               
               cddddddddddodddddddddxxxxdddol........'................,,':odddddddddddddddddddc               
               cdddodddddooooooddddxxxxddddoo'.......'................:ddddddddddddddddddddddd:               
               :ooooooooooooooooddddxxxdddooo........,;;'..............;dddddddddddddddddddddo:               
               :oooooooooooooooooddddddddoooo........,,;'...............lddddddddddddddddddddo:               
               :ooooooooooooooooooodddddooodo'.......',;,...............:dddddddddddddddddddoo:               
               :ooooooooooooooooooooooooodddd'.......',;;'...............lddddddddxxxxxxxxxdoo:               
               :ooooooooooooooooooooooooodddd'.......',;;,'..............cddddddddxxxxxxxxxddo:               
               cxxxxxxxxxxxxxxxxxxxxxxdxxxxdddddxxxdddddddxxxxxddddooooddddxddxddxxxxdddooddddc               
               cxxxxxxxxxxxxxxxkkkxxxxdxxxddddddxxddooddxxxdddddxxdooooddddxxxxxxxxxxdddooodddc               
               cxxxxxxxxxxxxxkkOOkxkOkkkkkkxddddddddodxkkkkxxddddooooooddddxkkxxkkxxxxddooodddc               
               cxxxxxxxxxxxxkOOOxxxkOOOOOOOxdddxxxxddxxkkkkkxxxxkxdooodxkkkkOOkkOOkxxxxdooddddc               
               cxxxxxxxxxkkkkkkkxkOOOOOOkkkxxxxxddddoc:;;;:lodddddooooodxkkOO0OkxkOOOxddooddddc               
               lxxxxxxxkOOOOkxxxkOOOkkkxxkOOxxxxxxxdc'''''',;ldxdoddooddodxkOO0Oxxkkxdddooddddc               
               lxxxxxkkO0000OkxxOOOkxkOkkkOkxxxkkkxl:;;;;;::;;xkkxdoooxxdddddkOOOxxddxkkxddxxxc               
               lxxxxxOOO00000OkxxkkxxO0Okkkkxxxkkkx::cclllooc;dkkkxoooxxdxxxddxkkxdxkkkkkkkxxxc               
               lxxkxxOO000000kxxkxkOkkkkkOOkxxxkkkx:::::clclccxkkkxdooddddxxddxxdddxkOOOOOOOkxl               
               lkkOkkOO0000OOkxkOkkkkOOkO00kxxxxxkdlc:::clllloxkkxdooodkkddddxxxxxdxkOO0000Okxl               
               lkkkxxxkOOOOkxxxkkkkxk00OO00kxxkdddolc:::cclllodxddddoodkkxxkxdddxxdxkOO0000Okko               
               lkkkxxkkkkkkxxxxxxxxxxO0OOO0kxxxxxxxdl:::clllddddxdddoodkxxkOkxdxxddddxO00Okkkko               
               ckOOOOOOkxxkOOkOOkxxkkxOOkkOxxxxkkxxdc:::cllodddxxxxooodxdxkkxxxdxxxkkkkkkkkkkko               
               ckkOOOOkkxxkOOkkOxdxxxdxxkkkxxxxkxdddc:::cllddxxddxxdooodddxxxkkdxkOOO0Okxk0000d               
               cxkkkkkkkxxkkkkkkxddxddddkkkxdddolclocccccllo:oxxoddooodxxddddddddkOOOOOkxkO000o               
               cxxxdxkkxxkkxxdddxxkxxddddkxoc:,'.'co::cccclc'.',:lodoodxxdoddxxdodxkkOOkxO000Oo               
               lkdxxxxddddxxxxxdkkkkxxxdl;''......cl::cclod:......',cldxxdoddxkkxddddxxkxkOkkxl               
               lxdkkkkkxdxkkkkxdxkkkxkkd;.........,;::ccodl...........;ddodxddkOkxdxkxxddxkkkkl               
               cddkkkkkddxkkkkdddxkxxxdl...........':::::;.............lddodxdxOxdxkkkkkdxOOOOo               
               lxxxxkxddddxxxddxxdddddo,...........'cl::;,.............:dddddodxxxxxxkkxddxOOOo               
               lkkxxxxxkkxdoodkkkxdddxl.............::::;'..........''':ddxddoddkOkxdxxdxxxxkkl               
               lkkxxxxxxxxdodxxxxxddxxc.............;;,;;..........,cc:cdxxxxddxkkkkxxxxkxkxxxo               
               lkkkxxkkkkkxodxxxxxxddd:.............,;;,'..........;cccoxxxkxddxkOkkkxxkkkkOxxo               
               lkkkxxkkkkkxodxxxxxxdo:'.......,,,,'.';,,'..........:cc:cdxxddddxOOOOOxxkkkOOkko               
               okkxdxkkkkkdodxxxxxdo,.......';::::...,,,...........;::';ddddxxdxOOOOOxxkkkkOxxo               
               okxxddxxxxxdodddxxxdl........';;::;...,,'............''..;oddxxddkkkkkdxkkxkkxxl               
               lkkxddxxddxddxxxxxxxd;........',,'....,''.................'loddddxxxxxddxxxkkxxl               
               cxxxddxxxxxddxxxxxxxdc................,,'..........  .....'oxdoodxxxxxddxxxxkxxl               
               cdddddxxxddoodxxxxxddxdoc:;;..........,'..................oxxdddddddddddddxxxxdc               
               cddddddddddooddddddddxxxxddl..........'..................:dddddddddddddddddddddc               
               cddoooddddoooooodddddxxxdddl..........'.............:lccodddddddddddddddddddddd:               
               :ooooooooooooooooddddddddddc..........';,...........,oddddddddddddddddddddddddo:               
               :ooooooooooooooooododdddddo:..........';,............,odddddddddddddddddddddddo:               
               :oooooooooooooooooooodooodo:..........',;'............lddddddddddddddddddddddoo:               
               :oooooooooooooooooooooooood;..........',;,............:dddddddddddddddddxxxxdoo:               
               :oooooooooooooooooooooooood;..........';:;'...........'odddddddddddxxxxxxxxxddo:               
               cxxxxxxxxxxxxxxxxxxxxxddxxxxdddddxxxdddddddxxxxxddddooooddddxdxxxxxxxxdddodddddc               
               cxxxxxxxxxxxxxxxkkkxxxdddddddddddxxddooddxxxdddddxxdooooddxdxxxxxxxxxxdddodddddc               
               cxxxxxxxxxxxxxkkOOkxkkkkkkkkxdddddddoooxkkkkxxxddddoooooddddxkkxxkkxxxxddodddddc               
               cxxxxxxxxxxxxkOOOxxxkkkOOOOOxdddxxxxddxkOOOOOkxxxxxdooodxkkkkOOkxOOkxxxxdooddddc               
               cxxxxxxxxxkkkkkkkxkOOkOOOkkkxxddddddddxkOOOOkxxddddddooddxkOOOOOkxkOOOxddooddddc               
               lxxxxxxxkOOOOkxxxkOOOkkkxxkOkxxxxxxdlc::cldxxxxkxdoddodddodxkOO0Oxxkxxdddooddddc               
               lxxxxxkkO0000OkxxOOOkxkOkkkOkxxxxko;'''''',cdkkOkkxdoooxxddddxkOOOxxddxkkxddxxxc               
               lxxxxxOOO00000OkxxkkxxO0Okxkkxxxkxl;;;,;::;,ckkkkkkxdooxxdxxxddxkOxdxkkkkkkkxxxc               
               lxxkxxOO000000kxxkxkOkkkkkOOkxxxxo:cccloool;:xkkkkkxdooddddxxddxxdddxkOOOOOOOkxl               
               lkkOkkOO0000OOkxkOkkkkOkkO00kxxxxo:c::clcll:cdxkkkxddoodkkxdddxxxxxdxkOO0000Okxl               
               lkkkxxxkOOOOkxxxkkkkxk00OO00kxxkxdoc::clcllcodddxddddoodkkxxkxdddxxdxkO00000Okko               
               lkkkxxkxkkkkxxxxxxxxxxO0OOO0kxxddool:::clllloxxddxdddoodkkdkOkxdxxdddxxO00Okkkko               
               ckOOOOOOkxxkOOkOOkxxkkxOOkkOxxxxkxdl::clllodxdddxxxxooodxxxOkxxxdxxxkkkkkOkkkkko               
               ckkOOOkkkxxkOOkkOxdxxxdxxkkkxxxxkxdl::clllodddxxddxkdooodddxxxkkdxkOOO0Oxxk0000d               
               cxkkkkkkkxxkkkkkkxddxdddxkOkxdddddol::cccloddxkkxddddoodxxxdddddddkOOOOOkxk0000o               
               cxxxdxkkxxkkxddddxxkxxdddxkkddddolol:::ccllc;lxkkdooooodxxddddxxdodxkkOOOkO000Oo               
               lkdxxxxdddddxxxxdkkkkxxxddxkdol:,':lc::cccoc...,:clodooodxdoddxkkxddddxxkxkOkkxl               
               lxdkkkkkddxxkkkxdxkkkxkkddol;'....;olccc:ld:........,:odddodxddkOOxdxkxxdddkkkkl               
               cddkkkkkddxkkkkdddxkxxxdc,........,lllolodo'..........,odddodxdxOxdxkkkkkdxOOOOo               
               lxxxxkxddddxxxddxxdddddd,...........;cl:::'............cdodoodoxxxxxxxkkxddkOOOo               
               lkkxxxxxkkxdoodkkkxdoddo............,:c::,.............:dddxddoddkOkxdxxdxxxxkkl               
               lkkxxxxxxxxddddxxxxddxxl............'::;;'.............;ddxxxxddxkkkkxdxxkxkxxxo               
               lkkkxxkkkkkxddxxxxxxddxc............':;;;....;:;,......;ddxxkxddxkOOOkxxkkkkOxxo               
               lkkkxxkkkkkxodxxxxxxdddc.............,;,,...':ccc,.....,ddddxdddxOOOOOxxkkkOOkko               
               okkxdxkkkkkdodxxxxxddxxl.............,;;'...,::c:'.....:dddodxxdxOOOOOxxkkkOOxxo               
               okxxddxdddxdodddxxxdxxxl..............,,.....';::......;dddodxxdxkkkkkdxkkxkkxxl               
               lkkxddxxddxddxxxxxkddxo,..............,,.......',.......codoodxddxxxxxddxxxkkxxl               
               cxxxddxxxxxddxxxxxxdddc;c:'...........,,'................ldxdooodxxxxxddxxxkkxxl               
               cdddddxxxddoddxxxxxdddlcccc,..........,'................:dddddooddddddddddxxxxdc               
               cddddddddddoooddddddddc:;:c:..........,'...............:dddddddddddddddddddddddc               
               cddoooddddooooooddddddo:,;;'..........'...........,',:ldddddddddddddddddddddddd:               
               :ooooooooooooooooddddddc'.............'..........;ddddddddddddddddddddddddddddo:               
               :ooooooooooooooooododdool:...........'::;'.......'odddddddddddddddddddddddddddo:               
               :oooooooooooooooooooooooo;...........':::;........cddddddddddddddddddddddddddoo:               
               :oooooooooooooooooooooddo,...........,:c:;,.......cdddddddddddddddddddddxxxxdoo:               
               :oooooooooooooooooooooddo'...........,:c:;,..'....cdddddddddddddddddxxxxxxxxddo:               
               cxxxxxxxxxxxxxxxxxxxxxddxxxxdddddxxxdddddddxxxxxddddoooodddxxdxxxxxxxxdddodddddc               
               cxxxxxxxxxxxxxxxkkkxxxdddddddddddxxddooddxxxdddddxxdooooddxdxxxxxxxxxxdddodddddc               
               cxxxxxxxxxxxxxkkOOkxkkkkkkkkxdddddddoodxkkkkxxxddddoooooddddxkkxxkkxxxxddooddddc               
               cxxxxxxxxxxxxkOOOxxxkOkOOOOOxdddxxxxddxkOOOOOkxxxxxdooodxkkkkOOkxOOkxxxxdooddddc               
               cxxxxxxxxxkkkkkkkxkOOOOOOkkkxxddddddddxkOOOOkxxddddddooddxkOOO0OkxkOOOxddooddddc               
               lxxxxxxxkOOOOkxxxkOOOkkkxxkOkxxxxxxxxddxkkOkxxxxxxoddodddddxkOO0Oxxkxxdddooddddc               
               lxxxxxkkO0000OkxxOOOkxkOkkkOkxxxxdlc;;;:lodxkkOOkkxdoooxxddddxkOOOxxddxkkxddxxxc               
               lxxxxxOOO00000OkxxkkxxO0Okxkkxxxdc'''''',,:xkkOkkkkxdooxxdxxxddxkOxdxkkkkkkkxxxc               
               lxxkxxOO000000kxxkxkOkkkkkOOkxxdo:;:::cc:,'okkkkkkkxdooddddxxddxxdddxkOOOOOOOkxl               
               lkkOkkOO0000OOkxkOkkkkOkkO00kxxdlcccllool:,lxdxkkkxddoodkkxdddxxxxxdxkOO0000Okxl               
               lkkkxxxkOOOOkxxxkkkkxk00OO00kxxxol::cccclc;dxdddxddddoodkkxxkxddxkxdxkO00000Okko               
               lkkkxxkxkkkkxxxxxxxxxxO0OOO0kxxddlc:clclllcdkkxddxdddoodkkxkOkxdxxdddxxO00Okkkko               
               ckOOOOOOkxxkOOkOOkxxkkxOOkkOkxxxdoc:cllllloxxdddxkxxdoodkxxOkxxxdxkxkkkkkOkkkkko               
               ckkOOOkkkxxkOOkkOxdxxxdxxkkkxxxxxoc::cllloddddxxddxxdooodddxxxkkdxkOOO0Oxxk0000d               
               cxkkkkkkkxxkkkkkkxddxdddxkOkxddddol:ccclloodxkkkxddddoodxxxdddxdddkOOOOOkxk0000o               
               cxxxdxkkxxkkxddddxxkxxdddxkkddddool;:::cloookkkkkxooooodxxddddkxdodxkkOOkkO000Oo               
               lkdxxxxdddddxxxxdkkkkxxxddxkdddollc::::cclc',:lodddddoodxxddxdxkkxddddxxkxkOkkxl               
               lxdkkkkkddxxkkkxdxkkkxkkdddxdl:'.,ol:::::ol'......,;loodddodxddkOOxdxkkxdddkkkkl               
               cddkkkkkddxkkkkdddxkxxxdddl:,.....lolllcodl..........,odddoodxdxOkdxkkkkkdxOOOOo               
               lxxxxkxddddxxxddxxdddddo;'........;cclllll'...........cddddoddoxkxxxxxkkxddkOOOo               
               lkkxdxxxkkxdoodxkxxdodxl...........'::c::,............;ddddxxdoddkOkxdxxdxxxxkkl               
               lkkxdxxxxxxddddxxxxddxx:............,;;;,'............,dddxxxxxdxkkkkxdxxkxkxxxo               
               lkkkxxkkkkkxddxxxxxxddx;............,c;;,,::,'........'oddxkkxddxkOOOkxxkkkOOxxo               
               lkkkxxkkkkkxodxxxxxxddd;.............;,,',:cc:........'odddxxdddxOOOOOxxkkkOOkko               
               okkxdxkkkkkdodxxxxxxdxd;.............,;,',::::........'odddodxxdxOOOOOxxkkkOOxxo               
               okxxddxdddxdodddxxxddxd;.............';'...;:;.........cdddodkxdxkkkkkdxkkxkkxxl               
               lkkxddxxddxddxxxxxxxdxo,.............';,....''.........'oddoodxddxkkxxddkxxkkxxl               
               cxxxddxxxxxddxxxxxxxdol,..............,,'...............'odddooodxxxxxddxxxkkxxl               
               cdddddxxxddoddxxxxxdoolcc;............,,'...............:dddddooddddddddddxxxxdc               
               cddddddddddoooddddddl:cccc,...........,''..............cdddddddddddddddddddddddc               
               cddoooddddooooooddddol:cc:'...........,'.........'..':odddddddddddddddddddddddd:               
               :ooooooooooooooooodddoc,'.............'..........oddddddddddddddddddddddddddddo:               
               :oooooooooooooooooooodo:;'............;,'........cddddddddddddddddddddddddddddo:               
               :oooooooooooooooooooooool'...........':c:;,......;dddddddddddddddddddddddddddoo:               
               :oooooooooooooooooooooddc'...........,:cc:;,.....,ddddddddddddddddddddddxxxxdoo:               
               :ooooooooooooooooooooodd:............,:cc:;;.....,ddddddddddddddddddxxxxxxxxddo:               
               cxxxxxxxxxxxxxxxxxxxxxddxxxxdddddxxxdddddddxxxxxddddooooddddxdxxxxxxxxdddodddddc               
               cxxxxxxxxxxxxxxxkkkxxxddxxdddddddxxddooddxxxdddddxxdooooddxdxxxxxxxxxxdddodddddc               
               cxxxxxxxxxxxxxkkOOkxkkkkkkkkxddddddddodxkkkkxxdddddoooooddddxkkkxkkxxxxddodddddc               
               cxxxxxxxxxxxxkOOOxxxkOkOOOOOxdddxxxxddxkkOOOOkxxxxxdooodxkkOOOOkkkOkxxxxdooddddc               
               cxxxxxxxxxkkkkkkkxkOOOOOOkkkkxddddddddxkOOOOOxxxxxdddooddxkOOO0OkxkOOOxdoooddddc               
               lxxxxxxxkOOOOxxxxkOOOkkkxxkOOxxxddxkkxdxkOOkxxxkkxoddddddddxkOO0Oxxkkxdddooddddc               
               lxxxxxkkO0000OkxxOOOkxkOkkkOkxxxxxxxddxxxkkxkkOOOkxddodxxddddxkOOOxxddxkkxddxxdc               
               lkxxxxOOO00000OkxxkxxxkOOkxkkxxxoc;;,,;:loxkkkkkkkkxoooxxdxxxddxkOxdxkkkOkkkxxxc               
               lxxxxkOO000000OxxkxOOkkOkkOOkxxdc,''''',,,oxkkkkkkkxdooddddxxddxxdddxkOOOOOOOkxl               
               lkkkkkOO0000OOkxkOkkkkOkkO00kxxdlc:cccc:,':xddxkkkxddoodkkxdddxxxxxdxOOO0000Okxl               
               lkkkxxxkOOOOkxxxkkkkxk00OO00kxxdocclllol;'cxxdddxddddoodkkxxkxddxkxdxkO00000Okko               
               ckkkxxkxkkkkxxxxxxxxxxk0OkO0kxxoc::cccll:,lkkxxddxdddoodkkxkOkxdxxdddxxO00Okkkko               
               ckOOOOOOkxxkOOkOOkxxkkxOOkkOxxdoc:clllllc:dkxdddxkkxooodkxxOOxxxdxkxkkkkOkkkkkko               
               ckkOOOkkkxxkOOkkOxdxxxdxxkkkxxddc:cllllllodxodxkddxkdooddddxxxkkdxkOOO0Okxk0000d               
               cxkkkkkkkxxkkkkkkxddxdddxkOOxdddc::clcclododdkkOkddddoodxkxdddxxddkOOOOOkxk0000d               
               lxdxdxkkxxkkxddddxxkxxdddxkkddddl::cc::oxddxkkkOkdddooodxxxddxkxddxkkkOOOkO000Oo               
               lkdxxxxdddddxxxxdkkkkxxxddxkddool:;:c::oooddxxkkxdoddoodxxddxdxkkxxdddxxkxkOOkkl               
               cxdkkkkkddxkkkkxdxkkkxkkddddl:;cl:;::::ll,;;codxdooddoodxdodxddkOOkdxkkxdddxkkOl               
               cddkkkkkddxkkkxdddxkxxxdlc;'...;dlc:cllol'....',;cloooooddoodxdxOkdxkkkkkdxOOOOo               
               lxxxxkxdddddxxddxxdddl:,.......,ooolclddc..........:dooooododddxkxxxxkkkxddkOOOo               
               lkkxdxxxkkxddodxxxddo,..........',::cllc...........'odooodxxdoddxkOkxdxxdxxxxkkl               
               lkkxdxxxxxxddddxxxddo'............;:::;,............cdddddxkkxxdxOOkkxxxkkxkxxxo               
               lkkkxxkkkkkxddxxxxxdc.............;::;;'............cdddddxkkxxdxOOOOkxxkkkOOxxo               
               lkkkxxkkkkkxodxxxxxdc.............,;::;'............cdddoodxxdddkOOOOOxxOkkOOkxo               
               lkkxdxkkkkkdodxxxxxdl......;::,...'::;,.......,,'...cddddddodxxdxOOOOOxxkkkOOxxo               
               okxxddxdddxdoddddxxdl....';:::,....,;;;'......;cc:,.cddddddodkxdxkkkkkdxkkxkkxxl               
               lkkxddxxxdxdoxxxxxxd:.....,;;;'.....,,,.......;::c,.'lddddooddxddkxxxxddkxxkkxxl               
               cxxxddxxxxxdoxxxxxxd;.....',;,......,;,'......,:::....:oddddxddodxxxxxddxxxkkxdl               
               cddddddxdddooddddddd,.......'........,,'.......,;,.....;ddddxdooddddddodddxxxxdc               
               cddddddddddooddddddl....'............,,'..............'lddddddddddddddoodddddddc               
               cddooodddoooooooodoo,................','.............'ldddddddddddddddddddddddoc               
               :oooooooooooooooooool,...............''............';lddddddddddddddddddddddddoc               
               :ooooooooooooooooooooollll...........''..........ldddddddddddddddddddddddddddoo:               
               :oooooooooooooooooooooooo;...........';;;,,......,dddddddddddddddddddddddddddooc               
               :oooooooooooooooooooooddc............':cc::,'.....:dddddddddddddddddddddxxxdddoc               
               :oooooooooooooooooooooddc............':ccc::,.....,dddddddddddddddddddxxxxxdddoc               
               cxxxxxxxxxxxxxxxxxxxxxddxxxxdddddxxxdddddddxxxxxddddooooddddxdxxxxxxxxdddodddddc               
               cxxxxxxxxxxxxxxxkkkxxxddxxdddddddxxddooddxxxdddddxxdooooddxdxxxxxxxxxxdddodddddc               
               cxxxxxxxxxxxxxkkOOkxkkkkkkkkxddddddddodxkkkkxxdddddoooooddddxkkkxkkxxxxxdodddddc               
               cxxxxxxxxxxxxkOOOxxxkOkOOOOOxdddxxxxddxkkOOOOkxxxxxdooodxkkkkOOkkkOkkxxxdooddddc               
               cxxxxxxxxxkkkkkkkxkOOOOOOkkkkxddddddddxkOOOOOxxxxxdddooddxkOOO0OkxkOOOxddooddddc               
               lxxxxxxxkOOOOxxxxkOOOkkkxxkOOxxxxxxkkxxxkOOkxxxkkxoddddddddxkOO0Oxxkkxdxdodddddc               
               lxxxxxkkO0000OkxxOOOkxkOkkkOkxxxkkkkkkkxkkkxkkOOOkxddodxkddddxkOOOxxddxkkxddxxdc               
               lkxxxxOOO00000OkxxkxxxkOOkxkkxxxxxddoodxkxxkOkOkkkkxooodxdxxxddxkOxdxkkkOkkkxxxc               
               lxxxxkOO000000OxxkxOOkkOkkOOkxxdl;,,'',;clxxkkkkkkkxdooddddxxddxxdddxkOO00OOOkxl               
               lkkkkkOO0000OOkxkOkkkkOkkO00kxxdl;,''''',,lxddxkkkxddoodkkddddxxxxxdxOOO0000Okxl               
               lkkkxxxkOOOOkxxxkkkkxk00OO00kxxdocccclc:'':xxdddxxdddoodkkxxkxddxkxdxkOO0000Okko               
               ckkkxxkxkkkkxxxxxxxxxxk0OkO0kxxoc:cllooc,'ckkxxdxxdddoodkkxkOkxdxxxddxkO00Okkkko               
               ckOOOOOOkxxkOOkOOkxxkkxOOkkOxxdl::cc:clc,;okxdddxkkxooodkxxOkxxxdxkkkkkkOkkkkkko               
               ckkOOOkkkxxkOOkkOxdxxxdxxkkkxxdl:clllllc;lxddxkkxdxkdooddddxxxkkdxkOOO0Okxk0000d               
               cxkkkkkkkxxkkkkkkxddxdddxkOOxddl:ccclcclooddxkOOkddddoodxkxddxxxddkOOOOOkxk0000d               
               lxdxdxkkxxkkxddddxxkxxdddxkkdddl:::cc::oxddxkkkkkxddooodxxxddxkxddxkkkOOOkO000Oo               
               lkdxxxxdddddxxxxdkkkkxxxddxkddol::::c::lddddxkkkkddddoodxxddxdkkkkxdddxxkxkOOkkl               
               cxdkkkkkddxkkkkxdxkkkxkkddddlclc:;;:c::coddddxxxdooddoodxdodkdxkOOkxxkkxdddkkkOl               
               cddkkkkkddxkkkxdddxkxxxol:,'..:l::::cloc';codddddooddoooddodxxdxOkdxkkkkkdxOOOOo               
               lxxxxkxdddddxdddddddl:,'......colccccld;....';cododddooooododddxkkxxxkkkxddkOOOo               
               lkkxdxxxkkxddodxxxdl'.........;cllclodc'........,cdxdooooddxxdddxkOkxdxxdxxxxkkl               
               lkkxdxxxxxxdodddddd;............,;;cll;...........lxdoooddxkkkxdkOOOkxxxkkxkxxxo               
               lkkkxxkkkkkdodxxxxo'............,:::;;,...........:dddooodxkkxxxkOOOOkxxkkkOOxxo               
               lkkkxxkkkkkdodxxxxo.............';::::,...........;ddddooodxxdddkOOOOOxxOOkOOkxo               
               lkkxdxxxxxxdodxxxd;............;:c::;;'...........;ddddddddddxxxkOOO0OxxkkkOOxxo               
               okxxddddddxdoddddo'...........;:ccc:;;'...........;ddddddddddkxdxkkkkkdxkkkkkxxl               
               lkkxdddxxdxdodxxxc...........';:::;,,;,...........:dddddddoddxxdxkkkkkddkxxkkxxl               
               cxxxddxxxdxooxxxx;...........','...;,,,...........;dolclodddxddodxxxxxddxxxkkxdl               
               cddddddddddoodddo'.................',,,............::;:codddxdooddddddodddxxxxdc               
               cddddddddddoooodc...................',,............',;:codddddddddddddoodddddddc               
               cdooooooooooooool'..................',,............',;:cddddddddddddddddddddddoc               
               :ooooooooooooooool,..................',......     .....:ddddddddddddddddddddddoc               
               :ooooooooooooooooooccccoc............''......    ......:dddddddddddddddddddddoo:               
               :oooooooooooooooooooooooc............',,,,......''';:coddddddddddddddddddddddooc               
               :oooooooooooooooooooooddl............::cc:,.....,lodddddddddddddddddddddxxxdddoc               
               :oooooooooooooooooooooddl............;:ccc;'.....,ddddddddddddddddddddxxxxxdddoc               
               cxxxxxxxxxxxxxxxxxxxxxddxxxxdddddxxxdddddddxxxxxddddooooddddxdxxxxxxxxxddooodddc               
               cxxxxxxxxxxxxxxxkkkxxxdddddddddddxxddooddxxxdddddxxdooooddxdxxxxxxxxxxdddooodddc               
               cxxxxxxxxxxxxxkkOOkxkkkkkkkkxddddddddodxkkkkxxdddddoooooddddxkkkxkxxxxxxdooddddc               
               cxxxxxxxxxxxxkkOOxxxkOkOOOOOxdddxxxxddxkkOOOOkxxxxxdooodxkkkkOOkkOOkkxxxdooddddc               
               cxxxxxxxxxkkxxkkxxkOOOOOOkkkxxddddddddxkOOOOOxxxxxdddooddxkOOO0OkkkOOOxddooddddc               
               lxxxxxxxkOOOOxxxxkOOOkkkxxkOkxxxxxxkkxxxkOOkxxxkkxoddddddddxkOO0Oxxkkxdddooddddc               
               lxxxxxkkO0000OkxxOOOkxkOkkkOkxxxkkkkkkxxkkkkkkOOOkxddodxxddddxkO0Oxxddxkkxddxxdc               
               lxxxxxOOO00000OkxxkxxxkOOkxkkxxxddollodkkxxkOkkkkkkxooodxddxxddxkOxdxkkkkkkkxxxc               
               lxxxxxOO000000OxxkxOOkkOkkOOxxxo:,,,''';cdxxkkkkkkkxdooddddxxddxxdddxkOO00OOOkxl               
               lkkkkkOO0000OOkxkOkkkkOkkO00kxdo:,'''''',:dxddxkkkxddoodkkxdddxxxxxdxOOO0000Okxl               
               lkkkxxxkOOOOkxxxkkkkxk00kk00kxoolcccclc;',xkxdddxxdddoodkkxxkxddxkxdxkOO0000Okko               
               ckkkxxkxkkkkxxxxxxxxxxkOOkO0kxdoc:cllll:,:xkkxxdxxdddoodkkxkOkxdxxxddxkO00Okkkko               
               ckOOOOOOkxxkOOkOOkxxkkxOOkkOkdol:::cccl:,okkxdddxkkxdoodkxxOkxxxdxkkkkkkOkkkkkko               
               ckkOOOkkkxxkOOkkOxdxxxdxxkkkxdoccccllllccdxdddxkddxkdooddddxxxkkdxkOOO0Okxk0000d               
               cxkkkkkkkxxkkkkkkxddxdddxkOkxdoc::cclcclododxkOOkddddoodxkxddxxxddkOOOOOkxk0000d               
               lxdxdxxkxxxkxddddxxkxxdddxkkdddc:::cc::ldddxkkOOkxddooodxkxddxkkddxkkkOOOkO000Oo               
               lkdxxxxdddddxxxxdkkkkxxxddxkdooc:::cc::lddddxkkkkddddoodxxddxdxkkkxdddxxkxkOOkkl               
               cxdkkkkxddxxkxkxdxkkxdkkdddo:;l:;;:clc:ldddoddxxdooddoodxdodkxxkOOkxxkkxdddkkkOl               
               cddkkkkxddxxkkxdodxkdooc;''...ll::::cll:;:lddodddoooooooddodxxdxOkdxkkkkkdxOOOOo               
               lxxxxkxdddddxdodddol,'........ldlccclod;...';codddddddoooododddxkkxxxkkkxddkOOOo               
               lkxxdxxxxxxddodxxxl'..........;:ccclddc'.......;cdxddooooodxxdddxkOOxdxxdxxxxkkl               
               lkkxdxxxxxxdoddddo;............';:;:cc,.........'oxddoooddxkkkxxkOOOkxxxkkxkxxxo               
               lkkkxxkkkxkxodxxxo..............,:cc:;,..........ldddoooodxkOkxxkOOOOOxxkkkOOxxo               
               lkkxxxkkkxkdodxxxl..............';;::;,..........cddddoooodxxdddkOOO0OxxOOkOOkxo               
               lkkxdxxxxxxdodxxd:.........;:::'.;::;,,..........cxddddoddddxxxxkOO00OxxOOkOOxxo               
               okxxddddddxdodddo'........,::::'.';;;;,..........ldddddoddddxkxdxkkkOkdxkkxkkxxl               
               lkxxddxxddxoodxx:.........';;;;...;,,,'..........cxdddddddodddxdxkkkkkddkxxkkxxl               
               cxxdddxxxdxoodxd'..........,,'....',,,'..........cdddddddddxxddodxkxxxddxxxkkxdl               
               cddddddddddooddc...................'','..........;dolloddddxxdoodddddddoddxxxxdc               
               cdddddddddooooo,...................',,'...........:;;:lddddddddoodddddoodddddddc               
               cdoooooooooooooc....................','..........',;;:ldddddddddddddddooddddddoc               
               :oooooooooooooooc...................'''......  ..',;;codddddddddddddddddddddddoc               
               :ooooooooooooooool:::cc..............',......   ...''cdddddddddddddddddddddddoo:               
               :oooooooooooooooooooooc.............,,;'.....  .....,ldddddddddddddddddddddddooc               
               :ooooooooooooooooooooo;.............:c:;,....'::ccloddddddddddddddddddddddxdddoc               
               :ooooooooooooooooooodd;.............:c::;'....cdddddddddddddddddddddddddxxxdddoc               
               cxxxxxxxxxxxxxxxxxxxxxddxxxxddddxxxxdddddddxxxxxddddooooddddxdxxxxxxxxxddooodddc               
               cxxxxxxxxxxxxxxxkkkxxxdddddddddddxxddooddxxxdddddxxdooooddxdxxxxxxxxxxdddooodddc               
               cxxxxxxxxxxxxxkkOOkxkkkkkkkkxddddddddodxkkkkxxxddddoooooddddxkkkkkxxxxxxdooddddc               
               cxxxxxxxxxxxxkkOOxxxkOOOOOOOxdddxxxxddxkkOOOOkxxxxxdooodxkkkkOOkkOOkkxxxdooddddc               
               cxxxxxxxxxkkxxkkxxkOOOOOOkkkxxddddddddxkOOOOOxxxxxdddooddxkOOO0OkkkOOOxddooddddc               
               lxxxxxxxkOOOOxxxxkOOOkkkxxkOkxxxddxkkxxxkOOkxxxkkxoddddddddxkOO0Oxkkkxdddooddddc               
               lxxxxxkkO0000OkxxOOOkxkOkkkOkxddooooodxxxkkkkkOOOkxddodxxddddxkO0Oxxddxkkxddxxdc               
               lxxxxxOOO00000OkxxkxxxOOOkxkkxoc;,,,',;oxxxkOkkkkkkxooodxddxxddxkOxdxkkkkkkkxxxc               
               lxxxxxOO000000OxxkxOOkkOkkOOkdl;,''''',,lxdxkkkkkkkxdoodddxxxddxxdddxkOO00OOOkxl               
               lkkkkkOO0000OOkxkOkkkkOkkO00ko::::ccclc;ckxxddxkkkxddoodkkddddxxxxxdxOOO0000Okxl               
               lkkkxxxkOOOOkxxxkkkkxk00Ok0Okl::cclllll:lkkkxdddxxdddooxkkxxkxddxkkdxkOO0000Okko               
               ckkkxxkxkkkkxxxxxxxxxxkOOk0Oko:::::lcclcxkkkkkxdxxdddoodkkxkOkxdxxxddxkO00Okkkko               
               ckOOOOOOkxxkOOkkOkxxkkxOOkkkxlc::::cllloxkkkxdddxkkxooodkxxOkxxxdxkkkkkkOkkkkkko               
               ckkOOOkkkxxkOOkkOxdxxxdxxkkkxdlc:::cllloxxxdddkkxdxkdooddddxxxkkdxkOOO0Okxk0000d               
               cxkkkkkkkxxkkkkkkxddxdddxkOkxdoc:::ccccodoodxkOOkddddoodxkxddxxxddkOOOOOkxk0000d               
               lxdxdxxkxxxkxddddxxkxxdddxkkddo::::cc::oxddxkkkkkxddooodxkxddxkkddxkkkOOOkO000Oo               
               lkdxxxxdddddxxxxdkkkkxxxddxdl;c:;;;cc::ldoddxkkkkddddoodxxddxdxkkkxdddxxkxkOOkkl               
               cxdkkkkxddxxkxkxdxkkxxxdl:,'..:c:;:cc:c,',;coxxxdooddoodxdodkxxkOOkxxkkxdddkkkOl               
               cddkkkkxddxxkkxdodxxoc;'......,ooccccll,.....,:lodooooooddodxxdxOkdxkkkkkdxOOOOo               
               lxxxxkxdddddxdodddo;..........,lolllool.........;ddddooooododddxkkxxxkkkxddkOOOo               
               lkxxdxxxxxxddodxxxc.............,;::cl:.........'odddoooooxxxdddxkOOxdxxdxxxxkkl               
               lkkxdxxxxxxdoddddd'.............';ccc:,..........ldddooodxxkkkxxkOOOkxxxkkxkxxxo               
               lkkkxxkkkxkxodxxxo...............,:::;,..........lddddooodxkOkxxkOOOOOxxkkkOOxxo               
               lkkxxxkkkxkdodxxxl...............,:::;'..........cddddoooodxxdddkOO00OxxOOkOOkxo               
               lkkxdxxxxxxdodxxdc................;;;;'..........:xddddoddddxxxxkOO00OxxOOkOOxxo               
               okxxddddddxdodddd,................,;;,'..........:xddddoddddxkxdxkkkOkdxkkxkkxxl               
               lkxxddxxddxoodxxo'.....;c'........',,,'...',:;'..;ddddddddoddxxdxkkkkkddkxxkkxxl               
               cxxdddxxxdxoodxxc.....:cc;.........'','...';:cc;.;dddddddddxxddodkkkxxddxxxkkxdl               
               cddddddddddooddd;....',;:c;........',,'....;:cc;..lddddddddxxdoodxxdddddddxxxxdc               
               cdddddddddoooooo,.....',;:;........',,'.....,;,..,oddddddddddddoodooddoodddddddc               
               cdooooooooooooooc..................',,'.........,oddddddddddddddddddddooddddddoc               
               :oooooooooooooooo:...................''........,ldddddddddddddddddddddddddddddoc               
               :ooooooooooooooooolll,.............'',,....'ccoddddddddddddddddddddddddddddddoo:               
               :oooooooooooooooooodc..............;c:;'....lddddddddddddddddddddddddddddddddooc               
               :ooooooooooooooooood;..............,l:;'....'dddddddddddddddddddddddddddddxdddoc               
               :ooooooooooooooooodd,..............,l::,.....oddddddddddddddddddddddddddxxxdddoc               
               cxxxxxxxxxxxxxxxxxxxxxddxxxddddddxxxdddddddxxxxxxxddooooddddxdxxxxxxxxxddooodddc               
               cxxxxxxxxxxxxxxxkkkxxxddddddddddddxddooddxxxdddddxxdooooddxdxxxxxxxxxxdddooodddc               
               cxxxxxxxxxxxxxkkOOkxkkkkkkkxxddddddddodxkkkkxxdddddoooooddddxkkkxkkxxxxxdooddddc               
               cxxxxxxxxxxxxkkOkxxxkkkOOOOkxddddxxxddxkkOOOOkxxxxxdooodxkkkkOOOxOOkkxxxdooddddc               
               cxxxxxxxxxxkxxkkxxkOOOOOOkkxxxddddddddxkOOOOOkxxxxdddooddxkOOO0OkkkOOOkdoooddddc               
               lxxxxxxxkOOOOxxxxkOOOkkxxxkOkdlc;,;;;:lxkOOkxxxkkxoddddddodxkOO0Oxkkkxdddooddddc               
               lxxxxxkkO0000OkxxOOOkxkOkxkkdc,'''''',cxxxxkkkOkkkxddodxkddddxkO0Oxxddxkkxddxxxc               
               lxxxxxOOO00000OxxxxxxxkOOkxl,''',;;::clxxxxkOkkkkkkxdooxxdxxxddxkkxdxkkkOOkkxxxl               
               lxxxxxOO000000kxxxxkkkkkkkko''';:clooooxxxxxkkkkkkkxdoodxddxxddxxdddxkOO00OOkkxl               
               lkkkkkOO00000OkkkOkkxkOkkOOd'',;:::cclldkkkxddxkkkxddooxkkxdddxxxxxdxOOO0000Okkl               
               lkkkxxxkOOOOkxxxkkkkxk00kkOx;,,:::cccllxkkkkxdddxxdddooxkkxxkxddxkkdxkOO0000OkOo               
               ckkkxxkxkkkkxxxxxxxxxxkOOkOOo:::::cccclxkkkkkxxdxxdddoodkkxkOkxdxxxddxkO00OkkkOo               
               ckOOOOOOkxxkOOkkOkxxkxxOOkkkxoc:::ccclodkkkkxdddxkkxooodkxxOkxxxdxkkkkkkOkkkkkko               
               cxkOOOkkkdxkOkkkkxdxxxdxxkkkddc::::ccloddxxdddkkddxxxooddddxxxkkdxkOOO0Okxk0000d               
               cxkkkkkkkxxkkkkkkxddxdoodxkklcc::;::ccclooodxxOOkddddoodxkxddxxxddkOOOOOkxk0000d               
               lxxxdxxkxxxkxdddddxxxddoodo;.'c::::cc:;:,',:ldxkkxdoooodxxxddxkkddxkkkOOkkO000Oo               
               lkdxxxxdddddxxxddkkkxddl;'....:l::cc::;:'....';xxdoddoodxxddxdxkkkxdddxxkxkOOkkl               
               cxdkkkkxddxxkxkxdxxdl:'.......'oollclc:;.......:ddoddoodxdodkxxkOOkxxkkxdddkkkkl               
               cddkkkkxddxxkkxdool'...........coollccl,.......,odooooooddddxxdxOkxxkkkkkdxOOOOo               
               lxxdxkxdddodxdoddo,.............,:cc:cl,.......'oddddooooododddxkkxxxkkkxddkOOOo               
               lkxxdxxxkxddoodxxl...............;cc:::'.......'odddooooooxxxdddxkOOxxxxdxxxxkkl               
               lkxxdxxxxxxdooddd,...............,:;;;,.........cddddooodxxkkkxxkOOOkkxxkkxkkxxo               
               lkkkdxkkkxkxodxxo................';;;;,,,,......cddddoooodxkOkxxkOOOOOxxkkkOOxxo               
               lkkxdxkkkxkdodxx:.................,,,',;ccc;....:ddddooooodxxdddkOO00OxxOOkOOkxo               
               lkkxdxxxxxxdodxd,.................','.,;ccc;.....ldddddoddddxkxxkOO00OxxOkkOOxxo               
               lkxxddddddxdoddo'..................,..'..;:'.....;dddddoddddxkxdxkkOOkdxkkkkOxxl               
               lkxxddddddxoodxo...................'......'.....,oddddddddodddxdxkkkkkddkxxkkxxl               
               lxxdddxxxdxooddc...............................,odddddddoodxxddodkkkxxddxxxkkxdl               
               cddddddddddoodo;........';;'..........'.....':lddddddddddddxxdoodxxdddodddxxxxdc               
               cddooodooooooool'......,;::;..........'....odxddddddddddddddddooodddddoodddddddc               
               coooooooooooooooc'......,;::..........'....;ddddddddddddddddddddddddddooddddddoc               
               cooooooooooooooodo:.......'.......';,'......ldddddddddddddddddddddddddddddddddoc               
               :ooooooooooooooool.............. .,:;,'.....cdddddddddddddddddddddddddddddddddo:               
               :oooooooooooooooo:................;::;'.....,ddddddddddddddddddddddddddddddddoo:               
               :oooooooooooooooo,................:c:;,......oddddddddddddddddddddddddddddxdddoc               
               :oooloooooooooool.................ccc:;,'....lddddddddddddddddddddddddddxxxdddoc               
               cxxxxxxxddxxxxxxxxxxxxdddxxddddddxxddddddddxxxxxddddooooddddxdxxxxxxxxdddooodddc               
               cxxxxxxxddxxxxxxkkxxxxddddddddddddddoooodxxxdddddxxdooooddddxxxxxxxxxxdddooodddc               
               cxxxxxxxxxddxxkkOOkxkkkkkkkxxddddddddodxkkkkxxdddddoooooddddxkkkxkkxxxxddooodddc               
               cxxxxxxxxxdxxkkkkxxxkkkkOOOkxddddolooodkkOOOOkxxxxxdooodxxkkkOOOxOOkxxxxdooddddc               
               cxxxxxxxxxxkxxkkxxkkOOOOOkkxxoc:;,''',:dkOOOkxxddxdddooddxkOOOOOkkkOOOxdoooddddc               
               lxxxxxxxkOOOOxxxxkOOOkxxxxxxl;'''''..',okOOkxxxkkxoddooddodxkkO0Oxxkkxdddooddddc               
               lxxxxxxkO0O0OOkxxOOkkxkOkxxl,''',;;:::ldxkkxkkOkkkxddodxxdodddkO0Oxxddxkkxddxxdc               
               lxxxxxOOO0000OOxxxxxxxkOkkx:.''';:cloooxkxxkOkkkkkkxdooxxdxxxddxkkxdxkkkOOkkxxxl               
               lxxxxxOOO0000Okxxxxkkkkkkkx;'''';:ccclldxxxxkkkkkkkxdooddddxxddxxdddxkOO00OOkkxl               
               lkkkkkkOO0OOOOkxkkxxxkOkkkk:,;;;::clllldkkkxddxkkkxddoodkkxdddxxxxxdxOOO0000Okkl               
               lkkkxxxxkOOOkxxxkkkkxkO0kkOx::::::clllcdkkkkxdddxddddoodkkxxkxddxkxdxkOO0000OkOo               
               cxkxxxxxxkkxxxxxxxxxxxkOOkOOd::::::clllxkkkkkxxdxxdddoodkkxkOkxdxxddddxO00OkkkOo               
               ckOOOOkkkxxkOkkkkkxxkxxkkxxkxl::::::clodkkkkxdddxkkxooodkxxOkxxxdxkxkkkkkkkkkkko               
               cxkOOkkkxdxkkkkkkxdxxdddddd:cc:::::clclodxxdddxkddxxdooddddxxxkkdxkOOO0Oxxk0000d               
               cxkkkkkkxdxkkkkkkxdddoolc;'.'l:::ccco::c;;;coxkOkddddoodxkxdddxxddkOOOOOkxk0000o               
               lxdxdxxkxxxkxdddddddoc,......:occc:col;:,...'lkkkxdoooodxxxddxkxdddkkkOOkkO000Oo               
               lkdxxxxdddddddxddl:;.........,oolccodc;:,....,dkxdoddoooxxddxdxkkkddddxxkxkOOkkl               
               cddkkkkxdddxxxkdo'............:llllcc,:;'.....lddooddoodxdodkxxkOOkxxkkxdddxkkkl               
               cddkkkkxdddxxxxd:..............;:cc:;'c:......cddoooooooddddxxdxOkdxkkkkkdxOOOOo               
               lxddxxxdddoddddl'..............'::::,'c:......cddddddooooododddxkkxxxkkkxddkOOOo               
               lxxxddxxxxdooodc................;:;,'';,......cddxxdooooooxxxdddxkOOxxxxdxxxxkkl               
               lxxxddxxxdddooo;................,::;'',.......:ddxxxdooodxxkkkxxkOOOkxxxkkxxxxxo               
               lkkxdxxxxxxdool..................,,'..,.....'';ddxxddoooodxkOkxxkOOOOkxxkkkkOxxo               
               lkkxdxxxxxxdooc..................,,'..'....';:cloddddooooodxxdddkOOO0OxxOkkOOxxo               
               lkkxdxxxxxxoodc..................','..'....,:cccodddddoodddddxxxkOOO0OxxOkkkOxxo               
               lkxxddddddxood:...............'''''...'......,:coddddddodddddkxdxkkkOkdxkkkkkxdl               
               lkxxddddddddoo..............',;;:;'...'........,odddddooododddxdxkkkkkddxxxkkxxl               
               cxxdddxxxddooo,.............',;;:;....'......':oddddddoooodxxddodkkxxxddxxxkkxdl               
               cddddddddddoodo,.............';;;'........:dddddddddddddodddxdoodxddddodddxxxxdc               
               cdoooooooooooodol;'...................'...'dddddddddddddddddddooodoooooodddddddc               
               cooooooooooooooddo;'..................'....cddddddddddddddddddddoodoooooddddddoc               
               :ooooooooooooooodl'...............'...'....,ddddddddddddddddddddddddddddddddddo:               
               :ooooooooooooooodc................''..'.....ldddddddddddddddddddddddddddddddddo:               
               :oooooooooooooood;................,,........:ddddddddddddddddddddddddddddddddoo:               
               :oooooooooooooooo'................;;'.'.....'dddddddddddddddddddddddddddddddddo:               
               :oooloooooooooooo'.............. .::;''.....'dddddddddddddddddddddddddddxxxdddoc               
               cxxxxxxxdddxxxxxxxxxdddddxxddddddxxddddddddxxxxxxxxdooooddddxdxxxxxxxxdddooodddc               
               cxxxxxxxddddxxxxkkxxxxddddddddddddddoooodxxxdddddxxdooooddddxxxxxxxxxxdddooodddc               
               cxxxxxxxdddddxkkOOkxkkkkkkkxxddddddddooxkkkkxxdddddoooooddddxkkkxkkxxxxxdooodddc               
               cxxxxxxxxxdxxkkkkxxxkkkkOOOkxdoolc:ccldkOkkkOkxxxxxdooodxxkkkOOOxOOkxxxxdooddddc               
               cxxxxxxxxxxkxxkkxxkkOkOOOkxxxoc,''''',;dkOOOkxxddddddooddxkOOO0OkkkOOOkddooddddc               
               lxxxxxxxkOOOOxxxxxOOOkxxxxxxc,'''''''',okkkkxxxkkxoddooddodxkOO0Oxxkkxxddooddddc               
               lxxxxxxkO0O0OOkxxOOkxxkOkxx:'''',::clllxxxxxkkkkkkxddodxxdodddkO0Oxxddxkkxddxxdc               
               lxxxxxOOO0000OOxxxxxxxkOkkd,.''';:cllloxxxxkOkkkkkkxdooxxdxxxddxkkxdxkkkOOkkxxxl               
               lxxxxxOOOO00OOkxxxxkkxxkkkd,'''';::cclldxxxxkkkkkkkxdooddddxxddxxdddxkOO00OOkkxl               
               lkkkkxkOOOOOOOkxkkxxxkkkxkk:;::;::clllldkkkxddxkkkxddoodkkxdddxxxxxdxOOO0000Okkl               
               lkkkxxxxkOOOkxxxkkkkxkO0kkOd;::::::clllxkkkkxdddxxdddooxkkxxkxddxkxdxkOO0000OkOo               
               cxkxxxxxxkkxxxxxxxddxxkOOkkko::::::cccoxkkkkkxxdxxdddoodkkxkOkxdxxxdddxO00OkkkOo               
               ckOOkkkkkdxkkkkkkkdxkxdkkxdoc:::::::llodkkkkxdddxkkxdoodkxxOkxxxdxkxkkkkkkkkkkko               
               cxkkkkkkxdxxkkkkkxdxxdooc;';c:::cccooddddxxdddxkddxxxooddddxxxkkdxkOOO0Oxxk0000d               
               cxxkkkkkxdxkkkxxxdooc;'.....ll:ccc:oc:ccccodxkkOkddddoodxkxddxxxddkOOOOOkxk0000o               
               lxdddxxkxdxxxdool:,.........:dlccccdl;;:'.':okkkkxdoooodxxxddxkxdddkkkOOkkO000Oo               
               lxdxxxddddddddd:............,lollldo:;;:'...,dkkxdoddoodxxddxdxkkkddddxxkxkOOkkl               
               cddkkkkxdddxxxo'..............::c::;.,;;.....lxddooddoooxdodkxxkOOkxxkkxdddxkkkl               
               cddxkkkxdodxxxl...............,;:::,.,l;.....:dddoooooooddddxxdxOkdxkkkkkdxOOOOo               
               lxddxxxdddoddo;................;c::'.,l;.....,dddddddooooododddxkkxxxkkkxddkOOOo               
               lxxxdddxxxdooc.................';;:'..;'.....'dddxxdooooooxxxdddxkOOxxxxdxxxxkkl               
               lxxxddxxxddoo;..................,,;'..,......'oddxxxdooodxxkkkxxkOOOkxxxkkxxxxxo               
               lkkxdxxxxxxdl...................';;;'.'.......lddxxddoooodxkOkxxkOOOOkxxkkkkOxxo               
               lkkxdxxxxxxdc..................,;:::,.'.......;ddddddooooodxxdddkOOO0OxxOkkOOxxo               
               lkkxddxxxxxdc.................';::::'.'.......;ddddddddodddddxxxkOOO0OxxkkkkOxxo               
               lxxddddddddd;.................',;;;'..'........:lodddddodddddkxdxkkkOkdxkkkkkxdl               
               lkxdddddddddc.....................................,:::coooddddxdxkkkkxddkxxkkxxl               
               cxxdddxxxddoo,........................'.............,;;;:clooododkkkxxddxxxkkxdl               
               cdddoddddddooolcc::,..................'.............';;;;:cloooodxddddodddxxxxdc               
               cdooooooooooodddddo:..................'....col::,'....,c:lloooooodoooooodddddddc               
               :oooooooooooooddddo:...............''......:dddddddolcldoddddddddddoooooddddddoc               
               :oooooooooooooooooo;...............,,''....;ddddddddddddddddddddddddddddddddddo:               
               :oooooooooooooooool;...............,;,'....;ddddddddddddddddddddddddddddddddddo:               
               :oooooooooooooooool'...............,;,'....,dddddddddddddddddddddddddddddddddoo:               
               :oooooooooooooooool................,:;,....,ddddddddddddddddddddddddddddddddddo:               
               :oooooooooooooooooc................':;,....,ddddddddddddddddddddddddddddxxxdddoc               
               cxxxxxxxdddxxxxxxxxxdddddxxddddddxxddddddddxxxxxxxxdooooddddxdxxxxxxxxdddooodddc               
               cxxxxxxxddddxxxxkkxxxxddddddddddddddoooodxxxdddddxxdooooddddxxxxxxxxxxdddooodddc               
               cxxxxxxxdddddxkkOOkxkkkkkkkxxddddddddooxkkkkxxdddddoooooddddxkkkxkkxxxxxdooodddc               
               cxxxxxxxxxdxxkkkkxxxkkkkOOOkxddddolooodkkOOkOkxxxxxdooodxxkkOOOOxOOkxxxxdooddddc               
               cxxxxxxxxxxkxxkkxxkkOkOOOkxxxol;;,'',;:dkOOOkxxddddddooddxkOOO0OkkkOOOxxdooddddc               
               lxxxxxxxkOOOOxxxxxOOOkxxxxxxo;'''''..',okOOkxxxkkxoddooddodxkOO0Oxxkkxxddooddddc               
               lxxxxxxkO0O0OOkxxOOkxxkOkxxc,''',;;:::lxxkxxkkkkkkxddodxxdodddkO0Oxxddxkkxddxxdc               
               lxxxxxOOO0000OOxxxxxxxkOkkd;''',;:cloooxkxxkOkkkkkkxdooxxdxxxddxkkxdxkkkOOkkxxxl               
               lxxxxxOOOO000Okxxxxkkxxkkkd'.'',;:ccclldxxxxkkkkkkkxdooddddxxddxxdddxkOO00OOkkxl               
               lkkkkxkOOOOOOOkxkkxxxkkkxkx;,;;;::clllldxkkxddxkkkxddoodkkxdddxxxxxdxOOO0000Okkl               
               lkkkxxxxkOOOkxxxkkkkxkO0kkOo::::::cllclxkkkkxdddxxddxooxkkxxkxddxkxdxkOO0000OkOo               
               cxkxxxxxxkkxxxxxxxddxxkOOkkkl;::::ccllokkkkkkxxdxxdddoodkkxkOkxdxxxdddxO00OkkkOo               
               ckOOkkkkkdxxkkkkkkxxkxxkkxxdl:::::::clodkkkkxdddxkkxdoodxxxOkxxxdxkxkkkkkkkkkkko               
               cxkkkkkkxdxxkkkkkxdxxdodol;:c::::::lddoddxxdddxkxdxxxooddddxxxOkdxkOOO0Oxxk0000d               
               cxkkkkkkxdxkkkkkxdoooc:,...'lc::ccclc:cloooodkkOkddddoodxkxddxxxddkOOOOOkxk0000o               
               lxdddxxkxdxxxdddolc;'.......cocccc:ol;;:,,:lxkkkkxdodoodxxxddxkxdddkkkOOkkO000Oo               
               lxdxxxdddddddddl,...........;ddolcodc;;:'...;dkxxdoddoodxxddxdxkkkddddxxkxkOOkkl               
               cddkkkkxdddxxxd;.............,::cclc',:;.....:xdoooddoooxdodkxxkOOkxxkkxdddxkkkl               
               cddxkkkxdodxxxo'..............;::::,.,l,.....,dddoooooooddddxxdxOkdxkkkkkdxOOOOo               
               lxddxxxdddodddl................;:c:'.,l,......oddddddooooododddxkkxxxkkkxddkOOOo               
               lxxxdddxxxdooo,................;:;:'.';.......lddxxdooooooxxxdddxkOOxxxxdxxxxkkl               
               lxxxddxxxdddoc.................';;;'..,.......lddxxxdooodxxkkkxxkOOOkxxxkkxxxxxo               
               lkkxdxxxxxxdo,..................,;;'..'.......cddxxddoooodxkOkxxkOOOOkxxkkkkOxxo               
               lkkxdxxxxxxdl...................,::;'.'.......,odddddooooodxxdddkOOO0OxxOkkOOxxo               
               lkkxddxxxxxd:.................',;:::'.'........odddddddodddddxxxkOOO0OxxkkkkOxxo               
               lxxddddddddd;.................,;:::;..'........ldddddddodddddkxdxkkkOkdxkkkkkxdl               
               lkxddddddddd;.................,,;;;'...........,:lddddooddodddxdxkkkkxddkxxkkxxl               
               cxxdddxxxddol.....................................':::cloodxxddodkkkxxddxxxkkxdl               
               cdddoddddddool;,''..................................,;;;;:coxdoodxddddodddxxxxdc               
               cdoooooooooooooddooo'......................'........,;;;;:coddooodoooooodddddddc               
               :ooooooooooooooooooo'..............;,'.....cdol;'....':lcloodddddddoooooddddddoc               
               :ooooooooooooooooooc...............;;,'....'ddddddl:;:ddddddddddddddddddddddddo:               
               :oooooooooooooooooo:...............::;'.....odddddddddddddddddddddddddddddddddo:               
               :oooooooooooooooooo:...............::;,.....lddddddddddddddddddddddddddddddddoo:               
               :oooooooooooooooood:...............:c;,.....ldddddddddddddddddddddddddddddddddo:               
               :oooooooooooooooood:...............:c;;'....ldddddddddddddddddddddddddddxxxdddoc               
               cxxxxxxxdddxxxxxxxxxdddddxxddddddxxddddddddxxxxxxxxdooooddddxdxxxxxxxxxxdooodddc               
               cxxxxxxxddddxxxxkkxxxxddddddddddddddoooodxxxdddddxxdooooddddxxxxxxxxxxdddooodddc               
               cxxxxxxxdddddxkkOOkxkkkkkkkxxdoddddddooxkkkkxxdddddoooooddddxkkkxkkxxxxxdooodddc               
               cxxxxxxxxxdxxkkkkxxxkkkkOOOkxdddxxxxddxkOOOOOkxxxxxdooodxxkkOOOOxOOkxxxxdooddddc               
               cxxxxxxxxxxkxxkkxxkkOkOOOkxxxdolllllldkkOOOOkxxddxdddooddxkOOO0OkkkOOOxddooddddc               
               lxxxxxxxkOOOOxxxxkOOOkxxxxxkdl;,'''',;oxkOOkxxxkkxoddooddodxkOO0Oxxkkxdddooddddc               
               lxxxxxxkO0000OkxxOOkxxkOkxxc;,''''''';dxxkkxkkkkkkxddodxxdodddkO0Oxxddxkkxddxxdc               
               lxxxxxOOO0000OOxxxxxxxkOkkd,.',;:ccllldkkxxkOkkkkkkxdooxxdxxxddxkkxdxkkkOOkkxxxl               
               lxxxxxOOOO000Okxxxxkkxkkkkx,'',:cclloodxxxxxkkkkkkkxdooddddxxddxxdddxkOO00OOkkxl               
               lkkkkxkOOOOOOOkxkkxxxkOkxkx;,,;:::cccloxkkkxddxkkkxddoodkkxdddxxxxxdxOOO0000Okkl               
               lkkkxxxxkOOOkxxxkkkkxkO0kkkl:;:::clccloxkOOkxdddxxddxooxkkxxkxddxkxdxkOO0000OkOo               
               cxkxxxxxxkkxxxxxxxddxxkOkkOxc::::cccclxkkkkkkxxdxxdddoodkkxkOkxdxxxdddxO00OkkkOo               
               ckOOkkkkkdxkkkkkkkxxkxxkkkkkd:::::ccloddkkkkxdddxkkxdoodxxxOkxxxdxkxkkkkkkkkkkko               
               cxkkkkkkxdxxkkkkkxdxxdddxxxdl::::::coddddxxdodxkxdxxxooddddxxxOkdxkOOO0Oxxk0000d               
               cxkkkkkkxdxkkkkkxdodxdoooo:'::::::ccocccoooddkkOkddddoodxkxddxxxddkOOOOOkxk0000o               
               lxdddxxkxdxxxddddddxdoc;'...;l::cc:co:;::;cdxkkkkxdodoodxxxddxkxdddkkkOOkkO000Oo               
               lxdxxxddddddddddddlc;'......'ooccc:ldc;:;..';lxkxdoddoodxxddxdxkkkddddxxkxkOOkkl               
               cddkkkkxdddxxxxdl,..........'ldoocodl;;;'....'lddooddoodxdodkxxkOOkxxkkxdddxkkkl               
               cddxkkkxdddxxxxo;.............,:::::'.c;......:ddoooooooddddxxdxOkdxkkkkkddOOOOo               
               lxddxxxdddoddddl...............::c::.'l;......;ddddddooooododddxkkxxxkkkxddkOOOo               
               lxxxddxxxxdooodl...............';;:;..;'......;ddxxdooooooxxxdddxkOOxxxxdxxxxkkl               
               lxxxddxxxdddood:...............':::,..'.......;ddxxxdooodxxkkkxxkOOOkxxxkkxxxxxo               
               lkkxdxxxxxxdooo'................';;,..'.......,ddxxddoooodxkOkxxkOOOOkxxkkkkOxxo               
               lkkxdxxxxxxdodc..................,,...,........odddddooooodxxdddkOOO0OxxOOkOOxxo               
               lkkxddxxxxxdod:..................'''..'........ldddddddodddddxxxkOOO0OxxOOkkOxxo               
               lxxddddddddooo,...................'...'....;:ccldddddddodddddkxdxkkkOkdxkkkkkxdl               
               lkxdddddddddol........................'....;:ccloddddddoddodddxdxkkkkxddxxxxkxxl               
               cxxdddxxxdddoc........................'.....,:clodddddddoodxxddodkkkxxddxxxxkxdl               
               cdddoddddddood:.............',;;,.....'.......',lddddddddddxxdoodxddddoddxdxxxdc               
               cdooooooooooooo;...........,,;::,.....'........codddddddddddddooodoooooodddddddc               
               :oooooooooooooool;,........,,;;;......'....loodddddddddddddddddddddoooooddddddoc               
               :oooooooooooooooood:.........''.....,.'....;ddddddddddddddddddddddddddddddddddo:               
               :oooooooooooooooooo;............  ..,,'.....ldddddddddddddddddddddddddddddddddo:               
               :oooooooooooooooooo:............  ..;,'.....:ddddddddddddddddddddddddddddddddoo:               
               :oooooooooooooooooo:................;;,.....'dddddddddddddddddddddddddddddddddo:               
               :oooooooooooooooooo:................:;,......lddddddddddddddddddddddddddxxxdddoc               
               cxxxxxxxdddxxxxxxxxxddddxxxddddddxxddddddddxxxxxxdddooooddddxdxxxxxxxxxxdooodddc               
               cxxxxxxxddddxxxxkkxxxxddddddddddddddoooodxxxdddddxxdooooddddxxxxxxxxxxdddooodddc               
               cxxxxxxxdddddxkkOOkxkkkkkkkxxddddddddodxkkkkxxddddddooooddddxkkkxkkxxxxxdooodddc               
               cxxxxxxxxxdxxkkkkxxxkkkkOOOkxdddxxxxddxkOOOOOkxxxxxdooodxxkOOOOOxOOkxxxxdooddddc               
               cxxxxxxxxxxkxxkkxxkkOkOOOkxxxxddddddddxkOOOOkxxxxxdddooddxkOOO0OkkkOOOxddooddddc               
               lxxxxxxxkOOOkxxxxkOOOkxxxxxkkdoollloxxxxkOOkxxxkkxoddooddodxkOOOOxxkkxdddooddddc               
               lxxxxxxkO000OOkxxOOOxxkOkxxkl;,'''',:okxxkkxkkOkkkxdooodxdddddkO0Oxxddxkkxddxxdc               
               lxxxxxOOO0000OkxxxxxxxkOkkdo:,'''',,,;xkkxxkOkkkkkkxdoodxdxxxddxkkxdxkkkOOkkxxxc               
               lxxxxxOO0O000Okxxxxkkxxkkkx;;;:clllll;okxxxxkkkkkkkxdooddddxxdxxxdddxkOOOOOOOkxl               
               lkkkkkkOOOOOOOkxkkxxxkkkxkk:;::clllllcoxkkkxddxkkkxddoodkkxdddxxxxxdxkOO0000Okxl               
               lkkkxxxxkOOOkxxxkkkkxkOOkkOl;::::ccccloxkOOkxdddxxddxoodkkxxkxddxkkdxkOO0000Okko               
               lkkxxxxxkkkxxxxxxxddxxkOkkkc:::::cllllxkkkkkkxxdxxdddoodkkxkOkxdxxxdddxO00OkkkOo               
               lkOOkkkkkdxkkkkkkkxxkxxkkkxdc:::::cllodxxkkkxdddxkkxdoodkxxOkxxxdxkxkkkkkkkkkkkl               
               lxkOkkkkxdxkkkkkkxdxxxddxxkxdl::::cloddddxxdodxkdxxxxooddddxxxOkdxkOOO0Oxxk0000d               
               cxkkkkkkxdxkkkkkxdodxddodxkkdc::::ccolccloooxkOOkddddoodxkxddxxxddkOOOOOkxk0000o               
               lxddddxxxdxxxdddddxxxddooxdc:c:;;:cclc;:ccodkkkOkxdodoodxxxdddxxddxkkkOOkkO000Oo               
               lxdxxxdddddddddddxkkxddoc;'..l::::c:ll;:;.'';coxxdoddoodxxddxdxkkxddddxxkxkOOkkl               
               lddkkkkxdddxxxxdddxxoc;'.....coc:::coo:;'......:dooddoooxdodkdxkOOkxxkkxdddxkkkl               
               cddxkkkxdddxxxxoooc;'........:odoccod:c:........ooooooooddddxxdxOkdxkkkOkddOOOOo               
               lxddxxxdddodxdoodl............,:::::,.c:........cddddooooododddxkkxxxkkkxddxOOOo               
               lxxxdddxxxddooddd:.............,:ccc,.,,........cxxdooooooxxxdddxkOOxxxxdxxxxkkl               
               lxxxddxxxxxdooddd,..............,:;;'.''........:xxxdooodxxkkkxxkOOOkxxxkkkkkxxo               
               lkkxddxkxxxdooddo...............,:;;'.''........,dxddoooodxkOkxxkOOOOkxxkkkkOxxo               
               lkkxdxxxxxxdodddl................,;,'',;;;;.....'odddooooodxxxddkOOO0OxxOOkOOxxo               
               lkkxddxxxxxdoddxc.................,'.,;::cc,....;ddddddoddddxxxxkOOO0OxxOkkkOxxo               
               lxxddddddddooddd;.................''..';;:c,....'ldddddodddddkxdxkkkOkdxkkkkkxxl               
               lxxddddddoddodxo;..................'.....',......'odddooddodddxdxkkkkxddkkxxkxxl               
               cxxdddxxxddooddo'.....................'.........,oddddoooodxxddodkkkxxddxxxxkxdl               
               cdddoddddddooddo'.....................'........;dddddddddddxxdoodxddddoddddxxxdc               
               codooooooooooddo;.....................'....':oodddddddddddddddoooddooooodddddddc               
               :oooooooooooooodc.....;;;'............'....odddddddddddddddddddddddoooooddddddoc               
               :oooooooooooooooo:,.':c::;..........'',....,ddddddddddddddddddddddddddddddddddo:               
               :ooooooooooooooooooc,,;:c:.........';;,.....cdddddddddddddddddddddddddddddddddo:               
               :ooooooooooooooooooc..';:,....... ..:;,'....,dddddddddddddddddddddddddddddddooo:               
               :ooooooooooooooooool...........    .::;,'....lddddddddddddddddddddddddddddddddo:               
               :ooooooooooooooooool...........    .cc;;,....:ddddddddddddddddddddddddddxxxdddoc               
               cxxxxxxxdddxxxxxxxxxddddxxxddddddxxddddddddxxxxxxxddooooddddxdxxxxxxxxxxdooodddc               
               cxxxxxxxddddxxxxkkxxxxddddddddddddddoooodxxxdddddxxdooooddddxxxxxxxxxxdddooodddc               
               cxxxxxxxdddddxkkOOkxkkkkkkkxxddddddddodxkkkkxxddddddooooddddxkkkxkkxxxxxdooodddc               
               cxxxxxxxxxdxxkkkkxxxkkkkOOOkxdddxxxxddxkOOOOOkxxxxxdooodxxkOOOOOxOOkxxxxdooddddc               
               cxxxxxxxxxxkxxkkxxkkOkOOOkxxxxddddddddxkOOOOkxxxxxdddooddxkOOO0OkkkOOOxddooddddc               
               lxxxxxxxkOOOkxxxxkOOOkxxxxxkkxddddxkkxxxkOOkxxxkkxoddooddodxkOOOOxxkkxdddooddddc               
               lxxxxxxkO000OOkxxOOOxxkOkxxkkxdoodxxkkkxxkkxkkOkkkxdooodxdddddkO0Oxxddxkkxddxxdc               
               lxxxxxOOO0000OOxxxxxxxkOOkxxo::,'',;:okkkxxkOkkkkkkxdoodxdxxxddxkkxdxkkkOOkkxxxc               
               lxxxxxOO00000Okxxxxkkxkkkkkx:''''',,,,okxxxxkkkkkkkxdooddddxxdxxxdddxkOOOOOOOkxl               
               lkkkkkkOOOOOOOkxkkkxxkOkxkOdc:;:clll:,cxkkkxddxkkkxddoodkkxdddxxxxxdxkOO0000Okxl               
               lkkkxxxxkOOOkxxxkkkkxkO0kkOl:ccclllll,cxkOOkxdddxxddxoodkkxxkxddxkkdxkOO0000Okko               
               lkkxxxxxkkkxxxxxxxxxxxkOOkOxc;;:cc:cl;okkkkkkxxdxxdddoodkkxkOkxdxxxdddxO00OkkkOo               
               lkOOkkkkkdxkkkkkOkxxkxxkOkkxo:::clllllodkkkkxdddxkkxdoodkxxOkxxxdxkxkkkkkkkkkkkl               
               lxkOkkkkxdxkkkkkkxdxxxddxxkxoc::cllllloddxxdodxkdxxxxooddddxxxOkdxkOOO0Oxxk0000d               
               cxkkkkkkxxxkkkkkkxddxddddkkkdl::cclllccldddddxOOkddddoodxkxddxxxddkOOOOOkxk0000o               
               lxddddxkxxxkxxddddxxxdddodkkdl:::cllc::ldodxxkkOkxdodoodxxxdddxxddxkkkOOkkO000Oo               
               lxdxxxddddddddxddxkkxdxxddxkol::::clc:;ccclodxkxxdoddoodxxddxdxkkxddddxxkxkOOkkl               
               lddkkkkxdddxxxkddxkkxdxxdolc';::;::c:c:;....',;ccooddoooxdodkdxkOOkxxkkxdddxkkkl               
               cddxkkkxddxxxxkdooxkxdxl:'...'lc::::col'.........;ooooooddddxxdxOkdxkkkOkddOOOOo               
               lxddxkxdddddxdddddddo:,.......loolccodo'..........cdddoooododddxkkxxxkkkxddxOOOo               
               lxxxddxxxxxdoodxxxdc..........,ccc:clc:'..........;ddoooooxxxdddxkOOxxxxdxxxxkkl               
               lxxxddxxxxxdoodxddd;............;;;;;;,...........,ddooodxxkkkxxkOOOkxxxkkkkkxxo               
               lkkxdxkkkxkxodxxxxd;............'::::;,............odoooodxkOkxxkOOOOkxxkkkkOxxo               
               lkkxdxkkkxkdodxxxxd'.............,;;,,,............:dooooodxxxddkOOO0OxxOOkOOxxo               
               lkkxdxkkxxxdodxxxxd,.............';:;;,............,dddoddddxxxxkOOO0OxxOkkkOxxo               
               lxxdddxddddoodddddd,..............',,,,....',;,'...,dddodddddkxdxkkkOkdxkkkkkxxl               
               lxxddddddoddodxxxxx'..............',,,'....,::ccc'..,lddddodddxdxkkkkxddkkxxkxxl               
               cxxdddxxxddoodxxxxd;''.............',,'....,;:ccc,..'ldooodxxddodkkkxxddxxxxkxdl               
               cdddoddddddooddddddccc:'...........',,,......';::...lddddddxxdoodxddddoddddxxxdc               
               cdddooddddoooodddolcccc:............',,............:ddddddddddoooddooooodddddddc               
               :oooooooooooooooooolclcc............,,,.........,coddddddddddddddddoooooddddddoc               
               :ooooooooooooooooool:;;'.............''.......cdddddddddddddddddddddddddddddddo:               
               :ooooooooooooooooool;...............''''......:dddddddddddddddddddddddddddddddo:               
               :ooooooooooooooooooool:.............;:;;,'.....oddddddddddddddddddddddddddddooo:               
               :ooooooooooooooooooool'.............;c:c:;'....:ddddddddddddddddddddddddddddddo:               
               :ooooooooooooooooooodl..............;c:cc:;....:ddddddddddddddddddddddddxxxdddoc               
               cxxxxxxxdddxxxxxxxxxxdddxxxddddddxxddddddddxxxxxxxddooooddddxdxxxxxxxxxxdooodddc               
               cxxxxxxxddddxxxxkkxxxxddddddddddddddoooodxxxdddddxxdooooddddxxxxxxxxxxdddooodddc               
               cxxxxxxxdddddxkkOOkxkkkkkkkxxddddddddodxkkkkxxddddddooooddddxkkkxkkxxxxxdooodddc               
               cxxxxxxxxxdxxkkkkxxxkkkkOOOkxdddxxxxddxkOOOOOkxxxxxdooodxxkOOOOOxOOkxxxxdooddddc               
               cxxxxxxxxxxkxxkkxxkkOkOOOkxxxxddddddddxkOOOOkxxxxxdddooddxkOOO0OkkkOOOxddooddddc               
               lxxxxxxxkOOOkxxxxkOOOkxxxxxkkxxxdxxkkxxxkOOkxxxkkxoddooddodxkOOOOxxkkxdddooddddc               
               lxxxxxxkO0OOOOkxxOOOxxkOkxkOkxdxkkkkkkxxxkkxkkOkkkxdooodxdddddkO0Oxxddxkkxddxxdc               
               lxxxxxOOO0000OOxxxxxxxkOOkxkkxdoolcldxkkkxxkOkOkkkkxdoodxdxxxddxkkxdxkkkOOkkxxxc               
               lxxxxxOO00000OkxxkxkkxkkkkOOxc;,,''',;cxxxxxkkkkkkkxdooddddxxdxxxdddxkOOOOOOOkxl               
               lkkkkkkOO0OOOOkxkkkxxkOkkkO0xc,'',,;;,,lkkkxddxkkkxddoodkkxdddxxxxxdxkOO0000Okxl               
               lkkkxxxxkOOOkxxxkkkkxkO0kk0Odlc:cllol:,cOOOkxdddxxddxoodkkxxkxddxkkdxkOO0000Okko               
               lkkxxxxxkkkxxxxxxxxxxxOOOkOOolc:ccllll;ckkkkkxxdxxdddoodkkxkOkxdxxxdddxO00OkkkOo               
               lkOOkkkkkxxkkkkkOkxxkxxkOkkkxo:;:lcclc:lxkkkxdddxkkxdoodkxxOkxxxdxkxkkkkkkkkkkkl               
               lxkOkkkkxdxkkkkkkxdxxxdxxxkxdo:::clllllodxxdodxkdxxxxooddddxxxOkdxkOOO0Oxxk0000d               
               cxkkkkkkxxxkkkkkkdddxddddkkkdoc::clllccldddddxOOkddddoodxkxddxxxddkOOOOOkxk0000o               
               lxddddxkxxxkxxddddxxxdddoxkkdol:::cll::cdddxkkkkkxdodoodxxxdddxxddxkkkOOkkO000Oo               
               lxdxxxddddddddxddxkkxxxxddxkddl:::ccc::cdoodxxkkxdoddoodxxddxdxkkxddddxxkxkOOkkl               
               lddkkkkxddxxxxkddxkkxdkkddxxoll::;:clc:;;:clodxddooddoooxdodkdxkOOkxxkkxdddxkkkl               
               cddxkkkxddxxxxxdooxkxdxddoc;'.c::;:ccll,.....';:clodooooddddxxdxOkdxkkkOkddOOOOo               
               lxddxkxdddddxddddddddoo:,.....coc:::coo,..........:dddoooododddxkkxxxkkkxddxOOOo               
               lxxxddxxxxxdoodxxxdol'........cddoccodc'...........lddooooxxxdddxkOOxxxxdxxxxkkl               
               lxxxddxxxxxdoodxdddo,..........,;;;:cl;............:ddooodxkkkxxkOOOkxxxkkkkkxxo               
               lkkxdxkkkxkxodxxxxdl............,::::;,............,dddoodxkOkxxkOOOOkxxkkkkOxxo               
               lkkxdxkkkxkdodxxxxxl.............;:::;,.............cddooodxxxddkOOO0OxxOOkOOxxo               
               lkkxdxkkxxxdodxxxxxl.....''......;;;;,,.............;ddoddddxxxdxOOO0OxxOkkkOxxo               
               lxxdddxdddxooddddddl...,::;......':;;;,.............;ddddddddkxdxkkkOkdxkkkkkxxl               
               lxxddddddoddodxxxxxc..,::::,......;;,,'..............lddddddddxdxkkkkxddkkxxkxxl               
               cxxdddxxxddoodxxxxx:..,;;::'......',,,'...............:dddddxddodkxxxxddxxxxkxdl               
               cdddoddddddoodddddd;..,,;:;........',,,...............,oddddxdooddddddoddddxxxdc               
               cdddodddddooooddooo,.,'.''.........',,,'............',;oddddddddoodooooodddddddc               
               :oooooooooooooooooo,.,.............',,,'........  ..,;:coddddddddddoooooddddddoc               
               :ooooooooooooooooool................',,''...........,;:lodddddddddddddddddddddo:               
               :oooooooooooooooooooc;;;c'..........',''''.......;'.',:lodddddddddddddddddddddo:               
               :oooooooooooooooooooooooc............',,,;,......looc;,codddddddddddddddddddooo:               
               :ooooooooooooooooooooooo;...........:::llc:,.....,ddxdddddddddddddddddddddddddo:               
               :ooooooooooooooooooooool,...........:ccllcc;.....'odddddddddddddddddddddxxxdddoc               
               cxxxxxxxxxxxxxxxxxxxxdddxxxddddddxxddddddddxxxxxxxddooooddddxdxxxxxxxxxxdooodddc               
               cxxxxxxxxxxxxxxxkkxxxxddddddddddddddoooodxxxdddddxxdooooddddxxxxxxxxxxdddooodddc               
               cxxxxxxxxxxxxxkkOOxxkkkkkkkxxddddddddodxkkkkxxddddddooooddddxkkkxkkxxxxxdooodddc               
               cxxxxxxxxxdxxkkkkxxxkkkkOOOkxdddxxxxddxkOOOOOkxxxxxdooodxxkOOOOOxOOkxxxxdooddddc               
               cxxxxxxxxxxkxxkkxxkOOkOOOkxxxxddddddddxkOOOOkxxxxxdddooddxkOOO0OkkkOOOxddooddddc               
               lxxxxxxxkOOOkxxxxkOOOkxxxxxOkxxxxxxkkxxxkOOkxxxkkxoddooddodxkOOOOxxkkxdddooddddc               
               lxxxxxxkO0OOOOkxxOOOxxkOkxxkkxdxkkkkkkxxxkkxkkOOOkxdooodxdddddkO0Oxxddxkkxddxxdc               
               lxxxxxOOO0000OOxxxxxxxkOOkxkkxxxxxxxxkkkkxxkOkOkkkkxdoodxdxxxddxkkxdxkkkOOkkxxxc               
               lxxxxxOO00000OOxxkxkkxkOkkOOkxxdlcc;,,:loxxxkkkkkkkxdooddddxxdxxxdddxkOOOOOOOkxl               
               lkkkkkkOO0OOOOkxkkkxxkOkkO00Oxxl,''''',,,cxxddxkkkxddoodkkxdddxxxxxdxkOO0000Okxl               
               lkkkxxxxkOOOkxxxkkkkxkO0kk00kxdc;;;:ccc:,;xkxdddxxddxoodkkxxkxddxkkdxkOO0000Okko               
               lkkxxxxxkkkxxxxxxxxxxxkOOkOOkxocccclllll:,dkkxxdxxdddoodkkxkOkxdxxxdddxO00OkkkOo               
               lkOOkkkkkxxkkkkkOkxxkxxkOkkOkxocc;:cc:cl::xkxdddxkkxdoodkxxOkxxxdxkxkkkkkkkkkkkl               
               lxkOkkkkxdxkkkkkkxdxxxdxxxkkxxdoc::cllllllddodxkdxxxxooddddxxxOkdxkOOO0Oxxk0000d               
               cxkkkkkkxxxkkkkkkdddxddddkkkxddol:::clcclooddxkOkddddoodxkxddxxxddkOOOOOkxk0000o               
               lxddddxkxxxkxxddddxkxxddoxkkxdddoc::c:::oodxxkkkkxdodoodxxxdddxxddxkkkOOkkO000Oo               
               lxdxxxddddddddxddxkkxxxxddxkdddddc::c:;cddddxxkkxdoddoodxxddxdxkkxddddxxkxkOOkkl               
               lddkkkkxddxxxxkddxkkxdxkddxkdddddc;;:c:clloddxxddooddoooxdodkdxkOOkxxkkxdddxkkkl               
               cddxkkkxddxxxxkdodxxxdxxdxdxolcco:;;:cllo;';:looooooooooddddxxdxOkdxkkkOkddOOOOo               
               lxddxkxdddddxdddddddddddooc;'..,oc:::cooo;.....,;:lodooooododddxkkxxxkkkxddxOOOo               
               lxxxddxxxxxdoodxxxddddl:,'.....;odlc:clod,.........'lodoooxxxdddxkOOxxxxdxxxxkkl               
               lxxxddxxxxxdoodddddood;........,:ccc:olo;...........,odddxxkkkxxkOOOkxxxkkkkkxxo               
               lkkxdxkkkxkxodxxxxxddo'..........';;::;;.............lddddxkOkxxkOOOOkxxkkkkOxxo               
               lkkxdxkkkxkdodxxxxxddc............,;;::;.............:dddodxxxddkOOO0OxxOOkOOxxo               
               lkkxdxkkxxxdodxxxxxxd;........';;,;:;;;,.............'odddddxxxdxOOO0OxxOkkkOxxo               
               lxxdddxddddoodddddddd;......,::;,.,;;;;,'.............cddddddkxdxkkkOkdxkkkkkxxl               
               lxxdddddddddoxxxxxxxd,.....':::::;;:,,,,'.............,oddddddxdxkkkkxddkkxxkxxl               
               cxxdddxxxxddoxxxxxxxo'.....'::::,..;;,,'...............cddddxddodxxxxxddxxxxkxdl               
               cdddddxddddooddddddd:......';,.....''',,'..............'odddddooddddddoddddxxxdc               
               cdddodddddooooddddoo'......... ....'',,,,...............:dddddddoodooooodddddddc               
               :oooooddoooooooooooo,...............,,,,,'..............:ddddddddddddoooddddddoc               
               :oooooooooooooooooooc...............',,,,'..............:dddddddddddddddddddddo:               
               :ooooooooooooooooooooc::;;:'........,,,,''........   ...,cldddddddddddddddddddo:               
               :oooooooooooooooooooooooool..........''''',.......   ..',;:cloddddddddddddddooo:               
               :oooooooooooooooooooooodddc..........,;::cc:,..........',,;:coddddddddddddddddo:               
               :oooooooooooooooooooooddddc.........:cclollc;'......:,'',,;:ldddddddxxxxxxxdddoc               
               cxxxxxxxxxxxxxxxxxxxxddddxxddddddxxddddddddxxxxxxdddooooddddxdxxxxxxxxxxdooodddc               
               cxxxxxxxxxxxxxxxkkxxxxddddddddddddddoooddxxxdddddxxdooooddddxxxxxxxxxxdddooodddc               
               lxxxxxxxxxxxxxkkOOkxkkkkkkkxxddddddddodxkkkkxxddddddooooddddxkkkkkkxxxxxdooodddc               
               lxxxxxxxxxdxxkkkkxxxkkkkOOOkxdddxxxxddxkOOOOOkxxxxxdooodxxkkkOOOxOOkxxxxdooddddc               
               lxxxxxxxxxxkxxxkxxkOOkOOOkxxxxddddddddxkOOOOkxxxxddddooddxkOOO0OkxkOOOxddooddddc               
               lxxxxxxxkOOOkxxxxkOOOkxxxxxOkxxxdxxkkxxxkOOkxxxkkxoddooddodxkOOOOxxkkxdddooddddc               
               lxxxxxxkO0OOOOkxxOOOxxkOkxxkkxdxkkkkkkxxxxxxkkOOOkxdooodxdddddkO0Oxdddxkkxddxxdc               
               lxxxxxOOO0000OOxxxxxxxkOOkkkkxxxxxdol:;cloxkOOOkkkkxdooxxddxxddxkkxdxkkkOOkkxxxc               
               lxxxxxOO00000OkxxkxkkxkOkkkkkxxxxl,,,''',,:dkkkkkkkxdooddddxxdxxxdddxkOOOO0OOkxl               
               lkkkkkkOOOOOOOkxkOkxxkOkkO00kxxxdc;,;;:::;,lddxkkkxdooodkkxdddxxxxxdxkOO0000Okkl               
               lkkkxxxxkOOOkxxxkkkkxkO0kk00Oxxdlccccloool;cxdddxxddxoodkOxxkxddxkkdxkOO0000Okko               
               lxkxxxxxkkkxxxxxxxxxxxOOOkO0kxddl::::ccccl:lkxxdxxdddoodkkxkOkxdxxxdddxO00Okkkko               
               ckOOkkkkkxxkkkkkOkxxkxxkOkkOkxxxdlc::cllllloddddxkkxdoodkxxOkxxxdxkxkkkkkkkkkkko               
               lxkOkkkkxxxkkkkkkxdxxxdxxxkkxxxxdoc::cllllloodkkddxxxooddddxxxOkdxkOOOOOxxk0000o               
               cxkkkkkkxxxkkkkkkdddxddddkkOxddddoo::cclllodxxOOkddddoodxkxddxxxddkOOOOOkxk0000o               
               lxddddxkxxxkxxddddxkxxddoxkkxdddddo::::cllodxkkkkxdoooodxxxdddxxdddkkkOOOkO000Oo               
               lxdxxxddddddddxddxkkkxxxddxOxdddddo::::cllooddxxxdoddoodxxddxdxkkkddddxxkxkOOkkl               
               lxdxkkkxddxxxxkddxkkxdxkddxkdddoolo:;::clll:':cloodddoodxdodkdxkOOkxxkkxdddkkkOl               
               cddxkkkxddxxxxxdooxkxdxxdxdxoc;,',lc:clccco;.....,:codddddddxxdxOkxxkkkOkddOOOOo               
               lxddxkxdddddxddddddddddxdlc;'....'odllolloo,.........,cooooodddxkxxxxkkkxddxOOOo               
               lxxxddxxxxxdoodxxxddodxkl'.......'lllllodoc...........'ldddxxdddxkOOxxxxdxxxxkkl               
               lxxxddxxxxxdooddxxdddxxk:..........,::::cc,............cddxkkkxxkOOOkxxxkkkkkxxl               
               lkkxdxkkkxkdodxxkkxddxxx,..........':c::::'............:ddxkkkxxkOOOOkxxOkkkOxxo               
               lkkxdxkkkxkdodxxxxxddddo'...........;:;;;;'............,dddxxxddkOOO0OxxOOkOOxxo               
               lkkxdxkkxxxdodxxxxxddxxo............,::;;;,.............odddxxxdxOOO0OxxOkkkOxxl               
               lxxdddxddddooddddxxdxkxo.............;;;;;,.............cdddxkxdxkkkOkdxkkkkkxxl               
               lxxddddddddooxxxxxxddxxo,',,.........,;;;,,.............:dddddxdxkkkkxddkkxkkxxl               
               lxxdddxxxxxdoxxxxxxxdddl::::,........';;;;,.............,dddxddodxxxkxddxxxxkxxl               
               cdddddxddddoodxxxxxddddccccc;........',;,,,..............:ddddooddddddoddddxxxdc               
               :dddodddddooooooddddddo:::cc,........',,,,,'.............,ddddddooddoooodddddddc               
               :dooooddooooooooooddddo:,,;;.........',,,,,'............'ldddddddddddoooddddddoc               
               :ooooooooooooooooodddddc'.............,,,,,'........,,'.:dddddddddddddddddddddo:               
               :oooooooooooooooooooddoolc::c.........''''''.......';:ccodddddddddddddddddddddo:               
               :ooooooooooooooooooooooooood;.........'',;;;,'.....';::lddddddddddddddddddddooo:               
               :ooooooooooooooooooooooodddo'.........;llllc:,......,;coddddddddddddddddddddddoc               
               :ooooooooooooooooooooooodddo'.........;lllllc;.......,ldddddddddxxxxxxxxxxxdddoc               
               .''''',''''''''''''''''''''''''''',,,,''''',,,,'''''''''''.            .';;;;;;'               
               .''''',,'''''''''''''...........',,,,'''''',,,,'''''''''''.             .,;;;;;'               
               .''''',,,'''''''''''..   ...........','',,,,,''''''''''''..             .';;;;;'               
               .''''',,''''''''''..................',,,,,,'''''''''''''..              ..;;;;;'               
               .,,,,,,,,,,,,''''..................',;::;,,''''''''''''''.               .;;;;:,               
               .',,,,''''''''''...........   ......'';;:;,''''''''''''''...         .....;;:::,               
               .',,,,,,'''''''....................',,,,,,,,,'''',,''''''.................,::::,               
               .'',,,,,,,,,,,''......''''''.....'';:;,'''''''''',,,,''''.................,::::,               
               .'',,,,,,,,,,,'.....,;::clllc::::::cll:'''''''''''',,''''.................,;:::,               
               .',,,,,,,,,,,,'....,:ccclllllcccccccloo;,,,'''''''',,,'''..............''';::::,               
               .,,,,,,,,,,,,,,...';:cccclllcccccccclodl;,,,,,,,,''',,,'''......''''''''',;::::,               
               .,,,,,,;;,,,,,,'..';:cccccccccccc:ccclxo:;,,,,,,,'''''''''''''''''',,,,,,,;::::,               
               .',,,,,,,,,,,,,'..';::;;;;;;::::;;;;:ldolc;,,,,,,,,'''''''',,,,,,,,,,,,;;;:::::,               
               .'''''',,,,,''','.,:::;;,,,;::;''.'',:oolc,''''''''''''''',,,,,,;;;;;;;;;;::ccc;               
               .','',,,,,,,,',;:,;:cc:::::ccc:;;;;;;:lol:;,,,,,,,,,,,,,,,,,,,,;;;;;;;;;;:::ccc;               
               .'''',,,,,,,'',;::::cccccccc:::;;::::col;:,,,,,,,'''''''',,,,;;;;;;;;;::::::ccc;               
               .,,,,,,,,,,,''',:c:::ccc::::::c::;:::loc,:,,,,,,,,,,,,,,,;;;;;;;;::;;;;;::::ccc;               
               .',''',,,,,,,,,,;::::::;;::;;;;,'';;:lolc,,'''''',,,,,,,,,;;;;;;;;;;;;;;:::cccc,               
               .'''''''''''''''',,;;;,,::ccc;,',,,,;lc;,,,,,,,,,,,,,,,,,,;;;;;;;;;;;;;:::ccccc,               
               .,,,,,,,,,,,,,,,,,,;;;:::,;:::;,'.';:l;,''',,,,,,''''''',;;;;;;;;;;;;;;;;::cccl;               
               .''''',,,,,,,,,,,;::::::c:;;;;,,,;::c:,,,,,,,,,,,,,,,,,,,,;;;;;;;;;;;;;;;;:cccc;               
               .,''',,,,,,,,,,;clcc::::c:::;;;;::ccc;;,,,,,,,,,,,,'''',,,;;;;;;;;;;;;;;:::cccc;               
               .,,,,,,,,,,,;:clll,.;:;::cc::;;:cll:..::',,,,,,,,,,,,,,,,,,;;;;;;;,;;;;;::ccccc;               
               .,,,''''',',cllod:..,:::;;:::::cc:,. .,lc;,,,,,,,,,,,,,,,,;;;;;;;;;;;;;:ccccccl;               
               .,,,,;,,,;coooodd;...,:::;,''',,'...  .lll::;;,,,,,,,,,,,,;;;;;;;;;;;;;:ccccccl;               
               .,,,,,;;:oddoodoo'....';;;;,......    .llc:cloc:;,,''''''',;;;;;;;;;;;;:ccccccl;               
               .,,,;clddddddoooc.  .. ..',,'..       ,lll:lddddol:;,,,;;,,;;;;;;;;;;;;:cclllll;               
               .,;codddddddollc;.  ..                ;oolccoddddodol:;;;;;;;;;;;;;;;;;:cllllll;               
               ;oddddddddddlcl:;'....                :oolc:coddddddddlc;;;;,;;;;;,,,,;:cllllll;               
               cdddddddddddollll;....               .cooll::lddddddddddo;;;,,,,,,,,,,,:cllllll;               
               cddddddddddddooolc......             .looooc;cdddddddddddo;,,,,,,,,,,,;:cccclll;               
               cdddddddddo:::::cl:.......       . ..;loolc:;:ldddddddddddo:;;;;;;;;;;;:cllllll;               
               cdddddddddc,,,,,:lc,......    ......'cccc;;:;:codddddoddoddo::::;;;;;;;:cllllll;               
               cdddddddddllcclooolc;...............c:;;;;;;;;:coddddodoooddl:;;;;;;;;;:cllllll;               
               cdddddddddddddddddooo,. ...........;lc;ccc:;;;;:lddddloododddoc;;;;;;;;:clllllc;               
               cdodddddddddddddddooo;  ...........cl:;oddllc;;:lddddloododdodd:;;;;;;;:clllccc;               
               .................''''''''''''''''''''''''''''''''''''''''..            .,;;;;;;'               
               .................''''''''''''''''''''''''''''''''''''''''.             ..,;;;;;'               
               ........''''''...''''''''''''''''''.'''''''''''''''''''''.              .,;;;;;'               
               .........''''''..'''........''''''''''''''''''''''''''''..              .,;;;;;'               
               ....''''''''''................''''''''''''''''''''''''''..              .';;;;:,               
               ....''............................',,,''''''''''''''''''..            ....;;:::,               
               ....'''''.........................,;;;,,''''''''''''''''..................;;:::,               
               .........'''..............   .....',;;:;''''''''''''''''..................;;:::,               
               ....''''.''''.....................',,,;,,'''''''''',,'''.................';::::,               
               ...'''''''''.....................';;,,''''''''''''''''''................',:::::,               
               .'.'''''''''........'',;;;,''',;;:c:;''''''''''''''''''''.......''''''''',:::::,               
               .'''.'''''........,;:ccllllccccccclll;,''''''''''''''''''''''''''',,,,,,,;:::::,               
               .....'''''''.....';:ccccllllcccc::cool;,,,''''''''''''''''',,,,,,,,,,,;;;;:::::,               
               .........'''.....,;:ccccccccccc:::ccod:;,,''''''''''''''',,,,,,;;;;;;;;;;::::cc;               
               ......'''''......,::::cccccccc:::::codc:;,'''''''''''''',,,,,,;;;;;;;;;;;:::ccc;               
               .....'''''.......,::;;;;,,;:::;'''';colc;''''''''''''''',,,,,;;;;;;;;;;;::::ccc;               
               .....'''''....'..,:::;,,;;;:c;',,,,;:olcc,''''''''''''',;;;;;;;;;;;;;;;;::::ccc;               
               .''''.....'''',;,;::c::::cccc;;:::::cll:;,'''''''''''''',;;;;;;;;;;;;;;:::ccccc,               
               .............';:::::ccccccc:::;;::::coc,;'''''''''''''',,;;;;;;;;;;;;;::::ccccc,               
               .......''''''',:c:::ccc::::::::;,;::coc:,''''''''''''''',;;;;;;;;;;;;;;;::ccccl;               
               ........''''''',c:::::;;:::;,'..,,;;cl:,'''''''''''''''',;;;;;;;;;;;;;;;;:ccccc;               
               ........'''''''',,;;;;;;:::::;,,,,,;cc'''''''''''''''''',;;;;;;;;;;;;;;;::ccccc;               
               ..'''...''''''.''',;:;::;;:::;;'',:cl,'''''''''''''''''',;;;;;;;;;;;;;;:::ccccc;               
               ..............'.';::::::::::;,;;:::c:;,'''''',,''''''''',;;;;;;;;;;;;;;:ccccccl;               
               ..''''''''''''';ccc:::::c:::;;;::cl:.,l:,,,'',,'''''''',,,;;;;;;;;;;;;;:ccccccl;               
               ....'''''''''';ccl:,::;;::cc:::cl:,. .:lc;,'''''''''''''..,;;;;;;;;;;;::ccccccl;               
               ..''''''''',;:cloo;.;:::;;;;;;;:,'..  ;llc:::;,,,,,''''''',;;;;;;;;;;;;ccclllll;               
               ....''''';cloollodc..,::;,'...'....   ,ll::cloocc;,,,,,,,,,,;;;;;;;;;;;clllllll;               
               ....',;codddooloool. ..,;;,'.....     ;olcclddddddlc;,,,,,,,,;;;;;,,,,;clllllll;               
               .'',:lddddddddooool.   .......        ;oolccodddddddol:;,,,,,,,,,,,,,,;:lllllll;               
               .;lodddddddddddoll:.                  ;ooll:cddddddddddl;,,,,,,,,,,,,,;ccccclll;               
               ;ddddddddddddddoc:,.                 .:ooll:;odddddddddddc,;;;;;;;;;;;::cclllll;               
               cddddddddddddddoc;;;...             ..:ooooc;cdddddddddddoc;::::;;;;;;:clllllll;               
               cdddddddddddoddolcll,...             .loolc:;;loodddddddodoc;;;;;;;;;;;:lllllll;               
               cdddddddddddodoollccc'...       .....;llc:;,;,:ooddddloloddd:;;;;;;;;;;:clllllc;               
               cdddddddddddooolc:::c:...     .......cc;;;;;;,;clddddlolodddo:;;;;;;;;;:clllccc;               
               ,::::ccc::::::ccccccccccccccccccccc:::::::::::::::;;;;:;;;.            .,;;;;;;'               
               ,:::cccc::::::::::cc::cc:::ccc::::::::::::::::::::;;;;;;;,.            ..,;;;;;'               
               ,::::ccc:ccccc::::cccccc::ccc:::::;;;;:::::::::::;;::;;;;.              .,;;;;;'               
               ,:::::cc::ccc:::::::::::::::::::::::::::::::::;;;;;::;;;,.              .,;;;;;'               
               ,::ccccccccccc:::::::::;;;;::::::::;;;;;;;;;;;;;;;;::;;;,.              .';;;;:,               
               ':::c::::::::::::::::::::::::::::::;;;;:;;;;;;;;;::::;;;,...         .....;;:::,               
               ,:::cc::::::;;::;;;;::;;,,,,;;;;;;;;;;;:;;;;;;;::::;;;;;,.................;;:::,               
               ,::::ccccccccc::::;;'.........',;:;;::;;;;;;;;;;;::::;;;,.................;;:::,               
               ,:::cccc:::::::;;'................';;:;;;;;;;;;;;;;::;;;,................';::::,               
               ,:::ccccc::::::'..   ............'',;;;;;;;;;;;;;;;::;;;,...............',:::::,               
               ,::::cccc:::::,...................',;::::;;::::::;;;;;;;,'......''''''''',:::::,               
               ,:cccccccc:::,..........     ......',;:;;;,;;::;;;;;;;;;,''''''''',,,,,,,;:::::,               
               ,::::::::::::;...................',;,,,,,;;;;:;;;;;;;;;;;,,,,,,,,,,,,,;;;;:::::,               
               ,::::::;;:::;,.......'''''.....'';:c;'',,;;;;;;;;;;;,;;,,,,,,,,;;;;;;;;;:::::cc;               
               ,:::::cc:::::,....';:cclllc:::::cclol;,,,;;;;;;;;;;;;;;;;,,,,,;;;;;;;;;;::::ccc;               
               ':;;;:ccc:;;;'...'::cccllllccccc:clddl;;;,;;;;;;;;,;;,,,,,;;;;;;;;;;;;::::::ccc;               
               ':::::::::::;,...,::ccccllccccc:::cldd:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::::ccc;               
               ':::::;;;;;;;;...,::ccccccccccc:::clddlc:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::::ccccc,               
               ';;;;;;;;;;;;;'..;::;;;;;;::::;,,,,:odoc:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::::ccccc,               
               ';::::::::::;;;..;::;;,'',;::,'..'',colc;,,;;;;;;;;,,,,;;;;;;;;;;;;;;;;;::ccccl;               
               ';;;;;;;::::::;:,:cc::;;;::c:;;;;;;:coc:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:ccccc;               
               ';;;;;;;::::::c::::ccccccccc::::::::lo;:;;;;;;;,,,,,,,,,;;;;;;;;;;;;;;;;::ccccc;               
               ,::::;;;;;;;;;:cc:::ccc::::::::;::::ooc;;;;;;;;;;;;;;;;;,;;;;;;;;;,;;;;:::ccccc;               
               ,::;;;;;;;;;:;;:c:::::;;::;:::;',;;:ol:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:ccccccl;               
               ,::::;;;::::::::;;::;,;:cc::,'.,;,,:o:;;;;;;;;;;;;;;;;;,,,;;;;;;;;;;;;;:ccccccl;               
               ,;;;;;;;;;;;;;;::::::;:;;;;:;;,..,:cc,,,,,,,,,,,,,,,,,,,'',;;;;;;;;;;;;:ccccccl;               
               ';;;::::::;;;;:c:l:::::c::::;;;;::::c:,,,,,,,;;;;;;;;;;;;;;;;;;;;;;;;;;ccclllll;               
               ';;,;;;;,;;;,,::lc;::::c:::;;;;:cc:.'cc::::;;;;;;;;;;;;;;;;;;;;;;;;;;;;clllllll;               
               '::;::::;;;:clllo;'::::::::::::cl;. .;lc:::::;;;;;;;;;;;;;;;,;;;;;,,,,;clllllll;               
               '::::::ccloddolodc.':::;;::::::;,.. .;ol::::coolc:;;;;;;;;;;,,,,,,,,,,;:lllllll;               
               ';;;::lddddddllddo,..,:;,'...''..   .:ooc::odddodolc:;;;;;;;,,,,,,,,,,;ccccclll;               
               .;:loddddddddooodo;....',,'....     .loolccddddddddddlc::;;;;;;;;;;;;;::cclllll;               
               ,lodddddddddddoool;.    ....        .loool:ldddddddddddc:;;:::::;;;;;;:clllllll;               
               :ddddddddddddddoc:'                 .oooolc:odddddddddddl;;:;;;;;;;;;;;:lllllll;               
               cddddddddddddddoc;....              'oooooc:lddddddddddddl::;;;;;;;;;;;:clllllc;               
               cddddddddddddddoc;;;..             .,loool;;:dddddddooooddc;;;;;;;;;;;;:clllccc;               
               ......'..........'''''''''''''''''''''''''''''''''''''''...             .,;;;;;'               
               ......''.........'''''''''''''''''''''''''''''''''''''''...             .';;;;;'               
               ......''..........'''''''''''''''''..''''''''''''''''''....              .;;;;;'               
               ..........'''.....'''''''''''''''''...'''''''''''''''''...               .,;;;;'               
               .....'''''''''....''''''...............'''''''''''''''''....            ..,;;;:,               
               ..............''''''''''''''''''''''''''''''''''''''''''.. .         .....';:::,               
               ....''........''''..'''''''''''...'''''''.''''''''''''''.. ...............';:::,               
               .'..''''''''''''.'''.........'''''''''''''''''''''''''''..................';:::,               
               .'.'''''''''''.................',,'''..'''''''''''',,''''.................,;:::,               
               .'''''''''''''....  ..............',,,''..'''''''''''''''..............''';::::,               
               .'''''''''''''...................',,;;,''''''''''''''''''........'''''''',;::::,               
               .''''''''''''.............   .....'';::,''''''''''''''''''''''''''',,,,,,,;::::,               
               .''''''''''''...........     ......',,;,''''''''''''''''''',,,,,,,,,,,,;;;:::::,               
               .''''''''''''....................,;,,''''''''''''''''''''',,,,,,;;;;;;;;;;:::cc;               
               .'''''''''''......',;;;:;;,''',,;:cc,'',''''''''''''''''',,,,,,;;;;;;;;;;:::ccc;               
               .'''''''''''.....';:cccllllcccc::cloc,,,,'''''''''''''''',,,,;;;;;;;;;::::::ccc;               
               .'''''''''''.....,::ccccllccccc::cloo:;,,''''''''''''''',;;;;;;;;:;;;;;;::::ccc;               
               .'''''''''''.....;::cccccccccc:::ccldl:;,''''''''''''''',,;;;;;;;;;;;;;::::cccc,               
               ................';:::::ccccc::::::clolc;'''''''''''''''',;;;;;;;;;;;;;:::::cccc,               
               .'''''''''''''..';;;;;;,,,;::;,''',:llc;'''''''''''''''',;;;;;;;;;;;;;;;;::cccl;               
               .'...'''''''',,',:::;,,,,;:::''''',;cl:;''',,'',,,,''',',;;;;;;;;;;;;;;;;;:cccc;               
               .''''''''',',;:;;:cccc:::ccc:;;:::::ll:,''',,,,,,,,''''',,;;;;;;;;;;;;;;:::cccc;               
               .'''''''''''',:c::::ccccccc:::;::::coc;;,,,,,,,,,,,,,,,,,,;;;;;;;;,;;;;;::ccccc;               
               .''''''''''',,:c::::cc:::::::::,:::col;,,,,,,,,,,,,,,,,,,,;;;;;;;;;;;;;:ccccccl;               
               .,''''''',,,,'';;::::,;:::;,,'.';,;cl;,,,,,,,,,,,,,,,,,,,,,;;;;;;;;;;;;:ccccccl;               
               .''''''''',''',;;;::,;;;:::;,','',;c:'''''''''',,,,,''''''',;;;;;;;;;;;:ccccccl;               
               .''',,,,',,,,,;:c:::;::;;;::;;'.,;cc,'''''''',,,,,,,,,,,,,,,;;;;;;;;;;;:cclllll;               
               .''''','''''',:cc;::;:c::::;,,;::::c;,,,,,,,,,,,,,,,,,,,,,,,;;;;;;;;;;;:cllllll;               
               .,,,,,,,,,,,:c:l:,::::::::;;;;:cl;.,c:;;;,,,,,,,,,,,,,,,;,,,,;;;;;,,,,;:cllllll;               
               .,,,,,;;:cloocloc.;:::::::::::cc,. ':c::::;;;,,,,,,,,,,,,,,,,,,,,,,,,,,;cllllll;               
               .,,,,;coododocodo'.,;:;;,,,;,;;..  .:l:;::;:cl:;,,,,,,,,,,,,,,,,,,,,,,,:cccclll;               
               .';:loddddodolooo;...,;;,'.....    .:ll;;:clooddoc;,,,,;;;;;;;;;;;;;;;;:cllllll;               
               ,lodddddddddooooo;......'''..      'lol:;ldddddddddl:,,;;;;;;:::;;;;;;;:cllllll;               
               :oooddddddddooolc'                 ,oooc:coddddddddddl:;,,,;;;;;;;;;;;;:cllllll;               
               cdodddddodddoooc:'                 ;oool::lddddddddddooc,,,;;;;;;;;;;;;:clllllc;               
               cdddddddodddooo:;,..               ;oool::codddddddddddd:,,;;;;;;;;;;;;:ccllccc;               
               .....................................'......................            .',;;;;'               
               ............................................................             .,;;;;'               
               ...........................................................              .,;;;;'               
               ...........................................................              .';;;;'               
               ...........................................................              .';;;;,               
               .......................''''''..............................              ..;;;;,               
               ......................'''''................................  ..............;;;:,               
               ......................'''..........................''......................,;;:,               
               ...................................................'''.''..................;;;:,               
               ......................  ....''''...................'''''..................';:::,               
               ........'''.......  .... ......''''''..''...'''''..''''''........''''''''',;:::,               
               ........'........   ...........'',;,,''''....'''''..'''''''''''''''',,,,,,;;:::,               
               ................................',;;;,'''''''''''''....'''''',,,,,,,,,,,;;;::::,               
               ..........'...........      .....',,,,'..''..''''''......'',,,,,;;;;;;;;;;:::::,               
               .........''............   .....',,'''''.'''''''''''.....'',,,,,,;;;;;;;;;;:::::,               
               ........''....................';:;'''''''''''''''''''''.',,,,,;;;;;;;;:::::::::,               
               ........''......',;;:::::;;;:::ccl:,''''''''''''''''''''',;;;;;;;;:;;;;;:::::::,               
               ...............';:cccccccccccc::loo:,,''''''''''''''''''',,;;;;;;;;;;;;;::::ccc,               
               ...............,;:::cccccccc::::ccdo:,''''''''''''''''''',;;;;;;;;;;;;;;::::ccc,               
               .'....'''......,;:::ccccccc:::::ccooc;,'''''''''''''''''',;;;;;;;;;;;;;;;;:cccc;               
               .'.............,;;;;;;::::::;;;,;:loc:''''''''''''''''''',;;;;;;;;;;;;;;;;::ccc,               
               .'........'''..;;;;;,,'';::;'...',:lc:,'''''''''''''...''',;;;;;;;;;;;;;;:::ccc,               
               .'''.......';,';:::;,,,;:::;,;;;,;:l::,'''''''''''''''''',,;;;;;;;;;;;;;;:ccccc,               
               .'''.......'::;:::cc:::c::::;;::::co,;,,,,''''''''''''''',,;;;;;;;;;;;;;:cccccc,               
               .''''''''''',cc:::ccc::::::::;;:::ll:,,'',''''''''''''''',,,;;;;;;;;;;;;:cccccc,               
               .'''.'''''''';c:::::;;::;;;;,',;;;lc;''''''''''''''''''''..';;;;;;;;;;;;:cccccc,               
               .''''''''''',,;;;;;,,::c:;,..';,';c;''''''''''',,,,'''',,'',,;;;;;;;;;;;:cccccc;               
               .'''''''''''',::;;;;;;;;::;;,..';::,,'',,,''',,,,,,,,,,,,,,,,;;;;;;;;;;;cclllll;               
               .''''''',,'';:l;;;;;::::::;;,,;;:c;,'',,,,,,,'''''',,,,,,,,,,,;;;,,,,,;;:llllll;               
               .''''''',,,;:l:.:;;;::::;;,,;::cc,;,,',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,:clllll;               
               .'''''',,;:c:oc.,:;;:::c::;;;:c:..';;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,;:cccccl;               
               .'''',;clolclol..;::;;:::::;:c;.  .,:;,,,,,,,,,,,,,,;;;;;,,;;;;;;;;;;;;;:clllll;               
               ..';clooool:loo'..,;::,'''',,..   .;ll::;;;,,,,,,,,,,,,,,,,,;::;;;;;;;;;:clllll;               
               ':looodoooolloo;. ..',;,'.....    .;llc::;c:;,,,,,,,,,,,,,,,;;;;;;;;;;;;:cllccl;               
               :ooooodoodoollc;    .......       .:lllcccoool:,,,,,,,,,,,,,;;;;;;;;;;;;:cllccc,               
               :ooooodooooool:'                  .clllcclooodol;,,,,,,,,,,,;;;;;;;;;;;;:cllccc,               
               .'''''''..............'''''',,,;;,;;;;,,,''''''''''''..........'''........'''''.               
               .'''''''......'.......'''''',,,,,,,,,,,,,'''''''''''''''''''''''''''''..'''''''.               
               .'''''''..............''''''',,,,,,,,,,,,''''''''''''''''''',,''''..''..'',''''.               
               .'''''''''''..........'''''''',,,,,,,,,,,'''''''''''''',,,,,,,''..'''''',,,,,,'.               
               ....''''''''''''''''''''''''''''''',,,,,,',,,,,,,,,,,''''''','...',',;;;;;,,,,'.               
               ...  .....'''''...''''''....''''''''''''''''''',,,,,,,,,,,,,,'...',',;;;;;;,,,'.               
                .','. .....'''............''''''''''''''.''''''',,,,,,,,,,,,,''',,,;:c::::;;;,'               
                  .'c;.. ................'''..........   ..''''''''''',,,,,,,,,,,'';cccc:::::,;               
                    .:l,.  ........''''''''........ .'.     ..'''''''''',,,,,,'....:ccccc::::;;               
                     .cl:.....'..''''''''........    .,;.    ..''''...'''',,'..    .,ccllcccc,'               
                ... ..'oo:.. ..'''''''''.........     .;:.    .'''''....''''..'.    .':cccccc,'               
               ........coo'........'''''........     . .::.   ..''''......',..,,.    .,:ccccc''               
               .''.....cdo;.............................;c,    .''''......',.':;'     .;::c::.'               
               ',,,,'''cdd:.....................'''...,,;c,.....''''''....,, ':;'     .,;;;;,..               
               ,::;;;;;ldd:....................''',',:c:cc,.....,,''''''..,,.,c;'     .',,,,,..               
               ,cc:::::ldd:.....................,,,::cc:cc,.....,,,,'''''''c.,:;'     ..'''''..               
               ;ccccc::odd:.....................,cdx:.'llo;.....,,,,,,,''','.,;;'     ...''''..               
               ;cccccccodo,....................'oxxxo.,oool,...',,;;,,;;,,,. .;,.     .....'...               
               ;llcccclddc... ................'oxxddc':ooodo;'.';;;;;;;;;;;. .,,.     ....''. .               
               ;llllccldd,... ................,odddl,..odolooo:,:::::::::::'..,;.     ....... .               
               ;llccccldd;... .................,cll;.  cxxc:clc::::::::::::,'';;...   .'..... .               
               ;ccccccldd;..  .................'col.   ,kkl'''',:::::::::::,'';;.......'...'. .               
               ;ccccccldd;..  .................'cl;    .dOx,''',:::;:::::;;'................. .               
               ;llllllodd;.. ..................'c;.     ;kx,..',::;;::::;,'....................               
               ;ccccccloo;..  .................':.   .. .xk:,''''''''''........................               
               ;c::::::::'.   .................,'   ..'..:k:...................................               
               ...................            .'.   ..,, .xc.........................'''''''''.               
               ..............            ......'   ..... .o,..........'''',,,,,,'''''..'''',,,.               
               ................  ................  .....  ,....................................               
                ................................. ......  .....................................               
               .............................'.....,..... .,''''''''''',,,'',,,,,,,,,,;;;;;;;;;'               
               ..............          ..........''.......'''''',,'',,,,,,,;:::ccccccc:::;;,,;'               
               ........''.....................................'''',,;;;;;;;;:::;::::::::::::;,'               
               ........''.......................................'''''',,,,;;;;;;;:::::::::::;;'               
                   ........                              ...............................''',;;'               
                    .......                              ........ ......      .................               
               ..............................................................''''''',,,,,''''..               
               ......................................................'''''''''''''''',,,''''''.               
               .................................................''''''''''',,,,,,,''''''''''''.               
               ...................................'''.....''''''''''',,,,,,,,,''''''''',,,,,,'.               
               ..................................''''''''''''''',,,,'''''',,'...',,,,;;;;;;,''.               
               ... ..............................''''''''''''',,,,,,,,,,,,,,....''';;;;;;;,,'..               
               .',..  ................................''..'''''',,,,;;;;,,''....'';:clc:;;;,'''               
                 .,:,.. ....................................'''''',,;;;;,,,'''''.':coolc:::;;od               
                   .:c,.  ............................     ..''''''',,,,,,,'''....;:lllcc:::;cl               
                    .co:.  ......................   .,,.    ..''''''''',,,,'..    .;:ccccccc,;,               
                     'lo;.. ....................     .;;.    .........'',,'..'.    .,::cccll;:,               
               .......coo'.....................       .::.   ..........''''..',.    .,;::cll;:;               
               .......:oo:.............................:c,    ...........';.':;'     .,;::cc;:;               
               ',,,''':ddc. ...........................;c;.. ............', 'c;'.    .,,;:::';,               
               ,:;;;;,cddc. ...................''''.,;:cc;...............,,.'c;'.    .'',,;,.,'               
               ,cc::::lddc.....................'',;:cc:cc;................;',c;'     ..'',,,.,.               
               ;cccc::lddc.....................':lo;':::c;...............';.,:;'     ....'''.,.               
               ;ccccccodo;....................,oxxxl.:ool'......'........'. ';,.     .....'..'.               
               ;ccccclodc.. .................'oxxxdc.:ddl......''''''''.... .,,.     .....'. '.               
               ;lllccldd;.. .................:ddddo:,.loc'.....'''''''''''. .,;.     ....... '.               
               ;llcccldd;.. .................,looo:.  'ooc,'..'',,,,'''''''.';;..   ..'..... '.               
               ;ccccccdd;..  .................,clo,   .cdl:,''',,''''''''',,';;.......,''''. ..               
               ;cccccldd;..  .................,lod'    .l;..''',,'''''''''............',,,'. ..               
               ;lllllldd;.. .................';ldo.     ';...'';,''''''''........ .........  ..               
               ;lccccloo;.. ..................:ld:...    ;,''..''..............................               
               ;cccccccc'.   ................'::l'..'..  .;....................................               
               ..................  ..    ... .:::..'''.  .;,...................................               
               ..''........                ...;:' .....  .,;........'''',,,,,,,'''''''''''',,,'               
               ............      .............',.  ....  ..'.............................'''''.               
                ................................  .....  ......................................               
               ...........................'''... ...... .'.'''..'.'.'''''''''''''''',,,;;,,,,'.               
               ............          .................. .''''',,,''''',,,',;::c::::::::;;;;;;;'               
               ................................................'''',;;;;;;:::::::::::::::;;;;;'               
               .......'''......................................',,,,,,,,,;;;;;;;:::::::::::;;;'               
                  .........                                   .............'...''..'''',,;;:::'               
                    .......                                     ....... .....................'.               
               ...................................................................''''''''.....               
               ...................................................................'''''''''....               
               ..''...............................................''''''''''''''''.....''''''..               
               .'''''.........................................'''''',,,,,,,,,,''......'''''''..               
               .'''''''''''...............................'''''''''''''',,,,'...''''''',,,'''..               
               .......'''''''''..........................''''''''',,,,,,,,,,....'.''',,,,'''...               
               .,'......',,,,''''.........................''''''''''',,,,,,'...'''',,;;,,,,'''.               
                 .::'.  ..''''''..'''.....................'.''''''''''''''''''''.';::cc::;;;;do               
                  .,c:.. ....''...'''.................    ...''''''''''''''''....';cloolccc:;do               
                    'll,.........................   .,.     ..''''''''''''''.    .':ooddooo:;:,               
                    .;ol'.......................     ';'.   ............''....     'clodddoc,:'               
               .......loc.. ...................      .,c,.   .............. .,.     'ccloolc,:,               
               .......ldo.............................'cc.   ............,, ,;,.    .,;:ccc:,:'               
               ',,''''ldd'............................,:c................;..;:;.     .,;:::;';'               
               ';;;;;;ldd'.....................'''.',;;cc'...............;..;:;.     .'',,,'.,.               
               ,c:::::odd'....................'',;;cc:;cc'...............':.::;.     ..''',..,.               
               ;ccc::codo'....................';cdc;:c:cc................;'.;;,.     ....''..,.               
               ;ccccccodl.....................:dxxd:,lcl:................'..,;'.     .....'..,.               
               ;cccccldo,.. .................,dddxd:,ool;.....''''''''..'.. .;'      ........''               
               ;lllclodo... .................lddddd;.cdo,.....''''''''''.....;'.     ...... .''               
               ;llcccodo... .................cdddoc:.;oo,.....'',,,,''''''..':'.    ....... .''               
               ;cccccodo... ................',looo;. .:l:'.''',,''''''''''',,;'.... ....''. .''               
               ;cccccodo.....................,lood'. ..;:,'''',,'''''''''....'........',,,'  ''               
               ;lllllodo......'''....''''....;lldd.   .';;...',,,''''''..........  ........  ..               
               ;lccccodo......'''......''....:cldl..  ..,:'''''''..............................               
               ;lccllllc..  ..'..............::lxc...  ..;;....................................               
               .'............................;::l,...   .,;'...................................               
               ...'''.'........          ....;;::.....  .',;.......'''',,,,,'''...''''''',,,,,.               
               ............  .   ............',;' ....  .................................'''''.               
                ...............................  .....  .......................................               
               ...........................''...  ..... .''..........''''.........'''',,,,,,'''.               
               ............      ............. .......  .,'''',,,'''''''',;;:::::::::;;;;;;;;;'               
               ...............................................'''',;;;;;;;:::::::::::::::;;;;;'               
               .......''......................................'',,,,,,,,;;;;;;;;:::::::::::;;;'               
                 .........                 ...               ............'''''''''',,,;;;;::::,               
                    ......                                      ....  ....................''','               
               ........................................................................'.......               
               ........................................................................''......               
               ........................................................................''......               
               ........................................................................''......               
               ...........................................................''.....''''''''......               
                . .....................................................'''''...',,,,,,,''......               
               .'.. .................................................''''''....''',;;;;,,''....               
                .;:,.. .............................................''''',''''''.,;;;;;;;;;,cxl               
                  'cc,...............................     .........''''',,,'''...',;;;;;;;;,lOd               
                   .cl;.  ......................   .,..    .......'''''''''.    ..,;;;;::::,;;'               
                    'ol,.......................     .;,.    ......''''''''...     .;:::ccc:','.               
               ......col......................       .:;.   ......'''''''...''.    'ccccc::.;,.               
               ......:do,.. ..........................:c,.  ........'''.';..:;'    .;cccc::.;,.               
               .,'''':dd;............................':c;. . ...........', .c;,.    'cccc:;.,,.               
               ';;;,;cdd;.  ..................'''.',:;cl;...............,;.'c;,.    ';;:::,.,'.               
               ,:::::cdd;. ...................',cccc:;cc;................,',:;,    .';;;;,'.,..               
               ;ccc::lxd;.....................:oxo;:c;cc;...............':.,:;'     .,,,,,'',..               
               ;cccccldo,....................,dxxxl:o:lc,...............'. ';,.     .'',,,..''.               
               ;cccclodc.....................cxdddo;dll:.................. .;,.     .',;;,. .,.               
               ;llccldd,..  .....''''''''...'oddddl'ool:......'''''''''... .;,.     ',,;;,. .,.               
               ;lcccldd,..  ....''''''''''..'oddddl'coo:.....''',,'''''''...;;.    .',,,;,..','               
               ;ccccldd;.. ....''''''''''''';oollo:',ll:....'',,,,'''''''',,;;......',;:::. ','               
               ;ccccldd;.......''''''''''''':ooood;..,l:..'''',,'''''''''...''......',;:::. .;'               
               ;llllodd,.......'''''''''''',clllox'. .:c,...',;,''','''.........  ....'''.  .'.               
               ;lcccldo,.. ...''''''''''''',:cccod.   .;c;'..','...............................               
               ;lclllll'.   ....'''''''''',,::::od..   .;:'....................................               
               .'''..........''.............:::cdl...  .','....................................               
               ....'''''.......       ......;;;ldc...  .'''........'''''''''''.....''''''',,,,.               
               ............  ..  ...........',;lo,...  ................................'''''''.               
                .............................. .....  ................... .....................               
                ..........................'... .....  .'............'''...........''''','''....               
               ............................... ........',''''',,''''''''',;;:::::::;;;;;;;;;;;'               
               ...............................................''.',;;;;;;;::::::::::::::;,,,,;'               
               ......''......................................'''',,,,,,;;;;;;;;::::::::::;;,,;'               
                ..........               .........       ..............''',,,,,',,,;;;;;;::::;'               
                   .......                                       ..   ...................';;;:,               
                ...............................................................................               
                ...............................................................................               
                ...............................................................................               
                ..........................................................''.........''........               
                .........................................................''..',;,,,,,,'.......                
                .  ......................................................'....,;,;;,,''.......                
               .'. ..................................................'''''....,,',;;;,'........               
                .:;'................................................'''''''''''.',;;;;,,,,',lkl               
                 .,c:. .............................     ..........''''''''''''.',,;;;;,,,',dOo               
                   'll'.. .....................    .,.     .......'''''''''.. . .';;;;;,,,,,,,.               
                   .;ol'......................      .;'.    ....''''''''''...     ';;;;;,,.....               
                .....loc......................       ,:,.   ....'''''''''. .'.    .';;;,,,..'..               
               ......ldo..  ..........................:c'   ....'''''',,,;.,;,.    .,,,,,,..'..               
               .,''''ldd..  .......................,,,cc'.  ......'''''';..;:,.    .',,,,,.''..               
               ';;;,,ldo'.. ..................''',::;;cc,.........'''''';'.;:;.    .',,,,'.''..               
               ,:::::odo'.....................,coccc;;cc,............''',;.;:,.    .''''''.,'..               
               ;cc:::oxd'....................;oxxl;o:;cc'.............'';;.;;,.    .''''''.,...               
               ;cccccodo.....................lxdxxcoo:l:................'..,;,.    .''''''.....               
               ;ccccldo;....................;dxddd:coll;...............'.. .;.     .,,,,,' .''.               
               ;lcclodo..  .................;ddddd::dol;.....''''''''''''. .;'     .;;;,,' .,'.               
               ;lcccodo'.  .................:ooddo:cool;.....''',,'''''','.';'.    .::;,,' .,,.               
               ;ccccldo..  ................'cooolo,';ll,...''',',,'''',,;,,,:,.... .::;;;' .;,.               
               ;ccccodo... ................'cooood,..:l,..''',,''''''',,,'.''.......;::::' .;,.               
               ;llllodo........''..........'clllox'  .c:....',;,''','',,,''''''....''''... .;'.               
               ;lcccodo........''''''...'..,ccccox'   .::'..'','...............................               
               ;ccclllc..   ....'''''..'''';::::od,.   ,o;.....................................               
               .'............''............;::::od,..  ',......................................               
               ..'''''.........       .....';;;:oo'.. ............''''',,,''''...'''''''',,,,,.               
               ..........        ..............':;... .................................'''''''.               
                ..............................  ..... ........................................                
                ..........................'''. ...... .''...........'''..........'''''',,''''..               
               ................................'........'''''',,''''',''';;::::::::;;;;;;;;;;;'               
               .............................................'.''',;;;;;;;::::::::::::::;;,,,,,.               
               ......''......................................'''',,,,,,;;;;;;;;::::::::::;,,,;'               
                .........                .........        ..............'''''''',,,,,;;;;:::::'               
                   ......                     ..                 .  ........... .........',;;;'               
                ...............................................................................               
                ...............................................................................               
                ..............................................''''''''.........................               
               ..............................................'''''''''.........................               
               ...............................................''',''''........................                
                  ...........................................''''''''''.......'...............                
               .'.. .........................................'''''''''''''....''.''''..........               
                .:;,........................................'''''''''''''',,,,,'',,,''.....;xOo               
                 .,c:................................    ...'''''',,,,,,,,,,''..',,,''.....;dkl               
                  .,ll'.. .....................    .,.     .'''',,,,,,,,,,,.    ..,,,''.''',,'.               
                   .:ol........................     .;'.   ..',,,,,,,,,,,'...     .'''''''.....               
                ....'oo:......................  .  ..,:'.   .',,,,,,,,,,,. .,.     .'''....''..               
               .....'odl. ........................,'.':c.   .',,,,,,,,,,;'.;;,.    .''''''.....               
               .,''',odo.  ................''...,:c;',cc... .',,,,,,'',,;..::,.    ....''......               
               ';;;;;odo....................'';lccc:,;cc.....''''''''''';..:;,.    ............               
               ,:::::odo....................':dkd::o:;cc......'''''''''',;.c;,.    ........'...               
               ;ccc:cddo....................;dxxxd:dl:cc..........''..'';'.:;,.    ........'...               
               ;ccccldoc........''........',oxxdxd'odll;........''''..'''..;;'.    ........'...               
               ;ccccodo'.....'''''''''''''';dddddo.cool'......''''''''','..';.     .'''''. .'..               
               ;lclcodl..  ..'''',,,,,,,,'';oddddl;clol'.....',,,,,,,,,,'...;.     .,,'''. ''..               
               ;lcccodl..  ..'',,,,;;;;;,,,,clllo; .:ol'....',,,,,,,,,,,,'.,;.     .,,'''. ','.               
               ;ccccodl..  .',,,,;;;;::;;;,;odddol. ,ll'..''',,,,,;;;;::;,,,;'......,''''. ','.               
               ;ccccodl..  .',;;;::::::::;;cdooodo. .ll,..'',;;;;;;;:ccc:'..'.......'',,,. ','.               
               ;llllodl.....,;;;:::::::::;:loollox. .cl'....,::::cllllcc;,,,''..............,'.               
               ;lcccodc.. ..,;;;::::::;::::lllcclx, .,o:,,,,,::::;::;;,,'''..........''........               
               ;cccccc;.   .,;;;;:::;;,;;;cccc::lx;  .c;''.....................................               
               .............,,''..'........:::::cxc.  .........................................               
               .''''''.......................'',:o:.  ............'''',,,,,,'''..''...''',,,,,.               
               ............................... .....  ..................................''''''.               
                .............................. ...... .........................................               
               ...........................'''. ......  .'.....''...'''''''''''''''',,,,,,'''''.               
               ..........................................'''''''''''','',;:::::::::;;;;;,;;;;;'               
               .....'''.....................................''''',;;;;;;;::::::::::::::;;,,;;;'               
               .....'''.....................................'',,',,,,,;;;;;;;;;::::::::::;;,,;'               
                .........                ..........         .............'''''''''',,,,;;:::::'               
                   .....                      ...             ..      .........   ........',;;.               
               ..''''''''''................................'''''''.............................               
               ..''''''''''''...............................''''''.............................               
               .'''''''''''''''...............................'''''''..........................               
               .'''''''''''''''''''''.............................''''.........................               
               .'''''''''''''''''''''...........''''..........................................                
                . ....'''''''''''''.............''''''''''.......'''''........................                
               .,.......'''''''''....'''''''''.''''''''''''''''''''',,,'''....''.'''...........               
                .:;,.......'''''''''''''''''''''..........'''''''',,,,,;;;,,,,'.',''.......:xOo               
                 .,c:........''''''',''''''''''......    ...'',,,,,,,,,;;;,,'...'','.......:dkc               
                  .,ol'........''''''''''',,,'.    .,.     .',,,,,,,,,,,,;,.    ..,''....'',,'.               
                   .col.....'.'''''''''',,,,,..     ';'    ..',,,,,,,,,,,'...     .......'.....               
                ....,oo;....''''''''''',,,,,,. .... .;:'.   .',,,,,',,,,,. .,.     ......'.''..               
               .....,ooc.....'''''''''',,,,,,...,;,..,c:.   .',,,,,',,,,;..:;,.    ..'''''.'...               
               .,''',odl.....'''''''',,,,,,;;'';llc,';cc... .',,,,,,,,,,;..:;,.    ....''......               
               ';;;;;odl.....'''''''',,,,,,,,,:llc:;,:cc.....',,,,,,,,,,:..c;,.    ........'...               
               ,::::cddl.....'''''''',,,,,,,;cxko,:dc:cc.....,,,,,,,,',,;;.c;,.    ........'...               
               ;ccc:cddl....''''''''',,,,,;;lkkxxl;xdllc.....,;;;;,,''',:..:;,.    ........,...               
               ;cccclod:....''''',,,,,,,,,;cxxxxxl.odoo;.....;;;;;;;;;,,' .;;.     ........'...               
               ;ccccddo.....',,,,,,,,,;;;;;lddddxl;:ddl'....';::cccc:::;,..';.     .,''''. '...               
               ;lcccddc..  .,,,,,;;;;;;;;;;codddd;..lol''...':ccllccccc:;..';.     .;,'''. ''..               
               ;lcccodc..  .,;;;;;;;;::::::::cllo' .col''''''cllllllccc::..,;.    ..;,'''. ','.               
               ;ccccodl..  .;;;::::::::::::codddx:. :ol'.''',llccccccccc:',;;......';;,''. ','.               
               ;ccccodl..  .;::::::::::::::ldooodo..,dl'.''';llcccccccc:;..''.......;;;,,. ','.               
               ;llllddc....':::::::::::ccclooolldx..;x;.....;ollccccc::;,...................''.               
               ;lcccddc.. ..;::::cc:::cccllolccllk;.,xl;;;:::cc:;;;,,'''''.....................               
               ;cccccc;.   .;:::cccc::::ccllcc::lkc .cc,'''.''.................................               
               ............';;,'..'..',,,,,;::;;cxl  ..........................................               
               .,,,,,,''.......................',c;. .''..........'',,,,,,,,,'..'....'''',,,,,.               
               ............................... ..... ...................................''''''.               
                .............................. .....  .........................................               
               .........................'''''. ......  ..'..''''...,,,'''''''''''',,,,,,,,''''.               
               ............................... ..........'''''''''''','',;:::::::::;;;;;,;;;;;.               
               .....'''.....................................''''',;;;;;;;::::::::::::::;;,,,;;'               
               .....''......................................'',,',,,,,,;;;;;;;;::::::::::;;,,;'               
                .........                .................  .............''''''.''',,,,;;:::::'               
                   .....                        ....          ..      .........  .........',,;.               
               ......'''...............'''',,,,,,,,,,,,,''''''''''.............................               
               ......''''''............''''',,,,,,,,,,,,'''''''''''............................               
               ..''''...'''''..........'''''',,,,,,,,,,,,,''''''''''''...............''''......               
               .'''''.................''''''',,,;;;;;;,,,,,,,'''''''''''''''.........''''......               
               .'''''''..................'''',,,;;;;;;;;;;;;,,,,,,'''',,,,'...'''''''.........                
                . ....''...................'''',,,;;;;;;;;;;,,,,,,,',,,,,,....,'.''''.........                
               .,. .......................''''''',,,,,,,;;,,,,'''''',,,,;;,..','',,,,'.......'.               
                .:;,....................'''''''''.......'''''''''''''',,;;;,,''.,,;;;,'....:xOd               
                 .,c:. ..........'.''''''''''''......    ...'''''''''',,,;;,'...',;;;,'..'':dkl               
                  .,ol'........'''''''''''''''.    .,.     .'''''''''',,;;,.    .';;;;,'''',,..               
                   .col.....'.'''''''''',,,,,..     ';'    ..''''''''',,,'...     ',,,,'''.....               
                ....,oo;....''''''''''',,,,,,.   ....;:'.   .'''''..'',,,. ''.     .''''...''..               
               .....,odc....''''''''''',,,,,'...,;...,c:.   .'''......'';'.:;,.    ..''''..'...               
               .,''',odl....''''''''',,,,,,,'.'cll;'';cc..  ..''........;..:;,.    ............               
               ';;;;;odl....''''''''',,,,,,,,,,cll:;,:cc...............';..c;,.    ............               
               ,::::cddl....''',,'''',,,,,,,,;dd;'cdlccc..............'',:.c;,.    ........'...               
               ;ccc:cddl....',,,,,,,,,,,,,,,:xkkd,:xxolc...............';..:;,.    ....''..''..               
               ;cccclod:....',,,,,;,,,,,,;;cxxxxk:'dxdo;......''''''..... .;,.     .''',,,.','.               
               ;cclcodo..  .,;;;;;;;;;;;;;;dxxdxd:.:ddo'.....'''''''''''. .,,.     .,',;;' ,;,.               
               ;ccccddc..  .,;;;;;;;;;;;;;;odddxo::;lol'....',,,,,,,,,,,'..';.     .;,,,,'.','.               
               ;ccccodc..  .,;;;;;;;;;::::::clool'..lll'.''.';;;;;;;;,;;,'.,;.    ..;,,',. ','.               
               ;ccccodl..  .,;;;;;;;;;;:::::coooo:..col'.'''';;;;;;;;;;;;,,,;.......;,,;;. ','.               
               ;ccccodl..  .,;;;;;;;;;;;;:::odddxo. ,ol'.''',::;;;;;;;;;;...'......';;;::. ','.               
               ;llllddc..  .,;;;;;;;;;;;;::looloxx. 'lc....',:c:;;::;;;,,',,'...............''.               
               ;ccccodc... .;;;;;;;;;;;;;;:lllclxk,.'cc;;,,,,;,,,,,,''...............''......'.               
               ;cccccc;.   .',,,,,,,,,',,,:ccc:ldk: .',,''.....................................               
               .............''.............':::cdkc  ..........................................               
               .'''''''.......   ............,,:od:  .,'..........''',,,,,,,,'''''...'''',,,,,.               
               ............................... ..... ....................................'''''.               
                .............................. .....  .........................................               
               .........................'''''. ...... ..''..''..''',,,'''''''''',,,,,,,,,,,'''.               
               ......'........................ ....... ..''''''''''',,'',;::::cc:::;;;;;;;;;;;'               
               .....'''.....................................''''',;;;;;;;:::::::::::::::;;;;;;'               
               .....''......................................'',,,,,,,,;;;;;;;;;::::::::::;;;;;'               
                .........              ...................  ................'''..'''',,,;;::::'               
                  ......         ..      .............        ......  ........    ........',,,.               
               .'',,,,,,,,,,,,,'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''.               
               .'',,,,,,,,,,,,,,''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''.               
               .,,,,,;;;;,,,,,,,,,,''''''''''...'''''''''''''''''''''''''''',,,,,''',,,,,,,'''.               
               .,,,,,,,;;,,;;;;,,,,,,,,''''''''''''''''''''''''''',,,,,,,,,,,,,,,,,,,,,,,,,;,,.               
               .,,,,;;;;;;;;;;;,,,,,,,,,,,,'''''''''''',,,,,,,,,,,,,,,,,,;;;;,,;;;;;;,,;;;;;;;'               
               .,,;;;;;;;;;;;;;;;;;;;;;,,,,,,,'''''',,,,,,,,,,,,,,;;;;;;;;;;;;;;;;;;;;;;;:::::,               
               ';;;;;;;;:::::::::;;;;;;;;;;;;;,;;;;,,,,,,,,,;;,,,,;;;;;:::::;;;;;;;;;::ccccccc;               
               ';;;;;;;;;;:::::::::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::::::::::::::::cccllooood:               
               ';;;;;;;;;;;;;;;::::::::::;;;;;::::::::::::;:::::::::::ccccccclcccccllllooddddxl               
               ';;;;;;;;;;;;;;;,;;;;::::;;;;;;:::::::::::::::::::::ccccccllllllooooooddddxxxxxl               
               ';;,,,,,;::::'........',;;;:;;;;;;;;;::::::::::cc::ccccccccllllloooddxxxxxxxxxxl               
               ',,,,,;:cc;..........'',.,;;;;;;;;;;;:;;;::::::cccc::;,'....';coooddxxkkkxxxxxxl               
               ';,,,;cl:.......'''',;,'...,;;;;;:;::::::::::::cccc,.  ........':oodxxxxxxxxdddc               
               ';,';cl;..........',;coc,,,.,;;;::::::::::::::::::'.     .,,.....;odddxxxxdddddc               
               .,,,cl:..........;lclloooll;.;;::::::::::::::::::;.       .':,...'coddxxxxdddddc               
               .',;cl;,,,'''''.,oolclclddol',;;;;::::::::::::;;;'.        .;c'..',llooddddddddc               
               .',:clccccc:::;;,c:,;llcoddo;';;;;;;;;:::;;;;;;;;...........,l:''''clloooooddddc               
               .',:cloooooollllcclllclooddo;,::;;;;;;;;;;;;;;;;;'..........,lc,''':cllloooodddc               
               .,,:clddddddddoooolllc:coodl..cxoc:ccc:;;;;;;;;,,'''''''',,,;lc,'',:cccclllooodc               
               .,;cclddddddddoooooolc::clc.  .oxoccdxxdoc;;;;;;;,,,,,,,,,,,;lc,',,:cccclllloooc               
               ';;cllooddoooolllllllc,,'..   .cxxdodxxxddl:;;;,,,,,,,,,,,,,:lc,',,:cccclllloooc               
               .,;:lclolllllllllllooo,       .cddoooodooool:;;;;;;,,,,,,,,;cl,'',,:ccclllllooo:               
               .',;cl:ccccccccccloddo,       .cddolool:coolol:;:;;;;;;;;;;;cl,'',,:ccllllooooo:               
               .'';cl;ccc::::::cddoooc.      .cooodol:;;llllool::::::::::::ll,''',:cllllloooooc               
               ..',cl;;::::;;::odolooo:;,.    :ollddl:,,lllloooolccccccccccll''''';cccclllooooc               
               ..',cl,;:::::cclddocollccc.    ;oooodl:;,;lclolllooc::::::::cl'..'';cc:::clloooc               
               ..',cl;cccccllloddoclclcc;     .;olloo::;;cclolllllool:;,,,''......;cc:::clllll;               
               .'',cl:ccccccccooolcccooc.       ,:cldc:::ccloooollllldl;'.........,:;;;,;,,'''.               
               .,,;cl:ccccc:::lollccclo;         .:lddl:c:::cooollllldolc:,'''''...........'''.               
               .,,;cc,.'''..':ooolcccll.          .:ldo::,.'.',coolllcccclc;...................               
               .,,,:;'.....';ooooolllll'           .coolcc,......;lolccccccl:..................               
               .,,,,,'''''',lddodocloll;      .  .  .colccc........':llllc:;;;,................               
               ............'oddddo:ldooc.     .      .coooo:..........';c:;,'.':,..............               
                     ......'oxxxdoooxooo.             'ldddo,............',,'..,;'.............               
                    ........:ddddkxoxdod'..            'oxkxo'..............'...'....''''''''..               
                   .........,llokOxoxddd'....... .      ;xkkx;.......................'''''''''.               
               .',,,,;;;;;;;;;;;;,,,,;;;;;;;;;:::;;;;;;;;;;;;;;,;;;;;;;,;;;;;;;;;;;;;;;;;;;;;,'               
               .',,;;;;;;;;;;;;;;,,,,;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'               
               .,,,;,;;;;;;;;;;;;;;;;;;,,,,;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::::::::;;:,               
               .',,,,,;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::::;;;;;;;;;;:::::;;::;;;;:::::::::::;               
               .,,,,,;;;;;;;;;;;;,,,,;;;;;:;;;;;;;;;;;:::::::::::::::::::::::::::::cccccclllll;               
               .,,,,;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:::::::::::::::::::::::cccccclloolll:               
               .,,,,;;;;,,;;;;;;;;;;;;;;;;;;;;;;;;;;;:::::::::::::::::::cccccccccccllloooooooo:               
               .,,,,,,,,,,,,,;;;;;;;;;;;;;;;;;;;;;;;::::::::::::::::::::ccccccccccllloooooodddc               
               .,,,,,,,,,,,,,;;;;;;;;;;;;;;;;;;;;:::;;::;;::::::ccccllllccccllccclloooollllool;               
               .,,,,,,,,,,,;,''..'',;;;;;;;;;;;;;;;;;;;;;;:::::::ccccclllllllllcclllloollllool;               
               .'''''',;::,'..........,;;;;;;;;;;;;;;;::::::::::::::cccccclllllcllllllllllllll;               
               .'''',;c:'...........'..',,;;;;;;;;;;;;;;::::::::::;,.......,:cccllllllllllllll;               
               .,,,;cl;..............''','',;;;;;;::::::::::::::;'. .........';cllllloolllllll;               
               .,,;cl;...............',:cc,.,;;;;;::::;;;;;;:::;.      .,;.....;ccllllllllllll,               
               .,,cl:'..............:olllloc;;;;;;;;;;;;;;;;;;;,.       .':,...';clllllllllll:.               
               .,;cl::;;,,,,,''..'';llclccoooc:;;;;;;;;;;;;;;;,'......  ..;c'..',:cllllllllll:                
               .,;cllllllcccc::;;,,,:::llllodl;;;;;;;;;;;;;;;;;...........,l;'''':cccllllloooc                
               .,;cloddddoooolllccc::llccclodl;;;;;;;;;;;;;;,,;'......'''';l:'''':cccllllooooc                
               .,;cloddddddddoooollllllccccodl.'co:;;:;;;;,,,,,''''''',,,,;l:''',::cccclllllll,               
               .;:cloddddddoooooooooollcccclc.  ;xocoddol:;;;,,,,,,,,,,,,,;l:''',:cccllllooool.               
               ';:llloooooooollllllllllc;;,..   ,dxoodoooooc;,,,,,,,,,,,,,:l;''',:cccllllooooo'               
               .,;ccclllllcccllllllllllo:.      .odoclooloooc;;;;;;;;,,,;;ll,'',,:cllllooooooo'               
               .',:l:cccccccccccc::ccooo:.      .ooc;:cc:llllolc:;;;;;;;;;ll''',,:lllooooddddo,               
               .'':l:::::::::::::::cloodl,.     .llc;::::clclllllccc:::::cll'''',:lllooooddddo;               
               ..':l;;;;;;;;;;;::::cdolol:;;.   .:clc:c:;:ccll:clodlcc:::clc'.'',;cclllllooool,               
               ..':l:::::ccccccllllodoclccc:.   .;cll::c;;:lllclllddlc::;;::....':cc::cllllllc,               
               .'':c:ccccccccccccccoooccclc;     .:clc:::;;clllllllllll;'........;c::::cc::;;;.               
               .,':lc:ccccccccccccclolcccc:.      .:ccc::::cclooollllclxl;,'''''',,''''''..''..               
               .,,clc,;;;;;,,,,,,;:lllcccl,        .:cc:::col;;:lolllccc:cc:;............'''''.               
               .,,::;'...........;loolcccl.         .:cccccod,...'coolc::ccccc:................               
               .,,,,'......''''',loooollll'          .collloxl'....'cllccccccoxl...............               
               .'''''...........;lodddlclol.     .  ...coddodol.......;llllc::;;;,,'...........               
                .      .........,oddxxdloodc.    .     .coxoldd'........,:c:,,,,';cl,..........               
                   ..............:lodkkdddxd'           .:odoox;..........';:;,,.';ll''''''....               
                   ..............;coxOOkxxko..           .ldxdxo'.............';'..,;,''''',,'.               
                  ...............,coxOOOxxx; ..           ,xkkkk;..............,'...'''''',,,'.               
               .',;,,,,,,,,,,,,,,,,,,,,,,,,,,,,;;;;;;;;,,,,,;;;;;;;:::::::ccccccccccccc:::::::,               
               .,,;;,,,,,,,,,,,,,,,,,,,,,,,,,,,;;;;;;;;;;;;;;;;;;;::::::::ccccccccccccccc:::::,               
               .,,,,,,;;,,,;;,,,,,,,,,,,,,,,,;;;;;;;;;;;;;;;;;::::::::cccccccccc::cccccccccccc;               
               .',,,,;;;;;;;;;;,,;;;;;;;;;;;;;;;;;;;;;::::::::::::::ccccccc:ccc:::cccccclccccc;               
               .,,;;;;;;;;;;;;;;,,,,,,,;;;;;;;;;;;;;::::::::::::ccccccccccc:cccccccccccccclllc;               
               .,;;;:::::;;;;;;;;;;;,;;;;;;;;:::::::::::::cccc::cccccccccc::::ccccccccccllllll;               
               .;;:::::::::::;;;;;;;;;;;;;::::::::::c:ccccccccccccccccccccccccccccllllllllllll;               
               .;;:::;;::::;;;;;;;;;;;;;;;::::::::::::cccccccccccccccccccccccccccccllllllllool;               
               .;;;;;;;;;;;;;;;;;;;;;;;;:;;;;:::::::::::::::::::cccccccccclllccccccccccccccll;.               
               .,;;;;;;;:;;,,'....',,;;;;;;;;;:;;;:;;;;;;;::::::ccccccccccclcccccccccccccllll:.               
               ';,,;,;:c:,............';;;;;;;;;;;;;;;;;;;:::::::;:::::::ccccccccccccccccllllc,               
               ';,,;:cc'............'...',,;;;;;;:::;;;;;;;;;;;;;,'.......';::ccccccclllllllll;               
               ',,;cl;................'..'',,,;;;;;::;;;;;;;;;,,..  .........;cccccllllllllllc'               
               .,;:l;...................',:c;'';;;;;;;;;;;;;;;,.       ';'....,:cccccllllllll;.               
               .,:lc,'.................;lllllo:;;;;;;;,;;;;;,,'.       .':,...';ccccclllllll,..               
               .,:lc::;;;;;,,''.......,olcl:cool:;;;;,,,,,,,,,....      .:c'...,::cccllllool,..               
               .,:cloolllcccc::;;;;,,,,c::clcldo:,;,,,,,,,,,,,...........;c;''',::cccllllooo'.;               
               .,:cldddddoooolllccccc:::clccclodc,;:;,,,,,,,,,'.....''''':l;''',::cccllllloo'.:               
               .,:cldddddddddooollllllllllc::cod,.,do::c:;,,,,'''''',,,,,:l;''',:::cccclllllc':               
               ';ccldddddoooooooooolllllllc::;;.  'odlodddl:;,,,,,,,,,,,,;l;''',:::cccclllll;.,               
               ';cccooooooolllllllllllllloo;..    .ldoloooool;,,,,,,,,,,,cl,''',::ccccclllll:..               
               .':c::llcccccccccccclllllldo'      .ll::lollool:;;;;;;,;;;lc'''',:cccccclllllc..               
               .';cc:cccc::::cccccccccccodo;.     'lc;;cccclllllc::;;;;;;lc'''',:ccccllllllol,.               
               .';c:;::::::::::::::ccccoddoc;.    ,::c:ccccllccloocc:::::lc'''',:cccccclllool:.               
               ..;c:,;;;;::::::::::::ccoololl:.   ':ll:;c:cllccloxoc:::::lc...'':::::ccccllll;.               
               ..;cc:cccccccclllllllllodollll,    .cllc;c:;cclllodxdc:;;,;,....':::::ccccccc:;.               
               .';cc:cccccccccccccccccloolcl:.     'clc:::;:clllllloo:..........;;;;;;;,,'',,'.               
               .,:lc:cccccccccccccccccllllcl;       ,ccc::::lloollllod:'...'''.................               
               .,:cc,,,,,,,''''''''',cllllcl:.      .;cc::ccoo:llllllocc:'.....................               
               .,;:;'..............';looolclo.       .clc::cdxo';cllcccclo:....................               
               .,,,''.'''''''''''..':lodddlodc.      .'llc:ldkxc..clc:cllldo,..................               
               ......................:oxkkddxd;        'ccc:oxdx'..;cllcclxkk;.................               
                      ...............;lxkOkxxx:         ,c::cdkOc...;lccclloo:;'...............               
                   ..................'cdkOOkxd'         .;clodkOx,...':::,,',;cl:,''''''''''''.               
                  ....................;lxkOOx;           .ldxdxOOc.....',,,,,',odd;'''''',,,,,'               
                  ....................;cdxOkx,       .    ;xxdxOOd........',,.'cdd;'''''',,,,,'               
               ..'''''''',,,,,,,,'',,,;,,,;;;;;;;;;;;;;;;;;;;::::::::::::::::::::::::::ccccccc;               
               .''''''''',,,,,,,,,,,,,,,,,,;;;;;;;;;;;;;;;;;;;::::::::::::::::::::::::cccccccc;               
               .''''''''',,,,,,,,,,,,,,,,,,,;;;;;;;;;;;;;;;;;;:::::::::::::::::::cccccc::ccccc;               
               ..'''''''',,,,,,,,,,;;;;,,,,;;;;;;;;;;;:::::::::::::::::::::::::::::::cc::ccccc,               
               ...''''''',,,,,,,,,,,,,,,,,,;;;;;;;;:::::::::::::::ccccc:::::::::::::cccccccllc;               
               .....''''''''',,,,,,,,,,,,,,,,,;;;;:;;;;;::cc:::::::::::::::::::::ccccccccccool:               
               ......'''''''',,,,,,,,,,,,,,,,,;;;;;;::::::cccc:::::::ccccccccccccccccllllllool;               
               ............'''''''''',,,,,,,,,,,,;;;;;;;;::::::::c::ccccccccccccllllloooooolc:'               
               ..................'''''''''',,,,,,,,,,;;;;;;:::::ccccccccccccccclllloooolll:';c:               
               .....................'''''''''',,,,,,,,,,;;;;::::::ccccccclccccclllloooooooc,'c:               
               ......''......................'''''''',,,;;;;;;;;;;:;;;;cllccccccllllloooooolll:               
               ...,,,..............''..........'''''',,,,,;;;;,,........';:ccccllllllooooooool;               
               ..,;,.................;'.......',,''''',,,,,,,,..  ...'.....;ccccclllllllllc;,..               
               .';,...................;,....',:llc;''''''''''.       ';'....;ccccccllllllc,....               
               .,;,''''................:,..,llcccloc,''''''''.        .c;...';cccccccllll,..,'.               
               .,;ccc::::;;,,,,''......;c..,:;cl:ldl''''''''......  ...;c'..';::cccccccll;.,;;.               
               .,:ooooollllcc:::;;;;,,,;l..':ccccclo,,:,''''...........;c;''',::cccccccll,.cc:'               
               .,:ddddddooooolllcccc:::co...',:::cl:..od:::;''..''''''';l;''',::cccccccll;'ccc,               
               .;:dddddddddoooollllllccll'...'::;,.  .oxloddo:'''',,,,,;l;''';:::ccccccllc,:::,               
               ';:oddoooooolloooooolllllo'..';oc.    'lc:lolooc,,,,,,,,:l;''',;::ccccllll;.;::'               
               '::lllolllllllllllllllllo:''':odc..   ;c;;llcooo:,,,,,,;ll,'',,;:::cccllll:.'::'               
               .;c:cccccccccccccclllllll'.';oooccc. .;;cclccllooc;;;;;;lc''',,;::ccccllll:..;c'               
               .;c;c:c:::::::::ccccccccl'.;lolllll. .:clcc:clllodc:::::lc''',,;::ccccccllc,,:c'               
               .;c;;;::::::::::::::ccccl'.;oollll:.  ;lll:cccloddoc:::clc.''',;:::::cccccc,,::'               
               .;c;;;;:::::::::ccccccccl,':olllll.   .:ll:c:loooddc::::lc...',;;;;;::::cc:'',,.               
               .:c:ccccccccccllcccccccco,:llllllc.    .ccccclllloxc,,''......';;;;;::::;;,',,'.               
               .:l:ccccccccccccccccccccl:lllllclc.     ,cc:cllllldc..........''''..............               
               ':l::ccc::::::::::::::::;;cllllclc.     'cc:cclccldo............................               
               ':c;'.....................'cllllcc'. ..';:cccollldxd.  .........................               
               .,,'............''''''.....'ccccclc,',;,..cccddodxkk,...........................               
               .,''''''..'............... .,:cc::;,;:;'..':;llloxkkc...........................               
               .............................;ccc;,,,;;;. .;;:c:oxkOk,..........................               
                   .........................,:oo;:;,,;.   ,;::;cdxkd,...........'''''''''''....               
                  ..........................;:lll;....    .;:loodxkx'...........''''',,,,,,,,,.               
                 ...........................;cllo'...      ,:okkxxkkc.............'',,,,,,,,,,'               
                 ...........................;lddo'...      .:oxxkkkkd'.............',,,,,,,,,,'               
               .,,,,,,,;,,,,,,,,,,,;;;;;;;;;;;;;;;;;;;;;;;;::::::::ccccccccccccccccccccllccccc;               
               .,,,,,,,;,,,,,,,,,,,,,,,,,,,,,,;;;;;;;;;;;;;;:::::::::ccccccccccccccccccccccccc;               
               .'',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,;;;;;;;;;;;;:::::::::::ccc:cccccccccccccccccc;               
               .'',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,;;;;;;;;;;;::::::::::cccccccccccccccllccccc;               
               .''',,,,,,,,,,,,,,,,,,''''''',,,,,,,,;;;;;;;;::::::::::cccccccccccccllllllllccc,               
               .''''''',,,,,,,,,,,,,,,,,,,''''''',,,,,,;;;;;::::::::ccc:::::::cccccccllclllool:               
               .'''''''''''',,,,,,,'',,,,'''''''',,,,,,,;;;;;;::::::ccccccccccccccllllllooollc,               
               ..''....'''''''''''''''''''''''''',,,,,,,,,;;;;;;:::::::ccccccccccllooooool:;::'               
               ..................'''''''''''''''''''',,,,,,,;;;;;;:::::cccccccccllllllooc,;:::,               
               ......''.............'''''''''''''''''''',,,,,,;;;;::::::ccccccccllllloodl,'clc,               
               .....''..................'''......'''''''',,,,,,,,,,,,;:ccccclllclllllooooooxoc:               
               ..','..............',............',,''''''',,,,'.... ...';:cclllllllooooddddxlc:               
               .',..................;,.........;:clc;''''''''.   ..''....':cccllllloooool:,,',;               
               .,'...................,;......,llcc:ll:''''''.      .,;'...':cccllllooool,......               
               .,,,,,''''.............:,.....':::lclo:'''''...      .,:'...,:ccllllllol;..,'...               
               .;clcccc::;;;,,,''''...,:.....':cccccoc,;;''...........::...'::cccllllll:.,:;'..               
               .:oodooolllccc::::;;;;,;c......',;:::c..cdc;,'.........:c'''':::ccclllll;.cc:,'.               
               .:dddddddooooollllccc::cc.......,:;'.  .cdllooc,''''',,cl,'',;::ccccclll:'cc:;,.               
               ':dddddddooooooolllllcclc.....',cd,    .lc:loloo:,,,,,,cl,'',;::ccccccllc,:::;,.               
               ':oooooooolllloooollllllc....':odd:,.  ;c;:lclloo;,,,,;lc,'',;:::cccccll:.;::;'.               
               ':cllllllllllllllllllllo,...';oooolo, .;;ccl:llool:;,,:o:''',;:::cccccllc..:c;,.               
               '::ccccccccccccccclllllo'..',cooooll, .:llcc:llcldc;;;:o;'',,;:::cccccllc..:c;;.               
               ':;:c:::::::::::ccccccll..',;lollol:.  ,llc::cloodo:::cl;.',,;::::ccccclc;;cc;;'               
               'c;;;:::;;;;::::::ccccco..';lllllll,   .;cc:cclloxdc:ccl,.''';;;:::::cccc,';:;;'               
               ,c;;::::cccccccccclllllo'.,loollcll,   .';;:ccc:lxx::;:c,...';:;;;::::cc:,,;;;,.               
               ,c:ccccccccccccccccccccl'.,clllllllc;,',;,;;:cloxkx,'........;;;,;;;;,,,'''''...               
               ,l:ccccccccccccccccccccl'.,:clllllcc;,,,,,;cldkkkOc......''.....................               
               ,l::::::;;;;;;;;;;;;;;;,..,;:clcccc;,,...,cdkOOOOko.............................               
               ,c,........................''',:ccc,,....;ldxkOOOxx;............................               
               .,'......'''''''''''.......   .,cccc;,coxxxxdxOOOxdd'..........................                
               .'............................':cloocoodxkkkllO00Oxxc...........................               
                ..  .........................::lddc;looodddcoO00OOxx,..........''''''''''......               
                  ...........................;:ddd'.',:;;:,coO00OOkkl........'''''',,,,,,,,,,'.               
                 ............................;lxdl.        ,lk0000Okx:.........'''',,,,,,,,,,,'               
                .............................:okd:.        .cxO0000Okx,..........'''''',,,,,,,.               
                .............................:dkd:.        .:dO0000Okk:................'''''''.               
               .,,,,,;;;;;;;;;;;;;;;;;;;;:::::::::::::::::cc::ccccccccccccc:::::::::::::::;;;;.               
               .,,,,,,,;;;;;;;;;;;;;;;;;;;;:::::::::::::::cccccccccccccccccc:::::::::::::;;;;;'               
               .,,,,,,,;;;;;;;;;;;;;;;;;;;;;:::::::cccccccccllllllllllllcccccc:::::::::;;;;:::'               
               .,,,,,,,,,,;;;;;;;;;::;;;;;;;;:::::cccccllllllllllllllllllcccccccc::::::;;:::::,               
               .,,,,,,,,,,,,;;;;;;;;;;;;;;;;;:::::cccclllllloooooooooollllllcccccc::::::cccccc,               
               .',,,,,,,,,,,,,,,,;;;;;;;;;;;;;;:::::cccclllloooooolllllllllllllccccccccllc::::,               
               .'''''''',,,,,,,,,,,,,;;;;;;;;;;;;;::::cccccccclllllllllloooooolllcccccccc::::;'               
               ..'''''''''',,,,,,,,,,,,,,,,,,,;;;;;;::::::::cccccccccclloooooooolllllcl:;::::;'               
               ......'''......''''''',,,,,,,,,,,,,,,,;;;::::::::::::cccllloooooooooool,;cccccc;               
               ....','.............'''''''''''''...',,;;;;:::::::::::ccccllloooooddxxd:':lclll:               
               ..'''..................'''''''''..',:c;,;;;;;;;;,,,,,::::cclllooodddkkOxdxdlllo:               
               .,'...............',.......'''''';llccl:,,,;,'.... ...',::cllloooodxxkOOxxooxxdc               
               .'..................;,.....'''''';cclcll:,,,.    .''....':clloooooddxxxo;;,:dkkl               
               .'...................;;....'''''';llccll,,,.       ';....':cllloodddxxc,....':xl               
               ';;;;;,,''''..........c'.........';cccl;'c;...     .,c'...,ccllooodddl..,,....;:               
               ;oolllccc:::;;;;,,'''.c,.........':;;,. .do:;,.......c:...,ccclloodddl.,:;'.''';               
               ;oddooooolllcccc::;;;;c;.......',lo'    ,ollool;....'cc''',::ccllooodl.:c:,'''',               
               ;dddddddoooollllllccc:l;......'codo;.  .c:;lllooc,,,,cl''',;::cccclloc,:c:,'''',               
               ;dddddooooooooolllllcco;.....':dooooc. ,;cclcllod:,,,cl''',;:::cccccll';::,'''''               
               ;ooooolllllllllllllllll;.....,ddoooo; .;llcc:llcool,:l:''',;:::ccccclc.,::,,''''               
               ':ccccccccllllllllllllc.....,coooooc.  ;::;;;::cloo;cl,''',;:::ccccclc'.:c;,,,''               
               ':ccccccccccccccccllclc...';oollloo:,,,,,;,,,;:llodlll'''',;:::cccclll,':c;;,,,,               
               ':::::;::::::::cccccclc..'':oolllllc;,''',,;;:ccldxoll'''',;::::ccclll:,cc;;;;;,               
               ';;;;;;;;:::::::::ccclc..',,collllc:''..;:cloooodxxllc'.'',;;;;:::clll,';;;;,,;,               
               ,:::cccccccccccclllllll..,,,;lclc:::::::;cldxxxxxxc,,,....,;;;;;::ccc:,,,,,'....               
               ;cccccccccccccccccccccc..;;;;;;::::cllc:,;oxkkkkddl.......',,'''''..............               
               ;:cccc::::::ccccccccclc..;;;;;,:cc:c;.. .,odxkxxxdxc................'''.......'.               
               ;;,,,,,'''''''''''''.....,,,'',;cllc'     ;cdkkkkxdx,...........................               
               ''...............'''......... .:clol.     'cdkOOOOxko...........................               
               .''..'''''''''........      ...;:odl.     .:ok0OO0kkkc..........................               
               ...............................;:dd:.     .;lk0000Okkx,.......'''''''...........               
                  ............................;lxd:       ,cdO0000OkOo'....'''''',,,,,,,,'''''.               
                 .............................;oxd,       'clk00000Okk:.....''',,,,,,,,;;;;;,,.               
                ..............................:xxo'       .::x000000OOo........'''''',,,,,,,,,.               
                .............................':xxo.       .;;lk00000OOk,...................'''.               
                .............................':xxo.        ,;ck00000OOO;.......................               
               .,,,,,',,,,,,,,,'',,,,,,,,,,,,,;;;,,,;;;;;;;;;;::::::::::::::::::::::::::::;;;;.               
               .''',''',,,,,,,,,,,,,,,,,,,,,,,;;;,,;;;;;;;;;;;:::::::::::::::::::::::::::;;;;;'               
               .'''''''',,,,,,,,,,,,,,,,,,,,,,,;;;;;;;;;;;:::::::::::::::::::::::::::;;;;;;;;;'               
               .''''''''',,,,,,,,,,,,,,,,,,,,,,;;;;;::::::::::::::::::::::::::::::::;;;;;::;;;'               
               .'''''''',,,,,,,,,,,,,,,,,,;;;;;;;;;::::::::::::::::::::::::::::::::::;;::::;;;'               
               .',,,,,,,,,,,,,,,,,,,,;;,,;;;;;;;;;;;;:::::::::cccccc::ccccccccccc::::::::;;;;;'               
               .''''',,,,,,,,,,,,,,,,,;,,,,,,;;;;;;;;;::::::::::ccccccccllllccccccccccc::;;;;;'               
               .''''''''''',,,,,,,,,,,,,,,,,,,,,;;;;;;;;:::::::::ccccllllllllllcclcccc::::::::,               
               ..'''''''.....'''',,,,,,,,,,,,,,,,,,,,,;;;;;;::::::ccccclllllllllllll;;:ccccccc;               
               ..',,,.............'',,,,,,,,,,,,,'..',,;;;;;;:::::::cccclllloooooodo;'collllll:               
               .,,'.................',,,,''',,,,'.';:c;,;;;;;,,,,,;:::cclloooddddxkkddxdlddddo:               
               ',................,'..''''',,,,,,,;lcccl:;;,.........';ccllooddxxxkOOOkkdoxxkkxc               
               ...................,;..''',,,,,,,,:llccll;,.    .,'....,cclloddxxxkkkd:;,:dkOOkl               
               ....................,:..'''',,,,,,:llccll;.      .;;....;cllloodxxkxl,'...,lOOOo               
               ,:;;;,,,''''.........c,.'''',,,,,,,:c:cc,:'....   .:;...,:cclllooddl..,,'..,okko               
               :llllccc::::;;,,''''':;.''',,,,,,:l;''. .do;,......;c'..':cccllloddo.,::,''';odc               
               :odooooollllcc:::;;;;c:..',,,,,;col.    ;doool:'.'':l,''';:ccclllooc.:c:,''',co:               
               cddddddooooollllcccc:l:.''''',;oddo:.  'lc:oolll;,,:l,'',::ccccccllc,:c:;''',:c;               
               :odooooooooooooollllcl:.'''',;oxdddl. .;:cllclldl,,cl,'',::cccccccll';::;,''';:,               
               :ooolllllllllllllllllo;.'''',cdoool..';;;;:::llloo:cc,'',;:::ccccclc.'::;,''';:,               
               ;cccccccccllllllllllll....';loooloc;;:;''',;;llccool:''',,:::ccccclc'.;c;,,,,:c;               
               ':ccc::cccccccccllccll...',looooooc;,;;,,:c:;cccoddo:''',,:::cccclll;':c;;,,;cl;               
               ':::::::::::::ccccccll..''':lollll:,,;::;:colcccodxo;.'',,;:::ccclll;,:c;;;;;co:               
               ';;;;;:::::::::cccccll..',,;cllcc:,'...',;lddoooddoo;..'';;;;:::cclc,',;;,,,;cl;               
               ,:ccccccccccccllccccll..,,,;;;;:::;:.  .;codddddx:''.....,;;;;:::::;,',,'.......               
               ;ccccccccccccccccccccl..;;;;;;;:cc:c.   ,ccddodxxo,..'''.'''..................'.               
               ,:cc::::::::::::cc:::;..,;;;;;;:clcc.   .:cdxxxkkkl...............''''......'''.               
               .,'''''...'.............,;,'..':cllc.   .;cokOOkOOk;............................               
               ............''''''''........  .,:loc.    ':okOOOOOOd'...........................               
               .'.'''''''.....................,:loc.    .:lkOOOO00Oc...........................               
               ...............................,:odc.    .;:dOOOO00Ox'.....'''''',,,,,'''''''''.               
                 .............................':od:      ';lkOOO000Oc'....'''',,,,,,,;;,;;,'''.               
                ..............................':od;      .;cxOOO0000x,......''',,,,,,,,,,,,,,,.               
                ..............................';ld,      .;:oOOO0000Ol.................'''''''.               
                ..............................';lx;      .,;lkOO00000x.........................               
                .......................    ...';lx;     ..,;lkOO00000k'........................               
               cddddxxxxxkOkkkkkxdddxkkkkkkkkkxxxxdllccccccooolodxxddddxkkkkkkkkkkkkkxxddddddxc               
               cddddxxxxxkkkkkkkxdddxkkkkkkkxxxdddollcccc::lllclddxddddxkkkkkkkkkkkkkxdddddxxxl               
               cxddxxxxxkkkkkkkxxddxkkkkkkkkkxdololllllc:;;::::coddddddxkkkkkkkkkkkkkxdddxxxxxl               
               cxxxxxxxkkkkkkkkxxddxkkkkkkkkkxollllllllc:;:::::coodddddkkkkkkkkkkkkkkxdddxxxxxl               
               cxxxxxxxkkkkOOOOxdxxkkkkkkkkkkdlclllllc:;:::c::ccooddddxkkkkkkkkkkkkkkxdddxxxxxl               
               cxxxxxkxkOkkkkkkxxxxxxxxxxddddoccccclc;;::;cc:clloodddddxxxxxxxxxxxxxxddddxxxxxl               
               cxxxkkkkkOkkkkkxxxxxxxxxdddddol::::cc:;;::;cc:clloodddddddddxxxddddddddddxxxxxxl               
               ckkkkkkkOOOOOOOxxxxkxxxxdddddoc:;;;:c:;:::;ccclllodddddddddxxdddxdddxxdxxxxxxxxl               
               lkkkkkkkOOOOOOkxxxxkxxxxdddddlc:;;;::::::;;ccclllodddddxxxxxddddxxxxxxxxxxxxkkxl               
               lkkkkkOOOO0OOOkxxxxxxxxxddddolc:;;;::::::;;:cclooodddddxxxxddddddxxxxxxxxxkkkkkl               
               okkkkkO000000Okxxxxxxxxxxxddolc;;;:::;:::,;::clooooddddddddddxxxddxxxxxxxxkkkkkl               
               okkkkkO000000Oxxxxxxxxkkkkxdolc;;:::;;::;,;:::cooooddddddddxxxkkxddxxxxxxxkkkkkl               
               okkkkO0000000kxxxxxxxxkkkkxdol::;;;;;::::,;:;:clloooddddddxkkkkkkxdxxxxxxkkkkkkl               
               okkkkO00000OOkxxxxxxxkkkkxxdl:::;;;,;::;;,;:;:::clllooddddxkkkkkkxxxxxxxxkkkkkOl               
               okkkkOOOOOOOkxxxxxkkkxkkxxoc;,;::;;;:;;;,,::::cccccclllooddxxxxxkxxxxxxxxxkkkkkl               
               okkkkOOOOOOOxxxxxkkkkkxxdo:;,,,;:;;;;;;,,,;;;;:::::clllcloddxxxxkxxkkxxxxxkkkkkl               
               okkkkOOOOOOOxxdxxkkkkko:,,'''',;;;;;;;,,,,,,,,;;;;;::,,,,;lodxxxxxxxxxdxxxxxxxkl               
               okkkO0000O0Oxxdkkkkxoc,.........',,,'''''''...''...''....,clodxkkxxkxdddxxxxkkkl               
               okkkO000O00kxxxkkkxl;,...................................;ccloxkkkkOkddddxxxxxkl               
               okkkO000O0OxxxxkOkd:;,...................................,:clodkkkkkxdddxxxxxxxl               
               lkkkO0OOOOkxxxxkkkl;;,...................................,:ccloxkkOOxdddxxxxxxxl               
               lxkOOO000OkxxxkOOx;;;,...................................,;::codxkkkxdddxxxxxxxl               
               lxkOOO0OOkxxxxkOkl;;;,...................................';;:cloxkkkxdddxxxxxxxl               
               lxkOOOOO0kxxxxkkd:;;,'...................................',;::coxkkkxdddxxxxxxxl               
               lxOOOOOOOxdddxkko:;;,'...................................',;::cldkkkddddxxxxxxxl               
               lxOOOOOOkxddxkOko;;;,'...................................',;;:cldkkkdxddxxxxxxxl               
               lxkkkkOkxdddxxxxc;,,,'...................................',,;:cldkkxdddxxxxxxxxl               
               lkkkkkOkxdddxkkx:;,,,'...................................',,;:cldkkxdddxxxxxxxxl               
               lkkOOOOkxdddxkxd;;,,,'..................................;',,;:cloxxxdddxxxxxxxxl               
               lOOOOOOkxxdxkkxl;;,,,'.................................;c,,,;:cldxkxddddxxxxxxxl               
               oOOOOOOxxxdxkkxc;;,,,''................................cl,,,;:cldxxxddddxxxxxxxl               
               okOOOOOxxxdkOkx:;;,,,'.................................co;,,;:ccokkdddddxxxxxxxl               
               lkkkkkkxxxxkkxd;;,,,,''................................;o:,,;;:coxxdddddxxxxxxxl               
               lkOOOOxxxdxOOkl;;,,,,':;...............................'ol,,,;:coxxdddddxxxxxxxl               
               okOOOkxxxxxOkxc;,,,,''c'................................oo,,,;::lxddddddxxxxxxxl               
               okkkkkxxdxkkkx:;,,,,';c.................................oo;,,;::cdddddddxxxxxxxl               
               cddddxxxxxkkkkkkkxdddxkkkkkkkxxxkxdooodxxxxddoloxxxxddddxkkkkkkkkkkkkkxxddddddxc               
               cddddxxxxxkkkkkkkxddxxkkkkkkkxxxkxdooodxxxxdolccdxxxddddxkkkkkkkkkkkkkxdddddxxxl               
               cxddxxxxxkkkkkkkxxddxkkkkkkkkkkkxxdooddxxddlc::codxxddddxkkkkkkkkkkkkkxdddxxxxxl               
               cxxxxxxxkkkkkkkkxxddxkkkkkkkkkkkkxdooddddolc:;;:loddddddxkkkkkkkkkkkkkxdddxxxxxl               
               cxxxxxxxkkkkOOOOxdxxkkkkkkOkkkkkkxoooddoollc::::cloddddxkkkkkkkkkkkkkkxdddxxxxxl               
               cxxxxxkxkOkkkkkkxxxxxxxxxxxxdddddddooooollllc:::clloddddxxxxxxxxxxxxxxddddxxxxxl               
               cxxxkkkkkOkkkkkxxxxxxxxxxddddddddddolollllllc:;;:cclooddddddxxxddddddddddxxxxxxl               
               ckkkkkkkOOOOOOOxxxxkxxxxxddxxxxxddolcolllllc::::cllloodddxxxxdddddddddddxxxxxxxl               
               lkkkkkkkOOOOOOkxxxxkxxxxxdddxxxxddolclllll::::::clllloodxxxxdddddxxxxxxxxxxxkkxl               
               lkkkkkOOOO0OOOkxxxxxxxxxxddddxkkxolc::ccc;;::::ccllllloddxdddddddxxxxxxxxxkkkkkl               
               okkkkkO000000Okxxxxxxxxxxxxdddxxdoc::::::;;::;:ccclllloodddddxxxddxxxxxxxxkkkkkl               
               okkkkkO000000Oxxxxxxxxkkkkkxdddddl:::;:::;;::;:ccclllooooddxxkkkxddxxxxxxxkkkkkl               
               okkkkO0000000kxxxxxxxxkOOOkxddddoc::;;;::;:::;:cccllloooddxkkkkkkxdxxxxxxkkkkkkl               
               okkkkO00000OOkxxxxxxxkkkkkkkxxdolc::;;;:;;::;;:::cllooooddxkkkkkkxxxxxxxxkkkkkOl               
               okkkkOOOOOOOkxxxxxkkkkkkkkkkkxdolcc:;;;;;;:;,;::::cooooddxxxxxxxkxxxxxxxxxkkkkkl               
               okkkkOOOOOOOxxxxxkkkkkkkkkkxxddlcccc:;;::::;;;:;;:coodddddxxxxxxkxxkkxxxxxxxkkkl               
               okkkkOOOOOOOxxdxxkkkkkkkxxxdllc;;:cc:::::::;:::;;::clooodxxxxxxxxxxxxxdxxxxxxxkl               
               okkkO0000O0OxxdkkOOOOOOkol:;;;;,,;:;;;;;,,;;;;;;;:::ccclllodxkkkkxxkxdddxxxxkkkl               
               okkkO000O00kxxxkkkOOkxl:'..''',,,;;,,;;,,,;,,:::::::::ccl:codxkkkkkOkddddxxxxxkl               
               okkkO000O0OxxxxkOOOOd:;'........',;;;,'''','',;,;;;;,,cc;';clodkkkkkxddddxxxxxxl               
               lkkkOOOOOOkxxxxkkkkxc;'............'............'.....','.;ccloxkkOOxddddxxxxxxl               
               lxkOO0000OkxxxkOOOko:,....................................;cccldxkkkxdddxxxxxxxl               
               lxkOOOOOOkxxxxkOOko:,'....................................:cccloxkkkxdddxxxxxxxl               
               lxkOOOOO0kxxxxOOOx:;,.....................................;::ccldxkkxdddxxxxxxxl               
               lxkOOOOOOxdddkkkkl;;'.....................................,:::ccoxkkddddxxxxxxxl               
               lxkOOOOOkxddxkOkxc,,'.....................................,;;:ccoxkkdxddxxxxxxxl               
               lxkkkkOkxdddxxkxo;,,'.....................................',;::ccdkkdddxxxxxxxxl               
               lkkkkkkkxdddxkkxl;,,'.....................................',;;:ccdkkdddxxxxxxxxl               
               lkkOOOOkxdddxkkxc;,,'.....................................',,;::coxxdddxxxxxxxxl               
               lOOOOOOkxddxkkxd:;,,'.....................................',,;;:coxxddddxxxxxxxl               
               okOOOOOxxxdxkkxo;;,,'...................................,;',,;;:clxxddddxxxxxxxl               
               okOOOOOxxxdkOkxc;;,,'...................................ll,,,,;:cloxddddxxxxxxxl               
               lkkkkkkxxxxkOkx:;,,,'...................................od:',,;::codddddxxxxxxxl               
               lkOOOOxxxdxOOkd;;;,,'...................................lol,,,;;:codddddxxxxxxxl               
               okkkkkxxxxxOkko;;,,,'...................................;oo;,,;;:cldddddxxxxxxxl               
               okkkkkxxdxkkkkl;,,,,''..................................;od;,,;;:cloddddxxxxxxxl               
               cddddxxxxxkOkkkkkxddxxkkkkkkkxkkkxdooodxxxxddddddlldddddxkkkkkkkkkkkkkxxddddddxc               
               cdddxxxxxxkkkkkkkxddxkkkkkkkkxxxkxdooodxxxxddddooccoddddxkkkkkkkkkkkkkxdddddxxxl               
               cxdxxxxxxkkkkkkkxxddxkkkkkkkkkkkkxdoodxxxxddoolcccclddddxkkkkkkkkkkkkkxdddxxxxxl               
               cxxxxxxxkkkkkkkkxxddxkkkkkkkkkkkkxddddxxxddollccccclodddxkkkkkkkkkkkkkxdddxxxxxl               
               cxxxxxxxkkkkOOOOxxxxkkkkkkOkkkkkkxdddxxdddolclllccccloddxxkkkkkkkkkkkkxdddxxxxxl               
               cxxxxxkxkOkkkOOkxxxxxxxxxxxxxdddddddddoooollllllllcclooddddxxxxxxxxxxxddddxxxxxl               
               cxxxxkkkkOkkkOkxxxxxxxxxxxxddddddddddoloollllllcc::clooooodddddddddddddddxxxxxxl               
               ckkkkkkkOOOOOOOxxxxkxxxxxxxxxxxxddddoolollllllc::;:clollooddddddxdddddddxxxxxxxl               
               lkkkkkkkOOOOOOkxxxxkxxxxxxxxxxxxddddolclllllc:::::;:llclloodddddxxxxxxxxxxxxkkxl               
               lkkkkkOOOO0OOOkxxxxxxxxxxxddxxkkxdddolcclcc:;;:::;;:cc:llloddddddxxxxxxxxxkkkkkl               
               okkkkkO000000Okxxxxxxxxxkkxdxxxxxdddoc:::cc:;;::;,,;cc:clloddxxxddxxxxxxxxkkkkkl               
               okkkkkO000000Oxxxxxxxxkkkkkxddddddddlc::::::::::;,,;cc:colodxkkkxddxxxxxxxkkkkkl               
               okkkkO0000000kxxxxxxxkkOOOkxdddddddolc:::::;::::;,,:cc::ooodxkkkkxdxxxxxxkkkkkkl               
               okkkkO00000OOkxxxxxxkkkkkkkkxxddddolc::::::;:cc:;;;:llccooodxkkkkxxxxxxxxkkkkkOl               
               okkkkOOOOOOOkxxxxkkkkkkkkkkkkxddddol::;;:::;:cc::;;cllllooldxxkkkxxxxxxxxxkkkkkl               
               okkkkOOOOOOOkxxxxkkkkkkkkkkkkxdddol:;;;;;;;;:cc::;;cccclllldxxxxkkxkkxxxxxxxkkkl               
               okkkkOOOOOOOxxxxkkkkkkOOOOkkxxddolc:;;;;;;;:cc:;,,;:::cclolxxxxxkxxkxxdxxxxxxxkl               
               okkkO0000O0OxxxkOOO0OOOOOOkxdollc:::;;;,,,;::;;;,,;;;:cllooxkkkkkxxkxxddxxxxkkkl               
               okkkO0000O0kxxxkOOOOOOOOOkdoc;:::::;,;,,,,,,,;;,,;;:clcllooxkkkkkkkOkddddxxxxxkl               
               okkkO00000OkxxxOOOOOOOOko:::;,;;;,,',,,;,,,;:;,;;;:ccccclooxkkkkkkkkkxdddxxxxxxl               
               lkkkOOOOOOkxxxxkOOkOkkxo,.';,,,;,'''',,,',,,,'''',;:::::lodxkkkkkkOOkddddxxxxxxl               
               lxkOO0000OkxxxkOOOOOOkl,.....'''''...''..........',,;;;:cldxkkkkkkkkxdddxxxxxxxl               
               lxkOOOOOOOxxxxkOOOOkxc'..........................',,;;;:cldxkkkkkkkkxdddxxxxxxxl               
               lxkOOOOO0kxxxxOOOOOxl;...........................',,,;;;:coxxkkkkkOkxxddxkxxxxxl               
               lxkOOOOOOxxxxkOOkOxc;'...........................',,,;;;:cldxkkkkkOkxxxxxxxxxxxl               
               lxkOOOOOkxddxkOOOko;,.............................',,,,;:cloxkkkkkOkxdxxxxxxxxxl               
               lxkkkkkkxdddxkkkko;;,.............................'',,;;;:coxkkkkkOkxxxxxxxxxxxl               
               lkkkkkkkxdddxkkkdc;;,.............................''',,,;:cldkkkkkkkxxxxxxxxxxxl               
               lkkOOOOkxdddkkkxo;;;,..............................'',,,;:cldkkkkkkxddxxxxxxxxxl               
               lOOOOOOkxxdxkkkd;;,,,'.............................'',,,;:cldxkkkkkxddxxxxxxxxxl               
               okOOOOOkxxdxkkxc;;,,,'..............................',,,;::ldxkkkkkxddxxxxxxxxxl               
               okOOOOOxxxdkOko;;;,,,'..............................''',,;:ldxkkkkkxddxxxxxxxxxl               
               lkkkkkkxxxxkOx:;;;,,,''..............................''',;:loxkkkkxddddxxxxxxxxl               
               lkOOOOkxxxkkkl;;;;,,,,l;.............................',,,;:clxxkkkkdddddxxxxxxxl               
               okkkOkxdxxkkx:;;;,,,,ldl.............................',,,,;:ldxxkkxdddddxxxxxxxl               
               okkkkkxddxkkd;;;;,,,:doo.............................',,,,;:coxxkkxdddddxxxxxxxl               
               cdddxxxxxxkOkkkkkxxxxkkkkkkkkkkkkxdoodxxxdddxxxxxxxxddddxkkkkkkkkkkkkkkxddddddxc               
               cdddxxxxxxkkkkkkkxxxxkkkkkkkkxxxkxdoodddollodddxxxxxddddxkkkkkkkkkkkkkkxddddxxxl               
               cxdxxxxxxkkkkkkkkxddxkkkkkkkkkkkkxdodoollccloodddxxxddddxkkkkkkkkkkkkkxdddxxxxxl               
               cxxxxxxxkkkkkkkkxxddxkkkkkkkkkkkkxddolllcccclollllloddddxkkkkkkkkkkkkkxdddxxxxxl               
               cxxxxxxxkOkkOOOOxxxxkkkOkkkkkkkkkxoolllc:::clllcccccloddxkkkkkkkkkkkkkxdddxxxxxl               
               cxxxxxkxkOkkkOOkxxxxxxxxxxxxxxdddoollllc::::cccccccllllldddxxxxxxxxxxxddddxxxxxl               
               cxxxkkkkkOkkkOkxxxxxxxxxxxxdddddooollllc:;;;;:::::clllllcloddddddddddddddxxxxxxl               
               ckkkkkkkOOOOOOOxxxxkkxxxxxxxxxxdoolllllc:;;;;:::::cooddddoddddddxdddddddxxxxxxxl               
               lkkkkkkkOOOOOOkxxxxkkxxxxxxdxxxxoolllllc:;;;;::::ccloddddddddddxxxxxxxxxxxxxkkxl               
               lkkkkkOOOO0OOOkxxxxxxxxxxxddxxxdolllllc:;;;;;;;;:ccclddddddddddddxxxxxxxxxkkkkkl               
               okkkkkO000000Okxxxxxxxxxkkxddxddolccc:;;;;;;;;;;:ccccodddddddxxxddxxxxxxxxkkkkkl               
               okkkkkO000000Oxxxxxxxxkkkkkxddddoc:::::;;;;;,;;;;cccclodooodxkkkxddxxxxxxxkkkkkl               
               okkkkO0000000kkkxxxxxkkOOOkxdddolc:::;;;;;;;,,,;;:ccclooooodxkkkkxdxxxxxxkkkkkkl               
               okkkkO000000Okkkkxxxkkkkkkkkxxdolc:;;;;;;;;;,,,;;:ccclooooodxkkkkxxxxxxxxkkkkkOl               
               okkkkOOOOOOOkxxxxkkkkkkkOOkkkxdoc::;;,;;;;;;,,,;;cllllooooddxxxkkxxxxxxxxxkkkkkl               
               okkkkOOOOOOOkxxxkkkkkkkOOOkkkxdlc::;,,;;;;;;,,,,;cllllloooddxxxxkkxkkxxxxxxxkkkl               
               okkkkOOOOOOOxxxxkkkkOOOOOOkkkxdl:::;,,;;;:;;,,,;;:clllloooodxxxkkxxkxxdxxxxxxxkl               
               okkkO000000OxxxkOOO0000OOOOOOxoc:::;,,;;::;,,,,;;:ccllllllodxkkkkxxkkxddxxxxkkkl               
               okkkO000OO0kxxxkOOOOOOOOOOOkkdc;::;;;;;;;;,,,,,;;:cclooolcloxkkkOkOOkxdddxxxxxkl               
               okkkO00000OkxxxOOO0000OOOOOxoc:;;;;;;;;;;,,,;;::::ccloddolldxkkkkkkkkxdddxxxxxxl               
               lkkkOOOOOOkxxxkOOOOOOOkkkkkocc:;,,,,,,',,,,,;:c:::ccloddddxkOOOOOOOOkxdddxxxxxxl               
               lxkOO0000OkxxxOOOOOOOOOOOkxl::;;,,,,''',,,''';:cllllloddxxkkkkkkkkOOkxddxxxxxxxl               
               lxkOOOOOOOxxxxOOOOOOOOOOkkdl;,,''','...'''.'',:coooodxkkkOOOOkkkkOOOkxxxxxxxxxxl               
               lxkOOOOO0kxxxkOOOOOOOOOOkdc,,,'...........,,;;:cloddxkkkkkkkkkkkkOOOkxxxkxxxxxxl               
               lxkOOOOOOxxxxkOOOOOOOOOkd:...............',;;:ccclodxkkkkkkkOkkkkOOOkxxxkkxxxxxl               
               lxkOOOOOkxxdxOOO0OOOOOOo;'..............',,;;:ccc::cldxkkkkkkkkkkOOOkxxxkkkkxxxl               
               lxkkkkOkxxddxkkkkkkkkkxc,..............',,,;;:cccc'...;dxxxkkkOOkOOOxxxxkkkkxxxl               
               lkkkkOOkxxddxkkkkkkkkxl;'..............',,,;;::ccc:'..,dxxxxkkkkkOOkxxxxkkkkxxxl               
               lkkOOOOOxxxxkkkkkkkkxo:;'..............',,,;;::cccc;..,dxxxxxkkkkkkkxxxxkkxxxxxl               
               lOOOOOOkxxxxkkkOOkkkd:;;'..............',,,;;::cccc;...;oxxxxxkkkkkkxxxxkxxxxxxl               
               okOOOOOkxxxxOkkOkkkdc;;;'..............',,,;;::ccc:'....:xxxxkkkkkkxxxxxkkxxxxxl               
               okOOOOOxxxdkOkOOkkdc;;;;'..............'',,;;::ccc;.....;xxkxkkkkOkxxxxxxxxxxxxl               
               lkkkkkkxxxxkOkOOkxc;;;,,'...............',,;;;:ccc;.....;xxkkkkkkkkxddxxxxxxxxxl               
               lkOOOOkxxxxOOOOOxl;;;;,,'...............',,,;;:ccc:'....;xkkkkkkkOkdddxxxxxxxxxl               
               okOOOkxdxxkOOOOko:;;;,,,:,...............',,,;;:cc:,....;xxkkkkkkkxdddxxxxxxxxxl               
               okkOOkxddxkOOOkxc;;;;,,,oc...............',,,;;:ccc,....;xxxkkkkkkxdddxxxxxxxxxl               
               cxxxxxxxxxkOOOOOkxxxxkkkkkkkkkkkkkxdddxkkkkxxxxkkkkkxxdxkkkOOOOOkOOOOkkxxxxxddxc               
               cxxxxxxxxkkOkkkkkxxxxkkkkkkkkkkkkkddddxkxxxxxxxxxkkkxddxkkkkkkkkkkkkkkkxdxxxxxxl               
               cxxxxxxxxkOOOOkkkxddxkkkkkkkkkkkkxddddxxxxxxxxxxxkkxxddxkkkkkkkkkkkkkkxxddxxxxxl               
               cxxxxxxxkkkkkOOkxxddkkkkkkkkkkkkxxdoddxxxxxxxxxxxkkkxddxkOOOkOOkkkOkkkxxddxxxxxl               
               cxxxxxxxkOOOOOOOxxxxkOOOkkOkkxoooloooddddddxxxxxxkkkxddxkOkkkOOOkkkkkkxdddxxxxxl               
               cxxxxxkkkkkkOOOkxxdddxddddddoooooooooddodddddddddddddddxxxxxxkkxxxxxxxddddxxxxxl               
               cxxxkkkkOOOOOOkxxdddoooooodddddddddooddddddddoooodddddddddxxxxxxxxxddddddxxxxxxl               
               ckkkkkkkOOOOOOkxddddoooooloooddddddddddddddooooooddddddxxxxxxxxxxxxxxxdxxxxxxxxl               
               lkkkkkkkOOOOOkkdddddoollllloooooooooooollllllooddddddddxkkxxxxxxxxxxkxxxxxkkkkxl               
               lkkkkkOOOO0OOOkxxdddolcccccclllllllllllccccclloooodddddxkxxxxxxxxxxxkxxxxxkkkkkl               
               okkkkkO000000Okxxxddoc::::::::ccccccc:::::::::cl::odddxxxxdddxxxdxxxkxxxxxkkkkkl               
               okkkkkO000000Oxxxxdoc:;;;;,,,,;;;;;;;::::;;;;;:c::loodddddxxxkkkxddxxxxxxxkkkkkl               
               okkkkO0000000kxxxxddoc;,,,'''',,,,,;;;;;;;;;::;::lodddddddxkkkOOkxxxxxxxxkkkkkkl               
               okkkkO000000Okxxxxddoc;,,''''',,,;;;;;;;;;;:c:;;;coodddddxkkkOOOkxxxxxxxxkkkkkOl               
               okkkkOOOOOOOkxxxxxxxdo:,,,,,,,;;;;;,,,,,,,;;:::::lloddxxxkkkkkkkkkkkxxxxxxkkkkkl               
               okkkkOOOOOOOkxxxkkkkxxdl;;,,,',,,,,,,,,,,,,;;;;,;:codxxxxxxxxkkkkkkkkxxxxxkkkkkl               
               okkkkOOOOOOOxxxxkkkkkkOkkdc,''''''''''''',,,;;;;:coodxkkkkkkkkkkkkkkxxxxxkkkxxkl               
               okkkO000000OxxxkOOO000OOOOkdc;,,,,,,,'''''',,,,;:coddkkkOOOOOOOOkkxkkxddxkkkkkkl               
               okkkO0000O0kxxxkOOOOOOOOOOOOxc;,,,,;;,,,,,''''';loodxkOOOOOOOOOOOOOOkxxdxkkkxxkl               
               okkkO00000OkxxxOOO0000OOOOOOkl;,;;;;,,,,,;;;;;;oxdddxkOOOOOOOOOOOOOOkxxxxxkxxxxl               
               lkkkOOOOOOkxxxkOOOOOOOOkkkkkkdc::;,,,,''''',;;:dxdddxOOO000OOOOOOOOOkxxxxxxxxxxl               
               lxkOO0000OkxxxO000OO00OOOOOOkdl::,'..''.......'cddddxkkkkOOOOOkkkkOOkxdxxxxxxxxl               
               lxkOOOOOOOxxxxO000OOOOOOOOOOkdoc;'....'.......'cddddxkOOO0OOOOOOOOOOkxxxxxxxxxxl               
               lxkOOOOO0kxxxkO000OOOOOOOOOOxdo;.............'',ldddkOOOOOkOOOOOOOOOkxxxkxxxxxxl               
               lxkOOOOOOxxxxkO000OOOO00OOOOddc'........'''''...:oodkkkOOOOOOOOOOOOOkxxxkkxxxxxl               
               lxkOOOOOOxxdxOO000000000OOOkdl'.......',,,:c:;'';oodxkkkkkkkkOOOOOOOkxxxkkkkxxxl               
               lxkkkOOOkxddxkOOOOkkOOOOkkkko;.......',,,;::clc,'cddkkkkkkkkkkOOOOOOxxxxkkkkxxxl               
               lkkkkOOOxxdxkkOOkkOOkkkkkkkdl........,,,,;::cll:',oxxxxxxxkkkkOOkOOkxxxxkkkkxxxl               
               lkkOOOOOxxxxkkkOOkOOOOOOOOkd:.......',,,,;::cllc;,;dxxxxxxxxxkkkkkOkxxxxkkxxxxxl               
               lOOOOOOkxxxxOOOOOOOOOOOOkkxo,.......',,;;;::cllll;';dxxxxxxxxxkkkkkxxxxxkxxxxxxl               
               okOOOOOkxxxkOOkOOOOOkOOOOOxo'.......,,,,;;;:cccccc;.;ddxxxxxxkkkkkkxxxxxkkxxxxxl               
               okOOOOOkxxxkOOOOkkkOkkkkkkdl........,,,,;;;::cc::c:'.'cdxxxxkkkkkOkxxxxxxxxxxxxl               
               lkkkkkkxxxxkOOOOOOOOOOkkkxoc........,,,,,;;:cc:,;::'...,lxxkkkkkkkkxddxxxxxxxxxl               
               lkOOOOkxxxkOOOOOOOOOkkkkxdoc........',,,,;;:cc:'','......cxkkkkkkOkdddxxxxxxxxxl               
               okOOOOxxxxkOOOOOOOOOOOkkxdl;.........',,,;;:cc:..........'dkkkkkkkxdddxxxxxxxxxl               
               okkOOkxxxxkOOOkkkkOOkkkkxdc,.........',,,;;:cc:..........,dxkkkkkkxdddxxxxxxxxxl               
               cxxxxxxxxkkOOOOOkxxxxkkkkkkkkkkkkkxdddxkkkkxxxxkkkkkxxdxkkkOOOOOkOOOOkkxxxxxddxc               
               cxxxxxxxxkkOOkkkkxxxxkkkkkkkkkkkkkxdddxxxxxxxxxxxkkkxddxkkkkkkkkkkkkkkkxdxxxxxxl               
               cxxxxxxxkkOOOOkkkxddxkkkkkkkkkkkkxddddxxxxxxxxxxxkkkxddxkkkkkkkkkkkkkkxxddxxxxxl               
               cxxxxxxxkkkkOOOkxxddkkkkkkkOkkkkkxdddxkxxxxxxxxkkkkkxddxkOOOkOOkkkOkkkxxddxxxxxl               
               cxxxxxxxkOOOOOOOxxxxkOOOkkkOkkkkkxdddxkxxxxxxxxxxkkkxddxkOkkkOOOkkkkkkxdddxxxxxl               
               cxxxxxkkkkkkOOOkxxxxxxxxxxxxxxxxdddddddddooddddddddddddxxxxxxkkxxxxxxxddddxxxxxl               
               cxxxkkkkOOOOOOkxxxxxxxxxxxxddddddddddddolcclloooooodddddddxxxxxxxxxddddddxxxxxxl               
               ckkkkkkkOOOOOOOxxxxkkxxxxxxxxxxxdddddoc:;;;:::cccclodddxxxxxxxxxxxxxxxdxxxxxxxxl               
               lkkkkkkkOOOOOOkxxxxkxxxxxxxdxxddlcccc:;;;;;::ccccclodddxkxxxxxxxxxxxkxxxxxkkkkxl               
               lkkkkkkOOOOOkkxxddxxddddddolllc:;;;;;;;;;::::ccllllodddxkxxxxxxxxxxxkxxxxxkkkkkl               
               okkkkkkkOkxxxddddoooooollcccccc:;,,,,,,;;::::cclllloodddxddddxxxdxxxkxxxxxkkkkkl               
               okkkkkkkkxxxdoddddddddoolllcc:;,'',,,,;;;;;;;;:clc::odddddxxxkkkxddxxxxxxxkkkkkl               
               lkkkkkxxdddooooolllllccc::::;;,'''',,,;;;;;,,;;;::::odddddxkkkOOkxxxxxxxxkkkkkkl               
               lkkkkxxddooollcc::::::;;;;;;;;,'''',,,;;;;;;;::;;:cloddddxkkkOOOkxxxxxxxxkkkkkOl               
               okkkkkxxxddolccc::::;;;;;;,,,'''''',;;;;;;;;;::;;;cloddxxkkkkkkkkkkkxxxxxxkkkkkl               
               okkkkOOOOkxdooolc::;;;;;;;,,,'''...,;;;,,,;;;:::::lloxxxxxxxxkkkkkkkkxxxxxkkkkkl               
               okkkkOOOOOkkddddol:;;;,,,,,,,'''....',,,,,,;;;;;;;:coxkkkkkkkkkkkkkkxxxxxkkkxxkl               
               okkkO000000Oxxxxxolllccc:::;;;,,''''',,,,,,,;;;;;:codxkOOOOOOOOOkkxkkxddxkkkkkkl               
               okkkO0000O0kxxxkOOOOOOkkkkxol:;;;:;,,,,,,,,,,,;;;:lodkOOOOOOOOOOOOOOkxxdxkkkxxkl               
               okkkO00000OkxxxOOO0000OOOOOOxoc::::;,,,,,,,'''',;lodxkOOOOOOOOOOOOOOkxxxxxkxxxxl               
               lkkkOOOOOOkxxxkOOOOOOOkkkkkkkddolc:,,,,,,,,;,,,;ldodxOOO000OOOOOOOOOkxxxxxxxxxxl               
               lxkOO0000OkxxxO000OOOOOOOOOOkddooc;''......',;;codddxkkkkOOOOOkkkkOOkxdxxxxxxxxl               
               lxkOOOOOOOxxxxO000OOOOOOOOOOkdddo;............';odddxkOOO0OOOOOOOOOOkxxxxxxxxxxl               
               lxkOOOOO0kxxxkO000OOOOOOOOOOxddl;'.............:ddddkOOOOOkOOOOOOOOOkxxxkxxxxxxl               
               lxkOOOOOOxxxxkO000OOOO00OOOOxdo,........'''''..;ooodkOkOOOOOOOOOOOOOkxxxkkxxxxxl               
               lxkOOOOOOxxdxOO000000000OOOkdo;.......',,;:::;',loodxkkkkkkkkOOOOOOOkxxxkkkkxxxl               
               lxkkkOOOkxddxkOOOOkkOOOOkkkko:.......',,,;::loc,loodkkkkkkkkkkOOOOOOxxxxkkkkxxxl               
               lkkkkOOOxxdxkkOOkkOOkkkkkkkdl'.......,,,,;::cll;:oodxxxxxxkkkkOOkOOkxxxxkkkkxxxl               
               lkOOOOOOxxxxkkkOOkOOOOOOOOkd;.......',,,,;::cllc,:oxxxxxxxxxxkkkkkOkxxxxkkxxxxxl               
               lOOOOOOkxxxxOOOOOOOOOOOOkkxl........,,,,;;::clll:,cdxxxxxxxxxxkkkkkxxxxxkxxxxxxl               
               okOOOOOkxxxkOOkOOOOOkOOOOOx:........,,,,;;;:ccccc:'';oxxxxkxxkkkkkkxxxxxkkxxxxxl               
               okOOOOOkxxxkOOOOkkkOkkkkkkd;........,,,,;;:::cc::c;..'oxxkkkxkkkkOkxxxxxxxxxxxxl               
               lkOkkkkxxxxkOOOOOOOOOOkkkxo,........,,,,,;;::c:;;:;'..;dxxkkkkkkkkkxddxxxxxxxxxl               
               lkkOOOkxxxkOOOOOOOOOkkkkxdo,........',,,;;;::c:,;;,....,okkkkkkkkOkdddxxxxxxxxxl               
               okOOOOxxxxkOOOOOOOOOOOkkxdo,........',,,;;;::c;.........,dxkkkkkkkxdddxxxxxxxxxl               
               okkOOkxxxxkOOOkkkkOOkkkkxdl,........',,,;;;::c;.........,dxxkkkkkkxdddxxxxxxxxxl               
               cxxxxxxxkkkOOOOOkxxxxkkkOOOOkkkkkkxdddxkkkkxxxxkkkkkxddxkkkOOOOOkOOOOkkxxxxxddxc               
               cxxxxxxxkkkOOOkkkxxxxkkkkkkkkkkkkkxdddxxxxxxxxxxxkkkxddxkkkkkkkkkkkkkkkxdxxxxxxl               
               cxxxxxxxkkOOOOkkkxxxxkkkkkkkkkkkkxddddxxxxxxxxxxxkkxxddxkkkkkkkkkkkkkkxxddxxxxxl               
               cxxxxxxxkkkkOOOkkxxxkOOOkkkkkkkkkxdddxkkkxxxxkkkkkkxxddxkOOOkOOkkkOkkkxxddxxxxxl               
               cxxxxxxxkOOOOOOOxxxxkOOOOOOOOOkkkxdddxkkxxdddxxkkkkxdddxkOkkkOOOkkkkkkxdddxxxxxl               
               cxxxxxkkkkkkOOOkxxxxxxxxxxxxxxxxxddddddddollloodddddddxxxxxxxkkxxxxxxxddddxxxxxl               
               cxxxkkkkOOOOOOOxxxxxxxxxxxxxxxdddddddddolcc::::lllooddddddxxxxxxxxxddddddxxxxxxl               
               ckkkkkkOOOOOOOkxxxxkkxxxxxxxxxxxxdddolc;;;;;::::::clodddxxxxxxxxxxxxxxdxxxxxxxxl               
               lkkkkkkOOOOOOOkxxxxkkxxxxxxxxkkxxddoc:;;;;;::::::ccloddxkxxxxxxxxxxxkxxxxxkkkkxl               
               lkkkkkOOO000OOkxxxkkxxxxxxxxxkkkxdoc;;;;;;::::cccclloddxxxxxxxxxxxxxkxxxxxkkkkkl               
               okkkkkO000000Okxxxxxxxxxkkxxxxxxxdo:;;;;;;;:::ccccllloddxddddxxxdxxxkxxxxxkkkkkl               
               okkkkkO000000OkkxxxxxxkkOOkxxdddddl:;;;:;;;;;;::::;:loddddxxxkkkxddxxxxxxxkkkkkl               
               okkkkO0000000OkkkkxxxkOOOOOkxxdddoc:;;;:;;;,,;;:c;;;coodddxkkkOOkxxxxxxxxxkkkkkl               
               okkkkO000000OkkkkkkkkOOOOOOkxxdddl::;;;::::::;;;:ccclooodxkkkOOOkxxxxxxxxkkkkkOl               
               okkkkOOOOOOOkkxxkkkkkkOOOOOkkkxdol:;;;;;;;;::;;;:clloooodxkkkkkkkkkkxxxxxxkkkkkl               
               okkkkOOOOOOOkxxxkkkkkOOOOOOkkxxooc:;;;;;;;;;;;;::clloddddxxxxkkkkkkkkxxxxxkkkkkl               
               okkkkOOOOOOOxxxxkkOOOOOOOOOkkxdolc:;,;;;;;;;;;,;::clodxxxxxkkkkkkkkkxxxxxkkkxxkl               
               okkkO000000OxxxkOOO0000Okkkkkxdlcc:;;;;;;;;;;;;;:clodxkkxkkkOOOOkkxkkxddxkkkkkkl               
               okkkO000OO0kxxxkOOOOOOOkkkkxxddddolc:;;,,,,,,;;:cloodxkOOOkOOOOOOOOOkxxdxkkkxxkl               
               okkkO00000OkxxxOOO00000OOOOOkxdddoo:,,,,,,,''',:cclddxkOOOOOOOOOOOOOkxxxxxkxxxxl               
               lkkkOOOOOOkxxxkOOOOOOOOOOOOOkdddoc:'...'',;;;,;::clodxkOO000OOOOOOOOkxxxxxxxxxxl               
               lxkOO0000OkxxxO0000OO0OOOOOOkddd:'.........'',;::clodxxkkOOOkkkkkkOOkxdxxxxxxxxl               
               lxkOOO000OxxxxO0000OOOOOOOOOkdoc'.............':cllooxxxkkOOOOOOOOOOkxxxxxxxxxxl               
               lxkOOOOOOkxxxkO0000OOOOOOOOOxd:'...'..........'looooodxxxkkOOOOOOOOOkxxxkxxxxxxl               
               lxkOOOOOOkxxxkO000OOOO00OOOOdc'..';::;;,,'....'oodooodxkkOOOOkOOOOOOkxxxkkxxxxxl               
               lxkOOOOOkxxxxOO000000000OOOko,..',;;;::clc,...'lddoddxkkkkkkkOOOOOOOkxxxkkkkxxxl               
               lxkkkOOOkxddxkOOOOkkOOOOkkkxc...,,;;;::cllc,''':dooxkkkkkkkkkkOOOOOOxxxxkkkkxxxl               
               lkkkkOOOxxdxkkOOkkOOkkkkkkkd;..',;;;;::cllc,''';ooodxxxxxxkkkkOOkOOkxxxxkkkkxxxl               
               lkOOOOOOxxxxkkkOOkOOOOOOOOkl...,;,;;;:cclll:''',loodxxxxxkkkxkkkkkOkxxxxkkxxxxxl               
               lOOOOOOkxxxxOOOOOOOOOOOOkkx;..',;;;;;::ccccc;'''cooxxxxxxxxxxxkkkkkxxxxxkkxxxxxl               
               okOOOOOkxxxkOOkOOOOOkOOOOOd'..',;;;;;::ccccc:;..;odxxxxxxxkxxkkkkkkxxxxxkkxxxxxl               
               okOOOOOkxxxkOOOOkkkOkkkkkko...',;;;;:::::;::::'..cxxxxxxxkkkxkkkkOkxxxxxkxxxxxxl               
               lkOkkkkxxxxkOOOOOOOOOOkkkxc...',;,;;::::;,,;::,..'lxxxxxxkkkkkkkkkkxdxxxkkkxxxxl               
               lkkOOOkxxxkOOOOOOOOOkkkkxdc...',;,;;::::;,,,,,'....:dxxxxkkkkkkkkOkxdxxxxxxxxxxl               
               okOOOOxxxxkOOOOOOOOOOOkkxd:...',;;;;::::,...........:xkxxxkkkkkkkkxdddxxxxxxxxxl               
               okkOOkxxxxkOOOkkkkOOkkkkxd:...',;;;:::::'............lxxxxkkkkkkkkxdddxxxxxxxxxl               
               cxxxxxxxkkkOOOOOkxxxxkkkOOOOkkkkkkxdddxkkxxxxxxxxkkkxddxkkkkOOOOkOOOOkkxxxxxddxc               
               cxxxxxxxkkkOOOkkkxxxxkkkkkkkkkkkkkxdddxxxxxdddxxxxxxdddxkkkkkkkkkkkkkkkxdxxxxxxl               
               cxxxxxxxkkOOOOkkkxxxxkkkkkkkkkkkkkxdddxxdolllooddxxxdddxkkkkkkkkkkkkkkxxddxxxxxl               
               cxxxxxxxkkkkOOOOkxxxkOOOkkkkkkkkkxddddddocc::ccllloddddxkkOOkOOkkkOkkkxxddxxxxxl               
               cxxxxxxxkOOOOOOOkxxxkOOOOOOOOOkkkxdddl:::;;;;;;:::cloddxkkkkkOOOkkkkkkxdddxxxxxl               
               cxxxxxkkkkkkOOOkxxxxxxxxxxxxxxxxxddolc;;;;;;;;;;;::cldddxxxxxxkxxxxxxxddddxxxxxl               
               cxxxkkkkOOOOOOOxxxxxxxxxxxxxxxdddddlc;;;;::::::ccclloddddddxxxxxxxxddddddxxxxxxl               
               ckkkkkkOOOOOOOOxxxxkkkxxxxxxxxxxddoc;;;;;::::::cclllloddxxxxxxxxxxxxxxdxxxxxxxxl               
               lkkkkkkOOOOOOOkxxxkkkkxxxxxxxkkxxdoc;;;;;;;;;::::ccclodxkkxxxxxxxxxxkxxxxxkkkkxl               
               lkkkkkOOO000OOkxxxxxxxxxxxxxxkkkxdoc;;:;,,,,,;:c;,;:coodxxxxxxxxxxxxkxxxxxkkkkkl               
               okkkkkO000000Okkxxxxxxxxkkxxxxxxxdoc;:::;;;;;;:c;;:clllodddddxxxdxxxkxxxxxkkkkkl               
               okkkkkO000000Okkxxxxxxkkkkkxxdddddoc:::::;;;;;:ccclllclodddxxkkkxddxxxxxxxkkkkkl               
               okkkkO0000000OkkkkxxxkOOOOOkxxxdddlc::;;;;;;;;:cccccccloodxkkkOOkxxxxxxxxxkkkkkl               
               okkkkO000000OkkkkkkkkOOOOOOkkxxdddlc:;;;;;;;;;;::ccc::loooxkkkOOkxxxxxxxxkkkkkOl               
               okkkkOOOOOOOkkxxkkkkkkOOOOOkkkxdddoc:;;;;;;;,,;::::;;;cclodxxxxkkkxxxxxxxxkkkkkl               
               okkkkOOOOOOOkxxxkkkkkkOOOOkkkxxddddo:;;;;;;;;::cc:,',;:clodxxxxxkkkkkxxxxxkkkkkl               
               okkkkOOOOOOOkxxxkkOOOOOOOOOOOkddddoo:;;,,,,,,,:::;'',;:clodxxxxkkkkkxxxxxkkkxxkl               
               okkkO000000OxxxkOOO0000000OOOxddool:,',,,,,,,,::;,'',;:cloddxkOOkxxkkxddxkkkkkkl               
               okkkO0000O0kxxxkOOOOOOOOOOOkkxddc,.......',;;;:;;;;,,,;:clodkOOOOOOOkxxdxkkkxxkl               
               okkkO00000OkxxxOOO00000000OOOxoc,............',;;;:;;;::cloddkOOOOOOkxxxxxkxxxxl               
               lkkkOOOOOOkxxxkOOOOOOOOOOOOOkdc,'.............';::ccloolcloddkOOOOOOkxxxxxxxxxxl               
               lxkOO0000OkxxxO0000OO00OOOOOxolc:;;,'.........':cllodxxdoloddxkkkkOOkxdxxxxxxxxl               
               lxkOOO000OkxxxO0000OOOOOOOOko;:;;::cc:'.......'loooodkkxoloxkkOOOOOOkxxxxxxxxxxl               
               lxkOOO00OkxxxkO0000OOOOOOOOd:;;;:::cll,........cddodxkkkxxkkkkOOOOOOkxxxkxxxxxxl               
               lxkOOOOOOkxxxkO000OOOOOOOOd:;;;;::cccc:'.......'loodxkkOOOkOOOOOOOOOkxxxkkxxxxxl               
               lxkOOOOOkxxxxOO000000000Ok:;;;;;::ccccc,'......';oddxkkkkkkkkOOOOOOOkxxxkkkkxxxl               
               lxkkkOOOkxddxkOOOOkkOOkkOd;;;;;;::cccc:;'......''loxkkkkkkkkkkOOOOOOxxxxkkkkxxxl               
               lkkkkOOOxxdxkkOOkkOOkkkkkd;;;;;;::c:::c:;'...'''':odxxxxxxkkkkOOkOOkxxxxkkkkxxxl               
               lkOOOOOOxxxxkkkOOkOOOOkkOx:;;;;:::c:,;::;,''''''';odxxxxxkkkxkkkkkOkxxxxkkxxxxxl               
               lOOOOOOkxxxxOOOOOOOOOOOOkd:;;;;::::;,,,;;,''''''',ldxxxxxxxxxxkkkkkxxxxxkkxxxxxl               
               okOOOOOkxxxkOOkOOOOOOOOOOd:;;;;::::;''',,'''....'';dxxxxxxkxxkkkkkkxxxxxkkxxxxxl               
               okOOOOOkxxxkOOOOkkkOkkkkko:;;;;:c::'.............''cxxxxxkkkxkkkkOkxxxxxkkxxxxxl               
               lkOkkkkxxxxkOOOOOOOOOOOOkl;;;;;:c:;...............':xxxxxkkkkkkkkkkxdxxxkkkxxxxl               
               lkkOOOkxxxkOOOOOOOOOkkkkxl;,;;;:c:,...............'cxxxxxkkkkkkkkkkxxxxxxxxxxxxl               
               okOOOOxxxxkOOOOOOOOOOOkkxc,,;;;:c:'...............'ldxxxxxkkkkkkkkxxdxxxxxxxxxxl               
               okkOOkxxxxkOOOkkkkOOkkkkd:,,;;:cc:................'ldxxxxxkkkkkkkkxdddxxxxxxxxxl               
               cxxxxxxxkkkOOOOOOkxxxkOOOOOOkkkkkkxolc:;;;;;;,,,,;::coodxkkkkkkkkOOOkkkxxxxxxxxc               
               cxxxxxxxkkkOOOOOkxxxxkkkkkkkkkkkkkdolc:;;;;:;;;;;;:cloodxkkkkkkkkkkkkkkxxxxxxxxc               
               cxxxxxxxkkOOOOOOkxxxxkOkkkkkkkkkkxdl::;;;;;:::::ccccldddxkkkkkkkkkkkkkkxdxxxxxxc               
               cxxxxxxxkkkkOOOOkxxxkOOOOOOOOkkkkxol::;;;;:::::clllcclodxxkkkkOkkkkkkkkxdxxxxxxl               
               cxxxxxxxkOkOOOOOkxxxkOOOOOOOOOkkkxoc:;;;;,;::::::cccclloddxkkkkkkkkkkkxxddxxxxxl               
               cxxxxkkkkOOOOOOkxxxxxxxxxxxxxxxdddoc::;,,,,;::;,,;;ccccclodxxxxxxxxxxxxdddxxxxxl               
               cxxxkkkkOOOOOOOkxxxxxxxxxxxxxxdddool::;;;;;;:c:;;;:c:;;:cloddddddddddddddxxxxxxl               
               cxxkkkkkOOOOOOOxxxxkkkxxxxxxxxxxddoc::;;;;;;:ccccccc;,;;;codddddxxxxxxdddxxxxxxl               
               ckkkkkkkOOOOOOkxxxkkkkxxxxxxxkkxdooc:;;;;;;;;:ccccc;',;;;:coddddxxxxkxxxxxxxxxkl               
               lkkkkkOOO0000Okxxxkkxxxxxxxxxxkxdooc:;;;;;;;;:c::::,,;;;;;:coddddxxxxxxxxxxxxxkl               
               lkkkkkO0000000kxxxxxxxxxkkxxddxxdddoc:;;;,,,;;;:::;;;;,,;;;:ldddddxxxxddxxkkkkkl               
               lkkkkkO000000OkkxxxxxxkkkOOxddddddddo:;;;;;;;::;;;;,,,,,,;;;codxxddddddxxxkkkkkl               
               lkkkkO0000000OkkxxxxxkkOOOkxdddddddol:;,,,,,,,,,,'..',,,,;;:codxxxddddxxxxkkkkkl               
               lkkkkO000000OkkkxkkkkOOOOOkxxxddol:'..'''''....''..'',,;;:::lodxxxdddxxxxkkkkkkl               
               lkkkkOOOOOOOOkxkkkkkkkkkkkkkkxdoc,...............'',::;;;:cloddddxxxxxxxxxkkkkkl               
               lkkkkOO00OOOkxxxkkkkkkOOOOkkkdl;'................;::cooolclodddddxxxkxxxxxkkkkkl               
               lkkkkOOOOO0OkxxxkkkOOOOOOkkkdc;,'................;cllodddlooddxdoxxxxxxxxxxxkkkl               
               lkkkO000000OxxxkOOO0OOOOOOdl:::::;'..............',:codxdloddxxxxxxkkxddxkkkkkkl               
               lkkkO000000kxxxkOOOOOOOOOd:;;;::cc:...............',:odxoldkkkkkOOOOkxddxxkkkkkl               
               lxxkO00000OkxxxOO00000OOxc;;;:::ccc;...............',oxxxxkkkkkkkkkOkdddxxxxxxxl               
               lxkOO0000OOxxxkOOOOOOOOko;;;:::cccc:'''.............':xxkOOOkkkkOOOOkdddxxxxxxxl               
               lxkOO00000kxxxO0000OOOOx:;;;::::ccc:;,,'.............,lxkkkkkkkkkkkkkdddxxxxxxxc               
               lxkOO0000OxxxxO000OOOOOo;;;;:::::::;;,,,''............,lxkkkkkkkkOOkxxxxxxxxxxxc               
               lxkOOOOO0kxxxkOO00OOOOkl;;;;::::::;;;,,,,'............';dkkkkkkkkkOOxxxxxxxxxxxl               
               lkOOOOOOOxxxxkOO00OO0Okc;;;;;::::;,,,,,,'..............':dkkkkkkkkOOxxxxxxxxxxxl               
               lkOOOOOOkxxxxOO000OO0Okl;;;;;;:::,,,'''.................'cxxkkkkkkOkxxxxkkkkxxxl               
               lkkkOOOkxxdxxkOOOOkkkkkl;;;;;;:::'.......................,oxkkkkkkOkxxxxkkkkxxxl               
               lkkkOOOkxxdxxkOOOOOOkkkl;;;;;:::;........................,dxxkkkkkkkxxxxkkkkxxxl               
               lkOOOOOkxxxxkOOOOOOOOkOo;;;;;:::,........................:xxxxkkxkkxxxxxxxxxxxxl               
               lkOOOOOkxxxxOOkOOOOOOOOo;;;;;::;........................'lxdxxkxxxkxdxxxxxxxxxxl               
               lkOOOOOkxxxkOOkOOOOOOOko;;;;;::;........................,dxxxxxkkkkxddxxxxxxxxxl               
               lkOOOOOkxxxkOOOOkOOkkkko;,;;:::;........................:xxxxkkkkkkxddxxxxxxxxxl               
               lkkkkkkxxxkkOOOOkkOOkkkl;;;;:::,........................cxxxkkkkkkkxddxxxxxxxxxl               
               lkkkOOkxxxkOOOOOOOkkkkxl;;;;:::'.......................'oxxkkkkkkOkdddxxxxxxxxxl               
               lkkkOOxxxxkOOOOOOOOkkkxc,,;;:::........................'oxxxkkkkkkxdddxxxxxxxxxl               
               lkkkOkxxxxkOOOOOOOOkkkxc,,;;::;........................,oxxxxkkkxkxdddxxxxxxxxxl               
               cxxxxxxxkkkOOOOOOkxxxkOOOOOOkkkkkkxddl:;;;;;;::;;;:loddddkkkkkkkkOOOkkkxxxxxxxxc               
               cxxxxxxxkkkOOOOOkxxxxkkkkkkkkkkkkkdooc:;;;;;;;;,,;;:coodxkkkkkkkkkkkkkkxxxxxxxxc               
               cxxxxxxxkkOOOOOOkxxxxkOkkkkkkkkkkxdool:;;;;:;;;;;::ccloddxkkkkkkkkkkkkkxdxxxxxxc               
               cxxxxxxxkkkkOOOOkxxxkOOOOOOOOkkkkxdolc:;;::::::::::cloddooxkkkkkkkkkkkkxdxxxxxxl               
               cxxxxxxxkOkOOOOOkxxxkOOOOOOOOOkkkxdl::;;;::::::cccc:clooccoxkkkkkkkkkkxxddxxxxxl               
               cxxxxkkkkOOOOOOkxxxxxxxxxxxxxxxdddol:;;;;;;::::::cccccl:::lddxxxxxxxxxxdddxxxxxl               
               cxxxkkkkOOOOOOOkxxxxxxxxxxxxxxdddool:;,,,,,;:;,,,;::::,,;:codddddddddddddxxxxxxl               
               cxxkkkkkOOOOOOOxxxxkkkxxxxxxxxxxdddoc:;,,;;:cc;,,;::;,,,;cllodddddxxxxdddxxxxxxl               
               ckkkkkkkOOOOOOkxxxkkkkxxxxxxxkkxdddoc:;;;;;:ccc::cc:'''';cllodddxxxxxxxxxxxxxxkl               
               lkkkkkOOO0000Okxxxkkxxxxxxxxxxkxddooc:;;;;;::::ccc:;,''',:cloddddxxxxxddxxxxxxkl               
               lkkkkkO0000000kxxxxxxxxxkkxxddxxddool:;;;;;;;;;;;;;,'''',;:codddddxxxxddxxkkkkkl               
               lkkkkkO000000OkkxxxxxxkkkOOxddddddddol:;;,,;,,,,,'..'',,,;;coxxxxddddddxxxkkkkkl               
               lkkkkO0000000OkkxxxxxkkOOOkxdddddddddo:;;;;;;,,''...',,;;;:codxxkxddddxxxxkkkkkl               
               lkkkkO000000OkkkxkkkkOOOOOkxxxdddodddl;,,,,,,''...',,;;;:cloddxxxxdddxxxxkkkkkkl               
               lkkkkOOOOOOOOkxkkkkkkkkkkkkkkkddddo:;,'''.........',;;:::cldddxxxxxxxdxxxxkkkkkl               
               lkkkkOO00OOOkxxxkkkkkkOOOOkkxxdooo;...............',;:cllloddddxxxxxkxxxxxkkkkkl               
               lkkkkOOOOO0OkxxxkkkOOOOOOOkkkdooc,................';:cllooddddxxxxxxxxxxxxxxkkkl               
               lkkkO000000OxxxkOOO00O0OOOOOkdc,..................',;:clooodxxkkkxxkxxddxkkkkkkl               
               lkkkO000000kxxxkOOOOOOOOOOkdl;'....................'',;:codxkOOOkkOkkxddxxkkkkkl               
               lxxkO00000OkxxxOO00000OOkol::;;,'....................',;cdxkkkkkkkkOkdddxxxxxxxl               
               lxkOO0000OOxxxkOOOOOOOOko;;;;:::;,'....................'cxkkOOkOOOOOkdddxxxxxxxl               
               lxkOO00000kxxxO0000OOOOkc;;;:::::;,''..................':xkkkkkkkkkkkdddxxxxxxxc               
               lxkOO0000OxxxxO000OOOOkd:;;;:::::;,,,,,'................,oxkkkkkkkOkxxdxxxxxxxxc               
               lxkOOOOO0kxxxkOO00OOOOOl;;;;;:::;,,,,,,'................';dkxkkkkkkkxxxxxxxxxxxl               
               lkOOOOOOOxxxxkOO00OOOOk:;;;;;::;,,,,,,,'.................';dxxxxkkkkddxxxxxxxxxl               
               lkOOOOOOkxxxxOO000OO0Ox:;;;;;:;;,',,,,'....................,dxxxxkkkddxxkkkkxxxl               
               lkkkOOOkxxdxxkOOOOkkkkd;;;;;;::;'',,'.......................cxxxkkkkxxxxkkkkxxxl               
               lkkkOOOkxxdxxkOOOOOOkkd;;;;;;:::,'..........................:xxxkkkxddxxkkkkxxxl               
               lkOOOOOkxxxxkOOOOOOOOkx;;;;;;:::'..........................'cxxxxxkxddxxxxxxxxxl               
               lkOOOOOkxxxxOOkOOOOOOOx:;;;;;::;...........................,oxxxxxxxddxxxxxxxxxl               
               lkOOOOOkxxxkOOkOOOOOOOx:;;;;;::;...........................,oxxxxkkxddxxxxxxxxxl               
               lkOOOOOkxxxkOOOOkOOkkkx:,;;;;::,...........................,dxxxxkkxddxxxxxxxxxl               
               lkkkkkkxxxkkOOOOkkOOkkkc,;;;:::'...........................;dxxxkkkxddxxxxxxxxxl               
               lkkkOOkxxxkOOOOOOOkkkkxl;;;;:::'...........................:dxkkkkkddddxxxxxxxxl               
               lkkkOOxxxxkOOOOOOOOkkkxc,,;;:::'...........................:xxxkkkxdddddxxxxxxxl               
               lkkkOkxxxxkOOOOOOOOkkkxc,,;;::;............................cxxxxkkxdddddxxxxxxxl               
               cdodddddddxkOkxxxxxxxkxxkkdddddxkxxdddoodddoddddxkOOOkdddddxkkkxxxdddddddddddddc               
               cdoddddddxOOOkkOOkkkkkxxxxdddoooddxxddxkkkkxdddxxddxxxdddddddddddxxxdxxxddoddddc               
               :ddddxxkkOOOOxO0OO00000OxxdddolldxxddxkkkOOOxddddddxxddoodxkkkkkkOOkxkOOxdoddddc               
               :ddddkO000OkxkO0O0000000kxxxxolldkxxkkOOOOOOOOxdxkkkxdooodkOOOOOOOOkdxxkkxxddddc               
               :ddxxkkO0OkkO00000000OkkxxxxxxlldxxxxkOOOOO0OOkxkkkkxdddddxkkkOkkOOOkxdxkkkxdddc               
               :xkOOOkxkkkkO0000OOOkxkkOkxxkxloxkOkxdxOOOOOkxxkkkxxxkxddxxdddxkkkOOOkxxxxddddxc               
               ckOO00OkkkkO0K00kkkkxxk00kxxxolxOOOOxxdxxxkkxkOOOOOkxxxxxkkkxddddxkOOOkdddodxkkl               
               oOOO000Okkk0K0OkkOOOOkkO0kxxoclO000OkdlccloxkO000OOOkxddxkOkxxkkxdxxkOOxdddkOOkl               
               oOO00000OkkkkkkxkO000Okkkkxo::oO000Odc;,,:odxkO00OOOOxddxkkxkkOOkxxxxxxxdxkOOOkl               
               o0000000kkkkkO0OkO00OkkOkxdl;:d000Oxl:,;,,cloxOOOOO0OxxdxxxkxkOOkkxkxddddxOOOOko               
               o000K000OkkOkkOOkkkkkO00Oxdc;;okOOkol:;c:;:cldkOOOOOkxddxxOOOkxxxdxkxdxxdkOOOOOo               
               o000KK0OkkO0OkkkO00OO0000kxd,..'lkxo:::cc:::lodkkOOkxxxxxkOOOOkkkxxddxOkxkOOOOOo               
               oO000OkkkkOOOOkkO0K0OO00Oxxxl'...'cl;;ccc:;:cloddxxxxkkxxkOOOkOOOkxxkOOOkxxkkOOo               
               lOOOkkkkkkkkkkkxkO000O00Oxxxxd:...,:;:cc:;:cclooodxxxxxddxOOOkOOkxxdxxxxxxdddkOo               
               lxxkO00OOO00OkOOkkO00OO0OxxxkOOd;';::cc:;;:ccclllodkkxdddxkOkkOOxxxkxOOOkkkkkxxl               
               lxxxO00OOO00OkOOOkkkkkkkxxxxkOOkxl::cc:;;;::::cccldxkkxdddxxxxkkxkOOxkOOOOOOOkxc               
               lxdxO0OOO00OkxkkkxxxxkOOkxxxxOkxdc;:c:;;;;;:::;:cllldxddoodxkxdddxkkxxkOOOOOOkxc               
               okdkOOOOO00OkkkkkxxxxkOOkxxxxxddl::c:;,,,,;;;;;;:c:;:oooodxkOddddxxxddxOOOOOOOkc               
               oxxkkkxxxxxxkOOOkxxxxkOOkdddxxdolcccc;'''',,;;:::;,''looodxkkdoodxkkxddxxxxkOOkc               
               lxdddddxxdxkO0OOxxxxxxOOkddddxdoooooo;,''''',;;,,,...:doodkkxoddddkkkkxdddddxxxc               
               cdoddxkxkxxkOOOkxxkkxxkOkddddddddddxd:,'''''',,'',,..'loodxxdodxxdxkkkkddxxxxxdc               
               cddxkOkkkxddkkkxdkkkxkkkxdddddddddddd:,,''','''..;o,.,looodddodxkxxkkkxodxxxxxxc               
               cddxkOkkkddddxxxxkkxxkxxxdddddooddddl;,'''''.....ldl;:clooddddodkxxkkxdddxxxxxxc               
               cdddxkkxddxxdoddxxxkkkxxddoddddxxddc'...........ldddo:;coddddddddddxxdxxxdddxxdc               
               lxxxdddddxxxxdooddkkkkxdddooodxxxxc............cxddddo:;codddxxxdddddxkkkddddddc               
               cdxxxdodddxxxxoodxxxxxxxdodddxxxxl.............lxddddddc;ldxxxxxxdoodxxxxxdddddc               
               cxxxxdodxxxkkxdodddxxxdddddoddxxo'.............cdddddddo:;oxxxxxxddddxxxxdddddxc               
               cxxxddddxxkkkkdddoddxxdddddooodd,..............lxdddddddl;coddxxdddddxxxxxddddxc               
               cdddddddxxxxkxdddddddddddddddddc..............'dddddddddl,,:oodooodddddddxxdddxc               
               :dddddddxxxxxxddddddddddddddddd;...............cddddddddc;,;coodddddddddddxdddxc               
               :dddddddddddddddddddddddddddddo'...............'odddddddoccloddddddddddddddddddc               
               :dooodddddddddddddddddddddddool.......''........cddoodddddodddddddddddxddddddddc               
               :ooooddddddddddddddddoooooodooc......:llc.......;dxddoooodooooooddddddddddddddd:               
               :ooooddddddddddddddddoooooodoo:.....'clllc......'odddoooddooooooddddddddddddddd:               
               :oooodddddddddddddddooooooodoo;.....;lllll:......:ddddddddolllooddddddddddddddd:               
               :oooodddddddddddddddooooooodoo;.....cllllll;.....:ddddddddolllloddddddddddddddd:               
               cdodddddddxkOkxxxxxxxkxxkkdddxkkkxxdddoodddoddddxkOOOkdddddxkkkxxxdddddddddddddc               
               cdodddddxkOOOkkOOkkkkkxxxxddddxdddxxddxkkkkxdddxxddxxxdddddddddddxxxdxxxddoddddc               
               :ddddxkkkOOOOxO0OO00000OxxxdxxkkkxdddxkkkOOOxddddddxxddoodxkkkkkkOOkxkOOxdoddddc               
               :ddddkO000OkxkO0O0000000kxxxxkOOOOxxkOOOOOOOOOxdxkkkxdooodkOOOOOOOOkdxxkkxxddddc               
               :ddxxkkO0OkkO00000000OkkxxxxxkkkkkkxxkOOOOO0OOkxkkkkxdddddxkkkOkkOOOkxdxkkkxdddc               
               :xkOOOkxkkkkO0000OOOkxkkOkxxkkxxkOkxxxxOOOOOkxxkkkxxxkxddxxdddxkkkOOOkxxxxddddxc               
               ckOO00OkkkkO0K00kkkkxxk00kxxxkkO00OkxdxxkkkkxkkOOOOkxxxxxkkkxddddxkOOOkdddodxkkl               
               oOOO000Okkk0K0OkkOOOOkO00kxxkO000OkdoxoccloxkOO00OOOkxddxkOkxxkkxdxxkOOxdddkOOkl               
               oOO00000OkkkkkkxkO000OkkkxxxkO000Oocll:;,;lodkO00OOOOxddxkkxkkOOkxxxxxxxdxkOOOkl               
               o0000000kkkkkO0OkO00OkkOkxxxkO000Oocl:;;,':loxOOOOO0OxxdxxxkxkOOkkxkxddddxOOOOko               
               o000K000OkkOkkOOkkkkkO00OkxxxkOOOdool;;::,;ccoxOOOOOkxddxxOOOkxxxdxkxdxxdkOOOOOo               
               o000KK0OkkO0OkkkO00OO0000kxxkxxxdlxo:;;:cc:::odxkOOkxxxxxkOOOOkkkxxddxOkxkOOOOOo               
               oO000OkkkkOOOOkkO0K0OO00Oxxxkkdccdxl:;:ccc;;:loddxxxxkkxxkOOOkOOOkxxkOOOkxxkkOOo               
               lOOOkkkkkkkkkkkxkO000O00Oxxxxd:,cxdc::ccc:;:cllddxkxxxxddxOOOkOOkxxdxxxxxxdddkOo               
               lxxkO00OOO00OkOOkkO00OO0Oxxxx:'.,clc::::;;;:cccllodkkxdddxkOkkOOxxkxxkOOkkkkkxxl               
               lxxxO00OOO00OkOOOkkkkkkkxxxxkl..;c:::;;;;;;::::cclodkkxdddxxxxkkxkOOxkOOOOOOOkxc               
               lxdxO0OOO00OkxkkkxxxxkOOkxxxxkxlccc::;;;;;;;::::cllloxdooodxkxdddxkkxxkOOOOOOkxc               
               okdkOOOOO00OkkkkkxxxxkOOkxxxxxdolllc:;,;;;;;;:::ccc::dooodxkOddddxxxddxOOOOOOOkc               
               oxxkkkxxxxxxkOOOkxxxxkOOkdddxxdollll;,,,,,;;;::::c;,'cooodxkkdoodxkkxddxxxxkOOkc               
               lxdddddxxdxkO0OOxxxxxxOOkdddxdooooodl,,'',;,,;;,,;,..'ldodkkxoddddkkkkxdddddxxxc               
               cdoddxkxkxxkOOOkxxkkxxkOkddddddddddxd:,'.',,,;,'',:...;oodxxdodxxdxkkkkddxxxxxdc               
               cddxkOkkkxddkkkxdkkkxkxkkddddddddddddc;,'',,,'''''l;..'coddddodxkxxkkkxodxxxxxxc               
               cddxkOkkkddddxxxxkkxxkkxxdddddoddddddc,,',,''....,doc';codddddodkxxkkxdddxxxxxxc               
               cdddxkkxddxxdoddxxxkkkxddddddddxxdddd:...........ldddc;:ldddddddddddxdxxxdddxxdc               
               lxxxdddddxxxxdooddkkkkxdddooodxkxxddl............oxdddl:;loddxxxdddddxkkkddddddc               
               cdxxxdodddxxxxoodxxxxxxxdodddxxxxxdd;............cxddddd:;ldxxxxxdoodxxxxxdddddc               
               cxxxxdodxxxkkkdodddxxxdddddodxkkkxxl.............,dddddddc;lxxxxxddddxxxxdddddxc               
               cxxxddddxxkkkkdddoddxxdddddoodxxxxo,.............;xddddddo;;odxxdddddxxxxxddddxc               
               cdddddddxxxxkxdddddddddddddddddddd;..............,oddddddo;,;ldddddddddddxxdddxc               
               :dddddddxxxxxxdddddddddddddddddddl................cddddddo;,,,cdddddddddddxdddxc               
               :dddddddddddddddddddddddddddddddd,................:ddddddocccllddddddddddddddddc               
               :doooddddddddddddddddddddddddoooc.................;dddddddooddddddddddxxxxdddddc               
               :ooooddddddddddddddddoooooodoooo,......,ccl:......'oddodddooooooddddddddddddddd:               
               :ooooddddddddddddddddoooooodoooc......'cllll'.....'oddodddooooooddddddddddddddd:               
               :oooodddddddddddddddooooooodool:......:llllol......lddddddolllooddddddddddddddd:               
               :oooodddddddddddddddoooooooddol;.....'cllllod:.....lddddddolllloddddddddddddddd:               
               cdodddddddxkOkxxxxxxxkxxkkdddxkkkxxdddoodddoddddxkOOOkdddddxkkkxxxdddddddddddddc               
               cdodddddxkOOOkkOOkkkkkxxxxddddxdddxxddxkkkkxdddxxddxxxdddddddddddxxxdxxxddoddddc               
               :ddddxkkkOOOOxO00O00000OxxxdxxkkkxddxxkkOOOOxddddddxxddoodxkkkkkkOOkxkOOxdoddddc               
               :ddddkO000OkxkO0O0000000kxxxxkOOOOxxkOOOOOOOOOxdxkkkxdooodkOOOOOOOOkdxxkkxxddddc               
               :ddxxkkO0OkkO00000000OkkxxxxkkkkkkkxxkOOOOO0OOkxkkkkxdddddxkkkOkkOOOkxdxkkkxdddc               
               :xkOOOkxkkkkO0000OOOkxkkOkxxkkxxkOkxxdxOOOOOkxxkkkxxxkxddxxdddxkkkOOOkxxxxddddxc               
               ckOO00OkkkkO0K00kkkkxxk00kxxkkkO000OkxdooooxxkOOOOOkxxxdxkkkxddddxkOOOkdddodxkkl               
               oOOO000Okkk0K0OkkOOOOkO00kxxkO00000OOxl:;;loxkO00OOOkxddxkOkxxkkxdxxkOOxdddkOOkl               
               oOO00000OkkkkkkxkO000OkkkkxxkO000000xl:;;,:odxO00OOOOxddxkkxxkOOkxxxxxxxdxkOOOkl               
               o0000000kkkkkO0OkO00OkOOkxxxkO00000Ooc;;;,;lldkOOOO0OxxdxxxkxkOOkkxkxddddxOOOOko               
               o000K000OkkOkkOOkkkkkO00OkxxxkOO000xc:;:c:;:clxOOOOOkxddxxOOOkxxxdxkxdxxdkOOOOOo               
               o000KK0OkkO0OkkkO00OO0000kxxxkkkO0Odl;::cc:::cdkkOOkxxxxxkOOOOkkkxxddxOkxkOOOOOo               
               oO000OkkkkOOOOkkO0K00O00Oxxxkkxxkxdoc;:ccc::::oddxxxxkkxxkOOOkOOOkxxkOOOkxxkkOOo               
               lOOOkkkkkkkkkkkxkO000O00OxxxxkOO0Odc::::::;;;:lodxkxxxxddxOOOkOOkxxdxxxxxxdddkOo               
               lxxkO00OOO00OkOOkkO00OO0OxxxkOOOkdc::::::;;;;:cllodxkxdddxkOkkOOxxkxxkOOkkkkkxxl               
               lxxxO00OOO00OkOOOkkkkkkkxxxxO00Odl:::::;;,,;;;:cclodkkxdddxxxxkkxkOkxkOOOOOOOkxc               
               lxdxO0OOO00OkkkkkxxxxkOOkxxxkkOxdl:::::;;,,,;;:ccclcoxdooodxkxdddxkkxxkOOOOOOkxc               
               okdkOOOOO00OkkkkkxxxxkOOkxxxxxxddlc::;;;;,,;;::clc;,;oooodxkOddodxxxddxOOOOOOOkc               
               oxxkkkxxxxxxkOOOOxxxxkOOkdddxxddolc:;,,;;,,,,;:cc;'..;ooodxkkdoodxkkxddxxxxkOOkc               
               lxdddddxxdxkO0OOxxkkxxOOkdddxkxoollc,,;;;;;;,;:::c,...cdodxkxoddddkkkkxdddddxxxc               
               cdoddxkxkxxkOOOkxxkkxxkOkddddxddoodd:,;;;;;;,,;;;ll...'lodxxdodxxdxkkkkddxxxxxdc               
               cddxkOkkkxddkkkxdkkkxkkkxdddddddddddl,,,,,,,,,,''co:...;oddddodxkxxkkkxodxxxxxxc               
               cddxkOkkkddddxxxxkkxxkxxxdddddodddddo;...........:ool,,:ldddddodkxxkkxdddxxxxxxc               
               cdddxkkxddxxdoddxxxkkkxddddddddxxddddo............lddc,;coddddddddddddxxxdddxxdc               
               lxxxdddddxxxxdooddkkkkxdddooodxkxxdddo............'ldo:,;ldddxxxddoodxkkkddddddc               
               cdxxxdodddxxxxoodxxxxxxxdddddxxxxxxddc.............'oddl;;ldxxxxxdoodxxxxxdddddc               
               cxxxxdodxxxkkkdodddxxxdddddodxkkkxddd:..............:dddo;:oxxxxdddddxxxxdddddxc               
               cxxxddddxxkkkkddddddxxddddooodxxxdddd:..............'odddc,cdxxxdddddxxxxxddddxc               
               cdddddddxxxxkxdddddddddddddodddddoddo'...............lddd:,,:odddddddddddxxdddxc               
               :dddddddxxxxxxdddddddddddddddddoddddc................:odd:,,,lddddddddddddxdddxc               
               :doodddddddddddddddddddddddddddddddo.........   .....:dddllllodddddddddddddddddc               
               :doooddddddddddddddddddddoddddddooo:........',,......cdddoooddddddddddxxxxdddddc               
               :ooooddddddddddddddddoooooodooooool'.......cooo,.....cdddoooooooodddddddddddddd:               
               :ooooddddddddddddddddoooooodoooolo:.......:odddc.....:ddddooloooodddddddddddddd:               
               :oooodddddddddddddddoooooooddoooll'......;lodddo,....:ddddolllloddddddddddddddd:               
               :oooodddddddddddddddoooooooddollll'.....,loodddd:....:ddddolllloddddddddddddddd:               
               cdodddddddxkOkxxxxxxxkxxkkdddxkkkxxdddoodddoddddxkOOOkdddddxkkkxxxdddddddddddddc               
               cdodddddxkOOOkkOOkkkkkxxxxddddxdddxxddxkkkkxdddxxddxxxddoddddddddxxxdxxxddoddddc               
               :ddddxkkkOOOOxO00O00000OxxxdxxkkkxddxxkkOOOOxddddddxxddoodxkkkkkkOOkxkOOxdoddddc               
               :ddddkO000OkxkO0O0000000kxxxxkOOOOxxkOOOOOOOOOxdxkkkxdooodkOOOOOOOOkdxxkkxxddddc               
               :ddxxkkO0OkkO00000000OkkxxxxkkkkkkkxxkOOOOO0OOkxkkkkxdddddxkkkOkkOOOkxdxkkkxdddc               
               :xkOOOkxkkkkO0000OOOkxkkOkxxkkxxkOkxxdxOOOOOkxxkkkxxxkxddxxdddxkkkOOOkxxxxddddxc               
               ckOO00OkkkkO0K00kkkkxxk00kxxkkkO000OkxdddoodxxkOOOOkxxxdxkkkxddddxkOOOkdddodxkkl               
               oOOO000Okkk0K0OkkOOOOkO00kxxkO00000OOxl:;;lodkO00OOOkxddxkOkxxkkxdxxkOOxdddkOOkl               
               oOO00000OkkkkkkxkO000OkkkkxxkO00000Oxl:;,,:odxO00OOOOxddxkkxxkOOkxxxxxxxdxkOOOkl               
               o0000000kkkkkO0OkO00OkkOkxxxkO00000koc:;;,;cloxOOOO0OxxdxxxkxxkOkkxkxddddxOOOOko               
               o000K000OkkOkkOOkkkkkO00OkxxxkOO00Odl:;;::;:ccoOOOOOkxddxxOOOkxxxdxkxdxxdkOOOOOo               
               o000KK0OkkO0OkkkO00OO0000kxxxkkkO0xl:;;:cc:cc:lxkOOkxxxxxkOOOOkkkxxddxOkxkOOOOOo               
               oO000OkkkkOOOOkkO0K0OO00Oxxxkkxxkxdl:;::::::::cdxxxxxkkxxkOOOkOOOkxxkOOOkxxkkOOo               
               lOOOkkkkkkkkkkkxkO000O00OxxxxkOO0koc;;::::;;;;:odxkkxxxddxOOOkOOkxxdxxxxxxdddkOo               
               lxxkO00OOO00OkOOkkO00OO0OxxxkOOOkd::;;;:;;,;;;;lodxkkxdddxkOkkOOxxkxxkOOkkkkkxxl               
               lxxxO00OOO00OkOOOkkkkkkkxxxxO00Odl:;;;;;;,,;;;;clodxkkxdddxxxxkkxkOkxkOOOOOOOkxc               
               lxdxO0OOO00OkkkkkxxxxkOOkxxxkkkxdl:;;;;;,,,,;;::ccloxxdooodxkxdddxkkxxkOOOOOOkxc               
               okdkOOOOO00OkkkkkxxxxkOOkxxxxxxxdl:;;;;;,,,,;::::;,:doooodxkkddodxxxddxOOOOOOOkc               
               oxxkkkxxxxxxkOOOOxxxxkOOkdddxxxddl::;;;,,,,,;::;,...cddoodxkkdoodxkkxddxxxxkOOkc               
               lxdddddxxdxkO0OOxxkkxxOOkdddxkxdooc:;,;;,,,,;::;:....ldoodxkxoddddkkkkxdddddxxxc               
               cdoddxkxkxxkOOOkxxkkxxkOkdddxxddoolc;,;;;;;,;;;;c;...;ooodxxdodxxdxkkkkddxxxxxdc               
               cddxkOkkkxddkkkxdkkkxkkkxddddddddddl;'''';;,,;,',o:...:ooodddodxkxxkkkxodxxxxxxc               
               cddxkOkkkddddxxxxkkxxkxxxdddddooddddc............:o:..,looddddodkxxxkxdddxxxxxxc               
               cdddxkkxddxxdoddxxxkkkxddddddddxxddddc............,lc,;codddddddddddddxxddddxxdc               
               lxxxdddddxxxxdooddkkkkxdddooodxkxxdddd,.............:c,;codddxxxddoodxkkkddddddc               
               cdxxxdodddxxxxoodxxxxxkxdodddxxkxxxddd,..............::,;ldxxxxxxdoodxxxxxdddddc               
               cxxxxdddxxxkkkdodddxxxdddddodxkkkkxddd'...............:l;:dxxxxxdddddxxxxdddddxc               
               cxxxddddxxkkkkddddddxxddddooodxxxxdddo,...............'l;;loddxxdddddxxxxxddddxc               
               cdddddddxxxxkxdddddddddddddodddddodddd;................:,';ooodooddddddddxxdddxc               
               :dddddddxxxxxxdddddddddddddddddodddddo'........  ......;,''cdoodddddddddddxdddxc               
               :doodddddddddddddddddddddddddddddddddc.......   . .....:olcldddddddddddddddddddc               
               :doooddddddddddddddddddddoddddddddool'.......,;l:......looodddddddddddxxxxdddddc               
               :ooooddddddddddddddddoooooodoooooool:.......:oddo.....'ldoooooooodddddddddddddd:               
               :ooooddddddddddddddddoooooodoooooool'......,odddd,....'lddolllooodddddddddddddd:               
               :oooodddddddddddddddoooooooddoooollc......,odddddc.....lddolllloddddddddddddddd:               
               :oooodddddddddddddddoooooooddooolll:......codddddl.....lddolllloddddddddddddddd:               
               cdodddddddxkOkxxxxxxxkxxkkddxkkkkxxdddoodddoddddxkOOOkdddddxkkkxxxdddddddddddddc               
               cdodddddxkOOOkkOOkkkkkxxxxdddxxdddxxddxkkkkxdddxxddxxxddoddddddddxxxdxxxddoddddc               
               :ddddxxkkOOOOxO00O00000OxxxxxxkkkxddxxkkOOOOxddddddxxddoodxkkkkkkOOkxkOOxdoddddc               
               :ddddkO000OkxkO0O0000000kxxxxkOOOOxxkOOOOOOOOOxdxkkkxdooodkOOOOOOOOkdxxkkxxddddc               
               :ddxxkkO0OkkO00000000OkkxxxxkkkkkkkxxkOOOOO0OOkxkkkkxdddddxkkkOkkOOOkxdxkkkxdddc               
               :xkOOOkxkkkkO0000OOOkxkkOkxxkkxxkOkkxxkOOOOOkxxkkkxxxkxddxxdddxkkkOOOkxxxxddddxc               
               ckOO00OkkkkO0K00kkkkxxk00kxxkkkO000OkxxkkOOkxkkOOOOkxxxdxkkkxddddxkOOOkdddodxkkl               
               oOOO000Okkk0K0OkkOOOOkO00kxxkO000000OOkdoolxkO000OOOkxddxkOkxxkkxdxxkOOxdddkOOkl               
               oOO00000OkkkkkkxkO000OkkkkxxkO000000Oxo:;:loxkO00OOOOxddxkkxxkOOkxxxxxxxdxkOOOkl               
               o0000000kkkkkO0OkO00OkkOkxxxkO000000koc:;,:loxOO0OO0OxxdxxxkxxkOkkxkxddddxOOOOko               
               o000K000OkkOkkOOkkkkkO00OkxxxkOO000Odl:;;;;lodkO00OOkxdddxOOOkxxxdxkxdxxdkOOOOOo               
               o000KK0OkkO0OkkkO00OO0000kxxxkkkOOOxlc:;;:::cldxkOOkxxxxxxOOOOkkkxxddxOkxkOOOOOo               
               oO000OkkkkOOOOkkO0K0OO00Oxxxkkkkxxxoc:;::c::c:ldxxxxxkkxxkOOOkOOOkxxkOOOkxxkkOOo               
               lOOOkkkkkkkkkkkxkO000O00OxxxxkOOOOdl;;;:c:::c;:odkkkxxxddxOOOkOOkxxdxxxxxxdddkOo               
               lxxkO00OOO00OkOOkkO00OO0OxxxkOOOOkoc;;;:::;:::codxkkkxdddxkOkkOOxxkxxkOOkkkkkxxl               
               lxxxO00OOO00OkOOOkkkkkkkxxxxO0OOxo:;;;;::;;,;:coodxkkkxdddxxxxkxxkOkxkOOOOOOOkxc               
               lxdxO0OOO00OkkkkkxxxxkOOkxxxkkkxdl:;;;;:;,,,;;cloddxkxdooodxkddddxkkxxkOOOOOOkxc               
               okdkOOOOO00OkkkkkxxxxkOOkxxxxxxxdl;;;;;;,,,,,;clldddddddodxkkddodxxxddxOOOOOOOkc               
               oxxkkkxxxxxxkOOOOxxxxkOOkdddxxxxdl:;;;;,,,,;:;;:clodddddodxkkdoodxkkxddxxxxkOOkc               
               lxdddddxxdxkO0OOxxkkxxOOkdddxkxdol:;;;,,,,;::;;,..'lxxddodxkxoddddkkkkxdddddxxxc               
               cdoddxkxkxxkOOOkxxkkxxkOkdddxxdddoc:;;,'',;:;,'....'oddoodxxdodxxdxkkkkddxxxxxdc               
               cddxkOkkkxddkkkxdkkkxkkkxddddddddol:;;;;,,;;,'.,'...'loooodddodxkxxkkkxodxxxxxxc               
               cddxkOkkkddddxxxxkkxxkxxxdddddooodoc;;;;;,;;'...;,...'ooooddddodkxxxkxdddxxxxxxc               
               cdddxkkxddxxdoddxxxkkkxddddddddxxddoc'.',........,;...'looddddddddddddxxddddxxdc               
               lxxxdddddxxxxdooddkkkkxddoooodxkkxddd:.............'..;coddddxxxdooodxkkkddddddc               
               cdxxxdodddxxxxoodxxxxxkxoooddxkkxxxddd,...............',cddxxxxxddoodxxxxxdddddc               
               cxxxxdoddxxkkkdoddddxxxdddoodxkkkkxddd;................';odxxxxxdddddxxxxdddddxc               
               cxxxddddxxkkkkddooddddddddooodxxxxdddd,................,,cooddxddddddxxxxxddddxc               
               cdddddddxxxxkxddxdddddddddddddddoodddd;................;',loddoooddddddddxxdddxc               
               :dddddddxxxxxxddxddddddddddddddoddxdddc........  ........'cdddodddddddddddxdddxc               
               :doodddddddddddddddddddddddddddddddddo;....        ....''.,odddddddddddddddddddc               
               :dooodddddddddddddddddddddddddddddoool.........''......:lccoddddddddddxxxxdddddc               
               :ooooddddddddddddddddooooooddoooooooo;.......;odo'.....;ooooooooodddddddddddddd:               
               :ooooddddddddddddddddoooooodooooooool'......,oddd;.....:ddolllooodddddddddddddd:               
               :oooodddddddddddddddoooooooddoooooll:......'oddddl.....:ddolllloddddddddddddddd:               
               :oooodddddddddddddddoooooooddoooolll;......cdddddo.....;ddolllloddddddddddddddd:               
               cdodddddddxkOkxxxxxxxkxxkkddxkkkkxxdddooddddddddxkOOOkdddddxkkkxxxdddddddddddddc               
               cdodddddxkOOOkkOOkkkkkxxxxdddxxdddxxddxkkkkxdddxdddxxxddoddddddddxxxdxxxddoddddc               
               :ddddxxkkOOOOxO00O00000OxxxxxxkkkxddxxkkOOOkxddddddxxddoodxkkkkkkOOkxkOOxdoddddc               
               :ddddkO000OkxkO0O0000000kxxxxkOOOOxxkOOOOOOOOOxdxkkkxdooodkOOOOOOOOkdxxkkxxddddc               
               :ddxxkkO0OkkO00000000OkkxxxxkkkkkkkxxkOOOOO0OOkxkkkkxdddddxkkkOkkOOOkxdxkkkxdddc               
               :xkOOOkxkkkkO0000OOOkxkkOkxxkkxxkOkkxxxOOOOOkxxkkkxxxkxddxxdddxkkkOOOkxxxxddddxc               
               ckOO00OkkkkO0K00kkkkxxk00kxxkkkO000OkxxkkkkkxkkOOOOkxxxddkkkxddddxkOOOkdddodxkkl               
               oOOO000Okkk0K0OkkOOOOkO00kxxkO00000OOkxoclldkOO00OOOkxddxkOkxxkkxdxxkOOxdddkOOkl               
               oOOO0000OkkkkkkxkO000OkkkkxxkO000000Oxl:;,:oxkO00OOOOxddxkkxxkOOkxxxxxxxdxkOOOkl               
               o0O00000kkkkkO0OkO00OkkOkxxxkO000000koc:;;;ldxOOOOO0OxxdxxkkxxkOkkxkxddddxOOOOko               
               o000K000OkkOkkOOkkkkkO00OkxxxkOO000Odc::;:;clokOOOOOkxddxxOOOkxxxdxkxdxxdkOOOOOo               
               o000KK0OkkO0OkkkO00OO0000kxxxkkkO0Oklc:::c::ccdkOOOkxxxxxkOOOOkkkxxddxOkxkOOOOOo               
               oO000OkkkkOOOOkkO0K0OO00Oxxxkkkxkxxdc:;::cccccoxxxxxxkkxxkOOOkOOOkxxkOOOkxxkkOOo               
               lOOOkkkkkkkkkkkxkO000O00OxxxxkOOOOdl:;;:::::ccodxkkkxxxddxOOOkOOkxxdxxxxxxdddkOo               
               lxxkO00OOO00OkOOkkO00OO0OxxxkOOOOkoc;;;:::::ccldxkkOkxdddxkOkkOOxxkxxkOOkkkkkxxl               
               lxxxO00OOO00OkOOOkkkkkkkxxxxO00Oxo:;;;;::;;;::loddxkkkxdddxxxxkxxkOkxkOOOOOOOkxc               
               lxdxO0OOO00OkkkkkxxxxkOOkxxxkkkxdl;,,;;:;,,;::codddxkxdooodxkddddxkkxxkOOOOOOkxc               
               okdkOOOOO00OkkkkkxxxxkOOkxxxxxxxdl;,,;;;,,,;;::cldddddddodxkkddodxxxddxOOOOOOOkc               
               oxxkkkxxxxxxkOOOOxxxxkOOkdddxxxxdl;,,,;,,',;:::::codddddodxkkdoodxkkxddxxxxkOOkc               
               lxdddddxxdxkO0OOxxkkxxOOkdddxkxddl;,,,,,,,,;;,''',:oxxddodxkxoddddkkkkxdddddxxxc               
               cdoddxkxkxxkOOOkxxkkxxkOkdddxxdddl:;;,,,,,,,'.':..,;oddoodxxdodxxdxkkkkddxxxxxdc               
               cddxkOkkkxddkkkxdkkkxkkkxddddddodoc;;;,,,,''..'d;...'ooooodddodxkxxkkkxodxxxxxxc               
               cddxkOkkkddddxxxxkkxxkxxxdddddooodoc;;,,,......co:...,ooooddddodkxxxkxdddxxxxxxc               
               cdddxkkxddxxdoddxxxkkkxddddddddxxddo,''........'cdc...:oooddddddddddddxxddddxxdc               
               lxxxdddddxxxxdooddkkkkxddoooodxkkxddc............,ol,':loddddxxxdooodxkkkddddddc               
               cdxxxdddddxxxxoodxxxxxkxoooddxkkxxxdo'............'ll,,;lddxxxxxddoodxxxxxdddddc               
               cxxxxdoddxxkkkdoddddxxxdddoodxkkkkxdd'.............'ol;,:odxxxxxdddddxxxxdddddxc               
               cxxxddddxxkkkkddooddddddddooodxxxxddo'..............,oo:,:odddxxdddddxxxxxddddxc               
               cdddddddxxxxkxddxddddddddddoddddooddd'...............lodc,coddoooddddddddxxdddxc               
               :dddddddxxxxxxddxddddddddddddddoddddo'....... .......:odc,,lddodddddddddddxdddxc               
               :dddddddddddddddddddddddddddddddddddc......      ....:oo:,.,lddddddddddddddddddc               
               :doooddddddddddddddddddddddddddddddo,...... .... ....:ddol::ldddddddddxxxxdddddc               
               :ooooddddddddddddddddooooooddooooooc........;lo'.....:dxdoooooooodddddxxddddddd:               
               :ooooddddddddddddddddoooooodooooooo:.......,oddc.....;ddddolloooodddddddddddddd:               
               :oooodddddddddddddddoooooooddoooool'.......ldddd,....,ddddolllloddddddddddddddd:               
               :oooodddddddddddddddoooooooddooooll.......:odddd:....,dxddolllloddddddddddddddd:               
               cdodddddddxkOkxxxxxxxkxxkkddxkkkkxxdddooddddddddxkOOOkdddddxkkkxxxdddddddddddddc               
               cdodddddxkOOOkkOOkkkkkxxxxdddxxdddxxddxkkkkxdddxdddxxxddoddddddddxxxdxxxddoddddc               
               :ddddxxkkOOOOxO00O00000OxxxxxxkkkxddxxkkOOOkxddddddxxddoodxkkkkkkOOkxkOOxdoddddc               
               :ddddkO000OkxkO0O0000000kxxxxkOOOOxxkOOOOOOOOkxdxkkkxdooodkOOOOOOOOkdxxkkxxddddc               
               :ddxxkkO0OkkO00000000OkkxxxxkkkkkkkxxkOOOOOOOkxxkkkkxdddddxkkkOkkOOOkxdxkkkxdddc               
               :xkOOOkxkkkkO0000OOOkxkkOkxxkkxxkOkkxxkOOOOOkxxkkkxxxkxddxxdddxkkkOOOkxxxxddddxc               
               ckOO00OkkkkO0K00kkkkxxk00kxxkkkO000OkxxkkkkkxkkOOOOkxxxddkkkxddddxkOOOkdddodxkkl               
               oOOO000Okkk0K0OkkOOOOkO00kxxkO00000OOkxoclldkOO00OOOkxddxkOkxxkkxdxxkOOxdddkOOkl               
               oOOO0000OkkkkkkxkO000OkkkkxxkO000000Oxl:;,coxkO00OOOOxddxkkxxkOOkxxxxxxxdxkOOOkl               
               o0O00000kkkkkO0OkO00OkkOkxxxkO000000klc:;,;lodkOOOO0OxxdxxkkxxkOkkxkxddddxOOOOko               
               o000K000OkkOkkOOkkkkkO00OkxxxkOO000Ooc::;;;:llxOOOOOkxddxxOOOkxxxdxkxdxxdkOOOOOo               
               o000KK0OkkO0OkkkO00OO0000kxxxkkkO0Oxl::::c::ccokOOOkxxxxxkOOOOkkkxxddxOkxkOOOOOo               
               oO000OkkkkOOOOkkO0K0OO00Oxxxkkkxkxxoc::::cc:cccddxxxxkkxxkOOOkOOOkxxkOOOkxxkkOOo               
               lOOOkkkkkkkkkkkxkO000O00OxxxxkOO0koc:::::lc::ccloxkkxxxddxOOOkOOkxxdxxxxxxdddkOo               
               lxxkO00OOO00OkOOkkO00OO0OxxxkOOOklc:;;:::c:;:::clxkkkxdddxkOkkOOxxkxxkOOkkkkkxxl               
               lxxxO00OOO00OkOOOkkkkkkkxxxxkOOl:c:;;;;::::;;::ccodkkkxdddxxxxkxxkOkxkOOOOOOOkxc               
               lxdxO0OOO00OkkkkkxxxxkOOkxxxxx:''',,,;;::::;;:::cldxkxdooodxkddddxkkxxkOOOOOOkxc               
               okdkOOOOO00OkkkkkxxxxkOOkxxxo,...,,,,,;;;;;;;::::clodddoodxkkddodxxxddxOOOOOOOkc               
               oxxkkkxxxxxxkOOOOxxxxkOOkddl'...:l;,,,,;;,,;;:::;,,:ldddodxkkdoodxkkxddxxxxkOOkc               
               lxdddddxxdxkO0OOxxkkxxOOkdo:'..,::;,,,,;;,,;;;,','.,:odoodxkxoddddkkkkxdddddxxxc               
               cdoddxkxkxxkOOOkxxkkxxkOkdo:;,';:c:;,,,,,,,,,'..cc...;ooodxxdodxxdxkkkkddxxxxxdc               
               cddxkOkkkxddkkkxdkkkxkkkxdddooooodo:,,,,,,,,'..'ld:...:ooodddodxkxxkkkxodxxxxxxc               
               cddxkOkkkddddxxxxkkxxkxxxdddddoodddl;,;,;,'....;ddd,...cooddddodkxxxkxdddxxxxxxc               
               cdddxkkxddxxdoddxxxkkkxddddddddxxddo'.','......:dddd:',codddddddddddddxxddddxxdc               
               lxxxdddddxxxxdooddkkkkxddoooodxkxxdc...........:ddddd:,:lddddxxxdooodxkkkddddddc               
               cdxxxddddddxxxoodxxxxxkxoooddxxxxxx,...........'lddddo;,:ldxxxxxddoodxxxxxdddddc               
               cxxxxdoddxxkkkdoddddxxxdddoodxxxxxc.............:dddddo;;cdxxxxxdddddxxxxdddddxc               
               cxxxddddxxkkkkddooddddddddooodxxxd,.............;ddddddl;:odddxxdddddxxxxxddddxc               
               cdddddddxxxxkxddxddddddddddoddddd:..............'oddddddc,coddoooddddddddxxdddxc               
               :dddddddxxxxxxddxdddddddddddddddl'...............;dddddo:,;odoodddddddddddxdddxc               
               :dddddddddddddddddddddddddddddddc................'lddddl;'':dddddddddddddddddddc               
               :dooodddddddddddddddddddddddddol,.......... ......:ddddoc;,;odddddddddxxxxdddddc               
               :ooooddddddddddddddddoooooodoool'......',''.......'oddddolllooooodddddxxddddddd:               
               :ooooddddddddddddddddoooooodoooc......,llllc.......cddddddooloooodddddddddddddd:               
               :oooodddddddddddddddoooooooddoo:......clllloc......;xdddddolllloddddddddddddddd:               
               :oooodddddddddddddddoooooooddol;.....;llllloo:.....;ddddddolllloddddddddddddddd:               
               cdodddddddxkOkxxxxxxxkxxkkddxkkkkxxdddooddddddddxkOOOkdddddxkkkxxxdddddddddddddc               
               cdodddddxkOOOkkOOkkkkkxxxxdddxxdddxxddxkkkkxdddxdddxxxddoddddddddxxxdxxxddoddddc               
               :ddddxxkkOOOOxO00O00000OxxxxxxkkkxddxxkkOOOkxddddddxxddoodxkkkkkkOOkxkOOxdoodddc               
               :ddddkO000OkxkO0O0000000kxxxxkOOOOxxkOOOOOOOOkxdxkkkxdooodkOOOOOOOOkdxxkkxxddddc               
               :ddxxkkO0OkkO00000000OkkxxxxkkkkkkkxxkOOOOOOOkxxkkkkxdddddxkkkOkkOOOkxdxkkkxdddc               
               :xkOOOkxkkkkO0000OOOkxkkOkxxkkxxkOkkxxkOOOOOkxxkkkxxxkxddxxdddxkkkOOOkxxxxddddxc               
               ckOO00OkkkkO0K00kkkkxxk00kxxkkkO000OkxxkkkkkxkkOOOOkxxxddkkkxddddxkOOOkdddodxkkl               
               oOOO000Okkk0K0OkkOOOOkO00kxxkO00000OOkxlclldkkO00OOOkxddxkOkxxkkxdxxkOOxdddkOOkl               
               oOOO0000OkkkkkkxkO000OkkkkxxkO000000Oxl:,,:odkO00OOOOxddxkkxxkOOkxxxxxxxdxkOOOkl               
               o0O00000kkkkkO0OkO00OkkOkxxxkO000000klc:;;;loxOOOOO0OxxdxxkkxxkOkkxkxddddxOOOOko               
               o000K000OkkOkkOOkkkkkO00OkxxxkOO000Ooc::;:::llxOO0OOkxddxxOOOkxxxdxkxdxxdkOOOOOo               
               o000KK0OkkO0OkkkO00OO0000kxxxkkkO0Oxl:::;cc:cclxkOOkxxxxxkOOOOkkkxxddxOkxkOOOOOo               
               oO000OkkkkOOOOkkO0K0OO00Oxxxkkkkxxxdl::::clccccodxxxxkkxxkOOOkOOOkxxkOOOkxxkkOOo               
               lOOOkkkkkkkkkkkxkO000O00OxxxxkOOOkdlc::::cccccccoxkkxxxddxOOOkOOkxxdxxxxxxdddkOo               
               lxxkO00OOO00OkOOkkO00OO0OxxxkOOko;;:;;:::ccc::::ldkkkxdddxkOkkOOxxkxxkOOkkkkkxxl               
               lxxxO00OOO00OkOOOkkkkkkkxxxxkOk;..';;;:;:cc:::::cldxkkxdddxxxxkxxkOkxkOOOOOOOkxc               
               lxdxO0OOO00OkkkkkxxxxkOOkxxxxl,....',;;;:cc::::::codxxdooodxkddddxkkxxkOOOOOOkxc               
               okdkOOOOO00OkkkkkxxxxkOOkxxo,....,:;,,,;::::;:::::coddddodxkkddodxxxddxOOOOOOOkc               
               oxxkkkxxxxxxkOOOOxxxxkOOkdd:'...clc;,,,;:::::::::;,:coddodxkkdoodxkkxddxxxxkOOkc               
               lxdddddxxdxkO0OOxxkkxxOOkdl:;,',;;;;;,,;:::;;:::;'..,cddodxkxoddddkkkkxdddddxxxc               
               cdoddxkxkxxkOOOkxxkkxxkOkddoooooooolc;;;:::;::;;';;...coodxxdodxxdxkkkkddxxxxxdc               
               cddxkOkkkxddkkkxdkkkxkkkxddddddodddoc;;;;:::;,''.ld'..'loodddodxkxxkkkxodxxxxxxc               
               cddxkkkkkddddxxxxkkxxkxxxdddddooddddc;;;;;;;,...,ddl'.'cooddddodkxxxkxdddxxxxxxc               
               cdddxkkxddxxdoddxxxkkkxddddddddxdddo,..........'ldddo;;codddddddddddddxxddddxxdc               
               lxxxdddddxxxxdooddkkkkxdooooodxxxxo,...........;dddddc,:oddddxxxdooodxkkkddddddc               
               cdxxxddddddxxxoodxxxxxkxoooddxxxxd,............:dddddo:;cdddxxxxddoodxxxxxdddddc               
               cxxxxdoddxxkkkdoddddxxxdddoodxxxd;.............;ddddddl;:odxxxxxdddddxxxxdddddxc               
               cxxxddddxxkkkkddooddddddddoooddx:..............:dddddddc,lddddxddddddxxxxxddddxc               
               cdddddddxxxxkxddxddddddddddoddol...............:dddddddl,cddddoooddddddddxxdddxc               
               :dddddddxxxxxxddxdddddddddddddd:...............;ddddddo:,:ddddodddddddddddxdddxc               
               :dddddddddddddddddddddddddddddo'................cddddo:,',cddddddddddddddddddddc               
               :doooddddddddddddddddddddddddoo'........ .......'odddol:;;cdddddddddddxxxxdddddc               
               :ooooddddddddddddddddoooooodool'.....'c:;........cdddddollooooooddddddxxddddddd:               
               :ooooddddddddddddddddoooooodool......:lllc.......,ddddddddooloooddddddddddddddd:               
               :oooodddddddddddddddooooooodooc.....'lllll:.......cdddddddolllloddddddddddddddd:               
               :oooodddddddddddddddoooooooddoc.....;llllll;......cdddddddolllloddddddddddddddd:               
               '::::::;...',:x00OdoooloooloolloolllolllllllllloodxxdooodxkkOk0O0KKKOXXXKdllx0Xk               
               '::::::;...',:dO0kxooolllllllllllollllllllllllllloooooooddxkxkxkO00K0KKX0dllx00x               
               '::::::;...,,:ok00koooolloolllllloolllllllllllllllllllllodoolddxddx000OxdolokOkd               
               '::::::;...'';ldOOkxoolooddollllloddoolooooodoollccllllloddoldxxxxkOO0OOxoloOXXk               
               '::::::;..''';cldxkxdooodxxdodooloooollllloddooolllllooddddkOkOkOOO0OkO0kooxKNXk               
               '::::::;...',;:cokOkollcldxoloolclllllllllodxddoollllodxxxkkO00000000KKKxookXXKx               
               '::::::,...'';ccloxkdllcllllllllllllllodoccllllloollloddxkOOk0KKKK0XXXX0oloOXXKx               
               '::::::;..''':cclodkxdolllllclllllllll::,,;,'....,:cllodxkO0000KKKKKK000oooOXXXk               
               '::::::;'..,;:ccoxddxdollllccllllllllc;,,,,'.......',cdxxxk0KK0OKXXK00K0oookXNNk               
               '::::::;..',,cloxxxdddlllcclllllllllo:'..''..........'oxkOO0K0KX0KKKXXKkood0XXKk               
               '::::::;.''',:clxxxxolllcccllllllllll:;,,;;'..........cdk000OKXKX00XXXXxloxKXXKk               
               ':::::::'..,;:cldddolccccllllodoloooodkxxkxl:'........;dk00KKK00KXXKKKKxood0XNNk               
               '::::::,..',,:ccooooolllcccloxxddoddodOOkxol:,........,oxk0KKK0KKKXXOO0xooxKNXNk               
               '::::::,..'',:ccllodxxollcllldddddxl:cll::c;'.........,ldkOO0KXKKK00OkkdooOXXXKk               
               'c:::::,...,,:ccclloxkdlllllllooodxl'.,'.',;;;,'..',,.;codxOOKKXK00OkxdoooOXXKKk               
               'cc::::'...',:::cccldxdlllcllllllloo::dl;;;cc:;;;;,;;,cloodk00kOKKOkxoolooOKXNXx               
               'cc::::'..'',:::c:ccoxdolccllccllllolollcllcc::::::;,cooolodxkkkO0Okdoooood0XXXk               
               '::::::'...,,:::::cloxxdollllllclllllloocccllc:::::,:dooolllldxxdxkkkxdoldkOOKXk               
               '::::;;...'',::::::codddolllcllcclllllodllllllccc:::codollllloooddxkOkollodxOO0k               
               '::::::...'',::::::coollllcllccllllollldxoooollcc:;,;loollllloooxkkxxxdoooodx0Xx               
               ':::::;...',;::::::clolccllllllllllooolloloodolllc;,;;:cllllllodxxxkkxoooddddxOx               
               ':::::;...',;:::::::cclcclllllllooooddoooxOdoollc:::;;,,;:ccllodddO00xoldOOxxxko               
               ':::::;...',;:::::::cccclllooloddooodxkOKK0Odolcccc::;;;;;;::lodxkk00xoldKK0kxOd               
               ':::::;...',;:::::::cccccllooodxxooxOKKKKKK0dlcccc:::;;:::clddddxO00OdookKKXXKKx               
               ';::::,..'',;:::::::cccccllooxxxOkxOKKKKKKKxxxc::::cc:::cokO000OxxkOOoooOK0XNNNx               
               '::::;,..'',;:::::::ccclcclldxkkkOkO000KKKO000kdlcclol:cckO00OkdollO0dloONNXKXXx               
               ';:::;'...',::::::::cccccclodkOkxOkk00KKKKKK0000xddxOkdxook0kdxlclllkoloONNNX0Xk               
               ';::::'..'',::::::::cccccllodkOkdkkk0KKKKKKKKK00000KK00KkkK0doxoccdcclod0KXXNXXx               
               ';:::;...'',::::::::ccccccllodkkdkxO0KKKKKKKKKKKK00KKKKKkk00odkdc:ol::lxKK0XNNNk               
               ';;;;;...',,::::::::ccccccclloxxxdd0KKKKKKKKKKKKKKKKKKK0Ok00oxOd:clo::;oKXXXXXXk               
               ';;;;;...',,::::::::cccccllcclodddo0KKKKKKKKKKK00KKKKK00OOOOokOd::loc::cONXNX0Xk               
               ';;;;;...',,::::::::ccccccccclloodd0KKKKKK0KKKKKKKKKK000OOkdlkOd::col:::cOXXXXXk               
               ';;;;;...',;::::::::::clccclccllloO0KKKK0K0K0O0KKKK0000OkxollkOdc:cloccc:oONNNNk               
               ';;;;,..''';:::::::::cccccclccllllOKKKK0O0000k0KKKK000OkxocclkOxc:coolcc:l00XXXx               
               ';;;;,..''';::::ccccccccccccclccllk0000O00000kOKKKK00OOkdlc:oxOxl:clolccccOXK0Kk               
               ';;;;,''..,;::::ccccccccccccclccllkKK00KK0000xOKOkkkOOOxolccoxOxl:clolllcckN00Xk               
               ':::::;..'',lOOkollooloolllllllllllllllllllllloooooooddxkkkO00OO0KKKK0X0oloxXNNO               
               ':::::;...''ckOkollllooolllclolllolllollllllllllllllloodxxkOOOOk0KKK00K0llokKKXx               
               ':::::;...,,cxOkdollloooollllllllolllllllllllllllllllloodxxdodxkkxxOKK0kold0KKko               
               ':::::,...'':xkxdooooodxdoooolooooodolodoooodllllllooolloddocldxxxkO0K0xllxKXXXk               
               '::::;,..''';lxkxddoooxxxdoooooloooollllooooooolloddddxxxdoodxxddkO0OOkxookKKKXk               
               ':::::;...',;loxkxolclodxollllllllllllllloddddooooddxxkkxdddxkkOOO000K0dooOXXXXx               
               ':::::;..''';ldxxxdolcclolllllllllllllloollccc:::cloxkxxxkOkxk0KKKk0XX0ooo0XXXXx               
               ':::c:;..'',:odxxxxdolcccllllllllllllll:;,;;,'.....,ldxxkOOOO00K0KKKK0Oood0KXXXk               
               ':::cc:,..,;coxxddxdolclcllccllcloolllc;,,',..'......'cxkkk0KKKO0KKK0Okood00KXXk               
               '::::c:..,,,:lxkxddoolcllllllllllooolc;'..''...........lkO0000KK0000KKkolxKNNXKx               
               ':::::;..'',:lxkxdolllcllllllllllllool:;,;:;'..........;xO00O0KKK0O0KKxooxXNNXKx               
               '::::::,..,;:coddddolllcclllodoooooooddkxxkdl:,'.......'xO0KKK000OOO00dookKXXXXk               
               '::::c;..'',:clddddxxlccclloddddddooddxkOkxdo:,'........oxOKKK0kOOkxkdood0KKXXNk               
               ':::::,..',,:ccloxkkxollccllodddddoollcloccc;'..........okO0O000OxdooolodOXNNXXx               
               ':::::,...,,:cccloxkxdlcccclllooodol:..',.',;:;;,'',;;.'oxkkkO00OxdooooodOXXXXXd               
               ':::::,..'',::::cldddlcccccccllllllll:;od:;,:lc:;;;,;;';lodkkkxxkkxdooooxO0KKXNk               
               ':::::'..'',::::ccoddollcccccclllllllloollclcc:::::::,;lllodxdddxOkxxooodkO0XXNk               
               ':::::'..',;::::ccoxxdolllcccllclllllllllllcllccc:::;,cllllolodxxxxkxooooxO0KKXk               
               '::::;...'',:::::coddoollllcllcccllllllllollllllcc:::;clllllodxxxxkkxdooodxk0KKx               
               '::::;...',,::::ccoollllllllllllloooollloxdlloollcc:;,;:cllodxxdkOOkdoooddddO0Xk               
               '::::;...',;:::::clolclllllllllloddddollloooooolllc:;,;;;:clodxxkO0OdlldkkxdkOKk               
               '::::;...'';::::::ccccclloolooooodddddolloxOkdoollc:::;;;,;;cox00OO0xlldO0OOOO0x               
               '::::;...,';::::::ccccclooddoodddddddoodk0KKKxlllcccc:;;;;;;;;:lxk00dlld0KKKK0Ox               
               '::::;...',;::::::::cccclodddxxxdddddx0KKKKKKOolccc:::::;::cldkkkOOOoloONKKXXXNk               
               ';:cc;...,,;::::::ccccccloddxxkkkxxxkKKKKKKKKxxoc::::cc:::cdx0K00Oxdlll0XXKKXNNk               
               ';:cc;..'',:::::::::cccllodxkkk0OkxkO000KKKKO00OxooccllcccdkO00OxxlllllkKXNNXXXk               
               ';:::,...',:::::::::cccclodxOxxkOOkkk00KKKKKKK000OxdxkOOooddk0Kxddlcodlx0XNNNXKk               
               ';:::'..'',:::::::::cccclooxOkdxOOOkxO0KKKKKKKK0000000KK0KOxOK0oddo:ldcoKXXXXXXk               
               ';:;;...'',:::::::::ccclllldxxodxkOkk0KKKKKKKKKKK0000KKKKKOk0KOlxko:ldl:lO0KNNNk               
               ';;;;...',,:::::::::ccclllllddooddxdOKKKKKKKKKKKK0000KKKK0OkO0klxko:coo::lKXKKNk               
               ';;;;...',,:::::::::ccclolllodoooldoOKKKKKKK0K0000000KKKK00OO0kckko:clocc:oKXK0x               
               ';;;;...',,:::::::::ccccllllooolllookKKKKKKK0KK00000KKKKK0OOkxlckko:clol:ccxKXXk               
               ';;;;...',;:::::::::cccccclllloollookKKKKK00000OO00KKKK00Okxdlclkko::looccclOXNk               
               ';;;;...'';::::::::::ccccccccclllcoxOKKKK0O0O00kkKKKK0000Okdlc:oxOd::looccccdXXk               
               ';;;,..''';::::ccccccccccccccllclllxO000OkO0O00kk0K000000OxocccoxOd::loolcccl00x               
               ';;;,...',;::::clcccccclcccccccclllxOKKK00K0O00kk00kkxxkkxolcccoxOdc:lodolcclx0x               
               ':::,.''',lolllcloddolllllllllllllllllllllloollllloddxOOOOO0KK0O0KKK0dlld0X0XXXx               
               ':::,...',lolllllodddllollllllllolllllllloooooolloooodxkkxkO000OOKKK0dlld0KXKKKx               
               ':::,. .,,ldollloodddolllllloollllllllllllloooodoooooolloddoodkkkkxOkollok0K0K0o               
               ':::,..'',lddooooddxddoooooooooooooooooddoodoooddodxxdooddxxxkkOOO00kolokXXKKKXk               
               ':::,...',cdxdllllloxolllllllllllllloodddddooodxxkkkxdxkkkxO000OkOO0kooo0NXKKKXk               
               ':cc,...',cdxdolllcllllclllllllllllllodddddoodddddxkxkkkkO0O000000OOdlodOKXXNXXx               
               'cll,..'',codxdolcllcclccclllllllllllloooc:;;;''..';okkkO00KOOKKKKOOdolx00KXXXXx               
               'clo:...',lddxxdolcclllcllllllolllllllol:;;,;,''.....';cxO00KK0000K0dolxXXXK0XXx               
               ':cc;...,;oxxddoolccllcclllllloooolllll:,'.'............,kO0KK0O0KXKdolkXXXKKXXk               
               ':::,..'',oxxooolllllllllllllloooooolll:''''.............xK0OO00K0OOoooOKKXNNXXd               
               ':::,...';oddollllcclllloooloooooddolllllcldoc;,,'.......:OOkOOOOOOxoooOKKNNNXKd               
               ':::,...,;lddoddolcclllldddddoooodxxoollkOOxdol:;''......'xOOOxdxkkxood0NNXKXXXk               
               ':::'..'',clodxkkollcclloodddddooodxdollxkxddo:;,.........dOkxdooodoood0XXXKXXNk               
               '::;,..',;:cldxkxollcclllloodddolloddl;,;;'',,'''....''..'dkdxxdolooook0KKXNNXXx               
               ':::,...,,:ccloxdlcclcccllllooolllloolc',l,,,:ol:;,,;;;,.;dxxxxxddooookK0KXNXKXx               
               ':::'..,',::ccoddolccccclcclllllllllllllddo:::cc:::::;;,,cdxkkkxkkdloox0XNKKXXNk               
               ':::'..',,::cclddollcclllccccclllllllllloolclllc::::::,':odxxkxkkkdooodkKXXKXXNk               
               '::;'..';;:::coddollllllllcccclllllllllllolccllllcc:::;;ldxxdkkOOkoooodxk0XNNXKx               
               '::;..',';::cclllllllllcllllllllllllllllloddooolllccc:;,:dkOOOOOOOdlloodk0XXXXKx               
               '::;...,,;::::clcccclllllllllloddoollllllooddoooollcc:,,;:lxO0kxOOoolokkkOO0KXXk               
               '::;...',;::::ccccccllllllloooddxxdolllllooodxooollc:;;;;,,,;cdOKOoooxO0000OXXXk               
               '::;..',,;::::::ccccclllllooooddxxdoolllodkO00xloolc::::;;;;;,;;lolodOK00XXXNXKx               
               '::,..',,::::::::cccclllllooooddxxxdoloxOKKKKK0occcccc:::;;:::codkOkk0KXKKNNNXKx               
               '::,...';:::::::::cccllooooodddxxxxdodOKKK00KKKxllc:::::::::cok0KKK0OkOXNXXXXNNk               
               '::'..',,;::::::::cccloxdoodxxxxkkkxdx00000KKKOkkdlodlcccc:cox00K0kkoooxKXKKXXNk               
               ';:'..',;:::::::::cclodxkkxdxkkkkOOkxxO000KKKKO00Okkdldxxocokk0KKOddlcldo0NNXXXx               
               ';;....,;:::::::::clllox0OxoodxkO00OOdO00KKKKKK00000Oxk000kkOkOKKxoxoccdolKXNX0x               
               ';;...'';:::::::::clllodkOOxddxkkOOOOxO0KKKKKKK000000000KKKK0OO00dokxc:lo:cOXXNk               
               ';;...'',:::::::::clollldkOxdodddxkOOk0KKKKKKK00K0000000KKKK0OO00dlOxc:ldc:c0NNk               
               ';,...',;:::::::::ccollloxxxddoooodkxkKKKKKKKK00KK00000KKKK00OO00olOdc:col::c0Xx               
               ';,...',;:::::::::cccccclodxddollllxokKKKKKKKK0O0000000KKKK00OOOkclOxc:cooc::okd               
               ';,...'';:::::::::cccccccloddddolllddxKKKKKKKKOO0K00KKKKKKK00Okxl:oOxl:codccccxk               
               ';,...',;:::::::::cccccccclooddolllddxKKKKKK00Ok00O0KKKKK000Okxoccokkl:coolccclx               
               ';,...',;:::::::::ccccccccclllllllldxxKKK000O0Ok00k0KKKKK000Okdcccokko:codlccccl               
               ';'..''';:::cc::ccccccccccccclllllcoxx00000OO0Ok00kOK0OOOOOkxdlccloxkoccoddlccc:               
               ';''..',;:::cc::ccccccccccccccllllcoxxKK000KK0OkK0kOK0OOOkkxdolcclodkdccoddlccc;               
               ':'...',llllccloddllloolllolllllllllolclooollolloodooodxkkO00K0kKK0dlldOKXXKKKXx               
               ':,. .',llllccloddollollllollllllcllllllloooooolooooooddddkOOOO0O0Oollx0K0KKK0Oo               
               ':'...',loolclloddollolloloooollloooooooooddoxxdooooooooddxdlxkOOkdlllx0O0KXXK0d               
               ':'..'',coollllloddolloooooooooooooddddooooooxkkxxxxxkkOkOOOO0kOOKkoookXXXXXKKXk               
               ':'...',cooolccllldoccllccllllllollodddddddddxxxkkkkxk000Ok0000OOKkoooOKXXXXKKXk               
               ,:'...''coodolccllllllcclllllllllllodddooollc::::::cdOOO0000O00KK0dlld0X00XXNNXx               
               ;c'..'',:oodolccccccllcclllloollllllloolc:;,,;,,'....,:ox000O0KK0OollxKXKKKXXXXx               
               ,c,...',coodolclcclllclllllooooolllllolc:;,'''..'''.....'ck00K0O0Oolod0XXXXK0XXk               
               ':....',cllllllclllclllllllooooolllllllc;'.''.............oOOOOO0OolokKXXXXXXKXk               
               ':...'',clllllccllccllllooooloooooolllllc:;:c:,''.........cxdkOO0kold0XX0KNNNXKd               
               ':'...',cloooollccllllooooodoooxkdolllllokkkkdoc;,'.......,dddxkOdoodOKXXXXNNXXx               
               ':'...',codxkxdlllllloddddddoloxkxoollllokOkxdlc:,''......'oolloxdooxOKXNXXKXNNk               
               ':...'',cldkOkdollccllooooddooodxxdollc;:lccc:;'..........'llllloooox0KKXXKXXXNk               
               ';,...,;:cldxxdlccllcclllloooollodololc,','.',:::;,.',;;'.;ooooooolokKXK0XNNNXXd               
               ';...'',::clddlcccclccllccllllllllllloolldo:;;llc::;;;;;,,lxxxxxollokKKKKKXXXXXx               
               ';...,',::ccodlcllcclllclllllllllllllloddolcllcc:::::::,'ldkkkxxdlloxOXXNNX0XNNk               
               ';'..',;:cccodolllllllllllllllllllllllooooolccllcc::::;,:xkkxkOOdlloxO0XXXXXXXNk               
               ';...',;::ccllolllllcclllllllllllllllllooodoloooolccc::;ckOxxOO0xllldkOK0XNNNNKx               
               ';..',,;:::cccccllcclllllllooolllllllllloodxdoooollllc:,,lxOOkxxdllodxk0XXXNXXKx               
               ';...',;::ccccccllllllllllldxddollllllllloodxxdoolllc:;,;;;:ldxkolodxxO0KXX0KXXk               
               ';..',;::::cccccclllllloooodxxxdolloooooooxO0Kxooolcc::::;;;;;;cllok0K00KXXXXXXk               
               ',..,;,;::::ccccclllllloooodddddoollooodk0KKKK0occlcccc:;;;;;;;;:cokKXX00XNNNXKd               
               ',''',;:::::ccccccllllooooodddddoollodOKKKK0KKKOllccc::;::;;:clxkO00000XXXXNNXXx               
               ''..',;::::::cccccllodooooodddddoooodk000000KKKxoocccc:ccc::cokKKK0OkxxOXNKKXXNk               
               ''..,;,:cc:::cccccloxxxollodxkkxxdddkxO000KKKKO00Oxkkoodolccxx0KK0xxolloxKXXXXNk               
               ''..',;:::::::ccccooxOOOdlodkOOOOkxkOx000KKKKKK0000OkdkO0OxxkOO0KOoxolcdodXNNNKx               
               .....';:::::::::cllldkOOxdodxxkO00OOOx00KKKKKKKKK0000000000K0kO0KOoxdl:oocdKXX0x               
               ....',,:::::::::ccllodkOOxdddxxkOO0KOkKKKKKKKK00KKK00000KKKK0kk0Kklkko:ldc:o0XNO               
               ....'',:::::::::cclllldkkkxdoooddkO0xkKKKKKKKK00KKK0000KKKK00OOO0kckkl:col::lKNk               
               ....',;:::::::::::ccclodxxxdolllodxkdxKKKKKKKK0O0KK0000KKKK00OOO0dckko:clo:::dKd               
               ....',;:::::::::::ccccclodxxdllllllddx0KKKKKKK0O0KKKK00KKKK00OOOxc:kko:cldlcccxx               
               ....',;:::::::::cccccccclodddollllloxx0KKKKKK0OO0K00KKKKK000Okxdl:ckko::ldocccld               
               ....',;:::::::::cccccccclloooollllclkkKKKKKK0O0k00O0KKKKK000Okxoc:lxOdc:ldoccccl               
               ....',;:::::::::ccccccccccllllllllllxkK0000OkOOk00kOKKKK0000OkdlccodOdc:loocccc:               
               ....',;:::::::::ccccllccccllllllllllxxKK0000KKOk00kkK0OOOkkkxdlcclodkxlcloxllll;               
               ....'';:::::::::cccllllcccclcclllcllxx0K0000KKOkK0kk000000Okdolcclodkxlcloxllll;               
               .';,:lcccoddolldolclooolllllloolllllloooooodxkOOOO000K0Ok0KK000dllxKK0KXKXNXKXXd               
               ..'':lcccloddllloollllolllllllloollllooddddxkkOOOOOOOO00Okxx0K0dllx0KKOxOKXKKKOo               
               ..',clcccllddollooloooooooooooddddddoodxkxxxkOOOOO000O0000OO00xollk0KKKXXKKKXXXk               
                .',:cccccllolcllllllllllollooddddoolodxkOOOkO0000000KK0O0KKK0dlld0XO0XXXXKKXXNk               
                .',:cccccccccccllllllllllllloodddoooooxkkO0OOOOOOO00000000000dolo0KXXKKKKXNXXXk               
               ..'':ccccccclllcllllcllolloollloooolloodddoc;;,,',,,:lk0000OKOdlldKXXXXK0XXNXXXx               
                .',:ccccccclllllllllloooolllollllolllool:;,;;;',''....;lk00OOollkKKXKKXXKKXXXXx               
               ..,,:ccccccllllllccllllodollllllllolllll:,'..'...'''.....,d0KkollkKK0XXXXXKKXNNx               
               .'',:ccccllcclllllolllooooooolloolllllllc,''''............:OOklookKKXKKKKXXXXXXx               
               ..',:ccccccllcllllllodoloodddollllllllllodlodo:;,''.......,x0xlookKXXXX0KNNNXXXx               
                .',:clllccllccllllooooooodxddllllollllodOOkxdol:;,'......'xOdllo0KKXXXNNXXXXXXk               
               .''':lodollclolccloolloollodxdoolllllllookkxddoc:;,'.......oxolldKXKKXNNNXKKXNNk               
               .'',:lllollllllcllllllloolooddooollloo:',;;,;;;''.........'ldolld0XXXXKKXXNNXXXk               
               ..,,:cllllccccclccccllllooooooolloooool;,c,',;lcc:;'';;;'.;lllllx0KXXXKKXNNNXXKk               
               .'',;clllcccclclcllllllllloooolllooddddoddo:;:llcc:::;;;,,odlclokKKKKXXNNKKXXXXx               
               .',,;cllcclccllccllccllllllollllloodxxddolllollccc:cccc;,okxocldOKK0KXNNNX0XNNNk               
               ..,;:cclcclllllllcclllllllllllllloooddddooolclollcccc:;,lxxkdllok0KXXXXKXXNXXXXk               
               .,,,:cccccclllllllllllllollllllllloooodddddoooooollcc:::dkkkdllodkKXXXKKXNNNXKKk               
               .,,;:ccccccccllcclllllooooolllloooolloooodxkdoooooollc;,cdxxocloxkOOKXNNXXXXXNNk               
               .';::cccccclllllllllllodxdoolloddddooooodxkOOdooolllc:;;;:collloxkOO0KXXXK0XXXXk               
               .;,::cccccccclllllllllloddooolodxxxddodxO0KK0Ooooolc::::;;,;;:loxk0KXKXXXXNNXXXk               
               .;,;cccccccccllodolllllloooooooodxxkk0KKKKKKKKd:cllclcc:;;;;;;:cok0XXXKKXNNNX0Kk               
               .,;:cccccccccclddolllllloooooolooxxk0KKKKKKKKKxlocccc:;::;;::::ccldOKXXXXXXNXNNk               
               .,;:ccccccccccldxxollloodddoooooddxkO000KKKKK0xkxlllccc::::clxOK00OkkOXNNK0XNNNk               
               .,,;ccccccccccoxkkdlloodxxxxxxxxkkkkO00KKKKKKO000OOkokkkoccooOK0000kddkKKXNXXXNk               
               .,;:::ccccccclodkkxdoooxkkkOOOOOO00kO0KKKKKKKKK0000kO0000kkkdO000xkolloxXNNNNXKk               
               .,;:::cc:cccccloxOOxdoodxxkOO00000Ok0KKKKKKKKKKKKK0KK000000kdO0Kxdkoclxld0XXNNNk               
               .,,;:ccccccccclloxOkxxdooodkO0KKKKkxKKKKKKKKK0KKKKKKKKK0000koOK0odkdcldo:oKXNNNk               
               .,;::ccccccccccclodxkkxollloodkO0KxxKKKKKKKK00KKKKKKKKK0000OxkOOoxOxclodc:dKXXNk               
               .,;:::cccccccccccllodxxdllllllodxkxdKKKKKKKK0OKKKKKKKKK00000OkOOokOxclodc::kXKXk               
               .,;::::::cccccccccclodkxolllllllloxkKKKKKKKKOOKKKKKKKKKK0000OkxxdOOxccldl:clOXXk               
               .,;:::::::ccccccccccloddolllllllllx0KKKKKKK00O000KKKKKK0000OkxdolOOxcclodcccoKNO               
               .,;::::::::cccccccccclodoollllllllx0000000Ok0OOOO0KKKKK000OkdolcoOOxlclodlcc:dXx               
               .,;::::::ccccccccccclloooollllllllxO000000OO0O00O0KKKK0000OkxlccoO0xoclodollclKx               
               .,;::::::ccllcccllllllllllllllllllx0K0000KKKK000k0K0OOOkkkkxdlccdkOxoclodolllckx               
               .,;::::::ccllccclllllllllllcllllllx0K0000KKKK000kOK0000OOkdolccldkOkoclodolllcdd               
               'ccccoddollooolllolllloddddoolllllodxdxkkO00KKKKK0KKKKKK000klloO0KXK0KKKNXKK00Kx               
               '::ccooddooooooollooooodddddddoooodxkkkkkkO0Okk0000000K0Odkxllodk000OxkOKKKK00Kx               
               ':::cccoollllllllolooooododddddddddxkO0OOO00OO000K000KKK00Oollx0KKKKKKXXKKKXNNXk               
               ':::ccccccccclcclolllloooooodxdodddxkO00KK0O0KK0O0KK00000K0dloOXXXK0KXXXXKKXNNNk               
               'ccccccccccccclllllolloddooodddddoodxkO0K0OOOOOOOO0000000KkoloOKKKXXKKKKXNNXXXXk               
               ':ccccccccccccllllloolloddolooddoodoooxkdl:;,,',,,,cdO000kxlld000KXXKKKKXXNXXXXk               
               '::cccccllccclllloodoooooooolloooooooool:;,;;,''''...,coO0xlld0XKKKKKXXKXXXXNNXx               
               '::cccllllllclllllodddolllllllllllooool;'...'...''......cOdlcd0XXK0KXXXXKKKXNNXx               
               ':::ccllllllclllllloodolllllllllllloddl;''''............'ddlox00KXXXKKKXXNXXXXXk               
               ,ccccccllllllolllllloodollllllllllloddoddldxo:,,,'.......cllox00KXXXXK0XNNXXKXXk               
               ,llcccclollllolllollloddolllllloollooddkOOkxxdl:;,'......:lllkKXKKKKXXNXKKXXXXXk               
               ,llllllodooocllolllloodxxolllllllloooooxxkxddo::;''......;lllkKXKK0KXNXXKKXNNNNk               
               ,llllccloollccllllllooodxdolooooooool,',;;,;:;,..........;cloO00KXNXXKKXNNXXXXXk               
               ,clcccccllccllclllllooddoooooooooooodc',l,',,cc::;'',;;''ccld000KXXXXKKXNNXK0KXk               
               ,ccccccccccllcllllllloddoollloddooooododxo:;;clcc:::;;:,:llld0KXXKKXXXXXXXXXXNNk               
               ':cccclcccclccllcclllooooolllodddddoodddolloolccc::cc:,:lllldKKKXXKXNNNXKKXNNNNk               
               ':ccccllccccllllllllllllllllloodxxdooodddlcclolccc:c:;:dollox000KXNNXKXNNNXXKXNk               
               '::cccllcccclllllllllllllllllllodxddddddddooooollllc::okdllldkO0KXXXXKXXNNNXXXXk               
               ':cccclllcccccllllloollllolllllooooooddddxxddoooollc:,,oxllloxO0000XXXNXXXXXXXXk               
               '::ccclolllllllllooooolllloooooodoooddxxkOOkooooollc:;;;::llodk000KXXXXXKKXXXXXx               
               ':ccccloolllollloollooollllodddxddoodk00KKK0xoooolc::::;,,;:loxOKXXXXKKXNNNXXXXk               
               ':ccccllooooooooollloooolllodxxxxxxk0KKKKKKKOoclclccc::;;;;;;clxOXXXKKXNNNNXXXNk               
               ':ccccclllodoooddolloooooooooxkOkkO0KKK0KKKK0dllcccc:::;;::::::cok0XXNXXXXXNNNNk               
               '::cccccllodxdoxkxoooddddddodxkOOkO00KKKKKKKkdxlccc:::::::codkOOkkx0XNNXKXNNNNNk               
               'cc:cccccloxkxodxOkxkkkkkkkkkkkkOkk00KKKKKKOO00Okkdodddcccoxk00K0Oxdx0KXNNXXXXNk               
               '::cccccccldOkoodOOkkO0000000OOOOkk0KKKKKKKKKKK000dk000OddddkK00xkllloKNNNNKXNNk               
               '::ccccccclodkxdodkkkO0K0KKK00OOOk0KKKKKKKKKKKK00000000000kok00xdxlcooxKKXXXNNNk               
               ':ccccccccccoxxxdodxxxk00000KKK0kx0KKKKKKKK00KKKKK00000000xdOKOoxxocodcx0XNNNNXk               
               ':cccccccccccoddddoooodxddddk000xd0KKKKKKKK00KKKK00000000Okdk0klkkdcodlcOXXKXXXk               
               ':::cccccccccclooddoollolllloxkOkd0KKKKKKKKO0KKKK000000000OkkOxo0kocldoclOX0KNNk               
               ':::::ccccccccclodxkdollllllllddxd0KKKKKKKKOOKKKKKK00000000kkkxd0koclodccdKXXXNk               
               ':::::ccccccccccldxkkdoollllllldxOKKKKKKK00OO000KKKKKKK000Oxddlx0koclodlcckNNNXx               
               ':::::ccccccccccloxkkxdooolllllok0KKKKKKKOOOOOOO0KKKK000Okxdlccx0koclodoccoKXXXx               
               ':::::cccccccccclodxkxoollllllllkk00000OOk00O00O0KKKK000OOkocclx0koclodocccxKXXk               
               ':::::cccclllccclodxxdllllllllloxk0K0000KKK0000O0K0OOOOOOkdlccox0koclodolllxXXXk               
               ':::::cccllllcclllddxdolclllllloxk0K000KKKK000OxOK000Okkddolclox0kocloddlloxXXXk               
               :olcclclllllllllloooodooooodxxkOO00KXXKKXXKKKKKKKK00KkollOKKKXXKKKXKKXXKXX00KX0:               
               :ollcllllllolloooooooddddddxxkkO00KK00KKKK0KKK0000000xlllkOkO0KK00kx0KKKOxxkxxxc               
               ;cccccccclllllooodddodddddxxxxxkO00000KKK0000000O0000dcloO00KKKXXKKXKKXXXXXK0xo:               
               ;cccccccllllollllddoloxxxxxxxxxxk00KKKKKKKKKK000KKKO0xlldOKKKXXK0KXXXX0KNNXXK0xc               
               ,ccccclllooolllllooooodkkkkxdddodk00K0KKKKKK00KKK00K0dlld0KKKKKKKKKXXXXXXXXKXXKl               
               ,ccccclllooooollllooodxkOOOkxddodkO00OOOxollllloxO00OollkKKKOKXXXXK0XXNNXKKXNXOl               
               ,lllccllllodddolllooodOOOOOkkxddxkO0koc;;,,;,''.';oxxlllkKKKKKKKXKKXXXXXXXXXXX0d               
               ,lllllllllodddddoollodk00OOOOkkxkOOOl:;,,''''......';clldOKKKXK00XXNXXKKXNNNXKXk               
               ,clooolllllooddddollodxOOOkkOOOkkO0x;,''...'.........;loOK00KKKKKKXKXXNXXXXXXKkl               
               ,cllooooollllodddoolllodxxxxxkOOOO0kc:;;,,;;'........'coOKKKOKXXXX0KNNNNXKXNNXx:               
               ;oolloddolllloooddoollooooooodxkkOO00OOxdxkxl:,'.....'coO0KKXKKXXXXXXXXXXXXXXX0l               
               ;ddllooollllllodddoooooooooooooxxkkOOOOOOkxolc;''....'lx00KXXXKKKNNNXK0XNNNXKKXx               
               ;odoolllllllllodddddoooddooooooddddododxdoolc;'......'lx0KKKKXXXXXXXXXXXXXXXXXXk               
               ,loollclllclloddddooolodddoooodddol,'',;,,,,,,,,'.',,;lk0KK0KXXXXX0KXNNXX0XNNNXk               
               ,cccccllllllllodddoolloddddooooddddc,,:ol;,;;cc:;;;;:cok00KKXKXXXXXXXXXXXXXXXNXx               
               ;lccccllllllllooddolllloddxdoooddddollddoc:ccc::::::cld000KXXXK0XNNNNKKNNNNNKXNk               
               ;lcccccllllllllooollllllodxxdoooodoodddoccccllcccccclldO0KKKKXXXXXXXXXXXXXXXXNNk               
               ;lcccccclllllollllllllooodxxxdoooddddddoolcclolccc:llloxO0KKKXXXXXKXNNNNX0XNNNNk               
               ;lccccccclllllllllllllllooodddoooodddddxxdollllllc:;coodxO0KXKKKXXXXXXXXNXXXXXXk               
               ;lllcccclllllloolllloooooooooodddddodddxkxdooolllc;,:ccodkOKKKK0KXXXK0KXXXXXXXXx               
               :oollllllllloollllllloooddddoodxkkxddxO00xooollll:;:;,,;cok0KKXXXXXXXNXXXXXXXXNk               
               ;ooollloooollllllllloodxxxxdoooxkOOOO0KKK0xoooocccc:;;;;;;:cd0XXXXKXNNNNXXNNNNNk               
               ,oooooldddollllllllloodxxkkxdooxO0KKKKKKKK0dcclllcc::;;:::::ldk0KXNXXNNNNNNNNNNk               
               ;oodddoodxxollllloooooddxkkxdddOKKKKK0KKKK0xolc:::::::::ccod0KK000XXXKXXNNNXXXNk               
               :dddxxdodxkxddoooddxkkkkkkkxddk000000KKKK0kkkdlcccccccccclxkKK0Oxox0XNXXNNNXNNNk               
               :ddddddddxkkkkxxxxkO00000OkxdxxO0000KKKKK0000OkddlllldlcldOk00xxollxXNNNXXNNNNNk               
               :ddooooooxkkOOOOOO000KKKK0OxdkxO000KKKKKKKK00000kdddx0Oxkdxk0OoxooldxXXXXNNNNNNk               
               ;oolclllodxkkkOO0OOO0KKKKK0kxkxkO00KKKKKKKK000000OOO000K0kk00klxxocdldKXNNNNNNXk               
               ;lllccccloddxxk00OxxkkO0KK0kxOxO00KKKKKKKKK0000000000KKK0Ok00xlOkocdlcxXNXXNNNNk               
               ,clccccclllooodxOOxolloxkOkxkkk0KKKKKKKKK000000000000KKK0OOO0dlOkolodccOKXNNNNNk               
               'cccccclllloooodxkxollloddddxdxKKXKKKKKKK00000000000KKK00OOOkolOklcodccoKXXNNXNk               
               ':ccccclooodddxxdoollllloooodod0KKKKKKKKK00K000KK00KKKK00OOkd:dOxlcldoclkNNXKKXk               
               '::cccclodddxkkxdollllllloooxod0KKKKKKK00K000O0KKKK00000OkxdccdOxlcodocloKXXXXNk               
               'cccccclooodxkkkxoollllllllokdo0KKKKKK00K0000OOKKKKKK000OkdlcldkxlcoddlllOXNNNXk               
               'ccccccclooddxkkxollclllllllkdoOKK000OO0K0O00OOKKKK00000OxolcodxxlloddlllkKXXXXx               
               'cclolcclodddxkkxolcclllllllxxlOKKKKK00KK0O00OOKKOOkkkkkxdlclodxxlldxxlllOKXXXXx               
               ;olccccclllloooooddddddxkxdxkO00KKKKKKKXXK0KXNXK00dllx00KXXXKKKKXXXKKKXNX0xoool;               
               ;olllllloollooooodddddxkxxxxkk000KKKKKKKKKKKKK0KK0dlcxK00000KK0OOOOKK00OxO0kdol;               
               ,ccccllllloooddooddddddxxxxxxkO0KK000KK000000Ok00kocldO00OkO0KXKOO0KKXX000KK0xo:               
               ;cccllcclllloddolooodddxxxdddxkKKKKKKKKKXXK00KKKKOoloOK0OKKKKK0KKXXXKKXNNNXOk00d               
               ,lllolllllloooooooddxxxddddoodk000KKK0KKKKK00KKKKkolo0K000KKKK0KXXXXKKXXNNXKKXXk               
               ;cllloddoollllllodxkOOkxdddoodxO0KK0KKKK0OOOOOO0KkoloOKKKK00KXXXX0KXXXNXKKNNNNXd               
               ,ccllodxxxdooollodkOOOOOkkxxxxkO000K0ko::;,,;:ccodlld0KKKKK0KXXXKKKXXXXXKXXKOkko               
               ,lllllodxxxdooooodkO0OOOOOkkkOO000KOlcc:;;,,,,,''',:d00O0KKXK00XXXXX0KXXNNXOdooc               
               ;lllooooodxxxdoolodkO0OOkOOOOOO0K0kl;,''.....'......l00000KKKXKKXXXXXXXXNXXKOxoc               
               ;odoooolllodxdoollodxkkkxxkOOO0KK0o:,',,''''''......:000KKO0KXXXK0XNNNXK0XNNXKxc               
               ,oxddoollllodddoolllodxxddxxkkO0000d:oxxlcccc:,'....c0KKK0KKKXXXKXXXNXXXKXNNNXKd               
               ,odddoollllodddollllooddddoodxkO0KKkokOOOOkxoc:,'...c0K00KXXX0KXNNXXKXNNNXKXXXXk               
               ,looooollllodddoloollloooooloddkO0Kkdkxxkxxolc;,'..'l0K00KXXXKKKXXXXKKXNNNXXNNNx               
               ,ccclllllloddddoolllooooooooooodkOkc;:;:cc;:;;,,,'''o0KKKK0XXXXXKKXNXNNXXNNNNXKd               
               ,lcclllllloddddollllodddddoooooodxko,,,;cc,,,;;;;,,;l0KKKKKKKXXXKXXXXXXXXNNNNXKo               
               ;lllllllllloddolllllodddddooooooooxxoc:lxdc;;:::::;:kK00KXXXX0KXXXXXKNNNNNNXXXKo               
               ;lccclllllllooolllllooxxxdoooooooodddddxolccllc::ccdO0KKKXXXXXXXXXXXXXNNNNNXXXXx               
               ;lcccllllllllllllllloodxkxxdooooooodddodllc:cllccccoxO0XXK0KXNXXKKNNNNXXNNNNNNNx               
               ;cccccllolllllllllllloodxxxddooooddxxxxkdolccllc::cldxO0KKKXXXXXXXXNNNNNXNNNXXXx               
               ,ccccclooooloollloooooooodddddddddxxkkkkkxdllllcc;;coxkk0KKK00KKXXXKKXNNXXXXXXXk               
               ,cccclllodolllllooooddddooodxxxxxxkOOO0kxddoollcc;;;;clxO0KKXKKXXXXXXXXXNXKKXXXk               
               ,lllllllooolllooooddxxxdooodxxkkxxxO0KKOxdoooll::::;;;;;:cdOXXXXKKXNNNNXXNNNXXXk               
               ;llloollllllllllloodxxkkdoodxkOOkO0KKKKK0kdoolllcc::;;;::;:cxOKXXXXNNNXXXNNNNNXk               
               :doodxdollllllllooddxkkkxdddxk0KKKKKKKKKK0Odlcccc::::::c:cox00O0KXNXXNNNNNNNNNNk               
               :ddoxxxdollllllodxxxxxkkxxxxkOKKKKK0KKKKK0dxdc:::cccccccclkk00OkdkKXXXXXNNNXNNNk               
               :ddddxkkdllooooxkOOOOOkxxxxkOK00000KKKKK0kOOOkdllllllccccokxOkxxcokXXNNXXXNNNNNk               
               ;ooodkkxddooddxkOO0KK0Okxxxk00O0000KKKKKK00000OxolllllokkdkO0ddxolxkXXXXXXXXNNNk               
               ;llodxxxddddddxkO0KKKK0Oxddk0OOOO00KKKKKKK000000kxxxxxk0Ok000odxdldoxKNNXXXXNNNk               
               ,clooddddoodxxddkO0KKK0kxdokOkO00KKKKKKKKK000000O000K00KOkO00oxOdcoocxXXXXXXNNNk               
               'ccloollllodxxdooodk000kdookkkO00KKKKKKKK00000000000KKK0OkOOOoxOdclolck0XNNNNNNk               
               ':cclllllooodxxollloxkxdoodOkk0KKKKKKKKKK000000000000KK0OOOOklxOdclolcl0KXNNNNNk               
               ':cllllodddddddollllloooooxxxOKKKKKKKKKKK00000000000KKK00OOkocxOdcldoccxKKXXXXXk               
               'cllooodxkkkxdolllllloooodxxdOOKKKKKKKK00KK0000000000000OkkdclxOdclddlllKK0XXXXk               
               'cclodddxkOOkdolllllllooodxxdkOKKKKKKK00K00000000KKKK000OkdlcodxdclodlllkKXXNNXk               
               'cccodddxk0Okdllllccllllookxdk0KKKKKKKOOK000OO000KKKK000OkdlcodxdcldxollxXXXXXXk               
               ':ccloddxkkkkdlccccclllllokxok00000000kOK0000O0000K00000OxlclodxdlldxollxXXXXXXx               
               ,cccccccllllllooooooooddc,cdddddddddddddddddddddddddddddddxkO0KXNNNNKOK0OxddOXd:               
               ,ccccccclllllloooddooooo:,cdddddddddddddddddddddddddddddxxxk0KXNNNNNNXXNOdddxkdc               
               ,ccccccclllllloooodooooo;,coddddddddddddddddddddddddddddxxxkOKXNNNNNNNNKOxdxOOxc               
               ,ccccclllllllloooooooooo;,codddddddddddddddddddddddddddddkOO0KXXNNNNNNNOxdddkkxl               
               ,ccccccclllllloooooooooo;,codddddddddddddddxdxdddddxxxxxxOKXXXXNNNNNNNNNKxddxkxl               
               ,ccccccccllllloooooooooo;,codddddddddddddddkkkxdxddddxkkkKXNNNNNNNNNNNNNNXOxdxkd               
               ,ccccccccllllllooooooooo;,lddddddddddddddddxOOkdxdddxxxkxOXXXNNNXXXXXNNXXXXX0Oko               
               ,ccccccccllllllloooooooo;,coooooddddddddddddxxxddddxxkkxdkXXXXXXXXXXXNNXNNNNNNXx               
               ,ccccccclllllllloolloooo;,cooooooddddddddddddddddddxk0KOx0XXNNNNNNNNNNNNNNNNNNNk               
               ,ccccclolllllllloooooooo;,looc:::coddddddddddddxxxxxkKX0x0XNNNNNNNNNNNNNNNNNNNNk               
               ,ccccccdlllllllooooooooo;,looo:,'.,ooddddddddddxxxxkO0X0xKXXNNNNNNNNNNNNNNNNNNNx               
               ,ccccclllllolllloooooooo;,lolo:;,.,oddddddddddxxxxxkOOOkxKXXNNNNNNNNNNXXNNNNNNNk               
               ,ccccccllllllllloooooooo;,lolc::::codddddddddddxxxxxxkkxkKXNNNNNNNNNNNXK0XNNNNNk               
               ,ccccccllllllolllooooooo;,loolccccoddddddddddddddxxddxxxkKXNNNNNNNNXKKXKOOKXXNNk               
               ,ccccccllllllooolooooool,,looolcc:coddddddddddddddddddddxOXXXXXNNNNNX00KOO000XXk               
               :oolcccllllllllllooooool';loodolc::cloodddddddddddddddxxxxOKKKKKKXNNNXKOOO00OOKk               
               ,clllccllllllllloooooool';looxxxolcllllddddddddddddddxxxxxxxOOkkk0KXNXKkxxO00OOd               
               ,cclllcllllllllloooooool,;lookOOkxolllloxdxxxxxxxxdddddxxxxxxxxxxxkOKKKOxxkO0OOd               
               ,cccllcllllllllloooooool';lldkkOOOkolloldxxxxxxxkxxkxdddxxxxxxxkkkkkO0OkxxxxkO0d               
               ,ccccclllllllllloooooool';lldxdkOkxccllloddddxxxxxxkOxdddxxkkxxkOOkkkkkxxkkxxxxo               
               ,ccccclllllllllloooooool;:lclodxkkdcclllodddddddxxxkOxxxxxxxkkxxkkOOOOkkxkkxxxdl               
               ,cccccllllllollloooooollllcccoddxxo:lolllddddddxxxxxkxxxxxxxxxxxxkkO00Okxxxxxxdc               
               ':cccccllllloooooooooolc;:lllloodxxkkdlloddddddxxxxxxxdxxxxxxxxxxxxkO0Okxxxxxxdc               
               '::::ccclllloooooooooooc';ooolllllcc:clooddddddddxxxxddddddxxxxxxxxxxxxkkxdddddc               
               '::::::ccccclloooooooooc':odxdooooc:::lodddddddddxxxxdddddddxkkxxxxddddxxxddxxdc               
               ';::::::cccccccclllloooc':ok0Ooloollcclooddddddddxxxxxdxxxxxxkkkxxxxxxddddddxxdc               
               .;;;;;::::ccccccccccccl;':dkxxxcldOxdclooddddddddxxxxxxxxxxxxxxkxxxxxxxxxxxxxxdc               
               .;;,,,;;;::cccccccccccc,.:odooc:d00xlloooddddddddxxxxxxxxxxxxddxxxxxxxxxxxxxxxdc               
               .;;;,,;,;;;;::ccccccccc,'cllc:;:dOOocloooodddddddddddxxxxxxxxxxxxkxxxxxxxxxxxxxc               
               .;;;,;;;;;;;;;;;::::ccc,;lc::;:cxkdccclllooooddddddddddxxxxxxxxxkkkkxxxxxxkkkkxc               
               .,,,,,,,;;;;,,,,,,,;;;;,:cc:;;:cddlccccccccccloooddddddxxxxddxxxkOkxxxxxxxxkkkkc               
               .,,,,,,,,,,,,,,,,,,,,,,':c::;;:loolcccccccccccccclllddddxxdddddxkOOkxxxxxxxxkkkl               
               .,,,,,,,,,,,,,,,,,,,,,,,:::;;;:lolc:ccccccccccccccccclloodddddddxkOkxxkxxxkkxxxl               
               .,,,,,,,;,,,,,,,,,,,,,,,;::;;;;lllc:ccccccccccccccccclllllllllooodxxddxxxxkkkkxl               
               .,,,,,,,,,,,,,,,,,,,,,,,;;::;;;:cccc:;;:ccccccccccc::ccclcclloolloooooodddxkkkxl               
               .;;,,,,,,,,,;;;;,,;;,,,,,;;:;;;:cccc:,,;:;:cccccccc::::ccccclllloollllcloodxxxxl               
               ,cccccllllllooooooooooo;;odddddddddddddddddddddddddddddddxO0KXNNNNN0OK0kdddOXxoc               
               ,ccccclllllloooodoooooo,;odddddddddddddddddddddddddddddxxxk0XXNNNNNXXXN0dddxkxo:               
               ,ccccclllllllooodoooool,;odddddddddddddddddddddddddddddxxxkOKXNNNNNNNNKOxddOkkdc               
               ,cccccllllllooooooooool,;odddddddddddddddddddddddxxddddxkO00KXNNNNNNNNOxdddkkxxl               
               ,cccccllllllooooooooool,:ooddddddddddddddxxxxddddxxxxxxxOKXXXNNNNNNNNNXKkdddxxxo               
               ,cccccclllllooooooooooc,:ooddddddddddddddxkkkxxdddddxkkOKXXXXNNNNNNNNNNNXOxxxx0x               
               ,cccccclllllloooooooooc,:oddddddddddddddddxOOxdddddxxxkx0XXXXXNNXXXNNXXXXXK0kkOd               
               ,cccccclllllloooooooooc,:ooooodddddddddddddxxxddddxkkkddOKXXXXXXXXXXXXXXNNNNXXXk               
               ,ccccccllllllloollooooc,:oooooddddddddddddddddddddxk0KOxKNXNNNNNNNNNNNNNNNNNNNNk               
               ,ccclolcllllllooooooooc,:ooooooodddddddddddddddxxxxOKXOxKXNNNNNNNNNNNNNNNNNNNNNx               
               ,ccccoocllllloooooooooc,:oo:,;',:ldddddddddddxxxxxkOKXOkXXXNNNNNNNNNNNNNNNNNNNXd               
               ,ccclllllollllooooooooc,:odxl:,..:dddddddddddxxxxxkO00xkXXNNNNNNNNNNNNXNNNNNNNXx               
               ,cccclllllllllooooooooc,:oc:,,,''coddddddddddxxxxxxxkOxkKXNNNNNNNNNNNXKKXNNNNNXx               
               ,cccclllllllllloooooooc,coolc:cccodddddddddddddddxxddxxkKXNNNNNNNNXKXXKO0KXNNNNx               
               ,ccccllllllloolloooooo:'cooolccccodddddddddddddddddddddx0XXXXXNNNNXXKK0OO00KXNNk               
               ;lccllllllllollloooooo:'coooolcc:cloddddddddddddddddxddxxOKKKKKXXNNNK00OO00OOKXk               
               ,llccllllllllloooooooo:'coodddlc:cclldxddddddddddddxxddxxxkOOOkO0KXNX0kxk00OOOKx               
               ,llccclllllllooooooooo;,coodkOxocllllodxddxxxxxddddddddxxxxxxxxxxkOKKOkxxk00000x               
               ,cllcclllllllooooooooo;'lloxkOOOxdoclllxxdxxxdxkxxxxdddxxxxxxxkkkkkOOkxxxxxkO0Kx               
               ,ccccllllllllooooooooo;'lcokkxO0OklclllddddddxxxxkkkxxdxxxkkxxkOOkkkOkxxkkxxkkOd               
               ,ccllllllllllooooooooo:'clldddxOOdclollodddddxxxxkkkxxxxxxxkkxxkkkOOOOkxkkxxxxxo               
               ,cclllllllllooooooolllc;llclodxkko;cooloddddddxxxxxxxxxxxxxxxxxxxkO00Okxxxxxxxxc               
               ,cclllllllooooooooolllccllccodddddkkdoloddddddxxxxxxxxxxxxxxxxxxxxkO0Okxxxxxdddc               
               ':cccllllloooooooooooo;,lolllloooolllooodddddddxxxxxxdddxxxxxxxxxxxxxxkxxxdddddc               
               '::::ccccllooooooooooo;,oodolodolc:::loodddddddddxxxxddddddxkxxxxxddddxxxxxxdddc               
               ':::::cccccllllllloooo;,ldkOxoddolcc:coooddddddddxxxxddxxxxxkkxxxxxdddddxxxxxxdc               
               ';;::::cccccccccccllll,,lxO0Olclcodlccoodddddddddxxxxxxxxxxxxxkxxxxxxxxxxxxxxxdc               
               ';,;;;;:ccccccccccccc:',lodxddlok0Odlloooddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxl               
               .;,,;,,;;:::ccccccccc:':lllc:;:dO0xclooooddddddddxxxxxxxxxxxxxxxkxxxxxxxxxxxxxxl               
               .;,;;;;;;;;;;;:::ccccc:llc:;;:cxOkoccllooooddddddddddxxxxxxxxxxkkkxxxxxxxkkkkkxc               
               .,,,,,;;;;,,,,;,,;::::ccc:;;::cdxdlcccccccllloodddddddxxxxdddxkkOkxxxxxxxkOOkkxc               
               .,,,,,,,,,,,,,,,,,,,,;cc:::;::coolcccccccccccccclloddddxxdddddxkOOkxxxxxxxkkkkkc               
               .,,,,,,,,,,,,,,,,,,,,,::;;;;::coolc:cccccccccccccccllooddddddddxkOkxkkkxkkxxxxxl               
               .,,,,,,,,,,,,,,,,,,,,,;:;;;;;:colccccccccccccccccccclllllllooooddxxxxxxxxkkkkkxl               
               .,,,,,,,,,,,,,,,,,,,,,;;;;;;,;clccc:;;:cccccccccccc:ccllllllollllooooddddxkkxxxl               
               .,,,,,,,,,,,;;,,;;,,,,;;;;;;;;:cccc:,,;::cccccccccc:::cccclloolooollccooddxxxxxl               
               ,cccllllloooddooodddo,;ddddddddddddddddddddddddddddddddxO0KXNNNNNNOO0kkxdxK0ddxl               
               ,cccllllloooodooooddl,:odddddddddddddddddddddddddddddxxxk0XXNNNNNNXKXKkdddkkdoo:               
               ,cclllllllooodooooool,:odddddddddddddddddddddddddddddxxxkOKXNNNNNNNNNKOxdxOkxddc               
               ,cllllllloooooooooooc,:odddddddddddddddddddddddxxddddxkkO0KXNNNNNNNNKxdddxkxxdxo               
               ,cllllllllooooooooooc,:odddddddddddddddxxxxddddxxxxxxkOKXXXXNNNNNNNNXKOxddkkxxxl               
               ,cccllllllooooooooooc,:odddddddddddddddxkkkxxdddddxkkOKXXXXNNNNNNNNNNNN0xxxxOX0l               
               ,cccllllllooooooooooc,:dddddddddddddddddkOOxxddddxxxkxOXXXXNNNNNNNNNNXXXXKkxk0Ol               
               ,cccllllllooooooooooc,cooooodddddddddddddxxxxdddxkkkxdkKXXXXXXXXXXXXXXXXXNXXXXXx               
               ;ccclllllloooooooooo:,coooodddddddddddddooddddddxk0KOx0XXNNNNNNNNNNNNNNNNNNNNNXx               
               ;oolcllllloooooooooo:,cooooodddddddddddddddddxxxxkKXOxKXXNNNNNNNNNNNNNNNNNNNNX0o               
               ;odllllllloooooooooo:,coolcc:coddddddddddddxxxxxkO0XOkKXXXNNNNNNNNNNNNNNNNNNNXkl               
               ;llllllllllooooooooo:,cdo:;'..'cdddddddddddkxxxxkO00kkKXXNNNNNNNNNNNNNNNNNNNNN0l               
               ,clllllllllloooooooo:,coool:'..;oddddddddddxkxxkkxkOkkKXXNNNNNNNNNNXKKXNNNNNNXOl               
               ,clllllllllloooooooo:,coc;,;,'';dddddddddddddxxxxxxxxkKXXXNNNNNNXKXX0OOKXNNNNNKo               
               ,clllllloolloooooooo:,coollcc::odddddddddddddddxxxdddxOXXXXXNNNNNXKKKOO000XNNNNk               
               ,clllllllllloooooooo;'looolccccodddddddddddddddddxxddxxOKKKKKXXXNNXK00O00OOKNNNk               
               ,clllllllloooooooooo;,loooolc::ccodddddddxxddddddxxddxxxkOOOOO0KNNX0kkkO00OOKXNk               
               ,ccllllllloooooooooo;,loooddocccclldxxxxxxxxxxdddxxddxxxxxxkxxxk0KK0kxxkO0OO0XXk               
               ,ccllllllloooooooooo;,loodxOOxooollodxxxxxxxxkxxxxxddxxxxxxxkkkxxO0kkxxxkOOOKXXk               
               ,ccllllllloooooooooo;,lllxkO00OklllloddddddxxxxkkkxddxxxkkkxxkOkxkkkxxkkxxkkO0Kd               
               ,ccllllllloooooooooo;'llldxxO0OdclollodddddxxxxkkOxxxxxxxkkxxxkkOOOkkxkkxxxxkkOd               
               ,clllloolooooooooooo;;loloookxxllddolodddddxxxkxxxxxxxxxxxxxxxxkO00Okxxxxxxxxxxl               
               ,lllllooooooooooooolcloolcoooxo:cxxolodddddxxxxxxxxxxxxxxxxxxxxxxk0Okxxxxxxxxxxl               
               ,clllloooooooooooolcccllllllldxOOOxolodddddddxxxxxxddxxxxxxxxxxxxxxkkkxxxxxxdddc               
               ,ccllllooooooooooool,,locccllcllolddooddddddddxxxxxddddddxkkxxxxddddxxxxxxxxdddc               
               ,ccccccclllooooooool,,ooool:llllcccccodddddddxxxxxxxdddxxdxkkxxxxxddddxxxxxxxxdc               
               ':cccccclccccclllool,,ooxOkdodoccccccodddddddxxxxxxxxxxxxxxkkxxxxxxxxxxxxxxxxxxl               
               '::::cccccccccccccc:',lok00Od:ccdkxllodddddddxxxxxxxxxxxxxxxkkxxxxxxxxxxxxxxxxxl               
               .,,;;:ccccccccccccc:.,loddxxxoloOKkllodddddddddxxxxxxxxxxxxxxxkkxxxxxxxxxxxxxxxl               
               .,,,;;;;:::cccccccc:.,lollc:;:clxOoclooodddddddddddxxxxxxxxxkkkkkxxxxxxxkkkkxxxl               
               .;;;;;;;;;;;;;::ccc:':olcc:;;:loxxlccllllooddddddddxxxxxxxxxxkOOkxxxxxxxkOOkxxxc               
               .,,,;;;,,,,,,,;;;;;,;doc:::::ccoxxlccccccccccloooddddxxxdddddxOOkxxxxxxxxkkkxkxc               
               .,,,,,,,,,,,,,,,,,,,odlc::::ccccodoccccccccccccccllddddddddddxkOkkxxxxxkkkxxxkkl               
               .,,,,,,,,,,,,,;,,,,,cc::::;;:::lodoc::cclcccccccclcllllloooodddxkxxxxxxkkkxxxxko               
               .,,,,,,,,,,,,,,,,,,,::::;;;,,,,:oool:ccccccccccccc:clllllllllllooodddddxkkkxxxko               
               .,,,,,,,,,,,,,,,,,,,;:;;;;;,,,,cdolcccccccccccccc:::clllloooooooollloodddxkxxxko               
               ,clllloooodoooooddxl,cddddddddddddddddddddddddddddddddxkO0KXNNNNN0OKOkddd0Kxdxxc               
               ,clllllooooddooooodc'cddddddddddddddddddddddddddddddxxxk0KXNNNNNNX0KKOdddxOxooo:               
               ,clllllloooodoooooo:,cddddddddddddddddddddddddddddddxxxkO0XNNNNNNNNNXKkddkkxddoc               
               ,cllllloooooooooooo:,cddddddddddddddddddddddddxxxdddxkOO0KXNNNNNNNNNKkxxkkOxddko               
               ,cllllllooooooooooo:,cdddddddddddddddxkxxdddddxxxxxxk0KXXXXNNNNNNNNNKOxxdxkkxxko               
               ,cllllloooooooooooo:,cddddddddddddddddxkkkxxxddddxOOkKXXNNXNNNNNNNNNNNXkdddkKKkc               
               ,cllllllooooooooooo:,cdddddddddddddddddkOOxxdddxxxkkxOXXXXNNNNNNNNNNNXXX0kxxO0xc               
               ,cllllllooooooooooo;,cooooddddddddddddddxxxddddxxkkxdkKXXXXXXXXXXXNXXXXXNNXKXXXx               
               ;cllllllooooooooooo;,coooodddddddddddddddddddddxk0K0x0XXXNNNNNNNNNNNNNNNNNNNNXKx               
               ;cclllllooooooooooo;,loooodddddddddddddddddxxxxxkKX0x0NNNNNNNNNNNNNNNNNNNNNNNKko               
               :lclllllooooooooooo;,looolllloddddddddddddxxxkkkO0X0xKXNNNNNNNNNNNNNNNNNNNNNX0xl               
               :lllllllloooooooooo;,lol;,''',cdoddddddddxkkkxxkO00kxKXNNNNNNNNNNNNNNNNNNNNNNXOl               
               ;lllllllloooooooooo;,loool;...'oodddddddddxkkkkkxkOkxKXNNNNNNNNNNNXK0XNNNNNNXOxc               
               ,lllllllloooooooooo;,lol;,;'..,ooddddddddddxxxxxxxxxkKXNNNNNNNNXKKXKOOKXNNNNNXOl               
               ,lllllooloooooooooo;,lodolc::;cddddddddddddddxxxxdddxOXXXXXXXNNNX0KK0kO0KKNNNNNx               
               ,lllllllloooooooooo,,loolcccccoddddddddddddddddddxxxxxOKXKKXXXNNNNXK0OO00O0XNNNk               
               ,cllllllooooooooooo,,loooolcc:codddddddxxxdddddddxxxxxxkOOOOO0KXNXKOkkO00OO0XXNk               
               ,cllllllooooooooooo,,looooolcc:clodxxdxxxxxxxddxdxxddxxxxxkxxxkO0K0OxdxO00O00XNk               
               ,cllllllooooooooooo,;loooxkxollllcdxxdxxxxxkxxxkxddddxxxxxxxkxxxk0OkkxxxkOO0KXXk               
               ,cllllllooooooooool,,llldkkO0OOolclodddddxxxxxxOOxxxxxxkkkxxkOkxxkkxxkkxxxkO00Kx               
               ,cllllllooooooooool,,lclddxO00xlollldddddddxxxxkOxxxxxxxkkxxxkOOOkkkxxOkxxxxkkOo               
               ;lllooloooooooooool',lcclldOOkolddlldddddddxxkxxkxxxxxxxxkxxxxxk00OOkxxxxxxxxxkl               
               ;lllooooooooooooool',odooloxxolxxdlloddddddxxxxxxxxxxxxxxxxxxxxxkO0Okxxxxxxxxxxl               
               ;lllooooooooooooool';dxdkkxddllkkdllodddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxdddddddc               
               ;lllooooooooooooool';olclcccoxkxddlodddddddddxxxxxxdddddxxkxxxxxdddxxxxxxxxxdddc               
               ;cccclloooooooooool';ollcclcccclloclodddddddxxxxxxxxxddxxxkkxxxxxdddddxxxxxxxxdc               
               ,cccccllccccllooooc';ooododoccc:::::oddddddddxxxxxxxxxxxxxxkkxxxxxxxxxxxddxxxxxl               
               ':ccccccccccccccll:';ooxOOkdcc:::::coddddddddxxxxxxxxxxxxxxxkxxxxxxxxxxxxxxxxxxl               
               ';:ccccccccccccccc;.;codkOOkolllccccoddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxl               
               .,;;::::cccccccccc;.;cllllccldxkdlccoodddddddddddxxxxxxxxxkxxxxxxxxxxxxkkkxxxxxl               
               .;;;;;;;;;;:::cccc;.;llllc:;;cdOOdlclloooodddddddddxxxxxxxxxkOkkxxxxxxxkOOkxxxxc               
               .,;:;,,,,,,,;;;:::,.;dlcc::::cokOOocccccccclooodddddxxxdddddxkOkkxxxxxxxxkkkxxxc               
               .,,,,,,,,,,,,,,,,,',odlc::::cccdkxocccccccccccclloddxxxddddddxOOkxkxxxkkkxxxkkkl               
               .,,,,,,,,,,,,,,,,,,cxoc::::::ccoddoc:cccccccccccccllooooodddddxkxxxxxxxkkkxxxkko               
               .,,,,,,,,,,,;;,,,,,:lc:::;,,,;;cddoc:ccccccccccccccllllllllllooodddxxxxxkxxxxkko               
               .,,,,,,,,,,,,,',,,,:::::;;,,,,,;odlccccccccccccccccllllllodooollollooddxxxxxxkOo               
               ;llooooodoooooddxl,;oddddddddddddddddddddxxddddddddddxO0KXNNNNNNXOXKOxkxk0xx0Odc               
               ;lllooooooooooodd:,;oddddddddddddddddddddddddddddddxxxO0XXNNNNNNX000Oxddd0kdddoc               
               ,lllloooooooooooo:':oodddddddddddddddddddddddxxddddxkkO0KXNNNNNNNNXXXOddxkkdooo:               
               ,lllooooooooooooo:,:oddddddddddddddddddddddddxxddddxkO0KKXNNNNNNNNNNKOkxkOkxddxl               
               ,lllooooooooooooo:,:odddxddddxddddddxkxxxddddxxxkxxk0KXXXNNNNNNNNNNNOdddxxxddxOo               
               ,lllooooooooooooo:,:odddddddddddddddxkOkxxxxxddxkOOOKXXXXNNNNNNNNNNNXXOdddxkOkxl               
               ,lllloooooooooooo:,:oddddddddddddddddxOOkxdddddxxkOx0XXXXXNNNNNNNNNNNNX0xddxOOd:               
               ,lllloooooooooooo:,:oooooodddddddddddddxxxdddddkOkddkKKXXXXXXXNXXXXXNXXNXK0O0K0o               
               ;lllllooooooooooo:,:ooooddddddddddddddddddddddxOKKOx0XXXNNNNNNNNNNNNNNNNNNNXK0Kx               
               ;lllllooooooooooo:,:oooodddddddddddddddddxxxxxkOKXOx0XXNNNNNNNNNNNNNNNNNNNNXKkkl               
               ,lllloooooooooooo:,:ooolccclodddddddddddxxxkxkO0KXOxKXXNNNNNNNNNNNNNNNNNNNNXOxdc               
               ,lllllloooooooooo:,:oo:,''..,lddddddddddxkkkkxO000kxKXXNNNNNNNNNNNXNNNNNNNNNXOxc               
               ,lllllloooooooooo:,:oool:'...;oddddddddddxkkkOkxkOkkKXXXNNNNNNNNNXK0KXNNNNNN0xxc               
               ,lllllloooooooooo;,:ooc,,,'..;odddddddddddxxxkxdxxxkKXXXNNNNNNXKKKK0O0XXNNNNX0kl               
               ,lllooloooooooooo;,:odolcc::;ldddddddddddddddxxxxddx0XXXXXNNNNNXKKK0O00KXXNNNNXo               
               ,lllooloooooooooo;':ooolcccccodddddddddddddddddxxddxxOKXXXXXXNNNXXKK0O00O0XNNNNk               
               ,lllllooooooooooo;':oooolccc:cooddddddxxdddddddxxddxxxkO00O00KXNXX0OOO00Ok0XNNNk               
               ,lllloooooooooool,'coooollccc:clodxdxxxxxxxddddxxddxxxxxkkkxxk0KK0kxxkO000O0XXNk               
               ,lllloooooooooool;'colooodlcccclcoxxxxxxxxkxxxxxxddxxxxxxxxxxxxk0OkxxxkOOO0KXXXk               
               ,lllllooooooooool,':lcoodolldxdolcoddddxxxxxxkkkdddxxxxkxxxkOkxxkkxxxkkxkkO00KKx               
               ,lllllooooooooool,':lclollodk0oddloddddddxxkkkOOxdxxxxxkkxxxkkOOkkkxxkkxxxkOOOOo               
               ,lllloooooooooooo,,ccccc:lddxdldoooodddddxxxxxkkxxxxxxxxxxxxxxkO0Okkxkkxxxxxxkkl               
               ;looooooooooooool,,ldolllodll:lxlxoodddddxxxxxxxxxxxxxxxxxxxxxxkO0Okxxxxxxxxxxko               
               ;oooooooooooooool,,oolodddo::;lxxxoodddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdddddddl               
               ;looooooooooooool,'clllc:::::cO0kdlodddddddddxxxxxxddxxxkkxxxxxxdddddddddddddddc               
               ;looooooooooooool''loolccc::cdkxoloooddddddddxxxxxxxddddxkkxxxxxdddddddddxxxxxxc               
               ,cclllllllooooool''lodddkOxlllc::codddddddddxxxxxxxxxxxxxxkkxxxxxxxxxxddddxxxxdc               
               ,ccclcccccclllool''ldxkkkxolcccc:coddddddddddxxxxxxxxxxxxxxkxxxxxxxxxxxxxxxxxxxl               
               ,ccccccccccccccc:.'coxkkkdlloxkdlloddddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxkxxxxxxxl               
               ':cccccccccccccc:.':ollllccoOOkolloddddddddddddxxxxxxxxxkkkxxxxxxxkxxxkkkxxxxxko               
               ';;:::cccccccccc;.'cllc::;:o0kdlclooodddddddddddddxxxxxxxxxkkkkxxxkxxxxkOOkxxxxl               
               .;;;;;;;;;::cccc:.,llcc:;;:dOkdlcccccclllloodddddddxkxddxxxxkOkkkxxxxxxxkOkxxxxc               
               .,,,,,,,,,,,;;;;,.:olc::::clkxolccccccccc::ccllodddxkxdddddxxOOkxkkkxxkkxxxxkkxc               
               .,,,,,,,,,,,,,,,',loc:::::clxdoccccccccccccccccccllodddddddddxkkxxxxxxkkkxxxxkkl               
               .,,,,,,,,,,,,,,,,:ll:::::::ldolc:ccccccccccccccccllllllllllloodxxdxxxxxkkxxxxkOo               
               .,,,,,,,,;;;,,,,,;c:::;;;,;cool:::ccccccccccc:cccccllllllllllllooodddddxkkxxxkOo               
               ;loooodooooodddxc,:odddddddddddddddddddddxddddddddddxO0KKXNNNNNNKKX0kO0k0Odk0xdc               
               ;looooodoooooood:,:oddddddddddddddddddddddddddddddxxxk0KXNNNNNNNKO00kxddk0xdxdoc               
               ,llooooooooooooo;,:oddddddddddddddddddddddddxdddddxxxOO0KXNNNNNNNXKX0xddxkxdooo:               
               ,llooooooooooooo;,:oddddddddddddddddddddddddxxxddddkO0KKXNNNNNNNNNNNKkxxkOxddddc               
               ,loooooooooooooo;,codddxdddddxdddddxkxxdddddxxxxkxk0KKXNXNNNNNNNNNNXxxxxxxdodkOl               
               ;llooooooooooooo:,codddddddddddddddxkkkxxxxdddxkOOO0XXXNXNNNNNNNNNNNK0xdddxxkxxl               
               ,llooooooooooooo;,coodddddddddddddddxkOkxxdddddxkOkkXXXXXNNNNNNNNNNNNNKkdddO0kd:               
               ,llooooooooooooo;,:oooddddddddddddddddxxxdddddkOOkxx0KKXXXXXXXXXXXXXXXXNK0OO00kl               
               ;llloooooooooooo;,:ooooodddddddddddddddddddddxOKKKxkXNNXNNNNNNNNNNNNNNNNNNXKKXXk               
               ;llloooooooooooo;,:ooooodddddddddddddddddxxxxxOKXKxOXNNNNNNNNNNNNNNNNNNNNNNX0xOo               
               ,llloooooooooooo:,:oolc:;;:ldddddddddddxxxxkkOO0XKxOXXXNNNNNNNNNNNNNNNNNNNX0kxdc               
               ,llllooooooooooo:,:oo;;'....codddddddddxkkkxxk000Ox0XXXNNNNNNNNNNNXNNNNNNNNN0xxc               
               ,llllooooooooooo;,coool:'...,odddddddddxkkkkkkkkOkx0XXNNNNNNNNNNNXK0KNNNNNNXkdxc               
               ,llllooooooooooo;,cooc;;;,,';oddddddddddxxxxkkxxxxx0XXNNNNNNNNXKKXKO0KXNNNNX0kxc               
               ;ooolooooooooooo;,:odolcccc:odddddddddddddddxxddddxOKXXXXXNNNNXKKKKOO00KXNNNNN0o               
               ;ooolooooooooooo;,cooolcccc:loddddddddddddddddxxdddxk0XXXXXNNNNNXKK0O000OKNNNNNk               
               ;llloooooooooooo;,coooooccc:ccldddddddddddddddxxdddxxkO0000KKXNNXK0OOO00OOKXNNNk               
               ;llloooooooooooo,,coooolcccccccllodddxxxxxxddddxxddxxxxkkkkxkO0KK0xxkk00OO0KXXNk               
               ;llloooooooooooo,,colllloolccccllloddxxxxkxxxxxddddxxxxxxxkxxxkO0OkxxxkOOO0KXXXk               
               ,llloooooooooool,,clclloolcclllllllodddxxxxxxkkxxddxxkkkxxxkkxxkOkxxkkxkOO00KKKx               
               ,llloooooooooool,,cc:lllccclxklcooloddddxxxkkOOkdxxxxxkkxxxkkkkkkkxxkOkxkkkOOOOo               
               ,llloooooooooool,'::::cc:cldxoccxdododddxxxkxxkxxxxxxxxxkxxxxkO00Okxxkkxxxkkkkkl               
               ;llloooooooooool,,cll:ccoddlc::cdddxlodddxxxxxxxxxxxxxxxxxxxxxxO00kxxxxxxxxxxkko               
               ;loooooooooooool,'lo:lloolcc::::lkOxoloddxxxxxxxxxxxxxxxxxxxxxxxxkkxxxxxddxxxxxl               
               ;loooooooooooool''lllo::::::;;;:dKOxoodddddxxxxxxxxxdxxxxxxxxxxxxxxxddddddxddddc               
               ;loooooooooooool',loollolc::::ldxdl:codddddxxxxxxxxddddxxkxxxxxxdddddddddxxxxxdc               
               ;loooooooooooool',lodxxkOkxlcloolloooddddddxxxxxxxxxxxxxxkkxxxxxxxxxxxddddxxxxdc               
               ,cllcllllloooool',lokOkkdllccclllodddddddddxxxxxxxxxxxxxxxkkxxxxxxxxxxxxddxxxxxl               
               ,ccccccccccclllc''lokkkxdlldkkxlloddddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxkkxxxxxxxl               
               ,cccccccccccccc:.'cloll::ldOOkoloodddddddddddxxddxxxxxxkkkxxxxxxxxkxxxkOkxxxxxko               
               ,::cccccccccccc:.'clllc:;:x0kdlclooddddddddddddddxxxxxxxkkkkkkxxxxkkxxkOOOkxxxxl               
               ';;:::::ccccccc:.,lllc:;;cx0kdccccclllloodddddddddxkxxxxxxxxkOkxxxxxxxxkOkkxxxxc               
               .,,;;;,,;;;:ccc:.,llc:;;:coOkoccccccccc:cclllodddddxkxdxxddxkOOkxkkkxxkxxxkkkkxc               
               .,,,,,,,,,,;;;;,.;lc:;;::coxxoccccccccccccccccllloodxxxddddxxkkkxxkxxxkkxxkkkkkl               
               .,,,,,,,,,,,,,,,':cc:;;:::lddlc:ccccccccccccccccclllllloooooddxxdxxxxxkkkxxxkOOo               
               .,,,,,,,,,,,,,,,':c::;;::;lddl:::ccccccccccccccccccllllcccclllodddxddddkkxxxkOOo               
               :ooodooooodddxd;,ldddddddddddddddddddddddddddddddxxxk0KXXNNNNNNXKNKOk00O0xdkOkd:               
               :oooodooooooodo;,ldddddddddddddddddddddddddddddddxxxkOKXXNNNNNNXOO0Oxxddk0xxkxd:               
               :oooooooooooooo;,ldddddddddddddddddddddddddxxddddxkkkO0KXNNNNNNNXKXXOxddxkxddxo:               
               :oooooooooooooo;,ldddddddddddddddddddddddxxxxxxddxk00KXXXNNNNNNNNNNKOkxxkkxddddc               
               :oooooooooooooo;,ldddxdddxxxddddddxkxxxddddxxxkOkk0KXXXXNNNNNNNNNNXkxxdddxxddkOl               
               :oooooooooooooo;,lddddddddddddddddxkkkkxxxddddkO000XXXXNNNNNNNNNNNNXKkddddkOOxdc               
               ;oooooooooooool;,ldddddddddddddddddxOOkxdddddxkkkOx0XXXXNNNNNNNNNNNXNXOxdxkKKkd:               
               :oooooooooooool;,coodddddddddddddddddxxxxddddxOOOkdkKKXXXXXXXXXXXXXNXNXKK0KKXKOl               
               ;oooooooooooool;,coooolloodddddddddddddddddddk0XXOx0NNNNNNNNNNNNNNNNNNNNNNXNXNXk               
               ;oooooooooooooo;,cooc:,,'';ldddddddddddddxxxxOKXX0x0NNNNNNNNNNNNNNNNNNNNNNNXOOOo               
               ;oooooooooooooo;,loo::;'...'odddddddddxxxxxkkO0KXOxKXNXNNNNNNNNNNNNNNNNNNNK0kxxc               
               ;lloooooooooooo;,coooc:,....ldddddddddxkkkkkkO0O0kxKXNXNNNNNNNNNNXXNNNNNNNNKkxdc               
               ;lloooooooooooo;,cooo:::;;,'lddddddddddxkkkOOkkOOkxKXNXNNNNNNNNNNX0KXNNNNNNKkxxc               
               ,lloooooooooool;,coooolccc::odddddddddddxxxkOkxxxxkKXNNNNNNNNNXKKXKO0KXNNNNXOxxc               
               ;lloooooooooool;,loooolccccclooddddddddddddxxxxxxxx0XXXXXNNNNNXXKKK0000KXNNNXKOl               
               ;lloooooooooool;,looooolcc:::cclooddddddddddddxxxxxk0XXXXXXXNNNNXXK0000OOKNNNNNk               
               ;looooooooooool;'cooooolcc:cccccclloddddddddddxxxxxxxk00000KKXNNXK0OOO00OO0XNNNk               
               ;looooooooooool;'colllllooccccccccccodxxxxxddxxxxxdxxxxkkkxxkO0KKOxxkO00000KXNNk               
               ;looooooooooool;,clcclloodolcccccccccldxxxxxxxxddddxxxxxxkkxxxkO0OkxxxkOOOKXXXXk               
               ;oooooooooooool,'cc:clllllllllcccccccclloxxxkkxddddxxxkkxxkkkxxkkkxkkkxkOO00KKKd               
               ;oooooooooooool,'cc:;cccccllllccc:c:::ccloxkkkkxxxxxxkkkxxxkkOkkkkxxkOkxxkOOOOOl               
               ;oooooooooooooo,'clc:;cllclllllcccccoxolooxxxkxxxxxxxxxkkxxxxkO00Okxxkkxxxxxkkkl               
               ;looooooooooooo,'coc:lddlccclllcccoxxl:cldxxxxxxxxxxxxxxxxxxxxxO00Okxxxxxxxxxkko               
               ;looooooooooooo,'coc:lllc::cccc::dkdllllddxxxxxxxxxxxxxxxxxxxxxxxkkxxxxxddxxxxxl               
               ;oooooooooooooo,'cdddoc:::;;;;;;colllddddddxxxxxxxxdddxxkxxxxxxxxxxxddddddxddddc               
               ;looooooooooooo,'cddollllc:::::::coooddddddxxxxxxxxxdddxxxxxxxxxdddddddddxxxxxxc               
               :oooooooooooool,'looooddoolc:::::coddddddddxxxxxxxxxxxxxxkkxxxxxxxxxxxddddxxxxxl               
               ;lllllooooooool,'loodxxdolc:::cccodddddddddxxxxxxxxxxxxxxxkkxxxxxxxxxxxxxxxxxxxl               
               ;cccccclllllool''loodOOkdlccodolclddddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxkkxxxxxxxl               
               ,ccccccccccccc:.'cllxxolc::oO0Odlldddddddddddxxxxxxxxxxkkkxxxxxxxxkxxxkkkkxxxxko               
               ,ccccccccccccc:.':cloolc:::oO0OxlooddddddddddddddxxxxxxkkkkkkkxxxxkkkkkOOOkxxxxl               
               ':cccccccccccc;'.:clolcc:::ckOOxcloooooddddddddddxxxxxxxxxxkOOkxkxxkkkkkkkkxxxxl               
               ';;:::::cccccc;'.:clolc::::cxOkoccccccccllodddddddxkkxxxxxxxkOkkkkkkkkkkxxkkkkkl               
               .,;,,,,;;;::::;.':clllc::::cxkxoccccccccccccllllodxxxxxddxxxxkOkxxkxxxkkkxkkkkkl               
               .,,,,,,,,,;,,,'.';:clc:::::cdxdlcccccccccccccccclllooooooddddxxxdxxxxxkkkkxxkOOo               
               .,,,,,,,,,,,,,'.';::c::::::coxdlccccclccccccccccclllllllllllloddddxddddxkkxxkOOo               
               :oooooooodddxd:':ddddddddddddddddddddddddddddddxxkxxkKXXXNNNNNNKkKK0kOOkKOddOOx:               
               :ooooooooooddo:':dddddddddddddddddddddddddddddddxOkkkO0XXNNNNNNN0O00xdddk0kdxxd:               
               :ooooooooooooo:':ddddddddddddddddddddddddddxxddddkOkO0KXXNNNNNNNNNNX0xxxkkkdddoc               
               :ooooooooooooo:':odddddddxddddddddxxxddddddxxxxddk0KKKXNXNNNNNNNNNNOkkxxkkxdoxxc               
               :ooooooooooooo:':oddddddddxxdddddxkkkxxxxddddxOOkOKXXXXNNNNNNNNNNNXOxdddxxxddxOl               
               :ooooooooooooo;':oddddddddddddddddxkOkxxxdddddkO000XXNNNNNNNNNNNNNNNXOdddxk0Oxdc               
               :ooooooooooooo:':odddddddddddddddddxkkkxxddddxkkkOx0XXXXNNNNNXXXNXXXXX0kxxk0XOd:               
               :ooooooooooooo:':ooooooloddddddddddddxdddddddkOOOkdOKKKXXXXXXXXXXXXXXNNNXKKXNX0o               
               ;ooooooooooooo:':oooc:,,'';cooddddddddddddddxOKXXOx0NNNNNNNNNNNNNNNNNNNNNNNNXNXk               
               ;ooooooooooooo:':ooo:::,....loodddddddddxxxkkOKXX0xKXXNNNNNNNNNNNNNNNNNNNNNN0O0d               
               :oooooooooooooc':ooool:;'...:oodddddddxxxxxkk00KXOxKXNXNNNNNNNNNNNNNNNNNNNXKOxxc               
               ;oooooooooooooc':oool;::;;;':dddddddddkkkkkkkO0O0kxKXNNNNNNNNNNNNXXXNNNNNNNXOxxc               
               ;loooooooooooo:';oooooocccc;oddddddddddxkkkOOkkkOkkKXNNNNNNNNNXXXX00KNNNNNNKkxxc               
               ,loooooooooooo:';ooooolcccccooddddddddddxxxkOkxxxxkKXNNNNNNNNXKKKXKO0KKXNNNXOxxl               
               ;loooooooooooo:':odddoolcc::cccloooddddddddxxxxxxxx0XXXXXNNNNNNXKKKOO000KNNNX0Ol               
               ;loooooooooooo:':oooooooccccccccccclodddddddddxxdddxOXXXXXXXXNNNNXK0000OO0XNNNNk               
               ;loooooooooooo:':ooooooollccccccccccclddddddddxxddxxxkO00O000KXXXK0OOO00OO0XNNNk               
               ;loooooooooooo:';oollloodddlcccccccccccodddddddxxxxxxxxkkkxxkOO00OxxxkO0000KXXNk               
               ;loooooooooooo:';olcclloddddolcc::::::;:codxxxxddddxxxxxxkkkxxkO0OkxxxkOOO0KXXXk               
               ;ooooooooooooo:';lc;;clooooooccc::;;;;::::oxkkxddddxxxkkxxxkkkxkkkkkkkxkOOO000Kd               
               ;ooooooooooooo:';lc:,;cloolllccc::::ccccccdxkkkxxxxxxkkkxxxkkkOkkkxxkOkxxkOOOOkl               
               ;ooooooooooooo:';ooc:cccloollcccc:coolc:coxxxkxxxxxxxxxxkxxxxkO00Okxxkkxxxxxxkkl               
               ;loooooooooooo:.;oo:ddc:loddlcccclkdlloodddxxxxxxxxxxxxxxxxxxdxkO0Okxxxxxxxxxxko               
               ;ooooooooooooo:.;ooddlc::llccc:::clllodddddxxxxxxxxxxxxxxxxxdxxxxkkkxxxxddxxxxxl               
               ;ooooooooooooo:';odddoc;::;;;;::::lodddddddxxxxxxxxxxdxxkxxxxxxxxxxxxxdddddddddc               
               ;loooooooooooo:';oooooolccc:ccccc:codddddddxxxxxxxxxxddxxkxxxxxxxxddddddddxxxxxl               
               :ooooooooooooo:.;ooooooolccccc:::ccoddddddddxxxxxxxxxxxxxkkxxxxxxxxxxxxxddxxxxxl               
               ;llooooooooooo:.;ooooodddoc:;::oollodddddddddxxxxxxxxxxxxxkkxxxxxxxxxxxxxxxxxxxl               
               ;ccccllloooooo:.;oooodxxolc:::cooolodddddddddxxxxxxxxxxxxxxkxxxxxxxxxxxkxxxxxxxl               
               ,cccccccccccll;.;oooodxolc:::llolllodddddddddxxxxxxxxxxkkkxxxxxxxxxkxxkOOkxxxxko               
               ,ccccccccccccc,.,ccccodlcc::cxxxollodddddddddddddxxxxxxkkkkkOkxxxxkkkkkOOOkxxxxl               
               ,ccccccccccccc,.,cccclolcc::cokkxllooooodddddddddxxxxxxxxxxkOOkkxxxkkkkkOOkkxxxl               
               '::ccccccccccc,.,cccccllc:::coOkdlcccclllooddddddxkkkxxxxxxxkOOkkkkkkkkkxxkkkkxl               
               ';;;;;;:::cccc,.,ccc:cllc:::clkkdlccccccccclllloodxxkxxddxxxxkOkxxkkkkkkkxxkkkkl               
               .,,,,,,,;;;;;;'.':::::clc:::clxkdlcccccccccccccccllooooodddddxxxxxxxxxkkkkxxkkOo               
               .,,,,,,,,;;;,,'.,;::::cc::::clxxdlccccccccccccccclllllllcllllodddxxddddxkkxxkkOo               
               cddooooddddddc,;oddddddddddddddddddddddddddxxxxxkOkkk0KXXNNNNNNN0k0OxdddxKOxxkxc               
               :ddooooooooodc,;oddddddddddddddddddddddddddxxxxxxOOkO00XXNNNNNNNNKKKOxdddkOxxxdc               
               :ooooooooooooc';oddddddddddddddddddddddddddxxxxddkO00XXXNNNNNNNNNNNXKkxxxOkxdddc               
               :ooooooooooooc',oddddddddddddddddxxxxddddddxxxkxxOKXXXXNNNNNNNNNNNN0xxxxxkkddxkc               
               :ooooooooooooc';odddddddddxddddddxOkkxdxxddddxOOOOKXXXNNNNNNNNNNNNNXOxddddkxxxxl               
               :ooooooooooooc';ooddddddddddddddddkOOkxxxdddddkkOOOKXNNNNNNNNNNNNNNNNXOxddxOK0x:               
               :ooooooooooooc';oooodddddddddddddddkOkxxdddddxkkkOxOXXXNNXXXXXXXXXXXXXK0Okxk0Kkc               
               :ooooooooooool',loooooolllooddddddddddddddddxk000OxkKXXXXXXXXXXXNNNNNNNNNNKXNNXx               
               ;ooooooooooool,,loooo:;,''',:ooddddddddddddxx0KXX0x0XXNNNNNNNNNNNNNNNNNNNNNNNXXx               
               ;ooooooooooool',loooo::c;'...coddddddddxxxxkkOKXX0xKXXNNNNNNNNNNNNNNNNNNNNNNXOOo               
               :ooooooooooool,,looooo::;,...;oddddddxxxxxxkO00KXOxKXNNNNNNNNNNNNNNNNNNNNNNK0Oxc               
               ;ooooooooooool,,looool:::::;':oddddddxkkkkkkkOOOOkxKXXXNNNNNNNNNNNXKXNNNNNNX0kdc               
               ;loooooooooool',looooodocccc:oddddddddxxkkkOOkkkOkxKXNNNNNNNNNNXXNK00KXNNNNNOxxc               
               ,loooooooooool',looooddlccccclddddddddddxxxkkkxxxxxKXNNNNNNNNNXK0KK0O0KKXNNNKkxl               
               ;loooooooooool',loddddoolccc::cclooodddddddxxxdxxxxOKXXXXXXNNNNNXKKK0O000KXNNXOl               
               ;loooooooooool',loddddoooc:cc:cccccccoddddddddxxxxxxk0KKKXXXXNNNNNXK0O000O0XNNNk               
               ;loooooooooool',loddooooolooccccccccccloddddddxxxxxxxkkOOOOOO0XXXK0OOkO00OO0XNNk               
               ;loooooooooool',looolllooxkkxdolcccccccclddddddxxddxxxxxkkkxxkkO00kxxxkO000KKXNk               
               ;loooooooooool''loooclllodxkkkxocc:::c:;:codxxxddxxxxxxxxxkkkxxkO0OkxxxkOOOKXXXk               
               ;ooooooooooool''lool::loddddxxoc:::;,,;;;::okkxddddxxkkkxxxkkkxxkkkkkkkxkOOO00Oo               
               ;ooooooooooool''col:;;clodollolccc::;;cccccdxkkxxxxxxkkkkxxxkkkOkkkxxkOkxxkOkkkl               
               ;ooooooooooool,'cool:;:ccooololcccccoolc;coxxkxxxxxxxxxxkxxxxxkO00Okxxkxxxxxkkko               
               ;loooooooooooo,'coo:c;;:cloddoccccokdllooddxxxxxxxdxxxxxxxxxxdxxO00Okxxxxxdxxxxl               
               ;ooooooooooooo,'codddccccldddol:::cccloddddxxxxxxxxxxxxxxxxxxxxdxxkkkxxxddddddxl               
               ;ooooooooooooo,'cdxoclol:::c:,;c;;;:loddddddxxxxxxxxxddxxxxxxxxxddxxxxxxddddxxdc               
               ;ooooooooooooo''cooooodl;:cc:;;:::::codddddddxxxxxxxxdddxkxxxxxxdxxxdddddddxxxxl               
               :ooooooooooooo''looddddocccclcccccc:cldddddddxxxxxxxxxxxxkkkxxxxxxxxxxxxddxxxxxl               
               ;loooooooooool''loooooooocccclcc:::::loddddddxxxxxxxxxxxxxxkxxxxxxxxxxxxdxxxxxxl               
               ;llloooooooool''loooooddoolcc:::::cc:coddddddxxxxxxxxxxxxxxkxxxxxxxxxxxkkkxxxxxl               
               ,cccccllllllol''coooddddxxoc:::::cllcloddddddxxxxxxxxxxxkkxxxxxxxxxkkkxkOOOxxxxl               
               ,cccccccccccc:..:lllloodxdlc::cccloolloddddddddddxxxxxxxkkkkOOkxxxxkkkkkO0Okxxxl               
               ,cccccccccccc:..;ccccccoddlc::ccclddoloooddddddddxxxxxxxxxxkkOOkkkxxkOOkkOOkxxxl               
               ,ccccccccccccc..;ccccccldolc:::lcloxolloooodddddddxkkkkxxxxdxkOkkkkkkkkkkkkkkkkl               
               '::::cccccccc:..;ccccccllllc::codoodolccccclloodddxxkkxxxxxxxxkkkxkkkkkOkkxxxkkl               
               .,,,,;;;::::::..;c:::::clllcc::cxkdolcccccccccccclloododddddddxxxxdxxxxkkkkxxkOo               
               .,,,,,,;;;;;,,..,::::::cllccc:ccd0kdlccccccccccccccllllllllllooddddddddxxkkxxkOo               
               cdooooodddddo:,:ddddddddddddddddddddddddddxxxkkxkOOkkO0XXNNNNNNNXOO0kxdddkKxdxxl               
               :oooooooooooo:,:odddddddddddddddddddddddddxxxkkxxkOkO00XXNNNNNNNNXKXXkddxxOkxxxc               
               :oooooooooooo:';odddddddddddddddddddddddddxxxkxdxk0KKXXXNNNNNNNNNNNX0OxxxOOkddxl               
               :oooooooooooo:';odddddddddddddddxkkxxddddddxxkOkxOKXXXXNNNNNNNNNNNNXxdddxxxdddkd               
               :oooooooooooo:';odddddddddxddddxdxOOkkxxxddddxOOOOKXXXXNNNNNNNNNNNNNKOxdddxxxxxl               
               :oooooooooooo:';odddddddddddddddddk0OkxddddddxxkOOk0XXXNNNNNNNNNNNNNNNKxddxOKXk:               
               :ooooooooooooc';odoodddddddddddddddkkkxddddxxkOOkOxkKXXXXXXXXXXXXXXXXXXXK0kO0X0l               
               :ooooooooooooc';looooddooooodddddddddddddddxxO0000xkKXXXXXXXNNNNNNNNNNNNNNXXNNXk               
               ;ooooooooooooc';looooo:;,,'',cdddddddddddddxx0KXXKxOXNNNNNNNNNNNNNNNNNNNNNNNNXXx               
               ;ooooooooooooc';looool,;;,'...cdddddddxxxxxkkOKXXKxOXXXNNNNNNNNNNNNNNNNNNNNNNKkl               
               :ooooooooooooc,;lododdddl:,...;ooddddxkxxxxkO00KK0xOXXXNNNNNNNNNNNNNNNNNNNNX0Oxc               
               ;ooooooooooooc,,lododdc,;c:;;,;ooddddxkOOkkkkOOOOOxOXXXNNNNNNNNNNNXKXNNNNNNNX0xc               
               ;ooooooooooooc,,loooddddolc:c;cdddddddxxxkOOOkxkOkx0XXNNNNNNNNXXXXXKO0XXNNNNXOxc               
               ;ooooooooooooc',lodddddoolcccclodddddddddxxkkxxxxxx0XNNNNNNNNNNXKKKK0O0KKXNNXOxc               
               ;ooooooooooooc',loddddddolcc:::clloodddddddddddxxxxk0XXXXXXXXNNNXXXK0O0000KNNNXd               
               ;ooooooooooooc',ldddddxxdolc:ccccclooooddddddddxxxdxxOKKKKKXXXNNNNXKK0O00OO0XNNk               
               ;ooooooooooool',ldooddddoodlllcclllllcclddddddxxxxdxxxkOOOOkkO0KXXKOOkOO00OOKXNk               
               ;loooooooooool',looodooloooxkkxodoolcccclodddddxxxdxxxxdxkkxxxkk00OkxxxkO000KXXk               
               ;loooooooooool',looooolllodxOOO0Oxoccccc:coxxxxddddxxxxxxxxkkkxxkOOkxxxxkOO0KXXk               
               ;ooooooooooool',loooolcllodxxxkkkdlc::::;:cdkkxddddxxxxxxxxxkOkxxkkkkkkkxkOOOO0d               
               ;ooooooooooool''looooc:cloddoodxolc:;',;;::lkkkxxxxxxxkkxxxxxkkOOkkxxxkOkxxkOkkl               
               ;ooooooooooool''cooooc:clllloooolcc:;,:llc:cdkkxxxxxxdxxxxxxxxxkO00Okxxxxxxxxxko               
               ;loooooooooool''cooool:;cccodddolccllool::loxxxxxxxxxxxxxxxxxxxxxOOOOkxxxxddxxxl               
               ;ooooooooooool''coddolc;:ccldxdollxkdlllclddxxxxxxxxxxxxxxxxxxxxxxxxkxxxxxdddddc               
               ;ooooooooooooo''cooddo::clclolc::llccloddddddxxxxxxxxxdxxxxxxxxxdddxxxxxxxddxxdc               
               ;ooooooooooooo''cdkkocodolc::::;;;::::codddddxxxxxxxxxxddxkxxxxxxxxxxxdddddxxxxl               
               :ooooooooooool''ldxlcoddolcllcc::::c::codddddxxxxxxxxxxxxxkkxxxxxxxxxxxxxxxxxxxl               
               ;loooooooooool''looloodooccllllllcc::::loddddxxxxxkxxxxxxxxkkxxxxxxxxxxxxxxxxxxl               
               ;loooooooooool''loooooooolcooolc::::cccloddddxxxxxkxxxxxxxxxkxxxxxxxxxxxkkkxxxxl               
               ,ccllllooooool''coooooddddlcccc::::cllcloddddxxxxxxxxxxkkkkkkkxxxxxxkkxxkOOOxxxl               
               ,ccccccccclllc.':loooodddxxlcc::c:codolloddddddddxxxxxxxkkkkOOOkxxxxkkOkkOOOxxxl               
               ,cccccccccccc:..:ccccccclxxdlc::lcdkxdoloddddddddxxxxxxxxxxxkOOOkkxkkkkkkkkkkxxl               
               ,cccccccccccc:..:cccccccldddlc::clkkkxdloooddddddxxxkkxxxxxxxkOOkxxxkkkOkkkkkkko               
               ,cccccccccccc:..:ccccccclooolc::ccdOkkxllllllooddddxxxxxxxxxxxkkkxxxkkkkOkkxkxxl               
               ';;;;:::ccccc:..;c::::ccclllcccccclxkkdlccccccccclloodddddddxxxxxxxxxxxxkkkkxxxl               
               .,,,,,,;::::;;..;c::::::clllcccccccxkkolccccccccccclllllloooooodddddxxddxxkkxxxl               
               coooooodddddl,,cdddddddddddddddddddddddddxxxkOkxxOOkk00KXNNNNNNNNX0XKkddddOOkxxl               
               :oooooooooool,,cddddddddddddddddddddddddddxxkOkxxkO000KXNNNNNNNNNNNNXOxddxkkkxdl               
               :oooooooooooo,'cddddddddddddddddxkxdddddddxxxkOxxk0XXXNNNNNNNNNNNNNKxxxxxkOkxddl               
               :oooooooooooo,'cdddddddddddddddxxkkkxxdddddxxkOOkOKXXNNNNNNNNNNNNNNKOkddxxkxddxo               
               :oooooooooooo,'cdddddddddddddddddkOOkxxxxddddxkOO00XNNNNNNNNNNNNNNNNNXkdddxkkOOc               
               :oooooooooooo,':oodddddddddddddddxkOOkxdddddxxkkk0OOXNNNNNNNNNNNNNNNNNXKkxxxOXKl               
               :oooooooooooo,':oodddddddddddddddddxkxxddddxxO0000Ox0XXKXXXXXXXXXXXXXXXXXX0O0KXd               
               :oooooooooooo;,;oooooodddddddddddddddddddddxxOKKKKkx0XXXXNXNNNNNNNNNNNNNNNNNNNNk               
               :oooooooooooo;';oooooooodolllloddddddddddxxxkOKXXXkkKNNNNNNNNNNNNNNNNNNNNNNNNNXx               
               :oooooooooooo;';ooddddooc;'''.';ldddddxxxxxkkOKXXXkkXNXNNNNNNNNNNNNNNNNNNNNNNNKl               
               :oooooooooooo:,;oddddddl;;:;'...,ooddxkkkxxkO000KKxkXXXNNNNNNNNNNNNNNNNNNNNNX0Ol               
               :oooooooooooo:';oodddddddxdl,....cddddxkOOOOkkOOOOxkKXXNNNNNNNNNNNNKKKXNNNNNNXOc               
               ;oooooooooooo:';ooddddddl;;lc:;;'cddddxxxkkOOkxxkkxkXXXNNNNNNNNXKXXK0O0KXNNNNXkc               
               ;oooooooooooo:';oddddddddxxlccc:;ldddddddxxxkxxxxxxkKXXNNNNNNNNNXKKK0OO0KKXNNXOl               
               ;oooooooooooo:';oddddddddddocccccloddddddddddddxxxxxOKXXXXXXXNNNNNXXK0O00O0KXNNx               
               ;oooooooooooo:';oddddddddddolcccccclloxxdddddddxxxdxxk0K0000KKXXNNNXK0O000OO0XNk               
               ;oooooooooooo:';odooddddddddoc:cccclldxooddddddxxxdxxxxkOOkkxkO0KXK0kkkk000O0KXk               
               ;loooooooooooc';ooooddddooooollooloxOkdllloddddxxxdxxdddxxkkkxxkO00OkxxxkO000KXk               
               ;loooooooooooc';odoodddoooooodkOOxO00klllcloxxxxxddxxxxxxxxkOkkkkOOOkxxxxkOO0KKx               
               ;oooooooooooo:',ooooddddllloodkOOOK0koc:ccooxkxxxxdxxkkkkxxxkOkkkkkkkxkOkxkOOOOo               
               ;ooooooooooooc',ooooooooclloddxddk0Oxoc:ccollkkxxxxxxxkkkxxxxxkkOOkkkxxkOkxxkkkl               
               ;ooooooooooooc',oooooool::lodxdoldkdooc;ccollokxxxxxxdxxkxxxxxxxkO00Okkxxxxxxxxl               
               ;ooooooooooooc',oooooool::clooooooooloc:dxdllldxxxxxxxxxxxxxxxxxxkkkOkxxxxxxdddc               
               ;ooooooooooooc',loooooolc::clloddxxddddkkkdlooxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdddc               
               :ooooooooooooc''ldddoooolc::cloxkkdollccccclodxxxxkxxxxxkkkxxxxxxxddxxxxxxxxdxxl               
               ;ooooooooooooc''ldddddddc::;clldxxlccc;;::loddxxxxxxxxxxxxkxxxxxxxdxxxxxddxxxxxl               
               :ooooooooooooc''ldxdlcclccclccc::c:;;:;:::lddddxxxxxxxxxxxxxkxxxxxxxxxxxxxxxxxxl               
               ;ooooooooooooc.'loolccllooooccllcc::cccc::cddddxxxxxxxxxxxxxkkxxxxxxxxxxxxxxxxxl               
               ;ooooooooooooc.'looooooooooocloloodddolccccldddxxxxxxxxxxxxxkkxxxxxxxxxxkkkkkxxl               
               ;loooooooooooc.'loooooooooooclxxddollc:codoldddxxxxxxxxxkkkkkkkkxxxxxkxxkkOO0Oxl               
               ,ccccclllllooc.'loooodoooodddloxdolc:cokOOkdoddddxxxxxxxkkkkkOOOkxxxxkkOkkO0Okxl               
               ,cccccccccccc;.'ccllllooooodkollllcclokO00xldddddddxxxxxxxkkkkOOkkkxxxkOkkkOkkxl               
               ,ccccccccccc:;.':ccccccccccokdcccc:cloO000xloddddddxkxxxxxxxxxkOOkxxkkkkkkkkkkko               
               ,cccccccccccc;.':ccccccccccldxlc:::ccxO0K0klooodddddxxxxxxxxxxxkkkxxxxkkkOkkxxxl               
               ':ccccccccccc;..:ccccccccccllolc:::ccox0K0klcclllloooddddddxxxxxxxxxxxxxkkkkkxxl               
               ':::::ccccccc;..:ccc::cccccllllc:::cclx0K0Olcccccccccllloooddddddddddddddxkkkxxl               
               coooooodddddc,;odddddddddddddddddddddddddxxxk0OxxkOkkOKKXNNNNNNNNNKXN0xddddkkxdl               
               :oooooooooooc';ldddddddddddddddddddddddddxxxkOOxxk000KXXNNNNNNNNNNNNX0xddxkkkxdl               
               :oooooooooooc',ldddddddddddddddxkkxxddddddxxxOOkxOKXXXXNNNNNNNNNNNNXkdddxkOkxddl               
               :oooooooooooc',lddddddddddddddxxxOOkkxxdddddxxkOkOKXXNNNNNNNNNNNNNNNKOddxxkxxddc               
               :oooooooooooc.,lddddddddddddddddxk0OOxxxxddddxxkO0KXNNNNNNNNNNNNNNNNNN0xdddxO00l               
               :oooooooooooc',ldddddddddddddddddxkOOxdddddxxkOOOK0kXNXNNNNNNNNNNNNNNNNX0kxxk0Ko               
               :oooooooooool',loddddddddddddddddddxxxdddddxxO0KKKOx0XXXXXXXXXXXXXXXXNXXXXX00KXx               
               :oooooooooool',cooooooddddddddddddddddddxdxxxOKXKXOx0XXNNNNNNNNNNNNNNNNNNNNNNNXk               
               :oooooooooool',coooooddddddddddoooddddddxxxxkOKXXXkkKNNNNNNNNNNNNNNNNNNNNNNNNNXd               
               :oooooooooool',cooddddddddoocc:ccloddxxxxxxkkOKKXXkkXNXNNNNNNNNNNNNNNNNNNNNNNNXo               
               :oooooooooool,,cdddddddddl;'''....:ddxkkkxxxO000KKxkXXXNNNNNNNNNNNNXXNNNNNNNNKOl               
               :oooooooooool,,coodddddddl:loc,....lddxkOOOOOkkOOOxkKXXNNNNNNNNNXNNK00XNNNNNNNKl               
               ;oooooooooool,'cooddddddddddoc;....:oddxxkkOOkxxkkxkXXXNNNNNNNNXKKXK0OOKXNNNNNOl               
               ;oooooooooool,'cooddddddddo::lc::;'cddddddxxxxxxxxxkKXXNNNNNNNNNXXKKK0O00KXXNNKl               
               ;oooooooooool,'cdddddddddddxxlcccc:ldddddddddxxxxxdxOKXXXXXXXXNNNNNXK0O000O0XXNk               
               ;oooooooooool,'cdddddxxddddddoccccccoodddddddddxxddxxkO0000000KXNNXXK0OO00OOOKXk               
               ;oooooooooooo,'cooooddxddddddolcccccccldxxxddddxxddxxxxkkkkxxkkOKXK0OkxkO0000KXk               
               ;looooooooooo,':ooooddddddddddo::cllldkOkxdddxxxxxdxxddxxxkkkxxkO00OkxxxkO00KKXk               
               ;looooooooooo,':oooodddddddddoolcdkdO00KkdxdodxxxddxxxxxxxxkkkkkkO0OkkxxxxO0000x               
               ;oooooooooooo,':oooodddoooooooodk00kK000doxoooxxdddxxxkkkxxxkkkkkkkkxxkOkxkOOOOo               
               ;oooooooooooo,':ooooddddoooloooxkkkk000dlcdoxdxkxxxxxxxkkxxxxxkkOOkkxxxxOkxxxxxl               
               ;oooooooooooo,':ooooddddoolloodxxdox0OxdllxxkooxxxxxxxxxkxxxxxxxxO0OOkxxxxxxxxxl               
               ;oooooooooooo;';ooooddddolcclodxxdcokxxxolxkkodxxxxxxxxxxxxxxxxxxxxkkkkxxxxxdddc               
               ;oooooooooooo;';ooooddooolc:coodddoododxddO0kdkOkxxxxxxxkxxxxxxxxxxxxxxxxxxxddxl               
               :oooooooooooo,.:oodddddooolc:cokkxddodxkkOOOkxkkkkkxxxxxxkkxxxxxxxdxxxxxxxxxxxxl               
               ;oooooooooooo,.;oddoloollllcc:cdkolllllllcclooddxxxxxxxxxxkkxxxxxxxxxxxxddxxxxxl               
               :oooooooooooo,.;ooocccllccc:::clloooollc::::lodddxxxxxxxxxxkkxxxxxxxxxxxxxxxxxxl               
               ;oooooooooooo,.;oooooooooolccllccc:::;;:::::codddxxxxxxxxxxxkkxxxxxxxxxxxxxxxxxl               
               ;oooooooooooo;.;oooooooooooodolcloolc:codxl:cldddxxxxxxxxxxxxkxxxxxxxxxxxkOOOkxl               
               ;oooooooooooo;.;oooooooooooooolcoodxkkxxdoccccoddxxxxxxxkkkkkkkkxxxxxxkxkkO00Oxl               
               ,lllllooooooo,.;oooooooooooooddloxkxdoolccoxdooddxxxxxxxkkkkkkOOkxxxxxkkkkOOOkxl               
               ,cccccccccccc'.,lllloooooooodxOdlloolccclxOOOxdddddxxxxxxxkkkkOOOkkkkxxkkkkkkkkl               
               ,ccccccccccc:'.,cccccccc:clllxOxcccllloxO000OooddddxkxxxxxxxxxkOOkxxkkkkOkkkkkko               
               ,cccccccccccc'.,ccccccccccccldkxlcc::cldkO00xloddddddxxxxxxxxxxkkkxxxxkkkOkkxxxl               
               ,cccccccccccc,.,ccccccccccccclddoc:::clxO000kolllloooddddddxxxxxxxxxdxxxxkkkxxxl               
               ,cccccccccccc,.,cccc::::ccccclolcc:::ccdk000Odccccclclllodddddddddddddddddxxkxxl               
               coooooddddoc',oddddddddddddddddddddddddddxkkO0Oxk0000KXXNNNNNNNNNNNNN0xddddxkxxl               
               :ooooooooooc',odddddddddddddddxkxxxdddddddxkOOkdx0XXXXNNNNNNNNNNNNNNX0kddxOOkxdc               
               :ooooooooooc',odddddddddddddddxkOOkkxdddddxdxkkxk0XNNNNNNNNNNNNNNNNNXxdddxkxdddc               
               :ooooooooooc',lddddddddddddddddxOOOkxxdddddddxkOO0XNNNNNNNNNNNNNNNNNNKOxddxxkkkc               
               :ooooooooooc',loddddddddddddddddxOOOxdddddddxkO0KKOKXNNNNNNNNNNNNNNNNNNKxdddx0Xo               
               :ooooooooooc',lddddddddddddddddddxkkxddddddxk0KKKXkkKXXXXNNNNNXXXXXNXXXXKOxxxx0o               
               :ooooooooooc',cooooooddddddddddooddddddddddxk0KKKKkd0XXXXXXXXXXXXXXNXXXNNNNXKKXk               
               :ooooooooool',coooooooddddddddoooodddddddddxk0KXXXkxKNNNNNNNNNNNNNNNNNNNNNNNNNXk               
               :ooooooodool',cooodddddddddddooooodddddddxxkk0KXXKxkXNNNNNNNNNNNNNNNNNNNNNNNNNKo               
               :ooooooodool',coddddddddddddoooolllodxxxxxxkO00KXKxkXXXNNNNNNNNNNNNNNNNNNNNNNXXo               
               :ooooooooool',cddddddddddddddoc;''..';okkkkkkOO00OxOXXXNNNNNNNNNNNXKKXNNNNNNNXOl               
               :ooooooooool,'coddddddddddoool,;:;'...'okOOOkkkkOkxkKXXNNNNNNNXKKXXKOO0XNNNNNNKl               
               ;ooooooooool,'cooodddddddddddddkxo;'...:dxkkkxxxkxxOXXXNNNNNNNNXKKKK0O00XXNNNN0l               
               ;ooooooooool,':oddddddddddddddl;;c:,;;';oddxxxxxxxxOKXXXXXXXNNNNNXXK0000000KXNNx               
               ;ooooooooool,':ddddddddddddddddxdocccc,:ddddddxxxddxk0KKKKKKKXNNNNNXK0O000kO0XNk               
               ;ooooooooool,':dddddddddddddddddxdcccc:ldddddddxxddxxxkOOOkkkk0KXXXK0Okk000OO0Xk               
               ;ooooooooooo,':ooodddddddddddddddolccccccloddxdxxddxxxxxxkxxxxxk0K0OkxxxO000KKKk               
               ;loooooooooo,':ooodddddddddxxdddddo:cccloddkkxdxxddxxxxxxxkkkkkkkO0OkxxxkO0O0KKx               
               ;ooooooooooo,':oodddddddddddddddddoccxkOOOO0OxxxxddxxxkxxxxxOkkkkkOOkxxxxkOOOOOd               
               ;ooooooooooo,':oooddddooooddddddooook00kKK0KOkOxdoxxxxkkkxxxxxkOOkkxxxxkkxxxkOkl               
               ;ooooooooooo,';ooodddddddoooddoooodx0K00XKKXOkOxdxxxxxxkkxxxxxxkO0Okxxxxxxddxxxl               
               ;ooooooooooo;.;oooooddddddooddooooxkOOk0XKXXkkkkKxdxxxxxxxxxxxxxxkOkkkxxxxddxxxl               
               ;ooooooooooo,.;oooooddddoooodollodxkOxdkKKKKkO00kokkxxxxxxxxxxxxxxxxxxxxxxxxdddc               
               ;ooooooooooo;';ooooooooodooodoccldxkkdldOOO0xk00k0KOxxxxkkxxxxxxxxxxxxxxxxxxddxl               
               ;ooooooooooo;';oooooodccdxkxdocclodkkxddxxkOOO0kk00Okxxxxkkxxxxxxxxxxxddddddxxxl               
               ;ooooooooooo,.;oddddddcclk0koolx0OxxddxxkOO0KXK0KKOkxxxxxxkkxdxxxxxxxxxxdddxxxxl               
               :ooooooooooo,.;oooddoooooddollloxoolllldoooodxkxkkddxxxxxxxkkxxxxxxxxxxxxxxxxxxl               
               ;ooooooooooo,.;oooooooooooooolccllclloooollcc:llcldxxxxxxxxkkkxxxxxxxxxxxxxxxxxl               
               ;ooooooooooo,.:ooooooooooooooolcccllc:;::;;;:cl:::oxxxxxxxxxxkxxxxxxxxxxkkOOOOxl               
               :doooooooooo,.:oooooooooooooooooooocclllc:coxOxc::oxxxxxkkkkkkkkxxxxxxkkkkOO0Oxl               
               ;ooooooooooo,.;oooooooodoooooooooooc:cdxkOkkkdccccldkxxxkkkkkOOkkxxxxxkkkxkkOkxl               
               ,cccccllllll'.;loooooooooooooooooxOklcoxxdoollodxxdxkxxxxxkkkkOOOkkkkkkkkxxxkkxl               
               ,cccccccccc:'.,:ccccllcclloooooodkKklcldolllldk0OkOxxxxxxxxxxxkOOkxxkkkkOOkxxxxl               
               ,ccccccccc::'.,:ccccccccccccccllx00klccoolldO0KK00xdxxxxdxxxxxxkkkxxxxxxkOkkkxxl               
               ,ccccccccccc'.':ccccccccccccccclxOOkdl:::clxO0KKKklodddddddxxxxxxxxxddddxxkkkxxl               
               ,ccccccccccc,.'ccccc::ccccccccclxxdoc:;;;:ldOKKKKOolollloddddddddddddddddxxkxxdl               
               cooooooddo;';odddddddddddddddxxdddddddddxxkO0OxxOKKKXXNNNNNNNNNNNNNNXOxdddxxkxdc               
               :ooooooooo;';odddddddddddddddxkkxxdddddddxxkOkxk0XXXNNNNNNNNNNNNNNNN0kxddkOkxxdc               
               :ooooooooo;';odddddddddddddddxkOOOkxdddddddxxkkk0XNNNNNNNNNNNNNNNNNNkdddxxkxxddo               
               :ooooooooo;';oddddddddddddddddxO0OOxxddddddddxO0KKXNNNNNNNNNNNNNNNNNXK0xdddxxkxc               
               :ooooooooo;.;ldddddddddddddddddxOOOxdddddddxkO0KX0OXXNNNNNNNNNNNNNNNNNN0xdddx0Kl               
               :ooooooooo:',lddddddddddddddddddxxxxdddddddxOKXXXOxOXXXXNNXXXXXXXXXXXKKXK0Oxdk0o               
               :ooooooooo:',loooooooddddddddddddddddddddddxOKKKKkxOXXXXXXXXXXXXXNNNNNXNNNNXKXXk               
               :ooooooooo:',loooooodddddddddooooddddddxxxxk0KXXXOx0XXNNNNNNNNNNNNNNNNNNNNNNNNXk               
               :ooooooooo:',lddddddddddddddoooooddddddxxkkkOKKXXkxKXNNNNNNNNNNNXXXNNNNNNNNNNN0o               
               :ooooooooo:',ldddddddddddddoooooooodddddxxkOO00KKkxKXNNNNNNNNNNNXXXXNNNNNNNNXK0l               
               :ooooooooo:',lddddddddddddooooooocc:;,,;cdxkkOOOOxxKXNNNNNNNNNXXXXK00KNNNNNNXKkc               
               :oooooooooc',ldddddddddddddoooool;;::;'..'dxxxkkkxxKXNXNNNNNNXXKKXKOk0KXNNNNNXOl               
               ;oooooooooc',lddddddddddddddddddddkxo:,...:dddxxxdkKXXNNNNNNNNNXKKK0OO0KKXNNNXOc               
               ;oooooooooc',lddddddddddddddddddoc,,:;'',';dddddddx0XXXXXXXXNNNNNNXK0O00OOKXNNXd               
               ;oooooooooc',lddddddddddddddddddoddolc:c:,cdddddddxxO00000000XXNNNXK0OO00Ok0XXXk               
               ;oooooooooc''lddddxxddddddddddddddxkocccc:lddxddddddxxxkkxxxkO0KXK0OxxkO0O00KXXk               
               ;oooooooooc''cddddddddddddddddddddxxlccccccoodxdddddxxxxxxxxxxkO00OkxxxkO000KXXk               
               ;ooooooodol''cooddddddddddxxddddxxxddcccccccldkkxxxxxxxxxxkkkkkkO00OkxxxkO0000Kd               
               ;ooooooodol''coodxxddddddddxdddddxxxdlcddxkkkOOkxkkxxxxxxxxkOkkkkOOkkxxxxOOOkkkl               
               ;ooooooodol''cooddddddoodddddddddddooxk0XOO0000kkOkddkkkxxxxxkkOOkkxxxkkxxxkkxkl               
               ;ooooooodol''cooodddddoooodddddddoooox0XX00KKKKO00kloxkkxxxxxxkkOOOkxdxxxxdxxxxl               
               ;ooooooodol''coooddddddoooddddddoooodk00OOKXKXKk0OOxddxxxxxxdddxxkOkkxxxxxddxxxc               
               ;odooooodol'':dooddddddooooodddddoodxkkxdkKKKK0kkO0ddxxxxxxxddddxxxxxxxxddxdddxc               
               ;ooooooodol''cddoooooooooooooddddlldxOkxod0KKKOKXOdx0xxkkxxddddxxxxxxxxxddddxxxl               
               ;oooooooool''cddooooooooooooodddooloxOkxddkkOOkOK0KXKxxxkkxdddxxxxxxxxddddddddxl               
               ;oooooooool'.cddooooooooooolcoxxxdooxkkOOxxkO0KK0OK00odxxkkxddxxxxxxxxxxddddddxl               
               :oooooooool''cooooddooooooolccoxxxxdxxkxxOO0KKXK0KX0xldxxxkkxxxxxxxxxxxxxxxxxxxl               
               ;oooooooool''coooooooooooooolllllllcccldddxxxdkOkOOxoodxxxxkkxxxxxxxxxxxxxxxxxxl               
               ;oooooooool.'coooooooooooooooooollc::::;,;:::::lllcccdxkxxxxxxxxxxxxxxxxkkkkkkxl               
               :dooooooool.'cooooooooooooooooooool::cc;;::;;;coxo:::okkkkkkkkkxxxxxxkkkkOOOOOxl               
               ;oooooooool..coooooooooooooooooooooooo::cooodxk0OdccccdkkkkkOOOkxxxxxkkkxkkkkkxl               
               ,lllloooooc..cooooooooooooooooooooooooc::cdO0OkxlccllcoxkkxxkOOOkkkkkkOOkxxxkkxl               
               ,ccccccccc:..;ccllllllloooooooooooodxOkxlccloolllokdclodxxxxxkOOkxxxkkkkOkkxxxxl               
               ,ccccccccc;..;ccccccccccllllllllllodO00Okdc:cllodOklccldddxxxxkkkxxxxxxxkkkxxxxl               
               ,ccccccccc;..;cccccccccccccccccccclOK00kkdoccoO0Kdcccclodddxxdxxxdddddddxxxxxxxl               
               ,ccccccccc;..;::cc::::cccccccccccco0000kxdc:clxxklcllcloddddddddddddddddxxxxxxxl               
               coooodoc',cdddddddddddddddxkxxdddddddddxxkOOxxOKXXXXXNNNNNNNNNNNNNNXkdddkxdxdddc               
               :oooodoc',cdddddddddddddddxkOkkxxddddddxxkOOxxOKXXXXXNNNNNNNNNNNNNKkxdddOkxddddc               
               :oooodoc',cddddddddddddddddxkOOOkxxdddddddxkkk0KXXXNNNNNNNNNNNNNNNKxddddkkxddkkl               
               ;odddodc',coddddxdddddddddddxO0OkxddddddddxxkOKKXNNNNNNNNNNNNNNNNNNX0xdddkxkxdxl               
               :ooooooc',codddddddddddddddddxOOkxdddddddxOkkO00kKXXXNNNNNNNNNNNNNNNN0OxddxKXxoc               
               :ooooooc''cooodddddddddddddddddxxddddddddxO0000OdxKKXXXXXXXXKXXKXXXXXXK0Okxk00kl               
               :ooooooc'':ooooooodddddddddddoddddddddddxk0KKKKOdkKKXXXNNXNNXNNXNNNNNNNNNNXXXNXk               
               :ooooooc'':oddddddddddddddddooddddddddxxxk0KXXXOxOXXXNNNNNNNNNNNNNNNNNNNNNNXXXXk               
               :ooooooc'':oddddddddddddddddoodddxxxxddxkOOKXXKkx0XXXXNNNNNNNNXXXNNNNNNNNNNXOkko               
               :ooooooc'':ddddddddddddddddodddddxkkxdlccodk000xx0XXXXNNNNNNNNXK0KXNNNNNNNXOkxdc               
               :ooooooc'':odddddddddddddooodddddxkxl;,,,,,;:dkxx0XXXXNXXXXXKXXK0O0XNNNNNNNKkxdc               
               :ooooooc'':odddddddddddddddoooddddddclddoc;'.:xdxKXXXNNNNNXXK0KK0kO0KXNNNNN0kddc               
               ;ooooooc'':oddddddddddddddddddddddddxxoll:,'.'oxxKXXXXNNNNNNNXKKKOOO00KXNNNKkxdc               
               ;ooooool'':odddddddddddddddddddddddo:;.,:c;;;,ldxOKXXXXXXXXNNNNNXKOO00OOKXNNK0kc               
               ;ooooool,'coddddddddddddddddddddddddddolccc:::dddxkO00OOOO0KXXXXKKOkO0OOOKXNNNXo               
               ;ooooddl,':odddxxddddddddddddddddddddddocccc:oddddxxkkkxxxxk0KK000kxkOO00KXXXNXk               
               ;ooodddl'':odddxxddddddxddddddxdddddddxlccccccoodxxxxxxxxxxxkO00OkxxxkO00KKKKKXx               
               ;oooddol'':odddddddddddxxdddddxxxxxxxxxdccccccldkOOOkxxxkOkkxkO0OOkdxk00OOOOkkOo               
               ;oooddol'':oddddddddddddxxddddxxxxdxkxxxdlodddxkkkO00OkxxkkkkkkkkkkxxxkOOkkxxxxl               
               ;ooodool'';oodddddoodddddddddddddxxxxdddOxOKOOOOOO0O00OkxxxkOOOkxxxxxxxxkxxkkkkl               
               ;ooodool'';oooddddooddddddddddddddddooodOKXXOKK00K0OK0kdxxxxxkOOkxxxxxxxdddxxkko               
               ;ooooool'';oodddddddddddddddddddddddlllokKKK0XXXKK000kxldxxxdxkkOkxxdddddddddxkl               
               ;ooooool'';oodddddddoooooddddddddddollloxOOk0XXXXXOOOkkoodddddxxxxkxxxddddxxddxl               
               ;ooooool'';ooooooooooooooodddddddddoclodxkkxOXXXXKxOk0xlodddddddxxxxdddddddxxxxl               
               ;ooooool'.:ooooooooooooooodddddddddollldkkxdk0KKKOxKKkooxddddddddxxddddddddxxxxl               
               ;ooooool'.:ooooooooooooooooodddddddollldxkOkkOO00kxOKOO0Oxddddxxxxxxdddddddxxxxl               
               :ooooool'.:oooddddddooooooooddddddoolcclxkOOOO0K0kO0OO00Oddxxxxxxxxxxxddddxxxxxl               
               ;ooooool'.:oooooooooooooooooddddddooooodxOOOOOk0KXXXKK0Okdxxxxxxxxxxxxxxxxxxxxxl               
               ;ooooooc'.:oooooooooooooooodddddddddodxxkkxxxxxkkOOOkOOxddxxxxxxxxxxxxkkkkxxxxkl               
               :doooooc'':oooooooooooooooodddddddddoollcccclcccccloolcclkkkxxxxxxxxxxkOOOkkxxOo               
               :ooooooc.':oooooooooooooooodddddddddddoc:::::ccloddo::::lxOOOkxxxxxxxxxkOkkkxxkl               
               ;ooooooc.':ooooooooooooooooooooooooddddoccc:::lodk0d::::cokOOkkkkkkkkkkkxxxxxxxl               
               ;olllllc.':ooooooooooooooooooooooooooddkxxddl::::clcc::::cdkkkxxxxxxkkkkxxdxxxxl               
               ,cccccc;..;cccllccccllooooooooooooooodO0Okkkko::::ccoocc:cdxxkxdddxddxxxkxxxxxxl               
               ,cccccc;..;cccccccccccccccccccccccccoOK0Okxxkxlc::cdxocccldddddddddddddxxxxxxxxl               
               ,c:::cc;..;cccccccccccccccccccccc::coKK0Okxdoxkkl:cOklcccldddddddddddddxxxxxkkkl               
               cdddo;',oddddddddddddddxkkkxxddddddddxkkO0kxkKXXXXXNNNNNNNNNNNNNNNKxddxxxdddddo:               
               :oooo:';ldddddddddddddddxkOOkkxdddddddxxk0kxkKXXXXXNNNNNNNNNNNNNXOxddxkOxdodddo:               
               :oooo:',lddddddddddddddddxkOOOkxdddddddddxkkOKXNNNNNNNNNNNNNNNNNNOxddxxkxddkxxdc               
               ;odoo:',ldddddddddddddddddxk0Okxddddddddxxxx00KNNNNNNNNNNNNNNNNNNNXOdddxkkxddkOo               
               ;oooo:',lodddddddddddddddddxkOkxdddddddxOOkkOOx0XXXNNNNNNNNNNNNNNNNX0kddx0Xkddko               
               :oooo:',looooodddddddddddddddddddddddddxO00O0kdx0KXKXXXXXXXXKXXKXXXXK00Oxk0Okdoc               
               :oooo:',ldddddddddddddddddooddddddddddxk0KKXKOdxKXXXXNNNNNNNNNNNNNNNNNNNXXNNXKOl               
               ;oooo:',ldddddddddddddddooooddddddddxxxkOKKXX0xkXXXXXXNNNNNNXNNNNNNNNNNNNNKXXNXk               
               ;oooo:',ldddddddddddddoooooddddxxxxdxxoccllodddOXXXXXXXNNNNXXXXXNNNNNNNNNXOxkk0k               
               ;oooo:',ldddddddddddddoooodddddxkkkkxc;,,,,,,,ckXXXXXXXXXXXXX0O0KXNNNNNNKOkdddxo               
               ;oooo:',ldddddddddddddoooddddddxkkOOkolokxol;,,oKXXXXXXXXXKXX0OkOKXNNNNNNKkdddxl               
               ;oooo:''cddddddddddddddddddddddddxxxkkkkdol:,.'lKXXXXNNNXXK0KK0kO0KXXNNNN0xddddc               
               ;oooo:',lodddddddddddddddddddddddddxdc,:,.,cc;;lKXXXXXXNNNNXXKKOOO000KXNNKkxdddc               
               ;oooo:',lddddddddddddddddddddddddddddollllcccccxKKKKKKKKXXNNNXK0O000kk0XNNX0kxxl               
               ;oood:''cdddxxdddddddddddddddddddddddddoollccccdkOOOOOOOOKXXXXK0kkO00O0KXXNNXKkc               
               ;ooodc''cdddxxdddddddddddddddddddddddddddlccccccookOkxkxxxO000OOkkkO00KKXXXXXX0l               
               ;odod:''cdddxxdddddddxddddddxxxxxxdddddxdocccccclx0XXK0kkxkO00Oxxxxk000000000K0o               
               ;oddo:''lddddddddddddxxddddxxxxxxxxxxdddxxoccloodxk0KKKK0kxkOOOkxxxx00OkkkkxxkOo               
               ;oddo:''codxxddddddddddxddddxxxxdxkkxxxxxxkoxOxkOkO0K00K0OkkkkkkkxxxkOOkxxxxxkOo               
               ;oddo:''coodddddooddddddddddddddddxxkxdodxO0KKO00OO0K0KKO0xkOkxxxxxxxxxxxkkkkOOo               
               ;oodo:''coooddddoodddddddddddddddddxxdlllx0KXK0KK00KKO00kOdk0OkkxddxxxdddxxkkkOo               
               ;oooo:''coodddddddoodddddddddddddddxxoclldOKX00XXXXKKk0Ox0doxkkkkxdddddddddxkkOo               
               ;oooo:''coodddddddoooooodddddddddddxdl:llok0K00XXXXK0xK000dlddxxxxddddddddxxxkkl               
               ;odoo:''coooooooooooooooodddddddddddoc;cloxOOkOKKKK0kd0O00dokxxxxxxdddddddxxxxkl               
               ;dddo:''loooooooooooooooooddddddddddoc;:loxkOOO00000kdkO0Ok00kxdddxdddddddxxxxxl               
               ;oodo:''loooooooooooooooooddddddddoool:;cdxkOOO00KK0O0KXK00OOkxxddddddddddxxxxdc               
               :oooo:.'looooodddoooooooooddddddddddoolcloxkOO0OkkkOKXXXK0K00kxdddddddddddxxxxdc               
               ;oood:.'looooooooooooooooodddddddddddoc:ldkOkOkOkxdxkkxxxxkkdddddddxxxddxddxxxxc               
               ;oooo:.'looooooooooooooooddddoddddddddlcoOOkdllcccccccc::clodddxxxxxkkkkkxdxxxxl               
               :oooo:.'looooooooooooooodddddddddddddddodxkxlcccclodkkoc:cdxxxxxxxxxxOOOkxdxkkkl               
               :oooo:.'looooooooooooooooddddodddddddddoollc:::loOO00xlcccdkxxxxxxxxxkOkxxdxkkkl               
               ;oooo;.'loooooooooooooooooooooooooodddddooool::lcokkoooodlokkxxxxxkkkkxxdddxxxxl               
               :oooo;.'loooooooooooooooooooooooooooodxkkxxxdl:;:ccloxO0kdxkxxxxxxxkkkxxddddxxxl               
               ,lccc,.'clllooooooooooooooooooooooooodk0Okxxxdl;;cldxO00xkkxxddddddxxxxxxxxxxxxl               
               ,cccc,..:cccccccccccccccllllllllllllok0K0Okxdddodxk0KXX00Oddddddddddddddxxxkkkkl               
               ,cccc,..:ccccccccccccccccccccc::::::l0KKK0Oxoc:dxOKKKXXK0xldddddddddddxxdkOOOOkl               
               :;',lddddddxkdddddxxxkOOkkxxddddddxxkOOxxOKXXXNNNNNNNNNNNNNNNNNKxooxxdddddoooooc               
               ;;',cdddddddddddddddxxkOOOOkxdddddddxkOkkOKXXNNNNNNNNNNNNNNNNN0kxdxOOxdodddoooo:               
               ;;',cdddddddddddddddddxkO0OkxddddddddxxkOOKXXNNNNNNNNNNNNNNNNN0xddxkxdoxkxdoooo:               
               :;',codddddddddddddddddxO0OkxddddddddxxxxO00XNNNNNNNNNNNNNNNNNNX0xddxxkxdxkkdool               
               :;''cooddddddddddddddddddxkxdddddddxxO0Okxkd0XXXXNNNNNNNNNNNNNNNN0xddx00dox000kl               
               :;''coooooooddddddddddddodddddddddddxO000Okod00KXKKXXXXXXKKKKKXXXKK0OkO0xoodxkxc               
               :;',coddddddddddddooddooddddddddxxxxk0KK0xlcclooxKXXXXXNXXNNNNNNNNNNNXXXXKkdodxc               
               :;',coddddddddddddooddoodddddddddxxxk0Kk;;,;;:,''oKXXXXXXXXNNNNNNNNNNNXXXXXKK0Kd               
               :;''cdddddddddddddoodddddddxkkxxddxkOO0x:dOOOOo;'cKXXXXXXK0KXNNNNNNNNXKkkOKXNNNk               
               :;''cdddddddddddddoooodddddxkkkkkkxxkOOOodxxol:;':0XXXXXXKOOKXXNNNNNNKOkddxO0XNk               
               :;''coddddddddddddooooooddddxkkOOkkkxxkko,':;.';;c0XXK0000OkO0KXNNNNNNKxdddxOOkd               
               :,''codddddddddddddddddddddddxxxxkkkxddxxoolclc::dKXXXXK0K0OkOO0KXNNNNOxdddddddc               
               ;;''codddddddddddddddddddddddddddxxxdddddolllccccOKKXXXXXXK0OOOOO0XNNNKkdxxdddd:               
               ;;''codddddddddddddddddddddddddddddddddddddlccccclxk0KXXXXK0OOO0Ok0XNNNXOkxxddd:               
               ;;''codxxxdddddddddddddddddddddddddddddddddo:::cc::cdKXXXXK0kkOOO00KXNNNXKkxxxdc               
               ;;''codxxxdddddddddddddddddddddddddddxxxxdxOoc:cc:cokKXNXXXKOxkkOO0KKKXXXXOxdddc               
               ;;''coddddddddddxxddddddxxxxxxdddddddxxxxxkOdlloolxkOKKKKKKK0kxkO0OOOOkkOOOkddd:               
               ;;''cddddddddddddxxddddxxxxxxxxxxddxxxddddkkxOOOxxkO00K0OKKKKKOkO00kxxxxxkOOxdd:               
               ;;''codxddddodddddxxdddddxxxxxxkxxxxxkdlloxO0KKK0OOO0KX0d0000KKOkkOxxkkxxkO00kdc               
               ;;''cdddddddooodddddddddddddddxxxkkkOkllllx0KKK00KK00KX0lOKKOXNKOkxxxxkOkkO0XX0l               
               ;;''coddddddoooddddddddddddddddxxxxkkd::loxKKXK0KKKKKKK0lxKXXXXX00kxddxkkkO0KXNx               
               ;;''coddddddddoodddddddddddddddxxxxxxl,,cod0KK000KKKKKKkldO0OOKXO0XOxddxxkOO0KXk               
               ;;.'coodddddddoooooodddddddddddddxdddl;;:lok0K000K0dx0OxcclxkO0Okk0OkxddxkOOO00d               
               ;;.'cooooooooooooooooodddddddddddddddol::coxO00000K0000kc:ckKXNXXKKKOxxddxkO0KKd               
               ;,.'loooooooooooooooooddddddddddddddddoc:clxkOOO00000K0Oxddx000Oxkkkxdxkxxdxk0Kx               
               ;,.'loooooooooooooooooddddddddddddddddoc:coxkkkk0KKK0Okdolloddoc:cloddxkkddddxOd               
               ;'.'looooooooooooooooooodddddddddddddddddxkkdldxkkkOOOkollllll:;;coddddxxxddddxl               
               ;'.'ldoooooooooooooooooodddddddddddddddddxkdl:::::;;;;;;:ccooooloddddddxxddddddc               
               ;'.'loooooooooooooooooooooddddddddddddddoool:ccddolddxkdc:cdddddxkkkxxxxkkxdddxc               
               ,'.,loooooooooooooooooooooddddddddddddddollc:;oO000O0OdlcccoxxxdxxkkxxdxOOkkxxkl               
               ,'.,looooooooooooooooooooooddddddddddddoollloldkOOkkkdooddooxxxxxxkkxdddxkxxxxxl               
               ,..'loooooooooooooooooooooooooooodddddddooooodddlododdxO0kdxxxxxkkxxddddxxxxOOOl               
               ,..,looooooooooooooooooooooooooooooddddxxdoloddddllodxOKOxxxxddxxkxxxxxxxxxxxOKd               
               '..,loooooooooooooooooooooooooooooooodkOOkxdocccldxO0KKK0Okddddddxxxxxxxkkkxdxkx               
               '..,clllllcllllloooooooooooooooooooodk0K0xolcc:clodk0KKK0OloddddddddxxkkkOOkxxdl               
               ...'cccccccccccccccccccccccccccccloodOK0OOkxocldddxOK0KKKxcoddodddddxxOOkkOOkxdc               
               'lddddddxdddddddxxxOOOOkxxdddddddxkOkkO0XXXNNNNNNNNNNNNNNNNNXkdddxdoodooolodkxdl               
               'ldddddddddddddddddxO00OkxddddddddxkkO0KXXXNNNNNNNNNNNNNNNNXOxddxkxdodddolloodOd               
               'lodddddddddddddddddkO0OkxdddddddddxxkOKXNNNNNNNNNNNNNNNNNNXkxddxkxddxxddooooodc               
               .lododdddddddddddddddkOOkxddddddddxkkxk0OKXNXXNNNNNNNNNNNNNNXKkddxxxxxxkxoooxko:               
               .cooooooooddddddddddddxxdddddddddxk00OkOxxKX0OO0KXXNNNNNNNNNNNXkddxOKxod00kxk0Ol               
               .lodoooddddddooooooooodddddddddddxk00K00xdddlc:;:okKXXKXKKXKKXKK0Oxk0kdookOkdxko               
               .lodddddddddddoooooodddddddddxxxxk0KXXXKxc;::::;;,'kXXXXXXNNNNNNNNXXXXKkooxxoooc               
               .lodddddddddddooooddddddddddddxxkkOKXXXKxccOKK0Oxc,dXXXXXNNNNNNNNNNXXNNXKOO0Oxo:               
               .lodddddddddddddodddddddxxkkxxxxkO00KKK0xl:lllol:,,kXKK00XXNNNNNNNXXkkOKXNNNX0xc               
               .lodddddddddddddoodddddddxkOOkxxxkOO00OOdol:';o,.,:kKXKOOOKXXNNNNNK0kddxOKXXX0dc               
               .lodddddddddddddooddddddddxkkOkkkxxkkOOxddxdoolclclkO00OkkO0XNNNNNX0xdddxOkO0Od:               
               .loddddddddddddddddddddddddxxxxkkxdddxkxdk0dllcccl0K0000OkOO0KXNNNN0xddddddddddc               
               .ldddddddddddddddddddddddddddddxxdddddddxOXOolcccck0XXXKKOOOOkkKNNNKxdddddddood:               
               .ldddddddddddddddddddddddddddddddddddddddk00dc:::::cldOKKOOOOOkOKNNNXOkxxdddddd:               
               .ldxxxddddddddddddddddddddddddddddddddddxxkOklccc::ccd0NNXKK0O000XXXNXKkxxddddd:               
               .ldxxxddddddddddddddddddxxddddddddddxxdxxxkOxldddcccd0XXXKXXKK0O0KKKKKKOxdddddd:               
               .ldddddddddddxxxddddddxxxxxxxxdddddxxdoddxkkxkOkxoxk00KX00KKXXK0OOkkkkOOxdddddd:               
               .ldddddddddddxxxdddddxxxxxxxxxxxxxxxxoloodk00KK00OOkk0KXkkK00KKKKOxxxxk0Oxddddxc               
               .lddddooooodddxxddddddxxxxxxxxxxkkkkklcoodOKXKKKK0000KXKdoO0KK0XXK0kxkkOK0kdddxo               
               .lodddooooooddddddddddddddddxxxkOOOkx:;codOXXK00KKKKKKK0oox0KKKXXXXK00OO0KKOdddl               
               .loodddoooooodddddddddddddddxxxkOOOkd;,;cdOKK000KKKKKKKOdkkkO0kkOKKkkkkO0KXX0kxl               
               .loodddooooooodddddddddddddddxxxxkkkxc;;coxO00000KOkOOOdolookxoxO0kkxdoxk0KXXX0o               
               .looddooooooooooodddddddddddddxxdddxddc:ccdk0000000kO0Ooccocxxx0XNXKKKOxkOO0KKKd               
               'looooooooooooooooddddddddddddddddddddl,:cokO000000000Oocldlodx0000klodxkO000K0o               
               'looooooooooooooooddddddddddddddddddddoooodxkOO0000OOOkdoodddxxxdddo;;loxk0K00Ko               
               'loooooooooooooooodddddddddddddddddddddddxxdlxkkkkkkkxdc:coooolcllcccoddddx00OOo               
               'ooooooooooooooooooodddddddddddddddddddddooc:;::;,,,;;;;::lddocccllodddddddxkxxc               
               'ooooooooooooooooooooddddddddddddddddddxdll:;::cc:;:cldolcldddddddddxxdddxxddddc               
               ,oooooooooooooooooooooooddddddddddddddddollcclxkkxxxk00xolcodxxxxxxxxOkxddxxdddc               
               ,oooooooooooooooooooooooddddddddddddddddolloddxO00OxOkooooooddxxxxxdxkOkxxxxdddc               
               ,ooooooooooooooooooooooooddddddddddddddoollodkkkxdddxooxkOookxxxxxdddxxxxxxddxxc               
               ,oooooooooooooooooooooooooooooddddddddoooooooooolcododxk0kddxxxxxxxxxxxxxO0OxkOo               
               ,ooooooooooooooooooooooooooooooooddddddddolllooollcclx0K0kOddxxxxxxxxxxxdk0KOOOd               
               ,oooooooooooooooooooooooooooooooooodddxkkkxdoc:;ccoxO00KK0xoodddddxxkOOkxdxO0Okl               
               ,loooooooooooooooooooooooooooooooooodxO00kdlc:cooloxkO0KKOllodddddxkkkOOkxdxk0kl               
               ,ccccc:ccclllllllllllllllllllllloooodkKKOkkxocoooddxOKKKKOlldddddxkO0OOOOxddddxc               
               cdddddddddddxxk000OOxxddddddxxkOkkOKXXNNNNNNNNNNNNNNNNNNKxdddxoodoooookkdodooooc               
               :dddddddddddddxkO00OxxddddddddxkkOKXXXNNNNNNNNNNNNNNNNNXkxdxkxdodooooooddxxdooo:               
               :oddoddddddddddxO00Oxdddddddddxxxk0XXNNNNNNNNNNNNNNNNNNKxddxkkdoddddoooodkxoool:               
               ;odoodddddddddddxkOkxddddddddxkkkxOK0KNNNNNNNNNNNNNNNNNNXOxdxxxxxkxdooodoooolll:               
               :ooooodddddddddddddddddddddddk000OO0xkXXXNNNXKOOO0KXNNNNNXOdddk0kdx0xxxOOdoolll:               
               ;odddddddooooodddddddddddddddk00KKK0xx0KKX0kolcc:;;lOKKKKKX0OxdOkdoxOOkkOOkddol:               
               ;odddddddoooooddddddddddddxxxOKXXXXKxkKXXXdcccool:;;kXXXXXXXXK0KK0xodddoooooool:               
               ;odddddddoooooddddddxxddddxxkO0KXXX0xkXXXXo:d0KKK0x:dXXXXXNXXXXXNNXOkkkxooooodd:               
               ;dddddddddooddddddddxkkkxddxOO0KKXK0xOXXXXo;cc;;:o:,lKXXXXXXXXXKO0XNXXXKkdxxddxl               
               ;dddddddddddddddddddxkOOkkkxxkO0000kx0XXXKoldl,;ox;;oKKXXXNNNX0Oddx0XNXKxodOxdxo               
               ;ddddddddddddddddddddxkkkkkxxdxkOOOxx0XXXXOddooddlcoxO00XNNNNXKkdddkOO00dodkxodl               
               ;dddddddddddddddddddddddddxxdddddxkxx0XXXXXkllodoccxkkOOOKXNNNKkddddxxddooooddd:               
               :dddddddddddddddddddddddddddddddddddxKXXXXKOollllck0OOOOkk0NNNXkddddoddoooooddoc               
               :dddddddddddddddddddddxxddddddddddddxO0000Oxoolc::coxkOOOkOKXNNXOxddddddooooood:               
               :dddddddddddddddddddddxxxxddddddddddddxxxxkkxdolc::c:cdO0000KXXXKOxdddddooooddd:               
               :dddddddddddddddddxxdddxxxdddddxxxddddddddxOdxkkklcccdOXXXXKK0OO00xdddddooddddd:               
               :ddddddxkkxdddddxxxxxdddxxxdxxxxdddollldxk0OO00OdxkxkO0KKKKXK0OkkOkdddoodddddddc               
               :dddddddxxxdddddxxxxxxddxxxxxxxxxddlclldOKXXXKKK0Okxxk0Kk00KKKK0000kdodddddddddc               
               :dddddddddxdddddxxxxxdddxxxkkkkkxdo;;lodOKXXXKKKK00OO0K0xO000KKKKKKKOxddxkkxddko               
               ;dddodddddddddddddddddddxxxOOOOkkxc,,:lokKKXXKKKKK0000OddO0KKKXXXXKXKKkddxO0kxko               
               ;oddddodddddddddddddddddxxxkO0Okkxl;,;clxO0KK00KKK0000kdkOO0KKK00XXKKXXOxxOXXOko               
               ;oddooooddddddddddddddddxkxxkkkkxxdc;:cloxkO0OOK0OOO0OxOkOxdOOddk0kxxOKXKOOKXOxl               
               ;oooooooodddddddddddddddddxddddddddo:::codkkOOO00kxOOdcldkdxdldk0XNXK0kkXKOKXKkl               
               ;ooooooooodddddddddddddddddddddddddo;;:ldxxdkOO00000Odcokdlodlok0XXXOddk0KXKKXXx               
               ;oooooooooooddddddddddddddddddddddddddooddd:oxO0OkkO0xoxkdddooddxO00kccxK00Ok0Xk               
               ;oooooooooooodddddddddoodddddddddddddxddool;cdxxxkxddoloddddddoxxdk0OxxkOkxxxxko               
               :oooooooooooodddddddddddddddddddddddddxdl:''';c,,,;:;;;:cdddddddddddoooddxxxxxxl               
               ;ooooooooooooodddddddddddddddddddddddddoc::;;:cc:;:coxlccddddddxxdolcclodxOOkxko               
               ;ooooooooooooooddddddddddddddddddddddxdlccododxxdokk00xlcokkkxxkOOxoooodddxkOxxc               
               :ooooooooooooooooooooodddddddddddddddddlcclodkO000OOOollooxxxxxxkkkxxxxdddxkkxxl               
               :oooooooooooooooooooooodddddddddddddddolllloodkkOkxxdodkOddxxxxxxxxxkxxdddx0Okkl               
               :oooooooooooooooooooooooooddddddddddddollllldxxoccododkOxodxxxkxxddkKK0kO0kk0Oxl               
               :ooooooooooooooooooooooooodddddddddddddoooooollclllccdO0xxdddxxkkxdxkOKOkkkxxxxc               
               :oooooooooooooooooooooooooooooooddddddxxxdolllcc::;cx00OOxlddxxkkOkxdxO0kdxxxxxc               
               :ooooooooooooooooooooooooooooooooodddxkOkkxxo:clc;:dkOOOOdlddxxxxkkxdddxxddxxxxc               
               :ooooooooooooooooooooooooooooooooodddxO00Oklc:odl;lkOOO00xoddxxxxxxxdddddxxxxxxc               
               cdddddddxxxk00OOkxddddddddxkOOkOKXNNNNNNNNNNNNNNNNNNN0xddxxoooooooOkdodooodOkoo:               
               :ddddddddddxO00OkxdddddddddxkkkOKXNNNNNNNNNNNNNNNNNN0kxddxxoooooooddddddooooooo:               
               :oddddddddddkOOOkxdddddddddxxxk0KXNNNNNNNNNNNNNNNNNX0xxxxkxdoddoooooxOkdlllllll:               
               ;ooddddddddddxxxxdddddddddxOOkx0K0KNNNNNNNNNNNNNNNNNXKkxdxxdxkxdoooooodolllllll:               
               :ooooooooddddddddddddddddxk0K0000kkKXNNNNNNNNNNNNNNNNNXkddxOOdxkkddOkolllllllll:               
               ;oodddoooodddddddddddddddxk0KKKKKxx0KKKXXXXK0kddddxOKXXK0kxO0dodOOkkOOxodoooddl:               
               ;oddddooooddddddddddddxxxxkKXXXXXxxKXXXXXXOoc:;,,,,;dKXXXK00K0kdodddddddxxooool:               
               ;oddddddooddddddxxxxxxxxkOO0XXXXKxkKXXXXXKc::okkkoc:OXXXXXXXNNXKkxkxdooooooooxx:               
               ;dddddddooooodddxkkkxxxxkO00KKKK0xkKXXXXX0;;lxxkO0klkXXXXXXX0KKXXXXKOdoxdddoood:               
               ;dddddddoooodddddxkkkkxxxxkOO000OxOKXXXXXk:,::,'.:;'lKXXXXXKkxx0XXXXkdokxdkkddxc               
               ;oddddddddddddddddxxxxkkxxxxkOOOkdOXXXXXX0doxxocokl;xKXXNNXOxdddO000xookkddkkk0o               
               ;ddddddddddddddddddddddxdddddxxkxdOXXXNXXXOoddddxocdO0KXNNNKxdddxkdodooodooxkOOl               
               :ddddddddddddddddddddddddddddddddd0XXXXKKK0ooodxdlokOkkKXNNKxddddddooooooodxxxdc               
               :dddddddddddddddddxxxxddddddddddddk0000OOOxdddocclkOOOk0KNNX0xxdddddooooooddkkkc               
               :dddddddddddddddddxxxxxxddddddddddxxxxxkkkkkOkoccccokO0O0XXXX0xddddddoooooddodkl               
               :dddddddddddddddddddxxxxdddddddddddddddxxxO0Okdoc:::coxO00OO00kxddddddoooddddddc               
               :ddxxxxdddddxxxxxxdddxxxxxddxxddddoooooxk00kO000kdlcldxKKKOxkOkxddddddddddddxOxc               
               :dddxxxdddddxxxxxxxxddxxxxxxxxxdddlclodOKKKKKK0kk0Okk0KKKKK0OOOOkdddddddddxdxxOo               
               :ddddddddddddxxxxxddddxxxkkkkkxddlcclodOKXXXXKKKK0kkkOKO0KKKK000Kkddxxkkxxkkxxxl               
               ;odddddddddddddxxxddddxkOOkkxxxdl;;:lloxKXXXKKKKKKK0000k0000KKKKKKOxddk0OkkOOOOo               
               ;oddddddddddddddddddxxxxOOkxxxxl:,,;clldO0KK00KKKKKKK0kk000KKKKKKKK0kxkKKOk0KOOd               
               ;oooooddddddddddddddxxxxxkkxxxdl:;,;clldxkO0OOKKK000Kkx000KXKXXXXXXXX0O0XOk0XXOl               
               ;oooooddddddddddddddddxxddddxxddl:::clooodxkkO00OOO0Ok0OkxOKOxkK0OOXXK00K0k0NNXx               
               ;oooooodddddddddddddddddddddddddoc;;::ldxxxkkO00OOOOolokOxoddxO00OOKKKKKXXXNNNNk               
               ;ooooooooddddddddddddddddddddddddc,;clxkxddxxOOO000kodOOdxxlk0XNNXKO000OO0XNNNXk               
               ;oooooooodddddddddddooooddddddddddddoldxxoldxOkxxkOkodkxdddooo0XXKkldkkkxxOKNNNk               
               :oooooooodddddddddddddddddddddddddddddool::lxxdxxdoooodddddddddxkOOxdxkkxxkkOKXk               
               ;ooooooooddddddddddddddddddddddddddxxxl,''',:;,;;c:;;:codddxxxddxkOkxxkOkxkkk0Kx               
               ;ooooooooooddddddddddddddddddddddddxxdc:;;;::cc::ldOxlcoxxxxOOOxxddooodkkxxxxOko               
               :ooooooooooooooooodddddddddddddddddxxoccc:cccoxxOO0Odlloxkxxkkkkxdollodkkxxxxxxc               
               :ooooooooooooooooodddddddddddddddddddlcccccoxO00OkOxddkxdxxxdxxxkkxxxxk00kxxdddc               
               :ooooooooooooooooooodddddddddddddddddlccclllodkxxdkoxO0xdxxxxdddkK0OO0OkOkxddddc               
               :ooooooooooooooooooodddddddddddddddddoollllodoc;lddodkkdxxxxkxxddk0Okxxxxxddxxdc               
               :oooooooooooooooooooooddddddddddddddddddddoollcccccd00Okdoxxkkxxddk0Oxdxxdxxxxkl               
               :ooooooooooooooooooooooooooodddddxxxxxkkxdolccc;;cxO0OOkldxxxxxxddddxxxddxxxxxxl               
               :oooooooooooooooooooooooooooodddxxxxxkOOkxddccl;;okOOOOkodxxxxxxxddddxkxddxxkkxl               
               cdddddOK0OOkdddddddddxkOOkOKNNNNNNNNNNNNNNNNNNNXOddxOxxkdooxxooooooxOOxoloolllo:               
               :oddddk000OxddddddddddxkOO0KXNNNNNNNNNNNNNNNNNNX0xddxxoooooodxooooodkkdlllooooo:               
               :ooodddkOOkxdddddddddddxxkOKXXNNNNNNNNNNNNNNNNN0xxdxkdoooooloddddoooooolllloooo:               
               ;ooooddddxxddddddddddxkOkxOKKKNNNNNNNNNNNNNNNNNKkxxxkxddddoooookxolllllllllllll:               
               :oooooooddddddddddddxkOK0000OxKXNNNNNNNNNNNNNNNNN0xdxxxxxxdoodoooolllllllllllll:               
               ;oooooooddddddddddddxkO0KKKKOdOXXXXXXXXXXXXXXXXXXXKkdx00ddkOxxOxolllloolooollll;               
               ;oooooooddddddddxxxxkO0KXXXXkd0XXXXXXXXXXKOxdooddxkOOxkOxookkxxkxdxdoodlodddooo:               
               ;ooooooddddxxxdxxxkkOO0KXXXXkxKXXNNXNNNX0dc::;,,,;:kXKXKKOdodooooodxdooollllllo:               
               ;oddoooddddxkkxxxxxkO00KKKKKxxKXXNNXXXXKc,,;:odxocdKXXKKXXKOkkxdoodxxodxooooooo:               
               ;oddoooodddxkkxxxxxxxkOO000OxkXXXNXXXXKO,',:oxkOOkxXXXKOk0XNXXKkddxxkooolooodkxl               
               ;oddddddddddxxxxxxxxdxxkO00OdkXXXXXXXX0d''':c:;,;::dK0OxddkKXXOddddodddxxdooldOd               
               ;dddddddddddddddddxxddddxkOkxkXXXXXXXXK0dodxkxlcxxlOXXKxddxOkkxdoddooxkOOkxoooo:               
               :dddddddddddddddddddddddddxxdkKXXKKKXXXX0doxkkxxdlOXXX0xdddddoooooooodxxxdxdoodc               
               :dddddddddddddxxdddddddddddddxO000OO00KXXkxxddxxodOKXXKOxdddoooooooodxkxdooooodc               
               :dddddddddddddxxxxxxddddddddddxxxxxxxkO00xkkxllldO0KKXXKOdddoooooooooodkxdddoodc               
               :dddddddddddddxxxxxxxxxxddddddxxxxxxxkkkOOOOkoccldk0000KOxdoooooooooooodxddddodc               
               :dddddddddddddddddxxxxxxxdddddxxxddddddxO000kdlcc:coxxkkkxdoooooooodddxxdodddodc               
               :ddddddxxxxxxxddddddxxxxxxdddddddoooodxk0K0kO0Odocc:cdkkkOxdodddddddddxkOxddddd:               
               :ddddddxkxxxddxxddxxxxkkxxxdddddoclloxO0KK0KK0kkOkoldxkOO00kdddxxxxxxxxxkxxkxddc               
               ;oddddddxxkxxxddddxxxxkkkxxddddol:llodk0XXXKKKKKK0OOKkk000K0OxddxOkkkOkkkddxkxxl               
               ;oddddddddxxxxddddxxxxxxxxddddolc:clloxOKKK0KKKKK00KKxO0000KKOxdx0KkO0KO0kxOXXOc               
               ;oddddddddddxxddddxxxxxxxxdddolc;;cllloxO0000KKK000X0ok00O00KKK0k0Kkx0X0kOOKNNKl               
               ;oddddddddddddddddddddxxxdddocc;,,:clloxkkOkk00K0000dck00O000KKKOO0OxKXXKKXXNNNx               
               ;oddddddxdddddddddddddddddddl::;,';clooddxkdx00OOOOkdckOOk0KK0KKKKKXKXNNNNNNNNNk               
               ;oodddddddddddddddddddddddddocc:;';coddddxkxk0OkkOklccoxxxkk00K0O00KXNNNNNNNNNXk               
               ;ooodxxdodddddddddddddddddddollc:;ccldxkkkkkkOOOOkxcc:dKXNX0Okkkkkxk0KXNNNNNNNNk               
               :ooodddddoooooddddddddddddddolccc:::lodkOOOkkxoxxxdcc:xKKK0xxxddkxxxxk0XNNNNNNNk               
               ;ooodddddoooooddddddddddddddolcccc::cloxOOOOkxxdoooooodkOO0O0OxxkkkxkkO0XNNNNNNk               
               ;oooddddddooooddddddddddddddddollol;;;:clodoc:cl::ldxddxddxxxxddxkkxxxkOOKNNNNNk               
               :ooooooodoooddddddddddddddddddddxkxo:::ccc::;;::ldooxxxkkkdlloodxkxxxxxxxOK0KKXx               
               :oooooooooooooddddddddddddddddddO0Odc:cloddddddkOkoodxdxxxxxxxxxxO0kxxdddxxxddxl               
               :ooooooooooooooodddddddddddddddxOOOo::clldxkOOkkkooddxxdddxO0kkOkkOxdddddddddxdc               
               :oooooooooooooooddddddddddddddddxxdc:::clodxkxdkdd00OkkxxddxOOkxxxdddddxxdxxkOkl               
               :ooooooooooooooooodddddddddddddddoolc:cldxxoclddok00OOkxxdddxOkxdddddddxkkdkkxxl               
               :ooooooooooooooooodddddddddddxxddodxoc:clooolllox0K00Okxxddddddxxxddxxxxxxdxdddc               
               :ooooooooooooooooooooddddddddxxdodkOko::lddoodO0KKK00Okxxddddddxkxddxxxkxdddocc;               
               cxO00OkkxdddddddddxkkkOKXNNNNNNNNNNNNNNNNNKKOdodkkdkdoodoooooldkkkddddoolllooll:               
               cdxO00OkxdddddddddxxkkOKXNNNNNNNNNNNNNNNNNNNKxdoxkdddooodoooolodOkdolooloololll:               
               :ddxkkkxddddddddddxxxkOKXXNNNNNNNNNNNNNNNNNN0kddxxoooolloooodoloodollllooolooll:               
               ;odddxdddddddddddxkkkxk0XXXNNNNNNNNNNNNNNNNXkxxkkkdooooolloxdollllllllllllldOkko               
               ;oooddddddddddddxxO0K0O0KOOXNNNNNNNNNNNNNNNNKOxxxxxdxxdooooddolllllllllllllokOOl               
               ;oooodddddddddddxxk0KK000kx0XXXXXXNNNNNNNNNNNNOdodkOxdxxddkoolllllllllllllllodxl               
               ;ooooddddddddxxxkk0KXXXXKxd0XKXXXXXKXXKXKKXKKKK0kdk0kodOOkOkdoooloolooooollloooc               
               ;ooodddxxxdxxxxkOO0KXXXXKxx0XXXNNNNNNXXXX0koloodxk00Odooddoddddxdolllooooolodddl               
               ;ooddddxkkxxxxxkO000KKXX0xxKXNNNNXNNXXKkl;;;,,',,cOKXX0xdxoooooddoddllllllolllo:               
               ;oodddddkkkkkkxxxkOO0000OxkKXNNNNXXXXXO;',,;cllc:x000KXXKKOxddxxxoodooooodoolll:               
               ;odddddddxxxxkkxddxxO0KKOdkKXXXXXXXKKKk,',cdkkOOxxOOdxOKXX0xoxddxddooooodOOkdol:               
               ;oddddddddddddxxddddxkO0kdOXXXXXXXXK0Oo''':cc:;:::oxdddkO0OdoddoddxOkxdoloxO0Oo;               
               :dddddddddddddddddddddxkxxkKXXXXXXXXXKklloxkxccxxckkdodxxdoooodoodkkkkxoodxOOxd:               
               :dddddddddddddddddddddddddk0K000O0KXXXXOdxkkOkxdoOKkddddooooooooddddoooooodxxdd:               
               :dddddddddddddxxxxxxdddddddxkkkxkkk0KKKKxdxdxxxoo0XKOxddooooooooodkkdodoookkxdd:               
               :ddddddddddddxxxxxxxxxddddxxxxxxxxxkO00Okkkdloodk0KK0xddoooooooooodxxdddoooddodc               
               :dddddddddddddddxxxxxxddddxxxxxdxxxkkkkkkOOkdccodkOOOkdoooooooooodddoodddooooodc               
               cddxxxxxddddddddxxxxxxddddxxxxxxxxxxddxO000Oxocc:cloxkxdooooooddddxOxddddoooddoc               
               cdxxxxxxddxxddddxxkkkxdddddxxxxxdddddxkO0KKkkOklccccdk0Ododdddddxxxxkxkxdoooodd:               
               :dddxxxxddddddddddxxkkxdddxxxxxdoloooxO0KK0K00kxdccldkO0Oxddxkxxkkkxxddxxdodddd:               
               :dddddxxxdddddddddxxxxxdddddxxxolcclodk0KKKKKK0O0kdxxxO0K0xddO0OO000OxxOKOddoooc               
               :dddddddxdddddddddxxddddddddxxollcclloxO0K00000KK0OKxxk00KKOxOKOk0KOOOOKXXxooooc               
               ;dddddddddddddddddxxxxdddddddollc;cloodkOOO0O00KK0K0oxxO00KKOO0OxKXK00KXXXOddddc               
               :ddxdddddddddddddddddddddddddlcc:,:loddxkkOOkO00000dlxdk000KKKKK0XNNNNNNNNKxdddc               
               :dddddddddddddddddddddddddddolc:;,:ldxxxxkOkdk0OOOklcook00K0O00KXNNNNNNNNNXkxddc               
               cxxdddddoddddddddddddddddddolcc:,':lddxxxxkkdOOxxkdck0OxkOOOOkxk0KXNNNNNNNXKkddc               
               :xxxdooooooddddddddddddddddlccc;'':lodxkOOOkxkOOOkdx000kxxxxxxxxxkKXNNNNNNN0xoo:               
               ;ddddoooooooddddddddddddddolccc;,,:cldxkOOOkddddxxdodoodddddkkkxkkOKXNNNNNNKOdo;               
               :oddddooooodddddddddddddddolllc:;;:ccldkkOOkdoollll:codxxddoxkxxdxkk0XXXXNNX0xd:               
               :oooooooodddooodddddddddddoloool:;;;;:cldxdlccllldxxkOkxxxddxxxxxxdxkO0OO00OOkkl               
               :oooooooooooooodddddddddddoooooc,;;;;::::::;;;:clddddxxxxxddxOOkxddddxxxddddxOOl               
               :oooooooooooooddddddddddddddoxx;,:cccloooolllodxddxddxxkOkxkkxkkddddddxxxxdodxx:               
               :ooooooooooooooddddddddddddddx0l:cllllodxxkOOOkdloxxxdddkOkxxxddddxxxdxkkOkdooo:               
               :oooooooooooooooddddddddddddxOKd:cdddodddxkOkxdlokkkxxdddxxxxdddddxxkxdkkxddool;               
               ;ooooooooooooooooddddddddddxk0Oo:cdxxxxxxdocodook00Okxdddddxkxdddddxxxxxxdoollc,               
               ;oooooooooooooooooooodoodddxkOxl::xOkxxxxdlldllOK00Okxxddodxkkxdoodxxddoolccccc,               
               lxxxdddddddxxxkkO0KXNNNNNNNNNNNNNNNNOO0xxxxxxxddxdoooooodxxddkxollcolclollcc;'c;               
               cxxdddddddddxxxxO0KXNNNNNNNNNNNNNNNNXKKkddxOxxxooodoloooodkkxxdollllolllllcc;'c;               
               :ddddddddddddxxxk0XXNNNNNNNNNNNNNNNNNNNKkddxxooooooooooolodoooooloolllllllcc;'c;               
               ;dddddddddddxkOkkOXXXXNNNNNNNNNNNNNNNNXkxxxOxooooolooodolllllllllllldxdoolcc,,c;               
               ;dddddddddxxxOKK00XX00XNNNNNNNNNNNNNNNXkxxxkxddxdooooxxolllllllllllloOOxoool,'c;               
               ;ddddddddxxxkk0KKKKXOx0XXNNNNNNNNNNNNNNXKxddxxxxxdoodooollllllllllllloxkdood;,c;               
               :dddddxkOOOOO00KXXXXOdOXXXXXXXXXKXKKXXKXX0xddO0ddOkxkkolllllllollllllloooodo;lx:               
               :xxxdxxkkO000000KXXXOx0XXNNNNNNNXXXXXXXXXKKKkkOdodxxdxxddddooodoooolodddkkdl,dO:               
               :xkkkkOOkkkkO0000KXXkxKXNNNNNNNNNXXXNXXXXK0000KKOdodoolloddodollllllllooxkkl,cd:               
               cdxkkkO00OkxkO0KXXXKkxKXNNNNNNNNXXKKXXXkl:;::cox00OOkdoodxxoddoooooollllloxd,:l:               
               :dddxxkO0Okddxk0KXXXxxKXNNNNXXXXXK0OOkc,,,,''',:k0XKKkodxxxooolllokOkdollldo,:o:               
               :ddddddxkkkxdddxOKXKxxKNNNXXXNXK000Ok;,,,cdddlcloxO0Kxodxodddkdoolodk0kolodl,od:               
               :dddxdddddddddddxkkOdkKXXXXXXXXXKKKOx;';okOkkkxoodxxdoooooodxkkxdloxkOxxool:;dOc               
               :ddddddddddddddddddddx0000000KXXXXX0k;,,cll;,::',odoooooooooddoooloddxdoddl;:xOl               
               :ddddddddddxxxxxdddddxxkkkkkkO0KXXK0Oddxk0Oodkdcoddoooooooodxxooooodxdooool,;oo:               
               :dddddddddxxxxxxxxddddxxxxxxxkOO0000OkooxO0OOkldkddooooooooodxdddooooooddol,;ll:               
               cdddddddddxxxxxxxxdddxkkkxxxxkkkOOOOkkdodddkkdoOkdoooooooooodddodddoooodOkl,:ll:               
               cdddddddddxxxxxxxxdddxxkOkkkkkOOkOOOkxxxkxllllxkkxdooooooodoxkxdddooooddodc;:lo:               
               cxddxxxdddddxxkkkxddddxxxxxkkOOOkkxxddxkOkxc::cldkxdoddddddddxkxxkdoooddool,:lo:               
               cdddddxxdddddxxkkkxdddxkkxxxxxkkkxdddxkO00kdlcccccokdddkkxkkxxdodxxdddddddl;cll:               
               cxxdddddddddxxxxkxxdddxkOOkkxxxddooddxO000xkkdlccccdOdox0OkO000xx0Kkodooool;cll:               
               cxxxddddddddxxxxdddddddxkkkkxxdoooolodxkOkOOOxocccloOOkk00xk0OkkOKXOooooooc,cll:               
               :dddddddddddddxxddddddddxxxxxxollclloodxkOO000Okdoood00OOOxkKX0KKXXKxddooo:,llo:               
               :dddddddddddddddddddddddxxxxdollcccoddxxxkkkkO00OOxld00KKKKKXXXXXNNXkddoooc:lod:               
               :dddddddddddddddddddddddxxkxdclcc:codxkkkkkkxkO000ocd0OOOOKXXXNNNNNNKkdoddlcoddc               
               :dddddddddddddddddddddddxxxxdlccc:cldxkOOOOkxkOOOklokkOkxxxOKXNNNNNNKkdodd;:oooc               
               :oooooodddddddddddddddddddxxollcc;:loxkkkOOkdkkoodxO0kxxxxxxOKXNNNXKKOdooo,;loo:               
               ;oooooooddddddddddddddxxxddolllc:,;coodddxOkxOkxxkkxdolxkxxxkO0XNNNXXKxdol,:loo:               
               :oooooooddddddddddddxxxxxdoclll:,';cllodkkOkxddddlloodoxxxddxxk0K00KKKOxxo,:loo:               
               :oooooooddddddddddddxxxdddl:clc;',;:clodkkkkdlclloodxddxxxxddddxkxddxxxOOx,:ooo:               
               :oooooooddddddddddddxxxdxxoloooc;;::::clodxocccodxxxxdxxOOkxddddddxdooxkdo,:ooo:               
               :oooooooooooddddddddddddxxollodl,,;;;::::c:;;:codxkkxdxxxxddddddxxkOxooool,:llo:               
               :oooooooooooddddddddddddxxdc:okx;;looooolc:;:clddddxxddddddddxOxdkkxdooooc,:lll;               
               :oooooooooooodddddddxxxxxxddddk0kolddxxxkkkkkkxldxdddxxddddddxxxxxxddollc:,;ccc,               
               :oooooooooooooddddddxxxxxxxxdxk0Oddxxxxxxkkkxdldkxddddxkxddoooooddolcccllc,;cc:,               
               :oooooooooooooddddddxxxxxkkxdxxOkodOOOkkxddoollOOOdooodkxdllcccloodolllolc,;:::,               
               cddddddddxkkkOKXXNNNNNNNNNNNNNNNKOK0kOxxdxkoddodollodxddddxolllooloolccc;':cccc;               
               :dddddddddxxkO0XXNNNNNNNNNNNNNNNX000xddkkxxddoooollloddxxxxollclollllccc;':cccc;               
               :dddddddddxxxk0XXNNNNNNNNNNNNNNNNNXX0dddkdddoooooloolodddoooloolllllllcc;':cccc;               
               :ddddddddxOOOkOXXXXNNNNNNNNNNNNNNNNX0kdxkdooolllolodolllllllllllodoollcc,,ccccc;               
               :ddddxxxxkOKK00KXKOXNNNNNNNNNNNNNNNKxdxkkxdddoolloxxollllllllllloOkxooll,,ccccc;               
               :dddxdxxxxkOKKKKX0dkXXNNNNNNNNNNNNNXKOddxxdxxdoooooolllllllllllllxkxoldx;,ccccc;               
               cdxxkOOOOO00KXXXXOdkKKKXXXXXXXKXXKXXXXkdodOkdxxddkdlllllllllllllllooooxkc:lcccc;               
               cxxkkOOOO0000KXXXOdOXNNNNNNNNNXXXXXXXXK0kxkkooxxxxkdodoooodollllodddkxdd:lolccc;               
               lkOO0OkkOO0000XXXkxOXXNNNNNNNNNXXXXXXXXXXKKKOxoodolllddodollclllllodkkxl,:olllc;               
               lkOO00kxxkOOKKXXXkx0XXNNNNNNNNXKKKXXXXXXKOOOK0Okkxoooddoddoolloolllllokk;:llllc;               
               cxxkO0OxddxkOKXXXkx0XXNNNNXXXXXK0OKXXXkl:;;;:ldOK0xodxxdoooolokkxollllxx;:olllc;               
               :dddxkkkxdddxOKXKxx0XXNNNNXXXK00OkkOOl;,,,''',ck00xoxdoddxdoolodkOxoooxx;lolllc;               
               :xxdddddddddddkOOxx0XXXXXXXXXKK00Okkc',;ldxxdlodxdoooooodkkxdlodkkxxoloc;xdllll;               
               :dxdddddddddddddxdxOKK0000KXXXXXK0Ok:',lkkkxxdolooooooooodooolloddodxdo:;xxllll;               
               :dddddddxxxxddddddxxkkkkkkO0KXXXK0Okc;,col;'::';looooooooxdoooloxdooool:,oollll;               
               :ddddddxxxxxxxdddddxxxxxxxxkO0KK00OkdoxkO0xxkxcloooooooooddodooooooddll:,llllll;               
               cddddddxxxxxxxdddddxkkxxxxkkkOOOOOkkxdoxOOkkxlooooooooooooooodoooooxOxo:;lollll:               
               cddddddddxxxxxxxdddxOOOkxkkOOOOOOOkkkxddooxkxoxooooooooodxkdddooooodddo;;loolll:               
               cxxddddddxxxkxxxddddxxkkkkkOOOkkkkxxxxxkxoclokOxdoodddddddxxxkdoooodddd;;llllll:               
               cdxxxdddddxkkkxxdddxkkxxxxxkkkkkxddddxkkkxlcccodxdddkkdxkxxdodkdodddooo:;lloooxl               
               cdddddddddxxkxxxddddkOOkkxxxxxdddooodxkOOkdlcccclddokKOkO00kx0XOooooooo;;llllll:               
               cdddddddddxxxxddddddxxOOkxxxxdooooooodxkkxkkocccclxxkK0xk0kkOKX0doooool;:llllll:               
               :dddddddddxxxddddddddxxkxxxxdolllloooddxxkkkdocccldOkOOxkKKKKXXXkddoooo::loodddc               
               :dddddddddddddddddddddxxddxxollcclooodxxxxkkOkdlooox0KKKKXXXNXXX0xdooooccoodddo:               
               :dddddddddddddddddddddxkxdddllllcllodxkkkxxxOOkO0doxOOk0XXXXXXXXX0xooooclodxxddc               
               :ddooodddddddddddddddddxxxdollllcclodxkkkkxxkOO0koxxxxxxOKXXXXXNXOdoooo;:ooodkkc               
               :oooooodddddddddddxxdddddxxlllcc::cloxkOOkxxkOOkdlokkxxxxO0XXXXXK0xoool,:ooooddl               
               ;oooooooddddddddddxxxdddddolllc:;;:clodxkkxkkoooloOOOOxxxkOOXXXXXKkddoc,coooddoc               
               ;ooooooooooodddddddxxddddollllc:,,ccllodxkkkkxxolOKKKOxddxxk0OkkOOOkkxl,cooodddc               
               :oooooooooooooodddxddddddl;::cll;,ccclodxxxooooook0KK0OOOkxdxxxdooxkkxl,coodxdo:               
               :ooooooooooooooodxxxdddddocccooddollllodxxdolcldoooxxxkkxdooodxkdooddoc,coooooo;               
               :ooooooooooooododxxxddxxxdocc::ldkOOOkxddol::coxOkdxdoddoldxdxkkxdooooc,clllccc;               
               :oooooooooooooddddddddxxxxxdc;,,:oxOOkxdoc;;:odddxxddoodddkkxxkxdoolll:,:ccc:::,               
               :oooooooooooooddddxxxxxxxxxxxo,,',cxxxxdoc:ldxodxddddddddddxxxxdoolllc:,;:c::::,               
               :oooooooooooooddddxxxxxxdddddl;;::cloodxkkkOkooxkxddxxddolllooooolllloc,:::::::,               
               :oooooooooooooddddxxxxxxdddddl::lolc::cokOkxdcd0Kxoddxooollcldoddollcc:;::ccccc,               
               cdddddxkOOO0XNNNNNNNNNNNNNNXOKOOOOdoldoodoxdoooxddddooolloolllcccc:,,:ccccccccc;               
               :ddddddxkkO0XNNNNNNNNNNNNNNX0O0kxkxxdxdodooolllodddxkdolllollllccc:,,:ccccccccc;               
               :dddddxxxkOKXNNNNNNNNNNNNNNNXKK0xookkdxdoooooollldxddooodolllllcccc,,:ccccccccc;               
               cddddxOOkkOKXXNNNNNNNNNNNNNNNNNX0ddxkddollloooollllllllodooollllccc,;cccccccccc;               
               lkkkkxOKK00KXK0XNNNNNNNNNNNNNNN0xxxxkddooolllddoooolllllllokkdollc:,;cccccccccc;               
               ckkkkkO0KKKXXKxOXNNNNNNNNNNNNNNKkxddxddxxdoooddlllllllccclldkdolddc,,cccccccccc;               
               oOOOOOOO0KKKKKdxKKXXKXXXXXXXXXXNX0dodxxxxxooxolllllllllccllloooodkx;;cccccccccc;               
               oOO000000KXXXKdxKNNNNNNNXXXXKXXXKK0xddOdodkdxxdololldxdlclodddxddkO:;cccccccccc;               
               oOkOO00000KXX0xkKNNNNNNNNNXXXXXXXXXXK00kdoodooooddoodollllllodkkxoo;:cllccccccc;               
               o0kkkkO0KXXXX0xkXNNNNNNNNNXKXXXXXXXXXXXK0xdxdoolooodxooolllllllokxl,:cccccccccc;               
               oK0kxxxk0XXXN0xkXXXXXNXXXXXK00KXXXXXXXKkkOkkOxddddooooddoxxdolllxxl,:cccccccccc;               
               lO0Oxdddk0KXXOdOXNXXXXXXK00K0kO0KXXXXkc:;;;,,cdddddodoooloxOOollxxo;:cccccccccc;               
               :dxxddddddxk0kdOXXXXXXXXXXKK0OOOO0KKl,,,,'''';ooooooxkxdloxkxdollol,cllcccccccc;               
               :dddddddddddxddkKK00000KXXXXK0OOkkkd'',:dxxxolollooooooolloxdodoloo;clllccccccc;               
               :ddddddddddddddxkOkkkkk0XXXXK0OkOkkc.';oxdoooccoooooddlooloddoolll:,clllccccccc;               
               :dddddxxxxdddddddxxxxxxk00KKK0OkkkOc,,;loc,,c.;ooooodxooooooookdll:,cllllllcccl;               
               :dddddxxxxxxxddxkkxxxxxkkOO0OOkkkkOxloxOOkdkxlloooooooooooooookkooc;loollllllll;               
               cdddddddddxxxddxkOOkxxkkkkkOOOkxxxxxoldxkkxkolooooooxkddooooooodoo:,cllllllllll;               
               cdddddxxxxxdddddxkkkxxkOOOkkkkxdddddoodocoxxoddddddddxxdxdooooodddc,colddllllll;               
               cddddddxxxxdddddxxxxxxxkkkkkxxddddoooodxdccxxddxkxxkkxdoxkdooooood:,looodolllll:               
               cdddddddxxxxddddxkOkxxxxxxkkkxddooollldddc:cododO0xOOOkxOKkoooooodc;lllllllllol:               
               cddddddddddddddddxkOOkxddddxddoooolloodoooocccodO0xk0kxk0X0doooooo:;llolodlllol:               
               cdddddddddddddddddxxkxxdddddolllllooooooddooccldkOxx0KKXXXXkdoooooc;cooooxdllloc               
               :dooodddddddddddddxxxxdddddolllllooodddddddxdlodk0KKXXXXXXX0xooooolcoddodddoodo:               
               :dddddddddddddddddxxxdddddolllcclllodddxxxxxxxkOOOO0XXXXXXXKOooooo:;loxkdddxxkd:               
               :dooooddddoodddddddxxxdddolllc:cclllloddxxxxxOOO0OkxkKXXXXXKkdoooo:,looxxddO0Odc               
               :oooooddddoooddddddddxxddlc:c:;:cccccloddxkkkkkkO0OkxO0XXXXKOdoool;;loollloddoo:               
               ;oooooodddodddddddddddxxocc::;,;ccccccoxxdxxxkkOOOOkxkx00O000kxdoo;;ldddolllool:               
               ;oooooooooooodddxdddddddlc::::;,;:cc::oxkxdoooccdkkkdddxkddddkOkxo;;loddollllll;               
               :ooooooooooooodddddddddo:;;;:clooooooddxkxool::lkxxxdooodxkdodxdoo;;looollllllc;               
               :oooooooooooodxxdddddddo:;;:cllcloooolcc::ccl::oxOKK0xdodxkxoooool;;llcccc:::::,               
               :ooooooooooooodxdddxxddxoc::::;,,;;;;;;:::::ddlox0KKK0kxxkxdolllll;;:cc:;::::::,               
               :ooooooooooooodddddxkkxxOOkdc,,,,;;;;;;;;;;:cddodkkk0KK0xkkkdllcc:,,:cc::cccllc,               
               ;ooooooooooooodxxxddxxxxxkOOd,,,,,;:::;;;;;:cldxxddddkkxOOkxolllll;,:c:;::clooc;               
               ;oooooooooooodxxxxxxddddddxxd;;;;:codxddolc:clkOkxooooclooooollllc;;:::::::::::,               
               ;oooooooooooddxxxxxxddddddddo::::cloxkkkkOklcoOOkxddoooccloodoolcc:;::::cccc:::,               
               cddddxOOOKXNNNNNNNNNNNNNNKOKO0Oxoloooooxxoloxddodoollldocllcccc:,,:cccccccccccc;               
               :ddddxkk0KXNNNNNNNNNNNNNNXO00xkxxddxdddodollloddxkdoollllllcccc:,,:ccccccc::::c;               
               cdxxxxxk0KXNNNNNNNNNNNNNNNXKKOdoxkdxdoodollllloxxdooodollllcccc:,,:ccccccc:cccc;               
               cddxOOkk0XXXXNNNNNNNNNNNNNNXX0xddxxddollooloollllllllddoollccccc,,ccccccccccccc;               
               lkxkOKKKKKXXOXNNNNNNNNNNNNNNKxdxxkxdooollloxoooolllllllokxdllccc,;ccccccccccccc;               
               ckkkkO0KKKXKxkXXNNNNNNNNNNNNN0xddxxdxxdoooodollllllccllldxdooxoc';ccccccccccccc;               
               lOOO00KKXXKKdx0KKXXKXXXKKKXXXXKxodxkxdxdoddllllllllllllllooodkkd,,ccccccccccccc;               
               oO00000KXXXKdxKXNNNNNNNNXXXXKXXKkxdkkookddkxolllldxollcldddxdxOO:;ccccccccccccc;               
               oOOO0000KXXKxxKNNNNNNNNNXXXXNNXXXX000koodooooodoodollllllodkxodd;;clccccccccccc;               
               okkkk00KXXXKxkXNNNNNNNNXXXKKXXXXXXXXKKOxxxolloolodoollollllldkdl,;clccccccccccc;               
               lxddxkOKXXN0xkXXXXXXXXXXKKOOKXXXXXXK0kkkddolooolooododkxdolldkdo,;ccccccccccccc;               
               lkxdddxO0KX0dkXXXXXXXXK000OkO0KXXXX0xc;;;,,,,:oxdddoolodkOdloxdd;:cccccccccclll;               
               :dddddddxkOkdkKXXXXXXXXXKK0OkOO0KXX0:,,,,,,,,;looxxxdloxkxdolodd;:llccccccclool;               
               :dddddddddxxdx0000000KXXXXX0OOOkOKKo'',lxkkxdlooooooolloddloolod,:llcccccccllll;               
               :ddddddddddddxkkkkkkkOKXXXK0OkkkOOOc..,loolc:;cooddloolodooololc,:lllccllllllll;               
               :dddxxxxdddddddxxxdddxO0KK0OkkkkOOOl;;:odo;:o:cooodooooooldkollc,clllllllllllll;               
               :ddddxxxxxxxdxkkxxxxxxkkOOOOkkkkkOOklloxOOkkdooooooooooooooxxooc,clllllllllllll;               
               cdddddddddxxdxkOOkxxkkkkkOOOkxxxxxxxocoddxxxooooodkddoooollodol:,clllllllllllll;               
               cdddddxxddddddxkkxxxxkkkkkxkxxdddddoloddlcloodddddddoxdoooooddoc,codxolllllldol;               
               cdooddxxxxddddxxxxddxxkkkkkxdddddoooolodoccloxxxkkkxdkOdoooooodc,cllolllllooxdo;               
               :ddddddxxxdddddxkkxxxxddxkkkxdooooolllooolcccoOkkOOkk0XOoooooooc,cllollllooooll:               
               cdddddddddddddddxkkkxxdddddxdoooolllooooooocccoddO0kOKXKxooooooc;loodkdlloodooo:               
               cdddddddddddddddxxxxxdddddddolllllloooooddddccloxOXXXXXXOdoooooo:odoodxoloododo:               
               :ooddddddddddddddxxxddddddollccclllooodddddxdoxxOKXXXXXXKkooolol:oxddxddddooool:               
               :dddddddddodddddxxxdddddddollccccclllooddxxxxOOOO0KXXXXXKkoooooc,loxxddkkkddooo:               
               :dodddddooooddddddxxddddxdcclccccccllloddxxxxkxOOOOKXXXXKOooollc,loooooxxdoooooc               
               :oodddddooodddddddddxxddolc:::;;:clllooodxxxxdokk0kkKKKKK0xdool:,lodollloolllll:               
               ;oooddddddoddddddddddxxdlcc::;,;:cllcldxxxdddlokkOxxOkxxkkkkxdo:,lddollllolllll;               
               ;ooooooooooodddddddddxxdlc:;;::;:cllcokkkxool:lxxkdodxxxddxxxdo:,loollllllcc:::,               
               :ooooooooooodddddddddddo;;;;:looooddddkkkdlc:;oxOK0dooxkxoooooo:,clllcccc::::::,               
               :oooooooooooddddddddddddc:::ccccllloolllcccll:dOKKKOxdxkxoollll:,cc:::::::::::c;               
               :ooooooooooodddddxkxddxOxll::;,,,,;;;;;;;;:odlodxOKKOOOOOkollc:;,:::::cccccccc:,               
               :ooooooooooodddddxkkxxxO0Okx:,'''',,,;;;,;:loddddoddk000Okdolol:,:::::ccoolc:::,               
               ;oooooooooooddxxddxxxxxkkkkxc,,,,;;cc:;;;;:clkkdddolodddddolcllc,:::::::::::::;'               
               ;ooooooooooodxxxxdddddddddddl;::::codddocccclOOxoooolccloddolllc;::::clcc:::;;:,               
               ;ooooooooooodxxxxxxxddddddddl;:::ccloxxxollclOOOxollolllooddlllc:::::cc::::;,,;,               
               cdxkO0KXNNNNNNNNNNNNNNKk0KkOkdodxodoxdoooddoodoooodollcccccc;'::cccccccc::::;;;'               
               cdxxkOKXNNNNNNNNNNNNNNXK00kddkxxkddooollloodxxdooooollcccccc;':ccccccccc::cccc:,               
               ckOOkOKXXNNNNNNNNNNNNNNNXXKxodkdddoooollllldddoooddolllccccc;':cccccccccccccccc;               
               lOKKKKKXXXKNNNNNNNNNNNNNNX0kxdxxdoollolloollllllldddollccccc;,:cccccccccccccccc;               
               ok0XXXXXXKk0NNNNNNNNNNNNNXkddxkxdddoolodxooollllllldkxdllccc,,ccccccccccccccccc;               
               lkOO0KKKK0xx0XXXNNNNNNNNNNX0ddxxddxdooodolloollllllldxdoddlc;':cccccccccccccccc;               
               o00KXXXXXKdx0XXXKXXKXXKKKXXKOddxOOoxxdxdlllllloolllloooodkxo;':cccccccccccccccc;               
               o0000KKXXKxxKXNNNNNNNNXXXXXXX0OxxOoodxddolllloxdolloddkkdxOd;,:cccccccccccccccc;               
               o000000KX0dxKXNNNNNNNNXXXNNXXXXK0K0xodoollloodllllllcldxxooo;,:lccccccccccccccc;               
               lkOO00KKX0dxKXXNNNNNXXXK0KXXXXXXXKKKOoc::::::loddodolllldkol;,cllcccccccc:ccccc;               
               cdxxkOKXXOxxKXXXXXXXKKKKOO0XXXXXX0kkd;,,,,'.':loolxxxdlldxdo;;cccccccccllcccccc;               
               cddddxOKXOxxKXXXXXXXK000OkO0KXXXKOdl,'',:lllcdxdolldkkolodxd:;cccccccccllcccccc;               
               :dddddxkOkxxKXKKKKKXNXKK0OOOO0XXX0dc..,ldddolcoxxllxxdolloxx:;llccccccloccccccc;               
               :ddddddddddx00OOOOO0XXXXKOOkkk0KX0xl,',;c:,,c,:looloxdoloood;;clccccccccccllllc;               
               :dddddddddddxkkkxxxk0KXXKOkkkkO0KKOdl:clddoxxoxooolodooolool;;lllllllccccllllll;               
               :ddxxddddddxxxxxxdddkO000OkkkkO0000Od:::lodxllooooololdkoool;;llllllllllllodoll;               
               :dddxxdddddxkkkxxxxxkkkOOOkkkkkOkkxxdcc:;:ldoddooooloolodoll,:llllllllllcllooll;               
               cddddddddddxkOOkxxxkkkkkOOkxxxxxdddoollc:::llodxddoooooloolc,:oolllllloolllllll;               
               cdddddddddddxkxxxxxkkkkxxxxxddddoooolllllc:cclddodxdooolodoc,:ldollllldxollllll;               
               cdddddxxxdddxxxxxxxxxkkkkxdddoooollllllllllcccxOxkKkoooooool,:lllllloooolllllll;               
               :dddddddxddddxkkkxxxddxxkxxddoolllllllllloolccoxkOK0dooooool,:lodolloooolllllll;               
               cdddddddddddddxOOkxxddddddddollllcllllloooddoco0KKXKkoollooo:cloxdllodxolllllll;               
               cddddddddddddddxxxddddddddddoccccccllloooddxxloKXXXX0xdolloocoddddoddoollllllll;               
               :ddddddddddddddxxdddddddddddllllccclllloodddxddKKXXXKkoooloo;cxxddkkddollllllll;               
               :ddddddddddddddxkxdddddddxxdollccc:clllodddddod0KXXXKkodoool;cododkxloooodoolll;               
               :dddddddooddddddxxxdddddddddllccc::clllloddxddkO0XXKKOddoool,coollooollllllllll;               
               :dddddddddddddddddxxdddddddoccccc::clllloddxdoxkOO0Okkkkdool,ldollllllllolcc:::,               
               ;oddddddodddxxdddddxxddddddl:::clcccllllloodododdxxxddxxdoll,ldolllllcccc::::::,               
               ;oooddddodddddxdddddxxddddo;::;::;:clllllllkkxddodxkxodoooll,:lllccc:::::::::::,               
               :oooooooooddddddddddxxxxddoc:cccclllcc:::;:ldddxxdxkxdoooolc,;::::c:::::cc:::::,               
               :oooooooooddddddddddxxkkxxxo::c:;cdkkkxolccloddxxdxxxxdollc:,;:::cllllc:::::c:;'               
               :ooooooooodddddxkkxdxkOOkkkxo;,'';:odxkkxxdodxxddoooooodoolc,;:::ccllcc:;:::;,,.               
               :oooooooooddddddxkkxxk0Okxddo;,,,,,;clllolldkOdlllccldddolll;;::::::::::::::;,,.               
               ;ooooodoooddxxdddxxddxkkxdddo;;;:ccc::;::cokO0Odllllodddxoll:;::cllc::;;;;cc:;;'               
               ;oooooooooddxxxxddddddddddddo:;:coxxo::loxO000Okollloooddollcccc::;;;;;;;;,:::;'               
               ;oooooooooddddxxxdddddddddddo::codkOOdclddkOOOOOdoloooooddoccccc:;;;;:;;::;,,,;'               
               cdxk0KXNNNNNNNNNNNNNNKO0kxkxddkddddxoloddoodoooodlllccccc:;'::cccccc::;;;,,:oxOd               
               cxxkOKXNNNNNNNNNNNNNNNK00xodkdxddooollloodxkdooooollccccc:;':ccccccc::::::;;;;:;               
               l0OO0XXXNNNNNNNNNNNNNNNXX0dodkddooddllllloxdoooxoollcccccc;':ccccccc::::cc:::::,               
               lKXXXXXXXKXNNNNNNNNNNNNNKkxdxxddolloolooolllllldddollccccc;,:cccccccccccccccccc;               
               o0KXXXXXKkOXNNNNNNNNNNNNKxddxkddddolodxooollllllldkxolcccc;,cccccccccc:cccccccc;               
               o0KKKKXX0xdOXKXXXXNNNNNNNX0ddxxdxxoodoolloollllllldxdoxolc;,ccccccccccccccccccc;               
               oKXKXXXXKxx0NXXXXXXKKXKKKKKkddxOddkdxkolllllolllllloooxkdc;,ccccccccccccccccccc;               
               o00KKKKXKxxKNNNNNNNNXXNXXXXXKOkOxooddddlccclooolloddkxdkkl;,ccccccccccccccccolc;               
               dK00000K0xxKNNNNNNNNXXXXXXXXXXKKKOdoo:;,;:;;,clolllldxdool;,ccccccccccccccccccc;               
               lkO000KX0xxKXXNNNNXXXXK0KXXXXXXKKKKkl,',,,'',loddllllokdll;,cllcccccccccccccccc;               
               cdxkk0KX0xxKXXNNXXKKKK0kOKXXXXXKkkO0:.';lxxxdoooxxxoodxddo;,cccccccllcccccccccc;               
               cddddxOXOdxKXXXXXXXK000OkO0KXXXOdodx;.':llllc;cloxkxooodxl:;cccccccllcccccccccc;               
               :dddddxkkxx0XKKKKXXXXKK0OkOO0KNKxooxc;,::,;lc:ollxxoooldko;;lccccccllcccccccccc;               
               :ddddddddddk00OOOOKXXXXKOkkkk0XKxoooo::clooollolloxolooool;;clccccccccllccccllc;               
               :dddddddddddxxxxxxk0KKKKOkkkkOKK0kdooc::;:lllooooooodolool;;llllllccllllllcclll;               
               :dxdddddddxxxdddxddxOO00OkkkkO000Oxdolcc:;:loooollloxdlool;:lllllllllllodllllll;               
               :dddddddddxkOkxxxxkkkkOOOkxkkkkxxxxooolll::cloooooooloolol,:lllllllllcloollllll;               
               cddddddddddxkOkxxxkkkkkOOkxxxxdddooooollll:clxddoooooodolc,cdllllllollllllclccc;               
               cdddddxdddddxxxxxxkkkkxxxxxdddooollolllllllcloodxdoolloooc,:ollllllxolllllloccc;               
               cdddddxxddddxkxxxkxxxkkkxxddoolllllllllllloolodOKxooooddol,:llllooooollllllllll;               
               :dddddddddddxkOkkxxxddxxxdddlcccccccclllllodook0XOdoollool;:oxollodoolllcccllll;               
               :ddddddddddddxkkkxddddddddddlcccllcccclloooodkKXXKkoollloo:lodxloloolllllllllll;               
               cddddddddddddddxxdddddddddddoccclllcccllloooodOkkkkdollooo;lddddxdolllllllllccl;               
               :dddddddddddddxxddddddddddddoccclllc::cllldddoooldOxoooool;oxddOkdooooooolllccc;               
               :dddddddddddddxxxdddddddddxdlcclllc:::cccldxx0000KKxddoool,cloldolloooooollccc:;               
               :xxxxdddodddddddxxdddddxxxxdollllllc:ccclooldkOKOO0kxdoool,lolllolllllllcccc:::,               
               :dxxxxddddddddoddxxdddddxdxdc::;:cc;;:ccccloodxOxddxkkdool,lollllllcclc:;;;;;;:,               
               ;dddddddddddxdddddxxxddddxxxl:::cccc:::;;;:lodddkkddxdoolc,cllllcc:::::::::::::,               
               ;oooddddodddxddddddxxxddxxxxo::ccccldddolllldxxxkOxoooollc,::::c::::::::::::::;'               
               :ooooooooddddddddddxxxxdxkkkx:;;;,,:oxOOOOxodkxdxxxddoollc,;::ccccc:c:::::::;;;'               
               :ooooooooddddddxxdxxkOkxxkkkk:,,,,,,:loxxxdokkxddoooddolc:,;::cclolc:::::;;,,,,'               
               :ooooooooddddddxkxdxO0Oxxxxxx:;;;;;::ccccloxkOOdlcloddollc,:::::::::;:::;;,,,,,'               
               :ooooodooddxxdddxxxxkOkxdddddc;:::lodlc::cdkO00Odloddddoll;:::cllc:;;;;cc;,,;;;'               
               ;oooodddodddddddddddddkxdddddl;;;coxkkxcclkOOOOOOdooddddllcccc::;;;;;;;;::;;:::'               
               ;oooooooooddddxxddddddddddddoo:;:loxOOx:;dOOOOOkkxoodxxdolccclc;;;;;;;:;,;;;;;;'               
               ;oooooooooddddxxddddddddddolll:::loxOOd:;lxkkOkkkkxxkOOxdo;;:cc;;;;c:By J.S:::;'               
ID3     #TSSE     Lavf58.76.100           ��T                                 Info     C �@ 
"$'),.1368:=ACFHJMORTWY\^bdgilnpsuxz}��������������������������������������������������    Lavc58.13            $@     �@�`�(���d �  i     
     �      4�  J� �	�:�e賯�+�W�->(�=���E|ҘA����i�o����w��y:2�П�@������?�'^WF�@��&�:a��<#'QG${P����u�h���Ru"����B-.�"���"E3��m&N�mU �bC�x��(s� JjD��X�,�0���v_+go#���n��,�gs1�y���G�
�w�K*Q)B<��,�m
P. 8�Q��h��D�#`&���0 ^�I���ŏ�.j�]q\���H0C\ E��׶��DfLr�pn������,<��Xӷ��;�&bY={fe�L��������ѿ��g�"�ym�37�@����EQ�A��9�1�����D� "S@P#0TG�  ifŉ�0��d4���]�N��M?i�)"������0
?��qg��<y�2�e��&��G �p/���%�"Ur�~\
2��)�2E��z� ~4-"�ڈ`	�'9��3�s��f`%��U��o��sE���i
��N��6I��G��N{)Ǜ�Ȝdx�xi�@�PWp���F�����?x���f	���� `md�O}B�ɮ ��
���{���� �.�Qr@�=�?�p&T	&L�P�Td"m7�q��04����s��#��tb&���'&���Q-u9(��Ŝ���t�j�ԛ���ʭ�m���۶�p+%6��ʹ�ic���J�$��򟿛0U����"P���9�w�|�y������DE�cH��H �LIE1&�
�y3��V�H&��hD���iڣ�� ����p�V���5������K	I"	�#%&=�KM�X�fk&�B�J��FS6�1�I��	���4�[Bt�03�3x9:'?� �c��]ڒD��lU�j�s�Ŏ#�E�������2�i��jz��\��Y��wr�I�'����/��'Q��xq����K�6�R������N��!�JAi��'��4W����B�-��������w�o������������V� ?!⁸���pH�z*RzM�C�2� ��Ԫ�.0h��P�͍y�9�f�q�	�$��#��)B��."��yU	ޒ 6�Bع�ds�9C4ȱ�j%#o���d
�2�^K!�<�S�I�<�LKIy,����M�fP��n�>Ф(�]ʤc�s:�*���WU�g��Ϻ!����u��U��Uϡ����(P��rѡr�NV4����&�\���NK�e"5�	2m�"~õT�>6c�dW���3U�!�"=�v����d%+��޽�z��GZ�e����\�i��u���ِ8
�����2N$�����]žڮ�x���Ш�;��[�h�C���3����^�D+��ు���b�+)��/-�o���2o���7"0'�쿙��gC����nJ�NA��r�3@s=�����lJ�fv^�k9�ZM��MYP����������K�n�������*
:k@��\ T ЁN�F�zA^t����D
 �_K�<@ S�鋧� ��s�� u�owp ��v2�"쥜�Et%.�U�y�UyHwT��[��5?i�N�������Wkk"��c�����x�!�H�d��,�@�B@ᮔ*D�x�C��9�� �20�\D��K$�lb�ݶ��v�W�]s�~��j�F�	�/�t������������b15Nb � ��ccZ=)��#����ȹ⢇�A��.$� R.(v�� z4
����X�����I�q}um�Ϯ39��������P�0�m��%S�}�����h%�(tI���~ a���@��B=L4�4�{���{a�?��`��k�7˼���z{�w�}����` ����%I�3���~&����D	�"a$[_<`V$ۄ� T�m��a�h�y�ѝ(b��k��t#Ks��b���I� ,p@�,?�����2$�p�D5�O'"v~U^��Q���(t��ITa�Ж�P}�YbD�[q����w�mf����K54~ ���:�2]�Q"����X�<��Q�K7����(�,��"�Sav���#H�PD�.� 
B��0�V�²�ؠ#ʸ 9dē"6o�Ĩ3Ǥ��gX̊�@����]�iZ��9&�u�#>Нl���������"���� YR�F�
I�=)~��n�<&�Uj�y5^|���U�v��~��@��Eky6��\�k��]��Pd��	��~��_�GZ?*~����Q�&U2  �G�����=&��;l�:���D �?Zy��V�=�F8�c��M�O���y���&@��tޏ�T@�i.1\�ft�+���fG�x�g��+���]��,"#�~�E��=C:��g�R�B���  (J�J	
!D�-,��	X��0�3x�TC:F��+
V�ʝ(i��fG���P����_�,�ޢ��g1l�Ő�\��Ns!TN�@ Ӆa
b.�*��^��Q��* �K�"�^��u��$H�2��H���)Q�c81��dw��V1��F;� [�eUmt�a"�_/��.,k�" �I�7��H��#k�;��q�du3�m��G�<�q���G��B/�e����|����U�D�����i3�a��QV�G4  %:VBS�g���
.^K'���D�"����12GD�D0bjI�{g��j�K���
�5 �D�/Z�k�QSB��D����p�>�3-Q�މf���Ϝ/��Z�y.����]�b=[(O�aZ�܀��O�c@"�-�pc�������T�`@��� �<a㢢��T
�ܻ��u�2_c�+�3_�����   t,3��G���$x���J!�QE�s�{)�C�+�'c�	i�T�z�$���#9��c�F�V��GEO���-k� �qb��D$���+43�����-���r�?f�ƍ|g�9;��������j�bDL���Dv��@}$M�
�U���{
���B�Y@  ��H�A�;� �«>���u��7-of�g�ǂPۡ�"�I,e�����h���C�����d�0Yi��1�[0%$��a�����0�� �<י%2B��&:�B�Ba�1�x���J�B0 D��͛��D���AZ��}#�
+C�"r�ڢ(���
�\a� t�/�4�5R(Ca-�4"x[$x��ĥ�� tY�
��i��	�i�����B<H˝M-yQTc��6�d�1�	&*q�(��+����,��f�X 8*�@S�.
�HБ㲲{U���'mnZ���I�v8���4%����j   ��3�G�b�o��є|�ـvY���F�OSPٜ	�>R��(4�xz���]�L6��&�yr#;&],�,��x�\$�q��Of��۵@A(pD:@2�?BIQ�)U��ˤ���d<��<����6��-$�  ac�� ׈k��  Б�u��������dCd�*���P�qz[�$Jݺ�  �D �I�d8
S���|7a��X�Λ�r;��4�5�r���J>g�X	�L29��r��+�T����,t�-��?����f���y�)�_�� ��   ����h�ů}�L���,�ڤ�8��˞R�E������ˏ�
5	4Am$jWKm0ɍDjQ�딨	u�� _�m/󲋲 	n^���]����Dϰ$��yR4��D0��Lu���6@� ���6x�Vg�E�j��ܶ�?��-n� C�<���S�K������<j)p���7��|$jh��L�c��j�r5��/�!�xr�����+T�s�Թ�a���dU �Z�nc r+;�Ǩ ��sk����	�w�0 �~���y�p��%�M���u{���������ְ�s>��4�:��b�W5��I��dCl�H*˰䣅�¥��D1���IAjq���x�d��4���s�f���%U�1�����1�����.L��-ϡ�>��'O9�cι�1������7��� '��&��y4� @Q�]ňW�$��Ḃ�V�7jH�x?�&v�{�֭ݟe�����z�vp��"b����P��3�Vݸ$)�T�0�_�܅���P>e��5�3GHр�
i��\�����ڒ��
��a�ME����p6���Z'5�����bgZd  �R�e �/0�G�m��j��đ:^d�l�O�T���D�2����HD�0�jIT}cf��`�
!3��"Hd, DP\���X�A��&���K1�D���d$�쾽��)B'�S"͊>.��T��64� pC��IT��>��1{�S� O��P��N묟��VS�28�pb$�Rq'�Į��W�ր+�*q��,e��S.��Z��-�$M"*Ƣ��� &��6'lPB�4����L�R��8@FD��(���Y�f{D���e4髛S��-K���l܇K��oslj�"�;<ѿ�:o�U���  CQ�.,�Õ�`�Ԫ�54�nW6uU�����+MU���T�Ɨ�0���cDC�\ևlj�*��6��@��� �с����~Xr|+.������D4Y����K�[/1�
	t�c�m	��@��I
�,�.� m�l��*��?���'���f�6J+*&�yM � �N�H�648a�㸎$G�g+ ������vMU'ĤQyܭ}�-�n���Xi�gؚ?s̈i���2��m�7M���;���#�X��⢅>M{ >�!�,�"�ˊ��"G�W�,�e���q�
�E+��Z�]|!���ʻ����6���۾��:�d$	*`z ���
 �I�X�2�p�d~��ܾ����7XcA��wv���R�Z��#&���ϲIH�?r�Q]Pf���B �A/�++�JD�G#UV�G��U�pN֐ԡ!R5E2������&hJ��I}�B��
���_}�K	 ����DM�k!�i��H�.<#�	I]'�O�7����lZl'���f�G2A���䘑N�U��mߵkRPuIdٛЫ,�\�CRu�V�ܞ�o����ȋ��Yؼ�����j@��R�a��lfE/�?x�b�)�U�y7�eNp�,�`X>,�� �4�y��߹	�%.E!aY�	k���A��D %M��D4Z�FH���&,+���!l�w�飥x����Ή�����^y����7BrL�
.��6��MCn�#7ׇ�u��}&"/9  ��f�'T5J"�Xw	�a+��{��j��;�6�6�5dE��C�)��)"j7�f\�i�
@ �*\���=E�[ɩ֙p@�cC!�u�n����Х�&]�i'(�a����dd��(���p?�Z�=T��['�����4��J�( �JZ��YD:9$�+Q �3��������g`U�G�>�:��^�����Ӊ�H$��mC�%!:`p(�L<X���"ho�P�����e�u[��4D c�2�@ "D  È�)9 %�F�C���!9z'Їx��1E�(W#zD�NF�"ѣs������"@��wI�'Ƚ�@IB����a���v� {�V$^��#J@�
�T1�����C�U1�����I�hp`�U�
���AS%���A�hNH���Y�%JJGu�� >�[�e�)Vų 4��g��1��P�Ч��wD�F)�N�ʍ�����_�PV�9k����P]������
������dy�(���J�6!�{a,1� {_��ƈޅk0� _�����0  0sS��a�6W?�M�	Q �Y�K�:l��p��ShB�O�hZq̂VEOM
@ �2$���4`�.A�0J�B�0
��� (�9e���+,��$IDVG��������ƒU���,UN_�eO���[

%��a�8�;�~����  �����9�jnr�������`��&<����c�-i�8A�X�p�`݁hL` ��Ҷ���I���j&4Ў�kH�lJЭYL�-3g/�>�$
�����R����=��F�rpDXT�S��4�Ή�(.��aFI�=��:�,��/oГ!���X��$����6���M3�B��5W�<���d��#"UI�2"8J�- x�S1)@�j���r��p@�,�n� %%S
= �م��g0��-ޤ�!Z�B!�@� E�4.�H:$i�s�"D�3����@���j��BNU�5$a�_�A�kGXJP�h%&����1�y�@J�*[?ְ���	Y���]�yHq���O����4*z��I"	pX��46��cM>���a�%�F'.�)�Cܚ!;��<m4i�����!C�Ec��51�Ac<��д��"���8
�[(����}�������Y�@ �cȀ�t�[	����#X�/�0���>+���K���Q��)[7�\a`6m�ZI@  �J���a�bMj�[��a�+��#ΥЉ���d��)T�	+p6AlA����W��k��k0���Ӓ�(� �hI"Bbw~�����M�r/�43�|bX�VE�A3�l�ʂ�?{�li ��.b��i� 8
B׼��.�i C���B/�D(��L8�Ry�O���d,"�z $��BR�!(a�K���d�$�yw���
E /�諝$�Ф�h�H��Lo�81�� ����Z�:p@��I6ӄ�t�dV�
EnI�� ����B�X
�3����AP�����*.�o��J��ZYa�a  ��
�K�=TuN�d��G�>n���a$����H�h�I
4}�O�Ј]ܗℐ94)&�ЬK���*YqdO-	��}bc��w(��
)R ���d�#+TS	p.�< ����M'�R����,��N �AX4����k�{�A�J��]�L���B�H�\�H�Q��M<���耑�j&ڶ����=�澪��Re���9c�4�9'<��0G&�\�4
 �t�i7���NI�'|�sD���h�4
4�[R�ӷm}���Mst܏|�i'�Y��� (���RP��֫]l�bU`  �P2�� IWD(ܬ�`���\_����*s΃�i�:������6����z�^w�����:��
 �  '�b,�R.n(�D����(�P���|�#s&&cd$1����HRwF
$��xޅ�F�{Ѡ�P@V�g~�Ӭ)-/��C�{���@��{��󏜞�  �(�"tp���d��,S�	p3A:�0) ��>�Q�	�*����-�ʮ������NC�3����әL�s+2�gk*�|�0c���a+�{��<hL��HQZ:6�E�0�*�z����%R�l$	e4"���9A
%�%H�S
đ)P�"JbT�� ȔR����J�8�#]
�a����#��?:�������V���#w�W�����`�[$~92D�d&Vj�t�Cj@�K�0�Q!��XH�& ��DQ��њ6"I��P/-i)�B�[��D,�<�f���B4�B�:ʁiwq�J��!�9_�`,ת�6B�����Xc��Z��m��	��r�A���28y��Q�D�﫸�7F��2+@�=��M�rbu��\b��M���Z�����d�#N'�KJr>I0C�@�@5� 	i��0 BZ��@�"
���xr(�w.J)/K#��\Ɲ�@�nr�ڐY�y��w���ԕ���ruÂ(�Ym�!x�m��������8o�,w'"���E)&c:�B%���K��]��:�k�����b[�G%�r�WE����	 ��N�"����P�_�?~�t��n��ߑ8�Y3�(�r�2�r�M-R��
�����R3��ӣ�i��wn��^��Eu�V�UY�}������������lGY������<-��o�ez����KvS,�.�  � �+p:����v1ptZS#v/Klȴz�Ld=��N���H���QL��Q��9��)��tV�Ff#&o,Ò�aY/]U�N\��V���d��^[nc ����ǰ ̄�o�� /?�` �^�g�-K�9S��ļ)�I �T!"
"�t+Ŝ]�ڃ.P�^*y�(@>Ŵe�)
CT�Io�z<��V�O��ܑX���E�?]@�G5B0@$��(�X&i>�	�̥t�  H�,u��" E0thɥ �I N_N/=0���l3rm���<�6Օ��ifU@�$���rĠA"� �E��*K��x��0���0�L�㽱;��xhtS�6
֥ʅ׸;.�Jڍ����c(��R !�M����^+\��=m�$���x�DϝJ^���	2��+p��c `��}�����bC-��o�cb����͑�   !n(�y��S���Ѐ	�� An ��8f���D� ��ylH�OAk�=�	0�gg�c�B���
`s�!J��A8:�"�A"�c����"�kH�

 ��M#��$5��U�)YE   �'Gx��\	�`h/JP}O�-�m�֖{�����IS}H
40��"�#Km
~
 
	K-P�`a�
D�=ͩ�X�%�����u�W~�L�@
��X�}��S��|��<asn��!�\>*��;���ha�$�wEE�����M4�3��?��!��g7
��?��o�e 
�4�C�H��ѹr�{b�f�<l^N#����`ZI�ƃ�	�$0��{!�$b@�AvL���B�����_���kM��wa��   *�h#��+S	(���ȅ4A�s7D�e@)�<��E����D���$Yi�pS#˝<�XJp_c�kIU�t��� h(��B�4�Ad:5���� Ã�5c9R4?��e55h��(�$� �2�p-%jx�K&�{#�b�M���-D�����}����*<��1L4oZ���"\�ܼ��n�����=�\���(/a�	W�;����S   N�q ��02"�[�$���cOJ��'hRZ�Jh
�^�U���1��RMd�B��I�a��1�
�}��|ٗଊp*�W�:y��D2D@ �0	1�7FJ(�	�V@
���Z�܇�˃$�9P��Ň��p���e�h
Y���Sδ�rVW\y���ޝ��m�R}N8f�j"�w��
�� /�"��t��0�*գ���h��Ϧ����D��"�HXi�`\�+M=�*
��_��j�n��������#8n�o� ��xodȜP:獤D��oS�?�8����Bt������w�]�[  ��"�B��%Ҧ�V�\�2%m>����/�SDF�H��I7?��G�#Is�K�� 0`P!��Ό:�;��	t�}�0��5-���Ճ��  x��Ԫ>��=.�-D_Sh�z���`��r�������F�20�%�Jb����P,#,j#���S(pLh�!��Y��5��=z��� A�8���eJ�!&��KYє�`!*(#��a��Sb'�ޚ.������B�/���{�g��q�2e3eذ�×�P�}5ᷕ���E����
g2�� I����
����D��"�,�I�pY�k-=#b
�[��-��4��G.�+J�O��{�f"���M�!r79I�M7�'�R�\�v�����z��Ъ�V��s2�3w�=�{E�D�Ծu���   0H+�Rbd������j
�ez�(��X��� ̡!"Ddc�YK����9F�d��
)�P+#�d�B�ڧS��Oͣ�L�5���Y7�3k��*�6����>�0P  � Pi$30�AtǜYz�W��J��M����hJA'����TK����!>P<��jj[w��H�F$�@�RP8��Uv`$i4s�l
M�Ȩ�p�}�?-48cF�hҼұ�;H��
��խ
���ڸPD3=!�򶾃�s��R�ۥ��\�o�w����d���1�==�>@��� Z{cY� o�����<�����~�S�����?)0��h����9�L;s����'0�P���D*A#�=���ZZ߾Pa��3�V
xו?q�{���������X��7�m㋸�i�֝�Hi�ȀTffjF(
a�����N�s^[Ա�!�|[u>Ttլ�8f�g5�◉�]�i�]��������梿�rU�[�+�$!v�Ы�Тī���3v���d���|��^������L���Z�x{��o�P3Ć���~�������9���@�h
��>��$�� ّP�j:���M��CE꺓}zT��p��ͭ�]���u6�xnݛ[M9�����l��/��w��f�(�*��*	>������D)��4Z�0� a%+�� I$�gg�I��,�x����qE6c� '�(�[�Iq2P�T�jK
ûыu�3]��6Dlm�f�iy���H�y�$Q�}F�.�ǰqm�תh��
�2�����=ԟ�cG�K�� K�4�~�S+��`�)���љN土�L�q�G���A�*ʄ���v��h&q;�/M���������ؐ �%e)�HR� B�X�~[W�GU�ȆF.�k�0��h�4`(ࠖq/Qc��B�pPH4F0H4���Bē(�X��9��Y*�U�x[uC�g���]u�rk��k��0!���( \r��$%�����:�6O7[s���e$H  �� �
�
h��F<lܚ����D2�P'�!��L���-#&I��_$�	(�m��qT2�����7=�/��XM��/ɹ����B��uE���_�A�p{�w��%T
�P4O��DBQKl��ؖ��⨙����F]K$L�+ Y|�B
QZ��E�6^kЫl�a�u~M���_������� ĥ9��4N"�&L��Z�_�SM�s.���6vE4���&CĚ����˸���vT�/߼(��(���7����8�$QNP2����X��UyQah����b���y��
yH`��i80�m��Q�&���cJ<D�M,hb�!526��MRB� �� �!ZR��D%,$E3!)/Y����Əz�$0��>���$-a�Qj*'z����a�iO��7J!E���DI�o]i,0dL#�\0�F	�{e��a�2ntĘ�
�e[��"�( 	�B0dvR�1��4�T���cZ
��*z���ie��fD@�%��.�j�VF�|ö){?j[�Q��{�O��;[�E
c�C']4B�I�J��hY�<%w�؃�EAG�8D�`��UT	�D��v�Ӕ��O������E[��w6�ՊJ�KeČ�[T3MJ��3^&d���
"4�h--�Ֆ�6&<�t�
,�D$#΂kv��yG�R#�����s��A��` b^f	����L���+7h�{��'s����S�,/����h"� ��r��
�8��l�PF�2b$�U�Aq���xx2P�
`Xe��(��ab��d��a���D]�"P^a�<L�[<0#�	4)g�1 )���ǌ�p�B�@C�|�ȫB�cD
��Pjl(|w��j��ɓM� �*CS'��+�H���Z����������q���4�A"�S#�$�V�.���q��2���x[���c]\�!�{��*oVl�������V������R �\"�ot�i����p�+5cNv��؆df^��9�����L%
�
��4�Զ�
��DeL��
��PՄ�a-i�5�h&��A �6���8�����o[O 
A@T$�ZoC�����8\Jb0X�V�-aJ{����%�x]��.�t9lK�G�@�m3mjDL�VvƲ��֝���2#?�������>�}G��!�r7��������dv  #�iX0P5��-& ��g�� �*��  �3*�"+.-���ꟿ����   	�0<�4���lz��js��d�����` cFY��x�F��xEC�?�����8)IX�eD8-1�O*��0BR 0B�����83,^�!A�R�a��f� H��,�J��?/��k�c��"���bM��R���4fgi�K뺑�e֓eu�7��2x���i=��dyo;4�tTW���Y=��?+��YI���Z��Vm��nSҪ������E�l��R��N�3�����������=���������a���A����g �@H �e (	�����6��jӪ���ln�+�j�K�jl	��-H�Ɗ�7��q��x�n����d���]�ng ���Ǭ ok���	T��g (?��S:�Ø�Ǩ�<���_���V�P��sx448���g�p�&��7�Z�L.49/����".?�	Ù� 	I��g"P � �+ L�	<���S�y�}#+�X�jK���)��C��t?;Ԯ���4���䅣ԻGٙ�
��6�?r��
o
���s�0�"�
�L]�B��}[^��-#����0�oL�c�㱬�q������~�Ưx1����{���=u�i_f.�L}�D�y��:��܃    8!X�0�߭�k��������ݹQ���tG�;����F�k��J��ꙺ���u�wVUV��]�`A4�m�083dB( +�	#$��B~������d
 
0Y�=  6��� ��c����ʄ�8�$�{2#�%�x#D�#�y�3U��Ѹ�C
��xe����G�W����-t�EsE��2M��x
��dHH0*	�������%@ۍ�q,�sgw� 0����X�&�LԞ!��6z_��k'hc�cf6��[�a�o    MR�U���MT���V�W��ѥ�����r��ڷ������5�[N7������*k\�zX�@����3Ҷ�4��:�
d��ڟ�$@��e�D�  q|� ����Ӟ
�#�Ǌ׷����gK�	:�X9	Z�>E����Kc$  @^	 ����9�J�!�M��nO����u4�Ⱥ�6+�����]��.\���D�$�%�W_���������D#�"a��"Md��<�^	$�_g�Q	-�dĘX��|���@ 	��ܔ�V�.M�4rrV����TD�����jw����5�i�3�|}�B��Q�c؀�$�Î�Z����Е>�M���^�Pk�%B�dF)N(�2�x���-��A�f�z�ʎV�q� ��`��������3�ǽ0����U�a�L�I��H
���h�7J�d�噩dX�E�F�$�����&�-��Pbf�<L�ś�EI��Ea  �,b ��#��UN�,QĻc|K�?��{G����1>o�o�1�6V��b�m��؆�W����#a��[��Sp�		Lǒ��t�1/,��,<]$�"'�1r� �Cz����D:�k$�a�0bL�k
1&&I�KiG�j�/����
yU�cx岹�ma�m����{�_��}����5�E�&���@�S��@�[<$��!�t�;{/L�e��<�EA�X$�Ў,}���������9��_�{�f基?�������� �fQ9��,�!
dz�\6@���YJ��D㩞&AK+�H��Z�Q^�1���?H�]�aՅV�N����xo�k���j ��  ��<P�K�B�YT�D"�4�7��4d:y���{"�����+�
 0t�*@:"	�}�L�z��N"�Nr��� ��aT&��ā�a��
�;��b�
�W���B^S
G�b�6����
m�� $@�X$<H\�􋊸F9r��,���N���DN"l"Wi��L�*�0�J�{]F$k�h�`p ���ψC��| *�"k��J#ORF�ѿ�X���q�P� ������`)v�A�q"7�n��
� F��(,�L2!��\?D�Vd�V!T�%f�=&�l<<=3��P�ؐ�� �\m�q0�p
˿�/����?r5�nG-��+f�g�Pܼ-"z2�~B�щ	�S�R������\ !�@�]�6t�����<�m	��z������詢��  	�#��Ep���7�w�����l�g�>�-�܁�v�,��S~ey��� ���1��n���}����~K���PHih&�H�xnږ��R�$�mV�`f��z��y��@ғǁc
�(���BP7���Di `]�0`M���� W�k_���
�/is2� �z-�2��OJ���"��A��hgh.H���.o��u�ͨ]il���p�w��u2!PN̆E��[=C�W?�#/�|'C��s2���{�ٮ�]e(��c�:�|2�&�Jo�����;{��}�k�~x��,�$� ��X� �
>�Zb!t'�q��F��s��q�A�ɘ�;Ev  2a���@!��Ey�h�����!4G���|�Q:T���N�li\��7�
֭�WNJ4�kW�\�8�S*�!�W�*w�*�}�����Q�n-p�����`cw��]޾+xy�V���[�����4����%{���4�� �J�Q��O7���.�;�ڪ���D�"?#�G<� K�
�� hed��g	2
�p�
Y�5�u��2k(�o��k5����fX��S�@]y�V��
���d�*� 	�y8����J(��P&��Z��E�yù����Gƽ�F��s��FDg���=��N��D
�b/�)��`db,
�I�֯V�� Q
m���6vjLyF��{(��0��~w<+���6~~n�A><�@\�t-���FKD��`�#���Dr�*D�/�A�'�R�k��_�Z�v����d�[�e7�������s����X�b���  f��@<@��t$o�R��1j#��czR51a��β��
��>��I��G�ʾ?�ɻ'��x���7��id�   �f�����D,�r�a��J���<�f	H�c��g�#��4g� F5��C)F��QP�&T�,�%x����w)�R9_8��cAb�Y��M	dҘ)��:,����-RHX�: ��� I�qΈiͨ�6����iHQb5�7�9L�[\�FF�$��A� �0O���k�'@�u\��  �� �� �N��T�AF5�
p]A��OCV�0{�6��$�@*��B�������˨c�d���C��, #��<h��*��u�W���R;���v�@���V�:����3�ؓ���o�̖��F�
>^�F1�s�y��L�}��L�  �����
$�s!�W� �ĐEd�k���G���P�j�dM��P1��\�!�B��o{|���DD�"c*֩�2�H���=�&I�+i���	1������5�۶�o������}) �K�0t#F�)�jW(hB�ID˷x� 0����� ���J�~l9hV���U��!|�c^�~m�=m}xv�O��Ǌ9� �Zx�U�h��J9���A��X|rgsx^LV@��+�k���
����,�r�{55��c�����Zv-�R[�J��h  с�O�2@�c�B��1�Sl�`��E�oY�F�3��=�.X�N˳L?��7����3�3�S�:�Ӂt�^��Rk���B�7{gs�	[  ='�0���)rm�� �ԣ�yT�.���i^)����v�^<	��j/⢶'2�h�5`��di�K�����ip�eDa�����d[�)Wk0�8��=�
x�Y�1$�̆��$w���G�t${�����п�ɢM4(^��'q����#��j��2�AF�$`m.8p�y��
~�ۑ�E��@�&�>N������C��4�ѥ����?u Ʌ7�?�~�X��oWR�F$4   �mP��-
�VX�pӊ�3�HO�w@��tU�$fAMX��̳j���F5�N�H$�(�&����
Pd�,�bِ2�q��@����mpn��C  MF�e�ƠI�`
�%�"���D�(�z_W��͠ t8NT��h`,D6&
@��	� .��
N?	]�s&�=�K�$�a�V�
�BH�hz>�4"'='��$i=��A�73���O�4����c�kd�����0���dv #W�	P8A[?0&R�]����*� �;�uw'�����^��d]H@ '(���>�!1н$m����%7�,A�"�
���ݦ�	3���6��@�F:b@dJ�Sh
�[��+U��[��W!(���`���K ���Ȇ�Y�oV��@%��~6�h�+߼*M:<a4�r��t2+�=��6F򪭪��ڄ�r��gP+%�D�2�X���P��>D��lW307�V�_�s��XɯO�.�Hj�Dǵ��������ĥ)JK5U�im�8�l�����}����V�1��!Q	 �e�5�Am-�ȹ�_)`~����
�A4�p��x�Zh'&��P�|'���榄:Ds��N2S{S�C�
��֮h	����d� =^��a� �K�}Ǭ ˌ}q�����0 ��v��?~�ԅ�Z��l!�,���١�2�o]�#�L`�l7~��y"s��ŧ�������/������TĚU�Ɛ  
�!"O��ڡJ����xUF:�ьaX d��V�X���O�K��٩
�y 0��qm��$Xo�,c�U���9�
��?�
BOUc����hT�4a��{��8�p��
�`T��K�	
.
�(t�FELH�.�19�(���$U��#L�H)@r��0��hӠ�i	���Z�����)�d�I)�0��� Q�Κ�|q�C����B�006M�,Ԁ�]LƐA];��I\R�,+��5�z,c@��A H��U%���S�D$������D? J]i�DM�K�=,I�yi��a�1-��(������b+o�ܶN���?o}��j
�v�  ��>1��`��7'oÊl�"�2"U%#�ᙯw��jBO`|��0�ǁ����$�BpPH�H�A_=�����Kd�2A  ����⅟��\��B�n������r��G��̻�s2��-0�. Ʃ�Xԋ���I0Nf�A��s Ƒyx�uz�b�Z  ���a���B�%g�JYR�ZZ+aZv���*�mITPK}�fJ9�C���E�e�����V�L<Mi��@ٸ�;��@��'����[P����в��OI�!�@�wV��)Ŗ��M��~!��-YN��p���v��2t5`bL57c@  T�Bf%�y:=��3����DU "d'�Y��I�k-�	�3k��������Pv��>�>��NI(hc,
�>UB�;f����	�����f�]�{_��W�7���lk4�bC! ��]�A8&WZ�	�3vI�j�YE{��tj��ALo&�J�>�3n�+�]����n�S�z%�	�� �@MZ/E*�a,@;1�*R`ȭ�H�O
3�' &��gC
H�d��V����,:���PnG`  8�d��\��j��8 b�*����"�W`��ͥ\�!q��40�Vr��<�,IS�^���	��!���͡#jO�/�@��
K�04�θ���!&R��t@�/��A�`K�&"��Ο�(k�&���9���v��}Oֿgߟ�����0\��G����Dn1�&�A� K��L=#F	t/eF$������
xa�HJ�Ҭ1c���QQ����Ȑ)DJ���D�
�}rM�I�RJ)���ψJ�R,T6�c��űg�+ȏ��:4$f�1T�Pp�"�,��Y��"C�'��{�;��U�ĺ'"rh�n�B�C�z�������DUj>�M�@ T�&���v�dE95-*�JAܪI�_��s��.6�{0�
�G؋MW^����5�-�99G����������_�DA)�6L�?zte�&��֊�@�ȣ3IAP�"
��i�� C�K$P��C��������� !
5�����۱�B  �#b�9��%dW����G@R�g���p@#�Ei\�\�qÀ'	�,!Q����D��l)��J`KE;<�lI�1k���/�����̨cu��]+:�"@_<I����U*� ,�0����/,G�f5:�C���(1������x���۽��7f��mݧּ߮�����q��MJz�`�!�Z��`U��D;/Nj��w/,�l~ Um`�گ�CpV�k��x8?�;�u)�o����� (4@	��=	2��A����(��!�JR�6߱pf�4
W�A<���)z��$�vႨ.��i5G@�7R\�@�p��ɸ�|
B!$�\�@�	'7ͨ�5�g�gS�Qg���͝�j�D��P�!S�&��,]}4�!�9׬.��]�a<ϓ'�~�Y�#�ӣ�\�8�����D��r1�M<� NEJ�� ZsY���A�m2��:���Y޿�;?�����?p���s��!�g�h^M���u7 xFTDB#hD"G���8��GS=$̐�a�R�T
ض�'�Yd7�&&B:~���x�����?V$�(�
��S�e�����!�VgN#
�|'�5V�CU�'��O��gfpt�Q�$K�ZFf��6�x���FF���4c��9�LC�^6�1\߼�MS��G|���X��M�E�Pw�������,� ����:�Ď�����Y�u
%�d���rK8F?H�r�kQ����hAh����-sp7{0������:�q.�R�˽��bg�$ee�k���[wH�  Ǆ�P�N��K=�jq��3 �t���D2�"O"٧<�M�K�� 	@mg��cA+����EdCO>
�c��|���R[��zr�C�7���0�I=�E��T,T�u5�&�
��)�E)�i3�a���RSr�G��)�b�"���bs��
Q�D����
F�|�1e.U���S�w>��r�3-jn�� $P�&d�4Be/
��U���A
�����8�a���,�K�C�B�%1Y.:��l6]�Ji׺E��m�I@ ���c��1���v�� P٤g���)n�Kr��b��
��׮Ő�]4�G�+Xu��Q�>����RS�մL���̫�L��I��<��aVY�8��
#n
�'#���Y��Q�n��aS��g��ݘ��{>/NK4�1E��0e�&���DJC(X���G��~=�7�|�e��m	(-��
i�%GN�>W��B�;;.Az��ԙ��	"ډ(mH1���t�J�1���k����z�}��Q���1W�����_��iSH  �d�\N{�qh�#��^�y�=���J�B�o'�$����T�ߎ��r",��yO��[�d����{����[zJ+$QA.qS�X Nv���JL��N���C۩��uH�7���lof���3b:��52~�;�<Z-˚6�����	��n_���X� T�æ+F�Hc ��DBl� nIwUC[�ċ�
0iYt@+���k�ωO�1��ěyA/M����F����q&�i�I)(b�,��b`�J���*&:X��X�3)I�)������"���De oZi�BM���-�I�em�$i#n���A``$�Eȋ�BXx�8huB������MI��h�INPLT-h�l��Z�K~��)sH����M�}��D��a�^�_�"�45�u$��G�V�1���ݴ�*%�   
���\eϳ�9�N�?V��]u��|Ǜ���f)<�xQ�<.���7[�{�셫�v¬�u����� X �⺃I�!ȓI��T��V=3@���w�~�ȓQ\�.�O�#Ll\�l^\���s�pʲ�WKn�V�nH��k�oe���@
�i>U�c��������!ʐ7���D��{���$�b�G�T�Qp�ݶ��T�XH��D��X����פѶ�1p�p_�
YH@XɄBz$aLv���Dz�"P��1�L�*�<�jH`�]'�	I)�n���	��k&��0cL��"@p�@J
�.�J�����l#Za@�:I����   � ���)���j�a��ɻ$��Y������7���R���"��os�ɕ
��'�����Jz������c$T���   ��B؅=?�j��H����}�X�T�ݙZ�XF��RH^ke�6qTN����Y���_:ڗ���, U2�
 �[E��7��O���V�Jչ��������y>~��6���X|�%aw��L����x6{�2�l�c������.m��
6���Z����e��r�$t��H\�5� [%�e>�KkW�©����
�[��B�C���xU�nJ�v���D��"^;Wi��J%<�jI0]]�� 	-k��` 약r4ڭ���S	L�3 C�"Pր��X��D��sfE�F�AgQ@X�I��l�
�l���z��
�V�*��}�K�V�ɥ�VH�Z�x�?��*�-�|�e�@~��C�@��L{'ժj^z@<��x&BFy�S��а�3�pQ�e�"b���Ic�㜇B�Q���
(F��c������<t2-�),~�1J��:�eM1�$�PL&P���bGe�o6,�F�9�/�~��wl���DE�4�^ft�`dNP����Z�O���:s5s�W
��9��E��]���v��eg���������mz3e�{o�~}�;�~�v���M^陙�����)s){u����d� �^��a����}�0 ��cs�� ����  |x����U�3�fJ��b  *�19�,%���h�e��;T�p�P�'_2��h��Nom�G%�.��-`�>
��Vd�&n�6�a�%(/0SI܊�
�~5���_���K ��  c��V=bU3,
�
ϳ~
1���]�����R����jQ�ec   I����F�70�Di���$f	Fzdu`�z˹:��m����Q�����H��A1HhH��k�-MU���_H����E;���|��o�,�I`�Y�;�7׭�w *�+�
x��w����MO5i*g�@��@�_�d$]�Ȁ�g��,isD@P�Lpx��p]��r��p���@�٣�F��C���df�*Z��7�
$5��g�0E@�l��x0 %դO�:,�d
0V���
�
(R��A勚J-�Z����)lP8s���CX�	�6e�9��R��"���a9�8@��p����-јBUdA  Sΰ�&f x:A�x�P,���� 6������<Au�P�
뢃HE`�a�4q+4d*	� "�`0<�HZ
�W*�@�ɭ�k�g([l$� Ph�e=����#�� �1rH(�Ѝ�>ڮ�5#r,�ѧ��ܗ� ��	�F�  sa�[\��5H�[t� �/�Tt]1�6��lf:�Hӏ�}�:nZ� YR�,��+��,\:
\�20\Uvς��c�b�x��UkJ�����d} 
)�{P6A
a�l�_��� �j����EP  
pf���E�o��|2�����چ]�̈̔8�6�*���%��#�
#\ �  �6TQK�>�$	�/��a�d�Ւ�����X) ��&Y7e�]��eW��k��}ݗހ2(`h��IMs&�C���p\����:���6�j�-� ���ʂX���H� 02��~X��ǈ�=�@�`�Hk�������_�����
H0[�	�<FR%8�;��ՕR�U�6��(? M�L_ H�QK��ɨ���-}j��"�=uMC���"�pX�(�^����A��-����Ɗ��$ "3Օ��v�H+�O=��\C��	��������H`���N�z�����d�(Wk1@5a;�E���]G�o�ńm�𰎨�N��>�"pM��X��3HWXp�����[���x(�,���,�HY��'?P��p��@!a�ÀP
T�(t�J���xpm"��qa�b��!s'$�A Hp���(�ĩ	
�@Bd��<��o�q�����<N�u�ܵ��x2�_�   �o1%vc�%��r���i�ë�-B�f�$(�5e�J��B�3锒��(��T�C6l��K��e�m}�I��E/d+i�� ��1G  *>��}g=pխ�#Q�c��a͈ش(l��He~p@��<��S���X*�g�*�XA�i@  
�@C$����vL�
E�8��aa�YmDi8�?2�<���5�q�2���d���#�i�`:!;]K	 �P�YG�O�����'��}1�G�hk�z�m��b�" �ˁ���f����-a�$��@�V|�#D 
P���p��3b���!I
u}������{���j��E:�F,��?�`H%٥b�E��*�ݢ�AOr�z
Dk���G����ո�a]�IC��F��L�G8���L΀:DZ�T�:����	Q����b}Am�Ęb�ͭ��nkb�����V���1W���S�^u��>��Ea����O`(# ���F �� e|p&v�q�k
���Pe����j§�\|J�u��s B	�Һu_7���T��w�� ��Q�^'>	�a�|���	�̪dU���dń $��2D6G�}L��ygL=-�,Ԑ�H@ Ng��EL%Q��aBl��UA����I���XΔ�aM)�������,���LME^̍2
I�k��c%]�'&��)\��iw@�ф��E�Ue�#��0E�؆��IN��YK�.���I6��  ��Ōc?� ��]�����J�6�ԨeAFz�n��UWR��"�5�r����U��Sd.�N��@*
 {�`�:О'����;�	�H�(�e�-dS�ݹ/�� V��Za�xn����YL��֬=�p����
�*)R���n�*��
�IhA/�[x�����Ut�c0��I:��!��x�WN1�P�f��f0U�$��+Bm�$��\k�Wf�4hS3  �#dS_����d��`]Q�L�>��=�ː�i�o ��t�
#+�j�C��� �27N�š��Y�B��PȎ�P�3M����^{�2�/�.g�8�Է���&�>Xa��1��*�6��H�) �'X�υD�?2�%Aw����H�YD�\x\y˭��vt��K������   �!_#���_�6�Q����1�R�(9dd��U�)l�h"P�	`�P5�՟�־7��W�OD���P�R�}�>i���i���˳=��"��iv�˞@�hf�E0xP,��
I/���|T����Z#7����E��P��"*SXx�
;�` H����" @\E�"hx`$��p��գ&'���˦�����wpk��o�2���d� .���8A�$9m��j�ケ0���tV;\�Q�s�Z�8����E�}q�)�2�;�s(�����v��0�2̬��(�*K�}ο6JP�%����x��i�z���H��֡
Έ��?�����rH��|�M�
\S��O��0@y�ȶ���н��֨�Eг�!���#	vhi��o3���`� ��|
��Q��f�:�u�J  
Wp\O
%L�
RV�o9krA�*o�S�н�����i�w���*��(  !@�&�a���g��\�$\�T|a@Dq��2#�Ƿk'	|�i��	oe{�*�6��F��#2�����0Cց���d   �'�=�|�; �"���v(f���d� .Zk0b7�̟0)e� �i��k Ċm��0|p0��o^������%܋y�'f.Su�*^�d	n�c(�<1KX�6��|pskI�JSq�d�a��1X���U���jU��t/u��3���ɖm(p!�±|�G�1�m.�]f�h��p�=a�
r`�4��C�%�����)'3�H�5�Q�I�
�+&+��,*������Zl�f�т8qF[%��vc��̿�%}<���ܟ����t���=���&���� $*
�   b���pc��fR���㍡!@�t��P��@�����&�!��U���$HTE�04p0ĴTB"	nw��a�)�
dH�e�P� n'
p�z+�� �:��i�Yz���D� [<Yi�`NDK=<�Jd�i��e�n��􍘥x����g"��N{�����A�*ݎ�����I����n�/t<��^� W #����;�@W@I�h	J58
$8�yS
A��C�.SO�F!NG�(M�ƪ�l��
�{ƙAx����x��K� ���|]5���뻓6U�JBJ�D  %�TI�d����k$�����H;�ʘ��1O��zyD�z�
.�WE#}o�����7��.-=���d��/��l��J\Y)��S:>���*& :Z�bg�����:T�ٶ �v`�oK���\HhDO�\�#z� @� 6,:�y;����T�`��&<�8��P��H�M�ȝ$���D��'XS	BPX��_<b�
ģ]'���N���	x���}��v��pL�W-|�������AERZ��Vb�C>�����!|��
��6�r���4�C1�A$�h�+�r���9���	"a!�����,�Uh�͉�%��{�'�3����᷋O����?߅ ���5�`ʋ��_��~���#� @,NS$B� A�A��V�� k��g<�<�ʫ̄Sl絖1�xTp$A�:��qE�(3�6U��	� �a�;�o���z��#
 � ($d$c&D�^�~,�[q����Ƶ��t���꣦�M(y���̈́�SU��X�u��Y��(a�dD��� �;��k�P�ڱ�D)�o�vv��d���5^r��닯
�����D��"Zi��[�_<�z
�Si�$g	Z��0Ê�I@�D|6l��[�-~O� v1���5���w�������܂*   ��$�a�R-#t�JYvWúA)"�W�I��+������I4�w�����L�>O�묐"ԮW,�J� ��/��Z�R6[�.��� �>- �2��P^��u�D$��$ �#Gd�$"F���(U�S>���z�͋�3�e\�
�Î��'���Ȏޤ��Asn#�f�<�t�ʽ��   Q��NE�De��8�B�6#�CQs /	�Bw�S���i�Ξ�\�D��<�i���^�Yd�fh�������r˄=�I��x�������mBa˨�W��ﾐ�<<�"�&ݑ5hI����d� �I�i�R)&�80"
��c��Z�'
��f���BH�@mb�n�{&�PX0��w7��m��4S�����������.H@�����Jì4S(�� 2##i�Q@}�r�!�)%���tq����RMԓL���j���P��ǡ\�P��(�ȑ�.��Y*�1�y���ә�di�{;/b@���8 �� ���E��Ķ�B�؈�H y���
g���j�Q����_���B���}ԟz�!����?DGȅ#�������� @-W�����Q&ta|�=#[�?

���|���� �-;K�j��}��8�����EH��ziL�W�#�^"�"1t����r�e�a�^X���}N���Y����-�����5�m ���d��=W��/<��,a)V'�Y�l0�	8A:!"(�l���2�c@��ðsЈ�����)�1 QC��P,3��P��#}�
!ܷ�� �� � N&�4�E`�5����A���xq4/o�C�ӳ��};W44��W2��M$����HkƇ���Ȥø�	�=��rL����t�^�����\�����N�z��Y_�����M?�����c(
� Ȍ�  ��T%��s�H�݇���h.�gЌ������ d1o��������(�A�'�C\�y0�E$ i  @:AK��Ph�v!~���EI���#4�Q�E���ޯ�r|a_������\���j��a?�I�фO�h����9�E^;�@���m�Z���P:� " .�����d�xKVCSp?��M<�Hi)W�=��l���XN
���K�j>�i�E��H~�5�5�\��}/7��>��ߔƵ
���������_u���&��0F��E(7�� M�kQ�� B�}� ���"	�iT]4��y�U:�g��<�Rn�뻈��Pg���`pZ)X���0ϛ�R�]��d����M�5
���^*>gl��-N�`�%� ��5����E���ؚ
��	�K�O!�3��A,@�L�)	�E��:�O�@�Du��Ƈ�4�(��2����?�b�n�I7�����o�U��n�n�F�{O�r��fW-�&婁��b�A)����t�3wW/#'�.�n�E�QO��wϿ�6�����D� �(���=0^+=gz�-]G������t�������s���X�#�p|�p������l �׌���l�
$������[�.�,��÷=��iV1q��� �R����n����o�d? e�����=�!�?��T�Ǘ�H  �w����B'Y��[�d!:�(r!�q�"Wi8�潜GI�S�;�$��[N�c�U��a�SD2��dC\�?��H�u9ن
��R*E|�\�;�b�^��5ơ3�0�%@�BBC~��.HI|�$X�b�
��!�)�5�ˉ���.|���Ze�&+Rh�� ��� ����q��]D�XOgR5gM�~�Jϯ��ω+����r�J�	d
"a�Ltу��6�n��.u�w���D� �6���bUe�1%.S�{eG���_/�t�2�W�����{9�
jE{�Ia �v薐�x��e@��`_Z�(�_-�*�vKZ��i�}I<|;L�~�~�h؄  Zy4��>I�L�q��Ʊ��BE�S՘TN&o��W'tzE�Xgj��t�H���Qbi��%4?��}&��F�J(s�ܓ��>�������t�zj���rS�w��?���K�t�>`Po��d<g9�4���z~����,�%��d1
��
*�Ӓ1t�cOUK����F*1C�<�ůW�WAP��2�6،��NI���c��l=#��E<��x�f-k�PY2��-�V[U�AJ,�b�/����������޳�
�/C/�����e�����d� ZY��J5	;@V4wq����܆�x��ս����T��@��@�eM
�X����,s򆙷������dCK��"@�ƅ\0իhtz�^�5��챀/��gdu���a@,:�H;L��k��37�\#�$԰1��0c��������#/�����he-dL�\�cV(i8�nK�[����+�}s��
K@ ����L��yua����`һ�������CG�i$��B*��̱He��cP�:�H#ny�z��jn��.4��v���$j��O���Эϗ�%�<00@]��Uk������C�^#t�-*�4�����A�V�9��T�ˠ���T3j�X_(/����O�����ԃC�����yzI/�_���d�#5[�`8!˟<#H �kg�T����p����Z��
)D� :�>��Dw�X>J}�
��8����v�V���h���Wr(f����$l��3���ޯ�;]��G8>u��o<�*P sR�\X�8�+�(:i� 0X<<��#R5��f��	�jT��+����ڿ�@������'_nk,T-Y � P�Z9��4�+<��\�����$ld�)�P�99+I�����+2�Wԓl�K>(�7.�WA�ޝ��:[��v�N{��� C�CbIpl%.�'�`�TA#��A�xM=�����.��N��hp�W��V�^��ԊI
�@ &�w'E,LG6��v>A�u0��|���z�+�򼍻�Ф���d� 6Zcp8�\0%Hg��q �0<�	B��Hݒ�e�,�ײb�E$!ED��]�šaq��'X��0Ph`�$P}j(���m�J� #���ƖL��̎T��e�i�t�v��2Gz�Q��l�{[\������1-� �ٶ,ϒyî��Ik���l�)�@ʡΑa�Z����>��D�Y$b�d>��*D*'�\�KL��3N��������d�pdj��a	PP�@L�d����	��Q��?�X���9)j��������ؐ�jU�@��R����� ���BLq���4(��um��n ���E��EUy�o�FR`E�yieE/bN}�P�3��/��觠FO��"f�mkYGx'?���MG�����d�*����6�\=CO�L�g�,M@�o��V0C$� @ZI�C��/V���A�x��_:��m�T���"f�I�H�߿� �  *� yx$�.p3Ѕ�$v�{9�j�,��$�q���4z�RxA������!���Q)���er���;;�r����9;�.K�qмp���g�_��Eeکk��y(C#0#X qn
�O
M����Eܪ! @�_jb`�����k��L?������>�cW�@Q#Vc���,hz��jA� }۬i�FyJ�������ӱ �Q5[��@)	��Um�h5DnHD	9$���)Zg��yޛޟ��Q��2�P\`ј�22�<e]�dH�fXer�#��'}�������k��� �i�����d� 5Y���/!�\,%
IZ����-x� @��W���܊q�O*	4��I�W�:�%���S�(耘�P���8�6\� �@�]L�*�#���8���Zo0�����\k-�ݵ������C�F^��d׌~9e���y���c��4q���`8.�U�Mv���1h�B	=z�O��&�TZ���j   LѤ��pq�*���G{G��g��x�`5���$�t�3���urDI  2o�XA��IoYe5+/�U��K�hv��f�@)���Jy;]$��
Ii�Y,��C�u�4OE�!�i)Rf\�m�@�I$����h�������Lڞg?K�r\���K��`���Z]4�R$F	j�����`�3��h�������d��>X�	+�Ba�M-�1�/e'�U���0� T0',�����x&Yw���u��Ë��\} �΍|8jrA�IP���$)K &�*Bh�*%`�?C0
b����P� f����=$ő�B��)&�'���rI��hzI=Nr$�B����*��bv��e��'IA�P����T<ʏ�%ѯGn���� P}��.���e��K�����?�E^)��#A"�@w����Y���/*��S	�IK��EC'D�"�4Y 6  �	��ث���Kx����T���s��Ik��A鮵�\�j�q�C��Gi�����������&����� �� �ƌ8=>3�H�z�J�F��,�:�
I��H ���d��IZc	pF%�4<�:
��h��(A 
�t��F�޻2P`�����3A2�%4 �O��3��ϥ"�9�o�H�b(��:+�Ra���a����J   P�v�HH�1E��#q��wv�?,�C�5;�oƭ�)f�$�e_R̄���+��ϕ��{N��K:���v�ө���.����#rO'��)����.�"0� ���>1��,�
�*�D��]��P�1=�2�ikl
sh�zz@>EF�vy���BPf"<)UD ���LgKE��B�d����r:�g��<_��;��w����!���o.�$���խd�[��[���� ���Ï��X�h@em}l�AD��(�w�ŃQ�M����-L����d� aJXC+�C[<0eV��c��X����(F����,4I)R(~�4��3�?��*��s}`��GP�ke\"�7k�B� @%lrB�.Qa!`y)tƓ���6Ve���)z�
��^E��'�ʙ{$ش����Ȅ_����{���zxw��{<t��ǹ�ϟ�Ud���$�
���F�P��>�',�T����XY��iwB�
���px��y$�O�����B5�+�!G��-�� 3���L��(�ͻ�   �DV&EQ*��x� F����F��$�De0�QC�7��J�:�R*0�_ۯʹ�PZ�|��t:�Y�o����F?��:hw�Te~G5��V��ޖh��v�ͼ��I h�����d� L7V+�@�0'V�|�Y,=���l��	uмIjUm%�:�i��(h,6x
���E�AC���)=J�0���ɸ<|!��e�
rӘG�L�Åh��IV�ۊ[�X�×Ap#"��<�C�ɱ�iBǁ���NQB͡t���fT��U�
ގtmt�%}!�$u��u���>�SԄ@���:��w��j����_�5ô�5�z�p���y
��*g|U��������>@?2Q�pD��Vt� �@   Ș�$W�$�	˃Qc2θQ�ISY�(� N��R6�s�;�l!p`������$\�
�D�(�y�q-l\�7,�����N�v<�t�E3y'�?t*�3.y%PTcܑ�1�
(HH%0ٱ�s���d� �JV�+�A!�-!%"��k��O�.�e���B^;�`����qDŐ#����/���(�8���_��S��P��G� ����   ���T�JR�od�&vWl���ˋ?k�c�$Q�D��/����g�,~1!95�F	�B� 3��b'D��#E��S"@�,$I�(P���s�a<�&�u� ���0���*Ģ��c�L<��ɛJ��=,�:x�uӓוt�;S�j�o��ެ=��t������K��w�.S���0�F g.[	�u�ŐH�vbC	�,IRȰ~t�
���*����E	��g��*�T�D  �DVSc�)��]�m��jC*Gխ0y��d��NСH��(���'�]�����d��I���pCK_0"r9[,����	.<`;�#B�Q�@�h�%T�b�u�Y��/�*����фD'om�	�`��E�:,�MU!��   TT*R2�K`�@�
�k�����02��\\�Gm:�"Ϭ��%ͥD�  �W &k��YacI8�G�rY�d�n�=�����uU��*��	�d�BlY��nRk�6���H
���d����@�������KG ED�lM@4��]?���A��4Ä���RT'���	ת�   (��4px ah���p����0��D~����447��6��o��&���+�&���&Z����l�@�T�8�./�ȞK����0���E���@�\�Ryd���d� #fF[�),P4�lo0`9�|�q��l����0��@gZJw�����V���/飼�쮑���XL)R�?�>�.�D� 2RN0�������ɀ� ���R`T�d��;��[���W��N:*ⓀHpW�\�ӧN���D �$i��z]
$I�7"I�ws��@�nr_��~�$Rl,���K�Qm:Td i9�#T.`���mc�{��;��!��hp�R'P�֙(�6"xX}�E�%a,i�`�4���V�j�L*,@ ʳcLU1��\nP�d:�	�I�щh�!zN@�Oz'餟B������h�����rns�G�=ȓ��I/��q�����酕*vl���"�s[-��t7
����^�?oZ�r4@~-���d��'[k0�7���0�2p�c,�$�$���	�i�0�)��|/B�#��
O�s�M�2��#�`��Bh������-�[�x
D $Q�^-�}JZ���Y��9��%@:d��C��|�H^�L�I��=$Aލ$�E�7ġqVs���W03\��]�}�3M}ݴ�ɋ(��PaK�H�n���Q���w!����HOo�d\�Đ��A�Ϝv�Op(uR,������h�jtkҖ�|^z-}uT�� :�2U�}%�4w�Fǉ�Q���r�t�Z�u���Z�׳��h�^=�r$�È���(�NwM DJ�\N�J�]�� ��I��	���Q�z$�r�`��R�E�b��28����l� [��9���d��0��J�?A��=##���eL$��/<�� �J ���&iԕϣ� ����C�	�����F�>h�.�U.a��,<��=�`�e �h�YJ8�I+a�3w�3YD��~�fƪ.V���r�d��(W�^%"��D��e���JRT�9�4<�C*��Ӑ�P��Iw��]ДW�q��4�"fgv��Yg��kP����A� �+)" �5��𠬝��bY��N�^`h�k�_�� ��{>`���ZX6� �VNX�*Y�B���e	�;Ld�4
X=&0L�cQ0�6�I����q�U��х����4E�''}���$���{�4�A�o���\������E �lzE˅@6MBF%:�����d��/׳I�D˿$&b�^�0����l����*���'Ga��8ò��`L��ࡏ**��xa�X��!��F{"���A�m"� bufM#��  �Ɓ/�d-`��YA�Tͥy��> t������F�tᙦ������s9<��0֎���q��@�\2d7�c�0�:�o v�"X `�5΄X�D�#�i��.W�I�\t֤X�/�ݡe��5�GqV�|����5�T��[�D���
%�T��~�>�������~%A��� DЀ R��%�P$V�OZ5P���^Rş�~B����ڸL��M�c�Iv��.�ч��xCТD,�Ф!F�y����u8�|����hλ��U��5��vV/_�����x��2�#������D���i�@�Y"��1ct
ȭ^ǰ�A^�� �\�*��b� X�g*�
$�)�b�:&9ܘ�%�x��S��(^[�b��o�N�t�R�̊\�]�����   ���`n�`�+RȈ��.�Z���a�? ��U
6/��Ҹ���	�mզ�kW�[���p�G�ȕ�N!v�\u�#��K��㺥�n���п��ۣ�uV
״@�eUh� *Zby���X+�r�r������D�,C��	�h�Ջ?�Y�� ���ND�,���@)�M@E6���c=Ѻ�^0��d0��0;D�}$���t<s��	"I��]'����|D�'�zi#I1[�(A�p����II�� 	   ;�+OU�(S'F$�4ײ�����d� C�K�S	�9�j�<gX
E)`�=	@�m����1�$0}�
!7�B�$�H]�I�Aބ��wO�M4(ɞ������,���)ݺa3�����`�=�,?� E��O����)2��w���4�x��7cW�T&պ�W7j�t�晢3�A�k*�1�[�8an���(uv{�e;��M�����Q�5�*u�!r�my�L%�  �(t��'19z�9%Y"���k�V�bw�d�t��hg���cUF��s]L�G���'pb5׵�)�c���c�"������ d��;Q6� � �¬�kh��5$����d>
ou;��Z��i�2 ��GP  �ʦUYB�C2/�
���  ��` "����r�������D�+/�/I�e��a#~�'_G����,t�
�8ߌ��~8��@� g�$���l���oTs!샮�������L���6��	 g�P�˝DK��?up��ы�9Y�ѫG�y������c�V�Ш��J�R��	��  �qh�[��SU�H�X.��D'+e��PSZ�K��Qu���A��݊�j����������뾮TM5�&�}�ZUV��w��nh�8EĀ$� �����r�8� ^ɢ�(\*x�5�xl�"t�U_H��o�)>r��T Aу<tl��J�T�J��rt5� ^��a�j�,M�(oa�� ,� H7������D���D��"W	�OO�?��}��Fi?�'�	��8x�I#B|eMb����Dր�6���0`K+
=�K4�YL,��s��4�X&�~'.!*��1�W���K+�,��?�^h��r����0����H �)m�m�
��`$eМaʔXf��H�~L���Ѧ�j����7l�-N;�o�vT?w� �싣�VĞ
�x8�*�?�˙�aV  @�B�	�I�C�Z��
��˓�.��#�B'��P�ڀ_77}Y�܏�]7�DB���.�E�e��M_C3�T�+�����[�A�*V����   �|��+9
�P�~_��>v����/����ۯ���0������Cѡ@�]4�25y�3*採��/� ��n��!�y?+j1T�O�|ݥa!f#�  �� P,�2IHs9��'3����D�./��=[e�<b��)YL$����h�$�G�|�������7y~l?��G������f�����o�μ�yL��&S,�r
ͶaC��'�EQs���9����zH� f�Q�"��  E�p�� �90�)���{�s�k��I8��x��Nz�8�w�{͑�ք8�V�yA�U%Z�j��ҭ��fC2}�j=�ʵ�U�g&v�Y  ��������JK˂5��.�����i�V��,ئa�_A�Kڄ�_7����#�$�I'�yؙf����x2��	 �
��;�����L#jT:.#7��H�	=  ��H�d:�Rʇ�y*m\��8�'2��R�Y����9PLk�ZN��"��]JҘ:�[�4˦�UjS2+L����D� #CKU��])[
="���U5�������� i�ޞ�65��$Q<D��zO
�j  Ru l��dZy2cB����gŹ���C�C�v�S`�/�T�I1��Ś���4���[]�e��R�W^Jw5�W�.b1vx���wH�Kj*����y=�ir����8_����y��M�d9NF79Ci��st��V��J����k����r�=��z�z�X��Ss��\��ir�txc{+������������������äaqJ
Ŋ7�W J���a�
~#��!e&�V+�[Õ2�<D,
��2��c?�~*�,�&�Z=����E$s3��'�F��7�Qq��I~��eg|�b�]F�q���QZ�5e|��q�����d��ZZ�Ng  �KZP�< U�_k���	ªn�PX��T�v���SF���������������?�����I�c�粍o�H�4H,BA�8��H#���4e�#����9��$��p�J'ӊr�g��4$ؚ�p��;<�'�x������i���e���,�����3�dl���^��޻}$ӧ�1�<g��w����)��e�-d��U���|Vx�Ŕ	��q�o���1�Nj��h��ö��
"4E ��0�HD�[P੒a�D��$�o:X�Mv�3 �Jx7�pO�kT�i�de:�'*�ś|��u=���EwK\�%џ!���K����AJ �>& tm��Qjq�@  (X	�<��7�r�����d
}I��=  9 �k� �MbǘuH꫱�p��v²��¼.����;�}�-�T�Ҧ��������L��E����<n7(��rڜ:�$du���J��Ɩⴵ\�k�ޟh��(@P�uz\��J  `F|�L�D��t���L)�_6Q.�/Zu%�G�)u�J�mM/u�qh� PaG��dG�dڔ�1�I�z�۟����^�L��R��D�W�yIx~��w8�:�*�yC��iK8����E
j-]^�C:$�������ڄ<���_�Xj҇l�����"�S��v��,4�0*�`�Ck�4����\�����D�>N����軵��"y���2��X8y¹
 [(�3�b=,u�u"��;��.)����d��S֋R9d[$":
�c��O�mh��H4���[�����5����P��j 1�?`��A�J�)�,\�*T�Hд��N1��?�߂��h�` \x���u32�V~�F3�ܪ��h�֢p 
���ѯa��+�U�����gY�>����\L4��@Z�c�r�I"��04����Ј# �{0_��L.�Ժlˌw�L��7�@�Fu
D�!z7$��G�p� 1��@�0C� ��C�ͯ�S��L|?_�M���/��Z;��	��s�o`��S�x� ����PP�E}*�D�ꩁ&�����@�E��X��(ʓ<�Rv����R�X��@  *Ӥ����Aĩ�bI!⌢`,憔�D򾘲\	i�T���D "�'X��B]�m<�^ �i��Mb���pÈ��v�4��Tnw���<�8
���b)�G�z���~�`¡��(I�U̫�S���*o�ݚ��  Ix�S�"�5�0���Q� D�#��!�CV������X-�v�*p���_Lӹ=�YZ��e<Ș�G�������V���<����v{�t�R� )�1Pq���_��pGB���H�
��6���К����["s�V``�#�Ϟ����ƅπ�Sb-1R˷�?P��Q #��1nr�YP(z�F	��\�sA�)tx�g@��b;&�OM��B���/LEb��iU�e�g$p"��:�p�M�?���=�)7��{@�d#���
Z�� AJC,^HbĮY-�TL)����D "�[Q�9�X��M=B�
�{k�$iA^�4���í�dԎ.f)
��CWچ*�a�YG�()�8�v�a�~&�n��� �ad�2L�-D�Cq���.�\�   ��8��ć HZi���4����(��oG�ʩB6'ڌ��RN��g�}�f���M"�pvv �3�H���p�E���}	t��!)	Q���8(:5 b�E���,r��꛼# "���0l��<Nh� (j2���YH����
x�p�����2�S�YM��@ .�1Դj,ҒT����a9�⹤�[#��E��d�X�]��p*�zsT����S�$?=�i~�����QX����@d�>��t�RNn8C[���;�	����D
 _�i�4Jۍ1&>
<]o�,J�G�|��XN ��<�D�b �U�b�W���Î���0�r��� 3�����ٕzV��S�V�`p���H�K0(�Z��qV-�ޣJ��k�0�G�#�ʻ�	�D�]�i����3Z�:��!��wz���/�VJ)QD㸔PC	���qE��b1{��h1�5�t�S��b�٬b�w�,d6���
�'����=��E�0��H����|��P" ���P�GDN3XP˶�ʎ�J��Z�v���n!���!�/���v�!�����>2��K��Ə� '�����-��vױ��𘒿�jx%=��븾�[7-�(��hYNS�ܜ�S4r�wB����3�ԥ���D sFZ)�RM���$%�̛g�2�����CF���C�	��y}��u���_�6��   H�´g���O��p5~��n���9�����S��+�#���o�}���;���,+�Q^�莃�I���=��s� ��( jxtQ{�����K����G�&�Mٹ��" �\�c��L&k�_��"���֔9WY��.�7�7I_��)Z�K� HN"N���'�%�dJ��|�I��e|��cm�@@o�����9�O��~A=ۚ���n�w�ME��P)V�����Ty]�$;��ʛw�1����>=<����%�I�GG<�s!#k,�
P�ڠ"Ǳ��As PjϾ�u�LL��F|"��65��*�[(����D1�d.Y��`?#۬0bx�]o�$�A)���ДUܺ�k��������P�y��n�t�?��䌨$!V8�a�`����{� �5ڍCB��8�i��� 4�'}�����d��f��ʸ�$F�5��7T�)BP pR�-Ѡ$�BujbY��U2�����B}usHS��O�׭�R�m+	��42z$=��y��$:i�U�"� kI`&"�>�l�U	S�\u04�q�����WE���V���;�/96 ��z�L�@I
��u�!Nt@(�������.� Hs�tF9)	ҍ#�t���=6�Mڠ���R�i�?k�JlT��`配�a����p�D�(�^j,�r �%��d
����DR o&�I�S�I��1bV	0�m�wA3�n<â(�J�g���m��\��{2���f�o@D�$e��J��d0澭�����
^��x$;PXTz:\�!L���aRgD(��@T!Ԡ�d��P�� ڒ\	9Cy��1�ڵN�w�wK�� �ޱ?�D�z!���|a��#��-����P  *1)�c��1��R�����rH텶�UJ�xR��M���� |���ʍqh$z���B$�5��Lq�\*o2�r?N(��  ��,�'ƵXv�ⴤVu�v����0��hv!t�����Z��^c?�D��d �k�F��e;7��X�Ģ/�;��\-D�!BMC�7!ʴ	�u �N���5�c����P�e�[5�HRH�+�=?�� 2���Dh�"e'Wɏ<�L�<1�	��m��M--�¡�zr:�1���L��޳ o��H���F���F�����N�@ph��
�Ǥ)�^0;�k�|T(�j�e��*KN"��0���ԅ
����X�5���բ4�  M�W#�p����2��G�	C
a�����R����2�P0r�%/�=�r+X|��4�Z@��~_�,��
i�m���W	�D"Br]L��8��H����_��	?��R��z��q������p���R���x���Y�ѵ �[�)ʘ,7��
 H��LV>�rRxR�/?�-�*i��B� ����.���<~D�*�8�8�������e  %/��AA��#������D}�nYi�C�K%ˍ1#8	�scF�A2�,pâ����q|S/�Ь]0��^c���� �JK�SIc�k��~�'<'7X����!� ЇF�O�*�  	��.҈}��Gq���Oo*]nJnrџ�V�{���D�a���.F[*#VR	IA:�	����g�@?�Qcd )͗1!�C�R��+�Wqo�ߊ�8�(�����3��C'za�]M�s��kk!��������?t9_�$�����!-�L��
 �<��~��4���7d
�L�ʐ M�"���`q��n��ϵ*�5K��e���̸,Ӟ�Ƀ~O�)���
Dc�$	�ڼ�~�}at�MVX~�����>BN
�,� �˥ �zҍ�}����1�	����D��X&XI�*pMi�o1�	��k=,�4n8�&X��v�Ds�c:i3���]��P 	NVzq���䔠�L8���k����sWu��=�T�B��GQD�ԥ̊V�e�˔�ŉ*����-=�
:�St%���ܫG�9���tn���3�+��     ��kp���nc~�F�(��c�!�{}�P������7���ԡY	�;�� ��$ 	���/sDuK�� g���)5D9,l��5�%��*��h
��AЭ+��z9�� �u�I�:�X����D[}J����"����������u��[d� @��3��N�Ol!���g�F3ie���~�ϱ�E�~���I}[@�W�R�&�� 0�#~�}�jd�m�QP��	0�#��hm���d� �S���7G�M<"L)1aL����le����
nY��Oz(��A�Ks�X�#�!���O4���S_��!dJ�����/  R,���[k�e��3*�
R��z�K����z������樀Zn�I�T������^��I������V3�H,����
�r`
�v�$�FC����!��ݦ����>��[�9�>X��a���@{�D]�BB{��>Ă@��u5��>�406	�ϲ��A�ny��O���ǣ��p2��#=����[��?������9|i#A�e�!��b�  ���6h��-�>�I'G王;���a��ӔV���Z�L�nZ����a.*R���#fzTh��ݿ���T���D�
R-֫)RpM�`�j	 }\�!m0��Մ���A��ʳ����FՓ�E[��B�,�ľ)�P)&s+���6��
~���ej���.sȪT@�G�n�G����mL��˾�!���R�BG|.q  �n�%-I�E��� $�R���bR���]�88����	��zf/�Y8Y<.d,�� 脨@���!0�InTF��4)�>�cz���R ������x�҇K�#R:2���xi~V*V�.��7�eJb���CuQ(�홥J!1����멢�㩃��@��.�� ��V_F�-)l���P�.�q�x�D�^d�e#m$lxZkj�U��R����B�����N��˄�V��B}��Q�,�4���D� "�-�3,*�Qg��e*>t_a�=��^�q�(x*�$LB{�%mC��ݡ���R{MP Ü<D�Y
�tO�H#�8i��5��)�.W�D�x
+�F6�����j��5�kzqc_�H���j�o��q�~���}(�`n�߭�c�5�� �rR %oft$��C�f�O�9��*Ya92�Vy8v�^_�V>����Ɇ�Ф��~�4�g�����ޒ�J5���M��HE�_�S���
c�.���	`�F.I��hh���0�Q`P	VBc��3�	���Ӓ��� C��3��3��e�
�3~�!ImY�b�)�_��FS��Y�`����(g��k   %AP��XTz��Ң�vq�`��1�vFU�0�
NψE�����DҀ�=]a�L`��=<��Mc���Au�p�0!LM�4�7���|�^��Sʰ�{fۻQ�)�?_K5��0������˿���U?�'���E�6� �N�ә9-ˢ��~Qgq��L
I�B�MHRd
��V~̪|<(Z�T���ӱ�V�@8q���j�e;6��q�G���*e?�9Y�G��F���AߚPR7#������u�@,�9�%O�[�1���@k;Y%���w�|�s�d�M�<����e'8�]R�/��0>��-`������rS�3�_��0�/�����ԀH���  
�*�:Dp�_1�Ԙ�sJ�`��
����W&�0r�	���yR�2�X>��Pm��YE�Z"	5�e΁FO��c�����ʃ�����DÀGE�S	B�bʛ-=%h}3e������,4�٬���������R	(�z�Hrn	���|XZG�������u���L|��@H���j{�� z�W�Qw�ﻍ�v�7bDͥ!@N ���]&�+T ��6 ?��i?SA"��  �s������O9#ӆ��ZJK��@9�G�H�;����$/�����D����>�X�Z�!��_݈R9?�Wut�[9�d~�����؈A��\�D�Al �[�j�n��Q�MЂZ�b]L���ܵe6�Y|ܧ
Z�Xы���k�%:I��<������Vwz��AQB���đ���J*���Q ���h���@ @��U�g �1�s��K��M2�_Ep:���$���{�������|+o=��?���D���.���)p`j�=B�E1_���~*,h��Q#u��_�( �e��;�*~��p:�T����U����a�yHT�d���H�E��=.I��[��H���%9	�v!��_�J�����{��!~�����+Q�_�� ��ؐ(E*���ft�6�@�Pޅ� �>��D�AI�wR�¾s(�8|���]ڨ�EHh怶�upA1��>F��i���G]G���u�{�#=�{�Y��{�˷�2!��W���D�r,�I&R�U  �d��y5��@�! �<l}y0�XyRM���`���v�fY�f���L�_N�E���Ƭ˅͜�
�* ��� A���.�5���  '(Y7CQ_K�U+����-����D���.X��B�]��=<�z
t�e����_�������}�a'g������~�Y��W�����jp1�����i�C�ap�!Ӽ�}�a^� �܂0lV��S�d�E�ҿ��݄H�JH�P��q���Ҹ�.��kYx�A�����1��>�aç�+B���.��� s�3MXM��֋@ń�
�¢$�D*<�r����*W�Rx�H1�#a�U��)'OTC�����
ˬ�g������&0 ������dhG�U���N�d���p��a��
��g���DBds�Jb�v��E4��@�p�R�����C�]9'eu�9G1��Ez:PC4@!�h�QXN�� �Em�d����YI��3�������D���5Zi�`OF��<�<
$�_'��0����� �8�,<�j�U��>E~*BΤ�����+\�B�lfsq<�k!��Zz��jFj���'�86"�WO���o��դ'�`�Ķ���S��s0b�
װ���{厡n�knI@��t*h@\.K��O5���.�׶�G11��UTn#��JՀ���~��J���]�����1;�!'�s�8�����bP  L�0
��)�/�4-�ܕ��U�.U��?  ��\�K�,��maH�b��Q�P�_�	}��kPt�:���i�ӝбA{@d�r TU�( 
���d"�k�۴w� ��{ i˱
��7�a���;�2�Z8<)��B�m�3�$�ob�\�m�UԢ���D���=�i��QG�M1"\ �a���`�|��(������ĥ�C����U�B  	M���e��灬�NQ%��a��֛�v��D�ؗ�ՠ��S�dO�b�_�;m�s�ud��<9���F��:q��a��O [&@ 	����'�q|�E�I�5��h����|
hj5-*{B��s���#2tj0����^�F���u��Ǹ�C��c���L�K��y�p" ��Mi���P鎋g>�Lig�)�$n����oe׽F�`T
Xc]�&�q]T��`�#
:��%�q�{i��w�����_����;D@���xr!�@dH|�"f��$́��۳
I�ymVy��`�0����T{w?2���D�u���:k�>H#�P	���D�"�E�y�@X��-=�<
��['��L�pŊ0ߞH?���U�U�҈
�J���c1�"�{�P,�-��X�����'���m�+��1����X�Jĝo}�$����G����,"9��g�����  	L��5�C�2b��%XS'ya}}�?<ۯ�c���7HQ����O�������g�������9?x|F@���q;��� �@B� �9FY�Z��+�Ei�v��D�
���)�%��q�o�miz�ܛk������Q=y����7�u��Y�
�M�z��x�>^����x�0Q��>�}��E�������
$���]��C6z���iȉ ��ӓ?z��/�%?���$�����1IV��M���������D���5Zi��T$�M1'�qQc'����-�4���Fl,}5�{>�K1���'����ʧ�2%s�Vv=�ޔ�"� y�^
F�1�"R��E1&�@��ʝ�r�޾E�F�P� :g�>�l�g��m�Qn�s���	�}v��^��@M�'5����^[E��'��5��k�B�7�>�N�N����򿔍�=h��K��$�p�b�@�|,���j���������ȊW�9����S��������4���c�i[������I R��R'�/-���=��/��E�tt����f�l�<0��Ҧ�£G�1� #�s�P����$��Ɩ|#�ͳ>�U`�3��&E��R c,��� y]�򅆁�(\�h��`g���k���d� U�i��6�l|7�t�m��O Ή�t`��D  2��O�6��@���z'cH #X�?���G�%�o�ha�ਗ਼d�%<��CyX�V���tI�Ӧ���N�=\X1�Z���mtVBy����R����m�/���W�����^�� "�b������T���S
m��9R��ά-����ḣBL�:���?�ߪ�JLD�Y Qa�md��&G2 �R9:=r2VjN��g߆6�%4
����̯+���b�Ǝ����v�dy?o��~�x������z���P���e J�\.p�rm��v��,@����������<L4H&4��P�F��@P ��Xu�� �_�� ��#hp��{;Y����e�KcsN���d���G���+�<,$A��
gg�U ��4���P�
�o��b������C����;�������d�����,hFH�p��"5drȨ��C%�u�4P�ld Sou����4��U�}5GA�GR��X�'�Qw����f��C����-x���f� &9pP `�"E|���҄�CK��<�=ti
�P�0���Pʳ�'�;H�X�g��`���r�D�RY�Hz���B�[�M�I��a�B(Gf�,I�-��1�=z-M�|�{���_��4F@h����"3�3o�����԰��* &��J o)Q�(��#I	��`\i�>�3^��Ue/�e�Ij�f�|Nx���
���q�1� M$y�M,A�N	ڱ����d� �/���,@<d�}0%6 �iǔS@��<�N*�"*x����"T*�������
���)�����8����Tn����������@���3D��hjS��e�u͂l�#$W�8 D""V>Eԥs9�Ў8[p����ԉ��@�p�z��b������c��n�����ϡ<a`�xlM�I��U&Z�f8�V�h̬��
a ���h��$��) ��J��y��#�a[�����?ʊCU�@������ky
`g� 
���\�
C,c3���k*���-e�����]����q�+�@3jn
���~`��������8.8 �������q�c�(?��Үx�֒Kca�f:�  ��Ǌ�����������d� ��a�L�;��=eK��iǤ�@؇���&�൱�����z��	c��v�}2���)��(�%*v�ȏ4�dz�i�&Ϻ���U
�f��ٸ ylBh�	ę��Bn�2�&��d2���t�K�&��/��UQ�V ����� �H���t�~�e� $U�,����	|n#Ȫӊ�O8���qt���ѐ EV�����N�
�8G@��<���V��� 6M�nٴ�yM@������-`T�����}r�`�E#d�* I|��.q
�%���AB�p�R���)��|�a���9������a��DO/uۻ�E�ռT<�
�&�p�U��˦�cS�Rq@lpPH�-�w)����������fC���i��o��"@]�"����d� xF���Mb�?a�D�e��vA��|�
��-���߻�6�uκ�w���{����@&�rw�|3��?���d�����ag�����D'R�  i��ax-���LM��A[�o�U��q���ԪU 4�׽�rsS��\�y���҄�Oh ��#�|� �Q����� q�Av[7L���K"�b�G���Z��2�Q�Ы�l�Qc���ts���|��R�(��P؆�1l��H�s&D�͢�e~�U$� 8�B��n0���@I������'��V
;uR���P��>b<��aj�a�i��5�T8i��2�*/[�\8T�O&-�:#��J��v���F�ao�Q�B�Ҧ��\�M[�����D� �$�a��[��n=hrJp�c��iD,�����>�x�� ��E,]k_���'ǭ��UN�V��ڗ�Q)�C�O��qQ�_�X�	�[4�2)�`��VЩ3
�:�^n31���i��t�8��q>�q�����]��ES�"�k���@��\����xӴO���j�
���z�A�Mt�Z|<�H�����׸�醨* ����R�L�Ǌ���ffS�T�@k�
�:�L�HP���jN�@!�
�CG^҃�"���j`̩�(Ɩ`����r=d����8�U����vI�@ʘ�O"��W�Y��MW����m]��+���},�����8~�������4*��3~�DKO�«�(Q��	` �����D��!�a�;0Y��=�:(�g����c�-pÖ`V�hb�Q���� v�K���m��ҊuO�q���(�ț	�[�"˟�5�P��`���3!�� 8�
�*��% j��r�+/L��0"+��*�/�.���Ai��})Fs�h���Ac
��@��W�AԺ
's:Pt?))?��n��nX�ŽSOJ@��}`Eߥ�@ZB��:��)����!/��\#���Y��������"rƑ��}�� #t �
'iA�Ѡ��\���3Jn@P���Z��eW��Z��-�	;/�	\�������"�2�w�A�Weçȋg� ;��{\�t�?����J�C�Q�Q`}t�=,k�O��H��� )K���Y�X
S�ka`����d�[=֣+�=��$%B��a��v���4����]:/i��gN�=����E.r�b4[8
�n���ԗR�
3��Z  `���9A��Bn��$�h.�)���r֝���	\���.��˂_��W~IT�w�^���俪����}y���7U�^u��V���~�~�gC����
{!Qu��~D  PJ�jX��v�χ�ʑ��X#�u%���D@c���'m����Հ�$`W� �Ag1�ӰTDL*����߻U` ��"$ \�

K>����"	�,7)��B%+(��$b�&o^�S�#�N���?}�x：o$�v��~uD�H�_$�>+R`���4�L6�D)��I�Lj���?�m�)����h2@	�����d�n=W�,�C��?a'3[���*�lp�0��}��f(1oK�[�N�?B�5��]@t0��L�r��/�|��:�,}H>���ܕ�w���Fl 
rA5��΄5�H%��pԄ�
��qi7f���a3�'}I�N��*KH���v�
M�Ϯ�~gj�6:�T�?m�Q"���s���ѿ�~O��n�_�&D��.�2sR@@  P%�HB
.���0�Ƕ��JP��F�_����~����]��k�%�X�s��6zR����3&����   �8�!"W���b^$�ĸ)�9H��Ek�}8^#�q�~�\����	��Nge��y��h¦~�e��[nl ����y��۶&�^�`�f|��AO% w��*"$@u�����d� �.���B$��<�J�/]��v�
��������3F`�jT�POp��]
]�n\-"]s������
��1B��pD��*u��i���Ի��7�����:k`dl�%���`�V8��}䔻������)X�ɦ)��~+�8&���,�J۔���� �fh@�ü�P��)�?�!(N`O&��\��λ?��%-
XĠ�&��*B�m,J���M��MCb�`�|IR����hiɨ֧	S��R
��C{��+���/�!�I�!��a&�!�� ȀPe��(so�����ԭ��|��ʻ)�21�q�k�rrŢ�a��L�
�ɶR&,��VM�{	�N�e��J�  :r�@"[�Ӡ��%s_���5���d��6X��b?"0f��we�=1�+md�
@�Ij"w!� F*]�������"�B����1�
�ڴ*8�2�!*�y翊Z�S��_�NzI&��w�&sQ|��&�З � ��ʛ>�H��-%Vl��D�Ċa��[ƭ�+� Ԃ����s�����r�i��jضImEg�&��`
����z�*'��y��עu���L;��|��*c���/�!MȄ)�ܗD�?��,�܏��l>ꊸ2a7�o����<JK�-No��Я�Vl����%�*Z�  `��Ⱥg
����S���p(|@�P�����4,��Y�,4`��.]�
CUaA    "��B��g
#w��{�Չ��S������(��3e3M֧z�����d��4ZcXHp2!{�<R��kl-ڃo��$TYj)|�� %J�����:���	Tu�
ػs
���ђyXWe ����g�«L�`��?�$
7�7���oh�X�,,X�@�p����ܝ����P�" u%��R��Ҝ�%����#"�F�+8&�L�I�z ���+W/��1Wd[�w���U�M<�*Y)���`�)]Jd"N��s�l�֬m��޺l�L���,v���� 7�y�SD¢P撁�֐�7�>(�"��G����	f�׊
K�`]?�E�@� Z�VP
K�Cw{���r2L .Kd�k��r^T`r�x�ۗ�҈�����'\����=�lrx�3v����~�<(bXln�4dw��%������d�� [�0�8���=#
%Si�$��Ԃ�������$�M�� '�Ū�0�B�Qʩ:3����3cŨCE�iW$��W[�H�O��S���.���Q$]UE�t7��	Q@�!Cb%d(GȎ�r�Y|��Z�Q �I��dQe��K�v�c�����&��V�������гi�n
ߝ8���¶o�U��~��UHEd(�h�hIو�f�r.i���cYO�cP~��s^x	�~�E�0��s5;REh�@&� 
�D   (�^��C��-8���s��a��D��*ć��U�kRq]�|7�HP+����9f���8�K����	�_���GgA�\BZ,���"�~��׹h�`�p�x�T��Ќ���dނ#)Z�	�7�{�1� ���g���������=㟊?BN�1q����_�ΈS1���� ��hB���=�E��JW��؟�xL@�R% �s@�z�@��u)4��r�X7����(�⧈^��F����ܓ�z�ܒ��4�3S�i)��鄔mv�����ܺJ�����goj�(p��� �Xǰ6�-p��K��~�
��e�İh�c2�˅4���h�j�P*>�����w���Q����Xh���y	�� ~ %.�������m��t��˪E�*���d�i�H�B��D�zItOO��D��I!p�ߝ����z�����/���M�I嶏�v��aH  
R6�_HI���o@�-8d��>>ݏN���d�^1X��3`=C�o<b4��c�=!A��<�0P�1���+~'�K�b$2*s�Sgb(X�[
{�(����R<�؆ h4�C*-�3AP�n�� �Ű�bx�b%0�wG)"�#��������E��
���93�D�ks��H���N�`�@�qbbm&|�1:geW��d�h���@ ��1���ހTV1s�^�t&��L4�463W/�9�1[f
��x;3����#`!!⇠\B�Ä��^��'_ �}�o_Z�_�!���#(� �ϋj�iz{h��P6[Ѯ��L�a��	�6�e�I]]m8n[��� �8)v�����b4A\����������������t���Y2%y��  N2@y���X�=�i�p�_HE�_ES���D��,W�	+rYE;O<�f�g��me���� ����*:�JR���EI�&a�{�P<ǐ @��\�
�9p��P4��.1)��?�� ��@ &A%_�����n���`Z��4��!w��f6�c'hV���,6R��K�q΄�^x���FDs�X4&��BP��Z����@H���P �	�r��m6�g�}�,$,�k���Kť|��#x8�@��Q�_�ٗԽ��J�鄄�9���k���r!���0v��~���S7Nk�U *P-�Y�,*��逢��x~������uP٣D+X#�k�`�D$Ia�(s�(�6��^���TT<)�D�c4��J�S�^%KS"�3��*���D� �"����X��M<f�
�e��n�_��4�
؅�ӧt\� F�O".rL"��2$$�Г(\CF$�l��Y�r|X�O���=}�ưDq�'/+˨�0X<��~�U�����&S���xe6%�o.�eӧ
9z)h�R��eG��0�1f���c�CLu �z�(.
������A	ۅ&$"�H�����:&4�L��J��� �5�6v�)Y�`ٓq��!8�\"*�m��q �Ё��@I�6�i��7�P��9��1�oX.B3Q 
Nlw+��\�!^��� PS��al
����2��8�Z��^�v�9�F�珉\>1j� :����H�'ȅr,4��H��_�Դ f�� ���N�6�NÏFM{,�>���D��Yi��R$�,=�,�e�pf��č+,1�OL���<�s��2�0�Dd�Eg��@�O�
���'�qBՁ�STګQ�q�i�щ'/b�L�  �L��
t�0���C$r����q0�����Q�[���\߃��ɏ�� �38M~�s����K����l�2��*��$*�X�G�'��EP �L�Fͅ���"t�zuWC���(�X�\�0�+,��WY$B+���i���)j��E�s���E��P�L -��������� h  
$-�9�H�L#����ቺ���i	B<�����-|;�4�Du���2�
|n�AK�d�m;�a��d��S�D�h3�s�����r]  
�L2g+��zO��}�6�@��C�7���D� "����; X#�=1#F
��]'�oAQ��0SM߈Sr��"Se�pB�9���-�z�OB��E���E�����W-z�TA�[�߹[�3#�z ��]�d��,� N
��#�ղ*|sc��p�۫�!¢�^�}�l$UP�0!�����V�B�,�a�v!k��������k&�� 	I�4�@p0cH��Q��+['�=l��� v���˯Oc��B��D�$*�qQ�S�+C�
��Q�����wW��  8�&zJv ��#M}`#��kV1���V���ȃE�}'�J�DLX�'e8p|<�ꬵdb�R��)ڎ�m>��0Ѧ���@Uf�[��
�IvREx�   TR�GyVr�dv,�MT�Q�����D� �&�KY�]i[=%N	�ee��AD���ř�eceW5����B	�_��)����j����-�^E�ߥ�"�5�W^�V3�U�'�U���+�{�[g���BHX���!$� GE�p�AR}�\"?s���a�5�A�Q/Y+�dK�����n��v9�(<
�u�o���SP�V�B��;��&H�
���䛜��r�8
����n�V�?a�V�d"p�2���c������W��,�guQdK$�����۩
h�bza���Y�.�#Z���GZ �10H 
 $c,7�X�YdK�
���+7DT�FB3ZQwb	�1�64��(�* �ۣ��I�� R��dux-�D즹�g��hN�T���V���(�X�c�2����D�=Vk*pb
��=�h	�i[4� 	g���� ��̍�lN�7�c�7�#E71A��x�N�3����������#��;�rr��l�Kq�����r�r�)�/���ʗ����_�������������E"qx�J��v�B�� "�
�N4�&  ��P�!�����k�6�(Q2&�
�8yPy�D���LB��Spz"&�-C���ڛ��UF�����Uf��"o~�� D��2��|4�e.�n�דs�9���x�B�'*���~�fyU�_�����.HQ � �@   P�E�k�.  H"[I2a�-p�D���c9 �C��N`Y�PC���Ѓ@yʥI�y�m��=�99Q6�)eF�.N�5(���N�Je��u2�1���d��\��g �+Z�Ǥ Y�u_���
x,�;� ��<˂��8!��U�ܒH�^T�O�亽�3:�_E$��c�s/�_*��*��>c���4�ܬ�N(Z�m���c*�)ns��ff?폈��:4�O���������>�\eu�� �D����PT�Ge � !bW(�������N�
%Ka��	�>�QU��r����*uY�k6�c�t��޴ީ�@�"F�=���+TkB˦+^��5#7äzI�j�ʴq��m6"^��/Me��>+
��֯CԲM����H���{�n�N�o����j`D@ cӱ������N�X�+��	���?Wѩ�Ge	~��ՙ���8s��N�<�7&��O�w��@��У���O�D��='�����d*mGX�=  8�[E� 
y`�����p������!s���B�����8�A��Tz& 5��i��P�V�@,�wS�&�Z��#���r�ϴ] P�Z۾@q��� &"���$���.�S4��4�z#��%�9�y��hD����7��"D�U'&�H��:H�	8Phl*°�dx��x��0x�ã�~>:24lo���*u��}J�-O8�  
��"S��(��7��*��~����d���x$���'�H����`Rf�:� �,�(j� �����cD  ��J^y�+�*�����8!��{��~�m�}�;������6�CC@8P
�V�ѣ�7��������#���d4�zGס�*�="��lV�
^�$QA
/��
ڸ\���sID�q�@ ��}��@��e[\q���"XkW&�t��l��/�q�������rt/�ޣs��A T���S��V��t�*�?0c��̿0�gP֔��<)�m�6e���2]ۚ����Ir	RG�`����0(� 0�P|a����  �
�ƍ� 4lB�GT�m9%DZm˩ֳ�W,A$���,�-���URttɍX�Nަ'��(
���,�����U�;Y������k��Mr��*P�"Z�E~��l�`	@�,#&����	��ҩw�K�L�p��ܱ����
�JF�(�ƎX�dP��&��K+��3|�p��TU=�_�u�$����	��i�R����d2 �4�Y� ?*�0bt
A']l$��:m�ǤH(۶���q�K��r"7_�E��N�Ց�-Y����_�����������$@)�Q�׃ٳc�y4��Y��(��h�y�9PAh]_�z:��*f���rI�ށ��n��l47�27��ÿ:8|t867��Q�b�*6��{���tD:u[5Va�T.�	��|U�$z���%�s����m�8�b�j��2
���d�PH���Dࠪ@�($
�08��9�~�q(Z@-a Mf��e�n��'�&y#�VɈS/`]PB�h�SR*��T�`��v0~8v<}���{��[ٍ�|��������Ne��*I�ZS= �~i%� l@����|�0J�J�=�����d; �FX�*�D��%#�L�iǤm �����XA�w��}��7��D��p�`�k�͘��e
KA��jwQ2�!�j�Kx�1�1����$��c���:��5mԻ��V4��SS�\|ĕ��"3ۢ��m�.9G\q'߽�Kȋ��@��5F�WE��  �'���T��1�6w��a��kM�dU�����gu��S���>��\��Z��~�U5)@���l\�2PL_h�l9���+�����X��_�DNXY%S��{1֖��	��MVbͫ����;��֨HRZE̫*�owc�%,e�A�$2���_ٺ�0R����
�>~]��Q��Z��P��6�wO�]�&�/H��;�2P$���dL �8ء�,P;B�0Id�$Go�0���x��:&@`��p��EJn�}Kz�L�����<FtHt>��i@L�*�d��.)��R%��[J��@D,���V<��&з�MN�v@�Y�Q��[�,(>r{
�M�Dyj���3 �/ӪG�@�ʝqJ7Z�Z� 1�(rT]�f�$�$� S�Nl0�&kIV���!n��!h��B��K���`�.d�Y�]�5��5I�3�s��ex��A
i�8�|$��5��TP�����s�jGVq���9~��3�!����r����$eC����I��PU燩k�kRh>�b�/"c%ߺ��}�LDʃ�DS���N\P	Ӿ��X�NІwӾ��8�
X����X��%���de 	%Zc	�6��k#r�g'�R�����P�c��A�3ҥFz�4�h2���#�ykvI� ��P]��3��MQ�M��  m\:_��a&�٪o��3��آ��X�]�B�c�;��$6�Er�Sp�� �`C�/�*��(֜u��kr�	�$bF���R���wP�(a���#)ʎjU�֚��|����6�:���(Hy->����d�G1�A?��"�w���������Qm
��BV�Ā�sjE�V
0 A�]^JXʣM�0�zܩ����ģb�yw�G\���������OCS�5��9�D!ѬC�)�Mև6;���lo�:\����iE�#]��c|
��md�`,  E3���dz��:�[	�0��0#�4�a,,��ވ/t�!�y�#
*��Tna�
���匙U
W����A�𔨜�:*4�Y�%�*k@�1#	hFE�Nd�.�)�XB�`JO�V����(�(Bv�ѓΙ����a5͂�C8�s4��h��� Щ!z�A�p��lV(|j��H�A�';��2(�)�	9TQ*������C�Y�+�TgN�ڂ*�`�=#o���@
��d�\��f�� JY�O������mє�#xZqr����?�m��٪������'�NH�K񀇏�ec���0��qǜ��������C�.���+��8�`�`�n�$@���P���j�b'm��YS�&z�4��!%���㚵�� ����d��$�a�P6�<%���]$M�Ȍ����� Z蒊��e�����9�E:��ɉ}(�������RR�nv�b��(����(7�>�t��~��W�U�����Qe�]M$"Z�T��T�B *%��
��%^��Y5�1��e��y �#�����/�<���S��C��>w�P�@  ��L ԫ,���:<O�p�:B����{��S_x�mE��B!	���G�CO�̩�Io��|6r��"�T�����|��{�V�����H( �Yȴ����c����d=�*��o��Ǣ�X�8�����H�ͪ���!.� � �N�C��礙
(��qOp� c*�2Ο�s�k[����B��J���d��.Xa�5�:akoa��a��i�܇����._PB��G`A���3�Ĥ�=by15�&0�؀��D�(���8��
�_w��F[{Z: V���mZgWt/�=(1[Q\�P��2������.���3Yկ�҉ສu) �� ` P\žN&�!�!*F���4o�pLꬴ=j����ҕ�UܡeS��|�w�Æ��G]ᰥiB�{u���͋T�x	�Z�k��sm�k:���$���ƕ�ි䆁j�f����Rs����T�R�H�4���`;��i��*T�`�4��7�d�@��s�0Vh0Wdk/�gtǭ�=^�ˎ�+b���#���o��,��dCfs�K6�z��c
�!�Y7o�ߑ%V�wve�@����dƀ�)Xa�-�:�M0+`�_�0���/0�`WV�f�%�5��u�C>���l�:�جw����8,#,�ZFoK��� 	�C����*8�Z\x�j`�e�f�?��p`�XyZK��W�0�B���&'�6
�vk�3 ���i�ڍ��\��J�B�N{��0*.���I��$�.<Jk5��$���U�~	�ɺ�b�`�C��c�r�18N&�4��/V|ƧlŲ���"U�jِ�0ǳ��ω�$�E�G*iK�ͷH   NW�*P�G�c4���j/F<phN�*���Y "�$�gH	�/">��DJ�!��$$)"D�d$�BO�4Dz�T5��6.&*���AU.T��5#�Cu&��dS��� �v=��^x���d� �(����8_<�/���al=		�p�	9F.��ŝ��mX�3>�E5������r�wQA�4\�V@_C�]"�� ��b������껠n�u�X�%�#���Ӓ}+����yC�Z:�����70Q��x�����z���+���S?Ig]�<R�	�\�hEKX�U ��
	�7=u�P� �.F ��[ �DB6�A�sh�.���O��T.,�%��A���m�� ��x� ���ԡ�r�ժƃ�z�$�PDz\���K!�0r�</�%�ETM�Rj�F����J�c�n�kV�W��V�`����pf&�J�ƃR���4��ı��=���b�{+:�� ���4����%%a���a2A�`����d�B X�HP1���0#G���N��O��t���rŬ�;���Aʄq$�=�se��G�o>���(����u3J�q�I�q{\.F����
Q_ϴ˧"����L��|�,�}2� 
|p�2  zNL��^y$ޅ瑡 ��@���$�H�>�ϑ��͎?�g++�h���܇,?�0�{�v~���1������f�$�
8 
9B��}f��K���T��OK���t��Q��k=D��W� "�v!�����+wX�`�q AH�
�T�b���b�n�"o�,E��<���.F!��K�:�([-� �q�R��?)�O���k �R����)�َ��l����Ӫ�C��tgq@ζ̡��{�T   �Z0����d��=T�o<D@�k
A��[L�o����4�
���goK/�:͊�S˴!�0�Z?W���k��2��ƻ��Mj�gw��?�+���������e��Y
w=ܵ
>ڟ����WT���������Q10�C��tp�$O3�o����.�tˀ4 6���UGU��	z�/��]$�C�SJ-�H���%s	]��D&
�j6z�hE�
��C��E�B�g�<�s$����Gtr��$P��̉Iw��M�Y@�BH�O�iI�0L�x�{�<��vd1��]I���� �L���@3=gT���E����zRi�^*"Kܳ�C 7�����  X)8������8��������Z
�%(���lr�#\� �&�����D�#sLU�J-�vǺ�e�NK�3]�(QAX�l����A�"�?���A��k0�_��D���y�$s?FMȪ���y6��\���:N�@��@ I�v'�-�,y{U�K ��R
'���v��V���$@9׹L�y�T�#�|�$��x�\�1wg]�+u3��g;�%zQ�BS36��A�<���Q/j^Aۿ�{T�_dg!>D`@ �+�}\ k�=��;ϥ<�rk8,�ڎv����})�A	k�ו}�������UZ��a��<}m:�·/d����t�]���1����[�(,�69��jS���]я���G@�@�   X(�_V�Sh��[!�'��$�t��Uή��Ls�����x3�!x�E�X��RH�� �N��ظ���DʂcJ��,;�nkz�a�^�qW������1���E��_�~TRX~?��Q��yB�~?�ǂ��>)�>�Ls�>�n���4��T. ! ,Yg!J����!�H��'��?1������h|웫��a��ӯ��/��kC���3�_�����ƅ�J�%���yo�D���[�c1�{��v���wA���ƫ�@  ~E�D(e�%��!�q�ͫ���j�I��[���=I2|Jn=���t)���4�����w^'�cO�h\�ԩhJ��ʖ��%ˍ�dT.]��'	#%yB�ee�rś�٤[#���� 	ġ�ay��s8.� 9l+����<���x�q1V�����i�j�����O�FH�\H����D��#z=T�O:�yi��a�n	N����Ψꕆ5 ^�3���'��s��+��TY���t�t茗���$Yp��p�\-�4P
~Q!s2 yy�䓹-D�
��,�&�"E"�!�Q�@zB��3��F��O�|��Z���������^R�x�{?�d��D����<�zx�����t���s2���FK}W7��Y� 	��d��*����J_���~lq�<�+���k|aO:�W{S��Xn��~o��������Ţ�O���H�Q��R��(%��ʁD�R����p`�=+)�* ��5	��������z�D 1MԴ�j���Q����KG���sآO�L��^�yh6ZZ?;��W�W�2�����DW3�=S�OR�uJj�a�^�OR�=K�ئj�������h���F�g�G� �!�"�8��N�"lx��sΏ"�t�9�w.�������TI��\� 
 i@1
�Z����?R�_�Ȼr���T��@�R��~n�:���W�sS�����$���=(PC�[�()+-�l\6"��i爥��g1��B����F�m�4�h@`,I J
!�y
�/���F�_'&f�ӝ���%Q�,j�1T�n��mn��� CP�ך���|�y���1��iʔ.X<:4�,\����Q��l7,[��R�a?��<��PB�h!��    HJ��' 	��I��s8�{B2|��R�lc�"��u�Ue��O�a�5U_���D=5�i�+`a*J�=*Z
��[L1G�\!���������;�s��`Xt���w9Ad��[�x��PvŒ�>��12L�JE � B�(hI�<o�f�hsJ
��#�A���s�X�5y�c$'��-��?R��J��r2�����V[���Q���]�枧��?�ttO�ł5�P�,G� B�Dy��{�����*��h.l�O���~(
���aC(W�P�,<|�
K��/*<�o�Uo�z��BCˌ�6� �|�*�^ꢒAS 
R	��7ǚ��>񰩗��6���M��� c�퍥1@��m^r�������p���9�Q��Aa1�Z~,I�����
z��x NA��5�"�����)Z��Yf���D
��<�Q�dXE�o='f	U_G�V�V����hA��>���1���ՀK7�S���G�o�Nuv����N��f�	�p������`�63�KFވ��.d@[o
"z#��KQ$)N�-�L�&m���5&�eF���f�Oy�0l^��*��[�Ǐ��
n(�h$r�Co�h���	�t++2@ #)�z���5��bQj�a(w:���N2���x�yק�i]��Y��=E��P�2��#�o� Y���Ȇ��Ŝ��r��ʨ���( E������/,J"���[q���r�cy�r���:i���df21�\l���+�
?�C��oM4&iw��\�~*
���WxQh��r�|B��JY�y�\���e$��+60>���D �=X��+@Z�==bl
�5mG�K�U*�4ŕy�Uf'+ C&�O�-FdA��T��Ƒ���F"��L��	��B���-��l�
�}`�SB�z�i�� �V2���\h��EF�-�eV���D\;�+&5�Q�ڿ&{��R���v��!?��,�eF��!Ƚ?f3���!�zB/=k`��ֵ�/�k��)Ӗ*� �y�/��6�>\I���O���Ѝ�ޚsܨ���]��h@��Q�`h+N���P�۷������_�,�'�a w�j򎅥�@	=��H�d'���ȤT� Z�fZk�c���|�h-�9�N���O�_��Z�!Hr?}�f'�B����O�S��Z��xy�*��M��N~�I��a�вr�
|����D �=Y��)�WJ�]$"�
�}e��k,2�p ��f?c�RVTw��qT��G�u��;ד�Q�ѭ�1���tTw;�S��a���0 ��8�
)�Y�{�3�� W
��` Ѕ�k�Ξ��.>��N���'���@�;2'����D1�e+_�G?��)_�9Կ��y7��F9JS��te�j�r����!��į�Q8+#��ΌF�R��fQ��Z�����>��,s��_�������W�8�W� � XhJ�PT���
}E���2F� �$%�h"h�z>�3�(x5v�\X�Lt"a��`�
���1z
�Q�@�{��V����9^6�A���P�d�S���]D�����tS��kkW�sI��)�"�&�Ο����D	 �/�=  O��UĠ i1s8k���� #���#a�Xl�"�Q3��9��<oA �X�i�1��j�,:�o3��oo��������������0�x�	(�mp�����:�Q�'5���(x�� ؎�D ������q#�Qζa�;�y����7�D}�(�8�W���5~�z����LPH8P�	P��J�'w�l���,�<.���2x����jc�oI��c�H�Echwf+9�,�eC9};��;DL����O������b=�k�n� EB4��@d�O�8n
Z�hk�yw����3�S4���DM�4�oo��i!�Q6�	
C�$�	�<y����T�<� #�D���ո�@  �S� �(���4����d	 .��<�9�kk� ��g'�M��
�t���o��J�<�vB�2tt�q�s#]8с�(d�u*�î�'1DJ�q$a�=
"��s����.v���.Dx�7��O�w���~��$���u� ��W��[S�vd���p4�ֲԃ8r�V܊�T(
,�F��ܳ�s�E�2� H���BH� ���ճ �F��]�2�ԏ�q���JZ�M�Y��������M��`q����x.p^
x�0@౿��q�H�� ;�P�E��)���ѝ�:�[�`$�>E7�,�n�Җ	�G�GCˡ61fo������1�ķ{f	ç�Aa�� �&5��4$&x�b9з˄=�6��(��Ym�P����U��G	�|#������d�SAX��+�1�ۭ$d�e���@�)��p�������i�z4!��Ǝ�
�G������k���1�F5�GL,����f�*0� W!$��:��e�Y2YK���p���	H�c?������.���m ؈� ;üM�䇧hCM�R^�%�ڄ��@]S��dD�Y��\XL��I��#HZ<6V��Gg;�H����xp83�q�L�*j�V�ܤq'��I��͊�_�E��� $!� :^��v��,�/����lTx%�ț��w����������}�-}�eh% �`( $��o(��Ƞ4��ƖBx�P��ӑ��$>�����iM��KE@��_�z,�1Y�<:4:G
S�gc)X�3u��HNVJ�d�̪��F���d, 9W���+�5��l$"P�i��V@ۋ����s=���gk�ӓ8�n� T+:@I@֬���8f��T��r[�g�ԀLD��%@F�O�~.D֑*:�+���ҁ2�ؤ  *91TPt
�J{S^q#X�7�&�WIS��W�i�#�#2@�O�l��Ί��OzL�+�����עA�o�X"MIi��'֚�25#n�a��O��>6�j;��;_�a|�_��@���!��b��u�Σ��1�D� @b �*��@̸-ƈ�y�7�;YUR00|���ZŁQ�N���.��e�Ih9<|yQ��.t6��C���b*����!&bf@ �`d�9�� !��+�~D��V1^0	�{�>4q�ر�P]��  h �Ye��+���DB�f&�A�)�Mb�[1%	h�g'�I�m�@'j�r-$Ǭ�
��|��V
� 5���b�`�����8��|����ƛ7n����
�o�G%Q������A�+k���rE2��:�/-tFz�B����%�"E0F�S$�Q�_�X�5�f��z�[�"SS����ŕ�A�0�����Q�B{�V�* \, 'YyP���{��ҫOOw�,}��T)�!)�K�CΩ;j�����K��̎A ^�I�ǇPv�>~O�=�C�FYK�d4��Y��%e�|�M� 8V8D��0NL��u��\곁`�yn�X��+uO�Ёz���IUO9P��E��㱐%�zG�^�M��9�	�WW�/���dZ  7X���6cl,"R�m�����m���`���1
e *�.KwH���)��ȍ�TX���՜�������j�]m{�	�C�ƈ��� !	P� "�����@5ݾEY�>79���r��1�oa�5�Dh8! գ�ע�2|��/�IU� Pg
�B���?����B�/'㪙j�~�+AjDZ���5��~��N��^B):,O��#� a0MMs�K8
J�
������R�2���"���+91(`Quv$8�bG�QW���E�⸡����&�^��S��hG $@ �^I�.K�!��TG�む����Y|G�����A��y��%%�?Kٜ���K!�N�ב�n�~�|�`�����do��.����8ዿ=" �i��m��m$������*0����ֆ66���   �A�	G�R�2�(
��yc��I�~�Zv D��P�3�����A
4��}߭�5�f�E*G������L���bq��;���K�+V�V��fɩK��
�����& iB���g��_���Ӗ�5��Pv�Ѝ�<td��J�˔;�Ɲ�M'�A �P�(����u&ٞ���2���Fއ������Բ���Hx�8� R B�4�1>2���v���3��j�tX��O^|�U	��T�g:iZ�u:�c�PK4(���$���ZC��
\��`C�,N8�Ib��-3�_��Ǆ�ן7(
�o�9����
���D��W&]i��K��l0#�	d�e��qA6����)������]_�47�.�;�/�e����?.%�E �D@  &�;?�W��Xr���xB�l
4��#�9~ib`��]��5�lwl��#��$���@f"����.;h,HT���>T�C��/{E�
�5Ek�-G���d +Ο�E޿
�!�>�����G���b����+*
�O��6ƠH_�  �N �k��q�M�h��C�MoX�iby��v
^�H�92��j�|���=yB�\j#.�t3I�f���i)>Da{jx�3G��5K��	�ơ� #�4m��Ǘ�$�2�p.�7F��d.����ڏ�_�����3��EH
K%È!�
�Q��%:B�5J���d��/���*�5c�]1��a��� ڋ��V�$P��%i= �$lÙ���5PL�pl������
}�S��$�|�4Rų�T���e�6���y��ګ
c�Xc]��S��|��D X���&����7{L�����Xi'����V5~a�����[%L�¢0�e�F��  
�d$�a�/��:�����l�F۶E���Y��(�i�k�❂��g��]��*�x�EG+���0�]_�3�L�$�d@�%��0�:נ�j   eF�#�@�KD�=�p�v�H���ſX��/��#�A�h�P�z�".�6�-� I�  �9`�h��y�>`���!e��x��߆��#�
�J�m�d�g4��"B���d��-���*b:��<<���aG�V�⇭4�8_��b35k��H-2�e�R�ᅣ<� ��A����FkČb � 0,`���	y�*��L3��;Bk����˧��}���*�(�x���C��K�X
�X !(� D���&CTg
�TS�V�gK���X��~��t�!��SP���R�1NXV~b{� �u6�a�A�(C�d��bw��X]?N�/����v�.|�"SY�z�$i T
Ų�'�×�s�����mU>*-��},ψ�����k
${�D*l�5���-�[�x��9��Т���h�yBD��(�L`MY��FPr��"��E;����>s����]>sЖX璮�#;����Vm堂QN�>������dʀ-���P7��0�XU+c��� ���t�0G ( DBF��y�p`�Z&����]+��B�L�.$r1�Mm��:3���n{��D H #��ؘ�Ź[�f�����\5����,��"U�h�I�[� ��%D��\IG��)&aYkŃ�Z�ؙW��ԋTa�6q
RF��_��y�nY5`�w�k%QD��C�r�`n�$t�����Z�g��!
 ^3sv�_����˵����2bdϙ��V�m�Z��F�(�^��K���!?m+�ruX2$4�=Ȁ�(i��b��C��
��v��#�f�c$����;o�:��]RC�;��c�
���T?��CQ{�:��t?�堀K���J�U�u����d� �E�i�`8�M$bD1h�q�����`�8�J��� �,���>'V�<����_Ȼ"R�(�?����]���,�5��mQg�ʁ�@   3�`i;	Q{7�� @tPF���;ý
I$
�rA���I z0U萤�2�����F����tB'���h�$�$����D���hJ�Y!L���dlZ
5u���!g��І�  �  L'A:��E�����n/J{?umT���F�Q46.մ �J
��[Eo,�Wy��� 
�M�	�+$�  �|lK�\�gؔ�+łAy3c5v3���_[, Ӫ����x�%dЬ��������\0�5���6%��8
��/������/����}��5�@  �� 5���dހG^y��4�,�$%A��eG�)�
�-��@
J!��J���s��'	�ğ�����@ �0;
-��$�9^`��J� 
�w0��Z��ը�����0.��@[ 24ޒI��Hѝ@�Oy� ���$.:Kѣs����F)�a�߮����5M_}b����Ğy�>Dz�I?A��W�	`�!"  �_�(��dK�p�5�*�b�����AfB�:����4�Ǩi��P�kb�'4�B]҈U5
0l�_�X    "�*	�@<a��
���9���!0��: s��}�	�D�4I��� D#IH�Ȑ8�e(�J�Sp��q��	�g���8��� �f��^�#}�0��B�H�����r	H�`�E�I����d�9*[kBR9�۝0#
��g�$m��<��H��M�/�t�RE_����	�+X��2��I�<.ųG�] ָ��H�*��<��@ :H22'B�+�R��q<�����QF_a\�"t�A��i<㑤t��Ȑ��+��!>J�Ȏ�?�r"#�Mt��ը0x^4Yס�,���@�E��F�OA�;t��4�^��5�n_�>  ��X�i�Ac�&�������c`�|�x0@`�0cS��A=�9^��E@��vO�^r&�g��8   ����"��:��i���}#��}�I6�wg�j���u�/��<z�T=�Ý�d�UH�u\�w��Js�i}3f�67��hs�`YBwp�hM�)��g!.���^uU�ٕ=���DUJ������d�^0X�	3`B�L0#I�L�aL$O�����)���^�!͑�K���^{קَݥd҅v�#�l�����npPQ��ౠ�ֵ�׹�Q���
B�C��� /�N�����$����p�zyӄNnt�䋫cW�W.�ly;ıꃓf���B^El��F�����Ң�aH��yY�S���M��v��{.������=c�F"�WPT �6u�h�A]r���Ee���
����Q|j��Xf�/T">Y�^*
���� H(   �9���'��ֈ4L
�B�"�bv�+k��fR_i��X2G�f�-�ݶ�Em$a8���M�;��*e"��i)6��^R�[�x�����"muGպ%b���	�|=(BA���d��LW;+�;���<�L
0�cL$�H�����60�����������p��
��u+p�S��Ʒ�HP������h!��Qj�>�/��(� rȏL���� �DB?��m�u�~#��$�g��3I\�g�������(���5�-'�QJ�T)��Z�t�
*�^"]"%g}޿(�L��@�2�5쮵����t�"F}ǥ�@PTC��z�;ƅ�^jz� "9�
 \�A����BR����}��=����+|38lY�b�ɣ	�f����0��Μ���g�}� ��  ��-'F��==Jb|+��Bxr�e.c�:��o�+���*�tM�V��q�b��(r�
>BK��J�0�$�Z�ːp�U=nF8��T���d��.WkJ�=�0eV(�V̽/���<�	0M���x������������o�Wh���s�o�*"�D @0r��z�D��ӌ��(`��?h�{������*Y��t�R��_��& T	��יj��[��U��bK!C$ȕk4��Y4���_��H�8~�I���"�+����N�*��n��y_y��ڪo���j�������G�QPT*qb!3�@`������ �I �#.J&�o�����-0�y�-o�˲�%���R����2��2�v&
 
2�D����7��f��zW>��?�,�'E�Z��k
��{�~���f����d�8b@��w��C��\�,��>��ra��r���2(W^�!*�O����dۂ�/�SA�-�+�$bI�95\l=���(�H�E/���{�h��A�4 	7��3�1�e�w%H�qy��P��ޙ縂�z6�+~LW޳�+z��_���@  ���$�*�i���AC�X�����C��P���,o�؜\H�<Y"R��]Z<Ӻt�,�c@c����Ǜ�y~�S�K���� 7Gm�0?����8f2;W��Q���9��*yᕑ@ �G�M\�����X����(AR�-�|��o��0=�(\�*�u �0 N\L�跗�`e ��9�H��p�ܛ٪b|�����(u�}]m���u�@h><����*>�a98��a?ʚ��]��`?��h  <�#���@��*�)DB$t����dހ#vMW;�7��*0f:�SX�<O��윑���E�����x!̒�l �az�U������J�ϖ��yj\�##��w������a�>8������8,��D�i�|Pf���9��D�� I��{�Sy8�3�i�Ï������`�(,
�	�F}ED@�8�֠ c�  �-J�E) H�R�.��*kl��ʫ{�l�4qGM�hf�~8T���CG*���!�����g��p*��0";�>&7�mj � S@A%���i�ri6']�m�P��#Qy�K�d4?����[|ꘫ�u����;���1
b��}�(�gn��{
hz���¨6��e1�m[I��H\x��J(   �o	X���D��&X��*PX	��=%N	�ee�$l�l��4����FH�fPֲe�2�@���>��q��.r���MTy��QO��E�7YQ]u=s H2����\=��U�U	��nrO��O�V�T���ޣ���KH&��p"^B�#��@�@<���
����+�邓���^�w���ʼLzt�܈tP� �q�"x$�cʸ���U}A����"�[,R������G	x3rvT�'�
��#e�Sz��8�)}%P"�X��)�֥����>�v+f������d�Xq@�z�B�v2I�Xb=(
� �  &D�Y-&P�#H�H�������g����>!��=/�na�?�P�᩾��� �z��(I��B�Y�{���D�1L��*�ij��=b�8ee��'o�,��hs�}Y������Vw��G8���7℀�E   �\����`b}�,g{���,��sD�$��B����Q�����
���K����)@��N��%��R��K<��S���~�`�Y�T(�ᯉ�JF�$����'Y BD�걈K��_�Wu� �Y�v�H)H���79R����b0�UO�>�)�TW�:5#��&עT5��� ���
+��
s!�
LT�Nz��b�Sh���U�	"�u$�
G�)����pHB�T�AQ�AIٙĬ�R�d��Ҧ��etRaP����"���'#~Γ�CN;�y$�6ձ����QF��d�r  )I�   ��L|c�-�^�T���DҀ#MVS+�c���='jl�i�� ������ �Ț�.��
�HF,;���q|���U1�+���i*t��KKo$�'	U��b	�i*�P�d%S|&�).���ˤB7]��8
��ƪ�a�jX�;��r�ݘ�b�I�K'n�a�R7u��S��1����j�rԦ�RZ[���E/֕o���;��=���w
�ߤ����������������='ݿ��|  Ȃ@,@ ��A2�h�z�(���v��HQ'�S�`G9&��nBLb�����=@�!°�7`�v=;���GDu��C4��U��8%v�..6���n�6̯���k8ՈD6mڼ������ȋn�]hZY�
Շ�;�m���?�����֤@o}�ͳN���D��v]��k  �kz��< R�eq���d,m�0������������޵����w�/&���)"H�Q(]O��D�E�P���F��qTJ�M��o
�ih����\�A��Q�;ȥ
nD�-	�1X���yA4�������X�[Gq�ᆆ�yciu�ۡ��ή�Y1~���*ѭ�y�7���������/kُ��SJ ƿ��#����@z�H�EH����  �~(���u��rá%�Y�'�8��	i	�.;�s-),��%1{+��U����6����~y�6���b�$n���S���)WX��K׊���?ju=�s�ⶕu�����oZO�����+j_W��o'��rf����L̾�)l�Jd �ab�J�i:�S�����d	�cSZO=  =���
�gcL$��Ӂ�tĀx���S밌pD"���8��	$a�5;�*y��?f�Z)�Z.�+�!���mg�9�������2;���h�]y箢=�7��껏n~�ƗH�����  [h��4N�h�]/�&|�1
�"��(��ew��1���S��Qv.$
(��+Z@	   2`��ά%�&[��Y���?P�BU�G����"!V��J�]#w��������ܚi&��;�)��vR(b�DguA��b�?��Ϻ-�_���a'��~�� ��Tf}�� &� 8�<�x%���y͔	�8#B�@/��.�0�O���(,4�T�J�?�IT  ����	<W���q�m+�%
�z��N���djWXI��>�K�<#J��\1*��0���ժ�ee���4\��#�n�U�R�m�*�?�S��U4���,��D74�[Q�]��>����>�ߑ��s.d��Ȕ1[x��Z�~���$U��N5���pB���/���S��@��;��]�&��,%��֊7�B�������&� Җ�9���[�&<w͓Q�D;"%je�˅�Jh��܅4/s�&� U$"�����t��P(�������pp9�i#s�&�]4�
pa�	nX�R�!wE�;��e[d�L���%����R���F:��Wu���齒�g_�7=�?��Gz"
HPk���  �S��N�'��2 ��,F1,:��fVE��Mu�G6B�h6��c�ڝ�r������dy8WA�J�5#K�0�!
@�_�O��10��S�r94�;�!O�1w �?�$_�����p���i=$	�D����'@�`��&}�Oҿ�ɲ3�)� Ӗ|}��l��	��D`D�=��t�
���`8�q���K2DĂ@�@T d�	ׄ跉�����J���iA����7�"���Ц%� @���Q2^y�\&��ПB���C��a���`�yȥ�rM@�':^�9�N�����(q��'����/��
�qw)�&@૿����-���oz�- ���� !1Y%/@��,�����@���NP�^v���r*�`��E�\��%r��n7ܗ|g^|����cm2 ��rby$:�����d&��*YA�1�4<$C��3a�� ����<'��4*��CŌ�ɻ�\�#v)2�E\�2߷
GPL�I@���,�bχק���v�K&������  2�:CnRaԉ��0�ʪ�|�j�R��*�,�g���֭W�{?�Y����&ƃl�ir��Iq�q�~S�,��P�eC�=��T��U3C���=�U�a�� �~xO��	��z��N�&���\�� O^��g�_KW���B� �mD���ص$eIVD�*9���A�I����
������P� P��vP�n�
�|�z)1�zѼ���838_�s
%C��\��P����d<�\��A�@ Xl�;�g?� ��z�Z�.�����d= �2\��08�;L,F�,�gg�Q�օn8������c�}�ކ}q�)J�(g�G�*:��J	�7H �%�����3I`�=����s�Rnp��-<D�� �! dlft�P�gAzG2�cުC�j2?�bn{��k}A���R���n�A	̍� `͇�?ͨ�͌��R'�Lp2�R�4�����X��Bˡg��
z4��7�I��, �Y]#b�հ�q�g+�q��̬p�;K5P8�CwUM�H5�z�3��$f�+�9Q��:�<��J�j��GJ�QS���JU�8O��}i�7���G�&�����D�} �y?�r��Կ���#j�����?�ՙ��F�|X�5���h5�hcC�j�~����KU��Iȅ��~�%R����dW��F\a��@�;�$bK�o��G��x��p����di�µ��! �ޔB!�&�CTɫJ�0���,fB��(d��բ|J�k�j/��M�%B�F�B$�Y�YD�A�Es�t��H
�>>'S����>�I���'���&W���2\�*y�`Ƭ��Ð�|�GH���꘲)���\���Wp�5
���B%�kd���q��|80ƃ���F�S$^��խ��DJa��(��` PT		����'dN@�ec9���1��J��F�Gk��Ic
B��j�ُ�r6�0�,82�Wש{ͼV.>��C0�#ɉb(ʁ��!d-�Γ���� �?�t���0f�Y�R���K�rYr�&�@�hnE-�Q�Y���Dk�2X/؁��G�KX$�l��`�$k� ���9���j�x��J�b��|�)�q�w���"����48� *�>�zX��o���?g~�@"Z�λ�������ꭾ�S|_�
t�c 4   %K��m@����@�j�^cg�I4/lo���!v��
��?���\1�����"ŗH���Hk�P@���J�-aCGvʴTEs�eD;��ȀE&CRe�
�=���-ޒ����_��2?�����U E��ߚ��=t3#P	0���57
I�s b/����dתh�-�1�\���6�R��㤆�(@R{�(��s��Wo�����P�*�U��MpH�֥.��RG�C�(G�EmD����.,�DP=߈�re�.���d� �+Z{	`:�L_<)9���k�$̀镮|0�O�u��E]��	����3�������6\����fQ�  
�U��Ɓ��s�!U(z��;G�k��7�e��*M��z�ߋ@oiI���x���yG�_���ܹ'��H :�n@'���C�c�6�2@  "�MSDH��S
F �h?���@F֛-tP�Gj�]L?�
ڰXB��Z����xC` N��v+!0�5R2���������^�Z<<��o��3*�aMj��Ƌ�;<�P q�\� ^=��3�#���U���ӧ6E���L � 0���a���o
��C�����b�^ڝh,Y[F���fz�H�*3W�^���^������DU  �����d��"�=Zi�p;�k$�>�{g��K�癬p����Ka�,�)�s��DoʫO�
b<c֭�m6���y����&���s�2�+lԔ ��J��Q�pS�A�!�8,���"��?�9�@���	u���CZ��JxCJ�b�������q*��\\Wҿ�(T̳DtO��錈E$  S���U4���8���I~k���,0�C�?g�=ڏ6��X�<���}8���`{�=t1�P���k>ZP���\�a 4˘����r��
���u�ϞP �}���������Ԑ�)��)0/��8�ܦ�H�9�kY��8�ט�,L�����=k�� ܆�z���?���b�M��{�� h�������|ׂ6�o*]YT2����d� �+X���;#K=�6��_�<���
-0􈠲1�� s-4+����VZ��X�Wۤ>�`�);�cJ�D0 @��F%{P
��,;��3�R�}z�/�������@#�tD;����r`)ث � C)���k��j�+��TFh؆
�B8����5�'4$:>�"vD��l()6(G�m�����(v0�c��p8�w�{�1����Ҧh�j�$� P��p�&d��=�#OW���9��\[�88��@/C?��*&h   J�z#ɳp˜�eq�h�vfy�R$$�$hYΛ��0�V���k5
^�B�@O�r��۪
o`��O
;š&�5���#���؀Rxv��D+O/+	Ո�FSY����d� �<Zi��9�{0�RT�m��S Ї�8g��,3*���50�ڴ���٥V�e&֙�he+!�����Nw
�����G`������(��%;�Q���q��XF�h�����$�x	J�f;�S���@�:�t���*�8s��P����A��Q��((A�F��헲P i<v���Y�f9E�ER8q��F)|,��N<�&L�(�x
4P
�<���)��9H��k^f�>y��#��A��*����?��d� �: �!��4�œr�xmő�Xl�s�1����"�L��^�(d{T�ժ�N?��87א������( ��Eh$"F�T>d�HX:���� t7�3����
�f�<m�������D��"�Q�`U'��=~
��a��EAH��U�!8�5�f\��fޠ��nl�13���k�Z�[
�&�����9����-��
BǙ�:�����5[������Rv����J��p�#���@*z��AWވ��P%��{�v�������U{����7�J\���N�ߐ�o�X M>T,"{*swJ�6�ޞ�5�Y��8��x)��:
�ܠP��'�<���lk|�g���]QxC�C�`��4�7 5���%M���?h~0��B J9e�~yߊ�Ľq��$i�I�x��ڹl'�uǱ�7J�X�W�1��)Tj��y�@��
�u����d�S���9IE*
��F5������y�j�߳����'UbEydg�����D��=W�)�cJ��ig|
��o��O�l�l��P� � @aqpr��`5t���mD���#)ت�u{$����EB��f�u&����`�/��:=�謍���l��|pv������������]տ�ѿ�@�ٰ �@ n>���PK9Q��j�
�Q�E
<��$3:m�ߣ�dy�ã�� �d(��8��DZcT��2����b�U�o��B#�� 
�w�*ﲀI$@D���}[�Q��
P�XNz����^��	09]GD*� �2���f�P,\:4:Ȅ�"F����RJ�� �S��Q�\h�V  A�ĥk�EFSI'��?9u�c-"MǦ�t3%凱�t��(�����9|?.P�)��j���D� #!M��S�a���e�^Y1W,���t�,5��[2�0>�����R�Q)�f9ż��I�]ɲ����'!�wz੏^�@$�  (��auےv@�:���D��'�v�23���UD��������w�l|C�ZxYSqR���jk~��-1����e�dWI���
L�Ă ߭����� �@���Y#I[�VJe�^r�#�Tk�{�_�O�;t�j���I��<k���W�����Dbv�%&=V�k�s����\����i���(���B\G}��w�4i�� �Ջ0�����2�Yw�((�*QeC����7~a9q�E�s��g*������e�O��`]\��eA`�5|���gO�eq���r�Q��س
5\,`�����D� 34NU�*pbf��a�H
W,�K��'+a���Q P ��F�	t���V���lϳ:�-k|P�j*�,�h��88(螚h�#r]4 ���D��b`��O���a0D[�(W*S�(ƫ�:M^T.EoVdH��,&��P wo�Б"L�Yg������]4�E˻�WO#CM��p�;�%�Nǯ����o�9�c?qp�pnq�To��_���,XS�������{Q���_��q��`@��&�-/��S�-J�ݧXK���JUQ��s�@��Ub>S`.i����;�ݫ]�n��ﾃ6�5��S�s��?�
@�/��
��G�9t��:��[��4�,f����h P( ��5�� �61��U���U����D�\=��);�j
��a�^
�7R�<���++d�)��&5'&�L�1��%  ��v{T�#�1a�;�/��֘�#�~�A���t��#?�UQ�������8��Ӛ�����iT ��[2��>��M�F�zj
�Pى�e5��.� 3���z�����q�r��O �߮�)k���������۲Z�".��K�MV�	 �! ,���2f�T�אg��`�T���!�`�,�������������꫍NniE"��gK�t�Bg���[��b�v�Y�}-�aOp
/>��C��,� �I�`=BD耧Kc�,�����L(����~�u�H��~Et��7��Jn���������D��L��*�cgz�='n�]��M����������3��ڑMӠ�� GI��!�s�}� 
 遌���(3�䃕��bQ����t���Cl���+���� :�"��F�ƣ����b�_�G5N<���H��E����,Do���ݏ�D�4bD��<¢1;z�sE���Xܮ�=l�h_�f�W���ez��⧟D��Ӂ)���9Ԫ��d8Bj��g�����j|z͠�   %	Y��
�tS�G#.�J�u_KL�ךR����]]�GwV�T�&���\J9];�:�����љ/���1�$�S�U�t�j=?���vp $� u#�	$�ĕLj5��@�ث#s����w 8}J���Dn��;�i��Z�=eh�_G��A\�l0�	�E�����
齭FN�XP{Q�s象��ۡ���Q���P�7�k���k��	� W}T��v @<��8�1H.%ɔr?4�F)��p�6��q����B-S��ӔGt�a���u��+��)�����O����9��/��d
��@�ujB�*����t����t��U�b��(2�근/*�B�#6��g���Q�Y�8M����܂�7����s��cHJ�c����	>8 ��)��Ո��](''؍�|�clE%l��m���^6�d+l,%�O�LH���v�G�}���5J������������P��u��j"�}R���%�z��A�� ;���Vd�x�V�	�����Dg �;Y�+p^ek<�x
�a�	p���ĕ���׍Z<�[�������y,�"ք|���x2��o�2!w� �� P�,U��>�A��| /��.�\��j�y�+�u#����F�ﺨ\�E�$�P]��mG4������Є}����"@%�Aq7�����d�qaH�Bf��e]�"3��{},6Q��HQI��/��T���S*�R����r4�h[���#����C^4*�fn̉C��ʺf	�����*��O��F�;�
� �]�J'%Ici s��qac���\&�~,<�J�m���yjt߷�Qp�6��Ԭna��8?�o�P@Y�n�!���|kĀ�p8���a$�� ))ʞ*�1���J=����D`��3�i�+�Q�[]1b�@�c��M�_,t��FFJ����+Wĝ�����+?*���qU�I��W�?�A�x\;� �Pu��>9�	��I��`  �ԓ2Ld$�/�P��K�%q*ieh�,��5v&?���1%	���e��Z`��4�^ z����i�Ph*�_yp\��I�]�$�? Z`L   ��@���V��ºr3e?�[��Y��Փ'џU7ʔ
M�>��K�b��7k���@4Ɏ,��-����y0���o�E���  )�5y4N�s��.K�{��fZ�\�i�9��'t6�����$Xܘy��b�Q�}]��&��UoԐ��p�X��z����/@�L��%��B����D_ �+W�4�W�{
=g|
�['���|#,tŊ�zx=O,Χ���ojUc0�zH�/���z��t����sc�1�[/�

_�j�}��U�_�;
m� b�@�]O��i�D�c/����¹��N۸*�<�h��t@�-Jgf�;��j���P�'��a�<���_�v�0�m,�P4�8@��48R4#5D�BC�;'HX��lbB	��R"�5Q�T�S�S��T�� ���"���z
R�(����\���ǜ���|�H�mO_�M��#y����9��=����Qr����B��R���� �W}��1"3�wə�3����o��+D��A�����"�	�K��0  �,�����	4ٞ�Bv-�B����d^�bNZ��Ar7�$"J�u^Ǳ1	m*,��
y�s���mP�l�C��s4�m���\CPe��)�3l�tl��rx�L�as�z�L�BX�`��2�X���/%�'���h��j�U"�m�����*Ē:���H���H7�FD@�\���L��l��m't�m�3�$�;;pݴ<��c�L���[�nԧuh��Np�ݍ�dT`�nc12�8J��Ĺ�#Cu	�_ 1�*(@��t	s1��30� v+#����}�{�e @�c�c�bn�h�Vrt�V%��'��Q����\���� �%��=J�
TՒ�r3��X3��!�<XHh����زt
�����(p����y�ZHf���D�yx"XH�^����d9��.���0A�k�=" �k��i��ml�� g4��\�n]��cXt� ��ڎ$��<�*�[K���}%B*���$b%* z�%�$�p�i	�G�(aėYI�[�+3��=�K�y?�V�>a�HJe����2���
�rfiR�v�J��������_�V&�*L���B� ��: ��0<`x��|�Ó�JC�f�����<z�hpT��m��#���H�;"ԓ�!F�rp ]��t_V�:�p
B"ay	��ں�&Z�Q�5�֊9�+DO���?�� ������?����[�g�>�Bw��.F�M�	�O*~�}��w��� �6zBS!��!��[w�<�P��B0��x�4�"�Z��,�h�<-0
���I�
���dI��[a��>��i$c ��m��	@�
p����1/#S����y�F��6��)Z�n�^!��C�KW<�a�ˑ�ɽp�/A��El��N#�I�v�M4��b�/���
��4&�J�T��ι�L�2J!�G��d�:lh~Q1�B�9�����3�ՄK
���h�	Z�y���@8��#�����V0��v�(�l�&���0I��BL�T<?R$�/���bţL���L;,T��8��x���qF��u���s�$�y�o�o���s��9%o�5gr}:棒5&H�� A1Ƞh�4tI���>o�f<�~�Dٯ���vP���"!��s���R��P Oa(���0I-�p�.+��#���Q9l�?�t_uFr����d\��[���;ěK,"j Go��'ۈ�4��^siv����^(�x)>�V��u	čD������ر�MO>_�8�O��;����i���O���_E�6 ����r�̽g��'����g�v�+���i�0�H��\x�%�*�;����   C(��v:��Ps$A��X������ѭ/��B��Qz�8):"ɨ�$w٘���tA"=�˚�g.~̴~7��ܽ�yfVT(�@!�d�CJ3�4�	j3�wI�g�[�<�~�����=�R����B5�&�6���lKK�1	��\� 2g Lʷ$�� �KIj�|н�0��$��B��D�n�����|����U�#��KBBA%��XDM�"�#��^P���dr��CYQ�*`8c[�0�"��g��q �	-��	>b�R�q1�T�����0�& �*��T�l��0R-��F���~$.�'���u���_��*l�� �p#��ѢfJw@^��c�`�Ɓ!�#��1��B?���nl$,6䔼p���yC� h#2|������Q)TŉH���A�Ayi�q� ы��2AR�Р��k�߸{	_�F&3*��	+�nߔrU/�����K8��kMeJ���*h"��� X(Y e�V�:�F��CR� ���w��S�]�M�ݨ@�u�똄FDr]���c�����֤��d����Z+U�T�P�-HDn�1�zt�v���a�D� ���[JU|�Qo�h d�
�t5��S�v���t���������d����i�C�9�;~1*�]g�������� ~���Bص�)�Ռ$[�R�x�</#����'�;Ņ�8f"��x�k�`b�I안IE���b��
�FX�h�L\$�P<I溪��XE�0�烀��v��$Q�)h  �u��K���
)�� $�#�B@�8E��������A����ҍ��8�{(�D�XH t�k�Re$N��/_K�_)��Q�"�i$��i��\n�ӎ
K9z0�Kw͙2���M�++1%�Xc����i����&[�:�߱�Km&T�i�H�\�?�E���T����k�������������������K��W�����08s�!HH �jD,��íBV����<Es%��GG�XC����d�����3�8���1�EhOm��P�ߥ����~�bn�x�042��b��F���R�hb���l9~<��-�U�䈁��56�4��k�E����Y\� ` ����i�����<�]�1�����b�-�:�)<� �iU�4 	rL 
o%$�($1�k��� ��C5��*�q�Wb�h�a���WI|��a5#��7D5��P�U��� M@Tqr��ԁ
��p���)�%k�Z�V�l�nKk{�T���7n	�W�_C�._?�E�r�k���Y�Á�p�P�� &\$ !�<�V�d �r'tXP*�ˑ*�3rʣ��I��M�r�BD�F����T,.WR5:9�
H8qBBIZ��;T�c��e�O�����d��"YI�*b1b,M0"=� �g����
��aXD�����-pM���	�g�U�1(��.RVJ�^���]HhD1���|�8\xe
������X���-�Ʉ���1\/�z[J2�L��� e���mR�Dݝ�}���51C�/=_
Gk�8����'�_Bњ�
}��1~�Q?��j����v�9 K�Z��O}v������E�*
�Af/� �:y�?z���&�E�_� B�����e��öh��C]o] D� 
HJi�ilx�z\�s��������h�*�_n�l�u1�_�H��4���~�������IT�|��:11:;ȏ�I$�J�,4*K�yr����e�O/Xm�\	0����4�0 5�/��K|nFVӳ����d� �,W��;�<�;L=�8ĭg���䈭0�	�p�!��(�7��
�
Κ�0�0C��� 0����Jq��脳���RM�1�.� )0F!$0D�A����J��a{nAJ{j���`ɲ�.�8�!����F ����⊍�S[W[��P�7UW��M:�/������|�'E��J`'�]�r� �� ��p�,"��ӊX�E��V��|���-=���)*TJ?d=�t>́vh��}{�Ŕ�H�j�:�ň��%��@��H�U��&Rt��5�u���+ȵ� Tf��.��*��,�d���	�"�E@L�}L�S�+%r�Q�VA����}Ӟ\��JX�7֋���
@}6���J��¦%�6�Y
����d�#Y9��;�I%��<�^X�Y%k$kp���/�hJ���Ǳ��	W^%z��H��lyV��F���6��Y��!N�A���m�
  B���PpmE������C_���G���'g�s�N�/0�2u1�\��F������<��B0VZZ[���,�Q�Y���jM����컚�E��>.jԵk;c|L����R�`�¶%��J�&#��b}k�풭Ң����f���3��6��xG�}�贮6P:n���[�  �      j!#�\	�q�M bŋ�@0$2��rh��X��&	ES��oI'�!�ע� ��4�-&Ha`��˹�)�+��l��N��E��Q�U�����d� Y3�c,;�BA�<�
��U��
철� ��9����f�S��i�S���n5�X\�3)\�	EL�h/���-+��Q�r�zYu$��sSۣ�[�W?��T���jg���������������߼ `[�DVԉ/߰Pq��U0P ����i���K0庵�30��t5T�H��sI$Yu	α�&���*��[o��`�}Y
*`��7V�'�)\@�qdx�Ϩq�l>4j���-�v�&����i�����ځ*���\�������_)��7ړ�,
z��
�Ƣ� ����@  %�m1���@��I��&h�i2d�li�T
�3�r!��<��C�{�`!}'b��.'�aL�`�p\� 
h�g���d� �YR�k  �kz��< Y�ke���
Z���2�p"���Sd����4�Aƪ������f��~7m��$Yy��F�k;����
��y㷏3x,��'�
�^�^��5v�y�y�K�R�Q���ڋvh���j˸���X�=�y1�u��/��Q��%�" C   �ҭ[\�5�d��l�P�jG=k�X^�n��9/��Y�v��rp�0�����j-�$�l̲5��+y:4m��*2I���D��ⴸ���N�/m��f�m֘��du<u�ҪE�Z�ɊMT�H �l����.��%"Pߌzm�@�   =@]��k����$����`t՗�EI"F�_�6-�v�^�9ye}-��T�3��W�EY?���S�V�����d&/+��=  6���� ��g�1&���|��H5'MD#�B��d�R\x�<�*����6  � �
��֮L �Ԙ���6�R�g`*x�ae-�DV}��X*�e�������  &�PT�<�MuE�P�u'�Zd�4b�Kf�9�tI��&�J�{���$�oM�I?Ż��4�B�)���I����?���{�<d:m�@pu��G�ؤEZe`   RQ\ME�7R?.RE���5_O�mB7qZOQ�}H��{Kz����b�j�
�    F�5��$[��a��ҷ���P���Ύ����;���0�"B%s�!%����B?�燞@B�4(��
(�B��
_�	��sFV������|$h�;����d5�#�9YS	p6`ˍ00�k�0�������0V]f�z�d˰`H   *����=0k�b��.�T�������U��
"8�(�E=?�Rȸ���@�� Up�����X�S0$G���|vrtb^_e��<��j�,$�娢E�+������)}3�g˼ۼ���"ᐠP(&d�ه�Pδ`��顧���gY�6 ��4Ґ����m �.��������\���_�����Q��yк��UF!Ü��]��   8��y*�.e��CL�Q�3,�G͎9T9lG�M7��!�@��;�{�O����4't�K�]��Ф��p�����h"i*vd�[��/1C�J�HB����X��;�NJ㠀YgLg�Q���d?�S.YcJ 5���<�K���i�m���<��o.E���+#�p�p�B���h�\0<a5���(1 
�L ��~�RfF��y>E��:P)e��F�ܓB���$���|<�ށ);�	3��#zh�#��X�H��ƫIV��28��0�A�*�a��a�2Xš�)�>+P��<�"9�+#D�|��fx!h��h�MZ��`[�3[����\ϢY?��0Fg`�1���Z�ε&C��R��"辥��GU9�IP��<��P�/��!���������L�!6�sλ�Y�ݕ�x�a��,�o��o\j�ؓ��Lw�r�>�K�ճ8� ��J�`��Q��%CT��R�[�,��+�f��kd�4�3M�����DB�"����Z`�}0e�T�i���vmt���KJ�Vb�&p�#^��VuC�R��?����C�� ��jqc�`�N��fy&  �e|p�2
�)ÃQ��tm
�=�&�O�Z\�Z��`�d�g��G�b*ߖ�c�86)
��\Ph<eJ��#s���9����HdB��BP{�!ʉGD��b��`H�ʦ�����r�����^1�<����s[ӳ�
�|�6��� 0�iv���!?����9C�Y%փ!D�������&�,M�
P�=͌���1�U��By&����g���Bt�߿�Ύt�kaL���k�h?�`C�^ͱ�nPi�)-�&� �^
PGS��&_ARRV�"V�y�mN����|Ј�W.��]����D: A'�� KD��0f�	�{g�%
�3�.|�B��[]�[�nz8\>{PC�ϓ��2��������E  ,�ʎ�
D
2-(��t-;w�2�~�VQ+'�`��p����pt�>��6O��0U�����o�1iCB ��Q°��L��Ue���!Q]���;jG^Z3KKi D#�zP�'B�π@SD��
!�`��S~
�����2�M�	)�P(.�#ă��ܺ3,/t�~x352Z� �tHhKT�Xb���
M�B�"
�q�B�C �N�n��V\ %��'�(�y�eQ�1���Z��j���FHյA��\�;\���Z��G�ӹ��B6�G��Fw)�E,��?���V҃(���0����DQ "p[i��IG{Y1�	L{q������
(K�)đ��Jh�O��GK!yS11��e�J��s�
0׽�Z��q�f@�9ϫR��ਹ/��r�\���ҥ�;
��%�#�����4�R
���w6�^�SD�k�' 1�4�4�Dw�Т7���+s:ҭ�)����c��)�1Kи��A�AU'ɵ[����)�}19��M�ӣ�*�9US6B+a��t~��������+����<L��u.>Km�����h���u�,�-���c���#�A��
h��@ȁ�}/�4�I���9�� �?�;�#V  !@�]�x����c;i5cQR��Ґ1�o6��5�P*���;��_
��y�
K�)Nt[]�����dk "�QZ��,0:�k,e�|�eG���陬T�����J�>oB�o��r
8������V����P���_B��Y���s"���ΉV����8sK(�̬��o��.$i�y����e*  00Ä����*��g|�/S �A⪙I�"�H	��#U�rEp�"�&�p�A����+�o��`�%j� �4����7#n   9.�D�y4ٔg�K��=��	U��ժ��		3�ϩ��5G
j=�f�s��A�� @i�Q ��GYM "�6�
i: �ɸzyE�B&�-.�2��S�kigF���N��Wp�A~Q��fEE�
�N��b+:�3�� ID� �]@����ypT��J3G�e�!y��$
�U����D�[6�1�pL�km0e�	8�e'�	A&�-p��,�Ŵ ���`��6
��Xh�~&�����	A;�>��"D�
 ��yM�!M�(���Sf�M���?t�	�f&��P ��(�Gq��/�g�4��D'������0B����D�t	!��0 ~:�E�XuD�����$��?ў��xh����%`�mʄ��Z��! |�K��A/�xQ��	� 	p�&�r�B#�*����p9�L>E�0�Pmfi��a�&7�Xn������w$m�#��<�|��<��f�-�,` Hp$"��uH�b!�#�,�!��%)K.Q5����7	K���T�G����J��<����|
�1g�� ��,m��NL�`���D� _Zi�DF���1�	\�e��M�5��4�8jL��'FkK�+4����������03)NG���;�v*�C�_O���ؗ��Gd޷��i���s��[�0@ z*"�zoA�}Be��

��B�_�r�q(5��bV�v8�iۢ������}�w,��G���Y�_�>(	�ؙ��M@��m�
�����Z��I�ծ�p��(}<��V��#tt�r�	�	��g�]�<Do�8 ?F��FB  �P>�M	�XC؇sx��$��z�̈́ZJ��p�բ�eJ41��7�``���$���P��k<������1 %*� I8�B��-�`���QG	�x:��%�W!N�n��;�
�o�8�������9
���D��I6��+4L��l0�	H�i� �#m��
4��J� ����ҳ���l�j�9S��F���!�
���5ӼUR;n�>����
�|hDY+�/���[����!�@4؀�"��iǲ�@e�@#3J7������A8��ѱ _��R�~�����Y�}��z�7���Ê�t��r�h�R<�b�	:+l����P
�&�AE&i#�s�=�"o���ۧ�x3?ȿ_�k�s�e��y��%�����3��X����QN2+� L���Vgg�e$��Ob@��U_=���P��0������ �6s��?��P�O��	Ŝ%p'G�1����Ȃ����"!sW��M�H��ӄ ����D� o$Z�)pN#k�0�H	�Su��Q�?��t`�( (�I�d�J�D ���a�9?�T�=���.�G`�������B"P� ��qD ���H��� ��N*�I�f@)�M)k���udS��ş�4�4�ٖ�����ya�����E�v:�4�
f. �*���rV�R�vNo���!B���{7�D�:ڠ��I@ 	}2Ox)�����$-�e�,BDW�ݏ��i�a���-M�f������3�&H�Q>>�#�H�ڗ�2�c kMr�3���A���^�M>X
���~9a�(�C����j�(T,�>���C�0U~'�cq�F��w����CtVuK.wb�O����4x��qW���T(�J��������d݀�]���>�[�$�8
 �i��s	-x����n20ED*(~����ZgG؃�.��i����4��,�i�������������p��P	�t�Z�s���>��[_�����e\
_���&���o�	)�b��?c��H M�~���$".���zI=7�I�$(�@��ƃ�������?rSE6z|��&m@A���0�������|s3s-�G�a:#�A��ujO�P`e�sE�,I630���aF�S"E�I,   �hI�W�:(��/��%�������̷2�-�o����~�o������o��.�*�KS5a���ڭ�hT?�?4T�����o���R�����'H�
�	L��"!�������d�$6���C�G���1�*�	`��W(�mp��@1\GH�P�0>$\�C��X<h�eC��G�:���pVWJ�=�ɲ��vH^��qz��J�H���P�e�\���
�Aĉ4�J�L��u^���Sl����xp�5�(RY$��RB�q��8�X58\je�	\mm�����s� @9�h8�`� ����̶��/ �T��G�Y�С:�&��&.�5�ed
�*;xՈ+7e���-�Iy� �SU�9C��qX��ge��涷I��L��D'M��~t�V*>�=�s���h�C�F��"B��7%���ߦ�gw~���߷��z�LR���**����)��p�Dfn��?���R�N�j����d�Y2Y�	rH"�^<bHeǤ���x��`G�1to`������'U�J�ƈw�SN��a����-@]�.u2m�.�R�C ����A��XR�l��tml���c_�_�LI�/�
f�'�����.�0�"�u��D���2��81��|$�}��Ԩ��n/᧳ߢ�\�A���Ƥ��=(>ݽ�]X���j��6O�x��v�7)�n� �1ѕ��\�Վ,��yQ9�.�>e�&jH�Z�h
   �iA7HahUl\��Ա��oR*&�R�'kv�����y5���R�C^M�NH�T]
NI3�s�0?����7'�=���D@��Jpy�
)n�b��h厯�|����p�eYQ� �n81h���9\EDc���d�R;ףJ`Q�K�<�d4�e�X���,�	 O�8��k��
0�y�"�-��L�U�)?P��6�*�r'��"���|��DF~�mZ�:�&��d qVv?1����9�XS��a��y�X>6$MﯜA���a�qnI4�܀�>��DL��z�9INOzD�꯭9�9_4O�tbT,d�J�9Ԣ��`   ]��0�/�Xr�`o�T!�mS����5���R� �W��\��?f/��<t��0t|
�ٕ������[�h� 	J�B��>$��7�Ĉ��BŐw�'&�X��n�s�)7�bPV��D���
m��h�;�2�����q?A
H挡�|XD��U�#*�=6;�f��Bt �@�4VsU�9�����d�B3Xa��Q�;o=L��eǥ�(�8��q�ŋD��j�XU    ��@8BԐ�Ep�M����m���_�tnߵ��g�[/u=Yo+�gMaQ<���-�c�9��e�S�2+�����Ү�eT�p�� m�[Xg:��arV4�p��<�o��(��%�/�蓜�s�� �;�`� �
�xeG���ꈘt�U���,�P�U��ċt�:�N�L��oQu��
�P1i���7����w�び`�(^��p�T].i&5Ժ�f��kc�O;�K�U�? ���#�"P�S��8ዝ���%V!��{�:��^b�W騰�P��x����R֓�Z����zI]*JvQ�%	*�@&˪�
)K  Q �D�����d� �W�i�@Q+{� F��m�$K��.���R35�wĄ�>p`K�Y��H0�g⣂�XI�>����8hD�(��Dx��U7����H \�����~  �@H�|3@7=Y��nR�y��UK6�
ߖ�J��O��)�`����O��mg����~���v�Y+���_�153�C"B�Z%�"(H	��Ť쒥��n�oĠM�J��N��nE�D%~�g-����z;�/A�}������Ͳ7���_���B��9o4  �� �fI����9�	jeT�bcP�z�B)�|���~w�y/�p�b۬|@ ���D	�Y"*�H�������g����T.~:}j��m�[0eo���Wc��ؔs������D��Z��`K⛭<�:�gm�$�o-��!�����h8�lfxܘ<	O��"$�r�y���
�Z��<0]X���
f ˉ	'�JT�?H'���\T�lOū�L�|�d3�a�>]ӥå�Z'����Y�E�� -�GM� �A�`\����w�Y���i�<�·|'mi��y��N
�`  @�"%�ɪÎ�PF��Vsw�:�`��o8q���"aØ��s��!:��aj��3`�Y!��L�7c@  xkY�k�cp��S��d-�q�\T����J�����]�+rK"�I$�%��
i�/����U��E�ֱ%��Q-��߉*&G�:CO,��s���m���ŘDx�V��"Ի�$@�f   L�ր�lݘA��_���d�7/�I�6 9<,<f��a��T�
��𒍀]8^�8���(��7��8�:򴨤J��u`+�m�ƽ���A@�c�T1�o"=��@j5P �c"���n�^���9����}�����;�?^�<fz��������3�7��niH���-Q�Ť�Q��y����J[�7�l��+-K�A�� m��ʐ ����@�(�Wm���DI���#I��jv���A�ӤA�Hs
�VP����Çw�'�jM*��    ��$�Pr�%�_S��ۂg��}#:�뾡�U6���_��*.R9�ۣ���`�-�u��t`����;�3�>$籠�E�2tӐX�;��BO��}�<o�T$p� L�:)���d�oJX���H�K.=#
0�c��-4���rt�h��s�h	�A�4����r���VT
�� He���x�,�/�����-�s�!?�� }��:n ,�Q�K�#1��"[n<���ऍk�#q��0��0���3:��`���Mba���!\�"���C��8��d^����L��F>AMC��h�X�Dެ�n�k<ݦ:��$�D��ACP�s�����>�6`
��Hd�������iu�����n��`� �������bc+�$r �
�  1>+�D;]��,�;�ac���BA;#�/Y|�Vt �@�_ Sǿ8w�s�@�'��H�ލ�!D	;�>��.����x�o�R�]��T"<�S��PI���d�S6X��+pIc�,="*
4�a'�ԁ�t�
--��e)Y �Xp�	�5L'�?�",�p����5I1�*�Ѭ��oK��S�a<TB��
�LCY@d��b*$���b *���
���i`��_�H5M�A$X�e�	���#T���J�А�����Ԟ��fv��|K�!\p�1a̮A�
df�F`_.��\u�֍aN�^��@	F02@
F��U'�)�:7�A�B�[8l �ǋ9�al(uJpA5��w��U ���  :�e�y����U	b\!p
�aPB{+ٻ�SL��S�C
A�����w��9V��J���D���k�i��)�v���i�G������{TM��Z�}��� !)AaZ����d�#�=���-PC��\$�,
��m�0s Ň.8����8����p�p/[%���ܖX�V���"��i5�-�|�H���A�qfo�. 	E�J'Ѡ���Ж�I��	�V�VN�ݟ�K/�E\�?�|҆5�Qӿ�N�">�tD�1n��ѡr�!M�%��w@���T�9J~&~z��H�a��մ40�-N&�
���g�x�X:�����.����2V��'����*�:!� ۡ1fXt�!RE�e���*�h�  ���+_NK#�po��rb3�Ftx��k_l|��G�1ҞMD@e�(1�DV����@�����Fa�@3Q�9&���:�n�l~�ld�ɿ����Ch��D��K���������A��  �@���d�S=Z��2?a��$�
��a,=)�r<����l^��Wbŀz�A6����N�?��pE����z*B@AD���$^2u��TZ�u�'}�`�{\YJ\�;m&4�(%��/Y�["W�J��.�),�/�$�"�ٖ�g�6�T���T�Щ�t��+��qB����;�������ʠ:Ib�S��!QC�PP?��2���0Q��S�8V�Vl��@U���HH�G%�_A%CM��NeJ�   	�������(@<����3��Ѐ�/�q�Óe�7QS`q^bR�.UT��= A��Uei���0�:����bJ��� "���ߑ���$�4��@  B���p;��
q��|��N����zbd���d�f Y�2RB��$ ��g��oH�.4��H�
C����G&��Ry���b$�� ۿ��7`@�����p���Z��#=Ca�;�Ua ѹ`��@���i�{����
 H��QA0�BJ��f�8ȵȰ�I�����Tvs)��?2�cy��z*T�Q�a��Q��̝?-E�T��p��:wc5w ?qw��3��~Q`�0�*P�%2N�"�l���:y��8~;��-�0'�`IKImE%h��Hq��P,�2�Q@I�b�����}@�0�-��!q��m 7��� 	R`&@�6��Dh��JS��|<��<��G'��סJ�h}D��e�Tt$cs ��Q�Ѥ�[ߋy���"k��r,�-Vp��V=��(i�����D�# -WS*�lǋ
a%n
��q'�i�b,��	�  ��B�TL� �j=8i���9���2�I�~i�~� �PP_�AGq@���lh�2��ІoG(Y��գR�Ot_��[��Z��};�тp�P  �쀉l �:��	�Ⰲ
�� ����A���Ǣ�p���`
-�w^��P���Ȣ���*�%��A;Y��dF�ڱIJp���篯�Еi���Rqe�+�6�W�I	>&�#�P���&8A\�5@�E�/�aϗ�2'��4L��$t��&�h���$Kv�i�II��#$�E8@ 
�`CL�p��	���.�����VJ��i����r`ZDO�����HU�<q��� üB�I4D?V��hs�O5����D� �=X��Ap[��=�L�_G�K�Z�.5��'л~eiGuh  
M�<��4����&�;2�s���>[�Kz���.{�9��<�/b::�w�N�23)�Xr&T 
�N�`(>��De�2@Е唰���ܑ�L�����T�iP:_g\�;��"-�\��18}
I�k3��qv�U9=�����P,s#�9���\����,*s��u�O2���x�����H�JXBR�"�F�XNv1�WX��I|�pzXj�{�wTD�r��p�V��~����L����"�:T�LNk�R滜�X�h�����	�  �vF��%��/��@��{9�Ib���!��j��ŨG'������׶eBZ.�5�f-W��LP��c���D׀"�%W�	+PY&m<�v��s��n�l����!���0�/�dW[%���#"]�~�)�W��r�pk�"Bk2f%>&'n,)+n�,�AQ,+p�Ҙ�v��������BS,��������7�kӺ�Z]��ǳv�+mv�ꣿα��>�6�� u�i�_���E\�r�)r���t���
,�L� !�I����_�.RC<���U0��?

�
�;ޱ���$��9&%�*�c��х���I�[��q�ˈU,�EMM�(� A�@%�2�;���2XA��Es�(j'Y���HUj�� Us��3�M����N���E�Z   ��n!D�T�zN�Kb��R���Q_Ц� ����r�����7��ٶ��G���d��X�S+�DJ;�<e�u+_L0���lTѕx{_
�����Q��+�����؟�� ��#���p�w����   ��6[��1�`����ww��������@QkY��8.\0�I�)f����@�6�|�VD\�:M��u�w�ٍ#��US�7�M+���y�c^N��{�5�T6��hgt陚t�����wgEn�
�*��]Kcu���Z8��ka�ؖ�z6�	�ޢ�)?~#
ѯs�D����`� {����Ha��v&	"=7�g��n��	   ԙ��;E�� y�oPP����zHRL>�I=AъBB�i���^rG�w��OA�����^ز����|SI�S�R�ӾJM�����}s=���d˂4#Y���3A�]0FH�)eG�X�އ/�Č�Џ�~6�ѓ���8 �+x�=��J�U�Q�Aٸ��>>>�"+J�Gz(���d�V��JJ�������� B ?_�f���JX4��s �`@`�G1�����uB$��[�~��J�j�%��b��X{����&����"&�9)���H��6��*�a"��U�� 	�v�s�ՠ,i�  ��-ld��
6ɶmQ�������>�|N�SO���5�  L�D3"V����i�&O��z��mtxM=�<���QJ��b�ub��6�_	8W�U��I��>���>M�7�W�"�]H
M���$GMrw_���<��0��v����go���ƀ�������d�E*���Cr8
�0�X
L�],=)���o��~N����7_h�]�U � 	j��s�����,��{���su5���3_=?���k�c�̕��S]�1�"��rΘ��e(�����
0�)4�Z�4�:��h���K=ח�X����
�{�v앑�?�e�F�� Zk>��R��{ˇ���-
�x�����9Q�\$q�2�3��e�AJ�C�p�)��9���(�86k0r2��Z:D�$��'(��`΢��>Ya����[����G��ZY�Y�=�U)�$z�~>�Ηb 
i��u`��s��EB��(�A?̗��jN7Х/���T���	SBC>ت$��X"������{|��>����q}#�b���d�MWT�,�D��M,#��/V�4X��mt��(H	   .�j⨗�f�Uei4g7B��N��
�38Ky�a���V�	]�Y��,���%S�#�{~��W*ea��w*7����Q&z�c�����Y�$   �2�.P�N�A�u��f7�y�(Y��22{o��8�쯈� ��u�X~�� �rtcY�m�l�dW�b)��M���V;A�ߵW��Tu�@��%���:��j9�
[b�衾���Ҙ&�o#�G�s\�ә���!������QY
~�1��BJuF�[���{�}Hafa�L����U���  E�[G�q�K��T�1 ��W8L�{�:�o���b_j5�7ϥja��m��KO>�^�r�X^y���>����Dـ�)���@]	;-=%j�'c�$��v��������*gV�&�קK;2صe`q7��t��>T���8_����!�ᥙ�Z7M�-��:G>a����!�s��[�%Y�n�����,��^�k��, /a8Q@�I.R��������W�`v��r#0�T��|��jIYKyO,ܑT���d���^^2��}�ֱ�
5��/6��J�Ul~"r#��	)��MOI�}�ܡ;]����!��.�A��r3.��3!�H�a:`���"�X�HA4/�c��V�f��\�|�5��z��x�Ċ��?J��Q��D�L�`  $��Q,dj$dF~s���[��w����B��
z>��3�8"�n���{���>�������d��TYi�2;A�<F;��{i�%�����4���p�0�	�๨.D9QxP(���������t)I�>��g8,[6��"1!    �ՖL��+I�e��{:��2��
{v*�y������Q1F���^�Ԉ��������+3�g�f����������M͉!����F����'�%7��]���<h� AK$RH��r[�k�u�?����K���G����j:σ�0�*�>����o���\�R��J�T�R -&S!f9L:��s��S{*T҇����^�w&O�טTn� R�"�2R6�;1Y���Z���LHafpՁ������Sg�n/�(Q�&&����c���^n���   �	������d���Y[{%MpF��� #���q��M���<�$M�!&AV���"/����-��0��hq�aiY�a艇�}��[.�}.�  �3%|D�,�J��Ƙ��Iv�a�>�t�;h���t(JjP�b�Nʪ�B=7UT�L�4Y���jj�p�$.�I}
ʶeFO�0ˑQ�]᝘� %3��pq4�� ��}%��������eU�*�4:��lh�,i!�	 XA�r�T���+��wb2��i�D1���&g�E�;2�I?
Y\_�{T�f�:�|o`U��ht)s��	b���\_�G�-<�?_���o�]�X5��TVK
~΅7o�e��6�+�߷�f��_�����p���Ť$������}$\��b@�3�x�]�;����d��(��*@1@��$��صig�t�ё0��^J,�Z�Z��fթ����B��ڊE���(t�K%֨eXЫ6m��T�Gijk�d0껚�ד�OOdY��Nj#.�R~6$Q+���,-֓Js}��5#���ܝ@�*xdhhO�9�~��VPq�M�m��w��gx� C+!�Y2A�e�z��|�D�@̘�Bp�GQ��ٍ�*�
7Й��v�<TL!Rd�?�Ө�|l��Zg�|��u�c�;���5���'�DF��($A`�(+����R	w,��P���B��(����R�F_������iz� .�p�1U��[�CHv��O	����P��^X��Sm��~�mZ�)��Pt2�B(�x:Ã����(]�����d� �WY���9���1c�omǤN��
�����i���Wmf�7,��"�Q��ΙN�|�f�q\�@ �`L�mv���:5��o�jo����t��(.7���/%+����l�YS���t+�;��$!��7�c<5d�$��S����ՌYW4�� ��7N��� �ʷ����$�Er?�Q"%r����B���<89������c8ߍ.E��Η�&~�Qb�0"��",\w	�9��g浓�YC�g��ة!��E�_��\�lP02�@B�Ϫ��  �1�$��$�R���pT�<�ݱcp~9\q'v���JjT�&�f�iY�a��\O���42�D���P����I�B�j�!��h���ra��VH�(����dЃM���*r<��(<bB�b��� �.8���P�&�g#2���kJ�����Z�A&.��گn�\EJ�"��y��=H���-B�$��eKQ��[K�}�E�W~��<�Gn@m�]e��]��C}���w����|j��y	.�3�{y���C����� @�i̜f`���xM�jO�J���:
(�3�뱪K�3[ca(*�+L�~$u�����?x�!^�� Â�z����'���� 	����H��n��5լ `�!��?��H�#�0Gb�ظ.\�$Γ����$�
[h.�d4���E�B�P�*�� ��8�ࣃ���
<�����|`�ƍ�?�|�S��V�&y�%�w������ �JT����dށ�0Y���?��\%f0
(�d�0��
r<��.����u3L N�Z-��GE�G_����WM�,f�FA�M3��[!0��N8BQ����
�   �`%���RE��.�k�v�ap|�yT1J$�m���L xr�+�HM���$�������I�t� @��],`�J&�{��~8ۋ�{���
���,Ų�j i!���Ǖ�b���c�r��*���?�WK{M+�#V���U�_��w�y�Ꝓ���Jd ji��0��K���-��BlV*��Jg�K��B��x��5���8��nL@8PTdɢ�s�9�Ѣ�I�ʀ��1,vP��SJ�:�5��m�?��D�,Dن��iR򖪟Q^7MZD�0  %��f��O=�t���d� #nGYY�b@A�|0�R
@�e'�2��-��Dqw���#���nc�UX�sER�����ƅPu_Ы��HA ��T��E0�����d@ qP!��&CN��1�A1,*�r�DH/��L�g:d�p�����6a��!�;Qe�$��~����/`�:�����B/��5lAJBKT����Ͽ��Y��[��Ѱ����
�J��W��
��s���\VĎ��2×-ptr������bR¤�5 g�ת(��   8�1iiǑkWd�+A��+�)]5��r~�u�v����'�#`1�@��,���ewV� �c�n������W����l��-/��T+8��Tz�;�� H�,��,�bI:"�t'j���d�kS�a�-0E�kl=��o��g��20�$��*�S��C8��wT3ս�Դ�l���u�A�OP4�������*���H ��9a�,m���#;��ቧ�u�s��
����^rbM������R$\������>f����/x��>n���H�8�1�
�����A��!1�T��)�^뒊\��Pc�%���5�B~�!���|�B����-A��P�(�kY1��)<kcL�jB��2���@� �	i�J	WL�pEF��[�s�6,H\�Sw���[N���O�����.C��QJ�@�VD���>�����D  x�dL!jL��#�cH���i4�DK T��Xխj7�S,'�U���d�?"Zk5"E�(<�J
��],<O��m��0J����׿�Po�j��yas����L�e d͹�".Ur�Yh��ak>^� B   Ő��d� DL�(n���n ���x	֎e���m,���;|oO$��;
��/�ĩ��l�O��O��{��/�����l��f�u#�4�P��?u�Bv�94H�V���m ����E+�#2&E�/[�6�P3�U�D (� �p=�@\8���`�ȧ&,����G�#ݫ�p���> R� ��D\����b�[���!m�x_;r�v����xV*
V�b���S�%ƥs�c�D����\]������HI�E�w��I��B���nP@ᥕh*��@�E.��Z���d�R/WK2pI�k	<fL,�[L<o�
�mt�@M\L ]�a���7Wr��͍���+�sg�&��g�@ʞ��k�k��@�oY��$4����%	�uS��
U*0Bw�ŝ�:$fi��ʨ�b��1�����̥1V� �ު��\��7��ˡ��l[�?�ƣ��D�J��ȇV҅%ϝ��C$�Μ��P��\��B�q���'Q��R�E���͕����0s=����������Ȑ��簢�5{h  3P���6�΀s`�2�Y!�@,�DzL�n� �+�D��=��$�҉�]�y�D�T4���V{�\����k�tF�"��D���P�ً���`�d�g�
�ǎ��\�T��"�P���d� |/��MB]0kd��g��  �
���P ����q�`f��nY(�0���&�A���R���)nvE�et?��vS��2�C���f/���;�Z�c�v��?\���~�{��zKK$��{���`8&�$Q�ܚV+���5A�z�h���������
Nvږd�	��t�V����s<��1밣�[���\W�Ek������H��G~5�[�U5���Wq?��������ի~�7�ZR��Lbu��_mƆ������Ud�m��/��R։�,�q��lw��%�|�������<w��     "%\8@L�rQ�J���8�i���O�P0��v�䬴�H��$a3>Q$��>W��6X'a0�6��ܛ��ɸ�z!@M���d��^Ӗk  �k�-�< �me���
Y���6`��uIReE�q���r$���G��Sݵ�e�.��<S��N�;jQ���
���q�F���s��D�'x{��8ꈕyEk��=Ʀ�W-����w֩4g�Gzk�i7����7fFZ7ق�Q��R"  ""@	"�5�)��rj��I�DYс��{W�����fS�ͳ�����kj{�|��-ڞi �La#Y���&�!�H�H�c�;"*��B� �da!���� �����8 �֠�7������L�{���I�b"�묜*o� ��B���ƥb��X�����<�Y�G���M�5�6�k�b	ScE<A���fx�ø���11���c����5�6���d'#g3�Ga` 4�K�� ��m�m���x�$[_�Ysu=v9�^X8'Ʃ�{Pj�J%��e�"!.@` � ,i-. �8f��"�#�v�I���k����mAm[,���=b�l�!m&$ �� J+-jK}�ro�Ʈ�ơ*?IO�I��byB|�,�D�� ����@�֢��(�"�.����\QRLz�Ā�#xX
i-"�	%ڣ�J�o�m5��E025 ���2��$7�8@������TذHy�!/����Y�c��+
=�A�M�U��@  :��"#FlR��1u#����{��nI珓��	P�8��>��
'�Ȉ^�2h���~�n{Фu�s����Q��rN�w�g���H�gD,�eH�dh�������d6#�9Zc	p6�{5=�X�g��o�ɂ���0�ץ� �H���&�������G��7��^t���ξuB��9�OE�$ X65�1�.b<��  Um���U�L]51|�\b�<�C�*��H	X9dHW#�Q2�D�ad�L$���D�EErA�MH�n\�,+4̄0�!G'��t^�sam��@44V}�E��.h 
X똀TʘA	B nj��*\'=�.{����-c=��X�@��,HX&�⚛����p�   Ya(D�U`��5�"��{���s&Գn@�H]!M
?���Q"p2��=�ܟO���{���ozOI$���F�K�&�Bab-P�J�L�a��R��4���f�j��@{<�"�	
��w
���d>G/�cH�2`�l5	��c�=!�ʂ/��������3"��1��v0ʮ0���J���
�
�@0 P���v�\���p'���1�5ѸB-�S�]�M�o\� 4䐡�����ns�D��#CœD����znw�=��2�K��_6?*�Ѵ��۞�zOX��Gͭ7
�A�(pL�������Blg��LQn>�(�!��YV-�)@�$ %(T*^�ėJv�R���?�N�v��1���,����6�6yrn��Db�t��{�Xp��cp�*�����<����W^a���2E<,.e�42�#��dV��w�P�9Wo�Jb�.(y�������I,V�/4�.��D)�GjIq&�H�JR��v�5@���dR�CZ��4 �n=����q��ΐ��<��A�2#��H�]Q4�C������nûD�S��F����ҳ���6�
�I�V4y DD`ia �.3o!�ްeD�v�!`������ )Pv��u�>���k �:i_�<Hh��3����X�	�N@�O��)2&{�(��M" )�.��m1��!�nr��Bg��C��iX�PP�)l��,�J�1}{��yk�����Z��&9n�N�*p�@e�'�:�H�j�˔��:qJ#t�0H�Xh����Cf��&�Y��-_�\���M����N��Q�!B������$��e

�Vd�_,�V:�:�=�h�Q ��\��b3]����⋫���w2F�T�y���dj �)�i�D8��0%3�0�q�0j���,���A�	�h:��KN60�rh�@m��h���  �4yQ�QՆ�zRK		�P�7�fm�RjT��!�
�"n}�M9�ʛ��T��3��~��@  * ����%*��>a+�������]�}�g��Bc�B�
�9�������0�ER�����5^Ԟ1QPx*p�<�BN
� �C��A!�F�M�/G��q��J4d �C��9X�=�y����C�����O��;���-̡!K�#c��6h���b  
��b>�M����@Ud�
C�0�Hk�3b���#n���,Ȥ��٭)}�>�]瞥Z�0 �	!gX�+��dHl5Q��K������� 	)Jʰ�"���d���"YRHp9f�0"Q�8�eG���݇-t��$�ڝ�uI����׾���eaPK��v���� ��� ����iR���@u3��+�f,1�L��ʊ�j9$5�a����O�5}��sq-��#�Ce@�"-<e��� ��T  �23�)hK��+e���1��K�/���@�{�����{�9��4$xU�X5r��M�n�3��L '��[��z�lu_	J���dE��f���$�ѣ˗m?���z./�0�\B�r�S�\p40�+W�>����/�t=Z�睨p\�����Z%S�X�Y�Т1�V���9�P���c�+�幟}��j�p���EKÆO�����a���d����� t4	���D��R"֋	[@L�[*<fn	4�\,1�*�t���#<�(�~H�����Y2)n���;rs�/A�w�`>�lԨ,���,�HJt:(H�4�"sƨ�����  !NG��@H\pM�$�ʴ�W �E�2P��7w�&��lҚ��nF��&�!@�4�ǭ0�ŽW�T��������A�:�$!]E��-��h	G�i��~X5c4F[�s=*|
Ɗ\��.�HT\6T`q ��B
�H)A�#��3�X�V N�f��"�Hn��~6d%�j9N��X��C��G9���6cYJ5��~d��7�E�,a���R�kz�N֒�k�@ ,pP�I<8d 
���e��of+1���*��O���7s�
h9����D� dX9��L�K=#N	�SeG��5����	0�A������(	��o���
��n���� P��I஡bID�*��wd��U�=�h)�/(SgS�l��M9�|\����&��%��S��,�xgE��ްg�{���q�	�$�X�:�bN�N#ܝ(^?�T/��*KW-):�p0UӲ0頱��Aph��$d��I+T����<0#7}OX� ��2�C�G�OeTg-��l"�A��TDwZf�瘢 q��iT@8q[~�!�ǳY؉��`�;�����	*p n`Q��qj&Q����q�6ZXp�Q>�NV�S�x�2�:��Q���Tb`�&
=� ���� ����a���GX�h@�-��I�LFK�����DƂ"]"XQ��L���<�V	Po_��l�-���� t�*<���b��b��Ғ��MB��g����5�+�2�6��'�?(歉P*�Tɉ���RɃ_ud"r�! �!`�9@��>�j�R#�����Ԃ|%��4Y����̀���2����#��}�Rښ�6�rh>颁6a�ƈ:�����,>�o�n����0TC�"�����6'�ch=�����ll1	��%��R����F_��EW)��f��Goׂ"�����e^��33�'֠A�P �C�Xj�K�*QXƟzP�D��@N�:Z����C�}e���]Y������)����O�Ǘ>��-c�%�0A�T ������JF��֭0 ��TADT@�d����H˨���D݀pYi�A�IE+M$I��i�$P�c�mtĉxQő|,Wzʇeu�.�NP�J8�3����Bc�����v�x���ES�T, �]�q�=h m� 	w�9A22�"M�� E(�@�جr+������m�q���o�gߝU��G/���ҲgnGß3��~���Euk�Ƚ�� �I�Ñ��2���1t��-^��,jD��;qS�@�%�!�ʕ�uI츫���q��x��Y��6 3�<B8��\�$�ǀܤCG#4HA �]�iu��n,�{���E�k$�"6���Y�C���S8Z�*��LB)�O�Gx�@6ڜ�}����J��u� sǅ�(a!c� Me�u�
��'�^$$3��   &9���������D� �(WI�C@VE=0���qiF�
,,TĚ)�*�����\�Z��܃��#��29Bnu�uwY��" �ٓ	h�j��"�7G��ҷF���������QZq���9�7%u;   �aH,���!�>P��d�(ھ�&֬�֦�+z�J�]A�Ц�.�Mۣ��$�6��[ܔ�Y�v�dk|A�Â���80v��	$q\D�QI�P
�,�Tҋ��@���/�%;����0?���&%2<�2_����!�*AP���K4ƒQ����L��千�j��'��à��J{I��	�82>��;���b}l�2�A�-)m0VTpV� �c��P��x4O�x�Hi/���R�Q#J(�N�q�|����D���JY��`Y*ki0�\HHSk'�e�� �NxE��%&w���ՙ5w���}��?����k��uigi+*�ޫ������eb��Ԗ�|��ȝ�b PQ  b�	����a:�	WL�(:/f�Gt����<���;n�A4���w!
M`���F���,UdJ���x�D����|VD��"7�
��~����yE��ç����#�D0e]�B�:�1Lc=�4�43�_��o�[+!�S�F�cYj
���������+d�+H�M"���3��W�U�3&��������;Z�Q�w�]�Q��OT� eQ  *S��!�9J)��%ubq>�����`_{���m���c�R���֥{��o:/>�	��l�yS��|���x�fs����d�?SX��P3��\`�/a'����l@�l'u���K�o�#  P����	0��ǉ��PM�#� M�]
oA�W(�˄S��C��Nk�1�RS��gWnT{3�Z�t
��(���Q�����#�ܒ�v&�JH m,��C�
���� L0h�uS��f>�$��%��U���>y[W~�{���A�pnaETJ5��"����.ggJZ�@�(hC�7�r� �R
X�(r�C�&�1�v[q��ө��
�7X%��N�w��=�,zw��p�Mn���<��
.��ui�ٜ�'Bi��n�_dg�7~J1�Uͨ�Na� h��  &�s�A�=0��F���K3�P�OB�(�����Ku������D� "�.XQ�)�]��='^y-_L0G����D���H�)D���ts��T��`�Ome�|�ʈL6�93��bW)EȎA�H����K9  �����r�9L6��<ϵ�'��Yn�P���;'�Fo?�g���?f�i��N.9Pг'��R��/�>�hmJ����Fw��T��T>��A�QؼB9����	� ��I
lY_��ЎH\�^>���������S*%|xI#I��I$��<��_4��0Y3+�۬�" %�߭���T�P��t�g_��_�A�B����b� � 4�x)H�=]i�c�,G3���ޭp�eG|�O"�z?�I�܀wLF%O�$@w�N��Ц���g��}�皿Ta �k��.�CT�~���>�e���D�"�W��30c	�<b�umYL<���-�����;[��z��e�
R�` Iz�)`T�M�q*h�v�\/qľ�)nen�VI̹�c%�%��K�)S�aq�����_�v-�O�G\���S5F��W�'U��8�����׺�	  ='Ĕ�&���Ftӛ1�����Y����_spxă&fE�����f�ߠI	�d R�Iv�o��s�y
c#"�;����i�L��a_��҃�UZ�6+=L.�.Ec�IH   %G*"��{�1PZ���[| �@�o���B�dT�s�]�_+ ��g�x�N�`�W�!��Gab�����į�g��"sο�JD|��2����,�[���"$s����i�'���D��DLXkA�n���=*�}a�$m���-��F�HɃ�2)�o�ӝL(	�E�u��p�河��'��}���`q�'vj�����q�8c�$c�Ѕ���D@��j>@-�Et@  *QXT�r-\�G!�x��{�+���_i)��������(��,b��] �{���$3��BT���ht��~�3L�]`9+!�!ғ𒢭�@�2�����IDh�Z�#�Np�Q	9�������Y�����^   u�P�p7pJA��)���������͏�Lt:��e���g��:H^�u�6��ZN�e`�N�%a���8|��f�9��7��m �\���F �� �ę����,JDڵ�q�,����.�
��I���D� B^Xцep�Kk)0��K'q�K	z+�|�
(`
��J�D�LƁ��`�1��`>(,�׶�l�]�	5��0p�#���B��;m����{���:d/D�?�h���3j��f�^���FR�%��֙a����4HT���)����>���/��X��מb�� t����<�pz��������5��%�����W�����g����De!�.����D��1B)��T%r��@AјLj:��`��Gkr�pF��jȦ*�B%�B5p����R[�>�
�]����Q��='K�}�F�"�ZQ�J JD�q�K@|���"�
3(JM���&Ǩ�M���h�a���h����.�\�<
�@iH�����:Y)���L�F1�i��\Ù�p����DQ�,�Y�PI���0�I	�ck����3�0Ġ���F���	+Z�e��<j��O-d7���0�@E����W�0�1�V��a�����S��Z��/�5k�g��D��Q��x�1�S��A�Aj���v��\�0�?�=i�r
���C֠Xڌ��;�dE� �$�[�`����V~�Cx#^+��3����϶���)E��WHV�N~���5e#Ł��8�B�BJ"Y��rB���\L��   �!0��-
�uT?Z��n��}e9�<�����j����5�|���m���kD�/Ȍ: 8}OlM6RD�J
B�gq�-
�X<8~� F�
�)�uq݈�~@1��m\=E��?�ԏ�xR8&�a�K�4P�����Dl 2U'XA��G�L$�x	_o�PQ-�������E �f2��)��͐��]*��\7UcOQu�'x$<�����G嶨R
��o�����:k���)FMxH�:#x/�U�0 ��cH�:_�=���j	ۥu�;�£���KI
ᖬ��<
�*�?�D�+�@��

ꃢ�+(W�F?�XFU@ @�ùbp�d��J���P5�<t\7(���E�������x:Ϭ�@�e��c�_�>k�0JN	 �`j%9]EB �M`p��N���"V%��k�\��"���E�Q�@!�v�Ԣ��IR�U˜ua�`�;�0�N ��z����_��R "` �v;-�lf�P�%�iU�U��C�/q2+�]��ni���D� L&WA�+PL"o0�X	Нc� ��4lp�Ȁۗ7�J���w$��@�|T(K?��A����c����� 8��O�RHtr��ɾ�W���F&��zJI��y���������f�f��ߵ��Ԝ��B�[u��~��D�}'Q�$u�� M����](�+�H�0�z箼G#j�,���&J�����m?���P���a�mzԨ�������<ߪN�ow�D��ҵ  <���E�PR� =�
�?]]�A�R�0>R��ͩQr���;X��
=Vd?�A�p�6�o�s=w~� ���G�����詆�-8��S����8	����z4�b!@�R���:� SQ(�W/�����u�Y"p���H}J������D� l=V��,PT	�M1ev	@�]&��,k�ĕ�@ 0�rtu"��y�:G%����=U��=��$�7SO���j�
t=�q@�n�|}�scL��G�4�(�� )�S�-�\�T��M��B�D��^�++�r���\���> 9���O*� $8P��su�\!�5�L)�'ɛ$�]ߧ�@���"��6
�u/L`�N2�`C�X��PU	��c�I��̂��^�
8 �0�{'���L�[�������A��p�Bwըa:�L�h�2����g����Zl�Zj�h��XK��J��Ԫ�A�%��2�*��p����Fq0@�<�#79��&Մg9�q'n6 �O ��|��`ّP -cV�Ƽ���?��P���D��b&W1��Q"�0I�
�^���S��č�  M�Bdb���)�5c7����
��������X��d[{�j���|_oC���2���̎����i�tt%�Z��#$��]BJu�����x'
a�Ǿ��T     ��ė+d"R���4OLn05r"�ţ���˹J�z��D	s��G�Ѐ!ER�� $)l�C:�'�r��]r�5{�F0�,���e��j�=���EC�SP��9��7P9�{~�Bo��+�SH��<�_�3�r��a�  � ���8�R��hn���}K�ϧ���ˢ��@������� �RUl��?����P��HR�SÀj:kѐ}�{hE''����!E��U���LӼ�Sz/����d�>[SI*�4d�+0%F��eL0e���t���0A�f����{Ho�AS�d�3����� %I.l��D��3�*
���Kw�m�kX��P����	\j�]�E'T�gN��n}��FWƙ�� �g8�
�����)
�pc���B�F�W2
{^.�a�2&�55LsP$v]�c�Ѣⷾn������5�mw	q�5�1Ї���% t�ؓ!Ƀl��,��;ũ+qC	�i�SLH��2~orU�\�W�A���m��=����{Hs&�T�DA
�/_8�\�@ �U��˃i�
�����>��JNF�!A�Y�c��a��H���5-���s�״�>�V���i�X�[��ʧD��1����w�%���DȀcU�,I�M��a�

��o,$�qen4�t����t��hO���~�;��i/HCص1<�#XM�O:��sIT�ɢ�s�m:#.����%������[�J�8L
1ݢBn�8q��|}"?�U��z; �����J�@�}���Z��I�._��jFYe`f�!�����?�=��WV��g���O9t�	Ϸ�Jq=�bA���)�F�8 ĻF�SBv�M�`��f5�;i�����eQ�HC�Y�:��}yC�n��Å�;"T
Y�G���w��&����\dQ�Ku̮]��ˢvIp�hȨ��,���Q�ꊙQ)"�Q��^ETԦc�l�1���&�YR T�Y`$�8]���yk�����DЀ�E�S�S�˝0�e
@�T�O�Q�-4��ha"Ӎ$B)'
� ��S��U2æ��=�CD	���]�!��v��Q��<k�P*�'cAsg4�P5���xxwP
��ɗ<	9m40Y��rH���R����G-&9�{>/~���JUH��v^+�|��I6�c�6����m�=�H��������� �|��9GrF����` R�NLR�1Ҫ>Y�	6�7�"#���gACx�MAhN3��Z��ɿ���͡�8���(��	���A@b�ԍ
� ��P���q� Bn�w
5
)Bq�`+b��G�
����H��aHy|�S�fp����A�I�iu�y���_����H�����HQ�@  ����Og� ���D׀�-��)PS��=%f��w�sq^�,�����@p���h� ��\�N�`=Y(`�1���T&vP,pJ�7Pd
-8�%b�l���*��}�5��Ab $&0i���LҹB�H�(�8(5=J���d���4�n��>��!Ə}d�VyQ�Lg���ZF(���[�PM�Ky^T8���Ae7�$0�Casp*2D+bCռ���ӈz�8��w��Hʎ��}` 其��iDzθ�<&X{�*qR�U�0  �^I����m���
ל��cc����0��X�)^,j�E�(��WWht�z�沃
P�}i��S���s���)�� `O�0&�f��&� T��p}�"���}8���Dۀ\'X��`S�-=�.
��aG���2����L�sFam/I�3T������{,���t��{0�:]:#8p[�"w�p\����P�z� n�xa� L T�%�p:thg9����+�	���-:LW�Mߧ��'��^�ʩZ�D�雅���P���`.r�C����E?R �62��	�v�j*����.�֛
ـy{���}�zt��b�5];���f��E��i�)
�Hp�B+n!�ޙ�����
	�d& m� ���X�\æ��Ѕ��X�6x��"K��>�\+�x��V���E�Y���e�R+�R��|�B���k+�"�U �z_��n�A+%��P�P�j���7�����D��=�S	*�\��-=%L
,�Z�$k�F��������;�ߥZ
$t�ޕ3��??�p�u�=����}���Z9#��)���37��9[d�(��>_D��AD�  p�U�=�\�������0��/�$E��\˕�Ū��C,:�o�����~k�6T���.$���o���O�����Ae4�\�ä3���ƥocX���V[r������汦��f�a�)6�:�D�藪J�H��0@]�@x ����D�q�OE��a� -��-�	|$�	�.l/l1R��%/&��j_.���ME��r��y��E7{!ټ*I^~բ1�͝�阉9�� 6������!���m���H&����FI�"�LE��1R��)U$	�'�͜^̥���D��L���Y��]1�	P�c��AP�k��#@C��ԯO9��$�d3�h��8�&W_�I�5�E r14O����O�F��꒸�w��
 һz,�@�qYt�ʆ	9�� 2Z�E.h����~0G��]�P�8�6��c���;�
lW{��;>�}@�P�|��{1FT0-��|%B�C�:!Qai{
����������aw�v�x��mԚ��C9�w�وR��-};eA�P@	�F��2��E@ '�i]��UJ2|O;-Y�7�
��8�
.%R4M0����3�bHټ������c����ɍ�
\��A�����0���d=�Q~Pq��x}	w�X��4  `�#�X����*eN+i��]|.���D��=WS;P_j{]<⤉�[cG�H���
 vM��x��T[r�z�w�p�8�2��q]�[���`Җ�n�#�Sst�\@5Q>�Xh���3����=�]�DQ���U$Gur ����ދ���3UOO�������~��Ҍr"G�@q��1 =�|L\���sw��"�;/~�+��c1 h�3�G���<�� �XjQLLL�`"�Ni �!GP.�Q���z�Ȩ)��l��x�$�̆�{����������=�j��i�|�L���T��sA��le�,��� ��Rg	�x�/oD�$��Be�06��HM)�d��[��101���2	븐]��v|�2���!Pw�r�۬(Yނ�5W霦RD&0@%����o"QH�v����D� "�9U�*�fJj�ae�
��g���M�+���8�I�$��'�/8�= �r(DL��}�rT@�,�%������l�"B��
Ɯ���P��0���� �J�6a���<��<<L&����.^N/���H��C�C���ME���:a���_!/����*���ޣ���$uE�'" HN�! N�����]�"�d�!$
e�Qw�/5���xV�B2S�	!mv�E��4�tv���������8�ZŖ�=�໸�Z�@t7�h�(���[/Iz�/;8�j��If���1��	߬�^�����'�s�H,h�G�1B�R5��Y��RM�ȓcK��w��b���D�%4"�a���D� ��i�LYd�O=�J
�]��O�]�,��Pt7�G��˙w�B�(@�
��L�0���tB�L� 5��{�b�������;&GF����1�����tK��	d�S��8. "����RbhI�8�`@;@	p��}vD�tL�	F_�1R��;�j�
�8Y����6��6�YR��(���.f[� h��0� A����C!j�Ƈ7��b�4��F�*�JTeT�!�z�_ӊ�
�Jh+ؕ�\&T=1��p@'jH�g��u�֕��Gy��q  
$|��b��a�C~�bwI��^�;�tM�)�7'PmkV�N�`�Bp�K����I��T����%x����BQ���Έ̱���SI
�+�G�_�����d� �F��Z2�5"5�a}m���Ѡ-l�q�X+'k�2چۄ@\�^���^��K�+w)9C���X�m��oM_����21|�I��T��ƈ�:�
�Qu;��G�q����ƌk�9�qt!���c�[>�^4�¹�"��b��.w���൲Ū�9�Et�      �p�&GC�H����W����O�2e&I��縞I؉�1�&�?��v(��/��}/��I432�n�a�8�
A��2^U�fD�^#��Hb�?��)��]ɴUd�=̫_\���P��p���,�����O����
�0P\?cVXq��U'��Z�-@�sD &5��¼"v�-��ifI:�yo�bC��څ����޿�[J�u�
���U� ���d� �Z[kMp@�k~L"�K��u��o ߄.�� (Ђ���F�,��'�V�ªTJÍ��䤒'�"_	;�VS��ǵ$r{c��`��� ��l `Q�`#��� s�+��d-΅��(�O	&�$ 	��9m2ٺĿ�_5�E��"��1_ˣ����ٲ�x(`KaԸ`��v>~��r͂H�R�h9c�}T�9��;#Fs�����-���?�z6���^�8���g����̤0��84f���?lRd�7ھ"�J>�� *FmO�j�l�� ����މ��b�
N-����a�	��S��TtSH���.��� ��T %Л�2��G����>�ƈ��Da� �����;��	6^���~h���d� �9YA�@<��<�V]Qq��W��q|���_��C�cSf�ic����h��Pcj7������-�w����*���9b@
A�C%���z-�'O��?������!����G����(<x1q�=� �ἦ#�[�9|.(p�3Kk��l�6�MG$���]�g[+� �[�5��r����>>�)7�/l��4I]����ET���!�[_�!v�t���I$�]e� �C+��4ד���B���C$�X �I?r���ش�5��� 3� �R`�3c��t�L˯���#mZ����
d�ǔG�6Z9��h�+�1��Ѡ�O�C�b�r�ռ���S����L�̎��d+��L��!F�R�AH Pr�����dǀ�4���B�8�$�-��g�����/����'XU��&��J=�[=��Z��xo�p�Ǹ��w���o��pL�@�0EJ��YI3��J����������V:���?}?����C��Y���7��RAܚ/�M'8F����P��Is��>�礋�8v8;���;�	�����XnH@W�# CP�z *+���׋�����%F�䘮aƚ��R�
�):.����j�6��if��=f����OQ�D�H� �״` ��A�>�atX���"1Z�.*� ��+	���",��o���|
��}M_5�Z�(�e���## N�9��y�\�A�!�p Xߍ����X?Z�BG�� �VN����������d� �NYq�, 9�K�0LV�m
^���&�,����Ĕ[�{O7"!��g���뙓�80U���)�"W4�+.6-��N��C՛;*���L� �*P�)G��3���KLN���K���R�D��D'uf ����G�� a�4���B�ڌ	�X3��Qh�yԟ]+�iZ�ߜ��`������4x��*��H��LX����xS�O�ӧ�3W�%���Á���� T:�#*x~@"(HQ�g�P,8
T.D$"r�ة�5*JCEth;!!��!"B�f9��e�?��&���e�E=8�yJ W����ma���	�I��T��" 10���8x��1y��.i�gP	 ��5T�U�?@0
K��>�t��'�ec;�,��p���d� 7JW���F��,1b>�c��Q#.���
n6��)�dN�i;�V-ur`�_/��Y�M�ȿ���>�����^@�1���	(��j��  �2���2�r亞C�B�BbC&��[u�5V�r���`�[}Nc�:����D�%d��H��&}}�[��:0��~���Yă���$O��o&��O�(����L��@�1�8X)��5p�#���w)$��Љ�+�E�(Ё=�_4)`�(/��;��D�j�PT�` 8�3,����.��R��u�5�j�bX�U|��^�`��}��f�YB��R�q�_/�� ߜ�vճY3&��GD��{=����R�5�*�ig�\:rR���FQ<�L�,�"�0�nL,<����D� ��y�D�[��~0�K(�a����U�,P�X���}ZH~q�D����E?Px"�i���z�����0:PƐ	4K,����u1� B��xq�q��E�M��3K6[<�.�R��?�~7e���g�?�~�;���x{�.�1"pCAx���� ��@PC���D�ʠ����3�: $���M�=�E
%�m�Q$  �1k��c�/g��=��f�x���>�('G��uy0ٳ2�"X80:�fʸU�h���J*1�Ô%��U@� b�8��pZ�`L.��␙`�!�:<�}������"����� eU_͕765�ƾ�;���ve��L�>�/1,����S"檯�����k�������>)�p���ā-В;
������d� GXa�;BA!��0�
q)]�O��,�Č �+(�E�����G��ѺR/j�
�W���f
`��e�Pua��h�X �`�h`P�{tHI2���a� }
I�i}El��1�.�c������=1P��9����Ȑ!���O�X��������yO��V�e�1�|a#EEN<�Fp(��_B� �P�0`8 #44��T	�ɰ5��.����%��M <���J����8����*Y`+���dJl� +"-@���T�a�R�W"�N�/����}{�"�����x�j,(�W$(�:R?~?���E�?q�~����!��\��7���`���.Z"�S�!�AP�
 B����3�
�;��c?ڼ �FĠ ��<�����e��!A���d�kCVA�ZP9�<$b*H�X�1+@��|`@��ŌI�Ot2�T�d��q��|�Q���k�4�y�W#��-
 Uuh2�_\ 2�!GXE %�5&`��>�+_�7Fbz�'�5WBY{5�o�?�|��L�i<����y�T�l6�y|�6ƠPjX�|��\�����W�LY�u���kH���w0u H	(4<�Ł �
Y�	���>��������������
E�Ì.H0����ݐ,ѕ�Ŗ�J�h   , �L���"H�S�H3�����w�^`�\� ��J��-�*5'�ڪUS|X��=�����V8:	XR0&0�*�H+�
���gӇ�i��P�@j���$�������9�ک�J����d���MS�0-PL$��<jHD�X�<���l00E��j�s���K�m���5�H�-RՋ�����=���(O(����`�|o��s�� 9b v����b6���7]K�m)�LP�B��f���� ��1��������9�#&�U�5��]su�k�$v�wS�{����My�C�.���r��S�7�Jx�],��D��eh��{s� 	7G�`��t�2�3N�BĽ��9�*�3�{1��{��
��������  #H d o��rB�,��AH�4���2��@���C �W��4
||�Y�ZJ���e��QT&̢��72�\�D|�FlB��O'gjP��j�i�GЊ[�%2n��#ni���d�3&�i�PMF��=�
 �[���"+��p�V$Z���?��#I}�q"J �nS\�Y^y�M���穠����A�{��إ-蔂s�a��Lh�J�s.IpΧ)���~�����O��������ߦ���������v�R��ݲ[����ɾ r+����Jͧ�	.pFwh���T��/י�?
�'�W��`8��-4�hcR}SW��,��2(�bG�W�����Q�=$��<����[SU#�|�w<��mU��w9�֭[�
j�U�ӻX���������=�ka�����kc�	��E � 0	+u��  �a���KF�bi���-]�
��`C�/�e9tCI�-cdpŐ����3�z����d��]R�k  ���
�� Yqwg���Q.� a^mE$�	��1p-���
������(��H'��$<�V�C�tt=FX��Nr��!�ۨ������A���5���<����dG���v�����
���>u_�W~�Z&/}�>۴/]�v�/$kS�|)����L�   6��s�o��ʑ�tVc�C3�"�۠�����QZl�
 `�S��ɱ6fj��U��M���R�:L��ɘ��H:t�cD
&n��b�2d�L̷@��2��i����Ih�tN��H-#3E��4�p���&&�u��T�����F��v�`  ;�����lx8�tj�?:�0MN#\�cU���œqn������1|𥳐M(}�R�h4�����d$�c)\oa` 5�k�� l�k�0��؂s�����6ĵ�.=��Bu�oMM�z�m내0 c  ;��������w���%&��3V�M������YGO�CN�Le?�RD  
�ʧә�%�E`$`3/S��c6T��,��=�� �Ȭ��+�'�
�>0;_^�P(T&��,��V�.$�K�K1��QZ��i�r�@��$��@�?����x�$��A㧌	 �����Mɶ]�uzH�H    
�@+�ȑ �J�m�f5p�h$_��@�hN��h��@�4"'��Bt��r]'����B��8��/��&s��/I�@��?�u�W�T�QoAFłMh�����c�\	JD@������d>u3��H�5 �
=����k�<������� �ò(���~���޻׬�� ��_��-���,�
iR�
�`��@ 2�c�2�1��&��GAK*1À��T������$�r$8YaM��y� �E���:%��ݮ��[�7ƹ�Τ�ϸ��(�ë�����٬syo���Ja$H  
`�
��U������܁Ae���U>Ԭ��¢���� I��H�  �	�
Vde� 
0�A�jt���
�vK��0h�.��P�X�%�Hnl��2��h)H�"lJ�ǔ�l�������+��� P׃�η<c]����4(A3�!�;���|k��ȝ�U ��Ə�(�Wd�	)�aM�1B!�w6���dM6*�i�b5b�l<b,h�c,1&�܅14���
JEYú�<�e��a��&��������]��L��>pTx��
�G?�D��>�t(����w�Oz�zI#B�8��5�&qم)�1XHc��Y��@� �
��D8�ג�N�)��\�H~@�����p�6��<�~V�,�9B�����	
`   �pr��JAWf�Fr��	t��WI�ܨ ��-#�_(2����0��,�K��u�p��$E�"�a"v��F^�(�O:�B�l���q������ܤ��AH'%����0Le���2_�`�'˪,z�ٲ��  ���<%?�uA��e9dkhL�pt��mF��;)d
`��1�a��X���d_�#%Yi�4 ,;�$`E��mm��l��mt��� �W��AEښM��g*-������ׯ���wIe��!�QC���Di  �d|(%L���Ġ�Z_f�}E��o
��?M����ֳ�(ؒ��GO�U��	�,d� 
nLSe�E8�1	��i��h+N
�0�Wn�n\�i(XR�Vr*2":D�"�e��p̶����?�m�z�+��������N����~�c(H r� �Já f/�c��~�ʽ�K��E�<$L�?�������K���1J���%�� '� ��T"�#j	������B�`;�
V,;�~�Ӈ���Ȍȕ8��,:�!�j�����b����[C��-��|Xh��$��H�@ �}���d}��i�R=K]0�
��i��e@�����R�� ��
�ڦs&����HaL"��E�K��.c���ԮϤ
�{���|��`�ީ -jf   ��yR�*��)�H��)j��%3��
�� *�N�>_���6�&�ʐaK�|��dL�8��)E��R[��Π 1�B ��F�<�G ��.�d�̨,��U�Rr2SՐ��~p  c����y����cEwB������zU�I<yBH 
X�����V�ĺ��Mә@�Q�=H�xb�M�T�ac�Г*�S�zo
#�&V@� ��yH�����F^�qK�N�#�OcR���RI���+�9pE*��[+:Ԗ4��4X4z�=h��v-�N`��ID.�-���D��L3���`L&k,<�<��_��g3�-��	hBGtUV�   JP.��ɢ��[|�CdT��r��.z��|�8�\ؙ������o@��;�����Z��;�#_�;�kc�h>�S�  a���d��Z�=�1S"M�K]MU�������v���$=�T�^�`�"i��_{j+�����T=�e�R(@)D0~5����M]8$M��!��3_d���H@h|��  ��˓@�����@�<u{�
�<\��Sm�?U��$��"����r$�'I���d���?o�:�?-jQJQ� ��@���������g�` �S�w?D�5��s�$IZ�lpwm�)t8QPu!M!*L��S=f�mY��c�h��'_���D�2m=X���L{	="^	]c��g�0+���'j��A��(`H��xX<�`6[���Z#�\D���a�i��5��$s����D�A:1XJ6V�x�W��J=���c��3�
�Nt:)�E�X�Y&Us�B�1����̲�]��1���$�b�uwJz���`jX�bo"|�}��h�B���B?�L�)&s���#O�zNma��!аBh��SVab��}�e@�i�n;�	�c p6أ;�1��j�%Qh歾���El��6�%����T�W�kԓ.�������7#m�@�?��1XD7uaqZB|I�au���1{B%Y�+F�<��L�-`48�@1�����_����#U	��,�MI�#)�a�s�w4�l����D� hYi��M��,<�J	\�V$qA!�-tČp�8�.�LV���[��J��[�TI�
@#���:�&u��:�9��vD��GYG�&G\m�"#1�(� >�,���FG'-�`<���U�{����mx3i�tʝ2ǝ2�0�\&�*M�BX+j�/�����$�j�� !i
�،�x�r��	Ұ�����������Hg��i�.EӶ���G٩;��!�� yzE�	��(��o��� � #�)� q$�b�t��J��w3�Ȉ��UlN���a#��UW[S5/��ߪ������������uN8��
�t��<�ys֏�G8+�P���x_�@ $�1�S6�c��&�1�H�˷7���B��V����D� H<�a��M�;<=(<	HCs��g13k��xt�1V�:���eDÂC<��R�9��e�y�`AQS��q���mM6 ܎Ay&��E����d
��#���_�&7��n	���¿P8E��le����_[}F<����Z���(ç�?��1�;���6��F�OH��-��\Q %:�
��&�6(�b(�x���JlM&F���+^�ka� ��(��z���<&pP�c����8+�uFU��9Qn'/�e��  4      Zq�R)� @���9�H8�E�q%dF
V�B����)�����20ɵ��92�}�q��مR�'uDV��`L����5�/�CM#;1T�Fz}��z[�a��Yf=rz����D�	)UKY�ZF��=cz
Է[�� alv�� ���W������7$��~[KR
��ͺ{ݭOI��%�|%��/ť�Kv�7�,�w����j;PU_����/����߿�������K>����Z������ @   �Ј�Gc�d Ц22"��0��uG�5X�ݛ�B��fE�W�<Y�}��9%ӥv-g�I�A.���4�f��A�ut�]�m:��n\��$4�ى�d��L)����kO�΍:���y�ߒ��^Lf��!R��/�Z\�o��A�!N�Z[�K��[�Sy˿��;��SP�ט¤�/eM��g��s��>�~���K�W�s_��Q}ړ�_��~��T����g$4�c3"3��x	�*7L���0
�!�
�]ƀ���D��_R�g  ���E�` ��oeه�
�.m�0��o���tp4P����@G�����Q����O.�1��t�Ժ���\�+�n;�L*(�֮6��&�;#�#20���<�g5��-���`���R�x�]hn�{f��3�I[�3�3f~����^���1�8w�z׿�u��
nڼ-W1|���e3�)���!������"+�y��(p�P��5��6�_XC�L�C��������?n�G̥O(�
�.q�o(��?�)�N���:��pʢ��Li��[o�2N��v�M=��35Va�qW�I�E��Zj;/�L21'"C?�Fk�-}�8�~m�^c�7hc�������@פ��7z�$�z�)B  )��$c�Ct�;�����d
�!��<�:!\n��mMm�0G�������r�V��<��(�#��,D%M������;�ݘd�Wh����[�e)���;����N����|d>.��wE���SP���l�"�xrf
A�&��mW��ˆ�����mo?D{(us�����#�����Å /���Cm��D �m�8
[��G-� x8p�Rb���bu�o�_}�o��4+�;	{2���S*4uj����t~��:����J���u���c�a2 2��I� 3s����Nah0�0 "�p"� <v����*��\L�mם�u�-�q��27Z��� } �<�&�hZ�%U &h r\�h�B�/���Z�'�YY���2}��I�K?��kJ���D�ߪ����d�
G�Y�+�?���<t�59cg�Q���ĈОg����@�ލ���Y���"ST;Y���~�_���8��V�2��z�n� 	),��6�g���^��6�-�;5���?���Gݻ�?�O�ٓ�1�#����6A�/~�("� ��	���r�w��i7e�� �U1+�I
�'���J�ܺ�(���^p�Y��������O�K�w �wI��1�h�q��O�j���)Y��3�uT*5�}(�n���� CHRS�d�<���<	8��6K0�����I���F�MI|��c��6��V�F�B�wZ�;J��R� /P m���Հ=��s?�0�2�M�"R��b�%�
%4Y��6�S���.�鿼N��Ф����d�cJW�	�KJ�,1�"ġ`� ͉B���	0��8.
<p<h 8�cc8((!��G��T`�@3�>��� 7���  #_�f(f��O�D;HH>���w��Ү���B������:6�ul���-;���Dm�%����N[�X���C$C� B���L�)#��Y���Ӑ�HuDÈ �q��5���6�\��W)jYDy?ֲ���5��É34�g�z�e5��~��|��17[w��}����Pʀ�kD �$N&F��Q�Y�B60�,1�gpc��c��2���R��߿�w���2>��=���1�h����]鶕�|]�* �$F_�`����6^��Ddқ4�m㟹Z=N�"�uQ�>�3K�'�����d NDW#	pRj{<=�M�Yc�����|�p���|���?=_��O1K������_1��<GW��&ļ��8�92[ye!�έP��T� Bv�2���j��b,�ʴ�1zǤ@wgk���N��l�~�Z�،ȋb5L�%ٚ�{O؟����=k��l�셈����4�Z6� ^��1�����y���%��~t�q-���z�� �+n{M��t�ة��Y�fQ�z�a1���*y�f��(�m]H�]X�Fj
�tW�>Ϋ�V����Qu	i+A��4*)ƈ +�4i�*� 
�}��ٶ�Duuc�uW�n�.����=W<�-�����������_����}�ϭ:j�Q` ��v,����-S���Bbn�D����d��8���*`?b;o,c �gk�e�҈o4�uW]�i����7�a��fI�T�Bm�Ve#���Z$����F����f*�RL�w��zh2'�I�"!��  
S�`:
u���&�	��?���:$�8ȴ]��X�SMsTP��&��@$�six#h T�V&� J��m�Lg�F��O�!ʊ�6>�]�F#�{��ַ61���µ	��N�����]�����|������6�F�8d�~� {F,���J:�z;+@$&,Ĕ\�vd��:G=��"�4'G �\F+�����*����B�����(urV�!:���!��U��gj =* �:�*i�E��B/�
6:���aK킠�*��̃�P!&YA�go�`����d& \i�K�6b�<%X�gG�g��0�cD�}.��&(l��
�"!YBHCPŻ��2��I��dLO�/t0ۨ��r	W?��勪��NN"4 Yr�T���	  T5���\�dl��DP�$������!�tk{-V��K|
a�5 �Ci���lQ\���?�������=��E�N���� ,�t;K�QY ye����:%�. ��'Dg"����5�����2i�u�
$$�&X
"K�L��*� F���p�z�
d�`��>4�'���G�|t�̔ן5��1^s��2�W�F�AÜV^��RJ��@�����u����h]��x�s*��� 11^�=f�����������d; �X�`4�L<"�0�e'�I��
m����bEJ:��À�JDBa0��| �ֱ�� (�)�,�����'#�j�NR�z����%��mU�S��T[.���{��B����?�|�i�[nt>5��n�ϊt��a��z�0@)��w"�@$W}����}C	V.�M�&]!�X,	 �,<�o��Ӣ���O�2F��  � f�Q��ؕ�|·�(#�r�]gƨ�j�Zn���u�z�ڹ���������'4���r.cK�V�����"�(F
OC�E�撄����<ؘi�"d�`t
ݽ����;�x.�hl���`㪂���m����V�r݁T�R��%�ʁc!ŵGA�O&����dX ��SZP<a[\0g
�Ai���lp����+��ĉ��|ԤZ��dPH���.<2�(.�h�H�>���#{Csކ����hT���ϖ�ܝh�q'����&�PKyYT����vG��P����������C�D��+���!���i)�xfH)�,�#%:���2Z<%A���o��"ip�P�x�̴9\vx��D�	�!��q��B����gl?�������z���Y�  ����>�dL��R�M���pim���H\�V�^	�M�5�F�$�w�����^��t*��c��qZ�t�I��`G
E?�����g�F�-
��N�
��4�&`P��m�J�Pn(�]<����dk ��i�1R*��=='
�e}��pq�l�ĝ ( Ady7lR"���S�6�'���L�RP��(v�)q��^�rF(��s��@��e$��X�y7�+ �Ð�t8��Lh"�H�'Qb�&�,���ǧ�C0�.G�~4W�}5�.�F��T@k��e礶��l�X�(�\�E�������V��(��N�'�����,�.nh�^X9�EY�nw4b��O�&[&�2�[�'���f�	�_������T�A����
���;/l,��x!��"2#�y�#����� �)e��X���5�Q�̷55�]�e�XGEǿ2u�sมv��Уfү,�@���e��   �iSW���~Dž1 {�.	�m����K�v<���d���*���B�:C�-0#x��_�,i��+��ȷޠ<��
�<����׳V�
6� @%A��k1e�ю�������/6� -���H��ߪ�m(�{��Zx�"�lс?}�����0�,���~�.j�E�Q���_�U�ʃ ���U��u�
���F���fe�P�9`cmcu��Hv�Qc%sܠ��W���r��A-�W� � �K^/�V��16a}�Jϲx�9��<�����/V4�i�����W
�vuA;R
e9mY����Z�
t,��6��H �e7��t÷Rm;���P
W[u���VMH��KZ�ʁ�i12�鰀1�e��/T䓆#}�yvl�u��z�P�Rrk���u@�{���\�c���(���d� �*��3�6�="�m�=�H�n0�A��1"���Q��GR��*�ff�y�.��.�j�B�(8T'�<\�z����s�N@>0Em��d|����U:��i0u�Թ�y3�
f�3��5۶,Ú�t�D����􉒨���vZh� ����1�yY��9R�R�� q�1
$X�,D�ލ"(@L���?&:䜝���JndP�b�c�X:��
P�ҁ�4:�J���S�,���Y�9ԺL   F�@`DǳH� R� 0���j?TR����@dǈ@���)����RH�?�� I�* ���0�-�(�8
&f"�ǥ��騧aa�,���@�.���w�D@���,oo��MJ;@p�������d� �$\��5K�=��l�_L�k�֎ke��Vx���"1�9�8�h
y��PU�.��	��  rP,�y@a?ycՔ�����m
I�l����AJ�!���}=t;,��H(  ��H�lh�%�Ft�Tlu٫�E
@2)���D)�����eǐ���M|A��[��p �D?��2�2^�c)R̮mTv��Ho�����&��*z�� �*�cuh,FZ���1�v�����䟨&���Y���ȡ����	�#�]R��'[j x1��$���d����h�lg��,�ȝ�M����J}kk��^ ��7�Fjcj1ɞ��#_�!��9��#���DJ���@6yp  �D��u9�B�w�������dҀ($WkOH�5��<��WM�S �k	��(;-~�*"��� }0��$o�q���\�#�����X�=�"��ve�^�9;�C7�e?�e�;����f��?8*�CY  Y�f�
 2	�9���?�BY)������;òٕ���l�F��T����O�tC��I�5=���:�f5�����o����6����./[�k�H6� [K*�����-WJ�ɜ|���	�"�
�b�6o�|��u\{QㅔM�7��%�wD��v��螖o�w�C		�o@�8�)缀�ms���F0��E���`=La�[6�����Z#\%8:y;&/�~D���"
D�Qv���xac�c�,�<�0�C�7�.�@B������D��.ԳO:`bJ��e"n��V�<��|멄�h-���`Pe��d������ô��p�|��w�89�ӥ�ܺt��d)$P#�Q�.(u�����p�(�RRQ�*�����m��k�z��X5���X��m���R&h��@�C����l˖�L��ܡ>8]t0tÌ��`@ч�8`�)
��lH*�dhj��4�Y.��8t���.`���.qs�.?���PX-K2�kΜ.��\:^/��)p�w�?=�(05��)��
A"��
�ʶ̎�:�O�H��I@  �*����ȜX�s��
�*�|�KSUk-�à�v��D�(,�E��et�#��b���E �B4�� FCD��\���[��r�"��
4�~���d�e=Ѓ���C�+M<( ��CJ-����j儈X����O:�G�i��h})�yO#J�J�b,Ho��-s��?���5�C�'�2�DӺ����5���?�"�[���g\\0L"�  ��%�GłU�4�.K��Wc���e�ڂ\���O�c-d7����M���!�H>-�HI�?��I������1��ek;����?Se�VՇ'"�Z�W3:l�1b�A*�  �#�|,
�xF�*Zd��аְV��4�h^'�4=�k�zsH����
bt�}y�$���I�y|�f){�������c��,gW�b����eI�.���  #aG�p(UE�a˹�:���6y����[!Y�&��ߵ���%�&���sB�h��x���D�#vFҋo;th%�i�>
��H
<Q�Þ�%�� ���g�!yA�R��qa��Ti��*_.^V${<�oթ�*��u�䱤QY"���F��r� �  L=��3�T�Zb�P�j�U^ /�@�TP+d�=�NIcn�c� l��|u�a����P��Z�����D�*X�UB#Y�A��tA##����Qo�R�.�g}Mu)��A����&@   XE��.�UNe@��ۇ`vc�/m�X�Ț��?��m���Ɉ���!I����܁�b����6����;#��O��X��N�+Կ3��?�s���"�O��G�V@-T�8
��]�X5d~�P��
d��{�������L8A�D�9�Z"��\���删��	��x�O<\<?������D��#hP�K--0h�j�a%��mF-@Sј+*e��`��.���8|���/��_>�	�s���(��kWd��2� ���.��e]2}3)SMt�-H���D$�,���t�`�*+ܛb9E���0�G��&p�s�FPu+ʄ�ї�Ff�c�������.G�������~�UЀF   ���2d�Y��'�B�/N'F`.��C
G̐sɠʫ�A�����`^/��#��<�*2gR����Q�K�>�׶�$�tgUɣjN�&t��r@&   *����צۤk���t�
�~�����KQ��~��6'�����'ʄ��ޥ�p��Q�?�r���d��v�+���ʿz&�$�&ͦ��*�������Dg�C"<�K/Q�[�a�L��H�Q��*q���h�e���YM��I_/����$�=}X�n:��������y|�C�����]Q�������.5��d�3�ji��d���-��/� �� &$ M�TYk�X��L�)�e�ȧ�����E�^!�cew�����b�E�V ��WR]� ~?D+����2~�+�C���{d^���������U��2��H_eIL�O����t�����dE�͍VX����2 (��fc��s?� >�ŔT�{#���C�^偃.� \�@�A�o/������ � �*^:Dve���;t�`�x�E#dc���,2�ϚA ]�n��UM���r�nB�\Y����DP��.Գ,@_J:�ae^�[����e�,tĉ8��UU�������;�gB����N��8�-�H�  �vJ��x�'#�Xb�d2�nF��z��;lsz��XRJ�a�"xY3	.�k�̯vgsg��a��v����� *:�;o���Dq����8�&�`�t�-�x���8�)���iD���J�M���2��.FH �&V��P�,R���1���:**�`�.��3Z��P n���a�K�C��Yh�!����b��(���8�����l
��4^T�Qu�
�Yv�":Ɛ%�:��8Db2b����mk�  �n���'���H�6����ˏ��CL;*��D�$����v�3���&�����a0���DF �V��)�Z�ڶ=I��WL<K�h,4��(@I=�:�?p&s�~닏�\Bw�@aN�|�c   ���EQ�)S~L�q�F�9���5L�J��\���%������Y&�������yp�����'�!�������O�D}���ʽ�:ˠ1|�`W���yLI��i-��;�<
��Nф-�h��p��-��J�j_�j&�8� e�3X������S�/gS��P\8��`Յ� �����M&���p�s��D���u��Lx]"o+��T\���k�us����70�=��}\)��E�w�Q����}�s�qO>rED����  |.D�0�Ü`!�	J����	���1�2�����!����DB��=ԓpS�z�=%l0�]T�	T+&�p ��H��_���C�#n��)� U
~�^���܉�xkƟ�|d������ԋ��|!���A�ʸ
Ffz�0��ty�'vl�$�fT�Y��Uܻ�VҨ�o�B3�p��� �������v�4������`�-F�L��A	�*P���A*�UG� � GR�}˜M��-��RŸо7-�LKo� k~���(	7Hx��Tp���Y�JW
/�Ƥ� QI�m#n9$�Ep�>�XFE��	R�c$D�_F��M���:C)��́-�БGߥ��-9ސF)��Kq��]�}m�~7���_w�*M���h#��}���{�f�<w1{+V��L��+����g_�}ڱ����dA��]X�? _%��Ǵ 
9s8�  ��r� �'%�m��z���uvsT��L�b��X������������������>����1�~
���O�"���v���(�j%�"��E��+@��<�3���l����'e�q�[D}d�5*�g�����pZ(�<|����4��EE�w@���Ì�a���G5��"��Ҕ��N����+��8���HީvDɧW!����#���p��N��e�E_��N��0Ǘ�+o���J�릯C 8�0Z,
���d!WU��p8�J�� ����>Q=�Ϥ3�,�~����ש�$�
d�}6U��5%�Rs�{�U�X @ � �!�(�dR4��~F�����d�^WZo= 4�|���=-a��@�1�ňF+�ل;�"��*�fU���8��F��g�Et���g��C�Q#?�h���?G5���S��\|�37�M�Cs��J�P�QOk�-kla[z�Qd��l�ESj&Ӻ�,�Bΰ����.P��P~�8
@�F=�0  <>���cb�H�2�d�n/��'9N��l(R]�G 	vI���`�A �01���7
�8`��ddv��ё��;��b��ÔDȨ�cX��
�ye�$��B$�-*������}A�뵭<�,�����(�
��_u��L	���� �v@ ��&�(_��d����Թ,���cT���ڏ4�nP����C�SD>�[h��B���d�*/�I��;A�0`}`��G@���c$ �
8�`������uzpn�Z��������F���y��L�_�!��M�
d�
�!%��L͓�� pkW�ؕ����p���U+-�$m��o��)�A�F�@ �\��u�� �8���J	^�2 �������t�Y�:A�΁���
��   �(��� ��`�0?�4~?�
�p�%�46�s�۲%��	�F(�@ 0$�p��
���(�!�W%��. "gY����FYED����$ �D�@ �C���[��9��U�6:5H��YJ�b�v���w)E��n�P���9h���(�a�f���[+$"�s���ѡ����d)��/��� :"L=<�+��e��I��-��HTm��������� ���	�q�U���-s�D0��G��ְ�����՟��1�0dѴ����O�w�B��  .�M87M��h	��-	+�D�H��
w:�:μ�}YPU+��#/6���������U��fF�V^��(�Ek�K�����IM�I;)�
%H� B�o��,N�P��Bg���!�ސ��S>B�Q��X�ѭ6���ƽlV��U˹`�   -X��d�
 �1�sY*Q�
�	/t텱Q���[EJ�m���/�~4`�;�c�q|g⹷	oR����B��^/��������|���d��K`�E�"����Y}�����
�lJyNE��,�����dA��NXY�r9��lP�-e��g��0�����ŋ=A�h�X8Y
1	�<�AM@ ��F�d�"ФZO���������'4�փ���&�ʵ�������hV��R����^�?�F;d߅n����ʘ6J��c�ː��t@4 (�<)��m?��	�9���M[��E;W�z��������6���W(�0 �� ��3Ja�#�2�=fA��JZ���fE�;�F�9,�)!�̪T<��G6�����0������n<`|�q��
H�t�l�^U�t�#� 
�'�&%=Q�{����[+�����Y�h� \]�M3e��`@|*�i �%�� �����v�qUx��X�����dV��D���06�J<(>P�cg�SHь�5�2(�Kġ�N�����
���n��s����
�60/�S.d� _�"O�}��=�W-a��+�P�b Ԁ
:_�;_�J����9Wo��ꨵJ3�ā��(<zC��ݯ����� Ut R<�O#N������M��%��7
�
�Rurc���-F
���M�zy�Qr��e!�Mq��H�d锩�Iƞo�5�8@"k�*Z ��F㯻��;4�Ic�)4?��=q���`����E���X���d�{���ri����q� �xs�AF'60�k�:�YrvAn���;��Ҋ]1Si��hs��;�������l>�j)��R��g��~dގR܌(�n������dt�	$����3!�,0��y)g'�S�邮4�� �zě�����	�  ( 
ȱ8�lem+�D=��]@AO����l�EV-�"�` @�J���}u�p ���A�qE����z(��-�yq�wǲ㧌B��$&����Z��zr�9,�k�U�O�a
�|��x������`px0��P��	l<	�l�������G�A)%���}Xf*�@��0iN]/Cފ+���ԩB�\�.�]oO���F� 
�Ob�]I�d�$	!$	��g�a}3/${
�6�W]�<�x���t6R.�j6d\�:dbn&�4�Z��'�
 X������*bA�C�J�z1��"ވ�^�����%S�@0���<��l�������d� �DW���3�[I<��c'�g@�����p
�f�9o=(zB�*��Z�I�#�0��+�Q?�dnq����ҤyY�xd!��M�{��������B�DC����"���dr�;�k-x�fQ�+�G����pP�0,̅�/H:}�X��aĀNZ�t6?��j?�$Ye t
ނ �	� tMJ���LJ�x�,�A	���fzCf"�a����%��(T2̩�rX0`� ���p>	`w(pu�rG�z�'L{� 76���tN�Ѭ�h6P@T�����훝:%����4�8�@� ������D�+R-Xv BN�W���7-	)�ִ�&��?3�b�D8�Ӟ���
���'a���d���&�CJ6�[}$#`Л]�R�Ԉ,�Ĝ0�EM���a��+���l������:��	M���
3&GɗN��W�'����������[�}	�fW�z�X`�rK�	b�1)��gA�/���xӔLI
:Հ`� ��I��*��Z�Q���fD�_!3�I���;2`X�Z+��YY�N80ch,���UQ�W�씠�6&�ծN��T�
�"��F����� �	9��] �5$H}�`��&����	�@�3<
	<�L�������BB)�xI*3A���P��1�@��P��H�.�|��)�И7��b�%Ꚍ	Os=!H�+�$J�3��M1q�
�ܔ.�P9��e�K��}xB   
`+�)�
h#�@�ѵ���d� �3VC�4�	<I<��]L0I��k��
����o1���n6يO�p���������J
�Gѫ[~SB3��3� �L�d�|�Q��|� �cN���p$G'�0;p�Zw���Q�q�v���%�O�^)~:��_A�<��#J-��3|�n�%����qq<�ȡ��P����TG	o��4��HC�c�B��c��У�ھ4W�<��b"!�Ȩz"���5�xء��j
�j��,"h�j(8!yBH��b��[��  
,�GI���t�E�
T��Ʌ�,���9DYA�ΊB`*A��J ��N@��۬P����r�u�w���U�ɊS?��*�>���G�>�@��J�5��Y(�H����d��3�a�@@#:�<�>
E_U� O�k�P �D#v�?��^5A.�	tGB����Ov5-�,���=;O_	�r�]����+T�Yݜ�Y�n�f2�ʖ�u*��-I�~����޹��r�����.Pݹ��ܽ|  	  aJH  
��61e�3h���K%�G��5�ÞŤ�˧�߈S0���)�^Ks�*�����f��-A�̆�5-5�Ն��^TN,2ݙ�#���7Y�^�r��H��v;ָ�{�݀/���[-K�R=��M�ׯ�q��6�gn;v����ʃ�����'������������o\������R^���S��_��׾� J�Z31   ��k�r:f'i�U7i�]F�(Fs2���p3�!�D�0���d� �^�fg  ��^�` �wi���	���70�����|�\�>�@>��c�:!��X�W�-�6_L$���B]��J�)(��E�]�㚍�ȌޏTDP1+Vbٓ9۹%��{mU�,�y|�w���z*#���^�ee�|g�Z��hy�^���?Y���Z���)-y��;�0s󒵶� �H%$�v�<��Ё@�K&��̵��)�¤��
�
o�f�7-�d�_��Nj��{�z������S��+�K�Ðl*��T�-F���"��V:~�u�
�	0�2^�D�F-���$XY������N��@  �H:%�k/ӆ�7҈^����t� �a��4�Wi�xǄ�ZX�1�x�Y��檇�2��
G�,FbZ���d#� "��a 7#̭����o��o@���İHr��>���f�_?��0�]F���H�_���v k8��}� F�*���2���������+�3��BVJ������($H>,H���~�  .$�l�8�D��
�b&��-t��7E��Ҝ�x�Xf}��+o7���y
��(G�rK�xf
H���E����$A,&2޲��k3�   @F ���I�E������ �C���A���	`yO�m�,T�@�!�[���rD   �F�<#�r�,�C�xP	����˪@��S]E�M�F}2���Fi�e�-�6��K�Va�mN�^w[1�c�=�h��3�_.�c����q���>���]������1  �  DX	�(*Ƶ��W����d?�9-�i�2�+���1� ��m�0g@��<�0����֩�h;��"40���]k� zNM����`��"�"[�H�g�3��B�ԟ�T��N��)�қ��5 pƈ��U�!��$7X.ӊc>8
�8��HĢ�4��fX   ��ӏ����hY[�o����
��U�����8\Q�߬"����H^��   �:.eip:��P�8<&@A�B�RF%$@�Q��Q_����:*
@qY�H����Eg�
�'E��h\"I��~�_��'&�}?�M$_�ޅ7=8nzZ2����ue�)���A@kM�S%A}`�ʞ I���8?�?\����I.L�R�Ruձl*0��a� �*���dY#�<��I�7$�+<�2
��_L$Q��0�PR�8L��b��f�:�Ap�����E$�SA��$zGS�1H��D�8�D��$Ѧ��������Dp��y?rg���B� I/�2\�x��R�@���d�.m��%�@a�p�)��C#�X��80�S��� ��;e�R�+;q �Z8�NX=h�h�;�y����!��    (X�z���Pl,�V���5岕����.?]���/�`��0�^S-��L@�0����y4�=>�D(��"S钓�$���w{�97�G@�qV��\�y@���2&��~�"G���[0� HcFj�S7��@rwa	�<| �
��1P|a@��(A8����ɲ�����Y�F@ /͇��R���d[��0W�J�9A[}-�
�YaL$O���� ���vS/w݇��Gc��zL�Ă���g=3B��4{K�왁�&�5�4��e����8��g�<�c!c�:�6W���""���ET������m�������J��  p�#�HFhu�c���~��[ǂ�x.À!g Ps�,.�J���� ��    ��5K�=�$�����,�Q �K�s�pM�I����HQ=7�{��B�HRr$܍]� ά텘�@�(K�(@���E}Z��1��lAf  �$0|<��מm�nV
cN�z�y�/`>C����2��iY�y,� +
5��  �������Xp���� �G�h�h��+�]�~�����#�����dc�(X��+p;Ak>0"`��c��@愭����¨H��F�c+w�����O(-.r�Y#�m`�(]hAQĆ�8 �f�ϱ�u9�n��Eu%H"�X	��E��r�R֧�����M1c��X�|���&^Љ撃ԉH�c�?Z�   N��ʲ�XO!�?Gi�
�A��	0#hI�Z6 ^Zi*�qI�9�V�k��j��e��G՚���ubc!,_�^�SC��3���!����õ��$ ���=�V�Q/#:���)̘x����|hl�!=H҉H��e!��Dg�� ��@L r��0:���zv���z��;L2�Bu�����T�p�N`������C ���I%>s�\*������c��\`�8���du��"Y��B�=�ˍ%�h{cG�r@�.(��t09*���"�q� ' I�)l:΂�4���/t���Pm��HФ $6<��!x���(f�   v��
=���|Ut�[.ͅ�H�E���#�4�a��XB&�쥙ʱ���z}��H%����"��-t0o+`>T�㉾��mO���i�ꐼ��� ��h�i&��VWW_ �y��*�|�
j�W���`�0���S5�}j�����*���'��*C/�DiF����P��<H����?M�wu�9$I9����:�*�T�3.�:-��b�V�םG|_+9A�AB @H��=`��i��Q` �К��*���R�0`�P��
޴�I�O�pq���d��-W��4D��<�8J�}\�=%@��觌�A����* �� "P�������u//�����`*�L�S�8332j ��~f������y�1���n ����T�"*,���zYR
��<��|���2�%&)����i���k����m])e�X8���)j#��Ʌ���n��pu���+�3��Ҵ���J�7T���w-�(tOT�H�쒟�YB@���wY@|l�Hk��E4$;���L����BU)
W������IPF@E����49�{�
qF�w&��x�IK��i��_m�!���CKB�� $�rx��4�8��z�����2� 
wP\&�I�n5��S�ߴJ��eF�g���)$�h.`����D�"b'֑�pH$��a�8I<�Xl0g�0�+��
X��[,an�ic'�*�O��\+rτ􇏩ĚwQ�w�P  D��"R���+)M��Q<���B�.�4ӄK3��|��]�>�;,E-dJ�hPD1�C:� ��-��~����Z�I%���4@�B���Y�Y�����˪J*%9�!��Y%�R�E��������W���p�Jwჩ�������	��'�j_C!��B���s"D	'B�03��!��R�ⴋY&$ �1�, ���>u����xP��@"tY�Xf�I�� wB6��G)�<��i$X
Q�%�Bc�7��$�L�?h�'D�D����h�������N�����9�`�����Y��7��*
RX���Dbe���pJ�z�=(J	�QeFj�0k���K��"Lĩ.�Ea%�:I1���c�`��>8!�@p@_�|�wS:s%(�B&
"V�}�߻�����(Q T�v�"Ʈ%E(�	������H̴l�ɼIO��������T�ϸ���QqQD�4E��ᙰl!����9�讠��Xi�N��� &���i:��CM���5��fpu�P�ĺ�ׇ?�V�� A�
$��c,7��^JvW�* @ !�3}Q4�2@�r6�S!'1�#�+���'�	I�,T�%:�B��\�A[�V��$�`��t�Ň+��f�Nr�-��3�����& �
���a*�S%7"=L[�0W�a��[�V[��|u!�����d؂�>X��PBE�`�X}_T�  ��v�P ��C�4<�P�fT������5A?)vl㪗��6:L>�z���Jh����Fq�l�����gS�����y��������������r��%'�^���`  � ȥ�J��� �����ꃌ$�U�����l� A5!
�biӱ)#p�yG5#���*��x�R��w%\�J�4�O)e��#q ��W���V�!��,�M,������G̭�k�T���� Wh�Ϝ��:��S�j�ĐZL^���u�������Y��w����D
 ��iD9�	$�F pX�0�VE�B`pP̙NC=~ˎ��eI���:}
��T)b�.��n���/�S��TP�'C��S4�m������d� �]�.o  �+�I̼ �wa���
q.��C�͹�n��Z:
�y�$�K�L!m�Z�=!ˈ24�T�+�!je����L0��JE`k����QýS�w�9��^ޥ��3�!�TچCj�a��z4T
�vC�xnm_�K�Q��A{�P�
�#@��@P_V�d���&l���R^�[��O�ؓ	�RF�Q���^�7��A^SG3���h�
M��>Wџ�f��*tM�8X�p��x6�Q����b�$eɛL��H�� bu&oc��AGd=X�t��
�[�y���t.�V
�&�q�GЊXD����Y   2�9���"���>T(�I']����I"�mv|>v^7;�g;b��O���$Z�Zv�D�N�k�������d#����<� 8�������g'�pH��pĈDU�ON�N$&�q�O
:|��ݡT  �[I��]Z	�Z���~�N���+1���1�8�,T�H����kw�&t ��a�� � �;%a{����؞UT�|v�М�hF_>�ʪ�`v�$W�L�LݻeX�?����Q��~Km
��1��i=�a]a�����kϝ�@ �����<�Fo������$����b�N�R�?�s�X���Y!��Hq`�R@` ��#�^�	�V��|�9L���W�` ��5ۘs=�x[[���p#}�~c<f<~;����=��L�i�"I��#������TM1|9�X����Oɿ]څ5 -FG�(C2�����cA�����d> %1X��+�:a[l$"�^�$Q�˂pt F9e�x��$7U��r�Z�zI�Ap�2"(e�"�nj�*@
��Ia�l�E���Z[Hp�C��6H�,B .�L�,U��k�㰌�T>�������I�:_�M4�G�ޒ]D�I�G�$��F�Ś��K��2m�(?��Ā(  aG���)��`2
bU�	 �H����! �ZnˡS
P�P,�
")�Ay Sf@ҐEYCd��g܈��έn3�g˦��{*)^����mM��;�Fɤ��M�S�y����V����X�t}�~|;jt�kj\㎍�Á���3���B����C�� P`̣ࠪ���m����"&�%�"��\,�ԝ
&�L�Q��Ш�f���dS��ST�,p8@�0�  �Y1(A�m��%�VU��cSk�@��w(��� ~�@H�1,	�� ��zЏA|�M�HY'tȏ��$�D�o�����s��C�=$G=���F�]����h������˂פV�+Xh�:՟�3�2���+`���d��?��)��ߋJ.��6!
�:�'q8@��z��#ȓ���Ĉ��q+�T����� �舷E����mI�z�O"�P�P5y$n��4N�Fv����+�քv�����WvL��m]�Cz��׿V�ri�X���_��W���M<�I%| 8,
9]
u(�e2>�&�,(��"s��	��wv���/G��
&�k�s�5�`������dL��FU+t:[)=%�-R�3@�����
�(+0�
&D͡d�=lȷ�������1!:",x�_hh.����vy�����gO$N�J/�*���8�+-�BTZ[�`�KH�r!"��<�������U
e�#@���M���`sФ�$���'t�M/ރ�E�A�M�$ށ/�Z1�{�1s�d���Z��4$T0"��}�$�!�.��2(������n� �
?bp�C�����Ջ��( �  "�7��K�sÒ׋!���%��S0�x�
518�B�L�� I4�"�>�@'�ܚ�~��p���K��Ξ<x����)� I'&��s�JU��*|̒���O�U���L�/!�p�'l�N���J�=������dE��8��a  5 |杻�ysU9��	�$ls� ���j  �����i�oǿ{{nn��� � @ �>V�����$DY@�cT�C�%�FU5Y<_�K�s�B����?ge�1��z��qSF\-Lf�.��.�I!�x�'
G���ۗy9*���'
23o���
k����aላMO�8�N.M��Ո�x�y_->����o�������Ա��_f77�}�MBc�ͻ>���~񇻼B߉]�=bt��`O� b����j�#��q1��uW���݅�G�M@��Pn�T�M�;����q�5��W.e�w�<�m5�(ޢ/e�R�m��Ԭ��l|�C�c����S���};����t�X
z�F�ﭠ  ��Ą��)���d
 UY\�0�D�{�ƈ �io�ŀ�r?���T�t�dHL>A��X�1�.a��vI
 ����V1��EBp�f�ddq�h��=ȮȊ�d4�d���ƻ����F�R1��V�ٰ �8P   $���d�Ory������}�"�'"��t-c�ɿ���$�'�!(J�}g�aqj���0T�L�P���@X�uC��I
�JVL;f��M�������7I���6���ؽ�̈́
7�Թ�y�h���_7�:�Fe������p�ٿ�<��2m�V\z�Р@F
� l����p��j���Xp���Ĭ-K�����Pp�����bZt��M* 8�;�T�������h��� P(��|/)E�p i�-���d��-Y��P9�[L0ID�ik��È�t�-Ԃ+m6VSf�XIu)B?��������JG�O��0	����~$P�à��l#s�+� !�Z�o�����2��;�ב��)��}^���1�-<�I���� �Cd�Dm&�q4 %�9<�P�!�F�:�"���Mu$)m����?
��{��r��9�du���]����rsQf�������y#�����7А{5z�W\r�(�$�W/��	C�yYF��v,��'å@c�z����������,Rr]�b֖C�0_��S�@  U�l?��?�Ʉ�j�-M�ʹ<D�Ez7ދ�]�،�⍸�����l�X��\PD@���<+�}�9�7����ڕ���d)��!Yi��=k�4�a��� ݇����yj  L�"̮<B�(���dY��^,,�0��p&�9s��;	��Y��}$�+�zQ�I�	g���"I( �23�,w3��X�S�h�H��F��q��OF��7n�����%�I��eG#RJ5��L>�`��"�%HsE.�5s�U��	a�=n���)�+`�  �XRm5#"����F@8�P�P�� �B�����G<�_N�q�j�� @��$��=	c��I���ּ��0ǫh	j�V�{�'|�Yd�r��Bd�)�3����q���V����W��nM�,	ؖ9��~�W��ݓ�U�@�0KTP$��u }F��D�D��V�?���QEM>x;���dE ����K�8��%����]�$� �0���z�8J�¦A`��@X�5� 
^CRr�q�V�Z[����ݡR�(
eaD��"����L՞�/�IzUZ���X��9ãp���3�];�pq�q��5B<��]���f�΃��T�:���hA:o
��O��n[���1�i!G�E������܄�c�iP����c[���(   YT5E��+�[�h��l�1��9q��V����
�ԫqU�!�zUA��Ȃ�;�"���Q�`0�ˀ�K�&(�bu�w���_�� �	B�<�^�E���g��԰s*�1�l������`C�
�����kJ���VUG'���Qc� s%�8HY:@&y��k��&6���dZ��-V���>���<"�P�c��m@�1<�	�Q�f��݋7�<�$)<D`kH�q�K�e'�&�t�xt� |MZdV�@]�Bn����DW�Ҍ� ����^���ut`a|"�?�QA!��O�"/:@�q*>�
���Z� ��z�.R���  I0�I�c���ȴ�1X�j��`@��S�!Cʩgw��E�Z�ݽ�����R8�򱝙��}�6q!2%��I��g{-�р�$!$�� ��/��T��)�谤���	��%,W�|U���^�P �b H�HJ)���W��L�B�^�(u�IAA�&���p��܀:�s�fB������mS2�bN��C�I:��`�[���dq �0V��3 3�+	
�"�i�0M�����f!*� 	�b�8�!|��ﵖ<����M��wD�a;@nn�1d,  88&Y�h
���"<�擕��$� ,Z��������ԭVS"��+�y0j��(HP��*E�sZ��D�|����8=US�vͿ,����:��)ՑW��`d7APT\�cb#�J�M�º$�� n�P�M0���X�Ü�"p(�w�}���k��=���?���u�`!�>�TA�   �P���w�S���i5J��u�@2ms��g�z'��$��	�w����d&���7So�t?�~���}D�>+��4E�1��_����ź��� �cr�uj$��iq��r,}���Z��oQ>g���d���([�	D<!��0�F<iY�$�H�n��V��
*R�a�* �K@ �aѲ���n���`n�Fs'��P�����7�.���4.Aދ��н4~;?���`h
�P��W-B�qY���ȍdᥓWu��Zՠ( ���Yb�E�(fU���D�H��Z7��K B������}��0���tF��a#F�    J�4C/\�Y��n��0Vh�j(�4!�s�ݎ���XXˬ?Z��t��J�&ߩ��X�| �X&�0i��p�f&�CV���҈   �@����ف��H ���R��[������R�F*��'�7��C��);�n�I@�B8jp4˹�f��bl5O^%L[.���RB������d���U�I�>�k+`ba��}W��	�̅�u���,����a�SS��I��S��r��?�0%9����f���pϢ�c�H$ ���+����h��= �A$p0UǢ�� 
����(�0����[�}�&�!�<�4N,�� �  � �� &g����|�}�mc4�w��|��Fr�vE���43�~_�W!�]4�d8*"�tE]�N�F�[������3��uh����@�
�	�@���M��Aj�8H���PP۪���7����� m�h�
�$�LU�  �vXqv ���,(��RlF	М�I�v���Z ��WnX�k�YW�6�pݳV���{�Z���C	l�E~ή��}��}�TM��,Lb���dĀ�#]i��>��a�W��Q �
+�(����� a�1#:���0�}�O%�6��`����ӈp�b�K87���P"l��8:,T�CiŹ%4}���Al����4�0HB� �U=|C%|�N���E��5?Bįh�7�:vM�ꩵ��UU5�S)X��26�~�>>��c>�"�`s�{����   ��
�p�I/�c����닋#�r�7�
ǵ_���o�uZ��v�'I�CF�ȫ��/0��  �,4�Z 	��!CՂ��Ĉ-Dž���W1�]2Ã?������q���I���Ս�f�w��eG~����|wn��F�����f�1�uG38I�7����
]eA��M�
q  9pBl�������d��=UO*�6�ʩa���R�=��锉 6"{�	��������k�@�s����2! ��.�(�m"�2�h�cqg� ���4� � �`=
��,U�|�$��6G�t1@XC�R��2߽��$�Y&C�Cgy4������-w�~�ȩS�"r�ő&q']
B=l���C�3m��|��u�[:��  @� 
t�@�(7�^0�w9j���r�Yk(�UM���ۿ�`��s���� !�PGX��f� 2|��=�Bء� �fHH�X0�@��X������Ⱥ�,�FN��b�Y~{����{��+W��y'�
W�6�#����i���!�ioWf�������ed�x][().�L"n�
� `�AP`���d�A2SO,PBZ�a�

eO�<��굃	p�W���X�UP���!�po���| �b/Il����m?�2}��֏���lc�i�J�"��ȩI�.Q^h�#$IV��6�U
��:$Q��nR�H��ټ�i�T�x�'?�ϯϬ}[*7.��4�Y�T�`
�J;�R�]T���0��dj޼��A��
��U`�ɸ
8'��=�h���w�ί��n��0�CH�ˏ?3HxF P,݈B�,I�q���k �퐘��!����� hG�q#�*�,�Z\��A�@���&"�M��I_���i��d��ɔ�Q\$9E�"� ��R�HdK QeQ 0 _��Ƥ\��{���dK�%z_�� �I8����d�h0�xZ�D��E�

5
M,��@��+��	Z��Zfs����[l�xޙfk�XPg�������1{�9�`l��QPV#����>�ȁ�����0C� J��F��
@H����ZUUVS�r�`+�5�fֆ��
$�$�Mz��B����<�{��kv�8��y�������+ٿ�Y���7��,Tm1�����
���Ն @��,�]�8��0��@�R�����2U��������SЪ�o[	�$�-X@jQx����R ��>�����o0���kAsƂ�K�՟F��߈ҢT0z�Z�a���/�Z\���68��A�Y����k���}$.�߽�	��������gV(�h��GQS��8��  �)���d�~.R�& @c:�`%L���FMe���+���h�O�F5�+6� <;%yq�r��*��.[o}fo�^�����"���`���ɑ�����qY����!�%�1�JXL��̲��2��$�I��r\��$_u��v�NO�����y�1��ݫ�Z��ݟ��������׿�H�y'�M߼h������;�&��哃��'��dB��
�]z�c� X 6���c`)(	E�Y���m��������*�V	#*��7�v���yܙ�MB�0AQCRf%_� � ��:���< �34H-�PE3.�܁��K!+�6Qv�<�kSP�L�O�{;A%��J�Nu�p�mۿ�o$ǃC��'����+��� ��`c藑���d�P1ғI�3�
e?P��>
��
��(z��&�G�U�x����@����WI5������MjW�?���)O��?�5>�m?��UfI)v��IU@֫����0�}��~|�]�65,әtm�4`� ٲ�9q�M�D�>)$�pp��Lr�m"���2$�^N��TT��'����}�à��&���.�tФ%D�K��'��M4I?����E�5"��
�QC�ل~�	�ؠ@9�G��_���3U��=�ޯ�P�8�Py�W�����w���������`
�dFy��8@
�"(
���<�	��<ہ�Y�paVc��a��X0�;d���d$�i�F���l
��`{#�m�o��j����wѯ��������d��>QO�A�:�<C����D
a+���kt𙀕�_�;jV;��s��Z����Ԭwڤ��/{߿y��K,���U��lZt8�   a5�O<04h���=T2@b�����<#�
��70pplg�p��.������Gr�PKA�S�A�M@ 8 ؟�X�#L1(a��_e���̒ r�����v�w�itdD�#�KIRP5i"���jY"��F�%�+T�X*��� �T?�MV�2쓝R��Z�R��s�9*�)�m��� ,��4�
p�8DR��t��+򄀬,BF��
��f�6ei��?�hX�҇�9E�صu    � C�,!�Q��
.,ҦǭMo���^3�Fe`�8b@!�D$ .����d�49O�yz@E�J9i�F|�I5�  �j&�P �($HX�60!���C P��!��E( �)D�o��=��cQ�*Xi���X=Ҙx�
ܝi<|[�8Y�D�(�d _�P%5��LK�2H�Lԉ����(D�s#S�8���Z�/��rw������ӇO��������?����(  0    HεC���Q��H�&
�DҜǥ���ʆ��X,,
]�< R���N` li8A�H������p]�q�-���%���`��Yt�:Gax��A�BRJ�QX�i��t�|�ι@��48\@������|������s�����'��������w� �@iX
�! hHU�/}+�\F:�"2�����dȀ_P^n� ��Y��� ]oi���
/-?0�  6P�zr+� ��C�p;
�C)⪆uN�@'Q����$�j��*ieI���^L��UV�>Ӌ,G��;����N.r�^��򻕆uZ�G�:�Ѵ�q/�Y�x{���������s+��S��ú�>�d����˶��L��1Y�#m��c����0�8@0
M4/ܷ
��=�s؅T8�s-�Q~8���Q�?�@��US�]���Dt��w��d�4�Vyc��(D�2�g����E��p�^+>I�a)黻�R���N��C��A0G2]��@Z<!Ö=G�� H n�������f��.���I���U��,$g���9l�[P����M�Cj=usU0�������d��DY_i`?@��� �}]^�=1����n(�njl�����m�m�l������j����*j�������o��l����w��G<��~I�hɪ� 8�I4�0U���)e���u;���
���]��a4$�SVM0�:�i�c7�âP�CS ���[=
��m�Z��6�M�T����U����|�Y���^y�5G��/��̿"�C{B�//�ݣ�1
i^^C��J�<�\��I��8):+>pS�
���P+=��OⓂ��?8w�O����r'!M�Ȑ���й/�����$.I]U�-� �p��$K��ڈ�;���W#��x���w&���H�c@ѥ���: @
7`�(KwO'�"չ�kR��K�]���d �G��;�)#,s��Ya<S���/|6�E'�/3ϻ��"}�y�z�a���|�y��2����Y'T�S��i�h�`c����o��
���R���� ܧ�+��T��9K41?����77�؄��  |��h��נD۩�=t��������
	m@ �Q��%�42<�B>�M��#��N�jQ��z��N<|�b>}!�3��O����}�p��G�~�D&��^﫚�����Z�:�&{��O$��3��~JѲ/�>����  ?�?���*~��J�TZ��;��נ�� �   ��ETO�?�����_uJ6kY7�"��q�-�%�ӯB�5&�JN�T���,�ɦ��@ד��D[-�	���d�I��<p1�{|0F �^<����1p��N(����?������؇�<�dcޘk>�Z��8ݵ����ktp�t��H��z�W��<�'���|�W���<�iQ�Tm���KFņ��lW(7��G��rG�@��
��,A@  649H �pm���g�����GP�t���5F�AC�qV:1�u�Qp��˼��ufD�����aɱ$�B�뫏v��G�4�1���
���Wv�i�o;k�J��-7?���W�����_�D"!� !��H��-ʍ�-�%KK�%
K�K�M8��8���S���`  !�����l�&H7����=*��@JҨ��Μ��!��k� 1 *-T������R1b��gU �Zp�S&�H��2����d �2��J�3��H1��MaG�V���4��p�>���L�r���'��F'�Ç��yӽ$���4�I�M ����\�5�@�7����̇a���k�4If 
�'S�!u ê_[� �r3Qp���<o�Y|7W��J���9n_w
[S�m� Ǩ$=X:.��
m��
    `N���lN	15��1ڏt�M4¯��3l5=������1n�$/葊���z}
!t�$�7"M�?��!��Ȥ�̥����Qe�o�B�;���w����6f�`��\�� � �n@P.(>��]�'S�}�س+�PhUH�24��#ɧ�bU�s�����  M���$E� U�.i������A�����L���Ji�<����d�/Y�� 6�<1���oe�0�ȭnp�$yC7�g�;f�5�}��H�h��?�\��J+m��.(#Q$�@T]�M�QQ�a� @���x�E.�
���1������:�3���)�!��J���7�ܒ!B�  ��QN	k�!�B�
F3�!$�E�,�_`�X>� ����uL`�JBj$v��Jt���7�����B�z���[ߜ&�?�@w�m�����kǯ+�9� ќ�
j*�B]�F��b��������������u�q�U�6J�'��MU.أEѤ"��")�B��1{�PV���IZP�ဓ`�i�,������IEWO���ݡ�I�QD蝯��p_�Ee�VU��@(���d3 ��i�1b;�\O=�	���k��p��l�Ĉ���j@#�/X{��Z�  ��5 ������C�#���4��jy̀
��!1� �s�We܌�E��ފ���$�.-�k)Q(����v*W�E(\��ԙ^\�'����b�k8���P��
O "�_�6�lqw ��[@ j��9��,��d�cc�_��T�iJ�q4<B�'��1"C3� ��`�`���
5u��m����$�m3$����o��dy�6������H�x��f\-e ȮkF��h����0D`�Qt�<D'��rܸ�0��s���p��2v�f�0��j� � rp1GL-깠����w�3���;��߂��.�eA�'w'&􇁣K\^���dH �3[��7E�$<",4�i����ۂ������A�  �h\���7LCr:z'�/,34V�6�	�i�������b�Pj$&�^�@�}Nm�E�����>���.[�*Pl[��Á�����"}z��zv~�kk`0$A���2<6&�u;�9��������%��	J��&Ш�G���.·^ImL��R� y��8�r�X,G��;�Jʅ�)����"fՏKi����M'(���|<f�����43�P���R�}��aA������,��� �F�[LL2�0   ��͍uQ8HZ����*�l������$��c�G*C�Ue_`���i�*���=DK�[+�"�A����oQzRU��ҞM
��l���d`�2���- 6�[�<�@-/s��S ڂ�4�� ��rY8��@����P�4\<�B9�L{T�l��u�𥉉���[IW�P����%U~<�,�iW &	r���f�y0�KS�%��J�Û���b֌P+�	Y�,|Ld:���܌ �  q%�q�l��TBT�UZQ��P�7���;[����3��@�r�ˇDt��+��E��N4�;c�������ep��ӹߩG�K7l�ET�{�ŭmMD�P��� �\#B�G�9ioOݿ<�ő1�X���[��w]:����$u�� }[ �@��ݰ?��K�k�Rn�����4�}�H#|1�ÂM8�-���QJ�J!J�A���Q�{���BT9+�aY4ݍ����du�"=Yi�-�5��(�� �]�H��|�x:B���<�y��t���] �ޞ�� ��{!�H�Ͽ?�$11��(���� GP4��
��������A�H�ʢ�� �6@ ��<K�
 ��BܳP]�2��0��LDx���R�l�Zܨ��B�l��(Ť�X�=w8�#��V��9�5*��R�����I>�qc��#c�b���`AR!@V��$�(�^?���V��O��2����_�Ē��9a��Y�ʣ�� �_$�!L���=�)��S ���u�:�hR���0rMQ��wt䯈V��H�e��`�k5u��^�-1#��$�y�R���̢����U��&m�2�0(1�C�
O��VqA����7����U1���d� F�i�:�7�[_0�(Ыc���ڄltg�@nrN�t~�@��+��}`��Ӂ�25U�5U(`\e�M%f���ps����QJ{9�����̰�촢��0���D���X��/���T�cgC

C�ظ�vߪ~�yR�7����I�� p wu��c'���=�V������������`��F����*����������B �  0!N¨�pK�X�3�Gj`h�� 	f�h����
BT���;�^�2����l	���-�1H`\6���aȨ<�$Z�x)�%�$8^��;��\A�2���/DL�.l
��F�H(S���թ$�gv�H��
USy��ȡ�#
^�j?�n�-<�.�˸�w���d�  ��a 7*ݧ� �qa���
5��� z��`�}�M�:������ؗ+J����z=l��u��(��L��@ �j1J�-Ǹu��zoG�w8�\�T
�����ҋ��8�����
9�Em���%"&D��Zj{$r��Ћ&�3̢�T$���.�i�Ӗ�����e� T��j�
������1|�o���s�n5k14/��iJ��"  ���f
$ܜ�"�Ѹ�h�kq8bP\�m8���a��*��s{����B�`�=3�����Ҝ��3�B���{*#u��.��pT~l��
����s�h   �-���;�bM���ɞl��BԂ<�� �T�(
�6��e���T�D  	`�Fl`��l9���dV�C��a 4������s�l@�n��0 cyL�/(�f!��)�U!o�Q{�Ӕ��IV�8@�rd��؀XJ@\4|�0�4�wT��S����}ɏ(�@�J���
�,���W����p�uQ�����)lsŁ6�
PLBԮ�
4`    ����%n�Ya�$�G�����`mj���h��������	!K�����z�F�q��AE�FMF��,0X��&p�:6���B�~P�
��lʬ ��p�Y|�#�7o�����Ƙi��G�C,m�u1kH^ׁ���:��H3�FN���E�E"r�bQ�
�z3�(`T�q��y)q~a6�c�3�cُ�i9<�b�W���@�LM A ���@���do �k	;`0���="���n��� ςn������@��Q�ł�F�a���W�	y�  �`��Hu�6#e�[�w��*-�B�̣������xm���6ZT�7�I/]G   ;$"��l�{��GA� �t$�Դ�E��^�W���8y��C�c�@iȭ͖�g��Ǌ�w�������\��A�b��cҥ�dM�#c
^�e� �	�'+.��d"�*d�������
�-���(R� �ӳb���m6hLHoe �Xo���4a@j6P�^�g#������(�K
���Z5�(����|*ek:���vw��Ac��wb�R�����Ѳ���x�j�v&y�Ɲ��X"iK}@���h  ��\qe!����d�#3[k0�8@�
1+ ��kG��@��<�������aH�w���F��ƨ)
��M�y�D@�?Ԛ�`��	��Ǧ6&����F����^	��a�ॱ|������Fu��(|-������?�����R"���xe,jE��3�M#,H
{N���St�X  z�2N�Q$��*E@��V�z��[�zHz$�Ѥ��
�s���%�>�raJ��r���Њ'��h�#��=P""<��� ��"��F�6���2\&    R�'�о'h�u��\�<�YYh��@�+8�$�U�P�6�(1�<+Xǥ��t�pQZ�&^E���W�/Θa�i`$�֣��tΉ�e`9�D��D r��<���ۣ��x�>���ŀX�����D� "�3�k�]D�\=#|��g��n����8���ؑ�i�˒^y]��TQeM3u�u�S�_��ZA�U�+�������oY�Ȕ����w����aOق��7TXCE1(  �P����q޹-���z��d�6�ʎ�S�>���&��˱C
���s��0�5��~���������q�,�Z(m��C��,�)TH  5:*�QyS��"1�{�{���`D�pF�����>�/Nj�ޫ�ي0l�
#3���0��")�դR"�E���$HL�
w�~~\�
�D�@  ���h��%ٌ�V%��Vʬ�U�*���v���0RG����J D�]k�� ��H��"E����g��Ɗc^��D����<^�'��Z��H0����D��"�>�i�,�_g{M<�n��c��sA�l�����n[	��$�K�{'����v�z#�9���\BV���p��?ŀp��Z�ŷ4pP�*�DV���t{���	2�������6����@P�  
à�!�q�|�z��v\��ಜ7P��/�?S�y���}�u�x���w��-���Ԟy��k�(�����mȕ8Wm?�`t�_��e �:�.�� �p<��V��0� ��w�<�N*��ґ������#�Z����rK,#2��B�A?�<��2?�P 131Q;/�&Q�
OI"��M7Ø'���'{l��5�G#�t�b������0���A��J9
����8۪(�N�e ���d��qPYQ�>��)$ex#eG�O��
�$�	�9�w#9�8$�����-D�i�3�0�  pZLQ�F�ҹ���VQ��--����HN�a��oϢ�����q о� ��   �+�YrA&�2�����C�[�ee��eS�+��w��z�:���$A�j��O؁���m��l��v^]CM��5���5I�S<�n��1��5��p��4cdɚ�ܖ�$ą��~p����+�yl�o;�L8BN     
A��M,;���B�L�?�����~J����G]I��%�o��i
�p���DY*ql��*�a4����K �
��X0�r�9�N��2�s������獯$�"���Y��1ܓ�zG��ߕ~����d��$M]Z��N�FJ}$">M!!m��Q�ˡ�0�	X��q��c1C)]�gn�o�]B
5�À�pd�3���p�r�f$4�& �a����
'�zuv���m���_[�:���R��J�E���4�>FN{ �  ����,nb�_��u���hE�����c�U����&�>�2� �pH�;�w��~x1S�s���2r�c<��ׂ=��?Ic__S�4"�hl�,   
��QFiȀ;>��G9��'��u��}E,^Q�s�"s�X�2�Z,�: &B)^]�,�Qh�;	�V�蝡��� a�w?i���GV �vTÑ#�(�ؓ�� &p�<6]�EO��}�1�p��ϸ�@J*u| ��g��N���d~��<�i�p8�+�$	@�w�m@���İHh
$"� �:6\�Z<ub>w�
	�}N�����-�lY� ����G؟���e�E
)d   ��(ΒX!��E�3������MO�8w-�����fIʭ3IM��٠Ǔc5�$E.{-��I��9�D���Ko�k�W��]��v�#� f"�� r��+���$�7�a�:�W[}���Cdf�b�"���n�|� �zܒ'2߷��
J$Q��2�1.q��tf`�g������bȋE�x�T�1]D�G�=�¨��9�ɐ���m���J����T��
�@{	o9�?���~���	I��0	ɦ8�q}�o~+���S�c�WFN������0�2!�����d��JZ��*�9f�k0"F�Go���X�-0��9���L{�~&% �5��.�T5#��YK�q�Q���3�s�����k�s9~�Κ��ƙ���X��Kv�����e#
z�0�s]5�fp�� P�K��p�b)��f��ˊ�!���OKKcZ��s�UF":��sΉ�gp�
��LHz=I�R�x ���g��IE<q�%��`���m� ���g��&o;��	
����7��8�ȅ��hO��Ǿ�~Wl����E���F�&��F�B`�8TB�$v�j=:6��}�հ�LF)
��C�H�@p	��f��x�܆ �,��fM��g����ԭK�bOZp 
D)_l3�]!r>�@?�	_f���66ܕ���D� O6�I�pL�۟=�d	�o���9n|¢�D���K\��aU�c鎉r���ZY�
>1Ե�9��?��� �5.�jҨ*F8���H���j��H�7Y�L�R�E5c�.�)�CW�7P�AΒNX�{\�'  ��x�Q�@h��@!  8�b� P�����ؓ��/Q�5-	�Ա����\J]$y��h��4T���6�y?����$V)�J�XFN�0�s<�� ���x%"�� �D�����芁0��� �$�|~��F+bĮXa�!	d%��m�BE޾]S�%3�J}�T��246B|���::;�̝BK��gO$	�"?2���!�=�>J��A2tI܃ET�R1n�#q��>����D�g%YI�Z�LË�0F��MgF o���/<�
�/sZx}{�sw�m���d�Iri:.<]�<��5ɍ���a���m��Q�����١.�[�N�C�˕� <1� ��x�5P��
M�G}-��������KѪ�[��u��E:9��!������}U�@ ,�=JaM1��tT�A�)����B���wcPW( ����d�2/{��6�����R
8�a��r�#��9���� �`x5Qr�r@6_�Du�f  �J��Lω����9��RNP ����?�D�������4!!h$���m�l�    �[�3ѝ,9�
I݃��䈈(ś�V���r�v]qW:���D�7�l���g�?���L��O�!�}�\�����d��� Z��Kb>���(�K�om��r��
n����:Y��h��BѠل/��'jeƐ ��DD�'��c	�j��$�4<�����.����b$��TӕI�f�(qT�3H��'9l���D��8L̥�~�!�P��9>��]����J�}�B!�T0��FH��cc�s變e��U����*�E˽W�R�d6cy�t�?%ޚ��$ ��B���k�)�].h��<!�H�D%��h����B�DD� �B[�T
pq0k���r帬��jdV��O3��ךY�Vuj�V�kx��n�+� wދ�%�����ޒOB��B��wIĉ��>��I$��T2·{���o��4o��{���?�39*� ��c� ����d��G[��@7��k%#��kg�����0p���$H7����X'�B�a��x8
���R�pT���G�)@DXu��P�|����=e��� @G0��2�!*�\O��IwdS���N/i�i^J��	��b3Ή'�����	!�$��@A܍ߤ�sP�fg}��e��i���7��j}&�fy���3��ie�$� ��<L@�8~���~��#a&Ab�����p��Y���K)�0⡠XNǇ]O �����Ɨ�&�BS  [
T����3N3E ��=�W���E�*~7�;��	ں,�����ӆ�����H�eaz]#N.�M�J��P�3<�����Z[�bQ����7l���D-#��(,H��`�f����d���9ء�N�D��o=#
0�eg�������	��1>�w��\�b&5*����歲؁(�<���,9�{��&��t�J�,�b�B�s���o)[K��2�1�_n�Fap�~��O?z�_j����ޅ x.����
=$M.����`�0����/K���4įs�'ܚN� ��8�X�c��NDDS�iN
������ é���vLȎ4����6�:/5�J�H9�?�BF����U4��7L���C�qdU��*� ��2�٢W�$�b\'R��E�Y��e�s�����
�XQF�����v	��/As&�b�m%9�pGi��$�U�� �{_!���M�X͌�
�a��.��P�X�.t���d�YL�q�+�E��n<F<
t�`��W��8��،�pU$(����Lz����OҰGm?�L˒��I�U�$�0��*� �z
S(X�"q;�1�Rr��ϱQ�K��'z�ɒ��<4J�u4c뤲�����ZD$�]�#�����+p�F�~�S���ҋ[�?��)����oSſi�@CZ213 q ��;U�K�ı�0���L�1"�g7Z��C��2�(����t~��Z���F�nu�B�ͷ%�.5�O��JjH @ (=��q��Z`�b��VB�/:�ՌE���b��a̡{��w�O��/��u>U��o �Bֺ!U�����<pS4�ᓟY	������|��Ʉ.g���KYz�8�'�δ2M���d��+Y�� C�;�$fL
m^��i�1������Ga���`����P�S�?�w��|o�����F�ȇ�#�E<۾1|�q_Ճ��c���L�zWF�<�!"�N��ɀ<��7���ɂ�S�D$����Y�_����D�/����ʏL�'��c�)��Q6{e�M.Se}���Z"h���r�A�(�+:%��e2
郺�D @,8��io��=���aC�g�¥^�_��"	��S�p��C�w*M��rUIF   �`�Q���_$iviV�(y��qh��L}V4�x�?f��������z���i��'`*���ђ=א;�� ��<pc��8  wr��<,�@�S�
$��f�8�+����մ r %� ��N�����<���d��S�i��B+k�#�5Wy��M��
�t���%(� Ϯi1}D�s���sS���&��>�E�����{��5�� �"��0�k�+�u  T #">j0��Ď�J5HY�O`5<t�M<�吝��e����zY���Gӣdy4�c���y�D^�ᚾ����/몾��kk���eeKJ����>�.��D��hH+���Sz^ ���Düz��n�g��H����	�3u�B%�ꠎv�л�)�E*[������
 ���UC`   A�l���$G���[K�&@�V�v��|^mc�5i�7�U!�+��>D�;��$1_<���I_/d���I�rb_��zH�����	���L��0Q������3��"��4�,D
� �.E���d� v2�I��Dˌ#nN�g'����1���͠_ʿ�1�y�������v��D�&ݪTz�6��d�@�vG�k
��@�\u/�� �� ]t[��怜N�CH9��]N�*�
V�E��S����������}<}�~�w�Ԁp�`v�,+���ٍ�
�95�V~�w�( ؎�`����Z��x���¨��X�MwZ  TD��
��6�V򡜂6�}�����
�PA����"&j���,��IA��e�`7�*`   
.��5a�F4�Y���Q���"y�K�̬U,���}�Xir�	fb���4�)-�v�����8����*�����kn_̔/f� ��;����Fᔂ�z@
�d�%NF;R_uu����d��JYQ�/�D$K�0e:��k���A��4��xU*Lo������z*SQ3��:oD3�vӗ���7�Ҡ�\���DN�C1�� �q� 	�HS`*�	o5U�9]E�O���{>F&$r�)"��4�������������O*��d�y��<���s7y,���.�'�th�~��#Z:,��p�G�h,9�*�E�:'�Z���Æ����
 +ɧXE}����	��-J�΀b�$1B~�X�4��r�L�L���#��n%.a�B �   	"�piI�2Ưi�����\�4C=�/._���ٴ�GʥIO�;�},��%�_������+�\�W�e�y^O4�]H��w��W�$�o��CC�E1����@�,2��i��R���d�#N6���[P@g�40EL �a���4�x���jN���0��  �.Jz���k��O���C�8�ƾ.-e��A�p����n�f�r'⍌K
�d�a�#	��Yk@ @O<�1`!74�2��Qs�B��tB[�	�B~���ͱo��<��m��	+s�)��f������m0�#χ�qP1��x^e�56;�j�,���z�$L(gh z�8�_q����P�k�oܶL�M�
��翍Y(a�20�ƽfj �K`  8�� ��$����*_�ŪVXE��ZGyϹ�x��>�����<p���3������'�Ľ���������� #��0�����v�}��h���U�y� ��H� ���d� �=W�p?��\0H&��k����׊����� !AE�y=�0Td>�Ä}�V�*��X/�5@��_��������kt./�Io���L6I�Cl�B�$��@��� ¡B`h�L��*�.ÑGݮE#P*��Bw�ѽ���Y�ase�I ��Ds���C.e*�3������MP� �Ja��r����|��B��)Z`���;O") �X bN$M�2	��B_���𶕬�j4��WX\����
�@6���� ��
G��[0
�Z%�x������xO��J�8�ڱٸ�ԯt�'J�q�N���N����mj�h�LH�D���̘�$�$H�E��i�������l�H�ƞ�p�3C��y?.m�� ��<
���d��=W���E�.0"�
X�k�a' �.x�X�5S�����   08d��,p�ʪ�U��T �PN�Q�44	ʁ�n�����X�ǰ�p�� ��0����@���Ua,.��{E뫓�j�~�^�B��i�M�A������q�"[���/+�ɜ opp<�I�u%��ou�Ȩ�t�:>
8������#=en6��%�QKu`6�d��]�<-��<(JR ��r�����ɃP�`Í�9dD +�L��@?)��.�M޳B�.���x����������v��?����4������`�B���3�
ִ�nX"S�ac��/zHĢ��  A��@������Th�4�Iei�o�+������d��Kر�?��m0bF
h��T�ق��Č���A�)#�0�B�T�?(�%J�*�1�@H6�q︤�`�f$e� 8� a�M4�/Z�Xv U�o�l��D&HY���\�g����'��W?ρ@'<+���Y����$�����$H�wI=���K�F�"z$�}4�3V��au
�ʙI	)�j�o�� � ��	�7$Sd#���#"�g�u�t{)HS�y噖�sD���ؕ��
]2�C�g
�,
8=� ��@ %�*!��
���*���:d#	8J[��C(̓�ĉ$az1*?�}�m�DR���\w3�j�O�z��2�����?^O�?���o��~[�j	%�ƮD^X~�fX�C�)���d�� ��/HPI��n<l@�^̱&�#�-t�� ��c�gBe
X���%8ϱ��=Dс�P_?�=Z�qc�3���̋�pԡ����e���V�"����.c�Iy��rA�O*   P�Җz��=�އ��+&��͕M��:<�?��F��i���<�wO����_��Q���-�=������SZ�#�%��Αp��j���I�Ӿ�PN��*c��?K�aΈW�����!�8�
���m���<ι*gB%��%��ͪ�e�좝҃p��Ǆ�9���O�(��
��*	����bq9��]   *�s9��H)�Qː�����a�wT
�y=}�vo+�P�����m�c5~�
ɘ&N"��@>eX���h`���D� ���	22^�k�=#k��Z�)�|�t��".�L�,���֮���r� ��mL,���wQ.��'�@H�A�F=IHM0#R�,���]��Bg۰5�Q�E�R�2�4�
1�c��]�@H` �.�x� �d����ĞM�! B:b1*^.������k>ZiY��ǔ�<`�3W�����ᓤ⮺�ZRS�.��M\Nv��ͦ�4d8*���qxȭ"�U���m��Q�e�� )� �dn���K�YM�T��|��r�jo�^��g�qg''�K~�+a�+7��~ޤ����&!� 	I��$k�Úq��^��s$�t6�ԣ�d'w=]�	�.�>w���UU�s3j�A%ե�2"��VT��:�Y�����d��<W;E09A,=0)���_'�X��m���0����:
��&��.u    *r�e��QH�<hf�C���W�B�2WS��9�[vỲ�ukXlL_��
�Y�7�������2�������h�e�č�
#��� ���H�1�d�` ���P�:��>V����'>v-vU�N�Ҵ�3���e8tVs�B�2z�
w��DC[��8ʈA���Wz��$�a ��^=�@��C�v�Q��|iO�;���g�f�OY�~�~��N�+�?����}�Hii�?�Ś9�\����4����@b�,�BVd\����� B�$  L����"h]�+R+�1/SH}{j�����hI�!�>R���-��_�NM��p�1��z���Dր"�.�Q�,4Z#{M=�$�i�P�q��p���2�<���'�{�D�5�ж�}�9o��R�K�n�R�g�e�Nn���1�:sW�h�Y&,7m�!D��Ք6#M�d��ir������N��f1O��K�����J�	���
���֠��ޛQ ђ�����5���9��-��ŎL��+
�ej�II|h0��,+���Z��_&�՗
Q.��5��T̬�U�+�Q���A۫�(,�߽X>�zwc�N�0������HS֭���E�p)��Y`\K��*ߴ����,�7�������=�&����74:HNt�Ur�$�  ��d���� F�/��s�$b�-C=�y1r'��$ߐ�
E�FD�g��o����w���$���d��WXkC�=�K}1"&9g`�0�����p���\�g��S�[��˟8���
���O�]���yOɖ�)|��1�&��/w��+�QsA6�n��}����_Z�+˅�E`��"��[��#���pu�u0j�Iي辰�D�P1����� �%��l�C�>"$3����J]~�49r��_��p,��tXKĆS=�D>��k=/��O���କ
y5��S� +m,�P�?�ݥف�0�
�Ɋ�T;�K"=��hg
����Bn���~"�Ń@�ʤL�dL�    (h�Q�KȒ<~9�!���2�EG��'�ߘ�M�I�
�B@��e�y��F�ށ�\�>��:?Сw����������T���I���d��;Y�	b9�,,<C���i��q �2|�%6:�
y�"*Y�$c�O#��D  �L�Md��]q��m����t�+��_��j/VR�1+.�;�������
�ߗ�
�=J ��6О��^��{�<����|lPP9?r(��hO��K�6�JljM������������S��_4_���e?6�_�X��V6������G�gR��|��wj�ò��6 '"�3ϝG�m���0&˴]P������dW�"��=����S�
x�I��pE��@V�   �0�x�e%B���@A4�����Wqy�a"oH'��}7?�$D�ǽ0�#��&��p��9�΁gK*IH�n�A5�m��� 򪻮���N���d���dق@=Y��@7�;�<FM�aL�S���-t��Z�&�Jꃩ�DhFJ ����e�g��B�å�-�{����g�������
���Y�s	q)�~R���  ��c@d��pS���_�Ȳ�(�?W��R�n�Rf4^yQ�#ɞK$����G����:?�w��&��7�� �JB�2*���-`�E�������fm����c��<���*�!�4� Ģ����"��=ԁ�Dd;~�������R:��{��j��  ���V�A&8@� 	�2��/4}��� �G'����R��A0J�
+#�OdJ��#F*=r��ڮ�W�UT}ݙ�9�:�`!��*���x  /P�(�93c	�2Yٻ�:���d��D�i�+p7�{�0"H�I-],<����<�%Hd{ ġ�x�p�9卦���
+�KcJ�G-���Y��@���p��А.ʢ���x61��z}
�Jh )=̣��/��>���x��¢�;�s�~������L���+���q���o\�(�so��(+mOh*�u���R����Y @d}ō��Y�}/E˩"  M��<��c��{<Վ'B���C�N��w�)1JxWT�(�`��l5/��֣�s��o��4���.�&�QgmIRO
���W�Y~���K    �M*l0���0#U���	� 1�,7�L�8G��bqM�pT��Kr�	I�[KS�F�1yu����"<o���w\�ZUK5����#����D� �KXQ�)p_K,=�ȥg���A�-4���)5a�bMY��ۻ�;�@�	1ػӬ�J��Q�d@��0�^���&���P��me��o~��O�����%F�����R��S���G��*0Q�`C9��m"!ڼ[��O���goc�7Ϟ���<
��-���NQU���!�J�4��V��>@�4�WP�#���i�L^��FY
a��0����.��$���H��b�i�⡑���D����y��x��z���V�F�6�W����v   ���0��:��|���p����}�*����_����D☴��i��Fh�K�D�L9�9�f(�B�ܤ��r��ۚ��d�D	����:mMHN���.�g>�@�d���d��R�i�B�7)|,Ó�{iG��٘-l䱦����.'h@�"�\M"�|72@�T75YiLXw��$����x6�/�]�H��w8�9�SH��J9NM.|f�KP�I(?���
4x8�����9rk�t���<�v�� -��P<�dN\�Io_���0�
�?��NZd�q�i�7��_�QT���g��ǒI:M����q�7�ņ�L @ɬ���H�1N���;J�~���+1d�p4m��r`�M�{��#A���zI�+���ά��񻅿����������qn�������º�;3 4�	 h&]��\j�o�c5!n���Us��X,0x�֤hX]��zT�ȱx��)eH�  ;`��҈�1g����d� ~EY��rF���#�K�ym��0���<�&-��X��/y��)۶�n��+�|�e�%�,}��� ]�ͳT���|'��ݦ�ʮ���z������G���2��� ��ɢ 8��gx���gТ���z��J<�@8�W��� ��%��V B�����3�:�  �2Ǡ��!���hO��[�����	Z5a!�,�Q��5����%��ˮZ���)T�	y��dB�%c.(��Qp
{��(� ʆ��u�]~>q��$�T�%n��CgB�W�-�5�K�����@� &���(�
�|�"�D�S6Ryz� 4�(  8�
$�q
0Q�*Q<Z9�J�`�+-+��f�
g;j���6h�,e϶:�q̏�sF�þ^T���d���\a�2=��"0��u�p@�q��%��g9{�v�F�F�+t!��w��EnP嵵��\cJJ��c&
H  C�f �2=���Y�����E� '� &��������r������-2��V<YY� *+-~��M[Tmg����
�t��f!�:Sߕ��'�jM6Q�Y�~�r2�xŝ�݄`���A����F���O?''sF��Bs]��P є��`�:x���ZM�
�IJ|�ϖ͠�ȌH߄�]3���� !���9J� �` ��K��aeH�}Ȅ�^ �HFƁb_�$����/t�����h3V	�P
�
��X�䂟���U���f#����2�
��z�{[��u���Ry (�Ls��r����d� JY���;"�},�h��k�$mHڊn<��إgi���,�EA��G@ t�X2 y!+Z�/���Q���Tge�v��7�@	'P,���`e��I3����tc\��\�L�&��C��3{M51h�a�ja�:���i�L9�h�b�� ��V���'�}g���9Aa����n6C�|� �d��I'������,�K4dM�_v�6�r �&�
7 i�A�N�]�Q\�"�%��u�Kz��V�c�l�*K�F�v�P?  X�Q�v(kʥ0˺�G�]Eo-��)�hYe���iY��w���>�O4�g�����_��W�=c��x�y;�'������|��7��(�����˳�:!b��]`���҅7�UG/���d��B����<�|,�J�+^�0q��8��  t���v=	Z,1�k�}�^�lwm^�ݤs��2��������R
�Wà� ��_^�CJ4H� e�	:RA����O�+ʴ$y_ډ�g���hζ^���'=T�0%�X����}�HyvyB3.S�K��)d��mQU�;�V
L�W�bh[�}����F� ��4aR�a~��7�욶��_��m]��x�j5�Զ��I'����Q-�wڡ;�\�� �   �����P�IOZ�N����XX����A!�
JiHW�Y(��Ai�/�^�d?�0��`�0@#`����cq���8�|���ؚ��������>�T8���n)��x����d�dG�CpBk�=bJ�-g��Y �p���Ț!�C�4.�����O<�XX������΍u��E+�O��	昖9
t�k4�[��4�������?�A��IgA���
�zF�
�nL�쮢A$
�OT5�	̋w�f����Q��}�GwS$kS�����$�8Dm���<D��s��NS����r��E��K&KZp����5

��G]����ۻ��R���KBf�$�
����թ�   0S���#�p/����)OB~��;,j*nȝ �z��9G��,�H���BF��t��z2?��ݬ��Oez�)��.C�������u;jp-�E1�@��Q�M���(� �A 
 0��E� ����d�|S�KrI%\<�X��i���n0��ؓ �L��G)Vgc���Q��N��>@��"ӑ�XJ]��8,x��� L@�fPd��p�BL��Ӏ�P�]f63^
�ͼ�|[20�����4`r4]萹��Ν<)8|Q��{�i��M4��܍�[�����{��4��>(�յg�A���v����@ۖ���C�ȣ�> e�c�����C�/��!���/��H�tO���_�\��"������l��1"$� 0R�i-=�2�g��-Vo6by��b�t�������nMHL��Q~!������ (��C��Ǟ��;�����:Ƶ�6��#<�`�7t  e�ņ�ãz����d��J�a�pDd[~=�
��d��-A"m,�	 Fe&I�}O��_#<��'<�����$��#��گR����

,f����Av�aBp�'��9ki]Ů_�!=C��7������,�K+��R#�3��D�_���Do���ye����:P���i\��o�.6/)/�#r�B��IX��l�����u�Fz�J�J�-�q]@M8|�I�3�U0���^��;����w��;Էt,�S����#[$������j�u� ���t��@�-�&,\D���x�ϦO���]
��z7���ɓ��zh��2'����s��):G�D�.�����	��$��)��>^&<��e��w�Z�9�Y����X�$�����d�+/��	�B!�\`b8�X�������0fN�88�pC�N����܁��tX,����cw|�� ��Y�HQ�(����b�T@L��S��y*�RuhI���։���
�W���A�@�Eb���X�/�#�����Ke�K�.VP��r��/"d8,{@6����l�-e]�R  xNZ\P��ޫ���ӳ�k	¨8�ja ��֛�`��#� �Ы�
�9Sce�$��� ��ǥ�_�*�EB\V'��
$Q�#B˒ɥ*��7I>Z�4�;g�z��eU�>�/NЮC<�%�����I?�Q7��̧^���w�On7��  p�K*L��xP����@�SX|Y���`]˔��0�N
�k�P���d�N5�3JP:d[9,EH
��X,=K�
�����ol�G�J�J�+(5����B�}�V�#9�ڼ�dZ�R���O�����D�@@  ����#

��r�i.�@7���>uFȎښ�Y���7Dy����ͩ������{�����r0.��]e�W2q�¶����)�!�5z#��y��it\(��R�`ˈ�P�`M>A 0�Q��v�(���VhT
����w��C���<>?��'gR�j�s�vZD����c��}�-Ye��E�a%U�TH���+��v�h^J߻sL�]�FIѓy|��Bg�O<�����k����o�DN�7��'��CI,���g�=|�wH�#��:2�@��G���� � P�����m^d�e����d��\0V�>���<�\
��Y,=k�+�Õ���۪"�| "=��7�@E��X<kX�E��0 	����
C��;"� U��0  � @4ix
%��R󹦀����1���B���	'B] � �w��e1��k���GqT}���R���2g���Ӈ 
�(,�)^2��m������ �Z i�T%�f*���,��~Κ�[k�=X��%��<������G�r�7��[p$";�G��W�T�~\���[V3�v�o�c�p�z����������?yc�����M��(Q ��<�	�F���Rh�K�w��=
��S������
E��h�3 `���tYL��y8.	6M���:�DF.̥�����d� G0U�e� A��]�� �s[�� 
��o710��؋�I�|���Z��(:�H�	�M�3D��.��4TYM39�zWB\[<Ċ�76IgMT�v����Դ��SM4s�2RN�U�;+d  &^��A�&�Q�֢!g���Ȳy!n�U5�#��d��g��z,i;��[��\�ݶꮥ�ܧ+�Z�T(�7)X���`���x`(8,��v�ɢ��`  @�=�Xp_�ly` �������u�{���c�C���w���"�  �h��[C��3
�3��C�%2��_H�y+�Z_#�l�K�?y�<�
��F�4OD�L�
�D�܏�:��)z$P$�h�=H"8�V�,�V��rH��'���	�����d��@)��=` /`˜� 
8�i'�8 ��t�� (�1�;�Z	g>(�Z��@AW����q��jM(<�QJ4(�*�@ ۡ\�n�0�D�4����e�&�&�!�I����=��N��4RD�B�'&��~'�z	���t���s�'����! �̬�>,�m?�9s~�8�m� ��`�ZS�G�!l%sd��"4����)�f*y�P�����:4Z�T���F]Yu� @� R,
)4��3�V��_��{��Q���بF�h�q'���$��M�H��&��܁F�A��G�2܌���nL|ɟ8;�j�a�=�fՀP�J�����^��-�,0&)�Ħ	"��T��e���񣒃���d��#N/��,HP6໌=�
4�k�$m�҆�t���g�J�~�H�W0ޡ@"i��T� �  (*s2u���$j�=�f=:4��rfJn`��sI�H����Љ���"�O�W���hC�EP (�� h ����A�r�"���(A�I��%s5�*4� �q�Ih?�|�
m����"������i���XNK����X����'⛐M8�+HhyX�D,�Ȩ6��'��c,Vٞ)�WN�z��_����!�f�7<FG���y������٨V6�>v��X,$��ܘ6P@��ؓ
|���tu��ƀ�5CA��(�v8r2���,8
���ɧ-��(�Ӭ�L%'�z��q7ƍ,J'P  ��"K��'S'��eMZQ���d�#!"��	2�7��|$�4�i�<��І-,� �hUl���4^���@��h�{�M10�ޚ����I�����$wy=*v"av�(z<��-��l:�Z��#J� ��i�7(��:ِ �%���$�)��"8���A�l������V(A�I��� � '_!i8����=N$n�����ĵ��v��� s{i1���N�ӨW�18�	Xc�؏$�|��F^W1F�<ڊ���n�U^�;�ҫ���8��)AϞ:����eP�)d1
��ف�D������g���ĎS�S�D� w8��B ���r��$ �#�  �'��5�v�<��Ӄ�8Vi9!�Ӱ���;�ƸAAї��f�^�O�F��J�����d��#'$X�K0)��<1���aL1
����`3�li5��b�hy��@s�o<T{}T|ۍ
������d�b @)� @b�Ǌ�mΦ��
!ư����c�/ާl�g@$�� �N����a!r����\��l,�r�BI��0=�72!�2gica*�V�w�I�����Tɣ�UN�*8.%�K�TnALTk���ڝ=#�Q����`$��F�6�
��ɨ.����kQGP���@��=`��B��]O����!�� LK�a^AUc��lU�B��v�؜fB�[�13�H�(���;)
�Hf	),��� ���6[n���IJ�&���GJ�cC���q�ױ�uToz� B ����d�&)Zi�b.�}�бe�=�؃14���WV<���o�*)W[�����?�����\������rRê�5�%86B  䢢��
\��CHD�}+�[,���3�V�#�Ô!1E&(¶��~o���.o�n�ʮ��ꚯ����������XE��0y�Z aR��4,}��qE����ݱA� ��"��q10���+��c��s��*`AȎ�Y������,�v�;+�\�^M;4A�=a�I����* 	�r���ظi�}ļ��{a�\0J$���E9)��m^�y����������;-�U�F�F�-��,�1YK/����L�"Ņ�q��q~X�.�RH;5�	]	OG�IŠЉ���d�R)�i�M 6D[<�:M\�\̱p�l ��H�p������$L?@(�2*]��-uګn&�%�x�B�B��[$�  {5�ќ d�e�x<��K�Kdyڞ�5��S�ඝa�V3��T���� ,�ZkQTH4���MwB1��o�&�s�G�������$�
��)1�w3��
�����\������  A�q
aP��q���5ǃ�~��8����!���΢+�k ����b�5K �1,���o�   S�/�!�kaȞHB�>9c{�����Er�>�
��+}��A�*�߫�	�1~8���ed(�XC6�3�R�3'�D�Ԭy p  pT^^J[��*^�o�o3b�`�&�t������d�gC��p@ {Z=�5`�s����h*9˔�� ��B��˕��~6��B�S�a�T=����Y�����M�%�Z�q��$Ѐ zbJ��P�%iBtP�8FC�j
1ы��ǣT��RXy=��0�c�˜ſ�P�1��ևw}{�a�c�0�}��dԃ��7��A �	���-2B�n���ꑔ���\��ru���m���p$;���a@Q��9�n�� 9��=S��.(��3R#�m"�>�   2�!����hw��>�YU-"c�k}����/;���QT06"8�m���c1�����W
��LyC����V[^&�Xw�.yY�f�7�ށ4g���a�;����$@P�����D��/W���Y��`�~
ĿX�%IAc����G5�!z�?���!�k�t���E"6����� 7�����?����N�y}��K%P@
W�L���e�
��G����8Ƙ�X~�I���!�̤�Y��i�r���a�/+�.X�r�L��R/4�3viI������sc}Ab��b����&�.���@� %�g`�INٳ��A
e|��t���8�������"c�"H�G� 1�$���
�R��U �  ���*$D�Dt'L %����*9�hL�b���6~n����	�Ӎ��p��c����+���#u��P
US�};z�����ft�����H9���@.�� "����N�������d�s/W;BR=&=XM�XL<��-4�P��\U�ʆh�v�WV��������~
����y�:����N͍6��}�R�h �Kd���z]J��{H�_JB/O����-qZ�-2��$}V.:$`#�Z�	��?+�r
�p ��)Dh��N8�hy�<��0��f�G�V1���{��lMW�܂l���I\��
h�\U�t��|6p"����80ѣ����B���!��6�Ӟ��a �p5-*e�Ge����UcD  %J~0�<�5����.gS���M��>M
��U�P(
Q�
�iW,�J�L�["z�4��垅3*Qz����k�?s�Lj$�8�l�:���⊟�J�@��*�t9+h)����d�GI��BpDe+<�D
4�YL=	��m��(��15���(�ӎ�����QZN�p�Ia���LP� !y8l�--Q�L%�r@����\�8��)�t�܃f#>�B���#�@��d���R�1�"Dd,��1��'B'7$ck G�0�%���ת���I�vc$퐺��N/�a�㶦+�;U�k*	�>�G_�b1=E�����bq�OH6�<��.���A�sr��sp�_��b�x����쒒C��')0�y�n}Ќ�̺�Y�_��=�&�R�}ü�;鈑M%��ZSiA�m��p��c+�ܥ�.@�4p �@@ 
U	�ZsK0��A%T%ݐ�v8pc�N�_�ڋ�5P��aM1
#Ɩ�}�͏��W�-i����d� EF�m<� D�Jŧ� �we�� 
�.�2�G9�������^o+3�w���;U�n��$�#O�}Fs�=���I)����n=��j��U�u_Ƨ�7ɨ�<f�pTV����ee�_�O��%�v�K=�*,�� * 6�Q\*�ϴ��b�ƑS$`�"��(90�{��ɂ{�!Y�,�E���~�l�{TYN�ok�g�����N�Kv�0�M��LY�A!.���k5��w��� \AK�:1/#/.yQR� O��!qa?����Q	��|����������&)i@�s�M���:zu�qYx������W��-d���8�+�jGPFl�v��Ʃ(atr�_*]v���sv��D�n��ߝ�`���eBO���4�����d~&�g<�1������)g'�� ܂q0v �%�
Af�w���܃�G����<��~����G¡�Ͱ*�4���  T� Ny���) 4	��'��O��|�O�$�>�nO��Ѥ���NR�pJH�j����L��b����㓷E���dDhMJ��U�`J  �BJ����.�[,e6�iXz,oߟ  ?0<��2��$��/Qqؕ _�\�2"��R���1v��?�\Ά�X���
/����$d� � )G��8DqJq�J��y-�P,
̓���a��R�?3���(dh��%�C��z��)0\��G����/:��SN����=:�i I�e�CKy�A����HD!�U�4�$���D��3=X1��YDK=#JJ�qg��j�W�l`�p��ѷ��hwM'�Ó9���]��Ў�boU:�OY�+wo��8�!�Z�ZET���U�P �0
br3CD<���>�x�8\"���_�#D�E3���v����h�� ��	;�2 �WW�/ǎ�� ������3�K�֗5�
��5�r   J�"-��NLBm	��>`.
.�)T��tbaL������� ����́eɟɱ`�@O�ɿJ�S��X&����!/�,�Z���~���D�1 �p?I�4Is(�xkI�CA�!"�5�Iܟ��A8�zѦ���Ⱥ_���{�:0��	Cg;�T���IF"=[�f;W�%wD*�R��,;i�W����e���D��"�&����ag�=#l1_G�K���p�x�@��(.葒B��{>� �
��Mzk��K�J�/���FF�ȒK�Sc�xRL�cC_��$��Y�����Y��&,NAr5
*
3�	��� ���d�����g��'���XW�F�,@�w���%ˎ�!I��L�
HSO����ϙ��B^B�|7,#[H���q�����D8
��l�`�@ 4���p�$s���ur���<���?]M3C������޼�y��#���x�Ȝg�g��ʕ���s&t��"�i\#��w4:�E-T���>���@p� ���H3�rLW��2�f#sj��oqVGuC=���RL���\Ek��
�Q��h���D"�-�S	�c���<��
Q_�����lt����ٱ0�����H��ю=ƭ=+��g��
R<s�L�������l � ���#�H�4(�;ۂ�ҳYai�
���[�������q2����7��-o�ٴ4W��աe���l�s�gGX����uB�Sx��q*�������U �ؒ	J@Xs����d�(�j�Rˉ%����%��@�߿[��($ds��'i$~Qe��B+���k������P��ֻ���Tl���%�a�����i�� =KǱ2Jy��`-ϒ��LH�]Z�Hd%�[P�{a샽��HJ�q2*4w���`
3���N1���P��?�w/�S���?��z��49
���DΈ��{I��I&2F�L���De �MZт5�b�,=�KqkG�����-��x���44ns���{��#�UT���}�Q���:�G?*�����x����DBjg��rS��f��uUd>���pp|�

�������D$��"��3�H�F��B�V�����(�|4�����a�t�zdfc����
�7�� ��Fg�F3;h�b[��B�@�AAQ<0h9�	�1��U��*BH�6=3\Ȗq�������9I3}O�j�`L����;ߥ��mGF��vv�ꖭ�(;&�,u�����lf;Ly̥U.-:P��[���Ye�7��_���f�����˦�!9����IK�m���)����ӐqG�2�6o��r&���tJ���^�'��Jy���DT�3Z�Q�d�o[�0��H(]k҉=�m��
0��I�vDtd��d��$��J"|��.z��}�Fc�	O�(~b;> Dq4������y�S�>{���I���Ջ���5�uZ��������2B�M�;�k��c���a�cFP QKA�^��8:��	<�t[iǯ���^*�q��MϿ�/�v�a���k��j��H J6�rǙ �]ÚveVkD7l(���pZ4��CH���ٹ`�.�����?���[�Ā�, �å�  ���K��S*yT|J���\X<C=J�2
�a  ��8xiGb�ҥ�ߞ+5D3b��E���E	����9���m��I=��v��-�7�56���2Jlڮ�IKp6����DO�r[a��E��|0��I`]q�j�&��lĠ��N�Lq{�����S,�O���8�����`1F��T���~�6�ˌ�K���Y�U��#���@Z�X*G  ���?�#��eΓ��
[cYwvcv"��Z^]'���@�`�N�i7@"�,ʸ�,���
P8E���GC �iL8
�Z!���خ ���z��6Mb H�0Y˶�g��j��}/���Ny5��B��O{U�&����z�H �8��ς�bªMH�4xt:�p1��;rL��_�h	@om��[+2ğ`p�DA!b��S�(����'F &!( NPy?�%㴫͑-��vZ�>�.�,9��������tU�8�� ����Di j�i�0@Lc\0fx	�?i� ΁'�-��	�*\0ʀ�"g\TG��T��݉u�@ ����aO���Z�[	֤���rl��!nZL9�և�{N��*���$/�
��5�D�Bb̋,D���6�fJT*5��59�2�"�|�7�$/'sʟ��������>|?\���;�"�ѿ�!�����Ԑ G?C|l�K�(=� "���t��2�1+�l}M��V:栠�+���O~�|�(!ŧ�~�F$$֯����O�� �, �
��.�e45�t�f @|�}gi~Me[�z�-V�jG��Ǣ1��S���`l�i�T�V3��#��US��&VK 
*J*b{'��N�w��f�/����������D~�5W�M�<=*N	�i��K�+�m��	�4_Àcr�����N� c�?�(������*.-/�`
��Bz��H  E:��� �Y��F�=��HQ�����8r��R=a;��<tDƬգ� ��@ �G���mP�!uH�"�h&  HQ��U�8�n|T�A�}�+��Qk�j���Pg��D��E)YPxw�,!
�L�@�SME=K� N5�����oP��\��bg[����a��;��Eܘ�{�K�>����uFk%��ꑑF��`HNA�v~�~�L�%��)�x�������� ?#%�^h*fE,�EQ,�@P(��)�H���E�!�/�s��3'��ɒv��4od&U�U�%��Y����D�_�i�+ I#�_0�d	P�]�K��,��0�y#�jJ��P���`/
LM)-�YO"�C8<�ꯥr��9���P���A��{��s�\ ��"0 )(�C���4��@%C�+�]d���p=e!�[h�\�hYăx�`��(r�2t��P
7C��[�8���02�ÝNb.Y�0��n÷���q-Y ����q�,ݲ�n_�ńLS�A���C�����Y3ɻQEw���s`�M�}�@  (L�|+^����r�Z���Ԭ��IAవ�,/��!�h��5�����~�6�����(	
�/�e���  @�B�[�
&R4XO������8)%�$Hx��;����*4T΍�X������S�I���D�=-ש�PK��o=�	��d����1�mpĘ�`V��E�罿@���Y��A$  
C�b#�� �t���	��R:瑍%���6�Z�gԵ
��ޛdP?�[���H:L� �-;Q�.�����zN�Έh@��`����&rD��w^]!I�$�i��@K��2����D��{�]�?�'�?�.��s�����&�P�}[�mvJd6���O��'�ҵ$�v��B]��?���Y�Q��Nܴd�]�s���t�~ˡ�O�k05X�I�j�q����m-��¡)5hW> ¹�ĵ��}��P���/�4�P�n�=��-��B���"[��(�
�����k��T���lJ�WH�FI��2C":���|8z-��$g&K����Dˆ"^Y��2�I��l=&$��Z��l��x�M��'_kH����͵s�;ﶛ;9ح�BΆ�������4��R��X PzR�������A����"�j���X�gl�|&A�Q8�^�D�b�{T��{*qV�Kg�z��o�n0�6�R�12&^D�$$?JK=�c��N���X&�� 
 ɱuA�(HI�u<P%!�T|�1f5��%�o<]�VР(b7������Tw�\Q�gVv��;���Zɮ��`҅�h����&	5�r��t  nZK�,)���s��;���h[n��i}��v�V`��c_CY�Y:�so��D��%�Fw92��CQ�9ǯS�� �ӽ��}Mu���@1(  A�h������f����D� �]��z]f�}<�lJ��e�0i�[��d��x㐺QH?������\�T��2'�.�pfB��q�tx�޴�����}��
��fqG�7bߣWh�����&��( ���`�z4���(2!��T�H��0.�瑽Bƞ��]_U�P������*���������l��Q��g=`0!���D�Y�¦dɿʘ����J��T�li��p&_��j�(�f���X�C���j��46�Ua�փ
�@��T�Xr �l )ܪ%i^���E�QI�ro�B�᣼�_�P7�D������qM��s���9�r~�{��tF�%��@a�"��������*V� 
.�y����� ��
��[w���D�"�FX�<�_h��ee^
p�g�%�El�������1ϙz���P��w�{�4�v����ukȢ�I ���DB�r^%�#�s�(�xl�＠2�! `(�8P_�b.��	����NWn�^0��M1�5���vk��{�t<��l)S��NI_�����$ψ(c]����� I��EA	�]2��ciF�ұ��̵�.8LOh�`"glm�y@��7(1#���Y�D*���XL$B����kwK ��tm�` B�v �LF��,yWS �V��g,Dĳ:��YQϼ��Q��ya�`��`{��
���_�����2)���!w�Q��<@A{c�y� ��� r� � q�h��
���v���D� �E�k�Y%�M=j	�_a��	Y��<���Bq�S=5�m�"�� 4����cxO,� y�S
����V4+�k��j�<����
���2����}�̹�gv�$������As�� DDQ.�3E���IcI��W��J�j�?� ��6?o����v�R����q����D+q  ���4��
 :�ì����y�,��}���.S��>�ѠR�)	�k���͕��־Ge,Hm��)�1g3�2�0�"�|�Qb^����,��
��#�a�6��K��.�)�� ��(����aL!
���v(�՛/v�څ�|X��羸��5tK�@����qT����W����yy�&ǩ!�yw��
�a�ҷA���D� =VK9�if��a�>K(�i����em��x3� w�+\�� d�@J�92QT2�&9ƨ{U��ǹm�[4(*��%�4n��KTj<���8��'�G��
�`����&'$�(��kx����[�&8CA  'j��x�7֜W��6��hg�J�I!̔�G�ܨM.6{���i�i��a��"��|,"�*^$, ��Rn֕�
8��h!����%qpD��-X0��z�
2� IĈ�#Eh���@/�ߟw����~��3&c�N�̐a�Ş ����6�Ib@�s#@G�� @`   @Y�=E)6&��%\��S�c]*��]^8YSu>g�%V)�bXYR�� ̻���}=�$'�n%.���D׀�.[i�E(ZŻ=<��X�_L%I�q+��0�>m��D��H)a�u�_��l$ۘ��A3D�9:$�������u�����[IK�邮������ei��>Blp��t**��[>"@�D��.��G���|ë�K" ��:���#ʤ1�?�Q�\����P-E��%{��аR��e�]���k+��;�>���S4@��+˵�X�TT�2@�������š �
  
��{�H��!�V7&v��'k��LX�5�tY��:��g�i�t���5q�l��:j��$\~�L*f�<���,�Q�-�(9�����`�|/��Ҋ^.� ��5�f8��Q�bן�N���4h�Z�3p8
�m;U���A����D��-�i�D@X�}0e�p�a����u����X����j"ѐ���1K�Q�_QsK�S机��
BQ(���".��R�'6�<X�$	���Ǝ�l3�+��.�rH��^�$'X�"����/Ua�q6z<{k�zs���8�ґ�P�Zm1H�"r�����b����CTP:�e����l����}V�8dp��Vj�c7���B=�
W�{�V�� ��i���Y�ɲ*$H��	���ER�xP+Y�v�b@�@���h<y��@��6?�a&��V 4��	�HoDq�nPVZ
���2h!^_��,���r�V\�*��� �Y?L(%�?|�6Ek�1%��gW�6�����
ӛs�X<^��A<pPȘ���Dʀ�=Z��,�N�۝1cV	��X�G�-�m����P>�D��1 �K�p*F5s�ꉠ;}��!��u_b&����J���&1�z�Ћ^,=A`��A��̑��ȃ�N�m"l����������DG�Q���K[a�WC�[f�=�o���j���Cˢ�Z���vC��ݖ"���v�H`�NJ5�vS�B��-P�z�m|%t�8٩�UIC�LT1YK{����n���C�0�)��	��EL���
�    F^���[:�և֓�,Q��:_�}���Y�b�aRwP���/�0y<�n_��Tk��������i�Y�?[)���>S�N�usNnyҤ�����ƍӕ*� @���Ő &��p��m"�~l���Dڀc-���O%�80�X
�u��Kq-��l��0�<}WA�:U��ڍ����,�����i�7'��QC��+� BV��P�M�ݎ%��ISȝ&b�C��HD`�l#��2�S���!<N��ӜS��	~���;Z9k���l*�{��i �%�j�f�O�)NR����g�`��T�<
��W����*J��"��@D��ZpC�.���.��
7JbJ�1��T}E��®[���4#<	�pE�\a��Y?�W�X_�LU��`   ��+MR��=�&�]��R.:��<N)lp��.�>˲�˹un�5:Af�H��E�D5�W����V]���R.�ړ"vZ_e�)3��8�����T
���H�C���D�BKVk:�e��/=�l	��c��QE	.<ĵ�`@�8�:�՛ɧ�������HI�>X2�I�ImR����}k
�籢!��� 0R@1!���)¥� ���N6<ڔ@���Me�I|ؼZ':X59�_
��k�z,�A�A��r�G�3�jY���)�y��;ie�#��{)���	�Uv]z�OK�x���Had!��T�9P/lPX�~�4�ܘ�R
v�O�汍�c�u�I;IIOwP�;��|"��s�x�3��Ñ�qK��s���xr7���XaG�o��ܢ�Ѡm8��"���U(�*%+du�M�Z��tM �k�s���r~"��L<ܓ
ACa�l|� �����E�BW���tY���d� E5Xm=�<"�<�� Uq[�� 
��n�0���{�.��uh��[CUr>>UGd	�p����
:�6�U-X��Qa���W����;�i�d�����w��4mg�{U�%<���X�%7���X�Ľ�5�F*U����J!�$2  ��c1��Xjr�}�v�	��x�Q��5�"��xNbc+*�:���jRy��e���]G.�ڍ�
FvT���̅[��nh46��J$d9bj��0�q���A #�X�����y��o�'"�`Q"���ۨo�t��T�����f�
��\��!`�[َ8���(��]�̓���qP�B��ܹPa􆲚��`r���V��{�6�������[���>y��޿_��ʓ&��m�����d{�&��`� :A�-� �D_s���H�-� "b/03�0|��%"Cs�_kLH7~�W� -V�ʞ��|(.[��>pk���E
��`(_�!Tc _
�4��2�h�.�V��c�΂�^�6�Y�r_��]�`��yHw<�1;���2���AU�yn��Y�\1e!Y" �! �A�2�*X!��*��l�&'3�ý�yɚJp�����5=�?�����e���)��g�����\�wy�F|$ BH8=�`��tBU�i�2��Qat�����uFW4c�۞I=Z����HD��I	�Zx���Ng(�	 J�[�@
�"�`F--V�A^�xUg/�0�b�J� ���b%�y��g 8���%�\D<\�P����D��[:�A��J��k0�DIt�i&$d�+�- �	(��+�a2���4� 'u�D� (��p(#<pbE��g����'c���r��w� X_Ji�D�Cj�/^f����Mz���o�����u�c�D$�Ƅ�$T8�j���P\K9�K��CcY(B�#rr
4N���:r%d�<0��#! �����%
o��n��&��7���67#���i^S��R�`�,K��">���6�J��W���y�x6�(ʜ���xŪd*+���ңISh�c�����~-
DS.c���>�+����?�β�:V�.AP�y� �/[s���Uv[CϠy��V5rJl����)J2K�B8jH='��"�
���T �,N�"L����D� o[i��Gb�0&�	��i�QA���	PAF�E!V.���P�r�~2���r�ȯ6|g���}�o￭����������M���b=�4P��+]�C���e�W� M�&�{]��|r�`��z�3���������
9���
�  �	�I $�Tʌ�=W-���n�d�]���{{��ԕ��Ʒ���X���RŎ1Y�M��24�?fZB��yٴ�a3�E_0_#�T6�<+�l0](�Fa������B�0���~����]���q&�I�9S܄��<2��U ��#�<�N�C��j��9{��q�	N[-�*������ҿ��g�e��T�Ijt�(>���:��(/����d������HB?��<K)��c��-���o��p�j9��?w��d��Ҳ�X`�~�Wq�Z+�w9��)���Q�����>Y�s::��2�rV���@(ʒ��#����D�t�=�eb@J�0|)�N*F���g���:��V���[��
�X��J ��R�6D1��d�u��x�v��m�I]���z51U��J�`��
X+�FF>BS���@�77�8��12FE]��A �?�m�����Л�48c�R�\�� 9�Qs��+���[/�Nn-��������%���k�X~� ^�6wT�>���l��i�v�D�sB�"��:��!���@����R�`��
.�.(>��Ut `���0 �<�&��F6@X��� _:���dԀ�&�a�C�<�۝%Z
�{mǤi���.��0 W�3�~ϮP�	}���:5v��*N��@�D����~��8$!�<��� A$�DsC_���j��q�qJ���J2l���t`g�Q���;)z�^��х���Ϟ�}���Ң��TΔK{/���Z��+3��O<����ʜ�������������!ӣ�32�
��^����3�G,.�,�&D;�A[�Ouq�	k���y*e�^^ٴ�e�"r�LX9��Z<�PV� ��Z�T��!]����f��n��=a�傟�������}�nV�-���f�4�ѕ��twF�ﶦ,�rJ��ҐD_H�q:kl��D̈Aɭ�Rj�'5%<~S��]'2a������d� C9��+�I��~e�
��cl<����9��97���!i�����v������}�������[��ta���������6�k���W(;��봂IԤ ,�U-���G	 y �B	g9�.�[tO��&��MY\PdV��n�J�OQ ��p��Hhd��%�M�{:���GIhQHSP.��	�r	1���H1��Yb�5�>[~s5>*';96��#Lww��C)\�2>���c�Ц��{�m;�u�}��L�6��	)��u�D`@���ȴXk'�)��Hd�6���cW'���=oX�m`v���,����������h�����꿞�̗�d�j��1�?�T���9���P1�M`���V�z����SB�hBD TCc���D��G���,BY��\0)�K�i����L-,��ID��5�]�S�_��m�j��U@��w��oeo{���g�|,Q傑�V��cX�4�� ��"�o��@n3���z�	���t`�_{1�<�x_��R����o[vQ�FC$ͷZ
�&;[�*�g�R�!554�l�@�(�&-�Е2 
UT��7FdШ���?=��Gj(#�*�&�	N�~�������٭p���u���I$X�J�x�����  q��B��F�
4�{8��x�>~^�Z��0����OD��/y#�+�x#D�헕
�3�L��lS��tr9(vL,4'���Z<�!v%h�j�^�P������+P�رp#@L u��K����p�FU3n���d�a5����="m<�*��ag�TA ��P���������qW�?����>P�o�;�ǒ������|��	%��	�.�ad P����
�2������|�"VE�ՙ*����9;���4�O<����'��,���O�L+$|� 4x!����z�Z�k9�J�0�����%L ǩ�Z�A y��� *$)��� �оbD����K����G���������!.�J1��P,M@ɀ�
Ko��6�j� "   	d��PR�R���c;N�e�;j�Ba\vjݗ����,sw�_Gv��$�
<7��_ƏŇ�?u�*�U}�O�ȃU�5\ġ[U�6}���<%L�"�$��H� ӠQ2閷��aX ^V
E񊠍a������d��M�i�. E��$��M�]l<M��x���yG[��+�t���HI��.<8�v����S���4�6
�A^gЯ�ϡ�  
!&_��4�s�(�
$��(A�s	P݄�jl��T�M��<����'�0:~zt����杞���ZG���PIjJ�k����gOy�甃ϥ�R�T���A _�}}0�Ll��i�h`,<)d��,���� �n�fߡ#���Q�[m<Y��w�1���F����>y�춉Z` !A�  (v �CزU��
�>����$��)�YST��H/ϰ+�J6��6
8���h9���T�'�}v�Zmg�撢d�� '�zDϬ��,�d��_�HQlȂB���d��@WsB�FD��1J
��W=���/�������k	�؃d�T;Y�ώ�p�lEJ5uO��@����Ug�G�������@#ˈ��~ �@�j����0F� #��-m�oF��E� �	���&j�{�ā>�c��G}FJ��x�z�΄�i�6�y��Q�Œe&Wg$Ec
��L��Y� PdK G#�)���Y�gU�+Rp�Xx,|Pې�q���q�(|�j	@' ��{z�DOP����A�
(�^s#�>h�hN�l���vY�:ӆo�K��H(Y�s?�����,�j�<�Ő &_\��</����\�^��4��$C��!�OQ�Z��:����QN	
%rH3�m �'[4����^����d� g5�{A�A��]$�c,<�A�-�`�:�ߕ��W�����s'����-�T��Ҷ�r@�   �BA�PD����=hx�3ثA�ȭ�D�ڎ(��� B#���-��i;�F�D�
R� H�09*a����%R+�V&fa� ���#��Dv� ՜Ȍc�2?ϙ�Gҭ�7�z�2W��U�&�2h��w�4�f����"������@�`A=[��������A*�\F��`��R�M<�CYU"�A   Th�TbCIp0ih�	�$��Dz��"�rdV��"m�
�P0IE�QJY"�Y0�QRN�����F��i(�˟��%2b��irY�w�kd��F[�4`������dҀS=]k	 3��0%��{�<a��q8��N�Z5��C�d_j~�M�}�MQ�Â���ޖ�jh 6�
�!D<q>Kw��	H9� ĐJ  �;��2�Q�j�]-F��7��崄h?ҧ�N������ܳ���_~��`�0�H
B����\]B(�lB����O�e�����\�����k�+�w����ͅ@ ����|�7�� g��"��%�+��T!p���Ȇ��SR(���-�o$o�ĒP��̤K���*@   ����3��ip�]��os��X�H���ܒ��	������� 0@�s������x2 z|ց2��ujS�h������6��s_�}����������K � �DS� ���d�4"Z�0�B���,�
D�k�$m�������au�����������@..��^�1�JJ5֔��N��X���*�,�ޱ�ʦ�0(� EiM��J@KuM��ˁ)Ţ�Q�*Eq̢�ȣ���?ѽ
n@�h^I/��M$]�#���r�N��!萡r]�'w�֘T��g�2b�r�GE�� �P�t��� �˃��9J�<�� 	,��2�wqbu�J%����e�����©l�5�r�n�;)���
    (J1cB�rNR)z7��>W.јf�3(UZ-�Wĵ
B�K�@����i9�����&�t�*d�F�'~�(�}'!z\����Sa�o�d�tJ�-�$��ƃ�(�d^����d�F(Zk	2A��=�
��c��'�
.t񈈼�����4���������9;�^$������;0���߼A�=��=���]�Z� Dl��/	�M���-%ȟ�`�7�Ir D��barH���Z��C����A�'�寨$��d��8���Q�v=�.q�V
L�hGR�P�&Ku���sC� �X�	�EH*qY�����UD��z�y2�����8Og}�b��TH�V���$�����4Q���U �  U0[4�Z�D��O�Z������� LR+������=@�D�DѣD�$�����s��D��?q=�#E�&s��[����gf��o�ʬ�Ac[m+K�y���\��͗S���M+�$H ������d�G/�kI�EAk\1#PL��e��
@�,���PMv��7BQx�W��{��S��,�$4��vB`(Ǥؒ[�(	�BZ,� �#�$�d���4�C���{�"[Mx�{��jٳ���+�J�"��������!�,�ľ(�LpP��{��dB�.ɔ��������	�Q+�{#�)GI��2���mb�s�. P�Vd �	K�DɄ����Aڪ�;�.��tz�}��*D0����5�3�6YG�02��d���k$  Lu���&�CZ �1��G�\�Yrv�̟U� 1~�{ē8���Ʉ<*`�XX`d68�����ށ��7�96�F:W��)( :aP���H�=�L	��`��m�_���d��FXS	+�B�[�-"aL0���n<�� �9�U(�b�bK��_K�$��8u`��k BҮQ*�hCI<��Aú�G*?Ì�r�:� Jp��M��o���:��.��*�[D�n��|jzi��
���ᚮل����dH
��M�V,�Ȳ$[ď�/�L� +ԗ$���&P�R@ ���/B�o�B�la9_]B��3`"վwҼx*�Kw�L¡E��-e_�7�4X�$M����.��f��:�V����!�#$   �BO"s��M��~��Da��e��H��gwX�2�,�c�C�C��;��y3TP�a`��X:|Y�B��jK�!�����z�?�  b� �j?��ma;�t�s>e0�	���D��&�i��WDK]=#Fh�gG�kQV�p�
X���HG7���C�+�8&�Qg��A���=Y���8}�A�yP��$<Tr��p����q��l���(ќG�u8�fd��eBb5K+�I!B�dC�Ћ%��+��9E��	dwOg�����ᥚpL/RڵT��{�o$g�]�k@uBA&E�f�s.6�2i���^��HB�9��I$�EV�bSz�)�/�o.�*�n���u�ϐ�#S�������`n�%��b�M[h0
n~̩$+g�
k����#x3.i�w9��
����qH�ER�:�`Ǟl�1,��~�ị�Ȟ�{_���yT��:S�>������ �
@ �$4���#�H'3bQi�D���'���D��&Xi�`U�	="h
ܹ]'�K�a�, �y�W��	���eM���q|�d*���
�V7�ez�$�D�Ab5���������$_�Z	'..�L�`Âz�jv�E�S�ZG���M1;�E���&4��0�� �C���������x
!���GLs߿��b hxu��a��z ��63�!���Uj=�
��=���7��00�6 �P4	����2������ �$l��u�g<�CSRR�kP�*��$ %�
)���#���!݄�6��`��ƹ�+��G2(�](���&�lh�("@BA���P�d�C��"��<�u�%� ��NF�C�ɜ���{�FH  ��h���#�4ptT����D��Zi�BT��="l
�Si�<�c��x��#&��G�v�_?*s��g��F��)��qq�jl�s����i��aѯʢ�*�(zMJ�sV���i�u�^��v�HBc"`�� D�Ѭ8ȴ������*��q�>�׺�&l8�F,����@���ptSCɽ錡?�5>�q���*��;R�b5��>'QdK�_�֛���� >���P� l�g����Ai�K4$u�c���`�"�
6�רP������ !J����f��
2�.i[��A��2F=Q3�l�����3;e�]廿쎱<6��}��	\��;EC�s��_N|��/��
ɟ���X��DF�L݈
�  �#����,e����e�7^����D� "� X�C�[��a'L	�]cF="�8kՆ�Ud�.��"S4`�A@ FUu ��l��g|6�#6W@�0)+)��P�"�hSPj�iH���e��PK�����ҘVB@#���/�"j~N��]���[���Aa*��5��$�>o��o��o����ق�����Q�NY�w�߿5��\�����h�����4�R���R��5��9rqF��@dsb�������E�
* PĪ�����p`h�����$��)��a\�}�@  ��R�+c�=#SY�k�N�XG�s��<9'���� h�@����t��2T�t��˧e��C�y��s���jTUjLx&	,y����tT]�������� �
���D�#=Wi��Ye<��X]e��I=�����J0p�s)�k�%.Q$�/.<��Hb�޵��Ã��rt����x�vp�<\��3�����&mۭ
��u�>*d���8����Ȥ6�l{���a'��� `Ta���@@""4,D��r�a����j\%3O��E1:,J�P9!����Э6G΄p8�s�>�N�%��ɮƟt�#�(��:`?nʅ>��h��e�4w&0!�։�7�4of%S�#7�܍�.��ni�ɵa<����p��_�M�XG�T&W��)��f��Xz�Y�w��|�}�	O�<T#���j6X
��~�35�*�s%4D\�a���2p���::n�����!($��HÌ���p���D�K(�Mb  h�J맴 uw[������2� �����;�c�����	H�\!�3��*Ҩ�]ڠh!�b\=m�5v�@�#דn#C4���+>_��r{7n�Q����5$��o��n����5=����>���K$F��e�*�89�+ja_oڧ���\���±����Ǥg�����B� �.��@Jz��	~x�_u%r�f���8��G.��|,��$�$N?������0^rQ��s�r��'�Dt�q-�E�~T�Z(�l/���j�Wz����
�]��D�Yc*0�΀eI��A0��1T��
���k��_����>�G�?�TN�G��۫���)�~ϿOՑYy-�w�����rgH ��Ɍ\v�ƙ�~����dc �I�_`� DI;�� N%-c$����}�����Z�3�����5qNnU��-&%���-�1��H���Ey�@�X�|������x�ה^�7��a_�%��⹽������7*4�(:iZiD��ea\eF��w�a�K��["h��P�����8�C���8��l�3R�ʻ�Ѥhz�GhCv�{h<  �e�% 92QAJ�)�m� �V��~w�̂��R���'����R{��B�ܗM��w!�'t��{�t�㿟���>w��9����ɥ�i��!�?�p �aV������+�}�����" P`�&\��NG�����S瘋�0Wdr��_�n�T
!0�`Z8���u�I|�+���b_�_�G���@ *����d]��G��	bA�+k$"�M�I^���6
�p�p �Rpt��7�b�=��&�������6zNUm�jK��;��~PQE �/��� ��PXg�� !xg

�@tld9�㣆F������Ǉ1�C����3Ǫ�U�9��P Xj.��(Zv���{�-ZDrG���R� ���2�����  FaMc�qfdT̪���ʟ�KCz�� � `��3T���Ϊ��A�Brq�Q�2����B1����)��˔�T�s�]A�G�@���`88ు���l�Z�l��X��/��&�D���k� �|-�F�l�^2;3�GD�ɜAwΈ�
�jJ���1N��>a�d�<]����I��������dR�%M�c	�J!�l="
��b��oA+��x�(�qTh��P7H`�jĠ�z��O�/��5I��r~g/!q^�a,Ar��,�ӟ�ޟ�Lϯ��+�́���  ;���>������Ʉ���F+�[���̛�R@�� ���cC�Z��uʗ�T�`@�:�Ж����{ "�<)R� �J7C�.��d��,��EOa��8	� �t".@ ���3���J��p��YhP2?W	'ڏ�2�p|q)?Sm7T��T��Q�sa�a���t
0]%��$�]���5
t�[?�<x���L�L2� aK ~��hb:��Au��~��R?��6�ó�(D�M_磒���!��c�V������5���Eϸ���"  @�]���dX �Zy�J IbN1"F�Qc�����8�% �%F���a��U1܈&˞n���r�f�u�c��tOO��_���{m��i�8A�g�D��C������붍����U߯~���`<�g���:c�"�P��+�*��@�0�"TpH�U嫄�N��l?�@��z6J[�~QQ!E�8b��1���Թ�)}�1  ���,��ƚR?X����a��y��:�HĒ��ۣ��U�55f���F2��-e9��b^���赣W}ooo��dO��r��L=�r�rƆ��SEә|n0�P�_'�p��x�%b��ߵK
=��
��jI/���N�]�,�:��0 �8�Y*�P���:�;�&Ƣ���L��S^��Qݍ!y���db��XYs	`=�{�30���g��m	����@_̌�#��O�/!�̍���\���������03$���D)�Q���� $x�O�W��XP��X�Ӄ����Ǚ��cڠ�����-yi�n���8
�����k̪V�"@ (�Iɂ��g�d��'��FгD�	�#�p y� �^'(������H����^)� 9l�@ �X ��;ҳȗ�r���ի�4�Ru<NHQ	�
*�,UH$A�A�`YO db@
?�H� �ˁ>-�	?��8
&��׌n�
al��ցpF	��	��tQ��V�Gk�����u��	�h�վ:��9�y�OlnT�O�	�O5�o��-8����dw�8[�K�@!]%��Ug'�jȻ�m�d�J |X"�b�=�@�J�]����1�T��d�����C�@  �.�� ����9�
ɋk��4C���ʤ�!�"N�y������/1���e��'�ލ�Ԃ	��q�� $
+stg������c��3��f�"�[*��x�����?����P����i3�1���S�)��Nm�^�
��ҧwh�����@ �����D�6a���X�����	�g�η�r@-���]9W��N"������Ѳ�WN��	 H������2�
��&�Z#p������X�X�@)\3�XzÍ4�@F ��£�0'��hp�~������.H=IǵK��3��	����d���)Y��R;'�4<#^�c,$K�������@X�@3q�'�G��7��L,��]�h�����pE�����)��a�}�
�=޲. �DyOɱW�kz��8V>+���w}_��H�P��Bd6�|Mr���	�舐���W�V����U]�������`��i� \0t%�p\̀�%�L�u)L=�b�Ĕ��:\{.瑾��׼.n^�\�v^'���ɦ+&�Ԯ
���E3&>�[��9[�*�]���O���8q,%��>��/d˄wL9҂��w�����q�����=�ےMN��u*U H� 0  e�x-\�r�X@`�C1hf0./���v�������
n:;��ޤb�"-̰JQ�0�I��iC����d� [k@�-�0"f4}g��mHڈ/��	Vթ�����&W_g\�Z{�(�g
������T�����K�����I\5Ё0H�ᴥ�rO(٪��$\�˗RU����׼Y9Pb@  E!^B��-�HB��wuڲ+�֌�.�H[4�X�3>!�Wd>#��R�@�����.^��� ��� �D���i���*jS
�����K�1� d/���QqO��/�){�o�O��������"��V�$P팇�BB�   2��i{�Ge��ɫ�����]������Y@�����,}C��ƶj���6�����{���P4�Ԕj`Li�k0�m��Q�d�ه�p��M�P�齿��C�¿+����d� �(�i�*`>��,�Fx�cG�r@�l���6o�Zse]�!CH��(�e���ͼk]�p
�
�&]oQ�� *� �h/���E!��{�99Q�� o��츲l� ���0,�cg�OUA�U
Ǒ�׻��*�zƿ�����,� mT�α��l��QFNUy�s���@��%D��֎�ǰ�6�BB��O�ik�"]O�S`f�@A����q�c?�y�(���L1��h�K��� ! "�E�}T�ʒ�+FX7Vb�e�F��XyH�<�@_�?��xJ�O
�s�1�M�w8��|��Ϝ>�;�I4H]�wI�����c��0|m��s���Ss���%���<'��	�9���d��*W�	2�G�+�=�8�8�[�=cA ��|�!�D�� $W-�C%]�3������+�>A�Xj��>�x��P\N�]��d{�I7*UH�  3	0�8��U�p}��B�G̡4�_�$�8��!nH���@�C�!���X���<��I��~�y���V���0�\ݝ�
�d ��p�6��ғ.���$Gڝ��  ҺPMbp��{����
��C�`���Y�\B����P�nL44H#���z*�@�IƳ����	�*��1L�3L8��&'�>����̐���T�8&,D"E2Vx�m�VYU�
S�ր����
�����R$�c]�?K�.���������_������oD'���,� 
���d�}CV[	pI"�==:
ԕc��v���0� 9۞<
C�%���ƍ�x	)�
y�*�x2r�[��ȉ����� `Phq�
�H  r�=BGE���K�}+IS�LHʺ��dL��FבH�%9h�b�vT/ec�Ie�تUM૝�i~��LH�=�s���r4�K�E���_��'A�'�nNX�@"  ��dȇ���Ȫ��2���� ���	o��5Wd�pPV	��Yt��w��l4[�I!�  8Dq��G� $�J�[L�G����MR���d/�=_S*噫�������R��!-J�b�����WV��`��V.�����F�ӡN�R6�]6C�J-��Pj�F�O����@ ���d�[(�Q��@��m0#`
(�TM52���ke�� � " �du��)�M�:�+xi���;�KQb�N��[�H���:�����ˍE��$��C�%ѹH�Yʐ+׵�k�����9uǋ�&$z"�#9Ѣ� ��M}�{�T���^��%�,ׇݲB���2�D�<���0�_����\���s���������&V�O�7~��T|��(=��_
��g��E: ��n�}�u+�	A6�üK8V�'?��J a   AT��AP�h�.��9\gѴc�S%Rz�+4`�O�j�)":�����
��]QO	�F��J�J+���ɶ���ff�$�+��e$��Iq��fR��~��
  /Έ ��(A˕�;���d�#�MU3op:![`�
�YM$s	j��i�pJ#!�	�䀡,u�##�7�x���9�x��ٝ�:�M6p�e;g��$��� q�F�j����������
�Ѱ	�Ԡ� *���@�%�	X�$9?K�W~�*�?�e��y����b^gwΊ1���Պ]y*&�*��k<<W��I����!)(ځ\$S����@%)��m�`���{�����`W�̡ R,��Q��0b�2�p>eo�;��=煯z����X�x���VUż�̤DEO���<� ;  ��e )�;o���t�z%y�(� 5"�Vn�*aM��Q���I�M����3��vFGW�t"�>�=������ur��ER���D�3=�SL:�k��i"^
�ea�0ÉYl!� �dp�뮳���rBF�@ "M�*�V�ZMU�}!��U;%��Ԇf��
u2>�7M�Ue�UU�P���mCs_�S���x�dE�+S�x+�S���p63�{�h�]�/�u��� :J��g�u����^VT�#���wrT*$f�Պ��zh�������,��y����������fI��5�̦֡�!�U[��2�O�q	-7�3���-b~���(�8"jP�  =ꉱ�2�K��(�������b��hޮ� pz��������I4��z��F�(_�)(P�z�e�x/M?��;������k�1T��L<|�ĈY#0կ˯M      
���O�2��F	t������D�"L�S)`f(��ab|
QQ]L<M��&����xfpH#Ԭ���,J�E�".����j`I66]o��5����w�����u'�g���7�;)�l�����pw	�Q4d�"  ��� ��)�첤j4��l���񬛼&���#���|y�憬g�3���dz�id�[�0�mȜ�"��io,Ҳ�ԯ��OϑO������o�t�x�r�D~�"�^�2�a�R��V���Eh�Mq�Uc����P�uH��e�_�3��A,8jfl��������k[��D����M
*J�ݠ��]����浕#<	��I�U�94�(C`@�Or���9��̗tؤ����j�����7/�
�0(_����<jX����D�c-<��ps蚸a�N
m]L-���k���)/����-�eJ��Q����B�r�
~6,P��yIr�
c�0����=7�' +��Iٕ
  �n�s T�mUUb�y0�/�`�W�ԥ?4�#hb�BڕΝ��78�_z�_R�4�Q��7�-���(_�))��X�+?͗b���
C_0�����k���u�ýMJ��@ a�%^"^p���R	AS=ف
�W�%+�7�~W��?�4�jz����K4�~�`?��k������<)TG�4tpѳvv����_�����<d,l6���{��  +dh�m^�HK|ѓ�P���nT��GS���{���+��ye���4K�����/H�7�vc�H�*쌡����D��;Գ/S`i):�a�^
-GWL<O��&k���;#���ŷ����m�T�PA�{5ࢳ��C�w@�  ���������:T&!�M���6���d4Zc�&���Y�N�$�e���y���?zZTG�K�� K"�#�w�/b�(��І2�$L:GD�	č�vQ�~�@  yQk�1(
�!aǮa
��ϓttL���R��R?Gw�E?�)�]�be�ʆ��7�ʩ�4��?z�����iR����@:��5$s#;��df;��#��0� E�   �w$�`I���8_�C��G̾�R��5`��}ϴ}�o;¡�RfQ{;S���0? �ɫ���G]��3v���qXߣ������ ��f2���Df�_MVc+pm(j�<����[L0��*,4��� [*�	�M��`  P��.��
�:-a߀!��d��<Q�'�L/)xaZ4bd�1xܮ`X��7��" ���Q@�N��lqƬ�j+pسҎ��S��W\DB�9ל7�J��*@J   *B�M�����I[1Π0]�dAY{K����as3��;3E���l�q�o�����L�]��B��>��܃�TP��Ԣb�mCh�z���8�$E�+�    ����X:kK��O A�� �5�ej�ޙ���sΪ/�￉�8�,F�B�ylC�(7�n6�D���m93�7�S�+o�y�T;���2��'r�@ Ř���!e�s��Q��y<��ժ��ĝ����DB#
=U�9�^j�=e��T�<��x&l��M�o�������]E4��F���5s��M������# �����ЧȬӕ��SЃ��   &fP @?�0�T}e/j �t|��Ζ�Ok���BJ�]��u��v��o�W�?����{�`�sU��A�rm�����]�<���l�K�%W����"�1=Q$�:�jH�!H9�;��-s�Rd�#�����=Sj��M�i���f����[*\�u��EDb�S<���e�p�tO�ŀ��3J,5HIl���*�%3/�h����c���.u����<��?�Q�e`F����KP��J��~)^�w#����R�:�ۭMO��+�\j";T���]�����D0�'MX�	+�fH��a�^`�X�1m�,0��iC� e� � xCb���̾����*��}�p�|��6�S��Ɉ�2�tj4��ʍq JJ��B���J-CL� Tq��/��"@�g�+�t��z|r�H�g��� oX+b{����f��[P�qm\x�/���)�|R(׬�)̗�J��O�~/�16�73&�ƅ�J^=�=���X��N|^���v��
1dI��t�=���%
d�R,���\+2�!��rT$�&h�F�*�i1��w$7vH���W$l��ʗ���GӾ%�ն�|흋'��6��v�"u�@�Y7��d�����{ �Ul6�T��I�2��!i��y�gۛ`N��H��5,����D��>[���Xj��="LQOc��R�l��4� �_�҇��bԣ?��FS�{�s��fgu+��z�H��r�SK��vt� i�Q�M��  �B��3��?�H��sr�Oi���(5���� ���R��f�w
#��ZӶ��[��N9�O�D�NjZ\��?ha/�5Ȭ՘� E�]���	��@�J4�Os�r���D|��P��W��١Z��*��]_Uy��j]㪙�tUr�y��C�S��虮�d����9�A����  ���&�Ac�2����d4��s	N�d|�CGg2(�-b�* �+s���y�D*�<���y`nq�����֮����
T���f���J�Ѱ 	*APtI�B�l��e���D
��%�щ`X)�=1�
��f'�mO*-䀏a�Q;�m�'�$�`��?��JPl�R���}+Ϲ �X:��E��$h�!#He�ҧ��o����k��h��L`RJ@ �Ñ\y��!�6C��Ut�[1<�/����K
�i7غ��7z8������E��tu���;�{��%)���݉`v̪�����̒Fr0#�T<c[`(-t���#@H���e(��H�������db̡S�� l����u��"A��j�0L�?	4VH��V�   ��%��@x1����I�XpZ�_���h�������Ȍh{�r ?�27�b8��e%�hNF
!	��ޤ�ڄ��#�,��Ѩ�,   INJ��"����,���d :M�k�: �n<#1�l�k���@�md`�8CoLB�~��kU��M��bĂF"#cX�~\�KA}p~���G�}��22y��v���[m���0��Èp(�a�-ↅ�zᙙ�� ��B�s�P�X]�����i{	C__�R�Pz꫶z�L*�5�j��2yD���I �M�!(*��p�<BU&钄�e���_:����E�HP�J#cFaq�a�_G��G̷�0�� "]	��z�iX�! h���\� p���P�E�/���j�NY�^5��uѦ �#A��+��&A�U�H���l=���
 ��s@X���� JИB�
�>����@��q8��~�Bed��~��5�|����?���d 
&]i�Xp;bی0b�9i��I���|�MCḙ �<�����u��h�.p��
�!����#�\�`ڢ�@�	ԐEr����i����9��8KKK(7=\P�а��E���=7���������� $�^` [��s�ȃ)�K!�(���*� �43
��>�a�D@���fpB�����*��.�����B�Y��ߤ�
^�t]��D�c�fEhgxm�`
�)���j��kT;���:A'3�L2���$�H�������$xD=!��� լ� `��,
#�Jf�ЃE݀4A
 e\���?n^���|� ҳ�m��zn��RB^Ew)��p��5
�s)N5x<#{X�Z�'z�E��U�B��+RB���d3 �.Z��`>���0"@�gm��(�ӈ.t`!��D����6�"������@ҟ
�������*jk�*e�&�V�V'2��_cQ�B"rޕ4�#�/ؑ��%��R��e�Wb�jMȐT���h����g��%�����Q�F�/�[�'���P.Q�}�?�������d��! 
�f`�M3@�EQME�(��C�F����F�������]�*y�b�d�#5R  $�9�2��xZ�y�G������_��hÁ��
������)��0mҗ�!�G,K
 ���E 5�����B&^ &�q�陀D�k �I���ZiVF#4}
���ҮmlJ���l������$ÜA:a���T�'�����dL��'Z���<��l<�u;gl$��ل�y� ʱ.���e;guZ��	}rk4�K��_->�4?b��%�IޏBO~۸Ƙ@]���i
�d#0�z�5�,��o��ͽ���>��S^q֥iUp ��AH @�
`��U�XI�Q��r�����$�;��\��<F_�9���~G�⣐a�"h  ��R8������2h�xZ���u)�ż�	gN ���rK�Cy�X(����}1�1]�(�" x#=Ba(8�
�k�I,L���٩�����i��P,
Pۤ�]ۑ!�0�`u���O�s�E"9N%�t�����d�>�����X39)I�t#��1A;u'E�y'��3�~�~t�՟�HYnBr�Z*#O��(�����de��&�cBP5ۍDbJ${m��H����� � =�7���Ѽ������4���/g��b���5����57���t��4�� @<K��'��
����?�:X+U̬@��÷)$����p	���H��P�R �yyE��
��3)��]E�L��]��*�>Z4D�����B��g��	_5r��K�[D9 ��3��J�y���#��������~�
�  ���EN9�uJၹg��d�>�e	���"����q	X���2�4x\&-�7L���J 1�JG	~f[��F��$S�l�6�r����>!����g)��q ��
�}��.�������P�����w55�	�bD�S���$�u@�H���d} �,�I�B8a�Y,��]m��������8 !<J4h����䫚���uhw���;v+)����?�l��66GZ���l�)�c �EA�R	��B�ha�(<����r���s�[�ZR)�/�뢙���S�f6m�}����ؘ���2�2=,*����_��u�.���pD��k�ݴ�V0;���j���>�+��迯�TV�J
8�\�W�C����jjq)m��8N@�)+�c1MQƝ-��F�x
��|���r�}����;�vHq��a�O��+�J���_����h�7���^����$ς�/�$�N��4XR0���Bni�/9�O������C�B����X-��L@�j KB �M@�V���d� J���"/c�80b:�yk��
ԋ��`�X���A�����������)���1ElS2��z��Ru1�ʹF���c��xeJs�
B]\����A_ڎ��V�{Y3����Y�g��"�}P2�#��%N�d��Kq8x��1t�D5���@��I�����ڃEǮQ�Qt2���	
�
�"+$��DB�K�L^6)(4/�q⋽�{��gw˳�X�턅������W{0��P(�L�������
MV�" Pݖ����]�c�,(e���5���O��˽cY�o���)��pܰv �   �7p�����WUt ɀ�Z,��~�U�Rʨ�Qn�hc��z�f����u��W46���d���=��*�3!�\P��k�����<��$�
�bz�땂��f��"4�È۝t͙�g-�V:�  /6�P+�rhƌ-L2߈H���eyh����4(6ɖ��L�^�5�{'v��ҏ6m-�� �hP`�2�^�.���� -'����è�\��~� ���7�
�D^��Um)�����D�]Ő}%^�?�F��v ��Ō�o/�鰓���1~�H[g��x
��|�d���@d�ّV��W�ב�����e�<	=����.L ����!�F�J �>;�eڔ���Te򓂩���2���-�|�*<q?9?�.g����-ǦZV:��oy�@�<�ν��8��X><�6�ϰU��a0i�c	b2,�����d̀-W�	Z05��$�\�c�1�ŗ-��h՝�;�^�~�gz�i��24_���@X1�\�t�8&��?�J\�V�� 1 B�L���v(
m���c���W�A:/3)><���D��J��f�痩	Q�3<����Y������z$h�I���������O��M�z�̩������-���HB@��d�̈d�Q�W�xܥ���BO�����K��C0���  ~�t�.� �P�-9�@�FX�8
~��?Վ����$';;
nF�������~�N��ս������$-���c�m��E���������Ї���?y3����_�	�*�̼pp��2�x�nF@>�}S 4z�
�,<"�w���d� 6V�
`>!K�1	
d�V�=+��qt�6�o�k�=5^P�?�:�%���ջnkveA�1W$al��`�_��v����0>,4�r�
�CD� `  L�0�	�: ���� �5�D���?ɞ���,1�����[�X�He��TMrK��Ŭ���1����w)"�B���V��Q��qJH�
<�Q=[�_��Ob�%���A퍲��'�S�e낤�u�sV���O��?�hbQ�#�.:�ST�V��R����.]�=���w��K�Z��z����X�_g�k��������b ���\	�8����\�F�˩jGc
׳���5�I^s�r�!@i�MgJ�%�OZ�|��l2�lm�������d��0=�Ee�GCۏ� As_�� 
��m2���o�~�n�͛1e�z��<�-��C�sw��jN����`���e��}���kҹ��e�l^#3��tu�9���<���[�^BΨ�&�柯�ꦧ@  �� �*�.�[ͣ��ppX���F��Se3q��~465]a�_s����UM͍�[70u�&nm�.������5:dYP��P����hHlw��X  
0�RE<)���1S����a�vQ��a�S�x� ���"P7�#hA K�V��hh.?��j$�8O�D��D�$D�Q}_�_"C�$��I\��%�Q$9T*��P*v%:hH]K��X�P
P|TD�4uwB!�|F��S��6���d�&*��a` 3�����ԗm�<�@��28�$�+�h��t9��T��`������ЁI?�X���v��(T$9Y��h��   ���m^�jJ���2�]�\�����$�it�\"@�b�� |]1
�I&�H�мQ�r$�M7�	��u'!rH\B�$NK��(����<Ç� �1l쿾�.�KWEl@��n@��3�[}_�����Y��á��u�e�3օ(��1ްZ�� @�#A�8H���~�N��qyrWlRq���vħRB��4�й��J�I�F�z��W BF�xaDj$��}&MCh��`��X�"Y���+z0HBpӥ\�S��dG � @t�@�ږw/U[~��7�!���������d�{:��	p4 �<%#� �i��m�Έ.|�	��u4����Ɋ�f��E��)U�  W��D<��Ʋl�����|�L$)FAWx��z�,�� R�"L@e���d�)k�K�|^/O,@���w�n��}�D��Z{��rT�6�����U~����݀��\*`�6&SgA�����r_0(d$|��PY�"�Rꏉa1�sS��ߢ� � ecRy�њ���6-V	�!��<��'�d+ zi�a�I7��J���$i='~�$�?��"M'&�'tΠ?�P��D��s�7�TAQv9$�<�0*Ş�ӻ�	�h�?�Pb(�"�C�oU����[��ʞ��KFHUV4 e���H����M*�"H� (4Dh��~?����d��;&ZS0R7�i0",��eL1&����p��UXA��%^� ��	8hV���i$�,��b}'��t/@z]�.Vz*.TvR��q����4�s��hۆ�;(�*f��J�c=c
Є �`u\*R�4R, A�����⠹�	�`�AA0��,l� @*hy���	���$���h��{����B���­&(��I�734�
�)�1Iw`� ,
mL9;^�|�!cC�4B�.7���g��~[�s�7�?WcG_��翕_�d��Q�,��8��zheǡ�	?���W�ʲ�dR���"8â��f�&h6Da ������� *�P���3�
)����_d_z��|��6:���1e��
}|��|a_Q`��d������d��"�&���+`:@��=�D{q��l��n|Ĉ*"��Ł"���A����tX��B�a�|�_�q
T��L�j�U�5��Ƣ�� |�z���Y�0zk罅�ղ��Cʯ�0�`"��-�v�&Y��
"�$ �A�'�qihf9���y0�Ab�����v���w�`1��f3�X��>BGu��V�:h$tč�5���>=�PP\��=��M��U��AK��"A�:u~w�5i.CCDh�N���,*�ϸ��Y	PE�I,~��   �V���l%tF�J�"��j�F�`@��1Bx��\*���y�Y�$uj����4�:��: 6���	��t��y*������(�;��}|�����}5�����dʀ*Y���6"�,��p�i��ŀ�o��]��xĴ�!f�B����`2���+�`�����K!�Em*���bB&L ]��JX�h�T�B�_U*�uXo�,�ǂ��XJʠ���dV�8�7$�Vz���H�0D��#hRZuKB�n�Ɠ$I������\���(�	\�n&�� �.
ב��d�   ��*��\�@x��H�}��L�d�n�f�Ϯ���j�g=���D^Y�u��ҁ(���T��]2^P�n��M�Ҍ9él��V3�di}��e��%�C:��D@�J|�i��D�f�Sh#���^�����$�Yw߮���:~�S�������` C�  �NW���2\S	�:Lc�����XDŤ����d�.X�	B�8aK�-�
�b�q	,�ǘAc������8Cp�ws��g�����gJ�a'Ir�c���G���n� �ô$� �9eܛv�e"��!��x���\���d�/X{�Ȏ ��Np��w:�g.���{�>�?���6Sj��̛��T�Үm�>����ԑ)'Q�[����Ģ�iX �)qv]�^{zdG.&�(�j���c֧v�mG`#2i��<���XI���;�U��{>�L�ͬ=���RI��=�A@V!��aظ�`�Bi2�I��5F%#
Yֲ�p�!i	ប��D���";��Cm�ǁ����\K��f�u7+
��
F�  pN��xAsX�ZI��!�
=�9����D���i��YD�="z
��i��q�V�.(�z�>@�B�D������ [K�*��~�e4 �r/p�dE���5<f͉*�$�(��,K�v 'p $��`Yq�M�r
1i��!A���D��C���.�s$����{@���d1����!N�~��V::���gb��F<�JWs�5�U 0e�R��~��)&�F#�i���#�)�c 8��򳈟96�X@>(�S#�wq �Pp�E��5�HLX����-���5@1?�(�� b� )�He�ģ�^B�/��
Kq-��?7�(�|�5Џc_
�IkS.�lhN�����v���~�}����d���+�o��O���I @)��H��e���p�|? �Pۓ���D� "�2Yi�PWD�<e�)7aG�K�]��$��P)�/�/���o�o'i������6G|���>W=�?ݚ/�[��$aBO���9�J��W�\҈+��E�YS�R� :#��,�)��l�f+1GB��ފ5Q�����8��X���xN����� iԺdT{��P8(?���L ��)��6�  *1�R�I�ق_ו��aQ�=�A*�؈����X� �g*�(:y)��X;�Tyb��`F��H*�\�	PPs��0]�R ��h	 E�)�I�4O�����q}�q���d����;�>W�B�]B2 :�7����[��
�6}�y1��?�
�������ظ�[��
V� H�h *2FNQ�H����W?� w�*�n���D� �XkY�V�=0�^
�gm��r�U�lt� U�m��1�*�yWt�� ����4քJ���(V<�*<�Ў��h�T�2��l�O�=o���=V)��#ɢ�]�d�ިI�Q�����`��ތ�� @���D@�FF�PP;z�Da�H
��
 N��	�j��9
9��H5D��&B���G��B8�#N|�����8�3� ��������  ��]�@q�z�#X����*��	� ��s�<I�   !V�R��\/	�y^k�ǌvW��΃Hk'�WUwZu�1Q���j��/�hh���rʳ�/y��w��sN�õ��]�k��ܝԢ����\�k;2��,���Ԉ� � I���Y��&�ncK(����D� ����z�Y��-="^	�{cG��9m�¢��sP�cY&����'��f=��몠�0,$��Ǻ�d���⥝&���|t��뛩�ker���c7˿���u����B'�j`�q�����$8�@  � Բ0`�I��4m5d@� &�!.EpD84��D���=��2
�l5�
��ZJ3�J�R�Q�
��i�1������;��4�� �S����T�a��U�;=��b6��#���W+G��xl{�w�Z���&x�1'[���K�&c�I�Yij,4Es+*e�gV0�ȷ�Q��o�}�lSa�Q�JR�`fg|��<��_" � ���F�D�&j�|rA��J���&��WM,��)�A�3�#G~�M�Ũ���D�?HV�=`o)���� {Y���;�m3��
��>��]��i�e݄��jufu�lk��y"��,��c}�cf���\�y�1I���4���H.n������n�����n��ST���8�1�+�lU�A9b��),g��z��ľ�~�
az����#�����3��߹V�j��;��~�A)��,]�e� @ Z�wB�D_7��%ļ�e�X�\P�������¢���0�ŵh���T9f3_!�z5SGDJ�t{�>df�����6�Ğ�dr��r=�݄e��1F�: ��BG	�0�|2�~���	����!��� ����44@�� ̅��i!@�  V,Ci�x����w� �ڮ��'JU�i�9��3�����da T�g<� 5a��� \gi��� ��l��	WYK�% ���$��bO<Rh=�d�,�E�prTD�IO#����e@ f8��4W,��Pm'��g�����+�x�Z��O�I�IuS2��r	9EH�*xP �*VQ�f�  @�!�)Ţ���Q���}6�_�Z��v�U��p7o���E׉�M��羝Q�ӽ�{�q��G;>��i��V����zz ��
6��3V*/�W֤y�tr0f(� �?���I���&h�8��a�EI�A�D f��$��%(�E�2���^�F���_���*U[i����"Rn��'p:`w��+���E`�&r��F�84�
0�ԑ�����dx
&�K0�9��<=��xkeG�&����l�
 ހ
۪��`��aD�y��R�����6#r���9dd����ѷ]~vXPB|J�v��w�@�$�B� ֱ% �a`  ���m&h�*�Ʊ? �5�D�ɍ۪�B��6���h�&w��#����nRA������(J�|W��~�?>��$ J�� �a�i���hB���a�v�=r	<�{�$�'
�D������&D�
�)�RH  �*J�a��OS�7P�U��-�}�k�S�Y��'���Ϟ*��H���r�z��L�H!�0(81�ぁ� �1��a��g&��5�kO�^��`
��O>?�lf7jZ�Z��U|�W��������d��"��i�+P> �l�h�_,<K�lT�	x���Q�uVla�� �>Ed���7[�Y%~U�	P,UiX�C* Fv�7_�PJ����D$�2\��q,
ė���6f��R��a����j���$�=\�t��J��	��Ғ���ي�q.&�Ǌ�
&��� Č}@p Aj
��ω���6�^��D8!JS��%&��]%�y�?��|*�?�
K�|>k�R!�s��-	7.��'h�x�1��g��fh��:|��N�aZ�Ԛ-z��	9�Ǹ�;�IhH��<�8/��j�3E�l*�{�=�S����tF�b� �� A4���E߱E��v�����$������������#w�
n���d�+4W�:�<�[80�L��a'�V���4�P2Ҁ�
C�} (�$  ���J���iwj<�>�W�e��ȥu������`c��
a�g���z&fUȡ���8�{� t�64�����B #4�I�1���y���]��ǭ+�#��?yP�W���2xL�!oY�TJU�g�P�`cI�`q$ i����B\��/������1_/<�����O�/�� ����mp�'<���.����^n��K����Ra�����|B��
���/�-�ۋc����Y�J��Fd1H]��pe��Vi)*���$8Q*&�3Ll�E�p  �iH�F���mH��� X�<��ތ�#½��U�{���d��2Ya�-�?�{�$& �e��V ��p�n�b�O�Uh�]�Jϳ���#�����N�dDdS靆U_������w�OoE�8�Qt��I�
�D �! �����M<��]�}z����۪��P_1͜��HF"B>�՞_��/B��yx}5'B�e:��tk�f���#�C�=h#=�����B��F�P�⁨�����0���yQ��/95[�=��7��0k���[�Ǎ�v�΅����  N�\�0�q�u����U�2�㌰t�eF��x�D!s��_�J{�
�����D#ǻ�9s�D31  [V��4V�É�%� (�\�5l��ۙ��	��V��8��Ep@7���ܹ���U�*�����d�[��c.�F*�l#�
�i ��
.x��p�q򳡠�K']Y7��Г� ��3�<�8E`V�Pd�ԇA��,�삈��7{}(����w�'��oyj
 L�����:�t�PLc���u�$�e3�"�J����V
u!�p7�c+�F�*)�fs2�4K�t��QJ��$đ�ӎ[ݭc��rRϩ��wm���en�G/��H2J�v@��X}��PP�+�]��p �j�.1��[���r��ZNRw�������	5nxq"B����4�| �J�22!� %�a.h��n��ӂz�uʖ�3��C3[d�9CA�-��kn�Z��pw ����D˳n�U�-v�6�!0NKڳ�� ϗG�=���1[����g�W����`oe�����d� �*��P<�L>?�3o��O҄p��� ��ϡ�G>oL�����S@Jвbl�F+��I�.`�`\(����*p�0��J\�
��IF�l��|�HN m"N�Wh��T`�E�����)i�8k���M	��I���2e��$VhzF	6�G�p�<>�:^Gv5;�;ҫ�H():E�����dV3gu�� ;��Y *4�� ��c�V���0�Z����3�5�cU���__������a�7��W
/�[� "�D�q�]����p�4'����8~�J��Y;�������;��[Z�ڝ"j��O#���)�^�#��{�����# 1��  ������˖��̧�8���֭|Z�U0S���d� L+Zy�*r@�˝$C��g��m��n���Y�r�3���j:l�
�������<x9��v�_������?� ����Px��(~�V �! @l�����Pr�+Y�u
�eUׇYi^�d>�
��}�#ǒ?S��S)�[�j���*��2���i/;�P��%�{kf���v���?�ǽ�;<. ��7
� D��3Yv�����o_
h��&�x}eE�CK��� �,p_�/�"Yv�"X>�w�?�� 
  Ey�ABP@|�
����
Y�H���v�{��?U�&
��0�-�{�±JM\
�y�Q����#.�Mf�:	�0�;�A�kF7�T�:�[���K���������̨j�

��)���Lf$���d��EV���B�0�+�9_��{ ������v�	t�� �k���Az7g�Õ����hs��?��A_�b5��L�\ ��� �9�3�Mj�<�`���j��w���c�4���
��7W���.���|W,�?�8�F3�ۄz�ik�S�N3&�eC�.o���[��M
RQ<��=n��v�㈩j�P$0�
�޳X�O��1���han]7�
	z*����������8�Ś���̂M|��uq%E>��4Ut��QH  �H�
RLB�1vpT7���O9��t�7�a}S�P�Є�i4?�Wͤ�����:h�9�a|��o�5a����G�0u�'(: ��!�	��sD^Ao��S0�c! S�o+|j���d�_3WY��<�L/=-��U_��z� ���d���}���=l�z%�%ʢ��K�����r�G���Qshu	YKT�P�Y���t��
� *�X�Dj��p!z@)X��f �m'3%��r?�U���h�w�x��<;-�+�f��(��*�0-��5�zsڣ�<�1�0eB��4���-6����T���v��l�PQ ���`�m��?�� >�����"��g8 ��2�'��/�ڛTyc-o��H�D�vX>��H Iʏb(�¢;���<�9�hف+�QUHN!�PP	�{Zx��dhvGx*�i&��ݷ��pW�{F�Аh�#���iU��@  re����Z�g�!�7���\+f�"j2����d�D3Xa�C`A�k<"~
��g��I
�<�
Xa$6�T/SVc}��31Ҥ��5��5��)Gr�<��`PM�
`X��� �O����  M��C�:�1���l.Ӥ���"�����4.��@s��ԧl�_�Lq9n��*���,|4�k`����3�3���u��~�������S���a��, %8��ǣ�{��d�p]L���з���;|�c�6ִ����ښ������X��`M�:u��PH��2	~N$T��D�AV�a��őb�$#�)AX��gا)\?�X.�M���Ĳ5TB�����(h�[�;���6L���͊����^% ՙX��rI�؉ >��  D�9^|���D��
]k,$Y�{�`b~d_L�#	g��� 0�<@�#i�,fua�ǆN����IV��tsW.ؗ�(���ָMf��.46����q�̴���DWvR�M.I�[��0���%��1_�HI�#D"�NQ:	X�	��ֹ�_��N֞oP�Q�a�����J\!�'���;R�`���,��i�y )�8��s_p�C|�ΑG�P�x���2��#�L
�l�������'FTqF=��uOz���X��c��c��E�ϣĎ��<2q�j���Bc��6\���(�r� ��Ĩ.�  � �`0r�&+pQ^N��-fT�R��a�̭��v'nڹ��+�ʹ����uzw��IIڣu�Ĕ�XYB�6P��r���D� +U�LY�g)��a~
čm����,u� 0�����B���O�Ս���1>��ء�$&߾1pC	ӓ=��^��pc�D���0ƉxO�E-f�P�E��~Yo$���|�E�&,Rlv64 ����>��4
����t:23��������(�D.�}Ѡ�	�X����
G�ъ{
��٦2=S��cƧf�̈Ty%��5�w&T�gDQ&��)#z��ԏR�Y�*�(5g}�����D����(�n4E>�1e H ��Q�-Z��Y��l� W+*j;��MC̻Z���Q��d���y��0 �x�0BC/���S˖�l-���]&��ES�7��x	�������GU  X��ۚW��$aTom���D� #@MԳo;phi��i�^�Y,�i��뱁���m�� �jp.����_�@��{R(���E�+8)nQG�B����"�(@�F���@tV�5�����lѨ<���f�
Ϝo�l
 )-�8�������`'�5д�����\���	�&��N��qj��0�� 
��>Ph6,Z��!��п-�i�"P�T�7�Bŋ���,W��m�����wx���: l  A�P��X���|e��l���&^�6����ݪձ�g}ޝq��;ml�4��Ou"vAb������$��f|��
������޴
�*�
��~."w�X �d��q�Xo�`v���5h�8u�LY�0�3oM4i�x"%���6۞.�>�E2���D��FNV3	+tk���a�^��[L1K����1����җjT˞?�����E�O��������z �z~��t��W���S(h�^��� @�%��%3 �"�� �^�S�|y,�����K��\fE���S���V�D&Ex��k�'
���y/�LJ���?����$(eJ������,�Xƚ�o{�-b+�Yп��z��UL��~b�� �D�Dk2+
u�d�,)��΢Ƈ|�V�m�hz���4�������ߊ ��_Wo��b+���R]說b�%����� J :	�bM_!`������yQ����zuP����W��s��%�@sX�ũMڿ��&�����zC��5.Z�k��vB�%���)r�7���d���VU�/�O)�=e.-1U,�m� &-��	����@<˙\E�.^R�ψV[=���U��o�ܸ����F ���Aco�X�5�b�PȲ`����کd�5�w'�=~]9]��}�����GT��]���ϖ�Գ*�8]M��  �(D�	5F���&���I&�9��Z3�&���U�p��c��d42�T|z!�:����r�2�J�/����ꊚڊ�F>$�
���W�%�_@�F�0-� EQLJ��0��V�:Ԑ���S�!��s�J�L%3�� ���32��?���iN�By�:T�;)u���$,$o��7o�
rYэ���%:y���Tpt��v���2�T/aAeB9�J��u,7�l�n?s@j,�uc]b`���Dw '<VKQ�^ɚ�a�n�_G�O�~�l4���m���H-�~g'!d%^��00@ C���8R����t�ea9��:	��ƻ��rD   T<ϣ����F�?P�.t��̂��E��C�9ϱ�� �
��}P���ҡ���Tۣ��C��v��W���
2�����oj�BF���%9�K� "��
n_]�����T>�K:;#�|
��W[��^��S���˾���\J�T�j��g]����8#A�xb�
���_P���"��dB*b�ɐ?O�r�K��ho=��xᄒ�(�$G!�����c��<�VkZ���� =ks�*7��z���9E�3���8lT�IC��Qߥ(��p��M;
�u��y�I�2CN����Dc��Yi�3@YH{M=n%7o��O�~��p�
xn��d���I�7�|�gd���#��e��� *�������bOO�o���2���t��9�w:>���~��J��&ZDId69�o�*H"]Kk:?n�v��YѥǴ��8��9
�Y`b�i���m8E�u��S��3cb�"�+]�.y\��_��zkE+|��W����#��si�F�8d
�h�Y��l����x{�w͡qL�ݳ#�傐犳�	���������A0S���,:zפ�VxD�/*��� ��9c�Vz8�лR��W6�TKZw1��v����thXE�����R]i��1���(9e���?���Aҧ�@��0f�	4��$�8�xa����D\ �*�i�0@Ph�	a\
��g�=�zl���8�Ju�G؊l��^��Gu��[|�wr2�\�77ܵ2�����c��$D�iB��ն<�	���{>� h��ES�z-X\�3x��<�&��,�t%[����BR��
�z� �2��8aq2�����o�&,1�i�H &� �7
�9D@��V s*ң� �J��\��PV�Ɂ�}�
���*��~h�kƆ�(�T7�w���%�n��l*�ۯ������^P i��L������<���h�cU�JEI;�A�����p̨��ă��I��O~��6$�s�~�@��H�V8�=��4��%���DaQ�mOS���p��	)d��?"+j$�m�(-������D\��*�i��W�K0b�
��q���QN�t�	ಛB�#���q��w��e�/��/���\GP�x�&�H��|Ĳ��@��H"~�@ ���[ &��gd�At�O�[h��.R|�%�֡��t�,��"��we'���y(��g��3���:��pA�@ԏ��ٹ���dy�j�B��S'����8�U���   ʜ%h�R��R��Tc@��7W3,W�w�}��O���9a�Ŝyj4V�=�)��}���&P��7���g��b:�O��.� ��@��p����SɈTК��T��~�B�i��(�w��x�=�n��8wU�qW��@��<AD
��Zc��-Å����&�2���o?	�JQ]���D`��+�i��U�[=1Hx
��g���F�t���ő��E�DgZ��}�Q��o��^��!� �2%z�a�%�P;><{���ȓP|>e��٨g�� La�le �
ꗎ��`�/2�	k��'���i`j�To�^�!+� 
X7K���o�p���DH�� �n���*�
�h !IC����+���Y)��͇�r1����%�*=�V7~ X��R"&a�o�l�g;} �?\��XAV�������PX d8*P��L�ħx�dyhC��Vє�r"�b���w�9^�!7l�]tO�,=���r^���T�`QMEb��(���P�� � �C�y�RTI��m@�N�
��V�
�qA�����Dd q,Xi�*`S��M1�b�Ua'�7�
����&�$��W�D��Z� �����[Ӱ��!�LL!ff�=�b)h�֣�~� г�ۯ�xܭw_�����
z	��P
��6+]bD�f��#��Sc�f��ۀR� �<sUR�<�a`T+����[Y�G`y}qXHl^��sP�i�ʬݔޥ3�"ZZl�/~R��8pI����'��d�!��[>v�p��龾��1�ČM7�1�$�H���Ujf-��E������ň7"��  F�s4�+�
N]Lb�;�3�b�p7,FA��@D�Nc��1��9�7�N!�~�
�ÛV��1�w���|�ю�/�S=H�P�8x������k��WvV H�%�ܲ����d= PQ�i��?���L���!k�����m�� C�̈�E~���_����O��o��*Ue��w��+�fs7a�Z,I��@�@ƈA7�D�~"� ʌ�/b���󽩏�H�R>,�^��C�=E��y���`��jT�{/qǬ�Ew\�u�D��6�E�/|�iH�S)  �� D)�,���.ip4���GwӤ��U,
ON��
��4J*Nʕ�S��`93�( (4���/It��ѷ�hҕIzǯ�����x��i\:V7Ե���P���/z9��:��g8O_��������+D<��_6	�i�n?����J$��A���X�yI���a_�=�5�� �����T,Q�?�{��y��<��A�%�(�	�����dL�����Yb:�l0&J��i��K@�n���n8h �E��A9�S�N� .�jȥ�Jrݪ.��/W�aՊ�b:ܪ�9o	�gG~08�jbQS���uEힱֱ�"�r�s��	&�[(�CC	�@:�Tn� f�W8����`A1N@�B{z/P�������Pl
0�6S*#l� TD�--$����%��(l�����i�o�G�R1�[���!/�v;�s��0,p���rm��u�~�
���o�|��aCvcX�rD�-����s�g�6ٻp���NS�^fK�E�VXw�,3P��$��Lrk;z3��
a�' ��c�U��1�J��i��3G
��#��爇?��M�_@���-���da��7�a�`8B+l0""�g��M���4�Q���2�f�����D<I�D:��Pl�����:P�,�
g�ױ��S��^7�V�@G��:�<9��w��n0�HA�$��&A+>.�V/o;��������")C� 
�x��0�EăN�g9S�K�!�����^�;�i����ᦔ+�lU��K�<��o��yא��Q��5�s��������$w��X [F[��T-�����dl=N/��56�ğS�����z�E3��H�Y�T|"�x?��X����*  >R(� [�-��εq���)����$@�]F�QY�W�k�Ît��l�yAr���I*���T0�+z�g��m����i�並F2d���d{ �&Y��;"<��D="D�k�� �
-pƆ���?z��l����?Af\��� ���  �y���Q���φ�0�} H㼩 �o��.#�t#� ���Q��@���Z��Cň���i@�e #��D`q�����@z�	=b9��3����hcN�?aU=W��� �I�����Ι��f縯�'��v�Ȭ!�����`08]5�*�2V6�������zV�J&��7�	 
�6��Ȗ(�W#������j0@w]���1��%�;X��H�X���
;�������;��w�����Fx���l�L�}���������_���$&n�;wi;��G��?��h���+ A�X�
{�N���6g���D��(Ş���d���&Ya��>�[n5�$(io��҈�/��r��~���ގ�HJ��k�p*x�
�'����S2�#]6?����XΝi�]���8��\��$�"��H<���4Y�HPj�H ͂~i�N �� 	U.��`��p�q�P�9�_�i���hd�|�?������TrG� i2jA�   F�v7I�)P�Ģ�I��4�}�+��4���41��\C�ZL%�̫�}������6-4}�֯��P'a0��g��7�g:�o�s����(B��x�=h���|m�l_I6G�dB��*H�+J��m�M��[ͅ%S�*@\�(�%L�.�I�/L"��[��`���@+9��]��,�����d� \�J�9CK�%�3�igG�rHو�P����f��Q��fLKP!-���P>+�G;'��s�2�xw��O�b�Ný��h��]/��$ C� S��Ӵ���9�^(�s����E՘]26�y��^������%�� �J�  ��<胓�~v�F�eL�bM�ٗ��X�.���AY�[K����ޢ�L���4 ��q��(6�����'����_��C�lU��ҸB�Y   �)SIU�D\���(>{6�
;?������������ ��a���j�*�\s
�pAFt������k�²N�	�3�e�̥�ie�߽{�˗�������a�(5�l!.
���c�1��e?�f���C���ʹ�T��B���qy��_\��6������d�  [���.�KI0%8L�i��Gȟ	-����-�tL�h/s�qN�,�Yh�E����G�/`2�(S%EG�8P�iHu��J`D`���@b�[���/�b ���ǊA��<�ESμ3�s�����/���d9�P�V���3ުTʗ�4���?
� �
�ccCÃ�� p "�i�,��X�&YI��FxgLE�N ���^���^�P�X�I�K��[��hH�����qr(j����a�Qt=�`�ܵ V@ ,i#Ƥ"x�A3�]�p��b��-��Ui[�ڗ�[7���~S�o�y���U$�h�q��ϸtrfdܒ����W��WYT�j�tvF�n; �E)�V^�t�L�A(G���!�/q����d�]I�3:�8�<03���W<��
�<��Xi�e
�6�R�1}�#bJ��Qq����=	TP���&�6����ɋ>�����P�@Rth��k��Km�'ʷ&g�]�읖({|�n�4�=�q"o-����f�wE�Tʪ�*��|}Y]U=SU�B ����cU�6�U$�����C�m_-�e�"�1��Â��� Gv"�f�;���c���'ѧ:+�b쿪��yo�!��8�CN�ubP�B�a�fV*Z�z���1��� �ըB ����������\��N���j�X����P-~	)Gjб����g���#^E	�k�!��-��y��( ����q+:�����iW�[�}����4fz������@���d�>;��+�E��]=gY=k������(�`*�^�"��� ~��}VK�^��<.YU#C�?����� BA DhHz``�@��A�&1�~���r�B
�ƥd�[	���C睎,�M��<����d�I��i����EK�f������ ��(0w�F��G����Ya�.|�Q�AV�S������@ 7.^��l(�/�a3��_µ����YA_e�Z�{�)��Et��=������E_*I������O�٧� A0Y���S�DL��۴���lPM���*��`���G��1��seLje�uS������J����3g�����8m�Ha��1n�P�)�= "l"Uʇ6�1�L���̀����d�D0W[�7B,=#e���U
<����,�	pD"��tq\w��y�]��s�C[!.+���"�9�IQ�	�Yc)p���w�Rk�<P�*�@�	�:�WC`�	�G��]Ϋ��D�$�k�F�H!�����lj��%�����H4�]����ͫcYe��(H��I��z���)l�*5@����a�y'�Ӝ��S�D!"B�H��ZXZ �>!j���'�mF���/K�^NIu!F2\qgAh����wG(HHX�=�1)���!p���
�8��f����C��
"���7A1�IK9Bq2�+ߊ%<&��r��Ƚv�}f٩)��<Y`�0rd ����*���,� <�=������6{Y���d� q3�CJ`?�:�<�D�W]L�~�L��@�pm4�!���
2nz}�~i��#�p`�p���T.�h�wi�_]ǥ��4"�:(�b��+���n�UKг���S^��jzQ�	��T��Aт��sP���
 Xp�C�@B6^�+�#w��-��y;��^T/bT\�n^��|��a���t�l���  �Аe 8�#��-�$�	�2�4D��DH��Cm�����H���[��Ř�׵]��T�}=����J�#�{�����vB���/�������ev�  t �2p�%0F�>��ԽIo��I�k��{4͌Q"�
�����>��h�F�x���A   �z b?&�\���f��ОdH�t/~I�M4IW`ݑ��`�f����d���<��	�5@�$���q��n��.��$H3X-X��
��*\J86�Ɍ��h�u0;�Rݽ��������&*  ���.��R#��Yg\����
���Ԗ$��B@�&�+rh(%K�1��Ћ;�dTCc�u��ZS�6ΔٖPβ�m�kF��'�>�$I$�^ƫ��i�4�&�'#�b	ofKK��+eS6cɾ���-ī � 4�y��ԩS�I9�$@.�����f��$�I����qR���T�Ew^��&��ԋ]��.m��^�U��  ��[�
�@�C�6�C��A{���sӊ�%��r}"nM4B��#�@��K�u�i��v'�օ��wo*O��$�J� ��x�ޛ���dƂ"�#���P9«|<b6x�m�$m��
����&��ڠDy��c�dV�rm��/��K�t�rF���C�<f�u�|&z�X��"#��` B��  e[l�M݆�B+�e92�M���t
Yn���Ю���#��|���l'���_�� �a���d�Y����d���ۜ�~��Y�����Y�!��nZJ��mG���������D/�sE�M߳���
,�;'�Ϳ��0���`Y���,u�/�]G����eғ5$��0
_#0  \1�6�0Ț	��P��`��ҥ8�g*,-ư|j4.��D���IK4]��Ϛ`�H�����'�j����1�'��h2ϯ�w(�bA͑  ��
	%�D����d�$3ZS	p6 ��0�
�g�0����t�		�lDd�Y��+��QR��y1!7������*ެ�!	tD��g)U��bv�d"��sT-[���j�(���Zrc��U��B�&EY.S��YcG���("(��u�����֤��g-� �w9#��ind�sW�1
|��s�WG�i��ْ<P�a�BN��0��O.�{���P$OrDi�!,:R��q����$�WB�Dt��b�it9��iG�ˆx�qá��tt`xh3��0pې`�ʝ������?mC+��of�*_  8(!g�Ǳ$"�|�g��) В �^5zҨ�Z���7YK"QJQذ�4xѶTB��w�B��UE�1��TQ"��[��?�0���D�2�Zi�@�^��L=�N��e����w���8�\\"	�4h�e%B@	ɎQcB �d�0�J)USZQ���p4���[S�����_�ی�{=����m>\�~���vi������7��6Pɍ�Ū]%�k4l`�� �4!(� .Z=�_!HJ�Y.OP>��V��I@�Z�o�r���=x׼ƺ2ZH���W-zk�rBv�����ѵ��~�%Q��+ݙ�@ l]yc2�I���_`:JHu���<0
��K�ED��
��-�����c#0���ñ�
�#���N����S�H��DJ� �v�/��j(9R� �o,����� ,EFs�u�H��a����7S���I�G�,Sε�JڄA�dp
���D� �3X3C`_�[�<�n0�k�OAl�-0��δ��B-?��`�!��[�"�w����FI"K  
	��0l^���h�4x��&8;�&2gn�����1	������O�mIXb���g�Z ��M�j�`��9t�ᰏ�P���z�=s���N�3Ul��(��Od����������L�14	93p�[>�4��{��~�ݶ��s*��gz#�ֈ蛍 yn�&�S�<���p���PHpŎ$�  @&S(RPG˚Xp�7�j�qP51Dk��$���D^\q��\�Dj�j��w3���C�S2��$�C'���w��1Z�{ѳ\bX�q��U0   .('��WM�	,��iH���~��iS!�`B��$��x�L}iK����D���i�CR\kM1b�L�`g��Ao(�t�	����&�WR�QEu�$��
+�Ȓ��Y��r�ﻫ�Y�.���A �t�#�@��Tج L�� �, � ��%�1>i4Ͱ� k%�2#��~w�e�jY*OK ���;+��_o����� z@K��c(O���F�o��P
��J%l(��H�$e���V�{��y��O�����啨��G�.�^�D���>��"	�b��t�Q?��T6����I[?������8�h� ࠎ�"��DJ��(�	��(|@��6	��@�(�@�!��A������� �"D  !L�_��e$�hjH���EH����%H�� 
q�1b߷�(F���f�p�����}�?���dł�HX9� 7�)0">
 �cG��H��tİ ���&�K��!�%	"�T* %��86%4�k���F-�8(�N��]̧�C��0�ّ��As�����tzJ�Ȳu<����	ɇ@z<�E9H	)�B?E�R���{'���y�JƉ�PEm7%`9b���e�A�Tv���L?�v*��KȌ�Ғ�9��C���B���E���@&'5�����h@��]�?ִFas;�}(I� R�� ǂ$*�g2�ʄ=��.}����	6ⱪ����K�G�R�u��O�/�W�,U�CҘ��!6	]-yN�;�ܭV��@Ha��T�N��$�����1P&S�n��$���&h�D A�@���`?���d� 	<����;�{0�Nm#q��j�쉭p����"0Xz̜A��,REA��
�0j�T��@��>�:�/GM�g����6	p���̖\�]�h$𐐐LG2!��[F����}iN������D�'�Af~�-��\����mlQ*hmW[���h������k ;�>1����ˑ ��A��$�z<�Bd�<\��!&l�m�!����&�Οr�n�6O�dr[��^df1���ļ�@��m�4�\�;��J���B�ō��Hʴ�� 
�h �)�P>\<a\����b:=F��f��@�v0Mm�G�B;�Q6��V�%=�{
e��x@�  ό ���?<�ħ�}m'iZC=��c)� ;В���D� "�I\��,�QěK1x8�c��	�Xm4�	8N����̌��QH7^B��W坫��w����翹���Pet4������1�����1�=����C�Ŝ�/���Z�-��   
�#��(̔y
Ÿ�M������=v3e&�>��8u�����u��_�I���;�����u�1A~jʃŌ'�:��j���@	S��7��ػ(���Y2,K��(Qߪ5����_$�*�̾R�����k��V�_��������r��ʰHP9Z%��7�'�}V."~�  "B`w�U��a��p��`� �(^b���'
i{�ۿ�@�9;�W
F�1]�O��)���� YΟ����J��	��s�P����D� �(�i�@p\��,="�
��a��M�n�|�
���&�C��Ԯ�(@ ��Ɠ���+P&@p��+�CO�'0��$�#����� �ݼ���I����ꙑ�R�J4�)K����P��?ݢ6�p��������J9lq��M�^��U�\����e"I|�&g���󵤎��x�3/����?�b�?�M2�L�r��ثRe�]�!BO7sD�儃
�3�d�,<����%��
�����_CAIH�p  �R	!��iAUG~MY���.]�'7�e_7U�wi4����ܫ��llZn�d��D&�]�.	xS������
zSZ�Z���&�MY�cN��A֏�t�,,�ߨ,���OWTEH�gE$	���@����D� �H�Q�p]H�m1nN�o{�
5�˭�����@�$Dؐ��
�I|:�[cqe u�G�L5�As.O�����L�m:5��n>t�2�Vܥ5WxS2< 2�LXHQ+�"���"=Z��V�E:~�rv$�� 7���{@+���\����>~I�N��u�����4Z������@`���V?���N<f�q>��+O=�ҋ����q�Q(LED��[�m;�$����]Љ�<J#rA[�������gRǾ��� ��� �hB_�p����8�`d{4��ֿni���$�;�s�̝�^=�k����W*��:��l^��Ɉ]�P빠n3�%E�#  �� ��Aa/q�(蠨�'\��E�l}}�5�WiD�gӗ����D��<���pM{�0bj
�k�$�AG�� � ��sZ�H�����:�����P��W3[|�)����F<��}M�1]�U6yxvX�� ��*F�dg-J��H�fw-r�fߓ� �!
%��P7J���כK�� A@2d���T���� S)��P� R�e�����:��wG:�b�
�O�`ѐSdw��q�jb����H��(!H�Yb�%�b79�M�������IĐm�U��$�Ṉ\亰;��,�l��GF��lIH<D+2�_���2r�A�a�P*Ըn4
�́j+�U�XgF Q5�Gq�Z�R��q�����?a��D�j��X�j�h ��.���,>lL�x�� �i�B̛ �K73)�b���������dĀ�@�q��?�\�
�+�0�kǈr�'�����Xǡd�S8���   &��DR.&����>��ޕV)^�����]�?�#�8 +T�!Gs�=��n@���/��u�`3�#�ED��L[�O�4��N+�
&�C�����$�:C%U"�_��<�}þ��.����{�a�#Y���UY���B
/��>Kk�4��I��yz����)8@L4a�/�L�P�A�������	��/dH �#���pU��<ܔhk�+ҙ)]@C:��GLp�&SjƵz��B���� �@hw@`� �x��pFA����F������� 4o��~�������  ��Uq4���5���,�
���d؀��y��8�[n<�D
�Ss��e������/=��=���鳀a�c-ٌw�B��S�J�����;�0$XF�CB��N�e.-��V�;f�� "4M2f�ȶ��)d(���gl�h�9|�O�ݭX���/x,J�#��h�OG�=?�I�_�4ߢ{�D�7E܁7��_�9��;Ⱥ(�|����G�E4<��;+�$C�dL#�HRHU0,J�<(�{6��pd~+=O9���,�PgqlT2�������
$�I5�,�*�7   !���(��
b�8���QJ~�|����'������tG�
��nO�����H]�M!�;�%HY�M߹
$��4�M�#�${�3=h�xs�<tx�R��5-Nl�A.���q������d��K֡�0PF{=Ev��c��W	.<�)X�ڌ$����V�x��X`F(~��OX:@74��*���7����h.�yyPh{�t��'����.!��>�n��}�M�Qبu�!^�Q_�+�k�gP��N�@��?����1|T��((�[�r� �����D~�c�٢����}�{)^���� ����²%H�@�����"����ǝ9=c��ճ_�6�y����U/���������(�hqb��2Yst�#��D3  �EX�q�-��2u���V;/����_r'�=���YF2
w��� O�@�]�N�?ѧ��Gn.�}l�ĉ�q5[-G,�?��/)��-"��T��:I��+B춳Q�GUe����d�GE���-�J"+�0�dĭg��oH��<���n-��\�	�-�ư���*]i�5	�˛�X_�!`)nd��5P��_�%���\�Y�������Sb����c��q�w@��(���m6&�  
��q��&�BJ� �	�Z0	��[���KX��~R�9F�~����6�=��z.� �;���8AQ�&
���L*��+ʑ���^F�� ��A����d��@���B ��5c�&-���������w�(�C�,U
@ x�1Y��\4d4˓�*�@�j��۞�$D�URjuq�� 
�vlN�&�6��cꪖ����ik�,.X�M%��	,`:�C�Yh�?QlLb�ޝ��Hef���d��S�s	DRX�k�<%n�m��m��2t!$\J���  �G|��3Λ���tm�0T���#TAkcm�DT�mF��E�.�����3	���%�.��:'1���֢dֶ�j'�ov���y��*62:�U�-U�SU��QЉ{.�n�\�O��!�b\:�.��:������4;����G��	�����Y&*�ro�EUumEC��o��7)D�P�.!ʅ��5�t�{U���}e�`���X�E��eCU���T�%$`    �=��9	�0�!Qˁn?�4NW�"ٞ���Y���ޜA:{Y�|��~I!,��hA8Z�r�]zW������Y�/����G��<�5=$�A����k� 	�P��3������D� E3�)��M�[X1�h�a�mn"l`��x8��Ӂ0*d�,�WD)�Y`���Paop۔a��@�g���?�� 	��t�{q}��M���P����[6��.
>4�ФT)f��*�*>/å��I,�O!�}/�*n��y������f��3?��"]qW���lB�s��j�U�{a��
/���m�	C�x�1���S�	ِ�UQ�n�8�ꁺ��,�n�u�X�R~���\v)rGp�(�YA5@�����&ynd�	LGH�1T�����ft[�&@����H��v���m"�����~~eŬ�6�M��)����7�{ �2+�� H���B��#=��E�sh1[�T��X(��筳GS5�1  tF���d�#CL����9b�($C 
�_L=������91t_.w� �BCU@���vh1�����h%��%u40\0��ˋ�"��/��&^ƵO�"Y2�2 JQ'4�\#ςz�a��l2"-�<a�dl�+��ͩD�[/.���h���L%�Ï�q�с��G��RnKG)a҂0,��Q�8�h�٭�9R�o��A ,�f���t�]r�����{3�Z,65?�8t-��p�r����C�߾`��MVz�բ��h=u�@=��
� �R@  �5|
%�#�m"�֓Q����M��~}]gj3=p2��^>��.��b�h�O
�V��|TX@pi�]3L @$8�Qŭ�M  �Y���옣�r��0Q�����d��6���rJ#{_0b��g���<���0�.;�ޛ��D����QX\糍Ks�.����e�G����o��ǽ�Lr4 �M���X�Ɋ%	gC��n���2%�Z)����qO�)�G�y��Ɉg�v�)]��݊`�]��V��i՛��`�ܻƚ^GJ�S��@ �8
À�@�J�X�n�8�ab$�y�(�Vi;Y���1�5��
�D�E�V������p!Wxe���)L�Z�������oeʱ'���kz������D�$�`   �H�C���%O!��;Kp�Eo)*ѻR?ܧ��*��&	LM��.�4]���<��S����`2�5F��\J�@+�`���y�K }�ҤsS��  4�����D�"{X�1�M�[L1#N��a��T�{%l������.�_$��h`{΂���,�(�����c��_,ii�c��k�$
X��Z޶�jw��� ��U����q\. 
 CI`�K���!�C�"87
�Fa0\ܨ�D����"2n���kו��!?��HR��&dǄd�FB���̄�����|�$������ysD�/�TQj����F�cS 	oX�r^�iGrെi�x�"3�t[R�B���2 	�� ���um�����L��N=F:D  	\�0�2"�H�ǉ����#X1z�����+"QyGĜ��bgⶨ
B���$�qco�
�����r�0c��������o�
F0��qѭ�S�o�����O��0���d�#"(���0EA�L1Dȯg������у	�J0�
����k��iIئ�o�߀䁬�
&������@�!P8�P
X�� %  �ƝN�K�ĕ��ts�SB@
9$H���=ɡy	���>�M/��F(���;�_�ȓ�{��F����t}$)'$#DB60o:���8�{���N�B��@ ���֤��:p?:2��!��A�s�H
�+OV���ߡ��y+*/u�����'���"i���  R
aO�q� ¡�%5-w3{ӑ�W-�.���p?��#@��@�_�F��'$���>����
�ב@>i��F��C��pk����SdL� ��ƿ���o�2�`7�� )J"^~���d�!$���CR5"��1/� �c�=$����yI��1����vJ��u����ͩ�2R���Ř/hz�0\���i�!`���`8#�`��t�܄!��r5i�˱˩^X����ǎQ������(���tO���#�Es��󨱜��t��6�6�}!����Y�8�#��T��T)� *T�!7�D `�
   �H�G��.��>f��~���J�P���e�p���87?@+Z���+-;����a�)��S�i�U8J   :�G�ţU�J�4�IDq5�� ��A���e	�0�,��P������J0 �5&s�����sb�D��zJ� ���� �ghp�Ӻ���`��j]� M���,��}�?��L�����d�](YcH�D"�}0!���e��m��m4�� ��L�69
I mj����&�S�s
Y�����]r����؟�tB�����_����5��F!o�o�g��D��~���S+]LFk�G�	�@���X��q���ʺ�-�����D����f+�h~0��Cr���s�l�c1r��Q%�S������i�X  *�5����%|}8	D�lz���*;�(Ɏ�)U�X�)�6�h;�B�`n�:=3#���Ԛ{�1������������e}*�   a���`���F�0Ȫ����K�O<E��NE�ΰ�mf6$�-@���U����#:_3�f�Ƿ>p���*�����]e��?�ʙ���.f���D�$W�,pb#kMa+JJ��^�,M�l�l��	p}m�P �Ciæ�4�& 		$�!2E����W�;P����I�2f�@*&T�"	����E���_�`T����B�B�)g� �H��4� H��\y4� �H� 1r�l����dETX������c�S��WUegt%>�*�v�ُN϶��7�'�?$�*�|N �E@  �M���d�x
�G�à��2l@�i?�Y�����N�r_��(z�A@#�FH@ D���rֳ��-1��Ěň�С"~#M�N�#�H<釁1E��>��c�JƔP����%Gi&��J��M�v����+~��Α���@ N`���w�� $2   �:�i�>��fq<�c���d߂oJXSA�5�{}$��1gG����m4`��(�!\p������_'����O$�H�$�b+�_�K��0&/���Ȯ�1U|�@��U�g9��E�ܪ������X��"�����mӧD0�4��f "I� %�TSh���26ġ��ui�\�i�x1�{ġ���&�3�b����0䌽�$?�AH$�'yU�_\ŽY[�G d�쨒~��W��68 �
)�hIT�%�����9Z��I����&�z��k
���n[�P�``yb#O2��T{����N��E�"\�!�K[�AV�� �   �	 �B��Ug�O�C�
�Hm�@CA���P�B�%G��
n��
d/p����M�e-�!�B���D� /KWS	`o+��a�N�-a�$K�hl��"X�f2��wC��u)��Vb�ːƐ(X���ԅ>E"���sq���(��w�GG���.��*0�[����X�u���[ψM�p�u��c|qB� J�O�Bp?�RvIL��t��wFŀ���I]h�B3�D ��0�@�)1w~�
%�p��d0ժs�ޤf+���Օ�*ɯ�;_�RD:���(
fB��%K��7Z&w5� 
�    �;�9M,��4Q�w{��r?����޳�Ʊ���������L�8o���   )\�B�g�'u�Rn�JUi���i�`���,��N¨���]�_���g�[�I�>s3/���3̧Z5Nȟ���w|�A� Ox�Ē3���d� `RWS	+p7�;j%" aAe�����%���	�vp� �j@  �<ܺ�Q����g�C�|��ӱ �<8"+x�K� <[ŕ��Bڵ(
�płj0��`�����i�Âؘ)�!ƍ�=�=��8�+��K��r�@�
�̎�@��ޔ�\K� 6$$���Y��fM���VK+�`3�r���v�j��ܺ� `d���y��V�FDڷ�S�P�0���DMu�-Y׺���T��S����D ��H  �(@����x�m����,����Hy��}$��#�<|�E"}����>�x�J!L\L�N��Pw	8)�f� �6kgVz�Se�YW�rJ�����ݾ�}R���V�'��  "V^zy/Ff:��:kQ���d�#FY��,�;�9$�.��g��e�Ӟ�@���� �=3�2x�mJ`
��S�K�%ԮnI�g}�;SO�TаK�rt!  �;@�\w	ɦ�M���$�jS���P��H��'�M�+����nɹ1L��\���"���?�ڿ������'�g�����$��w��� @� @#�����*iN�c���F[S���~c��LzhC 0$!��݀I�mz�^��U8à(��.s�̮�ES\z3#C2D��pD��X
��֩� V`�-HiNe���,,�i�E���M��H��'�F���u���{���p~�,��;t�j�WI۹�v2��^)�|������iXN$@@$]Ό�P�.~��2����d�#xWWi�-�B��0�<O�qWL<Q�
����7�-�y��(xqm�HU^|&��'ѳ�[��8�`�"	%,h��)	�����"��{m@�Կ8ҟ�'U��T� 9�����B:nF?��We��)e�8�"h
|�f�b� `׳�AF�H��@zN_�,B�_Wj��"��=��J$>�+�q!@�m�YM+�5與Y  B��A���_#��ef!j]��?!� Ѹ�,��K�(�sMT(�,:�����.}�W?�:5�W%���B��]����P�����ǹ39F�rwZ�*J  .Ji(N�4���Ds��br��i\'�D���o�\�����k��Wz�8��� ����d���Q0�>�a���^#@0  �N ���D� �CX��+�Y�K]`jv<�cG��A�+���	��u|�%�5�R9�{3ygjc���i��?C�>��,,0\�z�Q�_ ����� ����DT�Z"���ƿ������>C����7" �1�9>��p� X|56H>�zt{*��˙ �n��;T�(�`#j]�@0���f���L�2�4&�N��[�n��wA� �ں:�#��!2 ���,�n*�.�8��5�S�������U�q�Шa	^���Tz�a.~	G����W��8�ذ�v��� �@��<��eV!0|2,��j�P   	����GRnd��e<$&�zkC���#I�C��x��ӆ����Kt�=��
����
��w�lA����y�f��t���Z�f����D� �#XQ�@\�+	=�
�+eFT�c�<� 8��3�`r!�[�\
��� '�ض�鐲>9O��J!�*" �F� �50��=4=����?O�ڰ#���&0N��*��,m�]/�G����y� ��n��7/���K	Bޗ(��S�ʩ
s�]�%i-�t	��j�St�_+^ג��!9䂰�B3��*T\��k*F�2�d��^HāpJ�E+��Ae��h.$���c<0a���e��t��9
vv�3#%U6���&�v\�P9�d�$�O֔������8�mkl����1�l�P>�b�s�����+�q������G���;ɾ貳JA�=������Ki2H�H劜]�B�Ɠ����C�D��2n�����dق�=�Q�"4dK�0e�{oG����-��S'Ν��fT�3(C#@@�������µ۬��%�  �H �Bd�3
 �(R$��f~��c�t���>�S�� I��9���)��Ȥ�Ҩ:>ԄQ��򇕩YO��UWK`�����+��4 -�V?�Rh��E����i��a �Q��$����A�>�������y���`B<�d�8ܠ@�c�Fd�J�_!!������Z�7�n-�����f����G�)%����~E4Mm�r��/U7���~�Vc8�C��@P��[a���u7��HeMb����|���Oy�xX@�Xy"�}���=��V����u���[���Q�x����3��t�&Vi���d��#�KZi�rJJk| "�K)m&{ �.,����K^�m�.3�_���[4� 8�����ND�
�Z
xZBS����4��f�K���PF-v��gՒ7��YD�8o��������	���>���_��������?�"� ;��D�_Ү��3�T8� ������+����1�d�"�eA�eE��k�?՞ߠ  �LR1�XwC&�&�-�/��ҷ5��]�yO,��M���%`��6	�T2���Zd��J���ō���zy4�&,\��Ǆ�4ጸ&�C�Q4B�H����)-���HM�k/��C���6�,Q�뼈eB����rH,cX[B1E&�$@$�4�� �1\K�s"!rw����y��9����bm&���d���]k�8A̟<&U���kG�M@Ђ���0���K\,���4�����L�w����������o��~[�a�n
�b�k��&�� Aa1�].X�(��=T�+�-�,���xBl��?6nP�&E-��!�A�q1��$���Tb*�Ar.d8:�Q�I�:��j��Y�X��޴�ޘ�N���s(��� 8��&3���~�_�yr>p,{"n֥d��	�
��M1 2�������z:ĩ���m������āR%yR����%��R,vk��aY�G�*g�� ̜~?��e�C��'gD��������=p��fO���(��V�D\�U����IlS�6=^]I�W����'�Kg�d�;��ѿ��qT �[~B[}���d����4">a\M0A�l�b��l���Ĕp��E	������؅ǘs��y�����mk�K*�]N+��^'J�	�*�eo��'��AJw  2���[��!�`����C4�;�ZC�:{5�64 �:��,-w���g������EWS����CE�u�	o.fd��&���S�l��}���پb̅
T�#���hF�ꃧ��{���mp��D�s���%�o ��!��|y�η���㠣K��	V�a۞"Q���O��>��@Q !  #����(�T��>�J��"�O�̸"�(��Q�?��*������	�s�����?���Mߤ�ɜ셳�[Pl7�?�|�FM�됒�0`~�j�f)�Y"�d* @���(X�fzt�r[oD����d� �J���r<@�<%/�iQ^�,Q��1t��V���~\56O�rEf��?s�A�G*��\{;��Fm���[�(g����A���&ê�������=Xs.a�YgO��a��P�d�:��Lg���5u�ッ����ӡN�~ȧPťhv��}�*���/V]\VÞ���}k@�t�e�(*Q6h%}�'���t.�:o�#Y���K���;����p�1l�-�s/z�o���PWW��=����@DMh   (,�bX�
��
0k�B��%.\<d�a�&
#�pO]�	���*��G�U<�+�p`X1�p!�V�l�1/����ͮ�׹�h��	��EK�:8"���6�b 0�'�����0⺳=]f�����d�=XY��F��\=KY+`����3l��������$�W X������tXw��D�a����������j��6'ǂ"yv��F�$ [� �����X�ˊ-���~�LJ��dviԥ�!�-J䖺9Zdӥ8��4R���C����nL�� ��)N�l�����wUɶDb�}�e\w��j��<,��2�!CcBB�2 �;Wq"���������O�dWJ�͟���g��P����H��
��`�`�\�Y����h* �%A��[��[p[+�N��
HuSsH�'v�x'�)Ҷ��
\��.�L���6��� $I'&�0��>n@�-wX���ť'�d�'M$����}��jNł.O��U����Kx ��'/g<�U)���d� �VYi�2C�|=&@
y/g'�UA
�.8�82�qW�\I���?���EVв�pA�p��`������>�2���12���v�ap4��]*�F4V(:l��WE6��u��9�0��-\�)�0 C��� @0`�@��� ��ǁA����>t�U���� J5)�K-��n &�pw-Ӑ
��DNV���Ҳ����/L�r\�xpP�K���uIkƭƏI� �ʥ� 00�"����`H�$   8��{i��}Ys�nP��!|r����u��'��`Uc��:�dHP2�$���f�Ǧ��+'&Q�lX�z
;�9��A�����O�(��LM�eC��+���*  �0g���Y	�M����d�95Z[	p=a�<0&U�L�gg�T�&����
	"fj��c@c�+�{�3+����hw�cq��J���]45{������C.�Jd�0���#�� �� .���c*���Ļ8�N)wdZ�P���T�<߰K,��-UOH��8�ADQdJ��>YD���64
�P�Ѭa8�
�L4=/��iMal$FdhFB�����p����0��^=\���W���o��~SS�vĂ�}R�L�'��U���ܑiЊԴ�� �� n���`��4���uD d,d)��c)�,��gY^�e�6 mT���{�柩����z�sOTӃ���V���s�RH?l�ȷ�^=�;��۬� 	�	'���Yw�XvG�dʋ���d�#E,Y�2RM�k<<�JL\�a,<���m��
��ܒ�r�\����Q}��¥/��m]�kܕ�vc��ҽ�W��%o�[�C2�`Ԗ1` � �	,�ұw�9�����KS���^�Ux�k�%51)��cO5�1٘�ᡉ��˚k-���ȸs��	@^9�qx�R<	Ųť9H���X��6�����^����>�5�z`��6������i���1�G��W5g�T�q���^�w��ia��Ri1��*4͏J� V����*,� �j�hyMN�jZY:Y�j�%ZW0��9��B^R���<���7]5�f�z)�� ^_*4�C��������言�dn\�-�K��o�<�$r`T������J(j���5NLY���d� 7WY�-@J���=eN
��Y,-T���4�	P��Y����L�p;^��0i��܏o��
�eVD1��gT���É�+w��� #@ 4�R�	hH�`\W�B.4D�1��z���b����!�4�'��^�#s�ܹ��K�o[�WY�\�O�QUM�:�+����yvu7;���N�c�����i0jS� �  ��])�
Ζ�j����1*Ə��5���Q% �� 3*�����H4���$dn�� 3� � i�rP�Z�0���X�t�80���7�C�-1�c�h��v�*�u��ԡ�=91^Ӎ�U����ɖ^
�����f5I��R5άs�%wY��eq��@�7�T8J��|��m�����d� 5=VC:�7���<eF\�Y�=m��+�p�b��Y��=3
_fg��\�����1����9S��7����L,�0k��:��WLz����ɛ=�{��ڄ@ŀ�ں76d�R.�:��v��ᵈ��FC�a��a�4����J�e�z��_e�y��0q��ː�!M��Kŉ���F0�֒�B��,J7�#�(�b$�L`]g�`���d���t�J5P��ψq�tϙK�����!^�\m�
���D���s�
�?b=Q{�*���YoH}8�P@s�)�h���,Z:�'$�a��Ef�Hx�(�:\(�L�_�����@�F*��@ 2 ��pD�wY?�N�J��Y�;��E"�m5j3�>��
J�<����d��DV�rG�[,<�t��\=1�k��<��vz
��溯
45n�E���)il�ݓ�b�8LP6y���*>���d�מj���ՄQ(&�����`E�_�C����M��<�@I�-'Vݫ�]G�X�,LH u��IH'�xu�%�7�,䵊�c^�6E������:��ҹ-|��.=`�35Ĩ(2`�������2�I������������v��Yris�0����l�s�!����4�:��Xmq�=�MI9�	�ˊ����\,0���:�u��U�ad� :6r^�a3�i�%��`;`|�Q!ɓ,�����U��SVg(��G��Ic|�X�	����ԕ�$l�i�u0�<�q���dƂ0[��3�6��$%Y�Ёm������ot`�j�K���uMH֭X  	.��#��j3���C����P�8�˝>J�N[��<4�64�T�
�
,3�X�X  �:=�m����&�-̴F`D,3�I>����މ�h^� �I� O��>�@�	�{����Ѣ2����ưP_<u�Ԉ�j�,����	/���+��@�c@�h��3�DJ{{?ʪڢ�`e��4�������&(��3���@�    *JI:Өw�5������I	�K��TE��r�8䴺%��.)������8��yab��)�pJ薊��{���r8|v���Ϋ�.A@ 2d]�,�����t�� �h-Z#4�ҳ���d��'[i�1P=`��%!��eL�"���p����`�
y*�nԬ�P�۫�pp��RO猑m�^.���,���}d�<l(z�73��������%�
�(�j\H��,X*�Ұ'g��Ż�"2�N�����dG�o3�</HQ�nt��	C��BM
�K�ɂ�ta���ou�:?�ރ*LY�`6�,=!���UP4�P��1�_������q�b@�I�!�;��ԒX6닙:�U @�   Q-�݋�%���"b@%��~G������ѯ���d}���:x���gz$�ɤ�4/B�4H?��H��� rh��@�oB仺OA��~[��|j�ӦǏ�b���R��
 Tv�� ,��z��y���d�#�3�k,3pB�[�="2 �i��t�ބ�p��M*���.B�5�)��������2q�>Ƙـ@ МT�cĮd4�5�O)	�Wju�<��V@Ib��S���0f:5�� i�6�#@���ѡmUf��<����(y"2RD@�ԉS!r}3�G�&���ؔ伔�G.l��B, ��3^>�`�����%��:����q�Ñ���:�$ !;�ȱ�hI� �Ǚ�� @b(��qA����/�2��(��g�����]"�^.�4��Xm��  � 
BB�j�J@�#{�FM�
@�Hƪ^�}���z���!r�dh�xіP��^tV(Z (s��ihjS��Ϊ���9�Tx��y�`�g�����m�H��5 �����d��2WcI�H�=J,�`�=!	����qSQRq!�C�QGT�6*�+����� ��Q����p�	�8�` @   �����Ƙ�*3	�.���Iu�xe�6�X��z�%KG4�QP����w��ˠ+ރ����r`�ܐu.����F�'=$�E܅�ѹ���r4�"��+!x�-���q�uJwwp��@��$ �%��C�:J��nȎ}7H�Q�v*�ܗ&��xJ*b��@:1�"IL�"&px����#��%X� N��<
A��J��RK�sA��sBr�h� WH��Q�C�eR�*�U��Nj�]�FC+g�+8̬kd]� ��Kp�IՉX���
5�T��/e��$��_� P�����d�6<���+b3���03�}[�$����4�� X8������.������o�"-i�
��00XT0_�4�QP��$P  6^�ITXcK�SUj�2c`�4L�����Z�?(hI�J�}�ȧ}$��7�G�]ѹ1X��t�縬:�)�M�I4�ޚ��~�C�%�#϶U��j�aJ���ј���;��� )�m) �;�d$A�b+�j��H������9��#� A �����*���\,H "�]�d.vgZ=hBm	@�*A��@"K8
�a+Yb�;7�6~��=��7*l�	{(�P6}$'%r/��H���<	�<		 `C@�X2 �����:'���Q*����� *�T�eeJ8=r��� ����d�1Y���7A[�0#R���Y,=)�������i�QXx�i=C�Nw?�_��,�Q�i�'�8���s$&!���}�n����(O3���Y�X�55̶���>a2�xJiD�uE   �ͤ�VA�"��
:�e��-��X8��DJ�=��붱���#�X�SB�����0R,��ĈM��A`kɝGȇU�Сރ�uSH�
;K�.&�G1l7H��l�e%�irr�(�ԝ�"U�8��dyd{��n @��54����������ء�̞A��5>� ^`  �2@�E­�9�M�P��/j��HKA[Br���sP�J2���r� ��*�W2��t���ê��i2�~B^�JM<�1����D� "�S	l+�a#^
ĉ`�ρX�-t�Wm�  T-�>M	����P�.
����5ES���o��7>�W�2sp���
���L� �6���T	]ˎ��.�K��,�	DW��J��hf��{�x�'����&�'V�h9w�z�I>-&�}��&\��rs��k˓�6��5!a�6���"�q��N�����Q���, �Q�%���,�   �l��Ԋz�O���
x�痑�kj` 5��׻nt"
�C�� ��"�fHlm����~G���.�>�p�����i�
��$�*,?E�  �F�
ِ��QL콨�_`�c�Z�Y� "�2���X^�sOtC�
�6�P�J�胣���2����Dڂ�=�i�+�X�[
=�*��]G�t�s�h�8���ڱ��L�:�RH5��b��"\��� ��F�w��B� �0ظ8��Kn�K��X��W��
�vwA � Fum������Q�;�y��Y���|B�7�H����4�M����H �#Bq,2&�e�\��U.b��`N�Ȥ	W5��rI�c��4�d� �[�_�����Q�K�`b��2��
& ��!o�  %  v���X�"�z�i���F�R�Z��*��� �~�m���4!�9[����7��C]�r]J���E�`�wEڌuWD���(��S)Q���&5
%`�	Jf�:�����hq�}���z��m4�7p?S��i���D� �>V�:�^�==�<��m�u1w%,t�
�*ESE��
��纗a��2z���Y]�uv-W��!����Fuk_Uk���a��3g�e �   ��o��./��\�'�y��&(W�|���w���m�6%���u��E˕/��G��.[������Ud1���� ���@����0m�xӼ�p� P  JZ9C�b��}G
��JSV&���+r܈D�K����_t�bE;^;���7_�����%zOV)|G�UwP��č��a����
�� sĝ`�|���A�As<T��L����%lv��,�/.PF'
.bl脜{2jR�)��w�K�d��ZFc1{��G�be�+us��T�WRt�ҭ]����uS5p2
��+ot ���DÀ#	J�Q��cF��<ʤE]T� ��f�� D9!
k  (   �ڌ���	�@,�SAa����,�Dng�l�HI0��(\��rz_iB�D�
����C�om��82�'W���9QȔ����\Ժ��QT������M5����RT�H�d<��*�Ѹ�͞ �m�(�;_7�T��$b2�ۑ�9QzGΕ��|b��V$�E/I;�fg{���;W�r��ÙeS�����d{�>������G������� 8��   P�m
l$
L���0�8�P;2T~RB����(r	� �S�Ԩ9��D)@�5�Be؝Ή�½Zk�MS�l"l��|�'������ڹ�O��֔��5�^�ay����5ڷuWQ�W�����D���XЦo  �+�i̼ �ci�� 
�m��y`]Q��k�mͪ�y����mZ4�Ʀ�>[qxũ�ijvJ���4�~y<�*����|���y���� �0	)B   D	�1�J�v7Ng��k'9�R�
3�Ȗ0�$%3f�Ñi��<��a�����Nc�1� z>&���� �s�p���au����_cm��_s+�ӥ�ͷ�,�1�rJA�h�����?V��HrL�#�H$�
� $	Ն=�kO8Ρ9�8&� ]�HT�5)\�J��z�O=�#�Ѿ-��f[��5d�̈́�<o��ގ܁;�fO�#rʌs���Y�{���_��y[��]j6�����E���=������  �%��F�H�J �H���d	8W�O=@ <"�d� �c'�O��mp���i�Λ]�_�@�E��MsO0��r���bƱ�W+���OS�eb����mX\����Mo?��6�a�wC�d�u/^���ÑR\in���bX*.���_�������l굌*Y.�U���N���qA�\&�F��$4**@�ڶ� @��PtLE��*���
a���z��2@a�RG?_ݡ>�~��B��!M.�!L�F:a

�00M�	6����Ԧ�F��ϸ����7�`UBb�����HMa#N�2'g�B��_��j����U�^����o��;I��2J���	5�A��J!����U	�@  !C�Tv1%8\F��&Q�jz&���d>5YQ��:K8$":
��[,<M�mt� Ru�]ҴW�1WQľ�wI��L�?�6	�0d�Hy�������0!K�(%�Q���*����fL�i����~���#�K�ƪ�� �����i�cy��$��k_��m�F���`g"�
8[Dxƥ�4.ڐt*3@������ � � �?���Ʉ�������{U2�GY������
�{�ϔ���_Τ|��jk�k<z��y����
ВXv����M��5Of
(ݗ�*xv
���::��t�.��Qp �U��6�jn0QW ������b�ĺ���$��D8���Ή8�Wzԧ�FڕH  �JI "�z.�qJ�	r�b0L�iw�6�����d�XJ���@=��,<eK�
K]L<������'��-hѢrNL��E�H{�)����$�H:H��Νz��i֦j�V��!�ܙ�y���f�gfʘ$g���pT����u�EBn�_CS����(@̏�@�@y��)��"e��r�
�1�_,����}�H)  		
i"81E0v��ì�0��}��w��w���N������A��y$�:y:��,�^�,�������02�Q�.¡�-ɣw�Ζ/��I]�^W�]�K9JQ�q3�7����+�7L��!�J    HH�;�ޘ:#6��`|����1g����a��ب�����fW�!��Å�����`��*q�  A"g(���~J���Q��,:F����d#cL����/ �M1&
am_�� �%�䠊��#�D~���
/��$�L�{<���O$�y�yL���c9r�Q.Ȗ�ce�V��b�OU�7��z~�wdb�C�0��d-�R�@  �w
v,S�Ѐ�U��L��N�������g��Z�� eh7B:
�i�1�%n9c,*u�����ђ���CÒyf�n��(��M�D>���>T�;O�R؄���#����kꊄR�t�E8�_���1��@�u����ƶ��н�+Y7~sM����pO���'��� 4���?�� DZ�c?�e���&� �4	��Ȁv	�hR܊�<Q_��
�^>�]�qd���.+��iO�X� ����w�����D�mY��3`TI{]1z	p�e'�MA)�t��@��A�1�u�`�$8����  #c���D��¥M丱���9� #���,��rK����E�9�*��3�U����_��Gw���MG+�V�`��Մ�'J q���pJ���<`f��֋?P�"X�����������I�����|w1ᇟ'4��;�����$ �l  ��`���O�� DEaCRz!�?��� ����^T�h��ym`Y`�����w�.8h�� ���РOgU	� ��GĲ���a^����Fx�`ƪ��FW�(���g�2����.dp�*{��F'���o��O�0/�3��R�
�D�L"˂4��;'X�~�� ����D0��OZI�BT�ˉ$C�I$?s�l@��4�� !0�C)ͭWe�!��[M�1U�]9�����/��%���	�wr$JFd��S�_
��-�)�fa!�hp@h��ｖR+�R$H �`'*$�aCˎ9X��]���
Hj�ZB�re�k5'�KQ#������à�0�Q Ǐd�#�Yn�ڜA�!4
��%z"�pm�1�
�(X�2�\DĢ1�]�'¥R ��n�����*'7�,  �,�N4�A�) �ae�Xh�q7\��K�p��:��� y%O�I�� 
m~>)|,E�R.���dK~�$�S@L�E#"��Ι~6�&-��.�s�˰�GI˨�@M+�
x@$�I�Ї9;�,�3�)���DF�dZ�& Kb�k1t	P}��nq+���8�1>@���-�[k�d�<�q%��C�����U8N���?�3u��ߨo���2<��&�
1J�h4vw��Ј���U9*���KѴ�aL=�S9�^�A����2�TS��q��'�򱼵�(4n�ɲ�^t
�L��`xP�q 4.�U�܈�Q�,1lI%���Ӗ�`dD�h_opM{
����a���[��MK����Q�z�"a��]�k�9�'�`;׋-�@ !�I;IE�3�0"�+X�Fӯ�1��L�����u��e~�֩9��t�������������� J!�H
��BB�OB,/1��%�o��>�Gu*���h���D]�g��2D'�L0b�	��a&%	�7����h��v3�.;������U�۪C�3�c@^T�PH[U;�����- 	.$���P&�B�d5���l�O��C��HoX4��g�>�h'�Y�{�
4������ �UA�x��� � >�)wW����c��BdtB'E��ߢf��r|�Ib$�fҤǝ����+��5��Z�
�H#͡�LT�G�����I`\GaY����@ G8	z<qLh�[���օ��h{g[ه#F�󋝎^��A����Z8����U����ᐂ�۞9�N�	| �f���Ml��b��F��OD�O��P5�m.���89�A-�"�ӈ���Jr��U�����?����	�n����!�1���Dui.�a�*`Kf�+0��G�]�IA2n�Ö`l��FX�N�a'q�1����e�?�j���r�͠(֫UW��B����S�j�����2 �:�d?��\�4mh�V<=[CS�,�Y&@��Y��@$9�"9����^$��i���%Ң���ɓ���D  7�0T~t�
�xi���]JW#��j0�fv�w-��·ִ��PG>n�"���o��3Ձ���S$8|p�J(�IIH�R�A��9<:��I|�g>���w����N��������62����.�� 	
P�O�mu@d8 �
���Q }/�HZ-9�0`NQl�0mci� ��c�ٞ�`j������;���!؎��T�U�z������D��"UX��A�Le�1*^	��m����"*,��	 ���I��V���JA�ɶ[h�Rmډ
�y��'��*��#�ܵ�
�LdL>J��l�����]ԯq�¨�f������	R!YU��R'��A��!(��@�t���Ӻ��$�|�hrJ����l���� J��}	��G*����5~_��%�}Qϧ�����Yaݾ(WR�- �%9����DZ?łn$@;�@�x��ɱ�ƣ�]�C+�Kg�C�� j� �t�h@����2��ҵ�T"5�R����O�p�M�$a �3n���� �J�GR���C[A4��DO�[��ֻ���<)a�J��V��  /2;�2�P��K���]�u��+yi�IP�V�PR���d���M]i�D6��0"��\�q�v�܈-��	��#v_�jY���L����Q��� �M5l��������I  c�\a2M#� ���5a�&�"�����,]RIU��7U�w�ۚH�b ��4*HA�����jZTQ?����rږB��a!�p����L�.iZ7+��X�X�jgE����o��5�_�����,�l>�@�� �x8YxPc��lW���@�x �.y�<Ý���t
.$Tm�jmtN����Y)�>��;�K��e��>���^�!(:Y�b�"<�{�U>�eJRT���He-
��9�a" d��+ɤ��n�5�cU!�]�\����:�����������L*>�0��J"w�Xc���!���C�>����D��L$ZI�1pL��}a�	�{sG��+,��x�mޔ�*�@�j�<�g*�c1`��9�s��&���-���ոy^}\��S53k�0ucHݲ
s( XA.�G~�N:� �J��\�A"i���HJlq289�H���;�&�~�A�_���k��E�P\se|X�&Q� (C�t�&\���e����f���$�����WJ2�3S󼤕����dD��j������K�{}M;��Ƀg�YIUH$�2_� F  ��}�-�p*h�*��1��Nr����,RM�|JI��8cOYM3�����n[�J��,��]�?�˧���Mϻ��t�t����KƆ�
����'�Ld�0h   ���&X�1�bd�H:,���D� Y>[��*dMd��a+N	�u��KqL����h,�l)���̼�&�5��Q4�S$���/gN�:b6ZW��VZ0#��-��v^8t�]��������ԗ�Ç���1�[�*��\㸌p@��'i�j)��]��A�b�"�񵉐�Ѫ������
8N;U_���"Ƌ�i��x�0g��S��RK������)�~b"@�2�oY�������	��eؾ��������I�PJ1`��$�E�5B8J�^��@�i�K��R�Q��Ã��D�>��ǞUK
�B^T���ؾC����M ��xt��Ș$-̄�ڌQ��������h��%�ACq�.���7{~}��^
��������˭�����*�%�d���D� %<�KOjpl��e�>�X̱g�v-4���O<���z��+�aP�  � �[��F��5�ذt��y���Ubʼ��"T}$6[(�D2����j���Q���P�z���d8�����������ĭ�SLS�F��B2_���TI�	`0��5#�b
�(���(�P�1Ҧ
��Z��@���}0��Br[��t�HI]E��߿��o��!G��]&��Ё�?�x��Q�uF=���%e�9��
@�E1cT*�uDv�e����	礰�@H�UhnN����Ҥ��=���6K�R��{�r�B�>�G a/v��������FZ�Y�$a�{�c �P A
�Lm����6h���ꎉ���I��&�QU������Dր-֛,+�d�:�a�:�a��V��*l��	��h���{������x����r}���^��\���P���3�>�Y ˼����
��e~0  ��t�?��9^{$R
�n%@q�����,����� �hʩq	p����-�6�@`9��(�Jժs��RjW�Ӕ2��P�����XW�*E�I�3	������7gjx�h�yֈ]�C[���+�����j��*e=��¦�N=��C�������BV�U��9�#7�RE�ݦ�B�	�~���!K�ўt����=˩����t$߆i�H^bn�;� l�
��}��Զ��:8�,�i�}�vj����\Il�[HB�9^t"'�Y�f~�����D� .=V�p]){
<�u3i����#,t�`K��%�kԅ��M|���i����'��
mkȵ����ە�y����o�m���^�5�[�E��U;zZ�V�l^�tɶJ���X ݥ ��GD��a��-6�v"e%!*�&b�W�bnOG[��n��0�{5?��ĴȄ+��3�n
s\s%�0��O��H�/�,0q.~�q�.�]a�r�A�M1@T�V,�^G�P� 
aw��,}�rg w�F7\��З�;T+���gm��r�n��vsm�ɪc�S�q�ZoW9��%_����"@�L	�7"tN�����d  ڎ<c
2��!��l��ې˩������
!R�ؕ�(s�p幪Y@
헮�Q��l�$u{���D� �-Yi��^eۍ=����],0m�i���� ̟�M��S1Y��$Q��Ș�,(.b����@ %LK@\8�F �:��tN!V7tIqH�܏�ʧ�C<Ѐ2�QV
	����E����ހ�:!g?� fv�(w֐q���l,���r�_�y�B�FBm(��L���d���x��!dH�����c�`r2��T�3�[��Lr���utף��&o���3b�*'ƽD�&3R
z�FT�DC"�x>�����q��ᡂ�^�:�:����('���߁�����\(��H6�ޞC�oe�G3͉^� �~�$#�1D�y(B��IJKh������b��ZB��{B�x;WF,�on�F)v-g�p\���t�"���D� �X�4 WǫM<e�
��c���Ay��<��i4�%"��l�qtM��Ng��/����O؉<��HM�{��'�20�8��E���#<���((�v�<��ЂLv��"(����"X��XvԖ��|����m�S��	!	ēdf�� �-a�.��51]�FP��G�BQ�]w��(�C?��"��eD?�Jt;��kʂd/���83� �QL� ���`�+�~v>�F�qN�NC�u5
[�$�E��BM��	�sfI�&�(�����)��	&>!��L���3`���ha��><7e�����&y��1��S������ڹ��MƁ���Pp:�[�
�Հ�Cd"(�Q�90���D��v&Y��*PP��j1B���[i�ҁ�,���8�بV{Ox��rs����0��)y�� ��	_�!�lB�J垥Y��nU��Ս�T��X��T	�����j�ѧ#z�s�]�4������U���e��P>�-F��k����{��C�#	�]�?�#���$�_�ea�T�  ]']�
��#ZQ�A�h��"�JH�ה*���aA["P$�K�Xw2�|�p��a���R�	��cLŪ�D$Kkz�C(�l��G_o��2|I�>��h	J��
�Q 0�)%6e�Q.NKȜc�3b�/N� ����d��K+�����_�����D��Ki	I��v�/�b��\67�U����Tpc	k�z ����xJ���d��bZY�	<V/��0�$M��Z�0����<��]9�Y���W}I�O � ���I��
�<o\�  HI������BwmZ[=渎��^m�w#Bڶi�^C_��a��Db��/�x�;��@5��(��Ɇ��z�*(c��j�H��*�����VJ.2>�W-�a�[�cVVLF��w=�q���C�z��"�e���7��6�r��L��S�?�b�U��� <�brG1(��'��<y��%��>�cƙ ���i]'ɡ44A���c
��S}L,`|�)�b�Q{������������Eϳ���j�U@M�K���8�c�\�����Ҋ�C���8����:\�u�f���̲{��a�Av�^�G
�O�9C�qJ���DĀU[���P&�==j
l�i���P�lpƞX��ÈA8�	�R�h���:+�2�+�q��s�qW�@�P�9�\��� �d�*��0�[��&Ȗ���GT��{��go����&�\���k��e��@k�  �@ w=>v�	�	��q���c��:�"K�(y��<�$x���-�w�ʹ;踾i�1�L�D��a�a�K|u�]����!�˓h�5$V� Ş!�#\��Ek��
�j�	!j@!p
�� �K�4���e:H�|BXq$#|-vѐ\[�s7B��Ln*��_���c"��t L(��ލ�����v�������*��}��Q�'�&��Y�v1�QO��m���P�My��a���^c���d� �KX��F7E�L$':�ye��:�q*�����^Ɩy���2�rF@$�4I6���}5e*vh`~@�E�vH
��a�d�;d�`B�YtjS�Y8���?�"��&��,��HxPP�l?%���Һ��!��L���#e\�
��?���m���;0D+�h:nXЛ�OQ�F���g2aW
������Ր"uD5M�r'�Ε{�z���� 6w��}�����h�3�Q �HI��U#�V۴��_������Tӥ*�`V��芬C�7����.�49���o�,Gh��F�^m��m�^��`��xw���Ta*���;���3����m�^�.�xP��������*dW�   ��-ɳ��`,
�v����UgK#s�ش���������d� eJ\k	�3���<&#�|_o���H��t����W<�Zc`6V�K�G�1uw��S�rO6�;<���0��� ��C�1�p��@[ =-..�C&=�Ҷ�A���ʇH���詳�r�z���g]�����<�:L˞��x&��F�c0'J���l�[D��9X�Y��R��UQ"�Y���w����q��`���������q�U"�����d[�  PIÐ�,�U��MvՇ�,x����D�ZK���.Ƞ���ؽ���CI9F� ��l� ��vr���#(?���
h��Jv4e��� ��h��]�uo��z_����C�C�m�RZ��uev
g��<n�oos::�����FC̬����d���=�Q�-�:���0R
��d��M���t&�� �b�OH9ɨ���V�#p�HZ;��	B�}0��x������� Sr1� &��%'����EA�c6��}zI?��=�t;�
���q�KyS[4�TA��ٗ����������չ��EM��YET7SC�b΢P18*4� ,@��obY��]��H� �K*�q
�D��d�hM�mO�������E�0}���O�<|Y"Q]@u�b�3�ap�� �B  XJ.�0Wuu��
��O��N��p:�i��T����̆+�"iտ�UE���WS5��Ycs`�����fƞh��j�������[�<O����gSY���s������ݜ�ۀ�tU���d܃�J�a��0���$)#��aǕv����Նtڢ���H��H�EsDkJ�������B�%PV���7# �2}ψr��]F( ����"�1HA3$'"��8q���.��`�l9U�q)=�iTo˴���8t�+��A�j��v�h��ok�T�c�68 ys �Nun��|�Z��U	�r�>�����q�&�Q��=��t�]=�"�����GQ����+�����e�?�6�-m
�r ߜ ��h 
I\P��-�&(v����6O�3JJ���,u~
�|�74_���|7�U���D W�QeW[6���q��3�   a��F���C��9��ã�C��у�Xt
X�S: eU�A mA L�f[�
h�s���d��/�k\2@a�\<�(��cg��A��tƽ*�P�G���.o���|n8� �;�~�:�T;�c&j"d��i����5��B��� E`#j�h$;fV����]?-ϓO$f*�o��F��h��T�%m���������[���ݘ㳂.4  Ì>���D+�X:RwI1�Xm��F�wg  P�&󷰴��\�~�G�B{���(ƫ+��2�!��L��X��J�+�˪U%��p�V��(�%������QDW��U��hNԚ�n�~�%�,�����~��H���b�|$U)�p����9�]��ۣi!�Vo�{����~ϱ�o��ʖ/�#$�X�Ml�Q�3�9Bϸ������d��DW[,`Dh�+0�8M�'\�,Q��t����}ڒ++�lt̽!_r�v"���*��4?ۣ���׺]��'+�m��I�[�a[h�@0Ҋ��H\[G"��mW���bK���(�v`O���D^ۿ�)�x�����+]k�sdk�I�[A�9��E����^���?�]4;q�   J���JT��) ?2�Iv��ԁKUenI���Vr��	\�9Gd�#n�@/M��^9��,xË�
���	���i�Ƞ
��@B�H���  � �r�H�`� �XOl�:�w����#��ލpl �Z��S�9|��~����#EW�2��L*ڝ��e@5�b]E���7�gfi[?��^��z=A�K��FHr i�� ����D� �Z��@�S�ˍ0C�K�g��l�i�4��`vv�/X�M��)��b*��澊�����:�q��tP�O4��K'Z{,q���`#�%�$�
D�0 `���C�^��TK ��5*ҸWF�Nm����[�X����D)8��4������Cc�o��+r�{E*�ު�7���1+%P8(/�5=�2ġ"�CuB
�u���}EX�fp4�gѠ��c[H
G"��g	��g�2�|iֵ'�T�!o�V��Ӵ)����+�j5��Ȫ$b$ ;	}�H_)��!Q�3���@���S���y�����Ŵ
��{��,m���2�3)3�!��0<n<3�����NK�

�Ž��b�R�� �� E
�Dx>J#4���d� fXXI��@"�m0gH
��a��u�p�8�P)�����������o�A��(9�Q�$IH��쁡a�$b�mq 
!�BQQe����d$�����hv��C��M�����I�sG��r�R�߻���1G�"�ؼtt\@�D�l��B�
G���P�(ǅ���ţ�ҿ�/�+�u��jR e �4Ƅ8�#��Rn-tug��9�8��3
�#����DHYď��\:h�i�\h�C�<$:��m�  �\�|���Bz��M=�$9�,�}I(�}��iiF�P�m�f.��W
U!�و�� �W�<��ٹ�	=̮�t���ĭ����#H�C�4�� R�0ߞ�Y9��4�����d� /�cpBD�<$�,
�V�=K��l�	h�Z��E��Ď2�qP��X-�&�T+��QB���b{�6�"=��]����i�C qUv�WS�LD���L�@��?�֠)�N�>򻢖]&�:���Z]o]e��MP����w·��͍M��t�'�E���z_�e�.�:f9F^ڀ�{N�G(��g��-�g���P�h*�	�5�3��~4�G����OqI�,�6Φ ��?R;"e���	o�Q��>�b.sm&��L5� $  aCP��|FE�iD>��
��!�ߐ~�n;���gP �P��'j�ŀ�8�$,
�h�Νy!�r�w���	B$VK.��*���5s��
�dtA�"����PT8���d�!=���+pF��=bv
�[�,q�,pĉ�A��yG� ǜl���ڋ�S�j��C[��`�ĭyR ��ICӇ>!�l:~� k"�$�@ ���B�BPF��Z*76�W��{��px=�
,����eBN��|�ue�����CN�?g*3�����ݼ=��<�,���h 	R(3 �$"���	��2�ECdk��SuJ�"����OY�G��	��Pu6���@׳�%��4$:����cD��`a�0��)��  Z��B �J"�Fjfڍ�a�*"��
Lt�,�Mȑ<]َ%$�3�&$!���_ү=��1_
g��F1���B&�#)�iv<�t��􁀸�"����4��Il�n���D��'���`WD�o1bt_a��Id�m<Ĕ�'rՒ`�D$ V�%3����[��j�� ?}�fު�UeQC���"�Y�L����\Ov�%��,g�R� %�Q�JŖ0�&��'[p�? �7f�,a����ty8��YF��P�hQ%���A�2�~�bڈf8U�:q�:r ��k��6� $)����N���U+��9
̓!H>��K�)� �>4��8�HeF�6i}
���W�@�'�2���a�O�Q#Q�� 0F+YǘM'�Z�n{!����*|�O��h��>��Q�8!p�yA0Lɐ��Ώ{�2d�T�N/��EXi��Ȱ��)��  ���r
�*��<�A�uЗD�*�`�c��h+&+!����d��5WcCp>��0�D0�c�=1�M�-t��8��$m ��}�4�Mш͏�C��b<ک! ��h�JnB�oy��G,8�
�L�H�Y�	��P��s�t�G������q�&�����ADqmY�0�rCB�\���W��H�QL@  K��_� &Z���YʖX��� �Pi��阋|�*��wl�����v9<���L��TR��o���y�_�V�s���Ί��z�z���PCL�d 	pYn
���;'O���H�Q�MK,���R���ac2,��܂x�hBkJ�S�TB   ���l���8�G� P"'�'*��@�Z�rx�d������㎲gY0`�@� x��\�d�lؠ q���d� �3[�)�-���$" �q�m����'�H�Y���4k�o��:��P.�,�� �C�NA���3�Ȼw���Hh���JhC�ËB�C�*�D���  k�-�R֚◧S��;rjO�K�$��>ܝ��}e
�:�R�α���\�襥,5kL(�BA��6*BE�Α����Z�7� hAU�pJ=+�T^��^���<o��0R�Hm��v~m��(Y	�
6�����    *����������0���K��oE,�T�'���$ ���rP2�0���'M;��P���/*£���ODH�F����3���g ��'�ThU^�v��ҫ$� A�e�U��l.����d���y��1`�,�
��m�m�ޏ�l��Jt�l�'=O������0�
�4\���S,I,�R��(�M��ƕ]�C�y��� *4�l횳%}��q�!4V31�N�C��#J��O��uG�{[�4�M>�$@p,�h����M$���ޏ�M1:O���bm�����j4^Ԇ�Hv���rC���S�Q JRH#B�KQ�.'yQ529��<PT"��W%n�����CcF%�+h<lꐅ��-�*�k   �JV���ѧ/���nNx���5�mɂ�H@6�I�$N�����=8��؉^��=�ZF.��ꨒn��k�9�o�Y����p@s��)e1���Ğ�T��)c�v��� 
8�U,Pѯ�09�$���d��4�k)C�I�O=�
h�a,=)�m�����J��<�af1v��Q���8p��#���{(�XY���M8>4Z�2��X 0x����HȐ@�T�zG8���H�u���IPg�X;y����}��,�Z�  �D�P�C�~G��+��z�d��|QBQ�`E%�巕����#T��E�N������l䨉9�L��V��l�Ϻ��oF^S��T�1$��|����$�Q��p�)���?��T��XW���U    <t��5�rM�y,t�:V���VMD���|�Z90S�kD��T)���Z/H2�E�\�X�2h�ZN����m�U1� � �95�8��rD����R8a�?Vi Nఴ6^p��\���d�V1X�	3�GĻ<ej��c�0�A��$��bc�`�G���I�����wƮ���H"���ִ5�ͬ:�:�hB��c��0N��p�  � C7x�[·ݥ�����x�m�E�bu���J�i�wE�F��B$�>�t(�$��!@}�U�o�)�ž�����I�۽|d��v��;�u7�������⻯�¢Q����S�e�dY�|�v��.��W
��'�d��ac"�K�SR�XTīv �M1��u��R
%#M2�I�"p����:O���M�R���NB�n��8"�`l��0�:9���$>����2a����]��Q����d
b"� ����T���'�!�
d>�S��)����d�M-���30G��m0(R
��a�1&� ��t���ԫN�������G��yT8�|S���)��aC��V�w�]�&a~u���3}�� �И@�p.z�Dl�?$#S�Ϫ^7���[$�!�ŬP�y@Ѐɡ LH���J 	L���2y-o�@�����B�
V���~�	"HM �25���':��T���j`-3�C<� I����w�?�ֿ�)k%��E��"9_/�uEAP�!ԑf�-�r���Fz�T�H  )�+�����E6�b�V���S�Nn�֪Li݌
լl��0�i& ��eð+
<>&�JBÔ9.A��y�(qG��{�6K*7X 8�` 
Ƶ����ܤ*C�gX
��L�������D� ���/0TYd�?<�t
�Ei���\,l�`�4/�Ji�X�(�����DJ=�G3���hNQX��8*@�0^X�2�l6�\s2�sTΣ��e� Hɛ���м\f 6:(<-����픮>�ڐ�
 %�e�IKACv6˖JQ��
�T���QG�##
�x��H�,��'�,�(��:��),A ����(XP�&I�A H2��p0ܲ(E�hTfOc?�@�{.z��n�R�K�0��"���/AlA��������=�׬���	SlN�	oG��s��~̖�J!���{ͫ�@邹H���9��9�����v�I�
D@���:!/	y����\��
v����NAZ$H �qp8ʃe̛��%e�����[ �/F���D� "�Yi� V��,0e�
��e�0c�V������
&a Z�6w��j YDV���5��&�W�we��;�sƼ�>\�d�G#FU�'�~��. '��O���R�
�P12(Y�F"Y��
�WWW�_5_X|k��)���=�Q�#<D[��`��Z?_W�LS8���M��Fx���L � �@	��ض�"Sw�\��
���0�}���*�06?�#�!��ZW�H�h�~��'�� q�ϱ�
�L�\c�U��ip�@-H� N^�a����\�� �3�9"nLK�8Jo����U�i7d�m�2�"O��`[�1�cyV�W;����o���)���o���O�T��#�z�  *Ee��*�'yؚO!F����D���i�,0Ze�<�z
��X�%g�T���!�1c�emѯ�G�K�i�K�f� �í�Q���c�u��O��u(h��!Z�
Mg��J�D�&E�@� Q�.��3R���;[�/s�|���Aޯ.4�����_.)٪�)Z��Z�B�[�&��h,�#�DC\X��嵏�M��ȏ4@0_�WA�}D'iQ�7�ع��V�~,����@D��>�t�������K*�Ҩ���-A7��T��L���5� �  |el9dOU���S����͈^HIQ�^Q�_��F��!{�O��0�bL��������[		�1���(�5���'+6��O��8�P �D��@HL@"-��k�~ܻ�;���D��Yi�B�Y��=�>	��Y���O�l��� �ҡF~�2T�;8�E��,WfTQ���x=Ǉeֻ,ۥ���|�P�ȭ;���.��&-\J�����5�*Z�
f�����S9e��U�L�����q����x����t�W�@c3����h0|�sX�Ha�U�&�!煀�	E�B��oW�HA$�fH�Kw�R�*8�G��'��J�č�O[Up]���ΤVm�J
.t]�w�B�u6���8���WiDr��.��G�yZjs����  	ש)�Y�L
T����C��e��AI�l~�%�B�� �!Y��/�f_����Rv�dhn�<3{��ҋ.�TS�¸{䅯����������'bL����D��.Vc	``i��=%�
ԛ_G��AZ�-|���~��⋒�0XO��#a�i�a��,�&g��lyl�զ0^���-,N=P���j��J�V�?�ϙG�۬��g� e����0D�& }8.�!ޢ!��d��m[$x�H�D�m8�l$+0F���Q��)�̜�2��D�e�l)��	P�
$裉 F�R�G�r�)��qP]�k�(�%'=}��\N��s
�I�/D�9�Y�o��)lȂ�P�ّ��:	�|��bDog��ʇ6wC BY� �4��8ʲ��^p�I��m�?�/�[�'ԕD�Χ c�|�y0��#�6�����u(��2I�e�B�D�6H�$�H��7�s_rD&T'G���d��Z��p<!�=0�-m`���ƪ���&1����1"� a���ݪ�  �*�B`r	PA�KO�f!�����!���z{%œ��>e�i�$H�Ck!���7���`HS��P|���^����>i8�ή|��*8t�M�����?���>���hP��+��>�s�Z(�R�[��V�I><��G�0�?��|<�� 1��j�!��^WC�H��.j��?�oo��oUVbڒ"M�FFZ��"6��� `��� �HW�@�ʌ�uV{T���@a����@��
0m|RD����㸚�*��*��А4�&O�@3	��s�ca�ݢ���b���?��@d� *VT�R���IA�o�|O�R^W�/�����@�H���}J���d� �^W��L�P���<T�c��@��t� ݞ�� �H�	8�#`Ų*L�>�����%�����ؽf��_��@��D���s%����?:�� �   ���M�M��FWa���F:�)��{&����D��ձ�I����]\fvy�k+�FU�-��B�r��I�u�k�&�˖�,\�l��k���٭WM
�},r)ɖ�]�{yn��GE��懍�`�K�A����=���������s٘�$փ�c���9'�����(CqNj��,L�m:.�gGeX�x_6lլ;��w���r� z����}��i��t(�t�ҥ*��1�@lp��Cу�ø�����b*U&v"f�!75���/�߶�r\����5%T�C���d���VX�	;�6@�l=#!�Ec����#�����=6�j��jg��O���Ԛ��������i��Iu&�9�w��  !��\.)�����9��A�vpoz��,�$ƣIr�$��, 
<hq�r��	�Fq���F�`c� q��<n/h�����X�����r��`0� 
& �*�a��A�`�
��1`�MRk�Q��wS�v�h���^��h 4>4��}E�*E �xM�lB�|�3ˁ���*W<�<$��Eg 8o;�Y�rDˤx��z4`�0`\pcl���i�Dh���|�8!�PuA<�<L锤:�6� ��i��3K(H����a��hGH���Zi���
�P̰�!����d�?NW���;�{~1�@��e��S��<�$�*�7v������׼�ۧ�@�6�,���N�P %:h5D�g�Ъ�;���Ȧ`�&�M���T�#����;�(iX���2�D��G����B=�ֻ��|w����_l�����_a	��o���<�r��)(}+�೶[�v:��������)�"\���.=ΆR�\uFH��V2_�BR�P @0 ��5 �����M�l�p����h߈,�d�T�Ե��Y0�GuaG�@�d��q��}��Ѩ�}<��:�ݶ��������BB�"CB�ѩ�ҁ�&E�L�]�ŐX��\�G��C�DSˡ�B�r\]��U3�}��/9X�W�4i����d� �NXC	*�@�[\0"@%ag� Q	#�8���h!ԊD  9
E�.���n ���w�+�J����7��;Z*|�L�{��u��<q ���\�;%0|�MS�X�8���p��WXT���1�Q!@T� D�����F��:\����D�?�P(���B%?��\������ֵ��t����)E�h��ͬ��M'l0� ���e��!''��gC☒$��(�&�9�v;��KdGd��yԹ���Gaљ�v3~�Ւ�Ǹ�-��jy��^�_�=߫��c��9G��p #�(0���
Cc�W������%��}�&Ps��t| ��T�5�
��	غ��	&H:(�rK�dp|$�Dð��M ��q���d� �(Y��PE�K><"VDgi����ڂ���	�Q�Ѭ��B�%����Pk&�F�[���o���R=Z�U��m���"������?���f���<�CH�P�̠ �]���Ю��i���u���+����"���*Ϝ8B���jJ   �l`qE �<앥'۴��҆c+h���2Eл�q���'A6�����Iԓ*%�CV؛�7�/#��_|�������o Gpt�˴�/��i���f��	F����*
��E����)Q����\	,*;�( �A�R��A��X�N'7����#v�<Gd�J�biZ����o�����a#�j���q7߷/;�q?a���g3�[�����d� ��Hb5��`����g,$mЂ򼑘|��x��c���I�j��5�� k"a�� ���49�"8�H|��P$!g坭�w�t%@ɲ@���Z�:����[�*�bl$�D��8�P����>Nbvd������rak�����߹����.����(H�qhQ m���E�  ���\D�7�tk*-��Ǝ@@�%�N.?9�ג*b��[�M����)���
�E�P;���ǴXWx��'JzK?���  ���B�'�M�H��Y��y�MI$�;�=?>2O4H�L����y�$�ޏ�I$���F���94�WC�l�jZ�� w�jU^���
< ���i}kZ�@ 44v''S*N��������d�0�3@r4a[� D���gG�i ������A��kd#\�"7��J�滤D%&H���TN�SjK޴�Bc\
4�E�4 	� "R�(�Y2�K��/%�H�i�Sә�D[��-E��P���T7,��&��tФ�B�$	�w�ޚH��?:v
aF"vv��!��'	0��Ho_OO�JPw�$ �x=���?H��I�łX�.��Ί��dF8�G���� x�K2��(��FJ�:A��* @�A�1nB�&`.b���TU�:2����8�o��R!��z�.�8]�ڹ�ԮjW��66M�c�{_t�ڰW���{R����ΚՎ���N�3�I�I���xf��������� AB@� 
�KO7#˶��cй�@���d�R2ֳ	`D��<%8 �Z�.��-t����[F���Ę��!A:�"�2��_a��E�T��#{�8��'#8�����ӽB��,�� �"�Xy���"��C](���Z�C%z`�s��I�Mr���"��R<�G�-\G���*bVZTT=#�|e=;�<\?�??�/�����$��p;n��
?��� ����{l�][���
iO��\JEN�0���$4���`��DXk¡)��� |����l"� $ 2 �#]1
�"�����cE�FNU-H�/�L��2���]K7���O��
Ow@�Nr}��.��n�鉺I$��h;�;�hQ�=�Cܗ���C�JY���y�+�g�Ȅ��� 
G�ێ���d�~HT+/,pI�$&@
,�R���
+��(S��O�M�����.�Ek읧U�<�k��kXt9��2Z��0���V�$ �  "�Sf���d���v�g���Q�WR�f�4�L�H������:rَ��[�m}�yޡ�Ⱦ�}�4/�A|64>;�������g���.-IV^���@%!�  0Ԝ�.:�G0�p�᩟��.�uSg���j!t�d����
��T�i0�T� e�>����h�EQ  
%��

e��]��@�=�4��C+ޞ���ڔ��
j_��|��Z���� 4��|��W��{�$)=.��ܒfӼ�����#j��=Щ�gFV�kj_+��k�9��5�������d��9��I�C�k<�@
l�Ul<�A
k�  ��c����q����c>uto�\�:�6'v`!��n�O���3VjD��u
���) � 
�:ךs$��0��Bw�w��yt?���ä�'C�\
��m��bFs��h��s�q��l 4�p9ݕ�8 �~����K^~���wj,��︽��^��f \8D�#��'��ȸ˸��q]��� B7���P[���o�~�o�pAB���}e�w��T9����yS2z�7HZ\О:=�8*!&g������J�  *nN����l���\Bn䤩�0U@�}�uX�(���5Ji%��o��RYJ���c�x�X"
?C��קo��A�l$��*H���[���d��LVC	0@�=b��a�=�A�l��
0�$L���E���Ty>.�
�Mdl	"^_�����$��"���r�,�2=R`+X�>�  ��)XF.�Wê�!Tn��uc�}Ս !B�]��"z Y�SB����U��]$HP;��g��v�v|�
����J�Ly׉��,qaN��V�ȦиcS�;�&LNl�$�.DPk$�@�u5[,o;�v�	ʣv�f���T�nP���!"�������)���E�S�[@�!1�⩩5�J�ܩ�ȗ��;������Ҽ�Y�[_�I,陟?�]9BNY�wf
9���"�fedtΘ�lʋ����\` ����&���  Aw�c�R�lO�0�q�y֌�Z|Gx
���dۀ[i�`7�{0FLP�Xm$�@���� ���XX[�A�(ⳏAЇ��ޟM���ǌ  fD_�L"��Bė��B��e	�>���84
����b\�״��,�^��H�!�ɨ��1OzI���Xt/x�4/E�G�E� �t��@?JQN�[�R��
<�0�	DV1����#�����Bhr+Ǝ�5���u-���sBq|Ь������rpr��2�0�����V5��C] E�CQ ��!
m&"fl1���@+�q����!г��* %�!$5��J5�dR�T݀��J�>n��;B�|�Z^^�%�4���B�]�D� �U��L������?�	�R ���wҵ5 �N�D���D�#=�o*�bfj�i"lp�RM�qo�%� �` $"J�t�.����^�U�H+��W��7��{�ч�#E�d��?K�_�FB
�i8�C��H�$�I���h���⯨�.�Ɓ���]�V̑f�a    �UT�P@�E�7%a��K���u8�j���~n?B�.�ڦ���
�
M��Q �0*2�2/g����繪��돎<$���hT
���*��{�,n
1\�2�$�,��s��g���|en^v�c�F��Yr���џ����`�2�}Cg\�Ph.�b��m����Q��ͧ)�w��n�I5     .0B����1�C�]l�V�E�0�2���/�f���3�y9��Q����Kr�� 0E��U����D݀2�=��Ip^*�i�<�O-�a�l�j���X��)TD�]H����]��D)�����v)Z�m��j�G_��� "   b8c%Ā%�k(�
�D^��dG��DKӶY^<|��Hƞ�,��Y��?�%��7����2���O�����c�d�GUՍ������g�B��C3۠VT ��]��#<����� �[IC�@��"F�:�ZH�F;��?b-�"e'lC5+ϏiCW[�$��l�3o�����l�����|��gw��_�?��|��Qq���.X�(���^����
��"�ʣ*w�I���2?zv&㼚.���s��Y�b-����[V����K"���W��)�B���(S�e�F�/�F����D΀#ALUSL`i�Z�i�nM�N�%mIá�������� �!V�a�  P,�q#��DV����M�{"�"1D@8������R=�>v�W��Ep�F�1 ���W�44Uuu}CRJ�k�j��k�~���x=O⡃�4�ߓT���V���` ��+�>������i���!
\{�oZrf�����z�r;�$��^�M�L�y�C��x  �`��
k�ek�A�8;�F ��eX@� C�Qˁ߭�Rb��"I����$h�:� h
=k��ޤ?_0����뒞C�O?^�D=�������?Я��_������fr+��YH�{(��0��k�P3����z��d �$0�<��Y~f�����}G�z���D��\.�3xXr]�ڕe�^
�L�=Ƀ�����0��zdJ���=�Лኛ�АL��,�u3c�F��`�9w`p�jȦ ɯ
w���̟�S����G.�eO��U   ��4�\_A�1IBn7%j4Ǆ���C'C��Fka�;�uW����)��_:�����T��e@���y�,ͪ���r>�:�_���ꤾ��|:Ha�\pm)2��\�<��'ʻ��*.��3Ő�)�)�XC�d�a��p0����A�*�Y֞��_r4�Z�_	��T���Qh��^�/�j&�`�Ҏ@*U�:~���PA��y�$wzD@=�e��T�=�����1�]�ws�Bi��-����9���F�u��������F�/���O�'��|�UD�/����D�f;�c*�_�ʸa�l��J��O��j�����0c��?�9L�z����P02�j����ޭ���  '���XT�-u@�z��d%(��4X�&C 9�*s����]eU�٪�P�CR<��0�nT��YS�2�������*�Ѕ�|�x�Z�­�,�   12ƫP��i�K��%�(ງm�������M�;3�^�[�x�i����K.=-�%m��đ��1N�虹��G��*�/���o^P�p,lbf����O.��jV�3N4E���C�j��l��d;W��χ��V�u[_Jjt�tb�����9/9����E>^;�<�2*]VbzN�/�'�>t��ZlH9V֟���z�����?C�+�$q!��R�aSU!���Dn3)<��/�f��a�L��Q,��A��*a����@
�O1�~���ED��	+�F+�S/1!y�Ȭ��r�rt�3��)�ǐ���T;������A`O��o��t����b !JzJ�3a�����)����˫��J'(�Zvt��!�@op ?��*6(_�6--�-�?��F�_ʌ��\�yn�
F��'�
�z(���~��k�  ( � X+�].OESb^���F8���B#.2�O��g�̩1��o��s�e��yT�d�+TZ��Sm*_�_�EE��ońa!m�؄�IB3�y�a��h  $�NIvFEd^b1GCg���3�4��:���"� ��W���ЈY���>��d���DT
#%3Tc*�jj�a%�LeQ,<K��-j�� D0tUWJ&2����E��S�Gv���W�uOR�I��G_�0| 1J�W��.;鸨�$�H�nf�v"�"G�w�H����y�������ih��h%3��񇻆f�"a�JY���=�A�Z��R��:O�!�G�[�@ � �� 9΄ :\���/J�"�3;:�x����n!��D�/�s�!����� �
z;"����� ���8B;��u'�/�?����َ$߆
c{I [���J��n�Z��С�KLZImj�}ǚA���d;V�Ԫ.���h BB�"X����ѕH	��H�
�?��}���c
�#D>�R_M(x��4� 2T�"����D7 �<T�@Z���="���NǰV�{������	�>t�-�9��3�ǜ��RK�
B����|?wK�!d�[Z�Ey�]�`^�m�u�Ns}D��nၼ'�"O��ƀ� 	!��y
0U�	"���T�L�Ҍ�sd��m=���G������3�p%�O���ݸ��q����0�M���G�(�!*k8c@�/��.v���"

��A�U1�O�>�o2������q�$r�4�VWG���n�M	go��;��s�ѷ�px�.q�!�Z�Q�H��p`�Z6�Q9
�B�tH�S<_�h�و�f#�/R��c��Ree�t3`kS�t{D[���9���4�p�o&Wl��[�U���p
����D%�3Xi��`fJ�=�ЧU���Tj➰ #���łFq8�@T: �.��� ({p�,�!��.I�z���u~v�����
KW_��8��e���G���@\e:n�B��#=�
S��VBj	�B[׋ C[h��lG&�M?IA�P � *a��=Wo���*� n�����U���h�e'H�ؤ��+)|rݒ��}��%�o��V����S�� �Ov���PK�"+"f��?� D �v.�إ�y8�R8���mPsDs���X;�����}"�=�����m���䓕�qq|��p�)��$vK�:V���ڝCD��AĂ��i��;�s�����&G���*�S3�⵮�&T!��W�A�L"�����D 2.W�=� e��Ǽ 
�Ks8��	V�.�P �{C�5V8��c�o'y(,G��^�b)��S,�!��3��lEF�̺��ً�Jj�F�@LOB ��DXE����Yc�0��"��Q�|?�Wň���)L�&bf>E��ٝf�ޥ�Y�'��o-} kr�����[�_��7��>��/��g7��w��s�g�O�m����w
�=Q
���4�0�MDQ��E����u.�y�h(�I�[��_s5�E~���������D�W ����"���*"�"9�@&�� �i���hq�xAG�E/Fr����w;%��g�~�f���6hx�� p�)iq@���S�r�) p����Q
<V�  $��:�/9�3����d
 5?Zwe  > �~� M'gg�q���(�x�u�D Z8�4$��cDZqu+�H�fZ���c�WE(Ѩ2��/;yәƎy9�>/c+��yO� Ǒs�	<P�¡w!�ܴ
��\4�!��: �AšMNx>�f�(��G�" ��u�e4�X�IF9�p׭Q\���k�"GYM�C�P "@ܽ�	�zǡ6%�A��O倌Q"%"[j����op߻���T�+V��ݶ�§¢'}��C���A���DO�L�t�?�c�)��Sa.�}-�TD�� 8 ��6���Z=��Յ����J��4Pm�T��=�z���[*�
�`Z�,KF�Q]����� ?�a#8e��^��
����K���J�+8�������d�#GYA�p;|<S��e�O ڃ-�������d�"�fJP@�lh�ೕ��՗�T�)�݂
�7��*X �Y�0d8�X!_���(C�
.-<t_?ou�j��vO}|p����* BO�
�a�8:"]�W'�����/T���[WG����J�ȩ7	#�#�K���2�w4ӧ;e[� �ЉFdb��!���
�S`<a��4Ɉ]Uυ�՚��ԅ�!0� T?j��ب���?��iA2~��]�U��7>)�ą�@*���g���	9�E  �5��o�c�&X�B�P��.pѤ:LH���K�Cwދiz��5��{��|*QNdjx�F���4�����j��]���G�yw�Z����d-�,�a��<iL=<"_�P�e�q �l�`��D�A���ʵ$�2��T� �)��o%/GN�J����W���U�)jJWԩ|�I�
�B޺S��'mB�a��R��I�h����de�	�ә�=_����A5<Xy.T`� �yf-،��M8۝�Y=����R#$�iX#��0�/eXb���_��l�Վ<� d�$ �P-1b1ZP
C����K[�F�j ��)  �0C��#Ծ��s�H+�)�}/u
�8ţ�@���&��A�9/��,�)�!Uj��n���|�}�֏���VD��f���ԃ��Ss^v�!�D  M(��p��9a�r�i���/<#hh��(M�R�P0���h�.}1�T�����dK "�UZi�-B;��4<��Mm��[H�����xo*�ܩ�KHJ�.�4�M�!0 ��Z?�6�&'�[i��~S�G��~����pܯ�,��$ܲ!�11�p��u�����s����NK�)2Ћ}D���� b)iRw:��&uR+,��?��b�j�����c�n��W��Y�#g��t#��'S��$H	 �AN�
Rz96BGڙ�ڡ��J�K"T���nř��Lۥ?�φl��`��U���q
��p�ϺF���	�@��4y�;��_2G
��i��o`�>��4�����A�W�a0�'ŅǞEqS"�?�G��s� {��8Qay�T
B$�è,���/�-͸�5���$�H��	Xu�*�g���d_ �6YY�@@ �L=��,�cl$m@�-�� O�zo8Ė�(���\���1����>2k���zɪQ6�\R\�"��� @`p�����y��2����<����U���Ej��wg�� ��C��00.�21H&H )D\�����"���� 0z�j���n�Jɐp`1�Kh�Ӽ7�Y��k�o7�ш��KIN� 4����@#ƨ`Le_В)�I�uHU fk( %�����"�����0��h8�!r������Z,/b��� NA��Y]- K	�9g8@�tr�Nۖn��ӡGkʮc�*�Pa�8
��T|0q�@�<x>��A�覹�Χ���=%l���Sr����dw [y�228A��<S���d��P�ޅs<�
F
�@h��B.l�;3�;>�H�é�G��52��84(������2�x��F(7���CA�Pygk�B@M %�,����i��"P�(֥��xܰ�!şǻ}p^� rT"���x��D�����$΍�A�a?�#������x�P�V~)��F��e}o�YQ$�$�2l�Q�ʿSN�%On����ϲ:#�K:$Iz�������h����k�� �� e}Z�8�/8<:{>\�\6��RA�3��Z���v�f�s�;\٪��=
U���t��C<ۧ������r_ܢ��S����t��Gnz!��ᄄ�'lC)�}�5y�U�X���V���Y3�\���d��!Y��r6�k�"���?a�O��������RƆ�d-Ԓ8HA�ّ�Y��h�� ��|-Gy.-�P�i
g��2K����� pÕ�6GM2�H"%N�W���d�W&*��l������!5��X�k�� m7C�����#6���H�J^�`�MQ~w�P\�����G���ʐ ]B�k���$<�9V��  �\s��_�]]�M�φf
�U�9e�*�u����+8�Q>�F3�v�㙅J�����e�NG%J]v�?J~�i�U�I����Gw0�ߘT+\�F  
$���8�榐C�ռC����?\r�������AD�Tc�=�  @:�#Z�Bcl"[�K��iB��Z׮�1U�����d���$�i��:�|0)E�}_aL0�@Ň�t����:�p���'$"K�]�?���d��᳑�˂� �D�8}nU%뭆�*��h���;�Xh�8F�:>b?
k�d�rx����Ȭ߾� *t�G�������T,	�ˆTF  ��@��Y
Q�����㭭���0�Q�O��@�t���?���n��!�g�su��>Ecއ��c���	E��t���L�� �nEv܁��Lh �4{-����|����Tf_B_�1�>���QjUS�������X�55����(e�T�# �)@ �,e���`�uS:���[W���Cqq����6b��11R���/��wFrn�U|I5z�]�{)��\_J��T�l�D���-����d���&�CJ�4!k<#��[�$� �
-��t h����f`\b��3�{6�zdv�g�(�X�ű���eL却�p������-I � ���(  $*̘h�$�k�Ŵ���謀�п,�� �F����4�颊h�����7!�����0��
ձbu����]��?���ZzRӛ����,pH������QbWA���i<n^�-�7*��ϩc��U v��M�Ѥ9�NuNm����1��o��S�2�,C  sҤ��B�,	!�	[Y�M���o�-��.��c/��Nկ|�*g_��ϻ��[ֿ'��$��<���N��yf���w�_$���I'{�rDx�Js�4� ���M9�����\�G���a;,U������d؂�3VcB�7�	=�h�Y�=!��k ����@��?�ЁQp:M�n�R�y%���S��F�� ��%Y*B5�� �1ª�  � n�q�F���$Ɍ ,���E,��+;$
8(PP�C 	��B5Vd�(��M��V�f����/A�.�a m'䭻Lb, D5�Z����G�
�r�%"�.j��{+{P��b/c+����d����(kp�vE�s�LJ�����b?*��FQ�S_��]�����������T9�_�J'+a�/�Ǻ���?��,#T��3�v��ЬHD�Փ����(%ӭ���Py�jA�xӏ8㼊��_�yR��=�
��b4r�����c�Ͻd��82+-H�q�MF����d� c0T�a� C������aa�� 
���74�B�H1�
d�)-�k{�ਉ�1`+[�s4\��3+.��Wl��6m-�U�ksݓ����U�f�vs}B~�X�h�H�����Ty��[yw�PkJE�X��ㅏ�EGB1   ;��0t�-F�~L\�9T�H���5ʀ&	������<��n��Rk*��t´j��U:9s��B 4��6,ul�p$T����>Ex�\���]W ` I8(d��{O������-�u(�GdO\�ڒ�C����%8�1�oY6ʚE 	J�
,#Q�p�c)Lv0�E�r��KN�k\ͭ�U��[5l�pb�	��"�4
!�R�C4E�L7�[��{�����������w� Ic�NM���d|�(��=` 2@�-� ��qs�<��m��	HO�m�I)^��w��?����K�F�ب
n�	RƓ�������	��ZCu	Ia    *��`���"����W�����	�#�HɊ��Gs�~�I	�B��萤�'��?�q����`��d�^�<桂�u'}�M���kIp@  �\k�Ne?��*�'�S]<�8��Y�A9)DT�"M�)��QP�i�A��  ��x�jK�f��I�H�m�#��Q��K�����^�Nk�j��0�����v��?�[����y��`9��UQu$��н1�
��Z(Y��P�Xv0�`  ����i�Q�� 2W�z�����f=�m���
0��ǖ�R�۠X�ۆ,X���d��$��H`;`��1� �k�<�@�n4��oMj
*�@� �(����jFbVD�e��@��p����50c��r�c"���](���0� A�ʧ��X)�K��[�r�����
��r�������/�~�+<(�6B�T��=�ux("=o���K[���d�F�*i�%d�$A�Lx8��S
Y 
P��(����8�>�%���JB����,s�'ȑ�#4��ȭQ�]|��~K�E,��
��LP�V
���է�w?�Ϲ���_� _8wRs���o��8��!�e���BQ�e��w_����{K�X�EP�Mq��P^ s>�@���i�QD	    �H�F�ѺE(Ɋ��+�����G&%����d��1��1B8`�n<H��g�����0,��q_�:��'��!t��rNr]�\��'�I�.p�Dѹ���@禗�=/��	cŴ�
4 &$Q֍�	[�"�'�R�4f@2H �s��W�
�k��|J	_���;��gG�[?���Y3O4T��q2���^�0  .�+�b�S%��=
L��ŵ:�?36:3�E�B�
"B���眙�d�hH@F��P��=��w��j��7ɶ�V�8��0��t�D���+8��2��;h����� (�2?"�S��L�餠*��������(�i�0^�2��к��(�峝�'   Ԁ=tM�k-�=�l+z��:�u=�`�Wïs���
8�Q�I�OsH����d�`/�kHP6��0)7���aH=!@������s��|��P�dH�ܒ�O���#$�dIt�t���9WA��c�_A��ս�[Z����.P(T7�<����L��p�k<�+����������S�T�
\�B� .aG7�*��o��%�N�C�)(�����TU]y\��^M+�[or-�~'@CB��
z�N�T+���֨�������������Ȥe��r�Qìaq�����@���V�@0BXT�� ��2 ��l~T�27��+Y�墢�{�R�!Ϲa0
ȩ!   	�&���8R��@8��\�2	�Y�n�$�xnb�h�p6DK�J�9��8��|�4	E�u)#F�(�gY�u��"�j���dʂ�9WK	p3���1� ���a�0�������Fp�:u�����`P�
�`�y͕��]��� S��y�"�i�X�3?�{�UU�b�<��&��I�Z����R!��Q�\+�����d�����yܼ�L��jJ���R���}�a�����J�&�<[l2da"�	�Dqa)P��K�1f;J�P@�g/& MdT��uΖw/`Qq���c@s!�o/�+�#^ٶ
&����X��Ş  R$;��vG�!d���L l�-~���@	���R�_8xRp DL�B�ɤ���!z0d��MO�I7��׌�hzC���@��0�����+{�,:��Cs���=Z~�,��P� y���d�K2�Q�`5@��<��D�`�p�Ѝ+�� �n:��,.�|�~Xh ��QF2�B\�I0�b�"N(��������gޠ\��T�kA�Q�K*HXiZ�I�R�3|ޙ��=5�>/�Um2y&�ξ��,�D��Q|��-e�ׁ��z���ؓc�3�͑�☷�<�|{m5�s�V>�/�B;�{��%� 烼Pp[�˙���@��=Ch����L<����$XȌ��%�EA�Q�:󣴜UT�  t"�N�14�R�M�w��k�.�������\��PO���͢�-`��Բ�_���,�q2� �Ĉ��ͨ�dE��d�^����6�{�DB� �BR����x��	���%��3�
�8�$����d�d#ֻI`? ��1����Xl<ˀ��m�
���Z��5sr!G��L����sQ` � �Z�D싃�DH�}1Up��=.���4B�0?�0sk�P$T�G<ZP$�tN���2�6YT�&`u><ǒ��/�� ����O�%N�"ls��BțBN�<�@ 
�����dN��Jgb�J��  
o0����4W���2��>5�!��
IȊ��=H�H#�j�~t���[z���'t��
��EB�
Fi_�}��ݛ�n�8�X�  *X)`OQ#I�F��")��ƍhi6��R��9�H��寬��͖�ޝ�7��1o���xo�Q��K�D�:��r�K3H-85JNnPE�ȖsA0��Jʡ�z������D��&V��P[K=#f �_G�oA_*�t�(�k�Q�`#3��\|B&:id�	�x@ av��.uD�
��/�`D0�p�輻�H8����V�Eu����+N�1[pէ�ȧ�A�h���x;�@�8Jѱ�,ku�������#u
�e�;^/�����Pu��fO�w��� �����g
�^�jԪ�PJ=Y��G
������ǋ��uk4���I�&��h��-@����c�Q^(��[~�p�   k�.S��Ts��T� 6��5�����7��djrp��q�2h^>��@��:��J���Tb�~ĕ��]���h���M�C8!�VU$���~���3�� �֤* RF���D��$V�0pW��M=�
�ke����R�+�� ��Q$�� ��h��Gu�n��Na01�o���s\�(/�ۄ�IC����Z�xa�{1A\  ��)�Z4p�pOI�@�t_�ƷYS!��H<��s���V���r���Qϱ^-u3)�e��<�IJ����I��t��`M��iP�nsOӢ���'[(�N�(��� �0���i�:�f	��G�6g{o̶��Y��y�)=<a��&��JFݨ[b�n���M  n/�i��� ��dD�y^�z�Z��5�|��ǭ�i�_4�8��Q�8��R�����ա_M�Dcz�k� X��Ų��<�}�Xa�m�"���G>M?��G�]NW�ӿ����1d�r���d� L^ֻ	R@;*0�
�o`瘱����
&�r ,��5�G�������?��ZZ���+��A�"B$�`��&�h�3�up����Q
H ��qt|#���B�wjB���JKق�L�Jm���N��s�P�h�)E�fe:w��,�Cic�H�]��*خ��I0��@�2P"Wf�Pl6�at� ؟��t5�RY�
��CĀ�����>`�!/GzY�X�9��4ٕ�	`�D��K��L�sQ��afV<���X"�N�\L9M�Bi\���k�)�\�U�<��دj�&�:�d�t�,�8�y��/yʯx�J�6Ճ_8s���J�m�d�kJ���������t���1P@R4|KF )T"	���d�c�_�;P?ڰ=#�q`g���'.,$������♑a)YBQ�بY���*t�M���؃��    X�p��`�AKH*f�0�B�P�ɥP4�[���J�J�(�r'54�O,C��?��O�y���~�����.�ɐHӑr��@��rO�E<K�e����h?ƥ�� J�E����$�
��d�U��*�;��-�M�-��fbP��T^�����Z�O��-��Ս�\nv��>!�<�Gvj�/�%��$�W#�}+���乒]�ex�r��H��� ��ܴD��$X6�`�5�;gj��ňF(1�@���+(�,�g��Of�Ui��vT��ƍ�����y��7��=$�'9n�F����d���]��	epT�{  F~)!g���ml���V����.������d [ɹK
&�]0�e~���1��P�}�MkBW5E�*9+�4T��@(��#�ƮHyz% ��+E�	��X�8rBT�P��:��w��rY���j�M���5r[��.����~���B��S��F���M�����������.'���v�5N� b(` ��8� ��)(���E��p)`E���⃉�J��\7��2pC9P�! 
.fE[lu���^�B�V�8K�8�qu�-�m@q�$~�[4�T�*D�T:���<��R�zG!����B�޹���1_�R=$̥d�H�/�������i���Y�)�#��_����?�����d�3G�A�p5@�# 
x�cl$m@������ ��	�6��>b $� W��3mb� ��Zx7C7��K.YF!M$p����(�P)?܏��c�@��M4�=/܇�SO�w!K�?r(RM
4i�18��c�G���W�g�}�k;>����(H	kH*@Xy�$~UR��QY~�T)h����S�b;=[����������*�`\L�	޲,_r�����R�p��(�3��#͉�g��Ym�]���e����G���zB^�h�z/M�H�B��rI�.�Y<ϻ\Ē@��9�|�p)�
����謂`0� D��έ��T��'M���7�'R�f�
0Y/jF�Ud�(M�ʗ��[��� ��/y!�^�  0)d�����d�EC��	,p=���$SH�X�=)�l�Ĉ��U��DS����"��S#ˍ�*%Fg�peG���E>o8^%�S�tI�F�B���	�/��@������@��VD@��0����o[��sQ� 0 Y�^0|E��BQGyI����G�:��Z�A쭌SMb�D��D;R�U�m��^��M󎭓@1�f	�Ň��i ��hT��x��"|]�S��TRm��E�覛+��
�����?�w��k��s���J�����&�����+����������?�C��!�H�u;=���vw�h����@�m�M��o[DN������]�_D�ݫ��rڷ�.�i�ƄDHa!������2.kXaS �H��/����d��@0֓J�>d��=��-TL<���,d�
8�Q�6���������yyQ�.�����9m�^��B��P�ʣE6[�n�R3/cY��ܢ�?���9|��׍�睹�桏w�QG��16 �Hv(�t�%+4��
Uߠ��H�{"Q�}'r�"��s��G�Ҝ�֟�J��(u����:�Q�]X�   � HL�x,Q�,!�fD�U 覍j�;A��P�0Q�VH�s�T�!aJTv:򭷲P��ǂ�.ze����l�5�Q6wJ�7���-q��wZ��C�}�B�N\I���N��_k���bQH���d��h��ɼ'�ԧr�w�:Y]$�9e4ZԳ�K��_�{-}&xw�50��;�����x~|�����d��7V�a  @��� �gN�� Q+k�0��������Y���a jBR b �r���Q��6���/���1c�kV�!h4C���i�YBpC�_��m�)�EU*Z�
�;���8�a�|�e�@q���Z9N���oY�ֽ���[�(���=V����3N�9��Ҕ���-w^���lv�9��~j�F0P��⥴��-��5J�	1 Q]aS@8hn���1��"i��ۯ�UU�PQ�B�zGZR60�r���d�G9��c
��g*��n~�n$��g�����l�C�D���Z�7�U��O�Wq�P�Oa��ͺ$��H����Қ�؋is��Lޔ��"=�l9���{�r����{ޔ����ra��g��r�#'��g{���d]��]��a���{_�, ��g�	��w� �Z:����Ȃ�1'vQ 
P#�G=ǥ]�urP����v_�e���P��-5L�4���=c� �ު(�ѱzf*�֭D�uյ)���С���:��?yӎ|�Z9j3�j�^�
n9}���{rE����c��fhr����$��74>�������� ���Q�� � 4sA�H!����f�m��pҡ��d+�����jF;���c~4f7ES���jԗ7��G��}¿�����A���H��M����q%����l0��@,�O'\3���?����}��������zۖG��ʓu�f�57�fO����_v���<�dS�¦*q��
R P�'(��)h>٤�:<�����d .N�a�p>��o<�(
1_g��H�-8Č�
�Zl=�_e
�[���d�֚E[��e����{(�L�z�fgGI����I����\�v���Z+ �(H@�R,�	
ʨ�	-����\��@�E�S��i�'B#U��z.	�T=�S�1�D�âZh��W��-=}䇉{z���J(� �w��am�x*T�Y��X"?GG�ro�v
�)H���Z9��v[�
�83
x:ehDQ�"���x�E�<NVA��VB��n��G0ÃT?=�mkpm?�m�T#("$@QI�Sk�������5,w�3cSk�B�Y%��L��!u�T~��qD�
�\4�^�*h,� 9qT�|��P��J	���u�K-�'R�������d �0W�� >![N<)@�e��Q ��e���l��;��#�-s��Ss'F#�������<�"�ls�<˪�XP�@,�*^]$ M%#:i���T,�/��/a��ɷ$��$tчvqb�EUV���
��PюM�+;W6&�V$���X�:z!�4�i�Ɨ5 L>�S���."�vk6�J��1��>ڬ��oNA��nη�*vV�HUI�T]�����)	
��Z��AF���M �j�Q � xq��I�ΧEZ��P��߳w�E��N���X#uNW����*
���  266�-���C
��!w@6�@�Jdh9#�&�J��޶������R�j_qaE?ۡY� �PY��{9R�P|!�$q��\���d( �-Y��p7!�<0@D�]� p���<��P,�ֆB����Ue}6F'P�/�5h`.b������N�̯o��h[��K
PT�sM,w`TU�l�U2��@  ���HVEW���N2~����� ������v�'g��@DWRp�ўH1�9H	O���^��fd����t������\��+2� A��U�q
�*�u�k
F}*�����>�P+V��Ї}�����.���ŏ0�  �.4
@�"ʚ���I��	���ܛ4�`�N0m�MZ;�ݪSa��r`���9#\��I����&���y�Bx�T�A�Ie�i'X�ҿ���@���,6��-����c�F�`�Wբ�@����z���dB��+U�L 6b�%H,|�Y�S@�����L��#����#�'�р �BU�X�D�EȋbQ%h�qbYq�u���^��J
����ӊ�O��&o��Y���ֲ� ��+S�$�r�h;U;��چb=�uc;n۪�
YU�XEG9o}zB.漴��V��7�`����&ץ�{��/J"�8�� �>�H�  � ��$�|�Jh��+ к~�p��"��(�e�R�=N�m���ŋo��j��I�E�C��Wq�kn
��
(>F8�w��f������ �
4g(v3�,������(��P�X�c�4#�\5M�cv�j&@�T&� SL�C�\p�
�I ���b�\��d���TG����d\��.Va�L ;���%�!���c$����0�!A��/	� �fvH �XV�O.	�@$`��k�
	q4ϰ��3�N
͸��-�viذ�<s���\
Ҿx���FQ��x}8�^���M����/�U�(9��[�a{���������U�����ЕI� 3`��c�@Bb\�.�sQ��,åe
DJRz���:�ƠtV�F&|;2�6h��4�6\��)ı6
��'ԍL�5V`p0ѧ#&U_������Q���,�I���
���(M�U+�̴R���s�!GYh�8�5�(���_�y�^�2�� ��cGJ�O���6΢��"d�� �i�����B��F�1v�;�la�9V�"ZO
��K���3"�q���do"�<\���:�`#8Kd�m��k���<� Tb\���<j��Z�	�P�j��2��ưd$8z���Y<@Ti��=���_=$���x<R`���&�8�$J4�	gҲ�K�v�    ��@�-j5ĉ6_Wf)S��F.�y����w�c7+D��ѹ�p�?��D봗�Rs�=�HT*.Dh6���Ha�5���,�a�lPEQ��  d�R�3���:*	���W�s+����"�҇/��a�{1bc��.0��.a��H  &[BGNg�JcN�\���X4X�DI9�-�n�>�!��PNntH�E�Of>�09�;���q&�=n~9���
tM����|k�=h4���)�@�.jD�B�@! CZ�,��z�@�����d��(��0p=`��)� l�m�$i@��|!��jk��Z��,mkds
:��5
5 �,HP��4EU�Y$ m�5��~Wl�ڲUxb/�#�ŋ8�%,���9�2�V^����Qz]�p�21B}�����_w��MY{�7��4'6��$�[�;A� �g��,��|�`��_�5^��4�J�Ά�@���`y
*�d��ƂkQ̣+�!��H  	t����5�-��r�����4^3��X�����H��T��[
.�8b�����0�>�Jy$��*		���D
0<��TJ��l`X�?���W#� �QL
�P��(i2b�E�qvwz��"v�a��� ���c̖�
<D��{1	�/z��4�  ���d� "�"�kR:��4<�T��i��t@�-p�0J5\�^He���渠G��3�
L�8A�NC�Y��I�ރC�[�Ɏ���ѡ');��U�I������ *ʗ���s�'H �Q\S +�d*�1_��&��?gJɩ���5�<�.aB2��h!K̗l`�j��cH"�aD�@ ���k0�S��
�����16VASJ���(��f"�Gb=�Lv|J����P�@����!��:q�jP��2��G���o��KOX�&�3v��a��aw+��6�i׃��V xn��������CD��\�L�D4�<�#�0!   	Ά��,I��%:�>p{684��J�U7/�G$ژ�u+�dxT ���d��2�(�k@@�{=�2�ig��l@捬�(VG,"���!`�@<>�����N U2F)��CC�.c���b�G�9DRLC�11ddx�DXß����*F,.5�� %
�?�>���E� �`�2a1�Ƴ�N�������)%�@]4D��	h��W,)��� +���Zu����Tr��Z#Ԕ���Y�<kZ��H
��G�]n�ݑ�x�Pa2R��C��(��0���΁����_�BUg�K�X��@�����䶔WU�X  
�6����4 ���K�R�ǵ�
L6����,��q�СfDپ�����˃�7�# ������Y�,�"O@  'pسx���``?���a�y�N���d��Yi�205�ˎ1�T�_,q@����$�b�G��
)��	}�(�-<,
���8���
�A��҆OajN�(N%*��f>�T��ȘL�1�dM��m�����QȢ�$Ii�Q������5$��7g�
��Ib2Jқ56�n��ڧ���/|~j�ic'3G�'&�����K%����B[W�Gf��o��k?�{�;�M���ll�� �*q�}G2�*"|�&�(�NB��n*�߁��X!���*'.A��\Z����Zt�Ł k>.���yW�S?Q��4A�a`8?A��}�   3dL�A�~�+����Uax������,�Y�L�X������
O8=[�������������L�nvN����~�SZ�o��A���/n�U����D�^#�a�@M-=��sdg��	d
���
�'�r�*�Ftt�� oe�CC$6��s?���ٖ�gR����mAS��R�d��rcq(�jx.��9Ń�\�˶V�$  
,�P
 �'�� h��,³� �ǔ�+�4İ\;r���s�S���
��K��T��2P���ػ��]uJ��eVe@��Um�F RplF�T��ŏ+* �9�X	+���p�}�et�.�n3v$�ҰTN|����@G�.Uuׇ   ��$��ph x��~6�)#;��i��%�$��RN��}���E O������)�蜘x@��5��+���j
&��z�ޱ��������Br�����85@������}]jH�@��   1���dڀ)O[��6@@�Ki<�
܉m�����04��dЄt��Y��6jx��^Aў��Ѽ�`��7�Pf:��?@�Y}{J�&T BWn��*��%��   т2�#��@�CvmL|���y_M""
�_B�)�7�B
��i����s�SF�'�_�`"�|�q�ߩm�?��Ҷ��Zu�
"V�a+��]=�����!  �.�(�\2�����0H����O�_����Rk�t��L����&_+
m&.�]�[�U�   �
�XԘ�`��X��/Y��hxN��2%$J�ā�g��WO$��7��:ܑ��.F��T��&��ѧ��62�F�nZXԻ~���mys����~O�7����L=�u�I��R(I����d��9���]�BN`�F��e��qA�m���P)����$� ^�@�>�e�b�)k��'��M���/)�Tb
�.��1d�w���
�`���4�\�܃� 
 �X�	��?B�J�4e,
� �RgH�M�>kV��s�oOF@E�<����RD�b�D�94���F��I��/���֥P��{��������'��+�~���렗9 )@,�Д�+`G�x`\Q��	��M����j���&D���6�D%��$*F�*�  �W���@�8 ���Vp�"�S����+��j�ۑf6M4K��<��HP�4�$��yyy}�
C���B�!�=��g�y}�^�8�������M|�5:v��jkv�۾�������d��<V�J�A@�]1� 
4�]��U@�-tf(e,��L-F���
3uK��`;   X
�pT��?Z�z(J�w�7#�x�q�sRUQt��Zt��C+#�ԄF1�����F_L	uv���
5��x� �[  e���I�ƕ���o�j�����"�g
�y���BP��ބ���9$��$,%�9 ��r�U٧r\j���}��n#�
UV�D��4��CC�J���� ���(X�V���7I^�ӻ���9UއM��o���#~�r�!l���	�#lW�.��`�B�/��W   �����L  k�
FΗ���f�p�F<2��J �Nc$[呺9��N1�`�%�rP�%	BPsq��S"����d�d@A�C/pNh;
%�
u]G���,(��ln�\��K2+"���Z�%�������sqq)5!D�#�Cn��������\0�@�B.A�Iȟ/-��quo,�Gf��M4&&X�F����ٰC�˸1F���ڂ�]����(��@ A  � *�rF(b|�0G6���́� ��x��dc���8�0���^)C0��U��懟�D&��:��SFz�1����m'�ݥ]̓9�GJ�r����>�{��y�!��@����|���%��D��\8ٙ�aP�~�>�w�����֕�0�v������Q�n�ϦH�yO���טl/~�|+߬E�<h�Ws;U�$%UV@�d!H��]�*�YMM��-�E
�`����dҀ�-��b ?`�M�� s]���
�.m?2��HCn�	����ʊRbA,J,0�T;6b%�V�$3��٪��h��%���n�R���&�N�p�r�N�(ʯ�����i�w�1���P�[��|5��~�i_&����{�L��P�"����4�tiE] d �r����jtb�8�7\L��ꨇ�X���]��)���Ч�S�׽��a�l�9�O����-�S�l(a�l�FY��H�LI&֪��� �xډ�@ �Bhq2+HJ�<��]��U`L(�A`@C�5��Uyc�fΟ�3��a��1}-�xEJ�R���i���J�Ƶ��]�	Oܽ)�}����=����wU
�1K�d��*����lT�������Dn#	(��=  \Ǜ�� K,�g'�O�x�l�!W2�t��ߖ��� @X�#���RZ��P(< 	��z���
_��#���PZ[c8
&XO="#RD�x��r�0�`�e~��\��WZ�ئ�֧!����
6h8!����B�
N[�wy'�n���LO��~����y�w	+@^�o5�~'E�p�

B��R��qS&A��}�?�n�\1��.��4���H�B�0����Fo��� �X��Cq��"7�ғ�8@@ $Xs�^|�
�E\�"����
�hp�`���:y��Ɲ��<x(��pc�Y5�N�Տ��3�rJA�$��<.�	���Jp�J��v���� �B���@��%���Da����0[��l<b|0�g��lAwm���B��$��A� d���!}�k�W#`WW��cR���P̡�ҡJ孁7� ��`�+"�k &+bǣ&H�H��egg;*d@8�,V�J�
�H���x7%�N:�i�_�� RF�����!� 0@ j�LOgZ��3a*/<�!jW��G���!�&?
��w��w� ��
u�Eʶ+d.fx	��X���ۤ��'�C��w=Ν>|�Mɼ<���0�C��(���������`����	��Ua�6%���� ��d��8
F�ա�����c��R�3J�O���r�E��m	 �`f�O�  T�;
PZ�q�$�5e����dZ+JX+	�;�ۍ=f�?cg�M�Ԉ������2��4�g��;)|�˨@�"X�)�H��`�� �F����� g��"�t_K��^��1�9]��ܠ�&ak��-�F� �+:��hں�"M/�DB�0I��Jӳ��������C�@`��C5�3 @ �3U4�U��<�X� �U�V�
�Bæ�a�I�|FB"�!�H.
�iq�SJ
`R�����ˮ����Y��{���$�f�  ������Zb�ڟ�ꮲ�Pl$�~f/�҈L�����
����0 p]KNs*�j\ExN��r~���.Z5��Q����48p�\\Z��}6�����
�o�#�N�W���&&���3.�����di��[y� 0��l$) D�c�������p�!�k��E�����·4 Yyc� hCy�oMƐXg��ku��C����_�J(�ZWJ0��	vI�-��I� (7�	�M��\hhW���<c�D>�T������f��M��r�M�t*I���g��9�
X	VI)�)
��J#�������ɷ~84��g��h��UU�h�
R*F2Y��fV�C� G��h�����_�k��S�@Q�6�Λ�{z@H�  IsT�Ec	D�cZ;11[�kI�Y�a�O
=E�*�Y��őج�n\�zAh�����W%�c��^�[w���h=D�[��
"�t�
UVxwfW# ��>M��� �[`��W�=�IW�$E��������d���&Z��29���1&yc��� ʄq|�V�����1����dh@ F��h�E@�pGV���Q�i �]�4B�!�䯷�8�s
|ڌ���h�* ��@>��ŝ�������	��&
�
C�L}�H?ltɥ�Ǔ�@` *(
���`�$Tp&8D�;?���P�2|,(]�)@�LE>QJ�td�F�Y��!3;J|�ʇ�"������MKn���E��Ka��}�KW{�kr$Kɨj�W�J��ݖ�m��T�ɦ �x�%�1T}\�d�'�K��lw���f�EZ9�r{o[�;�	Oܿ�����=�)$y �8̅�;��y�er�*fG�h a R�JKx�N�;/�"9*�)��鎀�����D��,-Za��J�ۼ0�1	�}k�&	K��0�
.����D&�685�d����~�����~�]iwO~��t�A����jII)  ��#`�NX$���1�'�A���Pq�	"� ��
�MHp�q��;����:�Kؠ1�z).���$,0v�љ׆����Iʔ$�^��5ij�����a�,c�S�-����UFWdBI*`,�M���˰mg���D:,@�p�g�px�t�Q��V��Lqg��+���H�L�����Q Вv�e��( `	(�'��@&ae����ȕ"66���۽��@9&�9���r��9���ڂ�+>���{T������F4 2C���� �������D��`[��0�F�%& �i'�i�//|��pOo���ŋc�g݋�y��_Vߒ�C���3�A�ϩƀ;��"�xM��	��z� �@  0|?��7��/�5�e���vm��i��M��ϲ���l#"=[��f������3{����׬L��f6�Cw.>��������Q�CK �̆�Z���4б��ݬ+�%涛��&�ԐF�K}�r�D�l'�:ȟ^_��m�M����9@�()�e������o� $   ͇J�b���yv=&���Ғ3�j���Y<�םK<�F���2<TtТLB$LY�pDY�D�Aӻᵅ匉��s%��tv8L�d����6-ލOnG�a���Y��Q"����Dހ"lZ�
2J�+k=�
��c��k	^������¶1cݮr��4�} �������1���[�m�ʨ�����*��\5O����̒A���H@pʧE��Hϳ��۳nA=!�u�N"��G�����|C����Ps�:t�9�'s���9�M��AТHH�@�7�"I @ 7���_M赊���,b� pH�.C��5)s�/,��"��@`SKA!a�9s�S:h��TL6�L�JK������x:�"B �   ���/�I�[�
0^�
��i�f!�ܘ�H!B�\>�.M0QIɤ��M$	���oM�Уt���Mz}$�?�cy8A�_����( :� @ �i��"Rku
]����d�Z/�Q�6E%�==c#���Y$Q��-0��;����(�HM�#G��v�JF$,EǇ|%��$���vޞ 
�����P 2  ߃���cgNX-�.敋�������N������<|�s�玝��W�8xTt�>(8u���B�'w��H�$i���?��L
.h��S�J�b���{w���@hЌ�R ����.H&`�T����D�<X0��L"Ż�\
��)�U(dx�b���5&��d>!,TL�'.�.�	U$�D� :���d`4�8�	8�m'��s�3��"��ή É����D*��γK��ʏ��Kb(���
AʄX���,	.#��L
y��<.�k�Y1�%��m��F��ǂ�7��/���d�//VKJ�Dk`"^
@�Y��!A!,�ǈ�s�W��8�#��T0�DEoV+��T����-�������f�=�2^�`���ʒ &+�   @ 2D�(���Pf�H
- T��T���jQ�BफEebZ�p�k
bN�� 2���}`�M���!N�TrT���J�M���Q�e*�$���#�%kO#Ƅ�zc2��i���q���Յ{t�H�4v'�]���8�5��@1ͻO��*�d�\�{�/�1���6UZEfS���%W/����_�}�s���LW�����9L���O�����.*�@@ ,��m��u8��'q��RA��R�U��j��3W�2� �{fiU'��){�
���w��|
��1�<�z���n�[����d�'��=  D���� ��u]�� 
�.��0�����)�1Y���cF���h*L�����b�o&����4:�&u����#��i��/\B�d�i��$����W�
(�j�J�<�l�f&�   �>Ģ�\�6̝)���	@�ey�2����ݏdu�M-xhfygC��<m�yǺ��)$J�?�a��
�J�|�;qך�n=R�F���a�b�6�D@ b���U*l��?Wf�0լ`*�j`����i�B*b����,$Qq���
�Kّ � *w��Q6�B��T�NS�����1����������˵^���z����piwX�}�<�I�3*��I�������w;�]��\��@A@�6IW������d� #$�o<�5�[�� �Su��nH�m���y���`�����/��R����n��4D1�p�;��=�r	,;F���Ws�  ���Š	�Z��8]D��؅ah2)K��0�Cª@�O����M�gË
�����Ð��(�>��ǌ�w=M]��t��VKSg�
x�Q)eg���O�����0��wυm�M8��f�,�����7<�
�@@K2I$i��   �@�WV,��%��$ZvZP�I�P^�ے�fcX)@YI���9!#����zD�/朞g��fǟ�8�0�&U�9h,���Z�H���?�,��Z�mpY� �B�4�8Ĝ������/�Ze� �a�2�ڸ,<���d� �%\i��;a\}<#%�h�iL1)��n�a 0Q
��U�ZuU��(  Lx��A\�;�'����L	p<��*�N<m�]ԟ��Ȼ��f�{��"���Co� *h��k"��pA����{t���w������w⪹�  �I'D9�)�	�i�>s��X��� :����*�5��κD�XV,��-I��Qۤ#   r)��\8��Y+��lCP�����#20� %zNrO@&���N��Ş&��F����Һ a
�:�Q[V`���J�� �!L�$�Ò�����ؘ�C�A  �q-F��� ��%h�d9�MS\QJ}ʁW�"����- ��!�b%D�   �.�̱�w�6#��Q	�u[s���d�!��0R<`��<����g�$� �-��H3����qyf^h�M,�f��X4ʄH#�Y�l��k�6a 
�yޒ'ɸ[OA��T��SK2�(��2�)��Q-�E-ə  8���b��QR��¤k{�>�\��h���Q�V����<}V��!OZ��Ӎ_"�$m2�  [�,z���:�0���$z����%6�6�#�����r��+t��x��
� �rJ�Rl����ֵ�g��V��C����P, 	�15�O����J�I�e  g;*d~�g��$
,��T�:�*/߶LT��B��h��9CU,�Ae!l  �!Rn!ŝ���z9�b������"a��S1m�%LX��a!B�a@
�ff�����d��3����;A+\0&��g����ׄm���	͑���04H.c�^� J��!V�+U�h	   ��ϖ"v�{
��_=���`���ƹ(�X�1��)CN��_���Gw�v�X�b�p�V"���0���Qj�\G��<D�,�Yq~�B_wzhcS��"7Cg �0}o�ϿK����gܼ�2Ǵ������u�FJ�`�c�O��/X�_��Zp�C勏�l-������`�*+8E�r�!��q�K ܶ�i�@Lر�'��&E���K!�"�{+��Mq�D4��
����ќ%\^/-6qת�����wK]U]���Ǉ�O�J�)a���3²�z�S�0*F �[���@�ʌF�X  ���d�"�(Y��7�{<%N�T�e���@⃱�� �9|��S��~�|�
8��������R������{_,p}G����ʀ  ��6�!�ؤ��
\d�O��`A�:f���
���o
DΩG���� ��;�	X@C�f���wo�<^r�%�SD�?v�:��������e����C}����b]��v� $�5��y`�&Kj��9�]qm��������?����Wc����I&(�,~����o7-��$�  .��3)���Z	L���s��ΥxQB`J"x�e���R>�K�>���'�Fu����Ãje���D��k�,�z�wؒ3�"��}�,��X(� �y�#��љjYA�@   2����d� #H.Y��;a��<#SUmiG�mX馮4�
�+���:������ֻ����W����*uD� B3:�qgo]�C��T�;08ǂ��>���q�  ��Ƃ$����2��/�d�0�AB�gz�1S�F���>@��I#�:i<U���es��h�]�*QZӹ�F0Ĥ�	G��0�/ �jd��%W�Z��� �ar��RQv"X������.x���Q������A9g���b@  �>/?	�8�Z�DK{�e Ɛ    ���/���>��D��qP���m2B�A
pE

>����b4)�zHŸ�4nF���~�����'����$Y���0�̬-�ߙ��JAf���t0��4g�H��ki&��m�"Ⱥ	�����d��6ٹ��@�\,�L��k��m���10��N^�: 7������j�w�X�"��yY�mCF��JjJ�$Q!W��rE ��@�]dRZ�TKQ D�qB���3贩��nv��~�/[]9_�s�� �"� �ph��1�)��
�ƥ:����Ms���>$l�43����:x��Jgk���ѷ�[�z�Y�Q�0   `8 ����uD&���o���v�!��,֒�^��+hxX/�]gm�B7�C�3��$�]P   �<~1�QlO����\�ؾ(�t0�6�h�v�~U"��b�t���T+>)>(�'�"'���_�4�x_�w9��Mn���I4��?�$���I7=$�s�� `��=d]_��N  �r�l�����d��4Y��D`F%-<��<�i����m������j��8���`�C��>!���ʔ�Nǲq2s�-�b��iA����D �O�Ө��@ b����Xa���ˋ(�P3��'�5�Z�ڕ�S��S٤�ďݼ8'��������8���M�M�h�!O��r\M��$����P�m��$�-d�g��Z>���X��&'�A�1�����1�g���~�/�>�0�9�-+y���i��H�X�]Qa�	���4  `Z��ٚ\�=�R/p���y��u�QQ��B�����$��,�> �p}�MI�Q�H�g�I9��<������;�%��<�4 ��U�ԑ�9Q��r�苧��F���  bx� `���d�#�C�I�`B	J�0G^
@�aL=+���, � ���y��ԅ�գ�m�?~������_���m��{\Ia0ӝ�YD�a�x��z+|�n!��  �#$ZB4�7OUq~.KÛ�$���+CD��6kf+��+���r\Q|W�V�yЫj�V6���}�!jݿ�^ԍZ�gu��˹�һ�.˖���j��H�&��\ ��c�T��_#`�����ԏ����:� u��Q0ǆA�N��8�QU���ڶR|���+D�Q   ��J����Ì}�`�sE:��˪��\.5Ў!��#NvsQ,���m���oT�}�}��)�t�5V+��l�-��+��O�[��c\�T3p:�1�"�ˆ��נ�Y�  |���d�~C�3	pA&=�
�]G�S�m���@[M뷿:�T9<"�(��	��C�E�
��^.sEfQ����aa�e`��3зl�~�4!�T       �T(ۋ�r��Gat&��"a�=Nz��B����@/2���	��M�ҵiV��&��|"(�$����,��,M���@�_vy-��Á�*�
�`�a�O��K��!�^C�9�I��9�i��cE	B���G��^������Z��J�y�>��� jV��c"y$S��j����U>�<����?㷰�\��ѩs��ږ�ǎ"R�h�  $ @   b�a+����PL�8�RW� �K�XZI����Z�����[+֛���ڜőGf�֥{���d� q<�}=  B ��� sW���.k0� 6b7)?C0z6�4�[�M+����g��i����\]����oG�)$����i�Wn
���p����5xsHc?y!����驞?4�MGW��8��S;>G�R
<�}��hA嵴��Q��
7O���� (_�d��"�$ٺ_O�p~���['ж��k���+�O��ǌ|��>J��.�0��-ߒ�6��y��|��&���'T`&�[g	�A��bj� ��=�`��2Ĩ�u�+͓�|���
�M�����i�TU'����BA�	����B<L�*Z�)�D�������9�N%2xz^�B��(�QR��!꫐��/���P��H��n���gfր���)���dr ([�<�6����� mw�������O�������)rU��ͺ���*F"*j � �l��%;�@���ź�C@�0���4���Bf�C #E�T�aT�f0J
.�51��  �A�#��$ɝ����B���/�j��餅§��6��E��$��{�$=$�oI?��x���7�9}4�F�?���20 �"�G�LƧh"æ�A ��T���T[S�˃�
 �(#`�^W�������
�����ªh����H*��< ~��H�$�
)$��� �  U*�_7f<��6e�!��>���6�"������E�4B߻�@�P#M������D'I'���'~�]���>�4I!ܞQ�
���d�u1X��K�?�L�0A�\�a�1'�
����@z��������kh�Gvp GӘ��rСz�`��@W�����IM�d�˲	���
&/����V��j۝R]��5�  ��=BO��#�|��|A�tA�|�G>����2 /�H�ץ�N��?���s�ρG����A�q�P��K�|�N\�ئ_+,7ƥ��D��M�礥��ӐG�~�mh�9@�1`2h�$��U��z�;�ޗ�r��A��ġ��ASR/皘hT����k_��J�)�Q e���@ı�b��:����Q��R���H�*-��4�~�I>@����4��~�q?M�I'�#z$}����ăA8(�x%D(��O|����&�p���d��MCV��<P=a,=)�P�]��U@ㄯ�f����*n$AR�:��_�O�O-@}������Ww��֍`�C)hЋ+��pqR5&�	   B_�����8C�[ͷ�Eީ��~��һ�Ϧ>^�z�~��7g9�I����}�y�_䗴��R>���� Mw@�79�p�b�W+7kд]P��Nx�0�g[��h[�뗬�TPI �V�Հ����}��þ
�-�x��:g�	�A�6�C�ԨI�X�#P ����   �.%��FCFd�=<���mxt?CI�C�#����g��}^֮h�f��L�G�>|�};��jWwJ�}۩�o&^{*����!T��ME_[]EYP����/���ꛛf�g����d� �AVa�/�F`�1�U��~A ����Pώ�z^�$��'ΡBG�'�u�]A��W�

�	c��0,�����#��D9 0�GF������i(����Y��m�#,�n�U��I �  �j����Y*��As.��*
lf�p[ح@����7��v�X>��>		�(�s���H4�����O%���^c\�x"$B�����1�<��q�xH�'��D 
D�:�l6ع��Ľ�� f������i��~o"���2��h�(��N%L҃]�;qx�M5 T��"^p!ɐx(Y�e9vW���n���'(U��{��JiI,�����ӞM �G�ÿ����or>��@�ŋ����rG���J�q7X�}�S+v���d��J8�kDP=e�=�2@�[�� �m>�  4�ɺ��@ �\̡�Ȅ,�=Oi��!`,~9i!u�����x��F`�`u�����ܱ��ju2V9PU �2�Bm��L��daJ�8(���!��bs��J���z�h+.V�Φ`U��,�����i��qH�N���b�п�(��@e����9O;�O�1*Ɗ��_(�+������W���z���Ql�̿[�,�^��$��R�frZK����c�y��$53�I?Ib��{�qꝱ��|�ϼ�����*����X��������d�gs�JS�;�X
P�h�P�Lp�!���,��q ]?&��Rf���#���������v+�
��:C��]ƽw����K#�g�����d���^Y~c  ��oǼ MX�i���ҁo�  �;R2H���g�����Ȭ�������'~�H�߁>��������
�����_ݵW�5;�o'�%~��[��)��'w<|D��P�U"����9��7P   4lBs$3LnMa�Xd��$�Ykr���P� ���R-�2}�jY�9�O;ޛ��E�O~dS����Y���s�u�zr����'ߙ|Q\�� !)4Sk�	k)�߯���T  ��L�N3�0�A��EC�>d�ê]�L�x<�]��$Tʚr"6�RS�� J }�1%�XF��n�G�MX�@�Sh�>�zo�M�$��0������ u�Թ�O��L��J:��=�_��/��wD�.�mU���ނB�����d0 "[��R6`K� b �
i'���.�� 2� � ��Cרw�������G��Z >�
�/��捥����(|�EC�`������  sw����/
��!��a�x�X|Ѭ��zP�iuQR����!��^6��9�Tc��8lT'(_�-�Gs+[	���(���;�bCd����!m�x��F�B#㻐������:$~�M,�j6/�`��V��B q�T�ei:���YG/։��x�A)�f��i�^�-�xC�JG-_
�ƧO�2.^�qJ�A%;MRtz��Z�Q��b���HT�����h�b�7ȅ��������G[��â��2��z�H   X�J>���������[T��uiq-��Vj���dC !�i�A�2�+i0" ))i����ᡭ0��X�
�$9�J���nh  q"0KG�-0��x�%Ӑ�>����~�<���1R�(/����'i"[�=�]��X�*>�O�6#�-Lt�:Jn��}?(��UdAZ�wQ�	E���  P�1��9n��I��G����1;�{{񃿧GjZ�D�����*~�f� "i����1@���Ŕص$0�W��{f:<��[�b�MbjZ5�ܻ?.f�e��M8|�{��Ξ=玜�����ۊ��I�� p��hMI�!VL�����ѽ�M�ˡ������������/ܻ�צw����	7 X�@ �L��D�%���&)�i�-G�/���i,���dY��6XCi`9IK�0H�$�e��
��n<�	@���,��z��Ѷl���O�s;��1��޵0d���<�F��V��mnn��`P;h�[�"�[�B�°Z��������D� ��������������3�#hw�gE����e�*�� ��  D�!���.	�#3�����n��?���\��%�x��#����(\�7��I78<�
�
�vb�z������2X�&���@�I�ހ�i��
0������������F��ow�{�1M\�D�SUP~����,5�ꟁ�Ż6e��� �_D�����5A��_V��O�ȓM��a��A�[�����c��S��6�z�fqw�[Ͻ�s�_�<^�o��o���"Hu���du�"�0V��L09�{0 t�a��� �lz�  ����0h ��c����G�7�����q�vȣν�
�(*uBP��)�Ԑ�� 
BRXhb�c�8�V� @P �6�M��l 8X� �R�U�](άD!ń�Xș�@�a ٸ�e�_�B�<u*Z�ο	��$��@�<�(�������U�"��x��A�1	;̯Y��w�'�a���łփ���zɢ���� &�kP��Ƙ�?Q�k�n����3+���l�]~7v���)����z+~����\��{x�V�ܿ��������������O���D@ �  5̨~��n\)�_��M�9R�|������8v��K
;	ɱy@���b#�A�Kbc4qQe��|P<�����d� jXQ�k  ��:h̰ S)iy���X�0�p�Ñ
kd����P�T�71K���O�j4!�?���t{]wj�O 0>�5����h�r��Ծ��1�6)��l�lL�KRu���A��-XH�y��)��H4�V�iq���4�tl�R�@*~�dEE�ʙj�V � ��<L��'c�y�l<j0!
G��"l@"bR5$Ld�&n��4[�E���(����\4H�g�Z'��477�N]W�������"�M$�ֵ�AH�̒��˄�;n�!P�@bQ)�
�S�5P��J��_����Ca�6_@�Q����71�Nc3YS��X�Ǳ�l�g��;�Y����:{W������(|��U��   	�-`T闇b<�ZR���d
�[�<�4 [U� }i��k��lࠎ9��.T���Eؖ�|�$�����ZY�V�(�Qn�N�F;���?�����PR2�g#��{O Obν���?��������-�}����X���k%�
6�zɃT�0㠸�d�O��@�D���
��Z���  I R`���pٔ�>�h����$���ߑ���M?�Dd��t$��n͡��#��������S��\��O$�O:i�g�.�w�k[�)�g�0 � @���[�������ȏ�>�Йb�"��D1�������9�Q�bS����
���,j  �\zoj#��}�� R�A�D��UC��,@���1s2GI<�(�����*.\'x��a��E�!���d"����; l,=���qb��H�-0�"���F���$��Ǥя<z�z�7~����  
 ���q� �x�E��������XxsX���E�	�J
�zH4���ƺDТ�*���Af �� �J�5�`, (��V�*=8m:�;���2�Z}EØA�4.�O��E&V���
�l�\oڗ����AXŗ�,�J��Sy���<ӿ_�"   @A[�<8.������I
�Ŀ�'�:���<z�O������������ Q5(��"�9�3�$�p�eQ�M'R>C�^BU����;�.^��,�J�RLn�#C�0��%���s�֨d\��>?nӫ�� ��6]o������������ARȀ #�?������d; K+U�OZp0�k\<��$�Rm<o���)���p�j*-��[z.	�����6�������ue�� �`��=yH`Ke�a%�u�+QR�Kr,��]+I�G�½X�~5?�2&�L�k�M��Ig�]}�'��$��o#�8�cٞ�Q��3d"����
�͈�a���� �"P�����nU
�O�PB��!?@��n5!��Lp��x)�ѡ2J�`�T����*   �� }'p�=:�H����P��|׽�עw�A������K�% s?'3>��X���8W�V��'�����RP�Ķ�~���S3$�S��eeS���O��|�	�7j�Pd/dI3i�a��"p b  ��~^�h�׿���������e�ƕ��G�d���dK �KU;/�2��:<��L�YL��H̀�4� Nc*����p�G7�>� a  )S�M���
�&�� ���kL�26,A ���.vZ��_�VZ�n�a��:
��7���JLNぶ��������l˱<+[��d�����;��N����ߠ     ��IH��<
�����3�h`���0(^m���$�O������NL` *���<�PB��=X2^9e���U�$jVN�4���DbxAL��hX4�J�&��.c��6�}	�S�6н8��θ+�g_�3p�������
���o�|`p��
0(����,WNP�Y����55R��A��Lǔ?���16x��C��<VG�d .�Q�@�G��HS�ـ�Z=ݹ���dW�C'W��M25*�=�Lt�Z�Q�ǐ*T��67ër��TIuɏ��2?�A���}�)��ߠ\hMMX|�]C�A&ݦ=K-�[Q�٬��q�9����c�Kk0���b �\h&^�P��V���2�����A��0��R�(&�@!��Y�<%9���*.p�����n# ��
/�����j�!D4oz�}�#9�3Q�S��@������Ϫ�4��"*>�\(�U	0'"���
9v�"8�u�!�w3�tB   )��7
\��n������o�L�Z!�� d;R��������P�x�ױD@@� [���kd�X
)�>��rp5O)Q
ň�����3~��y?k�ѓ49��
�'�ك�#c�W)X�ޚ���dn�&%�щ[�4���=��]'�xH�����@gQ�-mk#��;O����O��M��?j�0 %' ��4Z%�-�{H#VJAB���x�iB߻HG���&�rMFPX@��7v�DđiB(Hi�Ӗ2�F�Ìʹ쒧��^Wz���!�i�!�����������>)^Ær�C�����6Ӈ����R�������C��A}������P� =j��%�Oӷ^����|�e/���c��6�86<8�����3B��(-<�^��}SW�  H,���o%D�(����Q��*41�X����=
��(s��z1�0���,8K�%i�3�%�Z�
�PK���c���L�]���I `x$�
�Ƒ�Ǡ�&���d� �M[��f8�� bPYaG���킭�����g�+ŅC�(��(
"�ńL	��#��*K��1\�*d %� C��%)ѿ����&�e���gM�a������%U��?5��������Q!0�[�,��l4t��%I�YR�
�yZ�2�Ʀ�r��2�G}� B�&P��*$.�����!*�8�X6.@���
�����ֱ�+��G0�@ �ؙz	�
�DD��،A㓾�r]y�Sg�M��F�Qj���X�W5�����P����(���*(�A�б�@X�(�h*���\��O[��G �Q�3�!���`��Q�]~��`���$7����H���ר6F��j����b@5��^���d��C(���2�1���0b�<�WL,�@ʏ��!9�D��������@`^��\�?m���]O#�g��������; �$?jj�5T�ϣ9���������������D~!h�Ә�6xEX���	��������7�n0�,H�aE=�k��� �N@k�x��_�?R����c��s��rnX����v�Z+��F8�{d��b��p����ଘ�>4�KME!�Kw�q��oM��1�1���U������V(���0S!�0���U4�_\�;t b��N7�;�e�(Y�o�J"�����Yz�   "weC���1�9"��

2���,��95�r�ꐰ����a7���r)�@��M�@�X�wn���d����^[Q��4$:u=�$��]G�3�i���艪�R=kR��N����Sq���qw�ĥJƆ�Ѵ�7  �p"�e�>1Mm��O�Br?�ƈ�1��Y��KD��	�P  �X���K<�AS̱�	�jI��O��N�����}6�-�?�¦����K����V���&1U��N���Q�}q�`2P�g-̓"�aA.ں��E� ��� �#S�b����'C����!@r�{e���  �t(�ad�	����Έ�Հ  À� .`��B��Vu$ъ tR�q� ����4+Eć�l�]�\29CT�D��5I.G[P����;Q^��AS-�Q`cgss6�)�i����dπ;US�4dK
1���UU�� т���  j����q�����2�|h�9+4��yh/'����ڍ^�_
c�������Q����;�������������Z���h����   E��-
��.�P�=��"}X��l�k�4L�u��)�f���ƈ�ft������O�75:}r���V��D��rc��\sC*(��tK��4�i<��P)�MQ@�4L�s�n�ݛ��jݍ(<��3����]�h&i�8�E���C`j�I�KFH- ��H�ce��v
a��jRq���1����BP�>�%�MD�}F,IS��U.�h#�q��G��l8���(�GWCd�~�E�D���M3E\[ɣ$��R�(���h&�(���d�[R�i� �+��Ǵ {a���G�n0��d&��+9,�d��o�iY��B�������gNo�M�tX��|�M�EH����Á��@�\���a8�U�	m�Ązf\Br�d�4�GD@�i����i9c����L���4���r�>���N���iG.9t7j
�i'w8yS�B����Z�\���3��)I�ȉ��`��x�2�RL=R����21|���.�!6EH�7�
�6L#c�b|�CG��$j!��}�O!qC� W��R�Nt�x��BN�9��q~�$,<�PQ��C)\�911�w��ᱞ0=8x�����C%��t+�>�Ζ|�W꾉���[P3�aN~�%Y�W"   �\��Puo���4�EZ/�\����d< "�I��<�6�KT� ��o'�O�ۂn0�@X,��8�n"h�xY���c��S$ �#��U�� "=��
XȆs�L�s��\���9o�D�Lۘ<�kp�IY�].�?Wq�m|�@��6�Uu��2߰���ߟq\�/4)
��\�����+v�uȾF���?����Ǽ
[��W��vY���fU���02@$I�<��R�|�� �� d�Z��$��eX��%-GR�x���������WJ���;�k[$�=l�O��;�27�ə�ay��e�7����#���O�sjhn�� %b�dO
e0�`�n�����>~���Z��*4\Xڦ��F�J	�Hh���UO���I  !����8rD���dU ����1�=���0i go�l��p�0 ��
�J�t���� 6��u/�aI��2�NǢ&��L4L٧:`���:�Mk�k�����8��8qC��0��GQ 	��
[�Dh�r�kvyKY��C�o(��$�`QpSZ>��>�Khe$V%��`h,����* ��K  :4�r(��zR^{d�!=Kb�-R;MB�X�v�S�5i�[.h8~> 80x�!���n�Lc��3o:���C�6c[R���CQ����ML&R2�)�8(��]CE��X� w�À�S��cF���(�Y����RE��$IP���ઋ
�-ڴ ���bA3�6�W���Y-��n�G���;��M�n���?m����dh�#*,�a�bA��$`���c�<e����
��N���`� � 1�Е�u�"��Gm�8/�`?�xuy=T�6��S�:�$X4�&�miרٴ�ψ�"�)U�D��sı���`����r���JM�w�a�J B��~6�*(��vP _��h��2,����s�(����
fF8˸T�7���mG�[��<�kcmڦ@�)s2HtǑ����+�/r��Q�{��'%�P9Z��� 
ҢP���}!���2�ʈu�(J���u������'�!��H��w���I��
$��
���%�Ⱥ��vĻ%䑱r��N^d��&��J���n�7<̾Y��ޯ��r�wÃ���-!#芵b�ʶ}���dr �,�a�-�C@�n<��;ag��H��t�� B���|�Fz�zXϪ;	�ڧa�vg�L�!�B:  ���lh0���W�� $rU����!O<	��_����[�Pyp�4Ca��-*�5g�  ���Q�yS4,_���8N��'w�5���+VFsoT浌l��Ëepp( /`pC F���
������vM�����ς+^���`@$ Z̠�&�F=�Ԩ���KY�p�iJ�0i=��jQ�M�������Y�S�����Oe#H��Q4/)qe�L� EN �Z����6r�`	�>��"���_;��[-~����7�zY��;�7���s�����H�0-/d����������i�*f!����d �D����=��<,�8]m��gH��p�<(	�E¸�Qs�v��\k�ҶӬ���6<ś��T��⮂��	��
9l��U@@,��t- � ipS�uBM�&-��B�TYk�jD[`��i�܍��a��E4��+"#*&��A%�ź5��鳙�n��T��E��7�vֻ_-�@ ��
�?��ћ�t�[Q'�,h/��������J*�n%��W�-�;P��\�x�G���Uf"I��� � !�+-`y'�'`p�	�8��0O4�8�JA�y/���u<bL�[BqR��|��:�R��  �08s!�ͦ)���/07��P�r\&L�ƅ��Y���
*�JM����J��q�1#-� F	��Ă=D����d��)YA�,B#��}0#S�@�i'�e���0cN&�r��j������L�!L�y����"<U�=�ұ{���6Y�^D.����l�}
<#V��g�|����x"���qc� �   G@ ��bfU�җd���g@l,��1a@����+�lS/������+r�-5.^  �:L:�("nn8�	�`I�>VY�ӎB±��I]#�Fh$$i�(;w-��5�-Ȉ�O��-��36�>��Q����
�:�?��/�Cu����   @XK�����r�
6@颍u�fȠ��%�z(�@*u��0x$<�`�RHR!9   (2�4�C�d��
MY�-�/����M�5�w�档�ʎR��Gc�C���4T���d� �$�a��;@k|$B ėq��c���0`� 4IbR���c-䈇d��yD�P����QG�r'�1�H	p ��![d����	��J��K�M�=ƹϬ���+�F��&G�{;
�Kq&�,��� 	 R!b�YuIE3�XD?�����<P���9��Օ��̵M�=$=3�_܅�w��{؝N����
Eu��;)o.�
D��ۙm�[9� �������-��zk=��5�U�Ț��5��@'h:
�2b����M8w���j  � !gxZ�lrQ��!	2_~���2؝���d��<���uU���=B��!�����I�4}.�����D�9�05��W�$��}(�*Mȁ
 �C�H6�Bq)������d̂�&Y��)`9a�\$#88�Y.�����	��R������Y�"��e�
&YF��5$�G�����R`4�Ob"�eB�!��	[$�:���e��~��^~=��Z�)�2�^�k_/_�d�Z��P����)��1
�ES�Z�C���(��RI�m3���n�|,r�
̧=� ��3@�h�l2+O_���	��5@xU��o>8qv
5� \���m�c���B�AV�%?�ٖU   ��D3�aa
uo�❧85��&�)��# ��<���Τ�p���⩉�B��wI#�~+8xT*:s�s�	ދ��_��Mɻ�#߽'!��ע�-hf�u�6 zJ�/��L�7�%%�-o����d�
�0V[	�5�K=&
yU,0��!����O�5J�dED��T�(�h�+�������
�J*d\P4��@
��v���}.�v�<��o*�N`�)]AU�w��s)�X�)Hr�'U�0`~<:8p��I�)n���t3������k�}_�Tn9b{^�O��̎!u]�g	����j�����~�n\��1�>>0����xk���#�:�cP�x�p|!�w����}��u�L����Vm���   �A  6�͹C���?�`�96�F�<��AJ���UP⸧�d�)�Ö�#kU�i	���my�qbN�E�
�iM��+�U6��	�o�$})c@�@�89�O�ܤXٔ��F虼m��t4k7���d���y6��8H`<ej�<%L�#Y���,*�� ~��'%�f�댰�ɖ�p�6��i\�Q���\yb�������װ��sV0��w��y��%R�)]4�Qv��߹w����ϥ�OOz�������{�ԟ��  (dA 4 �7)�hZa�7�8�Xh�t��\��,��K�\�7����iꌼ=��X�����]CW~֯w-���W�۠����h�I�|>s��ZkU�%D\�	�1K�����Į���T�)�D��/���{�};��hy3��mC�d���׷�ǽ�_��MĒ,�� ��I4�B;��	4�V�Ȑ��	��M����<
>38ۦ+�!�x)$4��#Rn�έ��3!�ry�.stiv�]}���d��\�^k  ��:��< Y�wq�� q��7�~�X���}���)����Y�e����;���u�ˣ��q�>�wR���H��r
Kt�U��eKV�<;;i���nK2��{����?�5ڶ,��®����bY�y����v�}�K��[�v�=��{Av�� �A   ���X ���Y+�wT�{M�P\����3�^2I�	V�T���i�BRZ��h}qB�ŘC�E8�d����,D����B��옸�mw\��f~ن�{&�Fa��TRa�J���D�'B�8�� �h��A�"�g6a"��-$��)��R۪  +���qJ^����	�r©"���a��l\	�WiSw[�s10������t��f�&�a�	����d#�B�)\�=  7 {�� 
��o��m��q��0N�<X{��ewQ���4�!�  @Tn,�������g�4j�S(B\�%�@�
 o{�5��+Ȭ�% 1���
�Z�ی�@�'$�/H���n��dE{~."ln�mu��Д�U����%¤A��� �b��x`�.B5/�K�@�&A �!�G�60A
�;�Eg�&�(!S͍b���/N������$��*>Y    �Ҋ�����}ɓ��+����OT�
"g�p�n|�$��������w	�Y˹��].h�Օ��'
��;a&�Cގ]j[)�AU"�Zlkqy<����*��{�h  LCE'��e���������݆6]Xl-���dEK;Zk	+�7C�|0B|�k�$mH�nt��%�d�Ap X�]p�^`�[0/`#Y@2O���j,��c)c*����ޔ>��D��rI��Y����jR����)Z���YTI�ŉL`�`8f�悊�ѷot{Řk�4���>�~;��ԣ�6��� � P��o�b�� ��8�����R���C���@j\�+���h��)P   8�S�'x�`�!�
v�!/�g:��xGڝP�ᬘ�~�y�{޾6�h�Q&���r �G�<��I�����x�BDч�O�J�.��9B��K��X�"e�*q��D���-��e�0b��**�J�A��߽g(����J?zL	\J�m�l:F֕�ޱV��CB���dU�#�4��/J�4@�,
����aL$��΄�4���  EY7C:��BBث�e������K��6ZJV�a,��o�����ɞ��"�4W�3[	���d\k�l�j�RNl\���k,�N��|榓Ź^p�̟,x<Y�V��>�8��>�JSW����
����_��N1�iAA�N@V�胱ϩ�]���O@�_�� X�@,{`J�eΫ|ۺȴ��s��m&�)HsH��z�?{��N��B���4t7��v��gϜ>p������t�D/�G���ܻ��������nAZE�]���  ��U�"������ſ�xg	�. ��m���
!4��!�Z�kBp;   ��,(ZT@
^-��&����d\3r4��J�2F+8<"�
��aL=) ���������s�ΧTJHO9��)D� ��~��<E��Y�I4)tH܋�{�΢F�����;�I���}�>y�((v�(,6�{��Y�QI  H�([��I��	KͰ��_�����<�7S>�oK� F�M�_W�фG��� 8�    *@�DJv�ܚ����>�~,G�x�KN��n���*�X��r�&��3����I5&� ��U�C��r6�#!C�12�of�c �����"�4 0���^4,�８q����,%�;��̓ �Sd�RV�x(*���@�@5 ��8�8�X�k��IA��V"���m�ҒS����FS<�u��F��#�����dh<���6 ��1��e��sЃm8�  QK ��uW�h�kOid;Y�M8����Ǚ�I�F�J�������|I��s6��@  ������q��I�
�����T\Tp�A2I)*��+A���~�
X}�U�   ��
X�F2&���{��HC^pX�T)Pw�L����S3��J�|��*߾�I��n�)Z��Qy���i��Sc^0Z�&�bA!�*�*P%�e91bkb	�� `�,a#'dx:y0)��?���h�$7� ���1ǂ
x^�  (��������A5Q(��S�Ў�3?9�i5�6�����Y�֙/��~����TE�j6Li�^�2�����SA� t��*qW����_'������d|3X�P3@��0)��_<k�щm$�	����h][��Uk����Ӭ3�2\ȸ�PI��4:=%Ef��U �fb�U� ?P�J؉��#(3Se��;Q��T�-H���>a�_��M���w�wN�Bsʜ{���E���������$
ª[�?�����(f��T�2���"0 0�R�L�� ~x��ϑ*i|.����h��h�X;SĦ����P�z5�N��� (x0�J�H&����e��!Ӊ+�����s��6I�;�_C���dS4�+�Rk╘#xer�3r���)ϴ��ֺ�lb�͇��0�A p�<��a� ���f`t}�S���5����'�hP�,�A�������d��'J�;p5��$l T�_L<k�ւm� �	�,M)Z ǽ*�"�_��\���y�vI��p?DI
^�KI�?S~OZe�Z��L�y^��N���p̚��|۵��^~�j�%�&D
��m��" [��@v�51:Ć�3�νU�7�e¹�f4S$ty��xR!��_��Gou2�O3�ΐ  b@  ���� �e(�9 ܏E�w!x�)���U���H���3�-�7[��Ru�B��ɛu�	>��`�M?��'���ߒ���Zd�>@̀����QǸ��Z$<{�

����C2��b@F
��r��P�m?���BP @E�1,(BZ2�Q/�'�mO�&�r���=� ���d� C
3W�6���,#�L8�aG�r���T���N���{�YÖw۳��{�T�AV-ݒ�5��GR>�EP��{��&C�����v�^t���=�� 1@�p�R������F�ʑ�LeX�A�碔� �io��xpŁ0���D�� 0`�Z�븕���㊈ꄛG��ǜ�J���Y��f��ɬ>H@�*�3�Gr1eZ;=��#�K����8���¯j�5�͠���ސ@ �!�m vʤ�4l}���O�.l*h�R9o�8���I�A�(��"�A�\�U �   ψ���U�a9��.!�j��W�Ƣ�;�|�Fh_S�N�N�I�(Ŋ!Ѧ��}���4x���9'�X�$�������d��5WK/*p7��1�
��]<��ڈ,��P��/� �B �r9D|?!�	gX���}O*ӮYf B���2��y�U��ڔu�YU�Z� tQ�i� ����K�)�P�[Y��-�rN��L�DЇ������!�#�o�_:e�ϼ��m�rƵ�crֶݜ��7��߽��[��3��V��qS�kag5=[�`'@��	�X�L�A;pҧ��������E�*?4������g����`��w��@ѿz��oIť $��e�'�.`�t�:b�
V 63��!
'��(Ņ�\����`"`W{f��M�#�B	)�BK0. ���>륝��.!vT�'�Vd�Ъh�Tr#P�9u>����d��/�Kp6�[30��R��m�� V�yV�� ��q_���m�Dq��&x�; x.D]��s��8Cq�c��RK"�{_�*��_���6������?�ً���ok�����������������.`� $�M8m�Y�c�C�L�.C	��o�C�Ĝ62�)
���$	Lw]b6K�����.�L����~ў��P���3�v
�D�{Q��E������o�V�4
��VQ�W�$�|x�M�����Vz����qwjWk5c��V��cs��~�QdpƲ5��33+`�V�̯�l�%��.��`  �m�H AD( ���ŐZ�iJ�$;�!y9-E�:�?�UiB0Ť��(�P
����A-3�<!s0������d� �Yюo �Kڽ�0 sc���
��mw0�/ծ�ո����&e}<ߪ6�'ڜ]�����1D�Z��49��Ef�2}�|���Ǉ�ڿ{O���i����w���G��l�V
Z����ʄ��)=4�x�qZ�l�P+�������y*�L�V���)��n+R���"�X�*i@�?��G���P�CRبܲ]�d�xN�)�z~Y��0�hܘ��!mS̈��D�5K<�(��
\i� @�
А ��L������:ӎ��"��&��\�T�
��R��+"sEG�87ˉ�����127R2X�x���e1�#�Y�%�8
G��	T)8�\J���a,,Tw �ˌM:?���\^��޸�����d�SO�O=` 4`��� 8�e'�x �����n����1�������暕�q����s_������Jb�By�q+Yc����"1���R{4�2�BE9r��)��v�ٳ py�:�ӤxWד<TZ��z�T  ��J�_I�? Z�-B�y2��qؖ�=ݥ��;���:���vS�Ӳ��=�fI4*�[7.{�'Qڦ���U?s��X�W�(atԾ��eCR����l@�Ӑ	0wRDa��w,�?�`9�ǧn��e��x|�gr�4���jq�	�2a� ��8�ꜗ�A]�& ���,p1 �:T:���	:B/�w!�����,�{x\X6=$P=�"�֕4㌨��j�w�O
P�Ӧ�jo�	� +���D1 ����K \h�,<#�KЉ\�%m|,0����,7IY$Մ�0H+Y�]�r|��ک������!����v�~yo.�f���&�h�e�]9��@2
]JI~k=�prp�Ts�t
�t� �
`�e�MX� ���������C�)��B���p�@	�䕕�&mw���J/n�Q�w��'L�g�.�+O0]�7�:��H���H ` 0.��^�rDL�����<�o�� TB�NI����t �y���B�^�C7>�K����r '���5z� �
4����,{҃Ba��+�nh����E  2�ShTq�Q!t�{�\$8���"�� %�Q��u�X�:V��f3H���`²�}�[���~�Қ�Fq�'q2���d$��WT�I."<DJ�<bJ�'L�<V��
�Ł�('���B�����Ce�V��5(��Q������D������b��qf ߍ7 @	`kH�t0��]������Pc�����Ֆ�'�Y�8ǮU0Ĥ�ס��$Bąڠ��9��� 4(L�0�lѢtz�6T��]�l t��Fr����tT�:th]Y�t���,4�
�B��&�hɎ��w��*'{$��$y3��X�v�[������pX�c��ࠇƀq����a��f� 16���r�!!3�|�f��$�n�h���
�u!�yʩ-�͟b�>���R��`k��Qu ����\�p�jrI���˅Z"B4������߁ ���$�I3����d�IS�)."<i*�0"DNy#P̤����d��1ʃT( d�y;� O&:�!�����Iit�AQM7 $ڑ�ı��m�"�;���*%J�}������ag
&��P 0k �p��I����3;�:�]�~��u}?����N�*n��ZћF�Lk5YP��2o��
�嚇�q�i6{���g���Vt媢�9L��&_��5���!��H��'�d�I?�*�!��B��MҤ��&�+�H�]�����PW()�5�5�g^�?�8�T~(�9Ѫ��N	�Vr�"N(9�3��ߘs�u������@
"��Ke�(�p|"�a�H�  PX6j�&d�0��+|�����Q$|Y�B�5gd���d�JS�i� 2�;����P�\���
�g0 �i0it��4�<z����]���Y��ff{,������k���+�g�����V�ٗ溮>?����<�|������lֿǭ!��<A��� q �@T�M2���_v�ɉ(��0*mߴ�� ��d>.���`
���������
p1!	�a�B����:(+`��\N8L*S��Q���%���CG[�dj��F�8�?5�ףd����Ӻ���
��$�[��7��ϚH�:�4?8���b���L w����y�&��d��D���,�Ĉ3��e����k��;^
���PdJ���x�ލW����6I̭��JkGGA�����l�������d :[�=  I$[��� ��y���-�  L���@�tN�L���$̈́�
}acO�c,^�A�`��#�o)uP�TH�A��(�b ��px8
�O�W�  ��-��  �sLm"#�QUOtmS���~E���@���&*	�l~��ȅZj��B��E.� (���Y&Q3��4S1	)�e�#�*+��<A�$�P(M�v�j�a��2cjƥ� �r�y��I���-)ڇ�貓  �ZM�)�B�s��.��[s��7��  y3�z���7�vr�s�vO�e9/�ۦ�s~� �?66>
h8�,`@�A 8|8�/z���UK�ev� +���T��
4���$F6���䉆a	#e�^���d��$����Ba|
�4��7y�1�'.����L���$أ���>*wg��KiU�U�PE������(�� ����"6�vU�Il+N�z��t��g0/Q�h�+����?��<�BY���Д2�xU�� ,&r]������p8�l@#�5����Q0��-c�<yF=�^c�ZΌ��Y�&�����S�C�����?���[�6.۞��<�p� �XY(D@\+z|L����B��������q
�L��^��I��Oi����ߝ��}�"�	���Y5���K�T)��xE$�|�b�.�_*:`%g���0A�N8��Ǫ��	��ƽ��6���,#,��$8[@/�iQ H:d�!ߢ���d) ����4Fī�<�J�ky�j���.�ǘP̑]� ,Q5j
�<oP��]��5>5�6u��M2�����3��0�ۜ��|~��ɑVZ��j�߇�_<��WW��V� �1�R4�x���2g0T"�c��9;�����:���9���cO�
[�be�K�����~=����L��_������� ̮`�8ua!f�4�g	�]Ez?�D&%�ē0��Z5o��bRMj����U��&���f��t�X<�_�av��;���d$cpi�,n�Z��M�Xj����*���x���jQ��A�
���h=
&���xb�9��*]�b]��"���H����BQq��!�H���
#�oj1�i������d@��(^y��B�,�<"_�l�o�O��8�}���e�k2�B���H��7�V����Rq�P  � ?Q�/�����>5l7���RmI+:"�z��Z������$~�5��e��4R��ŷa6�d�hY�M�D�=�έ �
0a(���nٽ���+��w�����+�b��J44֚i*M7=VL4���+4�&�F)*��Sm��)ZN�uZ)J���;��ë�LM+��<z�I�*��� �)O_�FV.�|��rw�d��@�
1"+S�*��"���6Ve�yx��EGt�}��l	J@��+�<�ӆ��R�.�C�JI�����t���(l ��o�q)3��,`���H ��� U
MѢvW`y0����dW �N�i��9�[n0P��g�ƈԄmx�(m�b:�G)��*NB�(Ӽ5�>�0�h�����D	�+�.�HH�i�玏��8�!�|�`����>�+ �8n�4n�¤�����	�[튼y��p����h��G	ϗ((O��1%# ��% �<�cHALV�"��94�dmI��g+P�VD�́*�z`C(Aa	�������>���SAܔ
<2���zr�W_���C��(� R�>
�0l	#�Wc��C�{�ʋ�Oo��z��W~鈃��'#�q����<�����CeV42XL@dD1�ʁ�ʊ8pбS��8�X7;����>�Ҁq�;�|�2)�}�<d�"XL���do��:���B<�L_(��({w����t��vB�8���ٕ���܎�q�c�>�]�����a�D@$4�	�SH�
M��hCN#��!�%v�O=����<�؊!��H  N(Y���UIęq/	���$����zOדhc*.)J@(�ŉک��vh��(��%Wu�P6��0MgH>y7�j��N��~u�khJ�k�B>��,P 
��� .�����,�bhi*o~�h����Q�?��(i7u��� 1�-r[�
8�0�$+��O�o�T��Bu#�
0f����������p,P�H��j����!i��ن9ǄF��K��M�J��iW&�z-rO���&)�Q,%�d���X����͠���d�  Z�/H`6�|
0b �x�i�������	 p�"c�Q@R�*���;l�i�mytEȓ5�T_��J(@ �q�kLS�U��-
���T�X͌=֤�]�a}�c�����d�U�v��^ȣ.��1�!A���W��&S��Un���C���q�q�!b(�i��i��\C ��r]
�Ǥ�'��q��`\ڏ����GC�$@���a������eD�f!i�+^VY$��P��լ�bVBy�0�j��b@���my�H������#g�"$��˛�©�t�T���܎���[�	$p�=��<���Zh d-�	�}��0��w��o] =�{>0H	��� as	<Y�<���pAuN7dm�M\0�z���d��<��/*�3"[]0#Jx�e�<i��	������(�u��JN�Q� ��mO��Zk�{KnM^k�Z�@���ҚN��c%�3��]
8������_Y��X�$?��L󜪒&��M�xE�j�e � `h��¨(�������N����A9#���� ����`��5 @�A  ���-yb�3uw�������Q_.��)�f� ���~��8h�,5���R8%�K*�M6+��g��5
ti�K�c������?�ۋ䕸�T�0�A�  ���i�:SQ��V��Dؕ
�_@�<F<�(�{~��#   ��B<�jY��yiZy�)��h�*5��P�D��m�{UQ}�����mDn�
��p�;�g���d��*4]�
. �0)2 �e�<��Њ,�Ĉoe�7�!\�x�c�$��@(^S,t�f������S�@J P  ��6ܮc>	(ĮP���ͮq_�``��)rZ������2npG�!��36  �!(@�
�^�h@!&���������-���E<�T[��E��u$�
�$�|�����D���i�o��5`�f�^�=�i�����  s@�Z#Ap%��������V�Q`a�f��|0 ��x�����]�ѥ)�$�%�J��@[���I���<ߓ^�0��E,=.�,~ܵ���,uJ_k��dY�Q
M��Zlm4]�n��v)ȬDFܐ�f�\*&���`�
���BQEy)9K���d̀$4Y�p5`{^?de��r������e���?������s!ޯ��_�]��C�.n
��	<��C�u\6H   H�n��iWb�r����(%��O��W��b�F��ťz�,���G;��<��I���-{�F��=��$a������n����f`	�
5������;{}Zwd�J����h�x��40H���ñϝ���Ưk��E�K����S*C=Uky�h�������=�P$4@"= '    �#����Olqe=�����#���h�P�������
��8N=4T���b�{�d۞��d����yO���gG�С�G�*�����S�;\��s
�����䧸8��� @����.����d� #3[i�$1f��"��1Z�$��/t��:2	5���I] �����HbËq%Z�%u�@���<aP�X0��e�a f5�h"���{׾P}H`b��$	3��f����@��ta�0w�3s���������Y05�W���(���(�ɔQ/�ht8;���#���h��6	�b��;����~ґ��P���44��
5�^�V�y#�9!����Z�R�M�*<P��J���	��[CG)�� �S8$�J0!j�@��iۥ�������0˒����ʢ����,4$��Ẍ́i������Ћ�	�����M$F�}$_�D�} l�0�o�q�<Ǚ������/�vmn\5����G�FHč� ���d��7��	0="�,=�
��Z��������,
�9. �8H�,�?Z���`=��(��A��i�F�XSPpE��W ��1���@X ��n��r'g2��]�íJ�\��%+C�H�����g���22��D'U����׉��ʗi!��#��D��|N�* 
z3kP��v�����>�z�$D@b�-
 ��HcP 
 � �L,��U�0��P�U}V�G��<���������Κz�'�*ZK���T��%v�P&Z�� 2} �D�$��V����VD�� �{��p�r� j��L
H!`���՚����Vp
�9�X�Vt����p���8*�~
���#
`و�0�#��	
x�F�E<F���d��8�)n$<�k�0 ��;]LX�☭4�0c��� �I 	���X��$,�q�"L���aM�G��ʷņN�X$k�OegP����<4�@�"�Y�� Me�Y�OV�����R��=�هӝv�����%����b��U��@�B���?�.q
�z �s���4��t�g��{�n����D�E�O��M.�ӶMKu�'�]��!�P ����Fъ�4�}�M��v��~x��g�G���c��A%���  ]�!�nDd��U,�;!��
�UQm�����9�2����r����C���'CN�I���wI��|_�qp���pg�{����x�U���9��R)>y������
~��L�Pp����d�
c=S�IV :!\
0Q���WA6P�	����.��K����r���d �|��"������y���������SF/-�^Zm���qW�BG���N��k��P Q�
Z0 �,I ���&f�
�D�[�^媨A|��;dl͝�.�aUa���X`ц��A�w�=�,F����/��ي<s�G<��?��<�pb<�x����YQw�XW����9�]W���pFR�m�>���q��%rƬ�����P\5��\EY
�*�   ��H���p%�1I�`S
�
�kN3NMI;���G��� ���������>�5���]�ͳ	�	�el���f���1�Q��

f3��u�u�Ha��0�h����d�
;T+XL�7�Kl$"~���N-aK��	�$��~E�  ���<p`��-��o�޿���� �H  c�-�(b�8�|�f9[�s�<�� ��qc�ۂƁ�V1+��)'?��0���PD,ų((U�,�]~&<j��9�8����.;�è�!(X�� �����P]�t1�O���p�*K�A�%�I.JÝ�TV	rRJa��V�+Β��S�8�.N?/8��#P���ˁr�j�wC��  @N�j���%���g
����Pw~q��GJgl����K��v����� "�I0�P�w�� hq���������0 \�&<_��/%0�⒑Z�BM%#dn��BV��p��#��(���b���d�`^RKM6"��="��J�  єl6�  �<T)X�Xs5w�s�w�-�V�6���7�m���}ԇe�2��$צ��e\3w�5)����`��C�[�¥�|^z-&�
]Q�Y|1����y���j�s���sV���a����������������E"���t��@#5DB���t?2M�RNK���]�XN�vI"zo$8�1���a3�ɴ������QS8��H�ˈ��[�>YRڣei������V=�	���Q����[F����I��y��;�M���4�Π��r���o~��1_���������-W5XB@&��&�)(�L$(�%@B��	���NVr��@! 0�e�<�!H������q=�ĭZ��`k.���dԀ�]S>k  �kZ�Ǽ X�{k���`.n���k�~��影<h��(N'��}}��+�
9X�b-P�ӊ:B˸�S�j�W3;V;t��S<83;���o��U�#�G�0a��`G�#�����Ƽ���e�ܷx�]5�p���������^W����I0�.ÚR8��^��C��cq����u�9����0&�m3[�:�e�0mo��\9�r��)|��Қ�{���u���<4���Zzv�n~���=<Jqh^���rk=�����(�~�E����:�K_���)4�}]��l�u}n�&�q�o��fT����4ie�  �D�U����u�����L	�� �!3·��Q4i�Gށ�J����9'��?Ξ8s��:x����d��W�7= Eeh� PI`�<Q�� �p��O��>|��F��rhޗs�{ޚ��ޓ�k.7�U�o/��U�*�I��������j�:�M�&�hW@l,�f�-۱B<�Kӵ	�Ԯ�;��p���̡�H�o%-�ʯt���+���܋�zOIюk�������(D
Dc.�YS/��Z+ia��UË3� ���%��f�G��V:tn�
��8N3�ۦ����w���J�F�[[���J�C�Z��Jַ]ۯ�V��]pP`� 8h�><~h��?�c�f�������
{��`5D@B3m/G�[�)�?@�����hl���'H
y�=�P�֑$��p� �   m`U�_�N�2we���!ֽ~�vWL���d�SYc�-��<�Ι9_'�Q��p�ļ��q�Ϲz��1��(�b�21C1۪��������M�QmeW[7ST�B����
�ŷ���SW6[�6]o�;Q�O*#Բ�tGۺ_�B���	4-��'�6� �eLD/���3�������L���m��`iB�7�13=   ��I���4�(�'�35���w7#5�
hluC����+��%�s"o�\��I~w.��.O�I�狧c�����]>t��!����X�����'�W����������B�HB�+�D8F ��͌��<�g�du��?Ч�{U<��a�]�����|����Akl �*Jy�*  `   � ���I��m1K��u<���5:�����d�XXa�/ ;���<�5)\�$X��	�P�� ���<e�u�.穔��`��������޷���$�>Cg�%MA�f�+w[�� E+#*v>�jr��#+�Ռ��v1z��]���:���0�C��B@9����?�3��1���������

#��
@0�*�s�����F�xv|� � 
L��rV�����p�R��Tm��Zݒ1�?79� /P|AB�c������O�1{�������$HD��>y4M�I'=�HÂ�4�?��
�68/*���=X�S0 ����+2�׍ji����Ăg��h��d;<��O����u�XH� ;NBt/v8�\��h�5�JR��Y�z�܇�e�r������d��N�c."+�[�$�,�c��8H���|�VBn�2��;�z�����m[�4�?�U����u��T��|�s����3�h�ΧV%�C;Y_g+Y5l`}<�m �o`�7����  F�3�|�7��e�;�
[b��E�����aG,�Eu��  `w�b�
ǱO�q�b�:y�<���O�rL�M<�n�Pz��BXz�`y���I�x"��$��FI�n��Ҝ8�����������˫ꖲ�9'Phj�r\��o����V��xpF@A+�͸���A2�>0Q���mq�A��l���[�ӄJ2{����  � �S��]��a�¹�NBA.c	��U9���5렂��+�����+n�a��O���d �2Y��8@˯/  �i��ˀ�mlǈ�ҽ��3}���~�s[�p����=�(5���b��Z� �  D������_@�5�精��aB�L��K$ X��g�"3��|k�<Ρր��    �E?��r0����"�~(
�IJ�y���7P&��s�"�7�>D��0Ԏ�����z��F��:��u�lӦ���6�uҟT`�~]�!0 5f��c�:R���eA����f��W!(�]]ʨJ��A����  �p0�R�E��;��*257�2r �������Ҥ�C�'a������Eh�3	6&QsO#�V>Z��@��w Jt	�`���)!�ʙ� �aP�!-�P�u���iz�,קSZ�6t�����D6 )F]��rH�k�$�B	�+y�$C	4�|��9������әD>8�=$Ú;�A#����O��"1�ޏC;$EJ�E�PZ_��pP68`δh�
�����O�/�|��
��;��n`�d6R?w�I�3��?���?�зv���$N�`'GH�� 3�0���Ռm�%?����n3��gR[\!2u��s�
���1�1ܝ����Q���/�efI�g6��s.����H:4͂�T��֍�'�?��n���I��b{����.��o,s7E���
�A�@5�"$�����)�h��j��{dE%�gX��V 5�N���~���/�\��g5���޴:�h1�����HR�͛6,���˪�k$d�	N���dP �.�y�B?A�</$���y��pQ�������r�_���%�
�)z�:�US@>j�����:hl�
@d"{L���yF�!Ա(��!����EA�o��;�/k�pj]�a٢
i�f�N�G���<C�U��r.u��_�1倒Ś,,��pq�u�[P�(<@�A����,�Uih9�U8� ��S#�a��;5�Z#�`)���ޑ/�����8e)�S��i�ԉ�L�h+��'�>
��a� yAR9hl��Y�C֗t{s�� m�7�
^�h?���%� O��NT<w
��,
3�_$PN��b�J���H�4�
T�MF���H ��@� �I%	a60���.z��
���`��h|ͪ�I�u��
���de��#\��@A\-0�2�
!q��OP�	�0��hqJ����1��N��T4�+ܹ��SFpXE�ME�V����~Č�
 �´��
&;�e0F�'r�8�bE��5�.sGl�ѓ
r$j0�����a&��z��t@   ��)�Z#���vQ*I���ʥ�&� �GV�oٵ�l��t���Z�2ƹw�� �]K�Yc2O�����ӻ-C�M���Ze�p yH��O6��KWR��HG�̼�Z(y�'M�
����w	\�������88��M1�$���  b����)���צnUa���<�8�)��I�v� ��<�<��f������'�O�s3�Z����f���r��������o� �����dz��0����F!�=�&	��a�O����x��S�?bA�dH�����@��0Q���&��r��G�k0������h�h�Vȵl(��%; YY���d�۝��TT�z���G20�p�i�T݊�R�ͭԶ��B��Z����![����
w���_�`��ɴ"q�L�)�1  @ P|��e�[��[$��$.~�(�O(8�0�c(Kq�����0T��I@@"����  "K$"8pts�%'�VODy�����d��@������$wa-!� �#
�dh���t�n�{g�sW��.=���ﲢ}u5�]>/x� ]
U�LfQ���v�����t'Uy��<�;���:���f+:��ep��D������d��"� [��K�?�;o14(�k�$���.��
!�~�WF�FD .C5� L,��A�Dr�cL�tL�e:�k}e��u���	%P��!&�	�k%�4��5�1�m�rT_f�����Fh@ 2�ebf;�/w������\������?��0�N.*h�3�g2`JA�����n�GcI�
xx��:����ʨc���g��b��85g�PHىb"�X(^YD ͢]�5V+�쉆�0Z�'H��+
�B�������W��-���F����1dY�8�	F$g���������4�Qb`����@ C����E\<$��#xd!  �M*��M�zV��9]0��%oԲ�|��Ja�B�����d���/\��0�@�ێ=8`}����P�o��,�PA��K��`e��0֐D,0�B*����XaF0�z��6>X�u�� P!����$�a��5���Y[�d,s#C��(`*�����Ғ�D@JF �=G�Ks9F���T[H�B�j�U��ei��E��D���-E�Q2����R�E�Ea�YG�8��̝b�T�4L�̹�h�.�j��Q�aAX >��[�e
e���� ^pЄ�x˃�\�b���� �Rĕ(Tb   )���-ᐪ	p�	���Mbr`��C=���.Xa�g[��
9��L+vJ|1�_L�d�ą���Ӽ9pJુ\��8��n���N�Хr����w��_���2/�dn�n`   �)�0����dƂ��{,�,�L�<#Y�L�o���@�rx��%��H� |������m,JAQXD
@��*X�:�F����%��	 �,  ��	R���*	Յ�J� I���<��)X~�b�V,C�t2����$q�\�J�,�����(�Q`��Rè��+�&��-_��/��f ��H�5�U`�C��؆�%��H2�[�\��@{�{@�+a�XܨhC����٩��U�֥DU��;�`�Gܖo�:��;�[�4!�--Y?W�{�   �6nYJU��,��bj5�,d)V���R��p5N����^��ۛ��d�HM� z4�}
I���IxK܁'#z�D��=���9N�x��������ąX�F�:㺩����d�#k&��3�>�˯%��g�0��#�p��<�<�M�q�
_���+�1��������S>��]�z9�D:�P,k���a��c,+  A�h�EPjpCr`q�ҘOӢ*p�
�O3�z�	���4uk��;�Y�c�T�J;e<Ӝ�GH�q@ڱ↨��i��1�";a��$EŞ%y�"*��X�׺fB���l�AJ�uYTjQ��58���|���YT[����C`ࡠ+��G1���1�!�aIp� (�    J#	@B��x�C-�C�<Q�\� ��ǪE�0&�#��^-!��1�_�](&�x�(��(ሐw\�y�H�F�U�s�������>^�5
��f����3U�����9��z������d�a2XKJpB�+ <eL
T�e�1�
�.4�Hk��R����9���7�{߱L   �A�H�
���o�z{��4�6��ބ"�i*¡�=���,'�E[x�Qo��N��w�1N|  @ ��9 Ã���I�2��c)� X(�kN�T�
��F��u��K�����4���^�+�g�,�2�nZ-aR���˱�~�ыH[�Q�#p}�Y=��YNQG�3k�m�ZҞ����ܭM*�Kuޣ�ݞc*���k��/��-�W���?��
�~��,a^�8������?�����ʒ�e��SӃ֪-��P1������m�JM$�M�-#z�!A}za	MaX�]C����-�l�1:V�3��wm�^̾���V���d� D>W�a�?AK]�� �_W9� n,��4��6�f����V]!�5��UQܶ�j�%���IP�����J"��\����Oիr�»��ުk�hb�ׯzZY�L�e%ױi��3�;�'���/���f,&�r   D�h���L$���x�.J�־�����1�`&�Q�33P�&�*[1�0�� &J3a��DNʝ����U��,x�v
�W<X;`�G��`�G���[5
`�
������q���W��M��N
X(+H���7�_�����LAME3.100������������������������������������������������������������������������������������������������������d~��*F�<` /��� @ �      4�  ������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
