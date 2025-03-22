"
### `ChatPharoSpecChatHistory` Class
Maintains and displays the history of chat messages.

- **`from:`**: Factory method to create a history panel from a collection of messages.
- **`addMessage:`**: Adds a message to the history and updates the display.
- **`defaultLayout`**: Defines the scrolling layout for the history.
- **`initializePresenters`**: Initializes the panel that will hold the chat bubbles.
"
Class {
    #name : 'ChatPharoSpecChatHistory',
    #superclass : 'SpPresenterWithModel',
    #instVars : [
        'panel',
        'scroller'
    ],
    #category : 'AI-ChatPharo-Spec',
    #package : 'AI-ChatPharo',
    #tag : 'Spec'
}

{ #category : 'instance creation' }
ChatPharoSpecChatHistory class >> from: messages [
    ^ self basicNew
        setModelBeforeInitialization: messages;
        initialize;
        yourself
]

{ #category : 'initialization' }
ChatPharoSpecChatHistory >> addMessage: aMessage [

    self model add: aMessage.
    panel add: (ChatPharoSpecChatBubble from: aMessage).

    self scrollToBottom.
]

{ #category : 'layout' }
ChatPharoSpecChatHistory >> defaultLayout [

    scroller := SpScrollPanel new.
    panel := SpBoxLayout newTopToBottom.

    scroller add: panel.
    scroller vScrollbar alwaysVisible: true.

    ^ scroller
]

{ #category : 'initialization' }
ChatPharoSpecChatHistory >> initializePresenters [
    
    scroller := SpScrollPane new.
    panel := SpBoxLayout newTopToBottom.

    self model do: [ :message |
        panel add: (ChatPharoSpecChatBubble from: message) expand: true ].

    scroller add: panel.
    scroller vScrollbar alwaysVisible: true.

    self scrollToBottom.
]

{ #category : 'scrolling' }
ChatPharoSpecChatHistory >> scrollToBottom [

    | lastMessage |

	scroller ifNil: [ ^ self ]. 
    lastMessage := panel children ifNotEmpty: [ panel children last ].
    
    lastMessage ifNotNil: [
        scroller vScrollbar value: scroller vScrollbar maximum.
    ].
]

{ #category : 'accessing' }
ChatPharoSpecChatHistory >> panel [

    ^ panel 
]

{ #category : 'accessing' }
ChatPharoSpecChatHistory >> panel: anObject [

    panel := anObject 
]

{ #category : 'accessing' }
ChatPharoSpecChatHistory >> scroller [

    ^ scroller 
]

{ #category : 'accessing' }
ChatPharoSpecChatHistory >> scroller: anObject [

    scroller := anObject 
]