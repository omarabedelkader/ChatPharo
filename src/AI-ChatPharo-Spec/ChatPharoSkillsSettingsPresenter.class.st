"
Settings presenter for managing ChatPharo Skills.
Allows users to:
- View all available skills
- Enable/disable individual skills for manual context inclusion
- Toggle automatic skill detection
- Enable/disable skill tools for LLM access
"
Class {
	#name : 'ChatPharoSkillsSettingsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model',
		'skillsList',
		'automaticSkillsCheckBox',
		'skillToolsCheckBox',
		'skillDescriptionText',
		'refreshButton'
	],
	#category : 'AI-ChatPharo-Spec-Skills',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Skills'
}

{ #category : 'as yet unclassified' }
ChatPharoSkillsSettingsPresenter >> allSkills [

	"Returns all available skills from the registry"

	^ ChatPharoSkillRegistry default allSkills
]

{ #category : 'as yet unclassified' }
ChatPharoSkillsSettingsPresenter >> connectPresenters [

	automaticSkillsCheckBox whenChangedDo: [ :state |
		model automaticSkillsEnabled: state ].

	skillToolsCheckBox whenChangedDo: [ :state |
		model skillToolsEnabled: state ].

	skillsList whenSelectedItemChangedDo: [ :item |
		item ifNotNil: [ self updateDescriptionFor: item ] ].

	refreshButton action: [ self refreshSkillsList ]
]

{ #category : 'as yet unclassified' }
ChatPharoSkillsSettingsPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 10;
		add: (SpBoxLayout newLeftToRight
			add: 'Available Skills:' expand: false;
			addLast: refreshButton expand: false;
			yourself) expand: false;
		add: (SpPanedLayout newTopToBottom
			positionOfSlider: 60 percent;
			add: skillsList;
			add: skillDescriptionText;
			yourself);
		add: automaticSkillsCheckBox expand: false;
		add: skillToolsCheckBox expand: false;
		yourself
]

{ #category : 'as yet unclassified' }
ChatPharoSkillsSettingsPresenter >> initializePresenters [

	super initializePresenters.

	skillsList := self newTable
		addColumn: (SpCheckBoxTableColumn new
			title: 'Enabled';
			width: 60;
			evaluated: [ :skill | model skillsEnabled includes: skill name ];
			onActivation: [ :skill | model enableSkill: skill name ];
			onDeactivation: [ :skill | model disableSkill: skill name ];
			yourself);
		addColumn: (SpStringTableColumn
			title: 'Name'
			evaluated: [ :skill | skill name ]);
		addColumn: (SpStringTableColumn
			title: 'Description'
			evaluated: [ :skill | skill description ]);
		items: self allSkills;
		yourself.

	skillDescriptionText := self newText
		beNotEditable;
		text: 'Select a skill to see its description and context preview.';
		yourself.

	automaticSkillsCheckBox := self newCheckBox
		label: 'Enable automatic skill detection (model can request skills based on query context)';
		state: model automaticSkillsEnabled;
		yourself.

	skillToolsCheckBox := self newCheckBox
		label: 'Enable skill tools (allow model to call list_available_skills and get_skill_context)';
		state: model skillToolsEnabled;
		yourself.

	refreshButton := self newButton
		label: 'Refresh';
		icon: (self iconNamed: #refresh);
		help: 'Refresh the list of available skills';
		yourself
]

{ #category : 'as yet unclassified' }
ChatPharoSkillsSettingsPresenter >> refreshSkillsList [
	"Refresh the skills registry and update the list"

	ChatPharoSkillRegistry default refresh.
	skillsList items: self allSkills
]

{ #category : 'as yet unclassified' }
ChatPharoSkillsSettingsPresenter >> setModelBeforeInitialization: aSettings [

	model := aSettings
]

{ #category : 'as yet unclassified' }
ChatPharoSkillsSettingsPresenter >> updateDescriptionFor: aSkill [
	"Update the description text area with skill details"

	| text |
	text := String streamContents: [ :stream |
		stream
			nextPutAll: '=== '; nextPutAll: aSkill name; nextPutAll: ' ==='; cr; cr;
			nextPutAll: 'Description: '; nextPutAll: aSkill description; cr; cr;
			nextPutAll: 'Keywords: '; nextPutAll: (aSkill keywords joinUsing: ', '); cr; cr;
			nextPutAll: '--- Context Preview (first 500 chars) ---'; cr;
			nextPutAll: (aSkill contextString first: (500 min: aSkill contextString size)) ].

	skillDescriptionText text: text
]
