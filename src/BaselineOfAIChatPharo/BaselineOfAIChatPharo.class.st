"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : 'BaselineOfAIChatPharo',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfAIChatPharo',
	#package : 'BaselineOfAIChatPharo'
}

{ #category : 'baselines' }
BaselineOfAIChatPharo >> baseline: spec [

	<baseline>
	spec for: #common do: [
		self defineDependencies: spec.
		self definePackages: spec.
		self defineGroups: spec ]
]

{ #category : 'baselines' }
BaselineOfAIChatPharo >> defineDependencies: spec [

	spec
		baseline: 'NeoJSON'
		with: [ spec repository: 'github://svenvc/NeoJSON/repository' ]
]

{ #category : 'baselines' }
BaselineOfAIChatPharo >> defineGroups: spec [
]

{ #category : 'baselines' }
BaselineOfAIChatPharo >> definePackages: spec [
	
	spec package: 'AI-ChatPharo' with: [ spec requires: #( 'NeoJSON' ) ].
	spec package: 'AI-ChatPharo-Tests' with: [ spec requires: #( 'AI-ChatPharo' ) ].
]
