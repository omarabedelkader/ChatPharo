"
I'm a class that presents the option when the ChatPharo System Browser is activated
"
Class {
	#name : 'ChatPharoBrowserSystemPromptInputPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model',
		'textInput'
	],
	#category : 'AI-ChatPharo-Spec-Extentions',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Extentions'
}

{ #category : 'layout' }
ChatPharoBrowserSystemPromptInputPresenter >> defaultLayout [ 

    ^ SpBoxLayout newTopToBottom
        add: textInput;
        yourself
]

{ #category : 'initialization' }
ChatPharoBrowserSystemPromptInputPresenter >> initializePresenters [

	textInput := self newTextInput
		             placeholder: 'Browser system prompt...';
		             text: model agent browserSystemPrompt;
		             yourself.
	textInput whenTextChangedDo: [ :text |
			            (ChatPharoSafetyAdvisor confirmPromptModificationOn: self)
                    ifTrue: [
                            model agent browserSystemPrompt: text.
                            ChatPharoSettings setDefault: model.
                            ChatPharoSettings saveDefault ]
                    ifFalse: [ textInput text: model agent browserSystemPrompt ] ]
]

{ #category : 'initialization' }
ChatPharoBrowserSystemPromptInputPresenter >> setModelBeforeInitialization: anObject [ 

    model := anObject
]
