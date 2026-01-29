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

{ #category : 'running' }
ChatPharoCollectionsSkillTest >> testContextStringIncludesCollections [

	self assert: (skill contextString includesSubstring: 'Collection')
]

{ #category : 'running' }
ChatPharoCollectionsSkillTest >> testContextStringIsNotEmpty [

	self assert: skill contextString isNotEmpty
]

{ #category : 'running' }
ChatPharoCollectionsSkillTest >> testDescriptionMentionsCollections [

	self assert: (skill description includesSubstring: 'collection')
]

{ #category : 'running' }
ChatPharoCollectionsSkillTest >> testKeywordsIncludeArray [

	self assert: (skill keywords includes: 'Array')
]

{ #category : 'running' }
ChatPharoCollectionsSkillTest >> testKeywordsIncludeCollect [

	self assert: (skill keywords includes: 'collect')
]

{ #category : 'running' }
ChatPharoCollectionsSkillTest >> testKeywordsIncludeDictionary [

	self assert: (skill keywords includes: 'Dictionary')
]

{ #category : 'running' }
ChatPharoCollectionsSkillTest >> testKeywordsIncludeOrderedCollection [

	self assert: (skill keywords includes: 'OrderedCollection')
]

{ #category : 'running' }
ChatPharoCollectionsSkillTest >> testKeywordsIsNotEmpty [

	self assert: skill keywords isNotEmpty
]

{ #category : 'running' }
ChatPharoCollectionsSkillTest >> testMatchesCollectKeyword [

	self assert: (skill matchesKeywords: #('collect'))
]

{ #category : 'running' }
ChatPharoCollectionsSkillTest >> testMatchesSelectKeyword [

	self assert: (skill matchesKeywords: #('select'))
]

{ #category : 'running' }
ChatPharoCollectionsSkillTest >> testNameEqualsCollections [

	self assert: skill name equals: 'Collections'
]
