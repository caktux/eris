# How to create spider webs

The API for the Structural contracts are as follows:

Please Note!
This is NOT the API you will be interacting with in the final product. These will be filtered through the Bylaws and the Bylaws will call these. The Bylaws are not yet written however. So for practice, Create a web by hand and then test your spiders on it. (Just letting you know so you don't spend a lot of time on the bindings)

Initialization:
"init" (datamodel.JSON) (UI Structure) 0xOwnerAddress

Don't worry about the Owner I have commented out the only place it is used you can stick something in there if you want

Binding: (Setting parent)
"bind" 0xParentAddress

Add links:
"addlink" (linkID) (main) (type) (content) (datamodel.JSON) (UIstructural)

These fields correspond to the fields listed in the c3d compatibility.txt file
note linkID is something of your choosing. Just try to avoid collisions (The contract will boot you) handy trick add 0 to the end of the linkID just to ensure there are at least 16 slots separating linked list entries (more then enough)

Remove links:
"rmlink" (linkID)
...yup