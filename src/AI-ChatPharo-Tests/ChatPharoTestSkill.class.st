Class {
	#name : 'ChatPharoTestSkill',
	#superclass : 'ChatPharoSkill',
	#instVars : [
		'registry'
	],
	#category : 'AI-ChatPharo-Tests-Mock',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Mock'
}

{ #category : 'accessing' }
ChatPharoTestSkill >> contextString [

	^ 'Test skill context.'
]

{ #category : 'accessing' }
ChatPharoTestSkill >> description [

	^ 'Test skill description.'
]

{ #category : 'accessing' }
ChatPharoTestSkill >> keywords [

	^ #('AlphaBeta' 'GammaTool')
]

{ #category : 'accessing' }
ChatPharoTestSkill >> name [

	^ 'TestSkill'
]
