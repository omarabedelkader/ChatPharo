Class {
	#name : 'ChatPharoTemporaryChat2',
	#superclass : 'Object',
	#instVars : [
		'text',
		'onSubmit',
		'onCancel'
	],
	#category : 'AI-ChatPharo2',
	#package : 'AI-ChatPharo2'
}

{ #category : 'accessing' }
ChatPharoTemporaryChat2 >> cancel [

    onCancel ifNotNil: [ onCancel value ]
]

{ #category : 'initialization' }
ChatPharoTemporaryChat2 >> initialize [ 

	super initialize.
	text := ''.
]

{ #category : 'accessing' }
ChatPharoTemporaryChat2 >> onCancel [

	^ onCancel
]

{ #category : 'accessing' }
ChatPharoTemporaryChat2 >> onCancel: anObject [

	onCancel := anObject
]

{ #category : 'accessing' }
ChatPharoTemporaryChat2 >> onSubmit [

	^ onSubmit
]

{ #category : 'accessing' }
ChatPharoTemporaryChat2 >> onSubmit: anObject [

	onSubmit := anObject
]

{ #category : 'accessing' }
ChatPharoTemporaryChat2 >> submit [ 

    onSubmit ifNotNil: [ onSubmit value: text ]
]

{ #category : 'accessing' }
ChatPharoTemporaryChat2 >> text [

	^ text
]

{ #category : 'accessing' }
ChatPharoTemporaryChat2 >> text: anObject [

	text := anObject
]
