"
A **do-nothing placeholder** used when the user has not yet chosen a real backend.

* Always claims to be reachable and reports “no models”.
* `getResponseForPrompt:` answers a fixed string reminding the user to configure an API.
* **Why** – lets the rest of the application start and render its UI even when no LLM credentials are present; prevents accidental network calls.
"
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

	^ true 
]

{ #category : 'api' }
ChatPharoNullAgent class >> modelNames [

	^ #(  )
]

{ #category : 'api' }
ChatPharoNullAgent class >> settingsPresenterFor: anAgent [
 		anAgent ifNil: [ ^ nil ].
	^ ChatPharoNullSettingsPresenter on: anAgent
]

{ #category : 'initialization' }
ChatPharoNullAgent >> getResponseForPrompt: aString [

	^ ' No backend is configured. Open Settings → Configuration and select an API first.'
]

{ #category : 'initialization' }
ChatPharoNullAgent >> modelInformation [ 

    ^ 'No model selected yet'
]

{ #category : 'accessing' }
ChatPharoNullAgent >> testConnection [ 

        ^ true
]
