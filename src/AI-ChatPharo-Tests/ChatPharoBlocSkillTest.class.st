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

{ #category : 'tests' }
ChatPharoBlocSkillTest >> testContextStringIsNotEmpty [

	self assert: skill contextString isNotEmpty
]

{ #category : 'tests' }
ChatPharoBlocSkillTest >> testContextStringIncludesBloc [

	self assert: (skill contextString includesSubstring: 'Bloc')
]

{ #category : 'tests' }
ChatPharoBlocSkillTest >> testDescriptionIsNotEmpty [

	self assert: skill description isNotEmpty
]

{ #category : 'tests' }
ChatPharoBlocSkillTest >> testDescriptionMentionsBloc [

	self assert: (skill description includesSubstring: 'Bloc')
]

{ #category : 'tests' }
ChatPharoBlocSkillTest >> testKeywordsIncludeBlElement [

	self assert: (skill keywords includes: 'BlElement')
]

{ #category : 'tests' }
ChatPharoBlocSkillTest >> testKeywordsIncludeBloc [

	self assert: (skill keywords includes: 'Bloc')
]

{ #category : 'tests' }
ChatPharoBlocSkillTest >> testKeywordsIsNotEmpty [

	self assert: skill keywords isNotEmpty
]

{ #category : 'tests' }
ChatPharoBlocSkillTest >> testMatchesBlElementKeyword [

	self assert: (skill matchesKeywords: #('BlElement'))
]

{ #category : 'tests' }
ChatPharoBlocSkillTest >> testMatchesBlocKeyword [

	self assert: (skill matchesKeywords: #('Bloc'))
]

{ #category : 'tests' }
ChatPharoBlocSkillTest >> testNameEqualsBloc [

	self assert: skill name equals: 'Bloc'
]
