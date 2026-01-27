"
Concrete agent for a **local Ollama server**.

* Connectivity helpers ping `http://localhost:11434`.
* Discovers available models via `/api/tags`, asks completions via `/api/generate`, shows model metadata via `/api/show`.
* Uses JSON directly, not `ChatPharoTool`, because the Ollama REST schema is simpler.
* **Why** – wraps the Ollama CLI/daemon behind the polymorphic `ChatPharoAgent` façade so the rest of ChatPharo can treat it exactly like any cloud model.
"
Class {
	#name : 'ChatPharoOllamaAgent',
	#superclass : 'ChatPharoAgent',
	#instVars : [
		'host',
		'port',
		'temperature',
		'packageName'
	],
	#category : 'AI-ChatPharo-Agent',
	#package : 'AI-ChatPharo-Agent'
}

{ #category : 'initialization' }
ChatPharoOllamaAgent class >> defaultHost [ 

    ^ 'localhost'
]

{ #category : 'initialization' }
ChatPharoOllamaAgent class >> defaultPort [ 

    ^ '11434'
]

{ #category : 'api' }
ChatPharoOllamaAgent class >> deleteModel: aModelName [

	self isReachable ifFalse: [
		^ self error: 'Ollama server not reachable' ].
	self validateModel: aModelName.

	^ [
		  ZnClient new
			  url:
				  'http://' , self defaultHost , ':' , self defaultPort
				  , '/api/delete';
			  entity: (ZnEntity with:
						   (STONJSON toString: { (#model -> aModelName) } asDictionary));
			  contentType: 'application/json';
			  delete;
			  yourself.
		  true ]
		  on: ZnHttpUnsuccessful , NetworkError
		  do: [ false ]
]

{ #category : 'api' }
ChatPharoOllamaAgent class >> displayName [

	^ 'Ollama'
]

{ #category : 'api' }
ChatPharoOllamaAgent class >> isReachable [
	[
		ZnClient new get:
			'http://' , self defaultHost , ':' , self defaultPort
			, '/api/version' ]
		on: NetworkError
		do: [ ^ false ].
	^ true
]

{ #category : 'api' }
ChatPharoOllamaAgent class >> isValidModel: aModelName [ 

    self isReachable ifFalse: [ ^ false ].
    ^ [
        ZnClient new
            url: 'http://' , self defaultHost , ':' , self defaultPort , '/api/show';
            entity: (ZnEntity with:
                                 (STONJSON toString: { (#model -> aModelName) } asDictionary));
            post;
            yourself.
        true
    ] on: ZnHttpUnsuccessful, NetworkError do: [ false ]
]

{ #category : 'api' }
ChatPharoOllamaAgent class >> modelNames [

	^ self models collect: [ :ollamaModel | ollamaModel at: 'name' ]
]

{ #category : 'api' }
ChatPharoOllamaAgent class >> models [
	| response |
	self isReachable ifFalse: [ ^ OrderedCollection empty ].
	response := ZnClient new get:
		            'http://' , self defaultHost , ':' , self defaultPort
		            , '/api/tags'.
	^ (STONJSON fromString: response) at: 'models'
]

{ #category : 'api' }
ChatPharoOllamaAgent class >> newSystem: synstemText promptPrefix: promptPrefixText [

	| prompter |
	prompter := self new.
	prompter systemPrompt: synstemText.
	prompter promptPrefix: promptPrefixText.
	^ prompter
]

{ #category : 'api' }
ChatPharoOllamaAgent class >> ollamaVersion [

	| response |
	response := ZnClient new get:
		            'http://' , self defaultHost , ':' , self defaultPort
		            , '/api/version'.
	^ (STONJSON fromString: response) at: 'version'
]

{ #category : 'api' }
ChatPharoOllamaAgent class >> pullModel: aModelName [

	self isReachable ifFalse: [
		^ self error: 'Ollama server not reachable' ].

	^ [ ZnClient new
		url: 'http://' , self defaultHost , ':' , self defaultPort , '/api/pull';
		entity: (ZnEntity with: (STONJSON toString: { (#name -> aModelName) } asDictionary));
		post;
		yourself.
	] on: ZnHttpUnsuccessful, NetworkError do: [ :ex |
		^ self error: 'Error pulling model: ' , ex messageText , '. Please verify the model name.' 
	].


]

{ #category : 'api' }
ChatPharoOllamaAgent class >> settingsPresenterFor: anAgent [

	^ ChatPharoOllamaSettingsPresenter on: anAgent
]

{ #category : 'api' }
ChatPharoOllamaAgent class >> validateModel: aModelName [

    (self isValidModel: aModelName) ifFalse: [
        ^ self error: 'Invalid model name or model does not exist on Ollama server' ].
]

{ #category : 'accessing' }
ChatPharoOllamaAgent >> configurationErrorMessage [

	^ 'Please complete all required fields.'
]

{ #category : 'initialization' }
ChatPharoOllamaAgent >> getResponseForPrompt: userPrompt [

	| api result params |
	api := ChatPharoTool ollamaWithSystem: self systemPrompt tools: self tools.
	self onToolExecution ifNotNil: [ api onToolExecution: self onToolExecution ].
	model ifNotEmpty: [ api model: model ].
	params := self requestParameters copy.
	temperature ifNotNil: [ params at: 'temperature' put: temperature ].
	api requestParameters: params.
	self history ifNil: [ self history: ChatPharoHistory new ].
	self history addMessage: (ChatPharoHistorySaver role: 'user' content: userPrompt).
	result := api getResponseForHistory: self history.
	self history addMessage: result.

	[ result toolCalls notNil ] whileTrue: [
			result := api getResponseForHistory: self history.
			self history addMessage: result ].
	^ result content
]

{ #category : 'accessing' }
ChatPharoOllamaAgent >> host [

	^ host
]

{ #category : 'accessing' }
ChatPharoOllamaAgent >> host: anObject [

	host := anObject
]

{ #category : 'initialization' }
ChatPharoOllamaAgent >> initialize [

	super initialize.
	host := self class defaultHost.
	port := self class defaultPort.
	temperature := 0.0.
	self model ifNil: [
			| availableModels |
			availableModels := self class modelNames.

			availableModels isEmpty ifFalse: [
				self model: availableModels first ] ].

	self systemPrompt: self class defaultSystemPrompt.
	self promptPrefix: ''.
	packageName := ''
]

{ #category : 'accessing' }
ChatPharoOllamaAgent >> isConfigured [ 

        ^ host notEmpty and: [ port notEmpty and: [ model notEmpty ] ]
]

{ #category : 'tools support' }
ChatPharoOllamaAgent >> modelDetailsForToolSupport [
	"Fetch model details from Ollama API to check for tool support.
	Returns a dictionary with model info or nil on error."

	| url |
	model ifEmpty: [ ^ nil ].
	self class isReachable ifFalse: [ ^ nil ].
	url := 'http://' , host , ':' , port , '/api/show'.
	^ [
	  | response |
	  response := ZnClient new
		              url: url;
		              entity: (ZnEntity with:
					               (STONJSON toString:
							                { (#model -> model) } asDictionary));
		              post;
		              contents.
	  STONJSON fromString: response ]
		  on: Error
		  do: [ nil ]
]

{ #category : 'initialization' }
ChatPharoOllamaAgent >> modelInformation [

	| url jsonResponse |
	url := 'http://' , host , ':' , port , '/api/show'.
	jsonResponse := ZnClient new
		                url: url;
		                entity: (ZnEntity with:
					                 (STONJSON toString:
							                  { (#model -> model) } asDictionary));
		                post;
		                contents.
	^ (STONJSON fromString: jsonResponse) at: 'contents'
]

{ #category : 'api' }
ChatPharoOllamaAgent >> modelNames [

	^ self class modelNames
]

{ #category : 'accessing' }
ChatPharoOllamaAgent >> packageName: aString [ 
packageName := aString.
	self systemPrompt: (self browserSystemPrompt
			 copyReplaceAll: '{packageName}'
			 with: packageName)
]

{ #category : 'accessing' }
ChatPharoOllamaAgent >> port [

	^ port
]

{ #category : 'accessing' }
ChatPharoOllamaAgent >> port: anObject [

	port := anObject
]

{ #category : 'tools support' }
ChatPharoOllamaAgent >> supportsToolCalling [
	"Check if the current Ollama model supports tool calling.
	Uses model details from /api/show endpoint to detect capabilities.
	Falls back to checking known model families that support tools."

	| details family modelNameLower toolSupportingFamilies |
	model ifEmpty: [ ^ false ].

	"Try to get model details from API"
	details := self modelDetailsForToolSupport.
	details ifNil: [ ^ false ].

	"Check if details contains explicit capabilities (newer Ollama versions)"
	(details includesKey: 'capabilities') ifTrue: [
		| capabilities |
		capabilities := details at: 'capabilities'.
		(capabilities isCollection and: [ capabilities includes: 'tools' ])
			ifTrue: [ ^ true ] ].

	"Fall back to checking model family from details"
	(details includesKey: 'details') ifTrue: [
		| modelDetails |
		modelDetails := details at: 'details'.
		(modelDetails includesKey: 'family') ifTrue: [
			family := (modelDetails at: 'family') asLowercase.
			toolSupportingFamilies := #( 'llama' 'qwen2' 'qwen' 'mistral' 'mixtral'
			                             'command-r' 'gemma2' 'phi3' 'hermes' 'firefunction' ).
			(toolSupportingFamilies anySatisfy: [ :f | family includesSubstring: f ])
				ifTrue: [ ^ true ] ] ].

	"Last resort: check model name pattern for known tool-capable models"
	modelNameLower := model asLowercase.
	(#( 'llama3.1' 'llama3.2' 'llama3.3' 'qwen2' 'qwen2.5' 'mistral-nemo'
	    'mistral-small' 'mistral-large' 'mixtral' 'command-r' 'gemma2'
	    'phi3' 'hermes3' 'firefunction' 'smollm2' 'granite3' 'athene' 'aya-expanse' )
		 anySatisfy: [ :pattern | modelNameLower includesSubstring: pattern ])
		ifTrue: [ ^ true ].

	"Default: assume no tool support for unknown models"
	^ false
]

{ #category : 'accessing' }
ChatPharoOllamaAgent >> temperature [

	^ temperature
]

{ #category : 'accessing' }
ChatPharoOllamaAgent >> temperature: anObject [

	temperature := anObject
]

{ #category : 'accessing' }
ChatPharoOllamaAgent >> testConnection [

	^ [
		ZnClient new get: 'http://' , host , ':' , port , '/api/version'.
		true ]
		on: ZnHttpUnsuccessful , NetworkError
		do: [ false ]
]

{ #category : 'accessing' }
ChatPharoOllamaAgent >> tools [

	 | available settings customToolClients |
    settings := ChatPharoSettings default.
    available := ChatPharoBrowserEnvironment new tools.
    available := available select: [ :tool |
        settings browserToolsEnabled includes: tool name ].
    "Add enabled custom tools"
    customToolClients := settings customToolsAsClients.
    ^ available , customToolClients
]
