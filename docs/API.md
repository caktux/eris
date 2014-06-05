# How to create spider webs

The API for the Structural contracts are as follows:

*Note* this is NOT the API of the final c3D contract system. In the final product, these commands will be filtered through the Bylaws and the Bylaws will call these commands -- not the caller. This set of API commands are only for testing c3D in isolation (without a DOUG attached). To use this API structure, create a c3D web by hand and then test your spiders on it.

To deploy these contracts you will use the non-factory contracts from the contracts directory.

### Initialize -- `AB` and `BA` Contracts

`init` (blob) (datamodel.json) (ui) 0xOwnerAddress

These fields correspond to the fields listed in the `Structure.md` file.

*Note* when testing in isolation, don't worry about the `OwnerAddress` because the only place used in the testing contracts are commented out -- you can stick something in there if you want, or just leave blank.

### Set a Parent -- `AB` and `BA` Contracts

`bind` 0xParentAddress

### Add Link -- `BA` Contracts

`addlink` (linkID) (main) (type) (behaviour) (content) (datamodel.json) (ui)

These fields correspond to the fields listed in the `Structure.md` file.

*Note* `linkID` is determined in the c3D layer, not in the ethereum layer. It is the responsibility of the c3D client to avoid collisions. If a duplicate `linkID` is sent to the contract, the contract will simply not accept it. A handy trick is add 0 to the end of the `linkID` just to ensure there are at least 16 slots separating linked list entries which is more then sufficient.

if type=0 it will follow (main) to find the next contract
it can also check to see if anything has been placed in slot linkID+5 for any content
but it will follow main

if type=1 it will ignore the main slot

### Remove Link

"rmlink" (linkID)

Does what it says.
