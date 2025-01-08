Class {
	#name : 'OCodeLlamaModel',
	#superclass : 'OModel',
	#category : 'ChatPharo',
	#package : 'ChatPharo'
}

{ #category : 'accessing' }
OCodeLlamaModel class >> b13 [

	<ollamaInit: 'codellama:13b'>
	^ self new
		  tag: '13b';
		  yourself
]

{ #category : 'accessing' }
OCodeLlamaModel class >> b7 [

	<ollamaInit: 'codellama:7b'>
	^ self new
		  tag: '7b';
		  yourself
]

{ #category : 'accessing' }
OCodeLlamaModel class >> code [

	<ollamaInit: 'codellama:code'>
	^ self new
		  tag: 'code';
		  yourself
]

{ #category : 'accessing' }
OCodeLlamaModel class >> code7b [

	<ollamaInit: 'codellama:7b-code'>
	^ self new
		  tag: '7b-code';
		  yourself
]

{ #category : 'accessing' }
OCodeLlamaModel class >> codeLlama7binstructq3KS [

	<ollamaInit: 'codellama:7b-instruct-q3_K_S'>
	^ self new
		  tag: '7b-instruct-q3_K_S';
		  yourself
]

{ #category : 'accessing' }
OCodeLlamaModel class >> instruct7b [

	<ollamaInit: 'codellama:7b-instruct'>
	^ self new
		  tag: '7b-instruct';
		  yourself
]

{ #category : 'accessing' }
OCodeLlamaModel >> name [

	^ 'codellama'
]
