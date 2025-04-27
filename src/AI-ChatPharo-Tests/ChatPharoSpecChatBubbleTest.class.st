Class {
	#name : 'ChatPharoSpecChatBubbleTest',
	#superclass : 'TestCase',
	#instVars : [
		'bubble',
		'testMessage'
	],
	#category : 'AI-ChatPharo-Tests-Spec',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Spec'
}

{ #category : 'running' }
ChatPharoSpecChatBubbleTest >> setUp [
	
	super setUp.
	testMessage := ChatPharoHistorySaver
		               role: 'user'
		               content: 'Hello, this is a test message!'.

	bubble := ChatPharoSpecChatBubble 
		from: testMessage 
		parent: (ChatPharo new)
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
	self assert: bubble contentArea document asString
		equals: (Microdown parse: testMessage content) asString
]

{ #category : 'tests' }
ChatPharoSpecChatBubbleTest >> testLayoutConstraints [

	| layout constraints |
	layout := bubble defaultLayout.

	self assert: (layout children includes: bubble contentArea).

	constraints := layout constraintsFor: bubble contentArea.
	self assert:
		constraints height equals: (ChatPharoSpecChatBubble inputTextHeight * 4)
]

{ #category : 'tests' }
ChatPharoSpecChatBubbleTest >> testInitiallyCollapsed [
    
    self deny: bubble isExpanded.
]

{ #category : 'tests' }
ChatPharoSpecChatBubbleTest >> testExpandCollapseToggle [
    self deny: bubble isExpanded.
    
    bubble toggleExpand.
    self assert: bubble isExpanded.
    
    bubble toggleExpand.
    self deny: bubble isExpanded.
]

{ #category : 'tests' }
ChatPharoSpecChatBubbleTest >> testContentChangesOnExpand [
    
    | shortContent fullContent |
    
    
    testMessage := ChatPharoHistorySaver
        role: 'user'
        content: ('This is a long test message. ' , ('Extra text. ' repeat: 50)).

    bubble := ChatPharoSpecChatBubble from: testMessage parent: (ChatPharo new).

    shortContent := bubble contentArea document asString.
    
    bubble toggleExpand.

    fullContent := bubble contentArea document asString.
    
    self assert: shortContent ~= fullContent.
    self assert: (fullContent includesSubstring: 'Extra text').
]