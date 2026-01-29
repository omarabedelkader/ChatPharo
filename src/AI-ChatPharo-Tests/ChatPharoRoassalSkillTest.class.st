Class {
	#name : 'ChatPharoRoassalSkillTest',
	#superclass : 'TestCase',
	#instVars : [
		'skill'
	],
	#category : 'AI-ChatPharo-Tests-Skills',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Skills'
}

{ #category : 'running' }
ChatPharoRoassalSkillTest >> setUp [

	super setUp.
	skill := ChatPharoRoassalSkill new
]

{ #category : 'running' }
ChatPharoRoassalSkillTest >> tearDown [

	skill := nil.
	super tearDown
]

{ #category : 'running' }
ChatPharoRoassalSkillTest >> testContextStringIncludesRoassal [

	self assert: (skill contextString includesSubstring: 'Roassal')
]

{ #category : 'running' }
ChatPharoRoassalSkillTest >> testContextStringIsNotEmpty [

	self assert: skill contextString isNotEmpty
]

{ #category : 'running' }
ChatPharoRoassalSkillTest >> testDescriptionIsNotEmpty [

	self assert: skill description isNotEmpty
]

{ #category : 'running' }
ChatPharoRoassalSkillTest >> testDescriptionMentionsRoassal [

	self assert: (skill description includesSubstring: 'Roassal')
]

{ #category : 'running' }
ChatPharoRoassalSkillTest >> testKeywordsIncludeRSCanvas [

	self assert: (skill keywords includes: 'RSCanvas')
]

{ #category : 'running' }
ChatPharoRoassalSkillTest >> testKeywordsIncludeRoassal [

	self assert: (skill keywords includes: 'Roassal')
]

{ #category : 'running' }
ChatPharoRoassalSkillTest >> testKeywordsIsNotEmpty [

	self assert: skill keywords isNotEmpty
]

{ #category : 'running' }
ChatPharoRoassalSkillTest >> testMatchesRSCanvasKeyword [

	self assert: (skill matchesKeywords: #('RSCanvas'))
]

{ #category : 'running' }
ChatPharoRoassalSkillTest >> testMatchesRoassalKeyword [

	self assert: (skill matchesKeywords: #('Roassal'))
]

{ #category : 'running' }
ChatPharoRoassalSkillTest >> testNameEqualsRoassal [

	self assert: skill name equals: 'Roassal'
]
