"
I contain the code needed to select one of the ollama models in on your computer.
I should be made a SpPresenter subclass (as the other aspects)
"
Class {
	#name : 'ChatPharoOllamaModel',
	#superclass : 'Ollama',
	#instVars : [
		'modelList'
	],
	#category : 'AI-ChatPharo-Ullama',
	#package : 'AI-ChatPharo',
	#tag : 'Ullama'
}

{ #category : 'layout' }
ChatPharoOllamaModel >> getOllamaModelNames_old [
	"returns an array with one item per model."
	| modelResponse |
	
	modelResponse := ZnClient new get: 'http://localhost:11434/api/tags'.
	modelList := ((STONJSON fromString: modelResponse) at: 'models' )
		 collect: [ :item | item at: 'name' ].
	^ modelList
]

{ #category : 'initialization' }
ChatPharoOllamaModel >> initialize [ 
	super initialize.
	modelList := Ollama modelNames.
	self model: modelList first.
]

{ #category : 'layout' }
ChatPharoOllamaModel >> ollamaModelSelect [
	"Add to ChatPharo a select ollama model"
	^ SpDropListPresenter new
			help: 'Select ollama model';
			items: Ollama modelNames;
			display: [ :e | e  ];
			whenSelectedItemChangedDo: [ :e | self model: e];
			yourself
		
]

{ #category : 'layout' }
ChatPharoOllamaModel >> setOllamaModel_old: selectedModel [
	"Sets the selected model"
	model := selectedModel.
	
]
