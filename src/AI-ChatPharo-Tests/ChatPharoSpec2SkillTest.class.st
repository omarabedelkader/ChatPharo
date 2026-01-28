Class {
	#name : 'ChatPharoSpec2SkillTest',
	#superclass : 'TestCase',
	#instVars : [
		'skill'
	],
	#category : 'AI-ChatPharo-Tests-Skills',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Skills'
}

{ #category : 'running' }
ChatPharoSpec2SkillTest >> setUp [

	super setUp.
	skill := ChatPharoSpec2Skill new
]

{ #category : 'running' }
ChatPharoSpec2SkillTest >> tearDown [

	skill := nil.
	super tearDown
]

{ #category : 'tests' }
ChatPharoSpec2SkillTest >> testContextStringIncludesSpec2 [

	self assert: (skill contextString includesSubstring: 'Spec2')
]

{ #category : 'tests' }
ChatPharoSpec2SkillTest >> testContextStringIsNotEmpty [

	self assert: skill contextString isNotEmpty
]

{ #category : 'tests' }
ChatPharoSpec2SkillTest >> testDescriptionIsNotEmpty [

	self assert: skill description isNotEmpty
]

{ #category : 'tests' }
ChatPharoSpec2SkillTest >> testDescriptionMentionsSpec2 [

	self assert: (skill description includesSubstring: 'Spec2')
]

{ #category : 'tests' }
ChatPharoSpec2SkillTest >> testKeywordsIncludeSpec2 [

	self assert: (skill keywords includes: 'Spec2')
]

{ #category : 'tests' }
ChatPharoSpec2SkillTest >> testKeywordsIncludeSpPresenter [

	self assert: (skill keywords includes: 'SpPresenter')
]

{ #category : 'tests' }
ChatPharoSpec2SkillTest >> testKeywordsIsNotEmpty [

	self assert: skill keywords isNotEmpty
]

{ #category : 'tests' }
ChatPharoSpec2SkillTest >> testMatchesSpec2Keyword [

	self assert: (skill matchesKeywords: #('Spec2'))
]

{ #category : 'tests' }
ChatPharoSpec2SkillTest >> testMatchesSpPresenterKeyword [

	self assert: (skill matchesKeywords: #('SpPresenter'))
]

{ #category : 'tests' }
ChatPharoSpec2SkillTest >> testNameEqualsSpec2 [

	self assert: skill name equals: 'Spec2'
]
