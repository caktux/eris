**Please read all of the instructions before assembling your DOUG**

**WARNING**

Building DOUGs can be dangerous. Please use Caution and never Build DOUGs near small children. Dennis McKinnon Enterprises Inc. Is not responsible for any loss of property, loss of sanity or death resulting from use of these instructions or from use of DOUG including your DOUG becoming sentient and turning on its creator.

# Denny's Guide to Building a DOUG Cluster

## Step 1) Create DOUG-v6.lll and copy the address

## Step 2) Go into each of the following files:

General/repDB.lll
Swarum/Swarum.lll
Swarum/Thread Factory.lll
Swarum/Topic Factory.lll
Swarum/Votable Post Factory.lll
Bylaws/CreateThread.lll
Bylaws/CreateTopic.lll
Bylaws/PostToThread.lll

near the top of each of these files is a line that reads

(def 'DOUG 0x9c0182658c9d57928b06d3ee20bb2b619a9cbf7b)

Copy DOUG's address from the previous step into every one of these slots

## Step 3) Create all of those contracts.

Order does not matter but contract numbers all get generated in the same order on fresh blockchains so if you are going to do this a couple times without automation you can make your life simpler by sticking to some order. As you create each contract note its address (you can copy to the list below if that helps you will need them all)

## Step 4) DOUG Registration

Since there is no contract adding Bylaws yet we will do it manually. Don't worry by default the creator of DOUG gets "BYLAW" status allowing you to make any edits necessary The following list will help. Order does not matter at all But all transactions must go to DOUG. ALSO you NEED to replace the addresses you obtained for each contract in the slot where there are addresses below:

* 0x7265676973746572000000000000000000000000000000000000000000000000 "rep" 0x7ed820f11b6987139aeca5c0e38668ab089f7911 0x0 0x0 0x0 0x0 0x0
* 0x7265676973746572000000000000000000000000000000000000000000000000 "swarum" 0x9e4d58a9f74d7a5752c712210a9ffbe612f2609f 0x0 0x1 0x0 0x0 0x0
* 0x7265676973746572000000000000000000000000000000000000000000000000 "swarumthreadfactory" 0x540cfd9789ce49ccdc7c760ae5be640fb782109d 0x0 0x0 0x0 0x0 0x0
* 0x7265676973746572000000000000000000000000000000000000000000000000 "swarumtopicfactory" 0xf65fc8cd2c6b427903e6eddb85ec8a5737566510 0x0 0x0 0x0 0x0 0x0
* 0x7265676973746572000000000000000000000000000000000000000000000000 "swarumpostfactory" 0x644f87f92629c3856337722ad782ec41a20202c6 0x0 0x0 0x0 0x0 0x0
* 0x7265676973746572000000000000000000000000000000000000000000000000 "BLWCThread" 0xef9a9e3eaadf47b322b5111b85e6b569ad159664 0x0 0x0 0x0 0x0 0x0
* 0x7365747065726d00000000000000000000000000000000000000000000000000 "doug" 0xef9a9e3eaadf47b322b5111b85e6b569ad159664 0x1
* 0x7265676973746572000000000000000000000000000000000000000000000000 "BLWCTopic" 0x5b41a84c87d89b522279838a6fcb9a5ffa39dc6b 0x0 0x0 0x0 0x0 0x0
* 0x7365747065726d00000000000000000000000000000000000000000000000000 "doug" 0x5b41a84c87d89b522279838a6fcb9a5ffa39dc6b 0x1
* 0x7265676973746572000000000000000000000000000000000000000000000000 "BLWPostTT" 0x6e1e9f93cd2bc9ba6678cf7d17ddea13acb19f57 0x0 0x0 0x0 0x0 0x0
* 0x7365747065726d00000000000000000000000000000000000000000000000000 "doug" 0x6e1e9f93cd2bc9ba6678cf7d17ddea13acb19f57 0x1

## Step 5) Give yourself some rep!

I have my address hardcoded to automatically give me 9001 rep so you need to make the following transaction to the rep contract:

If you want to hardcode yourself for the future you can add in a line in repDB.lll at line 37 like [[0xYOURADDRESS]]0x9001

## Step 6) You now have a functioning DOUG cluster with three bylaws!

The bylaws you have are:

* CreateTopic API:(0xSwarumAddress "linkID" innerBlob innermodel innerUI outerBlob outermodel outerUI)
* CreateThread API:(todo)
* PostToThread

Note I have only tested CreateTopic the others should work....

inner**** are the values which get placed in the c3d Header of the created thing whereas
outer**** are the values in the linked list which you link your created thing to.

Swarum setup
0x9e4d58a9f74d7a5752c712210a9ffbe612f2609f "topic1" 0xA1A1 0xB2B2 0xC3C3 0xD4D4 0xE5E5 0xF6F6

## Step 7) Enjoy your new DOUG

Many DOUGs enjoy being played with consider taking your DOUG to the park or for a walk. Maybe play fetch or go swimming.

# Casey's Guide to Building a DOUG Cluster

## Step 1) (Optional)

Modify the DOUG.package-definition file however you like

## Step 2) Deploy

Using Ethereum Package Manager's tool you can deploy in one command from the cli or from Sublime.