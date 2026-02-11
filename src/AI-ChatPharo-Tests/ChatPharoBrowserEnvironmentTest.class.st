Class {
	#name : 'ChatPharoBrowserEnvironmentTest',
	#superclass : 'TestCase',
	#instVars : [
		'env'
	],
	#category : 'AI-ChatPharo-Tests-Env',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Env'
}

{ #category : 'running' }
ChatPharoBrowserEnvironmentTest >> setUp [ 
   super setUp.
   env := ChatPharoBrowserEnvironment new.

]

{ #category : 'running' }
ChatPharoBrowserEnvironmentTest >> testClassLookupIsCaseInsensitive [ 

   self assert: (env classNamed: 'string') == String.
]

{ #category : 'running' }
ChatPharoBrowserEnvironmentTest >> testClassLookupReturnsNilForUnknown [ 

    self assert: (env classNamed: 'NoSuchClass') isNil.
]

{ #category : 'running' }
ChatPharoBrowserEnvironmentTest >> testClassesInPackageNamedReturnsClasses [ 

    | classes |
    classes := env classesInPackageNamed: 'AI-ChatPharo'.
    self assert: classes notEmpty.
]

{ #category : 'running' }
ChatPharoBrowserEnvironmentTest >> testDescribePackageReturnsSummary [

    | reply |
    reply := env applyFunctionDescribePackage:
                (Dictionary with: 'package' -> 'AI-ChatPharo').
    self assert: ((reply at: 'summary_per_class') keys notEmpty).
]

{ #category : 'running' }
ChatPharoBrowserEnvironmentTest >> testFindMethodsWithSubstringCapsAt50 [ 

   | reply |
   reply := env applyFunctionFindMethodsWithSubstring:
               (Dictionary with:'substring'->'initialize').
   self assert: (reply at:'methods') size <= 50.
]

{ #category : 'running' }
ChatPharoBrowserEnvironmentTest >> testGetClassCommentsIncludesKey [ 

    | reply |
    reply := env applyFunctionGetClassComments:
        (Dictionary with: 'classes' -> (Array with: 'String')).
    self assert: ((reply at: 'comment_per_class') includesKey: 'String').
]

{ #category : 'running' }
ChatPharoBrowserEnvironmentTest >> testGetClassDefinitionsIncludesSuperclassAndPackage [ 

    | reply def |
    reply := env applyFunctionGetClassDefinitions:
                (Dictionary with: 'classes' -> (Array with: 'ChatPharoChat')).
    def := (reply at: 'definition_per_class') at: 'ChatPharoChat'.
    self assert: (def at: 'superclass') equals: 'Object'.
    self assert: (def at: 'package') equals: 'AI-ChatPharo'.

]

{ #category : 'running' }
ChatPharoBrowserEnvironmentTest >> testGetClassMethodsSelectorsOnly [

    | reply methods |
    reply := env applyFunctionGetClassMethods:
                (Dictionary with: 'classes' -> (Array with: 'ChatPharoChat') with: 'selectors_only' -> true).
    methods := ((reply at: 'selectors_per_protocol_per_side_per_class')
                at: 'ChatPharoChat') at: 'instance'.
    self assert: methods notEmpty.
]

{ #category : 'running' }
ChatPharoBrowserEnvironmentTest >> testGetClassSubclassesEmptyForLeafClass [

    | reply subclasses |
    reply := env applyFunctionGetClassSubclasses:
                (Dictionary with: 'classes' -> (Array with: 'ChatPharoChat')).
    subclasses := (reply at: 'subclasses_per_class') at: 'ChatPharoChat'.
    self assert: subclasses isEmpty.
]

{ #category : 'running' }
ChatPharoBrowserEnvironmentTest >> testGetPackagesIncludesSelfPackage [ 

   | reply |
   reply := env applyFunctionGetPackages: Dictionary new.
   self assert: ((reply at:'packages') includes: 'AI-ChatPharo').
]

{ #category : 'running' }
ChatPharoBrowserEnvironmentTest >> testNormalizeLineEndingsToCrConvertsLfAndCrlf [

    | source normalized |
    source := 'first', String lf, 'second', String crlf, 'third'.
    normalized := env normalizeLineEndingsToCr: source.

    self assert: normalized equals: 'first', String cr, 'second', String cr, 'third'.
]

{ #category : 'running' }
ChatPharoBrowserEnvironmentTest >> testPackageNamedCaseInsensitive [ 

    self assert: (env packageNamed: 'ai-chatpharo') notNil.
]

{ #category : 'running' }
ChatPharoBrowserEnvironmentTest >> testPackageNamedReturnsNilForUnknown [ 

    self assert: (env packageNamed: 'UnknownPackage') isNil.
]

{ #category : 'running' }
ChatPharoBrowserEnvironmentTest >> testToolsIncludeCheckSyntax [ 

    self assert: (env tools anySatisfy: [ :tool | tool name = 'check_syntax' ]).
]
