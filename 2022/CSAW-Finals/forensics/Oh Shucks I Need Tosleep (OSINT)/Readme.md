# Oh Shucks I Need Tosleep (OSINT) 
Premise:
You have work tomorrow but you're caught in an OSINT rabbit hole! Answer all the questions to satiate your curiosity so you can log off your computer and get some sleep!

## Author
Eliana Halevi

## Questions & Answers:
1.	Where was this filmed (Ex: 123 Area Street South): 301 Keawe Street
2.	On March 29th, a 2022 temporary restraining order was filed against the person in white. What is the case id of this TRO? (EX. XXXX-XX-XXXXXXX): 3DSS-22-0000203
3.	Ezra Miller ‘s 2017 costar later married a woman with the initials J.L.L. What is the certificate number on that marriage license? 202207160041807
4.	In 2009 ben Affleck played a character named Neil in another movie. One of the producers of that movie is currently married to a popular talk show host. What is the producer’s name? Nancy Juvonen.
5.	In 2022 Nancy Juvonen and her husband Jimmy filed a BOTH RPTT AND RETT document regarding a New York property. In this document, what address is listed under “GRANTOR/SELLER:” (Ex: 123 Area Street South):  200 Park Avenue South
6.	What is the DOS number of Jimmy’s business listed at that address? 4839348
7.	What is hotdogbuzz.com’s ip address? 23.236.62.147
8.	What name is listed as hotdogbuzz.com's domain registrant? PERFECT PRIVACY, LLC

Final Flag: flag{90g3750m35133py0u051n75up3R57@2r}
		          	"go_get_some_sleep_you_osint_superstar"
			

## Solution / Notes

### 1. Film Location
Reverse image search whatisthis.png
<img width="1186" alt="Screen Shot 2022-09-27 at 1 35 57 PM" src="https://user-images.githubusercontent.com/90015030/192655894-322200a8-da66-4011-9cf8-0cb1f037c675.png">
No results! But if you look for the image source...
<img width="1173" alt="Screen Shot 2022-09-27 at 1 36 16 PM" src="https://user-images.githubusercontent.com/90015030/192655980-f67df603-91b4-4ee7-afb3-206ebbea5633.png">
The first result is an exact match! It's a still from a tiktok from TMZ. 
Watch the video and you'll see the words Hilo Axe!

<img width="678" alt="Screen Shot 2022-09-27 at 1 42 02 PM" src="https://user-images.githubusercontent.com/90015030/192656414-efeea2bc-23c6-4e53-8d16-46fbf7ebd343.png">

Look up Hilo Axe on google images and you can see the backdrop is the same as the one in the video. The full name is Hilo Axe Lounge.
<img width="1060" alt="Screen Shot 2022-09-27 at 1 45 23 PM" src="https://user-images.githubusercontent.com/90015030/192656750-7754c83d-c5b0-4054-86b4-a6f6d48deeec.png">
Google Hilo Axe Lounge and the address will pop up:

<img width="388" alt="Screen Shot 2022-09-27 at 1 46 46 PM" src="https://user-images.githubusercontent.com/90015030/192656919-abf94d72-bb23-43f4-9ec0-9b8b39dfa42c.png">

301 Keawe Street


### 2. Case ID Number
From the TMZ video description you know the subject in white is Ezra Miller. 
Googling TRO's against the actor show a few TROs have been filed. Not to worry though, the gossip sites say the TRO related to this date was filed in Hawaii.
<img width="1148" alt="Screen Shot 2022-09-27 at 2 02 52 PM" src="https://user-images.githubusercontent.com/90015030/192658381-81f04a27-497c-4ecc-81d2-a6b1bcca7656.png">

So we look up Hawaii court douments by party 
<img width="1183" alt="Screen Shot 2022-09-27 at 2 01 26 PM" src="https://user-images.githubusercontent.com/90015030/192658544-5c1fc9d3-9cf8-4bf8-8bdd-82d17903bc77.png">
And see the case ID is 3DSS-22-0000203

### 3. Marriage License
Now we look up what shows Miller was in in 2017. According to IMDB there is only one: Justice League!
If you live under a rock and don't know Ben and J.Lo got hitched in 2022 a quick search for Justice League married will show that they got married in 2022.
<img width="921" alt="Screen Shot 2022-09-27 at 2 10 48 PM" src="https://user-images.githubusercontent.com/90015030/192659432-263024cc-18ae-4bfa-9eba-e5cd422a3130.png">

