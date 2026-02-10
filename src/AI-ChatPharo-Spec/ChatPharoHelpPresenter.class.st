"
Interactive help presenter that provides context-aware assistance for ChatPharo.
Shows helpful suggestions, quick tips, and actions based on the current context.
The help system automatically detects what the user might be working on and
provides relevant guidance, tutorials, and examples.
"
Class {
	#name : 'ChatPharoHelpPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'helpText',
		'currentContext',
		'chatPharo',
		'actionButtonsLayout',
		'tutorialButton',
		'settingsButton',
		'enableSkillsButton',
		'examplesButton'
	],
	#category : 'AI-ChatPharo-Spec-Core',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Core'
}

{ #category : 'accessing' }
ChatPharoHelpPresenter >> chatPharo [

	^ chatPharo
]

{ #category : 'accessing' }
ChatPharoHelpPresenter >> chatPharo: anObject [

	chatPharo := anObject
]

{ #category : 'accessing' }
ChatPharoHelpPresenter >> connectPresenters [

	tutorialButton action: [ self launchTutorial ].
	settingsButton action: [ self openSettings ].
	enableSkillsButton action: [ self enableRelevantSkills ].
	examplesButton action: [ self showExamples ]
]

{ #category : 'accessing' }
ChatPharoHelpPresenter >> currentContext [

	^ currentContext
]

{ #category : 'accessing' }
ChatPharoHelpPresenter >> currentContext: aString [

	currentContext := aString.
	self updateHelpContent
]

{ #category : 'layout' }
ChatPharoHelpPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 10;
		add: helpText;
		add: actionButtonsLayout expand: false;
		yourself
]

{ #category : 'layout' }
ChatPharoHelpPresenter >> enableRelevantSkills [
	"Enable skills that might be relevant based on current context"

	| registry relevantSkills message |
	registry := ChatPharoSkillRegistry default.

	"Detect relevant skills from context"
	relevantSkills := currentContext
		ifNotEmpty: [
			| keywords matchingSkills |
			keywords := registry extractKeywordsFrom: currentContext.
			matchingSkills := registry skillsForKeywords: keywords.
			matchingSkills reject: [ :skill | skill enabled ] ]
		ifEmpty: [ #() ].

	relevantSkills ifEmpty: [
		^ self inform: 'No additional skills detected for your current context.
Check Settings > Skills to manually enable specific skills (Spec2, Roassal, Collections, etc.)' ].

	"Enable the detected skills"
	relevantSkills do: [ :skill | skill enabled: true ].

	message := String streamContents: [ :stream |
		stream nextPutAll: 'Enabled skills: '.
		relevantSkills
			do: [ :skill | stream nextPutAll: skill name ]
			separatedBy: [ stream nextPutAll: ', ' ].
		stream cr; cr;
			nextPutAll: 'These skills will now provide specialized documentation to improve AI responses!' ].

	self inform: message.
	self updateHelpContent.

	ChatPharoLogger logFrontend: 'Skills auto-enabled from help'
		details: (Dictionary new
			at: 'skills' put: (relevantSkills collect: #name);
			at: 'contextLength' put: currentContext size;
			yourself)
]

{ #category : 'layout' }
ChatPharoHelpPresenter >> generateHelpContent [
	"Generate helpful content based on current context and state"

	| content registry enabledSkills suggestedSkills hasAgent |
	currentContext ifNil: [ currentContext := '' ].
	registry := ChatPharoSkillRegistry default.
	enabledSkills := registry enabledSkills.
	hasAgent := chatPharo notNil and: [ chatPharo settings agent notNil ].

	content := String streamContents: [ :s |
		s nextPutAll: '# ChatPharo Help'; cr; cr.

		"Show context-specific help if we have context"
		currentContext ifNotEmpty: [
			s nextPutAll: '## What You''re Working On'; cr.
			s nextPutAll: 'Current prompt: "'.
			s nextPutAll: (currentContext size > 100
				ifTrue: [ (currentContext first: 100) , '...' ]
				ifFalse: [ currentContext ]).
			s nextPutAll: '"'; cr; cr.

			"Suggest relevant skills"
			suggestedSkills := registry skillsForKeywords:
				(registry extractKeywordsFrom: currentContext).
			suggestedSkills := suggestedSkills reject: [ :skill | skill enabled ].

			suggestedSkills ifNotEmpty: [
				s nextPutAll: '**💡 Suggested Skills for Better Help:**'; cr.
				suggestedSkills do: [ :skill |
					s nextPutAll: '- **'; nextPutAll: skill name; nextPutAll: '** - ';
						nextPutAll: skill description; cr ].
				s cr.
				s nextPutAll: '👉 Click "Enable Relevant Skills" below to activate these!'; cr; cr ] ].

		"Agent status"
		s nextPutAll: '## Current Status'; cr.
		hasAgent
			ifTrue: [
				| agent |
				agent := chatPharo settings agent.
				s nextPutAll: '✅ AI Agent: **'; nextPutAll: agent class name; nextPutAll: '**'; cr.
				(agent class respondsTo: #isReachable) ifTrue: [
					agent class isReachable
						ifTrue: [ s nextPutAll: '✅ Connection: **Active**'; cr ]
						ifFalse: [ s nextPutAll: '⚠️  Connection: **Disconnected** - Check your API key or server'; cr ] ] ]
			ifFalse: [
				s nextPutAll: '⚠️  No AI agent configured - Open Settings to configure'; cr ].
		s cr.

		"Enabled skills"
		s nextPutAll: '## Active Skills'; cr.
		enabledSkills ifNotEmpty: [
			s nextPutAll: 'You have the following skills enabled:'; cr.
			enabledSkills do: [ :skill |
				s nextPutAll: '- **'; nextPutAll: skill name; nextPutAll: '** - ';
					nextPutAll: skill description; cr ].
			s cr ]
		ifEmpty: [
			s nextPutAll: 'No skills currently enabled. Skills provide specialized documentation to the AI.'; cr.
			s nextPutAll: 'Available: Spec2 (UI), Roassal (Visualization), Collections, Bloc'; cr; cr ].

		"Quick tips based on context"
		s nextPutAll: '## Quick Tips'; cr; cr.

		currentContext ifEmpty: [
			"General tips when no context"
			s nextPutAll: '**Getting Started:**'; cr.
			s nextPutAll: '- Try the **Tutorial** for an interactive introduction'; cr.
			s nextPutAll: '- Enable **Skills** for specialized help (Spec2, Roassal, etc.)'; cr.
			s nextPutAll: '- Be specific in your prompts for better results'; cr.
			s nextPutAll: '- Use Execute buttons to try AI-generated code'; cr; cr.

			s nextPutAll: '**Example Prompts to Try:**'; cr.
			s nextPutAll: '- "How do I create a Spec2 window with a button?"'; cr.
			s nextPutAll: '- "Explain the difference between Array and OrderedCollection"'; cr.
			s nextPutAll: '- "Show me how to visualize data with Roassal"'; cr.
			s nextPutAll: '- "What are blocks and how do they work?"'; cr; cr ]
		ifNotEmpty: [
			"Context-specific tips"
			(currentContext includesSubstring: 'UI' caseSensitive: false) |
			(currentContext includesSubstring: 'window' caseSensitive: false) |
			(currentContext includesSubstring: 'button' caseSensitive: false) ifTrue: [
				s nextPutAll: '**UI Development Tips:**'; cr.
				s nextPutAll: '- Enable the **Spec2 skill** for detailed UI framework help'; cr.
				s nextPutAll: '- Ask for complete examples including layouts'; cr.
				s nextPutAll: '- Mention specific widgets you need (buttons, lists, tables, etc.)'; cr; cr ].

			(currentContext includesSubstring: 'visual' caseSensitive: false) |
			(currentContext includesSubstring: 'graph' caseSensitive: false) |
			(currentContext includesSubstring: 'chart' caseSensitive: false) ifTrue: [
				s nextPutAll: '**Visualization Tips:**'; cr.
				s nextPutAll: '- Enable the **Roassal skill** for visualization examples'; cr.
				s nextPutAll: '- Specify the type of chart/graph you need'; cr.
				s nextPutAll: '- Ask about interactivity and animations'; cr; cr ].

			(currentContext includesSubstring: 'collection' caseSensitive: false) |
			(currentContext includesSubstring: 'array' caseSensitive: false) |
			(currentContext includesSubstring: 'list' caseSensitive: false) ifTrue: [
				s nextPutAll: '**Collections Tips:**'; cr.
				s nextPutAll: '- Enable the **Collections skill** for detailed API help'; cr.
				s nextPutAll: '- Ask about performance characteristics'; cr.
				s nextPutAll: '- Request examples with specific use cases'; cr; cr ].

			(currentContext includesSubstring: 'error' caseSensitive: false) |
			(currentContext includesSubstring: 'bug' caseSensitive: false) |
			(currentContext includesSubstring: 'not working' caseSensitive: false) ifTrue: [
				s nextPutAll: '**Debugging Tips:**'; cr.
				s nextPutAll: '- Include the error message in your prompt'; cr.
				s nextPutAll: '- Show the code that''s causing the problem'; cr.
				s nextPutAll: '- Describe what you expected vs what happened'; cr; cr ].

			"Generic tips when context doesn't match patterns"
			s nextPutAll: '**General Tips:**'; cr.
			s nextPutAll: '- Be specific about what you want to achieve'; cr.
			s nextPutAll: '- Include examples when possible'; cr.
			s nextPutAll: '- Ask follow-up questions to refine answers'; cr; cr ].

		"Help Skill info"
		s nextPutAll: '## About This Help'; cr.
		s nextPutAll: 'This help system analyzes your current prompt to provide relevant guidance. '; cr.
		s nextPutAll: 'The **ChatPharoHelp skill** is also available - it provides comprehensive '; cr.
		s nextPutAll: 'help documentation to the AI when you ask questions about using ChatPharo itself.'; cr; cr.

		s nextPutAll: '**Keywords that trigger help:** help, how to, tutorial, guide, '; cr.
		s nextPutAll: 'troubleshoot, getting started, configure, API key, settings'; cr ].

	^ content
]

{ #category : 'initialization' }
ChatPharoHelpPresenter >> initializePresenters [

	helpText := self newText
		text: self generateHelpContent;
		editable: false;
		yourself.

	tutorialButton := self newButton
		label: 'Start Tutorial';
		icon: (self iconNamed: #help);
		help: 'Launch interactive tutorial to learn ChatPharo features';
		yourself.

	settingsButton := self newButton
		label: 'Open Settings';
		icon: (self iconNamed: #smallConfiguration);
		help: 'Configure AI agents, skills, and preferences';
		yourself.

	enableSkillsButton := self newButton
		label: 'Enable Relevant Skills';
		icon: (self iconNamed: #smallObjects);
		help: 'Automatically enable skills relevant to your current prompt';
		yourself.

	examplesButton := self newButton
		label: 'Show Examples';
		icon: (self iconNamed: #smallHome);
		help: 'Show example prompts for common tasks';
		yourself.

	actionButtonsLayout := SpBoxLayout newLeftToRight
		spacing: 5;
		add: tutorialButton;
		add: settingsButton;
		add: enableSkillsButton;
		add: examplesButton;
		yourself
]

{ #category : 'initialization' }
ChatPharoHelpPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'ChatPharo Help - Context-Aware Assistance';
		initialExtent: 700@600
]

{ #category : 'initialization' }
ChatPharoHelpPresenter >> launchTutorial [
	"Launch the interactive tutorial"

	self window close.
	[
		ChatPharoTutorial resume
	] on: Error do: [ :ex |
		ChatPharoTutorial start ].

	ChatPharoLogger logFrontend: 'Tutorial launched from help'
		details: (Dictionary new yourself)
]

{ #category : 'initialization' }
ChatPharoHelpPresenter >> openSettings [
	"Open the settings dialog"

	| settingsWindow |
	chatPharo ifNil: [ ^ self inform: 'Settings not available' ].

	settingsWindow := chatPharo settings presenter.
	settingsWindow chatPharo: chatPharo.
	settingsWindow open.

	ChatPharoLogger logFrontend: 'Settings opened from help'
		details: (Dictionary new yourself)
]

{ #category : 'initialization' }
ChatPharoHelpPresenter >> showExamples [ 
	"Show example prompts for common tasks"

	| examples |
	examples := '# Example Prompts for ChatPharo
## Learning Pharo Basics
- "Explain blocks and closures with examples"
- "What''s the difference between = and == ?"
- "How do I handle exceptions in Pharo?"
- "Show me how to create a simple class"
- "What are metaclasses and why do they matter?"
## Building User Interfaces (Spec2)
**Tip: Enable the Spec2 skill first!**
- "Create a window with a button and text input"
- "How do I make a table with multiple columns?"
- "Show me how to create a custom toolbar"
- "Build a dialog with OK/Cancel buttons"
- "How do I update the UI when data changes?"
## Data Visualization (Roassal)
**Tip: Enable the Roassal skill first!**
- "Create a simple bar chart with Roassal"
- "How do I make an interactive node graph?"
- "Show me how to visualize a tree structure"
- "Create an animated line chart"
- "How do I add tooltips to visualizations?"
## Working with Collections
**Tip: Enable the Collections skill first!**
- "When should I use Array vs OrderedCollection?"
- "How do I filter and map over collections?"
- "Show me examples of using Dictionary"
- "What''s the difference between Set and OrderedCollection?"
- "How do I sort a collection by multiple criteria?"
## Code Exploration
- "Find all implementors of #printOn:"
- "What does the Collection class hierarchy look like?"
- "Show me how to use the Visitor pattern in Pharo"
- "What are traits and how do I use them?"
## Debugging & Problem Solving
- "Why might I get a MessageNotUnderstood error?"
- "My UI isn''t refreshing - what should I check?"
- "How do I debug code that runs in a forked process?"
- "This code gave an error: [paste your code and error]"
## Advanced Topics
- "How do I create a custom tool for ChatPharo?"
- "Explain how to use Zinc for HTTP requests"
- "Show me how to work with JSON in Pharo"
- "How do I create and use custom skills?"
- "What are announcements and how do I use them?"
---
**Pro Tips:**
- Be specific - mention exact widgets, classes, or features you need
- Enable relevant skills for detailed domain knowledge
- Include code snippets when asking about errors
- Ask follow-up questions to refine answers
- Use the Execute button to try generated code immediately
'.
	self inform: examples.

	ChatPharoLogger logFrontend: 'Examples shown from help'
		details: (Dictionary new yourself)
]

{ #category : 'initialization' }
ChatPharoHelpPresenter >> updateHelpContent [
	"Regenerate help content based on current context"

	helpText text: self generateHelpContent
]
