Hello!

Welcome to pwn2csaw!

To get this flag you will have to exploit a modified version of chrome.

== Setup ==

The patch (csaw.patch) should apply cleanly to latest at the time of writing (11/6/2018) which is chromium 70.0.3538.77 and v8 7.0.276.32. (See https://omahaproxy.appspot.com/ for version info).

I've provided you with a release build of Chrome (chrome_70.0.3538.77_csaw.tar.gz), a release build of v8 (v8_7.0.276.32_csaw.release.tar.gz) and a debug build of v8 (v8_7.0.276.32_csaw.debug.tar.gz). The debug build also has several DCHECKs disabled to help you write your exploit.


If you want to build your own copy of v8 do the following:
  
  git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
  export PATH=$PATH:$(pwd)/depot_tools
  fetch v8 && cd v8
  git checkout 7.0.276.32.
  gclient sync
  patch -p1 < ../csaw.patch
  ./tools/dev/v8gen.py x64.debug
  ninja -C out.gn/x64.debug

You only actually really need v8 to solve this challenge, an exploit should translate very cleanly to chrome. However if you would like to build a debug chrome see https://chromium.googlesource.com/chromium/src/+/HEAD/docs/linux_build_instructions.md

== Challenge ==

* North-America *
If you are on-site in North-America Finals there is a machine setup with chrome. To get the flag you will need to come over and give us a HTTP/HTTPS URL to visit. There will be a flag if you run `/read_flag` but we will also give you the flag if you manage to pop gnome-calculator. Chrome will be run with `./chrome --no-sandbox` inside Ubuntu 18.04 Desktop

* Other Sites *
For non North-America sites, there is a service that will load a given url in chrome for you. To get the flag, run `/read_flag`. In this case chrome will be run with `./chrome --headless --disable-gpu --no-sandbox --virtual-time-budget=60000 <your_url>` within an ubuntu 18.04 docker container. A proof of work will be asked before chrome runs, but a proof of work solver is provided.


