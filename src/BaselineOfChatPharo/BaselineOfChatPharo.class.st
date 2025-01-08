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
	#name : 'BaselineOfChatPharo',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfChatPharo',
	#package : 'BaselineOfChatPharo'
}

{ #category : 'baselines' }
BaselineOfChatPharo >> baseline: spec [

	<baseline>
	spec for: #common do: [
		self defineDependencies: spec.
		self definePackages: spec.
		self defineGroups: spec ]
]

{ #category : 'baselines' }
BaselineOfChatPharo >> defineDependencies: spec [

	spec
		baseline: 'NeoJSON'
		with: [ spec repository: 'github://svenvc/NeoJSON/repository' ]
]

{ #category : 'baselines' }
BaselineOfChatPharo >> defineGroups: spec [
]

{ #category : 'baselines' }
BaselineOfChatPharo >> definePackages: spec [

	spec package: 'Pharo-Ollama' with: [ spec requires: #( 'NeoJSON' ) ].
	spec package: 'Pharo-Ollama-Tests' with: [ spec requires: #( 'Pharo-Ollama' ) ].
	
	spec package: 'LLM-API' with: [ spec requires: #( 'NeoJSON' ) ].
	spec package: 'LLM-Spec' with: [ spec requires: #( 'LLM-API' ) ].

	spec for: #'pharo10.x' do: [ 
		spec
			package: 'Pharo-Ollama'
			with: [ spec requires: #( 'NeoJSON' 'Pharo-Ollama-Pharo10' ) ];
			package: 'Pharo-Ollama-Pharo10' ]
]
