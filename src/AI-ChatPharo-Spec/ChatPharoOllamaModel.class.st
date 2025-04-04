"
I contain the code needed to select one of the ollama models in on your computer
"
Class {
	#name : 'ChatPharoOllamaModel',
	#superclass : 'Class',
	#instVars : [
		'modelList',
		'selectedModel'
	],
	#category : 'AI-ChatPharo-Spec',
	#package : 'AI-ChatPharo-Spec'
}

{ #category : 'layout' }
ChatPharoOllamaModel >> getOllamaModelNames [
	"returns an array with one item per model. Each item has nested informations, and some arrays"
	| response  |
	
	response := ZnClient new get: 'http://localhost:11434/api/tags'.
	^ ((STONJSON fromString: response) at: 'models' )
		 collect: [ :model | model at: 'name' ]
]

{ #category : 'layout' }
ChatPharoOllamaModel >> ollamaModelSelect [
	"Add to ChatPharo a select ollama model"
	^ SpDropListPresenter new
			help: 'Select ollama model';
			items: self getOllamaModelNames;
			display: [ :e | e  ];
			whenSelectedItemChangedDo: [ :e | "Dummy"];
			yourself
		
]
