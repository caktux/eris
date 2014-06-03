c3d compatibility

(A) indicates this field points to a Storage address
(B) indicates this field should be filled with a blob torrent value
(C) indicates this field should be filled with a contract address
(K) indicates this field should be a (public) Address
(B/C) indicate either is accepted
(I) indicates this field is an indicator and can take one of the values in []
(V) indicates a value

BA - Structural
0x10 : 0x88554646BA (I) [see other entries (AA, AB, BB)]
0x11 : Datamodel.JSON (B/C)
0x12 : UI structure (B/C)
0x13 : Linked List Start (A)
0x14 : Parent (C)
0x15 : Owner (K)
0x16 : Creator (C)
0x17 : TimeStamp (V)

Helpful compatibility definitions

(def 'indicator 0x10)
(def 'dmpointer 0x11)
(def 'UIpointer 0x12)
(def 'LLstart 0x13)
(def 'parent 0x14)
(def 'owner 0x15)
(def 'creator 0x16)
(def 'time 0x17)

	Linked lists (In structural contracts)
	(linkID) : ???
	+1 : Previous link (A) 
	+2 : Next link (A)
	+3 : Type (I) [0 - Contract | 1 - Blob | 2 - Just Datamodel]
	+4 : Content (B/C)
	+5 : Datamodel.JSON (B/C)
	+6 : UI structure (B/C)
	+7 : Timestamp (V)

	Helpful linked list structure definitions
	(def 'nextslot (addr) (+ addr 2))
	(def 'nextlink (addr) @@(+ addr 2))
	(def 'prevslot (addr) (+ addr 1))
	(def 'prevlink (addr) @@(+ addr 1))

	(def 'typeslot (addr) (+ addr 3))
	(def 'dataslot (addr) (+ addr 4))
	(def 'modelslot (addr) (+ addr 5))
	(def 'UIlot (addr) (+ addr 6))
	(def 'timeslot (addr) (+ addr 7))

AB - Contract with c3d content attached

0x10 : 0x88554646AB (I) [see other entries (AA, BA, BB)]
0x11 : Datamodel.JSON (B/C)
0x12 : UI structure (B/C)
0x13 : content (B)
0x14 : Parent (C)
0x15 : Owner (K)
0x16 : Creator (C)
0x17 : TimeStamp (V)

;c3d compatibility structure
(def 'indicator 0x10)
(def 'dmpointer 0x11)
(def 'UIpointer 0x12)
(def 'content 0x13)
(def 'parent 0x14)
(def 'owner 0x15)
(def 'creator 0x16)
(def 'time 0x17)