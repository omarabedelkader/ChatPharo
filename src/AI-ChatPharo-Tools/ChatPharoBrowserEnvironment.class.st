"
Bridges the **running Pharo image itself** to the LLM via function calling.

* Wraps a *Refactoring Browser* environment and exposes read-only queries such as “get class comments”, “list packages”, “find methods containing a substring”… each exported as a `ChatPharoClient` tool.
* **Why** – empowers the LLM to answer questions about the live codebase while ChatPharo is running, without hard-coding any particular query set inside agents.
"
Class {
	#name : 'ChatPharoBrowserEnvironment',
	#superclass : 'Object',
	#instVars : [
		'browserEnvironment',
		'tools'
	],
	#category : 'AI-ChatPharo-Tools-System Browser',
	#package : 'AI-ChatPharo-Tools',
	#tag : 'System Browser'
}

{ #category : 'instance creation' }
ChatPharoBrowserEnvironment class >> browserEnvironment: env [ 

	^ self basicNew initializeWithEnvironment: env; yourself
]

{ #category : 'instance creation' }
ChatPharoBrowserEnvironment class >> new [ 

	^ self browserEnvironment: RBBrowserEnvironment default
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> applyFunctionFindMethodsWithSubstring: arguments [

	| substring methods |
	substring := arguments at: 'substring'.
	methods := self methodsWithSubstring: substring cappedAt: 50.

	^ Dictionary with: 'methods' -> (methods collect: [ :method |
				   Dictionary
					   with: 'class' -> method methodClass instanceSide name
					   with: 'side' -> (method methodClass hasClassSide
							    ifTrue: [ 'instance' ]
							    ifFalse: [ 'class' ])
					   with: 'protocol' -> method protocol
					   with: 'selector' -> method selector
					   with: 'source' -> method sourceCode ]) asArray
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> applyFunctionGetClassComments: arguments [

	^ self
		  response: 'comment_per_class'
		  collect: [ :class | class comment ]
		  forClassesNamed: (arguments at: 'classes')
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> applyFunctionGetClassDefinitions: arguments [

	^ self
		  response: 'definition_per_class'
		  collect: [ :class |
				  Dictionary
					  with: 'superclass'
						  ->
						  (class superclass ifNotNil: [ :superclass | superclass name ])
					  with: 'instance_variables' -> class instVarNames
					  with: 'class_variables' -> class classVarNames
					  with: 'package' -> class package name
					  with: 'tag' -> class packageTagName ]
		  forClassesNamed: (arguments at: 'classes')
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> applyFunctionGetClassMethods: arguments [

	| selectorsOnly |
	selectorsOnly := arguments at: 'selectors_only'.
	^ self
		  response: (selectorsOnly
				   ifTrue: [ 'selectors' ]
				   ifFalse: [ 'methods' ]) , '_per_protocol_per_side_per_class'
		  collect: [ :class |
				  Dictionary newFrom: ({
						   class.
						   class class } collect: [ :methodClass |
							   (methodClass isInstanceSide
								    ifTrue: [ 'instance' ]
								    ifFalse: [ 'class' ]) -> (Dictionary newFrom:
								    ((methodClass protocols sorted: [ :protocol1 :protocol2 |
									      protocol1 name < protocol2 name ]) collect: [ :protocol |
										     | selectorsInProtocol |
										     selectorsInProtocol := (methodClass
											                             selectorsInProtocol: protocol)
											                            sorted.
										     protocol name -> (selectorsOnly
											      ifTrue: [ selectorsInProtocol ]
											      ifFalse: [
													      selectorsInProtocol collect: [ :selector |
														      methodClass sourceCodeAt: selector ] ]) ])) ]) ]
		  forClassesNamed: (arguments at: 'classes')
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> applyFunctionGetClassSubclasses: arguments [

	^ self
		  response: 'subclasses_per_class'
		  collect: [ :class |
				  (class subclasses select: [ :subclass |
					   self browserEnvironment includesClass: subclass ]) collect: [
					  :subclasses | subclasses name ] ]
		  forClassesNamed: (arguments at: 'classes')
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> applyFunctionGetClassesInPackages: arguments [

	| classesPerPackage notFoundPackages |
	classesPerPackage := Dictionary new.
	notFoundPackages := OrderedCollection new.

	(arguments at: 'packages') do: [ :packageName |
			(self classesInPackageNamed: packageName)
				ifNotNil: [ :classes |
						classesPerPackage
							at: packageName
							put:
								((classes sorted: [ :class1 :class2 |
									  class1 name < class2 name ]) collect: [ :class |
									 class name ]) ]
				ifNil: [ notFoundPackages add: packageName ] ].

	^ Dictionary
		  with: 'classes_per_package' -> classesPerPackage
		  with:
		  'nonexistent_or_outside_scope_packages'
		  -> notFoundPackages asArray
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> applyFunctionGetPackages: arguments [

	^ Dictionary with: 'packages'
		  ->
			  (self browserEnvironment packages collect: [ :package |
				   package name ]) sorted
]

{ #category : 'accessing' }
ChatPharoBrowserEnvironment >> browserEnvironment [

	^ browserEnvironment
]

{ #category : 'accessing' }
ChatPharoBrowserEnvironment >> browserEnvironment: anObject [

	browserEnvironment := anObject
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> classNamed: className [
    "Return the class object whose *unqualified* name equals className,
    or nil if it is absent from the current browserEnvironment.
    Lookup is case-insensitive so that tool calls remain robust even when
    the assistant provides names in a different case."
    
    | direct normalised |
    direct := self browserEnvironment
        at: className asSymbol
        ifAbsent: [ nil ].
    direct ifNotNil: [ ^ direct ].

    normalised := className asLowercase.
    ^ self browserEnvironment classes
        detect: [ :cls | cls name asLowercase = normalised ]
        ifNone: [ nil ]

]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> classesInPackageNamed: packageName [

	^ (self packageNamed: packageName) ifNotNil: [ :package |
			  package definedClasses select: [ :class |
				  self browserEnvironment includesClass: class ] ]
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> functionFindMethodsWithSubstring [

	^ ChatPharoClient
		  name: 'find_methods_with_substring'
		  description:
		  'Finds methods whose source includes the given substring. Results are capped at 50 methods.'
		  parameters: (Dictionary
				   with: 'type' -> 'object'
				   with:
					   'properties' -> (Dictionary with: 'substring' -> (Dictionary
							     with: 'type' -> 'string'
							     with: 'description' -> 'The substring to find'))
				   with: 'required' -> #( 'substring' ))
		  block: [ :arguments |
		  self applyFunctionFindMethodsWithSubstring: arguments ]
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> functionGetClassComments [

	^ ChatPharoClient
		  name: 'get_class_comments'
		  description: 'Gets the comment of each class.'
		  parameters: (Dictionary
				   with: 'type' -> 'object'
				   with:
					   'properties' -> (Dictionary with: 'classes' -> (Dictionary
							     with: 'type' -> 'array'
							     with: 'items' -> (Dictionary with: 'type' -> 'string')
							     with: 'description' -> 'Names of the classes'))
				   with: 'required' -> #( 'classes' ))
		  block: [ :arguments |
		  self applyFunctionGetClassComments: arguments ]
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> functionGetClassDefinitions [

	^ ChatPharoClient
		  name: 'get_class_definitions'
		  description:
		  'Gets the definitions of each class: its superclass, its instance variables, its class variables, the package it is in and its tag.'
		  parameters: (Dictionary
				   with: 'type' -> 'object'
				   with:
					   'properties' -> (Dictionary with: 'classes' -> (Dictionary
							     with: 'type' -> 'array'
							     with: 'items' -> (Dictionary with: 'type' -> 'string')
							     with: 'description' -> 'Names of the classes'))
				   with: 'required' -> #( 'classes' ))
		  block: [ :arguments |
		  self applyFunctionGetClassDefinitions: arguments ]
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> functionGetClassMethods [

	^ ChatPharoClient
		  name: 'get_class_methods'
		  description:
		  'Gets the source code, or just the selectors, of each method for the given classes, organized per protocol and grouped by instance side and class side.'
		  parameters: (Dictionary
				   with: 'type' -> 'object'
				   with: 'properties' -> (Dictionary
						    with: 'classes' -> (Dictionary
								     with: 'type' -> 'array'
								     with: 'items' -> (Dictionary with: 'type' -> 'string')
								     with: 'description' -> 'Names of the classes')
						    with: 'selectors_only'
							    ->
								    (Dictionary with: 'type' -> 'boolean' with: 'description'
									     ->
										     ('Whether to get the full source of each method, or only its selector; '
										      ,
										      'prefer selectors only to get an overview of a class')))
				   with: 'required' -> #( 'classes' 'selectors_only' ))
		  block: [ :arguments |
		  self applyFunctionGetClassMethods: arguments ]
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> functionGetClassSubclasses [

	^ ChatPharoClient
		  name: 'get_class_subclasses'
		  description: 'Gets the subclasses of each given class.'
		  parameters: (Dictionary
				   with: 'type' -> 'object'
				   with:
					   'properties' -> (Dictionary with: 'classes' -> (Dictionary
							     with: 'type' -> 'array'
							     with: 'items' -> (Dictionary with: 'type' -> 'string')
							     with: 'description' -> 'Names of the classes'))
				   with: 'required' -> #( 'classes' ))
		  block: [ :arguments |
		  self applyFunctionGetClassSubclasses: arguments ]
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> functionGetClassesInPackages [

	^ ChatPharoClient
		  name: 'get_classes_in_packages'
		  description: 'Gets the classes in each given package.'
		  parameters: (Dictionary
				   with: 'type' -> 'object'
				   with:
					   'properties' -> (Dictionary with: 'packages' -> (Dictionary
							     with: 'type' -> 'array'
							     with: 'items' -> (Dictionary with: 'type' -> 'string')
							     with: 'description' -> 'Names of the packages'))
				   with: 'required' -> #( 'packages' ))
		  block: [ :arguments |
		  self applyFunctionGetClassesInPackages: arguments ]
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> functionGetPackages [

	^ ChatPharoClient
		  name: 'get_packages'
		  description: 'Gets all of the packages.'
		  parameters: (Dictionary
				   with: 'type' -> 'object'
				   with: 'properties' -> Dictionary new
				   with: 'required' -> #(  ))
		  block: [ :arguments | self applyFunctionGetPackages: arguments ]
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> initializeWithEnvironment: env [

	browserEnvironment := env.
	tools := {
		         self functionGetPackages.
		         self functionGetClassesInPackages.
		         self functionGetClassDefinitions.
		         self functionGetClassComments.
		         self functionGetClassMethods.
		         self functionGetClassSubclasses.
		         self functionFindMethodsWithSubstring.
		ChatPharoClient toolCheckSyntax.
		         ChatPharoClient toolOpenPlayground }
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> methodsWithSubstring: substring cappedAt: maximumNumberOfMethods [

	| methods |
	methods := OrderedCollection new.
	self browserEnvironment methodsDo: [ :method |
			(method sourceCode includesSubstring: substring) ifTrue: [
					methods add: method.
					methods size = maximumNumberOfMethods ifTrue: [ ^ methods ] ] ].
	^ methods
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> packageNamed: packageName [
    "Find a package by exact or case-insensitive name.  
     Previous version stopped in the debugger (`self halt.`) and
     always exited at the first ^ — hence many tools never worked."

    | direct normalised |
    direct := self browserEnvironment
                 packageAt: packageName
                 ifAbsent: [ nil ].
    direct ifNotNil: [ ^ direct ].

    normalised := packageName asLowercase.
    ^ self browserEnvironment packages
            detect: [ :pkg | pkg name asLowercase = normalised ]
            ifNone: [ nil ]
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> response: resultKey collect: block forClassesNamed: classNames [

	| resultPerClass classesNotFound |
	resultPerClass := Dictionary new.
	classesNotFound := OrderedCollection new.

	classNames do: [ :className |
			(self classNamed: className)
				ifNotNil: [ :class |
				resultPerClass at: className put: (block value: class) ]
				ifNil: [ classesNotFound add: className ] ].

	^ Dictionary
		  with: resultKey -> resultPerClass
		  with:
		  'nonexistent_or_outside_scope_classes' -> classesNotFound asArray
]

{ #category : 'accessing' }
ChatPharoBrowserEnvironment >> tools [

	^ tools
]

{ #category : 'accessing' }
ChatPharoBrowserEnvironment >> tools: anObject [

	tools := anObject
]
