"
""
Interactive tutorial for ChatPharo, inspired by ProfStef.
Provides a step-by-step guided tour of ChatPharo features.
Each lesson teaches a specific concept with explanations and examples.
Usage:
```smalltalk
ChatPharoTutorial start.  """"Start the tutorial from the beginning""""
ChatPharoTutorial resume. """"Resume from where you left off""""
"
Class {
	#name : 'ChatPharoTutorial',
	#superclass : 'Object',
	#instVars : [
		'lessons',
		'currentIndex',
		'presenter'
	],
	#classInstVars : [
		'default'
	],
	#category : 'AI-ChatPharo-Tutorial',
	#package : 'AI-ChatPharo-Tutorial'
}

{ #category : 'accessing' }
ChatPharoTutorial class >> default [
	"Return the singleton tutorial instance"

	default ifNil: [ default := self new ].
	^ default
]

{ #category : 'accessing' }
ChatPharoTutorial class >> resetDefault [
	"Reset the singleton"

	default := nil
]

{ #category : 'accessing' }
ChatPharoTutorial class >> resume [
	"Resume the tutorial from where the user left off"

	^ self default resume
]

{ #category : 'accessing' }
ChatPharoTutorial class >> start [
	"Start the tutorial from the beginning"

	^ self default start
]

{ #category : 'accessing' }
ChatPharoTutorial >> atEnd [
	"Return true if at the last lesson"

	^ currentIndex >= lessons size
]

{ #category : 'accessing' }
ChatPharoTutorial >> atStart [ 
	"Return true if at the first lesson"

	^ currentIndex <= 1
]

{ #category : 'accessing' }
ChatPharoTutorial >> currentIndex [
	"Return the current lesson index (1-based)"

	^ currentIndex
]

{ #category : 'accessing' }
ChatPharoTutorial >> currentLesson [ 
	"Return the current lesson"

	^ lessons at: currentIndex ifAbsent: [ lessons first ]
]

{ #category : 'accessing' }
ChatPharoTutorial >> first [
	"Go to the first lesson"

	currentIndex := 1.
	^ self currentLesson
]

{ #category : 'accessing' }
ChatPharoTutorial >> goToLesson: anIndex [
	"Go to a specific lesson by index"

	currentIndex := (anIndex max: 1) min: lessons size.
	^ self currentLesson
]

{ #category : 'accessing' }
ChatPharoTutorial >> initialize [

	super initialize.
	currentIndex := 1.
	self initializeLessons
]

{ #category : 'accessing' }
ChatPharoTutorial >> initializeLessons [
	"Initialize the tutorial lessons"

	lessons := OrderedCollection new. 
	
	"Lesson 1: Welcome"
	lessons add: (ChatPharoTutorialLesson
			 title: 'Welcome to ChatPharo!'
			 content: 'ChatPharo is your AI-powered coding assistant for Pharo.
It helps you write code, understand the system, debug issues, and learn Smalltalk concepts.
This tutorial will guide you through the main features of ChatPharo.
Click "Next" to continue, or "Close" to exit the tutorial at any time.'
			 icon: #announcement). 
			
	"Lesson 2: Opening ChatPharo"
	lessons add: (ChatPharoTutorialLesson
			 title: 'Opening ChatPharo'
			 content: 'You can open ChatPharo in several ways:
1. From the World Menu: Click anywhere on the desktop, then select ChatPharo > Temp ChatPharo
2. Using the keyboard shortcut: Press O, then C
3. From code: Evaluate this in a Playground:'
			 code: 'ChatPharo new presenter open'
			 icon: #smallWindow). 
			
	"Lesson 3: The Chat Interface"
	lessons add: (ChatPharoTutorialLesson
			 title: 'The Chat Interface'
			 content: 'The ChatPharo window has several parts:
- Toolbar at the top: New Chat, Delete, Save, Load, Settings, and connection status
- Chat tabs: Each conversation is in its own tab
- Message area: Shows the conversation history
- Input field: Where you type your messages
The chat interface is designed to be simple and familiar.'
			 code: 'ChatPharo new presenter open'
			 icon: #smallTalk). 
	
	"Lesson 4: Sending Your First Message"
	lessons add: (ChatPharoTutorialLesson
			 title: 'Sending Your First Message'
			 content: 'To chat with the AI:
1. Type your question or request in the input field at the bottom
2. Press Enter or click the Send button
3. Wait for the AI to respond
Try asking things like:
- "How do I create a class in Pharo?"
- "Explain the collect: method"
- "Write a method to reverse a string"'
code: 'ChatPharo ask: ''How do I create a class in Pharo?'''
			 icon: #glamorousSend).
			
	"Lesson 5: Working with Code Suggestions"
	lessons add: (ChatPharoTutorialLesson
			 title: 'Working with Code Suggestions'
			 content: 'When the AI suggests code, you have several options:
- Copy: Copy the code to your clipboard
- Execute: Run the code directly in Pharo
- Inspect: Execute and open an Inspector on the result
- Browse: If it is a class, open the System Browser
Code blocks in responses are highlighted and have action buttons.
Be careful when executing code - always review it first!'
code: 'ChatPharo code: ''Array with: 1 with: 2 with: 3 collect: [ :each | each * 2 ]'''
			 icon: #smallDoIt). 
			
	"Lesson 6: Managing Chats"
	lessons add: (ChatPharoTutorialLesson
			 title: 'Managing Chats'
			 content: 'You can have multiple conversations:
- New Chat: Creates a fresh conversation tab
- Delete Chat: Removes the current chat
- Delete All: Clears all chats (with confirmation)
Each chat maintains its own history, so you can work on different topics simultaneously.'
code: '| app presenter |
app := ChatPharo new.
presenter := app presenter.
presenter open.
presenter addNewChat.'
			 icon: #smallDelete). 
			
	"Lesson 7: Saving and Loading Chats"
	lessons add: (ChatPharoTutorialLesson
			 title: 'Saving and Loading Chats'
			 content: 'Save your conversations for later:
- Save Chat: Exports the current chat to a JSON file
- Load Chat: Imports a previously saved chat
This is useful for:
- Keeping a record of helpful conversations
- Sharing chats with team members
- Resuming work after restarting Pharo'
code: '| presenter |
presenter := ChatPharo new presenter.
presenter open.
presenter addNewChat.
presenter saveCurrentChat.'
			 icon: #smallSave). 
			
	"Lesson 8: Settings Overview"
	lessons add: (ChatPharoTutorialLesson
			 title: 'ChatPharo Settings'
			 content: 'Access settings via the gear icon or World Menu > ChatPharo Settings.
Settings are organized in tabs:
- Chat: API selection, model choice, system prompt
- Configuration: Iterations, caching, welcome message
- Extensions: Browser integration options
- Security: Sandbox and safety settings
- Personal: Your profile information
- Skills: Enable specialized knowledge areas
You can customize ChatPharo to fit your workflow.'
code: '| presenter chatPage |
presenter := ChatPharoSettings default presenter.
presenter open.
chatPage := presenter notebook pages detect: [ :page | page title = ''Chat'' ] ifNone: [ nil ].
chatPage ifNotNil: [ presenter notebook selectPage: chatPage ].'
			 icon: #smallConfiguration). 
			
	"Lesson 9: Choosing an AI Backend"
	lessons add: (ChatPharoTutorialLesson
			 title: 'Choosing an AI Backend'
			 content: 'ChatPharo supports multiple AI providers:
- Gemini: Google AI (requires API key)
- Ollama: Local AI models (free, runs on your machine)
- Mistral: Mistral AI (requires API key)
To configure:
1. Open Settings > Chat tab
2. Select your preferred API
3. Enter your API key or configure the connection
4. Choose a model from the dropdown
For beginners, Ollama is a great free option!'
code: '| presenter chatPage |
presenter := ChatPharoSettings default presenter.
presenter open.
chatPage := presenter notebook pages detect: [ :page | page title = ''Chat'' ] ifNone: [ nil ].
chatPage ifNotNil: [ presenter notebook selectPage: chatPage ].'
			 icon: #smallRemoteOpen). 
			
	"Lesson 10: Skills System"
	lessons add: (ChatPharoTutorialLesson
			 title: 'Skills System'
			 content: 'Skills give the AI specialized knowledge:
- Roassal: Data visualization expertise
- Bloc: UI framework knowledge
- Spec2: GUI building assistance
- Collections: In-depth collection handling
Enable skills in Settings > Skills tab.
The AI can also discover and use skills automatically based on your questions.'
			 icon: #smallLanguage). 
			
	"Lesson 11: Browser Extension"
	lessons add: (ChatPharoTutorialLesson
			 title: 'Browser Extension'
			 content: 'The Browser Extension adds AI assistance to your coding workflow:
When enabled, you get AI-powered features in:
- System Browser
- Playground
- Debugger
Features include:
- Explain selected code
- Generate code from description
- Fix bugs with AI suggestions
Enable it in Settings > Extensions tab.'
code: '| presenter extensionsPage |
presenter := ChatPharoSettings default presenter.
presenter open.
extensionsPage := presenter notebook pages detect: [ :page | page title = ''Extensions'' ] ifNone: [ nil ].
extensionsPage ifNotNil: [ presenter notebook selectPage: extensionsPage ].'
			 icon: #smallInspectIt). 
			
	"Lesson 12: Security and Sandbox"
	lessons add: (ChatPharoTutorialLesson
			 title: 'Security and Sandbox'
			 content: 'ChatPharo includes safety features:
- Sandbox Mode: AI-generated code runs in a restricted environment
- File System Protection: Prevents unauthorized file access
- Network Restrictions: Controls external connections
These protect you from potentially harmful code suggestions.
Advanced users can adjust these in Settings > Security tab.
For beginners, we recommend keeping default protections enabled.'
code: '| presenter securityPage |
presenter := ChatPharoSettings default presenter.
presenter open.
securityPage := presenter notebook pages detect: [ :page | page title = ''Security'' ] ifNone: [ nil ].
securityPage ifNotNil: [ presenter notebook selectPage: securityPage ].'
			 icon: #lock). 
			
	"Lesson 13: Tips for Better Results"
	lessons add: (ChatPharoTutorialLesson
			 title: 'Tips for Better Results'
			 content: 'Get better answers from ChatPharo:
1. Be specific: Instead of "make a window", say "create a Spec2 window with a button that prints hello"
2. Provide context: Mention what you are building or what problem you are solving
3. Ask follow-up questions: If something is unclear, ask for clarification
4. Request examples: Ask for code examples to understand concepts
5. Specify Pharo version: If relevant, mention your Pharo version'
code: 'ChatPharo ask: ''Create a Spec2 window with a button that prints hello'''
			 icon: #smallInfo). 
			
	"Lesson 14: Conclusion"
	lessons add: (ChatPharoTutorialLesson
			 title: 'You are Ready!'
			 content: 'Congratulations! You have completed the ChatPharo tutorial.
You now know how to:
- Open and use the chat interface
- Work with code suggestions safely
- Manage multiple conversations
- Configure settings and choose AI backends
- Use skills for specialized help
- Enable browser integration
Start exploring! The more you use ChatPharo, the more productive you will become.
You can always restart this tutorial from:
World Menu > ChatPharo > Tutorial
Happy coding!'
code: 'ChatPharoTutorial start'
			 icon: #glamorousAccept)
]

{ #category : 'accessing' }
ChatPharoTutorial >> last [
	"Go to the last lesson"

	currentIndex := lessons size.
	^ self currentLesson
]

{ #category : 'accessing' }
ChatPharoTutorial >> lessons [
	"Return all lessons"

	^ lessons
]

{ #category : 'accessing' }
ChatPharoTutorial >> lessonsCount [
	"Return the total number of lessons"

	^ lessons size
]

{ #category : 'accessing' }
ChatPharoTutorial >> next [
	"Go to the next lesson"

	self atEnd ifFalse: [ currentIndex := currentIndex + 1 ].
	^ self currentLesson
]

{ #category : 'accessing' }
ChatPharoTutorial >> previous [
	"Go to the previous lesson"

	self atStart ifFalse: [ currentIndex := currentIndex - 1 ].
	^ self currentLesson
]

{ #category : 'accessing' }
ChatPharoTutorial >> progress [
	"Return a string showing progress like '3/14'"

	^ currentIndex asString, '/', lessons size asString
]

{ #category : 'accessing' }
ChatPharoTutorial >> progressPercent [
	"Return progress as a percentage"

	^ (currentIndex / lessons size * 100) rounded
]

{ #category : 'accessing' }
ChatPharoTutorial >> resume [
	"Resume the tutorial, keeping current position"

	presenter := ChatPharoTutorialPresenter on: self.
	presenter open.
	^ presenter
]

{ #category : 'accessing' }
ChatPharoTutorial >> start [
	"Start the tutorial from the beginning"

	currentIndex := 1.
	presenter := ChatPharoTutorialPresenter on: self.
	presenter open.
	^ presenter
]

{ #category : 'accessing' }
ChatPharoTutorial >> tutorialCompleted [
	"Mark the tutorial as completed in settings"

	ChatPharoSettings default tutorialCompleted: true.
	ChatPharoLogger logSystem: 'Tutorial completed'
		details: (Dictionary new
			at: 'lessonsViewed' put: currentIndex;
			at: 'totalLessons' put: lessons size;
			yourself)
]
