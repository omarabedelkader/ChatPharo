Class {
	#name : 'ChatPharoSpecChatBubbleTest',
	#superclass : 'TestCase',
	#instVars : [
		'bubble',
		'testMessage'
	],
	#category : 'AI-ChatPharo-Tests',
	#package : 'AI-ChatPharo-Tests'
}

{ #category : 'running' }
ChatPharoSpecChatBubbleTest >> setUp [

    super setUp.
    
    testMessage := LLMAPIChatObjectMessage 
        role: 'user' 
        content: 'Hello, this is a test message!'.
    
    bubble := ChatPharoSpecChatBubble from: testMessage.
]

{ #category : 'running' }
ChatPharoSpecChatBubbleTest >> tearDown [

    bubble := nil.
    testMessage := nil.

    super tearDown.
]

{ #category : 'running' }
ChatPharoSpecChatBubbleTest >> testBubbleCreation [

    self assert: bubble notNil.

    self assert: bubble model equals: testMessage.
]

{ #category : 'running' }
ChatPharoSpecChatBubbleTest >> testRoleTextInitialization [

    self assert: bubble roleText notNil.
    
    self assert: bubble roleText text equals: testMessage role.
]

{ #category : 'running' }
ChatPharoSpecChatBubbleTest >> testRoleStyling [

    | userBubble aiBubble |
    
    userBubble := ChatPharoSpecChatBubble from: (LLMAPIChatObjectMessage role: 'user' content: 'User message').
    
    aiBubble := ChatPharoSpecChatBubble from: (LLMAPIChatObjectMessage role: 'assistant' content: 'AI response').

    self assert: userBubble roleText fontColor equals: Color blue.

    self assert: aiBubble roleText fontColor equals: Color green.
]

{ #category : 'running' }
ChatPharoSpecChatBubbleTest >> testContentRendering [

    self assert: bubble contentArea notNil.

    self assert: bubble contentArea document equals: (Microdown parse: testMessage content).
]

{ #category : 'running' }
ChatPharoSpecChatBubbleTest >> testLayoutConstraints [

    | layout constraints |
    
    layout := bubble defaultLayout.

    self assert: (layout children includes: bubble roleText).
    self assert: (layout children includes: bubble contentArea).

    "Check the height constraint for contentArea"
    constraints := layout constraintsFor: bubble contentArea.
    self assert: (constraints height equals: (ChatPharoSpecChatBubble inputTextHeight * 4)).
]