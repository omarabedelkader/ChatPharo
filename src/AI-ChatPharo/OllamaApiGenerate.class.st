"
I contain the code needed to select one of the ollama models in on your computer.
I should be made a SpPresenter subclass (as the other aspects)
"
Class {
	#name : 'OllamaApiGenerate',
	#superclass : 'Ollama',
	#instVars : [
		'modelList'
	],
	#category : 'AI-ChatPharo-Ullama',
	#package : 'AI-ChatPharo',
	#tag : 'Ullama'
}

{ #category : 'initialization' }
OllamaApiGenerate >> initialize [ 
	super initialize.
	modelList := Ollama modelNames.
	self model: modelList first.
]

{ #category : 'layout' }
OllamaApiGenerate >> ollamaModelSelect [
	"Add to ChatPharo a select ollama model"
	^ SpDropListPresenter new
			help: 'Select ollama model';
			items: Ollama modelNames;
			display: [ :e | e  ];
			whenSelectedItemChangedDo: [ :e | self model: e];
			yourself
		
]
