Class {
	#name : 'NullAgent',
	#superclass : 'Agent',
	#category : 'AI-ChatPharo2-Agent',
	#package : 'AI-ChatPharo2-Agent'
}

{ #category : 'api' }
NullAgent class >> displayName [
	^ 'None (offline)'
]

{ #category : 'api' }
NullAgent class >> isReachable [ 

    ^ true "always reachable"
]

{ #category : 'api' }
NullAgent class >> modelNames [ 

    ^ #()  "returns an empty collection"
]

{ #category : 'api' }
NullAgent class >> settingsPresenterFor: anAgent [
	^ nil   "Nothing to configure"
]

{ #category : 'initialization' }
NullAgent >> getResponseForPrompt: aString [
	"Do absolutely nothing and return nil or an empty string."

	^ ' No backend is configured. Open Settings → API and choose an API first.'
]

{ #category : 'initialization' }
NullAgent >> modelInformation [ 

    ^ 'No model selected yet'
]
