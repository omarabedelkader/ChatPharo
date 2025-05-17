Class {
	#name : 'ChatPharoTemporaryChat',
	#superclass : 'Object',
	#instVars : [
		'text',
		'onSubmit',
		'onCancel'
	],
	#category : 'AI-ChatPharo',
	#package : 'AI-ChatPharo'
}

{ #category : 'accessing' }
ChatPharoTemporaryChat >> cancel [

    onCancel ifNotNil: [ onCancel value ]
]

{ #category : 'initialization' }
ChatPharoTemporaryChat >> initialize [ 

	super initialize.
	text := ''.
]

{ #category : 'accessing' }
ChatPharoTemporaryChat >> onCancel [

	^ onCancel
]

{ #category : 'accessing' }
ChatPharoTemporaryChat >> onCancel: anObject [

	onCancel := anObject
]

{ #category : 'accessing' }
ChatPharoTemporaryChat >> onSubmit [

	^ onSubmit
]

{ #category : 'accessing' }
ChatPharoTemporaryChat >> onSubmit: anObject [

	onSubmit := anObject
]

{ #category : 'accessing' }
ChatPharoTemporaryChat >> submit [ 

    onSubmit ifNotNil: [ onSubmit value: text ]
]

{ #category : 'accessing' }
ChatPharoTemporaryChat >> text [

	^ text
]

{ #category : 'accessing' }
ChatPharoTemporaryChat >> text: anObject [

	text := anObject
]