Now we know who... but where?

<img width="808" alt="Screen Shot 2022-09-27 at 2 16 19 PM" src="https://user-images.githubusercontent.com/90015030/192659514-36b66d15-570b-414f-aab6-3774a36289fe.png">

Okay. It was in Las Vegas. That means there must be an marriage liscence in Las Vegas' database. 
So we go to the Clark County Clerk's Office website and... <img width="1187" alt="Screen Shot 2022-09-27 at 2 18 57 PM" src="https://user-images.githubusercontent.com/90015030/192659905-cb0400b0-6ed2-4f68-8cd5-2c37e61d820e.png">

Boom. 202207160041807.

### 4. Producer Name
What movie was Affleck in in 2009? IMDB says it is "He's Just Not The Into You"
<img width="684" alt="Screen Shot 2022-09-27 at 2 21 52 PM" src="https://user-images.githubusercontent.com/90015030/192660118-a51ba830-d67f-4507-b1e1-28d12a2223b4.png">
The producers on thsi movie were: 
<img width="710" alt="Screen Shot 2022-09-27 at 2 24 32 PM" src="https://user-images.githubusercontent.com/90015030/192660360-af2de5df-942a-4e6a-a18b-edb0821bab19.png">

Only one is married to a talk show host! 
<img width="792" alt="Screen Shot 2022-09-27 at 2 25 01 PM" src="https://user-images.githubusercontent.com/90015030/192660399-6b7d17c3-7998-4242-90c6-e9a26abead11.png">
Nancy Juvonen!

### 5. Address on Document
Most property records can be found with a search on ACRIS. Searching by name doesnt show anything for "nancy Juvonen" or "Jimmy Fallon" but are those the names they use? Jimmy's real name is James and his middle name starts with T! And legally, Nancy goes by Nancy Fallon! Using either of these names will show
<img width="1184" alt="Screen Shot 2022-09-27 at 2 32 48 PM" src="https://user-images.githubusercontent.com/90015030/192661236-a384c762-7cff-4360-b5f2-cf867916c667.png"><img width="1177" alt="Screen Shot 2022-09-27 at 2 33 07 PM" src="https://user-images.githubusercontent.com/90015030/192661248-908efbba-2125-4358-825c-07fe9c944545.png">

Looking at any of these documents shows the following addres

<img width="599" alt="Screen Shot 2022-09-27 at 2 35 11 PM" src="https://user-images.githubusercontent.com/90015030/192661413-ea9ec26c-da5c-4453-9edb-53dfe0baafbd.png">

200 Park Avenue South!

### 6.  DOS number
From here, start with a basic search. Jimmy fallon, 200 Park Avenue s 8th floor
<img width="878" alt="Screen Shot 2022-09-27 at 2 39 00 PM" src="https://user-images.githubusercontent.com/90015030/192662125-87830ce8-27cb-4262-89ff-9dfcc13c838e.png">
From here, you can see the DOS is 4839348. But if you want to double check, look up Electric Hot Dog in the NY State Department of State Division of Corporations look up. 
<img width="1158" alt="Screen Shot 2022-09-27 at 2 43 39 PM" src="https://user-images.githubusercontent.com/90015030/192662533-f5208f5a-c745-4f1c-a7cf-94d5ec209058.png">


### 7. ip address
Let's look into this Electic Hot Dog shall we? 
There are many avenues you can try here, but why not ping?

Remember: This question explicitly states hotdogbuzz.com NOT www.hotdogbuzz.com
You should get something like this:

ping hotdogbuzz.com
PING hotdogbuzz.com (23.236.62.147): 56 data bytes
64 bytes from 23.236.62.147: icmp_seq=0 ttl=60 time=102.589 ms
64 bytes from 23.236.62.147: icmp_seq=1 ttl=60 time=103.121 ms
64 bytes from 23.236.62.147: icmp_seq=2 ttl=60 time=103.594 ms
64 bytes from 23.236.62.147: icmp_seq=3 ttl=60 time=103.123 ms

hotdogbuzz.com is located at 23.236.62.147


### 8. Resgistrant Name
Easy. 
Perform a lookup for the website.<img width="795" alt="Screen Shot 2022-10-03 at 12 58 01 PM" src="https://user-images.githubusercontent.com/90015030/193700512-c1998f00-4f08-438c-a7d8-c7cd247c9520.png">
PERFECT PRIVACY, LLC
