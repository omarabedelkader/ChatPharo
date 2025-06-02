Class {
	#name : 'ChatPharoNullAgent',
	#superclass : 'ChatPharoAgent',
	#category : 'AI-ChatPharo-Agent',
	#package : 'AI-ChatPharo-Agent'
}

{ #category : 'api' }
ChatPharoNullAgent class >> displayName [
	^ 'None (offline)'
]

{ #category : 'api' }
ChatPharoNullAgent class >> isReachable [ 

    ^ true "always reachable"
]

{ #category : 'api' }
ChatPharoNullAgent class >> modelNames [ 

    ^ #()  "returns an empty collection"
]

{ #category : 'api' }
ChatPharoNullAgent class >> settingsPresenterFor: anAgent [
	^ nil   "Nothing to configure"
]

{ #category : 'initialization' }
ChatPharoNullAgent >> getResponseForPrompt: aString [
	"Do absolutely nothing and return nil or an empty string."

	^ ' No backend is configured. Open Settings → API and choose an API first.'
]

{ #category : 'initialization' }
ChatPharoNullAgent >> modelInformation [ 

    ^ 'No model selected yet'
]
