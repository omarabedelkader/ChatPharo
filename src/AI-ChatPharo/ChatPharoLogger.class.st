Class {
	#name : 'ChatPharoLogger',
	#superclass : 'Object',
	#classInstVars : [
		'LogMutex'
	],
	#category : 'AI-ChatPharo',
	#package : 'AI-ChatPharo'
}

{ #category : 'class initialization' }
ChatPharoLogger class >> agentNameFor: anAgent [

    anAgent ifNil: [ ^ 'None' ].
    (anAgent class respondsTo: #displayName)
        ifTrue: [ ^ anAgent class displayName ].
    ^ anAgent class name
]

{ #category : 'class initialization' }
ChatPharoLogger class >> ensureMutex [

    LogMutex ifNil: [ LogMutex := Mutex new ].
    ^ LogMutex
]

{ #category : 'class initialization' }
ChatPharoLogger class >> initialize [

    LogMutex := Mutex new
]

{ #category : 'class initialization' }
ChatPharoLogger class >> logBackend: aDescription [

    self logBackend: aDescription details: nil
]

{ #category : 'class initialization' }
ChatPharoLogger class >> logBackend: aDescription details: details [

    self logCategory: 'BACKEND' description: aDescription details: details
]

{ #category : 'class initialization' }
ChatPharoLogger class >> logCategory: aCategory description: aDescription details: details [

    | entry |
    entry := String streamContents: [ :stream |
        stream
            nextPutAll: '[' , DateAndTime now asString , '] ';
            nextPutAll: '[' , aCategory asUppercase , '] ';
            nextPutAll: aDescription.
        details ifNotNil: [
            stream cr.
            self writeDetails: details on: stream ] ].
    self writeEntry: entry
]

{ #category : 'class initialization' }
ChatPharoLogger class >> logDirectory [

    ^ FileLocator imageDirectory / 'chatpharo'
]

{ #category : 'class initialization' }
ChatPharoLogger class >> logFile [

    ^ self logDirectory / 'log-chatpharo.txt'
]

{ #category : 'class initialization' }
ChatPharoLogger class >> logFrontend: aDescription [

    self logFrontend: aDescription details: nil
]

{ #category : 'class initialization' }
ChatPharoLogger class >> logFrontend: aDescription details: details [

    self logCategory: 'FRONTEND' description: aDescription details: details
]

{ #category : 'class initialization' }
ChatPharoLogger class >> logSystem: aDescription [

    self logSystem: aDescription details: nil
]

{ #category : 'class initialization' }
ChatPharoLogger class >> logSystem: aDescription details: details [

    self logCategory: 'SYSTEM' description: aDescription details: details
]

{ #category : 'class initialization' }
ChatPharoLogger class >> stringify: anObject [

    anObject ifNil: [ ^ 'nil' ].
    (anObject respondsTo: #asString)
        ifTrue: [ ^ anObject asString ].
    ^ anObject printString
]

{ #category : 'class initialization' }
ChatPharoLogger class >> writeDetails: details on: aStream [

    aStream nextPutAll: '  Details:'; cr.
    (details respondsTo: #associationsDo)
        ifTrue: [
            details associationsDo: [ :association |
                aStream
                    nextPutAll: '    ';
                    nextPutAll: association key asString;
                    nextPutAll: ': ';
                    nextPutAll: (self stringify: association value);
                    cr ] ]
        ifFalse: [
            (details isCollection and: [ details isString not ])
                ifTrue: [
                    details do: [ :each |
                        aStream
                            nextPutAll: '    - ';
                            nextPutAll: (self stringify: each);
                            cr ] ]
                ifFalse: [
                    aStream
                        nextPutAll: '    ';
                        nextPutAll: (self stringify: details);
                        cr ] ]
]

{ #category : 'class initialization' }
ChatPharoLogger class >> writeEntry: anEntry [

    | directory file |
    self ensureMutex critical: [
        directory := self logDirectory.
        directory ensureCreateDirectory.
        file := self logFile.
        file ensureCreateFile.
        file writeStreamDo: [ :stream |
            stream setToEnd.
            stream
                nextPutAll: anEntry;
                nextPut: Character lf ] ]
]
