Class {
	#name : 'ChatPharoMistralAgent',
	#superclass : 'ChatPharoAgent',
	#instVars : [
		'host',
		'apiKey',
		'temperature'
	],
	#category : 'AI-ChatPharo-Agent',
	#package : 'AI-ChatPharo-Agent'
}

{ #category : 'api' }
ChatPharoMistralAgent class >> displayName [
	
	^ 'Mistral AI'	
]

{ #category : 'api' }
ChatPharoMistralAgent class >> isReachable [ 

    [ ZnClient new head: 'https://api.mistral.ai/v1/models'. true ]
        on: NetworkError do: [ false ]

]

{ #category : 'api' }
ChatPharoMistralAgent class >> modelNames [ 

    ^ #( 'Enter your API-Key' )
]

{ #category : 'api' }
ChatPharoMistralAgent class >> settingsPresenterFor: anAgent [ 

    ^ ChatPharoMistralSettingsPresenter on: anAgent
]
