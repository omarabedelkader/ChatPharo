Class {
	#name : 'ChatPharoBlocSkillTest',
	#superclass : 'TestCase',
	#instVars : [
		'skill'
	],
	#category : 'AI-ChatPharo-Tests-Skills',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Skills'
}

{ #category : 'running' }
ChatPharoBlocSkillTest >> setUp [

	super setUp.
	skill := ChatPharoBlocSkill new
]

{ #category : 'running' }
ChatPharoBlocSkillTest >> tearDown [

	skill := nil.
	super tearDown
]

{ #category : 'running' }
ChatPharoBlocSkillTest >> testContextStringIncludesBloc [

	self assert: (skill contextString includesSubstring: 'Bloc')
]

{ #category : 'running' }
ChatPharoBlocSkillTest >> testContextStringIsNotEmpty [

	self assert: skill contextString isNotEmpty
]

{ #category : 'running' }
ChatPharoBlocSkillTest >> testDescriptionIsNotEmpty [

	self assert: skill description isNotEmpty
]

{ #category : 'running' }
ChatPharoBlocSkillTest >> testDescriptionMentionsBloc [

	self assert: (skill description includesSubstring: 'Bloc')
]

{ #category : 'running' }
ChatPharoBlocSkillTest >> testKeywordsIncludeBlElement [

	self assert: (skill keywords includes: 'BlElement')
]

{ #category : 'running' }
ChatPharoBlocSkillTest >> testKeywordsIncludeBloc [

	self assert: (skill keywords includes: 'Bloc')
]

{ #category : 'running' }
ChatPharoBlocSkillTest >> testKeywordsIsNotEmpty [

	self assert: skill keywords isNotEmpty
]

{ #category : 'running' }
ChatPharoBlocSkillTest >> testMatchesBlElementKeyword [

	self assert: (skill matchesKeywords: #('BlElement'))
]

{ #category : 'running' }
ChatPharoBlocSkillTest >> testMatchesBlocKeyword [

	self assert: (skill matchesKeywords: #('Bloc'))
]

{ #category : 'running' }
ChatPharoBlocSkillTest >> testNameEqualsBloc [

	self assert: skill name equals: 'Bloc'
]
