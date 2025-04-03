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

{ #category : 'ollama models' }
ChatPharoOllamaModel class >> ollamaList [
	"Ask ollama for its list of model names, return them"
	| res |
	res := (LibC resultOfCommand: 'ollama list') lines allButFirst.
	^res collect: [:resItem | resItem copyUpToSubstring: ' ' ].
]

{ #category : 'layout' }
ChatPharoOllamaModel >> ollamaModelSelect [
	"Add to ChatPharo a select ollama model"
	^ SpDropListPresenter new
			help: 'Select ollama model';
			items: self class ollamaList;
			display: [ :e | e  ];
			whenSelectedItemChangedDo: [ :e | "Dummy"];
			yourself
		
]
