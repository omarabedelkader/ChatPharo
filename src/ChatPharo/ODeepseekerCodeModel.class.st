Class {
	#name : 'ODeepseekerCodeModel',
	#superclass : 'OModel',
	#category : 'ChatPharo-API',
	#package : 'ChatPharo',
	#tag : 'API'
}

{ #category : 'as yet unclassified' }
ODeepseekerCodeModel class >> b33 [

	<ollamaInit: 'deepseek-coder:33b'>
	^ self new
		  tag: '33b';
		  yourself
]

{ #category : 'as yet unclassified' }
ODeepseekerCodeModel class >> b6 [

	<ollamaInit: 'deepseek-coder:6.7b'>
	^ self new
		  tag: '6.7b';
		  yourself
]

{ #category : 'accessing' }
ODeepseekerCodeModel >> name [

	^ 'deepseek-coder'
]
