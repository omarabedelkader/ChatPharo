Class {
	#name : 'ChatPharoSkillRegistryTest',
	#superclass : 'TestCase',
	#instVars : [
		'registry'
	],
	#category : 'AI-ChatPharo-Tests-Skills',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Skills'
}

{ #category : 'running' }
ChatPharoSkillRegistryTest >> setUp [

	super setUp.
	registry := ChatPharoSkillRegistry new
]

{ #category : 'running' }
ChatPharoSkillRegistryTest >> testAllSkillsNamesAreStrings [

	self assert: (registry allSkillsNames allSatisfy: [ :name | name isString ])
]

{ #category : 'running' }
ChatPharoSkillRegistryTest >> testAllSkillsNamesAreUnique [

	| names |
	names := registry allSkillsNames.
	self assert: names asSet size equals: names size
]

{ #category : 'running' }
ChatPharoSkillRegistryTest >> testContextForEnabledSkillsEmptyWhenNoneEnabled [

	self assert: registry contextForEnabledSkills equals: ''
]

{ #category : 'running' }
ChatPharoSkillRegistryTest >> testContextForQueryEmptyWhenNoKeywordsMatch [

	self assert: (registry contextForQuery: 'nothing to match') equals: ''
]

{ #category : 'running' }
ChatPharoSkillRegistryTest >> testContextForQueryIncludesDetectedKeywords [

	| context |
	context := registry contextForQuery: 'Use AlphaBeta tooling'.
	self assert: (context includesSubstring: '### AUTO-DETECTED SKILLS CONTEXT ###').
	self assert: (context includesSubstring: 'AlphaBeta')
]

{ #category : 'running' }
ChatPharoSkillRegistryTest >> testContextForSkillNamedMissingReturnsMessage [

	self assert: (registry contextForSkillNamed: 'MissingSkill') equals: 'Skill not found: MissingSkill'
]

{ #category : 'tests' }
ChatPharoSkillRegistryTest >> testContextForSkillsNamedReturnsMessageWhenNoneFound [

	self assert: (registry contextForSkillsNamed: #('Missing')) equals: 'No matching skills found.'
]

{ #category : 'tests' }
ChatPharoSkillRegistryTest >> testDisableSkillNamedClearsEnabled [

	registry enableSkillNamed: 'TestSkill'.
	registry disableSkillNamed: 'TestSkill'.
	self deny: (registry enabledSkills anySatisfy: [ :skill | skill name = 'TestSkill' ])
]

{ #category : 'tests' }
ChatPharoSkillRegistryTest >> testEnabledSkillsEmptyByDefault [

	self assert: registry enabledSkills isEmpty
]

{ #category : 'tests' }
ChatPharoSkillRegistryTest >> testExtractKeywordsFromIgnoresShortWords [

	self assert: (registry extractKeywordsFrom: 'a b c') isEmpty
]

{ #category : 'tests' }
ChatPharoSkillRegistryTest >> testHasSkillNamedReturnsFalseForMissing [

	self deny: (registry hasSkillNamed: 'MissingSkill')
]

{ #category : 'tests' }
ChatPharoSkillRegistryTest >> testRefreshResetsEnabledSkills [

	registry enableSkillNamed: 'TestSkill'.
	registry refresh.
	self assert: registry enabledSkills isEmpty
]

{ #category : 'tests' }
ChatPharoSkillRegistryTest >> testSkillsWithAutomaticEnabledFilters [

	registry setAutomaticEnabled: false forSkillNamed: 'TestSkill'.
	self deny: (registry skillsWithAutomaticEnabled anySatisfy: [ :skill | skill name = 'TestSkill' ])
]
