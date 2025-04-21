Class {
	#name : 'OpenAIChatToolsetOnBrowserEnvironment',
	#superclass : 'Object',
	#instVars : [
		'browserEnvironment',
		'tools'
	],
	#category : 'AI-ChatPharo-OpenAI',
	#package : 'AI-ChatPharo',
	#tag : 'OpenAI'
}

{ #category : 'instance creation' }
OpenAIChatToolsetOnBrowserEnvironment class >> browserEnvironment: browserEnvironment [

	^ self basicNew initializeWithEnvironment: browserEnvironment; yourself

]

{ #category : 'instance creation' }
OpenAIChatToolsetOnBrowserEnvironment class >> new [

	^ self browserEnvironment: RBBrowserEnvironment default

]

{ #category : 'private - function implementations' }
OpenAIChatToolsetOnBrowserEnvironment >> applyFunctionFindMethodsWithSubstring: arguments [

	| substring methods |

	substring := arguments at: 'substring'.
	methods := self methodsWithSubstring: substring cappedAt: 50.

	^ Dictionary with: 'methods' -> (methods collect: [ :method |
		Dictionary
			with: 'class' -> method methodClass instanceSide name
			with: 'side' -> (method methodClass hasClassSide ifTrue: [ 'instance' ] ifFalse: [ 'class' ])
			with: 'protocol' -> method protocolName
			with: 'selector' -> method selector
			with: 'source' -> method sourceCode ]) asArray
]

{ #category : 'private - function implementations' }
OpenAIChatToolsetOnBrowserEnvironment >> applyFunctionGetClassComments: arguments [

	^ self response: 'comment_per_class'
		collect: [ :class | class comment ]
		forClassesNamed: (arguments at: 'classes')
]

{ #category : 'private - function implementations' }
OpenAIChatToolsetOnBrowserEnvironment >> applyFunctionGetClassDefinitions: arguments [

	^ self response: 'definition_per_class'
		collect: [ :class |
			 Dictionary
				with: 'superclass' -> (class superclass ifNotNil: [ :superclass | superclass name ])
				with: 'instance_variables' -> class instVarNames
				with: 'class_variables' -> class classVarNames
				with: 'package' -> class package name
				with: 'tag' -> class packageTagName ]
		forClassesNamed: (arguments at: 'classes')
]

{ #category : 'private - function implementations' }
OpenAIChatToolsetOnBrowserEnvironment >> applyFunctionGetClassMethods: arguments [

	| selectorsOnly |

	selectorsOnly := arguments at: 'selectors_only'.
	^ self response: (selectorsOnly ifTrue: [ 'selectors' ] ifFalse: [ 'methods' ]) , '_per_protocol_per_side_per_class'
		collect: [ :class |
			Dictionary newFrom: ({ class. class class } collect: [ :methodClass |
				(methodClass isInstanceSide ifTrue: [ 'instance' ] ifFalse: [ 'class' ]) ->
					(Dictionary newFrom: ((methodClass protocols sorted: [ :protocol1 :protocol2 | protocol1 name < protocol2 name ])
						collect: [ :protocol |
							| selectorsInProtocol |
							selectorsInProtocol := (methodClass selectorsInProtocol: protocol) sorted.
							protocol name -> (selectorsOnly ifTrue: [ selectorsInProtocol ] ifFalse: [
								selectorsInProtocol collect: [ :selector | methodClass sourceCodeAt: selector ] ]) ])) ]) ]
		forClassesNamed: (arguments at: 'classes')
]

{ #category : 'private - function implementations' }
OpenAIChatToolsetOnBrowserEnvironment >> applyFunctionGetClassSubclasses: arguments [

	^ self response: 'subclasses_per_class'
		collect: [ :class |
			(class subclasses select: [ :subclass | self browserEnvironment includesClass: subclass ])
				collect: [ :subclasses | subclasses name ] ]
		forClassesNamed: (arguments at: 'classes')
]

{ #category : 'private - function implementations' }
OpenAIChatToolsetOnBrowserEnvironment >> applyFunctionGetClassesInPackages: arguments [

	| classesPerPackage notFoundPackages |

	classesPerPackage := Dictionary new.
	notFoundPackages := OrderedCollection new.

	(arguments at: 'packages') do: [ :packageName |
		(self classesInPackageNamed: packageName) ifNotNil: [ :classes |
			classesPerPackage at: packageName put:
				((classes sorted: [ :class1 :class2 | class1 name < class2 name ]) collect: [ :class | class name ])
		] ifNil: [
			notFoundPackages add: packageName ] ].

	^ Dictionary with: 'classes_per_package' -> classesPerPackage with: 'nonexistent_or_outside_scope_packages' -> notFoundPackages asArray
]

{ #category : 'private - function implementations' }
OpenAIChatToolsetOnBrowserEnvironment >> applyFunctionGetPackages: arguments [

	^ Dictionary with: 'packages' -> (self browserEnvironment packages collect: [ :package | package name ]) sorted
]

{ #category : 'accessing' }
OpenAIChatToolsetOnBrowserEnvironment >> browserEnvironment [

	^ browserEnvironment
]

{ #category : 'private' }
OpenAIChatToolsetOnBrowserEnvironment >> classNamed: className [

	^ self browserEnvironment at: className asSymbol ifAbsent: [ nil ]
]

{ #category : 'private' }
OpenAIChatToolsetOnBrowserEnvironment >> classesInPackageNamed: packageName [

	^ (self packageNamed: packageName) ifNotNil: [ :package |
		package definedClasses select: [ :class | self browserEnvironment includesClass: class ] ]
]

{ #category : 'private - function declarations' }
OpenAIChatToolsetOnBrowserEnvironment >> functionFindMethodsWithSubstring [

	^ OpenAIChatToolFunction name: 'find_methods_with_substring'
		description: 'Finds methods whose source includes the given substring. Results are capped at 50 methods.'
		parameters: (Dictionary
			with: 'type' -> 'object'
			with: 'properties' -> (Dictionary
				with: 'substring' -> (Dictionary
					with: 'type' -> 'string'
					with: 'description' -> 'The substring to find'))
			with: 'required' -> #('substring'))
		block: [ :arguments | self applyFunctionFindMethodsWithSubstring: arguments ]
]

{ #category : 'private - function declarations' }
OpenAIChatToolsetOnBrowserEnvironment >> functionGetClassComments [

	^ OpenAIChatToolFunction name: 'get_class_comments'
		description: 'Gets the comment of each class.'
		parameters: (Dictionary
			with: 'type' -> 'object'
			with: 'properties' -> (Dictionary
				with: 'classes' -> (Dictionary
					with: 'type' -> 'array'
					with: 'items' -> (Dictionary with: 'type' -> 'string')
					with: 'description' -> 'Names of the classes'))
			with: 'required' -> #('classes'))
		block: [ :arguments | self applyFunctionGetClassComments: arguments ]
]

{ #category : 'private - function declarations' }
OpenAIChatToolsetOnBrowserEnvironment >> functionGetClassDefinitions [

	^ OpenAIChatToolFunction name: 'get_class_definitions'
		description: 'Gets the definitions of each class: its superclass, its instance variables, its class variables, the package it is in and its tag.'
		parameters: (Dictionary
			with: 'type' -> 'object'
			with: 'properties' -> (Dictionary
				with: 'classes' -> (Dictionary
					with: 'type' -> 'array'
					with: 'items' -> (Dictionary with: 'type' -> 'string')
					with: 'description' -> 'Names of the classes'))
			with: 'required' -> #('classes'))
		block: [ :arguments | self applyFunctionGetClassDefinitions: arguments ]
]

{ #category : 'private - function declarations' }
OpenAIChatToolsetOnBrowserEnvironment >> functionGetClassMethods [

	^ OpenAIChatToolFunction name: 'get_class_methods'
		description: 'Gets the source code, or just the selectors, of each method for the given classes, organized per protocol and grouped by instance side and class side.'
		parameters: (Dictionary
			with: 'type' -> 'object'
			with: 'properties' -> (Dictionary
				with: 'classes' -> (Dictionary
					with: 'type' -> 'array'
					with: 'items' -> (Dictionary with: 'type' -> 'string')
					with: 'description' -> 'Names of the classes')
				with: 'selectors_only' -> (Dictionary
					with: 'type' -> 'boolean'
					with: 'description' -> ('Whether to get the full source of each method, or only its selector; ' ,
						'prefer selectors only to get an overview of a class')))
			with: 'required' -> #('classes' 'selectors_only'))
		block: [ :arguments | self applyFunctionGetClassMethods: arguments ]
]

{ #category : 'private - function declarations' }
OpenAIChatToolsetOnBrowserEnvironment >> functionGetClassSubclasses [

	^ OpenAIChatToolFunction name: 'get_class_subclasses'
		description: 'Gets the subclasses of each given class.'
		parameters: (Dictionary
			with: 'type' -> 'object'
			with: 'properties' -> (Dictionary
				with: 'classes' -> (Dictionary
					with: 'type' -> 'array'
					with: 'items' -> (Dictionary with: 'type' -> 'string')
					with: 'description' -> 'Names of the classes'))
			with: 'required' -> #('classes'))
		block: [ :arguments | self applyFunctionGetClassSubclasses: arguments ]
]

{ #category : 'private - function declarations' }
OpenAIChatToolsetOnBrowserEnvironment >> functionGetClassesInPackages [

	^ OpenAIChatToolFunction name: 'get_classes_in_packages'
		description: 'Gets the classes in each given package.'
		parameters: (Dictionary
			with: 'type' -> 'object'
			with: 'properties' -> (Dictionary
				with: 'packages' -> (Dictionary
					with: 'type' -> 'array'
					with: 'items' -> (Dictionary with: 'type' -> 'string')
					with: 'description' -> 'Names of the packages'))
			with: 'required' -> #('packages'))
		block: [ :arguments | self applyFunctionGetClassesInPackages: arguments ]
]

{ #category : 'private - function declarations' }
OpenAIChatToolsetOnBrowserEnvironment >> functionGetPackages [

	^ OpenAIChatToolFunction name: 'get_packages'
		description: 'Gets all of the packages.'
		parameters: (Dictionary
			with: 'type' -> 'object'
			with: 'properties' -> Dictionary new
			with: 'required' -> #())
		block: [ :arguments | self applyFunctionGetPackages: arguments ]
]

{ #category : 'initialize - release' }
OpenAIChatToolsetOnBrowserEnvironment >> initializeWithEnvironment: initialBrowserEnvironment [

	self initialize.
	browserEnvironment := initialBrowserEnvironment.
	tools := {
		self functionGetPackages.
		self functionGetClassesInPackages.
		self functionGetClassDefinitions.
		self functionGetClassComments.
		self functionGetClassMethods.
		self functionGetClassSubclasses.
		self functionFindMethodsWithSubstring }.
]

{ #category : 'private' }
OpenAIChatToolsetOnBrowserEnvironment >> methodsWithSubstring: substring cappedAt: maximumNumberOfMethods [

	| methods |

	methods := OrderedCollection new.
	self browserEnvironment methodsDo: [ :method |
		(method sourceCode includesSubstring: substring) ifTrue: [
			methods add: method.
			methods size = maximumNumberOfMethods ifTrue: [ ^ methods ] ] ].
	^ methods
]

{ #category : 'private' }
OpenAIChatToolsetOnBrowserEnvironment >> packageNamed: packageName [

	^ self browserEnvironment packageAt: packageName ifAbsent: [ nil ]
]

{ #category : 'private' }
OpenAIChatToolsetOnBrowserEnvironment >> response: resultKey collect: block forClassesNamed: classNames [

	| resultPerClass classesNotFound |

	resultPerClass := Dictionary new.
	classesNotFound := OrderedCollection new.
	
	classNames do: [ :className |
		(self classNamed: className) ifNotNil: [ :class |
			 resultPerClass at: className put: (block value: class)
		] ifNil: [
			classesNotFound add: className ] ].

	^ Dictionary with: resultKey -> resultPerClass with: 'nonexistent_or_outside_scope_classes' -> classesNotFound asArray
]

{ #category : 'accessing' }
OpenAIChatToolsetOnBrowserEnvironment >> tools [

	^ tools
]
