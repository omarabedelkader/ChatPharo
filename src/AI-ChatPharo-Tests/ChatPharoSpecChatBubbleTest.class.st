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
    
    "Create a test message"
    testMessage := LLMAPIChatObjectMessage 
        role: 'user' 
        content: 'Hello, this is a test message!'.
    
    "Initialize the bubble with the test message"
    bubble := ChatPharoSpecChatBubble from: testMessage.
]

{ #category : 'running' }
ChatPharoSpecChatBubbleTest >> testBubbleCreation [

    "Ensure the bubble is not nil"
    self assert: bubble notNil.

    "Ensure the bubble's model is the provided message"
    self assert: bubble model equals: testMessage.
]

{ #category : 'running' }
ChatPharoSpecChatBubbleTest >> testRoleTextInitialization [

    "Ensure roleText is initialized correctly"
    self assert: bubble roleText notNil.
    
    "Ensure roleText matches the message role"
    self assert: bubble roleText text equals: testMessage role.
]

{ #category : 'running' }
ChatPharoSpecChatBubbleTest >> testRoleStyling [

    | userBubble aiBubble |
    
    "Create a bubble for a user message"
    userBubble := ChatPharoSpecChatBubble from: (LLMAPIChatObjectMessage role: 'user' content: 'User message').
    
    "Create a bubble for an AI message"
    aiBubble := ChatPharoSpecChatBubble from: (LLMAPIChatObjectMessage role: 'assistant' content: 'AI response').

    "Ensure the role text color is blue for user"
    self assert: userBubble roleText fontColor equals: Color blue.

    "Ensure the role text color is green for AI"
    self assert: aiBubble roleText fontColor equals: Color green.
]

{ #category : 'running' }
ChatPharoSpecChatBubbleTest >> testContentRendering [

    "Ensure contentArea is initialized"
    self assert: bubble contentArea notNil.

    "Ensure the contentArea correctly renders the message"
    self assert: bubble contentArea document equals: (Microdown parse: testMessage content).
]

{ #category : 'running' }
ChatPharoSpecChatBubbleTest >> testLayoutConstraints [

    | layout constraints |
    
    "Get the layout from the bubble"
    layout := bubble defaultLayout.

    "Ensure it contains roleText and contentArea"
    self assert: (layout children includes: bubble roleText).
    self assert: (layout children includes: bubble contentArea).

    "Check the height constraint for contentArea"
    constraints := layout constraintsFor: bubble contentArea.
    self assert: (constraints height equals: (ChatPharoSpecChatBubble inputTextHeight * 4)).
]