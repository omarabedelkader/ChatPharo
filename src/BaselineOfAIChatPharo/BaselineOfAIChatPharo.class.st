"
A baseline is a kind of map to load project.

Description
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

•	message one
•	message two
•	(for bonus points) how to create instances.


One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.
"
Class {
	#name : 'BaselineOfAIChatPharo',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfAIChatPharo',
	#package : 'BaselineOfAIChatPharo'
}

{ #category : 'baselines' }
BaselineOfAIChatPharo class >> postLoad: spec [ 

    <postLoad>
    UIManager default
        inform: 'ChatPharo is currently in beta. You might encounter bugs or memory issues that could halt your image.'
]

{ #category : 'baselines' }
BaselineOfAIChatPharo >> baseline: spec [

	<baseline>
        spec for: #common do: [
                        spec package: 'AI-ChatPharo'.
                        spec
                                package: 'AI-ChatPharo-Agent'
                                with: [ spec requires: #( 'AI-ChatPharo' ) ].
                        spec
                                package: 'AI-ChatPharo-Spec'
                                with: [ spec requires: #( 'AI-ChatPharo' ) ].
                        spec
                                package: 'AI-ChatPharo-Tools'
                                with: [ spec requires: #( 'AI-ChatPharo' ) ].
                        spec
                                package: 'AI-ChatPharo-History'
                                with: [ spec requires: #( 'AI-ChatPharo' ) ].
                        spec
                                package: 'AI-ChatPharo-Env'
                                with: [ spec requires: #( 'AI-ChatPharo' ) ].
                        spec
                                package: 'AI-ChatPharo-Tests'
                                with: [ spec requires: #( 'AI-ChatPharo' 'AI-ChatPharo-Agent' 'AI-ChatPharo-Spec' 'AI-ChatPharo-Tools' 'AI-ChatPharo-History' 'AI-ChatPharo-Env' ) ] ]
]
