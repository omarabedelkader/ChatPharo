"
Core sandbox execution engine for safely evaluating AI-generated code.
Provides:
* Process-based isolation with configurable timeout
* Code validation before execution (blocks dangerous patterns)
* File system restriction
* Comprehensive error handling
Usage:
```smalltalk
ChatPharoSandbox new
    timeout: 5000;
    restrictFileSystem: true;
    evaluate: '1 + 2'.
"
Class {
	#name : 'ChatPharoSandbox',
	#superclass : 'Object',
	#instVars : [
		'timeout',
		'restrictFileSystem',
		'restrictNetwork',
		'restrictSystemAccess',
		'blockedSelectors',
		'blockedClasses',
		'lastError',
		'lastResult',
		'executionLog'
	],
	#classInstVars : [
		'defaultBlockedSelectors',
		'defaultBlockedClasses'
	],
	#category : 'AI-ChatPharo-Sandbox',
	#package : 'AI-ChatPharo-Sandbox'
}

{ #category : 'accessing' }
ChatPharoSandbox class >> defaultBlockedClasses [
	"Classes that are blocked by default for security reasons"

	^ defaultBlockedClasses ifNil: [
		  defaultBlockedClasses := Set withAll: #(
			   "File system access"
			   FileStream
			   FileReference
			   FileLocator
			   File
			   FileDirectory
			   DiskStore
			   MemoryStore
			   "Process and system control"
			   OSProcess
			   OSPlatform
			   OSEnvironment
			   ExternalProcess
			   UnixProcess
			   LibC
			   "Image and snapshot operations"
			   SmalltalkImage
			   SourceFiles
			   MCWorkingCopy
			   "Low-level operations"
			   ExternalAddress
			   ExternalData
			   FFIExternalObject
			   "Socket and network primitives"
			   Socket
			   SocketStream ) ]
]

{ #category : 'accessing' }
ChatPharoSandbox class >> defaultBlockedSelectors [
	"Selectors that are blocked by default for security reasons"

	^ defaultBlockedSelectors ifNil: [
		  defaultBlockedSelectors := Set withAll: #(
			   "File operations"
			   writeStream
			   readStream
			   binaryWriteStream
			   binaryReadStream
			   openForWrite
			   openForAppend
			   delete
			   deleteIfAbsent:
			   deleteAll
			   ensureCreateDirectory
			   copyTo:
			   moveTo:
			   renameTo:
			   "Process control"
			   terminate
			   terminateActive
			   terminateRealActive
			   suspend
			   primitiveResume
			   fork
			   forkAt:
			   forkNamed:
			   newProcess
			   "System operations"
			   snapshot
			   snapshotAndQuit
			   quitPrimitive
			   quit
			   exit
			   exit:
			   primQuitNoSave
			   "Dangerous evaluation"
			   perform:
			   perform:with:
			   perform:withArguments:
			   perform:with:with:
			   perform:with:with:with:
			   valueWithReceiver:arguments:
			   tryPrimitive:withArgs:
			   "Class manipulation"
			   removeFromSystem
			   removeFromSystemUnlogged
			   removeSelector:
			   compile:
			   compile:classified:
			   addInstVarNamed:
			   removeInstVarNamed:
			   "Global manipulation"
			   at:put:
			   removeKey:
			   removeKey:ifAbsent: ) ]
]

{ #category : 'accessing' }
ChatPharoSandbox class >> resetDefaults [
	"Reset cached default values"

	<script>
	defaultBlockedSelectors := nil.
	defaultBlockedClasses := nil
]

{ #category : 'accessing' }
ChatPharoSandbox class >> withDefaults [
	"Create a sandbox with default security settings"

	^ self new
		  useDefaults;
		  yourself
]

{ #category : 'adding' }
ChatPharoSandbox >> addBlockedClass: aClassName [
	"Add a class name (symbol) to the blocked list"

	blockedClasses add: aClassName asSymbol
]

{ #category : 'adding' }
ChatPharoSandbox >> addBlockedSelector: aSelector [
	"Add a selector to the blocked list"

	blockedSelectors add: aSelector asSymbol
]

{ #category : 'adding' }
ChatPharoSandbox >> blockedClasses [

	^ blockedClasses
]

{ #category : 'adding' }
ChatPharoSandbox >> blockedClasses: aCollection [

	blockedClasses := aCollection asSet
]

{ #category : 'adding' }
ChatPharoSandbox >> blockedSelectors [

	^ blockedSelectors
]

{ #category : 'adding' }
ChatPharoSandbox >> blockedSelectors: aCollection [

	blockedSelectors := aCollection asSet
]

{ #category : 'adding' }
ChatPharoSandbox >> buildSandboxedContext [
	"Build a restricted evaluation context"

	| context |
	context := Dictionary new.
	context at: #sandbox put: self.
	^ context
]
