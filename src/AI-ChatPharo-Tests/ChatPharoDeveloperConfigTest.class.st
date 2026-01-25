Class {
	#name : 'ChatPharoDeveloperConfigTest',
	#superclass : 'TestCase',
	#instVars : [
		'oldZnClient',
		'cacheFile'
	],
	#category : 'AI-ChatPharo-Tests-Config',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Config'
}

{ #category : 'running' }
ChatPharoDeveloperConfigTest >> setUp [

	super setUp.
	oldZnClient := Smalltalk at: #ZnClient.
	Smalltalk at: #ZnClient put: ChatPharoDeveloperConfigZnClientStub.
	ChatPharoDeveloperConfigZnClientStub shouldFail: false.
	ChatPharoDeveloperConfigZnClientStub responseString: 'alpha\nBeta \n\nGamma'.
	ChatPharoDeveloperConfig reset.
	cacheFile := ChatPharoDeveloperConfig cacheFileReference.
	cacheFile deleteIfAbsent: [ ]
]

{ #category : 'running' }
ChatPharoDeveloperConfigTest >> tearDown [

	cacheFile deleteIfAbsent: [ ].
	ChatPharoDeveloperConfig reset.
	Smalltalk at: #ZnClient put: oldZnClient.
	super tearDown
]

{ #category : 'running' }
ChatPharoDeveloperConfigTest >> testCacheDurationIsOneHour [

	self assert: ChatPharoDeveloperConfig cacheDuration equals: (Duration hours: 1)
]

{ #category : 'running' }
ChatPharoDeveloperConfigTest >> testCleanTokenHandlesWhitespaceOnly [

	self assert: (ChatPharoDeveloperConfig cleanToken: '   ') equals: ''
]

{ #category : 'running' }
ChatPharoDeveloperConfigTest >> testCleanTokenTrimsAndLowercases [

	self assert: (ChatPharoDeveloperConfig cleanToken: '  AbC  ') equals: 'abc'
]

{ #category : 'running' }
ChatPharoDeveloperConfigTest >> testFetchDeveloperIdsWritesCacheFile [

	ChatPharoDeveloperConfig fetchDeveloperIds.
	self assert: cacheFile exists
]

{ #category : 'running' }
ChatPharoDeveloperConfigTest >> testLoadCachedDeveloperIdsReadsFile [

	cacheFile parent ensureCreateDirectory.
	cacheFile writeStreamDo: [ :stream |
		stream nextPutAll: 'Alpha'; cr; nextPutAll: ' Beta '; cr ].
	self assert: ChatPharoDeveloperConfig loadCachedDeveloperIds equals: (OrderedCollection with: 'alpha' with: 'beta')
]

{ #category : 'running' }
ChatPharoDeveloperConfigTest >> testLoadCachedDeveloperIdsReturnsEmptyWhenMissing [

	cacheFile deleteIfAbsent: [ ].
	self assert: ChatPharoDeveloperConfig loadCachedDeveloperIds isEmpty
]

{ #category : 'running' }
ChatPharoDeveloperConfigTest >> testParseDeveloperIdsReturnsEmptyForNil [

	self assert: (ChatPharoDeveloperConfig parseDeveloperIds: nil) isEmpty
]

{ #category : 'running' }
ChatPharoDeveloperConfigTest >> testVerifyDeveloperIdRejectsEmpty [

	self deny: (ChatPharoDeveloperConfig verifyDeveloperId: '')
]

{ #category : 'running' }
ChatPharoDeveloperConfigTest >> testVerifyDeveloperIdRejectsNil [

	self deny: (ChatPharoDeveloperConfig verifyDeveloperId: nil)
]
