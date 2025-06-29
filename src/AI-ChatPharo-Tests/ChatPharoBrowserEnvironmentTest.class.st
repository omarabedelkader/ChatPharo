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
ChatPharoBrowserEnvironmentTest >> testGetPackagesIncludesSelfPackage [ 

   | reply |
   reply := env applyFunctionGetPackages: Dictionary new.
   self assert: ((reply at:'packages') includes: 'AI-ChatPharo').
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
