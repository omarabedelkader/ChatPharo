Class {
	#name : 'ChatPharoTestSkill',
	#superclass : 'ChatPharoSkill',
	#instVars : [
		'registry'
	],
	#category : 'AI-ChatPharo-Tests-Skills',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Skills'
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
