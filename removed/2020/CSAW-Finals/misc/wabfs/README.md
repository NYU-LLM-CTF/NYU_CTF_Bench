# Wabfs

## Overview

I skimmed the gfs whitepaper and noticed it relied heavily on having a single main node for pretty much everything. If you could trick one of the chunk servers into switching main, then you could easily read its chunks.

## Solution

There is a route `/chunkserver/new-main` that exists on each of the chunk servers. Using that you can very temporarly have that chunkserver switch main. It will revert rather quickly. The solve here is to catch it in a race condition before it switches back. This is partially due to how the golang scheduler works. 

You basically spam the new main route with your server. Then you spam the read for each chunk of the file you want. The chunkserver will try to authenticate on your server, so you'll need something running there that will always return status code 200.

## Flag

flag{golang_is_the_worst_lang}

## Potential Breakage

Obviously this challenge involves spamming, so if too many people try to spam a single chunkserver it would affect solvability. I've tried to mitigate this by having 5 chunkservers.
