"
Lightweight **one-shot prompt model** used by pop-ups or modal dialogs.

* Stores a free-text buffer plus two callbacks: `onSubmit` and `onCancel`.
* No history, no agent – its only job is to forward the entered text to whoever opened the dialog.
* **Why** – avoids dragging the full chat infrastructure into places where you only need a quick prompt.
"
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
