Class {
	#name : 'ChatPharoCollectionsSkillTest',
	#superclass : 'TestCase',
	#instVars : [
		'skill'
	],
	#category : 'AI-ChatPharo-Tests-Skills',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Skills'
}

{ #category : 'running' }
ChatPharoCollectionsSkillTest >> setUp [

	super setUp.
	skill := ChatPharoCollectionsSkill new
]

{ #category : 'running' }
ChatPharoCollectionsSkillTest >> tearDown [

	skill := nil.
	super tearDown
]

{ #category : 'tests' }
ChatPharoCollectionsSkillTest >> testContextStringIncludesCollections [

	self assert: (skill contextString includesSubstring: 'Collection')
]

{ #category : 'tests' }
ChatPharoCollectionsSkillTest >> testContextStringIsNotEmpty [

	self assert: skill contextString isNotEmpty
]

{ #category : 'tests' }
ChatPharoCollectionsSkillTest >> testDescriptionIsNotEmpty [

	self assert: skill description isNotEmpty
]

{ #category : 'tests' }
ChatPharoCollectionsSkillTest >> testDescriptionMentionsCollections [

	self assert: (skill description includesSubstring: 'collection')
]

{ #category : 'tests' }
ChatPharoCollectionsSkillTest >> testKeywordsIncludeArray [

	self assert: (skill keywords includes: 'Array')
]

{ #category : 'tests' }
ChatPharoCollectionsSkillTest >> testKeywordsIncludeCollect [

	self assert: (skill keywords includes: 'collect')
]

{ #category : 'tests' }
ChatPharoCollectionsSkillTest >> testKeywordsIncludeDictionary [

	self assert: (skill keywords includes: 'Dictionary')
]

{ #category : 'tests' }
ChatPharoCollectionsSkillTest >> testKeywordsIncludeOrderedCollection [

	self assert: (skill keywords includes: 'OrderedCollection')
]

{ #category : 'tests' }
ChatPharoCollectionsSkillTest >> testKeywordsIsNotEmpty [

	self assert: skill keywords isNotEmpty
]

{ #category : 'tests' }
ChatPharoCollectionsSkillTest >> testMatchesCollectKeyword [

	self assert: (skill matchesKeywords: #('collect'))
]

{ #category : 'tests' }
ChatPharoCollectionsSkillTest >> testMatchesSelectKeyword [

	self assert: (skill matchesKeywords: #('select'))
]

{ #category : 'tests' }
ChatPharoCollectionsSkillTest >> testNameEqualsCollections [

	self assert: skill name equals: 'Collections'
]
