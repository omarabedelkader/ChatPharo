"
Handles developer ID verification by fetching authorized IDs from a remote server.
* Fetches developer tokens from https://omarabedelkader.github.io/ChatPharo/idtoken.txt
* Validates if a given token is in the list of authorized developers
* Caches the token list locally for offline verification
* **Why** – separates developer verification logic from settings and UI concerns.
```smalltalk
ChatPharoDeveloperConfig verifyDeveloperId: 'some-token'.
ChatPharoDeveloperConfig fetchDeveloperIds.
"
Class {
	#name : 'ChatPharoDeveloperConfig',
	#superclass : 'Object',
	#instVars : [
		'cachedDeveloperIds',
		'lastFetchTime'
	],
	#classInstVars : [
		'cachedDeveloperIds',
		'lastFetchTime'
	],
	#category : 'AI-ChatPharo',
	#package : 'AI-ChatPharo'
}

{ #category : 'accessing' }
ChatPharoDeveloperConfig class >> cacheDuration [
	"How long to cache developer IDs before refetching (1 hour)."

	^ Duration hours: 1
]

{ #category : 'accessing' }
ChatPharoDeveloperConfig class >> cacheFileReference [
	"Return the file reference for caching developer IDs locally."

	^ ChatPharoSettings settingsDirectory / 'developer-ids-cache.txt'
]

{ #category : 'accessing' }
ChatPharoDeveloperConfig class >> cleanToken: aString [
	"Clean a token string by removing whitespace and converting to lowercase."

	^ aString trimBoth asLowercase
]

{ #category : 'accessing' }
ChatPharoDeveloperConfig class >> developerIdsUrl [
	"Return the URL for fetching authorized developer IDs."

	^ 'https://github.com/omarabedelkader/omarabedelkader.github.io/blob/main/idtoken.txt'
]

{ #category : 'accessing' }
ChatPharoDeveloperConfig class >> fetchDeveloperIds [
	"Fetch the list of authorized developer IDs from the remote server.
	Returns a collection of ID strings, or an empty collection on error."

	| response ids |
	[
		response := ZnClient new
			url: self developerIdsUrl;
			timeout: 10;
			get.
		ids := self parseDeveloperIds: response.
		self saveCacheLocally: ids.
		cachedDeveloperIds := ids.
		lastFetchTime := DateAndTime now.
		ChatPharoLogger logSystem: 'Developer IDs fetched'
			details: (Dictionary new
				at: 'count' put: ids size;
				yourself).
		^ ids
	] on: Error do: [ :e |
		ChatPharoLogger logSystem: 'Developer IDs fetch failed'
			details: (Dictionary new
				at: 'error' put: e messageText;
				yourself).
		^ self loadCachedDeveloperIds
	]
]

{ #category : 'accessing' }
ChatPharoDeveloperConfig class >> getDeveloperIds [
	"Get developer IDs, either from cache or by fetching if cache is stale."

	| shouldRefetch |
	shouldRefetch := cachedDeveloperIds isNil or: [
		lastFetchTime isNil or: [
			(DateAndTime now - lastFetchTime) > self cacheDuration ] ].

	shouldRefetch
		ifTrue: [ ^ self fetchDeveloperIds ]
		ifFalse: [ ^ cachedDeveloperIds ]
]

{ #category : 'accessing' }
ChatPharoDeveloperConfig class >> loadCachedDeveloperIds [
	"Load developer IDs from local cache file."

	| cacheFile |
	cacheFile := self cacheFileReference.
	cacheFile exists ifFalse: [ ^ OrderedCollection new ].

	^ [
		| content |
		content := cacheFile readStreamDo: [ :stream | stream contents ].
		self parseDeveloperIds: content
	] on: Error do: [ OrderedCollection new ]
]

{ #category : 'accessing' }
ChatPharoDeveloperConfig class >> parseDeveloperIds: aString [
	"Parse a string containing developer IDs (one per line) into a collection."

	| ids |
	aString ifNil: [ ^ OrderedCollection new ].

	ids := OrderedCollection new.
	(aString lines) do: [ :line |
		| cleaned |
		cleaned := self cleanToken: line.
		cleaned ifNotEmpty: [ ids add: cleaned ] ].
	^ ids
]

{ #category : 'accessing' }
ChatPharoDeveloperConfig class >> reset [
	"Reset the cached developer IDs."

	<script>
	cachedDeveloperIds := nil.
	lastFetchTime := nil
]

{ #category : 'accessing' }
ChatPharoDeveloperConfig class >> saveCacheLocally: ids [
	"Save the developer IDs to a local cache file."

	| cacheFile |
	cacheFile := self cacheFileReference.
	cacheFile parent ensureCreateDirectory.

	[ cacheFile writeStreamDo: [ :stream |
		ids do: [ :id | stream nextPutAll: id; cr ] ]
	] on: Error do: [ "Ignore cache write errors" ]
]

{ #category : 'accessing' }
ChatPharoDeveloperConfig class >> verifyDeveloperId: aString [
	"Verify if the given developer ID is in the list of authorized developers.
	Returns true if authorized, false otherwise."

	| cleanedInput ids |
	aString ifNil: [ ^ false ].
	aString isEmpty ifTrue: [ ^ false ].

	cleanedInput := self cleanToken: aString.
	ids := self getDeveloperIds.

	^ ids anySatisfy: [ :id | id = cleanedInput ]
]

{ #category : 'accessing' }
ChatPharoDeveloperConfig class >> verifyDeveloperIdAsync: aString onComplete: aBlock [
	"Verify developer ID asynchronously. Calls aBlock with true/false result."

	[ | result |
		result := self verifyDeveloperId: aString.
		aBlock value: result
	] fork
]
