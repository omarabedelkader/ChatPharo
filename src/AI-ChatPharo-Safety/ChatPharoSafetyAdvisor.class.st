Class {
	#name : 'ChatPharoSafetyAdvisor',
	#superclass : 'Object',
	#category : 'AI-ChatPharo-Safety',
	#package : 'AI-ChatPharo-Safety'
}

{ #category : 'safety' }
ChatPharoSafetyAdvisor class >> confirmMaxIterationsOn: aPresenter [

    ^ aPresenter confirm: self maxIterationsMessage
]

{ #category : 'safety' }
ChatPharoSafetyAdvisor class >> confirmPromptModificationOn: aPresenter [ 

    ^ aPresenter confirm: self promptChangeMessage
]

{ #category : 'safety' }
ChatPharoSafetyAdvisor class >> confirmToolDisableOn: aPresenter [ 

    ^ aPresenter confirm: self toolDisableMessage
]

{ #category : 'safety' }
ChatPharoSafetyAdvisor class >> maxIterationsMessage [

    ^ 'Maximum iterations must be at least 1.\nSet value to 1?'
]

{ #category : 'safety' }
ChatPharoSafetyAdvisor class >> promptChangeMessage [ 

    ^ 'For optimal performance we recommend you to not change the prompt.\nAre you sure you want to modify it?'
]

{ #category : 'safety' }
ChatPharoSafetyAdvisor class >> toolDisableMessage [ 

    ^ 'For optimal performance we recommend keeping all tools enabled.\nAre you sure you want to disable this tool?'
]
