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
ChatPharoBrowserEnvironment >> applyFunctionDescribePackage: arguments [

        | packageName classes |
        packageName := arguments at: 'package'.
        classes := self classesInPackageNamed: packageName.

        classes ifNil: [
                ^ Dictionary
                          with: 'summary_per_class' -> Dictionary new
                          with:
                          'nonexistent_or_outside_scope_packages'
                          -> (Array with: packageName) ].

        ^ Dictionary
                  with: 'summary_per_class'
                  -> (Dictionary newFrom:
                                (classes collect: [ :class |
                                        class name
                                                ->
                                                        (Dictionary
                                                                with:
                                                                'comment'
                                                                        -> class comment
                                                                with:
                                                                'instance_methods'
                                                                        -> (class selectors sorted)
                                                                with:
                                                                'class_methods'
                                                                        -> (class class selectors sorted) ) ]))
                  with:
                  'nonexistent_or_outside_scope_packages' -> #()
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

{ #category : 'as yet unclassified' }
ChatPharoBrowserEnvironment >> applyFunctionRenameClass: arguments [
	"Rename a single class using Pharo's modern refactoring engine."

	| oldName newName theClass refactoring |
	oldName := arguments at: 'old_name'.
	newName := arguments at: 'new_name'.

	"Validate the old class exists"
	theClass := self classNamed: oldName.
	theClass ifNil: [
		^ Dictionary with: 'error' -> ('Class not found: ' , oldName) ].

	"Validate new name is a valid class name"
	(newName isEmpty or: [ newName first isUppercase not ]) ifTrue: [
		^ Dictionary with: 'error' -> 'New class name must start with an uppercase letter' ].

	"Check if the new name is already taken"
	(Smalltalk globals includesKey: newName asSymbol) ifTrue: [
		^ Dictionary with: 'error' -> ('A class with name ' , newName , ' already exists') ].

	"Perform the refactoring"
	[
		refactoring := ReRenameClassRefactoring
			rename: theClass
			to: newName asSymbol.
		refactoring execute.

		^ Dictionary
			with: 'success' -> true
			with: 'old_name' -> oldName
			with: 'new_name' -> newName
			with: 'message' -> ('Successfully renamed ' , oldName , ' to ' , newName)
	] on: Error do: [ :error |
		^ Dictionary with: 'error' -> ('Refactoring failed: ' , error messageText) ]

]

{ #category : 'as yet unclassified' }
ChatPharoBrowserEnvironment >> applyFunctionRenameClassesInPackage: arguments [
	"Rename multiple classes in a package based on pattern matching."

	| packageName searchPattern replacePattern classes renamedClasses errors dryRun |
	packageName := arguments at: 'package'.
	searchPattern := arguments at: 'search_pattern'.
	replacePattern := arguments at: 'replace_pattern'.
	dryRun := arguments at: 'dry_run' ifAbsent: [ false ].

	"Validate package exists"
	classes := self classesInPackageNamed: packageName.
	classes ifNil: [
		^ Dictionary with: 'error' -> ('Package not found: ' , packageName) ].

	renamedClasses := OrderedCollection new.
	errors := OrderedCollection new.

	"Find classes matching the pattern and compute new names"
	classes do: [ :theClass |
		| oldName newName |
		oldName := theClass name asString.

		(oldName includesSubstring: searchPattern) ifTrue: [
			newName := oldName copyReplaceAll: searchPattern with: replacePattern.

			"Validate new name"
			(newName isEmpty or: [ newName first isUppercase not ])
				ifTrue: [
					errors add: (Dictionary
						with: 'old_name' -> oldName
						with: 'error' -> 'New name would not start with uppercase') ]
				ifFalse: [
					(Smalltalk globals includesKey: newName asSymbol)
						ifTrue: [
							errors add: (Dictionary
								with: 'old_name' -> oldName
								with: 'new_name' -> newName
								with: 'error' -> 'Target name already exists') ]
						ifFalse: [
							dryRun
								ifTrue: [
									renamedClasses add: (Dictionary
										with: 'old_name' -> oldName
										with: 'new_name' -> newName
										with: 'status' -> 'would_rename') ]
								ifFalse: [
									[
										| refactoring |
										refactoring := ReRenameClassRefactoring
											rename: theClass
											to: newName asSymbol.
										refactoring execute.

										renamedClasses add: (Dictionary
											with: 'old_name' -> oldName
											with: 'new_name' -> newName
											with: 'status' -> 'renamed')
									] on: Error do: [ :error |
										errors add: (Dictionary
											with: 'old_name' -> oldName
											with: 'new_name' -> newName
											with: 'error' -> error messageText) ] ] ] ] ] ].

^ (Dictionary new)
	at: 'package' put: packageName;
	at: 'search_pattern' put: searchPattern;
	at: 'replace_pattern' put: replacePattern;
	at: 'dry_run' put: dryRun;
	at: 'renamed_classes' put: renamedClasses asArray;
	at: 'errors' put: errors asArray;
	at: 'total_matched' put: (renamedClasses size + errors size);
	at: 'successful' put: renamedClasses size;
	yourself


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

{ #category : 'accessing' }
ChatPharoBrowserEnvironment >> functionDescribePackage [

        ^ ChatPharoClient
                  name: 'describe_package'
                  description:
                  'Returns each class in the given package with its comment and list of methods.'
                  parameters: (Dictionary
                                   with: 'type' -> 'object'
                                   with:
                                           'properties' -> (Dictionary with: 'package' -> (Dictionary
                                                             with: 'type' -> 'string'
                                                             with: 'description' -> 'Name of the package'))
                                   with: 'required' -> #( 'package' ))
                  block: [ :arguments |
                  self applyFunctionDescribePackage: arguments ]
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
ChatPharoBrowserEnvironment >> functionGetSandboxStatus [
	"Returns current sandbox configuration"

	^ ChatPharoClient
		  name: 'get_sandbox_status'
		  description:
		  'Gets the current sandbox security configuration. Use this to understand what restrictions are in place before executing code.'
		  parameters: (Dictionary
				   with: 'type' -> 'object'
				   with: 'properties' -> Dictionary new
				   with: 'required' -> #(  ))
		  block: [ :arguments |
				  | settings |
				  settings := ChatPharoSettings default.
				  Dictionary
					  with: 'sandbox_enabled' -> settings sandboxEnabled
					  with: 'timeout_ms' -> settings sandboxTimeout
					  with: 'restrict_file_system' -> settings sandboxRestrictFileSystem
					  with: 'restrict_network' -> settings sandboxRestrictNetwork
					  with: 'restrict_system_access' -> settings sandboxRestrictSystemAccess ]
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> functionRenameClass [
	"Tool to rename a single class using Pharo's Refactoring Browser."

	^ ChatPharoClient
		name: 'rename_class'
		description: 'Renames a class in the Pharo image. This will update all references to the class throughout the codebase. Use with care as this modifies the live system.'
		parameters: (Dictionary
			with: 'type' -> 'object'
			with: 'properties' -> (Dictionary
				with: 'old_name' -> (Dictionary
					with: 'type' -> 'string'
					with: 'description' -> 'The current name of the class to rename')
				with: 'new_name' -> (Dictionary
					with: 'type' -> 'string'
					with: 'description' -> 'The new name for the class (must start with uppercase)'))
			with: 'required' -> #( 'old_name' 'new_name' ))
		block: [ :arguments |
			self applyFunctionRenameClass: arguments ]
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> functionRenameClassesInPackage [
	"Tool to rename multiple classes in a package using pattern matching."

	^ ChatPharoClient
		name: 'rename_classes_in_package'
		description: 'Renames multiple classes in a package by replacing a substring pattern in their names. For example, replace "Old" with "New" to rename "OldFoo" to "NewFoo". Use dry_run=true first to preview changes. This modifies the live system.'
		parameters: (Dictionary
			with: 'type' -> 'object'
			with: 'properties' -> (Dictionary
				with: 'package' -> (Dictionary
					with: 'type' -> 'string'
					with: 'description' -> 'The name of the package containing the classes to rename')
				with: 'search_pattern' -> (Dictionary
					with: 'type' -> 'string'
					with: 'description' -> 'The substring to search for in class names')
				with: 'replace_pattern' -> (Dictionary
					with: 'type' -> 'string'
					with: 'description' -> 'The string to replace the search pattern with')
				with: 'dry_run' -> (Dictionary
					with: 'type' -> 'boolean'
					with: 'description' -> 'If true, only preview what would be renamed without actually performing the rename. Always use dry_run first to verify the changes.'))
			with: 'required' -> #( 'package' 'search_pattern' 'replace_pattern' ))
		block: [ :arguments |
			self applyFunctionRenameClassesInPackage: arguments ]
]

{ #category : 'initialization' }
ChatPharoBrowserEnvironment >> functionSandboxEvaluate [
	"Evaluates code in sandbox with explicit restrictions - always sandboxed regardless of global setting"

	^ ChatPharoClient
		  name: 'sandbox_evaluate'
		  description:
		  'Evaluates a Smalltalk expression in a sandboxed environment with timeout and security restrictions. Always runs in sandbox mode regardless of global settings. Use this for testing potentially risky code safely.'
		  parameters: (Dictionary
				   with: 'type' -> 'object'
				   with: 'properties' -> (Dictionary
						    with: 'expression' -> (Dictionary
								     with: 'type' -> 'string'
								     with:
								     'description'
								     -> 'The Smalltalk expression to evaluate')
						    with: 'timeout_ms' -> (Dictionary
								     with: 'type' -> 'integer'
								     with:
								     'description'
								     -> 'Optional timeout in milliseconds (default: 5000)'))
				   with: 'required' -> #( 'expression' ))
		  block: [ :arguments |
				  | expression sandbox result timeoutMs |
				  expression := arguments at: 'expression'.
				  timeoutMs := arguments at: 'timeout_ms' ifAbsent: [ 5000 ].

				  sandbox := ChatPharoSandbox withDefaults.
				  sandbox timeout: timeoutMs.

				  result := sandbox evaluate: expression.
				  result isSuccess
					  ifTrue: [
							  Dictionary
								  with: 'success' -> true
								  with: 'value' -> result value asString
								  with: 'sandboxed' -> true ]
					  ifFalse: [
							  result hasViolations
								  ifTrue: [
									  Dictionary
										  with: 'success' -> false
										  with: 'blocked' -> true
										  with: 'reason' -> result errorMessage
										  with: 'violations' -> result violations ]
								  ifFalse: [
									  Dictionary
										  with: 'success' -> false
										  with: 'error' -> result errorMessage ] ] ]
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
		         self functionDescribePackage.
		         "Refactoring tools"
		         self functionRenameClass.
		         self functionRenameClassesInPackage.
		         ChatPharoClient toolCheckSyntax.
		         ChatPharoClient toolCheckSyntax.
		         ChatPharoClient toolOpenPlayground.
		         self functionGetSandboxStatus.
		         self functionSandboxEvaluate } asOrderedCollection. "Add skill tools if enabled and the Skills package is loaded"
	(Smalltalk hasClassNamed: #ChatPharoSkillEnvironment) ifTrue: [
		tools addAll: (Smalltalk at: #ChatPharoSkillEnvironment) new tools ]
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
