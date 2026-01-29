Class {
	#name : 'ChatPharoIntegrationTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo-Tests-Integration',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Integration'
}

{ #category : 'tests' }
ChatPharoIntegrationTest >> testChatWithHistory [

	| chat message |
	chat := ChatPharoChat new agent: ChatPharoNullAgent new.
	message := ChatPharoMessage new content: 'Test message'.
	chat addUserMessage: message.
	self assert: chat messages size equals: 2.
	self assert: chat history messages isNotEmpty
]

{ #category : 'tests' }
ChatPharoIntegrationTest >> testChatWithMultipleAgentTypes [

	| chat1 chat2 chat3 |
	chat1 := ChatPharoChat new agent: ChatPharoNullAgent new.
	chat2 := ChatPharoChat new agent: ChatPharoMockAgent new.
	chat3 := ChatPharoChat new agent: ChatPharoNullAgent new.
	self assert: chat1 agent class equals: ChatPharoNullAgent.
	self assert: chat2 agent class equals: ChatPharoMockAgent.
	self assert: chat3 agent class equals: ChatPharoNullAgent
]

{ #category : 'tests' }
ChatPharoIntegrationTest >> testMultiversWithDifferentAgents [

	| multivers step1 step2 |
	multivers := ChatPharoMultivers new.
	step1 := ChatPharoMultiversStep new
		agentClass: ChatPharoNullAgent;
		model: 'model1';
		yourself.
	step2 := ChatPharoMultiversStep new
		agentClass: ChatPharoNullAgent;
		model: 'model2';
		yourself.
	multivers addStep: step1.
	multivers addStep: step2.
	multivers enabled: true.
	self assert: multivers canExecute
]

{ #category : 'tests' }
ChatPharoIntegrationTest >> testSettingsAgentSelection [

	| settings agent1 agent2 |
	ChatPharoSettings resetDefault.
	settings := ChatPharoSettings new.
	agent1 := ChatPharoNullAgent new.
	agent2 := ChatPharoMockAgent new.
	settings instVarNamed: #agent put: agent1.
	self assert: settings agent equals: agent1.
	settings instVarNamed: #agent put: agent2.
	self assert: settings agent equals: agent2.
	ChatPharoSettings resetDefault
]

{ #category : 'tests' }
ChatPharoIntegrationTest >> testSettingsWithEthicsDirector [

	| settings ethics |
	ChatPharoSettings resetDefault.
	settings := ChatPharoSettings new.
	ethics := ChatPharoEthicsDirector new.
	ethics enabled: true.
	ethics mandate: 'Be helpful'.
	settings ethicsDirector: ethics.
	self assert: settings ethicsDirector enabled.
	self assert: settings ethicsDirector mandate equals: 'Be helpful'.
	ChatPharoSettings resetDefault
]

{ #category : 'tests' }
ChatPharoIntegrationTest >> testSettingsWithMemory [

	| settings memory |
	ChatPharoSettings resetDefault.
	settings := ChatPharoSettings new.
	memory := ChatPharoMemory new.
	memory enabled: true.
	settings memory: memory.
	self assert: settings memory enabled.
	ChatPharoSettings resetDefault
]

{ #category : 'tests' }
ChatPharoIntegrationTest >> testSettingsWithMultivers [

	| settings multivers |
	ChatPharoSettings resetDefault.
	settings := ChatPharoSettings new.
	multivers := ChatPharoMultivers new.
	multivers enabled: true.
	multivers name: 'Test Chain'.
	settings multivers: multivers.
	self assert: settings multivers enabled.
	self assert: settings multivers name equals: 'Test Chain'.
	ChatPharoSettings resetDefault
]

{ #category : 'tests' }
ChatPharoIntegrationTest >> testSkillRegistryWithMultipleSkills [

	| registry blocSkill collectionsSkill |
	registry := ChatPharoSkillRegistry new.
	blocSkill := ChatPharoBlocSkill new.
	collectionsSkill := ChatPharoCollectionsSkill new.
	registry registerSkill: blocSkill.
	registry registerSkill: collectionsSkill.
	self assert: (registry skillsForKeywords: #('BlElement')) isNotEmpty.
	self assert: (registry skillsForKeywords: #('OrderedCollection')) isNotEmpty
]

{ #category : 'tests' }
ChatPharoIntegrationTest >> testTutorialWithCustomLessons [

	| tutorial lesson1 lesson2 |
	tutorial := ChatPharoTutorial new.
	lesson1 := ChatPharoTutorialLesson title: 'Lesson 1' content: 'Content 1'.
	lesson2 := ChatPharoTutorialLesson title: 'Lesson 2' content: 'Content 2'.
	"Tutorial already has default lessons, so we test navigation"
	tutorial first.
	self assert: tutorial currentLesson isNotNil.
	tutorial next.
	self assert: tutorial currentLesson isNotNil
]
