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
        content: 'Hello, this is a test message!' 
        timestamp: DateAndTime now.  

    bubble := ChatPharoSpecChatBubble from: testMessage.
]

{ #category : 'running' }
ChatPharoSpecChatBubbleTest >> tearDown [
    bubble := nil.
    testMessage := nil.
    super tearDown.
]

{ #category : 'tests' }
ChatPharoSpecChatBubbleTest >> testBubbleCreation [
    self assert: bubble notNil.
    self assert: bubble model equals: testMessage.
]

{ #category : 'tests' }
ChatPharoSpecChatBubbleTest >> testContentRendering [
    self assert: bubble contentArea notNil.
    self assert: bubble contentArea document asString = (Microdown parse: testMessage content) asString.
]

{ #category : 'tests' }
ChatPharoSpecChatBubbleTest >> testLayoutConstraints [
    | layout constraints |
    
    layout := bubble defaultLayout.

    self assert: (layout children includes: bubble contentArea).
    
    constraints := layout constraintsFor: bubble contentArea.
    self assert: constraints height = (ChatPharoSpecChatBubble inputTextHeight * 4).
]