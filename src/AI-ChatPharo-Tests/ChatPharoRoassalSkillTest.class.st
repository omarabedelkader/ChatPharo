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

{ #category : 'tests' }
ChatPharoRoassalSkillTest >> testContextStringIncludesRoassal [

	self assert: (skill contextString includesSubstring: 'Roassal')
]

{ #category : 'tests' }
ChatPharoRoassalSkillTest >> testContextStringIsNotEmpty [

	self assert: skill contextString isNotEmpty
]

{ #category : 'tests' }
ChatPharoRoassalSkillTest >> testDescriptionIsNotEmpty [

	self assert: skill description isNotEmpty
]

{ #category : 'tests' }
ChatPharoRoassalSkillTest >> testDescriptionMentionsRoassal [

	self assert: (skill description includesSubstring: 'Roassal')
]

{ #category : 'tests' }
ChatPharoRoassalSkillTest >> testKeywordsIncludeRSCanvas [

	self assert: (skill keywords includes: 'RSCanvas')
]

{ #category : 'tests' }
ChatPharoRoassalSkillTest >> testKeywordsIncludeRoassal [

	self assert: (skill keywords includes: 'Roassal')
]

{ #category : 'tests' }
ChatPharoRoassalSkillTest >> testKeywordsIsNotEmpty [

	self assert: skill keywords isNotEmpty
]

{ #category : 'tests' }
ChatPharoRoassalSkillTest >> testMatchesRSCanvasKeyword [

	self assert: (skill matchesKeywords: #('RSCanvas'))
]

{ #category : 'tests' }
ChatPharoRoassalSkillTest >> testMatchesRoassalKeyword [

	self assert: (skill matchesKeywords: #('Roassal'))
]

{ #category : 'tests' }
ChatPharoRoassalSkillTest >> testNameEqualsRoassal [

	self assert: skill name equals: 'Roassal'
]
