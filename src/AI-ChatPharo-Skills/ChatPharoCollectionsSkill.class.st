"
Skill providing context about Pharo collections.
Collections are fundamental to Pharo programming. This skill
provides documentation about:
- OrderedCollection, Array, Set, Dictionary
- Collection iteration methods
- Streams
- Common patterns
"
Class {
	#name : 'ChatPharoCollectionsSkill',
	#superclass : 'ChatPharoSkill',
	#category : 'AI-ChatPharo-Skills',
	#package : 'AI-ChatPharo-Skills'
}

{ #category : 'accessing' }
ChatPharoCollectionsSkill >> contextString [

	^ '## Pharo Collections Documentation
### Overview
Pharo has a rich collection hierarchy. The main types are:
- **OrderedCollection** - Dynamic array, most commonly used
- **Array** - Fixed-size indexed collection
- **Set** - Unordered unique elements
- **Dictionary** - Key-value pairs
- **SortedCollection** - Automatically sorted
- **LinkedList** - Doubly-linked list
- **Bag** - Allows duplicates, counts occurrences
### Creating Collections
#### OrderedCollection (Dynamic Array)
```smalltalk
"Create empty"
coll := OrderedCollection new.
"Create with elements"
coll := OrderedCollection with: 1 with: 2 with: 3.
coll := OrderedCollection withAll: #(1 2 3 4 5).
coll := { 1. 2. 3 } asOrderedCollection.
"Add elements"
coll add: 4.
coll addFirst: 0.
coll addAll: #(5 6 7).
coll add: 10 afterIndex: 2.
"Remove elements"
coll remove: 3.
coll removeAt: 1.
coll removeLast.
coll removeAll: #(4 5).
```
#### Array (Fixed-Size)
```smalltalk
"Create"
arr := Array new: 5.
arr := #(1 2 3 4 5).
arr := { 1. 2. 3+4. ''hello'' }.  "Dynamic array literal"
"Access"
arr at: 1.        "first element"
arr at: 3 put: 10.  "modify element"
arr first.
arr last.
```
#### Set (Unique Elements)
```smalltalk
set := Set new.
set add: 1.
set add: 2.
set add: 1.  "no duplicate added"
set size.  "=> 2"
"Set operations"
set1 := #(1 2 3) asSet.
set2 := #(2 3 4) asSet.
set1 union: set2.        "=> #(1 2 3 4)"
set1 intersection: set2.  "=> #(2 3)"
set1 difference: set2.    "=> #(1)"
```
#### Dictionary (Key-Value)
```smalltalk
dict := Dictionary new.
dict at: ''name'' put: ''John''.
dict at: ''age'' put: 30.
"Access"
dict at: ''name''.           "=> ''John''"
dict at: ''missing'' ifAbsent: [ ''default'' ].
"Iteration"
dict keysAndValuesDo: [ :key :value |
    Transcript show: key, '': '', value printString; cr ].
"Creation shortcuts"
dict := { ''a'' -> 1. ''b'' -> 2 } asDictionary.
dict := Dictionary newFrom: { ''x'' -> 10. ''y'' -> 20 }.
```
### Iteration Methods
#### do: (Basic iteration)
```smalltalk
#(1 2 3 4 5) do: [ :each | Transcript show: each printString; cr ].
```
#### collect: (Transform elements)
```smalltalk
#(1 2 3 4 5) collect: [ :each | each * 2 ].
"=> #(2 4 6 8 10)"
"With index"
#(''a'' ''b'' ''c'') collectWithIndex: [ :each :index |
    index printString, ''-'', each ].
"=> #(''1-a'' ''2-b'' ''3-c'')"
```
#### select: / reject: (Filter)
```smalltalk
#(1 2 3 4 5 6) select: [ :each | each even ].
"=> #(2 4 6)"
#(1 2 3 4 5 6) reject: [ :each | each even ].
"=> #(1 3 5)"
```
#### detect: (Find first matching)
```smalltalk
#(1 2 3 4 5) detect: [ :each | each > 3 ].
"=> 4"
#(1 2 3) detect: [ :each | each > 10 ] ifNone: [ 0 ].
"=> 0"
```
#### inject:into: (Fold/Reduce)
```smalltalk
"Sum"
#(1 2 3 4 5) inject: 0 into: [ :sum :each | sum + each ].
"=> 15"
"Product"
#(1 2 3 4 5) inject: 1 into: [ :product :each | product * each ].
"=> 120"
"Also available as:"
#(1 2 3 4 5) sum.
#(1 2 3 4 5) fold: [ :a :b | a + b ].
```
#### anySatisfy: / allSatisfy: / noneSatisfy:
```smalltalk
#(1 2 3 4 5) anySatisfy: [ :each | each > 3 ].   "=> true"
#(1 2 3 4 5) allSatisfy: [ :each | each > 0 ].   "=> true"
#(1 2 3 4 5) noneSatisfy: [ :each | each < 0 ].  "=> true"
```
#### Chaining Operations
```smalltalk
#(1 2 3 4 5 6 7 8 9 10)
    select: [ :each | each even ]
    thenCollect: [ :each | each * 2 ].
"=> #(4 8 12 16 20)"
```
### Sorting
```smalltalk
#(3 1 4 1 5 9 2 6) sorted.
"=> #(1 1 2 3 4 5 6 9)"
#(3 1 4 1 5 9 2 6) sorted: [ :a :b | a > b ].
"=> #(9 6 5 4 3 2 1 1)"
"Sort by property"
people sorted: [ :a :b | a age < b age ].
```
### Grouping
```smalltalk
#(1 2 3 4 5 6 7 8 9 10) groupedBy: [ :each |
    each even ifTrue: [ #even ] ifFalse: [ #odd ] ].
"=> a Dictionary(#even -> #(2 4 6 8 10) #odd -> #(1 3 5 7 9))"
```
### Flattening
```smalltalk
#((1 2) (3 4) (5 6)) flattened.
"=> #(1 2 3 4 5 6)"
"Flat collect"
#(1 2 3) flatCollect: [ :each | { each. each * 10 } ].
"=> #(1 10 2 20 3 30)"
```
### Useful Methods
```smalltalk
coll := #(1 2 3 4 5).
coll size.           "=> 5"
coll isEmpty.        "=> false"
coll isNotEmpty.     "=> true"
coll includes: 3.    "=> true"
coll indexOf: 3.     "=> 3"
coll first.          "=> 1"
coll last.           "=> 5"
coll first: 3.       "=> #(1 2 3)"
coll last: 2.        "=> #(4 5)"
coll copyFrom: 2 to: 4.  "=> #(2 3 4)"
coll reversed.       "=> #(5 4 3 2 1)"
coll shuffled.       "random order"
coll asSet.          "convert to Set"
coll asBag.          "convert to Bag"
```
### Streams
```smalltalk
"Write stream"
stream := WriteStream on: String new.
stream nextPutAll: ''Hello ''.
stream nextPutAll: ''World''.
stream contents.  "=> ''Hello World''"
"String streamContents: shortcut"
String streamContents: [ :s |
    s nextPutAll: ''Hello '';
      nextPutAll: ''World'' ].
"Read stream"
stream := ''Hello World'' readStream.
stream next.      "=> $H"
stream next: 5.   "=> ''ello ''"
stream upToEnd.   "=> ''World''"
```
### Association and Pairs
```smalltalk
"Association (key -> value)"
assoc := ''name'' -> ''John''.
assoc key.    "=> ''name''"
assoc value.  "=> ''John''"
"Used in Dictionary"
dict := { ''a'' -> 1. ''b'' -> 2 } asDictionary.
```
### Tips
- Use OrderedCollection when size is unknown
- Use Array for fixed-size, performance-critical code
- Use Set when duplicates should be eliminated
- Use Dictionary for key-value lookups
- Use #select:thenCollect: instead of chaining separately
- Prefer #ifEmpty: and #ifNotEmpty: over checking size
- Use #streamContents: for efficient string building'
]

{ #category : 'accessing' }
ChatPharoCollectionsSkill >> description [

	^ 'Pharo collections including OrderedCollection, Array, Set, Dictionary, and iteration methods like collect:, select:, inject:into:.'
]

{ #category : 'accessing' }
ChatPharoCollectionsSkill >> keywords [

	^ #(
		'Collection' 'OrderedCollection' 'Array' 'Set' 'Dictionary'
		'SortedCollection' 'LinkedList' 'Bag' 'IdentitySet'
		'collect' 'select' 'reject' 'detect' 'inject' 'do'
		'anySatisfy' 'allSatisfy' 'noneSatisfy'
		'flatCollect' 'groupedBy' 'sorted' 'reversed'
		'add' 'remove' 'includes' 'indexOf'
		'first' 'last' 'at' 'atPut'
		'Stream' 'WriteStream' 'ReadStream' 'streamContents'
		'Association' 'iterator' 'enumeration' 'fold' 'reduce' 'map' 'filter'
	)
]

{ #category : 'accessing' }
ChatPharoCollectionsSkill >> name [

	^ 'Collections'
]
