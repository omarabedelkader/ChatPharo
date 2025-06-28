Class {
	#name : 'ChatPharoSafetyAdvisor',
	#superclass : 'Object',
	#category : 'AI-ChatPharo-Safety',
	#package : 'AI-ChatPharo-Safety'
}

{ #category : 'as yet unclassified' }
ChatPharoSafetyAdvisor class >> confirmPromptModificationOn: aPresenter [ 

    ^ aPresenter confirm: self promptChangeMessage
]

{ #category : 'as yet unclassified' }
ChatPharoSafetyAdvisor class >> confirmToolDisableOn: aPresenter [ 

    ^ aPresenter confirm: self toolDisableMessage
]

{ #category : 'as yet unclassified' }
ChatPharoSafetyAdvisor class >> promptChangeMessage [ 

    ^ 'For optimal performance we recommend you to not change the prompt.\nAre you sure you want to modify it?'
]

{ #category : 'as yet unclassified' }
ChatPharoSafetyAdvisor class >> toolDisableMessage [ 

    ^ 'For optimal performance we recommend keeping all tools enabled.\nAre you sure you want to disable this tool?'
]
