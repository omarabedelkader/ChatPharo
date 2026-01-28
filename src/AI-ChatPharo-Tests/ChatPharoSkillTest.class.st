Class {
	#name : 'ChatPharoSkillTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo-Tests-Skills',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Skills'
}

{ #category : 'tests' }
ChatPharoSkillTest >> testAutomaticEnabledDefaultsToTrue [

	| skill |
	skill := ChatPharoTestSkill new.
	self assert: skill automaticEnabled
]

{ #category : 'tests' }
ChatPharoSkillTest >> testAutomaticEnabledSetAndGet [

	| skill |
	skill := ChatPharoTestSkill new.
	skill automaticEnabled: false.
	self deny: skill automaticEnabled.
	skill automaticEnabled: true.
	self assert: skill automaticEnabled
]

{ #category : 'tests' }
ChatPharoSkillTest >> testContextFormatting [

	| skill context |
	skill := ChatPharoTestSkill new.
	context := skill context.
	self assert: (context includesSubstring: '=== SKILL:').
	self assert: (context includesSubstring: 'Description:').
	self assert: (context includesSubstring: skill name)
]

{ #category : 'tests' }
ChatPharoSkillTest >> testContextIncludesName [

	| skill context |
	skill := ChatPharoTestSkill new.
	context := skill context.
	self assert: (context includesSubstring: skill name)
]

{ #category : 'tests' }
ChatPharoSkillTest >> testEnabledDefaultsToFalse [

	| skill |
	skill := ChatPharoTestSkill new.
	self deny: skill enabled
]

{ #category : 'tests' }
ChatPharoSkillTest >> testEnabledSetAndGet [

	| skill |
	skill := ChatPharoTestSkill new.
	skill enabled: true.
	self assert: skill enabled.
	skill enabled: false.
	self deny: skill enabled
]

{ #category : 'tests' }
ChatPharoSkillTest >> testMatchesKeywordsCaseInsensitive [

	| skill |
	skill := ChatPharoTestSkill new.
	self assert: (skill matchesKeywords: #('TEST')).
	self assert: (skill matchesKeywords: #('test')).
	self assert: (skill matchesKeywords: #('TeSt'))
]

{ #category : 'tests' }
ChatPharoSkillTest >> testMatchesKeywordsMultipleTerms [

	| skill |
	skill := ChatPharoTestSkill new.
	self assert: (skill matchesKeywords: #('other' 'test' 'another')).
	self assert: (skill matchesKeywords: #('other' 'sample' 'another'))
]

{ #category : 'tests' }
ChatPharoSkillTest >> testMatchesKeywordsPartialMatch [

	| skill |
	skill := ChatPharoTestSkill new.
	self assert: (skill matchesKeywords: #('tes'))
]

{ #category : 'tests' }
ChatPharoSkillTest >> testMatchesKeywordsReturnsFalseForNonMatch [

	| skill |
	skill := ChatPharoTestSkill new.
	self deny: (skill matchesKeywords: #('nomatch' 'nothing'))
]

{ #category : 'tests' }
ChatPharoSkillTest >> testMatchesKeywordsReturnsTrueForMatch [

	| skill |
	skill := ChatPharoTestSkill new.
	self assert: (skill matchesKeywords: #('test'))
]
